OBJECT Table 39 Purchase Line
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               TestStatusOpen;
               IF Quantity <> 0 THEN BEGIN
                 OnBeforeVerifyReservedQty(Rec,xRec,0);
                 ReservePurchLine.VerifyQuantity(Rec,xRec);
               END;
               LOCKTABLE;
               PurchHeader."No." := '';
               IF ("Deferral Code" <> '') AND (GetDeferralAmount <> 0) THEN
                 UpdateDeferralAmounts;
             END;

    OnModify=BEGIN
               IF ("Document Type" = "Document Type"::"Blanket Order") AND
                  ((Type <> xRec.Type) OR ("No." <> xRec."No."))
               THEN BEGIN
                 PurchLine2.RESET;
                 PurchLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
                 PurchLine2.SETRANGE("Blanket Order No.","Document No.");
                 PurchLine2.SETRANGE("Blanket Order Line No.","Line No.");
                 IF PurchLine2.FINDSET THEN
                   REPEAT
                     PurchLine2.TESTFIELD(Type,Type);
                     PurchLine2.TESTFIELD("No.","No.");
                   UNTIL PurchLine2.NEXT = 0;
               END;

               IF ((Quantity <> 0) OR (xRec.Quantity <> 0)) AND ItemExists(xRec."No.") THEN
                 ReservePurchLine.VerifyChange(Rec,xRec);
             END;

    OnDelete=VAR
               PurchCommentLine@1001 : Record 43;
               SalesOrderLine@1000 : Record 37;
             BEGIN
               TestStatusOpen;
               IF NOT StatusCheckSuspended AND (PurchHeader.Status = PurchHeader.Status::Released) AND
                  (Type IN [Type::"G/L Account",Type::"Charge (Item)"])
               THEN
                 VALIDATE(Quantity,0);

               IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
                 ReservePurchLine.DeleteLine(Rec);
                 IF "Receipt No." = '' THEN
                   TESTFIELD("Qty. Rcd. Not Invoiced",0);
                 IF "Return Shipment No." = '' THEN
                   TESTFIELD("Return Qty. Shipped Not Invd.",0);

                 CALCFIELDS("Reserved Qty. (Base)");
                 TESTFIELD("Reserved Qty. (Base)",0);
                 WhseValidateSourceLine.PurchaseLineDelete(Rec);
               END;

               IF ("Document Type" = "Document Type"::Order) AND (Quantity <> "Quantity Invoiced") THEN
                 TESTFIELD("Prepmt. Amt. Inv.","Prepmt Amt Deducted");

               IF "Sales Order Line No." <> 0 THEN BEGIN
                 LOCKTABLE;
                 SalesOrderLine.LOCKTABLE;
                 SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Sales Order No.","Sales Order Line No.");
                 SalesOrderLine."Purchase Order No." := '';
                 SalesOrderLine."Purch. Order Line No." := 0;
                 SalesOrderLine.MODIFY;
               END;

               IF "Special Order Sales Line No." <> 0 THEN BEGIN
                 LOCKTABLE;
                 SalesOrderLine.LOCKTABLE;
                 IF "Document Type" = "Document Type"::Order THEN BEGIN
                   SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Special Order Sales No.","Special Order Sales Line No.");
                   SalesOrderLine."Special Order Purchase No." := '';
                   SalesOrderLine."Special Order Purch. Line No." := 0;
                   SalesOrderLine.MODIFY;
                 END ELSE
                   IF SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Special Order Sales No.","Special Order Sales Line No.") THEN
                     BEGIN
                     SalesOrderLine."Special Order Purchase No." := '';
                     SalesOrderLine."Special Order Purch. Line No." := 0;
                     SalesOrderLine.MODIFY;
                   END;
               END;

               NonstockItemMgt.DelNonStockPurch(Rec);

               IF "Document Type" = "Document Type"::"Blanket Order" THEN BEGIN
                 PurchLine2.RESET;
                 PurchLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
                 PurchLine2.SETRANGE("Blanket Order No.","Document No.");
                 PurchLine2.SETRANGE("Blanket Order Line No.","Line No.");
                 IF PurchLine2.FINDFIRST THEN
                   PurchLine2.TESTFIELD("Blanket Order Line No.",0);
               END;

               IF Type = Type::Item THEN
                 DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");

               IF Type = Type::"Charge (Item)" THEN
                 DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");

               IF "Line No." <> 0 THEN BEGIN
                 PurchLine2.RESET;
                 PurchLine2.SETRANGE("Document Type","Document Type");
                 PurchLine2.SETRANGE("Document No.","Document No.");
                 PurchLine2.SETRANGE("Attached to Line No.","Line No.");
                 PurchLine2.SETFILTER("Line No.",'<>%1',"Line No.");
                 PurchLine2.DELETEALL(TRUE);
               END;

               PurchCommentLine.SETRANGE("Document Type","Document Type");
               PurchCommentLine.SETRANGE("No.","Document No.");
               PurchCommentLine.SETRANGE("Document Line No.","Line No.");
               IF NOT PurchCommentLine.ISEMPTY THEN
                 PurchCommentLine.DELETEALL;

               IF ("Line No." <> 0) AND ("Attached to Line No." = 0) THEN BEGIN
                 PurchLine2.COPY(Rec);
                 PurchLine2.SETRANGE("Document No.",PurchLine2."Document No.");
                 PurchLine2.SETRANGE("Document Type",PurchLine2."Document Type");
                 IF PurchLine2.FIND('<>') THEN BEGIN
                   PurchLine2.VALIDATE("Recalculate Invoice Disc.",TRUE);
                   PurchLine2.MODIFY;
                 END;
               END;

               IF "Deferral Code" <> '' THEN
                 DeferralUtilities.DeferralCodeOnDelete(
                   DeferralUtilities.GetPurchDeferralDocType,'','',
                   "Document Type","Document No.","Line No.");
             END;

    OnRename=BEGIN
               ERROR(Text000,TABLECAPTION);
             END;

    CaptionML=[DAN=Kõbslinje;
               ENU=Purchase Line];
    LookupPageID=Page518;
    DrillDownPageID=Page518;
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,Faktura,Kreditnota,Rammeordre,Returv.ordre;
                                                                    ENU=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order];
                                                   OptionString=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order }
    { 2   ;   ;Buy-from Vendor No. ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Leverandõrnr.;
                                                              ENU=Buy-from Vendor No.];
                                                   Editable=No }
    { 3   ;   ;Document No.        ;Code20        ;TableRelation="Purchase Header".No. WHERE (Document Type=FIELD(Document Type));
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 4   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 5   ;   ;Type                ;Option        ;OnValidate=VAR
                                                                TempPurchLine@1000 : TEMPORARY Record 39;
                                                              BEGIN
                                                                GetPurchHeader;
                                                                TestStatusOpen;

                                                                TESTFIELD("Qty. Rcd. Not Invoiced",0);
                                                                TESTFIELD("Quantity Received",0);
                                                                TESTFIELD("Receipt No.",'');

                                                                TESTFIELD("Return Qty. Shipped Not Invd.",0);
                                                                TESTFIELD("Return Qty. Shipped",0);
                                                                TESTFIELD("Return Shipment No.",'');

                                                                TESTFIELD("Prepmt. Amt. Inv.",0);

                                                                IF "Drop Shipment" THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION(Type),"Sales Order No.");
                                                                IF "Special Order" THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION(Type),"Special Order Sales No.");
                                                                IF "Prod. Order No." <> '' THEN
                                                                  ERROR(
                                                                    Text044,
                                                                    FIELDCAPTION(Type),FIELDCAPTION("Prod. Order No."),"Prod. Order No.");

                                                                IF Type <> xRec.Type THEN BEGIN
                                                                  IF Quantity <> 0 THEN BEGIN
                                                                    ReservePurchLine.VerifyChange(Rec,xRec);
                                                                    CALCFIELDS("Reserved Qty. (Base)");
                                                                    TESTFIELD("Reserved Qty. (Base)",0);
                                                                    WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                                                                  END;
                                                                  IF xRec.Type IN [Type::Item,Type::"Fixed Asset"] THEN BEGIN
                                                                    IF Quantity <> 0 THEN
                                                                      PurchHeader.TESTFIELD(Status,PurchHeader.Status::Open);
                                                                    DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");
                                                                  END;
                                                                  IF xRec.Type = Type::"Charge (Item)" THEN
                                                                    DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");
                                                                  IF xRec."Deferral Code" <> '' THEN
                                                                    DeferralUtilities.RemoveOrSetDeferralSchedule('',
                                                                      DeferralUtilities.GetPurchDeferralDocType,'','',
                                                                      xRec."Document Type",xRec."Document No.",xRec."Line No.",
                                                                      xRec.GetDeferralAmount,PurchHeader."Posting Date",'',xRec."Currency Code",TRUE);
                                                                END;
                                                                TempPurchLine := Rec;
                                                                INIT;

                                                                IF xRec."Line Amount" <> 0 THEN
                                                                  "Recalculate Invoice Disc." := TRUE;

                                                                Type := TempPurchLine.Type;
                                                                "System-Created Entry" := TempPurchLine."System-Created Entry";
                                                                OnValidateTypeOnCopyFromTempPurchLine(Rec,TempPurchLine);
                                                                VALIDATE("FA Posting Type");

                                                                IF Type = Type::Item THEN
                                                                  "Allow Item Charge Assignment" := TRUE
                                                                ELSE
                                                                  "Allow Item Charge Assignment" := FALSE;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Vare,,Anlëg,Gebyr (vare)";
                                                                    ENU=" ,G/L Account,Item,,Fixed Asset,Charge (Item)"];
                                                   OptionString=[ ,G/L Account,Item,,Fixed Asset,Charge (Item)] }
    { 6   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(" ")) "Standard Text"
                                                                 ELSE IF (Type=CONST(G/L Account),
                                                                          System-Created Entry=CONST(No)) "G/L Account" WHERE (Direct Posting=CONST(Yes),
                                                                                                                               Account Type=CONST(Posting),
                                                                                                                               Blocked=CONST(No))
                                                                                                                               ELSE IF (Type=CONST(G/L Account),
                                                                                                                                        System-Created Entry=CONST(Yes)) "G/L Account"
                                                                                                                                        ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                                                                        ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
                                                                                                                                        ELSE IF (Type=CONST(Item)) Item;
                                                   OnValidate=VAR
                                                                TempPurchLine@1003 : TEMPORARY Record 39;
                                                                FindRecordMgt@1000 : Codeunit 703;
                                                              BEGIN
                                                                "No." := FindRecordMgt.FindNoFromTypedValue(Type,"No.",NOT "System-Created Entry");

                                                                TestStatusOpen;
                                                                TESTFIELD("Qty. Rcd. Not Invoiced",0);
                                                                TESTFIELD("Quantity Received",0);
                                                                TESTFIELD("Receipt No.",'');

                                                                TESTFIELD("Prepmt. Amt. Inv.",0);

                                                                TestReturnFieldsZero;

                                                                IF "Drop Shipment" THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION("No."),"Sales Order No.");

                                                                IF "Special Order" THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION("No."),"Special Order Sales No.");

                                                                IF "Prod. Order No." <> '' THEN
                                                                  ERROR(
                                                                    Text044,
                                                                    FIELDCAPTION(Type),FIELDCAPTION("Prod. Order No."),"Prod. Order No.");

                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  IF (Quantity <> 0) AND ItemExists(xRec."No.") THEN BEGIN
                                                                    ReservePurchLine.VerifyChange(Rec,xRec);
                                                                    CALCFIELDS("Reserved Qty. (Base)");
                                                                    TESTFIELD("Reserved Qty. (Base)",0);
                                                                    IF Type = Type::Item THEN
                                                                      WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                                                                  END;
                                                                  IF Type = Type::Item THEN
                                                                    DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");
                                                                  IF Type = Type::"Charge (Item)" THEN
                                                                    DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");
                                                                END;
                                                                TempPurchLine := Rec;
                                                                INIT;
                                                                IF xRec."Line Amount" <> 0 THEN
                                                                  "Recalculate Invoice Disc." := TRUE;
                                                                Type := TempPurchLine.Type;
                                                                "No." := TempPurchLine."No.";
                                                                OnValidateNoOnCopyFromTempPurchLine(Rec,TempPurchLine);
                                                                IF "No." = '' THEN
                                                                  EXIT;

                                                                IF HasTypeToFillMandatoryFields THEN BEGIN
                                                                  Quantity := TempPurchLine.Quantity;
                                                                  "Outstanding Qty. (Base)" := TempPurchLine."Outstanding Qty. (Base)";
                                                                END;

                                                                "System-Created Entry" := TempPurchLine."System-Created Entry";
                                                                GetPurchHeader;
                                                                InitHeaderDefaults(PurchHeader);
                                                                UpdateLeadTimeFields;
                                                                UpdateDates;

                                                                OnAfterAssignHeaderValues(Rec,PurchHeader);

                                                                CASE Type OF
                                                                  Type::" ":
                                                                    CopyFromStandardText;
                                                                  Type::"G/L Account":
                                                                    CopyFromGLAccount;
                                                                  Type::Item:
                                                                    CopyFromItem;
                                                                  3:
                                                                    ERROR(Text003);
                                                                  Type::"Fixed Asset":
                                                                    CopyFromFixedAsset;
                                                                  Type::"Charge (Item)":
                                                                    CopyFromItemCharge;
                                                                END;

                                                                OnAfterAssignFieldsForNo(Rec,xRec,PurchHeader);

                                                                IF HasTypeToFillMandatoryFields AND NOT (Type = Type::"Fixed Asset") THEN
                                                                  VALIDATE("VAT Prod. Posting Group");

                                                                UpdatePrepmtSetupFields;

                                                                IF HasTypeToFillMandatoryFields THEN BEGIN
                                                                  Quantity := xRec.Quantity;
                                                                  VALIDATE("Unit of Measure Code");
                                                                  IF Quantity <> 0 THEN BEGIN
                                                                    InitOutstanding;
                                                                    IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
                                                                      InitQtyToShip
                                                                    ELSE
                                                                      InitQtyToReceive;
                                                                  END;
                                                                  UpdateWithWarehouseReceive;
                                                                  UpdateDirectUnitCost(FIELDNO("No."));
                                                                  IF xRec."Job No." <> '' THEN
                                                                    VALIDATE("Job No.",xRec."Job No.");
                                                                  "Job Line Type" := xRec."Job Line Type";
                                                                  IF xRec."Job Task No." <> '' THEN BEGIN
                                                                    VALIDATE("Job Task No.",xRec."Job Task No.");
                                                                    IF "No." = xRec."No." THEN
                                                                      VALIDATE("Job Planning Line No.",xRec."Job Planning Line No.");
                                                                  END;
                                                                END;

                                                                IF NOT ISTEMPORARY THEN
                                                                  CreateDim(
                                                                    DimMgt.TypeToTableID3(Type),"No.",
                                                                    DATABASE::Job,"Job No.",
                                                                    DATABASE::"Responsibility Center","Responsibility Center",
                                                                    DATABASE::"Work Center","Work Center No.");

                                                                PurchHeader.GET("Document Type","Document No.");
                                                                UpdateItemReference;

                                                                GetDefaultBin;

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine(TRUE);
                                                                  UpdateJobPrices;
                                                                END;

                                                                PostingSetupMgt.CheckGenPostingSetupPurchAccount("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                                                                PostingSetupMgt.CheckVATPostingSetupPurchAccount("VAT Bus. Posting Group","VAT Prod. Posting Group");
                                                              END;

                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.];
                                                   CaptionClass=GetCaptionClass(FIELDNO("No.")) }
    { 7   ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;

                                                                IF "Location Code" <> '' THEN
                                                                  IF IsServiceItem THEN
                                                                    Item.TESTFIELD(Type,Item.Type::Inventory);
                                                                IF xRec."Location Code" <> "Location Code" THEN BEGIN
                                                                  IF "Prepmt. Amt. Inv." <> 0 THEN
                                                                    IF NOT CONFIRM(Text046,FALSE,FIELDCAPTION("Direct Unit Cost"),FIELDCAPTION("Location Code"),PRODUCTNAME.FULL) THEN BEGIN
                                                                      "Location Code" := xRec."Location Code";
                                                                      EXIT;
                                                                    END;
                                                                  TESTFIELD("Qty. Rcd. Not Invoiced",0);
                                                                  TESTFIELD("Receipt No.",'');

                                                                  TESTFIELD("Return Qty. Shipped Not Invd.",0);
                                                                  TESTFIELD("Return Shipment No.",'');
                                                                END;

                                                                IF "Drop Shipment" THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION("Location Code"),"Sales Order No.");
                                                                IF "Special Order" THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION("Location Code"),"Special Order Sales No.");

                                                                IF "Location Code" <> xRec."Location Code" THEN
                                                                  InitItemAppl;

                                                                IF (xRec."Location Code" <> "Location Code") AND (Quantity <> 0) THEN BEGIN
                                                                  ReservePurchLine.VerifyChange(Rec,xRec);
                                                                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                                                                  UpdateWithWarehouseReceive;
                                                                  PostingSetupMgt.CheckInvtPostingSetupInventoryAccount("Location Code","Posting Group");
                                                                END;
                                                                "Bin Code" := '';

                                                                IF Type = Type::Item THEN
                                                                  UpdateDirectUnitCost(FIELDNO("Location Code"));

                                                                IF "Location Code" = '' THEN BEGIN
                                                                  IF InvtSetup.GET THEN
                                                                    "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                                                                END ELSE
                                                                  IF Location.GET("Location Code") THEN
                                                                    "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";

                                                                UpdateLeadTimeFields;
                                                                UpdateDates;

                                                                GetDefaultBin;
                                                                CheckWMS;

                                                                IF "Document Type" = "Document Type"::"Return Order" THEN
                                                                  ValidateReturnReasonCode(FIELDNO("Location Code"));
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 8   ;   ;Posting Group       ;Code20        ;TableRelation=IF (Type=CONST(Item)) "Inventory Posting Group"
                                                                 ELSE IF (Type=CONST(Fixed Asset)) "FA Posting Group";
                                                   CaptionML=[DAN=Bogfõringsgruppe;
                                                              ENU=Posting Group];
                                                   Editable=No }
    { 10  ;   ;Expected Receipt Date;Date         ;OnValidate=BEGIN
                                                                IF NOT TrackingBlocked THEN
                                                                  CheckDateConflict.PurchLineCheck(Rec,CurrFieldNo <> 0);

                                                                IF "Expected Receipt Date" <> 0D THEN
                                                                  VALIDATE(
                                                                    "Planned Receipt Date",
                                                                    CalendarMgmt.CalcDateBOC2(InternalLeadTimeDays("Expected Receipt Date"),"Expected Receipt Date",
                                                                      CalChange."Source Type"::Location,"Location Code",'',
                                                                      CalChange."Source Type"::Location,"Location Code",'',FALSE))
                                                                ELSE
                                                                  VALIDATE("Planned Receipt Date","Expected Receipt Date");
                                                              END;

                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Forventet modt.dato;
                                                              ENU=Expected Receipt Date] }
    { 11  ;   ;Description         ;Text50        ;TableRelation=IF (Type=CONST(G/L Account),
                                                                     System-Created Entry=CONST(No)) "G/L Account" WHERE (Direct Posting=CONST(Yes),
                                                                                                                          Account Type=CONST(Posting),
                                                                                                                          Blocked=CONST(No))
                                                                                                                          ELSE IF (Type=CONST(G/L Account),
                                                                                                                                   System-Created Entry=CONST(Yes)) "G/L Account"
                                                                                                                                   ELSE IF (Type=CONST(Item)) Item
                                                                                                                                   ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                                                                   ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
                                                   OnValidate=VAR
                                                                Item@1000 : Record 27;
                                                                ApplicationAreaSetup@1003 : Record 9178;
                                                                FindRecordMgt@1002 : Codeunit 703;
                                                                ReturnValue@1001 : Text[50];
                                                                DescriptionIsNo@1004 : Boolean;
                                                              BEGIN
                                                                IF Type = Type::" " THEN
                                                                  EXIT;

                                                                IF ("No." <> '') AND (Type IN [Type::Item,Type::"Charge (Item)"]) THEN BEGIN
                                                                  CASE Type OF
                                                                    Type::Item:
                                                                      BEGIN
                                                                        IF (STRLEN(Description) <= MAXSTRLEN(Item."No.")) AND ("No." <> '') THEN
                                                                          DescriptionIsNo := Item.GET(Description)
                                                                        ELSE
                                                                          DescriptionIsNo := FALSE;

                                                                        IF NOT DescriptionIsNo THEN BEGIN
                                                                          Item.SETFILTER(Description,'@%1',CONVERTSTR(Description,'''','?'));
                                                                          IF NOT Item.FINDFIRST THEN
                                                                            EXIT;
                                                                          IF Item."No." = "No." THEN
                                                                            EXIT;
                                                                          IF IsReceivedFromOcr THEN
                                                                            EXIT;
                                                                          IF CONFIRM(AnotherItemWithSameDescrQst,FALSE,Item."No.",Item.Description) THEN
                                                                            VALIDATE("No.",Item."No.");
                                                                          EXIT;
                                                                        END;

                                                                        IF Item.TryGetItemNoOpenCard(ReturnValue,Description,FALSE,FALSE,FALSE) THEN
                                                                          CASE ReturnValue OF
                                                                            '',"No.":
                                                                              Description := xRec.Description;
                                                                            ELSE
                                                                              VALIDATE("No.",COPYSTR(ReturnValue,1,MAXSTRLEN(Item."No.")));
                                                                          END;
                                                                      END;
                                                                    Type::"Charge (Item)":
                                                                      BEGIN
                                                                        ItemCharge.SETFILTER(Description,'@%1',CONVERTSTR(Description,'''','?'));
                                                                        IF NOT ItemCharge.FINDFIRST THEN
                                                                          EXIT;
                                                                        IF ItemCharge."No." = "No." THEN
                                                                          EXIT;
                                                                        IF CONFIRM(AnotherChargeItemWithSameDescQst,FALSE,ItemCharge."No.",ItemCharge.Description) THEN
                                                                          VALIDATE("No.",ItemCharge."No.");
                                                                      END;
                                                                  END;
                                                                END ELSE
                                                                  IF ("No." = '') OR (CurrFieldNo = FIELDNO(Description)) THEN
                                                                    IF FindRecordMgt.FindRecordByDescription(ReturnValue,Type,Description) = 1 THEN BEGIN
                                                                      CurrFieldNo := FIELDNO("No.");
                                                                      VALIDATE("No.",COPYSTR(ReturnValue,1,MAXSTRLEN("No.")));
                                                                    END;

                                                                IF ("No." = '') AND GUIALLOWED AND ApplicationAreaSetup.IsFoundationEnabled THEN
                                                                  IF "Document Type" IN ["Document Type"::Order] THEN
                                                                    ERROR(STRSUBSTNO(CannotFindDescErr,Type,Description));
                                                              END;

                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 12  ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 13  ;   ;Unit of Measure     ;Text10        ;CaptionML=[DAN=Enhed;
                                                              ENU=Unit of Measure] }
    { 15  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                TestStatusOpen;

                                                                IF "Drop Shipment" AND ("Document Type" <> "Document Type"::Invoice) THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION(Quantity),"Sales Order No.");
                                                                "Quantity (Base)" := CalcBaseQty(Quantity);
                                                                IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
                                                                  IF (Quantity * "Return Qty. Shipped" < 0) OR
                                                                     ((ABS(Quantity) < ABS("Return Qty. Shipped")) AND ("Return Shipment No." = ''))
                                                                  THEN
                                                                    FIELDERROR(Quantity,STRSUBSTNO(Text004,FIELDCAPTION("Return Qty. Shipped")));
                                                                  IF ("Quantity (Base)" * "Return Qty. Shipped (Base)" < 0) OR
                                                                     ((ABS("Quantity (Base)") < ABS("Return Qty. Shipped (Base)")) AND ("Return Shipment No." = ''))
                                                                  THEN
                                                                    FIELDERROR("Quantity (Base)",STRSUBSTNO(Text004,FIELDCAPTION("Return Qty. Shipped (Base)")));
                                                                END ELSE BEGIN
                                                                  IF (Quantity * "Quantity Received" < 0) OR
                                                                     ((ABS(Quantity) < ABS("Quantity Received")) AND ("Receipt No." = ''))
                                                                  THEN
                                                                    FIELDERROR(Quantity,STRSUBSTNO(Text004,FIELDCAPTION("Quantity Received")));
                                                                  IF ("Quantity (Base)" * "Qty. Received (Base)" < 0) OR
                                                                     ((ABS("Quantity (Base)") < ABS("Qty. Received (Base)")) AND ("Receipt No." = ''))
                                                                  THEN
                                                                    FIELDERROR("Quantity (Base)",STRSUBSTNO(Text004,FIELDCAPTION("Qty. Received (Base)")));
                                                                END;

                                                                IF (Type = Type::"Charge (Item)") AND (CurrFieldNo <> 0) THEN BEGIN
                                                                  IF (Quantity = 0) AND ("Qty. to Assign" <> 0) THEN
                                                                    FIELDERROR("Qty. to Assign",STRSUBSTNO(Text011,FIELDCAPTION(Quantity),Quantity));
                                                                  IF (Quantity * "Qty. Assigned" < 0) OR (ABS(Quantity) < ABS("Qty. Assigned")) THEN
                                                                    FIELDERROR(Quantity,STRSUBSTNO(Text004,FIELDCAPTION("Qty. Assigned")));
                                                                END;

                                                                IF "Receipt No." <> '' THEN
                                                                  CheckReceiptRelation
                                                                ELSE
                                                                  IF "Return Shipment No." <> '' THEN
                                                                    CheckRetShptRelation;

                                                                IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") OR
                                                                   ("No." = xRec."No.")
                                                                THEN BEGIN
                                                                  InitOutstanding;
                                                                  IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
                                                                    InitQtyToShip
                                                                  ELSE
                                                                    InitQtyToReceive;
                                                                END;
                                                                IF (Quantity * xRec.Quantity < 0) OR (Quantity = 0) THEN
                                                                  InitItemAppl;

                                                                IF Type = Type::Item THEN
                                                                  UpdateDirectUnitCost(FIELDNO(Quantity))
                                                                ELSE
                                                                  VALIDATE("Line Discount %");

                                                                IF Type = Type::"Charge (Item)" THEN
                                                                  "Line Discount %" := 0;

                                                                UpdateWithWarehouseReceive;
                                                                IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN BEGIN
                                                                  OnBeforeVerifyReservedQty(Rec,xRec,FIELDNO(Quantity));
                                                                  ReservePurchLine.VerifyQuantity(Rec,xRec);
                                                                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                                                                  CheckApplToItemLedgEntry;
                                                                END;

                                                                IF (xRec.Quantity <> Quantity) AND (Quantity = 0) AND
                                                                   ((Amount <> 0) OR ("Amount Including VAT" <> 0) OR ("VAT Base Amount" <> 0))
                                                                THEN BEGIN
                                                                  Amount := 0;
                                                                  "Amount Including VAT" := 0;
                                                                  "VAT Base Amount" := 0;
                                                                END;

                                                                UpdatePrePaymentAmounts;

                                                                IF "Job Planning Line No." <> 0 THEN
                                                                  VALIDATE("Job Planning Line No.");

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine(TRUE);
                                                                  UpdateJobPrices;
                                                                END;

                                                                CheckWMS;
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 16  ;   ;Outstanding Quantity;Decimal       ;CaptionML=[DAN=UdestÜende antal;
                                                              ENU=Outstanding Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 17  ;   ;Qty. to Invoice     ;Decimal       ;OnValidate=BEGIN
                                                                IF "Qty. to Invoice" = MaxQtyToInvoice THEN
                                                                  InitQtyToInvoice
                                                                ELSE
                                                                  "Qty. to Invoice (Base)" := CalcBaseQty("Qty. to Invoice");
                                                                IF ("Qty. to Invoice" * Quantity < 0) OR (ABS("Qty. to Invoice") > ABS(MaxQtyToInvoice)) THEN
                                                                  ERROR(
                                                                    Text006,
                                                                    MaxQtyToInvoice);
                                                                IF ("Qty. to Invoice (Base)" * "Quantity (Base)" < 0) OR (ABS("Qty. to Invoice (Base)") > ABS(MaxQtyToInvoiceBase)) THEN
                                                                  ERROR(
                                                                    Text007,
                                                                    MaxQtyToInvoiceBase);
                                                                "VAT Difference" := 0;
                                                                CalcInvDiscToInvoice;
                                                                CalcPrepaymentToDeduct;

                                                                IF "Job Planning Line No." <> 0 THEN
                                                                  VALIDATE("Job Planning Line No.");
                                                              END;

                                                   CaptionML=[DAN=Fakturer (antal);
                                                              ENU=Qty. to Invoice];
                                                   DecimalPlaces=0:5 }
    { 18  ;   ;Qty. to Receive     ;Decimal       ;OnValidate=BEGIN
                                                                GetLocation("Location Code");
                                                                IF (CurrFieldNo <> 0) AND
                                                                   (Type = Type::Item) AND
                                                                   (NOT "Drop Shipment")
                                                                THEN BEGIN
                                                                  IF Location."Require Receive" AND
                                                                     ("Qty. to Receive" <> 0)
                                                                  THEN
                                                                    CheckWarehouse;
                                                                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                                                                END;

                                                                IF "Qty. to Receive" = Quantity - "Quantity Received" THEN
                                                                  InitQtyToReceive
                                                                ELSE BEGIN
                                                                  "Qty. to Receive (Base)" := CalcBaseQty("Qty. to Receive");
                                                                  InitQtyToInvoice;
                                                                END;
                                                                IF ((("Qty. to Receive" < 0) XOR (Quantity < 0)) AND (Quantity <> 0) AND ("Qty. to Receive" <> 0)) OR
                                                                   (ABS("Qty. to Receive") > ABS("Outstanding Quantity")) OR
                                                                   (((Quantity < 0 ) XOR ("Outstanding Quantity" < 0)) AND (Quantity <> 0) AND ("Outstanding Quantity" <> 0))
                                                                THEN
                                                                  ERROR(
                                                                    Text008,
                                                                    "Outstanding Quantity");
                                                                IF ((("Qty. to Receive (Base)" < 0) XOR ("Quantity (Base)" < 0)) AND ("Quantity (Base)" <> 0) AND ("Qty. to Receive (Base)" <> 0)) OR
                                                                   (ABS("Qty. to Receive (Base)") > ABS("Outstanding Qty. (Base)")) OR
                                                                   ((("Quantity (Base)" < 0) XOR ("Outstanding Qty. (Base)" < 0)) AND ("Quantity (Base)" <> 0) AND ("Outstanding Qty. (Base)" <> 0))
                                                                THEN
                                                                  ERROR(
                                                                    Text009,
                                                                    "Outstanding Qty. (Base)");

                                                                IF (CurrFieldNo <> 0) AND (Type = Type::Item) AND ("Qty. to Receive" < 0) THEN
                                                                  CheckApplToItemLedgEntry;

                                                                IF "Job Planning Line No." <> 0 THEN
                                                                  VALIDATE("Job Planning Line No.");
                                                              END;

                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Modtag (antal);
                                                              ENU=Qty. to Receive];
                                                   DecimalPlaces=0:5 }
    { 22  ;   ;Direct Unit Cost    ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Line Discount %");
                                                              END;

                                                   CaptionML=[DAN=Kõbspris;
                                                              ENU=Direct Unit Cost];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Direct Unit Cost")) }
    { 23  ;   ;Unit Cost (LCY)     ;Decimal       ;OnValidate=VAR
                                                                IndirectCostPercent@1000 : Decimal;
                                                              BEGIN
                                                                TestStatusOpen;
                                                                TESTFIELD("No.");
                                                                TESTFIELD(Quantity);

                                                                IF "Prod. Order No." <> '' THEN
                                                                  ERROR(
                                                                    Text99000000,
                                                                    FIELDCAPTION("Unit Cost (LCY)"));

                                                                IF CurrFieldNo = FIELDNO("Unit Cost (LCY)") THEN
                                                                  IF Type = Type::Item THEN BEGIN
                                                                    GetItem;
                                                                    IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                                                                      ERROR(
                                                                        Text010,
                                                                        FIELDCAPTION("Unit Cost (LCY)"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");
                                                                  END;

                                                                UnitCostCurrency := "Unit Cost (LCY)";
                                                                GetPurchHeader;
                                                                IF PurchHeader."Currency Code" <> '' THEN BEGIN
                                                                  PurchHeader.TESTFIELD("Currency Factor");
                                                                  GetGLSetup;
                                                                  UnitCostCurrency :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtLCYToFCY(
                                                                        GetDate,"Currency Code",
                                                                        "Unit Cost (LCY)",PurchHeader."Currency Factor"),
                                                                      GLSetup."Unit-Amount Rounding Precision");
                                                                END;

                                                                IF ("Direct Unit Cost" <> 0) AND
                                                                   ("Direct Unit Cost" <> ("Line Discount Amount" / Quantity))
                                                                THEN BEGIN
                                                                  IndirectCostPercent :=
                                                                    ROUND(
                                                                      (UnitCostCurrency - "Direct Unit Cost" + "Line Discount Amount" / Quantity) /
                                                                      ("Direct Unit Cost" - "Line Discount Amount" / Quantity) * 100,0.00001);
                                                                  IF IndirectCostPercentCheck(IndirectCostPercent) THEN
                                                                    "Indirect Cost %" := IndirectCostPercent
                                                                  ELSE
                                                                    ERROR(CannotBeNegativeErr,FIELDCAPTION("Indirect Cost %"));
                                                                END ELSE
                                                                  "Indirect Cost %" := 0;

                                                                UpdateSalesCost;

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine(FALSE);
                                                                  TempJobJnlLine.VALIDATE("Unit Cost (LCY)","Unit Cost (LCY)");
                                                                  UpdateJobPrices;
                                                                END
                                                              END;

                                                   CaptionML=[DAN=Kostpris (RV);
                                                              ENU=Unit Cost (LCY)];
                                                   AutoFormatType=2 }
    { 25  ;   ;VAT %               ;Decimal       ;CaptionML=[DAN=Momspct.;
                                                              ENU=VAT %];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 27  ;   ;Line Discount %     ;Decimal       ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                GetPurchHeader;
                                                                "Line Discount Amount" :=
                                                                  ROUND(
                                                                    ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") *
                                                                    "Line Discount %" / 100,
                                                                    Currency."Amount Rounding Precision");
                                                                "Inv. Discount Amount" := 0;
                                                                "Inv. Disc. Amount to Invoice" := 0;
                                                                UpdateAmounts;
                                                                UpdateUnitCost;
                                                              END;

                                                   CaptionML=[DAN=Linjerabatpct.;
                                                              ENU=Line Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 28  ;   ;Line Discount Amount;Decimal       ;OnValidate=BEGIN
                                                                GetPurchHeader;
                                                                "Line Discount Amount" := ROUND("Line Discount Amount",Currency."Amount Rounding Precision");
                                                                TestStatusOpen;
                                                                TESTFIELD(Quantity);
                                                                IF xRec."Line Discount Amount" <> "Line Discount Amount" THEN
                                                                  IF ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") <> 0 THEN
                                                                    "Line Discount %" :=
                                                                      ROUND(
                                                                        "Line Discount Amount" /
                                                                        ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") * 100,
                                                                        0.00001)
                                                                  ELSE
                                                                    "Line Discount %" := 0;
                                                                "Inv. Discount Amount" := 0;
                                                                "Inv. Disc. Amount to Invoice" := 0;
                                                                UpdateAmounts;
                                                                UpdateUnitCost;
                                                              END;

                                                   CaptionML=[DAN=Linjerabatbelõb;
                                                              ENU=Line Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 29  ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                GetPurchHeader;
                                                                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                                                                CASE "VAT Calculation Type" OF
                                                                  "VAT Calculation Type"::"Normal VAT",
                                                                  "VAT Calculation Type"::"Reverse Charge VAT":
                                                                    BEGIN
                                                                      "VAT Base Amount" :=
                                                                        ROUND(Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                                                                      "Amount Including VAT" :=
                                                                        ROUND(Amount + "VAT Base Amount" * "VAT %" / 100,Currency."Amount Rounding Precision");
                                                                    END;
                                                                  "VAT Calculation Type"::"Full VAT":
                                                                    IF Amount <> 0 THEN
                                                                      FIELDERROR(Amount,
                                                                        STRSUBSTNO(
                                                                          Text011,FIELDCAPTION("VAT Calculation Type"),
                                                                          "VAT Calculation Type"));
                                                                  "VAT Calculation Type"::"Sales Tax":
                                                                    BEGIN
                                                                      PurchHeader.TESTFIELD("VAT Base Discount %",0);
                                                                      "VAT Base Amount" := Amount;
                                                                      IF "Use Tax" THEN
                                                                        "Amount Including VAT" := "VAT Base Amount"
                                                                      ELSE BEGIN
                                                                        "Amount Including VAT" :=
                                                                          Amount +
                                                                          ROUND(
                                                                            SalesTaxCalculate.CalculateTax(
                                                                              "Tax Area Code","Tax Group Code","Tax Liable",PurchHeader."Posting Date",
                                                                              "VAT Base Amount","Quantity (Base)",PurchHeader."Currency Factor"),
                                                                            Currency."Amount Rounding Precision");
                                                                        IF "VAT Base Amount" <> 0 THEN
                                                                          "VAT %" :=
                                                                            ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                                                                        ELSE
                                                                          "VAT %" := 0;
                                                                      END;
                                                                    END;
                                                                END;

                                                                InitOutstandingAmount;
                                                                UpdateUnitCost;
                                                              END;

                                                   CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 30  ;   ;Amount Including VAT;Decimal       ;OnValidate=BEGIN
                                                                GetPurchHeader;
                                                                "Amount Including VAT" := ROUND("Amount Including VAT",Currency."Amount Rounding Precision");
                                                                CASE "VAT Calculation Type" OF
                                                                  "VAT Calculation Type"::"Normal VAT",
                                                                  "VAT Calculation Type"::"Reverse Charge VAT":
                                                                    BEGIN
                                                                      Amount :=
                                                                        ROUND(
                                                                          "Amount Including VAT" /
                                                                          (1 + (1 - PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                                                                          Currency."Amount Rounding Precision");
                                                                      "VAT Base Amount" :=
                                                                        ROUND(Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                                                                    END;
                                                                  "VAT Calculation Type"::"Full VAT":
                                                                    BEGIN
                                                                      Amount := 0;
                                                                      "VAT Base Amount" := 0;
                                                                    END;
                                                                  "VAT Calculation Type"::"Sales Tax":
                                                                    BEGIN
                                                                      PurchHeader.TESTFIELD("VAT Base Discount %",0);
                                                                      IF "Use Tax" THEN BEGIN
                                                                        Amount := "Amount Including VAT";
                                                                        "VAT Base Amount" := Amount;
                                                                      END ELSE BEGIN
                                                                        Amount :=
                                                                          ROUND(
                                                                            SalesTaxCalculate.ReverseCalculateTax(
                                                                              "Tax Area Code","Tax Group Code","Tax Liable",PurchHeader."Posting Date",
                                                                              "Amount Including VAT","Quantity (Base)",PurchHeader."Currency Factor"),
                                                                            Currency."Amount Rounding Precision");
                                                                        "VAT Base Amount" := Amount;
                                                                        IF "VAT Base Amount" <> 0 THEN
                                                                          "VAT %" :=
                                                                            ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                                                                        ELSE
                                                                          "VAT %" := 0;
                                                                      END;
                                                                    END;
                                                                END;

                                                                InitOutstandingAmount;
                                                                UpdateUnitCost;
                                                              END;

                                                   CaptionML=[DAN=Belõb inkl. moms;
                                                              ENU=Amount Including VAT];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 31  ;   ;Unit Price (LCY)    ;Decimal       ;CaptionML=[DAN=Enhedspris (RV);
                                                              ENU=Unit Price (LCY)];
                                                   AutoFormatType=2 }
    { 32  ;   ;Allow Invoice Disc. ;Boolean       ;InitValue=Yes;
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF ("Allow Invoice Disc." <> xRec."Allow Invoice Disc.") AND
                                                                   (NOT "Allow Invoice Disc.")
                                                                THEN BEGIN
                                                                  "Inv. Discount Amount" := 0;
                                                                  "Inv. Disc. Amount to Invoice" := 0;
                                                                  UpdateAmounts;
                                                                  UpdateUnitCost;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Tillad fakturarabat;
                                                              ENU=Allow Invoice Disc.] }
    { 34  ;   ;Gross Weight        ;Decimal       ;CaptionML=[DAN=Bruttovëgt;
                                                              ENU=Gross Weight];
                                                   DecimalPlaces=0:5 }
    { 35  ;   ;Net Weight          ;Decimal       ;CaptionML=[DAN=Nettovëgt;
                                                              ENU=Net Weight];
                                                   DecimalPlaces=0:5 }
    { 36  ;   ;Units per Parcel    ;Decimal       ;CaptionML=[DAN=Antal pr. kolli;
                                                              ENU=Units per Parcel];
                                                   DecimalPlaces=0:5 }
    { 37  ;   ;Unit Volume         ;Decimal       ;CaptionML=[DAN=Rumfang;
                                                              ENU=Unit Volume];
                                                   DecimalPlaces=0:5 }
    { 38  ;   ;Appl.-to Item Entry ;Integer       ;OnValidate=BEGIN
                                                                IF "Appl.-to Item Entry" <> 0 THEN
                                                                  "Location Code" := CheckApplToItemLedgEntry;
                                                              END;

                                                   OnLookup=BEGIN
                                                              SelectItemEntry;
                                                            END;

                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Udl.varepostlõbenr.;
                                                              ENU=Appl.-to Item Entry] }
    { 40  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1),
                                                                                               Blocked=CONST(No));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 41  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                                                               Blocked=CONST(No));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 45  ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   OnValidate=VAR
                                                                Job@1000 : Record 167;
                                                              BEGIN
                                                                TESTFIELD("Drop Shipment",FALSE);
                                                                TESTFIELD("Special Order",FALSE);
                                                                TESTFIELD("Receipt No.",'');
                                                                IF "Document Type" = "Document Type"::Order THEN
                                                                  TESTFIELD("Quantity Received",0);

                                                                IF ReservEntryExist THEN
                                                                  TESTFIELD("Job No.",'');

                                                                IF "Job No." <> xRec."Job No." THEN BEGIN
                                                                  VALIDATE("Job Task No.",'');
                                                                  VALIDATE("Job Planning Line No.",0);
                                                                END;

                                                                IF "Job No." = '' THEN BEGIN
                                                                  CreateDim(
                                                                    DATABASE::Job,"Job No.",
                                                                    DimMgt.TypeToTableID3(Type),"No.",
                                                                    DATABASE::"Responsibility Center","Responsibility Center",
                                                                    DATABASE::"Work Center","Work Center No.");
                                                                  EXIT;
                                                                END;

                                                                IF NOT (Type IN [Type::Item,Type::"G/L Account"]) THEN
                                                                  FIELDERROR("Job No.",STRSUBSTNO(Text012,FIELDCAPTION(Type),Type));
                                                                Job.GET("Job No.");
                                                                Job.TestBlocked;
                                                                "Job Currency Code" := Job."Currency Code";

                                                                CreateDim(
                                                                  DATABASE::Job,"Job No.",
                                                                  DimMgt.TypeToTableID3(Type),"No.",
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::"Work Center","Work Center No.");
                                                              END;

                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 54  ;   ;Indirect Cost %     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("No.");
                                                                TestStatusOpen;

                                                                IF Type = Type::"Charge (Item)" THEN
                                                                  TESTFIELD("Indirect Cost %",0);

                                                                IF (Type = Type::Item) AND ("Prod. Order No." = '') THEN BEGIN
                                                                  GetItem;
                                                                  IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                                                                    ERROR(
                                                                      Text010,
                                                                      FIELDCAPTION("Indirect Cost %"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");
                                                                END;

                                                                UpdateUnitCost;
                                                              END;

                                                   CaptionML=[DAN=Indir. omkost.pct.;
                                                              ENU=Indirect Cost %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 56  ;   ;Recalculate Invoice Disc.;Boolean  ;CaptionML=[DAN=Genberegn fakturarabat;
                                                              ENU=Recalculate Invoice Disc.];
                                                   Editable=No }
    { 57  ;   ;Outstanding Amount  ;Decimal       ;OnValidate=VAR
                                                                Currency2@1000 : Record 4;
                                                              BEGIN
                                                                GetPurchHeader;
                                                                Currency2.InitRoundingPrecision;
                                                                IF PurchHeader."Currency Code" <> '' THEN
                                                                  "Outstanding Amount (LCY)" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        GetDate,"Currency Code",
                                                                        "Outstanding Amount",PurchHeader."Currency Factor"),
                                                                      Currency2."Amount Rounding Precision")
                                                                ELSE
                                                                  "Outstanding Amount (LCY)" :=
                                                                    ROUND("Outstanding Amount",Currency2."Amount Rounding Precision");

                                                                "Outstanding Amt. Ex. VAT (LCY)" :=
                                                                  ROUND("Outstanding Amount (LCY)" / (1 + "VAT %" / 100),Currency2."Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Belõb i kõbsordre;
                                                              ENU=Outstanding Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 58  ;   ;Qty. Rcd. Not Invoiced;Decimal     ;CaptionML=[DAN=Modt. antal (ufakt.);
                                                              ENU=Qty. Rcd. Not Invoiced];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 59  ;   ;Amt. Rcd. Not Invoiced;Decimal     ;OnValidate=VAR
                                                                Currency2@1000 : Record 4;
                                                              BEGIN
                                                                GetPurchHeader;
                                                                Currency2.InitRoundingPrecision;
                                                                IF PurchHeader."Currency Code" <> '' THEN
                                                                  "Amt. Rcd. Not Invoiced (LCY)" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        GetDate,"Currency Code",
                                                                        "Amt. Rcd. Not Invoiced",PurchHeader."Currency Factor"),
                                                                      Currency2."Amount Rounding Precision")
                                                                ELSE
                                                                  "Amt. Rcd. Not Invoiced (LCY)" :=
                                                                    ROUND("Amt. Rcd. Not Invoiced",Currency2."Amount Rounding Precision");

                                                                "A. Rcd. Not Inv. Ex. VAT (LCY)" :=
                                                                  ROUND("Amt. Rcd. Not Invoiced (LCY)" / (1 + "VAT %" / 100),Currency2."Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Modt. belõb (ufakt.);
                                                              ENU=Amt. Rcd. Not Invoiced];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 60  ;   ;Quantity Received   ;Decimal       ;AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Modtaget (antal);
                                                              ENU=Quantity Received];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 61  ;   ;Quantity Invoiced   ;Decimal       ;CaptionML=[DAN=Faktureret (antal);
                                                              ENU=Quantity Invoiced];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 63  ;   ;Receipt No.         ;Code20        ;CaptionML=[DAN=Kõbsleverancenr.;
                                                              ENU=Receipt No.];
                                                   Editable=No }
    { 64  ;   ;Receipt Line No.    ;Integer       ;CaptionML=[DAN=Kõbslev.linjenr.;
                                                              ENU=Receipt Line No.];
                                                   Editable=No }
    { 67  ;   ;Profit %            ;Decimal       ;CaptionML=[DAN=Avancepct.;
                                                              ENU=Profit %];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 68  ;   ;Pay-to Vendor No.   ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Faktureringsleverandõrnr.;
                                                              ENU=Pay-to Vendor No.];
                                                   Editable=No }
    { 69  ;   ;Inv. Discount Amount;Decimal       ;OnValidate=BEGIN
                                                                UpdateAmounts;
                                                                UpdateUnitCost;
                                                                CalcInvDiscToInvoice;
                                                              END;

                                                   CaptionML=[DAN=Fakturarabatbelõb;
                                                              ENU=Inv. Discount Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 70  ;   ;Vendor Item No.     ;Text20        ;OnValidate=BEGIN
                                                                IF PurchHeader."Send IC Document" AND
                                                                   ("IC Partner Ref. Type" = "IC Partner Ref. Type"::"Vendor Item No.")
                                                                THEN
                                                                  "IC Partner Reference" := "Vendor Item No.";
                                                              END;

                                                   CaptionML=[DAN=Leverandõrs varenr.;
                                                              ENU=Vendor Item No.] }
    { 71  ;   ;Sales Order No.     ;Code20        ;TableRelation=IF (Drop Shipment=CONST(Yes)) "Sales Header".No. WHERE (Document Type=CONST(Order));
                                                   OnValidate=BEGIN
                                                                IF (xRec."Sales Order No." <> "Sales Order No.") AND (Quantity <> 0) THEN BEGIN
                                                                  ReservePurchLine.VerifyChange(Rec,xRec);
                                                                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Salgsordrenr.;
                                                              ENU=Sales Order No.];
                                                   Editable=No }
    { 72  ;   ;Sales Order Line No.;Integer       ;TableRelation=IF (Drop Shipment=CONST(Yes)) "Sales Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                                              Document No.=FIELD(Sales Order No.));
                                                   OnValidate=BEGIN
                                                                IF (xRec."Sales Order Line No." <> "Sales Order Line No.") AND (Quantity <> 0) THEN BEGIN
                                                                  ReservePurchLine.VerifyChange(Rec,xRec);
                                                                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Salgsordrelinjenr.;
                                                              ENU=Sales Order Line No.];
                                                   Editable=No }
    { 73  ;   ;Drop Shipment       ;Boolean       ;OnValidate=BEGIN
                                                                IF (xRec."Drop Shipment" <> "Drop Shipment") AND (Quantity <> 0) THEN BEGIN
                                                                  ReservePurchLine.VerifyChange(Rec,xRec);
                                                                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                                                                END;
                                                                IF "Drop Shipment" THEN BEGIN
                                                                  "Bin Code" := '';
                                                                  EVALUATE("Inbound Whse. Handling Time",'<0D>');
                                                                  VALIDATE("Inbound Whse. Handling Time");
                                                                  InitOutstanding;
                                                                  InitQtyToReceive;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=Direkte levering;
                                                              ENU=Drop Shipment];
                                                   Editable=No }
    { 74  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                                                                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                                                                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Virksomhedsbogfõringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 75  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN
                                                                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                                                                    VALIDATE("VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Produktbogfõringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 77  ;   ;VAT Calculation Type;Option        ;CaptionML=[DAN=Momsberegningstype;
                                                              ENU=VAT Calculation Type];
                                                   OptionCaptionML=[DAN=Normal moms,Modtagermoms,Momskorrektion,Sales tax;
                                                                    ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax];
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                   Editable=No }
    { 78  ;   ;Transaction Type    ;Code10        ;TableRelation="Transaction Type";
                                                   CaptionML=[DAN=Transaktionsart;
                                                              ENU=Transaction Type] }
    { 79  ;   ;Transport Method    ;Code10        ;TableRelation="Transport Method";
                                                   CaptionML=[DAN=TransportmÜde;
                                                              ENU=Transport Method] }
    { 80  ;   ;Attached to Line No.;Integer       ;TableRelation="Purchase Line"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                                                                   Document No.=FIELD(Document No.));
                                                   CaptionML=[DAN=Tilknyttet linjenr.;
                                                              ENU=Attached to Line No.];
                                                   Editable=No }
    { 81  ;   ;Entry Point         ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=[DAN=Indfõrselssted;
                                                              ENU=Entry Point] }
    { 82  ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=[DAN=OmrÜde;
                                                              ENU=Area] }
    { 83  ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=[DAN=Transaktionsspecifikation;
                                                              ENU=Transaction Specification] }
    { 85  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   OnValidate=BEGIN
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=SkatteomrÜdekode;
                                                              ENU=Tax Area Code] }
    { 86  ;   ;Tax Liable          ;Boolean       ;OnValidate=BEGIN
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 87  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 88  ;   ;Use Tax             ;Boolean       ;OnValidate=BEGIN
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Use Tax;
                                                              ENU=Use Tax] }
    { 89  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   OnValidate=BEGIN
                                                                VALIDATE("VAT Prod. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 90  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
                                                                "VAT Difference" := 0;
                                                                GetPurchHeader;
                                                                "VAT %" := VATPostingSetup."VAT %";
                                                                "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                                                                "VAT Identifier" := VATPostingSetup."VAT Identifier";
                                                                CASE "VAT Calculation Type" OF
                                                                  "VAT Calculation Type"::"Reverse Charge VAT",
                                                                  "VAT Calculation Type"::"Sales Tax":
                                                                    "VAT %" := 0;
                                                                  "VAT Calculation Type"::"Full VAT":
                                                                    BEGIN
                                                                      TESTFIELD(Type,Type::"G/L Account");
                                                                      TESTFIELD("No.",VATPostingSetup.GetPurchAccount(FALSE));
                                                                    END;
                                                                END;
                                                                IF PurchHeader."Prices Including VAT" AND (Type = Type::Item) THEN
                                                                  "Direct Unit Cost" :=
                                                                    ROUND(
                                                                      "Direct Unit Cost" * (100 + "VAT %") / (100 + xRec."VAT %"),
                                                                      Currency."Unit-Amount Rounding Precision");
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 91  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code];
                                                   Editable=No }
    { 92  ;   ;Outstanding Amount (LCY);Decimal   ;CaptionML=[DAN=UdestÜende belõb (RV);
                                                              ENU=Outstanding Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 93  ;   ;Amt. Rcd. Not Invoiced (LCY);Decimal;
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Belõb modt. ufaktureret (RV);
                                                              ENU=Amt. Rcd. Not Invoiced (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 95  ;   ;Reserved Quantity   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Document No.),
                                                                                                       Source Ref. No.=FIELD(Line No.),
                                                                                                       Source Type=CONST(39),
                                                                                                       Source Subtype=FIELD(Document Type),
                                                                                                       Reservation Status=CONST(Reservation)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Reserveret antal;
                                                              ENU=Reserved Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 97  ;   ;Blanket Order No.   ;Code20        ;TableRelation="Purchase Header".No. WHERE (Document Type=CONST(Blanket Order));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Quantity Received",0);
                                                                IF "Blanket Order No." = '' THEN
                                                                  "Blanket Order Line No." := 0
                                                                ELSE
                                                                  VALIDATE("Blanket Order Line No.");
                                                              END;

                                                   OnLookup=BEGIN
                                                              TESTFIELD("Quantity Received",0);
                                                              BlanketOrderLookup;
                                                            END;

                                                   TestTableRelation=No;
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Rammeordrenr.;
                                                              ENU=Blanket Order No.] }
    { 98  ;   ;Blanket Order Line No.;Integer     ;TableRelation="Purchase Line"."Line No." WHERE (Document Type=CONST(Blanket Order),
                                                                                                   Document No.=FIELD(Blanket Order No.));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Quantity Received",0);
                                                                IF "Blanket Order Line No." <> 0 THEN BEGIN
                                                                  PurchLine2.GET("Document Type"::"Blanket Order","Blanket Order No.","Blanket Order Line No.");
                                                                  PurchLine2.TESTFIELD(Type,Type);
                                                                  PurchLine2.TESTFIELD("No.","No.");
                                                                  PurchLine2.TESTFIELD("Pay-to Vendor No.","Pay-to Vendor No.");
                                                                  PurchLine2.TESTFIELD("Buy-from Vendor No.","Buy-from Vendor No.");
                                                                  VALIDATE("Variant Code",PurchLine2."Variant Code");
                                                                  VALIDATE("Location Code",PurchLine2."Location Code");
                                                                  VALIDATE("Unit of Measure Code",PurchLine2."Unit of Measure Code");
                                                                  VALIDATE("Direct Unit Cost",PurchLine2."Direct Unit Cost");
                                                                  VALIDATE("Line Discount %",PurchLine2."Line Discount %");
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              BlanketOrderLookup;
                                                            END;

                                                   TestTableRelation=No;
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Rammeordrelinjenr.;
                                                              ENU=Blanket Order Line No.] }
    { 99  ;   ;VAT Base Amount     ;Decimal       ;CaptionML=[DAN=Momsgrundlag (belõb);
                                                              ENU=VAT Base Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 100 ;   ;Unit Cost           ;Decimal       ;CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   Editable=No;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 101 ;   ;System-Created Entry;Boolean       ;CaptionML=[DAN=Automatisk oprettet;
                                                              ENU=System-Created Entry];
                                                   Editable=No }
    { 103 ;   ;Line Amount         ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD(Type);
                                                                TESTFIELD(Quantity);
                                                                TESTFIELD("Direct Unit Cost");

                                                                GetPurchHeader;
                                                                "Line Amount" := ROUND("Line Amount",Currency."Amount Rounding Precision");
                                                                VALIDATE(
                                                                  "Line Discount Amount",ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") - "Line Amount");
                                                              END;

                                                   CaptionML=[DAN=Linjebelõb;
                                                              ENU=Line Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Line Amount")) }
    { 104 ;   ;VAT Difference      ;Decimal       ;CaptionML=[DAN=Momsdifference;
                                                              ENU=VAT Difference];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 105 ;   ;Inv. Disc. Amount to Invoice;Decimal;
                                                   CaptionML=[DAN=Fakturer fakt.rabatbelõb;
                                                              ENU=Inv. Disc. Amount to Invoice];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 106 ;   ;VAT Identifier      ;Code20        ;CaptionML=[DAN=Moms-id;
                                                              ENU=VAT Identifier];
                                                   Editable=No }
    { 107 ;   ;IC Partner Ref. Type;Option        ;OnValidate=BEGIN
                                                                IF "IC Partner Code" <> '' THEN
                                                                  "IC Partner Ref. Type" := "IC Partner Ref. Type"::"G/L Account";
                                                                IF "IC Partner Ref. Type" <> xRec."IC Partner Ref. Type" THEN
                                                                  "IC Partner Reference" := '';
                                                                IF "IC Partner Ref. Type" = "IC Partner Ref. Type"::"Common Item No." THEN BEGIN
                                                                  IF Item."No." <> "No." THEN
                                                                    Item.GET("No.");
                                                                  Item.TESTFIELD("Common Item No.");
                                                                  "IC Partner Reference" := Item."Common Item No.";
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 410=R;
                                                   CaptionML=[DAN=Ref.type for IC-partner;
                                                              ENU=IC Partner Ref. Type];
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Vare,,,Gebyr (vare),Varereference,Fëlles varenr.,Leverandõrs varenr.";
                                                                    ENU=" ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No.,Vendor Item No."];
                                                   OptionString=[ ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No.,Vendor Item No.] }
    { 108 ;   ;IC Partner Reference;Code20        ;OnLookup=VAR
                                                              ICGLAccount@1000 : Record 410;
                                                              ItemCrossReference@1001 : Record 5717;
                                                              ItemVendorCatalog@1003 : Record 99;
                                                            BEGIN
                                                              IF "No." <> '' THEN
                                                                CASE "IC Partner Ref. Type" OF
                                                                  "IC Partner Ref. Type"::"G/L Account":
                                                                    BEGIN
                                                                      IF ICGLAccount.GET("IC Partner Reference") THEN;
                                                                      IF PAGE.RUNMODAL(PAGE::"IC G/L Account List",ICGLAccount) = ACTION::LookupOK THEN
                                                                        VALIDATE("IC Partner Reference",ICGLAccount."No.");
                                                                    END;
                                                                  "IC Partner Ref. Type"::Item:
                                                                    BEGIN
                                                                      IF Item.GET("IC Partner Reference") THEN;
                                                                      IF PAGE.RUNMODAL(PAGE::"Item List",Item) = ACTION::LookupOK THEN
                                                                        VALIDATE("IC Partner Reference",Item."No.");
                                                                    END;
                                                                  "IC Partner Ref. Type"::"Cross Reference":
                                                                    BEGIN
                                                                      GetPurchHeader;
                                                                      ItemCrossReference.RESET;
                                                                      ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
                                                                      ItemCrossReference.SETFILTER(
                                                                        "Cross-Reference Type",'%1|%2',
                                                                        ItemCrossReference."Cross-Reference Type"::Vendor,
                                                                        ItemCrossReference."Cross-Reference Type"::" ");
                                                                      ItemCrossReference.SETFILTER("Cross-Reference Type No.",'%1|%2',PurchHeader."Buy-from Vendor No.",'');
                                                                      IF PAGE.RUNMODAL(PAGE::"Cross Reference List",ItemCrossReference) = ACTION::LookupOK THEN
                                                                        VALIDATE("IC Partner Reference",ItemCrossReference."Cross-Reference No.");
                                                                    END;
                                                                  "IC Partner Ref. Type"::"Vendor Item No.":
                                                                    BEGIN
                                                                      GetPurchHeader;
                                                                      ItemVendorCatalog.SETCURRENTKEY("Vendor No.");
                                                                      ItemVendorCatalog.SETRANGE("Vendor No.",PurchHeader."Buy-from Vendor No.");
                                                                      IF PAGE.RUNMODAL(PAGE::"Vendor Item Catalog",ItemVendorCatalog) = ACTION::LookupOK THEN
                                                                        VALIDATE("IC Partner Reference",ItemVendorCatalog."Vendor Item No.");
                                                                    END;
                                                                END;
                                                            END;

                                                   AccessByPermission=TableData 410=R;
                                                   CaptionML=[DAN=Reference for IC-partner;
                                                              ENU=IC Partner Reference] }
    { 109 ;   ;Prepayment %        ;Decimal       ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                UpdatePrepmtSetupFields;

                                                                IF HasTypeToFillMandatoryFields THEN
                                                                  UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Forudbetaling i %;
                                                              ENU=Prepayment %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 110 ;   ;Prepmt. Line Amount ;Decimal       ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                PrePaymentLineAmountEntered := TRUE;
                                                                TESTFIELD("Line Amount");
                                                                IF "Prepmt. Line Amount" < "Prepmt. Amt. Inv." THEN
                                                                  FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text038,"Prepmt. Amt. Inv."));
                                                                IF "Prepmt. Line Amount" > "Line Amount" THEN
                                                                  FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text039,"Line Amount"));
                                                                VALIDATE("Prepayment %",ROUND("Prepmt. Line Amount" * 100 / "Line Amount",0.00001));
                                                              END;

                                                   CaptionML=[DAN=Linjebelõb for forudbetaling;
                                                              ENU=Prepmt. Line Amount];
                                                   MinValue=0;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Prepmt. Line Amount")) }
    { 111 ;   ;Prepmt. Amt. Inv.   ;Decimal       ;CaptionML=[DAN=Forudbetalt belõb faktureret;
                                                              ENU=Prepmt. Amt. Inv.];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Prepmt. Amt. Inv.")) }
    { 112 ;   ;Prepmt. Amt. Incl. VAT;Decimal     ;CaptionML=[DAN=Forudbetalingsbelõb inkl. moms;
                                                              ENU=Prepmt. Amt. Incl. VAT];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 113 ;   ;Prepayment Amount   ;Decimal       ;CaptionML=[DAN=Forudbetalingsbelõb;
                                                              ENU=Prepayment Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 114 ;   ;Prepmt. VAT Base Amt.;Decimal      ;CaptionML=[DAN=Momsgrundlagsbelõb for forudbetaling;
                                                              ENU=Prepmt. VAT Base Amt.];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 115 ;   ;Prepayment VAT %    ;Decimal       ;CaptionML=[DAN=Moms i % af forudbetaling;
                                                              ENU=Prepayment VAT %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   Editable=No }
    { 116 ;   ;Prepmt. VAT Calc. Type;Option      ;CaptionML=[DAN=Beregningstype for moms af forudbetaling;
                                                              ENU=Prepmt. VAT Calc. Type];
                                                   OptionCaptionML=[DAN=Normal moms,Modtagermoms,Momskorrektion,Sales tax;
                                                                    ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax];
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                   Editable=No }
    { 117 ;   ;Prepayment VAT Identifier;Code20   ;CaptionML=[DAN=Moms-id for forudbetaling;
                                                              ENU=Prepayment VAT Identifier];
                                                   Editable=No }
    { 118 ;   ;Prepayment Tax Area Code;Code20    ;TableRelation="Tax Area";
                                                   OnValidate=BEGIN
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=SkatteomrÜdekode for forudbetaling;
                                                              ENU=Prepayment Tax Area Code] }
    { 119 ;   ;Prepayment Tax Liable;Boolean      ;OnValidate=BEGIN
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Skattepligtig forudbetaling;
                                                              ENU=Prepayment Tax Liable] }
    { 120 ;   ;Prepayment Tax Group Code;Code20   ;TableRelation="Tax Group";
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Skattegruppekode for forudbetaling;
                                                              ENU=Prepayment Tax Group Code] }
    { 121 ;   ;Prepmt Amt to Deduct;Decimal       ;OnValidate=BEGIN
                                                                IF "Prepmt Amt to Deduct" > "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" THEN
                                                                  FIELDERROR(
                                                                    "Prepmt Amt to Deduct",
                                                                    STRSUBSTNO(Text039,"Prepmt. Amt. Inv." - "Prepmt Amt Deducted"));

                                                                IF "Prepmt Amt to Deduct" > "Qty. to Invoice" * "Direct Unit Cost" THEN
                                                                  FIELDERROR(
                                                                    "Prepmt Amt to Deduct",
                                                                    STRSUBSTNO(Text039,"Qty. to Invoice" * "Direct Unit Cost"));
                                                                IF ("Prepmt. Amt. Inv." - "Prepmt Amt to Deduct" - "Prepmt Amt Deducted") >
                                                                   (Quantity - "Qty. to Invoice" - "Quantity Invoiced") * "Direct Unit Cost"
                                                                THEN
                                                                  FIELDERROR(
                                                                    "Prepmt Amt to Deduct",
                                                                    STRSUBSTNO(Text038,
                                                                      "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" -
                                                                      (Quantity - "Qty. to Invoice" - "Quantity Invoiced") * "Direct Unit Cost"));
                                                              END;

                                                   CaptionML=[DAN=Forudbetalingsbelõb, der fratrëkkes;
                                                              ENU=Prepmt Amt to Deduct];
                                                   MinValue=0;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Prepmt Amt to Deduct")) }
    { 122 ;   ;Prepmt Amt Deducted ;Decimal       ;CaptionML=[DAN=Fratrukket forudbetalingsbelõb;
                                                              ENU=Prepmt Amt Deducted];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Prepmt Amt Deducted")) }
    { 123 ;   ;Prepayment Line     ;Boolean       ;CaptionML=[DAN=Forudbetalingslinje;
                                                              ENU=Prepayment Line];
                                                   Editable=No }
    { 124 ;   ;Prepmt. Amount Inv. Incl. VAT;Decimal;
                                                   CaptionML=[DAN=Forudbetalt belõb faktureret inkl. moms;
                                                              ENU=Prepmt. Amount Inv. Incl. VAT];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 129 ;   ;Prepmt. Amount Inv. (LCY);Decimal  ;CaptionML=[DAN=Forudbetalt belõb faktureret (RV);
                                                              ENU=Prepmt. Amount Inv. (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 130 ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   OnValidate=BEGIN
                                                                IF "IC Partner Code" <> '' THEN BEGIN
                                                                  TESTFIELD(Type,Type::"G/L Account");
                                                                  GetPurchHeader;
                                                                  PurchHeader.TESTFIELD("Buy-from IC Partner Code",'');
                                                                  PurchHeader.TESTFIELD("Pay-to IC Partner Code",'');
                                                                  VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"G/L Account");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=IC-partner kode;
                                                              ENU=IC Partner Code] }
    { 132 ;   ;Prepmt. VAT Amount Inv. (LCY);Decimal;
                                                   CaptionML=[DAN=Forudbetalt momsbelõb faktureret (RV);
                                                              ENU=Prepmt. VAT Amount Inv. (LCY)];
                                                   Editable=No }
    { 135 ;   ;Prepayment VAT Difference;Decimal  ;CaptionML=[DAN=Forudbetalt momsdifference;
                                                              ENU=Prepayment VAT Difference];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 136 ;   ;Prepmt VAT Diff. to Deduct;Decimal ;CaptionML=[DAN=Forudbetalt momsdifference, der fratrëkkes;
                                                              ENU=Prepmt VAT Diff. to Deduct];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 137 ;   ;Prepmt VAT Diff. Deducted;Decimal  ;CaptionML=[DAN=Forudbetalt momsdifference fratrukket;
                                                              ENU=Prepmt VAT Diff. Deducted];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 140 ;   ;Outstanding Amt. Ex. VAT (LCY);Decimal;
                                                   CaptionML=[DAN=Udes. belõb ekskl. moms (RV);
                                                              ENU=Outstanding Amt. Ex. VAT (LCY)] }
    { 141 ;   ;A. Rcd. Not Inv. Ex. VAT (LCY);Decimal;
                                                   CaptionML=[DAN=B. reg. ikke. fakt. ek. moms (RV);
                                                              ENU=A. Rcd. Not Inv. Ex. VAT (LCY)] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnValidate=BEGIN
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 1001;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Receipt No.",'');

                                                                IF "Job Task No." <> xRec."Job Task No." THEN BEGIN
                                                                  VALIDATE("Job Planning Line No.",0);
                                                                  IF "Document Type" = "Document Type"::Order THEN
                                                                    TESTFIELD("Quantity Received",0);
                                                                END;

                                                                IF "Job Task No." = '' THEN BEGIN
                                                                  CLEAR(TempJobJnlLine);
                                                                  "Job Line Type" := "Job Line Type"::" ";
                                                                  UpdateJobPrices;
                                                                  CreateDim(
                                                                    DimMgt.TypeToTableID3(Type),"No.",
                                                                    DATABASE::Job,"Job No.",
                                                                    DATABASE::"Responsibility Center","Responsibility Center",
                                                                    DATABASE::"Work Center","Work Center No.");
                                                                  EXIT;
                                                                END;

                                                                JobSetCurrencyFactor;
                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine(TRUE);
                                                                  UpdateJobPrices;
                                                                END;
                                                                UpdateDimensionsFromJobTask;
                                                              END;

                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.] }
    { 1002;   ;Job Line Type       ;Option        ;OnValidate=BEGIN
                                                                TESTFIELD("Receipt No.",'');
                                                                IF "Document Type" = "Document Type"::Order THEN
                                                                  TESTFIELD("Quantity Received",0);

                                                                IF "Job Planning Line No." <> 0 THEN
                                                                  ERROR(Text048,FIELDCAPTION("Job Line Type"),FIELDCAPTION("Job Planning Line No."));
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Linjetype for sag;
                                                              ENU=Job Line Type];
                                                   OptionCaptionML=[DAN=" ,Budget,Fakturerbar,BÜde budget og fakturerbar";
                                                                    ENU=" ,Budget,Billable,Both Budget and Billable"];
                                                   OptionString=[ ,Budget,Billable,Both Budget and Billable] }
    { 1003;   ;Job Unit Price      ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Receipt No.",'');
                                                                IF "Document Type" = "Document Type"::Order THEN
                                                                  TESTFIELD("Quantity Received",0);

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine(FALSE);
                                                                  TempJobJnlLine.VALIDATE("Unit Price","Job Unit Price");
                                                                  UpdateJobPrices;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Enhedspris for sag;
                                                              ENU=Job Unit Price];
                                                   BlankZero=Yes }
    { 1004;   ;Job Total Price     ;Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Salgsbelõb for sag;
                                                              ENU=Job Total Price];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 1005;   ;Job Line Amount     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Receipt No.",'');
                                                                IF "Document Type" = "Document Type"::Order THEN
                                                                  TESTFIELD("Quantity Received",0);

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine(FALSE);
                                                                  TempJobJnlLine.VALIDATE("Line Amount","Job Line Amount");
                                                                  UpdateJobPrices;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Linjebelõb for sag;
                                                              ENU=Job Line Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1006;   ;Job Line Discount Amount;Decimal   ;OnValidate=BEGIN
                                                                TESTFIELD("Receipt No.",'');
                                                                IF "Document Type" = "Document Type"::Order THEN
                                                                  TESTFIELD("Quantity Received",0);

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine(FALSE);
                                                                  TempJobJnlLine.VALIDATE("Line Discount Amount","Job Line Discount Amount");
                                                                  UpdateJobPrices;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Linjerabatbelõb for sag;
                                                              ENU=Job Line Discount Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1007;   ;Job Line Discount % ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Receipt No.",'');
                                                                IF "Document Type" = "Document Type"::Order THEN
                                                                  TESTFIELD("Quantity Received",0);

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine(FALSE);
                                                                  TempJobJnlLine.VALIDATE("Line Discount %","Job Line Discount %");
                                                                  UpdateJobPrices;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Linjerabat for sag i %;
                                                              ENU=Job Line Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   BlankZero=Yes }
    { 1008;   ;Job Unit Price (LCY);Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Receipt No.",'');
                                                                IF "Document Type" = "Document Type"::Order THEN
                                                                  TESTFIELD("Quantity Received",0);

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine(FALSE);
                                                                  TempJobJnlLine.VALIDATE("Unit Price (LCY)","Job Unit Price (LCY)");
                                                                  UpdateJobPrices;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Enhedspris for sag (RV);
                                                              ENU=Job Unit Price (LCY)];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 1009;   ;Job Total Price (LCY);Decimal      ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Salgsbelõb for sag (RV);
                                                              ENU=Job Total Price (LCY)];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 1010;   ;Job Line Amount (LCY);Decimal      ;OnValidate=BEGIN
                                                                TESTFIELD("Receipt No.",'');
                                                                IF "Document Type" = "Document Type"::Order THEN
                                                                  TESTFIELD("Quantity Received",0);

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine(FALSE);
                                                                  TempJobJnlLine.VALIDATE("Line Amount (LCY)","Job Line Amount (LCY)");
                                                                  UpdateJobPrices;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Linjebelõb for sag (RV);
                                                              ENU=Job Line Amount (LCY)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1011;   ;Job Line Disc. Amount (LCY);Decimal;OnValidate=BEGIN
                                                                TESTFIELD("Receipt No.",'');
                                                                IF "Document Type" = "Document Type"::Order THEN
                                                                  TESTFIELD("Quantity Received",0);

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine(FALSE);
                                                                  TempJobJnlLine.VALIDATE("Line Discount Amount (LCY)","Job Line Disc. Amount (LCY)");
                                                                  UpdateJobPrices;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Linjerabatbelõb for sag (RV);
                                                              ENU=Job Line Disc. Amount (LCY)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1012;   ;Job Currency Factor ;Decimal       ;CaptionML=[DAN=Valutafaktor for sag;
                                                              ENU=Job Currency Factor];
                                                   BlankZero=Yes }
    { 1013;   ;Job Currency Code   ;Code20        ;CaptionML=[DAN=Valutakode for sag;
                                                              ENU=Job Currency Code] }
    { 1019;   ;Job Planning Line No.;Integer      ;OnValidate=VAR
                                                                JobPlanningLine@1000 : Record 1003;
                                                              BEGIN
                                                                IF "Job Planning Line No." <> 0 THEN BEGIN
                                                                  JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
                                                                  JobPlanningLine.TESTFIELD("Job No.","Job No.");
                                                                  JobPlanningLine.TESTFIELD("Job Task No.","Job Task No.");
                                                                  CASE Type OF
                                                                    Type::"G/L Account":
                                                                      JobPlanningLine.TESTFIELD(Type,JobPlanningLine.Type::"G/L Account");
                                                                    Type::Item:
                                                                      JobPlanningLine.TESTFIELD(Type,JobPlanningLine.Type::Item);
                                                                  END;
                                                                  JobPlanningLine.TESTFIELD("No.","No.");
                                                                  JobPlanningLine.TESTFIELD("Usage Link",TRUE);
                                                                  JobPlanningLine.TESTFIELD("System-Created Entry",FALSE);
                                                                  "Job Line Type" := JobPlanningLine."Line Type" + 1;
                                                                  VALIDATE("Job Remaining Qty.",JobPlanningLine."Remaining Qty." - "Qty. to Invoice");
                                                                END ELSE
                                                                  VALIDATE("Job Remaining Qty.",0);
                                                              END;

                                                   OnLookup=VAR
                                                              JobPlanningLine@1000 : Record 1003;
                                                            BEGIN
                                                              JobPlanningLine.SETRANGE("Job No.","Job No.");
                                                              JobPlanningLine.SETRANGE("Job Task No.","Job Task No.");
                                                              CASE Type OF
                                                                Type::"G/L Account":
                                                                  JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::"G/L Account");
                                                                Type::Item:
                                                                  JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::Item);
                                                              END;
                                                              JobPlanningLine.SETRANGE("No.","No.");
                                                              JobPlanningLine.SETRANGE("Usage Link",TRUE);
                                                              JobPlanningLine.SETRANGE("System-Created Entry",FALSE);

                                                              IF PAGE.RUNMODAL(0,JobPlanningLine) = ACTION::LookupOK THEN
                                                                VALIDATE("Job Planning Line No.",JobPlanningLine."Line No.");
                                                            END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Sagsplanlëgningslinjenr.;
                                                              ENU=Job Planning Line No.];
                                                   BlankZero=Yes }
    { 1030;   ;Job Remaining Qty.  ;Decimal       ;OnValidate=VAR
                                                                JobPlanningLine@1000 : Record 1003;
                                                              BEGIN
                                                                IF ("Job Remaining Qty." <> 0) AND ("Job Planning Line No." = 0) THEN
                                                                  ERROR(Text047,FIELDCAPTION("Job Remaining Qty."),FIELDCAPTION("Job Planning Line No."));

                                                                IF "Job Planning Line No." <> 0 THEN BEGIN
                                                                  JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
                                                                  IF JobPlanningLine.Quantity >= 0 THEN BEGIN
                                                                    IF "Job Remaining Qty." < 0 THEN
                                                                      "Job Remaining Qty." := 0;
                                                                  END ELSE BEGIN
                                                                    IF "Job Remaining Qty." > 0 THEN
                                                                      "Job Remaining Qty." := 0;
                                                                  END;
                                                                END;
                                                                "Job Remaining Qty. (Base)" := CalcBaseQty("Job Remaining Qty.");
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Rest. jobantal;
                                                              ENU=Job Remaining Qty.];
                                                   DecimalPlaces=0:5 }
    { 1031;   ;Job Remaining Qty. (Base);Decimal  ;CaptionML=[DAN=Rest. jobantal (basis);
                                                              ENU=Job Remaining Qty. (Base)] }
    { 1700;   ;Deferral Code       ;Code10        ;TableRelation="Deferral Template"."Deferral Code";
                                                   OnValidate=VAR
                                                                DeferralPostDate@1000 : Date;
                                                              BEGIN
                                                                GetPurchHeader;
                                                                DeferralPostDate := PurchHeader."Posting Date";

                                                                DeferralUtilities.DeferralCodeOnValidate(
                                                                  "Deferral Code",DeferralUtilities.GetPurchDeferralDocType,'','',
                                                                  "Document Type","Document No.","Line No.",
                                                                  GetDeferralAmount,DeferralPostDate,
                                                                  Description,PurchHeader."Currency Code");

                                                                IF "Document Type" = "Document Type"::"Return Order" THEN
                                                                  "Returns Deferral Start Date" :=
                                                                    DeferralUtilities.GetDeferralStartDate(DeferralUtilities.GetPurchDeferralDocType,
                                                                      "Document Type","Document No.","Line No.","Deferral Code",PurchHeader."Posting Date");
                                                              END;

                                                   CaptionML=[DAN=Periodiseringskode;
                                                              ENU=Deferral Code] }
    { 1702;   ;Returns Deferral Start Date;Date   ;OnValidate=VAR
                                                                DeferralHeader@1000 : Record 1701;
                                                                DeferralUtilities@1001 : Codeunit 1720;
                                                              BEGIN
                                                                GetPurchHeader;
                                                                IF DeferralHeader.GET(DeferralUtilities.GetPurchDeferralDocType,'','',"Document Type","Document No.","Line No.") THEN
                                                                  DeferralUtilities.CreateDeferralSchedule("Deferral Code",DeferralUtilities.GetPurchDeferralDocType,'','',
                                                                    "Document Type","Document No.","Line No.",GetDeferralAmount,
                                                                    DeferralHeader."Calc. Method","Returns Deferral Start Date",
                                                                    DeferralHeader."No. of Periods",TRUE,
                                                                    DeferralHeader."Schedule Description",FALSE,
                                                                    PurchHeader."Currency Code");
                                                              END;

                                                   CaptionML=[DAN=Returnerer startdato for periodisering;
                                                              ENU=Returns Deferral Start Date] }
    { 5401;   ;Prod. Order No.     ;Code20        ;TableRelation="Production Order".No. WHERE (Status=CONST(Released));
                                                   OnValidate=BEGIN
                                                                IF "Drop Shipment" THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION("Prod. Order No."),"Sales Order No.");

                                                                AddOnIntegrMgt.ValidateProdOrderOnPurchLine(Rec);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   AccessByPermission=TableData 99000758=R;
                                                   CaptionML=[DAN=Prod.ordrenr.;
                                                              ENU=Prod. Order No.];
                                                   Editable=No }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   OnValidate=BEGIN
                                                                IF "Variant Code" <> '' THEN
                                                                  TESTFIELD(Type,Type::Item);
                                                                TestStatusOpen;

                                                                IF xRec."Variant Code" <> "Variant Code" THEN BEGIN
                                                                  TESTFIELD("Qty. Rcd. Not Invoiced",0);
                                                                  TESTFIELD("Receipt No.",'');

                                                                  TESTFIELD("Return Qty. Shipped Not Invd.",0);
                                                                  TESTFIELD("Return Shipment No.",'');
                                                                END;

                                                                IF "Drop Shipment" THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION("Variant Code"),"Sales Order No.");

                                                                IF Type = Type::Item THEN
                                                                  UpdateDirectUnitCost(FIELDNO("Variant Code"));

                                                                IF (xRec."Variant Code" <> "Variant Code") AND (Quantity <> 0) THEN BEGIN
                                                                  ReservePurchLine.VerifyChange(Rec,xRec);
                                                                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                                                                  InitItemAppl;
                                                                END;

                                                                UpdateLeadTimeFields;
                                                                UpdateDates;
                                                                GetDefaultBin;
                                                                IF Type = Type::Item THEN
                                                                  UpdateItemReference;

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine(TRUE);
                                                                  UpdateJobPrices;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5403;   ;Bin Code            ;Code20        ;TableRelation=IF (Document Type=FILTER(Order|Invoice),
                                                                     Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                          Item No.=FIELD(No.),
                                                                                                                          Variant Code=FIELD(Variant Code))
                                                                                                                          ELSE IF (Document Type=FILTER(Return Order|Credit Memo),
                                                                                                                                   Quantity=FILTER(>=0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                                         Item No.=FIELD(No.),
                                                                                                                                                                                         Variant Code=FIELD(Variant Code))
                                                                                                                                                                                         ELSE Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=VAR
                                                                WMSManagement@1000 : Codeunit 7302;
                                                              BEGIN
                                                                IF "Bin Code" <> '' THEN BEGIN
                                                                  IF NOT IsInbound AND ("Quantity (Base)" <> 0) THEN
                                                                    WMSManagement.FindBinContent("Location Code","Bin Code","No.","Variant Code",'')
                                                                  ELSE
                                                                    WMSManagement.FindBin("Location Code","Bin Code",'');
                                                                END;

                                                                IF "Drop Shipment" THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION("Bin Code"),"Sales Order No.");

                                                                TESTFIELD(Type,Type::Item);
                                                                TESTFIELD("Location Code");

                                                                IF "Bin Code" <> '' THEN BEGIN
                                                                  GetLocation("Location Code");
                                                                  Location.TESTFIELD("Bin Mandatory");
                                                                  CheckWarehouse;
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              WMSManagement@1000 : Codeunit 7302;
                                                              BinCode@1001 : Code[20];
                                                            BEGIN
                                                              IF NOT IsInbound AND ("Quantity (Base)" <> 0) THEN
                                                                BinCode := WMSManagement.BinContentLookUp("Location Code","No.","Variant Code",'',"Bin Code")
                                                              ELSE
                                                                BinCode := WMSManagement.BinLookUp("Location Code","No.","Variant Code",'');

                                                              IF BinCode <> '' THEN
                                                                VALIDATE("Bin Code",BinCode);
                                                            END;

                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 5404;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5407;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item),
                                                                     No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                     ELSE "Unit of Measure";
                                                   OnValidate=VAR
                                                                UnitOfMeasureTranslation@1000 : Record 5402;
                                                              BEGIN
                                                                TestStatusOpen;
                                                                TESTFIELD("Quantity Received",0);
                                                                TESTFIELD("Qty. Received (Base)",0);
                                                                TESTFIELD("Qty. Rcd. Not Invoiced",0);
                                                                TESTFIELD("Return Qty. Shipped",0);
                                                                TESTFIELD("Return Qty. Shipped (Base)",0);
                                                                IF "Unit of Measure Code" <> xRec."Unit of Measure Code" THEN BEGIN
                                                                  TESTFIELD("Receipt No.",'');
                                                                  TESTFIELD("Return Shipment No.",'');
                                                                END;
                                                                IF "Drop Shipment" THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION("Unit of Measure Code"),"Sales Order No.");
                                                                IF (xRec."Unit of Measure" <> "Unit of Measure") AND (Quantity <> 0) THEN
                                                                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                                                                UpdateDirectUnitCost(FIELDNO("Unit of Measure Code"));
                                                                IF "Unit of Measure Code" = '' THEN
                                                                  "Unit of Measure" := ''
                                                                ELSE BEGIN
                                                                  UnitOfMeasure.GET("Unit of Measure Code");
                                                                  "Unit of Measure" := UnitOfMeasure.Description;
                                                                  GetPurchHeader;
                                                                  IF PurchHeader."Language Code" <> '' THEN BEGIN
                                                                    UnitOfMeasureTranslation.SETRANGE(Code,"Unit of Measure Code");
                                                                    UnitOfMeasureTranslation.SETRANGE("Language Code",PurchHeader."Language Code");
                                                                    IF UnitOfMeasureTranslation.FINDFIRST THEN
                                                                      "Unit of Measure" := UnitOfMeasureTranslation.Description;
                                                                  END;
                                                                END;
                                                                IF Type = Type::Item THEN
                                                                  UpdateItemReference;
                                                                IF "Prod. Order No." = '' THEN BEGIN
                                                                  IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                                                                    GetItem;
                                                                    "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                                                                    "Gross Weight" := Item."Gross Weight" * "Qty. per Unit of Measure";
                                                                    "Net Weight" := Item."Net Weight" * "Qty. per Unit of Measure";
                                                                    "Unit Volume" := Item."Unit Volume" * "Qty. per Unit of Measure";
                                                                    "Units per Parcel" := ROUND(Item."Units per Parcel" / "Qty. per Unit of Measure",0.00001);
                                                                    OnAfterAssignItemUOM(Rec,Item);
                                                                    IF "Qty. per Unit of Measure" > xRec."Qty. per Unit of Measure" THEN
                                                                      InitItemAppl;
                                                                    UpdateUOMQtyPerStockQty;
                                                                  END ELSE
                                                                    "Qty. per Unit of Measure" := 1;
                                                                END ELSE
                                                                  "Qty. per Unit of Measure" := 0;

                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 5415;   ;Quantity (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE(Quantity,"Quantity (Base)");
                                                                UpdateDirectUnitCost(FIELDNO("Quantity (Base)"));
                                                              END;

                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 5416;   ;Outstanding Qty. (Base);Decimal    ;CaptionML=[DAN=UdestÜende antal (basis);
                                                              ENU=Outstanding Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5417;   ;Qty. to Invoice (Base);Decimal     ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE("Qty. to Invoice","Qty. to Invoice (Base)");
                                                              END;

                                                   CaptionML=[DAN=Fakturer antal (basis);
                                                              ENU=Qty. to Invoice (Base)];
                                                   DecimalPlaces=0:5 }
    { 5418;   ;Qty. to Receive (Base);Decimal     ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE("Qty. to Receive","Qty. to Receive (Base)");
                                                              END;

                                                   CaptionML=[DAN=Modtag antal (basis);
                                                              ENU=Qty. to Receive (Base)];
                                                   DecimalPlaces=0:5 }
    { 5458;   ;Qty. Rcd. Not Invoiced (Base);Decimal;
                                                   CaptionML=[DAN=Modt. antal ufakt. (basis);
                                                              ENU=Qty. Rcd. Not Invoiced (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5460;   ;Qty. Received (Base);Decimal       ;CaptionML=[DAN=Modtaget antal (basis);
                                                              ENU=Qty. Received (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5461;   ;Qty. Invoiced (Base);Decimal       ;CaptionML=[DAN=Faktureret antal (basis);
                                                              ENU=Qty. Invoiced (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5495;   ;Reserved Qty. (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Source Type=CONST(39),
                                                                                                                Source Subtype=FIELD(Document Type),
                                                                                                                Source ID=FIELD(Document No.),
                                                                                                                Source Ref. No.=FIELD(Line No.),
                                                                                                                Reservation Status=CONST(Reservation)));
                                                   CaptionML=[DAN=Reserveret antal (basis);
                                                              ENU=Reserved Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5600;   ;FA Posting Date     ;Date          ;CaptionML=[DAN=Bogfõringsdato for anlëg;
                                                              ENU=FA Posting Date] }
    { 5601;   ;FA Posting Type     ;Option        ;OnValidate=BEGIN
                                                                IF Type = Type::"Fixed Asset" THEN BEGIN
                                                                  TESTFIELD("Job No.",'');
                                                                  IF "FA Posting Type" = "FA Posting Type"::" " THEN
                                                                    "FA Posting Type" := "FA Posting Type"::"Acquisition Cost";
                                                                  GetFAPostingGroup;
                                                                END ELSE BEGIN
                                                                  "Depreciation Book Code" := '';
                                                                  "FA Posting Date" := 0D;
                                                                  "Salvage Value" := 0;
                                                                  "Depr. until FA Posting Date" := FALSE;
                                                                  "Depr. Acquisition Cost" := FALSE;
                                                                  "Maintenance Code" := '';
                                                                  "Insurance No." := '';
                                                                  "Budgeted FA No." := '';
                                                                  "Duplicate in Depreciation Book" := '';
                                                                  "Use Duplication List" := FALSE;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Anlëgsbogfõringstype;
                                                              ENU=FA Posting Type];
                                                   OptionCaptionML=[DAN=" ,Anskaffelse,Reparation";
                                                                    ENU=" ,Acquisition Cost,Maintenance"];
                                                   OptionString=[ ,Acquisition Cost,Maintenance] }
    { 5602;   ;Depreciation Book Code;Code10      ;TableRelation="Depreciation Book";
                                                   OnValidate=BEGIN
                                                                GetFAPostingGroup;
                                                              END;

                                                   CaptionML=[DAN=Afskrivningsprofilkode;
                                                              ENU=Depreciation Book Code] }
    { 5603;   ;Salvage Value       ;Decimal       ;CaptionML=[DAN=Skrapvërdi;
                                                              ENU=Salvage Value];
                                                   AutoFormatType=1 }
    { 5605;   ;Depr. until FA Posting Date;Boolean;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Afskriv til bogfõringsdato for anlëg;
                                                              ENU=Depr. until FA Posting Date] }
    { 5606;   ;Depr. Acquisition Cost;Boolean     ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Afskriv anskaffelse;
                                                              ENU=Depr. Acquisition Cost] }
    { 5609;   ;Maintenance Code    ;Code10        ;TableRelation=Maintenance;
                                                   CaptionML=[DAN=Reparationskode;
                                                              ENU=Maintenance Code] }
    { 5610;   ;Insurance No.       ;Code20        ;TableRelation=Insurance;
                                                   CaptionML=[DAN=Forsikringsnr.;
                                                              ENU=Insurance No.] }
    { 5611;   ;Budgeted FA No.     ;Code20        ;TableRelation="Fixed Asset";
                                                   OnValidate=VAR
                                                                FixedAsset@1000 : Record 5600;
                                                              BEGIN
                                                                IF "Budgeted FA No." <> '' THEN BEGIN
                                                                  FixedAsset.GET("Budgeted FA No.");
                                                                  FixedAsset.TESTFIELD("Budgeted Asset",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Budgetanlëgsnr.;
                                                              ENU=Budgeted FA No.] }
    { 5612;   ;Duplicate in Depreciation Book;Code10;
                                                   TableRelation="Depreciation Book";
                                                   OnValidate=BEGIN
                                                                "Use Duplication List" := FALSE;
                                                              END;

                                                   CaptionML=[DAN=Kopier til afskr.profil;
                                                              ENU=Duplicate in Depreciation Book] }
    { 5613;   ;Use Duplication List;Boolean       ;OnValidate=BEGIN
                                                                "Duplicate in Depreciation Book" := '';
                                                              END;

                                                   AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Brug kopiliste;
                                                              ENU=Use Duplication List] }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   OnValidate=BEGIN
                                                                CreateDim(
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DimMgt.TypeToTableID3(Type),"No.",
                                                                  DATABASE::Job,"Job No.",
                                                                  DATABASE::"Work Center","Work Center No.");
                                                              END;

                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center];
                                                   Editable=No }
    { 5705;   ;Cross-Reference No. ;Code20        ;OnValidate=VAR
                                                                ReturnedCrossRef@1000 : Record 5717;
                                                              BEGIN
                                                                GetPurchHeader;
                                                                "Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";

                                                                ReturnedCrossRef.INIT;
                                                                IF "Cross-Reference No." <> '' THEN BEGIN
                                                                  DistIntegration.ICRLookupPurchaseItem(Rec,ReturnedCrossRef);
                                                                  VALIDATE("No.",ReturnedCrossRef."Item No.");
                                                                  SetVendorItemNo;
                                                                  IF ReturnedCrossRef."Variant Code" <> '' THEN
                                                                    VALIDATE("Variant Code",ReturnedCrossRef."Variant Code");
                                                                  IF ReturnedCrossRef."Unit of Measure" <> '' THEN
                                                                    VALIDATE("Unit of Measure Code",ReturnedCrossRef."Unit of Measure");
                                                                  UpdateDirectUnitCost(FIELDNO("Cross-Reference No."));
                                                                END;

                                                                "Unit of Measure (Cross Ref.)" := ReturnedCrossRef."Unit of Measure";
                                                                "Cross-Reference Type" := ReturnedCrossRef."Cross-Reference Type";
                                                                "Cross-Reference Type No." := ReturnedCrossRef."Cross-Reference Type No.";
                                                                "Cross-Reference No." := ReturnedCrossRef."Cross-Reference No.";

                                                                IF ReturnedCrossRef.Description <> '' THEN
                                                                  Description := ReturnedCrossRef.Description;

                                                                UpdateICPartner;
                                                              END;

                                                   OnLookup=BEGIN
                                                              CrossReferenceNoLookUp;
                                                            END;

                                                   AccessByPermission=TableData 5717=R;
                                                   CaptionML=[DAN=Varereferencenr.;
                                                              ENU=Cross-Reference No.] }
    { 5706;   ;Unit of Measure (Cross Ref.);Code10;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
                                                   CaptionML=[DAN=Enhed (vareref.);
                                                              ENU=Unit of Measure (Cross Ref.)] }
    { 5707;   ;Cross-Reference Type;Option        ;CaptionML=[DAN=Varereferencetype;
                                                              ENU=Cross-Reference Type];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,Stregkode";
                                                                    ENU=" ,Customer,Vendor,Bar Code"];
                                                   OptionString=[ ,Customer,Vendor,Bar Code] }
    { 5708;   ;Cross-Reference Type No.;Code30    ;CaptionML=[DAN=Varereferencetypenr.;
                                                              ENU=Cross-Reference Type No.] }
    { 5709;   ;Item Category Code  ;Code20        ;TableRelation="Item Category";
                                                   CaptionML=[DAN=Varekategorikode;
                                                              ENU=Item Category Code] }
    { 5710;   ;Nonstock            ;Boolean       ;AccessByPermission=TableData 5718=R;
                                                   CaptionML=[DAN=Katalogvare;
                                                              ENU=Nonstock] }
    { 5711;   ;Purchasing Code     ;Code10        ;TableRelation=Purchasing;
                                                   OnValidate=VAR
                                                                PurchasingCode@1000 : Record 5721;
                                                              BEGIN
                                                                IF PurchasingCode.GET("Purchasing Code") THEN BEGIN
                                                                  "Drop Shipment" := PurchasingCode."Drop Shipment";
                                                                  "Special Order" := PurchasingCode."Special Order";
                                                                END ELSE
                                                                  "Drop Shipment" := FALSE;
                                                                VALIDATE("Drop Shipment","Drop Shipment");
                                                              END;

                                                   CaptionML=[DAN=Indkõbskode;
                                                              ENU=Purchasing Code];
                                                   Editable=No }
    { 5712;   ;Product Group Code  ;Code10        ;TableRelation="Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
                                                   ValidateTableRelation=No;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Product Groups became first level children of Item Categories.;
                                                   CaptionML=[DAN=Produktgruppekode;
                                                              ENU=Product Group Code] }
    { 5713;   ;Special Order       ;Boolean       ;OnValidate=BEGIN
                                                                IF (xRec."Special Order" <> "Special Order") AND (Quantity <> 0) THEN
                                                                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Specialordre;
                                                              ENU=Special Order] }
    { 5714;   ;Special Order Sales No.;Code20     ;TableRelation=IF (Special Order=CONST(Yes)) "Sales Header".No. WHERE (Document Type=CONST(Order));
                                                   OnValidate=BEGIN
                                                                IF (xRec."Special Order Sales No." <> "Special Order Sales No.") AND (Quantity <> 0) THEN
                                                                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                                                              END;

                                                   AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=Salgsordrenr. for specialordre;
                                                              ENU=Special Order Sales No.] }
    { 5715;   ;Special Order Sales Line No.;Integer;
                                                   TableRelation=IF (Special Order=CONST(Yes)) "Sales Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                                              Document No.=FIELD(Special Order Sales No.));
                                                   OnValidate=BEGIN
                                                                IF (xRec."Special Order Sales Line No." <> "Special Order Sales Line No.") AND (Quantity <> 0) THEN
                                                                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                                                              END;

                                                   AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=Salgslinjenr. for specialordre;
                                                              ENU=Special Order Sales Line No.] }
    { 5750;   ;Whse. Outstanding Qty. (Base);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Receipt Line"."Qty. Outstanding (Base)" WHERE (Source Type=CONST(39),
                                                                                                                             Source Subtype=FIELD(Document Type),
                                                                                                                             Source No.=FIELD(Document No.),
                                                                                                                             Source Line No.=FIELD(Line No.)));
                                                   AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=Udest. mëngde pÜ lager (basis);
                                                              ENU=Whse. Outstanding Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 5752;   ;Completely Received ;Boolean       ;CaptionML=[DAN=Modtagelse komplet;
                                                              ENU=Completely Received];
                                                   Editable=No }
    { 5790;   ;Requested Receipt Date;Date        ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF (CurrFieldNo <> 0) AND
                                                                   ("Promised Receipt Date" <> 0D)
                                                                THEN
                                                                  ERROR(
                                                                    Text023,
                                                                    FIELDCAPTION("Requested Receipt Date"),
                                                                    FIELDCAPTION("Promised Receipt Date"));

                                                                IF "Requested Receipt Date" <> 0D THEN
                                                                  VALIDATE("Order Date",
                                                                    CalendarMgmt.CalcDateBOC2(AdjustDateFormula("Lead Time Calculation"),"Requested Receipt Date",
                                                                      CalChange."Source Type"::Vendor,"Buy-from Vendor No.",'',
                                                                      CalChange."Source Type"::Location,"Location Code",'',TRUE))
                                                                ELSE
                                                                  IF "Requested Receipt Date" <> xRec."Requested Receipt Date" THEN
                                                                    GetUpdateBasicDates;
                                                              END;

                                                   AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=ùnsket modtagelsesdato;
                                                              ENU=Requested Receipt Date] }
    { 5791;   ;Promised Receipt Date;Date         ;OnValidate=BEGIN
                                                                IF CurrFieldNo <> 0 THEN
                                                                  IF "Promised Receipt Date" <> 0D THEN
                                                                    VALIDATE("Planned Receipt Date","Promised Receipt Date")
                                                                  ELSE
                                                                    VALIDATE("Requested Receipt Date")
                                                                ELSE
                                                                  VALIDATE("Planned Receipt Date","Promised Receipt Date");
                                                              END;

                                                   AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=Bekrëftet modtagelsesdato;
                                                              ENU=Promised Receipt Date] }
    { 5792;   ;Lead Time Calculation;DateFormula  ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                LeadTimeMgt.CheckLeadTimeIsNotNegative("Lead Time Calculation");

                                                                IF "Requested Receipt Date" <> 0D THEN
                                                                  VALIDATE("Planned Receipt Date")
                                                                ELSE
                                                                  GetUpdateBasicDates;
                                                              END;

                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Leveringstid;
                                                              ENU=Lead Time Calculation] }
    { 5793;   ;Inbound Whse. Handling Time;DateFormula;
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF ("Promised Receipt Date" <> 0D) OR
                                                                   ("Requested Receipt Date" <> 0D)
                                                                THEN
                                                                  VALIDATE("Planned Receipt Date")
                                                                ELSE
                                                                  VALIDATE("Expected Receipt Date");
                                                              END;

                                                   AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=IndgÜende lagerekspeditionstid;
                                                              ENU=Inbound Whse. Handling Time] }
    { 5794;   ;Planned Receipt Date;Date          ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF "Promised Receipt Date" <> 0D THEN BEGIN
                                                                  IF "Planned Receipt Date" <> 0D THEN
                                                                    "Expected Receipt Date" :=
                                                                      CalendarMgmt.CalcDateBOC(InternalLeadTimeDays("Planned Receipt Date"),"Planned Receipt Date",
                                                                        CalChange."Source Type"::Location,"Location Code",'',
                                                                        CalChange."Source Type"::Location,"Location Code",'',FALSE)
                                                                  ELSE
                                                                    "Expected Receipt Date" := "Planned Receipt Date";
                                                                END ELSE
                                                                  IF "Planned Receipt Date" <> 0D THEN BEGIN
                                                                    "Order Date" :=
                                                                      CalendarMgmt.CalcDateBOC2(AdjustDateFormula("Lead Time Calculation"),"Planned Receipt Date",
                                                                        CalChange."Source Type"::Vendor,"Buy-from Vendor No.",'',
                                                                        CalChange."Source Type"::Location,"Location Code",'',TRUE);
                                                                    "Expected Receipt Date" :=
                                                                      CalendarMgmt.CalcDateBOC(InternalLeadTimeDays("Planned Receipt Date"),"Planned Receipt Date",
                                                                        CalChange."Source Type"::Location,"Location Code",'',
                                                                        CalChange."Source Type"::Location,"Location Code",'',FALSE)
                                                                  END ELSE
                                                                    GetUpdateBasicDates;

                                                                IF NOT TrackingBlocked THEN
                                                                  CheckDateConflict.PurchLineCheck(Rec,CurrFieldNo <> 0);
                                                              END;

                                                   AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=Planlagt modtagelsesdato;
                                                              ENU=Planned Receipt Date] }
    { 5795;   ;Order Date          ;Date          ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF (CurrFieldNo <> 0) AND
                                                                   ("Document Type" = "Document Type"::Order) AND
                                                                   ("Order Date" < WORKDATE) AND
                                                                   ("Order Date" <> 0D)
                                                                THEN
                                                                  MESSAGE(
                                                                    Text018,
                                                                    FIELDCAPTION("Order Date"),"Order Date",WORKDATE);

                                                                IF "Order Date" <> 0D THEN
                                                                  "Planned Receipt Date" :=
                                                                    CalendarMgmt.CalcDateBOC(AdjustDateFormula("Lead Time Calculation"),"Order Date",
                                                                      CalChange."Source Type"::Vendor,"Buy-from Vendor No.",'',
                                                                      CalChange."Source Type"::Location,"Location Code",'',TRUE);

                                                                IF "Planned Receipt Date" <> 0D THEN
                                                                  "Expected Receipt Date" :=
                                                                    CalendarMgmt.CalcDateBOC(InternalLeadTimeDays("Planned Receipt Date"),"Planned Receipt Date",
                                                                      CalChange."Source Type"::Location,"Location Code",'',
                                                                      CalChange."Source Type"::Location,"Location Code",'',FALSE)
                                                                ELSE
                                                                  "Expected Receipt Date" := "Planned Receipt Date";

                                                                IF NOT TrackingBlocked THEN
                                                                  CheckDateConflict.PurchLineCheck(Rec,CurrFieldNo <> 0);
                                                              END;

                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Ordredato;
                                                              ENU=Order Date] }
    { 5800;   ;Allow Item Charge Assignment;Boolean;
                                                   InitValue=Yes;
                                                   OnValidate=BEGIN
                                                                CheckItemChargeAssgnt;
                                                              END;

                                                   AccessByPermission=TableData 5800=R;
                                                   CaptionML=[DAN=Tillad varegebyrtildeling;
                                                              ENU=Allow Item Charge Assignment] }
    { 5801;   ;Qty. to Assign      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Charge Assignment (Purch)"."Qty. to Assign" WHERE (Document Type=FIELD(Document Type),
                                                                                                                            Document No.=FIELD(Document No.),
                                                                                                                            Document Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Antal, der skal tildeles;
                                                              ENU=Qty. to Assign];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5802;   ;Qty. Assigned       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Charge Assignment (Purch)"."Qty. Assigned" WHERE (Document Type=FIELD(Document Type),
                                                                                                                           Document No.=FIELD(Document No.),
                                                                                                                           Document Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Antal tildelt;
                                                              ENU=Qty. Assigned];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5803;   ;Return Qty. to Ship ;Decimal       ;OnValidate=BEGIN
                                                                IF (CurrFieldNo <> 0) AND
                                                                   (Type = Type::Item) AND
                                                                   ("Return Qty. to Ship" <> 0) AND
                                                                   (NOT "Drop Shipment")
                                                                THEN
                                                                  CheckWarehouse;

                                                                IF "Return Qty. to Ship" = Quantity - "Return Qty. Shipped" THEN
                                                                  InitQtyToShip
                                                                ELSE BEGIN
                                                                  "Return Qty. to Ship (Base)" := CalcBaseQty("Return Qty. to Ship");
                                                                  InitQtyToInvoice;
                                                                END;
                                                                IF ("Return Qty. to Ship" * Quantity < 0) OR
                                                                   (ABS("Return Qty. to Ship") > ABS("Outstanding Quantity")) OR
                                                                   (Quantity * "Outstanding Quantity" < 0)
                                                                THEN
                                                                  ERROR(
                                                                    Text020,
                                                                    "Outstanding Quantity");
                                                                IF ("Return Qty. to Ship (Base)" * "Quantity (Base)" < 0) OR
                                                                   (ABS("Return Qty. to Ship (Base)") > ABS("Outstanding Qty. (Base)")) OR
                                                                   ("Quantity (Base)" * "Outstanding Qty. (Base)" < 0)
                                                                THEN
                                                                  ERROR(
                                                                    Text021,
                                                                    "Outstanding Qty. (Base)");

                                                                IF (CurrFieldNo <> 0) AND (Type = Type::Item) AND ("Return Qty. to Ship" > 0) THEN
                                                                  CheckApplToItemLedgEntry;
                                                              END;

                                                   AccessByPermission=TableData 6650=R;
                                                   CaptionML=[DAN=Til afsendelse retur;
                                                              ENU=Return Qty. to Ship];
                                                   DecimalPlaces=0:5 }
    { 5804;   ;Return Qty. to Ship (Base);Decimal ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE("Return Qty. to Ship","Return Qty. to Ship (Base)");
                                                              END;

                                                   CaptionML=[DAN=Returantal til afsend. (basis);
                                                              ENU=Return Qty. to Ship (Base)];
                                                   DecimalPlaces=0:5 }
    { 5805;   ;Return Qty. Shipped Not Invd.;Decimal;
                                                   CaptionML=[DAN=Sendt retur ufaktureret;
                                                              ENU=Return Qty. Shipped Not Invd.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5806;   ;Ret. Qty. Shpd Not Invd.(Base);Decimal;
                                                   CaptionML=[DAN=Sendt retur ufakt. (basis);
                                                              ENU=Ret. Qty. Shpd Not Invd.(Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5807;   ;Return Shpd. Not Invd.;Decimal     ;OnValidate=VAR
                                                                Currency2@1000 : Record 4;
                                                              BEGIN
                                                                GetPurchHeader;
                                                                Currency2.InitRoundingPrecision;
                                                                IF PurchHeader."Currency Code" <> '' THEN
                                                                  "Return Shpd. Not Invd. (LCY)" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        GetDate,"Currency Code",
                                                                        "Return Shpd. Not Invd.",PurchHeader."Currency Factor"),
                                                                      Currency2."Amount Rounding Precision")
                                                                ELSE
                                                                  "Return Shpd. Not Invd. (LCY)" :=
                                                                    ROUND("Return Shpd. Not Invd.",Currency2."Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Afs. ret.vare - ikke fakt.;
                                                              ENU=Return Shpd. Not Invd.];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 5808;   ;Return Shpd. Not Invd. (LCY);Decimal;
                                                   CaptionML=[DAN=Afs. ret.vare - ikke fakt. (RV);
                                                              ENU=Return Shpd. Not Invd. (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5809;   ;Return Qty. Shipped ;Decimal       ;AccessByPermission=TableData 6650=R;
                                                   CaptionML=[DAN=Antal sendt retur;
                                                              ENU=Return Qty. Shipped];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5810;   ;Return Qty. Shipped (Base);Decimal ;CaptionML=[DAN=Antal sendt retur (basis);
                                                              ENU=Return Qty. Shipped (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 6600;   ;Return Shipment No. ;Code20        ;CaptionML=[DAN=Returvareleverancenr.;
                                                              ENU=Return Shipment No.];
                                                   Editable=No }
    { 6601;   ;Return Shipment Line No.;Integer   ;CaptionML=[DAN=Returvarekvit.linjenr.;
                                                              ENU=Return Shipment Line No.];
                                                   Editable=No }
    { 6608;   ;Return Reason Code  ;Code10        ;TableRelation="Return Reason";
                                                   OnValidate=BEGIN
                                                                ValidateReturnReasonCode(FIELDNO("Return Reason Code"));
                                                              END;

                                                   CaptionML=[DAN=ReturÜrsagskode;
                                                              ENU=Return Reason Code] }
    { 6609;   ;Subtype             ;Option        ;CaptionML=[DAN=Undertype;
                                                              ENU=Subtype];
                                                   OptionCaptionML=[DAN=" ,Vare - Lager,Vare - Service,Kommentar";
                                                                    ENU=" ,Item - Inventory,Item - Service,Comment"];
                                                   OptionString=[ ,Item - Inventory,Item - Service,Comment] }
    { 99000750;;Routing No.        ;Code20        ;TableRelation="Routing Header";
                                                   CaptionML=[DAN=Rutenr.;
                                                              ENU=Routing No.] }
    { 99000751;;Operation No.      ;Code10        ;TableRelation="Prod. Order Routing Line"."Operation No." WHERE (Status=CONST(Released),
                                                                                                                   Prod. Order No.=FIELD(Prod. Order No.),
                                                                                                                   Routing No.=FIELD(Routing No.));
                                                   OnValidate=VAR
                                                                ProdOrderRtngLine@1000 : Record 5409;
                                                              BEGIN
                                                                IF "Operation No." = '' THEN
                                                                  EXIT;

                                                                TESTFIELD(Type,Type::Item);
                                                                TESTFIELD("Prod. Order No.");
                                                                TESTFIELD("Routing No.");

                                                                ProdOrderRtngLine.GET(
                                                                  ProdOrderRtngLine.Status::Released,
                                                                  "Prod. Order No.",
                                                                  "Routing Reference No.",
                                                                  "Routing No.",
                                                                  "Operation No.");

                                                                ProdOrderRtngLine.TESTFIELD(
                                                                  Type,
                                                                  ProdOrderRtngLine.Type::"Work Center");

                                                                "Expected Receipt Date" := ProdOrderRtngLine."Ending Date";
                                                                VALIDATE("Work Center No.",ProdOrderRtngLine."No.");
                                                                VALIDATE("Direct Unit Cost",ProdOrderRtngLine."Direct Unit Cost");
                                                              END;

                                                   CaptionML=[DAN=Operationsnr.;
                                                              ENU=Operation No.];
                                                   Editable=No }
    { 99000752;;Work Center No.    ;Code20        ;TableRelation="Work Center";
                                                   OnValidate=BEGIN
                                                                IF Type = Type::"Charge (Item)" THEN
                                                                  TESTFIELD("Work Center No.",'');
                                                                IF "Work Center No." = '' THEN
                                                                  EXIT;

                                                                WorkCenter.GET("Work Center No.");
                                                                "Gen. Prod. Posting Group" := WorkCenter."Gen. Prod. Posting Group";
                                                                "VAT Prod. Posting Group" := '';
                                                                IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                                                                  "VAT Prod. Posting Group" := GenProdPostingGrp."Def. VAT Prod. Posting Group";
                                                                VALIDATE("VAT Prod. Posting Group");

                                                                "Overhead Rate" := WorkCenter."Overhead Rate";
                                                                VALIDATE("Indirect Cost %",WorkCenter."Indirect Cost %");

                                                                CreateDim(
                                                                  DATABASE::"Work Center","Work Center No.",
                                                                  DimMgt.TypeToTableID3(Type),"No.",
                                                                  DATABASE::Job,"Job No.",
                                                                  DATABASE::"Responsibility Center","Responsibility Center");
                                                              END;

                                                   CaptionML=[DAN=Arbejdscenternr.;
                                                              ENU=Work Center No.];
                                                   Editable=No }
    { 99000753;;Finished           ;Boolean       ;CaptionML=[DAN=Fërdig;
                                                              ENU=Finished] }
    { 99000754;;Prod. Order Line No.;Integer      ;TableRelation="Prod. Order Line"."Line No." WHERE (Status=FILTER(Released..),
                                                                                                      Prod. Order No.=FIELD(Prod. Order No.));
                                                   CaptionML=[DAN=Prod.ordrelinjenr.;
                                                              ENU=Prod. Order Line No.];
                                                   Editable=No }
    { 99000755;;Overhead Rate      ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Indirect Cost %");
                                                              END;

                                                   CaptionML=[DAN=IPO-bidrag;
                                                              ENU=Overhead Rate];
                                                   DecimalPlaces=0:5 }
    { 99000756;;MPS Order          ;Boolean       ;CaptionML=[DAN=Hovedplansordre;
                                                              ENU=MPS Order] }
    { 99000757;;Planning Flexibility;Option       ;OnValidate=BEGIN
                                                                IF "Planning Flexibility" <> xRec."Planning Flexibility" THEN
                                                                  ReservePurchLine.UpdatePlanningFlexibility(Rec);
                                                              END;

                                                   CaptionML=[DAN=Planlëgningsfleksibilitet;
                                                              ENU=Planning Flexibility];
                                                   OptionCaptionML=[DAN=Ubegrënset,Ingen;
                                                                    ENU=Unlimited,None];
                                                   OptionString=Unlimited,None }
    { 99000758;;Safety Lead Time   ;DateFormula   ;OnValidate=BEGIN
                                                                VALIDATE("Inbound Whse. Handling Time");
                                                              END;

                                                   CaptionML=[DAN=Sikkerhedstid;
                                                              ENU=Safety Lead Time] }
    { 99000759;;Routing Reference No.;Integer     ;CaptionML=[DAN=Rutereferencenr.;
                                                              ENU=Routing Reference No.] }
  }
  KEYS
  {
    {    ;Document Type,Document No.,Line No.     ;SumIndexFields=Amount,Amount Including VAT;
                                                   MaintainSIFTIndex=No;
                                                   Clustered=Yes }
    { No ;Document No.,Line No.,Document Type      }
    {    ;Document Type,Type,No.,Variant Code,Drop Shipment,Location Code,Expected Receipt Date;
                                                   SumIndexFields=Outstanding Qty. (Base) }
    {    ;Document Type,Pay-to Vendor No.,Currency Code;
                                                   SumIndexFields=Outstanding Amount,Amt. Rcd. Not Invoiced,Outstanding Amount (LCY),Amt. Rcd. Not Invoiced (LCY);
                                                   MaintainSIFTIndex=No }
    { No ;Document Type,Type,No.,Variant Code,Drop Shipment,Shortcut Dimension 1 Code,Shortcut Dimension 2 Code,Location Code,Expected Receipt Date;
                                                   SumIndexFields=Outstanding Qty. (Base);
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    { No ;Document Type,Pay-to Vendor No.,Shortcut Dimension 1 Code,Shortcut Dimension 2 Code,Currency Code;
                                                   SumIndexFields=Outstanding Amount,Amt. Rcd. Not Invoiced,Outstanding Amount (LCY),Amt. Rcd. Not Invoiced (LCY);
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    {    ;Document Type,Blanket Order No.,Blanket Order Line No. }
    {    ;Document Type,Type,Prod. Order No.,Prod. Order Line No.,Routing No.,Operation No. }
    { No ;Document Type,Document No.,Location Code }
    {    ;Document Type,Receipt No.,Receipt Line No. }
    {    ;Type,No.,Variant Code,Drop Shipment,Location Code,Document Type,Expected Receipt Date;
                                                   MaintainSQLIndex=No }
    {    ;Document Type,Buy-from Vendor No.        }
    {    ;Document Type,Job No.,Job Task No.      ;SumIndexFields=Outstanding Amt. Ex. VAT (LCY),A. Rcd. Not Inv. Ex. VAT (LCY) }
    { No ;Document Type,Document No.,Type,No.      }
    { No ;Document Type,Type,No.                  ;SumIndexFields=Outstanding Qty. (Base) }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 kan ikke omdõbes.;ENU=You cannot rename a %1.';
      Text001@1001 : TextConst 'DAN=Du kan ikke ëndre %1, fordi ordrelinjen er knyttet til salgsordre %2.;ENU=You cannot change %1 because the order line is associated with sales order %2.';
      Text002@1002 : TextConst 'DAN=Priser inkl. moms kan ikke beregnes, nÜr %1 er %2.;ENU=Prices including VAT cannot be calculated when %1 is %2.';
      Text003@1003 : TextConst 'DAN=Du kan ikke kõbe ressourcer.;ENU=You cannot purchase resources.';
      Text004@1004 : TextConst 'DAN=mÜ ikke vëre mindre end %1;ENU=must not be less than %1';
      Text006@1005 : TextConst 'DAN=Du kan hõjst fakturere %1 enheder.;ENU=You cannot invoice more than %1 units.';
      Text007@1006 : TextConst 'DAN=Du kan hõjst fakturere %1 basisenheder.;ENU=You cannot invoice more than %1 base units.';
      Text008@1007 : TextConst 'DAN=Du kan hõjst modtage %1 enheder.;ENU=You cannot receive more than %1 units.';
      Text009@1008 : TextConst 'DAN=Du kan hõjst modtage %1 basisenheder.;ENU=You cannot receive more than %1 base units.';
      Text010@1009 : TextConst 'DAN=Du kan ikke ëndre %1, nÜr %2 er %3.;ENU=You cannot change %1 when %2 is %3.';
      Text011@1010 : TextConst 'DAN=" skal vëre 0, nÜr %1 er %2";ENU=" must be 0 when %1 is %2"';
      Text012@1011 : TextConst 'DAN="mÜ ikke indtastes nÜr %1 = %2";ENU="must not be specified when %1 = %2"';
      Text016@1014 : TextConst 'DAN="%1 krëves til %2 = %3.";ENU="%1 is required for %2 = %3."';
      Text017@1015 : TextConst 'DAN=\De angivne oplysninger ignoreres muligvis af lageroperationerne.;ENU=\The entered information may be disregarded by warehouse operations.';
      Text018@1016 : TextConst 'DAN=%1 %2 ligger fõr arbejdsdatoen %3.;ENU=%1 %2 is earlier than the work date %3.';
      Text020@1018 : TextConst 'DAN=Du kan ikke returnere mere end %1 enheder.;ENU=You cannot return more than %1 units.';
      Text021@1019 : TextConst 'DAN=Du kan ikke returnere mere end %1 basisenheder.;ENU=You cannot return more than %1 base units.';
      Text022@1020 : TextConst 'DAN=Du kan ikke ëndre %1, hvis et varegebyr allerede er bogfõrt.;ENU=You cannot change %1, if item charge is already posted.';
      Text023@1072 : TextConst 'DAN=%1 kan ikke ëndres, nÜr %2 er udfyldt.;ENU=You cannot change the %1 when the %2 has been filled in.';
      Text029@1077 : TextConst 'DAN=skal vëre positiv.;ENU=must be positive.';
      Text030@1076 : TextConst 'DAN=skal vëre negativ.;ENU=must be negative.';
      Text031@1056 : TextConst 'DAN=Du kan ikke angive varesporing pÜ denne linje, fordi den er knyttet til produktionsordren %1.;ENU=You cannot define item tracking on this line because it is linked to production order %1.';
      Text032@1017 : TextConst 'DAN=%1 mÜ ikke vëre stõrre end summen af %2 og %3.;ENU=%1 must not be greater than the sum of %2 and %3.';
      Text033@1078 : TextConst 'DAN="Lagersted ";ENU="Warehouse "';
      Text034@1079 : TextConst 'DAN="Lager ";ENU="Inventory "';
      Text035@1048 : TextConst 'DAN=%1 enheder til %2 %3 er allerede returneret eller overfõrt. Derfor kan der kun returneres %4 enheder.;ENU=%1 units for %2 %3 have already been returned or transferred. Therefore, only %4 units can be returned.';
      Text037@1082 : TextConst 'DAN=mÜ ikke vëre %1.;ENU=cannot be %1.';
      Text038@1083 : TextConst 'DAN=mÜ ikke vëre mindre end %1.;ENU=cannot be less than %1.';
      Text039@1084 : TextConst 'DAN=mÜ ikke vëre stõrre end %1.;ENU=cannot be more than %1.';
      Text040@1090 : TextConst 'DAN=Du skal bruge formularen %1 til at angive %2, hvis der anvendes varesporing.;ENU=You must use form %1 to enter %2, if item tracking is used.';
      ItemChargeAssignmentErr@1097 : TextConst 'DAN=Du kan kun tildele varegebyrer til linjer af typen Gebyr (vare).;ENU=You can only assign Item Charges for Line Types of Charge (Item).';
      Text99000000@1021 : TextConst 'DAN=Du kan ikke ëndre %1, nÜr kõbsordren er knyttet til en produktionsordre.;ENU=You cannot change %1 when the purchase order is associated to a production order.';
      PurchHeader@1022 : Record 38;
      PurchLine2@1023 : Record 39;
      GLAcc@1025 : Record 15;
      Item@1026 : Record 27;
      Currency@1027 : Record 4;
      CurrExchRate@1028 : Record 330;
      VATPostingSetup@1034 : Record 325;
      GenBusPostingGrp@1039 : Record 250;
      GenProdPostingGrp@1040 : Record 251;
      UnitOfMeasure@1043 : Record 204;
      ItemCharge@1044 : Record 5800;
      SKU@1046 : Record 5700;
      WorkCenter@1047 : Record 99000754;
      InvtSetup@1050 : Record 313;
      Location@1051 : Record 14;
      GLSetup@1074 : Record 98;
      CalChange@1062 : Record 7602;
      TempJobJnlLine@1071 : TEMPORARY Record 210;
      PurchSetup@1095 : Record 312;
      SalesTaxCalculate@1057 : Codeunit 398;
      ReservEngineMgt@1058 : Codeunit 99000831;
      ReservePurchLine@1059 : Codeunit 99000834;
      UOMMgt@1060 : Codeunit 5402;
      AddOnIntegrMgt@1061 : Codeunit 5403;
      DimMgt@1064 : Codeunit 408;
      DistIntegration@1065 : Codeunit 5702;
      NonstockItemMgt@1066 : Codeunit 5703;
      WhseValidateSourceLine@1067 : Codeunit 5777;
      LeadTimeMgt@1069 : Codeunit 5404;
      PurchPriceCalcMgt@1030 : Codeunit 7010;
      CalendarMgmt@1032 : Codeunit 7600;
      CheckDateConflict@1013 : Codeunit 99000815;
      DeferralUtilities@1081 : Codeunit 1720;
      PostingSetupMgt@1031 : Codeunit 48;
      TrackingBlocked@1070 : Boolean;
      StatusCheckSuspended@1073 : Boolean;
      GLSetupRead@1075 : Boolean;
      UnitCostCurrency@1063 : Decimal;
      UpdateFromVAT@1087 : Boolean;
      Text042@1088 : TextConst 'DAN=Du kan ikke returnere mere end de %1 enheder, du har modtaget for %2 %3.;ENU=You cannot return more than the %1 units that you have received for %2 %3.';
      Text043@1089 : TextConst 'DAN=skal vëre positiv, nÜr %1 ikke er 0.;ENU=must be positive when %1 is not 0.';
      Text044@1080 : TextConst 'DAN=Du kan ikke ëndre %1, fordi denne kõbsordre er knyttet til %2 %3.;ENU=You cannot change %1 because this purchase order is associated with %2 %3.';
      Text046@1091 : TextConst '@@@=%1 - product name;DAN=%3 opdaterer ikke %1, nÜr %2 ëndres, da der er bogfõrt en forudbetalingsfaktura. Vil du fortsëtte?;ENU=%3 will not update %1 when changing %2 because a prepayment invoice has been posted. Do you want to continue?';
      Text047@1092 : TextConst 'DAN=%1 kan kun angives, nÜr %2 er angivet.;ENU=%1 can only be set when %2 is set.';
      Text048@1093 : TextConst 'DAN=%1 kan ikke ëndres, nÜr %2 er angivet.;ENU=%1 cannot be changed when %2 is set.';
      PrePaymentLineAmountEntered@1042 : Boolean;
      Text049@1085 : TextConst 'DAN=Du har ëndret en eller flere dimensioner pÜ %1, som allerede er afsendt. NÜr du bogfõrer linjen med den ëndrede dimension under finansposter, vil belõb pÜ lagerkonto (mellemregningskto.) ikke stemme, nÜr de rapporteres pr. dimension.\\Vil du beholde den ëndrede dimension?;ENU=You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?';
      Text050@1086 : TextConst 'DAN=Annulleret.;ENU=Cancelled.';
      Text051@1012 : TextConst 'DAN=skal have samme fortegn som kõbsleverancen;ENU=must have the same sign as the receipt';
      Text052@1053 : TextConst 'DAN=Det antal, som du forsõger at fakturere, er stõrre end antallet pÜ kvitteringen %1.;ENU=The quantity that you are trying to invoice is greater than the quantity in receipt %1.';
      Text053@1054 : TextConst 'DAN=skal have samme fortegn som returvareleverancen;ENU=must have the same sign as the return shipment';
      Text054@1055 : TextConst 'DAN=Det antal, som du forsõger at fakturere, er stõrre end antallet pÜ returvarekvitteringen %1.;ENU=The quantity that you are trying to invoice is greater than the quantity in return shipment %1.';
      AnotherItemWithSameDescrQst@1033 : TextConst '@@@="%1=Item no., %2=item description";DAN=Varenr. %1 har ogsÜ beskrivelsen "%2".\Vil du ëndre det aktuelle varenummer til %1?;ENU=Item No. %1 also has the description "%2".\Do you want to change the current item no. to %1?';
      AnotherChargeItemWithSameDescQst@1029 : TextConst '@@@="%1=Item charge no., %2=item charge description";DAN=Varegebyrnr. %1 har ogsÜ beskrivelsen "%2".\Vil du ëndre det aktuelle varegebyrnummer til %1?;ENU=Item charge No. %1 also has the description "%2".\Do you want to change the current item charge no. to %1?';
      PurchSetupRead@1096 : Boolean;
      CannotFindDescErr@1035 : TextConst '@@@="%1 = Type caption %2 = Description";DAN=Kan ikke finde %1 med beskrivelsen %2.\\Sõrg for at bruge den korrekte type.;ENU=Cannot find %1 with Description %2.\\Make sure to use the correct type.';
      CommentLbl@1024 : TextConst 'DAN=Bemërkning;ENU=Comment';
      CannotBeNegativeErr@1036 : TextConst '@@@=%1 - Field Caption;DAN=Feltet %1 kan ikke vëre negativt pÜ indkõbslinjen.;ENU=The %1 field cannot be negative on the purchase line.';

    [External]
    PROCEDURE InitOutstanding@16();
    BEGIN
      IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
        "Outstanding Quantity" := Quantity - "Return Qty. Shipped";
        "Outstanding Qty. (Base)" := "Quantity (Base)" - "Return Qty. Shipped (Base)";
        "Return Qty. Shipped Not Invd." := "Return Qty. Shipped" - "Quantity Invoiced";
        "Ret. Qty. Shpd Not Invd.(Base)" := "Return Qty. Shipped (Base)" - "Qty. Invoiced (Base)";
      END ELSE BEGIN
        "Outstanding Quantity" := Quantity - "Quantity Received";
        "Outstanding Qty. (Base)" := "Quantity (Base)" - "Qty. Received (Base)";
        "Qty. Rcd. Not Invoiced" := "Quantity Received" - "Quantity Invoiced";
        "Qty. Rcd. Not Invoiced (Base)" := "Qty. Received (Base)" - "Qty. Invoiced (Base)";
      END;
      "Completely Received" := (Quantity <> 0) AND ("Outstanding Quantity" = 0);
      InitOutstandingAmount;
    END;

    [External]
    PROCEDURE InitOutstandingAmount@19();
    VAR
      AmountInclVAT@1000 : Decimal;
    BEGIN
      IF Quantity = 0 THEN BEGIN
        "Outstanding Amount" := 0;
        "Outstanding Amount (LCY)" := 0;
        "Outstanding Amt. Ex. VAT (LCY)" := 0;
        "Amt. Rcd. Not Invoiced" := 0;
        "Amt. Rcd. Not Invoiced (LCY)" := 0;
        "Return Shpd. Not Invd." := 0;
        "Return Shpd. Not Invd. (LCY)" := 0;
      END ELSE BEGIN
        GetPurchHeader;
        AmountInclVAT := "Amount Including VAT";
        VALIDATE(
          "Outstanding Amount",
          ROUND(
            AmountInclVAT * "Outstanding Quantity" / Quantity,
            Currency."Amount Rounding Precision"));
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          VALIDATE(
            "Return Shpd. Not Invd.",
            ROUND(
              AmountInclVAT * "Return Qty. Shipped Not Invd." / Quantity,
              Currency."Amount Rounding Precision"))
        ELSE
          VALIDATE(
            "Amt. Rcd. Not Invoiced",
            ROUND(
              AmountInclVAT * "Qty. Rcd. Not Invoiced" / Quantity,
              Currency."Amount Rounding Precision"));
      END;

      OnAfterInitOutstandingAmount(Rec,xRec,PurchHeader,Currency);
    END;

    [External]
    PROCEDURE InitQtyToReceive@15();
    BEGIN
      GetPurchSetup;
      IF (PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Remainder) OR
         ("Document Type" = "Document Type"::Invoice)
      THEN BEGIN
        "Qty. to Receive" := "Outstanding Quantity";
        "Qty. to Receive (Base)" := "Outstanding Qty. (Base)";
      END ELSE
        IF "Qty. to Receive" <> 0 THEN
          "Qty. to Receive (Base)" := CalcBaseQty("Qty. to Receive");

      OnAfterInitQtyToReceive(Rec,CurrFieldNo);

      InitQtyToInvoice;
    END;

    [External]
    PROCEDURE InitQtyToShip@5803();
    BEGIN
      GetPurchSetup;
      IF (PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Remainder) OR
         ("Document Type" = "Document Type"::"Credit Memo")
      THEN BEGIN
        "Return Qty. to Ship" := "Outstanding Quantity";
        "Return Qty. to Ship (Base)" := "Outstanding Qty. (Base)";
      END ELSE
        IF "Return Qty. to Ship" <> 0 THEN
          "Return Qty. to Ship (Base)" := CalcBaseQty("Return Qty. to Ship");

      OnAfterInitQtyToShip(Rec,CurrFieldNo);

      InitQtyToInvoice;
    END;

    [External]
    PROCEDURE InitQtyToInvoice@13();
    BEGIN
      "Qty. to Invoice" := MaxQtyToInvoice;
      "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
      "VAT Difference" := 0;
      CalcInvDiscToInvoice;
      IF PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice THEN
        CalcPrepaymentToDeduct;

      OnAfterInitQtyToInvoice(Rec,CurrFieldNo);
    END;

    LOCAL PROCEDURE InitItemAppl@46();
    BEGIN
      "Appl.-to Item Entry" := 0;
    END;

    LOCAL PROCEDURE InitHeaderDefaults@97(PurchHeader@1000 : Record 38);
    BEGIN
      PurchHeader.TESTFIELD("Buy-from Vendor No.");

      "Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
      "Currency Code" := PurchHeader."Currency Code";
      "Expected Receipt Date" := PurchHeader."Expected Receipt Date";
      "Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
      IF NOT IsServiceItem THEN
        "Location Code" := PurchHeader."Location Code";
      "Transaction Type" := PurchHeader."Transaction Type";
      "Transport Method" := PurchHeader."Transport Method";
      "Pay-to Vendor No." := PurchHeader."Pay-to Vendor No.";
      "Gen. Bus. Posting Group" := PurchHeader."Gen. Bus. Posting Group";
      "VAT Bus. Posting Group" := PurchHeader."VAT Bus. Posting Group";
      "Entry Point" := PurchHeader."Entry Point";
      Area := PurchHeader.Area;
      "Transaction Specification" := PurchHeader."Transaction Specification";
      "Tax Area Code" := PurchHeader."Tax Area Code";
      "Tax Liable" := PurchHeader."Tax Liable";
      IF NOT "System-Created Entry" AND ("Document Type" = "Document Type"::Order) AND HasTypeToFillMandatoryFields THEN
        "Prepayment %" := PurchHeader."Prepayment %";
      "Prepayment Tax Area Code" := PurchHeader."Tax Area Code";
      "Prepayment Tax Liable" := PurchHeader."Tax Liable";
      "Responsibility Center" := PurchHeader."Responsibility Center";
      "Requested Receipt Date" := PurchHeader."Requested Receipt Date";
      "Promised Receipt Date" := PurchHeader."Promised Receipt Date";
      "Inbound Whse. Handling Time" := PurchHeader."Inbound Whse. Handling Time";
      "Order Date" := PurchHeader."Order Date";
    END;

    [External]
    PROCEDURE MaxQtyToInvoice@18() : Decimal;
    BEGIN
      IF "Prepayment Line" THEN
        EXIT(1);
      IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
        EXIT("Return Qty. Shipped" + "Return Qty. to Ship" - "Quantity Invoiced");

      EXIT("Quantity Received" + "Qty. to Receive" - "Quantity Invoiced");
    END;

    [External]
    PROCEDURE MaxQtyToInvoiceBase@17() : Decimal;
    BEGIN
      IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
        EXIT("Return Qty. Shipped (Base)" + "Return Qty. to Ship (Base)" - "Qty. Invoiced (Base)");

      EXIT("Qty. Received (Base)" + "Qty. to Receive (Base)" - "Qty. Invoiced (Base)");
    END;

    [External]
    PROCEDURE CalcInvDiscToInvoice@33();
    VAR
      OldInvDiscAmtToInv@1000 : Decimal;
    BEGIN
      GetPurchHeader;
      OldInvDiscAmtToInv := "Inv. Disc. Amount to Invoice";
      IF Quantity = 0 THEN
        VALIDATE("Inv. Disc. Amount to Invoice",0)
      ELSE
        VALIDATE(
          "Inv. Disc. Amount to Invoice",
          ROUND(
            "Inv. Discount Amount" * "Qty. to Invoice" / Quantity,
            Currency."Amount Rounding Precision"));

      IF OldInvDiscAmtToInv <> "Inv. Disc. Amount to Invoice" THEN BEGIN
        "Amount Including VAT" := "Amount Including VAT" - "VAT Difference";
        "VAT Difference" := 0;
      END;
    END;

    LOCAL PROCEDURE CalcBaseQty@14(Qty@1000 : Decimal) : Decimal;
    BEGIN
      IF "Prod. Order No." = '' THEN
        TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    END;

    LOCAL PROCEDURE CopyFromStandardText@95();
    VAR
      StandardText@1000 : Record 7;
    BEGIN
      StandardText.GET("No.");
      Description := StandardText.Description;
      "Allow Item Charge Assignment" := FALSE;
      OnAfterAssignStdTxtValues(Rec,StandardText);
    END;

    LOCAL PROCEDURE CopyFromGLAccount@96();
    BEGIN
      GLAcc.GET("No.");
      GLAcc.CheckGLAcc;
      IF NOT "System-Created Entry" THEN
        GLAcc.TESTFIELD("Direct Posting",TRUE);
      Description := GLAcc.Name;
      "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
      "Tax Group Code" := GLAcc."Tax Group Code";
      "Allow Invoice Disc." := FALSE;
      "Allow Item Charge Assignment" := FALSE;
      InitDeferralCode;
      OnAfterAssignGLAccountValues(Rec,GLAcc);
    END;

    LOCAL PROCEDURE CopyFromItem@100();
    VAR
      PrepaymentMgt@1000 : Codeunit 441;
    BEGIN
      GetItem;
      GetGLSetup;
      Item.TESTFIELD(Blocked,FALSE);
      Item.TESTFIELD("Gen. Prod. Posting Group");
      IF Item.Type = Item.Type::Inventory THEN BEGIN
        Item.TESTFIELD("Inventory Posting Group");
        "Posting Group" := Item."Inventory Posting Group";
      END;
      Description := Item.Description;
      "Description 2" := Item."Description 2";
      "Unit Price (LCY)" := Item."Unit Price";
      "Units per Parcel" := Item."Units per Parcel";
      "Indirect Cost %" := Item."Indirect Cost %";
      "Overhead Rate" := Item."Overhead Rate";
      "Allow Invoice Disc." := Item."Allow Invoice Disc.";
      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
      "Tax Group Code" := Item."Tax Group Code";
      Nonstock := Item."Created From Nonstock Item";
      "Item Category Code" := Item."Item Category Code";
      "Product Group Code" := Item."Product Group Code";
      "Allow Item Charge Assignment" := TRUE;
      PrepaymentMgt.SetPurchPrepaymentPct(Rec,PurchHeader."Posting Date");
      IF Item.Type = Item.Type::Inventory THEN
        PostingSetupMgt.CheckInvtPostingSetupInventoryAccount("Location Code","Posting Group");

      IF Item."Price Includes VAT" THEN BEGIN
        IF NOT VATPostingSetup.GET(Item."VAT Bus. Posting Gr. (Price)",Item."VAT Prod. Posting Group") THEN
          VATPostingSetup.INIT;
        CASE VATPostingSetup."VAT Calculation Type" OF
          VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
            VATPostingSetup."VAT %" := 0;
          VATPostingSetup."VAT Calculation Type"::"Sales Tax":
            ERROR(
              Text002,
              VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
              VATPostingSetup."VAT Calculation Type");
        END;
        "Unit Price (LCY)" :=
          ROUND("Unit Price (LCY)" / (1 + VATPostingSetup."VAT %" / 100),
            GLSetup."Unit-Amount Rounding Precision");
      END;

      IF PurchHeader."Language Code" <> '' THEN
        GetItemTranslation;

      "Unit of Measure Code" := Item."Purch. Unit of Measure";
      InitDeferralCode;
      OnAfterAssignItemValues(Rec,Item);
    END;

    LOCAL PROCEDURE CopyFromFixedAsset@101();
    VAR
      FixedAsset@1000 : Record 5600;
    BEGIN
      FixedAsset.GET("No.");
      FixedAsset.TESTFIELD(Inactive,FALSE);
      FixedAsset.TESTFIELD(Blocked,FALSE);
      GetFAPostingGroup;
      Description := FixedAsset.Description;
      "Description 2" := FixedAsset."Description 2";
      "Allow Invoice Disc." := FALSE;
      "Allow Item Charge Assignment" := FALSE;
      OnAfterAssignFixedAssetValues(Rec,FixedAsset);
    END;

    LOCAL PROCEDURE CopyFromItemCharge@107();
    BEGIN
      ItemCharge.GET("No.");
      Description := ItemCharge.Description;
      "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
      "Tax Group Code" := ItemCharge."Tax Group Code";
      "Allow Invoice Disc." := FALSE;
      "Allow Item Charge Assignment" := FALSE;
      "Indirect Cost %" := 0;
      "Overhead Rate" := 0;
      OnAfterAssignItemChargeValues(Rec,ItemCharge);
    END;

    LOCAL PROCEDURE SelectItemEntry@7();
    VAR
      ItemLedgEntry@1001 : Record 32;
    BEGIN
      TESTFIELD("Prod. Order No.",'');
      ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
      ItemLedgEntry.SETRANGE("Item No.","No.");
      ItemLedgEntry.SETRANGE(Open,TRUE);
      ItemLedgEntry.SETRANGE(Positive,TRUE);
      IF "Location Code" <> '' THEN
        ItemLedgEntry.SETRANGE("Location Code","Location Code");
      ItemLedgEntry.SETRANGE("Variant Code","Variant Code");

      IF PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK THEN
        VALIDATE("Appl.-to Item Entry",ItemLedgEntry."Entry No.");
    END;

    [External]
    PROCEDURE SetPurchHeader@12(NewPurchHeader@1000 : Record 38);
    BEGIN
      PurchHeader := NewPurchHeader;

      IF PurchHeader."Currency Code" = '' THEN
        Currency.InitRoundingPrecision
      ELSE BEGIN
        PurchHeader.TESTFIELD("Currency Factor");
        Currency.GET(PurchHeader."Currency Code");
        Currency.TESTFIELD("Amount Rounding Precision");
      END;
    END;

    LOCAL PROCEDURE GetPurchHeader@1();
    BEGIN
      TESTFIELD("Document No.");
      IF ("Document Type" <> PurchHeader."Document Type") OR ("Document No." <> PurchHeader."No.") THEN BEGIN
        PurchHeader.GET("Document Type","Document No.");
        IF PurchHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          PurchHeader.TESTFIELD("Currency Factor");
          Currency.GET(PurchHeader."Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
      END;
    END;

    LOCAL PROCEDURE GetItem@4();
    BEGIN
      TESTFIELD("No.");
      IF Item."No." <> "No." THEN
        Item.GET("No.");
    END;

    LOCAL PROCEDURE UpdateDirectUnitCost@2(CalledByFieldNo@1000 : Integer);
    BEGIN
      OnBeforeUpdateDirectUnitCost(Rec,xRec,CalledByFieldNo,CurrFieldNo);

      IF (CurrFieldNo <> 0) AND ("Prod. Order No." <> '') THEN
        UpdateAmounts;

      IF ((CalledByFieldNo <> CurrFieldNo) AND (CurrFieldNo <> 0)) OR
         ("Prod. Order No." <> '')
      THEN
        EXIT;

      IF Type = Type::Item THEN BEGIN
        GetPurchHeader;
        PurchPriceCalcMgt.FindPurchLinePrice(PurchHeader,Rec,CalledByFieldNo);
        PurchPriceCalcMgt.FindPurchLineLineDisc(PurchHeader,Rec);
        VALIDATE("Direct Unit Cost");

        IF CalledByFieldNo IN [FIELDNO("No."),FIELDNO("Variant Code"),FIELDNO("Location Code")] THEN
          UpdateItemReference;
      END;

      OnAfterUpdateDirectUnitCost(Rec,xRec,CalledByFieldNo,CurrFieldNo);
    END;

    [Internal]
    PROCEDURE UpdateUnitCost@5();
    VAR
      DiscountAmountPerQty@1000 : Decimal;
    BEGIN
      GetPurchHeader;
      GetGLSetup;
      IF Quantity = 0 THEN
        DiscountAmountPerQty := 0
      ELSE
        DiscountAmountPerQty :=
          ROUND(("Line Discount Amount" + "Inv. Discount Amount") / Quantity,
            GLSetup."Unit-Amount Rounding Precision");

      IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN
        "Unit Cost" := 0
      ELSE
        IF PurchHeader."Prices Including VAT" THEN
          "Unit Cost" :=
            ("Direct Unit Cost" - DiscountAmountPerQty) * (1 + "Indirect Cost %" / 100) / (1 + "VAT %" / 100) +
            GetOverheadRateFCY - "VAT Difference"
        ELSE
          "Unit Cost" :=
            ("Direct Unit Cost" - DiscountAmountPerQty) * (1 + "Indirect Cost %" / 100) +
            GetOverheadRateFCY;

      IF PurchHeader."Currency Code" <> '' THEN BEGIN
        PurchHeader.TESTFIELD("Currency Factor");
        "Unit Cost (LCY)" :=
          CurrExchRate.ExchangeAmtFCYToLCY(
            GetDate,"Currency Code",
            "Unit Cost",PurchHeader."Currency Factor");
      END ELSE
        "Unit Cost (LCY)" := "Unit Cost";

      IF (Type = Type::Item) AND ("Prod. Order No." = '') THEN BEGIN
        GetItem;
        IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
          IF GetSKU THEN
            "Unit Cost (LCY)" := SKU."Unit Cost" * "Qty. per Unit of Measure"
          ELSE
            "Unit Cost (LCY)" := Item."Unit Cost" * "Qty. per Unit of Measure";
        END;
      END;

      "Unit Cost (LCY)" := ROUND("Unit Cost (LCY)",GLSetup."Unit-Amount Rounding Precision");
      IF PurchHeader."Currency Code" <> '' THEN
        Currency.TESTFIELD("Unit-Amount Rounding Precision");
      "Unit Cost" := ROUND("Unit Cost",Currency."Unit-Amount Rounding Precision");

      OnAfterUpdateUnitCost(Rec,xRec,PurchHeader,Item,SKU,Currency,GLSetup);

      UpdateSalesCost;

      IF JobTaskIsSet AND NOT UpdateFromVAT AND NOT "Prepayment Line" THEN BEGIN
        CreateTempJobJnlLine(FALSE);
        TempJobJnlLine.VALIDATE("Unit Cost (LCY)","Unit Cost (LCY)");
        UpdateJobPrices;
      END;
    END;

    [External]
    PROCEDURE UpdateAmounts@3();
    VAR
      RemLineAmountToInvoice@1000 : Decimal;
      VATBaseAmount@1003 : Decimal;
      LineAmountChanged@1002 : Boolean;
    BEGIN
      IF Type = Type::" " THEN
        EXIT;
      GetPurchHeader;

      VATBaseAmount := "VAT Base Amount";
      "Recalculate Invoice Disc." := TRUE;

      IF "Line Amount" <> xRec."Line Amount" THEN BEGIN
        "VAT Difference" := 0;
        LineAmountChanged := TRUE;
      END;
      IF "Line Amount" <> ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") - "Line Discount Amount" THEN BEGIN
        "Line Amount" :=
          ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") - "Line Discount Amount";
        "VAT Difference" := 0;
        LineAmountChanged := TRUE;
      END;

      IF NOT "Prepayment Line" THEN BEGIN
        IF "Prepayment %" <> 0 THEN BEGIN
          IF Quantity < 0 THEN
            FIELDERROR(Quantity,STRSUBSTNO(Text043,FIELDCAPTION("Prepayment %")));
          IF "Direct Unit Cost" < 0 THEN
            FIELDERROR("Direct Unit Cost",STRSUBSTNO(Text043,FIELDCAPTION("Prepayment %")));
        END;
        IF PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice THEN BEGIN
          "Prepayment VAT Difference" := 0;
          IF NOT PrePaymentLineAmountEntered THEN
            "Prepmt. Line Amount" := ROUND("Line Amount" * "Prepayment %" / 100,Currency."Amount Rounding Precision");
          IF "Prepmt. Line Amount" < "Prepmt. Amt. Inv." THEN
            FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text037,"Prepmt. Amt. Inv."));
          PrePaymentLineAmountEntered := FALSE;
          IF "Prepmt. Line Amount" <> 0 THEN BEGIN
            RemLineAmountToInvoice :=
              ROUND("Line Amount" * (Quantity - "Quantity Invoiced") / Quantity,Currency."Amount Rounding Precision");
            IF RemLineAmountToInvoice < ("Prepmt. Line Amount" - "Prepmt Amt Deducted") THEN
              FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text039,RemLineAmountToInvoice + "Prepmt Amt Deducted"));
          END;
        END ELSE
          IF (CurrFieldNo <> 0) AND ("Line Amount" <> xRec."Line Amount") AND
             ("Prepmt. Amt. Inv." <> 0) AND ("Prepayment %" = 100)
          THEN BEGIN
            IF "Line Amount" < xRec."Line Amount" THEN
              FIELDERROR("Line Amount",STRSUBSTNO(Text038,xRec."Line Amount"));
            FIELDERROR("Line Amount",STRSUBSTNO(Text039,xRec."Line Amount"));
          END;
      END;

      OnAfterUpdateAmounts(Rec);

      UpdateVATAmounts;
      IF VATBaseAmount <> "VAT Base Amount" THEN
        LineAmountChanged := TRUE;

      IF LineAmountChanged THEN BEGIN
        UpdateDeferralAmounts;
        LineAmountChanged := FALSE;
      END;

      InitOutstandingAmount;

      IF Type = Type::"Charge (Item)" THEN
        UpdateItemChargeAssgnt;

      CalcPrepaymentToDeduct;
    END;

    LOCAL PROCEDURE UpdateVATAmounts@38();
    VAR
      PurchLine2@1000 : Record 39;
      TotalLineAmount@1005 : Decimal;
      TotalInvDiscAmount@1004 : Decimal;
      TotalAmount@1001 : Decimal;
      TotalAmountInclVAT@1002 : Decimal;
      TotalQuantityBase@1003 : Decimal;
    BEGIN
      GetPurchHeader;
      PurchLine2.SETRANGE("Document Type","Document Type");
      PurchLine2.SETRANGE("Document No.","Document No.");
      PurchLine2.SETFILTER("Line No.",'<>%1',"Line No.");
      IF "Line Amount" = 0 THEN
        IF xRec."Line Amount" >= 0 THEN
          PurchLine2.SETFILTER(Amount,'>%1',0)
        ELSE
          PurchLine2.SETFILTER(Amount,'<%1',0)
      ELSE
        IF "Line Amount" > 0 THEN
          PurchLine2.SETFILTER(Amount,'>%1',0)
        ELSE
          PurchLine2.SETFILTER(Amount,'<%1',0);
      PurchLine2.SETRANGE("VAT Identifier","VAT Identifier");
      PurchLine2.SETRANGE("Tax Group Code","Tax Group Code");

      IF "Line Amount" = "Inv. Discount Amount" THEN BEGIN
        Amount := 0;
        "VAT Base Amount" := 0;
        "Amount Including VAT" := 0;
      END ELSE BEGIN
        TotalLineAmount := 0;
        TotalInvDiscAmount := 0;
        TotalAmount := 0;
        TotalAmountInclVAT := 0;
        TotalQuantityBase := 0;
        IF ("VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax") OR
           (("VAT Calculation Type" IN
             ["VAT Calculation Type"::"Normal VAT","VAT Calculation Type"::"Reverse Charge VAT"]) AND ("VAT %" <> 0))
        THEN
          IF NOT PurchLine2.ISEMPTY THEN BEGIN
            PurchLine2.CALCSUMS("Line Amount","Inv. Discount Amount",Amount,"Amount Including VAT","Quantity (Base)");
            TotalLineAmount := PurchLine2."Line Amount";
            TotalInvDiscAmount := PurchLine2."Inv. Discount Amount";
            TotalAmount := PurchLine2.Amount;
            TotalAmountInclVAT := PurchLine2."Amount Including VAT";
            TotalQuantityBase := PurchLine2."Quantity (Base)";
          END;

        IF PurchHeader."Prices Including VAT" THEN
          CASE "VAT Calculation Type" OF
            "VAT Calculation Type"::"Normal VAT",
            "VAT Calculation Type"::"Reverse Charge VAT":
              BEGIN
                Amount :=
                  ROUND(
                    (TotalLineAmount - TotalInvDiscAmount + "Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
                    Currency."Amount Rounding Precision") -
                  TotalAmount;
                "VAT Base Amount" :=
                  ROUND(
                    Amount * (1 - PurchHeader."VAT Base Discount %" / 100),
                    Currency."Amount Rounding Precision");
                "Amount Including VAT" :=
                  TotalLineAmount + "Line Amount" -
                  ROUND(
                    (TotalAmount + Amount) * (PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                    Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                  TotalAmountInclVAT - TotalInvDiscAmount - "Inv. Discount Amount";
              END;
            "VAT Calculation Type"::"Full VAT":
              BEGIN
                Amount := 0;
                "VAT Base Amount" := 0;
              END;
            "VAT Calculation Type"::"Sales Tax":
              BEGIN
                PurchHeader.TESTFIELD("VAT Base Discount %",0);
                "Amount Including VAT" :=
                  ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision");
                IF "Use Tax" THEN
                  Amount := "Amount Including VAT"
                ELSE
                  Amount :=
                    ROUND(
                      SalesTaxCalculate.ReverseCalculateTax(
                        "Tax Area Code","Tax Group Code","Tax Liable",PurchHeader."Posting Date",
                        TotalAmountInclVAT + "Amount Including VAT",TotalQuantityBase + "Quantity (Base)",
                        PurchHeader."Currency Factor"),
                      Currency."Amount Rounding Precision") -
                    TotalAmount;
                "VAT Base Amount" := Amount;
                IF "VAT Base Amount" <> 0 THEN
                  "VAT %" :=
                    ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                ELSE
                  "VAT %" := 0;
              END;
          END
        ELSE
          CASE "VAT Calculation Type" OF
            "VAT Calculation Type"::"Normal VAT",
            "VAT Calculation Type"::"Reverse Charge VAT":
              BEGIN
                Amount := ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision");
                "VAT Base Amount" :=
                  ROUND(Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                "Amount Including VAT" :=
                  TotalAmount + Amount +
                  ROUND(
                    (TotalAmount + Amount) * (1 - PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                    Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                  TotalAmountInclVAT;
              END;
            "VAT Calculation Type"::"Full VAT":
              BEGIN
                Amount := 0;
                "VAT Base Amount" := 0;
                "Amount Including VAT" := "Line Amount" - "Inv. Discount Amount";
              END;
            "VAT Calculation Type"::"Sales Tax":
              BEGIN
                Amount := ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision");
                "VAT Base Amount" := Amount;
                IF "Use Tax" THEN
                  "Amount Including VAT" := Amount
                ELSE
                  "Amount Including VAT" :=
                    TotalAmount + Amount +
                    ROUND(
                      SalesTaxCalculate.CalculateTax(
                        "Tax Area Code","Tax Group Code","Tax Liable",PurchHeader."Posting Date",
                        TotalAmount + Amount,TotalQuantityBase + "Quantity (Base)",
                        PurchHeader."Currency Factor"),
                      Currency."Amount Rounding Precision") -
                    TotalAmountInclVAT;
                IF "VAT Base Amount" <> 0 THEN
                  "VAT %" :=
                    ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                ELSE
                  "VAT %" := 0;
              END;
          END;
      END;
    END;

    [External]
    PROCEDURE UpdatePrepmtSetupFields@102();
    VAR
      GenPostingSetup@1001 : Record 252;
      GLAcc@1000 : Record 15;
    BEGIN
      IF ("Prepayment %" <> 0) AND HasTypeToFillMandatoryFields THEN BEGIN
        TESTFIELD("Document Type","Document Type"::Order);
        TESTFIELD("No.");
        GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
        IF GenPostingSetup."Purch. Prepayments Account" <> '' THEN BEGIN
          GLAcc.GET(GenPostingSetup."Purch. Prepayments Account");
          VATPostingSetup.GET("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
          VATPostingSetup.TESTFIELD("VAT Calculation Type","VAT Calculation Type");
        END ELSE
          CLEAR(VATPostingSetup);
        "Prepayment VAT %" := VATPostingSetup."VAT %";
        "Prepmt. VAT Calc. Type" := VATPostingSetup."VAT Calculation Type";
        "Prepayment VAT Identifier" := VATPostingSetup."VAT Identifier";
        IF "Prepmt. VAT Calc. Type" IN
           ["Prepmt. VAT Calc. Type"::"Reverse Charge VAT","Prepmt. VAT Calc. Type"::"Sales Tax"]
        THEN
          "Prepayment VAT %" := 0;
        "Prepayment Tax Group Code" := GLAcc."Tax Group Code";
      END;
    END;

    LOCAL PROCEDURE UpdateSalesCost@6();
    VAR
      SalesOrderLine@1000 : Record 37;
    BEGIN
      CASE TRUE OF
        "Sales Order Line No." <> 0:
          // Drop Shipment
          SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Sales Order No.","Sales Order Line No.");
        "Special Order Sales Line No." <> 0:
          // Special Order
          BEGIN
            IF NOT
               SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Special Order Sales No.","Special Order Sales Line No.")
            THEN
              EXIT;
          END;
        ELSE
          EXIT;
      END;
      SalesOrderLine."Unit Cost (LCY)" := "Unit Cost (LCY)" * SalesOrderLine."Qty. per Unit of Measure" / "Qty. per Unit of Measure";
      SalesOrderLine."Unit Cost" := "Unit Cost" * SalesOrderLine."Qty. per Unit of Measure" / "Qty. per Unit of Measure";
      SalesOrderLine.VALIDATE("Unit Cost (LCY)");
      SalesOrderLine.MODIFY;
    END;

    LOCAL PROCEDURE GetFAPostingGroup@10();
    VAR
      LocalGLAcc@1000 : Record 15;
      FAPostingGr@1001 : Record 5606;
      FADeprBook@1003 : Record 5612;
      FASetup@1002 : Record 5603;
    BEGIN
      IF (Type <> Type::"Fixed Asset") OR ("No." = '') THEN
        EXIT;
      IF "Depreciation Book Code" = '' THEN BEGIN
        FASetup.GET;
        "Depreciation Book Code" := FASetup."Default Depr. Book";
        IF NOT FADeprBook.GET("No.","Depreciation Book Code") THEN
          "Depreciation Book Code" := '';
        IF "Depreciation Book Code" = '' THEN
          EXIT;
      END;
      IF "FA Posting Type" = "FA Posting Type"::" " THEN
        "FA Posting Type" := "FA Posting Type"::"Acquisition Cost";
      FADeprBook.GET("No.","Depreciation Book Code");
      FADeprBook.TESTFIELD("FA Posting Group");
      FAPostingGr.GET(FADeprBook."FA Posting Group");
      IF "FA Posting Type" = "FA Posting Type"::"Acquisition Cost" THEN
        LocalGLAcc.GET(FAPostingGr.GetAcquisitionCostAccount)
      ELSE
        LocalGLAcc.GET(FAPostingGr.GetMaintenanceExpenseAccount);
      LocalGLAcc.CheckGLAcc;
      LocalGLAcc.TESTFIELD("Gen. Prod. Posting Group");
      "Posting Group" := FADeprBook."FA Posting Group";
      "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
      "Tax Group Code" := LocalGLAcc."Tax Group Code";
      VALIDATE("VAT Prod. Posting Group",LocalGLAcc."VAT Prod. Posting Group");
    END;

    [Internal]
    PROCEDURE UpdateUOMQtyPerStockQty@9();
    BEGIN
      GetItem;
      "Unit Cost (LCY)" := Item."Unit Cost" * "Qty. per Unit of Measure";
      "Unit Price (LCY)" := Item."Unit Price" * "Qty. per Unit of Measure";
      GetPurchHeader;
      IF PurchHeader."Currency Code" <> '' THEN
        "Unit Cost" :=
          CurrExchRate.ExchangeAmtLCYToFCY(
            GetDate,PurchHeader."Currency Code",
            "Unit Cost (LCY)",PurchHeader."Currency Factor")
      ELSE
        "Unit Cost" := "Unit Cost (LCY)";
      UpdateDirectUnitCost(FIELDNO("Unit of Measure Code"));
    END;

    [External]
    PROCEDURE ShowReservation@8();
    VAR
      Reservation@1000 : Page 498;
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("Prod. Order No.",'');
      TESTFIELD("No.");
      CLEAR(Reservation);
      Reservation.SetPurchLine(Rec);
      Reservation.RUNMODAL;
    END;

    [External]
    PROCEDURE ShowReservationEntries@21(Modal@1000 : Boolean);
    VAR
      ReservEntry@1001 : Record 337;
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
      ReservePurchLine.FilterReservFor(ReservEntry,Rec);
      IF Modal THEN
        PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
      ELSE
        PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    END;

    [External]
    PROCEDURE GetDate@28() : Date;
    BEGIN
      IF PurchHeader."Posting Date" <> 0D THEN
        EXIT(PurchHeader."Posting Date");
      EXIT(WORKDATE);
    END;

    [External]
    PROCEDURE Signed@20(Value@1000 : Decimal) : Decimal;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Quote,
        "Document Type"::Order,
        "Document Type"::Invoice,
        "Document Type"::"Blanket Order":
          EXIT(Value);
        "Document Type"::"Return Order",
        "Document Type"::"Credit Memo":
          EXIT(-Value);
      END;
    END;

    [External]
    PROCEDURE BlanketOrderLookup@36();
    BEGIN
      PurchLine2.RESET;
      PurchLine2.SETCURRENTKEY("Document Type",Type,"No.");
      PurchLine2.SETRANGE("Document Type","Document Type"::"Blanket Order");
      PurchLine2.SETRANGE(Type,Type);
      PurchLine2.SETRANGE("No.","No.");
      PurchLine2.SETRANGE("Pay-to Vendor No.","Pay-to Vendor No.");
      PurchLine2.SETRANGE("Buy-from Vendor No.","Buy-from Vendor No.");
      IF PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine2) = ACTION::LookupOK THEN BEGIN
        PurchLine2.TESTFIELD("Document Type","Document Type"::"Blanket Order");
        "Blanket Order No." := PurchLine2."Document No.";
        VALIDATE("Blanket Order Line No.",PurchLine2."Line No.");
      END;
    END;

    [External]
    PROCEDURE BlockDynamicTracking@23(SetBlock@1000 : Boolean);
    BEGIN
      TrackingBlocked := SetBlock;
      ReservePurchLine.Block(SetBlock);
    END;

    [External]
    PROCEDURE ShowDimensions@25();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Document Type","Document No.","Line No."));
      VerifyItemLineDim;
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE OpenItemTrackingLines@6500();
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      IF "Prod. Order No." <> '' THEN
        ERROR(Text031,"Prod. Order No.");

      TESTFIELD("Quantity (Base)");

      ReservePurchLine.CallItemTracking(Rec);
    END;

    [External]
    PROCEDURE CreateDim@26(Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20];Type4@1006 : Integer;No4@1007 : Code[20]);
    VAR
      SourceCodeSetup@1008 : Record 242;
      TableID@1009 : ARRAY [10] OF Integer;
      No@1010 : ARRAY [10] OF Code[20];
    BEGIN
      SourceCodeSetup.GET;
      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      TableID[3] := Type3;
      No[3] := No3;
      TableID[4] := Type4;
      No[4] := No4;
      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      GetPurchHeader;
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup.Purchases,
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",PurchHeader."Dimension Set ID",DATABASE::Vendor);
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
      VerifyItemLineDim;
    END;

    [External]
    PROCEDURE LookupShortcutDimCode@30(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
    END;

    [External]
    PROCEDURE ShowShortcutDimCode@27(VAR ShortcutDimCode@1000 : ARRAY [8] OF Code[20]);
    BEGIN
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    END;

    LOCAL PROCEDURE GetSKU@5806() : Boolean;
    BEGIN
      TESTFIELD("No.");
      IF (SKU."Location Code" = "Location Code") AND
         (SKU."Item No." = "No.") AND
         (SKU."Variant Code" = "Variant Code")
      THEN
        EXIT(TRUE);
      IF SKU.GET("Location Code","No.","Variant Code") THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE ShowItemChargeAssgnt@5801();
    VAR
      ItemChargeAssgntPurch@1003 : Record 5805;
      AssignItemChargePurch@1001 : Codeunit 5805;
      ItemChargeAssgnts@1000 : Page 5805;
      ItemChargeAssgntLineAmt@1002 : Decimal;
    BEGIN
      GET("Document Type","Document No.","Line No.");
      TESTFIELD("No.");
      TESTFIELD(Quantity);

      IF Type <> Type::"Charge (Item)" THEN
        ERROR(ItemChargeAssignmentErr);

      GetPurchHeader;
      IF PurchHeader."Currency Code" = '' THEN
        Currency.InitRoundingPrecision
      ELSE
        Currency.GET(PurchHeader."Currency Code");
      IF ("Inv. Discount Amount" = 0) AND
         ("Line Discount Amount" = 0) AND
         (NOT PurchHeader."Prices Including VAT")
      THEN
        ItemChargeAssgntLineAmt := "Line Amount"
      ELSE
        IF PurchHeader."Prices Including VAT" THEN
          ItemChargeAssgntLineAmt :=
            ROUND(("Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
              Currency."Amount Rounding Precision")
        ELSE
          ItemChargeAssgntLineAmt := "Line Amount" - "Inv. Discount Amount";

      ItemChargeAssgntPurch.RESET;
      ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
      ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
      ItemChargeAssgntPurch.SETRANGE("Document Line No.","Line No.");
      ItemChargeAssgntPurch.SETRANGE("Item Charge No.","No.");
      IF NOT ItemChargeAssgntPurch.FINDLAST THEN BEGIN
        ItemChargeAssgntPurch."Document Type" := "Document Type";
        ItemChargeAssgntPurch."Document No." := "Document No.";
        ItemChargeAssgntPurch."Document Line No." := "Line No.";
        ItemChargeAssgntPurch."Item Charge No." := "No.";
        ItemChargeAssgntPurch."Unit Cost" :=
          ROUND(ItemChargeAssgntLineAmt / Quantity,
            Currency."Unit-Amount Rounding Precision");
      END;

      ItemChargeAssgntLineAmt :=
        ROUND(
          ItemChargeAssgntLineAmt * ("Qty. to Invoice" / Quantity),
          Currency."Amount Rounding Precision");

      IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
        AssignItemChargePurch.CreateDocChargeAssgnt(ItemChargeAssgntPurch,"Return Shipment No.")
      ELSE
        AssignItemChargePurch.CreateDocChargeAssgnt(ItemChargeAssgntPurch,"Receipt No.");
      CLEAR(AssignItemChargePurch);
      COMMIT;

      ItemChargeAssgnts.Initialize(Rec,ItemChargeAssgntLineAmt);
      ItemChargeAssgnts.RUNMODAL;

      CALCFIELDS("Qty. to Assign");
    END;

    [External]
    PROCEDURE UpdateItemChargeAssgnt@5807();
    VAR
      ItemChargeAssgntPurch@1003 : Record 5805;
      ShareOfVAT@1000 : Decimal;
      TotalQtyToAssign@1001 : Decimal;
      TotalAmtToAssign@1002 : Decimal;
    BEGIN
      IF "Document Type" = "Document Type"::"Blanket Order" THEN
        EXIT;

      CALCFIELDS("Qty. Assigned","Qty. to Assign");
      IF ABS("Quantity Invoiced") > ABS(("Qty. Assigned" + "Qty. to Assign")) THEN
        ERROR(Text032,FIELDCAPTION("Quantity Invoiced"),FIELDCAPTION("Qty. Assigned"),FIELDCAPTION("Qty. to Assign"));

      ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
      ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
      ItemChargeAssgntPurch.SETRANGE("Document Line No.","Line No.");
      ItemChargeAssgntPurch.CALCSUMS("Qty. to Assign");
      TotalQtyToAssign := ItemChargeAssgntPurch."Qty. to Assign";
      IF (CurrFieldNo <> 0) AND ("Unit Cost" <> xRec."Unit Cost") THEN BEGIN
        ItemChargeAssgntPurch.SETFILTER("Qty. Assigned",'<>0');
        IF NOT ItemChargeAssgntPurch.ISEMPTY THEN
          ERROR(Text022,
            FIELDCAPTION("Unit Cost"));
        ItemChargeAssgntPurch.SETRANGE("Qty. Assigned");
      END;

      IF (CurrFieldNo <> 0) AND (Quantity <> xRec.Quantity) THEN BEGIN
        ItemChargeAssgntPurch.SETFILTER("Qty. Assigned",'<>0');
        IF NOT ItemChargeAssgntPurch.ISEMPTY THEN
          ERROR(Text022,
            FIELDCAPTION(Quantity));
        ItemChargeAssgntPurch.SETRANGE("Qty. Assigned");
      END;

      IF ItemChargeAssgntPurch.FINDSET(TRUE) AND (Quantity <> 0) THEN BEGIN
        GetPurchHeader;
        TotalAmtToAssign := CalcTotalAmtToAssign(TotalQtyToAssign);
        REPEAT
          ShareOfVAT := 1;
          IF PurchHeader."Prices Including VAT" THEN
            ShareOfVAT := 1 + "VAT %" / 100;
          IF ItemChargeAssgntPurch."Unit Cost" <> ROUND(
               ("Line Amount" - "Inv. Discount Amount") / Quantity / ShareOfVAT,
               Currency."Unit-Amount Rounding Precision")
          THEN
            ItemChargeAssgntPurch."Unit Cost" :=
              ROUND(("Line Amount" - "Inv. Discount Amount") / Quantity / ShareOfVAT,
                Currency."Unit-Amount Rounding Precision");
          IF TotalQtyToAssign <> 0 THEN BEGIN
            ItemChargeAssgntPurch."Amount to Assign" :=
              ROUND(ItemChargeAssgntPurch."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                Currency."Amount Rounding Precision");
            TotalQtyToAssign -= ItemChargeAssgntPurch."Qty. to Assign";
            TotalAmtToAssign -= ItemChargeAssgntPurch."Amount to Assign";
          END;
          ItemChargeAssgntPurch.MODIFY;
        UNTIL ItemChargeAssgntPurch.NEXT = 0;
        CALCFIELDS("Qty. to Assign");
      END;
    END;

    LOCAL PROCEDURE DeleteItemChargeAssgnt@5802(DocType@1000 : Option;DocNo@1001 : Code[20];DocLineNo@1002 : Integer);
    VAR
      ItemChargeAssgntPurch@1003 : Record 5805;
    BEGIN
      ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type",DocType);
      ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.",DocNo);
      ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.",DocLineNo);
      IF NOT ItemChargeAssgntPurch.ISEMPTY THEN
        ItemChargeAssgntPurch.DELETEALL(TRUE);
    END;

    LOCAL PROCEDURE DeleteChargeChargeAssgnt@5804(DocType@1000 : Option;DocNo@1001 : Code[20];DocLineNo@1002 : Integer);
    VAR
      ItemChargeAssgntPurch@1003 : Record 5805;
    BEGIN
      IF DocType <> "Document Type"::"Blanket Order" THEN
        IF "Quantity Invoiced" <> 0 THEN BEGIN
          CALCFIELDS("Qty. Assigned");
          TESTFIELD("Qty. Assigned","Quantity Invoiced");
        END;

      ItemChargeAssgntPurch.RESET;
      ItemChargeAssgntPurch.SETRANGE("Document Type",DocType);
      ItemChargeAssgntPurch.SETRANGE("Document No.",DocNo);
      ItemChargeAssgntPurch.SETRANGE("Document Line No.",DocLineNo);
      IF NOT ItemChargeAssgntPurch.ISEMPTY THEN
        ItemChargeAssgntPurch.DELETEALL;
    END;

    [External]
    PROCEDURE CheckItemChargeAssgnt@5800();
    VAR
      ItemChargeAssgntPurch@1000 : Record 5805;
    BEGIN
      ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type","Document Type");
      ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.","Document No.");
      ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.","Line No.");
      ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
      ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
      IF ItemChargeAssgntPurch.FINDSET THEN BEGIN
        TESTFIELD("Allow Item Charge Assignment");
        REPEAT
          ItemChargeAssgntPurch.TESTFIELD("Qty. to Assign",0);
        UNTIL ItemChargeAssgntPurch.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE GetFieldCaption@31(FieldNumber@1000 : Integer) : Text[100];
    VAR
      Field@1001 : Record 2000000041;
    BEGIN
      Field.GET(DATABASE::"Purchase Line",FieldNumber);
      EXIT(Field."Field Caption");
    END;

    LOCAL PROCEDURE GetCaptionClass@34(FieldNumber@1000 : Integer) : Text[80];
    BEGIN
      IF NOT PurchHeader.GET("Document Type","Document No.") THEN BEGIN
        PurchHeader."No." := '';
        PurchHeader.INIT;
      END;
      CASE FieldNumber OF
        FIELDNO("No."):
          EXIT(STRSUBSTNO('3,%1',GetFieldCaption(FieldNumber)));
        ELSE BEGIN
          IF PurchHeader."Prices Including VAT" THEN
            EXIT('2,1,' + GetFieldCaption(FieldNumber));
          EXIT('2,0,' + GetFieldCaption(FieldNumber));
        END
      END;
    END;

    LOCAL PROCEDURE TestStatusOpen@37();
    BEGIN
      IF StatusCheckSuspended THEN
        EXIT;
      GetPurchHeader;
      IF NOT "System-Created Entry" THEN
        IF HasTypeToFillMandatoryFields THEN
          PurchHeader.TESTFIELD(Status,PurchHeader.Status::Open);
    END;

    [External]
    PROCEDURE SuspendStatusCheck@42(Suspend@1000 : Boolean);
    BEGIN
      StatusCheckSuspended := Suspend;
    END;

    [External]
    PROCEDURE UpdateLeadTimeFields@11();
    BEGIN
      IF Type = Type::Item THEN BEGIN
        GetPurchHeader;

        EVALUATE("Lead Time Calculation",
          LeadTimeMgt.PurchaseLeadTime(
            "No.","Location Code","Variant Code",
            "Buy-from Vendor No."));
        IF FORMAT("Lead Time Calculation") = '' THEN
          "Lead Time Calculation" := PurchHeader."Lead Time Calculation";
        EVALUATE("Safety Lead Time",LeadTimeMgt.SafetyLeadTime("No.","Location Code","Variant Code"));
      END;
    END;

    [External]
    PROCEDURE GetUpdateBasicDates@43();
    BEGIN
      GetPurchHeader;
      IF PurchHeader."Expected Receipt Date" <> 0D THEN
        VALIDATE("Expected Receipt Date",PurchHeader."Expected Receipt Date")
      ELSE
        VALIDATE("Order Date",PurchHeader."Order Date");
    END;

    [External]
    PROCEDURE UpdateDates@39();
    BEGIN
      IF "Promised Receipt Date" <> 0D THEN
        VALIDATE("Promised Receipt Date")
      ELSE
        IF "Requested Receipt Date" <> 0D THEN
          VALIDATE("Requested Receipt Date")
        ELSE
          GetUpdateBasicDates;
    END;

    [External]
    PROCEDURE InternalLeadTimeDays@35(PurchDate@1002 : Date) : Text[30];
    VAR
      TotalDays@1001 : DateFormula;
    BEGIN
      EVALUATE(
        TotalDays,'<' + FORMAT(CALCDATE("Safety Lead Time",CALCDATE("Inbound Whse. Handling Time",PurchDate)) - PurchDate) + 'D>');
      EXIT(FORMAT(TotalDays));
    END;

    [Internal]
    PROCEDURE UpdateVATOnLines@32(QtyType@1000 : 'General,Invoicing,Shipping';VAR PurchHeader@1001 : Record 38;VAR PurchLine@1002 : Record 39;VAR VATAmountLine@1003 : Record 290) LineWasModified : Boolean;
    VAR
      TempVATAmountLineRemainder@1004 : TEMPORARY Record 290;
      Currency@1005 : Record 4;
      NewAmount@1006 : Decimal;
      NewAmountIncludingVAT@1007 : Decimal;
      NewVATBaseAmount@1008 : Decimal;
      VATAmount@1009 : Decimal;
      VATDifference@1010 : Decimal;
      InvDiscAmount@1011 : Decimal;
      LineAmountToInvoice@1012 : Decimal;
      LineAmountToInvoiceDiscounted@1013 : Decimal;
      DeferralAmount@1014 : Decimal;
    BEGIN
      LineWasModified := FALSE;
      IF QtyType = QtyType::Shipping THEN
        EXIT;
      IF PurchHeader."Currency Code" = '' THEN
        Currency.InitRoundingPrecision
      ELSE
        Currency.GET(PurchHeader."Currency Code");

      TempVATAmountLineRemainder.DELETEALL;

      WITH PurchLine DO BEGIN
        SETRANGE("Document Type",PurchHeader."Document Type");
        SETRANGE("Document No.",PurchHeader."No.");
        LOCKTABLE;
        IF FINDSET THEN
          REPEAT
            IF NOT ZeroAmountLine(QtyType) THEN BEGIN
              DeferralAmount := GetDeferralAmount;
              VATAmountLine.GET("VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax","Line Amount" >= 0);
              IF VATAmountLine.Modified THEN BEGIN
                IF NOT TempVATAmountLineRemainder.GET(
                     "VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax","Line Amount" >= 0)
                THEN BEGIN
                  TempVATAmountLineRemainder := VATAmountLine;
                  TempVATAmountLineRemainder.INIT;
                  TempVATAmountLineRemainder.INSERT;
                END;

                IF QtyType = QtyType::General THEN
                  LineAmountToInvoice := "Line Amount"
                ELSE
                  LineAmountToInvoice :=
                    ROUND("Line Amount" * "Qty. to Invoice" / Quantity,Currency."Amount Rounding Precision");

                IF "Allow Invoice Disc." THEN BEGIN
                  IF (VATAmountLine."Inv. Disc. Base Amount" = 0) OR (LineAmountToInvoice = 0) THEN
                    InvDiscAmount := 0
                  ELSE BEGIN
                    IF QtyType = QtyType::General THEN
                      LineAmountToInvoice := "Line Amount"
                    ELSE
                      LineAmountToInvoice :=
                        ROUND("Line Amount" * "Qty. to Invoice" / Quantity,Currency."Amount Rounding Precision");
                    LineAmountToInvoiceDiscounted :=
                      VATAmountLine."Invoice Discount Amount" * LineAmountToInvoice /
                      VATAmountLine."Inv. Disc. Base Amount";
                    TempVATAmountLineRemainder."Invoice Discount Amount" :=
                      TempVATAmountLineRemainder."Invoice Discount Amount" + LineAmountToInvoiceDiscounted;
                    InvDiscAmount :=
                      ROUND(
                        TempVATAmountLineRemainder."Invoice Discount Amount",Currency."Amount Rounding Precision");
                    TempVATAmountLineRemainder."Invoice Discount Amount" :=
                      TempVATAmountLineRemainder."Invoice Discount Amount" - InvDiscAmount;
                  END;
                  IF QtyType = QtyType::General THEN BEGIN
                    "Inv. Discount Amount" := InvDiscAmount;
                    CalcInvDiscToInvoice;
                  END ELSE
                    "Inv. Disc. Amount to Invoice" := InvDiscAmount;
                END ELSE
                  InvDiscAmount := 0;
                IF QtyType = QtyType::General THEN
                  IF PurchHeader."Prices Including VAT" THEN BEGIN
                    IF (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" = 0) OR
                       ("Line Amount" = 0)
                    THEN BEGIN
                      VATAmount := 0;
                      NewAmountIncludingVAT := 0;
                    END ELSE BEGIN
                      VATAmount :=
                        TempVATAmountLineRemainder."VAT Amount" +
                        VATAmountLine."VAT Amount" *
                        ("Line Amount" - "Inv. Discount Amount") /
                        (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                      NewAmountIncludingVAT :=
                        TempVATAmountLineRemainder."Amount Including VAT" +
                        VATAmountLine."Amount Including VAT" *
                        ("Line Amount" - "Inv. Discount Amount") /
                        (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                    END;
                    NewAmount :=
                      ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision") -
                      ROUND(VATAmount,Currency."Amount Rounding Precision");
                    NewVATBaseAmount :=
                      ROUND(
                        NewAmount * (1 - PurchHeader."VAT Base Discount %" / 100),
                        Currency."Amount Rounding Precision");
                  END ELSE BEGIN
                    IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN BEGIN
                      VATAmount := "Line Amount" - "Inv. Discount Amount";
                      NewAmount := 0;
                      NewVATBaseAmount := 0;
                    END ELSE BEGIN
                      NewAmount := "Line Amount" - "Inv. Discount Amount";
                      NewVATBaseAmount :=
                        ROUND(
                          NewAmount * (1 - PurchHeader."VAT Base Discount %" / 100),
                          Currency."Amount Rounding Precision");
                      IF VATAmountLine."VAT Base" = 0 THEN
                        VATAmount := 0
                      ELSE
                        VATAmount :=
                          TempVATAmountLineRemainder."VAT Amount" +
                          VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";
                    END;
                    NewAmountIncludingVAT := NewAmount + ROUND(VATAmount,Currency."Amount Rounding Precision");
                  END
                ELSE BEGIN
                  IF (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") = 0 THEN
                    VATDifference := 0
                  ELSE
                    VATDifference :=
                      TempVATAmountLineRemainder."VAT Difference" +
                      VATAmountLine."VAT Difference" * (LineAmountToInvoice - InvDiscAmount) /
                      (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                  IF LineAmountToInvoice = 0 THEN
                    "VAT Difference" := 0
                  ELSE
                    "VAT Difference" := ROUND(VATDifference,Currency."Amount Rounding Precision");
                END;

                IF QtyType = QtyType::General THEN BEGIN
                  Amount := NewAmount;
                  "Amount Including VAT" := ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
                  "VAT Base Amount" := NewVATBaseAmount;
                END;
                InitOutstanding;
                IF NOT ((Type = Type::"Charge (Item)") AND ("Quantity Invoiced" <> "Qty. Assigned")) THEN BEGIN
                  SetUpdateFromVAT(TRUE);
                  UpdateUnitCost;
                END;
                IF Type = Type::"Charge (Item)" THEN
                  UpdateItemChargeAssgnt;
                MODIFY;
                LineWasModified := TRUE;

                IF ("Deferral Code" <> '') AND (DeferralAmount <> GetDeferralAmount) THEN
                  UpdateDeferralAmounts;

                TempVATAmountLineRemainder."Amount Including VAT" :=
                  NewAmountIncludingVAT - ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
                TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                TempVATAmountLineRemainder."VAT Difference" := VATDifference - "VAT Difference";
                TempVATAmountLineRemainder.MODIFY;
              END;
            END;
          UNTIL NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE CalcVATAmountLines@24(QtyType@1000 : 'General,Invoicing,Shipping';VAR PurchHeader@1001 : Record 38;VAR PurchLine@1002 : Record 39;VAR VATAmountLine@1003 : Record 290);
    VAR
      TotalVATAmount@1008 : Decimal;
      QtyToHandle@1006 : Decimal;
      AmtToHandle@1005 : Decimal;
      RoundingLineInserted@1010 : Boolean;
    BEGIN
      Currency.Initialize(PurchHeader."Currency Code");

      VATAmountLine.DELETEALL;

      WITH PurchLine DO BEGIN
        SETRANGE("Document Type",PurchHeader."Document Type");
        SETRANGE("Document No.",PurchHeader."No.");
        IF FINDSET THEN
          REPEAT
            IF NOT ZeroAmountLine(QtyType) THEN BEGIN
              IF (Type = Type::"G/L Account") AND NOT "Prepayment Line" THEN
                RoundingLineInserted := ("No." = GetVPGInvRoundAcc(PurchHeader)) OR RoundingLineInserted;
              IF "VAT Calculation Type" IN
                 ["VAT Calculation Type"::"Reverse Charge VAT","VAT Calculation Type"::"Sales Tax"]
              THEN
                "VAT %" := 0;
              IF NOT VATAmountLine.GET(
                   "VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax","Line Amount" >= 0)
              THEN
                VATAmountLine.InsertNewLine(
                  "VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax","VAT %","Line Amount" >= 0,FALSE);

              CASE QtyType OF
                QtyType::General:
                  BEGIN
                    VATAmountLine.Quantity += "Quantity (Base)";
                    VATAmountLine.SumLine(
                      "Line Amount","Inv. Discount Amount","VAT Difference","Allow Invoice Disc.","Prepayment Line");
                  END;
                QtyType::Invoicing:
                  BEGIN
                    CASE TRUE OF
                      ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) AND
                      (NOT PurchHeader.Receive) AND PurchHeader.Invoice AND (NOT "Prepayment Line"):
                        IF "Receipt No." = '' THEN BEGIN
                          QtyToHandle := GetAbsMin("Qty. to Invoice","Qty. Rcd. Not Invoiced");
                          VATAmountLine.Quantity += GetAbsMin("Qty. to Invoice (Base)","Qty. Rcd. Not Invoiced (Base)");
                        END ELSE BEGIN
                          QtyToHandle := "Qty. to Invoice";
                          VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                        END;
                      ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
                      (NOT PurchHeader.Ship) AND PurchHeader.Invoice:
                        IF "Return Shipment No." = '' THEN BEGIN
                          QtyToHandle := GetAbsMin("Qty. to Invoice","Return Qty. Shipped Not Invd.");
                          VATAmountLine.Quantity += GetAbsMin("Qty. to Invoice (Base)","Ret. Qty. Shpd Not Invd.(Base)");
                        END ELSE BEGIN
                          QtyToHandle := "Qty. to Invoice";
                          VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                        END;
                      ELSE BEGIN
                        QtyToHandle := "Qty. to Invoice";
                        VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                      END;
                    END;
                    AmtToHandle := GetLineAmountToHandle(QtyToHandle);
                    IF PurchHeader."Invoice Discount Calculation" <> PurchHeader."Invoice Discount Calculation"::Amount THEN
                      VATAmountLine.SumLine(
                        AmtToHandle,ROUND("Inv. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                        "VAT Difference","Allow Invoice Disc.","Prepayment Line")
                    ELSE
                      VATAmountLine.SumLine(
                        AmtToHandle,"Inv. Disc. Amount to Invoice","VAT Difference","Allow Invoice Disc.","Prepayment Line");
                  END;
                QtyType::Shipping:
                  BEGIN
                    IF "Document Type" IN
                       ["Document Type"::"Return Order","Document Type"::"Credit Memo"]
                    THEN BEGIN
                      QtyToHandle := "Return Qty. to Ship";
                      VATAmountLine.Quantity += "Return Qty. to Ship (Base)";
                    END ELSE BEGIN
                      QtyToHandle := "Qty. to Receive";
                      VATAmountLine.Quantity += "Qty. to Receive (Base)";
                    END;
                    AmtToHandle := GetLineAmountToHandle(QtyToHandle);
                    VATAmountLine.SumLine(
                      AmtToHandle,ROUND("Inv. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                      "VAT Difference","Allow Invoice Disc.","Prepayment Line");
                  END;
              END;
              TotalVATAmount += "Amount Including VAT" - Amount;
            END;
          UNTIL NEXT = 0;
      END;

      VATAmountLine.UpdateLines(
        TotalVATAmount,Currency,PurchHeader."Currency Factor",PurchHeader."Prices Including VAT",
        PurchHeader."VAT Base Discount %",PurchHeader."Tax Area Code",PurchHeader."Tax Liable",PurchHeader."Posting Date");

      IF RoundingLineInserted AND (TotalVATAmount <> 0) THEN
        IF VATAmountLine.GET(PurchLine."VAT Identifier",PurchLine."VAT Calculation Type",
             PurchLine."Tax Group Code",PurchLine."Use Tax",PurchLine."Line Amount" >= 0)
        THEN BEGIN
          VATAmountLine."VAT Amount" += TotalVATAmount;
          VATAmountLine."Amount Including VAT" += TotalVATAmount;
          VATAmountLine."Calculated VAT Amount" += TotalVATAmount;
          VATAmountLine.MODIFY;
        END;
    END;

    [External]
    PROCEDURE UpdateWithWarehouseReceive@41();
    BEGIN
      IF Type = Type::Item THEN
        CASE TRUE OF
          ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND (Quantity >= 0):
            IF Location.RequireReceive("Location Code") THEN
              VALIDATE("Qty. to Receive",0)
            ELSE
              VALIDATE("Qty. to Receive","Outstanding Quantity");
          ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND (Quantity < 0):
            IF Location.RequireShipment("Location Code") THEN
              VALIDATE("Qty. to Receive",0)
            ELSE
              VALIDATE("Qty. to Receive","Outstanding Quantity");
          ("Document Type" = "Document Type"::"Return Order") AND (Quantity >= 0):
            IF Location.RequireShipment("Location Code") THEN
              VALIDATE("Return Qty. to Ship",0)
            ELSE
              VALIDATE("Return Qty. to Ship","Outstanding Quantity");
          ("Document Type" = "Document Type"::"Return Order") AND (Quantity < 0):
            IF Location.RequireReceive("Location Code") THEN
              VALIDATE("Return Qty. to Ship",0)
            ELSE
              VALIDATE("Return Qty. to Ship","Outstanding Quantity");
        END;
      SetDefaultQuantity;
    END;

    LOCAL PROCEDURE CheckWarehouse@47();
    VAR
      Location2@1002 : Record 14;
      WhseSetup@1000 : Record 5769;
      ShowDialog@1001 : ' ,Message,Error';
      DialogText@1003 : Text[50];
    BEGIN
      IF "Prod. Order No." <> '' THEN
        EXIT;
      GetLocation("Location Code");
      IF "Location Code" = '' THEN BEGIN
        WhseSetup.GET;
        Location2."Require Shipment" := WhseSetup."Require Shipment";
        Location2."Require Pick" := WhseSetup."Require Pick";
        Location2."Require Receive" := WhseSetup."Require Receive";
        Location2."Require Put-away" := WhseSetup."Require Put-away";
      END ELSE
        Location2 := Location;

      DialogText := Text033;
      IF ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"]) AND
         Location2."Directed Put-away and Pick"
      THEN BEGIN
        ShowDialog := ShowDialog::Error;
        IF (("Document Type" = "Document Type"::Order) AND (Quantity >= 0)) OR
           (("Document Type" = "Document Type"::"Return Order") AND (Quantity < 0))
        THEN
          DialogText :=
            DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Receive"))
        ELSE
          DialogText :=
            DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Shipment"));
      END ELSE BEGIN
        IF (("Document Type" = "Document Type"::Order) AND (Quantity >= 0) AND
            (Location2."Require Receive" OR Location2."Require Put-away")) OR
           (("Document Type" = "Document Type"::"Return Order") AND (Quantity < 0) AND
            (Location2."Require Receive" OR Location2."Require Put-away"))
        THEN BEGIN
          IF WhseValidateSourceLine.WhseLinesExist(
               DATABASE::"Purchase Line",
               "Document Type",
               "Document No.",
               "Line No.",
               0,
               Quantity)
          THEN
            ShowDialog := ShowDialog::Error
          ELSE
            IF Location2."Require Receive" THEN
              ShowDialog := ShowDialog::Message;
          IF Location2."Require Receive" THEN
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Receive"))
          ELSE BEGIN
            DialogText := Text034;
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Put-away"));
          END;
        END;

        IF (("Document Type" = "Document Type"::Order) AND (Quantity < 0) AND
            (Location2."Require Shipment" OR Location2."Require Pick")) OR
           (("Document Type" = "Document Type"::"Return Order") AND (Quantity >= 0) AND
            (Location2."Require Shipment" OR Location2."Require Pick"))
        THEN BEGIN
          IF WhseValidateSourceLine.WhseLinesExist(
               DATABASE::"Purchase Line",
               "Document Type",
               "Document No.",
               "Line No.",
               0,
               Quantity)
          THEN
            ShowDialog := ShowDialog::Error
          ELSE
            IF Location2."Require Shipment" THEN
              ShowDialog := ShowDialog::Message;
          IF Location2."Require Shipment" THEN
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Shipment"))
          ELSE BEGIN
            DialogText := Text034;
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Pick"));
          END;
        END;
      END;

      CASE ShowDialog OF
        ShowDialog::Message:
          MESSAGE(Text016 + Text017,DialogText,FIELDCAPTION("Line No."),"Line No.");
        ShowDialog::Error:
          ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.")
      END;

      HandleDedicatedBin(TRUE);
    END;

    LOCAL PROCEDURE GetOverheadRateFCY@40() : Decimal;
    VAR
      QtyPerUOM@1000 : Decimal;
    BEGIN
      IF "Prod. Order No." = '' THEN
        QtyPerUOM := "Qty. per Unit of Measure"
      ELSE BEGIN
        GetItem;
        QtyPerUOM := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
      END;

      EXIT(
        CurrExchRate.ExchangeAmtLCYToFCY(
          GetDate,"Currency Code","Overhead Rate" * QtyPerUOM,PurchHeader."Currency Factor"));
    END;

    [External]
    PROCEDURE GetItemTranslation@44();
    VAR
      ItemTranslation@1000 : Record 30;
    BEGIN
      GetPurchHeader;
      IF ItemTranslation.GET("No.","Variant Code",PurchHeader."Language Code") THEN BEGIN
        Description := ItemTranslation.Description;
        "Description 2" := ItemTranslation."Description 2";
      END;
    END;

    LOCAL PROCEDURE GetGLSetup@45();
    BEGIN
      IF NOT GLSetupRead THEN
        GLSetup.GET;
      GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE GetPurchSetup@80();
    BEGIN
      IF NOT PurchSetupRead THEN
        PurchSetup.GET;
      PurchSetupRead := TRUE;
    END;

    [External]
    PROCEDURE AdjustDateFormula@48(DateFormulatoAdjust@1000 : DateFormula) : Text[30];
    BEGIN
      IF FORMAT(DateFormulatoAdjust) <> '' THEN
        EXIT(FORMAT(DateFormulatoAdjust));
      EVALUATE(DateFormulatoAdjust,'<0D>');
      EXIT(FORMAT(DateFormulatoAdjust));
    END;

    LOCAL PROCEDURE GetLocation@7300(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        CLEAR(Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    [External]
    PROCEDURE RowID1@49() : Text[250];
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;
    BEGIN
      EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Purchase Line","Document Type",
          "Document No.",'',0,"Line No."));
    END;

    LOCAL PROCEDURE GetDefaultBin@50();
    VAR
      WMSManagement@1000 : Codeunit 7302;
    BEGIN
      IF Type <> Type::Item THEN
        EXIT;

      "Bin Code" := '';
      IF "Drop Shipment" THEN
        EXIT;

      IF ("Location Code" <> '') AND ("No." <> '') THEN BEGIN
        GetLocation("Location Code");
        IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN BEGIN
          WMSManagement.GetDefaultBin("No.","Variant Code","Location Code","Bin Code");
          HandleDedicatedBin(FALSE);
        END;
      END;
    END;

    [External]
    PROCEDURE IsInbound@75() : Boolean;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote,"Document Type"::"Blanket Order":
          EXIT("Quantity (Base)" > 0);
        "Document Type"::"Return Order","Document Type"::"Credit Memo":
          EXIT("Quantity (Base)" < 0);
      END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE HandleDedicatedBin@71(IssueWarning@1000 : Boolean);
    VAR
      WhseIntegrationMgt@1001 : Codeunit 7317;
    BEGIN
      IF NOT IsInbound AND ("Quantity (Base)" <> 0) THEN
        WhseIntegrationMgt.CheckIfBinDedicatedOnSrcDoc("Location Code","Bin Code",IssueWarning);
    END;

    [Internal]
    PROCEDURE CrossReferenceNoLookUp@51();
    VAR
      ItemCrossReference@1000 : Record 5717;
    BEGIN
      IF Type = Type::Item THEN BEGIN
        GetPurchHeader;
        ItemCrossReference.RESET;
        ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
        ItemCrossReference.SETFILTER(
          "Cross-Reference Type",'%1|%2',
          ItemCrossReference."Cross-Reference Type"::Vendor,
          ItemCrossReference."Cross-Reference Type"::" ");
        ItemCrossReference.SETFILTER("Cross-Reference Type No.",'%1|%2',PurchHeader."Buy-from Vendor No.",'');
        IF PAGE.RUNMODAL(PAGE::"Cross Reference List",ItemCrossReference) = ACTION::LookupOK THEN BEGIN
          VALIDATE("Cross-Reference No.",ItemCrossReference."Cross-Reference No.");
          PurchPriceCalcMgt.FindPurchLinePrice(PurchHeader,Rec,FIELDNO("Cross-Reference No."));
          PurchPriceCalcMgt.FindPurchLineLineDisc(PurchHeader,Rec);
          VALIDATE("Direct Unit Cost");
        END;
      END;
    END;

    [External]
    PROCEDURE ItemExists@52(ItemNo@1000 : Code[20]) : Boolean;
    VAR
      Item2@1001 : Record 27;
    BEGIN
      IF Type = Type::Item THEN
        IF NOT Item2.GET(ItemNo) THEN
          EXIT(FALSE);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetAbsMin@56(QtyToHandle@1000 : Decimal;QtyHandled@1001 : Decimal) : Decimal;
    BEGIN
      IF ABS(QtyHandled) < ABS(QtyToHandle) THEN
        EXIT(QtyHandled);

      EXIT(QtyToHandle);
    END;

    LOCAL PROCEDURE CheckApplToItemLedgEntry@53() : Code[10];
    VAR
      ItemLedgEntry@1000 : Record 32;
      ApplyRec@1005 : Record 339;
      ItemTrackingLines@1006 : Page 6510;
      ReturnedQty@1003 : Decimal;
      RemainingtobeReturnedQty@1004 : Decimal;
    BEGIN
      IF "Appl.-to Item Entry" = 0 THEN
        EXIT;

      IF "Receipt No." <> '' THEN
        EXIT;

      TESTFIELD(Type,Type::Item);
      TESTFIELD(Quantity);
      IF Signed(Quantity) > 0 THEN
        TESTFIELD("Prod. Order No.",'');
      IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
        IF Quantity < 0 THEN
          FIELDERROR(Quantity,Text029);
      END ELSE BEGIN
        IF Quantity > 0 THEN
          FIELDERROR(Quantity,Text030);
      END;
      ItemLedgEntry.GET("Appl.-to Item Entry");
      ItemLedgEntry.TESTFIELD(Positive,TRUE);
      IF ItemLedgEntry.TrackingExists THEN
        ERROR(Text040,ItemTrackingLines.CAPTION,FIELDCAPTION("Appl.-to Item Entry"));

      ItemLedgEntry.TESTFIELD("Item No.","No.");
      ItemLedgEntry.TESTFIELD("Variant Code","Variant Code");

      // Track qty in both alternative and base UOM for better error checking and reporting
      IF ABS("Quantity (Base)") > ItemLedgEntry.Quantity THEN
        ERROR(
          Text042,
          ItemLedgEntry.Quantity,ItemLedgEntry.FIELDCAPTION("Document No."),
          ItemLedgEntry."Document No.");

      IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
        IF ABS("Outstanding Qty. (Base)") > ItemLedgEntry."Remaining Quantity" THEN BEGIN
          ReturnedQty := ApplyRec.Returned(ItemLedgEntry."Entry No.");
          RemainingtobeReturnedQty := ItemLedgEntry.Quantity - ReturnedQty;
          IF NOT ("Qty. per Unit of Measure" = 0) THEN BEGIN
            ReturnedQty := ROUND(ReturnedQty / "Qty. per Unit of Measure",0.00001);
            RemainingtobeReturnedQty := ROUND(RemainingtobeReturnedQty / "Qty. per Unit of Measure",0.00001);
          END;

          IF ((("Qty. per Unit of Measure" = 0) AND (RemainingtobeReturnedQty < ABS("Outstanding Qty. (Base)"))) OR
              (("Qty. per Unit of Measure" <> 0) AND (RemainingtobeReturnedQty < ABS("Outstanding Quantity"))))
          THEN
            ERROR(
              Text035,
              ReturnedQty,ItemLedgEntry.FIELDCAPTION("Document No."),
              ItemLedgEntry."Document No.",RemainingtobeReturnedQty);
        END;

      EXIT(ItemLedgEntry."Location Code");
    END;

    [External]
    PROCEDURE CalcPrepaymentToDeduct@59();
    BEGIN
      IF ("Qty. to Invoice" <> 0) AND ("Prepmt. Amt. Inv." <> 0) THEN BEGIN
        GetPurchHeader;
        IF ("Prepayment %" = 100) AND NOT IsFinalInvoice THEN
          "Prepmt Amt to Deduct" := GetLineAmountToHandle("Qty. to Invoice")
        ELSE
          "Prepmt Amt to Deduct" :=
            ROUND(
              ("Prepmt. Amt. Inv." - "Prepmt Amt Deducted") *
              "Qty. to Invoice" / (Quantity - "Quantity Invoiced"),Currency."Amount Rounding Precision")
      END ELSE
        "Prepmt Amt to Deduct" := 0
    END;

    [External]
    PROCEDURE IsFinalInvoice@116() : Boolean;
    BEGIN
      EXIT("Qty. to Invoice" = Quantity - "Quantity Invoiced");
    END;

    [External]
    PROCEDURE GetLineAmountToHandle@117(QtyToHandle@1002 : Decimal) : Decimal;
    VAR
      LineAmount@1001 : Decimal;
      LineDiscAmount@1000 : Decimal;
    BEGIN
      IF "Line Discount %" = 100 THEN
        EXIT(0);

      GetPurchHeader;
      LineAmount := ROUND(QtyToHandle * "Direct Unit Cost",Currency."Amount Rounding Precision");
      LineDiscAmount :=
        ROUND(
          LineAmount * "Line Discount %" / 100,Currency."Amount Rounding Precision");
      EXIT(LineAmount - LineDiscAmount);
    END;

    [External]
    PROCEDURE JobTaskIsSet@61() : Boolean;
    VAR
      JobTaskSet@1000 : Boolean;
    BEGIN
      JobTaskSet := FALSE;
      OnBeforeJobTaskIsSet(Rec,JobTaskSet);

      EXIT(
        (("Job No." <> '') AND ("Job Task No." <> '') AND (Type IN [Type::"G/L Account",Type::Item])) OR
        JobTaskSet);
    END;

    [External]
    PROCEDURE CreateTempJobJnlLine@55(GetPrices@1001 : Boolean);
    BEGIN
      GetPurchHeader;
      CLEAR(TempJobJnlLine);
      TempJobJnlLine.DontCheckStdCost;
      TempJobJnlLine.VALIDATE("Job No.","Job No.");
      TempJobJnlLine.VALIDATE("Job Task No.","Job Task No.");
      TempJobJnlLine.VALIDATE("Posting Date",PurchHeader."Posting Date");
      TempJobJnlLine.SetCurrencyFactor("Job Currency Factor");
      IF Type = Type::"G/L Account" THEN
        TempJobJnlLine.VALIDATE(Type,TempJobJnlLine.Type::"G/L Account")
      ELSE
        TempJobJnlLine.VALIDATE(Type,TempJobJnlLine.Type::Item);
      TempJobJnlLine.VALIDATE("No.","No.");
      TempJobJnlLine.VALIDATE(Quantity,Quantity);
      TempJobJnlLine.VALIDATE("Variant Code","Variant Code");
      TempJobJnlLine.VALIDATE("Unit of Measure Code","Unit of Measure Code");

      IF NOT GetPrices THEN BEGIN
        IF xRec."Line No." <> 0 THEN BEGIN
          TempJobJnlLine."Unit Cost" := xRec."Unit Cost";
          TempJobJnlLine."Unit Cost (LCY)" := xRec."Unit Cost (LCY)";
          TempJobJnlLine."Unit Price" := xRec."Job Unit Price";
          TempJobJnlLine."Line Amount" := xRec."Job Line Amount";
          TempJobJnlLine."Line Discount %" := xRec."Job Line Discount %";
          TempJobJnlLine."Line Discount Amount" := xRec."Job Line Discount Amount";
        END ELSE BEGIN
          TempJobJnlLine."Unit Cost" := "Unit Cost";
          TempJobJnlLine."Unit Cost (LCY)" := "Unit Cost (LCY)";
          TempJobJnlLine."Unit Price" := "Job Unit Price";
          TempJobJnlLine."Line Amount" := "Job Line Amount";
          TempJobJnlLine."Line Discount %" := "Job Line Discount %";
          TempJobJnlLine."Line Discount Amount" := "Job Line Discount Amount";
        END;
        TempJobJnlLine.VALIDATE("Unit Price");
      END ELSE
        TempJobJnlLine.VALIDATE("Unit Cost (LCY)","Unit Cost (LCY)");

      OnAfterCreateTempJobJnlLine(TempJobJnlLine,Rec,xRec,GetPrices,CurrFieldNo);
    END;

    [External]
    PROCEDURE UpdateJobPrices@69();
    VAR
      PurchRcptLine@1000 : Record 121;
    BEGIN
      IF "Receipt No." = '' THEN BEGIN
        "Job Unit Price" := TempJobJnlLine."Unit Price";
        "Job Total Price" := TempJobJnlLine."Total Price";
        "Job Unit Price (LCY)" := TempJobJnlLine."Unit Price (LCY)";
        "Job Total Price (LCY)" := TempJobJnlLine."Total Price (LCY)";
        "Job Line Amount (LCY)" := TempJobJnlLine."Line Amount (LCY)";
        "Job Line Disc. Amount (LCY)" := TempJobJnlLine."Line Discount Amount (LCY)";
        "Job Line Amount" := TempJobJnlLine."Line Amount";
        "Job Line Discount %" := TempJobJnlLine."Line Discount %";
        "Job Line Discount Amount" := TempJobJnlLine."Line Discount Amount";
      END ELSE BEGIN
        PurchRcptLine.GET("Receipt No.","Receipt Line No.");
        "Job Unit Price" := PurchRcptLine."Job Unit Price";
        "Job Total Price" := PurchRcptLine."Job Total Price";
        "Job Unit Price (LCY)" := PurchRcptLine."Job Unit Price (LCY)";
        "Job Total Price (LCY)" := PurchRcptLine."Job Total Price (LCY)";
        "Job Line Amount (LCY)" := PurchRcptLine."Job Line Amount (LCY)";
        "Job Line Disc. Amount (LCY)" := PurchRcptLine."Job Line Disc. Amount (LCY)";
        "Job Line Amount" := PurchRcptLine."Job Line Amount";
        "Job Line Discount %" := PurchRcptLine."Job Line Discount %";
        "Job Line Discount Amount" := PurchRcptLine."Job Line Discount Amount";
      END;

      OnAfterUpdateJobPrices(Rec,TempJobJnlLine,PurchRcptLine);
    END;

    [External]
    PROCEDURE JobSetCurrencyFactor@54();
    BEGIN
      GetPurchHeader;
      CLEAR(TempJobJnlLine);
      TempJobJnlLine.VALIDATE("Job No.","Job No.");
      TempJobJnlLine.VALIDATE("Job Task No.","Job Task No.");
      TempJobJnlLine.VALIDATE("Posting Date",PurchHeader."Posting Date");
      "Job Currency Factor" := TempJobJnlLine."Currency Factor";
    END;

    [External]
    PROCEDURE SetUpdateFromVAT@58(UpdateFromVAT2@1000 : Boolean);
    BEGIN
      UpdateFromVAT := UpdateFromVAT2;
    END;

    [External]
    PROCEDURE InitQtyToReceive2@57();
    BEGIN
      "Qty. to Receive" := "Outstanding Quantity";
      "Qty. to Receive (Base)" := "Outstanding Qty. (Base)";

      "Qty. to Invoice" := MaxQtyToInvoice;
      "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
      "VAT Difference" := 0;

      CalcInvDiscToInvoice;

      CalcPrepaymentToDeduct;

      IF "Job Planning Line No." <> 0 THEN
        VALIDATE("Job Planning Line No.");
    END;

    [External]
    PROCEDURE ClearQtyIfBlank@88();
    BEGIN
      IF "Document Type" = "Document Type"::Order THEN BEGIN
        GetPurchSetup;
        IF PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Blank THEN BEGIN
          "Qty. to Receive" := 0;
          "Qty. to Receive (Base)" := 0;
        END;
      END;
    END;

    [External]
    PROCEDURE ShowLineComments@62();
    VAR
      PurchCommentLine@1000 : Record 43;
    BEGIN
      TESTFIELD("Document No.");
      TESTFIELD("Line No.");
      PurchCommentLine.ShowComments("Document Type","Document No.","Line No.");
    END;

    [External]
    PROCEDURE SetDefaultQuantity@63();
    BEGIN
      GetPurchSetup;
      IF PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Blank THEN BEGIN
        IF ("Document Type" = "Document Type"::Order) OR ("Document Type" = "Document Type"::Quote) THEN BEGIN
          "Qty. to Receive" := 0;
          "Qty. to Receive (Base)" := 0;
          "Qty. to Invoice" := 0;
          "Qty. to Invoice (Base)" := 0;
        END;
        IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
          "Return Qty. to Ship" := 0;
          "Return Qty. to Ship (Base)" := 0;
          "Qty. to Invoice" := 0;
          "Qty. to Invoice (Base)" := 0;
        END;
      END;

      OnAfterSetDefaultQuantity(Rec,xRec);
    END;

    [External]
    PROCEDURE UpdatePrePaymentAmounts@65();
    VAR
      ReceiptLine@1000 : Record 121;
      PurchOrderLine@1001 : Record 39;
      PurchOrderHeader@1002 : Record 38;
    BEGIN
      IF ("Document Type" <> "Document Type"::Invoice) OR ("Prepayment %" = 0) THEN
        EXIT;

      IF NOT ReceiptLine.GET("Receipt No.","Receipt Line No.") THEN BEGIN
        "Prepmt Amt to Deduct" := 0;
        "Prepmt VAT Diff. to Deduct" := 0;
      END ELSE
        IF PurchOrderLine.GET(PurchOrderLine."Document Type"::Order,ReceiptLine."Order No.",ReceiptLine."Order Line No.") THEN BEGIN
          IF ("Prepayment %" = 100) AND (Quantity <> PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced") THEN
            "Prepmt Amt to Deduct" := "Line Amount"
          ELSE
            "Prepmt Amt to Deduct" :=
              ROUND((PurchOrderLine."Prepmt. Amt. Inv." - PurchOrderLine."Prepmt Amt Deducted") *
                Quantity / (PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced"),Currency."Amount Rounding Precision");
          "Prepmt VAT Diff. to Deduct" := "Prepayment VAT Difference" - "Prepmt VAT Diff. Deducted";
          PurchOrderHeader.GET(PurchOrderHeader."Document Type"::Order,PurchOrderLine."Document No.");
        END ELSE BEGIN
          "Prepmt Amt to Deduct" := 0;
          "Prepmt VAT Diff. to Deduct" := 0;
        END;

      GetPurchHeader;
      PurchHeader.TESTFIELD("Prices Including VAT",PurchOrderHeader."Prices Including VAT");
      IF PurchHeader."Prices Including VAT" THEN BEGIN
        "Prepmt. Amt. Incl. VAT" := "Prepmt Amt to Deduct";
        "Prepayment Amount" :=
          ROUND(
            "Prepmt Amt to Deduct" / (1 + ("Prepayment VAT %" / 100)),
            Currency."Amount Rounding Precision");
      END ELSE BEGIN
        "Prepmt. Amt. Incl. VAT" :=
          ROUND(
            "Prepmt Amt to Deduct" * (1 + ("Prepayment VAT %" / 100)),
            Currency."Amount Rounding Precision");
        "Prepayment Amount" := "Prepmt Amt to Deduct";
      END;
      "Prepmt. Line Amount" := "Prepmt Amt to Deduct";
      "Prepmt. Amt. Inv." := "Prepmt. Line Amount";
      "Prepmt. VAT Base Amt." := "Prepayment Amount";
      "Prepmt. Amount Inv. Incl. VAT" := "Prepmt. Amt. Incl. VAT";
      "Prepmt Amt Deducted" := 0;
    END;

    [External]
    PROCEDURE SetVendorItemNo@64();
    VAR
      ItemVend@1000 : Record 99;
    BEGIN
      GetItem;
      ItemVend.INIT;
      ItemVend."Vendor No." := "Buy-from Vendor No.";
      ItemVend."Variant Code" := "Variant Code";
      Item.FindItemVend(ItemVend,"Location Code");
      VALIDATE("Vendor Item No.",ItemVend."Vendor Item No.");
    END;

    [External]
    PROCEDURE ZeroAmountLine@66(QtyType@1000 : 'General,Invoicing,Shipping') : Boolean;
    BEGIN
      IF Type = Type::" " THEN
        EXIT(TRUE);
      IF Quantity = 0 THEN
        EXIT(TRUE);
      IF "Direct Unit Cost" = 0 THEN
        EXIT(TRUE);
      IF QtyType = QtyType::Invoicing THEN
        IF "Qty. to Invoice" = 0 THEN
          EXIT(TRUE);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE FilterLinesWithItemToPlan@70(VAR Item@1000 : Record 27;DocumentType@1001 : Option);
    BEGIN
      RESET;
      SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Expected Receipt Date");
      SETRANGE("Document Type",DocumentType);
      SETRANGE(Type,Type::Item);
      SETRANGE("No.",Item."No.");
      SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
      SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
      SETFILTER("Drop Shipment",Item.GETFILTER("Drop Shipment Filter"));
      SETFILTER("Expected Receipt Date",Item.GETFILTER("Date Filter"));
      SETFILTER("Shortcut Dimension 1 Code",Item.GETFILTER("Global Dimension 1 Filter"));
      SETFILTER("Shortcut Dimension 2 Code",Item.GETFILTER("Global Dimension 2 Filter"));
      SETFILTER("Outstanding Qty. (Base)",'<>0');
    END;

    [External]
    PROCEDURE FindLinesWithItemToPlan@68(VAR Item@1000 : Record 27;DocumentType@1001 : Option) : Boolean;
    BEGIN
      FilterLinesWithItemToPlan(Item,DocumentType);
      EXIT(FIND('-'));
    END;

    [External]
    PROCEDURE LinesWithItemToPlanExist@67(VAR Item@1000 : Record 27;DocumentType@1001 : Option) : Boolean;
    BEGIN
      FilterLinesWithItemToPlan(Item,DocumentType);
      EXIT(NOT ISEMPTY);
    END;

    [External]
    PROCEDURE GetVPGInvRoundAcc@72(VAR PurchHeader@1002 : Record 38) : Code[20];
    VAR
      Vendor@1000 : Record 23;
      VendorPostingGroup@1001 : Record 93;
    BEGIN
      GetPurchSetup;
      IF PurchSetup."Invoice Rounding" THEN
        IF Vendor.GET(PurchHeader."Pay-to Vendor No.") THEN
          VendorPostingGroup.GET(Vendor."Vendor Posting Group");

      EXIT(VendorPostingGroup."Invoice Rounding Account");
    END;

    LOCAL PROCEDURE CheckReceiptRelation@94();
    VAR
      PurchRcptLine@1001 : Record 121;
    BEGIN
      PurchRcptLine.GET("Receipt No.","Receipt Line No.");
      IF (Quantity * PurchRcptLine."Qty. Rcd. Not Invoiced") < 0 THEN
        FIELDERROR("Qty. to Invoice",Text051);
      IF ABS(Quantity) > ABS(PurchRcptLine."Qty. Rcd. Not Invoiced") THEN
        ERROR(Text052,PurchRcptLine."Document No.");
    END;

    LOCAL PROCEDURE CheckRetShptRelation@74();
    VAR
      ReturnShptLine@1000 : Record 6651;
    BEGIN
      ReturnShptLine.GET("Return Shipment No.","Return Shipment Line No.");
      IF (Quantity * (ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced")) < 0 THEN
        FIELDERROR("Qty. to Invoice",Text053);
      IF ABS(Quantity) > ABS(ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced") THEN
        ERROR(Text054,ReturnShptLine."Document No.");
    END;

    LOCAL PROCEDURE VerifyItemLineDim@73();
    BEGIN
      IF IsReceivedShippedItemDimChanged THEN
        ConfirmReceivedShippedItemDimChange;
    END;

    [External]
    PROCEDURE IsReceivedShippedItemDimChanged@89() : Boolean;
    BEGIN
      EXIT(("Dimension Set ID" <> xRec."Dimension Set ID") AND (Type = Type::Item) AND
        (("Qty. Rcd. Not Invoiced" <> 0) OR ("Return Qty. Shipped Not Invd." <> 0)));
    END;

    [External]
    PROCEDURE ConfirmReceivedShippedItemDimChange@90() : Boolean;
    BEGIN
      IF NOT CONFIRM(Text049,TRUE,TABLECAPTION) THEN
        ERROR(Text050);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE InitType@22();
    BEGIN
      IF "Document No." <> '' THEN BEGIN
        IF NOT PurchHeader.GET("Document Type","Document No.") THEN
          EXIT;
        IF (PurchHeader.Status = PurchHeader.Status::Released) AND
           (xRec.Type IN [xRec.Type::Item,xRec.Type::"Fixed Asset"])
        THEN
          Type := Type::" "
        ELSE
          Type := xRec.Type;
      END;
    END;

    LOCAL PROCEDURE CheckWMS@76();
    BEGIN
      IF CurrFieldNo <> 0 THEN
        CheckLocationOnWMS;
    END;

    [External]
    PROCEDURE CheckLocationOnWMS@79();
    VAR
      DialogText@1001 : Text;
    BEGIN
      IF Type = Type::Item THEN BEGIN
        DialogText := Text033;
        IF "Quantity (Base)" <> 0 THEN
          CASE "Document Type" OF
            "Document Type"::Invoice:
              IF "Receipt No." = '' THEN
                IF Location.GET("Location Code") AND Location."Directed Put-away and Pick" THEN BEGIN
                  DialogText += Location.GetRequirementText(Location.FIELDNO("Require Receive"));
                  ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
                END;
            "Document Type"::"Credit Memo":
              IF "Return Shipment No." = '' THEN
                IF Location.GET("Location Code") AND Location."Directed Put-away and Pick" THEN BEGIN
                  DialogText += Location.GetRequirementText(Location.FIELDNO("Require Shipment"));
                  ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
                END;
          END;
      END;
    END;

    [External]
    PROCEDURE IsServiceItem@77() : Boolean;
    BEGIN
      IF Type <> Type::Item THEN
        EXIT(FALSE);
      IF "No." = '' THEN
        EXIT(FALSE);
      GetItem;
      EXIT(Item.Type = Item.Type::Service);
    END;

    LOCAL PROCEDURE ReservEntryExist@78() : Boolean;
    VAR
      NewReservEntry@1000 : Record 337;
    BEGIN
      ReservePurchLine.FilterReservFor(NewReservEntry,Rec);
      NewReservEntry.SETRANGE("Reservation Status",NewReservEntry."Reservation Status"::Reservation,
        NewReservEntry."Reservation Status"::Tracking);

      EXIT(NOT NewReservEntry.ISEMPTY);
    END;

    LOCAL PROCEDURE ValidateReturnReasonCode@99(CallingFieldNo@1000 : Integer);
    VAR
      ReturnReason@1001 : Record 6635;
    BEGIN
      IF CallingFieldNo = 0 THEN
        EXIT;
      IF "Return Reason Code" = '' THEN
        UpdateDirectUnitCost(CallingFieldNo);

      IF ReturnReason.GET("Return Reason Code") THEN BEGIN
        IF (CallingFieldNo <> FIELDNO("Location Code")) AND (ReturnReason."Default Location Code" <> '') THEN
          VALIDATE("Location Code",ReturnReason."Default Location Code");
        IF ReturnReason."Inventory Value Zero" THEN
          VALIDATE("Direct Unit Cost",0)
        ELSE
          UpdateDirectUnitCost(CallingFieldNo);
      END;
    END;

    LOCAL PROCEDURE UpdateDimensionsFromJobTask@60();
    VAR
      DimSetArrID@1000 : ARRAY [10] OF Integer;
      DimValue1@1001 : Code[20];
      DimValue2@1002 : Code[20];
    BEGIN
      DimSetArrID[1] := "Dimension Set ID";
      DimSetArrID[2] := DimMgt.CreateDimSetFromJobTaskDim("Job No.","Job Task No.",DimValue1,DimValue2);
      "Dimension Set ID" := DimMgt.GetCombinedDimensionSetID(DimSetArrID,DimValue1,DimValue2);
      "Shortcut Dimension 1 Code" := DimValue1;
      "Shortcut Dimension 2 Code" := DimValue2;
    END;

    LOCAL PROCEDURE UpdateItemCrossRef@82();
    BEGIN
      DistIntegration.EnterPurchaseItemCrossRef(Rec);
      UpdateICPartner;
    END;

    LOCAL PROCEDURE UpdateItemReference@85();
    BEGIN
      UpdateItemCrossRef;
      IF Type <> Type::Item THEN
        EXIT;

      IF "Cross-Reference No." = '' THEN
        SetVendorItemNo
      ELSE
        VALIDATE("Vendor Item No.","Cross-Reference No.");
    END;

    LOCAL PROCEDURE UpdateICPartner@81();
    VAR
      ICPartner@1000 : Record 413;
      ItemCrossReference@1001 : Record 5717;
    BEGIN
      IF PurchHeader."Send IC Document" AND
         (PurchHeader."IC Direction" = PurchHeader."IC Direction"::Outgoing)
      THEN
        CASE Type OF
          Type::" ",Type::"Charge (Item)":
            BEGIN
              "IC Partner Ref. Type" := Type;
              "IC Partner Reference" := "No.";
            END;
          Type::"G/L Account":
            BEGIN
              "IC Partner Ref. Type" := Type;
              "IC Partner Reference" := GLAcc."Default IC Partner G/L Acc. No";
            END;
          Type::Item:
            BEGIN
              ICPartner.GET(PurchHeader."Buy-from IC Partner Code");
              CASE ICPartner."Outbound Purch. Item No. Type" OF
                ICPartner."Outbound Purch. Item No. Type"::"Common Item No.":
                  VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Common Item No.");
                ICPartner."Outbound Purch. Item No. Type"::"Internal No.",
                ICPartner."Outbound Purch. Item No. Type"::"Cross Reference":
                  BEGIN
                    IF ICPartner."Outbound Purch. Item No. Type" = ICPartner."Outbound Purch. Item No. Type"::"Internal No." THEN
                      VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::Item)
                    ELSE
                      VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Cross Reference");
                    ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Vendor);
                    ItemCrossReference.SETRANGE("Cross-Reference Type No.","Buy-from Vendor No.");
                    ItemCrossReference.SETRANGE("Item No.","No.");
                    ItemCrossReference.SETRANGE("Variant Code","Variant Code");
                    ItemCrossReference.SETRANGE("Unit of Measure","Unit of Measure Code");
                    IF ItemCrossReference.FINDFIRST THEN
                      "IC Partner Reference" := ItemCrossReference."Cross-Reference No."
                    ELSE
                      "IC Partner Reference" := "No.";
                  END;
                ICPartner."Outbound Purch. Item No. Type"::"Vendor Item No.":
                  BEGIN
                    "IC Partner Ref. Type" := "IC Partner Ref. Type"::"Vendor Item No.";
                    "IC Partner Reference" := "Vendor Item No.";
                  END;
              END;
            END;
          Type::"Fixed Asset":
            BEGIN
              "IC Partner Ref. Type" := "IC Partner Ref. Type"::" ";
              "IC Partner Reference" := '';
            END;
        END;
    END;

    LOCAL PROCEDURE CalcTotalAmtToAssign@84(TotalQtyToAssign@1000 : Decimal) TotalAmtToAssign : Decimal;
    BEGIN
      TotalAmtToAssign := ("Line Amount" - "Inv. Discount Amount") * TotalQtyToAssign / Quantity;

      IF PurchHeader."Prices Including VAT" THEN
        TotalAmtToAssign := TotalAmtToAssign / (1 + "VAT %" / 100) - "VAT Difference";

      TotalAmtToAssign := ROUND(TotalAmtToAssign,Currency."Amount Rounding Precision");
    END;

    [External]
    PROCEDURE HasTypeToFillMandatoryFields@103() : Boolean;
    BEGIN
      EXIT(Type <> Type::" ");
    END;

    [External]
    PROCEDURE GetDeferralAmount@105() DeferralAmount : Decimal;
    BEGIN
      IF "VAT Base Amount" <> 0 THEN
        DeferralAmount := "VAT Base Amount"
      ELSE
        DeferralAmount := "Line Amount" - "Inv. Discount Amount";
    END;

    LOCAL PROCEDURE UpdateDeferralAmounts@104();
    VAR
      DeferralPostDate@1000 : Date;
      AdjustStartDate@1001 : Boolean;
    BEGIN
      GetPurchHeader;
      DeferralPostDate := PurchHeader."Posting Date";
      AdjustStartDate := TRUE;
      IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
        IF "Returns Deferral Start Date" = 0D THEN
          "Returns Deferral Start Date" := PurchHeader."Posting Date";
        DeferralPostDate := "Returns Deferral Start Date";
        AdjustStartDate := FALSE;
      END;

      DeferralUtilities.RemoveOrSetDeferralSchedule(
        "Deferral Code",DeferralUtilities.GetPurchDeferralDocType,'','',
        "Document Type","Document No.","Line No.",
        GetDeferralAmount,DeferralPostDate,Description,PurchHeader."Currency Code",AdjustStartDate);
    END;

    [Internal]
    PROCEDURE ShowDeferrals@108(PostingDate@1000 : Date;CurrencyCode@1001 : Code[10]) : Boolean;
    BEGIN
      EXIT(DeferralUtilities.OpenLineScheduleEdit(
          "Deferral Code",DeferralUtilities.GetPurchDeferralDocType,'','',
          "Document Type","Document No.","Line No.",
          GetDeferralAmount,PostingDate,Description,CurrencyCode));
    END;

    LOCAL PROCEDURE InitDeferralCode@112();
    BEGIN
      IF "Document Type" IN
         ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::"Credit Memo","Document Type"::"Return Order"]
      THEN
        CASE Type OF
          Type::"G/L Account":
            VALIDATE("Deferral Code",GLAcc."Default Deferral Template Code");
          Type::Item:
            VALIDATE("Deferral Code",Item."Default Deferral Template Code");
        END;
    END;

    [External]
    PROCEDURE DefaultDeferralCode@110();
    BEGIN
      CASE Type OF
        Type::"G/L Account":
          BEGIN
            GLAcc.GET("No.");
            InitDeferralCode;
          END;
        Type::Item:
          BEGIN
            GetItem;
            InitDeferralCode;
          END;
      END;
    END;

    [External]
    PROCEDURE IsCreditDocType@83() : Boolean;
    BEGIN
      EXIT("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]);
    END;

    [External]
    PROCEDURE IsInvoiceDocType@91() : Boolean;
    BEGIN
      EXIT("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]);
    END;

    LOCAL PROCEDURE IsReceivedFromOcr@92() : Boolean;
    VAR
      IncomingDocument@1002 : Record 130;
    BEGIN
      GetPurchHeader;
      IF NOT IncomingDocument.GET(PurchHeader."Incoming Document Entry No.") THEN
        EXIT(FALSE);
      EXIT(IncomingDocument."OCR Status" = IncomingDocument."OCR Status"::Success);
    END;

    LOCAL PROCEDURE TestReturnFieldsZero@86();
    BEGIN
      TESTFIELD("Return Qty. Shipped Not Invd.",0);
      TESTFIELD("Return Qty. Shipped",0);
      TESTFIELD("Return Shipment No.",'');
    END;

    [External]
    PROCEDURE CanEditUnitOfMeasureCode@115() : Boolean;
    VAR
      ItemUnitOfMeasure@1000 : Record 5404;
    BEGIN
      IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
        ItemUnitOfMeasure.SETRANGE("Item No.","No.");
        EXIT(ItemUnitOfMeasure.COUNT > 1);
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE TestItemFields@93(ItemNo@1000 : Code[20];VariantCode@1001 : Code[10];LocationCode@1002 : Code[10]);
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.",ItemNo);
      TESTFIELD("Variant Code",VariantCode);
      TESTFIELD("Location Code",LocationCode);
    END;

    PROCEDURE ClearPurchaseHeader@120();
    BEGIN
      CLEAR(PurchHeader);
    END;

    PROCEDURE FormatType@149() : Text[20];
    BEGIN
      IF Type = Type::" " THEN
        EXIT(CommentLbl);

      EXIT(FORMAT(Type));
    END;

    PROCEDURE RenameNo@133(LineType@1000 : Option;OldNo@1001 : Code[20];NewNo@1002 : Code[20]);
    BEGIN
      RESET;
      SETRANGE(Type,LineType);
      SETRANGE("No.",OldNo);
      MODIFYALL("No.",NewNo,TRUE);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignFieldsForNo@122(VAR PurchLine@1000 : Record 39;xPurchLine@1001 : Record 39;PurchHeader@1002 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignHeaderValues@134(VAR PurchLine@1000 : Record 39;PurchHeader@1001 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignStdTxtValues@135(VAR PurchLine@1000 : Record 39;StandardText@1001 : Record 7);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignGLAccountValues@138(VAR PurchLine@1000 : Record 39;GLAccount@1001 : Record 15);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignItemValues@136(VAR PurchLine@1000 : Record 39;Item@1001 : Record 27);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignItemChargeValues@137(VAR PurchLine@1000 : Record 39;ItemCharge@1001 : Record 5800);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignFixedAssetValues@140(VAR PurchLine@1000 : Record 39;FixedAsset@1001 : Record 5600);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignItemUOM@118(VAR PurchLine@1000 : Record 39;Item@1001 : Record 27);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateDirectUnitCost@126(VAR PurchLine@1000 : Record 39;xPurchLine@1001 : Record 39;CalledByFieldNo@1002 : Integer;CurrFieldNo@1003 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeUpdateDirectUnitCost@127(VAR PurchLine@1003 : Record 39;xPurchLine@1002 : Record 39;CalledByFieldNo@1001 : Integer;CurrFieldNo@1000 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeVerifyReservedQty@113(VAR PurchLine@1000 : Record 39;xPurchLine@1001 : Record 39;CalledByFieldNo@1002 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitOutstandingAmount@109(VAR PurchLine@1000 : Record 39;xPurchLine@1003 : Record 39;PurchHeader@1001 : Record 38;Currency@1002 : Record 4);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitQtyToInvoice@128(VAR PurchLine@1000 : Record 39;CurrFieldNo@1001 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitQtyToShip@129(VAR PurchLine@1000 : Record 39;CurrFieldNo@1001 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitQtyToReceive@130(VAR PurchLine@1000 : Record 39;CurrFieldNo@1001 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterSetDefaultQuantity@150(VAR PurchLine@1000 : Record 39;VAR xPurchLine@1001 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateAmounts@121(VAR PurchLine@1000 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateUnitCost@98(VAR PurchLine@1000 : Record 39;xPurchLine@1001 : Record 39;PurchHeader@1002 : Record 38;Item@1003 : Record 27;StockkeepingUnit@1004 : Record 5700;Currency@1005 : Record 4;GLSetup@1006 : Record 98);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateJobPrices@106(VAR PurchLine@1000 : Record 39;JobJnlLine@1001 : Record 210;PurchRcptLine@1002 : Record 121);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeJobTaskIsSet@111(PurchLine@1000 : Record 39;VAR IsJobLine@1001 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateTempJobJnlLine@114(VAR JobJournalLine@1000 : Record 210;PurchLine@1001 : Record 39;xPurchLine@1002 : Record 39;GetPrices@1004 : Boolean;CurrFieldNo@1003 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnValidateTypeOnCopyFromTempPurchLine@147(VAR PurchLine@1000 : Record 39;TempPurchaseLine@1001 : TEMPORARY Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnValidateNoOnCopyFromTempPurchLine@148(VAR PurchLine@1000 : Record 39;TempPurchaseLine@1001 : TEMPORARY Record 39);
    BEGIN
    END;

    PROCEDURE AssignedItemCharge@119() : Boolean;
    BEGIN
      EXIT((Type = Type::"Charge (Item)") AND ("No." <> '') AND ("Qty. to Assign" < Quantity));
    END;

    LOCAL PROCEDURE IndirectCostPercentCheck@87(IndirectCostPercent@1000 : Decimal) : Boolean;
    BEGIN
      EXIT(
        (IndirectCostPercent >= 0) AND
        ("Document Type" IN
         ["Document Type"::Quote,"Document Type"::Order,"Document Type"::Invoice,"Document Type"::"Blanket Order"]) OR
        (IndirectCostPercent <= 0) AND
        ("Document Type" IN ["Document Type"::"Credit Memo","Document Type"::"Return Order"])
        );
    END;

    BEGIN
    END.
  }
}

