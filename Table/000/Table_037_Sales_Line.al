OBJECT Table 37 Sales Line
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232,NAVDK11.00.00.24232;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               TestStatusOpen;
               IF Quantity <> 0 THEN BEGIN
                 OnBeforeVerifyReservedQty(Rec,xRec,0);
                 ReserveSalesLine.VerifyQuantity(Rec,xRec);
               END;
               LOCKTABLE;
               SalesHeader."No." := '';
               IF Type = Type::Item THEN
                 IF SalesHeader.InventoryPickConflict("Document Type","Document No.",SalesHeader."Shipping Advice") THEN
                   ERROR(Text056,SalesHeader."Shipping Advice");
               IF ("Deferral Code" <> '') AND (GetDeferralAmount <> 0) THEN
                 UpdateDeferralAmounts;
             END;

    OnModify=BEGIN
               IF ("Document Type" = "Document Type"::"Blanket Order") AND
                  ((Type <> xRec.Type) OR ("No." <> xRec."No."))
               THEN BEGIN
                 SalesLine2.RESET;
                 SalesLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
                 SalesLine2.SETRANGE("Blanket Order No.","Document No.");
                 SalesLine2.SETRANGE("Blanket Order Line No.","Line No.");
                 IF SalesLine2.FINDSET THEN
                   REPEAT
                     SalesLine2.TESTFIELD(Type,Type);
                     SalesLine2.TESTFIELD("No.","No.");
                   UNTIL SalesLine2.NEXT = 0;
               END;

               IF ((Quantity <> 0) OR (xRec.Quantity <> 0)) AND ItemExists(xRec."No.") AND NOT FullReservedQtyIsForAsmToOrder THEN
                 ReserveSalesLine.VerifyChange(Rec,xRec);
             END;

    OnDelete=VAR
               SalesCommentLine@1001 : Record 44;
               CapableToPromise@1000 : Codeunit 99000886;
               JobCreateInvoice@1002 : Codeunit 1002;
             BEGIN
               TestStatusOpen;
               IF NOT StatusCheckSuspended AND (SalesHeader.Status = SalesHeader.Status::Released) AND
                  (Type IN [Type::"G/L Account",Type::"Charge (Item)",Type::Resource])
               THEN
                 VALIDATE(Quantity,0);

               IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
                 ReserveSalesLine.DeleteLine(Rec);
                 CALCFIELDS("Reserved Qty. (Base)");
                 TESTFIELD("Reserved Qty. (Base)",0);
                 IF "Shipment No." = '' THEN
                   TESTFIELD("Qty. Shipped Not Invoiced",0);
                 IF "Return Receipt No." = '' THEN
                   TESTFIELD("Return Qty. Rcd. Not Invd.",0);
                 WhseValidateSourceLine.SalesLineDelete(Rec);
               END;

               IF ("Document Type" = "Document Type"::Order) AND (Quantity <> "Quantity Invoiced") THEN
                 TESTFIELD("Prepmt. Amt. Inv.","Prepmt Amt Deducted");

               CleanDropShipmentFields;
               CleanSpecialOrderFieldsAndCheckAssocPurchOrder;
               NonstockItemMgt.DelNonStockSales(Rec);

               IF "Document Type" = "Document Type"::"Blanket Order" THEN BEGIN
                 SalesLine2.RESET;
                 SalesLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
                 SalesLine2.SETRANGE("Blanket Order No.","Document No.");
                 SalesLine2.SETRANGE("Blanket Order Line No.","Line No.");
                 IF SalesLine2.FINDFIRST THEN
                   SalesLine2.TESTFIELD("Blanket Order Line No.",0);
               END;

               IF Type = Type::Item THEN BEGIN
                 ATOLink.DeleteAsmFromSalesLine(Rec);
                 DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");
               END;

               IF Type = Type::"Charge (Item)" THEN
                 DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");

               CapableToPromise.RemoveReqLines("Document No.","Line No.",0,FALSE);

               IF "Line No." <> 0 THEN BEGIN
                 SalesLine2.RESET;
                 SalesLine2.SETRANGE("Document Type","Document Type");
                 SalesLine2.SETRANGE("Document No.","Document No.");
                 SalesLine2.SETRANGE("Attached to Line No.","Line No.");
                 SalesLine2.SETFILTER("Line No.",'<>%1',"Line No.");
                 SalesLine2.DELETEALL(TRUE);
               END;

               IF "Job Contract Entry No." <> 0 THEN
                 JobCreateInvoice.DeleteSalesLine(Rec);

               SalesCommentLine.SETRANGE("Document Type","Document Type");
               SalesCommentLine.SETRANGE("No.","Document No.");
               SalesCommentLine.SETRANGE("Document Line No.","Line No.");
               IF NOT SalesCommentLine.ISEMPTY THEN
                 SalesCommentLine.DELETEALL;

               IF ("Line No." <> 0) AND ("Attached to Line No." = 0) THEN BEGIN
                 SalesLine2.COPY(Rec);
                 SalesLine2.SETRANGE("Document No.",SalesLine2."Document No.");
                 SalesLine2.SETRANGE("Document Type",SalesLine2."Document Type");
                 IF SalesLine2.FIND('<>') THEN BEGIN
                   SalesLine2.VALIDATE("Recalculate Invoice Disc.",TRUE);
                   SalesLine2.MODIFY;
                 END;
               END;

               IF "Deferral Code" <> '' THEN
                 DeferralUtilities.DeferralCodeOnDelete(
                   DeferralUtilities.GetSalesDeferralDocType,'','',
                   "Document Type","Document No.","Line No.");
             END;

    OnRename=BEGIN
               ERROR(Text001,TABLECAPTION);
             END;

    CaptionML=[DAN=Salgslinje;
               ENU=Sales Line];
    LookupPageID=Page516;
    DrillDownPageID=Page516;
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,Faktura,Kreditnota,Rammeordre,Returv.ordre;
                                                                    ENU=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order];
                                                   OptionString=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order }
    { 2   ;   ;Sell-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Kundenr.;
                                                              ENU=Sell-to Customer No.];
                                                   Editable=No }
    { 3   ;   ;Document No.        ;Code20        ;TableRelation="Sales Header".No. WHERE (Document Type=FIELD(Document Type));
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 4   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 5   ;   ;Type                ;Option        ;OnValidate=VAR
                                                                TempSalesLine@1000 : TEMPORARY Record 37;
                                                              BEGIN
                                                                TestJobPlanningLine;
                                                                TestStatusOpen;
                                                                GetSalesHeader;

                                                                TESTFIELD("Qty. Shipped Not Invoiced",0);
                                                                TESTFIELD("Quantity Shipped",0);
                                                                TESTFIELD("Shipment No.",'');

                                                                TESTFIELD("Return Qty. Rcd. Not Invd.",0);
                                                                TESTFIELD("Return Qty. Received",0);
                                                                TESTFIELD("Return Receipt No.",'');

                                                                TESTFIELD("Prepmt. Amt. Inv.",0);

                                                                CheckAssocPurchOrder(FIELDCAPTION(Type));

                                                                IF Type <> xRec.Type THEN BEGIN
                                                                  CASE xRec.Type OF
                                                                    Type::Item:
                                                                      BEGIN
                                                                        ATOLink.DeleteAsmFromSalesLine(Rec);
                                                                        IF Quantity <> 0 THEN BEGIN
                                                                          SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);
                                                                          CALCFIELDS("Reserved Qty. (Base)");
                                                                          TESTFIELD("Reserved Qty. (Base)",0);
                                                                          ReserveSalesLine.VerifyChange(Rec,xRec);
                                                                          WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                                                                        END;
                                                                      END;
                                                                    Type::"Fixed Asset":
                                                                      IF Quantity <> 0 THEN
                                                                        SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);
                                                                    Type::"Charge (Item)":
                                                                      DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");
                                                                  END;
                                                                  IF xRec."Deferral Code" <> '' THEN
                                                                    DeferralUtilities.RemoveOrSetDeferralSchedule('',
                                                                      DeferralUtilities.GetSalesDeferralDocType,'','',
                                                                      xRec."Document Type",xRec."Document No.",xRec."Line No.",
                                                                      xRec.GetDeferralAmount,xRec."Posting Date",'',xRec."Currency Code",TRUE);
                                                                END;
                                                                AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);
                                                                TempSalesLine := Rec;
                                                                INIT;
                                                                IF xRec."Line Amount" <> 0 THEN
                                                                  "Recalculate Invoice Disc." := TRUE;

                                                                Type := TempSalesLine.Type;
                                                                "System-Created Entry" := TempSalesLine."System-Created Entry";
                                                                "Currency Code" := SalesHeader."Currency Code";

                                                                OnValidateTypeOnCopyFromTempSalesLine(Rec,TempSalesLine);

                                                                IF Type = Type::Item THEN
                                                                  "Allow Item Charge Assignment" := TRUE
                                                                ELSE
                                                                  "Allow Item Charge Assignment" := FALSE;
                                                                IF Type = Type::Item THEN BEGIN
                                                                  IF SalesHeader.InventoryPickConflict("Document Type","Document No.",SalesHeader."Shipping Advice") THEN
                                                                    ERROR(Text056,SalesHeader."Shipping Advice");
                                                                  IF SalesHeader.WhseShpmntConflict("Document Type","Document No.",SalesHeader."Shipping Advice") THEN
                                                                    ERROR(Text052,SalesHeader."Shipping Advice");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Vare,Ressource,Anl�g,Gebyr (vare)";
                                                                    ENU=" ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)"];
                                                   OptionString=[ ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)] }
    { 6   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(" ")) "Standard Text"
                                                                 ELSE IF (Type=CONST(G/L Account),
                                                                          System-Created Entry=CONST(No)) "G/L Account" WHERE (Direct Posting=CONST(Yes),
                                                                                                                               Account Type=CONST(Posting),
                                                                                                                               Blocked=CONST(No))
                                                                                                                               ELSE IF (Type=CONST(G/L Account),
                                                                                                                                        System-Created Entry=CONST(Yes)) "G/L Account"
                                                                                                                                        ELSE IF (Type=CONST(Resource)) Resource
                                                                                                                                        ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                                                                        ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
                                                                                                                                        ELSE IF (Type=CONST(Item)) Item;
                                                   OnValidate=VAR
                                                                TempSalesLine@1003 : TEMPORARY Record 37;
                                                                FindRecordMgt@1000 : Codeunit 703;
                                                              BEGIN
                                                                "No." := FindRecordMgt.FindNoFromTypedValue(Type,"No.",NOT "System-Created Entry");

                                                                TestJobPlanningLine;
                                                                TestStatusOpen;
                                                                CheckItemAvailable(FIELDNO("No."));

                                                                IF (xRec."No." <> "No.") AND (Quantity <> 0) THEN BEGIN
                                                                  TESTFIELD("Qty. to Asm. to Order (Base)",0);
                                                                  CALCFIELDS("Reserved Qty. (Base)");
                                                                  TESTFIELD("Reserved Qty. (Base)",0);
                                                                  IF Type = Type::Item THEN
                                                                    WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                                                                END;

                                                                TESTFIELD("Qty. Shipped Not Invoiced",0);
                                                                TESTFIELD("Quantity Shipped",0);
                                                                TESTFIELD("Shipment No.",'');

                                                                TESTFIELD("Prepmt. Amt. Inv.",0);

                                                                TESTFIELD("Return Qty. Rcd. Not Invd.",0);
                                                                TESTFIELD("Return Qty. Received",0);
                                                                TESTFIELD("Return Receipt No.",'');

                                                                IF "No." = '' THEN
                                                                  ATOLink.DeleteAsmFromSalesLine(Rec);
                                                                CheckAssocPurchOrder(FIELDCAPTION("No."));
                                                                AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);

                                                                TempSalesLine := Rec;
                                                                INIT;
                                                                IF xRec."Line Amount" <> 0 THEN
                                                                  "Recalculate Invoice Disc." := TRUE;
                                                                Type := TempSalesLine.Type;
                                                                "No." := TempSalesLine."No.";
                                                                OnValidateNoOnCopyFromTempSalesLine(Rec,TempSalesLine);
                                                                IF "No." = '' THEN
                                                                  EXIT;

                                                                IF HasTypeToFillMandatoryFields THEN
                                                                  Quantity := TempSalesLine.Quantity;

                                                                "System-Created Entry" := TempSalesLine."System-Created Entry";
                                                                GetSalesHeader;
                                                                InitHeaderDefaults(SalesHeader);
                                                                CALCFIELDS("Substitution Available");

                                                                "Promised Delivery Date" := SalesHeader."Promised Delivery Date";
                                                                "Requested Delivery Date" := SalesHeader."Requested Delivery Date";
                                                                "Shipment Date" :=
                                                                  CalendarMgmt.CalcDateBOC(
                                                                    '',SalesHeader."Shipment Date",CalChange."Source Type"::Location,"Location Code",'',
                                                                    CalChange."Source Type"::"Shipping Agent","Shipping Agent Code","Shipping Agent Service Code",FALSE);
                                                                UpdateDates;

                                                                OnAfterAssignHeaderValues(Rec,SalesHeader);

                                                                CASE Type OF
                                                                  Type::" ":
                                                                    CopyFromStandardText;
                                                                  Type::"G/L Account":
                                                                    CopyFromGLAccount;
                                                                  Type::Item:
                                                                    CopyFromItem;
                                                                  Type::Resource:
                                                                    CopyFromResource;
                                                                  Type::"Fixed Asset":
                                                                    CopyFromFixedAsset;
                                                                  Type::"Charge (Item)":
                                                                    CopyFromItemCharge;
                                                                END;

                                                                OnAfterAssignFieldsForNo(Rec,xRec,SalesHeader);

                                                                IF HasTypeToFillMandatoryFields AND (Type <> Type::"Fixed Asset") THEN
                                                                  VALIDATE("VAT Prod. Posting Group");

                                                                UpdatePrepmtSetupFields;

                                                                IF HasTypeToFillMandatoryFields THEN BEGIN
                                                                  VALIDATE("Unit of Measure Code");
                                                                  IF Quantity <> 0 THEN BEGIN
                                                                    InitOutstanding;
                                                                    IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
                                                                      InitQtyToReceive
                                                                    ELSE
                                                                      InitQtyToShip;
                                                                    InitQtyToAsm;
                                                                    UpdateWithWarehouseShip;
                                                                  END;
                                                                  UpdateUnitPrice(FIELDNO("No."));
                                                                END;

                                                                IF NOT ISTEMPORARY THEN
                                                                  CreateDim(
                                                                    DimMgt.TypeToTableID3(Type),"No.",
                                                                    DATABASE::Job,"Job No.",
                                                                    DATABASE::"Responsibility Center","Responsibility Center");

                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  IF Type = Type::Item THEN
                                                                    IF (Quantity <> 0) AND ItemExists(xRec."No.") THEN BEGIN
                                                                      ReserveSalesLine.VerifyChange(Rec,xRec);
                                                                      WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                                                                    END;
                                                                  GetDefaultBin;
                                                                  AutoAsmToOrder;
                                                                  DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");
                                                                  IF Type = Type::"Charge (Item)" THEN
                                                                    DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");
                                                                END;

                                                                UpdateItemCrossRef;

                                                                PostingSetupMgt.CheckGenPostingSetupSalesAccount("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                                                                PostingSetupMgt.CheckGenPostingSetupCOGSAccount("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                                                                PostingSetupMgt.CheckVATPostingSetupSalesAccount("VAT Bus. Posting Group","VAT Prod. Posting Group");
                                                              END;

                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.];
                                                   CaptionClass=GetCaptionClass(FIELDNO("No.")) }
    { 7   ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                TestJobPlanningLine;
                                                                TestStatusOpen;
                                                                CheckAssocPurchOrder(FIELDCAPTION("Location Code"));
                                                                IF "Location Code" <> '' THEN
                                                                  IF IsServiceItem THEN
                                                                    Item.TESTFIELD(Type,Item.Type::Inventory);
                                                                IF xRec."Location Code" <> "Location Code" THEN BEGIN
                                                                  IF NOT FullQtyIsForAsmToOrder THEN BEGIN
                                                                    CALCFIELDS("Reserved Qty. (Base)");
                                                                    TESTFIELD("Reserved Qty. (Base)","Qty. to Asm. to Order (Base)");
                                                                  END;
                                                                  TESTFIELD("Qty. Shipped Not Invoiced",0);
                                                                  TESTFIELD("Shipment No.",'');
                                                                  TESTFIELD("Return Qty. Rcd. Not Invd.",0);
                                                                  TESTFIELD("Return Receipt No.",'');
                                                                END;

                                                                GetSalesHeader;
                                                                "Shipment Date" :=
                                                                  CalendarMgmt.CalcDateBOC(
                                                                    '',
                                                                    SalesHeader."Shipment Date",
                                                                    CalChange."Source Type"::Location,
                                                                    "Location Code",
                                                                    '',
                                                                    CalChange."Source Type"::"Shipping Agent",
                                                                    "Shipping Agent Code",
                                                                    "Shipping Agent Service Code",
                                                                    FALSE);

                                                                CheckItemAvailable(FIELDNO("Location Code"));

                                                                IF NOT "Drop Shipment" THEN BEGIN
                                                                  IF "Location Code" = '' THEN BEGIN
                                                                    IF InvtSetup.GET THEN
                                                                      "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
                                                                  END ELSE
                                                                    IF Location.GET("Location Code") THEN
                                                                      "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                                                                END ELSE
                                                                  EVALUATE("Outbound Whse. Handling Time",'<0D>');

                                                                IF "Location Code" <> xRec."Location Code" THEN BEGIN
                                                                  InitItemAppl(TRUE);
                                                                  GetDefaultBin;
                                                                  InitQtyToAsm;
                                                                  AutoAsmToOrder;
                                                                  IF Quantity <> 0 THEN BEGIN
                                                                    IF NOT "Drop Shipment" THEN
                                                                      UpdateWithWarehouseShip;
                                                                    IF NOT FullReservedQtyIsForAsmToOrder THEN
                                                                      ReserveSalesLine.VerifyChange(Rec,xRec);
                                                                    WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                                                                  END;
                                                                  PostingSetupMgt.CheckInvtPostingSetupInventoryAccount("Location Code","Posting Group");
                                                                END;

                                                                UpdateDates;

                                                                IF (Type = Type::Item) AND ("No." <> '') THEN
                                                                  GetUnitCost;

                                                                CheckWMS;

                                                                IF "Document Type" = "Document Type"::"Return Order" THEN
                                                                  ValidateReturnReasonCode(FIELDNO("Location Code"));
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 8   ;   ;Posting Group       ;Code20        ;TableRelation=IF (Type=CONST(Item)) "Inventory Posting Group"
                                                                 ELSE IF (Type=CONST(Fixed Asset)) "FA Posting Group";
                                                   CaptionML=[DAN=Bogf�ringsgruppe;
                                                              ENU=Posting Group];
                                                   Editable=No }
    { 10  ;   ;Shipment Date       ;Date          ;OnValidate=VAR
                                                                CheckDateConflict@1000 : Codeunit 99000815;
                                                              BEGIN
                                                                TestStatusOpen;
                                                                WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                                                                IF CurrFieldNo <> 0 THEN
                                                                  AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);

                                                                IF "Shipment Date" <> 0D THEN BEGIN
                                                                  IF CurrFieldNo IN [
                                                                                     FIELDNO("Planned Shipment Date"),
                                                                                     FIELDNO("Planned Delivery Date"),
                                                                                     FIELDNO("Shipment Date"),
                                                                                     FIELDNO("Shipping Time"),
                                                                                     FIELDNO("Outbound Whse. Handling Time"),
                                                                                     FIELDNO("Requested Delivery Date")]
                                                                  THEN
                                                                    CheckItemAvailable(FIELDNO("Shipment Date"));

                                                                  IF ("Shipment Date" < WORKDATE) AND HasTypeToFillMandatoryFields THEN
                                                                    IF NOT (GetHideValidationDialog OR HasBeenShown) AND GUIALLOWED THEN BEGIN
                                                                      MESSAGE(
                                                                        Text014,
                                                                        FIELDCAPTION("Shipment Date"),"Shipment Date",WORKDATE);
                                                                      HasBeenShown := TRUE;
                                                                    END;
                                                                END;

                                                                AutoAsmToOrder;
                                                                IF (xRec."Shipment Date" <> "Shipment Date") AND
                                                                   (Quantity <> 0) AND
                                                                   NOT StatusCheckSuspended
                                                                THEN
                                                                  CheckDateConflict.SalesLineCheck(Rec,CurrFieldNo <> 0);

                                                                IF NOT PlannedShipmentDateCalculated THEN
                                                                  "Planned Shipment Date" := CalcPlannedShptDate(FIELDNO("Shipment Date"));
                                                                IF NOT PlannedDeliveryDateCalculated THEN
                                                                  "Planned Delivery Date" := CalcPlannedDeliveryDate(FIELDNO("Shipment Date"));
                                                              END;

                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Afsendelsesdato;
                                                              ENU=Shipment Date] }
    { 11  ;   ;Description         ;Text50        ;TableRelation=IF (Type=CONST(G/L Account),
                                                                     System-Created Entry=CONST(No)) "G/L Account".Name WHERE (Direct Posting=CONST(Yes),
                                                                                                                               Account Type=CONST(Posting),
                                                                                                                               Blocked=CONST(No))
                                                                                                                               ELSE IF (Type=CONST(G/L Account),
                                                                                                                                        System-Created Entry=CONST(Yes)) "G/L Account".Name
                                                                                                                                        ELSE IF (Type=CONST(Item)) Item.Description
                                                                                                                                        ELSE IF (Type=CONST(Resource)) Resource.Name
                                                                                                                                        ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset".Description
                                                                                                                                        ELSE IF (Type=CONST("Charge (Item)")) "Item Charge".Description;
                                                   OnValidate=VAR
                                                                Item@1000 : Record 27;
                                                                ApplicationAreaSetup@1004 : Record 9178;
                                                                FindRecordMgt@1005 : Codeunit 703;
                                                                IdentityManagement@1007 : Codeunit 9801;
                                                                ReturnValue@1001 : Text[50];
                                                                DescriptionIsNo@1002 : Boolean;
                                                                DefaultCreate@1003 : Boolean;
                                                                Confirmed@1006 : Boolean;
                                                              BEGIN
                                                                IF Type = Type::" " THEN
                                                                  EXIT;

                                                                CASE Type OF
                                                                  Type::Item:
                                                                    BEGIN
                                                                      IF (STRLEN(Description) <= MAXSTRLEN(Item."No.")) AND ("No." <> '') THEN
                                                                        DescriptionIsNo := Item.GET(Description)
                                                                      ELSE
                                                                        DescriptionIsNo := FALSE;
                                                                      IF ("No." <> '') AND (NOT DescriptionIsNo) AND (Description <> '') THEN BEGIN
                                                                        Item.SETRANGE(Description,Description);
                                                                        IF Item.FINDFIRST THEN
                                                                          Confirmed := IdentityManagement.IsInvAppId
                                                                        ELSE BEGIN
                                                                          Item.SETFILTER(Description,'''@' + CONVERTSTR(Description,'''','?') + '''');
                                                                          IF NOT Item.FINDFIRST THEN
                                                                            EXIT;
                                                                        END;
                                                                        IF Item."No." = "No." THEN
                                                                          EXIT;
                                                                        IF GUIALLOWED THEN
                                                                          IF NOT IdentityManagement.IsInvAppId THEN
                                                                            Confirmed := CONFIRM(AnotherItemWithSameDescrQst,FALSE,Item."No.",Item.Description);
                                                                        IF IdentityManagement.IsInvAppId OR Confirmed THEN
                                                                          VALIDATE("No.",Item."No.");
                                                                        EXIT;
                                                                      END;

                                                                      GetSalesSetup;
                                                                      DefaultCreate := ("No." = '') AND SalesSetup."Create Item from Description";
                                                                      IF Item.TryGetItemNoOpenCard(
                                                                           ReturnValue,Description,DefaultCreate,NOT GetHideValidationDialog,NOT IdentityManagement.IsInvAppId)
                                                                      THEN
                                                                        CASE ReturnValue OF
                                                                          '':
                                                                            BEGIN
                                                                              LookupRequested := TRUE;
                                                                              Description := xRec.Description;
                                                                            END;
                                                                          "No.":
                                                                            Description := xRec.Description;
                                                                          ELSE BEGIN
                                                                            CurrFieldNo := FIELDNO("No.");
                                                                            VALIDATE("No.",COPYSTR(ReturnValue,1,MAXSTRLEN(Item."No.")));
                                                                          END;
                                                                        END;
                                                                    END;
                                                                  ELSE
                                                                    IF ("No." = '') OR (CurrFieldNo = FIELDNO(Description)) THEN
                                                                      IF FindRecordMgt.FindRecordByDescription(ReturnValue,Type,Description) = 1 THEN BEGIN
                                                                        CurrFieldNo := FIELDNO("No.");
                                                                        VALIDATE("No.",COPYSTR(ReturnValue,1,MAXSTRLEN("No.")));
                                                                      END;
                                                                END;
                                                                IF ("No." = '') AND GUIALLOWED AND ApplicationAreaSetup.IsFoundationEnabled THEN
                                                                  IF "Document Type" IN
                                                                     ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote,"Document Type"::"Credit Memo"]
                                                                  THEN
                                                                    ERROR(STRSUBSTNO(CannotFindDescErr,Type,Description));
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 12  ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 13  ;   ;Unit of Measure     ;Text10        ;TableRelation=IF (Type=FILTER(<>' ')) "Unit of Measure".Description;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Enhed;
                                                              ENU=Unit of Measure] }
    { 15  ;   ;Quantity            ;Decimal       ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                              BEGIN
                                                                TestJobPlanningLine;
                                                                TestStatusOpen;

                                                                CheckAssocPurchOrder(FIELDCAPTION(Quantity));

                                                                IF "Shipment No." <> '' THEN
                                                                  CheckShipmentRelation
                                                                ELSE
                                                                  IF "Return Receipt No." <> '' THEN
                                                                    CheckRetRcptRelation;

                                                                "Quantity (Base)" := CalcBaseQty(Quantity);

                                                                IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
                                                                  IF (Quantity * "Return Qty. Received" < 0) OR
                                                                     ((ABS(Quantity) < ABS("Return Qty. Received")) AND ("Return Receipt No." = ''))
                                                                  THEN
                                                                    FIELDERROR(Quantity,STRSUBSTNO(Text003,FIELDCAPTION("Return Qty. Received")));
                                                                  IF ("Quantity (Base)" * "Return Qty. Received (Base)" < 0) OR
                                                                     ((ABS("Quantity (Base)") < ABS("Return Qty. Received (Base)")) AND ("Return Receipt No." = ''))
                                                                  THEN
                                                                    FIELDERROR("Quantity (Base)",STRSUBSTNO(Text003,FIELDCAPTION("Return Qty. Received (Base)")));
                                                                END ELSE BEGIN
                                                                  IF (Quantity * "Quantity Shipped" < 0) OR
                                                                     ((ABS(Quantity) < ABS("Quantity Shipped")) AND ("Shipment No." = ''))
                                                                  THEN
                                                                    FIELDERROR(Quantity,STRSUBSTNO(Text003,FIELDCAPTION("Quantity Shipped")));
                                                                  IF ("Quantity (Base)" * "Qty. Shipped (Base)" < 0) OR
                                                                     ((ABS("Quantity (Base)") < ABS("Qty. Shipped (Base)")) AND ("Shipment No." = ''))
                                                                  THEN
                                                                    FIELDERROR("Quantity (Base)",STRSUBSTNO(Text003,FIELDCAPTION("Qty. Shipped (Base)")));
                                                                END;

                                                                IF (Type = Type::"Charge (Item)") AND (CurrFieldNo <> 0) THEN BEGIN
                                                                  IF (Quantity = 0) AND ("Qty. to Assign" <> 0) THEN
                                                                    FIELDERROR("Qty. to Assign",STRSUBSTNO(Text009,FIELDCAPTION(Quantity),Quantity));
                                                                  IF (Quantity * "Qty. Assigned" < 0) OR (ABS(Quantity) < ABS("Qty. Assigned")) THEN
                                                                    FIELDERROR(Quantity,STRSUBSTNO(Text003,FIELDCAPTION("Qty. Assigned")));
                                                                END;

                                                                AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);
                                                                IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN BEGIN
                                                                  InitOutstanding;
                                                                  IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
                                                                    InitQtyToReceive
                                                                  ELSE
                                                                    InitQtyToShip;
                                                                  InitQtyToAsm;
                                                                  SetDefaultQuantity;
                                                                END;

                                                                CheckItemAvailable(FIELDNO(Quantity));

                                                                IF (Quantity * xRec.Quantity < 0) OR (Quantity = 0) THEN
                                                                  InitItemAppl(FALSE);

                                                                IF Type = Type::Item THEN BEGIN
                                                                  UpdateUnitPrice(FIELDNO(Quantity));
                                                                  IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN BEGIN
                                                                    OnBeforeVerifyReservedQty(Rec,xRec,FIELDNO(Quantity));
                                                                    ReserveSalesLine.VerifyQuantity(Rec,xRec);
                                                                    IF NOT "Drop Shipment" THEN
                                                                      UpdateWithWarehouseShip;
                                                                    WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                                                                    IF ("Quantity (Base)" * xRec."Quantity (Base)" <= 0) AND ("No." <> '') THEN BEGIN
                                                                      GetItem;
                                                                      IF (Item."Costing Method" = Item."Costing Method"::Standard) AND NOT IsShipment THEN
                                                                        GetUnitCost;
                                                                    END;
                                                                  END;
                                                                  VALIDATE("Qty. to Assemble to Order");
                                                                  IF (Quantity = "Quantity Invoiced") AND (CurrFieldNo <> 0) THEN
                                                                    CheckItemChargeAssgnt;
                                                                  CheckApplFromItemLedgEntry(ItemLedgEntry);
                                                                END ELSE
                                                                  VALIDATE("Line Discount %");

                                                                IF (xRec.Quantity <> Quantity) AND (Quantity = 0) AND
                                                                   ((Amount <> 0) OR ("Amount Including VAT" <> 0) OR ("VAT Base Amount" <> 0))
                                                                THEN BEGIN
                                                                  Amount := 0;
                                                                  "Amount Including VAT" := 0;
                                                                  "VAT Base Amount" := 0;
                                                                END;

                                                                UpdatePrePaymentAmounts;

                                                                CheckWMS;

                                                                UpdatePlanned;
                                                                IF "Document Type" = "Document Type"::"Return Order" THEN
                                                                  ValidateReturnReasonCode(FIELDNO(Quantity));
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 16  ;   ;Outstanding Quantity;Decimal       ;CaptionML=[DAN=Udest�ende antal;
                                                              ENU=Outstanding Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 17  ;   ;Qty. to Invoice     ;Decimal       ;OnValidate=BEGIN
                                                                IF "Qty. to Invoice" = MaxQtyToInvoice THEN
                                                                  InitQtyToInvoice
                                                                ELSE
                                                                  "Qty. to Invoice (Base)" := CalcBaseQty("Qty. to Invoice");
                                                                IF ("Qty. to Invoice" * Quantity < 0) OR
                                                                   (ABS("Qty. to Invoice") > ABS(MaxQtyToInvoice))
                                                                THEN
                                                                  ERROR(
                                                                    Text005,
                                                                    MaxQtyToInvoice);
                                                                IF ("Qty. to Invoice (Base)" * "Quantity (Base)" < 0) OR
                                                                   (ABS("Qty. to Invoice (Base)") > ABS(MaxQtyToInvoiceBase))
                                                                THEN
                                                                  ERROR(
                                                                    Text006,
                                                                    MaxQtyToInvoiceBase);
                                                                "VAT Difference" := 0;
                                                                CalcInvDiscToInvoice;
                                                                CalcPrepaymentToDeduct;
                                                              END;

                                                   CaptionML=[DAN=Fakturer (antal);
                                                              ENU=Qty. to Invoice];
                                                   DecimalPlaces=0:5 }
    { 18  ;   ;Qty. to Ship        ;Decimal       ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                              BEGIN
                                                                GetLocation("Location Code");
                                                                IF (CurrFieldNo <> 0) AND
                                                                   (Type = Type::Item) AND
                                                                   (NOT "Drop Shipment")
                                                                THEN BEGIN
                                                                  IF Location."Require Shipment" AND
                                                                     ("Qty. to Ship" <> 0)
                                                                  THEN
                                                                    CheckWarehouse;
                                                                  WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                                                                END;

                                                                IF "Qty. to Ship" = "Outstanding Quantity" THEN
                                                                  InitQtyToShip
                                                                ELSE BEGIN
                                                                  "Qty. to Ship (Base)" := CalcBaseQty("Qty. to Ship");
                                                                  CheckServItemCreation;
                                                                  InitQtyToInvoice;
                                                                END;
                                                                IF ((("Qty. to Ship" < 0) XOR (Quantity < 0)) AND (Quantity <> 0) AND ("Qty. to Ship" <> 0)) OR
                                                                   (ABS("Qty. to Ship") > ABS("Outstanding Quantity")) OR
                                                                   (((Quantity < 0) XOR ("Outstanding Quantity" < 0)) AND (Quantity <> 0) AND ("Outstanding Quantity" <> 0))
                                                                THEN
                                                                  ERROR(
                                                                    Text007,
                                                                    "Outstanding Quantity");
                                                                IF ((("Qty. to Ship (Base)" < 0) XOR ("Quantity (Base)" < 0)) AND ("Qty. to Ship (Base)" <> 0) AND ("Quantity (Base)" <> 0)) OR
                                                                   (ABS("Qty. to Ship (Base)") > ABS("Outstanding Qty. (Base)")) OR
                                                                   ((("Quantity (Base)" < 0) XOR ("Outstanding Qty. (Base)" < 0)) AND ("Quantity (Base)" <> 0) AND ("Outstanding Qty. (Base)" <> 0))
                                                                THEN
                                                                  ERROR(
                                                                    Text008,
                                                                    "Outstanding Qty. (Base)");

                                                                IF (CurrFieldNo <> 0) AND (Type = Type::Item) AND ("Qty. to Ship" < 0) THEN
                                                                  CheckApplFromItemLedgEntry(ItemLedgEntry);

                                                                ATOLink.UpdateQtyToAsmFromSalesLine(Rec);
                                                              END;

                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Lever (antal);
                                                              ENU=Qty. to Ship];
                                                   DecimalPlaces=0:5 }
    { 22  ;   ;Unit Price          ;Decimal       ;OnValidate=BEGIN
                                                                TestJobPlanningLine;
                                                                TestStatusOpen;
                                                                VALIDATE("Line Discount %");
                                                              END;

                                                   CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Unit Price")) }
    { 23  ;   ;Unit Cost (LCY)     ;Decimal       ;OnValidate=BEGIN
                                                                IF (CurrFieldNo = FIELDNO("Unit Cost (LCY)")) AND
                                                                   ("Unit Cost (LCY)" <> xRec."Unit Cost (LCY)")
                                                                THEN
                                                                  CheckAssocPurchOrder(FIELDCAPTION("Unit Cost (LCY)"));

                                                                IF (CurrFieldNo = FIELDNO("Unit Cost (LCY)")) AND
                                                                   (Type = Type::Item) AND ("No." <> '') AND ("Quantity (Base)" <> 0)
                                                                THEN BEGIN
                                                                  TestJobPlanningLine;
                                                                  GetItem;
                                                                  IF (Item."Costing Method" = Item."Costing Method"::Standard) AND NOT IsShipment THEN BEGIN
                                                                    IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
                                                                      ERROR(
                                                                        Text037,
                                                                        FIELDCAPTION("Unit Cost (LCY)"),Item.FIELDCAPTION("Costing Method"),
                                                                        Item."Costing Method",FIELDCAPTION(Quantity));
                                                                    ERROR(
                                                                      Text038,
                                                                      FIELDCAPTION("Unit Cost (LCY)"),Item.FIELDCAPTION("Costing Method"),
                                                                      Item."Costing Method",FIELDCAPTION(Quantity));
                                                                  END;
                                                                END;

                                                                GetSalesHeader;
                                                                IF SalesHeader."Currency Code" <> '' THEN BEGIN
                                                                  Currency.TESTFIELD("Unit-Amount Rounding Precision");
                                                                  "Unit Cost" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtLCYToFCY(
                                                                        GetDate,SalesHeader."Currency Code",
                                                                        "Unit Cost (LCY)",SalesHeader."Currency Factor"),
                                                                      Currency."Unit-Amount Rounding Precision")
                                                                END ELSE
                                                                  "Unit Cost" := "Unit Cost (LCY)";
                                                              END;

                                                   CaptionML=[DAN=Kostpris (RV);
                                                              ENU=Unit Cost (LCY)];
                                                   AutoFormatType=2 }
    { 25  ;   ;VAT %               ;Decimal       ;CaptionML=[DAN=Momspct.;
                                                              ENU=VAT %];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 27  ;   ;Line Discount %     ;Decimal       ;OnValidate=BEGIN
                                                                TestJobPlanningLine;
                                                                TestStatusOpen;
                                                                "Line Discount Amount" :=
                                                                  ROUND(
                                                                    ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") *
                                                                    "Line Discount %" / 100,Currency."Amount Rounding Precision");
                                                                "Inv. Discount Amount" := 0;
                                                                "Inv. Disc. Amount to Invoice" := 0;
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Linjerabatpct.;
                                                              ENU=Line Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 28  ;   ;Line Discount Amount;Decimal       ;OnValidate=BEGIN
                                                                GetSalesHeader;
                                                                "Line Discount Amount" := ROUND("Line Discount Amount",Currency."Amount Rounding Precision");
                                                                TestJobPlanningLine;
                                                                TestStatusOpen;
                                                                TESTFIELD(Quantity);
                                                                IF xRec."Line Discount Amount" <> "Line Discount Amount" THEN
                                                                  UpdateLineDiscPct;
                                                                "Inv. Discount Amount" := 0;
                                                                "Inv. Disc. Amount to Invoice" := 0;
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Linjerabatbel�b;
                                                              ENU=Line Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 29  ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                                                                CASE "VAT Calculation Type" OF
                                                                  "VAT Calculation Type"::"Normal VAT",
                                                                  "VAT Calculation Type"::"Reverse Charge VAT":
                                                                    BEGIN
                                                                      "VAT Base Amount" :=
                                                                        ROUND(Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                                                                      "Amount Including VAT" :=
                                                                        ROUND(Amount + "VAT Base Amount" * "VAT %" / 100,Currency."Amount Rounding Precision");
                                                                    END;
                                                                  "VAT Calculation Type"::"Full VAT":
                                                                    IF Amount <> 0 THEN
                                                                      FIELDERROR(Amount,
                                                                        STRSUBSTNO(
                                                                          Text009,FIELDCAPTION("VAT Calculation Type"),
                                                                          "VAT Calculation Type"));
                                                                  "VAT Calculation Type"::"Sales Tax":
                                                                    BEGIN
                                                                      SalesHeader.TESTFIELD("VAT Base Discount %",0);
                                                                      "VAT Base Amount" := ROUND(Amount,Currency."Amount Rounding Precision");
                                                                      "Amount Including VAT" :=
                                                                        Amount +
                                                                        SalesTaxCalculate.CalculateTax(
                                                                          "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                                                                          "VAT Base Amount","Quantity (Base)",SalesHeader."Currency Factor");
                                                                      IF "VAT Base Amount" <> 0 THEN
                                                                        "VAT %" :=
                                                                          ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                                                                      ELSE
                                                                        "VAT %" := 0;
                                                                      "Amount Including VAT" := ROUND("Amount Including VAT",Currency."Amount Rounding Precision");
                                                                    END;
                                                                END;

                                                                InitOutstandingAmount;
                                                              END;

                                                   CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 30  ;   ;Amount Including VAT;Decimal       ;OnValidate=BEGIN
                                                                "Amount Including VAT" := ROUND("Amount Including VAT",Currency."Amount Rounding Precision");
                                                                CASE "VAT Calculation Type" OF
                                                                  "VAT Calculation Type"::"Normal VAT",
                                                                  "VAT Calculation Type"::"Reverse Charge VAT":
                                                                    BEGIN
                                                                      Amount :=
                                                                        ROUND(
                                                                          "Amount Including VAT" /
                                                                          (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                                                                          Currency."Amount Rounding Precision");
                                                                      "VAT Base Amount" :=
                                                                        ROUND(Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                                                                    END;
                                                                  "VAT Calculation Type"::"Full VAT":
                                                                    BEGIN
                                                                      Amount := 0;
                                                                      "VAT Base Amount" := 0;
                                                                    END;
                                                                  "VAT Calculation Type"::"Sales Tax":
                                                                    BEGIN
                                                                      SalesHeader.TESTFIELD("VAT Base Discount %",0);
                                                                      Amount :=
                                                                        SalesTaxCalculate.ReverseCalculateTax(
                                                                          "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                                                                          "Amount Including VAT","Quantity (Base)",SalesHeader."Currency Factor");
                                                                      IF Amount <> 0 THEN
                                                                        "VAT %" :=
                                                                          ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                                                                      ELSE
                                                                        "VAT %" := 0;
                                                                      Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                                                                      "VAT Base Amount" := Amount;
                                                                    END;
                                                                END;

                                                                InitOutstandingAmount;
                                                              END;

                                                   CaptionML=[DAN=Bel�b inkl. moms;
                                                              ENU=Amount Including VAT];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 32  ;   ;Allow Invoice Disc. ;Boolean       ;InitValue=Yes;
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF ("Allow Invoice Disc." <> xRec."Allow Invoice Disc.") AND
                                                                   (NOT "Allow Invoice Disc.")
                                                                THEN BEGIN
                                                                  "Inv. Discount Amount" := 0;
                                                                  "Inv. Disc. Amount to Invoice" := 0;
                                                                  UpdateAmounts;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Tillad fakturarabat;
                                                              ENU=Allow Invoice Disc.] }
    { 34  ;   ;Gross Weight        ;Decimal       ;CaptionML=[DAN=Bruttov�gt;
                                                              ENU=Gross Weight];
                                                   DecimalPlaces=0:5 }
    { 35  ;   ;Net Weight          ;Decimal       ;CaptionML=[DAN=Nettov�gt;
                                                              ENU=Net Weight];
                                                   DecimalPlaces=0:5 }
    { 36  ;   ;Units per Parcel    ;Decimal       ;CaptionML=[DAN=Antal pr. kolli;
                                                              ENU=Units per Parcel];
                                                   DecimalPlaces=0:5 }
    { 37  ;   ;Unit Volume         ;Decimal       ;CaptionML=[DAN=Rumfang;
                                                              ENU=Unit Volume];
                                                   DecimalPlaces=0:5 }
    { 38  ;   ;Appl.-to Item Entry ;Integer       ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                                ItemTrackingLines@1001 : Page 6510;
                                                              BEGIN
                                                                IF "Appl.-to Item Entry" <> 0 THEN BEGIN
                                                                  AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);

                                                                  TESTFIELD(Type,Type::Item);
                                                                  TESTFIELD(Quantity);
                                                                  IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
                                                                    IF Quantity > 0 THEN
                                                                      FIELDERROR(Quantity,Text030);
                                                                  END ELSE BEGIN
                                                                    IF Quantity < 0 THEN
                                                                      FIELDERROR(Quantity,Text029);
                                                                  END;
                                                                  ItemLedgEntry.GET("Appl.-to Item Entry");
                                                                  ItemLedgEntry.TESTFIELD(Positive,TRUE);
                                                                  IF ItemLedgEntry.TrackingExists THEN
                                                                    ERROR(Text040,ItemTrackingLines.CAPTION,FIELDCAPTION("Appl.-to Item Entry"));
                                                                  IF ABS("Qty. to Ship (Base)") > ItemLedgEntry.Quantity THEN
                                                                    ERROR(ShippingMoreUnitsThanReceivedErr,ItemLedgEntry.Quantity,ItemLedgEntry."Document No.");

                                                                  VALIDATE("Unit Cost (LCY)",CalcUnitCost(ItemLedgEntry));

                                                                  "Location Code" := ItemLedgEntry."Location Code";
                                                                  IF NOT ItemLedgEntry.Open THEN
                                                                    MESSAGE(Text042,"Appl.-to Item Entry");
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              SelectItemEntry(FIELDNO("Appl.-to Item Entry"));
                                                            END;

                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Udl.varepostl�benr.;
                                                              ENU=Appl.-to Item Entry] }
    { 40  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1),
                                                                                               Blocked=CONST(No));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                                ATOLink.UpdateAsmDimFromSalesLine(Rec);
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 41  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                                                               Blocked=CONST(No));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                                ATOLink.UpdateAsmDimFromSalesLine(Rec);
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 42  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   OnValidate=BEGIN
                                                                IF Type = Type::Item THEN
                                                                  UpdateUnitPrice(FIELDNO("Customer Price Group"));
                                                              END;

                                                   CaptionML=[DAN=Debitorprisgruppe;
                                                              ENU=Customer Price Group];
                                                   Editable=No }
    { 45  ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.];
                                                   Editable=No }
    { 52  ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   OnValidate=VAR
                                                                WorkType@1000 : Record 200;
                                                              BEGIN
                                                                IF Type = Type::Resource THEN BEGIN
                                                                  TestStatusOpen;
                                                                  IF WorkType.GET("Work Type Code") THEN
                                                                    VALIDATE("Unit of Measure Code",WorkType."Unit of Measure Code");
                                                                  UpdateUnitPrice(FIELDNO("Work Type Code"));
                                                                  VALIDATE("Unit Price");
                                                                  FindResUnitCost;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 56  ;   ;Recalculate Invoice Disc.;Boolean  ;CaptionML=[DAN=Genberegn fakturarabat;
                                                              ENU=Recalculate Invoice Disc.];
                                                   Editable=No }
    { 57  ;   ;Outstanding Amount  ;Decimal       ;OnValidate=VAR
                                                                Currency2@1000 : Record 4;
                                                              BEGIN
                                                                GetSalesHeader;
                                                                Currency2.InitRoundingPrecision;
                                                                IF SalesHeader."Currency Code" <> '' THEN
                                                                  "Outstanding Amount (LCY)" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        GetDate,"Currency Code",
                                                                        "Outstanding Amount",SalesHeader."Currency Factor"),
                                                                      Currency2."Amount Rounding Precision")
                                                                ELSE
                                                                  "Outstanding Amount (LCY)" :=
                                                                    ROUND("Outstanding Amount",Currency2."Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Bel�b i salgsordre;
                                                              ENU=Outstanding Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 58  ;   ;Qty. Shipped Not Invoiced;Decimal  ;CaptionML=[DAN=Lev. antal (ufakt.);
                                                              ENU=Qty. Shipped Not Invoiced];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 59  ;   ;Shipped Not Invoiced;Decimal       ;OnValidate=VAR
                                                                Currency2@1000 : Record 4;
                                                              BEGIN
                                                                GetSalesHeader;
                                                                Currency2.InitRoundingPrecision;
                                                                IF SalesHeader."Currency Code" <> '' THEN
                                                                  "Shipped Not Invoiced (LCY)" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        GetDate,"Currency Code",
                                                                        "Shipped Not Invoiced",SalesHeader."Currency Factor"),
                                                                      Currency2."Amount Rounding Precision")
                                                                ELSE
                                                                  "Shipped Not Invoiced (LCY)" :=
                                                                    ROUND("Shipped Not Invoiced",Currency2."Amount Rounding Precision");

                                                                CalculateNotShippedInvExlcVatLCY;
                                                              END;

                                                   CaptionML=[DAN=Lev. bel�b (ufakt.);
                                                              ENU=Shipped Not Invoiced];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 60  ;   ;Quantity Shipped    ;Decimal       ;AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Leveret (antal);
                                                              ENU=Quantity Shipped];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 61  ;   ;Quantity Invoiced   ;Decimal       ;CaptionML=[DAN=Faktureret (antal);
                                                              ENU=Quantity Invoiced];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 63  ;   ;Shipment No.        ;Code20        ;CaptionML=[DAN=Leverancenr.;
                                                              ENU=Shipment No.];
                                                   Editable=No }
    { 64  ;   ;Shipment Line No.   ;Integer       ;CaptionML=[DAN=Salgslev.linjenr.;
                                                              ENU=Shipment Line No.];
                                                   Editable=No }
    { 67  ;   ;Profit %            ;Decimal       ;CaptionML=[DAN=Avancepct.;
                                                              ENU=Profit %];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 68  ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Faktureres til kundenr.;
                                                              ENU=Bill-to Customer No.];
                                                   Editable=No }
    { 69  ;   ;Inv. Discount Amount;Decimal       ;OnValidate=BEGIN
                                                                CalcInvDiscToInvoice;
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Fakturarabatbel�b;
                                                              ENU=Inv. Discount Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Inv. Discount Amount")) }
    { 71  ;   ;Purchase Order No.  ;Code20        ;TableRelation=IF (Drop Shipment=CONST(Yes)) "Purchase Header".No. WHERE (Document Type=CONST(Order));
                                                   OnValidate=BEGIN
                                                                IF (xRec."Purchase Order No." <> "Purchase Order No.") AND (Quantity <> 0) THEN BEGIN
                                                                  ReserveSalesLine.VerifyChange(Rec,xRec);
                                                                  WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=K�bsordrenr.;
                                                              ENU=Purchase Order No.];
                                                   Editable=No }
    { 72  ;   ;Purch. Order Line No.;Integer      ;TableRelation=IF (Drop Shipment=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                                                 Document No.=FIELD(Purchase Order No.));
                                                   OnValidate=BEGIN
                                                                IF (xRec."Purch. Order Line No." <> "Purch. Order Line No.") AND (Quantity <> 0) THEN BEGIN
                                                                  ReserveSalesLine.VerifyChange(Rec,xRec);
                                                                  WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=K�bsordrelinjenr.;
                                                              ENU=Purch. Order Line No.];
                                                   Editable=No }
    { 73  ;   ;Drop Shipment       ;Boolean       ;OnValidate=BEGIN
                                                                TESTFIELD("Document Type","Document Type"::Order);
                                                                TESTFIELD(Type,Type::Item);
                                                                TESTFIELD("Quantity Shipped",0);
                                                                TESTFIELD("Job No.",'');
                                                                TESTFIELD("Qty. to Asm. to Order (Base)",0);

                                                                IF "Drop Shipment" THEN
                                                                  TESTFIELD("Special Order",FALSE);

                                                                CheckAssocPurchOrder(FIELDCAPTION("Drop Shipment"));

                                                                IF "Special Order" THEN
                                                                  Reserve := Reserve::Never
                                                                ELSE
                                                                  IF "Drop Shipment" THEN BEGIN
                                                                    Reserve := Reserve::Never;
                                                                    EVALUATE("Outbound Whse. Handling Time",'<0D>');
                                                                    EVALUATE("Shipping Time",'<0D>');
                                                                    UpdateDates;
                                                                    "Bin Code" := '';
                                                                  END ELSE
                                                                    SetReserveWithoutPurchasingCode;

                                                                CheckItemAvailable(FIELDNO("Drop Shipment"));

                                                                AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);
                                                                IF (xRec."Drop Shipment" <> "Drop Shipment") AND (Quantity <> 0) THEN BEGIN
                                                                  IF NOT "Drop Shipment" THEN BEGIN
                                                                    InitQtyToAsm;
                                                                    AutoAsmToOrder;
                                                                    UpdateWithWarehouseShip
                                                                  END ELSE
                                                                    InitQtyToShip;
                                                                  WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                                                                  IF NOT FullReservedQtyIsForAsmToOrder THEN
                                                                    ReserveSalesLine.VerifyChange(Rec,xRec);
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=Direkte levering;
                                                              ENU=Drop Shipment];
                                                   Editable=Yes }
    { 74  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                                                                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                                                                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 75  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   OnValidate=BEGIN
                                                                TestJobPlanningLine;
                                                                TestStatusOpen;
                                                                IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN
                                                                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                                                                    VALIDATE("VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
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
                                                   CaptionML=[DAN=Transportm�de;
                                                              ENU=Transport Method] }
    { 80  ;   ;Attached to Line No.;Integer       ;TableRelation="Sales Line"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                                                                Document No.=FIELD(Document No.));
                                                   CaptionML=[DAN=Tilknyttet linjenr.;
                                                              ENU=Attached to Line No.];
                                                   Editable=No }
    { 81  ;   ;Exit Point          ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=[DAN=Udf�rselssted;
                                                              ENU=Exit Point] }
    { 82  ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=[DAN=Omr�de;
                                                              ENU=Area] }
    { 83  ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=[DAN=Transaktionsspecifikation;
                                                              ENU=Transaction Specification] }
    { 84  ;   ;Tax Category        ;Code10        ;CaptionML=[DAN=Momskategori;
                                                              ENU=Tax Category] }
    { 85  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   OnValidate=BEGIN
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Skatteomr�dekode;
                                                              ENU=Tax Area Code] }
    { 86  ;   ;Tax Liable          ;Boolean       ;OnValidate=BEGIN
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 87  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                ValidateTaxGroupCode;
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 88  ;   ;VAT Clause Code     ;Code20        ;TableRelation="VAT Clause";
                                                   CaptionML=[DAN=Momsklausulkode;
                                                              ENU=VAT Clause Code] }
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

                                                                GetSalesHeader;
                                                                "VAT %" := VATPostingSetup."VAT %";
                                                                "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                                                                "VAT Identifier" := VATPostingSetup."VAT Identifier";
                                                                "VAT Clause Code" := VATPostingSetup."VAT Clause Code";
                                                                CASE "VAT Calculation Type" OF
                                                                  "VAT Calculation Type"::"Reverse Charge VAT",
                                                                  "VAT Calculation Type"::"Sales Tax":
                                                                    "VAT %" := 0;
                                                                  "VAT Calculation Type"::"Full VAT":
                                                                    BEGIN
                                                                      TESTFIELD(Type,Type::"G/L Account");
                                                                      TESTFIELD("No.",VATPostingSetup.GetSalesAccount(FALSE));
                                                                    END;
                                                                END;
                                                                IF SalesHeader."Prices Including VAT" AND (Type IN [Type::Item,Type::Resource]) THEN
                                                                  "Unit Price" :=
                                                                    ROUND(
                                                                      "Unit Price" * (100 + "VAT %") / (100 + xRec."VAT %"),
                                                                      Currency."Unit-Amount Rounding Precision");
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 91  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code];
                                                   Editable=No }
    { 92  ;   ;Outstanding Amount (LCY);Decimal   ;CaptionML=[DAN=Udest�ende bel�b (RV);
                                                              ENU=Outstanding Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 93  ;   ;Shipped Not Invoiced (LCY);Decimal ;CaptionML=[DAN=Leveret, men ikke faktureret (RV), inkl. moms;
                                                              ENU=Shipped Not Invoiced (LCY) Incl. VAT];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 94  ;   ;Shipped Not Inv. (LCY) No VAT;Decimal;
                                                   FieldClass=Normal;
                                                   CaptionML=[DAN=Lev. bel�b ufakt. (RV);
                                                              ENU=Shipped Not Invoiced (LCY)];
                                                   Editable=No }
    { 95  ;   ;Reserved Quantity   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Document No.),
                                                                                                        Source Ref. No.=FIELD(Line No.),
                                                                                                        Source Type=CONST(37),
                                                                                                        Source Subtype=FIELD(Document Type),
                                                                                                        Reservation Status=CONST(Reservation)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Reserveret antal;
                                                              ENU=Reserved Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 96  ;   ;Reserve             ;Option        ;OnValidate=BEGIN
                                                                IF Reserve <> Reserve::Never THEN BEGIN
                                                                  TESTFIELD(Type,Type::Item);
                                                                  TESTFIELD("No.");
                                                                END;
                                                                CALCFIELDS("Reserved Qty. (Base)");
                                                                IF (Reserve = Reserve::Never) AND ("Reserved Qty. (Base)" > 0) THEN
                                                                  TESTFIELD("Reserved Qty. (Base)",0);

                                                                IF "Drop Shipment" OR "Special Order" THEN
                                                                  TESTFIELD(Reserve,Reserve::Never);
                                                                IF xRec.Reserve = Reserve::Always THEN BEGIN
                                                                  GetItem;
                                                                  IF Item.Reserve = Item.Reserve::Always THEN
                                                                    TESTFIELD(Reserve,Reserve::Always);
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Reserver;
                                                              ENU=Reserve];
                                                   OptionCaptionML=[DAN=Aldrig,Eventuelt,Altid;
                                                                    ENU=Never,Optional,Always];
                                                   OptionString=Never,Optional,Always }
    { 97  ;   ;Blanket Order No.   ;Code20        ;TableRelation="Sales Header".No. WHERE (Document Type=CONST(Blanket Order));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Quantity Shipped",0);
                                                                IF "Blanket Order No." = '' THEN
                                                                  "Blanket Order Line No." := 0
                                                                ELSE
                                                                  VALIDATE("Blanket Order Line No.");
                                                              END;

                                                   OnLookup=BEGIN
                                                              BlanketOrderLookup;
                                                            END;

                                                   TestTableRelation=No;
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Rammeordrenr.;
                                                              ENU=Blanket Order No.] }
    { 98  ;   ;Blanket Order Line No.;Integer     ;TableRelation="Sales Line"."Line No." WHERE (Document Type=CONST(Blanket Order),
                                                                                                Document No.=FIELD(Blanket Order No.));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Quantity Shipped",0);
                                                                IF "Blanket Order Line No." <> 0 THEN BEGIN
                                                                  SalesLine2.GET("Document Type"::"Blanket Order","Blanket Order No.","Blanket Order Line No.");
                                                                  SalesLine2.TESTFIELD(Type,Type);
                                                                  SalesLine2.TESTFIELD("No.","No.");
                                                                  SalesLine2.TESTFIELD("Bill-to Customer No.","Bill-to Customer No.");
                                                                  SalesLine2.TESTFIELD("Sell-to Customer No.","Sell-to Customer No.");
                                                                  IF "Drop Shipment" THEN BEGIN
                                                                    SalesLine2.TESTFIELD("Variant Code","Variant Code");
                                                                    SalesLine2.TESTFIELD("Location Code","Location Code");
                                                                    SalesLine2.TESTFIELD("Unit of Measure Code","Unit of Measure Code");
                                                                  END ELSE BEGIN
                                                                    VALIDATE("Variant Code",SalesLine2."Variant Code");
                                                                    VALIDATE("Location Code",SalesLine2."Location Code");
                                                                    VALIDATE("Unit of Measure Code",SalesLine2."Unit of Measure Code");
                                                                  END;
                                                                  VALIDATE("Unit Price",SalesLine2."Unit Price");
                                                                  VALIDATE("Line Discount %",SalesLine2."Line Discount %");
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              BlanketOrderLookup;
                                                            END;

                                                   TestTableRelation=No;
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Rammeordrelinjenr.;
                                                              ENU=Blanket Order Line No.] }
    { 99  ;   ;VAT Base Amount     ;Decimal       ;CaptionML=[DAN=Momsgrundlag (bel�b);
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
                                                                TESTFIELD("Unit Price");
                                                                GetSalesHeader;
                                                                "Line Amount" := ROUND("Line Amount",Currency."Amount Rounding Precision");
                                                                VALIDATE(
                                                                  "Line Discount Amount",ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Amount");
                                                              END;

                                                   CaptionML=[DAN=Linjebel�b;
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
                                                   CaptionML=[DAN=Fakturer fakt.rabatbel�b;
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
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Vare,,,Gebyr (vare),Varereference,F�lles varenr.";
                                                                    ENU=" ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No."];
                                                   OptionString=[ ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No.] }
    { 108 ;   ;IC Partner Reference;Code20        ;OnLookup=VAR
                                                              ICGLAccount@1000 : Record 410;
                                                              ItemCrossReference@1001 : Record 5717;
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
                                                                      ItemCrossReference.RESET;
                                                                      ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
                                                                      ItemCrossReference.SETFILTER(
                                                                        "Cross-Reference Type",'%1|%2',
                                                                        ItemCrossReference."Cross-Reference Type"::Customer,
                                                                        ItemCrossReference."Cross-Reference Type"::" ");
                                                                      ItemCrossReference.SETFILTER("Cross-Reference Type No.",'%1|%2',"Sell-to Customer No.",'');
                                                                      IF PAGE.RUNMODAL(PAGE::"Cross Reference List",ItemCrossReference) = ACTION::LookupOK THEN
                                                                        VALIDATE("IC Partner Reference",ItemCrossReference."Cross-Reference No.");
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
                                                                  FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text044,"Prepmt. Amt. Inv."));
                                                                IF "Prepmt. Line Amount" > "Line Amount" THEN
                                                                  FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text045,"Line Amount"));
                                                                IF "System-Created Entry" THEN
                                                                  FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text045,0));
                                                                VALIDATE("Prepayment %",ROUND("Prepmt. Line Amount" * 100 / "Line Amount",0.00001));
                                                              END;

                                                   CaptionML=[DAN=Linjebel�b for forudbetaling;
                                                              ENU=Prepmt. Line Amount];
                                                   MinValue=0;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Prepmt. Line Amount")) }
    { 111 ;   ;Prepmt. Amt. Inv.   ;Decimal       ;CaptionML=[DAN=Forudbetalt bel�b faktureret;
                                                              ENU=Prepmt. Amt. Inv.];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Prepmt. Amt. Inv.")) }
    { 112 ;   ;Prepmt. Amt. Incl. VAT;Decimal     ;CaptionML=[DAN=Forudbetalingsbel�b inkl. moms;
                                                              ENU=Prepmt. Amt. Incl. VAT];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 113 ;   ;Prepayment Amount   ;Decimal       ;CaptionML=[DAN=Forudbetalingsbel�b;
                                                              ENU=Prepayment Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 114 ;   ;Prepmt. VAT Base Amt.;Decimal      ;CaptionML=[DAN=Momsgrundlagsbel�b for forudbetaling;
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

                                                   CaptionML=[DAN=Skatteomr�dekode for forudbetaling;
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
                                                                    STRSUBSTNO(Text045,"Prepmt. Amt. Inv." - "Prepmt Amt Deducted"));

                                                                IF "Prepmt Amt to Deduct" > "Qty. to Invoice" * "Unit Price" THEN
                                                                  FIELDERROR(
                                                                    "Prepmt Amt to Deduct",
                                                                    STRSUBSTNO(Text045,"Qty. to Invoice" * "Unit Price"));

                                                                IF ("Prepmt. Amt. Inv." - "Prepmt Amt to Deduct" - "Prepmt Amt Deducted") >
                                                                   (Quantity - "Qty. to Invoice" - "Quantity Invoiced") * "Unit Price"
                                                                THEN
                                                                  FIELDERROR(
                                                                    "Prepmt Amt to Deduct",
                                                                    STRSUBSTNO(Text044,
                                                                      "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" - (Quantity - "Qty. to Invoice" - "Quantity Invoiced") * "Unit Price"));
                                                              END;

                                                   CaptionML=[DAN=Forudbetalingsbel�b, der fratr�kkes;
                                                              ENU=Prepmt Amt to Deduct];
                                                   MinValue=0;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Prepmt Amt to Deduct")) }
    { 122 ;   ;Prepmt Amt Deducted ;Decimal       ;CaptionML=[DAN=Fratrukket forudbetalingsbel�b;
                                                              ENU=Prepmt Amt Deducted];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Prepmt Amt Deducted")) }
    { 123 ;   ;Prepayment Line     ;Boolean       ;CaptionML=[DAN=Forudbetalingslinje;
                                                              ENU=Prepayment Line];
                                                   Editable=No }
    { 124 ;   ;Prepmt. Amount Inv. Incl. VAT;Decimal;
                                                   CaptionML=[DAN=Forudbetalt bel�b faktureret inkl. moms;
                                                              ENU=Prepmt. Amount Inv. Incl. VAT];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 129 ;   ;Prepmt. Amount Inv. (LCY);Decimal  ;CaptionML=[DAN=Forudbetalt bel�b faktureret (RV);
                                                              ENU=Prepmt. Amount Inv. (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 130 ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   OnValidate=BEGIN
                                                                IF "IC Partner Code" <> '' THEN BEGIN
                                                                  TESTFIELD(Type,Type::"G/L Account");
                                                                  GetSalesHeader;
                                                                  SalesHeader.TESTFIELD("Sell-to IC Partner Code",'');
                                                                  SalesHeader.TESTFIELD("Bill-to IC Partner Code",'');
                                                                  VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"G/L Account");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=IC-partner kode;
                                                              ENU=IC Partner Code] }
    { 132 ;   ;Prepmt. VAT Amount Inv. (LCY);Decimal;
                                                   CaptionML=[DAN=Forudbetalt momsbel�b faktureret (RV);
                                                              ENU=Prepmt. VAT Amount Inv. (LCY)];
                                                   Editable=No }
    { 135 ;   ;Prepayment VAT Difference;Decimal  ;CaptionML=[DAN=Forudbetalt momsdifference;
                                                              ENU=Prepayment VAT Difference];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 136 ;   ;Prepmt VAT Diff. to Deduct;Decimal ;CaptionML=[DAN=Forudbetalt momsdifference, der fratr�kkes;
                                                              ENU=Prepmt VAT Diff. to Deduct];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 137 ;   ;Prepmt VAT Diff. Deducted;Decimal  ;CaptionML=[DAN=Forudbetalt momsdifference fratrukket;
                                                              ENU=Prepmt VAT Diff. Deducted];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 180 ;   ;Line Discount Calculation;Option   ;CaptionML=[DAN=Beregning af linjerabat;
                                                              ENU=Line Discount Calculation];
                                                   OptionCaptionML=[DAN=Ingen,%,Bel�b;
                                                                    ENU=None,%,Amount];
                                                   OptionString=None,%,Amount }
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
    { 900 ;   ;Qty. to Assemble to Order;Decimal  ;OnValidate=VAR
                                                                SalesLineReserve@1000 : Codeunit 99000832;
                                                              BEGIN
                                                                WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);

                                                                "Qty. to Asm. to Order (Base)" := CalcBaseQty("Qty. to Assemble to Order");

                                                                IF "Qty. to Asm. to Order (Base)" <> 0 THEN BEGIN
                                                                  TESTFIELD("Drop Shipment",FALSE);
                                                                  TESTFIELD("Special Order",FALSE);
                                                                  IF "Qty. to Asm. to Order (Base)" < 0 THEN
                                                                    FIELDERROR("Qty. to Assemble to Order",STRSUBSTNO(Text009,FIELDCAPTION("Quantity (Base)"),"Quantity (Base)"));
                                                                  TESTFIELD("Appl.-to Item Entry",0);

                                                                  CASE "Document Type" OF
                                                                    "Document Type"::"Blanket Order",
                                                                    "Document Type"::Quote:
                                                                      IF ("Quantity (Base)" = 0) OR ("Qty. to Asm. to Order (Base)" <= 0) OR SalesLineReserve.ReservEntryExist(Rec) THEN
                                                                        TESTFIELD("Qty. to Asm. to Order (Base)",0)
                                                                      ELSE
                                                                        IF "Quantity (Base)" <> "Qty. to Asm. to Order (Base)" THEN
                                                                          FIELDERROR("Qty. to Assemble to Order",STRSUBSTNO(Text031,0,"Quantity (Base)"));
                                                                    "Document Type"::Order:
                                                                      ;
                                                                    ELSE
                                                                      TESTFIELD("Qty. to Asm. to Order (Base)",0);
                                                                  END;
                                                                END;

                                                                CheckItemAvailable(FIELDNO("Qty. to Assemble to Order"));
                                                                IF NOT (CurrFieldNo IN [FIELDNO(Quantity),FIELDNO("Qty. to Assemble to Order")]) THEN
                                                                  GetDefaultBin;
                                                                AutoAsmToOrder;
                                                              END;

                                                   AccessByPermission=TableData 90=R;
                                                   CaptionML=[DAN=Mgd. at montere til ordre;
                                                              ENU=Qty. to Assemble to Order];
                                                   DecimalPlaces=0:5 }
    { 901 ;   ;Qty. to Asm. to Order (Base);Decimal;
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE("Qty. to Assemble to Order","Qty. to Asm. to Order (Base)");
                                                              END;

                                                   CaptionML=[DAN=Mgd. at mont. til ordre (basis);
                                                              ENU=Qty. to Asm. to Order (Base)];
                                                   DecimalPlaces=0:5 }
    { 902 ;   ;ATO Whse. Outstanding Qty.;Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Shipment Line"."Qty. Outstanding" WHERE (Source Type=CONST(37),
                                                                                                                       Source Subtype=FIELD(Document Type),
                                                                                                                       Source No.=FIELD(Document No.),
                                                                                                                       Source Line No.=FIELD(Line No.),
                                                                                                                       Assemble to Order=FILTER(Yes)));
                                                   AccessByPermission=TableData 90=R;
                                                   CaptionML=[DAN=Udes. lagerantal for MTO;
                                                              ENU=ATO Whse. Outstanding Qty.];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 903 ;   ;ATO Whse. Outstd. Qty. (Base);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" WHERE (Source Type=CONST(37),
                                                                                                                              Source Subtype=FIELD(Document Type),
                                                                                                                              Source No.=FIELD(Document No.),
                                                                                                                              Source Line No.=FIELD(Line No.),
                                                                                                                              Assemble to Order=FILTER(Yes)));
                                                   AccessByPermission=TableData 90=R;
                                                   CaptionML=[DAN=Udes. lagerantal for MTO (basis);
                                                              ENU=ATO Whse. Outstd. Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 1001;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.];
                                                   Editable=No }
    { 1002;   ;Job Contract Entry No.;Integer     ;OnValidate=VAR
                                                                JobPlanningLine@1001 : Record 1003;
                                                              BEGIN
                                                                JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
                                                                JobPlanningLine.SETRANGE("Job Contract Entry No.","Job Contract Entry No.");
                                                                JobPlanningLine.FINDFIRST;
                                                                CreateDim(
                                                                  DimMgt.TypeToTableID3(Type),"No.",
                                                                  DATABASE::Job,JobPlanningLine."Job No.",
                                                                  DATABASE::"Responsibility Center","Responsibility Center");
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=L�benr. for sagskontrakt;
                                                              ENU=Job Contract Entry No.];
                                                   Editable=No }
    { 1300;   ;Posting Date        ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Sales Header"."Posting Date" WHERE (Document Type=FIELD(Document Type),
                                                                                                           No.=FIELD(Document No.)));
                                                   CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 1700;   ;Deferral Code       ;Code10        ;TableRelation="Deferral Template"."Deferral Code";
                                                   OnValidate=BEGIN
                                                                GetSalesHeader;
                                                                DeferralPostDate := SalesHeader."Posting Date";

                                                                DeferralUtilities.DeferralCodeOnValidate(
                                                                  "Deferral Code",DeferralUtilities.GetSalesDeferralDocType,'','',
                                                                  "Document Type","Document No.","Line No.",
                                                                  GetDeferralAmount,DeferralPostDate,
                                                                  Description,SalesHeader."Currency Code");

                                                                IF "Document Type" = "Document Type"::"Return Order" THEN
                                                                  "Returns Deferral Start Date" :=
                                                                    DeferralUtilities.GetDeferralStartDate(DeferralUtilities.GetSalesDeferralDocType,
                                                                      "Document Type","Document No.","Line No.","Deferral Code",SalesHeader."Posting Date");
                                                              END;

                                                   CaptionML=[DAN=Periodiseringskode;
                                                              ENU=Deferral Code] }
    { 1702;   ;Returns Deferral Start Date;Date   ;OnValidate=VAR
                                                                DeferralHeader@1000 : Record 1701;
                                                              BEGIN
                                                                GetSalesHeader;
                                                                IF DeferralHeader.GET(DeferralUtilities.GetSalesDeferralDocType,'','',"Document Type","Document No.","Line No.") THEN
                                                                  DeferralUtilities.CreateDeferralSchedule("Deferral Code",DeferralUtilities.GetSalesDeferralDocType,'','',
                                                                    "Document Type","Document No.","Line No.",GetDeferralAmount,
                                                                    DeferralHeader."Calc. Method","Returns Deferral Start Date",
                                                                    DeferralHeader."No. of Periods",TRUE,
                                                                    DeferralHeader."Schedule Description",FALSE,
                                                                    SalesHeader."Currency Code");
                                                              END;

                                                   CaptionML=[DAN=Returnerer startdato for periodisering;
                                                              ENU=Returns Deferral Start Date] }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   OnValidate=BEGIN
                                                                TestJobPlanningLine;
                                                                IF "Variant Code" <> '' THEN
                                                                  TESTFIELD(Type,Type::Item);
                                                                TestStatusOpen;
                                                                CheckAssocPurchOrder(FIELDCAPTION("Variant Code"));

                                                                IF xRec."Variant Code" <> "Variant Code" THEN BEGIN
                                                                  TESTFIELD("Qty. Shipped Not Invoiced",0);
                                                                  TESTFIELD("Shipment No.",'');

                                                                  TESTFIELD("Return Qty. Rcd. Not Invd.",0);
                                                                  TESTFIELD("Return Receipt No.",'');
                                                                  InitItemAppl(FALSE);
                                                                END;

                                                                CheckItemAvailable(FIELDNO("Variant Code"));

                                                                IF Type = Type::Item THEN BEGIN
                                                                  GetUnitCost;
                                                                  UpdateUnitPrice(FIELDNO("Variant Code"));
                                                                END;

                                                                GetDefaultBin;
                                                                InitQtyToAsm;
                                                                AutoAsmToOrder;
                                                                IF (xRec."Variant Code" <> "Variant Code") AND (Quantity <> 0) THEN BEGIN
                                                                  IF NOT FullReservedQtyIsForAsmToOrder THEN
                                                                    ReserveSalesLine.VerifyChange(Rec,xRec);
                                                                  WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                                                                END;

                                                                UpdateItemCrossRef;
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5403;   ;Bin Code            ;Code20        ;TableRelation=IF (Document Type=FILTER(Order|Invoice),
                                                                     Quantity=FILTER(>=0),
                                                                     Qty. to Asm. to Order (Base)=CONST(0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                            Item No.=FIELD(No.),
                                                                                                                                            Variant Code=FIELD(Variant Code))
                                                                                                                                            ELSE IF (Document Type=FILTER(Return Order|Credit Memo),
                                                                                                                                                     Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                                                          Item No.=FIELD(No.),
                                                                                                                                                                                                          Variant Code=FIELD(Variant Code))
                                                                                                                                                                                                          ELSE Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=VAR
                                                                WMSManagement@1001 : Codeunit 7302;
                                                              BEGIN
                                                                IF "Bin Code" <> '' THEN BEGIN
                                                                  IF NOT IsInbound AND ("Quantity (Base)" <> 0) AND ("Qty. to Asm. to Order (Base)" = 0) THEN
                                                                    WMSManagement.FindBinContent("Location Code","Bin Code","No.","Variant Code",'')
                                                                  ELSE
                                                                    WMSManagement.FindBin("Location Code","Bin Code",'');
                                                                END;

                                                                IF "Drop Shipment" THEN
                                                                  CheckAssocPurchOrder(FIELDCAPTION("Bin Code"));

                                                                TESTFIELD(Type,Type::Item);
                                                                TESTFIELD("Location Code");

                                                                IF (Type = Type::Item) AND ("Bin Code" <> '') THEN BEGIN
                                                                  TESTFIELD("Drop Shipment",FALSE);
                                                                  GetLocation("Location Code");
                                                                  Location.TESTFIELD("Bin Mandatory");
                                                                  CheckWarehouse;
                                                                END;
                                                                ATOLink.UpdateAsmBinCodeFromSalesLine(Rec);
                                                              END;

                                                   OnLookup=VAR
                                                              WMSManagement@1002 : Codeunit 7302;
                                                              BinCode@1000 : Code[20];
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
    { 5405;   ;Planned             ;Boolean       ;CaptionML=[DAN=Planlagt;
                                                              ENU=Planned];
                                                   Editable=No }
    { 5407;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item),
                                                                     No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                     ELSE IF (Type=CONST(Resource),
                                                                              No.=FILTER(<>'')) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.))
                                                                              ELSE "Unit of Measure";
                                                   OnValidate=VAR
                                                                UnitOfMeasureTranslation@1000 : Record 5402;
                                                                ResUnitofMeasure@1001 : Record 205;
                                                                IdentityManagement@1161 : Codeunit 9801;
                                                              BEGIN
                                                                TestJobPlanningLine;
                                                                TestStatusOpen;
                                                                TESTFIELD("Quantity Shipped",0);
                                                                TESTFIELD("Qty. Shipped (Base)",0);
                                                                TESTFIELD("Return Qty. Received",0);
                                                                TESTFIELD("Return Qty. Received (Base)",0);
                                                                IF "Unit of Measure Code" <> xRec."Unit of Measure Code" THEN BEGIN
                                                                  TESTFIELD("Shipment No.",'');
                                                                  TESTFIELD("Return Receipt No.",'');
                                                                END;

                                                                CheckAssocPurchOrder(FIELDCAPTION("Unit of Measure Code"));

                                                                IF "Unit of Measure Code" = '' THEN
                                                                  "Unit of Measure" := ''
                                                                ELSE BEGIN
                                                                  IF NOT UnitOfMeasure.GET("Unit of Measure Code") THEN
                                                                    UnitOfMeasure.INIT;
                                                                  "Unit of Measure" := UnitOfMeasure.Description;
                                                                  GetSalesHeader;
                                                                  IF SalesHeader."Language Code" <> '' THEN BEGIN
                                                                    UnitOfMeasureTranslation.SETRANGE(Code,"Unit of Measure Code");
                                                                    UnitOfMeasureTranslation.SETRANGE("Language Code",SalesHeader."Language Code");
                                                                    IF UnitOfMeasureTranslation.FINDFIRST THEN
                                                                      "Unit of Measure" := UnitOfMeasureTranslation.Description;
                                                                  END ELSE
                                                                    IF IdentityManagement.IsInvAppId THEN
                                                                      "Unit of Measure" := UnitOfMeasure.GetDescriptionInCurrentLanguage;
                                                                END;
                                                                DistIntegration.EnterSalesItemCrossRef(Rec);
                                                                CASE Type OF
                                                                  Type::Item:
                                                                    BEGIN
                                                                      GetItem;
                                                                      GetUnitCost;
                                                                      UpdateUnitPrice(FIELDNO("Unit of Measure Code"));
                                                                      CheckItemAvailable(FIELDNO("Unit of Measure Code"));
                                                                      "Gross Weight" := Item."Gross Weight" * "Qty. per Unit of Measure";
                                                                      "Net Weight" := Item."Net Weight" * "Qty. per Unit of Measure";
                                                                      "Unit Volume" := Item."Unit Volume" * "Qty. per Unit of Measure";
                                                                      "Units per Parcel" := ROUND(Item."Units per Parcel" / "Qty. per Unit of Measure",0.00001);
                                                                      OnAfterAssignItemUOM(Rec,Item);
                                                                      IF (xRec."Unit of Measure Code" <> "Unit of Measure Code") AND (Quantity <> 0) THEN
                                                                        WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                                                                      IF "Qty. per Unit of Measure" > xRec."Qty. per Unit of Measure" THEN
                                                                        InitItemAppl(FALSE);
                                                                    END;
                                                                  Type::Resource:
                                                                    BEGIN
                                                                      IF "Unit of Measure Code" = '' THEN BEGIN
                                                                        GetResource;
                                                                        "Unit of Measure Code" := Resource."Base Unit of Measure";
                                                                      END;
                                                                      ResUnitofMeasure.GET("No.","Unit of Measure Code");
                                                                      "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                                                                      OnAfterAssignResourceUOM(Rec,Resource,ResUnitofMeasure);
                                                                      UpdateUnitPrice(FIELDNO("Unit of Measure Code"));
                                                                      FindResUnitCost;
                                                                    END;
                                                                  Type::"G/L Account",Type::"Fixed Asset",
                                                                  Type::"Charge (Item)",Type::" ":
                                                                    "Qty. per Unit of Measure" := 1;
                                                                END;
                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 5415;   ;Quantity (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                TestJobPlanningLine;
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE(Quantity,"Quantity (Base)");
                                                                UpdateUnitPrice(FIELDNO("Quantity (Base)"));
                                                              END;

                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 5416;   ;Outstanding Qty. (Base);Decimal    ;CaptionML=[DAN=Udest�ende antal (basis);
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
    { 5418;   ;Qty. to Ship (Base) ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE("Qty. to Ship","Qty. to Ship (Base)");
                                                              END;

                                                   CaptionML=[DAN=Lever antal (basis);
                                                              ENU=Qty. to Ship (Base)];
                                                   DecimalPlaces=0:5 }
    { 5458;   ;Qty. Shipped Not Invd. (Base);Decimal;
                                                   CaptionML=[DAN=Lev. antal ufakt. (basis);
                                                              ENU=Qty. Shipped Not Invd. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5460;   ;Qty. Shipped (Base) ;Decimal       ;CaptionML=[DAN=Leveret antal (basis);
                                                              ENU=Qty. Shipped (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5461;   ;Qty. Invoiced (Base);Decimal       ;CaptionML=[DAN=Faktureret antal (basis);
                                                              ENU=Qty. Invoiced (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5495;   ;Reserved Qty. (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(Document No.),
                                                                                                                 Source Ref. No.=FIELD(Line No.),
                                                                                                                 Source Type=CONST(37),
                                                                                                                 Source Subtype=FIELD(Document Type),
                                                                                                                 Reservation Status=CONST(Reservation)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Reserveret antal (basis);
                                                              ENU=Reserved Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5600;   ;FA Posting Date     ;Date          ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Bogf�ringsdato for anl�g;
                                                              ENU=FA Posting Date] }
    { 5602;   ;Depreciation Book Code;Code10      ;TableRelation="Depreciation Book";
                                                   OnValidate=BEGIN
                                                                GetFAPostingGroup;
                                                              END;

                                                   CaptionML=[DAN=Afskrivningsprofilkode;
                                                              ENU=Depreciation Book Code] }
    { 5605;   ;Depr. until FA Posting Date;Boolean;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Afskriv til bogf�ringsdato for anl�g;
                                                              ENU=Depr. until FA Posting Date] }
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
                                                                  DATABASE::Job,"Job No.");
                                                              END;

                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center];
                                                   Editable=No }
    { 5701;   ;Out-of-Stock Substitution;Boolean  ;CaptionML=[DAN=Erstatningsvare;
                                                              ENU=Out-of-Stock Substitution];
                                                   Editable=No }
    { 5702;   ;Substitution Available;Boolean     ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Item Substitution" WHERE (Type=CONST(Item),
                                                                                                No.=FIELD(No.),
                                                                                                Substitute Type=CONST(Item)));
                                                   CaptionML=[DAN=Erstatningsvare findes;
                                                              ENU=Substitution Available];
                                                   Editable=No }
    { 5703;   ;Originally Ordered No.;Code20      ;TableRelation=IF (Type=CONST(Item)) Item;
                                                   AccessByPermission=TableData 5715=R;
                                                   CaptionML=[DAN=Oprindeligt bestilt nr.;
                                                              ENU=Originally Ordered No.] }
    { 5704;   ;Originally Ordered Var. Code;Code10;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(Originally Ordered No.));
                                                   AccessByPermission=TableData 5715=R;
                                                   CaptionML=[DAN=Oprind. bestilt variantkode;
                                                              ENU=Originally Ordered Var. Code] }
    { 5705;   ;Cross-Reference No. ;Code20        ;OnValidate=VAR
                                                                ReturnedCrossRef@1000 : Record 5717;
                                                              BEGIN
                                                                GetSalesHeader;
                                                                "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                                                                ReturnedCrossRef.INIT;
                                                                IF "Cross-Reference No." <> '' THEN BEGIN
                                                                  DistIntegration.ICRLookupSalesItem(Rec,ReturnedCrossRef,CurrFieldNo <> 0);
                                                                  IF "No." <> ReturnedCrossRef."Item No." THEN
                                                                    VALIDATE("No.",ReturnedCrossRef."Item No.");
                                                                  IF ReturnedCrossRef."Variant Code" <> '' THEN
                                                                    VALIDATE("Variant Code",ReturnedCrossRef."Variant Code");

                                                                  IF ReturnedCrossRef."Unit of Measure" <> '' THEN
                                                                    VALIDATE("Unit of Measure Code",ReturnedCrossRef."Unit of Measure");
                                                                END;

                                                                "Unit of Measure (Cross Ref.)" := ReturnedCrossRef."Unit of Measure";
                                                                "Cross-Reference Type" := ReturnedCrossRef."Cross-Reference Type";
                                                                "Cross-Reference Type No." := ReturnedCrossRef."Cross-Reference Type No.";
                                                                "Cross-Reference No." := ReturnedCrossRef."Cross-Reference No.";

                                                                IF ReturnedCrossRef.Description <> '' THEN
                                                                  Description := ReturnedCrossRef.Description;

                                                                UpdateUnitPrice(FIELDNO("Cross-Reference No."));
                                                                UpdateICPartner;
                                                              END;

                                                   OnLookup=BEGIN
                                                              CrossReferenceNoLookUp;
                                                            END;

                                                   AccessByPermission=TableData 5717=R;
                                                   CaptionML=[DAN=Varereferencenr.;
                                                              ENU=Cross-Reference No.] }
    { 5706;   ;Unit of Measure (Cross Ref.);Code10;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
                                                   AccessByPermission=TableData 5717=R;
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
                                                              ENU=Nonstock];
                                                   Editable=No }
    { 5711;   ;Purchasing Code     ;Code10        ;TableRelation=Purchasing;
                                                   OnValidate=VAR
                                                                PurchasingCode@1000 : Record 5721;
                                                                ShippingAgentServices@1001 : Record 5790;
                                                              BEGIN
                                                                TestStatusOpen;
                                                                TESTFIELD(Type,Type::Item);
                                                                CheckAssocPurchOrder(FIELDCAPTION(Type));

                                                                IF PurchasingCode.GET("Purchasing Code") THEN BEGIN
                                                                  "Drop Shipment" := PurchasingCode."Drop Shipment";
                                                                  "Special Order" := PurchasingCode."Special Order";
                                                                  IF "Drop Shipment" OR "Special Order" THEN BEGIN
                                                                    TESTFIELD("Qty. to Asm. to Order (Base)",0);
                                                                    CALCFIELDS("Reserved Qty. (Base)");
                                                                    TESTFIELD("Reserved Qty. (Base)",0);
                                                                    ReserveSalesLine.VerifyChange(Rec,xRec);

                                                                    IF (Quantity <> 0) AND (Quantity = "Quantity Shipped") THEN
                                                                      ERROR(SalesLineCompletelyShippedErr);
                                                                    Reserve := Reserve::Never;
                                                                    IF "Drop Shipment" THEN BEGIN
                                                                      EVALUATE("Outbound Whse. Handling Time",'<0D>');
                                                                      EVALUATE("Shipping Time",'<0D>');
                                                                      UpdateDates;
                                                                      "Bin Code" := '';
                                                                    END;
                                                                  END ELSE
                                                                    SetReserveWithoutPurchasingCode;
                                                                END ELSE BEGIN
                                                                  "Drop Shipment" := FALSE;
                                                                  "Special Order" := FALSE;
                                                                  SetReserveWithoutPurchasingCode;
                                                                END;

                                                                IF ("Purchasing Code" <> xRec."Purchasing Code") AND
                                                                   (NOT "Drop Shipment") AND
                                                                   ("Drop Shipment" <> xRec."Drop Shipment")
                                                                THEN BEGIN
                                                                  IF "Location Code" = '' THEN BEGIN
                                                                    IF InvtSetup.GET THEN
                                                                      "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
                                                                  END ELSE
                                                                    IF Location.GET("Location Code") THEN
                                                                      "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                                                                  IF ShippingAgentServices.GET("Shipping Agent Code","Shipping Agent Service Code") THEN
                                                                    "Shipping Time" := ShippingAgentServices."Shipping Time"
                                                                  ELSE BEGIN
                                                                    GetSalesHeader;
                                                                    "Shipping Time" := SalesHeader."Shipping Time";
                                                                  END;
                                                                  UpdateDates;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=Indk�bskode;
                                                              ENU=Purchasing Code] }
    { 5712;   ;Product Group Code  ;Code10        ;TableRelation="Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
                                                   ValidateTableRelation=No;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Product Groups became first level children of Item Categories.;
                                                   CaptionML=[DAN=Produktgruppekode;
                                                              ENU=Product Group Code] }
    { 5713;   ;Special Order       ;Boolean       ;AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=Specialordre;
                                                              ENU=Special Order];
                                                   Editable=No }
    { 5714;   ;Special Order Purchase No.;Code20  ;TableRelation=IF (Special Order=CONST(Yes)) "Purchase Header".No. WHERE (Document Type=CONST(Order));
                                                   AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=K�bsordrenr. for specialordre;
                                                              ENU=Special Order Purchase No.] }
    { 5715;   ;Special Order Purch. Line No.;Integer;
                                                   TableRelation=IF (Special Order=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                                                 Document No.=FIELD(Special Order Purchase No.));
                                                   AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=K�bslinjenr. for specialordre;
                                                              ENU=Special Order Purch. Line No.] }
    { 5749;   ;Whse. Outstanding Qty.;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Shipment Line"."Qty. Outstanding" WHERE (Source Type=CONST(37),
                                                                                                                       Source Subtype=FIELD(Document Type),
                                                                                                                       Source No.=FIELD(Document No.),
                                                                                                                       Source Line No.=FIELD(Line No.)));
                                                   AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=Udes. lagerantal;
                                                              ENU=Whse. Outstanding Qty.];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 5750;   ;Whse. Outstanding Qty. (Base);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" WHERE (Source Type=CONST(37),
                                                                                                                              Source Subtype=FIELD(Document Type),
                                                                                                                              Source No.=FIELD(Document No.),
                                                                                                                              Source Line No.=FIELD(Line No.)));
                                                   AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=Udest. m�ngde p� lager (basis);
                                                              ENU=Whse. Outstanding Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 5752;   ;Completely Shipped  ;Boolean       ;CaptionML=[DAN=Levering komplet;
                                                              ENU=Completely Shipped];
                                                   Editable=No }
    { 5790;   ;Requested Delivery Date;Date       ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF ("Requested Delivery Date" <> xRec."Requested Delivery Date") AND
                                                                   ("Promised Delivery Date" <> 0D)
                                                                THEN
                                                                  ERROR(
                                                                    Text028,
                                                                    FIELDCAPTION("Requested Delivery Date"),
                                                                    FIELDCAPTION("Promised Delivery Date"));

                                                                IF "Requested Delivery Date" <> 0D THEN
                                                                  VALIDATE("Planned Delivery Date","Requested Delivery Date")
                                                                ELSE BEGIN
                                                                  GetSalesHeader;
                                                                  VALIDATE("Shipment Date",SalesHeader."Shipment Date");
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=�nsket leveringsdato;
                                                              ENU=Requested Delivery Date] }
    { 5791;   ;Promised Delivery Date;Date        ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF "Promised Delivery Date" <> 0D THEN
                                                                  VALIDATE("Planned Delivery Date","Promised Delivery Date")
                                                                ELSE
                                                                  VALIDATE("Requested Delivery Date");
                                                              END;

                                                   AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=Bekr�ftet leveringsdato;
                                                              ENU=Promised Delivery Date] }
    { 5792;   ;Shipping Time       ;DateFormula   ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF "Drop Shipment" THEN
                                                                  DateFormularZero("Shipping Time",FIELDNO("Shipping Time"),FIELDCAPTION("Shipping Time"));
                                                                UpdateDates;
                                                              END;

                                                   AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=Transporttid;
                                                              ENU=Shipping Time] }
    { 5793;   ;Outbound Whse. Handling Time;DateFormula;
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF "Drop Shipment" THEN
                                                                  DateFormularZero("Outbound Whse. Handling Time",
                                                                    FIELDNO("Outbound Whse. Handling Time"),FIELDCAPTION("Outbound Whse. Handling Time"));
                                                                UpdateDates;
                                                              END;

                                                   AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=Udg�ende lagerekspeditionstid;
                                                              ENU=Outbound Whse. Handling Time] }
    { 5794;   ;Planned Delivery Date;Date         ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF "Planned Delivery Date" <> 0D THEN BEGIN
                                                                  PlannedDeliveryDateCalculated := TRUE;

                                                                  VALIDATE("Planned Shipment Date",CalcPlannedDate);

                                                                  IF "Planned Shipment Date" > "Planned Delivery Date" THEN
                                                                    "Planned Delivery Date" := "Planned Shipment Date";
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=Planlagt leveringsdato;
                                                              ENU=Planned Delivery Date] }
    { 5795;   ;Planned Shipment Date;Date         ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF "Planned Shipment Date" <> 0D THEN BEGIN
                                                                  PlannedShipmentDateCalculated := TRUE;

                                                                  VALIDATE("Shipment Date",CalcShipmentDate);
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=Planlagt afsendelsesdato;
                                                              ENU=Planned Shipment Date] }
    { 5796;   ;Shipping Agent Code ;Code10        ;TableRelation="Shipping Agent";
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF "Shipping Agent Code" <> xRec."Shipping Agent Code" THEN
                                                                  VALIDATE("Shipping Agent Service Code",'');
                                                              END;

                                                   AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Spedit�rkode;
                                                              ENU=Shipping Agent Code] }
    { 5797;   ;Shipping Agent Service Code;Code10 ;TableRelation="Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));
                                                   OnValidate=VAR
                                                                ShippingAgentServices@1000 : Record 5790;
                                                              BEGIN
                                                                TestStatusOpen;
                                                                IF "Shipping Agent Service Code" <> xRec."Shipping Agent Service Code" THEN
                                                                  EVALUATE("Shipping Time",'<>');

                                                                IF "Drop Shipment" THEN BEGIN
                                                                  EVALUATE("Shipping Time",'<0D>');
                                                                  UpdateDates;
                                                                END ELSE
                                                                  IF ShippingAgentServices.GET("Shipping Agent Code","Shipping Agent Service Code") THEN
                                                                    "Shipping Time" := ShippingAgentServices."Shipping Time"
                                                                  ELSE BEGIN
                                                                    GetSalesHeader;
                                                                    "Shipping Time" := SalesHeader."Shipping Time";
                                                                  END;

                                                                IF ShippingAgentServices."Shipping Time" <> xRec."Shipping Time" THEN
                                                                  VALIDATE("Shipping Time","Shipping Time");
                                                              END;

                                                   AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Spedit�rservicekode;
                                                              ENU=Shipping Agent Service Code] }
    { 5800;   ;Allow Item Charge Assignment;Boolean;
                                                   InitValue=Yes;
                                                   OnValidate=BEGIN
                                                                CheckItemChargeAssgnt;
                                                              END;

                                                   AccessByPermission=TableData 5800=R;
                                                   CaptionML=[DAN=Tillad varegebyrtildeling;
                                                              ENU=Allow Item Charge Assignment] }
    { 5801;   ;Qty. to Assign      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Charge Assignment (Sales)"."Qty. to Assign" WHERE (Document Type=FIELD(Document Type),
                                                                                                                            Document No.=FIELD(Document No.),
                                                                                                                            Document Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Antal, der skal tildeles;
                                                              ENU=Qty. to Assign];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5802;   ;Qty. Assigned       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Charge Assignment (Sales)"."Qty. Assigned" WHERE (Document Type=FIELD(Document Type),
                                                                                                                           Document No.=FIELD(Document No.),
                                                                                                                           Document Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Antal tildelt;
                                                              ENU=Qty. Assigned];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5803;   ;Return Qty. to Receive;Decimal     ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                              BEGIN
                                                                IF (CurrFieldNo <> 0) AND
                                                                   (Type = Type::Item) AND
                                                                   ("Return Qty. to Receive" <> 0) AND
                                                                   (NOT "Drop Shipment")
                                                                THEN
                                                                  CheckWarehouse;

                                                                IF "Return Qty. to Receive" = Quantity - "Return Qty. Received" THEN
                                                                  InitQtyToReceive
                                                                ELSE BEGIN
                                                                  "Return Qty. to Receive (Base)" := CalcBaseQty("Return Qty. to Receive");
                                                                  InitQtyToInvoice;
                                                                END;
                                                                IF ("Return Qty. to Receive" * Quantity < 0) OR
                                                                   (ABS("Return Qty. to Receive") > ABS("Outstanding Quantity")) OR
                                                                   (Quantity * "Outstanding Quantity" < 0)
                                                                THEN
                                                                  ERROR(
                                                                    Text020,
                                                                    "Outstanding Quantity");
                                                                IF ("Return Qty. to Receive (Base)" * "Quantity (Base)" < 0) OR
                                                                   (ABS("Return Qty. to Receive (Base)") > ABS("Outstanding Qty. (Base)")) OR
                                                                   ("Quantity (Base)" * "Outstanding Qty. (Base)" < 0)
                                                                THEN
                                                                  ERROR(
                                                                    Text021,
                                                                    "Outstanding Qty. (Base)");

                                                                IF (CurrFieldNo <> 0) AND (Type = Type::Item) AND ("Return Qty. to Receive" > 0) THEN
                                                                  CheckApplFromItemLedgEntry(ItemLedgEntry);
                                                              END;

                                                   AccessByPermission=TableData 6660=R;
                                                   CaptionML=[DAN=Antal til modtagelse retur;
                                                              ENU=Return Qty. to Receive];
                                                   DecimalPlaces=0:5 }
    { 5804;   ;Return Qty. to Receive (Base);Decimal;
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE("Return Qty. to Receive","Return Qty. to Receive (Base)");
                                                              END;

                                                   CaptionML=[DAN=Ant. retur til modtag. (basis);
                                                              ENU=Return Qty. to Receive (Base)];
                                                   DecimalPlaces=0:5 }
    { 5805;   ;Return Qty. Rcd. Not Invd.;Decimal ;CaptionML=[DAN=Modtaget retur ufaktureret;
                                                              ENU=Return Qty. Rcd. Not Invd.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5806;   ;Ret. Qty. Rcd. Not Invd.(Base);Decimal;
                                                   CaptionML=[DAN=Modtaget retur ufakt. (basis);
                                                              ENU=Ret. Qty. Rcd. Not Invd.(Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5807;   ;Return Rcd. Not Invd.;Decimal      ;OnValidate=VAR
                                                                Currency2@1000 : Record 4;
                                                              BEGIN
                                                                GetSalesHeader;
                                                                Currency2.InitRoundingPrecision;
                                                                IF SalesHeader."Currency Code" <> '' THEN
                                                                  "Return Rcd. Not Invd. (LCY)" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        GetDate,"Currency Code",
                                                                        "Return Rcd. Not Invd.",SalesHeader."Currency Factor"),
                                                                      Currency2."Amount Rounding Precision")
                                                                ELSE
                                                                  "Return Rcd. Not Invd. (LCY)" :=
                                                                    ROUND("Return Rcd. Not Invd.",Currency2."Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Modt. retur - ikke fakt.;
                                                              ENU=Return Rcd. Not Invd.];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 5808;   ;Return Rcd. Not Invd. (LCY);Decimal;CaptionML=[DAN=Modt. retur - ikke fakt. (RV);
                                                              ENU=Return Rcd. Not Invd. (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5809;   ;Return Qty. Received;Decimal       ;AccessByPermission=TableData 6660=R;
                                                   CaptionML=[DAN=Antal modtaget retur;
                                                              ENU=Return Qty. Received];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5810;   ;Return Qty. Received (Base);Decimal;CaptionML=[DAN=Antal modtaget retur (basis);
                                                              ENU=Return Qty. Received (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5811;   ;Appl.-from Item Entry;Integer      ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                              BEGIN
                                                                IF "Appl.-from Item Entry" <> 0 THEN BEGIN
                                                                  CheckApplFromItemLedgEntry(ItemLedgEntry);
                                                                  VALIDATE("Unit Cost (LCY)",CalcUnitCost(ItemLedgEntry));
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              SelectItemEntry(FIELDNO("Appl.-from Item Entry"));
                                                            END;

                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Udlign fra-varepost;
                                                              ENU=Appl.-from Item Entry];
                                                   MinValue=0 }
    { 5909;   ;BOM Item No.        ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Styklistevarenr.;
                                                              ENU=BOM Item No.] }
    { 6600;   ;Return Receipt No.  ;Code20        ;CaptionML=[DAN=Returvaremodt.nr.;
                                                              ENU=Return Receipt No.];
                                                   Editable=No }
    { 6601;   ;Return Receipt Line No.;Integer    ;CaptionML=[DAN=Returvarekvit.linjenr.;
                                                              ENU=Return Receipt Line No.];
                                                   Editable=No }
    { 6608;   ;Return Reason Code  ;Code10        ;TableRelation="Return Reason";
                                                   OnValidate=BEGIN
                                                                ValidateReturnReasonCode(FIELDNO("Return Reason Code"));
                                                              END;

                                                   CaptionML=[DAN=Retur�rsagskode;
                                                              ENU=Return Reason Code] }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad linjerabat;
                                                              ENU=Allow Line Disc.] }
    { 7002;   ;Customer Disc. Group;Code20        ;TableRelation="Customer Discount Group";
                                                   OnValidate=BEGIN
                                                                IF Type = Type::Item THEN
                                                                  UpdateUnitPrice(FIELDNO("Customer Disc. Group"))
                                                              END;

                                                   CaptionML=[DAN=Debitorrabatgruppe;
                                                              ENU=Customer Disc. Group] }
    { 7003;   ;Subtype             ;Option        ;CaptionML=[DAN=Undertype;
                                                              ENU=Subtype];
                                                   OptionCaptionML=[DAN=" ,Vare - Lager,Vare - Service,Kommentar";
                                                                    ENU=" ,Item - Inventory,Item - Service,Comment"];
                                                   OptionString=[ ,Item - Inventory,Item - Service,Comment] }
    { 7004;   ;Price description   ;Text80        ;CaptionML=[DAN=Prisbeskrivelse;
                                                              ENU=Price description] }
    { 13600;  ;Account Code        ;Text30        ;OnValidate=BEGIN
                                                                IF (Type = Type::" ") AND ("Account Code" <> '') THEN
                                                                  ERROR(Text13600,FIELDCAPTION("Account Code"),FIELDCAPTION(Type),Type);
                                                              END;

                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kontokode;
                                                              ENU=Account Code] }
  }
  KEYS
  {
    {    ;Document Type,Document No.,Line No.     ;SumIndexFields=Amount,Amount Including VAT,Outstanding Amount,Shipped Not Invoiced,Outstanding Amount (LCY),Shipped Not Invoiced (LCY);
                                                   Clustered=Yes }
    { No ;Document No.,Line No.,Document Type      }
    {    ;Document Type,Type,No.,Variant Code,Drop Shipment,Location Code,Shipment Date;
                                                   SumIndexFields=Outstanding Qty. (Base) }
    {    ;Document Type,Bill-to Customer No.,Currency Code;
                                                   SumIndexFields=Outstanding Amount,Shipped Not Invoiced,Outstanding Amount (LCY),Shipped Not Invoiced (LCY),Return Rcd. Not Invd. (LCY) }
    { No ;Document Type,Type,No.,Variant Code,Drop Shipment,Shortcut Dimension 1 Code,Shortcut Dimension 2 Code,Location Code,Shipment Date;
                                                   SumIndexFields=Outstanding Qty. (Base) }
    { No ;Document Type,Bill-to Customer No.,Shortcut Dimension 1 Code,Shortcut Dimension 2 Code,Currency Code;
                                                   SumIndexFields=Outstanding Amount,Shipped Not Invoiced,Outstanding Amount (LCY),Shipped Not Invoiced (LCY) }
    {    ;Document Type,Blanket Order No.,Blanket Order Line No. }
    { No ;Document Type,Document No.,Location Code }
    {    ;Document Type,Shipment No.,Shipment Line No. }
    {    ;Type,No.,Variant Code,Drop Shipment,Location Code,Document Type,Shipment Date;
                                                   MaintainSQLIndex=No }
    {    ;Document Type,Sell-to Customer No.,Shipment No.;
                                                   SumIndexFields=Outstanding Amount (LCY) }
    {    ;Job Contract Entry No.                   }
    { No ;Document Type,Document No.,Qty. Shipped Not Invoiced }
    { No ;Document Type,Document No.,Type,No.      }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;No.,Description,Line Amount,Quantity,Unit of Measure Code,Price description }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke slette ordrelinjen, fordi den er knyttet til k�bsordre %1 linje %2.;ENU=You cannot delete the order line because it is associated with purchase order %1 line %2.';
      Text001@1001 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text002@1002 : TextConst 'DAN=Du kan ikke �ndre %1, fordi ordrelinjen er knyttet til k�bsordre %2 linje %3.;ENU=You cannot change %1 because the order line is associated with purchase order %2 line %3.';
      Text003@1003 : TextConst 'DAN=m� ikke v�re mindre end %1;ENU=must not be less than %1';
      Text005@1004 : TextConst 'DAN=Du kan h�jst fakturere %1 enheder.;ENU=You cannot invoice more than %1 units.';
      Text006@1005 : TextConst 'DAN=Du kan h�jst fakturere %1 basisenheder.;ENU=You cannot invoice more than %1 base units.';
      Text007@1006 : TextConst 'DAN=Du kan h�jst levere %1 enheder.;ENU=You cannot ship more than %1 units.';
      Text008@1007 : TextConst 'DAN=Du kan h�jst levere %1 basisenheder.;ENU=You cannot ship more than %1 base units.';
      Text009@1008 : TextConst 'DAN=" skal v�re 0, n�r %1 er %2";ENU=" must be 0 when %1 is %2"';
      Text011@1010 : TextConst 'DAN=Automatisk reservation er ikke mulig.\Vil du reservere varerne manuelt?;ENU=Automatic reservation is not possible.\Do you want to reserve items manually?';
      Text014@1013 : TextConst 'DAN=%1 %2 ligger f�r arbejdsdato %3;ENU=%1 %2 is before work date %3';
      Text016@1040 : TextConst 'DAN="%1 kr�ves til %2 = %3.";ENU="%1 is required for %2 = %3."';
      Text017@1044 : TextConst 'DAN=\De angivne oplysninger ignoreres muligvis af lageroperationerne.;ENU=\The entered information may be disregarded by warehouse operations.';
      Text020@1019 : TextConst 'DAN=Du kan ikke returnere mere end %1 enheder.;ENU=You cannot return more than %1 units.';
      Text021@1020 : TextConst 'DAN=Du kan ikke returnere mere end %1 basisenheder.;ENU=You cannot return more than %1 base units.';
      Text026@1025 : TextConst 'DAN=Du kan ikke �ndre %1, hvis varegebyret allerede er bogf�rt.;ENU=You cannot change %1 if the item charge has already been posted.';
      CurrExchRate@1030 : Record 330;
      SalesHeader@1031 : Record 36;
      SalesLine2@1032 : Record 37;
      GLAcc@1035 : Record 15;
      Item@1036 : Record 27;
      Resource@1400 : Record 156;
      Currency@1037 : Record 4;
      Res@1043 : Record 156;
      ResCost@1045 : Record 202;
      VATPostingSetup@1048 : Record 325;
      GenBusPostingGrp@1050 : Record 250;
      GenProdPostingGrp@1051 : Record 251;
      UnitOfMeasure@1054 : Record 204;
      NonstockItem@1058 : Record 5718;
      SKU@1060 : Record 5700;
      ItemCharge@1061 : Record 5800;
      InvtSetup@1063 : Record 313;
      Location@1064 : Record 14;
      ATOLink@1016 : Record 904;
      SalesSetup@1065 : Record 311;
      TempItemTemplate@1099 : TEMPORARY Record 1301;
      CalChange@1052 : Record 7602;
      ConfigTemplateHeader@1057 : Record 8618;
      PriceCalcMgt@1071 : Codeunit 7000;
      CustCheckCreditLimit@1074 : Codeunit 312;
      ItemCheckAvail@1075 : Codeunit 311;
      SalesTaxCalculate@1076 : Codeunit 398;
      ReserveSalesLine@1079 : Codeunit 99000832;
      UOMMgt@1080 : Codeunit 5402;
      AddOnIntegrMgt@1081 : Codeunit 5403;
      DimMgt@1082 : Codeunit 408;
      ItemSubstitutionMgt@1085 : Codeunit 5701;
      DistIntegration@1086 : Codeunit 5702;
      NonstockItemMgt@1087 : Codeunit 5703;
      WhseValidateSourceLine@1088 : Codeunit 5777;
      TransferExtendedText@1100 : Codeunit 378;
      DeferralUtilities@1026 : Codeunit 1720;
      CalendarMgmt@1056 : Codeunit 7600;
      PostingSetupMgt@1068 : Codeunit 48;
      FullAutoReservation@1092 : Boolean;
      StatusCheckSuspended@1094 : Boolean;
      HasBeenShown@1018 : Boolean;
      PlannedShipmentDateCalculated@1012 : Boolean;
      PlannedDeliveryDateCalculated@1070 : Boolean;
      Text028@1098 : TextConst 'DAN=%1 kan ikke �ndres, n�r %2 er udfyldt.;ENU=You cannot change the %1 when the %2 has been filled in.';
      Text029@1021 : TextConst 'DAN=skal v�re positiv;ENU=must be positive';
      Text030@1042 : TextConst 'DAN=skal v�re negativ;ENU=must be negative';
      Text031@1093 : TextConst 'DAN=Du skal angive %1 eller %2.;ENU=You must either specify %1 or %2.';
      Text034@1084 : TextConst 'DAN=V�rdien i feltet %1 skal v�re et helt tal for varen i serviceartikelgruppen, hvis feltet %2 i vinduet Serviceartikelgrupper indeholder en markering.;ENU=The value of %1 field must be a whole number for the item included in the service item group if the %2 field in the Service Item Groups window contains a check mark.';
      Text035@1083 : TextConst 'DAN="Lagersted ";ENU="Warehouse "';
      Text036@1090 : TextConst 'DAN="Lager ";ENU="Inventory "';
      HideValidationDialog@1109 : Boolean;
      Text037@1009 : TextConst 'DAN=Du kan ikke �ndre %1, n�r %2 er %3, og %4 er positiv.;ENU=You cannot change %1 when %2 is %3 and %4 is positive.';
      Text038@1014 : TextConst 'DAN=Du kan ikke �ndre %1, n�r %2 er %3, og %4 er negativ.;ENU=You cannot change %1 when %2 is %3 and %4 is negative.';
      Text039@1034 : TextConst 'DAN=%1 enheder til %2 %3 er allerede blevet returneret. Derfor kan der kun returneres %4 enheder.;ENU=%1 units for %2 %3 have already been returned. Therefore, only %4 units can be returned.';
      Text040@1039 : TextConst 'DAN=Du skal bruge formularen %1 til at angive %2, hvis der anvendes varesporing.;ENU=You must use form %1 to enter %2, if item tracking is used.';
      Text042@1055 : TextConst 'DAN=N�r du bogf�rer udligningsposten, �bnes %1 f�rst;ENU=When posting the Applied to Ledger Entry %1 will be opened first';
      ShippingMoreUnitsThanReceivedErr@1047 : TextConst 'DAN=Du kan ikke sende mere end %1 enheder, du har modtaget for dokumentnr. %2.;ENU=You cannot ship more than the %1 units that you have received for document no. %2.';
      Text044@1103 : TextConst 'DAN=m� ikke v�re mindre end %1;ENU=cannot be less than %1';
      Text045@1104 : TextConst 'DAN=m� ikke v�re st�rre end %1;ENU=cannot be more than %1';
      Text046@1105 : TextConst 'DAN=Du kan ikke returnere mere end de %1 enheder, du har sendt for %2 %3.;ENU=You cannot return more than the %1 units that you have shipped for %2 %3.';
      Text047@1106 : TextConst 'DAN=skal v�re positiv, n�r %1 ikke er 0.;ENU=must be positive when %1 is not 0.';
      Text048@1108 : TextConst 'DAN=Du kan ikke anvende varesporing p� en %1, der er oprettet ud fra en %2.;ENU=You cannot use item tracking on a %1 created from a %2.';
      Text049@1139 : TextConst 'DAN=m� ikke v�re %1.;ENU=cannot be %1.';
      Text051@1141 : TextConst 'DAN=%1 kan ikke bruges i en %2.;ENU=You cannot use %1 in a %2.';
      PrePaymentLineAmountEntered@1015 : Boolean;
      Text052@1022 : TextConst 'DAN=Du kan ikke tilf�je en varelinje, da der findes en �ben lagerleverance for Salgshoved, og Afsendelsesadvis er %1.\\Du skal tilf�je varerne som nye linjer i den eksisterende lagerleverance eller �ndre Afsendelsesadvis til Delvis.;ENU=You cannot add an item line because an open warehouse shipment exists for the sales header and Shipping Advice is %1.\\You must add items as new lines to the existing warehouse shipment or change Shipping Advice to Partial.';
      Text053@1017 : TextConst 'DAN=Du har �ndret en eller flere dimensioner p� %1, som allerede er afsendt. N�r du bogf�rer linjen med den �ndrede dimension under finansposter, vil bel�b p� lagerkonto (mellemregningskto.) ikke stemme, n�r de rapporteres pr. dimension.\\Vil du beholde den �ndrede dimension?;ENU=You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?';
      Text054@1023 : TextConst 'DAN=Annulleret.;ENU=Cancelled.';
      Text055@1024 : TextConst '@@@=Quantity Invoiced must not be greater than the sum of Qty. Assigned and Qty. to Assign.;DAN=%1 m� ikke v�re st�rre end summen af %2 og %3.;ENU=%1 must not be greater than the sum of %2 and %3.';
      Text056@1011 : TextConst 'DAN=Du kan ikke tilf�je en varelinje, da der findes et �bent lagerpluk for Salgshoved, og fordi Afsendelsesadvis er angivet til %1.\\Du skal f�rst bogf�re eller slette lagerplukket eller �ndre Afsendelsesadvis til Delvis.;ENU=You cannot add an item line because an open inventory pick exists for the Sales Header and because Shipping Advice is %1.\\You must first post or delete the inventory pick or change Shipping Advice to Partial.';
      Text057@1027 : TextConst 'DAN=skal have samme fortegn som salgsleverancen;ENU=must have the same sign as the shipment';
      Text058@1028 : TextConst 'DAN=Det antal, som du fors�ger at fakturere, er st�rre end antallet i leverancen %1.;ENU=The quantity that you are trying to invoice is greater than the quantity in shipment %1.';
      Text059@1029 : TextConst 'DAN=skal have samme fortegn som returvaremodtagelsen;ENU=must have the same sign as the return receipt';
      Text060@1041 : TextConst 'DAN=Det antal, som du fors�ger at fakturere, er st�rre end antallet p� returvarekvitteringen %1.;ENU=The quantity that you are trying to invoice is greater than the quantity in return receipt %1.';
      Text13600@1101100000 : TextConst 'DAN=Du kan ikke angive %1, hvis %2 er "%3".;ENU=You cannot enter %1 if %2 is "%3".';
      ItemChargeAssignmentErr@1097 : TextConst 'DAN=Du kan kun tildele varegebyrer til linjer af typen Gebyr (vare).;ENU=You can only assign Item Charges for Line Types of Charge (Item).';
      AnotherItemWithSameDescrQst@1049 : TextConst '@@@="%1=Item no., %2=item description";DAN=Vi har fundet en vare med beskrivelsen "%2" (nr. %1).\Ville du �ndre det aktuelle varenummer til %1?;ENU=We found an item with the description "%2" (No. %1).\Did you mean to change the current item to %1?';
      SalesLineCompletelyShippedErr@1053 : TextConst 'DAN=Du kan ikke �ndre indk�bskoden for en salgslinje, der allerede er leveret helt.;ENU=You cannot change the purchasing code for a sales line that has been completely shipped.';
      SalesSetupRead@1067 : Boolean;
      LookupRequested@1059 : Boolean;
      DeferralPostDate@1069 : Date;
      FreightLineDescriptionTxt@1033 : TextConst 'DAN=Fragtm�ngde;ENU=Freight Amount';
      CannotFindDescErr@1200 : TextConst '@@@="%1 = Type caption %2 = Description";DAN=Kan ikke finde %1 med beskrivelsen %2.\\S�rg for at bruge den korrekte type.;ENU=Cannot find %1 with Description %2.\\Make sure to use the correct type.';
      PriceDescriptionTxt@1038 : TextConst '@@@={Locked};DAN=x%1 (%2%3/%4);ENU=x%1 (%2%3/%4)';
      PriceDescriptionWithLineDiscountTxt@1066 : TextConst '@@@={Locked};DAN=x%1 (%2%3/%4) - %5%;ENU=x%1 (%2%3/%4) - %5%';
      SelectNonstockItemErr@1062 : TextConst 'DAN=Du kan kun v�lge en katalogvare til en tom linje.;ENU=You can only select a nonstock item for an empty line.';
      EstimateLbl@1072 : TextConst 'DAN=Estimat;ENU=Estimate';
      CommentLbl@1046 : TextConst 'DAN=Bem�rkning;ENU=Comment';
      LineDiscountPctErr@1073 : TextConst 'DAN=V�rdien i feltet Linjerabat % skal v�re mellem 0 og 100.;ENU=The value in the Line Discount % field must be between 0 and 100.';

    [External]
    PROCEDURE InitOutstanding@16();
    BEGIN
      IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
        "Outstanding Quantity" := Quantity - "Return Qty. Received";
        "Outstanding Qty. (Base)" := "Quantity (Base)" - "Return Qty. Received (Base)";
        "Return Qty. Rcd. Not Invd." := "Return Qty. Received" - "Quantity Invoiced";
        "Ret. Qty. Rcd. Not Invd.(Base)" := "Return Qty. Received (Base)" - "Qty. Invoiced (Base)";
      END ELSE BEGIN
        "Outstanding Quantity" := Quantity - "Quantity Shipped";
        "Outstanding Qty. (Base)" := "Quantity (Base)" - "Qty. Shipped (Base)";
        "Qty. Shipped Not Invoiced" := "Quantity Shipped" - "Quantity Invoiced";
        "Qty. Shipped Not Invd. (Base)" := "Qty. Shipped (Base)" - "Qty. Invoiced (Base)";
      END;
      UpdatePlanned;
      "Completely Shipped" := (Quantity <> 0) AND ("Outstanding Quantity" = 0);
      InitOutstandingAmount;
    END;

    [External]
    PROCEDURE InitOutstandingAmount@17();
    VAR
      AmountInclVAT@1000 : Decimal;
    BEGIN
      IF Quantity = 0 THEN BEGIN
        "Outstanding Amount" := 0;
        "Outstanding Amount (LCY)" := 0;
        "Shipped Not Invoiced" := 0;
        "Shipped Not Invoiced (LCY)" := 0;
        "Return Rcd. Not Invd." := 0;
        "Return Rcd. Not Invd. (LCY)" := 0;
      END ELSE BEGIN
        GetSalesHeader;
        AmountInclVAT := "Amount Including VAT";
        VALIDATE(
          "Outstanding Amount",
          ROUND(
            AmountInclVAT * "Outstanding Quantity" / Quantity,
            Currency."Amount Rounding Precision"));
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          VALIDATE(
            "Return Rcd. Not Invd.",
            ROUND(
              AmountInclVAT * "Return Qty. Rcd. Not Invd." / Quantity,
              Currency."Amount Rounding Precision"))
        ELSE
          VALIDATE(
            "Shipped Not Invoiced",
            ROUND(
              AmountInclVAT * "Qty. Shipped Not Invoiced" / Quantity,
              Currency."Amount Rounding Precision"));
      END;

      OnAfterInitOutstandingAmount(Rec,SalesHeader,Currency);
    END;

    [External]
    PROCEDURE InitQtyToShip@15();
    BEGIN
      GetSalesSetup;
      IF (SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Remainder) OR
         ("Document Type" = "Document Type"::Invoice)
      THEN BEGIN
        "Qty. to Ship" := "Outstanding Quantity";
        "Qty. to Ship (Base)" := "Outstanding Qty. (Base)";
      END ELSE
        IF "Qty. to Ship" <> 0 THEN
          "Qty. to Ship (Base)" := CalcBaseQty("Qty. to Ship");

      CheckServItemCreation;

      OnAfterInitQtyToShip(Rec,CurrFieldNo);

      InitQtyToInvoice;
    END;

    [External]
    PROCEDURE InitQtyToReceive@5803();
    BEGIN
      GetSalesSetup;
      IF (SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Remainder) OR
         ("Document Type" = "Document Type"::"Credit Memo")
      THEN BEGIN
        "Return Qty. to Receive" := "Outstanding Quantity";
        "Return Qty. to Receive (Base)" := "Outstanding Qty. (Base)";
      END ELSE
        IF "Return Qty. to Receive" <> 0 THEN
          "Return Qty. to Receive (Base)" := CalcBaseQty("Return Qty. to Receive");

      OnAfterInitQtyToReceive(Rec,CurrFieldNo);

      InitQtyToInvoice;
    END;

    [External]
    PROCEDURE InitQtyToInvoice@13();
    BEGIN
      "Qty. to Invoice" := MaxQtyToInvoice;
      "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
      "VAT Difference" := 0;
      CalcInvDiscToInvoice;
      IF SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice THEN
        CalcPrepaymentToDeduct;

      OnAfterInitQtyToInvoice(Rec,CurrFieldNo);
    END;

    LOCAL PROCEDURE InitItemAppl@40(OnlyApplTo@1000 : Boolean);
    BEGIN
      "Appl.-to Item Entry" := 0;
      IF NOT OnlyApplTo THEN
        "Appl.-from Item Entry" := 0;
    END;

    [External]
    PROCEDURE MaxQtyToInvoice@18() : Decimal;
    BEGIN
      IF "Prepayment Line" THEN
        EXIT(1);
      IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
        EXIT("Return Qty. Received" + "Return Qty. to Receive" - "Quantity Invoiced");

      EXIT("Quantity Shipped" + "Qty. to Ship" - "Quantity Invoiced");
    END;

    [External]
    PROCEDURE MaxQtyToInvoiceBase@19() : Decimal;
    BEGIN
      IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
        EXIT("Return Qty. Received (Base)" + "Return Qty. to Receive (Base)" - "Qty. Invoiced (Base)");

      EXIT("Qty. Shipped (Base)" + "Qty. to Ship (Base)" - "Qty. Invoiced (Base)");
    END;

    LOCAL PROCEDURE CalcBaseQty@14(Qty@1000 : Decimal) : Decimal;
    BEGIN
      TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    END;

    LOCAL PROCEDURE CopyFromStandardText@131();
    VAR
      StandardText@1000 : Record 7;
    BEGIN
      StandardText.GET("No.");
      Description := StandardText.Description;
      "Allow Item Charge Assignment" := FALSE;
      OnAfterAssignStdTxtValues(Rec,StandardText);
    END;

    LOCAL PROCEDURE CopyFromGLAccount@142();
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

    LOCAL PROCEDURE CopyFromItem@144();
    VAR
      PrepaymentMgt@1000 : Codeunit 441;
    BEGIN
      GetItem;
      Item.TESTFIELD(Blocked,FALSE);
      Item.TESTFIELD("Gen. Prod. Posting Group");
      IF Item.Type = Item.Type::Inventory THEN BEGIN
        Item.TESTFIELD("Inventory Posting Group");
        "Posting Group" := Item."Inventory Posting Group";
      END;
      Description := Item.Description;
      "Description 2" := Item."Description 2";
      GetUnitCost;
      "Allow Invoice Disc." := Item."Allow Invoice Disc.";
      "Units per Parcel" := Item."Units per Parcel";
      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
      "Tax Group Code" := Item."Tax Group Code";
      "Item Category Code" := Item."Item Category Code";
      "Product Group Code" := Item."Product Group Code";
      Nonstock := Item."Created From Nonstock Item";
      "Profit %" := Item."Profit %";
      "Allow Item Charge Assignment" := TRUE;
      PrepaymentMgt.SetSalesPrepaymentPct(Rec,SalesHeader."Posting Date");
      IF Item.Type = Item.Type::Inventory THEN
        PostingSetupMgt.CheckInvtPostingSetupInventoryAccount("Location Code","Posting Group");

      IF SalesHeader."Language Code" <> '' THEN
        GetItemTranslation;

      IF Item.Reserve = Item.Reserve::Optional THEN
        Reserve := SalesHeader.Reserve
      ELSE
        Reserve := Item.Reserve;

      "Unit of Measure Code" := Item."Sales Unit of Measure";
      InitDeferralCode;
      SetDefaultItemQuantity;
      OnAfterAssignItemValues(Rec,Item);
    END;

    LOCAL PROCEDURE CopyFromResource@146();
    BEGIN
      Res.GET("No.");
      Res.CheckResourcePrivacyBlocked(FALSE);
      Res.TESTFIELD(Blocked,FALSE);
      Res.TESTFIELD("Gen. Prod. Posting Group");
      Description := Res.Name;
      "Description 2" := Res."Name 2";
      "Unit of Measure Code" := Res."Base Unit of Measure";
      "Unit Cost (LCY)" := Res."Unit Cost";
      "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
      "Tax Group Code" := Res."Tax Group Code";
      "Allow Item Charge Assignment" := FALSE;
      FindResUnitCost;
      InitDeferralCode;
      OnAfterAssignResourceValues(Rec,Res);
    END;

    LOCAL PROCEDURE CopyFromFixedAsset@148();
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

    LOCAL PROCEDURE CopyFromItemCharge@150();
    BEGIN
      ItemCharge.GET("No.");
      Description := ItemCharge.Description;
      "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
      "Tax Group Code" := ItemCharge."Tax Group Code";
      "Allow Invoice Disc." := FALSE;
      "Allow Item Charge Assignment" := FALSE;
      OnAfterAssignItemChargeValues(Rec,ItemCharge);
    END;

    LOCAL PROCEDURE SelectItemEntry@8(CurrentFieldNo@1000 : Integer);
    VAR
      ItemLedgEntry@1001 : Record 32;
      SalesLine3@1002 : Record 37;
    BEGIN
      ItemLedgEntry.SETRANGE("Item No.","No.");
      IF "Location Code" <> '' THEN
        ItemLedgEntry.SETRANGE("Location Code","Location Code");
      ItemLedgEntry.SETRANGE("Variant Code","Variant Code");

      IF CurrentFieldNo = FIELDNO("Appl.-to Item Entry") THEN BEGIN
        ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
        ItemLedgEntry.SETRANGE(Positive,TRUE);
        ItemLedgEntry.SETRANGE(Open,TRUE);
      END ELSE BEGIN
        ItemLedgEntry.SETCURRENTKEY("Item No.",Positive);
        ItemLedgEntry.SETRANGE(Positive,FALSE);
        ItemLedgEntry.SETFILTER("Shipped Qty. Not Returned",'<0');
      END;
      IF PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
        SalesLine3 := Rec;
        IF CurrentFieldNo = FIELDNO("Appl.-to Item Entry") THEN
          SalesLine3.VALIDATE("Appl.-to Item Entry",ItemLedgEntry."Entry No.")
        ELSE
          SalesLine3.VALIDATE("Appl.-from Item Entry",ItemLedgEntry."Entry No.");
        CheckItemAvailable(CurrentFieldNo);
        Rec := SalesLine3;
      END;
    END;

    [External]
    PROCEDURE SetSalesHeader@24(NewSalesHeader@1000 : Record 36);
    BEGIN
      SalesHeader := NewSalesHeader;

      IF SalesHeader."Currency Code" = '' THEN
        Currency.InitRoundingPrecision
      ELSE BEGIN
        SalesHeader.TESTFIELD("Currency Factor");
        Currency.GET(SalesHeader."Currency Code");
        Currency.TESTFIELD("Amount Rounding Precision");
      END;
    END;

    LOCAL PROCEDURE GetSalesHeader@1();
    BEGIN
      TESTFIELD("Document No.");
      IF ("Document Type" <> SalesHeader."Document Type") OR ("Document No." <> SalesHeader."No.") THEN BEGIN
        SalesHeader.GET("Document Type","Document No.");
        IF SalesHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          SalesHeader.TESTFIELD("Currency Factor");
          Currency.GET(SalesHeader."Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
      END;
    END;

    LOCAL PROCEDURE GetItem@9();
    BEGIN
      TESTFIELD("No.");
      IF "No." <> Item."No." THEN
        Item.GET("No.");
    END;

    LOCAL PROCEDURE GetResource@49();
    BEGIN
      TESTFIELD("No.");
      IF "No." <> Resource."No." THEN
        Resource.GET("No.");
    END;

    [External]
    PROCEDURE UpdateUnitPrice@2(CalledByFieldNo@1000 : Integer);
    VAR
      Handled@1001 : Boolean;
    BEGIN
      OnBeforeUpdateUnitPrice(Rec,xRec,CalledByFieldNo,CurrFieldNo,Handled);
      IF Handled THEN
        EXIT;

      GetSalesHeader;
      TESTFIELD("Qty. per Unit of Measure");

      CASE Type OF
        Type::Item,Type::Resource:
          BEGIN
            PriceCalcMgt.FindSalesLineLineDisc(SalesHeader,Rec);
            PriceCalcMgt.FindSalesLinePrice(SalesHeader,Rec,CalledByFieldNo);
          END;
      END;
      VALIDATE("Unit Price");

      OnAfterUpdateUnitPrice(Rec,xRec,CalledByFieldNo,CurrFieldNo);
    END;

    LOCAL PROCEDURE FindResUnitCost@5();
    BEGIN
      ResCost.INIT;
      ResCost.Code := "No.";
      ResCost."Work Type Code" := "Work Type Code";
      CODEUNIT.RUN(CODEUNIT::"Resource-Find Cost",ResCost);
      VALIDATE("Unit Cost (LCY)",ResCost."Unit Cost" * "Qty. per Unit of Measure");
    END;

    [External]
    PROCEDURE UpdatePrepmtSetupFields@102();
    VAR
      GenPostingSetup@1001 : Record 252;
      GLAcc@1000 : Record 15;
    BEGIN
      IF ("Prepayment %" <> 0) AND (Type <> Type::" ") THEN BEGIN
        TESTFIELD("Document Type","Document Type"::Order);
        TESTFIELD("No.");
        IF CurrFieldNo = FIELDNO("Prepayment %") THEN
          IF "System-Created Entry" THEN
            FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text045,0));
        IF "System-Created Entry" THEN
          "Prepayment %" := 0;
        GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
        IF GenPostingSetup."Sales Prepayments Account" <> '' THEN BEGIN
          GLAcc.GET(GenPostingSetup."Sales Prepayments Account");
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

    [Internal]
    PROCEDURE UpdateAmounts@3();
    VAR
      RemLineAmountToInvoice@1000 : Decimal;
      VATBaseAmount@1003 : Decimal;
      LineAmountChanged@1002 : Boolean;
    BEGIN
      IF Type = Type::" " THEN
        EXIT;
      GetSalesHeader;
      VATBaseAmount := "VAT Base Amount";
      "Recalculate Invoice Disc." := TRUE;

      IF "Line Amount" <> xRec."Line Amount" THEN BEGIN
        "VAT Difference" := 0;
        LineAmountChanged := TRUE;
      END;
      IF "Line Amount" <> ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Discount Amount" THEN BEGIN
        "Line Amount" := ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Discount Amount";
        "VAT Difference" := 0;
        LineAmountChanged := TRUE;
      END;

      IF NOT "Prepayment Line" THEN BEGIN
        IF "Prepayment %" <> 0 THEN BEGIN
          IF Quantity < 0 THEN
            FIELDERROR(Quantity,STRSUBSTNO(Text047,FIELDCAPTION("Prepayment %")));
          IF "Unit Price" < 0 THEN
            FIELDERROR("Unit Price",STRSUBSTNO(Text047,FIELDCAPTION("Prepayment %")));
        END;
        IF SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice THEN BEGIN
          "Prepayment VAT Difference" := 0;
          IF NOT PrePaymentLineAmountEntered THEN
            "Prepmt. Line Amount" := ROUND("Line Amount" * "Prepayment %" / 100,Currency."Amount Rounding Precision");
          IF "Prepmt. Line Amount" < "Prepmt. Amt. Inv." THEN
            FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text049,"Prepmt. Amt. Inv."));
          PrePaymentLineAmountEntered := FALSE;
          IF "Prepmt. Line Amount" <> 0 THEN BEGIN
            RemLineAmountToInvoice :=
              ROUND("Line Amount" * (Quantity - "Quantity Invoiced") / Quantity,Currency."Amount Rounding Precision");
            IF RemLineAmountToInvoice < ("Prepmt. Line Amount" - "Prepmt Amt Deducted") THEN
              FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text045,RemLineAmountToInvoice + "Prepmt Amt Deducted"));
          END;
        END ELSE
          IF (CurrFieldNo <> 0) AND ("Line Amount" <> xRec."Line Amount") AND
             ("Prepmt. Amt. Inv." <> 0) AND ("Prepayment %" = 100)
          THEN BEGIN
            IF "Line Amount" < xRec."Line Amount" THEN
              FIELDERROR("Line Amount",STRSUBSTNO(Text044,xRec."Line Amount"));
            FIELDERROR("Line Amount",STRSUBSTNO(Text045,xRec."Line Amount"));
          END;
      END;

      OnAfterUpdateAmounts(Rec);

      UpdateVATAmounts;
      InitOutstandingAmount;
      IF (CurrFieldNo <> 0) AND
         NOT ((Type = Type::Item) AND (CurrFieldNo = FIELDNO("No.")) AND (Quantity <> 0) AND
              // a write transaction may have been started
              ("Qty. per Unit of Measure" <> xRec."Qty. per Unit of Measure")) AND // ...continued condition
         ("Document Type" <= "Document Type"::Invoice) AND
         (("Outstanding Amount" + "Shipped Not Invoiced") > 0) AND
         (CurrFieldNo <> FIELDNO("Blanket Order No.")) AND
         (CurrFieldNo <> FIELDNO("Blanket Order Line No."))
      THEN
        CustCheckCreditLimit.SalesLineCheck(Rec);

      IF Type = Type::"Charge (Item)" THEN
        UpdateItemChargeAssgnt;

      CalcPrepaymentToDeduct;
      IF VATBaseAmount <> "VAT Base Amount" THEN
        LineAmountChanged := TRUE;

      IF LineAmountChanged THEN BEGIN
        UpdateDeferralAmounts;
        LineAmountChanged := FALSE;
      END;

      OnAfterUpdateAmountsDone(Rec,xRec,CurrFieldNo);
    END;

    LOCAL PROCEDURE UpdateVATAmounts@38();
    VAR
      SalesLine2@1000 : Record 37;
      TotalLineAmount@1005 : Decimal;
      TotalInvDiscAmount@1004 : Decimal;
      TotalAmount@1001 : Decimal;
      TotalAmountInclVAT@1002 : Decimal;
      TotalQuantityBase@1003 : Decimal;
    BEGIN
      GetSalesHeader;
      SalesLine2.SETRANGE("Document Type","Document Type");
      SalesLine2.SETRANGE("Document No.","Document No.");
      SalesLine2.SETFILTER("Line No.",'<>%1',"Line No.");
      IF "Line Amount" = 0 THEN
        IF xRec."Line Amount" >= 0 THEN
          SalesLine2.SETFILTER(Amount,'>%1',0)
        ELSE
          SalesLine2.SETFILTER(Amount,'<%1',0)
      ELSE
        IF "Line Amount" > 0 THEN
          SalesLine2.SETFILTER(Amount,'>%1',0)
        ELSE
          SalesLine2.SETFILTER(Amount,'<%1',0);
      SalesLine2.SETRANGE("VAT Identifier","VAT Identifier");
      SalesLine2.SETRANGE("Tax Group Code","Tax Group Code");

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
          IF NOT SalesLine2.ISEMPTY THEN BEGIN
            SalesLine2.CALCSUMS("Line Amount","Inv. Discount Amount",Amount,"Amount Including VAT","Quantity (Base)");
            TotalLineAmount := SalesLine2."Line Amount";
            TotalInvDiscAmount := SalesLine2."Inv. Discount Amount";
            TotalAmount := SalesLine2.Amount;
            TotalAmountInclVAT := SalesLine2."Amount Including VAT";
            TotalQuantityBase := SalesLine2."Quantity (Base)";
          END;

        IF SalesHeader."Prices Including VAT" THEN
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
                    Amount * (1 - SalesHeader."VAT Base Discount %" / 100),
                    Currency."Amount Rounding Precision");
                "Amount Including VAT" :=
                  TotalLineAmount + "Line Amount" -
                  ROUND(
                    (TotalAmount + Amount) * (SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
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
                SalesHeader.TESTFIELD("VAT Base Discount %",0);
                Amount :=
                  SalesTaxCalculate.ReverseCalculateTax(
                    "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                    TotalAmountInclVAT + "Amount Including VAT",TotalQuantityBase + "Quantity (Base)",
                    SalesHeader."Currency Factor") -
                  TotalAmount;
                IF Amount <> 0 THEN
                  "VAT %" :=
                    ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                ELSE
                  "VAT %" := 0;
                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                "VAT Base Amount" := Amount;
              END;
          END
        ELSE
          CASE "VAT Calculation Type" OF
            "VAT Calculation Type"::"Normal VAT",
            "VAT Calculation Type"::"Reverse Charge VAT":
              BEGIN
                Amount := ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision");
                "VAT Base Amount" :=
                  ROUND(Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                "Amount Including VAT" :=
                  TotalAmount + Amount +
                  ROUND(
                    (TotalAmount + Amount) * (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
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
                "Amount Including VAT" :=
                  TotalAmount + Amount +
                  ROUND(
                    SalesTaxCalculate.CalculateTax(
                      "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                      TotalAmount + Amount,TotalQuantityBase + "Quantity (Base)",
                      SalesHeader."Currency Factor"),Currency."Amount Rounding Precision") -
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
    PROCEDURE CheckItemAvailable@4(CalledByFieldNo@1000 : Integer);
    BEGIN
      IF Reserve = Reserve::Always THEN
        EXIT;

      IF "Shipment Date" = 0D THEN BEGIN
        GetSalesHeader;
        IF SalesHeader."Shipment Date" <> 0D THEN
          VALIDATE("Shipment Date",SalesHeader."Shipment Date")
        ELSE
          VALIDATE("Shipment Date",WORKDATE);
      END;

      IF ((CalledByFieldNo = CurrFieldNo) OR (CalledByFieldNo = FIELDNO("Shipment Date"))) AND GUIALLOWED AND
         ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) AND
         (Type = Type::Item) AND ("No." <> '') AND
         ("Outstanding Quantity" > 0) AND
         ("Job Contract Entry No." = 0) AND
         NOT "Special Order"
      THEN BEGIN
        IF ItemCheckAvail.SalesLineCheck(Rec) THEN
          ItemCheckAvail.RaiseUpdateInterruptedError;
      END;
    END;

    [External]
    PROCEDURE ShowReservation@10();
    VAR
      Reservation@1000 : Page 498;
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      TESTFIELD(Reserve);
      CLEAR(Reservation);
      Reservation.SetSalesLine(Rec);
      Reservation.RUNMODAL;
      UpdatePlanned;
    END;

    [External]
    PROCEDURE ShowReservationEntries@21(Modal@1000 : Boolean);
    VAR
      ReservEntry@1001 : Record 337;
      ReservEngineMgt@1002 : Codeunit 99000831;
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
      ReserveSalesLine.FilterReservFor(ReservEntry,Rec);
      IF Modal THEN
        PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
      ELSE
        PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    END;

    [External]
    PROCEDURE AutoReserve@11();
    VAR
      ReservMgt@1002 : Codeunit 99000845;
      QtyToReserve@1000 : Decimal;
      QtyToReserveBase@1001 : Decimal;
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");

      ReserveSalesLine.ReservQuantity(Rec,QtyToReserve,QtyToReserveBase);
      IF QtyToReserveBase <> 0 THEN BEGIN
        ReservMgt.SetSalesLine(Rec);
        TESTFIELD("Shipment Date");
        ReservMgt.AutoReserve(FullAutoReservation,'',"Shipment Date",QtyToReserve,QtyToReserveBase);
        FIND;
        IF NOT FullAutoReservation THEN BEGIN
          COMMIT;
          IF CONFIRM(Text011,TRUE) THEN BEGIN
            ShowReservation;
            FIND;
          END;
        END;
      END;
    END;

    [External]
    PROCEDURE AutoAsmToOrder@82();
    BEGIN
      ATOLink.UpdateAsmFromSalesLine(Rec);
    END;

    LOCAL PROCEDURE GetDate@22() : Date;
    BEGIN
      IF SalesHeader."Posting Date" <> 0D THEN
        EXIT(SalesHeader."Posting Date");
      EXIT(WORKDATE);
    END;

    [External]
    PROCEDURE CalcPlannedDeliveryDate@92(CurrFieldNo@1000 : Integer) : Date;
    BEGIN
      IF "Shipment Date" = 0D THEN
        EXIT("Planned Delivery Date");

      CASE CurrFieldNo OF
        FIELDNO("Shipment Date"):
          EXIT(CalendarMgmt.CalcDateBOC(
              FORMAT("Shipping Time"),
              "Planned Shipment Date",
              CalChange."Source Type"::"Shipping Agent",
              "Shipping Agent Code",
              "Shipping Agent Service Code",
              CalChange."Source Type"::Customer,
              "Sell-to Customer No.",
              '',
              TRUE));
        FIELDNO("Planned Delivery Date"):
          EXIT(CalendarMgmt.CalcDateBOC2(
              FORMAT("Shipping Time"),
              "Planned Delivery Date",
              CalChange."Source Type"::Customer,
              "Sell-to Customer No.",
              '',
              CalChange."Source Type"::"Shipping Agent",
              "Shipping Agent Code",
              "Shipping Agent Service Code",
              TRUE))
      END;
    END;

    [External]
    PROCEDURE CalcPlannedShptDate@93(CurrFieldNo@1000 : Integer) : Date;
    BEGIN
      IF "Shipment Date" = 0D THEN
        EXIT("Planned Shipment Date");

      CASE CurrFieldNo OF
        FIELDNO("Shipment Date"):
          EXIT(CalendarMgmt.CalcDateBOC(
              FORMAT("Outbound Whse. Handling Time"),
              "Shipment Date",
              CalChange."Source Type"::Location,
              "Location Code",
              '',
              CalChange."Source Type"::"Shipping Agent",
              "Shipping Agent Code",
              "Shipping Agent Service Code",
              TRUE));
        FIELDNO("Planned Delivery Date"):
          EXIT(CalendarMgmt.CalcDateBOC(
              FORMAT(''),
              "Planned Delivery Date",
              CalChange."Source Type"::Customer,
              "Sell-to Customer No.",
              '',
              CalChange."Source Type"::"Shipping Agent",
              "Shipping Agent Code",
              "Shipping Agent Service Code",
              TRUE));
      END;
    END;

    [External]
    PROCEDURE CalcShipmentDate@111() : Date;
    BEGIN
      IF "Planned Shipment Date" = 0D THEN
        EXIT("Shipment Date");

      IF FORMAT("Outbound Whse. Handling Time") <> '' THEN
        EXIT(
          CalendarMgmt.CalcDateBOC2(
            FORMAT("Outbound Whse. Handling Time"),
            "Planned Shipment Date",
            CalChange."Source Type"::Location,
            "Location Code",
            '',
            CalChange."Source Type"::"Shipping Agent",
            "Shipping Agent Code",
            "Shipping Agent Service Code",
            FALSE));

      EXIT(
        CalendarMgmt.CalcDateBOC(
          FORMAT(FORMAT('')),
          "Planned Shipment Date",
          CalChange."Source Type"::"Shipping Agent",
          "Shipping Agent Code",
          "Shipping Agent Service Code",
          CalChange."Source Type"::Location,
          "Location Code",
          '',
          FALSE));
    END;

    [External]
    PROCEDURE SignedXX@20(Value@1000 : Decimal) : Decimal;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Quote,
        "Document Type"::Order,
        "Document Type"::Invoice,
        "Document Type"::"Blanket Order":
          EXIT(-Value);
        "Document Type"::"Return Order",
        "Document Type"::"Credit Memo":
          EXIT(Value);
      END;
    END;

    LOCAL PROCEDURE BlanketOrderLookup@23();
    BEGIN
      SalesLine2.RESET;
      SalesLine2.SETCURRENTKEY("Document Type",Type,"No.");
      SalesLine2.SETRANGE("Document Type","Document Type"::"Blanket Order");
      SalesLine2.SETRANGE(Type,Type);
      SalesLine2.SETRANGE("No.","No.");
      SalesLine2.SETRANGE("Bill-to Customer No.","Bill-to Customer No.");
      SalesLine2.SETRANGE("Sell-to Customer No.","Sell-to Customer No.");
      IF PAGE.RUNMODAL(PAGE::"Sales Lines",SalesLine2) = ACTION::LookupOK THEN BEGIN
        SalesLine2.TESTFIELD("Document Type","Document Type"::"Blanket Order");
        "Blanket Order No." := SalesLine2."Document No.";
        VALIDATE("Blanket Order Line No.",SalesLine2."Line No.");
      END;
    END;

    [External]
    PROCEDURE ShowDimensions@25();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Document Type","Document No.","Line No."));
      VerifyItemLineDim;
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      ATOLink.UpdateAsmDimFromSalesLine(Rec);
    END;

    [External]
    PROCEDURE OpenItemTrackingLines@6500();
    VAR
      Job@1000 : Record 167;
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      TESTFIELD("Quantity (Base)");
      IF "Job Contract Entry No." <> 0 THEN
        ERROR(Text048,TABLECAPTION,Job.TABLECAPTION);
      ReserveSalesLine.CallItemTracking(Rec);
    END;

    [External]
    PROCEDURE CreateDim@26(Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20]);
    VAR
      SourceCodeSetup@1006 : Record 242;
      TableID@1007 : ARRAY [10] OF Integer;
      No@1008 : ARRAY [10] OF Code[20];
    BEGIN
      SourceCodeSetup.GET;
      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      TableID[3] := Type3;
      No[3] := No3;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      GetSalesHeader;
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup.Sales,
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",SalesHeader."Dimension Set ID",DATABASE::Customer);
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      ATOLink.UpdateAsmDimFromSalesLine(Rec);
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
      VerifyItemLineDim;
    END;

    [External]
    PROCEDURE LookupShortcutDimCode@28(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
    END;

    [External]
    PROCEDURE ShowShortcutDimCode@27(VAR ShortcutDimCode@1000 : ARRAY [8] OF Code[20]);
    BEGIN
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    END;

    PROCEDURE ShowItemSub@30();
    BEGIN
      CLEAR(SalesHeader);
      TestStatusOpen;
      ItemSubstitutionMgt.ItemSubstGet(Rec);
      IF TransferExtendedText.SalesCheckIfAnyExtText(Rec,TRUE) THEN
        TransferExtendedText.InsertSalesExtText(Rec);

      OnAfterShowItemSub(Rec);
    END;

    [External]
    PROCEDURE ShowNonstock@32();
    BEGIN
      TESTFIELD(Type,Type::Item);
      IF "No." <> '' THEN
        ERROR(SelectNonstockItemErr);
      IF PAGE.RUNMODAL(PAGE::"Nonstock Item List",NonstockItem) = ACTION::LookupOK THEN BEGIN
        NonstockItem.TESTFIELD("Item Template Code");
        ConfigTemplateHeader.SETRANGE(Code,NonstockItem."Item Template Code");
        ConfigTemplateHeader.FINDFIRST;
        TempItemTemplate.InitializeTempRecordFromConfigTemplate(TempItemTemplate,ConfigTemplateHeader);
        TempItemTemplate.TESTFIELD("Gen. Prod. Posting Group");
        TempItemTemplate.TESTFIELD("Inventory Posting Group");

        "No." := NonstockItem."Entry No.";
        NonstockItemMgt.NonStockSales(Rec);
        VALIDATE("No.","No.");
        VALIDATE("Unit Price",NonstockItem."Unit Price");
      END;
    END;

    LOCAL PROCEDURE GetSalesSetup@100();
    BEGIN
      IF NOT SalesSetupRead THEN
        SalesSetup.GET;
      SalesSetupRead := TRUE;
    END;

    LOCAL PROCEDURE GetFAPostingGroup@6();
    VAR
      LocalGLAcc@1000 : Record 15;
      FASetup@1001 : Record 5603;
      FAPostingGr@1002 : Record 5606;
      FADeprBook@1003 : Record 5612;
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
      FADeprBook.GET("No.","Depreciation Book Code");
      FADeprBook.TESTFIELD("FA Posting Group");
      FAPostingGr.GET(FADeprBook."FA Posting Group");
      LocalGLAcc.GET(FAPostingGr.GetAcquisitionCostAccountOnDisposal);
      LocalGLAcc.CheckGLAcc;
      LocalGLAcc.TESTFIELD("Gen. Prod. Posting Group");
      "Posting Group" := FADeprBook."FA Posting Group";
      "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
      "Tax Group Code" := LocalGLAcc."Tax Group Code";
      VALIDATE("VAT Prod. Posting Group",LocalGLAcc."VAT Prod. Posting Group");
    END;

    LOCAL PROCEDURE GetFieldCaption@31(FieldNumber@1000 : Integer) : Text[100];
    VAR
      Field@1001 : Record 2000000041;
    BEGIN
      Field.GET(DATABASE::"Sales Line",FieldNumber);
      EXIT(Field."Field Caption");
    END;

    [External]
    PROCEDURE GetCaptionClass@34(FieldNumber@1000 : Integer) : Text[80];
    VAR
      SalesHeader2@1565 : Record 36;
    BEGIN
      IF SalesHeader2.GET("Document Type","Document No.") THEN;
      CASE FieldNumber OF
        FIELDNO("No."):
          EXIT(STRSUBSTNO('3,%1',GetFieldCaption(FieldNumber)));
        ELSE BEGIN
          IF SalesHeader2."Prices Including VAT" THEN
            EXIT('2,1,' + GetFieldCaption(FieldNumber));
          EXIT('2,0,' + GetFieldCaption(FieldNumber));
        END;
      END;
    END;

    LOCAL PROCEDURE GetSKU@5806() : Boolean;
    BEGIN
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
    PROCEDURE GetUnitCost@5808();
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      GetItem;
      "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
      IF GetSKU THEN
        VALIDATE("Unit Cost (LCY)",SKU."Unit Cost" * "Qty. per Unit of Measure")
      ELSE
        VALIDATE("Unit Cost (LCY)",Item."Unit Cost" * "Qty. per Unit of Measure");
    END;

    LOCAL PROCEDURE CalcUnitCost@5809(ItemLedgEntry@1000 : Record 32) : Decimal;
    VAR
      ValueEntry@1001 : Record 5802;
      UnitCost@1004 : Decimal;
    BEGIN
      WITH ValueEntry DO BEGIN
        SETCURRENTKEY("Item Ledger Entry No.");
        SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
        IF IsServiceItem THEN BEGIN
          CALCSUMS("Cost Amount (Non-Invtbl.)");
          UnitCost := "Cost Amount (Non-Invtbl.)" / ItemLedgEntry.Quantity;
        END ELSE BEGIN
          CALCSUMS("Cost Amount (Actual)","Cost Amount (Expected)");
          UnitCost :=
            ("Cost Amount (Expected)" + "Cost Amount (Actual)") / ItemLedgEntry.Quantity;
        END;
      END;

      EXIT(ABS(UnitCost * "Qty. per Unit of Measure"));
    END;

    [External]
    PROCEDURE ShowItemChargeAssgnt@5801();
    VAR
      ItemChargeAssgntSales@1003 : Record 5809;
      AssignItemChargeSales@1001 : Codeunit 5807;
      ItemChargeAssgnts@1000 : Page 5814;
      ItemChargeAssgntLineAmt@1002 : Decimal;
    BEGIN
      GET("Document Type","Document No.","Line No.");
      TESTFIELD("No.");
      TESTFIELD(Quantity);

      IF Type <> Type::"Charge (Item)" THEN
        ERROR(ItemChargeAssignmentErr);

      GetSalesHeader;
      IF SalesHeader."Currency Code" = '' THEN
        Currency.InitRoundingPrecision
      ELSE
        Currency.GET(SalesHeader."Currency Code");
      IF ("Inv. Discount Amount" = 0) AND
         ("Line Discount Amount" = 0) AND
         (NOT SalesHeader."Prices Including VAT")
      THEN
        ItemChargeAssgntLineAmt := "Line Amount"
      ELSE
        IF SalesHeader."Prices Including VAT" THEN
          ItemChargeAssgntLineAmt :=
            ROUND(("Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
              Currency."Amount Rounding Precision")
        ELSE
          ItemChargeAssgntLineAmt := "Line Amount" - "Inv. Discount Amount";

      ItemChargeAssgntSales.RESET;
      ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
      ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
      ItemChargeAssgntSales.SETRANGE("Document Line No.","Line No.");
      ItemChargeAssgntSales.SETRANGE("Item Charge No.","No.");
      IF NOT ItemChargeAssgntSales.FINDLAST THEN BEGIN
        ItemChargeAssgntSales."Document Type" := "Document Type";
        ItemChargeAssgntSales."Document No." := "Document No.";
        ItemChargeAssgntSales."Document Line No." := "Line No.";
        ItemChargeAssgntSales."Item Charge No." := "No.";
        ItemChargeAssgntSales."Unit Cost" :=
          ROUND(ItemChargeAssgntLineAmt / Quantity,
            Currency."Unit-Amount Rounding Precision");
      END;

      ItemChargeAssgntLineAmt :=
        ROUND(
          ItemChargeAssgntLineAmt * ("Qty. to Invoice" / Quantity),
          Currency."Amount Rounding Precision");

      IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
        AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales,"Return Receipt No.")
      ELSE
        AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales,"Shipment No.");
      CLEAR(AssignItemChargeSales);
      COMMIT;

      ItemChargeAssgnts.Initialize(Rec,ItemChargeAssgntLineAmt);
      ItemChargeAssgnts.RUNMODAL;
      CALCFIELDS("Qty. to Assign");
    END;

    [External]
    PROCEDURE UpdateItemChargeAssgnt@5807();
    VAR
      ItemChargeAssgntSales@1003 : Record 5809;
      ShareOfVAT@1000 : Decimal;
      TotalQtyToAssign@1001 : Decimal;
      TotalAmtToAssign@1002 : Decimal;
    BEGIN
      IF "Document Type" = "Document Type"::"Blanket Order" THEN
        EXIT;

      CALCFIELDS("Qty. Assigned","Qty. to Assign");
      IF ABS("Quantity Invoiced") > ABS(("Qty. Assigned" + "Qty. to Assign")) THEN
        ERROR(Text055,FIELDCAPTION("Quantity Invoiced"),FIELDCAPTION("Qty. Assigned"),FIELDCAPTION("Qty. to Assign"));

      ItemChargeAssgntSales.RESET;
      ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
      ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
      ItemChargeAssgntSales.SETRANGE("Document Line No.","Line No.");
      ItemChargeAssgntSales.CALCSUMS("Qty. to Assign");
      TotalQtyToAssign := ItemChargeAssgntSales."Qty. to Assign";
      IF (CurrFieldNo <> 0) AND (Amount <> xRec.Amount) AND
         NOT ((Quantity <> xRec.Quantity) AND (TotalQtyToAssign = 0))
      THEN BEGIN
        ItemChargeAssgntSales.SETFILTER("Qty. Assigned",'<>0');
        IF NOT ItemChargeAssgntSales.ISEMPTY THEN
          ERROR(Text026,
            FIELDCAPTION(Amount));
        ItemChargeAssgntSales.SETRANGE("Qty. Assigned");
      END;

      IF ItemChargeAssgntSales.FINDSET(TRUE) THEN BEGIN
        GetSalesHeader;
        TotalAmtToAssign := CalcTotalAmtToAssign(TotalQtyToAssign);
        REPEAT
          ShareOfVAT := 1;
          IF SalesHeader."Prices Including VAT" THEN
            ShareOfVAT := 1 + "VAT %" / 100;
          IF Quantity <> 0 THEN
            IF ItemChargeAssgntSales."Unit Cost" <> ROUND(
                 ("Line Amount" - "Inv. Discount Amount") / Quantity / ShareOfVAT,
                 Currency."Unit-Amount Rounding Precision")
            THEN
              ItemChargeAssgntSales."Unit Cost" :=
                ROUND(("Line Amount" - "Inv. Discount Amount") / Quantity / ShareOfVAT,
                  Currency."Unit-Amount Rounding Precision");
          IF TotalQtyToAssign <> 0 THEN BEGIN
            ItemChargeAssgntSales."Amount to Assign" :=
              ROUND(ItemChargeAssgntSales."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                Currency."Amount Rounding Precision");
            TotalQtyToAssign -= ItemChargeAssgntSales."Qty. to Assign";
            TotalAmtToAssign -= ItemChargeAssgntSales."Amount to Assign";
          END;
          ItemChargeAssgntSales.MODIFY;
        UNTIL ItemChargeAssgntSales.NEXT = 0;
        CALCFIELDS("Qty. to Assign");
      END;
    END;

    LOCAL PROCEDURE DeleteItemChargeAssgnt@5802(DocType@1000 : Option;DocNo@1001 : Code[20];DocLineNo@1002 : Integer);
    VAR
      ItemChargeAssgntSales@1003 : Record 5809;
    BEGIN
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type",DocType);
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.",DocNo);
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.",DocLineNo);
      IF NOT ItemChargeAssgntSales.ISEMPTY THEN
        ItemChargeAssgntSales.DELETEALL(TRUE);
    END;

    LOCAL PROCEDURE DeleteChargeChargeAssgnt@5804(DocType@1000 : Option;DocNo@1001 : Code[20];DocLineNo@1002 : Integer);
    VAR
      ItemChargeAssgntSales@1003 : Record 5809;
    BEGIN
      IF DocType <> "Document Type"::"Blanket Order" THEN
        IF "Quantity Invoiced" <> 0 THEN BEGIN
          CALCFIELDS("Qty. Assigned");
          TESTFIELD("Qty. Assigned","Quantity Invoiced");
        END;

      ItemChargeAssgntSales.RESET;
      ItemChargeAssgntSales.SETRANGE("Document Type",DocType);
      ItemChargeAssgntSales.SETRANGE("Document No.",DocNo);
      ItemChargeAssgntSales.SETRANGE("Document Line No.",DocLineNo);
      IF NOT ItemChargeAssgntSales.ISEMPTY THEN
        ItemChargeAssgntSales.DELETEALL;
    END;

    LOCAL PROCEDURE CheckItemChargeAssgnt@5800();
    VAR
      ItemChargeAssgntSales@1000 : Record 5809;
    BEGIN
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type","Document Type");
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.","Document No.");
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.","Line No.");
      ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
      ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
      IF ItemChargeAssgntSales.FINDSET THEN BEGIN
        TESTFIELD("Allow Item Charge Assignment");
        REPEAT
          ItemChargeAssgntSales.TESTFIELD("Qty. to Assign",0);
        UNTIL ItemChargeAssgntSales.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE TestStatusOpen@33();
    BEGIN
      IF StatusCheckSuspended THEN
        EXIT;
      GetSalesHeader;
      IF NOT "System-Created Entry" THEN
        IF HasTypeToFillMandatoryFields THEN
          SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);

      OnAfterTestStatusOpen(Rec,SalesHeader);
    END;

    [External]
    PROCEDURE SuspendStatusCheck@39(Suspend@1000 : Boolean);
    BEGIN
      StatusCheckSuspended := Suspend;
    END;

    [External]
    PROCEDURE UpdateVATOnLines@36(QtyType@1000 : 'General,Invoicing,Shipping';VAR SalesHeader@1001 : Record 36;VAR SalesLine@1002 : Record 37;VAR VATAmountLine@1003 : Record 290) LineWasModified : Boolean;
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
      IF SalesHeader."Currency Code" = '' THEN
        Currency.InitRoundingPrecision
      ELSE
        Currency.GET(SalesHeader."Currency Code");

      TempVATAmountLineRemainder.DELETEALL;
      WITH SalesLine DO BEGIN
        SETRANGE("Document Type",SalesHeader."Document Type");
        SETRANGE("Document No.",SalesHeader."No.");
        LOCKTABLE;
        IF FINDSET THEN
          REPEAT
            IF NOT ZeroAmountLine(QtyType) THEN BEGIN
              DeferralAmount := GetDeferralAmount;
              VATAmountLine.GET("VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0);
              IF VATAmountLine.Modified THEN BEGIN
                IF NOT TempVATAmountLineRemainder.GET(
                     "VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0)
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
                  IF SalesHeader."Prices Including VAT" THEN BEGIN
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
                        NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),
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
                          NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),
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
                IF QtyType = QtyType::General THEN
                  UpdateBaseAmounts(NewAmount,ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision"),NewVATBaseAmount);
                InitOutstanding;
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

      OnAfterUpdateVATOnLines(SalesHeader,SalesLine,VATAmountLine,QtyType);
    END;

    [External]
    PROCEDURE CalcVATAmountLines@35(QtyType@1000 : 'General,Invoicing,Shipping';VAR SalesHeader@1001 : Record 36;VAR SalesLine@1002 : Record 37;VAR VATAmountLine@1003 : Record 290);
    VAR
      TotalVATAmount@1011 : Decimal;
      QtyToHandle@1006 : Decimal;
      AmtToHandle@1015 : Decimal;
      RoundingLineInserted@1010 : Boolean;
    BEGIN
      Currency.Initialize(SalesHeader."Currency Code");

      VATAmountLine.DELETEALL;

      WITH SalesLine DO BEGIN
        SETRANGE("Document Type",SalesHeader."Document Type");
        SETRANGE("Document No.",SalesHeader."No.");
        IF FINDSET THEN
          REPEAT
            IF NOT ZeroAmountLine(QtyType) THEN BEGIN
              IF (Type = Type::"G/L Account") AND NOT "Prepayment Line" THEN
                RoundingLineInserted := ("No." = GetCPGInvRoundAcc(SalesHeader)) OR RoundingLineInserted;
              IF "VAT Calculation Type" IN
                 ["VAT Calculation Type"::"Reverse Charge VAT","VAT Calculation Type"::"Sales Tax"]
              THEN
                "VAT %" := 0;
              IF NOT VATAmountLine.GET(
                   "VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0)
              THEN
                VATAmountLine.InsertNewLine(
                  "VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"VAT %","Line Amount" >= 0,FALSE);

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
                      (NOT SalesHeader.Ship) AND SalesHeader.Invoice AND (NOT "Prepayment Line"):
                        IF "Shipment No." = '' THEN BEGIN
                          QtyToHandle := GetAbsMin("Qty. to Invoice","Qty. Shipped Not Invoiced");
                          VATAmountLine.Quantity += GetAbsMin("Qty. to Invoice (Base)","Qty. Shipped Not Invd. (Base)");
                        END ELSE BEGIN
                          QtyToHandle := "Qty. to Invoice";
                          VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                        END;
                      ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
                      (NOT SalesHeader.Receive) AND SalesHeader.Invoice:
                        IF "Return Receipt No." = '' THEN BEGIN
                          QtyToHandle := GetAbsMin("Qty. to Invoice","Return Qty. Rcd. Not Invd.");
                          VATAmountLine.Quantity += GetAbsMin("Qty. to Invoice (Base)","Ret. Qty. Rcd. Not Invd.(Base)");
                        END ELSE BEGIN
                          QtyToHandle := "Qty. to Invoice";
                          VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                        END;
                      ELSE
                        BEGIN
                        QtyToHandle := "Qty. to Invoice";
                        VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                      END;
                    END;
                    AmtToHandle := GetLineAmountToHandle(QtyToHandle);
                    IF SalesHeader."Invoice Discount Calculation" <> SalesHeader."Invoice Discount Calculation"::Amount THEN
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
                      QtyToHandle := "Return Qty. to Receive";
                      VATAmountLine.Quantity += "Return Qty. to Receive (Base)";
                    END ELSE BEGIN
                      QtyToHandle := "Qty. to Ship";
                      VATAmountLine.Quantity += "Qty. to Ship (Base)";
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
        TotalVATAmount,Currency,SalesHeader."Currency Factor",SalesHeader."Prices Including VAT",
        SalesHeader."VAT Base Discount %",SalesHeader."Tax Area Code",SalesHeader."Tax Liable",SalesHeader."Posting Date");

      IF RoundingLineInserted AND (TotalVATAmount <> 0) THEN
        IF VATAmountLine.GET(SalesLine."VAT Identifier",SalesLine."VAT Calculation Type",
             SalesLine."Tax Group Code",FALSE,SalesLine."Line Amount" >= 0)
        THEN BEGIN
          VATAmountLine."VAT Amount" += TotalVATAmount;
          VATAmountLine."Amount Including VAT" += TotalVATAmount;
          VATAmountLine."Calculated VAT Amount" += TotalVATAmount;
          VATAmountLine.MODIFY;
        END;

      OnAfterCalcVATAmountLines(SalesHeader,SalesLine,VATAmountLine,QtyType);
    END;

    [External]
    PROCEDURE GetCPGInvRoundAcc@71(VAR SalesHeader@1000 : Record 36) : Code[20];
    VAR
      Cust@1002 : Record 18;
      CustTemplate@1003 : Record 5105;
      CustPostingGroup@1004 : Record 92;
    BEGIN
      GetSalesSetup;
      IF SalesSetup."Invoice Rounding" THEN
        IF Cust.GET(SalesHeader."Bill-to Customer No.") THEN
          CustPostingGroup.GET(Cust."Customer Posting Group")
        ELSE
          IF CustTemplate.GET(SalesHeader."Sell-to Customer Template Code") THEN
            CustPostingGroup.GET(CustTemplate."Customer Posting Group");

      EXIT(CustPostingGroup."Invoice Rounding Account");
    END;

    LOCAL PROCEDURE CalcInvDiscToInvoice@37();
    VAR
      OldInvDiscAmtToInv@1000 : Decimal;
    BEGIN
      GetSalesHeader;
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

    [External]
    PROCEDURE UpdateWithWarehouseShip@41();
    BEGIN
      IF Type = Type::Item THEN
        CASE TRUE OF
          ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND (Quantity >= 0):
            IF Location.RequireShipment("Location Code") THEN
              VALIDATE("Qty. to Ship",0)
            ELSE
              VALIDATE("Qty. to Ship","Outstanding Quantity");
          ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND (Quantity < 0):
            IF Location.RequireReceive("Location Code") THEN
              VALIDATE("Qty. to Ship",0)
            ELSE
              VALIDATE("Qty. to Ship","Outstanding Quantity");
          ("Document Type" = "Document Type"::"Return Order") AND (Quantity >= 0):
            IF Location.RequireReceive("Location Code") THEN
              VALIDATE("Return Qty. to Receive",0)
            ELSE
              VALIDATE("Return Qty. to Receive","Outstanding Quantity");
          ("Document Type" = "Document Type"::"Return Order") AND (Quantity < 0):
            IF Location.RequireShipment("Location Code") THEN
              VALIDATE("Return Qty. to Receive",0)
            ELSE
              VALIDATE("Return Qty. to Receive","Outstanding Quantity");
        END;
      SetDefaultQuantity;
    END;

    LOCAL PROCEDURE CheckWarehouse@46();
    VAR
      Location2@1002 : Record 14;
      WhseSetup@1000 : Record 5769;
      ShowDialog@1001 : ' ,Message,Error';
      DialogText@1003 : Text[50];
    BEGIN
      GetLocation("Location Code");
      IF "Location Code" = '' THEN BEGIN
        WhseSetup.GET;
        Location2."Require Shipment" := WhseSetup."Require Shipment";
        Location2."Require Pick" := WhseSetup."Require Pick";
        Location2."Require Receive" := WhseSetup."Require Receive";
        Location2."Require Put-away" := WhseSetup."Require Put-away";
      END ELSE
        Location2 := Location;

      DialogText := Text035;
      IF ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"]) AND
         Location2."Directed Put-away and Pick"
      THEN BEGIN
        ShowDialog := ShowDialog::Error;
        IF (("Document Type" = "Document Type"::Order) AND (Quantity >= 0)) OR
           (("Document Type" = "Document Type"::"Return Order") AND (Quantity < 0))
        THEN
          DialogText :=
            DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Shipment"))
        ELSE
          DialogText :=
            DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Receive"));
      END ELSE BEGIN
        IF (("Document Type" = "Document Type"::Order) AND (Quantity >= 0) AND
            (Location2."Require Shipment" OR Location2."Require Pick")) OR
           (("Document Type" = "Document Type"::"Return Order") AND (Quantity < 0) AND
            (Location2."Require Shipment" OR Location2."Require Pick"))
        THEN BEGIN
          IF WhseValidateSourceLine.WhseLinesExist(
               DATABASE::"Sales Line",
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
            DialogText := Text036;
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Pick"));
          END;
        END;

        IF (("Document Type" = "Document Type"::Order) AND (Quantity < 0) AND
            (Location2."Require Receive" OR Location2."Require Put-away")) OR
           (("Document Type" = "Document Type"::"Return Order") AND (Quantity >= 0) AND
            (Location2."Require Receive" OR Location2."Require Put-away"))
        THEN BEGIN
          IF WhseValidateSourceLine.WhseLinesExist(
               DATABASE::"Sales Line",
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
            DialogText := Text036;
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Put-away"));
          END;
        END;
      END;

      CASE ShowDialog OF
        ShowDialog::Message:
          MESSAGE(Text016 + Text017,DialogText,FIELDCAPTION("Line No."),"Line No.");
        ShowDialog::Error:
          ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
      END;

      HandleDedicatedBin(TRUE);
    END;

    LOCAL PROCEDURE UpdateDates@43();
    BEGIN
      IF CurrFieldNo = 0 THEN BEGIN
        PlannedShipmentDateCalculated := FALSE;
        PlannedDeliveryDateCalculated := FALSE;
      END;
      IF "Promised Delivery Date" <> 0D THEN
        VALIDATE("Promised Delivery Date")
      ELSE
        IF "Requested Delivery Date" <> 0D THEN
          VALIDATE("Requested Delivery Date")
        ELSE
          VALIDATE("Shipment Date");
    END;

    [External]
    PROCEDURE GetItemTranslation@42();
    VAR
      ItemTranslation@1000 : Record 30;
    BEGIN
      GetSalesHeader;
      IF ItemTranslation.GET("No.","Variant Code",SalesHeader."Language Code") THEN BEGIN
        Description := ItemTranslation.Description;
        "Description 2" := ItemTranslation."Description 2";
      END;
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
    PROCEDURE PriceExists@44() : Boolean;
    BEGIN
      IF "Document No." <> '' THEN BEGIN
        GetSalesHeader;
        EXIT(PriceCalcMgt.SalesLinePriceExists(SalesHeader,Rec,TRUE));
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE LineDiscExists@45() : Boolean;
    BEGIN
      IF "Document No." <> '' THEN BEGIN
        GetSalesHeader;
        EXIT(PriceCalcMgt.SalesLineLineDiscExists(SalesHeader,Rec,TRUE));
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE RowID1@47() : Text[250];
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;
    BEGIN
      EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Line","Document Type",
          "Document No.",'',0,"Line No."));
    END;

    LOCAL PROCEDURE UpdateItemCrossRef@48();
    BEGIN
      DistIntegration.EnterSalesItemCrossRef(Rec);
      UpdateICPartner;
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
          IF ("Qty. to Assemble to Order" > 0) OR IsAsmToOrderRequired THEN
            IF GetATOBin(Location,"Bin Code") THEN
              EXIT;

          WMSManagement.GetDefaultBin("No.","Variant Code","Location Code","Bin Code");
          HandleDedicatedBin(FALSE);
        END;
      END;
    END;

    [External]
    PROCEDURE GetATOBin@89(Location@1001 : Record 14;VAR BinCode@1002 : Code[20]) : Boolean;
    VAR
      AsmHeader@1000 : Record 900;
    BEGIN
      IF NOT Location."Require Shipment" THEN
        BinCode := Location."Asm.-to-Order Shpt. Bin Code";
      IF BinCode <> '' THEN
        EXIT(TRUE);

      IF AsmHeader.GetFromAssemblyBin(Location,BinCode) THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE IsInbound@97() : Boolean;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote,"Document Type"::"Blanket Order":
          EXIT("Quantity (Base)" < 0);
        "Document Type"::"Return Order","Document Type"::"Credit Memo":
          EXIT("Quantity (Base)" > 0);
      END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE HandleDedicatedBin@70(IssueWarning@1001 : Boolean);
    VAR
      WhseIntegrationMgt@1002 : Codeunit 7317;
    BEGIN
      IF NOT IsInbound AND ("Quantity (Base)" <> 0) THEN
        WhseIntegrationMgt.CheckIfBinDedicatedOnSrcDoc("Location Code","Bin Code",IssueWarning);
    END;

    LOCAL PROCEDURE CheckAssocPurchOrder@51(TheFieldCaption@1000 : Text[250]);
    BEGIN
      IF TheFieldCaption = '' THEN BEGIN // If sales line is being deleted
        IF "Purch. Order Line No." <> 0 THEN
          ERROR(
            Text000,
            "Purchase Order No.",
            "Purch. Order Line No.");
        IF "Special Order Purch. Line No." <> 0 THEN
          ERROR(
            Text000,
            "Special Order Purchase No.",
            "Special Order Purch. Line No.");
      END;
      IF "Purch. Order Line No." <> 0 THEN
        ERROR(
          Text002,
          TheFieldCaption,
          "Purchase Order No.",
          "Purch. Order Line No.");
      IF "Special Order Purch. Line No." <> 0 THEN
        ERROR(
          Text002,
          TheFieldCaption,
          "Special Order Purchase No.",
          "Special Order Purch. Line No.");
    END;

    [Internal]
    PROCEDURE CrossReferenceNoLookUp@53();
    VAR
      ItemCrossReference@1000 : Record 5717;
      ICGLAcc@1001 : Record 410;
    BEGIN
      CASE Type OF
        Type::Item:
          BEGIN
            GetSalesHeader;
            ItemCrossReference.RESET;
            ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
            ItemCrossReference.SETFILTER(
              "Cross-Reference Type",'%1|%2',
              ItemCrossReference."Cross-Reference Type"::Customer,
              ItemCrossReference."Cross-Reference Type"::" ");
            ItemCrossReference.SETFILTER("Cross-Reference Type No.",'%1|%2',SalesHeader."Sell-to Customer No.",'');
            IF PAGE.RUNMODAL(PAGE::"Cross Reference List",ItemCrossReference) = ACTION::LookupOK THEN BEGIN
              VALIDATE("Cross-Reference No.",ItemCrossReference."Cross-Reference No.");
              PriceCalcMgt.FindSalesLineLineDisc(SalesHeader,Rec);
              PriceCalcMgt.FindSalesLinePrice(SalesHeader,Rec,FIELDNO("Cross-Reference No."));
              VALIDATE("Unit Price");
            END;
          END;
        Type::"G/L Account",Type::Resource:
          BEGIN
            GetSalesHeader;
            SalesHeader.TESTFIELD("Sell-to IC Partner Code");
            IF PAGE.RUNMODAL(PAGE::"IC G/L Account List",ICGLAcc) = ACTION::LookupOK THEN
              "Cross-Reference No." := ICGLAcc."No.";
          END;
      END;
    END;

    LOCAL PROCEDURE CheckServItemCreation@52();
    VAR
      ServItemGroup@1000 : Record 5904;
    BEGIN
      IF CurrFieldNo = 0 THEN
        EXIT;
      IF Type <> Type::Item THEN
        EXIT;
      Item.GET("No.");
      IF Item."Service Item Group" = '' THEN
        EXIT;
      IF ServItemGroup.GET(Item."Service Item Group") THEN
        IF ServItemGroup."Create Service Item" THEN
          IF "Qty. to Ship (Base)" <> ROUND("Qty. to Ship (Base)",1) THEN
            ERROR(
              Text034,
              FIELDCAPTION("Qty. to Ship (Base)"),
              ServItemGroup.FIELDCAPTION("Create Service Item"));
    END;

    [External]
    PROCEDURE ItemExists@54(ItemNo@1000 : Code[20]) : Boolean;
    VAR
      Item2@1001 : Record 27;
    BEGIN
      IF Type = Type::Item THEN
        IF NOT Item2.GET(ItemNo) THEN
          EXIT(FALSE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE IsShipment@55() : Boolean;
    BEGIN
      EXIT(SignedXX("Quantity (Base)") < 0);
    END;

    LOCAL PROCEDURE GetAbsMin@56(QtyToHandle@1000 : Decimal;QtyHandled@1001 : Decimal) : Decimal;
    BEGIN
      IF ABS(QtyHandled) < ABS(QtyToHandle) THEN
        EXIT(QtyHandled);

      EXIT(QtyToHandle);
    END;

    [External]
    PROCEDURE SetHideValidationDialog@57(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    LOCAL PROCEDURE GetHideValidationDialog@123() : Boolean;
    VAR
      IdentityManagement@1000 : Codeunit 9801;
    BEGIN
      EXIT(HideValidationDialog OR IdentityManagement.IsInvAppId);
    END;

    LOCAL PROCEDURE CheckApplFromItemLedgEntry@157(VAR ItemLedgEntry@1000 : Record 32);
    VAR
      ItemTrackingLines@1003 : Page 6510;
      QtyNotReturned@1002 : Decimal;
      QtyReturned@1004 : Decimal;
    BEGIN
      IF "Appl.-from Item Entry" = 0 THEN
        EXIT;

      IF "Shipment No." <> '' THEN
        EXIT;

      TESTFIELD(Type,Type::Item);
      TESTFIELD(Quantity);
      IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
        IF Quantity < 0 THEN
          FIELDERROR(Quantity,Text029);
      END ELSE BEGIN
        IF Quantity > 0 THEN
          FIELDERROR(Quantity,Text030);
      END;

      ItemLedgEntry.GET("Appl.-from Item Entry");
      ItemLedgEntry.TESTFIELD(Positive,FALSE);
      ItemLedgEntry.TESTFIELD("Item No.","No.");
      ItemLedgEntry.TESTFIELD("Variant Code","Variant Code");
      IF ItemLedgEntry.TrackingExists THEN
        ERROR(Text040,ItemTrackingLines.CAPTION,FIELDCAPTION("Appl.-from Item Entry"));

      IF ABS("Quantity (Base)") > -ItemLedgEntry.Quantity THEN
        ERROR(
          Text046,
          -ItemLedgEntry.Quantity,ItemLedgEntry.FIELDCAPTION("Document No."),
          ItemLedgEntry."Document No.");

      IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
        IF ABS("Outstanding Qty. (Base)") > -ItemLedgEntry."Shipped Qty. Not Returned" THEN BEGIN
          QtyNotReturned := ItemLedgEntry."Shipped Qty. Not Returned";
          QtyReturned := ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. Not Returned";
          IF "Qty. per Unit of Measure" <> 0 THEN BEGIN
            QtyNotReturned :=
              ROUND(ItemLedgEntry."Shipped Qty. Not Returned" / "Qty. per Unit of Measure",0.00001);
            QtyReturned :=
              ROUND(
                (ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. Not Returned") /
                "Qty. per Unit of Measure",0.00001);
          END;
          ERROR(
            Text039,
            -QtyReturned,ItemLedgEntry.FIELDCAPTION("Document No."),
            ItemLedgEntry."Document No.",-QtyNotReturned);
        END;
    END;

    [External]
    PROCEDURE CalcPrepaymentToDeduct@63();
    BEGIN
      IF ("Qty. to Invoice" <> 0) AND ("Prepmt. Amt. Inv." <> 0) THEN BEGIN
        GetSalesHeader;
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

      GetSalesHeader;
      IF "Prepmt Amt to Deduct" = 0 THEN
        LineAmount := ROUND(QtyToHandle * "Unit Price",Currency."Amount Rounding Precision")
      ELSE BEGIN
        LineAmount := ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision");
        LineAmount := ROUND(QtyToHandle * LineAmount / Quantity,Currency."Amount Rounding Precision");
      END;

      IF QtyToHandle <> Quantity THEN
        LineDiscAmount := ROUND(LineAmount * "Line Discount %" / 100,Currency."Amount Rounding Precision")
      ELSE
        LineDiscAmount := "Line Discount Amount";

      EXIT(LineAmount - LineDiscAmount);
    END;

    PROCEDURE GetLineAmountExclVAT@349() : Decimal;
    BEGIN
      IF "Document No." = '' THEN
        EXIT(0);
      GetSalesHeader;
      IF NOT SalesHeader."Prices Including VAT" THEN
        EXIT("Line Amount");

      EXIT(ROUND("Line Amount" / (1 + "VAT %" / 100),Currency."Amount Rounding Precision"));
    END;

    PROCEDURE GetLineAmountInclVAT@351() : Decimal;
    BEGIN
      IF "Document No." = '' THEN
        EXIT(0);
      GetSalesHeader;
      IF SalesHeader."Prices Including VAT" THEN
        EXIT("Line Amount");

      EXIT(ROUND("Line Amount" * (1 + "VAT %" / 100),Currency."Amount Rounding Precision"));
    END;

    [External]
    PROCEDURE SetHasBeenShown@59();
    BEGIN
      HasBeenShown := TRUE;
    END;

    LOCAL PROCEDURE TestJobPlanningLine@60();
    VAR
      JobPostLine@1000 : Codeunit 1001;
    BEGIN
      IF "Job Contract Entry No." = 0 THEN
        EXIT;

      JobPostLine.TestSalesLine(Rec);
    END;

    [External]
    PROCEDURE BlockDynamicTracking@58(SetBlock@1000 : Boolean);
    BEGIN
      ReserveSalesLine.Block(SetBlock);
    END;

    [External]
    PROCEDURE InitQtyToShip2@7();
    BEGIN
      "Qty. to Ship" := "Outstanding Quantity";
      "Qty. to Ship (Base)" := "Outstanding Qty. (Base)";

      ATOLink.UpdateQtyToAsmFromSalesLine(Rec);

      CheckServItemCreation;

      "Qty. to Invoice" := MaxQtyToInvoice;
      "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
      "VAT Difference" := 0;

      CalcInvDiscToInvoice;

      CalcPrepaymentToDeduct;
    END;

    [External]
    PROCEDURE ShowLineComments@61();
    VAR
      SalesCommentLine@1000 : Record 44;
      SalesCommentSheet@1001 : Page 67;
    BEGIN
      TESTFIELD("Document No.");
      TESTFIELD("Line No.");
      SalesCommentLine.SETRANGE("Document Type","Document Type");
      SalesCommentLine.SETRANGE("No.","Document No.");
      SalesCommentLine.SETRANGE("Document Line No.","Line No.");
      SalesCommentSheet.SETTABLEVIEW(SalesCommentLine);
      SalesCommentSheet.RUNMODAL;
    END;

    [External]
    PROCEDURE SetDefaultQuantity@62();
    BEGIN
      GetSalesSetup;
      IF SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Blank THEN BEGIN
        IF ("Document Type" = "Document Type"::Order) OR ("Document Type" = "Document Type"::Quote) THEN BEGIN
          "Qty. to Ship" := 0;
          "Qty. to Ship (Base)" := 0;
          "Qty. to Invoice" := 0;
          "Qty. to Invoice (Base)" := 0;
        END;
        IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
          "Return Qty. to Receive" := 0;
          "Return Qty. to Receive (Base)" := 0;
          "Qty. to Invoice" := 0;
          "Qty. to Invoice (Base)" := 0;
        END;
      END;
    END;

    LOCAL PROCEDURE SetReserveWithoutPurchasingCode@198();
    BEGIN
      GetItem;
      IF Item.Reserve = Item.Reserve::Optional THEN BEGIN
        GetSalesHeader;
        Reserve := SalesHeader.Reserve;
      END ELSE
        Reserve := Item.Reserve;
    END;

    LOCAL PROCEDURE SetDefaultItemQuantity@122();
    BEGIN
      GetSalesSetup;
      IF SalesSetup."Default Item Quantity" THEN BEGIN
        VALIDATE(Quantity,1);
        CheckItemAvailable(CurrFieldNo);
      END;
    END;

    [External]
    PROCEDURE UpdatePrePaymentAmounts@64();
    VAR
      ShipmentLine@1000 : Record 111;
      SalesOrderLine@1001 : Record 37;
      SalesOrderHeader@1002 : Record 36;
    BEGIN
      IF ("Document Type" <> "Document Type"::Invoice) OR ("Prepayment %" = 0) THEN
        EXIT;

      IF NOT ShipmentLine.GET("Shipment No.","Shipment Line No.") THEN BEGIN
        "Prepmt Amt to Deduct" := 0;
        "Prepmt VAT Diff. to Deduct" := 0;
      END ELSE
        IF SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,ShipmentLine."Order No.",ShipmentLine."Order Line No.") THEN BEGIN
          IF ("Prepayment %" = 100) AND (Quantity <> SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced") THEN
            "Prepmt Amt to Deduct" := "Line Amount"
          ELSE
            "Prepmt Amt to Deduct" :=
              ROUND((SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted") *
                Quantity / (SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced"),Currency."Amount Rounding Precision");
          "Prepmt VAT Diff. to Deduct" := "Prepayment VAT Difference" - "Prepmt VAT Diff. Deducted";
          SalesOrderHeader.GET(SalesOrderHeader."Document Type"::Order,SalesOrderLine."Document No.");
        END ELSE BEGIN
          "Prepmt Amt to Deduct" := 0;
          "Prepmt VAT Diff. to Deduct" := 0;
        END;

      GetSalesHeader;
      SalesHeader.TESTFIELD("Prices Including VAT",SalesOrderHeader."Prices Including VAT");
      IF SalesHeader."Prices Including VAT" THEN BEGIN
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
    PROCEDURE ZeroAmountLine@65(QtyType@1000 : 'General,Invoicing,Shipping') : Boolean;
    BEGIN
      IF NOT HasTypeToFillMandatoryFields THEN
        EXIT(TRUE);
      IF Quantity = 0 THEN
        EXIT(TRUE);
      IF "Unit Price" = 0 THEN
        EXIT(TRUE);
      IF QtyType = QtyType::Invoicing THEN
        IF "Qty. to Invoice" = 0 THEN
          EXIT(TRUE);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE FilterLinesWithItemToPlan@69(VAR Item@1000 : Record 27;DocumentType@1001 : Option);
    BEGIN
      RESET;
      SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Shipment Date");
      SETRANGE("Document Type",DocumentType);
      SETRANGE(Type,Type::Item);
      SETRANGE("No.",Item."No.");
      SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
      SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
      SETFILTER("Drop Shipment",Item.GETFILTER("Drop Shipment Filter"));
      SETFILTER("Shortcut Dimension 1 Code",Item.GETFILTER("Global Dimension 1 Filter"));
      SETFILTER("Shortcut Dimension 2 Code",Item.GETFILTER("Global Dimension 2 Filter"));
      SETFILTER("Shipment Date",Item.GETFILTER("Date Filter"));
      SETFILTER("Outstanding Qty. (Base)",'<>0');
    END;

    [External]
    PROCEDURE FindLinesWithItemToPlan@66(VAR Item@1000 : Record 27;DocumentType@1001 : Option) : Boolean;
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

    LOCAL PROCEDURE DateFormularZero@73(VAR DateFormularValue@1001 : DateFormula;CalledByFieldNo@1002 : Integer;CalledByFieldCaption@1003 : Text[250]);
    VAR
      DateFormularZero@1000 : DateFormula;
    BEGIN
      EVALUATE(DateFormularZero,'<0D>');
      IF (DateFormularValue <> DateFormularZero) AND (CalledByFieldNo = CurrFieldNo) THEN
        ERROR(Text051,CalledByFieldCaption,FIELDCAPTION("Drop Shipment"));
      EVALUATE(DateFormularValue,'<0D>');
    END;

    LOCAL PROCEDURE InitQtyToAsm@76();
    BEGIN
      IF NOT IsAsmToOrderAllowed THEN BEGIN
        "Qty. to Assemble to Order" := 0;
        "Qty. to Asm. to Order (Base)" := 0;
        EXIT;
      END;

      IF ((xRec."Qty. to Asm. to Order (Base)" = 0) AND IsAsmToOrderRequired AND ("Qty. Shipped (Base)" = 0)) OR
         ((xRec."Qty. to Asm. to Order (Base)" <> 0) AND
          (xRec."Qty. to Asm. to Order (Base)" = xRec."Quantity (Base)")) OR
         ("Qty. to Asm. to Order (Base)" > "Quantity (Base)")
      THEN BEGIN
        "Qty. to Assemble to Order" := Quantity;
        "Qty. to Asm. to Order (Base)" := "Quantity (Base)";
      END;
    END;

    [External]
    PROCEDURE AsmToOrderExists@72(VAR AsmHeader@1000 : Record 900) : Boolean;
    VAR
      ATOLink@1001 : Record 904;
    BEGIN
      IF NOT ATOLink.AsmExistsForSalesLine(Rec) THEN
        EXIT(FALSE);
      EXIT(AsmHeader.GET(ATOLink."Assembly Document Type",ATOLink."Assembly Document No."));
    END;

    [External]
    PROCEDURE FullQtyIsForAsmToOrder@74() : Boolean;
    BEGIN
      IF "Qty. to Asm. to Order (Base)" = 0 THEN
        EXIT(FALSE);
      EXIT("Quantity (Base)" = "Qty. to Asm. to Order (Base)");
    END;

    LOCAL PROCEDURE FullReservedQtyIsForAsmToOrder@75() : Boolean;
    BEGIN
      IF "Qty. to Asm. to Order (Base)" = 0 THEN
        EXIT(FALSE);
      CALCFIELDS("Reserved Qty. (Base)");
      EXIT("Reserved Qty. (Base)" = "Qty. to Asm. to Order (Base)");
    END;

    [External]
    PROCEDURE QtyBaseOnATO@86() : Decimal;
    VAR
      AsmHeader@1000 : Record 900;
    BEGIN
      IF AsmToOrderExists(AsmHeader) THEN
        EXIT(AsmHeader."Quantity (Base)");
      EXIT(0);
    END;

    [External]
    PROCEDURE QtyAsmRemainingBaseOnATO@90() : Decimal;
    VAR
      AsmHeader@1000 : Record 900;
    BEGIN
      IF AsmToOrderExists(AsmHeader) THEN
        EXIT(AsmHeader."Remaining Quantity (Base)");
      EXIT(0);
    END;

    [External]
    PROCEDURE QtyToAsmBaseOnATO@88() : Decimal;
    VAR
      AsmHeader@1000 : Record 900;
    BEGIN
      IF AsmToOrderExists(AsmHeader) THEN
        EXIT(AsmHeader."Quantity to Assemble (Base)");
      EXIT(0);
    END;

    [External]
    PROCEDURE IsAsmToOrderAllowed@77() : Boolean;
    BEGIN
      IF NOT ("Document Type" IN ["Document Type"::Quote,"Document Type"::"Blanket Order","Document Type"::Order]) THEN
        EXIT(FALSE);
      IF Quantity < 0 THEN
        EXIT(FALSE);
      IF Type <> Type::Item THEN
        EXIT(FALSE);
      IF "No." = '' THEN
        EXIT(FALSE);
      IF "Drop Shipment" OR "Special Order" THEN
        EXIT(FALSE);
      EXIT(TRUE)
    END;

    [External]
    PROCEDURE IsAsmToOrderRequired@81() : Boolean;
    BEGIN
      IF (Type <> Type::Item) OR ("No." = '') THEN
        EXIT(FALSE);
      GetItem;
      IF GetSKU THEN
        EXIT(SKU."Assembly Policy" = SKU."Assembly Policy"::"Assemble-to-Order");
      EXIT(Item."Assembly Policy" = Item."Assembly Policy"::"Assemble-to-Order");
    END;

    [External]
    PROCEDURE CheckAsmToOrder@85(AsmHeader@1001 : Record 900);
    BEGIN
      TESTFIELD("Qty. to Assemble to Order",AsmHeader.Quantity);
      TESTFIELD("Document Type",AsmHeader."Document Type");
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.",AsmHeader."Item No.");
      TESTFIELD("Location Code",AsmHeader."Location Code");
      TESTFIELD("Unit of Measure Code",AsmHeader."Unit of Measure Code");
      TESTFIELD("Variant Code",AsmHeader."Variant Code");
      TESTFIELD("Shipment Date",AsmHeader."Due Date");
      IF "Document Type" = "Document Type"::Order THEN BEGIN
        AsmHeader.CALCFIELDS("Reserved Qty. (Base)");
        AsmHeader.TESTFIELD("Reserved Qty. (Base)",AsmHeader."Remaining Quantity (Base)");
      END;
      TESTFIELD("Qty. to Asm. to Order (Base)",AsmHeader."Quantity (Base)");
      IF "Outstanding Qty. (Base)" < AsmHeader."Remaining Quantity (Base)" THEN
        AsmHeader.FIELDERROR("Remaining Quantity (Base)",STRSUBSTNO(Text045,AsmHeader."Remaining Quantity (Base)"));
    END;

    [External]
    PROCEDURE ShowAsmToOrderLines@80();
    VAR
      ATOLink@1000 : Record 904;
    BEGIN
      ATOLink.ShowAsmToOrderLines(Rec);
    END;

    [External]
    PROCEDURE FindOpenATOEntry@96(LotNo@1003 : Code[20];SerialNo@1004 : Code[20]) : Integer;
    VAR
      PostedATOLink@1002 : Record 914;
      ItemLedgEntry@1001 : Record 32;
    BEGIN
      TESTFIELD("Document Type","Document Type"::Order);
      IF PostedATOLink.FindLinksFromSalesLine(Rec) THEN
        REPEAT
          ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Posted Assembly");
          ItemLedgEntry.SETRANGE("Document No.",PostedATOLink."Assembly Document No.");
          ItemLedgEntry.SETRANGE("Document Line No.",0);
          ItemLedgEntry.SetTrackingFilter(SerialNo,LotNo);
          ItemLedgEntry.SETRANGE(Open,TRUE);
          IF ItemLedgEntry.FINDFIRST THEN
            EXIT(ItemLedgEntry."Entry No.");
        UNTIL PostedATOLink.NEXT = 0;
    END;

    [External]
    PROCEDURE RollUpAsmCost@83();
    BEGIN
      ATOLink.RollUpCost(Rec);
    END;

    [Internal]
    PROCEDURE RollupAsmPrice@84();
    BEGIN
      GetSalesHeader;
      ATOLink.RollUpPrice(SalesHeader,Rec);
    END;

    LOCAL PROCEDURE UpdateICPartner@78();
    VAR
      ICPartner@1000 : Record 413;
      ItemCrossReference@1001 : Record 5717;
    BEGIN
      IF SalesHeader."Send IC Document" AND
         (SalesHeader."IC Direction" = SalesHeader."IC Direction"::Outgoing) AND
         (SalesHeader."Bill-to IC Partner Code" <> '')
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
              IF SalesHeader."Sell-to IC Partner Code" <> '' THEN
                ICPartner.GET(SalesHeader."Sell-to IC Partner Code")
              ELSE
                ICPartner.GET(SalesHeader."Bill-to IC Partner Code");
              CASE ICPartner."Outbound Sales Item No. Type" OF
                ICPartner."Outbound Sales Item No. Type"::"Common Item No.":
                  VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Common Item No.");
                ICPartner."Outbound Sales Item No. Type"::"Internal No.",
                ICPartner."Outbound Sales Item No. Type"::"Cross Reference":
                  BEGIN
                    IF ICPartner."Outbound Sales Item No. Type" = ICPartner."Outbound Sales Item No. Type"::"Internal No." THEN
                      VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::Item)
                    ELSE
                      VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Cross Reference");
                    ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Customer);
                    ItemCrossReference.SETRANGE("Cross-Reference Type No.","Sell-to Customer No.");
                    ItemCrossReference.SETRANGE("Item No.","No.");
                    ItemCrossReference.SETRANGE("Variant Code","Variant Code");
                    ItemCrossReference.SETRANGE("Unit of Measure","Unit of Measure Code");
                    IF ItemCrossReference.FINDFIRST THEN
                      "IC Partner Reference" := ItemCrossReference."Cross-Reference No."
                    ELSE
                      "IC Partner Reference" := "No.";
                  END;
              END;
            END;
          Type::"Fixed Asset":
            BEGIN
              "IC Partner Ref. Type" := "IC Partner Ref. Type"::" ";
              "IC Partner Reference" := '';
            END;
          Type::Resource:
            BEGIN
              Resource.GET("No.");
              "IC Partner Ref. Type" := "IC Partner Ref. Type"::"G/L Account";
              "IC Partner Reference" := Resource."IC Partner Purch. G/L Acc. No.";
            END;
        END;
    END;

    [External]
    PROCEDURE OutstandingInvoiceAmountFromShipment@12(SellToCustomerNo@1000 : Code[20]) : Decimal;
    VAR
      SalesLine@1001 : Record 37;
    BEGIN
      SalesLine.SETCURRENTKEY("Document Type","Sell-to Customer No.","Shipment No.");
      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Invoice);
      SalesLine.SETRANGE("Sell-to Customer No.",SellToCustomerNo);
      SalesLine.SETFILTER("Shipment No.",'<>%1','');
      SalesLine.CALCSUMS("Outstanding Amount (LCY)");
      EXIT(SalesLine."Outstanding Amount (LCY)");
    END;

    LOCAL PROCEDURE CheckShipmentRelation@94();
    VAR
      SalesShptLine@1001 : Record 111;
    BEGIN
      SalesShptLine.GET("Shipment No.","Shipment Line No.");
      IF (Quantity * SalesShptLine."Qty. Shipped Not Invoiced") < 0 THEN
        FIELDERROR("Qty. to Invoice",Text057);
      IF ABS(Quantity) > ABS(SalesShptLine."Qty. Shipped Not Invoiced") THEN
        ERROR(Text058,SalesShptLine."Document No.");
    END;

    LOCAL PROCEDURE CheckRetRcptRelation@95();
    VAR
      ReturnRcptLine@1000 : Record 6661;
    BEGIN
      ReturnRcptLine.GET("Return Receipt No.","Return Receipt Line No.");
      IF (Quantity * (ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced")) < 0 THEN
        FIELDERROR("Qty. to Invoice",Text059);
      IF ABS(Quantity) > ABS(ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced") THEN
        ERROR(Text060,ReturnRcptLine."Document No.");
    END;

    LOCAL PROCEDURE VerifyItemLineDim@87();
    BEGIN
      IF IsShippedReceivedItemDimChanged THEN
        ConfirmShippedReceivedItemDimChange;
    END;

    [External]
    PROCEDURE IsShippedReceivedItemDimChanged@113() : Boolean;
    BEGIN
      EXIT(("Dimension Set ID" <> xRec."Dimension Set ID") AND (Type = Type::Item) AND
        (("Qty. Shipped Not Invoiced" <> 0) OR ("Return Rcd. Not Invd." <> 0)));
    END;

    [External]
    PROCEDURE ConfirmShippedReceivedItemDimChange@114() : Boolean;
    BEGIN
      IF NOT CONFIRM(Text053,TRUE,TABLECAPTION) THEN
        ERROR(Text054);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE InitType@91();
    BEGIN
      IF "Document No." <> '' THEN BEGIN
        IF NOT SalesHeader.GET("Document Type","Document No.") THEN
          EXIT;
        IF (SalesHeader.Status = SalesHeader.Status::Released) AND
           (xRec.Type IN [xRec.Type::Item,xRec.Type::"Fixed Asset"])
        THEN
          Type := Type::" "
        ELSE
          Type := xRec.Type;
      END;
    END;

    LOCAL PROCEDURE CheckWMS@98();
    BEGIN
      IF CurrFieldNo <> 0 THEN
        CheckLocationOnWMS;
    END;

    [External]
    PROCEDURE CheckLocationOnWMS@101();
    VAR
      DialogText@1001 : Text;
    BEGIN
      IF Type = Type::Item THEN BEGIN
        DialogText := Text035;
        IF "Quantity (Base)" <> 0 THEN
          CASE "Document Type" OF
            "Document Type"::Invoice:
              IF "Shipment No." = '' THEN
                IF Location.GET("Location Code") AND Location."Directed Put-away and Pick" THEN BEGIN
                  DialogText += Location.GetRequirementText(Location.FIELDNO("Require Shipment"));
                  ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
                END;
            "Document Type"::"Credit Memo":
              IF "Return Receipt No." = '' THEN
                IF Location.GET("Location Code") AND Location."Directed Put-away and Pick" THEN BEGIN
                  DialogText += Location.GetRequirementText(Location.FIELDNO("Require Receive"));
                  ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
                END;
          END;
      END;
    END;

    [External]
    PROCEDURE IsServiceItem@68() : Boolean;
    BEGIN
      IF Type <> Type::Item THEN
        EXIT(FALSE);
      IF "No." = '' THEN
        EXIT(FALSE);
      GetItem;
      EXIT(Item.Type = Item.Type::Service);
    END;

    LOCAL PROCEDURE ValidateReturnReasonCode@99(CallingFieldNo@1000 : Integer);
    VAR
      ReturnReason@1001 : Record 6635;
    BEGIN
      IF CallingFieldNo = 0 THEN
        EXIT;
      IF "Return Reason Code" = '' THEN BEGIN
        IF (Type = Type::Item) AND ("No." <> '') THEN
          GetUnitCost;
        UpdateUnitPrice(CallingFieldNo);
      END;

      IF ReturnReason.GET("Return Reason Code") THEN BEGIN
        IF (CallingFieldNo <> FIELDNO("Location Code")) AND (ReturnReason."Default Location Code" <> '') THEN
          VALIDATE("Location Code",ReturnReason."Default Location Code");
        IF ReturnReason."Inventory Value Zero" THEN
          VALIDATE("Unit Cost (LCY)",0)
        ELSE
          IF "Unit Price" = 0 THEN
            UpdateUnitPrice(CallingFieldNo);
      END;
    END;

    [External]
    PROCEDURE HasTypeToFillMandatoryFields@103() : Boolean;
    BEGIN
      EXIT(Type <> Type::" ");
    END;

    [External]
    PROCEDURE GetDeferralAmount@104() DeferralAmount : Decimal;
    BEGIN
      IF "VAT Base Amount" <> 0 THEN
        DeferralAmount := "VAT Base Amount"
      ELSE
        DeferralAmount := "Line Amount" - "Inv. Discount Amount";
    END;

    LOCAL PROCEDURE UpdateDeferralAmounts@105();
    VAR
      AdjustStartDate@1000 : Boolean;
    BEGIN
      GetSalesHeader;
      DeferralPostDate := SalesHeader."Posting Date";
      AdjustStartDate := TRUE;
      IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
        IF "Returns Deferral Start Date" = 0D THEN
          "Returns Deferral Start Date" := SalesHeader."Posting Date";
        DeferralPostDate := "Returns Deferral Start Date";
        AdjustStartDate := FALSE;
      END;

      DeferralUtilities.RemoveOrSetDeferralSchedule(
        "Deferral Code",DeferralUtilities.GetSalesDeferralDocType,'','',
        "Document Type","Document No.","Line No.",
        GetDeferralAmount,DeferralPostDate,Description,SalesHeader."Currency Code",AdjustStartDate);
    END;

    PROCEDURE UpdatePriceDescription@147();
    VAR
      Currency@1000 : Record 4;
    BEGIN
      "Price description" := '';
      IF Type IN [Type::"Charge (Item)",Type::"Fixed Asset",Type::Item,Type::Resource] THEN BEGIN
        IF "Line Discount %" = 0 THEN
          "Price description" := STRSUBSTNO(
              PriceDescriptionTxt,Quantity,Currency.ResolveGLCurrencySymbol("Currency Code"),
              "Unit Price","Unit of Measure")
        ELSE
          "Price description" := STRSUBSTNO(
              PriceDescriptionWithLineDiscountTxt,Quantity,Currency.ResolveGLCurrencySymbol("Currency Code"),
              "Unit Price","Unit of Measure","Line Discount %")
      END;
    END;

    [Internal]
    PROCEDURE ShowDeferrals@106(PostingDate@1000 : Date;CurrencyCode@1001 : Code[10]) : Boolean;
    BEGIN
      EXIT(DeferralUtilities.OpenLineScheduleEdit(
          "Deferral Code",DeferralUtilities.GetSalesDeferralDocType,'','',
          "Document Type","Document No.","Line No.",
          GetDeferralAmount,PostingDate,Description,CurrencyCode));
    END;

    LOCAL PROCEDURE InitHeaderDefaults@107(SalesHeader@1000 : Record 36);
    BEGIN
      IF SalesHeader."Document Type" = SalesHeader."Document Type"::Quote THEN BEGIN
        IF (SalesHeader."Sell-to Customer No." = '') AND
           (SalesHeader."Sell-to Customer Template Code" = '')
        THEN
          ERROR(
            Text031,
            SalesHeader.FIELDCAPTION("Sell-to Customer No."),
            SalesHeader.FIELDCAPTION("Sell-to Customer Template Code"));
        IF (SalesHeader."Bill-to Customer No." = '') AND
           (SalesHeader."Bill-to Customer Template Code" = '')
        THEN
          ERROR(
            Text031,
            SalesHeader.FIELDCAPTION("Bill-to Customer No."),
            SalesHeader.FIELDCAPTION("Bill-to Customer Template Code"));
      END ELSE
        SalesHeader.TESTFIELD("Sell-to Customer No.");

      "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
      "Currency Code" := SalesHeader."Currency Code";
      IF NOT IsServiceItem THEN
        "Location Code" := SalesHeader."Location Code";
      "Customer Price Group" := SalesHeader."Customer Price Group";
      "Customer Disc. Group" := SalesHeader."Customer Disc. Group";
      "Allow Line Disc." := SalesHeader."Allow Line Disc.";
      "Transaction Type" := SalesHeader."Transaction Type";
      "Transport Method" := SalesHeader."Transport Method";
      "Bill-to Customer No." := SalesHeader."Bill-to Customer No.";
      "Gen. Bus. Posting Group" := SalesHeader."Gen. Bus. Posting Group";
      "VAT Bus. Posting Group" := SalesHeader."VAT Bus. Posting Group";
      "Exit Point" := SalesHeader."Exit Point";
      Area := SalesHeader.Area;
      "Transaction Specification" := SalesHeader."Transaction Specification";
      "Tax Area Code" := SalesHeader."Tax Area Code";
      "Tax Liable" := SalesHeader."Tax Liable";
      IF NOT "System-Created Entry" AND ("Document Type" = "Document Type"::Order) AND HasTypeToFillMandatoryFields THEN
        "Prepayment %" := SalesHeader."Prepayment %";
      "Prepayment Tax Area Code" := SalesHeader."Tax Area Code";
      "Prepayment Tax Liable" := SalesHeader."Tax Liable";
      "Responsibility Center" := SalesHeader."Responsibility Center";

      "Account Code" := SalesHeader."Account Code";
      "Shipping Agent Code" := SalesHeader."Shipping Agent Code";
      "Shipping Agent Service Code" := SalesHeader."Shipping Agent Service Code";
      "Outbound Whse. Handling Time" := SalesHeader."Outbound Whse. Handling Time";
      "Shipping Time" := SalesHeader."Shipping Time";
    END;

    LOCAL PROCEDURE InitDeferralCode@108();
    BEGIN
      IF "Document Type" IN
         ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::"Credit Memo","Document Type"::"Return Order"]
      THEN
        CASE Type OF
          Type::"G/L Account":
            VALIDATE("Deferral Code",GLAcc."Default Deferral Template Code");
          Type::Item:
            VALIDATE("Deferral Code",Item."Default Deferral Template Code");
          Type::Resource:
            VALIDATE("Deferral Code",Res."Default Deferral Template Code");
        END;
    END;

    [External]
    PROCEDURE DefaultDeferralCode@109();
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
        Type::Resource:
          BEGIN
            Res.GET("No.");
            InitDeferralCode;
          END;
      END;
    END;

    [External]
    PROCEDURE IsCreditDocType@110() : Boolean;
    BEGIN
      EXIT("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]);
    END;

    LOCAL PROCEDURE IsFullyInvoiced@224() : Boolean;
    BEGIN
      EXIT(("Qty. Shipped Not Invd. (Base)" = 0) AND ("Qty. Shipped (Base)" = "Quantity (Base)"))
    END;

    LOCAL PROCEDURE CleanDropShipmentFields@112();
    BEGIN
      IF ("Purch. Order Line No." <> 0) AND IsFullyInvoiced THEN
        IF CleanPurchaseLineDropShipmentFields THEN BEGIN
          "Purchase Order No." := '';
          "Purch. Order Line No." := 0;
        END;
    END;

    LOCAL PROCEDURE CleanSpecialOrderFieldsAndCheckAssocPurchOrder@125();
    BEGIN
      IF ("Special Order Purch. Line No." <> 0) AND IsFullyInvoiced THEN
        IF CleanPurchaseLineSpecialOrderFields THEN BEGIN
          "Special Order Purchase No." := '';
          "Special Order Purch. Line No." := 0;
        END;
      CheckAssocPurchOrder('');
    END;

    LOCAL PROCEDURE CleanPurchaseLineDropShipmentFields@155() : Boolean;
    VAR
      PurchaseLine@1000 : Record 39;
    BEGIN
      IF PurchaseLine.GET(PurchaseLine."Document Type"::Order,"Purchase Order No.","Purch. Order Line No.") THEN BEGIN
        IF PurchaseLine."Qty. Received (Base)" < "Qty. Shipped (Base)" THEN
          EXIT(FALSE);

        PurchaseLine."Sales Order No." := '';
        PurchaseLine."Sales Order Line No." := 0;
        PurchaseLine.MODIFY;
      END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CleanPurchaseLineSpecialOrderFields@219() : Boolean;
    VAR
      PurchaseLine@1000 : Record 39;
    BEGIN
      IF PurchaseLine.GET(PurchaseLine."Document Type"::Order,"Special Order Purchase No.","Special Order Purch. Line No.") THEN BEGIN
        IF PurchaseLine."Qty. Received (Base)" < "Qty. Shipped (Base)" THEN
          EXIT(FALSE);

        PurchaseLine."Special Order" := FALSE;
        PurchaseLine."Special Order Sales No." := '';
        PurchaseLine."Special Order Sales Line No." := 0;
        PurchaseLine.MODIFY;
      END;

      EXIT(TRUE);
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

    LOCAL PROCEDURE ValidateTaxGroupCode@79();
    VAR
      TaxDetail@1001 : Record 322;
    BEGIN
      IF ("Tax Area Code" <> '') AND ("Tax Group Code" <> '') THEN
        TaxDetail.ValidateTaxSetup("Tax Area Code","Tax Group Code","Posting Date");
    END;

    [External]
    PROCEDURE InsertFreightLine@121(VAR FreightAmount@1000 : Decimal);
    VAR
      SalesLine@1001 : Record 37;
    BEGIN
      IF FreightAmount <= 0 THEN BEGIN
        FreightAmount := 0;
        EXIT;
      END;

      SalesSetup.GET;
      SalesSetup.TESTFIELD("Freight G/L Acc. No.");

      TESTFIELD("Document Type");
      TESTFIELD("Document No.");

      SalesLine.SETRANGE("Document Type","Document Type");
      SalesLine.SETRANGE("Document No.","Document No.");

      SalesLine.SETRANGE(Type,SalesLine.Type::"G/L Account");
      SalesLine.SETRANGE("No.",SalesSetup."Freight G/L Acc. No.");
      IF SalesLine.FINDFIRST THEN BEGIN
        SalesLine.VALIDATE(Quantity,1);
        SalesLine.VALIDATE("Unit Price",FreightAmount);
        SalesLine.MODIFY;
      END ELSE BEGIN
        SalesLine.SETRANGE(Type);
        SalesLine.SETRANGE("No.");
        SalesLine.FINDLAST;
        SalesLine."Line No." += 10000;

        SalesLine.INIT;
        SalesLine.VALIDATE(Type,SalesLine.Type::"G/L Account");
        SalesLine.VALIDATE("No.",SalesSetup."Freight G/L Acc. No.");
        SalesLine.VALIDATE(Description,FreightLineDescriptionTxt);
        SalesLine.VALIDATE(Quantity,1);
        SalesLine.VALIDATE("Unit Price",FreightAmount);
        SalesLine.INSERT;
      END;
    END;

    LOCAL PROCEDURE CalcTotalAmtToAssign@154(TotalQtyToAssign@1000 : Decimal) TotalAmtToAssign : Decimal;
    BEGIN
      TotalAmtToAssign := ("Line Amount" - "Inv. Discount Amount") * TotalQtyToAssign / Quantity;
      IF SalesHeader."Prices Including VAT" THEN
        TotalAmtToAssign := TotalAmtToAssign / (1 + "VAT %" / 100) - "VAT Difference";

      TotalAmtToAssign := ROUND(TotalAmtToAssign,Currency."Amount Rounding Precision");
    END;

    [External]
    PROCEDURE IsLookupRequested@119() Result : Boolean;
    BEGIN
      Result := LookupRequested;
      LookupRequested := FALSE;
    END;

    [External]
    PROCEDURE TestItemFields@120(ItemNo@1000 : Code[20];VariantCode@1001 : Code[10];LocationCode@1002 : Code[10]);
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.",ItemNo);
      TESTFIELD("Variant Code",VariantCode);
      TESTFIELD("Location Code",LocationCode);
    END;

    [External]
    PROCEDURE CalculateNotShippedInvExlcVatLCY@118();
    VAR
      Currency2@1000 : Record 4;
    BEGIN
      Currency2.InitRoundingPrecision;
      "Shipped Not Inv. (LCY) No VAT" :=
        ROUND("Shipped Not Invoiced (LCY)" / (1 + "VAT %" / 100),Currency2."Amount Rounding Precision");
    END;

    PROCEDURE ClearSalesHeader@124();
    BEGIN
      CLEAR(SalesHeader);
    END;

    PROCEDURE GetDocumentTypeDescription@156() : Text;
    VAR
      IdentityManagement@1000 : Codeunit 9801;
    BEGIN
      IF IdentityManagement.IsInvAppId AND ("Document Type" = "Document Type"::Quote) THEN
        EXIT(EstimateLbl);

      EXIT(FORMAT("Document Type"));
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

    PROCEDURE UpdatePlanned@151() : Boolean;
    BEGIN
      TESTFIELD("Qty. per Unit of Measure");
      CALCFIELDS("Reserved Quantity");
      IF Planned = ("Reserved Quantity" = "Outstanding Quantity") THEN
        EXIT(FALSE);
      Planned := NOT Planned;
      EXIT(TRUE);
    END;

    PROCEDURE AssignedItemCharge@153() : Boolean;
    BEGIN
      EXIT((Type = Type::"Charge (Item)") AND ("No." <> '') AND ("Qty. to Assign" < Quantity));
    END;

    LOCAL PROCEDURE UpdateLineDiscPct@189();
    VAR
      LineDiscountPct@1000 : Decimal;
    BEGIN
      IF ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") <> 0 THEN BEGIN
        LineDiscountPct := ROUND(
            "Line Discount Amount" / ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") * 100,
            0.00001);
        IF NOT (LineDiscountPct IN [0..100]) THEN
          ERROR(LineDiscountPctErr);
        "Line Discount %" := LineDiscountPct;
      END ELSE
        "Line Discount %" := 0;
    END;

    LOCAL PROCEDURE UpdateBaseAmounts@173(NewAmount@1000 : Decimal;NewAmountIncludingVAT@1001 : Decimal;NewVATBaseAmount@1002 : Decimal);
    BEGIN
      Amount := NewAmount;
      "Amount Including VAT" := NewAmountIncludingVAT;
      "VAT Base Amount" := NewVATBaseAmount;
      IF NOT SalesHeader."Prices Including VAT" AND (Amount > 0) AND (Amount < "Prepmt. Line Amount") THEN
        "Prepmt. Line Amount" := Amount;
      IF SalesHeader."Prices Including VAT" AND ("Amount Including VAT" > 0) AND ("Amount Including VAT" < "Prepmt. Line Amount") THEN
        "Prepmt. Line Amount" := "Amount Including VAT";
    END;

    PROCEDURE CalcPlannedDate@218() : Date;
    BEGIN
      IF FORMAT("Shipping Time") <> '' THEN
        EXIT(CalcPlannedDeliveryDate(FIELDNO("Planned Delivery Date")));

      EXIT(CalcPlannedShptDate(FIELDNO("Planned Delivery Date")));
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignFieldsForNo@158(VAR SalesLine@1000 : Record 37;xSalesLine@1001 : Record 37;SalesHeader@1002 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignHeaderValues@134(VAR SalesLine@1000 : Record 37;SalesHeader@1001 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignStdTxtValues@135(VAR SalesLine@1000 : Record 37;StandardText@1001 : Record 7);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignGLAccountValues@138(VAR SalesLine@1000 : Record 37;GLAccount@1001 : Record 15);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignItemValues@136(VAR SalesLine@1000 : Record 37;Item@1001 : Record 27);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignItemChargeValues@137(VAR SalesLine@1000 : Record 37;ItemCharge@1001 : Record 5800);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignResourceValues@139(VAR SalesLine@1000 : Record 37;Resource@1001 : Record 156);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignFixedAssetValues@140(VAR SalesLine@1000 : Record 37;FixedAsset@1001 : Record 5600);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignItemUOM@141(VAR SalesLine@1000 : Record 37;Item@1001 : Record 27);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignResourceUOM@143(VAR SalesLine@1001 : Record 37;Resource@1000 : Record 156;ResourceUOM@1002 : Record 205);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateUnitPrice@126(VAR SalesLine@1000 : Record 37;xSalesLine@1001 : Record 37;CalledByFieldNo@1002 : Integer;CurrFieldNo@1003 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeUpdateUnitPrice@127(VAR SalesLine@1003 : Record 37;xSalesLine@1002 : Record 37;CalledByFieldNo@1001 : Integer;CurrFieldNo@1000 : Integer;VAR Handled@1004 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeVerifyReservedQty@145(VAR SalesLine@1000 : Record 37;xSalesLine@1001 : Record 37;CalledByFieldNo@1002 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitOutstandingAmount@132(VAR SalesLine@1000 : Record 37;SalesHeader@1001 : Record 36;Currency@1002 : Record 4);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitQtyToInvoice@128(VAR SalesLine@1000 : Record 37;CurrFieldNo@1001 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitQtyToShip@129(VAR SalesLine@1000 : Record 37;CurrFieldNo@1001 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitQtyToReceive@130(VAR SalesLine@1000 : Record 37;CurrFieldNo@1001 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCalcVATAmountLines@170(VAR SalesHeader@1003 : Record 36;VAR SalesLine@1002 : Record 37;VAR VATAmountLine@1001 : Record 290;QtyType@1000 : 'General,Invoicing,Shipping');
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateAmounts@152(VAR SalesLine@1000 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateAmountsDone@165(VAR SalesLine@1000 : Record 37;VAR xSalesLine@1001 : Record 37;CurrentFieldNo@1002 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateVATOnLines@162(VAR SalesHeader@1002 : Record 36;VAR SalesLine@1001 : Record 37;VAR VATAmountLine@1000 : Record 290;QtyType@1003 : 'General,Invoicing,Shipping');
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@164(VAR SalesLine@1000 : Record 37;FieldNo@1001 : Integer;VAR TableID@1003 : ARRAY [10] OF Integer;VAR No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterShowItemSub@166(VAR SalesLine@1000 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnValidateTypeOnCopyFromTempSalesLine@167(VAR SalesLine@1000 : Record 37;VAR TempSalesLine@1001 : TEMPORARY Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnValidateNoOnCopyFromTempSalesLine@168(VAR SalesLine@1000 : Record 37;VAR TempSalesLine@1001 : TEMPORARY Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTestStatusOpen@169(VAR SalesLine@1000 : Record 37;VAR SalesHeader@1001 : Record 36);
    BEGIN
    END;

    BEGIN
    END.
  }
}

