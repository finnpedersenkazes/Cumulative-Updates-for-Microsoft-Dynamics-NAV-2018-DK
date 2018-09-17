OBJECT Table 5902 Service Line
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441,NAVDK11.00.00.21441;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF TempTrackingSpecification.FINDFIRST THEN
                 InsertItemTracking;

               IF Quantity <> 0 THEN
                 ReserveServLine.VerifyQuantity(Rec,xRec);

               IF Type = Type::Item THEN
                 IF ServHeader.InventoryPickConflict("Document Type","Document No.",ServHeader."Shipping Advice") THEN
                   DisplayConflictError(ServHeader.InvPickConflictResolutionTxt);

               IsCustCrLimitChecked := FALSE;
             END;

    OnModify=BEGIN
               IF "Document Type" = ServiceLine."Document Type"::Invoice THEN
                 CheckIfCanBeModified;

               IF "Spare Part Action" IN
                  ["Spare Part Action"::"Component Replaced",
                   "Spare Part Action"::"Component Installed",
                   "Spare Part Action"::" "]
               THEN BEGIN
                 IF (Type <> xRec.Type) OR ("No." <> xRec."No.") THEN
                   ReserveServLine.DeleteLine(Rec);
                 UpdateReservation(0);
               END;

               UpdateServiceLedgerEntry;
               IsCustCrLimitChecked := FALSE;
             END;

    OnDelete=VAR
               ServiceLine2@1000 : Record 5902;
             BEGIN
               TestStatusOpen;
               IF Type = Type::Item THEN
                 WhseValidateSourceLine.ServiceLineDelete(Rec);
               IF Type IN [Type::"G/L Account",Type::Cost,Type::Resource] THEN
                 TESTFIELD("Qty. Shipped Not Invoiced",0);

               IF ("Document Type" = "Document Type"::Invoice) AND ("Appl.-to Service Entry" > 0) THEN
                 ERROR(Text045);

               IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
                 ReserveServLine.DeleteLine(Rec);
                 CALCFIELDS("Reserved Qty. (Base)");
                 TESTFIELD("Reserved Qty. (Base)",0);
                 IF "Shipment No." = '' THEN
                   TESTFIELD("Qty. Shipped Not Invoiced",0);
               END;

               ReserveServLine.DeleteLine(Rec);
               IF (Type = Type::Item) AND Item.GET("No.") THEN
                 NonstockItemMgt.DelNonStockFSM(Rec);

               IF (Type <> Type::" ") AND
                  (("Contract No." <> '') OR
                   ("Shipment No." <> ''))
               THEN
                 UpdateServDocRegister(TRUE);

               IF "Line No." <> 0 THEN BEGIN
                 ServiceLine2.RESET;
                 ServiceLine2.SETRANGE("Document Type","Document Type");
                 ServiceLine2.SETRANGE("Document No.","Document No.");
                 ServiceLine2.SETRANGE("Attached to Line No.","Line No.");
                 ServiceLine2.SETFILTER("Line No.",'<>%1',"Line No.");
                 ServiceLine2.DELETEALL(TRUE);
               END;
             END;

    OnRename=BEGIN
               ERROR(Text002,TABLECAPTION);
             END;

    CaptionML=[DAN=Servicelinje;
               ENU=Service Line];
    LookupPageID=Page5904;
    DrillDownPageID=Page5904;
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,Faktura,Kreditnota;
                                                                    ENU=Quote,Order,Invoice,Credit Memo];
                                                   OptionString=Quote,Order,Invoice,Credit Memo }
    { 2   ;   ;Customer No.        ;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Debitornr.;
                                                              ENU=Customer No.];
                                                   Editable=No }
    { 3   ;   ;Document No.        ;Code20        ;TableRelation="Service Header".No. WHERE (Document Type=FIELD(Document Type));
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 4   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 5   ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                CheckIfCanBeModified;

                                                                GetServHeader;
                                                                TestStatusOpen;
                                                                TESTFIELD("Qty. Shipped Not Invoiced",0);
                                                                TESTFIELD("Quantity Shipped",0);
                                                                TESTFIELD("Shipment No.",'');

                                                                IF xRec.Type = xRec.Type::Item THEN
                                                                  WhseValidateSourceLine.ServiceLineVerifyChange(Rec,xRec);

                                                                IF Type = Type::Item THEN BEGIN
                                                                  GetLocation("Location Code");
                                                                  Location.TESTFIELD("Directed Put-away and Pick",FALSE);
                                                                END;

                                                                UpdateReservation(FIELDNO(Type));

                                                                ServiceLine := Rec;

                                                                IF "Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"] THEN
                                                                  UpdateServDocRegister(TRUE);
                                                                Clearfields;

                                                                "Currency Code" := ServiceLine."Currency Code";
                                                                VALIDATE("Service Item Line No.",ServiceLine."Service Item Line No.");

                                                                IF Type = Type::Item THEN BEGIN
                                                                  IF ServHeader.InventoryPickConflict("Document Type","Document No.",ServHeader."Shipping Advice") THEN
                                                                    DisplayConflictError(ServHeader.InvPickConflictResolutionTxt);
                                                                  IF ServHeader.WhseShpmntConflict("Document Type","Document No.",ServHeader."Shipping Advice") THEN
                                                                    DisplayConflictError(ServHeader.WhseShpmtConflictResolutionTxt);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Vare,Ressource,Omkostning,Finanskonto";
                                                                    ENU=" ,Item,Resource,Cost,G/L Account"];
                                                   OptionString=[ ,Item,Resource,Cost,G/L Account] }
    { 6   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(" ")) "Standard Text"
                                                                 ELSE IF (Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Type=CONST(Item)) Item WHERE (Type=CONST(Inventory))
                                                                 ELSE IF (Type=CONST(Resource)) Resource
                                                                 ELSE IF (Type=CONST(Cost)) "Service Cost";
                                                   OnValidate=BEGIN
                                                                CheckIfCanBeModified;

                                                                TESTFIELD("Qty. Shipped Not Invoiced",0);
                                                                TESTFIELD("Quantity Shipped",0);
                                                                TESTFIELD("Shipment No.",'');
                                                                CheckItemAvailable(FIELDNO("No."));
                                                                TestStatusOpen;

                                                                Clearfields;

                                                                UpdateReservation(FIELDNO("No."));

                                                                IF "No." = '' THEN
                                                                  EXIT;

                                                                GetServHeader;

                                                                IF ServHeader."Document Type" = ServHeader."Document Type"::Quote THEN BEGIN
                                                                  IF ServHeader."Customer No." = '' THEN
                                                                    ERROR(
                                                                      Text031,
                                                                      ServHeader.FIELDCAPTION("Customer No."));
                                                                  IF ServHeader."Bill-to Customer No." = '' THEN
                                                                    ERROR(
                                                                      Text031,
                                                                      ServHeader.FIELDCAPTION("Bill-to Customer No."));
                                                                END ELSE
                                                                  ServHeader.TESTFIELD("Customer No.");

                                                                InitHeaderDefaults(ServHeader);

                                                                IF "Service Item Line No." <> 0 THEN BEGIN
                                                                  ServItemLine.GET("Document Type","Document No.","Service Item Line No.");
                                                                  VALIDATE("Contract No.",ServItemLine."Contract No.")
                                                                END ELSE
                                                                  VALIDATE("Contract No.",ServHeader."Contract No.");

                                                                CASE Type OF
                                                                  Type::" ":
                                                                    CopyFromStdTxt;
                                                                  Type::"G/L Account":
                                                                    CopyFromGLAccount;
                                                                  Type::Cost:
                                                                    CopyFromCost;
                                                                  Type::Item:
                                                                    BEGIN
                                                                      CopyFromItem;
                                                                      IF ServItem.GET("Service Item No.") THEN
                                                                        CopyFromServItem;
                                                                    END;
                                                                  Type::Resource:
                                                                    CopyFromResource;
                                                                END;

                                                                IF Type <> Type::" " THEN BEGIN
                                                                  VALIDATE("VAT Prod. Posting Group");
                                                                  VALIDATE("Unit of Measure Code");
                                                                  IF Quantity <> 0 THEN BEGIN
                                                                    InitOutstanding;
                                                                    IF "Document Type" = "Document Type"::"Credit Memo" THEN
                                                                      InitQtyToInvoice
                                                                    ELSE
                                                                      InitQtyToShip;
                                                                    UpdateWithWarehouseShip;
                                                                  END;
                                                                  UpdateUnitPrice(FIELDNO("No."));
                                                                  AdjustMaxLabourUnitPrice("Unit Price");

                                                                  IF (Type <> Type::Cost) AND
                                                                     NOT ReplaceServItemAction
                                                                  THEN
                                                                    VALIDATE(Quantity,xRec.Quantity);
                                                                  UpdateAmounts;
                                                                END;
                                                                UpdateReservation(FIELDNO("No."));

                                                                GetDefaultBin;

                                                                IF NOT ISTEMPORARY THEN
                                                                  CreateDim(
                                                                    DimMgt.TypeToTableID5(Type),"No.",
                                                                    DATABASE::Job,"Job No.",
                                                                    DATABASE::"Responsibility Center","Responsibility Center");

                                                                IF ServiceLine.GET("Document Type","Document No.","Line No.") THEN
                                                                  MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 7   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                UpdateWithWarehouseShip;
                                                                GetServHeader;
                                                                IF Type = Type::Item THEN BEGIN
                                                                  IF Quantity <> 0 THEN
                                                                    WhseValidateSourceLine.ServiceLineVerifyChange(Rec,xRec);
                                                                  IF "Location Code" <> xRec."Location Code" THEN BEGIN
                                                                    TESTFIELD("Reserved Quantity",0);
                                                                    TESTFIELD("Shipment No.",'');
                                                                    TESTFIELD("Qty. Shipped Not Invoiced",0);
                                                                    CheckItemAvailable(FIELDNO("Location Code"));
                                                                    UpdateReservation(FIELDNO("Location Code"));
                                                                  END;
                                                                  GetUnitCost;
                                                                END;
                                                                GetDefaultBin;
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 8   ;   ;Posting Group       ;Code20        ;TableRelation=IF (Type=CONST(Item)) "Inventory Posting Group";
                                                   CaptionML=[DAN=Bogf�ringsgruppe;
                                                              ENU=Posting Group];
                                                   Editable=No }
    { 11  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 12  ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 13  ;   ;Unit of Measure     ;Text10        ;CaptionML=[DAN=Enhed;
                                                              ENU=Unit of Measure] }
    { 15  ;   ;Quantity            ;Decimal       ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                              BEGIN
                                                                GetServHeader;
                                                                TESTFIELD(Type);
                                                                TESTFIELD("No.");
                                                                TestStatusOpen;

                                                                IF Quantity < 0 THEN
                                                                  FIELDERROR(Quantity,Text029);

                                                                CASE "Spare Part Action" OF
                                                                  "Spare Part Action"::Permanent,"Spare Part Action"::"Temporary":
                                                                    IF Quantity <> 1 THEN
                                                                      ERROR(Text011,ServItem.TABLECAPTION);
                                                                  "Spare Part Action"::"Component Replaced","Spare Part Action"::"Component Installed":
                                                                    IF Quantity <> ROUND(Quantity,1) THEN
                                                                      ERROR(Text026,FIELDCAPTION(Quantity));
                                                                END;

                                                                "Quantity (Base)" := CalcBaseQty(Quantity);

                                                                IF "Document Type" <> "Document Type"::"Credit Memo" THEN BEGIN
                                                                  IF (Quantity * "Quantity Shipped" < 0) OR
                                                                     ((ABS(Quantity) < ABS("Quantity Shipped")) AND ("Shipment No." = ''))
                                                                  THEN
                                                                    FIELDERROR(Quantity,STRSUBSTNO(Text003,FIELDCAPTION("Quantity Shipped")));
                                                                  IF ("Quantity (Base)" * "Qty. Shipped (Base)" < 0) OR
                                                                     ((ABS("Quantity (Base)") < ABS("Qty. Shipped (Base)")) AND ("Shipment No." = ''))
                                                                  THEN
                                                                    FIELDERROR("Quantity (Base)",STRSUBSTNO(Text003,FIELDCAPTION("Qty. Shipped (Base)")));
                                                                END;

                                                                IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN BEGIN
                                                                  InitOutstanding;
                                                                  IF "Document Type" = "Document Type"::"Credit Memo" THEN
                                                                    InitQtyToInvoice
                                                                  ELSE
                                                                    InitQtyToShip;
                                                                END;
                                                                CheckItemAvailable(FIELDNO(Quantity));

                                                                IF (Quantity * xRec.Quantity < 0) OR (Quantity = 0) THEN
                                                                  InitItemAppl(FALSE);

                                                                IF Type = Type::Item THEN BEGIN
                                                                  WhseValidateSourceLine.ServiceLineVerifyChange(Rec,xRec);
                                                                  UpdateUnitPrice(FIELDNO(Quantity));
                                                                  UpdateReservation(FIELDNO(Quantity));
                                                                  UpdateWithWarehouseShip;
                                                                  IF ("Quantity (Base)" * xRec."Quantity (Base)" <= 0) AND ("No." <> '') THEN BEGIN
                                                                    GetItem;
                                                                    IF (Item."Costing Method" = Item."Costing Method"::Standard) AND NOT IsShipment THEN
                                                                      GetUnitCost;
                                                                  END;
                                                                  IF ("Appl.-from Item Entry" <> 0) AND (xRec.Quantity < Quantity) THEN
                                                                    CheckApplFromItemLedgEntry(ItemLedgEntry);
                                                                END ELSE
                                                                  VALIDATE("Line Discount %");

                                                                IF (xRec.Quantity <> Quantity) AND (Quantity = 0) AND
                                                                   ((Amount <> 0) OR
                                                                    ("Amount Including VAT" <> 0) OR
                                                                    ("VAT Base Amount" <> 0))
                                                                THEN BEGIN
                                                                  Amount := 0;
                                                                  "Amount Including VAT" := 0;
                                                                  "VAT Base Amount" := 0;
                                                                END;
                                                                IF "Job Planning Line No." <> 0 THEN
                                                                  VALIDATE("Job Planning Line No.");
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 16  ;   ;Outstanding Quantity;Decimal       ;CaptionML=[DAN=Udest�ende antal;
                                                              ENU=Outstanding Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 17  ;   ;Qty. to Invoice     ;Decimal       ;OnValidate=BEGIN
                                                                IF "Qty. to Invoice" < 0 THEN
                                                                  FIELDERROR("Qty. to Invoice",Text029);

                                                                IF "Qty. to Invoice" > 0 THEN BEGIN
                                                                  "Qty. to Consume" := 0;
                                                                  "Qty. to Consume (Base)" := 0;
                                                                END;

                                                                IF "Qty. to Invoice" = MaxQtyToInvoice THEN
                                                                  InitQtyToInvoice
                                                                ELSE
                                                                  "Qty. to Invoice (Base)" := CalcBaseQty("Qty. to Invoice");
                                                                IF ("Qty. to Invoice" * Quantity < 0) OR
                                                                   (ABS("Qty. to Invoice") > ABS(MaxQtyToInvoice))
                                                                THEN
                                                                  ERROR(
                                                                    Text000,
                                                                    MaxQtyToInvoice);
                                                                IF ("Qty. to Invoice (Base)" * "Quantity (Base)" < 0) OR
                                                                   (ABS("Qty. to Invoice (Base)") > ABS(MaxQtyToInvoiceBase))
                                                                THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    MaxQtyToInvoiceBase);
                                                                "VAT Difference" := 0;
                                                                CalcInvDiscToInvoice;
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Fakturer (antal);
                                                              ENU=Qty. to Invoice];
                                                   DecimalPlaces=0:5 }
    { 18  ;   ;Qty. to Ship        ;Decimal       ;OnValidate=BEGIN
                                                                IF "Qty. to Ship" < 0 THEN
                                                                  FIELDERROR("Qty. to Ship",Text029);

                                                                IF (CurrFieldNo <> 0) AND
                                                                   (Type = Type::Item) AND
                                                                   ("Qty. to Ship" <> 0)
                                                                THEN
                                                                  CheckWarehouse;

                                                                IF "Qty. to Ship" = "Outstanding Quantity" THEN BEGIN
                                                                  IF NOT LineRequiresShipmentOrReceipt THEN
                                                                    InitQtyToShip
                                                                  ELSE
                                                                    "Qty. to Ship (Base)" := CalcBaseQty("Qty. to Ship");
                                                                  IF "Qty. to Consume" <> 0 THEN
                                                                    VALIDATE("Qty. to Consume","Qty. to Ship")
                                                                  ELSE
                                                                    VALIDATE("Qty. to Consume",0);
                                                                END ELSE BEGIN
                                                                  "Qty. to Ship (Base)" := CalcBaseQty("Qty. to Ship");
                                                                  IF "Qty. to Consume" <> 0 THEN
                                                                    VALIDATE("Qty. to Consume","Qty. to Ship")
                                                                  ELSE
                                                                    VALIDATE("Qty. to Consume",0);
                                                                END;
                                                                IF ((("Qty. to Ship" < 0) XOR (Quantity < 0)) AND (Quantity <> 0) AND ("Qty. to Ship" <> 0)) OR
                                                                   (ABS("Qty. to Ship") > ABS("Outstanding Quantity")) OR
                                                                   (((Quantity < 0) XOR ("Outstanding Quantity" < 0)) AND (Quantity <> 0) AND ("Outstanding Quantity" <> 0))
                                                                THEN
                                                                  ERROR(
                                                                    Text016,
                                                                    "Outstanding Quantity");
                                                                IF ((("Qty. to Ship (Base)" < 0) XOR ("Quantity (Base)" < 0)) AND ("Qty. to Ship (Base)" <> 0) AND ("Quantity (Base)" <> 0)) OR
                                                                   (ABS("Qty. to Ship (Base)") > ABS("Outstanding Qty. (Base)")) OR
                                                                   ((("Quantity (Base)" < 0) XOR ("Outstanding Qty. (Base)" < 0)) AND ("Quantity (Base)" <> 0) AND ("Outstanding Qty. (Base)" <> 0))
                                                                THEN
                                                                  ERROR(
                                                                    Text017,
                                                                    "Outstanding Qty. (Base)");
                                                              END;

                                                   CaptionML=[DAN=Lever (antal);
                                                              ENU=Qty. to Ship];
                                                   DecimalPlaces=0:5 }
    { 22  ;   ;Unit Price          ;Decimal       ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                GetServHeader;
                                                                IF ("Appl.-to Service Entry" > 0) AND (CurrFieldNo <> 0) THEN
                                                                  ERROR(Text052,FIELDCAPTION("Unit Price"));
                                                                IF ("Unit Price" > ServHeader."Max. Labor Unit Price") AND
                                                                   (Type = Type::Resource) AND
                                                                   (ServHeader."Max. Labor Unit Price" <> 0)
                                                                THEN
                                                                  ERROR(
                                                                    Text022,
                                                                    FIELDCAPTION("Unit Price"),ServHeader.FIELDCAPTION("Max. Labor Unit Price"),
                                                                    ServHeader.TABLECAPTION);

                                                                VALIDATE("Line Discount %");
                                                              END;

                                                   CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Unit Price")) }
    { 23  ;   ;Unit Cost (LCY)     ;Decimal       ;OnValidate=BEGIN
                                                                GetServHeader;
                                                                Currency.Initialize("Currency Code");
                                                                IF "Unit Cost (LCY)" <> xRec."Unit Cost (LCY)" THEN
                                                                  IF (CurrFieldNo = FIELDNO("Unit Cost (LCY)")) AND
                                                                     (Type = Type::Item) AND ("No." <> '') AND ("Quantity (Base)" <> 0)
                                                                  THEN BEGIN
                                                                    GetItem;
                                                                    IF (Item."Costing Method" = Item."Costing Method"::Standard) AND NOT IsShipment THEN BEGIN
                                                                      IF "Document Type" IN ["Document Type"::"Credit Memo"] THEN
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

                                                                IF "Currency Code" <> '' THEN BEGIN
                                                                  Currency.TESTFIELD("Unit-Amount Rounding Precision");
                                                                  "Unit Cost" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtLCYToFCY(
                                                                        GetDate,"Currency Code","Unit Cost (LCY)",
                                                                        ServHeader."Currency Factor"),Currency."Unit-Amount Rounding Precision")
                                                                END ELSE
                                                                  "Unit Cost" := "Unit Cost (LCY)";

                                                                UpdateRemainingCostsAndAmounts;
                                                              END;

                                                   CaptionML=[DAN=Kostpris (RV);
                                                              ENU=Unit Cost (LCY)];
                                                   AutoFormatType=2 }
    { 25  ;   ;VAT %               ;Decimal       ;CaptionML=[DAN=Momspct.;
                                                              ENU=VAT %];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 27  ;   ;Line Discount %     ;Decimal       ;OnValidate=BEGIN
                                                                IF CurrFieldNo = FIELDNO("Line Discount %") THEN
                                                                  TestStatusOpen;
                                                                GetServHeader;
                                                                IF (CurrFieldNo IN
                                                                    [FIELDNO("Line Discount %"),
                                                                     FIELDNO("Line Discount Amount"),
                                                                     FIELDNO("Line Amount")]) AND
                                                                   ("Document Type" <> "Document Type"::Invoice)
                                                                THEN
                                                                  CheckLineDiscount("Line Discount %");

                                                                "Line Discount Amount" :=
                                                                  ROUND(
                                                                    ROUND(CalcChargeableQty * "Unit Price",Currency."Amount Rounding Precision") *
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
                                                                TestStatusOpen;
                                                                GetServHeader;
                                                                TESTFIELD(Quantity);
                                                                IF "Line Discount Amount" <> xRec."Line Discount Amount" THEN
                                                                  IF ROUND(CalcChargeableQty * "Unit Price",Currency."Amount Rounding Precision") <> 0 THEN
                                                                    "Line Discount %" :=
                                                                      ROUND(
                                                                        "Line Discount Amount" /
                                                                        ROUND(CalcChargeableQty * "Unit Price",
                                                                          Currency."Amount Rounding Precision") * 100,0.00001)
                                                                  ELSE
                                                                    "Line Discount %" := 0;
                                                                "Inv. Discount Amount" := 0;
                                                                "Inv. Disc. Amount to Invoice" := 0;
                                                                VALIDATE("Line Discount %");
                                                              END;

                                                   CaptionML=[DAN=Linjerabatbel�b;
                                                              ENU=Line Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 29  ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                GetServHeader;
                                                                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                                                                CASE "VAT Calculation Type" OF
                                                                  "VAT Calculation Type"::"Normal VAT",
                                                                  "VAT Calculation Type"::"Reverse Charge VAT":
                                                                    BEGIN
                                                                      "VAT Base Amount" :=
                                                                        ROUND(Amount * (1 - ServHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                                                                      "Amount Including VAT" :=
                                                                        ROUND(Amount + "VAT Base Amount" * "VAT %" / 100,Currency."Amount Rounding Precision");
                                                                    END;
                                                                  "VAT Calculation Type"::"Full VAT":
                                                                    IF Amount <> 0 THEN
                                                                      FIELDERROR(Amount,
                                                                        STRSUBSTNO(
                                                                          Text013,FIELDCAPTION("VAT Calculation Type"),
                                                                          "VAT Calculation Type"));
                                                                  "VAT Calculation Type"::"Sales Tax":
                                                                    BEGIN
                                                                      ServHeader.TESTFIELD("VAT Base Discount %",0);
                                                                      "VAT Base Amount" := ROUND(Amount,Currency."Amount Rounding Precision");
                                                                      "Amount Including VAT" :=
                                                                        Amount +
                                                                        SalesTaxCalculate.CalculateTax(
                                                                          "Tax Area Code","Tax Group Code","Tax Liable",ServHeader."Posting Date",
                                                                          "VAT Base Amount","Quantity (Base)",ServHeader."Currency Factor");
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
                                                                GetServHeader;
                                                                "Amount Including VAT" := ROUND("Amount Including VAT",Currency."Amount Rounding Precision");
                                                                CASE "VAT Calculation Type" OF
                                                                  "VAT Calculation Type"::"Normal VAT",
                                                                  "VAT Calculation Type"::"Reverse Charge VAT":
                                                                    BEGIN
                                                                      Amount :=
                                                                        ROUND(
                                                                          "Amount Including VAT" /
                                                                          (1 + (1 - ServHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                                                                          Currency."Amount Rounding Precision");
                                                                      "VAT Base Amount" :=
                                                                        ROUND(Amount * (1 - ServHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                                                                    END;
                                                                  "VAT Calculation Type"::"Full VAT":
                                                                    BEGIN
                                                                      Amount := 0;
                                                                      "VAT Base Amount" := 0;
                                                                    END;
                                                                  "VAT Calculation Type"::"Sales Tax":
                                                                    BEGIN
                                                                      ServHeader.TESTFIELD("VAT Base Discount %",0);
                                                                      Amount :=
                                                                        SalesTaxCalculate.ReverseCalculateTax(
                                                                          "Tax Area Code","Tax Group Code","Tax Liable",ServHeader."Posting Date",
                                                                          "Amount Including VAT","Quantity (Base)",ServHeader."Currency Factor");
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
                                                                   NOT "Allow Invoice Disc."
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
                                                              BEGIN
                                                                IF "Appl.-to Item Entry" <> 0 THEN BEGIN
                                                                  TESTFIELD(Type,Type::Item);
                                                                  TESTFIELD(Quantity);

                                                                  ItemLedgEntry.GET("Appl.-to Item Entry");
                                                                  ItemLedgEntry.TESTFIELD(Positive,TRUE);
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
    { 42  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   OnValidate=BEGIN
                                                                IF Type = Type::Item THEN
                                                                  UpdateUnitPrice(FIELDNO("Customer Price Group"));
                                                              END;

                                                   CaptionML=[DAN=Debitorprisgruppe;
                                                              ENU=Customer Price Group];
                                                   Editable=No }
    { 45  ;   ;Job No.             ;Code20        ;TableRelation=Job.No. WHERE (Bill-to Customer No.=FIELD(Bill-to Customer No.));
                                                   OnValidate=VAR
                                                                Job@1000 : Record 167;
                                                              BEGIN
                                                                TESTFIELD("Quantity Consumed",0);
                                                                VALIDATE("Job Task No.",'');

                                                                IF "Job No." <> '' THEN BEGIN
                                                                  Job.GET("Job No.");
                                                                  Job.TestBlocked;
                                                                END;

                                                                CreateDim(
                                                                  DATABASE::Job,"Job No.",
                                                                  DimMgt.TypeToTableID5(Type),"No.",
                                                                  DATABASE::"Responsibility Center","Responsibility Center");
                                                              END;

                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 46  ;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Quantity Consumed",0);
                                                                IF "Job Task No." = '' THEN
                                                                  "Job Line Type" := "Job Line Type"::" ";

                                                                IF "Job Task No." <> xRec."Job Task No." THEN
                                                                  VALIDATE("Job Planning Line No.",0);
                                                              END;

                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.] }
    { 47  ;   ;Job Line Type       ;Option        ;OnValidate=BEGIN
                                                                TESTFIELD("Quantity Consumed",0);
                                                                TESTFIELD("Job No.");
                                                                TESTFIELD("Job Task No.");
                                                                IF "Job Planning Line No." <> 0 THEN
                                                                  ERROR(Text048,FIELDCAPTION("Job Line Type"),FIELDCAPTION("Job Planning Line No."));
                                                              END;

                                                   CaptionML=[DAN=Linjetype for sag;
                                                              ENU=Job Line Type];
                                                   OptionCaptionML=[DAN=" ,Budget,Fakturerbar,B�de budget og fakturerbar";
                                                                    ENU=" ,Budget,Billable,Both Budget and Billable"];
                                                   OptionString=[ ,Budget,Billable,Both Budget and Billable] }
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
    { 57  ;   ;Outstanding Amount  ;Decimal       ;OnValidate=VAR
                                                                Currency2@1000 : Record 4;
                                                              BEGIN
                                                                GetServHeader;
                                                                Currency2.InitRoundingPrecision;
                                                                IF ServHeader."Currency Code" <> '' THEN
                                                                  "Outstanding Amount (LCY)" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        GetDate,"Currency Code",
                                                                        "Outstanding Amount",ServHeader."Currency Factor"),
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
                                                                GetServHeader;
                                                                Currency2.InitRoundingPrecision;
                                                                IF ServHeader."Currency Code" <> '' THEN
                                                                  "Shipped Not Invoiced (LCY)" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        GetDate,"Currency Code",
                                                                        "Shipped Not Invoiced",ServHeader."Currency Factor"),
                                                                      Currency2."Amount Rounding Precision")
                                                                ELSE
                                                                  "Shipped Not Invoiced (LCY)" :=
                                                                    ROUND("Shipped Not Invoiced",Currency2."Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Lev. bel�b (ufakt.);
                                                              ENU=Shipped Not Invoiced];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 60  ;   ;Quantity Shipped    ;Decimal       ;CaptionML=[DAN=Leveret (antal);
                                                              ENU=Quantity Shipped];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 61  ;   ;Quantity Invoiced   ;Decimal       ;CaptionML=[DAN=Faktureret (antal);
                                                              ENU=Quantity Invoiced];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 63  ;   ;Shipment No.        ;Code20        ;OnValidate=VAR
                                                                ServShptHeader@1000 : Record 5990;
                                                                ServDocReg@1001 : Record 5936;
                                                              BEGIN
                                                                IF "Shipment No." <> xRec."Shipment No." THEN BEGIN
                                                                  IF "Shipment No." <> '' THEN BEGIN
                                                                    GetServHeader;
                                                                    IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                                                                      ServShptHeader.RESET;
                                                                      ServShptHeader.SETCURRENTKEY("Customer No.","Posting Date");
                                                                      ServShptHeader.SETRANGE("Customer No.",ServHeader."Customer No.");
                                                                      ServShptHeader.SETRANGE("Ship-to Code",ServHeader."Ship-to Code");
                                                                      ServShptHeader.SETRANGE("Bill-to Customer No.",ServHeader."Bill-to Customer No.");
                                                                      ServShptHeader.SETRANGE("No.","Shipment No.");
                                                                      ServShptHeader.FINDFIRST;
                                                                    END;
                                                                  END;
                                                                  TESTFIELD("Appl.-to Service Entry",0);
                                                                  ServDocReg.RESET;
                                                                  ServDocReg.SETRANGE("Destination Document Type","Document Type");
                                                                  ServDocReg.SETRANGE("Destination Document No.","Document No.");
                                                                  ServDocReg.SETRANGE("Source Document Type",ServDocReg."Source Document Type"::Order);
                                                                  ServDocReg.SETRANGE("Source Document No.",xRec."Shipment No.");
                                                                  ServDocReg.DELETEALL;
                                                                  CLEAR(ServDocReg);
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              ServShptHeader@1000 : Record 5990;
                                                            BEGIN
                                                              GetServHeader;
                                                              IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                                                                ServShptHeader.RESET;
                                                                ServShptHeader.SETCURRENTKEY("Customer No.","Posting Date");
                                                                ServShptHeader.FILTERGROUP(2);
                                                                ServShptHeader.SETRANGE("Customer No.",ServHeader."Customer No.");
                                                                ServShptHeader.SETRANGE("Ship-to Code",ServHeader."Ship-to Code");
                                                                ServShptHeader.SETRANGE("Bill-to Customer No.",ServHeader."Bill-to Customer No.");
                                                                ServShptHeader.FILTERGROUP(0);
                                                                ServShptHeader."No." := "Shipment No.";
                                                                IF PAGE.RUNMODAL(0,ServShptHeader) = ACTION::LookupOK THEN
                                                                  VALIDATE("Shipment No.",ServShptHeader."No.");
                                                              END
                                                            END;

                                                   CaptionML=[DAN=Leverancenr.;
                                                              ENU=Shipment No.] }
    { 64  ;   ;Shipment Line No.   ;Integer       ;CaptionML=[DAN=Salgslev.linjenr.;
                                                              ENU=Shipment Line No.];
                                                   Editable=No }
    { 68  ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Faktureres til kundenr.;
                                                              ENU=Bill-to Customer No.];
                                                   Editable=No }
    { 69  ;   ;Inv. Discount Amount;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD(Quantity);
                                                                CalcInvDiscToInvoice;
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Fakturarabatbel�b;
                                                              ENU=Inv. Discount Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 74  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=VAR
                                                                GenBusPostingGroup@1000 : Record 250;
                                                              BEGIN
                                                                IF "Gen. Bus. Posting Group" <> xRec."Gen. Bus. Posting Group" THEN
                                                                  IF GenBusPostingGroup.ValidateVatBusPostingGroup(GenBusPostingGroup,"Gen. Bus. Posting Group") THEN
                                                                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGroup."Def. VAT Bus. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 75  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   OnValidate=VAR
                                                                GenProdPostingGroup@1000 : Record 251;
                                                              BEGIN
                                                                TestStatusOpen;
                                                                IF "Gen. Prod. Posting Group" <> xRec."Gen. Prod. Posting Group" THEN
                                                                  IF GenProdPostingGroup.ValidateVatProdPostingGroup(GenProdPostingGroup,"Gen. Prod. Posting Group") THEN
                                                                    VALIDATE("VAT Prod. Posting Group",GenProdPostingGroup."Def. VAT Prod. Posting Group");
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
    { 80  ;   ;Attached to Line No.;Integer       ;TableRelation="Service Line"."Line No." WHERE (Document Type=FIELD(Document Type),
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
                                                   OnValidate=VAR
                                                                VATPostingSetup@1000 : Record 325;
                                                              BEGIN
                                                                TestStatusOpen;
                                                                GetServHeader;
                                                                VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
                                                                "VAT Difference" := 0;
                                                                "VAT %" := VATPostingSetup."VAT %";
                                                                "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                                                                "VAT Identifier" := VATPostingSetup."VAT Identifier";
                                                                "VAT Clause Code" := VATPostingSetup."VAT Clause Code";
                                                                CASE "VAT Calculation Type" OF
                                                                  "VAT Calculation Type"::"Reverse Charge VAT",
                                                                  "VAT Calculation Type"::"Sales Tax":
                                                                    "VAT %" := 0;
                                                                  "VAT Calculation Type"::"Full VAT":
                                                                    TESTFIELD(Type,Type::Cost);
                                                                END;

                                                                IF ServHeader."Prices Including VAT" AND (Type IN [Type::Item,Type::Resource]) THEN
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
    { 93  ;   ;Shipped Not Invoiced (LCY);Decimal ;CaptionML=[DAN=Lev. bel�b ufakt. (RV);
                                                              ENU=Shipped Not Invoiced (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 95  ;   ;Reserved Quantity   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Document No.),
                                                                                                        Source Ref. No.=FIELD(Line No.),
                                                                                                        Source Type=CONST(5902),
                                                                                                        Source Subtype=FIELD(Document Type),
                                                                                                        Reservation Status=CONST(Reservation)));
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

                                                                IF xRec.Reserve = Reserve::Always THEN BEGIN
                                                                  GetItem;
                                                                  IF Item.Reserve = Item.Reserve::Always THEN
                                                                    TESTFIELD(Reserve,Reserve::Always);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Reserver;
                                                              ENU=Reserve];
                                                   OptionCaptionML=[DAN=Aldrig,Eventuelt,Altid;
                                                                    ENU=Never,Optional,Always];
                                                   OptionString=Never,Optional,Always }
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
                                                                Currency.Initialize("Currency Code");
                                                                "Line Amount" := ROUND("Line Amount",Currency."Amount Rounding Precision");
                                                                VALIDATE(
                                                                  "Line Discount Amount",
                                                                  ROUND(CalcChargeableQty * "Unit Price",Currency."Amount Rounding Precision") - "Line Amount");
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
    { 950 ;   ;Time Sheet No.      ;Code20        ;TableRelation="Time Sheet Header";
                                                   CaptionML=[DAN=Timeseddelnr.;
                                                              ENU=Time Sheet No.] }
    { 951 ;   ;Time Sheet Line No. ;Integer       ;TableRelation="Time Sheet Line"."Line No." WHERE (Time Sheet No.=FIELD(Time Sheet No.));
                                                   CaptionML=[DAN=Timeseddellinjenr.;
                                                              ENU=Time Sheet Line No.] }
    { 952 ;   ;Time Sheet Date     ;Date          ;TableRelation="Time Sheet Detail".Date WHERE (Time Sheet No.=FIELD(Time Sheet No.),
                                                                                                 Time Sheet Line No.=FIELD(Time Sheet Line No.));
                                                   CaptionML=[DAN=Dato p� timeseddel;
                                                              ENU=Time Sheet Date] }
    { 1019;   ;Job Planning Line No.;Integer      ;OnValidate=VAR
                                                                JobPlanningLine@1000 : Record 1003;
                                                              BEGIN
                                                                IF "Job Planning Line No." <> 0 THEN BEGIN
                                                                  JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
                                                                  JobPlanningLine.TESTFIELD("Job No.","Job No.");
                                                                  JobPlanningLine.TESTFIELD("Job Task No.","Job Task No.");
                                                                  CASE Type OF
                                                                    Type::Resource:
                                                                      JobPlanningLine.TESTFIELD(Type,JobPlanningLine.Type::Resource);
                                                                    Type::Item:
                                                                      JobPlanningLine.TESTFIELD(Type,JobPlanningLine.Type::Item);
                                                                    Type::"G/L Account":
                                                                      JobPlanningLine.TESTFIELD(Type,JobPlanningLine.Type::"G/L Account");
                                                                  END;
                                                                  JobPlanningLine.TESTFIELD("No.","No.");
                                                                  JobPlanningLine.TESTFIELD("Usage Link",TRUE);
                                                                  JobPlanningLine.TESTFIELD("System-Created Entry",FALSE);
                                                                  "Job Line Type" := JobPlanningLine."Line Type" + 1;
                                                                  VALIDATE("Job Remaining Qty.",JobPlanningLine."Remaining Qty." - Quantity);
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
                                                   CaptionML=[DAN=Sagsplanl�gningslinjenr.;
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

                                                                UpdateRemainingCostsAndAmounts;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Rest. jobantal;
                                                              ENU=Job Remaining Qty.];
                                                   DecimalPlaces=0:5 }
    { 1031;   ;Job Remaining Qty. (Base);Decimal  ;CaptionML=[DAN=Rest. jobantal (basis);
                                                              ENU=Job Remaining Qty. (Base)] }
    { 1032;   ;Job Remaining Total Cost;Decimal   ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Rest. jobantal (kostbel�b);
                                                              ENU=Job Remaining Total Cost];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1033;   ;Job Remaining Total Cost (LCY);Decimal;
                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Rest. jobantal (kostbel�b) (RV);
                                                              ENU=Job Remaining Total Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1034;   ;Job Remaining Line Amount;Decimal  ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Rest. jobantal (linjebel�b);
                                                              ENU=Job Remaining Line Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   OnValidate=VAR
                                                                ItemVariant@1000 : Record 5401;
                                                              BEGIN
                                                                IF "Variant Code" <> '' THEN
                                                                  TESTFIELD(Type,Type::Item);
                                                                TestStatusOpen;

                                                                IF xRec."Variant Code" <> "Variant Code" THEN BEGIN
                                                                  TESTFIELD("Qty. Shipped Not Invoiced",0);
                                                                  TESTFIELD("Shipment No.",'');
                                                                  InitItemAppl(FALSE);
                                                                END;

                                                                CheckItemAvailable(FIELDNO("Variant Code"));
                                                                UpdateReservation(FIELDNO("Variant Code"));

                                                                IF Type = Type::Item THEN BEGIN
                                                                  GetUnitCost;
                                                                  UpdateUnitPrice(FIELDNO("Variant Code"));
                                                                  WhseValidateSourceLine.ServiceLineVerifyChange(Rec,xRec);
                                                                END;

                                                                GetDefaultBin;

                                                                IF "Variant Code" = '' THEN BEGIN
                                                                  IF Type = Type::Item THEN BEGIN
                                                                    Item.GET("No.");
                                                                    Description := Item.Description;
                                                                    "Description 2" := Item."Description 2";
                                                                    GetItemTranslation;
                                                                  END;
                                                                  EXIT;
                                                                END;

                                                                ItemVariant.GET("No.","Variant Code");
                                                                Description := ItemVariant.Description;
                                                                "Description 2" := ItemVariant."Description 2";

                                                                GetServHeader;
                                                                IF ServHeader."Language Code" <> '' THEN
                                                                  GetItemTranslation;
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5403;   ;Bin Code            ;Code20        ;TableRelation=IF (Document Type=FILTER(Order|Invoice),
                                                                     Location Code=FILTER(<>''),
                                                                     Type=CONST(Item)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                       Item No.=FIELD(No.),
                                                                                                                       Variant Code=FIELD(Variant Code))
                                                                                                                       ELSE IF (Document Type=FILTER(Credit Memo),
                                                                                                                                Location Code=FILTER(<>''),
                                                                                                                                Type=CONST(Item)) Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=VAR
                                                                WMSManagement@1000 : Codeunit 7302;
                                                                WhseIntegrationManagement@1003 : Codeunit 7317;
                                                              BEGIN
                                                                TESTFIELD("Location Code");
                                                                TESTFIELD(Type,Type::Item);

                                                                IF "Bin Code" <> '' THEN
                                                                  IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN
                                                                    WMSManagement.FindBinContent("Location Code","Bin Code","No.","Variant Code",'')
                                                                  ELSE
                                                                    IF "Document Type" = "Document Type"::"Credit Memo" THEN
                                                                      WMSManagement.FindBin("Location Code","Bin Code",'');

                                                                IF xRec."Bin Code" <> "Bin Code" THEN BEGIN
                                                                  TESTFIELD("Qty. Shipped Not Invoiced",0);
                                                                  TESTFIELD("Shipment No.",'');
                                                                END;

                                                                IF "Bin Code" <> '' THEN
                                                                  WhseIntegrationManagement.CheckBinTypeCode(
                                                                    DATABASE::"Service Line",
                                                                    FIELDCAPTION("Bin Code"),
                                                                    "Location Code",
                                                                    "Bin Code",
                                                                    "Document Type");
                                                              END;

                                                   OnLookup=VAR
                                                              WMSManagement@1001 : Codeunit 7302;
                                                              BinCode@1000 : Code[20];
                                                            BEGIN
                                                              TESTFIELD("Location Code");
                                                              TESTFIELD(Type,Type::Item);

                                                              IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN
                                                                BinCode := WMSManagement.BinContentLookUp("Location Code","No.","Variant Code",'',"Bin Code")
                                                              ELSE
                                                                IF "Document Type" = "Document Type"::"Credit Memo" THEN
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
    { 5407;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.))
                                                                 ELSE "Unit of Measure";
                                                   OnValidate=VAR
                                                                UnitOfMeasure@1003 : Record 204;
                                                                UnitOfMeasureTranslation@1000 : Record 5402;
                                                                ResUnitofMeasure@1001 : Record 205;
                                                              BEGIN
                                                                TESTFIELD("Quantity Shipped",0);
                                                                TESTFIELD("Qty. Shipped (Base)",0);
                                                                TestStatusOpen;

                                                                IF "Unit of Measure Code" = '' THEN
                                                                  "Unit of Measure" := ''
                                                                ELSE BEGIN
                                                                  IF NOT UnitOfMeasure.GET("Unit of Measure Code") THEN
                                                                    UnitOfMeasure.INIT;
                                                                  "Unit of Measure" := UnitOfMeasure.Description;
                                                                  GetServHeader;
                                                                  IF ServHeader."Language Code" <> '' THEN BEGIN
                                                                    UnitOfMeasureTranslation.SETRANGE(Code,"Unit of Measure Code");
                                                                    UnitOfMeasureTranslation.SETRANGE("Language Code",ServHeader."Language Code");
                                                                    IF UnitOfMeasureTranslation.FINDFIRST THEN
                                                                      "Unit of Measure" := UnitOfMeasureTranslation.Description;
                                                                  END;
                                                                END;

                                                                CASE Type OF
                                                                  Type::Item:
                                                                    BEGIN
                                                                      IF Quantity <> 0 THEN
                                                                        WhseValidateSourceLine.ServiceLineVerifyChange(Rec,xRec);
                                                                      GetItem;
                                                                      GetUnitCost;
                                                                      UpdateUnitPrice(FIELDNO("Unit of Measure Code"));
                                                                      "Gross Weight" := Item."Gross Weight" * "Qty. per Unit of Measure";
                                                                      "Net Weight" := Item."Net Weight" * "Qty. per Unit of Measure";
                                                                      "Unit Volume" := Item."Unit Volume" * "Qty. per Unit of Measure";
                                                                      "Units per Parcel" := ROUND(Item."Units per Parcel" / "Qty. per Unit of Measure",0.00001);
                                                                      IF "Qty. per Unit of Measure" > xRec."Qty. per Unit of Measure" THEN
                                                                        InitItemAppl(FALSE);
                                                                    END;
                                                                  Type::Resource:
                                                                    BEGIN
                                                                      IF "Unit of Measure Code" = '' THEN BEGIN
                                                                        GetResource;
                                                                        "Unit of Measure Code" := Resource."Base Unit of Measure";
                                                                        IF UnitOfMeasure.GET("Unit of Measure Code") THEN
                                                                          "Unit of Measure" := UnitOfMeasure.Description;
                                                                      END;
                                                                      ResUnitofMeasure.GET("No.","Unit of Measure Code");
                                                                      "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                                                                      UpdateUnitPrice(FIELDNO("Unit of Measure Code"));
                                                                      FindResUnitCost;
                                                                    END;
                                                                  Type::"G/L Account",Type::" ",Type::Cost:
                                                                    "Qty. per Unit of Measure" := 1;
                                                                END;

                                                                VALIDATE(Quantity);
                                                                CheckItemAvailable(FIELDNO("Unit of Measure Code"));
                                                                UpdateReservation(FIELDNO("Unit of Measure Code"));
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 5415;   ;Quantity (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                IF "Quantity (Base)" < 0 THEN
                                                                  FIELDERROR("Quantity (Base)",Text029);

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
                                                                IF "Qty. to Invoice (Base)" < 0 THEN
                                                                  FIELDERROR("Qty. to Invoice (Base)",Text029);

                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE("Qty. to Invoice","Qty. to Invoice (Base)");
                                                              END;

                                                   CaptionML=[DAN=Fakturer antal (basis);
                                                              ENU=Qty. to Invoice (Base)];
                                                   DecimalPlaces=0:5 }
    { 5418;   ;Qty. to Ship (Base) ;Decimal       ;OnValidate=BEGIN
                                                                IF "Qty. to Ship (Base)" < 0 THEN
                                                                  FIELDERROR("Qty. to Ship (Base)",Text029);

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
                                                                                                                 Source Type=CONST(5902),
                                                                                                                 Source Subtype=FIELD(Document Type),
                                                                                                                 Reservation Status=CONST(Reservation)));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure");
                                                                CALCFIELDS("Reserved Quantity");
                                                                Planned := "Reserved Quantity" = "Outstanding Quantity";
                                                              END;

                                                   CaptionML=[DAN=Reserveret antal (basis);
                                                              ENU=Reserved Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   OnValidate=BEGIN
                                                                CreateDim(
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DimMgt.TypeToTableID5(Type),"No.",
                                                                  DATABASE::Job,"Job No.");
                                                              END;

                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center];
                                                   Editable=No }
    { 5702;   ;Substitution Available;Boolean     ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Item Substitution" WHERE (Type=CONST(Item),
                                                                                                No.=FIELD(No.),
                                                                                                Substitute Type=CONST(Item)));
                                                   CaptionML=[DAN=Erstatningsvare findes;
                                                              ENU=Substitution Available];
                                                   Editable=No }
    { 5709;   ;Item Category Code  ;Code20        ;TableRelation="Item Category";
                                                   CaptionML=[DAN=Varekategorikode;
                                                              ENU=Item Category Code] }
    { 5710;   ;Nonstock            ;Boolean       ;CaptionML=[DAN=Katalogvare;
                                                              ENU=Nonstock];
                                                   Editable=No }
    { 5712;   ;Product Group Code  ;Code10        ;TableRelation="Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
                                                   ValidateTableRelation=No;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Product Groups became first level children of Item Categories.;
                                                   CaptionML=[DAN=Produktgruppekode;
                                                              ENU=Product Group Code] }
    { 5750;   ;Whse. Outstanding Qty. (Base);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" WHERE (Source Type=CONST(5902),
                                                                                                                              Source Subtype=FIELD(Document Type),
                                                                                                                              Source No.=FIELD(Document No.),
                                                                                                                              Source Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Udest. m�ngde p� lager (basis);
                                                              ENU=Whse. Outstanding Qty. (Base)];
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
                                                                    Text046,
                                                                    FIELDCAPTION("Requested Delivery Date"),
                                                                    FIELDCAPTION("Promised Delivery Date"));

                                                                IF "Requested Delivery Date" <> 0D THEN
                                                                  VALIDATE("Planned Delivery Date","Requested Delivery Date")
                                                              END;

                                                   CaptionML=[DAN=�nsket leveringsdato;
                                                              ENU=Requested Delivery Date] }
    { 5791;   ;Promised Delivery Date;Date        ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF "Promised Delivery Date" <> 0D THEN
                                                                  VALIDATE("Planned Delivery Date","Promised Delivery Date")
                                                                ELSE
                                                                  VALIDATE("Requested Delivery Date");
                                                              END;

                                                   CaptionML=[DAN=Bekr�ftet leveringsdato;
                                                              ENU=Promised Delivery Date] }
    { 5792;   ;Shipping Time       ;DateFormula   ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                              END;

                                                   AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Transporttid;
                                                              ENU=Shipping Time] }
    { 5794;   ;Planned Delivery Date;Date         ;OnValidate=BEGIN
                                                                VALIDATE("Needed by Date","Planned Delivery Date");
                                                              END;

                                                   CaptionML=[DAN=Planlagt leveringsdato;
                                                              ENU=Planned Delivery Date] }
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
                                                                  CLEAR("Shipping Time");

                                                                IF ShippingAgentServices.GET("Shipping Agent Code","Shipping Agent Service Code") THEN
                                                                  "Shipping Time" := ShippingAgentServices."Shipping Time"
                                                                ELSE BEGIN
                                                                  GetServHeader;
                                                                  "Shipping Time" := ServHeader."Shipping Time";
                                                                END;

                                                                IF ShippingAgentServices."Shipping Time" <> xRec."Shipping Time" THEN
                                                                  VALIDATE("Shipping Time","Shipping Time");
                                                              END;

                                                   CaptionML=[DAN=Spedit�rservicekode;
                                                              ENU=Shipping Agent Service Code] }
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
    { 5902;   ;Service Item No.    ;Code20        ;TableRelation="Service Item".No.;
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Quantity Shipped",0);
                                                                TESTFIELD("Shipment No.",'');
                                                                IF "Service Item No." <> '' THEN BEGIN
                                                                  IF "Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"] THEN
                                                                    EXIT;
                                                                  ServItemLine.RESET;
                                                                  ServItemLine.SETRANGE("Document Type","Document Type");
                                                                  ServItemLine.SETRANGE("Document No.","Document No.");
                                                                  ServItemLine.SETRANGE("Service Item No.","Service Item No.");
                                                                  ServItemLine.FIND('-');
                                                                  VALIDATE("Service Item Line No.",ServItemLine."Line No.");
                                                                END;

                                                                IF "Service Item No." <> xRec."Service Item No." THEN BEGIN
                                                                  IF "Service Item No." = '' THEN
                                                                    VALIDATE("Service Item Line No.",0);
                                                                  VALIDATE("No.");
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              IF "Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"] THEN BEGIN
                                                                ServItem.RESET;
                                                                ServItem.SETCURRENTKEY("Customer No.");
                                                                ServItem.FILTERGROUP(2);
                                                                ServItem.SETRANGE("Customer No.","Customer No.");
                                                                ServItem.FILTERGROUP(0);
                                                                IF PAGE.RUNMODAL(0,ServItem) = ACTION::LookupOK THEN
                                                                  VALIDATE("Service Item No.",ServItem."No.");
                                                              END
                                                              ELSE BEGIN
                                                                ServItemLine.RESET;
                                                                ServItemLine.SETCURRENTKEY("Document Type","Document No.","Service Item No.");
                                                                ServItemLine.FILTERGROUP(2);
                                                                ServItemLine.SETRANGE("Document Type","Document Type");
                                                                ServItemLine.SETRANGE("Document No.","Document No.");
                                                                ServItemLine.FILTERGROUP(0);
                                                                ServItemLine."Service Item No." := "Service Item No.";
                                                                IF PAGE.RUNMODAL(0,ServItemLine) = ACTION::LookupOK THEN
                                                                  VALIDATE("Service Item Line No.",ServItemLine."Line No.");
                                                              END;

                                                              IF "Service Item No." <> xRec."Service Item No." THEN
                                                                VALIDATE("No.");
                                                            END;

                                                   CaptionML=[DAN=Serviceartikelnr.;
                                                              ENU=Service Item No.] }
    { 5903;   ;Appl.-to Service Entry;Integer     ;AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Udl.servicepostl�benr.;
                                                              ENU=Appl.-to Service Entry];
                                                   Editable=No }
    { 5904;   ;Service Item Line No.;Integer      ;TableRelation="Service Item Line"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                                                                       Document No.=FIELD(Document No.));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Quantity Shipped",0);
                                                                ErrorIfAlreadySelectedSI("Service Item Line No.");
                                                                IF ServItemLine.GET("Document Type","Document No.","Service Item Line No.") THEN BEGIN
                                                                  "Service Item No." := ServItemLine."Service Item No.";
                                                                  "Service Item Serial No." := ServItemLine."Serial No.";
                                                                  "Fault Area Code" := ServItemLine."Fault Area Code";
                                                                  "Symptom Code" := ServItemLine."Symptom Code";
                                                                  "Fault Code" := ServItemLine."Fault Code";
                                                                  "Resolution Code" := ServItemLine."Resolution Code";
                                                                  "Service Price Group Code" := ServItemLine."Service Price Group Code";
                                                                  "Serv. Price Adjmt. Gr. Code" := ServItemLine."Serv. Price Adjmt. Gr. Code";
                                                                  IF "No." <> '' THEN
                                                                    VALIDATE("Contract No.",ServItemLine."Contract No.");
                                                                END ELSE BEGIN
                                                                  "Service Item No." := '';
                                                                  "Service Item Serial No." := '';
                                                                END;
                                                                CALCFIELDS("Service Item Line Description");
                                                              END;

                                                   CaptionML=[DAN=Serviceartikellinjenr.;
                                                              ENU=Service Item Line No.] }
    { 5905;   ;Service Item Serial No.;Code20     ;OnValidate=BEGIN
                                                                IF "Service Item Serial No." <> '' THEN BEGIN
                                                                  ServItemLine.RESET;
                                                                  ServItemLine.SETRANGE("Document Type","Document Type");
                                                                  ServItemLine.SETRANGE("Document No.","Document No.");
                                                                  ServItemLine.SETRANGE("Serial No.","Service Item Serial No.");
                                                                  ServItemLine.FIND('-');
                                                                  VALIDATE("Service Item Line No.",ServItemLine."Line No.");
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              ServItemLine.RESET;
                                                              ServItemLine.SETRANGE("Document Type","Document Type");
                                                              ServItemLine.SETRANGE("Document No.","Document No.");
                                                              ServItemLine."Serial No." := "Service Item Serial No.";
                                                              IF PAGE.RUNMODAL(0,ServItemLine) = ACTION::LookupOK THEN
                                                                VALIDATE("Service Item Line No.",ServItemLine."Line No.");
                                                            END;

                                                   CaptionML=[DAN=Serviceartikelserienr.;
                                                              ENU=Service Item Serial No.] }
    { 5906;   ;Service Item Line Description;Text50;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Lookup("Service Item Line".Description WHERE (Document Type=FIELD(Document Type),
                                                                                                             Document No.=FIELD(Document No.),
                                                                                                             Line No.=FIELD(Service Item Line No.)));
                                                   CaptionML=[DAN=Beskrivelse af serviceartikellinje;
                                                              ENU=Service Item Line Description];
                                                   Editable=No }
    { 5907;   ;Serv. Price Adjmt. Gr. Code;Code10 ;TableRelation="Service Price Adjustment Group";
                                                   CaptionML=[DAN=Serviceprisreg.gruppekode;
                                                              ENU=Serv. Price Adjmt. Gr. Code];
                                                   Editable=No }
    { 5908;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 5909;   ;Order Date          ;Date          ;CaptionML=[DAN=Ordredato;
                                                              ENU=Order Date];
                                                   Editable=No }
    { 5910;   ;Needed by Date      ;Date          ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF CurrFieldNo = FIELDNO("Needed by Date") THEN
                                                                  IF xRec."Needed by Date" <> 0D THEN
                                                                    TESTFIELD("Needed by Date");
                                                                IF "Needed by Date" <> 0D THEN
                                                                  CheckItemAvailable(FIELDNO("Needed by Date"));
                                                                IF CurrFieldNo = FIELDNO("Planned Delivery Date") THEN
                                                                  UpdateReservation(CurrFieldNo)
                                                                ELSE
                                                                  UpdateReservation(FIELDNO("Needed by Date"));
                                                                "Planned Delivery Date" := "Needed by Date";
                                                              END;

                                                   CaptionML=[DAN=Behovsdato;
                                                              ENU=Needed by Date] }
    { 5916;   ;Ship-to Code        ;Code10        ;TableRelation="Ship-to Address".Code WHERE (Customer No.=FIELD(Customer No.));
                                                   CaptionML=[DAN=Leveringsadressekode;
                                                              ENU=Ship-to Code];
                                                   Editable=No }
    { 5917;   ;Qty. to Consume     ;Decimal       ;OnValidate=BEGIN
                                                                IF CurrFieldNo = FIELDNO("Qty. to Consume") THEN
                                                                  CheckWarehouse;

                                                                IF "Qty. to Consume" < 0 THEN
                                                                  FIELDERROR("Qty. to Consume",Text029);

                                                                IF "Qty. to Consume" = MaxQtyToConsume THEN
                                                                  InitQtyToConsume
                                                                ELSE BEGIN
                                                                  "Qty. to Consume (Base)" := CalcBaseQty("Qty. to Consume");
                                                                  InitQtyToInvoice;
                                                                END;

                                                                IF "Qty. to Consume" > 0 THEN BEGIN
                                                                  "Qty. to Ship" := "Qty. to Consume";
                                                                  "Qty. to Ship (Base)" := "Qty. to Consume (Base)";
                                                                  "Qty. to Invoice" := 0;
                                                                  "Qty. to Invoice (Base)" := 0;
                                                                END;

                                                                IF ("Qty. to Consume" * Quantity < 0) OR
                                                                   (ABS("Qty. to Consume") > ABS(MaxQtyToConsume))
                                                                THEN
                                                                  ERROR(
                                                                    Text028,
                                                                    MaxQtyToConsume);
                                                                IF ("Qty. to Consume (Base)" * "Quantity (Base)" < 0) OR
                                                                   (ABS("Qty. to Consume (Base)") > ABS(MaxQtyToConsumeBase))
                                                                THEN
                                                                  ERROR(
                                                                    Text032,
                                                                    MaxQtyToConsumeBase);

                                                                IF (xRec."Qty. to Consume" <> "Qty. to Consume") OR
                                                                   (xRec."Qty. to Consume (Base)" <> "Qty. to Consume (Base)")
                                                                THEN
                                                                  VALIDATE("Line Discount %");
                                                              END;

                                                   CaptionML=[DAN=Antal til forbrug;
                                                              ENU=Qty. to Consume];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes }
    { 5918;   ;Quantity Consumed   ;Decimal       ;CaptionML=[DAN=Antal forbrugt;
                                                              ENU=Quantity Consumed];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5919;   ;Qty. to Consume (Base);Decimal     ;OnValidate=BEGIN
                                                                IF LineRequiresShipmentOrReceipt THEN
                                                                  EXIT;
                                                                IF "Qty. to Consume (Base)" < 0 THEN
                                                                  FIELDERROR("Qty. to Consume (Base)",Text029);

                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE("Qty. to Invoice","Qty. to Invoice (Base)");
                                                              END;

                                                   CaptionML=[DAN=Antal til forbrug (basis);
                                                              ENU=Qty. to Consume (Base)];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes }
    { 5920;   ;Qty. Consumed (Base);Decimal       ;CaptionML=[DAN=Antal forbrugt (basis);
                                                              ENU=Qty. Consumed (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5928;   ;Service Price Group Code;Code10    ;TableRelation="Service Price Group";
                                                   CaptionML=[DAN=Serviceprisgruppekode;
                                                              ENU=Service Price Group Code] }
    { 5929;   ;Fault Area Code     ;Code10        ;TableRelation="Fault Area";
                                                   OnValidate=BEGIN
                                                                IF "Fault Area Code" <> xRec."Fault Area Code" THEN
                                                                  "Fault Code" := '';
                                                              END;

                                                   CaptionML=[DAN=Fejlomr�dekode;
                                                              ENU=Fault Area Code] }
    { 5930;   ;Symptom Code        ;Code10        ;TableRelation="Symptom Code";
                                                   OnValidate=BEGIN
                                                                IF "Symptom Code" <> xRec."Symptom Code" THEN
                                                                  "Fault Code" := '';
                                                              END;

                                                   CaptionML=[DAN=Symptomkode;
                                                              ENU=Symptom Code] }
    { 5931;   ;Fault Code          ;Code10        ;TableRelation="Fault Code".Code WHERE (Fault Area Code=FIELD(Fault Area Code),
                                                                                          Symptom Code=FIELD(Symptom Code));
                                                   CaptionML=[DAN=Fejlkode;
                                                              ENU=Fault Code] }
    { 5932;   ;Resolution Code     ;Code10        ;TableRelation="Resolution Code";
                                                   CaptionML=[DAN=L�sningskode;
                                                              ENU=Resolution Code] }
    { 5933;   ;Exclude Warranty    ;Boolean       ;OnValidate=BEGIN
                                                                IF NOT (Type IN [Type::Item,Type::Resource]) THEN
                                                                  IF CurrFieldNo = FIELDNO("Exclude Warranty") THEN
                                                                    FIELDERROR(Type)
                                                                  ELSE
                                                                    EXIT;

                                                                IF CurrFieldNo = FIELDNO("Exclude Warranty") THEN BEGIN
                                                                  ServItemLine.GET("Document Type","Document No.","Service Item Line No.");
                                                                  ServItemLine.TESTFIELD(Warranty,TRUE);
                                                                  IF "Exclude Warranty" AND (NOT Warranty) THEN
                                                                    FIELDERROR(Warranty);
                                                                END;
                                                                IF HideWarrantyWarning = FALSE THEN
                                                                  IF "Fault Reason Code" <> '' THEN BEGIN
                                                                    FaultReasonCode.GET("Fault Reason Code");
                                                                    IF FaultReasonCode."Exclude Warranty Discount" AND
                                                                       NOT "Exclude Warranty"
                                                                    THEN
                                                                      ERROR(
                                                                        Text008,
                                                                        FIELDCAPTION("Exclude Warranty"),
                                                                        FaultReasonCode.FIELDCAPTION("Exclude Warranty Discount"),
                                                                        "Fault Reason Code",
                                                                        FaultReasonCode.TABLECAPTION);
                                                                  END;
                                                                IF HideWarrantyWarning = FALSE THEN
                                                                  IF "Exclude Warranty" <> xRec."Exclude Warranty" THEN
                                                                    IF NOT
                                                                       CONFIRM(
                                                                         Text009,
                                                                         FALSE,FIELDCAPTION("Exclude Warranty"))
                                                                    THEN BEGIN
                                                                      "Exclude Warranty" := xRec."Exclude Warranty";
                                                                      EXIT;
                                                                    END;
                                                                VALIDATE("Contract No.");
                                                                IF "Exclude Warranty" THEN
                                                                  VALIDATE(Warranty,FALSE)
                                                                ELSE
                                                                  VALIDATE(Warranty,TRUE);
                                                              END;

                                                   CaptionML=[DAN=Udeluk garanti;
                                                              ENU=Exclude Warranty];
                                                   Editable=Yes }
    { 5934;   ;Warranty            ;Boolean       ;OnValidate=BEGIN
                                                                UpdateDiscountsAmounts;
                                                              END;

                                                   CaptionML=[DAN=Garanti;
                                                              ENU=Warranty];
                                                   Editable=No }
    { 5936;   ;Contract No.        ;Code20        ;TableRelation="Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract));
                                                   OnValidate=VAR
                                                                Res@1001 : Record 156;
                                                                ServCost@1000 : Record 5905;
                                                                ContractGroup@1002 : Record 5966;
                                                                ContractServDisc@1003 : Record 5972;
                                                                ServContractHeader@1004 : Record 5965;
                                                              BEGIN
                                                                IF "Shipment Line No." <> 0 THEN
                                                                  IF "Shipment No." <> '' THEN
                                                                    FIELDERROR("Contract No.");

                                                                IF "Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"] THEN BEGIN
                                                                  IF "Contract No." <> xRec."Contract No." THEN BEGIN
                                                                    TESTFIELD("Appl.-to Service Entry",0);
                                                                    UpdateServDocRegister(FALSE);
                                                                  END;
                                                                END ELSE BEGIN
                                                                  ServMgtSetup.GET;
                                                                  IF NOT ServItem.GET("Service Item No.") THEN
                                                                    CLEAR(ServItem);
                                                                  IF "Contract No." = '' THEN
                                                                    "Contract Disc. %" := 0
                                                                  ELSE BEGIN
                                                                    GetServHeader;
                                                                    IF ServContractHeader.GET(ServContractHeader."Contract Type"::Contract,"Contract No.") THEN BEGIN
                                                                      IF (ServContractHeader."Starting Date" <= WORKDATE) AND NOT "Exclude Contract Discount" THEN BEGIN
                                                                        IF NOT ContractGroup.GET(ServContractHeader."Contract Group Code") THEN
                                                                          ContractGroup.INIT;
                                                                        IF NOT ContractGroup."Disc. on Contr. Orders Only" OR
                                                                           (ContractGroup."Disc. on Contr. Orders Only" AND (ServHeader."Contract No." <> ''))
                                                                        THEN BEGIN
                                                                          CASE Type OF
                                                                            Type::" ":
                                                                              "Contract Disc. %" := 0;
                                                                            Type::Item:
                                                                              BEGIN
                                                                                ContractServDisc.INIT;
                                                                                ContractServDisc."Contract Type" := ContractServDisc."Contract Type"::Contract;
                                                                                ContractServDisc."Contract No." := ServContractHeader."Contract No.";
                                                                                ContractServDisc.Type := ContractServDisc.Type::"Service Item Group";
                                                                                ContractServDisc."No." := ServItem."Service Item Group Code";
                                                                                ContractServDisc."Starting Date" := "Posting Date";
                                                                                CODEUNIT.RUN(CODEUNIT::"ContractDiscount-Find",ContractServDisc);
                                                                                "Contract Disc. %" := ContractServDisc."Discount %";
                                                                              END;
                                                                            Type::Resource:
                                                                              BEGIN
                                                                                Res.GET("No.");
                                                                                ContractServDisc.INIT;
                                                                                ContractServDisc."Contract Type" := ContractServDisc."Contract Type"::Contract;
                                                                                ContractServDisc."Contract No." := ServContractHeader."Contract No.";
                                                                                ContractServDisc.Type := ContractServDisc.Type::"Resource Group";
                                                                                ContractServDisc."No." := Res."Resource Group No.";
                                                                                ContractServDisc."Starting Date" := "Posting Date";
                                                                                CODEUNIT.RUN(CODEUNIT::"ContractDiscount-Find",ContractServDisc);
                                                                                "Contract Disc. %" := ContractServDisc."Discount %";
                                                                              END;
                                                                            Type::Cost:
                                                                              BEGIN
                                                                                ServCost.GET("No.");
                                                                                ContractServDisc.INIT;
                                                                                ContractServDisc."Contract Type" := ContractServDisc."Contract Type"::Contract;
                                                                                ContractServDisc."Contract No." := ServContractHeader."Contract No.";
                                                                                ContractServDisc.Type := ContractServDisc.Type::Cost;
                                                                                ContractServDisc."No." := "No.";
                                                                                ContractServDisc."Starting Date" := "Posting Date";
                                                                                CODEUNIT.RUN(CODEUNIT::"ContractDiscount-Find",ContractServDisc);
                                                                                "Contract Disc. %" := ContractServDisc."Discount %";
                                                                              END;
                                                                          END;
                                                                        END ELSE
                                                                          "Contract Disc. %" := 0;
                                                                      END;
                                                                    END ELSE
                                                                      "Contract Disc. %" := 0;
                                                                  END;

                                                                  IF Warranty THEN
                                                                    CASE Type OF
                                                                      Type::Item:
                                                                        "Warranty Disc. %" := ServItem."Warranty % (Parts)";
                                                                      Type::Resource:
                                                                        "Warranty Disc. %" := ServItem."Warranty % (Labor)";
                                                                      ELSE
                                                                        "Warranty Disc. %" := 0;
                                                                    END;

                                                                  UpdateDiscountsAmounts;
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              ServContractHeader@1000 : Record 5965;
                                                            BEGIN
                                                              GetServHeader;
                                                              ServContractHeader.FILTERGROUP(2);
                                                              ServContractHeader.SETRANGE("Customer No.",ServHeader."Customer No.");
                                                              ServContractHeader.SETRANGE("Contract Type",ServContractHeader."Contract Type"::Contract);
                                                              ServContractHeader.FILTERGROUP(0);
                                                              IF (PAGE.RUNMODAL(0,ServContractHeader) = ACTION::LookupOK) AND
                                                                 ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"])
                                                              THEN
                                                                VALIDATE("Contract No.",ServContractHeader."Contract No.");
                                                            END;

                                                   CaptionML=[DAN=Kontraktnr.;
                                                              ENU=Contract No.] }
    { 5938;   ;Contract Disc. %    ;Decimal       ;OnValidate=BEGIN
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Rabatpct. if�lge kontrakt;
                                                              ENU=Contract Disc. %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Editable=No }
    { 5939;   ;Warranty Disc. %    ;Decimal       ;OnValidate=BEGIN
                                                                UpdateUnitPrice(FIELDNO(Warranty));
                                                                UpdateAmounts;
                                                              END;

                                                   CaptionML=[DAN=Garantirabatpct.;
                                                              ENU=Warranty Disc. %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Editable=No }
    { 5965;   ;Component Line No.  ;Integer       ;CaptionML=[DAN=Komponentlinjenr.;
                                                              ENU=Component Line No.] }
    { 5966;   ;Spare Part Action   ;Option        ;CaptionML=[DAN=Handling i forb. m. reservedel;
                                                              ENU=Spare Part Action];
                                                   OptionCaptionML=[DAN=" ,Permanent,Midlertidig,Komponent udskiftet,Komponent installeret";
                                                                    ENU=" ,Permanent,Temporary,Component Replaced,Component Installed"];
                                                   OptionString=[ ,Permanent,Temporary,Component Replaced,Component Installed] }
    { 5967;   ;Fault Reason Code   ;Code10        ;TableRelation="Fault Reason Code";
                                                   OnValidate=VAR
                                                                NewWarranty@1000 : Boolean;
                                                                OldExcludeContractDiscount@1001 : Boolean;
                                                              BEGIN
                                                                SetHideWarrantyWarning := TRUE;
                                                                OldExcludeContractDiscount := "Exclude Contract Discount";
                                                                IF FaultReasonCode.GET("Fault Reason Code") THEN BEGIN
                                                                  IF FaultReasonCode."Exclude Warranty Discount" AND
                                                                     (NOT (Type IN [Type::Item,Type::Resource]))
                                                                  THEN
                                                                    ERROR(
                                                                      Text027,
                                                                      FIELDCAPTION("Fault Reason Code"),
                                                                      FaultReasonCode.Code,
                                                                      FaultReasonCode.FIELDCAPTION("Exclude Warranty Discount"));
                                                                  "Exclude Contract Discount" := FaultReasonCode."Exclude Contract Discount";
                                                                  NewWarranty := (NOT FaultReasonCode."Exclude Warranty Discount") AND
                                                                    ("Exclude Warranty" OR Warranty);
                                                                  VALIDATE("Exclude Warranty",
                                                                    FaultReasonCode."Exclude Warranty Discount" AND
                                                                    ("Exclude Warranty" OR Warranty));
                                                                  VALIDATE(Warranty,NewWarranty);
                                                                  IF OldExcludeContractDiscount AND (NOT "Exclude Contract Discount") THEN
                                                                    VALIDATE("Contract No.");
                                                                END ELSE BEGIN
                                                                  "Exclude Contract Discount" := FALSE;
                                                                  IF "Exclude Warranty" THEN BEGIN
                                                                    VALIDATE("Exclude Warranty",FALSE);
                                                                    VALIDATE(Warranty,TRUE);
                                                                  END ELSE
                                                                    IF OldExcludeContractDiscount <> "Exclude Contract Discount" THEN
                                                                      IF OldExcludeContractDiscount AND (NOT "Exclude Contract Discount") THEN
                                                                        VALIDATE("Contract No.")
                                                                      ELSE
                                                                        VALIDATE(Warranty);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Fejl�rsagskode;
                                                              ENU=Fault Reason Code] }
    { 5968;   ;Replaced Item No.   ;Code20        ;TableRelation=IF (Replaced Item Type=CONST(Item)) Item
                                                                 ELSE IF (Replaced Item Type=CONST(Service Item)) "Service Item";
                                                   CaptionML=[DAN=Udskiftet artikelnr.;
                                                              ENU=Replaced Item No.] }
    { 5969;   ;Exclude Contract Discount;Boolean  ;OnValidate=BEGIN
                                                                IF Type = Type::"G/L Account" THEN
                                                                  FIELDERROR(Type);

                                                                IF "Fault Reason Code" <> '' THEN BEGIN
                                                                  FaultReasonCode.GET("Fault Reason Code");
                                                                  IF FaultReasonCode."Exclude Contract Discount" AND
                                                                     NOT "Exclude Contract Discount"
                                                                  THEN
                                                                    ERROR(
                                                                      Text008,
                                                                      FIELDCAPTION("Exclude Contract Discount"),
                                                                      FaultReasonCode.FIELDCAPTION("Exclude Contract Discount"),
                                                                      "Fault Reason Code",
                                                                      FaultReasonCode.TABLECAPTION);
                                                                END;

                                                                IF "Exclude Contract Discount" <> xRec."Exclude Contract Discount" THEN BEGIN
                                                                  IF NOT
                                                                     CONFIRM(
                                                                       STRSUBSTNO(Text009,
                                                                         FIELDCAPTION("Exclude Contract Discount")),FALSE)
                                                                  THEN BEGIN
                                                                    "Exclude Contract Discount" := xRec."Exclude Contract Discount";
                                                                    EXIT;
                                                                  END;
                                                                  VALIDATE("Contract No.");
                                                                  VALIDATE(Warranty);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Udeluk kontraktrabat;
                                                              ENU=Exclude Contract Discount];
                                                   Editable=Yes }
    { 5970;   ;Replaced Item Type  ;Option        ;CaptionML=[DAN=Udskiftet artikeltype;
                                                              ENU=Replaced Item Type];
                                                   OptionCaptionML=[DAN=" ,Serviceartikel,Vare";
                                                                    ENU=" ,Service Item,Item"];
                                                   OptionString=[ ,Service Item,Item] }
    { 5994;   ;Price Adjmt. Status ;Option        ;CaptionML=[DAN=Prisreguleringsstatus;
                                                              ENU=Price Adjmt. Status];
                                                   OptionCaptionML=[DAN=" ,Reguleret,Redigeret";
                                                                    ENU=" ,Adjusted,Modified"];
                                                   OptionString=[ ,Adjusted,Modified];
                                                   Editable=No }
    { 5997;   ;Line Discount Type  ;Option        ;CaptionML=[DAN=Linjerabattype;
                                                              ENU=Line Discount Type];
                                                   OptionCaptionML=[DAN=" ,Garantirabat,Kontraktrabat,Linjerabat,Manuelt";
                                                                    ENU=" ,Warranty Disc.,Contract Disc.,Line Disc.,Manual"];
                                                   OptionString=[ ,Warranty Disc.,Contract Disc.,Line Disc.,Manual];
                                                   Editable=No }
    { 5999;   ;Copy Components From;Option        ;CaptionML=[DAN=Kopi�r komponenter fra;
                                                              ENU=Copy Components From];
                                                   OptionCaptionML=[DAN=Ingen,Styklistevare,Gammel serviceartikel,Gammel serviceartikel uden serienr.;
                                                                    ENU=None,Item BOM,Old Service Item,Old Serv.Item w/o Serial No.];
                                                   OptionString=None,Item BOM,Old Service Item,Old Serv.Item w/o Serial No. }
    { 6608;   ;Return Reason Code  ;Code10        ;TableRelation="Return Reason";
                                                   OnValidate=VAR
                                                                ReturnReason@1000 : Record 6635;
                                                              BEGIN
                                                                IF "Return Reason Code" = '' THEN
                                                                  UpdateUnitPrice(FIELDNO("Return Reason Code"));

                                                                IF ReturnReason.GET("Return Reason Code") THEN BEGIN
                                                                  IF ReturnReason."Default Location Code" <> '' THEN
                                                                    VALIDATE("Location Code",ReturnReason."Default Location Code");
                                                                  IF ReturnReason."Inventory Value Zero" THEN BEGIN
                                                                    VALIDATE("Unit Cost (LCY)",0);
                                                                    VALIDATE("Unit Price",0);
                                                                  END ELSE
                                                                    IF "Unit Price" = 0 THEN
                                                                      UpdateUnitPrice(FIELDNO("Return Reason Code"));
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Retur�rsagskode;
                                                              ENU=Return Reason Code] }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad linjerabat;
                                                              ENU=Allow Line Disc.] }
    { 7002;   ;Customer Disc. Group;Code20        ;TableRelation="Customer Discount Group";
                                                   OnValidate=BEGIN
                                                                IF Type = Type::Item THEN
                                                                  UpdateUnitPrice(FIELDNO("Customer Disc. Group"));
                                                              END;

                                                   CaptionML=[DAN=Debitorrabatgruppe;
                                                              ENU=Customer Disc. Group] }
    { 7300;   ;Qty. Picked         ;Decimal       ;OnValidate=BEGIN
                                                                "Qty. Picked (Base)" := CalcBaseQty("Qty. Picked");
                                                                "Completely Picked" := "Qty. Picked" >= 0;
                                                              END;

                                                   CaptionML=[DAN=Plukket antal;
                                                              ENU=Qty. Picked];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 7301;   ;Qty. Picked (Base)  ;Decimal       ;CaptionML=[DAN=Plukket antal (basis);
                                                              ENU=Qty. Picked (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 7302;   ;Completely Picked   ;Boolean       ;CaptionML=[DAN=Fuldt plukket;
                                                              ENU=Completely Picked];
                                                   Editable=No }
    { 7303;   ;Pick Qty. (Base)    ;Decimal       ;CaptionML=[DAN=Plukantal (basis);
                                                              ENU=Pick Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
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
    {    ;Document Type,Document No.,Line No.     ;SumIndexFields=Amount,Amount Including VAT,Outstanding Amount,Shipped Not Invoiced,Outstanding Amount (LCY),Shipped Not Invoiced (LCY),Line Amount;
                                                   Clustered=Yes }
    {    ;Type,No.,Order Date                      }
    {    ;Service Item No.,Type,Posting Date       }
    {    ;Document Type,Bill-to Customer No.,Currency Code;
                                                   SumIndexFields=Outstanding Amount,Shipped Not Invoiced,Outstanding Amount (LCY),Shipped Not Invoiced (LCY) }
    {    ;Document Type,Document No.,Service Item No. }
    {    ;Document Type,Document No.,Service Item Line No.,Serv. Price Adjmt. Gr. Code;
                                                   SumIndexFields=Line Amount }
    {    ;Document Type,Document No.,Service Item Line No.,Type,No. }
    {    ;Type,No.,Variant Code,Location Code,Needed by Date,Document Type,Shortcut Dimension 1 Code,Shortcut Dimension 2 Code;
                                                   SumIndexFields=Quantity (Base),Outstanding Qty. (Base) }
    {    ;Appl.-to Service Entry                   }
    {    ;Document Type,Document No.,Service Item Line No.,Component Line No. }
    {    ;Fault Reason Code                        }
    {    ;Document Type,Customer No.,Shipment No. ;SumIndexFields=Outstanding Amount (LCY) }
    {    ;Document Type,Document No.,Location Code }
    {    ;Document Type,Document No.,Type,No.      }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1085 : TextConst 'DAN=Du kan h�jst fakturere %1 enheder.;ENU=You cannot invoice more than %1 units.';
      Text001@1084 : TextConst 'DAN=Du kan h�jst fakturere %1 basisenheder.;ENU=You cannot invoice more than %1 base units.';
      Text002@1002 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text003@1086 : TextConst 'DAN=m� ikke v�re mindre end %1;ENU=must not be less than %1';
      Text004@1004 : TextConst 'DAN=Du skal bekr�fte %1 %2, fordi %3 ikke er lig med %4 i %5 %6.;ENU=You must confirm %1 %2, because %3 is not equal to %4 in %5 %6.';
      Text005@1005 : TextConst 'DAN=Opdateringen er afbrudt p� grund af advarslen.;ENU=The update has been interrupted to respect the warning.';
      Text006@1006 : TextConst 'DAN=Udskift komponent,Ny komponent,Ignorer;ENU=Replace Component,New Component,Ignore';
      Text007@1007 : TextConst 'DAN=Du skal v�lge en %1.;ENU=You must select a %1.';
      Text008@1008 : TextConst 'DAN=Du kan ikke �ndre v�rdien af feltet %1, fordi feltet %2 i vinduet Fejl�rsagskoder indeholder en markering for %3 %4.;ENU=You cannot change the value of the %1 field because the %2 field in the Fault Reason Codes window contains a check mark for the %3 %4.';
      Text009@1009 : TextConst 'DAN=Du har �ndre v�rdien i feltet %1.\Vil du forts�tte?;ENU=You have changed the value of the field %1.\Do you want to continue ?';
      Text010@1010 : TextConst 'DAN=%1 kan ikke v�re mindre end %2.;ENU=%1 cannot be less than %2.';
      Text011@1011 : TextConst 'DAN=N�r du udskifter en %1, skal antallet v�re 1.;ENU=When replacing a %1 the quantity must be 1.';
      Text012@1087 : TextConst 'DAN=Automatisk reservation er ikke mulig.\Vil du reservere varerne manuelt?;ENU=Automatic reservation is not possible.\Do you want to reserve items manually?';
      Text013@1013 : TextConst 'DAN=" skal v�re 0, n�r %1 er %2.";ENU=" must be 0 when %1 is %2."';
      Text015@1015 : TextConst 'DAN=Du har allerede valgt %1 %2 til udskiftning.;ENU=You have already selected %1 %2 for replacement.';
      Text016@1083 : TextConst 'DAN=Du kan h�jst levere %1 enheder.;ENU=You cannot ship more than %1 units.';
      Text017@1082 : TextConst 'DAN=Du kan h�jst levere %1 basisenheder.;ENU=You cannot ship more than %1 base units.';
      Text018@1018 : TextConst 'DAN=%1 %2 er st�rre end %3 og blev rettet til %4.;ENU=%1 %2 is greater than %3 and was adjusted to %4.';
      CompAlreadyReplacedErr@1021 : TextConst '@@@="%1 = Line No.";DAN=Den valgte komponent er allerede blevet udskiftet i servicelinjen %1.;ENU=The component that you selected has already been replaced in service line %1.';
      ServMgtSetup@1023 : Record 5911;
      ServiceLine@1024 : Record 5902;
      ServHeader@1026 : Record 5900;
      ServItem@1028 : Record 5940;
      ServItemLine@1030 : Record 5901;
      Item@1033 : Record 27;
      Resource@1089 : Record 156;
      Location@1017 : Record 14;
      FaultReasonCode@1037 : Record 5917;
      Currency@1043 : Record 4;
      CurrExchRate@1044 : Record 330;
      TempTrackingSpecification@1016 : TEMPORARY Record 336;
      SKU@1091 : Record 5700;
      DimMgt@1058 : Codeunit 408;
      SalesTaxCalculate@1061 : Codeunit 398;
      UOMMgt@1062 : Codeunit 5402;
      NonstockItemMgt@1064 : Codeunit 5703;
      ReserveServLine@1066 : Codeunit 99000842;
      WhseValidateSourceLine@1056 : Codeunit 5777;
      Select@1069 : Integer;
      FullAutoReservation@1078 : Boolean;
      HideReplacementDialog@1074 : Boolean;
      Text022@1019 : TextConst 'DAN=%1 kan ikke v�re st�rre end %2, der er angivet p� %3.;ENU=The %1 cannot be greater than the %2 set on the %3.';
      Text023@1077 : TextConst 'DAN=Du skal angive et serienr.;ENU=You must enter a serial number.';
      ReplaceServItemAction@1080 : Boolean;
      Text026@1068 : TextConst 'DAN=N�r du udskifter eller opretter en serviceartikelkomponent, kan du kun angive et helt tal i feltet %1.;ENU=When replacing or creating a service item component you may only enter a whole number into the %1 field.';
      Text027@1070 : TextConst 'DAN=Den %1 %2, der har en markering i feltet %3, kan ikke bogf�res,  hvis servicelinjetypen ikke er Vare eller Ressource.;ENU=The %1 %2 with a check mark in the %3 field cannot be entered if the service line type is other than Item or Resource.';
      Text028@1014 : TextConst 'DAN=Du kan ikke forbruge mere end %1 enheder.;ENU=You cannot consume more than %1 units.';
      Text029@1098 : TextConst 'DAN=skal v�re positiv;ENU=must be positive';
      Text030@1094 : TextConst 'DAN=skal v�re negativ;ENU=must be negative';
      Text031@1093 : TextConst 'DAN=Du skal indtaste %1.;ENU=You must specify %1.';
      Text032@1095 : TextConst 'DAN=Du kan ikke forbruge mere end %1 basisenheder.;ENU=You cannot consume more than %1 base units.';
      Text033@1001 : TextConst 'DAN=Den linje, du fors�ger at redigere, har den justerede pris.\;ENU=The line you are trying to change has the adjusted price.\';
      Text034@1000 : TextConst 'DAN=Vil du forts�tte?;ENU=Do you want to continue?';
      Text035@1076 : TextConst 'DAN=Lagersted;ENU=Warehouse';
      Text036@1102 : TextConst 'DAN=Lager;ENU=Inventory';
      Text037@1092 : TextConst 'DAN=Du kan ikke �ndre %1, n�r %2 er %3, og %4 er positiv.;ENU=You cannot change %1 when %2 is %3 and %4 is positive.';
      Text038@1088 : TextConst 'DAN=Du kan ikke �ndre %1, n�r %2 er %3, og %4 er negativ.;ENU=You cannot change %1 when %2 is %3 and %4 is negative.';
      Text039@1081 : TextConst 'DAN=Du kan ikke returnere mere end %1 enheder for %2 %3.;ENU=You cannot return more than %1 units for %2 %3.';
      Text040@1073 : TextConst 'DAN=Du skal bruge formularen %1 til at angive %2, hvis der anvendes varesporing.;ENU=You must use form %1 to enter %2, if item tracking is used.';
      Text041@1105 : TextConst 'DAN=Der var ingen ressourcelinjer at opdele.;ENU=There were no Resource Lines to split.';
      Text042@1072 : TextConst 'DAN=N�r du bogf�rer udligningsposten, �bnes %1 f�rst;ENU=When posting the Applied to Ledger Entry %1 will be opened first';
      HideCostWarning@1003 : Boolean;
      HideWarrantyWarning@1096 : Boolean;
      Text043@1097 : TextConst 'DAN=Du kan ikke �ndre v�rdien i feltet %1 manuelt, hvis %2 for denne linje er %3.;ENU=You cannot change the value of the %1 field manually if %2 for this line is %3.';
      Text044@1012 : TextConst 'DAN=Vil du opdele ressourcelinjen og bruge den til at oprette ressourcelinjer\til de andre serviceartikler med delte bel�b?;ENU=Do you want to split the resource line and use it to create resource lines\for the other service items with divided amounts?';
      Text045@1099 : TextConst 'DAN=Du kan ikke slette denne servicelinje, fordi der findes en eller flere servicelinjer for denne linje.;ENU=You cannot delete this service line because one or more service entries exist for this line.';
      Text046@1067 : TextConst 'DAN=%1 kan ikke �ndres, n�r %2 er udfyldt.;ENU=You cannot change the %1 when the %2 has been filled in.';
      Text047@1100 : TextConst 'DAN=%1 kan kun angives, n�r %2 er angivet.;ENU=%1 can only be set when %2 is set.';
      Text048@1101 : TextConst 'DAN=%1 kan ikke �ndres, n�r %2 er angivet.;ENU=%1 cannot be changed when %2 is set.';
      Text049@1103 : TextConst '@@@=Example: Inventory put-away is required for Line 50000.;DAN="%1 kr�ves til %2 = %3.";ENU="%1 is required for %2 = %3."';
      Text050@1104 : TextConst 'DAN=\De angivne oplysninger ignoreres muligvis af lageroperationerne.;ENU=\The entered information may be disregarded by warehouse operations.';
      StatusCheckSuspended@1106 : Boolean;
      Text051@1107 : TextConst 'DAN=Du kan ikke tilf�je en varelinje.;ENU=You cannot add an item line.';
      Text13600@1060000 : TextConst 'DAN=Du kan ikke angive %1, hvis %2 er "%3".;ENU=You cannot enter %1 if %2 is "%3".';
      Text052@1108 : TextConst 'DAN=Du kan ikke slette feltet %1, da der findes en eller flere serviceposter for denne linje.;ENU=You cannot change the %1 field because one or more service entries exist for this line.';
      Text053@1020 : TextConst 'DAN=Du kan ikke �ndre denne servicelinje, da der findes en eller flere serviceposter for denne linje.;ENU=You cannot modify the service line because one or more service entries exist for this line.';
      IsCustCrLimitChecked@1049 : Boolean;
      LocationChangedMsg@1055 : TextConst '@@@="%1 = Item No., %2 = Item serial No., %3 = Location code";DAN=Varen %1 med serienummeret %2 opbevares p� placeringen %3. Feltet Lokationskode p� servicelinjen vil blive opdateret.;ENU=Item %1 with serial number %2 is stored on location %3. The Location Code field on the service line will be updated.';

    LOCAL PROCEDURE CheckItemAvailable@3(CalledByFieldNo@1000 : Integer);
    VAR
      ItemCheckAvail@1001 : Codeunit 311;
    BEGIN
      IF "Needed by Date" = 0D THEN BEGIN
        GetServHeader;
        IF ServHeader."Order Date" <> 0D THEN
          VALIDATE("Needed by Date",ServHeader."Order Date")
        ELSE
          VALIDATE("Needed by Date",WORKDATE);
      END;

      IF CurrFieldNo <> CalledByFieldNo THEN
        EXIT;
      IF NOT GUIALLOWED THEN
        EXIT;
      IF Reserve = Reserve::Always THEN
        EXIT;
      IF (Type <> Type::Item) OR ("No." = '') THEN
        EXIT;
      IF Quantity <= 0 THEN
        EXIT;
      IF Nonstock THEN
        EXIT;
      IF NOT ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) THEN
        EXIT;

      IF ItemCheckAvail.ServiceInvLineCheck(Rec) THEN
        ItemCheckAvail.RaiseUpdateInterruptedError;
    END;

    [External]
    PROCEDURE CreateDim@26(Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20]);
    VAR
      SourceCodeSetup@1006 : Record 242;
      TableID@1007 : ARRAY [10] OF Integer;
      No@1008 : ARRAY [10] OF Code[20];
      DimensionSetID@1009 : Integer;
    BEGIN
      SourceCodeSetup.GET;
      GetServHeader;
      IF NOT ServItemLine.GET(ServHeader."Document Type",ServHeader."No.","Service Item Line No.") THEN
        ServItemLine.INIT;

      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      TableID[3] := Type3;
      No[3] := No3;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      DimensionSetID := ServItemLine."Dimension Set ID";
      IF DimensionSetID = 0 THEN
        DimensionSetID := ServHeader."Dimension Set ID";
      UpdateDimSetupFromDimSetID(TableID,No,DimensionSetID);
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup."Service Management",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",DimensionSetID,DATABASE::Customer);
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
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

    LOCAL PROCEDURE ReplaceServItem@8() : Boolean;
    VAR
      ServItemReplacement@1000 : Page 5985;
      SerialNo@1001 : Code[20];
      VariantCode@1002 : Code[10];
      LocationCode@1004 : Code[10];
    BEGIN
      ErrorIfAlreadySelectedSI("Service Item Line No.");
      CLEAR(ServItemReplacement);
      ServItemReplacement.SetValues("Service Item No.","No.","Variant Code");
      COMMIT;
      IF ServItemReplacement.RUNMODAL = ACTION::OK THEN BEGIN
        SerialNo := ServItemReplacement.ReturnSerialNo;
        VariantCode := ServItemReplacement.ReturnVariantCode;
        IF SerialNo = '' THEN
          CheckItemTrackingCode(Item)
        ELSE
          IF FindSerialNoStorageLocation(LocationCode,Item."No.",SerialNo,VariantCode) AND (LocationCode <> "Location Code") THEN BEGIN
            VALIDATE("Location Code",LocationCode);
            MESSAGE(STRSUBSTNO(LocationChangedMsg,Item."No.",SerialNo,LocationCode));
          END;

        "Variant Code" := VariantCode;
        VALIDATE(Quantity,1);
        TempTrackingSpecification.DELETEALL;
        TempTrackingSpecification."Serial No." := SerialNo;
        TempTrackingSpecification."Variant Code" := VariantCode;
        TempTrackingSpecification.INSERT;
        IF "Line No." <> 0 THEN
          InsertItemTracking;
        CASE ServItemReplacement.ReturnReplacement OF
          0:
            "Spare Part Action" := "Spare Part Action"::"Temporary";
          1:
            "Spare Part Action" := "Spare Part Action"::Permanent;
        END;
        "Copy Components From" := ServItemReplacement.ReturnCopyComponentsFrom;
        EXIT(TRUE);
      END;
      ReserveServLine.DeleteLine(Rec);
      Clearfields;
      VALIDATE("No.",'');
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE FindSerialNoStorageLocation@86(VAR LocationCode@1004 : Code[10];ItemNo@1000 : Code[20];SerialNo@1001 : Code[20];VariantCode@1003 : Code[10]) : Boolean;
    VAR
      ItemLedgerEntry@1002 : Record 32;
    BEGIN
      ItemLedgerEntry.SETRANGE("Item No.",ItemNo);
      ItemLedgerEntry.SETRANGE("Serial No.",SerialNo);
      ItemLedgerEntry.SETRANGE("Variant Code",VariantCode);
      ItemLedgerEntry.SETRANGE(Open,TRUE);
      IF NOT ItemLedgerEntry.FINDLAST THEN
        EXIT(FALSE);

      LocationCode := ItemLedgerEntry."Location Code";
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckItemTrackingCode@87(ReplacementItem@1001 : Record 27);
    VAR
      ItemTrackingCode@1000 : Record 6502;
    BEGIN
      IF ReplacementItem."Item Tracking Code" = '' THEN
        EXIT;

      ItemTrackingCode.GET(ReplacementItem."Item Tracking Code");
      IF ItemTrackingCode."SN Specific Tracking" THEN
        ERROR(Text023);
    END;

    LOCAL PROCEDURE ErrorIfAlreadySelectedSI@107(ServItemLineNo@1000 : Integer);
    BEGIN
      IF "Document Type" <> "Document Type"::Order THEN
        EXIT;
      IF ServItemLineNo <> 0 THEN BEGIN
        ServItemLine.GET("Document Type","Document No.",ServItemLineNo);
        IF (ServItemLine."Service Item No." = '') OR
           (ServItemLine."Item No." <> "No.")
        THEN
          EXIT;
      END;

      ServiceLine.RESET;
      ServiceLine.SETCURRENTKEY("Document Type","Document No.","Service Item Line No.",Type,"No.");
      ServiceLine.SETRANGE("Document Type","Document Type");
      ServiceLine.SETRANGE("Document No.","Document No.");
      ServiceLine.SETRANGE("Service Item Line No.",ServItemLineNo);
      ServiceLine.SETRANGE(Type,Type::Item);
      ServiceLine.SETFILTER("Line No.",'<>%1',"Line No.");
      ServiceLine.SETRANGE("No.","No.");
      IF ServiceLine.FINDFIRST THEN
        ERROR(Text015,Item.TABLECAPTION,"No.");
    END;

    LOCAL PROCEDURE CalculateDiscount@7();
    VAR
      SalesPriceCalcMgt@1002 : Codeunit 7000;
      Discounts@1000 : ARRAY [4] OF Decimal;
      i@1001 : Integer;
    BEGIN
      IF "Exclude Warranty" OR NOT Warranty THEN
        Discounts[1] := 0
      ELSE BEGIN
        IF ServItemLine.GET("Document Type","Document No.","Service Item Line No.") THEN
          CASE Type OF
            Type::Item:
              "Warranty Disc. %" := ServItemLine."Warranty % (Parts)";
            Type::Resource:
              "Warranty Disc. %" := ServItemLine."Warranty % (Labor)";
          END;
        Discounts[1] := "Warranty Disc. %";
      END;

      IF "Exclude Contract Discount" THEN
        IF CurrFieldNo = FIELDNO("Fault Reason Code") THEN
          Discounts[2] := "Line Discount %"
        ELSE
          Discounts[2] := 0
      ELSE
        Discounts[2] := "Contract Disc. %";

      ServHeader.GET("Document Type","Document No.");
      SalesPriceCalcMgt.FindServLineDisc(ServHeader,Rec);
      Discounts[3] := "Line Discount %";
      IF Discounts[3] > 100 THEN
        Discounts[3] := 100;

      "Line Discount Type" := "Line Discount Type"::" ";
      "Line Discount %" := 0;

      IF "Line Discount Type" = "Line Discount Type"::Manual THEN
        Discounts[4] := "Line Discount %"
      ELSE
        Discounts[4] := 0;

      FOR i := 1 TO 4 DO
        IF Discounts[i] > "Line Discount %" THEN BEGIN
          "Line Discount Type" := i;
          "Line Discount %" := Discounts[i];
        END;
    END;

    [Internal]
    PROCEDURE UpdateAmounts@13();
    VAR
      CustCheckCrLimit@1000 : Codeunit 312;
    BEGIN
      IF GUIALLOWED AND (CurrFieldNo <> 0) THEN
        ConfirmAdjPriceLineChange;

      GetServHeader;

      IF "Line Amount" <> xRec."Line Amount" THEN
        "VAT Difference" := 0;
      IF "Line Amount" <>
         ROUND(
           CalcChargeableQty * "Unit Price",
           Currency."Amount Rounding Precision") - "Line Discount Amount"
      THEN BEGIN
        "Line Amount" :=
          ROUND(CalcChargeableQty * "Unit Price",
            Currency."Amount Rounding Precision") - "Line Discount Amount";
        "VAT Difference" := 0;
      END;
      UpdateVATAmounts;

      InitOutstandingAmount;
      IF NOT IsCustCrLimitChecked AND (CurrFieldNo <> 0) THEN BEGIN
        IsCustCrLimitChecked := TRUE;
        CustCheckCrLimit.ServiceLineCheck(Rec);
      END;
      UpdateRemainingCostsAndAmounts;
    END;

    LOCAL PROCEDURE GetItem@12();
    BEGIN
      TESTFIELD("No.");
      IF "No." <> Item."No." THEN
        Item.GET("No.");
    END;

    LOCAL PROCEDURE GetDate@22() : Date;
    BEGIN
      IF ServHeader."Document Type" = ServHeader."Document Type"::Quote THEN
        EXIT(WORKDATE);

      EXIT(ServHeader."Posting Date");
    END;

    LOCAL PROCEDURE GetServHeader@14();
    BEGIN
      TESTFIELD("Document No.");
      IF ("Document Type" <> ServHeader."Document Type") OR ("Document No." <> ServHeader."No.") THEN BEGIN
        ServHeader.GET("Document Type","Document No.");
        IF ServHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          ServHeader.TESTFIELD("Currency Factor");
          Currency.GET(ServHeader."Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
      END;
    END;

    LOCAL PROCEDURE InitHeaderDefaults@90(ServHeader@1000 : Record 5900);
    VAR
      ServOrderMgt@1001 : Codeunit 5900;
    BEGIN
      "Customer No." := ServHeader."Customer No.";
      IF "Service Item Line No." <> 0 THEN BEGIN
        ServItemLine.GET(ServHeader."Document Type",ServHeader."No.","Service Item Line No.");
        "Ship-to Code" := ServItemLine."Ship-to Code";
      END ELSE
        "Ship-to Code" := ServHeader."Ship-to Code";
      IF "Posting Date" = 0D THEN
        "Posting Date" := ServHeader."Posting Date";
      "Document Type" := ServHeader."Document Type";

      "Order Date" := ServHeader."Order Date";
      "Replaced Item No." := '';
      "Component Line No." := 0;
      "Spare Part Action" := 0;
      "Price Adjmt. Status" := "Price Adjmt. Status"::" ";
      "Exclude Warranty" := FALSE;
      "Exclude Contract Discount" := FALSE;
      "Fault Reason Code" := '';

      "Bill-to Customer No." := ServHeader."Bill-to Customer No.";
      "Customer Price Group" := ServHeader."Customer Price Group";
      "Customer Disc. Group" := ServHeader."Customer Disc. Group";
      "Allow Line Disc." := ServHeader."Allow Line Disc.";
      "Bin Code" := '';
      "Transaction Type" := ServHeader."Transaction Type";
      "Transport Method" := ServHeader."Transport Method";
      "Exit Point" := ServHeader."Exit Point";
      Area := ServHeader.Area;
      "Transaction Specification" := ServHeader."Transaction Specification";

      "Location Code" := '';
      IF Type = Type::Resource THEN
        "Location Code" := ServOrderMgt.FindResLocationCode("No.",ServHeader."Order Date");
      IF "Location Code" = '' THEN
        "Location Code" := ServHeader."Location Code";
      IF Type = Type::Item THEN BEGIN
        IF (xRec."No." <> "No.") AND (Quantity <> 0) THEN
          WhseValidateSourceLine.ServiceLineVerifyChange(Rec,xRec);
        GetLocation("Location Code");
      END;

      "Gen. Bus. Posting Group" := ServHeader."Gen. Bus. Posting Group";
      "VAT Bus. Posting Group" := ServHeader."VAT Bus. Posting Group";
      "Tax Area Code" := ServHeader."Tax Area Code";
      "Tax Liable" := ServHeader."Tax Liable";
      "Responsibility Center" := ServHeader."Responsibility Center";
      "Posting Date" := ServHeader."Posting Date";
      "Currency Code" := ServHeader."Currency Code";
      "Account Code" := ServHeader."Account Code";

      "Shipping Agent Code" := ServHeader."Shipping Agent Code";
      "Shipping Agent Service Code" := ServHeader."Shipping Agent Service Code";
      "Shipping Time" := ServHeader."Shipping Time";

      OnAfterAssignHeaderValues(Rec,ServHeader);
    END;

    [Internal]
    PROCEDURE UpdateUnitPrice@19(CalledByFieldNo@1000 : Integer);
    VAR
      SalesPriceCalcMgt@1001 : Codeunit 7000;
    BEGIN
      OnBeforeUpdateUnitPrice(Rec,xRec,CalledByFieldNo,CurrFieldNo);

      TESTFIELD("Qty. per Unit of Measure");
      ServHeader.GET("Document Type","Document No.");

      CalculateDiscount;
      SalesPriceCalcMgt.FindServLinePrice(ServHeader,Rec,CalledByFieldNo);
      VALIDATE("Unit Price");

      OnAfterUpdateUnitPrice(Rec,xRec,CalledByFieldNo,CurrFieldNo);
    END;

    [External]
    PROCEDURE ShowDimensions@25();
    BEGIN
      IF ("Contract No." <> '') AND ("Appl.-to Service Entry" <> 0) THEN
        ViewDimensionSetEntries
      ELSE
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Document Type","Document No.","Line No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
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
      Reservation.SetServiceLine(Rec);
      Reservation.RUNMODAL;
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
      ReserveServLine.FilterReservFor(ReservEntry,Rec);
      IF Modal THEN
        PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
      ELSE
        PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    END;

    [External]
    PROCEDURE AutoReserve@39();
    VAR
      ReservMgt@1002 : Codeunit 99000845;
      QtyToReserve@1000 : Decimal;
      QtyToReserveBase@1001 : Decimal;
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      IF Reserve = Reserve::Never THEN
        FIELDERROR(Reserve);
      ReserveServLine.ReservQuantity(Rec,QtyToReserve,QtyToReserveBase);
      IF QtyToReserveBase <> 0 THEN BEGIN
        ReservMgt.SetServLine(Rec);
        ReservMgt.AutoReserve(FullAutoReservation,'',"Order Date",QtyToReserve,QtyToReserveBase);
        FIND;
        IF NOT FullAutoReservation THEN BEGIN
          COMMIT;
          IF CONFIRM(Text012,TRUE) THEN BEGIN
            ShowReservation;
            FIND;
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE Clearfields@6();
    VAR
      TempServLine@1000 : TEMPORARY Record 5902;
    BEGIN
      TempServLine := Rec;
      INIT;

      IF CurrFieldNo <> FIELDNO(Type) THEN
        "No." := TempServLine."No.";

      Type := TempServLine.Type;
      IF Type <> Type::" " THEN
        Quantity := TempServLine.Quantity;

      "Line No." := TempServLine."Line No.";
      VALIDATE("Service Item Line No.",TempServLine."Service Item Line No.");
      "Service Item No." := TempServLine."Service Item No.";
      "Service Item Serial No." := TempServLine."Service Item Serial No.";
      "Document Type" := TempServLine."Document Type";
      "Document No." := TempServLine."Document No.";
      "Gen. Bus. Posting Group" := TempServLine."Gen. Bus. Posting Group";
      "Order Date" := TempServLine."Order Date";
      "Customer No." := TempServLine."Customer No.";
      "Ship-to Code" := TempServLine."Ship-to Code";
      "Posting Date" := TempServLine."Posting Date";
      "System-Created Entry" := TempServLine."System-Created Entry";
      "Price Adjmt. Status" := "Price Adjmt. Status"::" ";
      "Time Sheet No." := TempServLine."Time Sheet No.";
      "Time Sheet Line No." := TempServLine."Time Sheet Line No.";
      "Time Sheet Date" := TempServLine."Time Sheet Date";
      IF "No." <> xRec."No." THEN
        VALIDATE("Job Planning Line No.",0);
    END;

    [External]
    PROCEDURE ShowNonstock@32();
    VAR
      NonstockItem@1000 : Record 5718;
      ConfigTemplateHeader@1002 : Record 8618;
      ItemTemplate@1001 : Record 1301;
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.",'');
      IF PAGE.RUNMODAL(PAGE::"Nonstock Item List",NonstockItem) = ACTION::LookupOK THEN BEGIN
        NonstockItem.TESTFIELD("Item Template Code");
        ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Item);
        ConfigTemplateHeader.SETRANGE(Code,NonstockItem."Item Template Code");
        ConfigTemplateHeader.SETRANGE(Enabled,TRUE);
        ConfigTemplateHeader.FINDFIRST;

        TestConfigTemplateLineField(NonstockItem."Item Template Code",ItemTemplate.FIELDNO("Gen. Prod. Posting Group"));
        TestConfigTemplateLineField(NonstockItem."Item Template Code",ItemTemplate.FIELDNO("Inventory Posting Group"));

        "No." := NonstockItem."Entry No.";
        NonstockItemMgt.NonStockFSM(Rec);
        VALIDATE("No.","No.");
        VALIDATE("Unit Price",NonstockItem."Unit Price");
      END;
    END;

    LOCAL PROCEDURE TestConfigTemplateLineField@102(ItemTemplateCode@1001 : Code[10];FieldNo@1002 : Integer);
    VAR
      ConfigTemplateLine@1000 : Record 8619;
    BEGIN
      ConfigTemplateLine.SETRANGE("Data Template Code",ItemTemplateCode);
      ConfigTemplateLine.SETRANGE("Table ID",DATABASE::Item);
      ConfigTemplateLine.SETRANGE("Field ID",FieldNo);
      ConfigTemplateLine.FINDFIRST;
      ConfigTemplateLine.TESTFIELD("Default Value");
    END;

    LOCAL PROCEDURE CalcBaseQty@11(Qty@1000 : Decimal) : Decimal;
    BEGIN
      TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    END;

    LOCAL PROCEDURE CopyFromCost@94();
    VAR
      ServCost@1000 : Record 5905;
      GLAcc@1001 : Record 15;
    BEGIN
      ServCost.GET("No.");
      IF ServCost."Cost Type" = ServCost."Cost Type"::Travel THEN
        IF ServHeader."Service Zone Code" <> ServCost."Service Zone Code" THEN
          IF NOT HideCostWarning THEN
            IF NOT
               CONFIRM(
                 STRSUBSTNO(
                   Text004,ServCost.TABLECAPTION,"No.",
                   ServCost.FIELDCAPTION("Service Zone Code"),
                   ServHeader.FIELDCAPTION("Service Zone Code"),
                   ServHeader.TABLECAPTION,ServHeader."No."),FALSE)
            THEN
              ERROR(Text005);
      Description := ServCost.Description;
      VALIDATE("Unit Cost (LCY)",ServCost."Default Unit Cost");
      "Unit Price" := ServCost."Default Unit Price";
      "Unit of Measure Code" := ServCost."Unit of Measure Code";
      GLAcc.GET(ServCost."Account No.");
      GLAcc.TESTFIELD("Gen. Prod. Posting Group");
      "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
      "Tax Group Code" := GLAcc."Tax Group Code";
      IF "Service Item Line No." <> 0 THEN
        IF FaultReasonCode.GET(ServItemLine."Fault Reason Code") AND
           (NOT FaultReasonCode."Exclude Warranty Discount")
        THEN
          VALIDATE("Fault Reason Code",ServItemLine."Fault Reason Code");
      Quantity := ServCost."Default Quantity";

      OnAfterAssignServCostValues(Rec,ServCost);
    END;

    LOCAL PROCEDURE CopyFromStdTxt@91();
    VAR
      StandardText@1000 : Record 7;
    BEGIN
      StandardText.GET("No.");
      Description := StandardText.Description;

      OnAfterAssignStdTxtValues(Rec,StandardText);
    END;

    LOCAL PROCEDURE CopyFromGLAccount@92();
    VAR
      GLAcc@1000 : Record 15;
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

      OnAfterAssignGLAccountValues(Rec,GLAcc);
    END;

    LOCAL PROCEDURE CopyFromItem@93();
    BEGIN
      GetItem;
      Item.TESTFIELD(Blocked,FALSE);
      Item.TESTFIELD("Inventory Posting Group");
      Item.TESTFIELD("Gen. Prod. Posting Group");
      Description := Item.Description;
      "Description 2" := Item."Description 2";
      GetUnitCost;
      "Allow Invoice Disc." := Item."Allow Invoice Disc.";
      "Units per Parcel" := Item."Units per Parcel";
      CALCFIELDS("Substitution Available");

      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
      "Tax Group Code" := Item."Tax Group Code";
      "Posting Group" := Item."Inventory Posting Group";
      "Item Category Code" := Item."Item Category Code";
      "Product Group Code" := Item."Product Group Code";
      "Variant Code" := '';
      Nonstock := Item."Created From Nonstock Item";
      "Unit of Measure Code" := Item."Sales Unit of Measure";

      IF ServHeader."Language Code" <> '' THEN
        GetItemTranslation;

      IF Item.Reserve = Item.Reserve::Optional THEN
        Reserve := ServHeader.Reserve
      ELSE
        Reserve := Item.Reserve;

      IF "Service Item Line No." <> 0 THEN BEGIN
        "Warranty Disc. %" := ServItemLine."Warranty % (Parts)";
        Warranty :=
          ServItemLine.Warranty AND
          (ServHeader."Order Date" >= ServItemLine."Warranty Starting Date (Parts)") AND
          (ServHeader."Order Date" <= ServItemLine."Warranty Ending Date (Parts)") AND
          NOT "Exclude Warranty";
        VALIDATE("Fault Reason Code",ServItemLine."Fault Reason Code");
      END ELSE BEGIN
        Warranty := FALSE;
        "Warranty Disc. %" := 0;
      END;

      OnAfterAssignItemValues(Rec,Item);
    END;

    LOCAL PROCEDURE CopyFromServItem@96();
    VAR
      ServItem2@1000 : Record 5940;
      ServItemComponent@1001 : Record 5941;
    BEGIN
      IF ServItem."Item No." = "No." THEN BEGIN
        ServItemLine.RESET;
        IF NOT HideReplacementDialog THEN BEGIN
          ReplaceServItemAction := ReplaceServItem;
          IF NOT ReplaceServItemAction THEN
            EXIT;
        END;
      END ELSE BEGIN
        ServItem.CALCFIELDS("Service Item Components");
        IF ServItem."Service Item Components" AND NOT HideReplacementDialog THEN BEGIN
          Select := STRMENU(Text006,3);
          CASE Select OF
            1:
              BEGIN
                COMMIT;
                ServItemComponent.RESET;
                ServItemComponent.SETRANGE(Active,TRUE);
                ServItemComponent.SETRANGE("Parent Service Item No.",ServItem."No.");
                IF PAGE.RUNMODAL(0,ServItemComponent) = ACTION::LookupOK THEN BEGIN
                  "Replaced Item Type" := ServItemComponent.Type + 1;
                  "Replaced Item No." := ServItemComponent."No.";
                  "Component Line No." := ServItemComponent."Line No.";
                  CheckIfServItemReplacement("Component Line No.");
                  IF ServItemComponent.Type = ServItemComponent.Type::"Service Item" THEN BEGIN
                    ServItem2.GET(ServItemComponent."No.");
                    "Warranty Disc. %" := ServItem2."Warranty % (Parts)";
                  END;
                  "Spare Part Action" := "Spare Part Action"::"Component Replaced";
                END ELSE
                  ERROR(Text007,ServItemComponent.TABLECAPTION);
              END;
            2:
              BEGIN
                "Replaced Item No." := '';
                "Component Line No." := 0;
                "Spare Part Action" := "Spare Part Action"::"Component Installed";
              END;
          END;
        END;
      END;

      OnAfterAssignServItemValues(Rec,ServItem,ServItemComponent);
    END;

    LOCAL PROCEDURE CopyFromResource@98();
    VAR
      Res@1000 : Record 156;
    BEGIN
      Res.GET("No.");
      Res.CheckResourcePrivacyBlocked(FALSE);
      Res.TESTFIELD(Blocked,FALSE);
      Res.TESTFIELD("Gen. Prod. Posting Group");
      Description := Res.Name;
      "Description 2" := Res."Name 2";
      IF "Service Item Line No." <> 0 THEN BEGIN
        "Warranty Disc. %" := ServItemLine."Warranty % (Labor)";
        Warranty :=
          ServItemLine.Warranty AND
          (ServHeader."Order Date" >= ServItemLine."Warranty Starting Date (Labor)") AND
          (ServHeader."Order Date" <= ServItemLine."Warranty Ending Date (Labor)") AND
          NOT "Exclude Warranty";
        VALIDATE("Fault Reason Code",ServItemLine."Fault Reason Code");
      END ELSE BEGIN
        Warranty := FALSE;
        "Warranty Disc. %" := 0;
      END;
      "Unit of Measure Code" := Res."Base Unit of Measure";
      VALIDATE("Unit Cost (LCY)",Res."Unit Cost");
      "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
      "Tax Group Code" := Res."Tax Group Code";
      FindResUnitCost;

      OnAfterAssignResourceValues(Rec,Res);
    END;

    [Internal]
    PROCEDURE ShowItemSub@30();
    VAR
      ItemSubstMgt@1000 : Codeunit 5701;
    BEGIN
      ItemSubstMgt.ItemServiceSubstGet(Rec);
    END;

    [External]
    PROCEDURE SetHideReplacementDialog@18(NewHideReplacementDialog@1000 : Boolean);
    BEGIN
      HideReplacementDialog := NewHideReplacementDialog;
    END;

    LOCAL PROCEDURE CheckIfServItemReplacement@9(ComponentLineNo@1000 : Integer);
    BEGIN
      IF "Service Item Line No." <> 0 THEN BEGIN
        ServiceLine.RESET;
        ServiceLine.SETCURRENTKEY("Document Type","Document No.","Service Item Line No.","Component Line No.");
        ServiceLine.SETRANGE("Document Type","Document Type");
        ServiceLine.SETRANGE("Document No.","Document No.");
        ServiceLine.SETRANGE("Service Item Line No.","Service Item Line No.");
        ServiceLine.SETFILTER("Line No.",'<>%1',"Line No.");
        ServiceLine.SETRANGE("Component Line No.",ComponentLineNo);
        ServiceLine.SETFILTER("Spare Part Action",'<>%1',"Spare Part Action"::" ");
        IF ServiceLine.FINDFIRST THEN
          ERROR(CompAlreadyReplacedErr,ServiceLine."Line No.");
      END;
    END;

    [External]
    PROCEDURE IsInbound@79() : Boolean;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Quote,"Document Type"::Order,ServiceLine."Document Type"::Invoice:
          EXIT("Quantity (Base)" < 0);
        ServiceLine."Document Type"::"Credit Memo":
          EXIT("Quantity (Base)" > 0);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE OpenItemTrackingLines@6500();
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      TESTFIELD("Quantity (Base)");
      ReserveServLine.CallItemTracking(Rec);
    END;

    LOCAL PROCEDURE InsertItemTracking@20();
    VAR
      ReservEntry@1001 : Record 337;
      CreateReservEntry@1000 : Codeunit 99000830;
    BEGIN
      ServiceLine := Rec;
      IF TempTrackingSpecification.FINDFIRST THEN BEGIN
        ReserveServLine.DeleteLine(Rec);
        CLEAR(CreateReservEntry);
        WITH ServiceLine DO BEGIN
          CreateReservEntry.CreateReservEntryFor(DATABASE::"Service Line","Document Type","Document No.",
            '',0,"Line No.","Qty. per Unit of Measure",Quantity,"Quantity (Base)",
            TempTrackingSpecification."Serial No.",TempTrackingSpecification."Lot No.");
          CreateReservEntry.CreateEntry("No.","Variant Code","Location Code",Description,
            0D,"Posting Date",0,ReservEntry."Reservation Status"::Surplus);
        END;
        TempTrackingSpecification.DELETEALL;
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

    LOCAL PROCEDURE GetDefaultBin@50();
    VAR
      Bin@1002 : Record 7354;
      BinType@1001 : Record 7303;
      WMSManagement@1000 : Codeunit 7302;
    BEGIN
      IF Type <> Type::Item THEN
        EXIT;

      "Bin Code" := '';

      IF ("Location Code" <> '') AND ("No." <> '') THEN BEGIN
        GetLocation("Location Code");
        IF NOT Location."Bin Mandatory" THEN
          EXIT;
        IF (NOT Location."Directed Put-away and Pick") OR ("Document Type" <> "Document Type"::Order) THEN BEGIN
          WMSManagement.GetDefaultBin("No.","Variant Code","Location Code","Bin Code");
          IF ("Document Type" <> "Document Type"::Order) AND ("Bin Code" <> '') AND Location."Directed Put-away and Pick"
          THEN BEGIN
            // Clear the bin code if the bin is not of pick type
            Bin.GET("Location Code","Bin Code");
            BinType.GET(Bin."Bin Type Code");
            IF NOT BinType.Pick THEN
              "Bin Code" := '';
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE GetItemTranslation@42();
    VAR
      ItemTranslation@1000 : Record 30;
    BEGIN
      GetServHeader;
      IF ItemTranslation.GET("No.","Variant Code",ServHeader."Language Code") THEN BEGIN
        Description := ItemTranslation.Description;
        "Description 2" := ItemTranslation."Description 2";
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

    LOCAL PROCEDURE FindResUnitCost@54();
    VAR
      ResCost@1000 : Record 202;
    BEGIN
      ResCost.INIT;
      ResCost.Code := "No.";
      ResCost."Work Type Code" := "Work Type Code";
      CODEUNIT.RUN(CODEUNIT::"Resource-Find Cost",ResCost);
      VALIDATE("Unit Cost (LCY)",ResCost."Unit Cost" * "Qty. per Unit of Measure");
    END;

    [External]
    PROCEDURE InitOutstanding@62();
    BEGIN
      IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
        "Outstanding Quantity" := Quantity;
        "Outstanding Qty. (Base)" := "Quantity (Base)";
      END ELSE BEGIN
        "Outstanding Quantity" := Quantity - "Quantity Shipped";
        "Outstanding Qty. (Base)" := "Quantity (Base)" - "Qty. Shipped (Base)";
        "Qty. Shipped Not Invoiced" := "Quantity Shipped" - "Quantity Invoiced" - "Quantity Consumed";
        "Qty. Shipped Not Invd. (Base)" := "Qty. Shipped (Base)" - "Qty. Invoiced (Base)" - "Qty. Consumed (Base)";
      END;
      CALCFIELDS("Reserved Quantity");
      Planned := "Reserved Quantity" = "Outstanding Quantity";
      "Completely Shipped" := (Quantity <> 0) AND ("Outstanding Quantity" = 0);
      InitOutstandingAmount;
    END;

    [External]
    PROCEDURE InitOutstandingAmount@61();
    VAR
      AmountInclVAT@1000 : Decimal;
    BEGIN
      IF (Quantity = 0) OR (CalcChargeableQty = 0) THEN BEGIN
        "Outstanding Amount" := 0;
        "Outstanding Amount (LCY)" := 0;
        "Shipped Not Invoiced" := 0;
        "Shipped Not Invoiced (LCY)" := 0;
      END ELSE BEGIN
        GetServHeader;
        AmountInclVAT := "Line Amount" - "Inv. Discount Amount";
        IF NOT ServHeader."Prices Including VAT" THEN
          IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
            AmountInclVAT := AmountInclVAT +
              ROUND(
                SalesTaxCalculate.CalculateTax(
                  "Tax Area Code","Tax Group Code","Tax Liable",ServHeader."Posting Date",
                  "Line Amount" - "Inv. Discount Amount","Quantity (Base)",ServHeader."Currency Factor"),
                Currency."Amount Rounding Precision")
          ELSE
            AmountInclVAT :=
              ROUND(
                AmountInclVAT *
                (1 + "VAT %" / 100 * (1 - ServHeader."VAT Base Discount %" / 100)),
                Currency."Amount Rounding Precision");
        VALIDATE(
          "Outstanding Amount",
          ROUND(
            AmountInclVAT * "Outstanding Quantity" / Quantity,
            Currency."Amount Rounding Precision"));
        IF "Document Type" <> "Document Type"::"Credit Memo" THEN
          VALIDATE(
            "Shipped Not Invoiced",
            ROUND(
              AmountInclVAT * "Qty. Shipped Not Invoiced" / CalcChargeableQty,
              Currency."Amount Rounding Precision"));
      END;

      OnAfterInitOutstandingAmount(Rec,ServHeader,Currency);
    END;

    [External]
    PROCEDURE InitQtyToShip@60();
    BEGIN
      IF LineRequiresShipmentOrReceipt THEN BEGIN
        "Qty. to Ship" := 0;
        "Qty. to Ship (Base)" := 0;
      END ELSE BEGIN
        "Qty. to Ship" := "Outstanding Quantity";
        "Qty. to Ship (Base)" := "Outstanding Qty. (Base)";
      END;
      VALIDATE("Qty. to Consume");
      InitQtyToInvoice;

      OnAfterInitQtyToShip(Rec,CurrFieldNo);
    END;

    [External]
    PROCEDURE InitQtyToInvoice@59();
    BEGIN
      "Qty. to Invoice" := MaxQtyToInvoice;
      "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
      "VAT Difference" := 0;
      CalcInvDiscToInvoice;

      OnAfterInitQtyToInvoice(Rec,CurrFieldNo);
    END;

    [External]
    PROCEDURE MaxQtyToInvoice@58() : Decimal;
    BEGIN
      IF "Document Type" = "Document Type"::"Credit Memo" THEN
        EXIT(Quantity);

      EXIT("Quantity Shipped" + "Qty. to Ship" - "Quantity Invoiced" - "Quantity Consumed" - "Qty. to Consume");
    END;

    LOCAL PROCEDURE MaxQtyToInvoiceBase@57() : Decimal;
    BEGIN
      IF "Document Type" = "Document Type"::"Credit Memo" THEN
        EXIT("Quantity (Base)");

      EXIT(
        "Qty. Shipped (Base)" + "Qty. to Ship (Base)" -
        "Qty. Invoiced (Base)" - "Qty. Consumed (Base)" -
        "Qty. to Consume (Base)");
    END;

    LOCAL PROCEDURE CalcInvDiscToInvoice@37();
    VAR
      OldInvDiscAmtToInv@1000 : Decimal;
    BEGIN
      GetServHeader;
      OldInvDiscAmtToInv := "Inv. Disc. Amount to Invoice";
      IF (Quantity = 0) OR (CalcChargeableQty = 0) THEN
        VALIDATE("Inv. Disc. Amount to Invoice",0)
      ELSE
        VALIDATE(
          "Inv. Disc. Amount to Invoice",
          ROUND(
            "Inv. Discount Amount" * "Qty. to Invoice" / CalcChargeableQty,
            Currency."Amount Rounding Precision"));

      IF OldInvDiscAmtToInv <> "Inv. Disc. Amount to Invoice" THEN BEGIN
        "Amount Including VAT" := "Amount Including VAT" - "VAT Difference";
        "VAT Difference" := 0;
      END;
    END;

    [External]
    PROCEDURE ItemExists@63(ItemNo@1000 : Code[20]) : Boolean;
    VAR
      Item2@1001 : Record 27;
    BEGIN
      IF Type = Type::Item THEN
        IF NOT Item2.GET(ItemNo) THEN
          EXIT(FALSE);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE InitItemAppl@40(OnlyApplTo@1000 : Boolean);
    BEGIN
      "Appl.-to Item Entry" := 0;
      IF NOT OnlyApplTo THEN
        "Appl.-from Item Entry" := 0;
    END;

    LOCAL PROCEDURE GetResource@49();
    BEGIN
      TESTFIELD("No.");
      IF "No." <> Resource."No." THEN
        Resource.GET("No.");
    END;

    LOCAL PROCEDURE GetCaptionClass@34(FieldNumber@1000 : Integer) : Text[80];
    BEGIN
      IF NOT ServHeader.GET("Document Type","Document No.") THEN BEGIN
        ServHeader."No." := '';
        ServHeader.INIT;
      END;
      IF ServHeader."Prices Including VAT" THEN
        EXIT('2,1,' + GetFieldCaption(FieldNumber));

      EXIT('2,0,' + GetFieldCaption(FieldNumber));
    END;

    LOCAL PROCEDURE GetFieldCaption@31(FieldNumber@1000 : Integer) : Text[100];
    VAR
      Field@1001 : Record 2000000041;
    BEGIN
      Field.GET(DATABASE::"Service Line",FieldNumber);
      EXIT(Field."Field Caption");
    END;

    LOCAL PROCEDURE UpdateVATAmounts@38();
    VAR
      ServiceLine2@1000 : Record 5902;
      TotalLineAmount@1005 : Decimal;
      TotalInvDiscAmount@1004 : Decimal;
      TotalAmount@1001 : Decimal;
      TotalAmountInclVAT@1002 : Decimal;
      TotalQuantityBase@1003 : Decimal;
    BEGIN
      GetServHeader;
      ServiceLine2.SETRANGE("Document Type","Document Type");
      ServiceLine2.SETRANGE("Document No.","Document No.");
      ServiceLine2.SETFILTER("Line No.",'<>%1',"Line No.");
      IF "Line Amount" = 0 THEN
        IF xRec."Line Amount" >= 0 THEN
          ServiceLine2.SETFILTER(Amount,'>%1',0)
        ELSE
          ServiceLine2.SETFILTER(Amount,'<%1',0)
      ELSE
        IF "Line Amount" > 0 THEN
          ServiceLine2.SETFILTER(Amount,'>%1',0)
        ELSE
          ServiceLine2.SETFILTER(Amount,'<%1',0);
      ServiceLine2.SETRANGE("VAT Identifier","VAT Identifier");
      ServiceLine2.SETRANGE("Tax Group Code","Tax Group Code");

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
             ["VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT"]) AND
            ("VAT %" <> 0))
        THEN
          IF NOT ServiceLine2.ISEMPTY THEN BEGIN
            ServiceLine2.CALCSUMS("Line Amount","Inv. Discount Amount",Amount,"Amount Including VAT","Quantity (Base)");
            TotalLineAmount := ServiceLine2."Line Amount";
            TotalInvDiscAmount := ServiceLine2."Inv. Discount Amount";
            TotalAmount := ServiceLine2.Amount;
            TotalAmountInclVAT := ServiceLine2."Amount Including VAT";
            TotalQuantityBase := ServiceLine2."Quantity (Base)";
          END;

        IF ServHeader."Prices Including VAT" THEN
          CASE "VAT Calculation Type" OF
            "VAT Calculation Type"::"Normal VAT",
            "VAT Calculation Type"::"Reverse Charge VAT":
              BEGIN
                Amount :=
                  (TotalLineAmount - TotalInvDiscAmount + "Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100) -
                  TotalAmount;
                "VAT Base Amount" :=
                  ROUND(
                    Amount * (1 - ServHeader."VAT Base Discount %" / 100),
                    Currency."Amount Rounding Precision");
                "Amount Including VAT" :=
                  ROUND(TotalAmount + Amount +
                    (TotalAmount + Amount) * (1 - ServHeader."VAT Base Discount %" / 100) * "VAT %" / 100 -
                    TotalAmountInclVAT,Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
              END;
            "VAT Calculation Type"::"Full VAT":
              BEGIN
                Amount := 0;
                "VAT Base Amount" := 0;
              END;
            "VAT Calculation Type"::"Sales Tax":
              BEGIN
                ServHeader.TESTFIELD("VAT Base Discount %",0);
                Amount :=
                  SalesTaxCalculate.ReverseCalculateTax(
                    "Tax Area Code","Tax Group Code","Tax Liable",ServHeader."Posting Date",
                    TotalAmountInclVAT + "Amount Including VAT",TotalQuantityBase + "Quantity (Base)",
                    ServHeader."Currency Factor") -
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
              VALIDATE(Amount,ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision"));
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
                      "Tax Area Code","Tax Group Code","Tax Liable",ServHeader."Posting Date",
                      TotalAmount + Amount,TotalQuantityBase + "Quantity (Base)",
                      ServHeader."Currency Factor"),Currency."Amount Rounding Precision") -
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
    PROCEDURE MaxQtyToConsume@47() : Decimal;
    BEGIN
      EXIT(Quantity - "Quantity Shipped");
    END;

    [External]
    PROCEDURE MaxQtyToConsumeBase@46() : Decimal;
    BEGIN
      EXIT("Quantity (Base)" - "Qty. Shipped (Base)");
    END;

    [External]
    PROCEDURE InitQtyToConsume@48();
    BEGIN
      "Qty. to Consume" := MaxQtyToConsume;
      "Qty. to Consume (Base)" := MaxQtyToConsumeBase;
      OnAfterInitQtyToConsume(Rec,CurrFieldNo);

      InitQtyToInvoice;
    END;

    [External]
    PROCEDURE SetServHeader@24(NewServHeader@1000 : Record 5900);
    BEGIN
      ServHeader := NewServHeader;

      IF ServHeader."Currency Code" = '' THEN
        Currency.InitRoundingPrecision
      ELSE BEGIN
        ServHeader.TESTFIELD("Currency Factor");
        Currency.GET(ServHeader."Currency Code");
        Currency.TESTFIELD("Amount Rounding Precision");
      END;
    END;

    [External]
    PROCEDURE CalcVATAmountLines@35(QtyType@1000 : 'General,Invoicing,Shipping,Consuming';VAR ServHeader@1001 : Record 5900;VAR ServiceLine@1002 : Record 5902;VAR VATAmountLine@1003 : Record 290;isShip@1008 : Boolean);
    VAR
      Cust@1013 : Record 18;
      CustPostingGroup@1014 : Record 92;
      Currency@1004 : Record 4;
      SalesSetup@1009 : Record 311;
      QtyFactor@1006 : Decimal;
      TotalVATAmount@1012 : Decimal;
      RoundingLineInserted@1011 : Boolean;
    BEGIN
      Currency.Initialize(ServHeader."Currency Code");

      VATAmountLine.DELETEALL;

      WITH ServiceLine DO BEGIN
        SETRANGE("Document Type",ServHeader."Document Type");
        SETRANGE("Document No.",ServHeader."No.");
        SETFILTER(Type,'>0');
        SETFILTER(Quantity,'<>0');
        SalesSetup.GET;
        IF SalesSetup."Invoice Rounding" THEN BEGIN
          Cust.GET(ServHeader."Bill-to Customer No.");
          CustPostingGroup.GET(Cust."Customer Posting Group");
        END;
        IF FINDSET THEN
          REPEAT
            IF Type = Type::"G/L Account" THEN
              RoundingLineInserted := ("No." = CustPostingGroup."Invoice Rounding Account") OR RoundingLineInserted;
            IF "VAT Calculation Type" IN
               ["VAT Calculation Type"::"Reverse Charge VAT","VAT Calculation Type"::"Sales Tax"]
            THEN
              "VAT %" := 0;
            IF NOT
               VATAmountLine.GET("VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0)
            THEN
              VATAmountLine.InsertNewLine(
                "VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"VAT %","Line Amount" >= 0,FALSE);

            QtyFactor := 0;
            CASE QtyType OF
              QtyType::Invoicing:
                BEGIN
                  CASE TRUE OF
                    ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) AND NOT isShip:
                      BEGIN
                        IF CalcChargeableQty <> 0 THEN
                          QtyFactor := GetAbsMin("Qty. to Invoice","Qty. Shipped Not Invoiced") / CalcChargeableQty;
                        VATAmountLine.Quantity :=
                          VATAmountLine.Quantity + GetAbsMin("Qty. to Invoice (Base)","Qty. Shipped Not Invd. (Base)");
                      END;
                    "Document Type" IN ["Document Type"::"Credit Memo"]:
                      BEGIN
                        QtyFactor := GetAbsMin("Qty. to Invoice",Quantity) / Quantity;
                        VATAmountLine.Quantity += GetAbsMin("Qty. to Invoice (Base)","Quantity (Base)");
                      END;
                    ELSE BEGIN
                      IF CalcChargeableQty <> 0 THEN
                        QtyFactor := "Qty. to Invoice" / CalcChargeableQty;
                      VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                    END;
                  END;
                  VATAmountLine."Line Amount" += ROUND("Line Amount" * QtyFactor,Currency."Amount Rounding Precision");
                  IF "Allow Invoice Disc." THEN
                    VATAmountLine."Inv. Disc. Base Amount" += ROUND("Line Amount" * QtyFactor,Currency."Amount Rounding Precision");
                  VATAmountLine."Invoice Discount Amount" += "Inv. Disc. Amount to Invoice";
                  VATAmountLine."VAT Difference" += "VAT Difference";
                  VATAmountLine.MODIFY;
                END;
              QtyType::Shipping:
                BEGIN
                  IF "Document Type" IN
                     ["Document Type"::"Credit Memo"]
                  THEN BEGIN
                    QtyFactor := 1;
                    VATAmountLine.Quantity += "Quantity (Base)";
                  END ELSE BEGIN
                    QtyFactor := "Qty. to Ship" / Quantity;
                    VATAmountLine.Quantity += "Qty. to Ship (Base)";
                  END;
                  VATAmountLine."Line Amount" += ROUND("Line Amount" * QtyFactor,Currency."Amount Rounding Precision");
                  IF "Allow Invoice Disc." THEN
                    VATAmountLine."Inv. Disc. Base Amount" += ROUND("Line Amount" * QtyFactor,Currency."Amount Rounding Precision");
                  VATAmountLine."Invoice Discount Amount" +=
                    ROUND("Inv. Discount Amount" * QtyFactor,Currency."Amount Rounding Precision");
                  VATAmountLine."VAT Difference" += "VAT Difference";
                  VATAmountLine.MODIFY;
                END;
              QtyType::Consuming:
                BEGIN
                  CASE TRUE OF
                    ("Document Type" = "Document Type"::Order) AND NOT isShip:
                      BEGIN
                        QtyFactor := GetAbsMin("Qty. to Consume","Qty. Shipped Not Invoiced") / Quantity;
                        VATAmountLine.Quantity += GetAbsMin("Qty. to Consume (Base)","Qty. Shipped Not Invd. (Base)");
                      END;
                    ELSE BEGIN
                      QtyFactor := "Qty. to Consume" / Quantity;
                      VATAmountLine.Quantity += "Qty. to Consume (Base)";
                    END;
                  END;
                END
              ELSE BEGIN
                VATAmountLine.Quantity += "Quantity (Base)";
                VATAmountLine."Line Amount" += "Line Amount";
                IF "Allow Invoice Disc." THEN
                  VATAmountLine."Inv. Disc. Base Amount" += "Line Amount";
                VATAmountLine."Invoice Discount Amount" += "Inv. Discount Amount";
                VATAmountLine."VAT Difference" += "VAT Difference";
                VATAmountLine.MODIFY;
              END;
            END;
            TotalVATAmount += "Amount Including VAT" - Amount + "VAT Difference";
          UNTIL NEXT = 0;
        SETRANGE(Type);
        SETRANGE(Quantity);
      END;

      VATAmountLine.UpdateLines(
        TotalVATAmount,Currency,ServHeader."Currency Factor",ServHeader."Prices Including VAT",ServHeader."VAT Base Discount %",
        ServHeader."Tax Area Code",ServHeader."Tax Liable",ServHeader."Posting Date");

      IF RoundingLineInserted AND (TotalVATAmount <> 0) THEN
        IF VATAmountLine.GET(ServiceLine."VAT Identifier",ServiceLine."VAT Calculation Type",
             ServiceLine."Tax Group Code",FALSE,ServiceLine."Line Amount" >= 0)
        THEN BEGIN
          VATAmountLine."VAT Amount" := VATAmountLine."VAT Amount" + TotalVATAmount;
          VATAmountLine."Amount Including VAT" := VATAmountLine."Amount Including VAT" + TotalVATAmount;
          VATAmountLine."Calculated VAT Amount" := VATAmountLine."Calculated VAT Amount" + TotalVATAmount;
          VATAmountLine.MODIFY;
        END;
    END;

    LOCAL PROCEDURE GetAbsMin@56(QTyToHandle@1000 : Decimal;QtyHandled@1001 : Decimal) : Decimal;
    BEGIN
      IF QtyHandled = 0 THEN
        EXIT(QTyToHandle);
      IF ABS(QtyHandled) < ABS(QTyToHandle) THEN
        EXIT(QtyHandled);

      EXIT(QTyToHandle);
    END;

    [External]
    PROCEDURE UpdateVATOnLines@36(QtyType@1000 : 'General,Invoicing,Shipping';VAR ServHeader@1001 : Record 5900;VAR ServiceLine@1002 : Record 5902;VAR VATAmountLine@1003 : Record 290);
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
    BEGIN
      IF QtyType = QtyType::Shipping THEN
        EXIT;
      IF ServHeader."Currency Code" = '' THEN
        Currency.InitRoundingPrecision
      ELSE
        Currency.GET(ServHeader."Currency Code");

      TempVATAmountLineRemainder.DELETEALL;

      WITH ServiceLine DO BEGIN
        SETRANGE("Document Type",ServHeader."Document Type");
        SETRANGE("Document No.",ServHeader."No.");
        SETFILTER(Type,'>0');
        SETFILTER(Quantity,'<>0');
        CASE QtyType OF
          QtyType::Invoicing:
            SETFILTER("Qty. to Invoice",'<>0');
          QtyType::Shipping:
            SETFILTER("Qty. to Ship",'<>0');
        END;
        LOCKTABLE;
        IF FIND('-') THEN
          REPEAT
            VATAmountLine.GET("VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0);
            IF VATAmountLine.Modified THEN BEGIN
              IF NOT
                 TempVATAmountLineRemainder.GET(
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
                  ROUND("Line Amount" * "Qty. to Invoice" / CalcChargeableQty,Currency."Amount Rounding Precision");

              IF "Allow Invoice Disc." THEN BEGIN
                IF VATAmountLine."Inv. Disc. Base Amount" = 0 THEN
                  InvDiscAmount := 0
                ELSE BEGIN
                  TempVATAmountLineRemainder."Invoice Discount Amount" +=
                    VATAmountLine."Invoice Discount Amount" * LineAmountToInvoice / VATAmountLine."Inv. Disc. Base Amount";
                  InvDiscAmount :=
                    ROUND(
                      TempVATAmountLineRemainder."Invoice Discount Amount",Currency."Amount Rounding Precision");
                  TempVATAmountLineRemainder."Invoice Discount Amount" -= InvDiscAmount;
                END;
                IF QtyType = QtyType::General THEN BEGIN
                  "Inv. Discount Amount" := InvDiscAmount;
                  CalcInvDiscToInvoice;
                END ELSE
                  "Inv. Disc. Amount to Invoice" := InvDiscAmount;
              END ELSE
                InvDiscAmount := 0;

              IF QtyType = QtyType::General THEN
                IF ServHeader."Prices Including VAT" THEN BEGIN
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
                      NewAmount * (1 - ServHeader."VAT Base Discount %" / 100),
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
                        NewAmount * (1 - ServHeader."VAT Base Discount %" / 100),
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
              MODIFY;

              TempVATAmountLineRemainder."Amount Including VAT" :=
                NewAmountIncludingVAT - ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
              TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
              TempVATAmountLineRemainder."VAT Difference" := VATDifference - "VAT Difference";
              TempVATAmountLineRemainder.MODIFY;
            END;
          UNTIL NEXT = 0;
        SETRANGE(Type);
        SETRANGE(Quantity);
        SETRANGE("Qty. to Invoice");
        SETRANGE("Qty. to Ship");
      END;
    END;

    LOCAL PROCEDURE CalcUnitCost@5809(ItemLedgEntry@1000 : Record 32) : Decimal;
    VAR
      ValueEntry@1001 : Record 5802;
      UnitCost@1004 : Decimal;
    BEGIN
      WITH ValueEntry DO BEGIN
        SETCURRENTKEY("Item Ledger Entry No.");
        SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
        CALCSUMS("Cost Amount (Actual)","Cost Amount (Expected)");
        UnitCost :=
          ("Cost Amount (Expected)" + "Cost Amount (Actual)") / ItemLedgEntry.Quantity;
      END;

      EXIT(ABS(UnitCost * "Qty. per Unit of Measure"));
    END;

    LOCAL PROCEDURE SelectItemEntry@45(CurrentFieldNo@1000 : Integer);
    VAR
      ItemLedgEntry@1001 : Record 32;
      ServLine3@1002 : Record 5902;
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
      END;
      IF PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
        ServLine3 := Rec;
        IF CurrentFieldNo = FIELDNO("Appl.-to Item Entry") THEN
          ServLine3.VALIDATE("Appl.-to Item Entry",ItemLedgEntry."Entry No.")
        ELSE
          ServLine3.VALIDATE("Appl.-from Item Entry",ItemLedgEntry."Entry No.");
        CheckItemAvailable(CurrentFieldNo);
        Rec := ServLine3;
      END;
    END;

    [External]
    PROCEDURE CalcChargeableQty@1() : Decimal;
    BEGIN
      EXIT(Quantity - "Quantity Consumed" - "Qty. to Consume");
    END;

    [External]
    PROCEDURE SignedXX@5(Value@1000 : Decimal) : Decimal;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Quote,
        "Document Type"::Order,
        "Document Type"::Invoice:
          EXIT(-Value);
        "Document Type"::"Credit Memo":
          EXIT(Value);
      END;
    END;

    [External]
    PROCEDURE IsShipment@55() : Boolean;
    BEGIN
      EXIT(SignedXX("Quantity (Base)") < 0);
    END;

    LOCAL PROCEDURE AdjustMaxLabourUnitPrice@23(ResUnitPrice@1000 : Decimal);
    VAR
      Res@1001 : Record 156;
    BEGIN
      IF Type <> Type::Resource THEN
        EXIT;
      IF (ResUnitPrice > ServHeader."Max. Labor Unit Price") AND
         (ServHeader."Max. Labor Unit Price" <> 0)
      THEN BEGIN
        Res.GET("No.");
        "Unit Price" := ServHeader."Max. Labor Unit Price";
        MESSAGE(
          STRSUBSTNO(
            Text018,
            Res.TABLECAPTION,FIELDCAPTION("Unit Price"),
            ServHeader.FIELDCAPTION("Max. Labor Unit Price"),
            ServHeader."Max. Labor Unit Price"));
      END
    END;

    [External]
    PROCEDURE CheckLineDiscount@33(LineDisc@1000 : Decimal);
    BEGIN
      IF ("Line Discount Type" = "Line Discount Type"::"Contract Disc.") AND
         ("Contract No." <> '') AND NOT "Exclude Contract Discount" AND
         NOT ("Document Type" = "Document Type"::Invoice)
      THEN
        ERROR(Text043,FIELDCAPTION("Line Discount %"),FIELDCAPTION("Line Discount Type"),"Line Discount Type");

      IF (LineDisc < "Warranty Disc. %") AND
         Warranty AND NOT "Exclude Warranty"
      THEN
        ERROR(Text010,FIELDCAPTION("Line Discount %"),FIELDCAPTION("Warranty Disc. %"));

      IF "Line Discount %" <> 0 THEN
        "Line Discount Type" := "Line Discount Type"::Manual
      ELSE
        "Line Discount Type" := "Line Discount Type"::" ";
    END;

    [External]
    PROCEDURE ConfirmAdjPriceLineChange@41();
    BEGIN
      IF "Price Adjmt. Status" = "Price Adjmt. Status"::Adjusted THEN
        IF CONFIRM(Text033 + Text034,FALSE) THEN
          "Price Adjmt. Status" := "Price Adjmt. Status"::Modified
        ELSE
          ERROR('');
    END;

    [External]
    PROCEDURE SetHideCostWarning@2(Value@1000 : Boolean);
    BEGIN
      HideCostWarning := Value;
    END;

    LOCAL PROCEDURE CheckApplFromItemLedgEntry@157(VAR ItemLedgEntry@1000 : Record 32);
    VAR
      ItemTrackingLines@1003 : Page 6510;
      QtyBase@1001 : Decimal;
      ShippedQtyNotReturned@1002 : Decimal;
    BEGIN
      IF "Appl.-from Item Entry" = 0 THEN
        EXIT;

      TESTFIELD(Type,Type::Item);
      TESTFIELD(Quantity);
      IF "Document Type" IN ["Document Type"::"Credit Memo"] THEN BEGIN
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

      IF "Document Type" IN ["Document Type"::"Credit Memo"] THEN
        QtyBase := "Quantity (Base)"
      ELSE
        QtyBase := "Qty. to Ship (Base)";

      IF ABS(QtyBase) > -ItemLedgEntry."Shipped Qty. Not Returned" THEN BEGIN
        IF "Qty. per Unit of Measure" = 0 THEN
          ShippedQtyNotReturned := ItemLedgEntry."Shipped Qty. Not Returned"
        ELSE
          ShippedQtyNotReturned :=
            ROUND(ItemLedgEntry."Shipped Qty. Not Returned" / "Qty. per Unit of Measure",0.00001);
        ERROR(
          Text039,
          -ShippedQtyNotReturned,ItemLedgEntry.TABLECAPTION,ItemLedgEntry."Entry No.");
      END;
    END;

    [External]
    PROCEDURE SetHideWarrantyWarning@16(Value@1000 : Boolean);
    BEGIN
      HideWarrantyWarning := Value;
    END;

    [External]
    PROCEDURE SplitResourceLine@43();
    VAR
      SumQty@1002 : Decimal;
      Qty@1001 : Decimal;
      TempDiscount@1005 : Decimal;
      NoOfServItems@1000 : Integer;
      NextLine@1004 : Integer;
    BEGIN
      TESTFIELD(Type,Type::Resource);
      TESTFIELD("No.");
      TESTFIELD("Service Item Line No.");
      TESTFIELD(Quantity);
      TESTFIELD("Quantity Shipped",0);

      ServItemLine.RESET;
      ServItemLine.SETRANGE("Document Type","Document Type");
      ServItemLine.SETRANGE("Document No.","Document No.");
      NoOfServItems := ServItemLine.COUNT;
      IF NoOfServItems <= 1 THEN
        ERROR(Text041);

      IF CONFIRM(Text044) THEN BEGIN
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type","Document Type");
        ServiceLine.SETRANGE("Document No.","Document No.");
        IF ServiceLine.FINDLAST THEN
          NextLine := ServiceLine."Line No." + 10000
        ELSE
          NextLine := 10000;

        Qty := ROUND(Quantity / NoOfServItems,0.01);
        IF ServItemLine.FIND('-') THEN
          REPEAT
            IF ServItemLine."Line No." <> "Service Item Line No." THEN BEGIN
              CLEAR(ServiceLine);
              ServiceLine.INIT;
              ServiceLine."Document Type" := "Document Type";
              ServiceLine."Document No." := "Document No.";
              ServiceLine."Line No." := NextLine;
              ServiceLine.INSERT(TRUE);
              ServiceLine.TRANSFERFIELDS(Rec,FALSE);
              ServiceLine.VALIDATE("Service Item Line No.",ServItemLine."Line No.");
              ServiceLine.VALIDATE("No.");

              ServiceLine.VALIDATE(Quantity,Qty);
              SumQty := SumQty + Qty;
              IF "Qty. to Consume" > 0 THEN
                ServiceLine.VALIDATE("Qty. to Consume",Qty);

              ServiceLine.VALIDATE("Contract No.",ServItemLine."Contract No.");
              IF NOT ServiceLine."Exclude Warranty" THEN
                ServiceLine.VALIDATE(Warranty,ServItemLine.Warranty);

              TempDiscount := "Line Discount %" - "Contract Disc. %" - "Warranty Disc. %";
              IF TempDiscount > 0 THEN BEGIN
                ServiceLine."Line Discount %" := ServiceLine."Line Discount %" + TempDiscount;
                IF ServiceLine."Line Discount %" > 100 THEN
                  ServiceLine."Line Discount %" := 100;
                ServiceLine.VALIDATE("Line Discount %");
              END;

              ServiceLine.MODIFY(TRUE);
              NextLine := NextLine + 10000;
            END;
          UNTIL ServItemLine.NEXT = 0;

        IF ServiceLine.GET("Document Type","Document No.","Line No.") THEN BEGIN
          IF "Qty. to Consume" > 0 THEN
            ServiceLine.VALIDATE("Qty. to Consume",Quantity - SumQty);
          ServiceLine.VALIDATE(Quantity,Quantity - SumQty);
          ServiceLine.MODIFY(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE UpdateDiscountsAmounts@44();
    BEGIN
      IF Type <> Type::" " THEN BEGIN
        TESTFIELD("Qty. per Unit of Measure");
        CalculateDiscount;
        VALIDATE("Unit Price");
      END;
    END;

    LOCAL PROCEDURE UpdateRemainingCostsAndAmounts@15();
    VAR
      TotalPrice@1000 : Decimal;
      AmountRoundingPrecision@1002 : Decimal;
      AmountRoundingPrecisionFCY@1001 : Decimal;
    BEGIN
      IF "Job Remaining Qty." <> 0 THEN BEGIN
        CLEAR(Currency);
        Currency.InitRoundingPrecision;
        AmountRoundingPrecision := Currency."Amount Rounding Precision";
        GetServHeader;
        AmountRoundingPrecisionFCY := Currency."Amount Rounding Precision";

        "Job Remaining Total Cost" := ROUND("Unit Cost" * "Job Remaining Qty.",AmountRoundingPrecisionFCY);
        "Job Remaining Total Cost (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              GetDate,"Currency Code",
              "Job Remaining Total Cost",ServHeader."Currency Factor"),
            AmountRoundingPrecision);

        TotalPrice := ROUND("Job Remaining Qty." * "Unit Price",AmountRoundingPrecisionFCY);
        "Job Remaining Line Amount" := TotalPrice - ROUND(TotalPrice * "Line Discount %" / 100,AmountRoundingPrecisionFCY);
      END ELSE BEGIN
        "Job Remaining Total Cost" := 0;
        "Job Remaining Total Cost (LCY)" := 0;
        "Job Remaining Line Amount" := 0;
      END;
    END;

    LOCAL PROCEDURE UpdateServDocRegister@1102601000(DeleteRecord@1102601000 : Boolean);
    VAR
      ServiceLine2@1102601001 : Record 5902;
      ServDocReg@1000 : Record 5936;
    BEGIN
      ServiceLine2.RESET;
      ServiceLine2.SETRANGE("Document Type","Document Type");
      ServiceLine2.SETRANGE("Document No.","Document No.");
      IF DeleteRecord THEN
        ServiceLine2.SETRANGE("Contract No.","Contract No.")
      ELSE
        ServiceLine2.SETRANGE("Contract No.",xRec."Contract No.");
      ServiceLine2.SETFILTER("Line No.",'<>%1',"Line No.");

      IF ServiceLine2.ISEMPTY THEN
        IF xRec."Contract No." <> '' THEN BEGIN
          ServDocReg.RESET;
          IF "Document Type" = "Document Type"::Invoice THEN
            ServDocReg.SETRANGE("Destination Document Type",ServDocReg."Destination Document Type"::Invoice)
          ELSE
            IF "Document Type" = "Document Type"::"Credit Memo" THEN
              ServDocReg.SETRANGE("Destination Document Type",ServDocReg."Destination Document Type"::"Credit Memo");
          ServDocReg.SETRANGE("Destination Document No.","Document No.");
          ServDocReg.SETRANGE("Source Document Type",ServDocReg."Source Document Type"::Contract);
          ServDocReg.SETRANGE("Source Document No.",xRec."Contract No.");
          ServDocReg.DELETEALL;
        END;

      IF ("Contract No." <> '') AND (Type <> Type::" ") AND NOT DeleteRecord THEN BEGIN
        IF "Document Type" = "Document Type"::Invoice THEN
          ServDocReg.InsertServSalesDocument(
            ServDocReg."Source Document Type"::Contract,"Contract No.",
            ServDocReg."Destination Document Type"::Invoice,"Document No.")
        ELSE
          IF "Document Type" = "Document Type"::"Credit Memo" THEN
            ServDocReg.InsertServSalesDocument(
              ServDocReg."Source Document Type"::Contract,"Contract No.",
              ServDocReg."Destination Document Type"::"Credit Memo","Document No.")
      END;
    END;

    [External]
    PROCEDURE RowID1@51() : Text[250];
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;
    BEGIN
      EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Service Line","Document Type",
          "Document No.",'',0,"Line No."));
    END;

    LOCAL PROCEDURE UpdateReservation@53(CalledByFieldNo@1000 : Integer);
    VAR
      ReservationCheckDateConfl@1001 : Codeunit 99000815;
    BEGIN
      IF (CurrFieldNo <> CalledByFieldNo) AND (CurrFieldNo <> 0) THEN
        EXIT;

      CASE CalledByFieldNo OF
        FIELDNO("Needed by Date"),FIELDNO("Planned Delivery Date"):
          IF (xRec."Needed by Date" <> "Needed by Date") AND
             (Quantity <> 0) AND
             (Reserve <> Reserve::Never)
          THEN
            ReservationCheckDateConfl.ServiceInvLineCheck(Rec,TRUE);
        FIELDNO(Quantity):
          ReserveServLine.VerifyQuantity(Rec,xRec);
      END;
      ReserveServLine.VerifyChange(Rec,xRec);
    END;

    [External]
    PROCEDURE ShowTracking@52();
    VAR
      OrderTrackingForm@1000 : Page 99000822;
    BEGIN
      OrderTrackingForm.SetServLine(Rec);
      OrderTrackingForm.RUNMODAL;
    END;

    [External]
    PROCEDURE ShowOrderPromisingLine@64();
    VAR
      OrderPromisingLine@1000 : Record 99000880;
      OrderPromisingLines@1001 : Page 99000959;
    BEGIN
      OrderPromisingLine.SETRANGE("Source Type",OrderPromisingLine."Source Type"::"Service Order");
      OrderPromisingLine.SETRANGE("Source Type",OrderPromisingLine."Source Type"::"Service Order");
      OrderPromisingLine.SETRANGE("Source ID","Document No.");
      OrderPromisingLine.SETRANGE("Source Line No.","Line No.");

      OrderPromisingLines.SetSourceType(OrderPromisingLine."Source Type"::"Service Order");
      OrderPromisingLines.SETTABLEVIEW(OrderPromisingLine);
      OrderPromisingLines.RUNMODAL;
    END;

    [External]
    PROCEDURE FilterLinesWithItemToPlan@70(VAR Item@1000 : Record 27);
    BEGIN
      RESET;
      SETCURRENTKEY(Type,"No.","Variant Code","Location Code","Needed by Date","Document Type");
      SETRANGE("Document Type","Document Type"::Order);
      SETRANGE(Type,Type::Item);
      SETRANGE("No.",Item."No.");
      SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
      SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
      SETFILTER("Needed by Date",Item.GETFILTER("Date Filter"));
      SETFILTER("Shortcut Dimension 1 Code",Item.GETFILTER("Global Dimension 1 Filter"));
      SETFILTER("Shortcut Dimension 2 Code",Item.GETFILTER("Global Dimension 2 Filter"));
      SETFILTER("Outstanding Qty. (Base)",'<>0');
    END;

    [External]
    PROCEDURE FindLinesWithItemToPlan@68(VAR Item@1000 : Record 27) : Boolean;
    BEGIN
      FilterLinesWithItemToPlan(Item);
      EXIT(FIND('-'));
    END;

    [External]
    PROCEDURE LinesWithItemToPlanExist@67(VAR Item@1000 : Record 27) : Boolean;
    BEGIN
      FilterLinesWithItemToPlan(Item);
      EXIT(NOT ISEMPTY);
    END;

    LOCAL PROCEDURE UpdateServiceLedgerEntry@65();
    VAR
      ServiceLedgerEntry@1000 : Record 5907;
      Currency@1002 : Record 4;
      GeneralLedgerSetup@1004 : Record 98;
      CurrencyExchangeRate@1006 : Record 330;
      LCYRoundingPrecision@1001 : Decimal;
      CurrencyFactor@1005 : Decimal;
    BEGIN
      IF "Appl.-to Service Entry" = 0 THEN
        EXIT;
      IF NOT ServiceLedgerEntry.GET("Appl.-to Service Entry") THEN
        EXIT;
      IF ("Unit Price" = xRec."Unit Price") AND ("Unit Cost" = xRec."Unit Cost") AND (Amount = xRec.Amount) AND
         ("Line Discount Amount" = xRec."Line Discount Amount") AND ("Line Discount %" = xRec."Line Discount %")
      THEN
        EXIT;

      CurrencyFactor := 1;
      IF "Currency Code" <> '' THEN BEGIN
        CurrencyExchangeRate.SETRANGE("Currency Code","Currency Code");
        CurrencyExchangeRate.SETRANGE("Starting Date",0D,"Order Date");
        IF CurrencyExchangeRate.FINDLAST THEN
          CurrencyFactor := CurrencyExchangeRate."Adjustment Exch. Rate Amount" / CurrencyExchangeRate."Relational Exch. Rate Amount";
      END;
      GeneralLedgerSetup.GET;
      LCYRoundingPrecision := 0.01;
      IF Currency.GET(GeneralLedgerSetup."LCY Code") THEN
        LCYRoundingPrecision := Currency."Amount Rounding Precision";

      IF "Unit Price" <> xRec."Unit Price" THEN
        ServiceLedgerEntry."Unit Price" := -ROUND("Unit Price" / CurrencyFactor,LCYRoundingPrecision);
      IF "Unit Cost (LCY)" <> xRec."Unit Cost (LCY)" THEN
        ServiceLedgerEntry."Unit Cost" := "Unit Cost (LCY)";
      IF Amount <> xRec.Amount THEN BEGIN
        ServiceLedgerEntry.Amount := -Amount;
        ServiceLedgerEntry."Amount (LCY)" := -ROUND(Amount / CurrencyFactor,LCYRoundingPrecision);
      END;
      IF "Line Discount Amount" <> xRec."Line Discount Amount" THEN
        ServiceLedgerEntry."Discount Amount" := ROUND("Line Discount Amount" / CurrencyFactor,LCYRoundingPrecision);
      IF "Line Discount %" <> xRec."Line Discount %" THEN
        ServiceLedgerEntry."Discount %" := "Line Discount %";
      ServiceLedgerEntry.MODIFY;
    END;

    LOCAL PROCEDURE UpdateWithWarehouseShip@66();
    BEGIN
      IF Type <> Type::Item THEN
        EXIT;
      IF "Document Type" IN ["Document Type"::Quote,"Document Type"::Order] THEN
        IF Location.RequireShipment("Location Code") THEN BEGIN
          VALIDATE("Qty. to Ship",0);
          VALIDATE("Qty. to Invoice",0);
        END ELSE
          VALIDATE("Qty. to Ship","Outstanding Quantity");
    END;

    LOCAL PROCEDURE CheckWarehouse@71();
    VAR
      Location2@1000 : Record 14;
      WhseSetup@1001 : Record 5769;
      ShowDialog@1002 : ' ,Message,Error';
      DialogText@1003 : Text[100];
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

      DialogText := Text035 + ' ';

      IF "Document Type" = "Document Type"::Order THEN
        IF Location2."Directed Put-away and Pick" THEN BEGIN
          ShowDialog := ShowDialog::Error;
          IF Quantity >= 0 THEN
            DialogText := DialogText + ' ' + Location2.GetRequirementText(Location2.FIELDNO("Require Shipment"))
          ELSE
            DialogText := DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Receive"));
        END ELSE BEGIN
          IF (Quantity >= 0) AND (Location2."Require Shipment" OR Location2."Require Pick") THEN BEGIN
            IF WhseValidateSourceLine.WhseLinesExist(DATABASE::"Service Line","Document Type","Document No.","Line No.",0,Quantity)
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

          IF (Quantity < 0) AND (Location2."Require Receive" OR Location2."Require Put-away") THEN BEGIN
            IF WhseValidateSourceLine.WhseLinesExist(
                 DATABASE::"Service Line",
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
              DialogText := DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Receive"))
            ELSE
              DialogText := Text036 + ' ' + Location2.GetRequirementText(Location2.FIELDNO("Require Put-away"));
          END;
        END;

      CASE ShowDialog OF
        ShowDialog::Message:
          MESSAGE(STRSUBSTNO(Text049,DialogText,FIELDCAPTION("Line No."),"Line No.") + Text050);
        ShowDialog::Error:
          ERROR(Text049,DialogText,FIELDCAPTION("Line No."),"Line No.");
      END;

      HandleDedicatedBin(TRUE);
    END;

    LOCAL PROCEDURE HandleDedicatedBin@73(IssueWarning@1000 : Boolean);
    VAR
      WhseIntegrationMgt@1001 : Codeunit 7317;
    BEGIN
      WhseIntegrationMgt.CheckIfBinDedicatedOnSrcDoc("Location Code","Bin Code",IssueWarning);
    END;

    LOCAL PROCEDURE TestStatusOpen@72();
    VAR
      ServHeader@1000 : Record 5900;
    BEGIN
      IF StatusCheckSuspended THEN
        EXIT;
      ServHeader.GET("Document Type","Document No.");
      IF (Type = Type::Item) OR (xRec.Type = Type::Item) THEN
        ServHeader.TESTFIELD("Release Status",ServHeader."Release Status"::Open);
    END;

    [External]
    PROCEDURE SuspendStatusCheck@69(bSuspend@1000 : Boolean);
    BEGIN
      StatusCheckSuspended := bSuspend;
    END;

    LOCAL PROCEDURE LineRequiresShipmentOrReceipt@74() : Boolean;
    VAR
      Location@1000 : Record 14;
    BEGIN
      IF ("Document Type" <> "Document Type"::Order) OR (Type <> Type::Item) THEN
        EXIT(FALSE);
      EXIT(Location.RequireReceive("Location Code") OR Location.RequireShipment("Location Code"));
    END;

    LOCAL PROCEDURE DisplayConflictError@76(ErrTxt@1000 : Text[500]);
    VAR
      DisplayedError@1001 : Text[600];
    BEGIN
      DisplayedError := Text051 + ErrTxt;
      ERROR(DisplayedError);
    END;

    [External]
    PROCEDURE GetDueDate@75() : Date;
    BEGIN
      EXIT(EvaluateDaysBack("Shipping Time","Needed by Date"));
    END;

    [External]
    PROCEDURE GetShipmentDate@77() : Date;
    VAR
      Location@1001 : Record 14;
      InventorySetup@1002 : Record 313;
    BEGIN
      IF Location.GET("Location Code") THEN
        EXIT(EvaluateDaysBack(Location."Outbound Whse. Handling Time",GetDueDate));
      InventorySetup.GET;
      EXIT(EvaluateDaysBack(InventorySetup."Outbound Whse. Handling Time",GetDueDate));
    END;

    [External]
    PROCEDURE OutstandingInvoiceAmountFromShipment@4(CustomerNo@1000 : Code[20]) : Decimal;
    VAR
      ServiceLine@1001 : Record 5902;
    BEGIN
      ServiceLine.SETCURRENTKEY("Document Type","Customer No.","Shipment No.");
      ServiceLine.SETRANGE("Document Type",ServiceLine."Document Type"::Invoice);
      ServiceLine.SETRANGE("Customer No.",CustomerNo);
      ServiceLine.SETFILTER("Shipment No.",'<>%1','');
      ServiceLine.CALCSUMS("Outstanding Amount (LCY)");
      EXIT(ServiceLine."Outstanding Amount (LCY)");
    END;

    LOCAL PROCEDURE EvaluateDaysBack@78(InputFormula@1001 : DateFormula;InputDate@1000 : Date) : Date;
    VAR
      DFCode@1002 : Code[10];
      DF@1003 : DateFormula;
    BEGIN
      IF FORMAT(InputFormula) = '' THEN
        EXIT(InputDate);
      DFCode := FORMAT(InputFormula);
      IF NOT (COPYSTR(DFCode,1,1) IN ['+','-']) THEN
        DFCode := '+' + DFCode;
      DFCode := CONVERTSTR(DFCode,'+-','-+');
      EVALUATE(DF,DFCode);
      EXIT(CALCDATE(DF,InputDate));
    END;

    LOCAL PROCEDURE CheckIfCanBeModified@81();
    BEGIN
      IF ("Appl.-to Service Entry" > 0) AND ("Contract No." <> '') THEN
        ERROR(Text053);
    END;

    LOCAL PROCEDURE ViewDimensionSetEntries@80();
    BEGIN
      DimMgt.ShowDimensionSet(
        "Dimension Set ID",STRSUBSTNO('%1 %2 %3',TABLECAPTION,"Document No.","Line No."));
    END;

    [External]
    PROCEDURE TestItemFields@88(ItemNo@1000 : Code[20];VariantCode@1001 : Code[10];LocationCode@1002 : Code[10]);
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.",ItemNo);
      TESTFIELD("Variant Code",VariantCode);
      TESTFIELD("Location Code",LocationCode);
    END;

    [External]
    PROCEDURE TestBinCode@82();
    VAR
      Location@1001 : Record 14;
    BEGIN
      IF ("Location Code" = '') OR (Type <> Type::Item) THEN
        EXIT;
      Location.GET("Location Code");
      IF NOT Location."Bin Mandatory" THEN
        EXIT;
      IF ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) OR
         NOT Location."Directed Put-away and Pick"
      THEN
        TESTFIELD("Bin Code");
    END;

    [External]
    PROCEDURE GetNextLineNo@83(ServiceLineSource@1001 : Record 5902;BelowxRec@1000 : Boolean) : Integer;
    VAR
      ServiceLine@1006 : Record 5902;
      LowLineNo@1005 : Integer;
      HighLineNo@1004 : Integer;
      NextLineNo@1003 : Integer;
      LineStep@1002 : Integer;
    BEGIN
      LowLineNo := 0;
      HighLineNo := 0;
      NextLineNo := 0;
      LineStep := 10000;
      ServiceLine.SETRANGE("Document Type","Document Type");
      ServiceLine.SETRANGE("Document No.","Document No.");

      IF ServiceLine.FIND('+') THEN
        IF NOT ServiceLine.GET(ServiceLineSource."Document Type",ServiceLineSource."Document No.",ServiceLineSource."Line No.") THEN
          NextLineNo := ServiceLine."Line No." + LineStep
        ELSE
          IF BelowxRec THEN BEGIN
            ServiceLine.FINDLAST;
            NextLineNo := ServiceLine."Line No." + LineStep;
          END ELSE
            IF ServiceLine.NEXT(-1) = 0 THEN BEGIN
              LowLineNo := 0;
              HighLineNo := ServiceLineSource."Line No.";
            END ELSE BEGIN
              ServiceLine := ServiceLineSource;
              ServiceLine.NEXT(-1);
              LowLineNo := ServiceLine."Line No.";
              HighLineNo := ServiceLineSource."Line No.";
            END
      ELSE
        NextLineNo := LineStep;

      IF NextLineNo = 0 THEN
        NextLineNo := ROUND((LowLineNo + HighLineNo) / 2,1,'<');

      IF ServiceLine.GET("Document Type","Document No.",NextLineNo) THEN
        EXIT(0);
      EXIT(NextLineNo);
    END;

    [External]
    PROCEDURE DeleteWithAttachedLines@84();
    BEGIN
      SETRANGE("Document Type","Document Type");
      SETRANGE("Document No.","Document No.");
      SETRANGE("Attached to Line No.","Line No.");
      DELETEALL;

      SETRANGE("Document Type");
      SETRANGE("Document No.");
      SETRANGE("Attached to Line No.");
      DELETE;
    END;

    LOCAL PROCEDURE UpdateDimSetupFromDimSetID@85(VAR TableID@1001 : ARRAY [10] OF Integer;VAR No@1004 : ARRAY [10] OF Code[20];InheritFromDimSetID@1000 : Integer);
    VAR
      TempDimSetEntry@1002 : TEMPORARY Record 480;
      LastAddedTableID@1003 : Integer;
    BEGIN
      DimMgt.GetDimensionSet(TempDimSetEntry,InheritFromDimSetID);
      ServHeader.GET("Document Type","Document No.");
      LastAddedTableID := 3;
      UpdateDimSetupByDefaultDim(
        DATABASE::"Service Order Type",ServHeader."Service Order Type",TempDimSetEntry,TableID,No,LastAddedTableID);
      UpdateDimSetupByDefaultDim(
        DATABASE::Customer,ServHeader."Bill-to Customer No.",TempDimSetEntry,TableID,No,LastAddedTableID);
      UpdateDimSetupByDefaultDim(
        DATABASE::"Salesperson/Purchaser",ServHeader."Salesperson Code",TempDimSetEntry,TableID,No,LastAddedTableID);
      UpdateDimSetupByDefaultDim(
        DATABASE::"Service Contract Header",ServHeader."Contract No.",TempDimSetEntry,TableID,No,LastAddedTableID);
      UpdateDimSetupByDefaultDim(
        DATABASE::"Service Item",ServItemLine."Service Item No.",TempDimSetEntry,TableID,No,LastAddedTableID);
      UpdateDimSetupByDefaultDim(
        DATABASE::"Service Item Group",ServItemLine."Service Item Group Code",TempDimSetEntry,TableID,No,LastAddedTableID);
    END;

    LOCAL PROCEDURE UpdateDimSetupByDefaultDim@95(SourceID@1002 : Integer;SourceNo@1003 : Code[20];VAR TempDimSetEntry@1001 : TEMPORARY Record 480;VAR TableID@1000 : ARRAY [10] OF Integer;VAR No@1007 : ARRAY [10] OF Code[20];VAR LastAddedTableID@1005 : Integer);
    VAR
      DefaultDim@1004 : Record 352;
      TableAdded@1006 : Boolean;
    BEGIN
      IF SourceNo = '' THEN
        EXIT;

      DefaultDim.SETRANGE("Table ID",SourceID);
      DefaultDim.SETRANGE("No.",SourceNo);
      IF DefaultDim.FINDSET THEN
        REPEAT
          TempDimSetEntry.SETRANGE("Dimension Code",DefaultDim."Dimension Code");
          TempDimSetEntry.SETRANGE("Dimension Value Code",DefaultDim."Dimension Value Code");
          IF TempDimSetEntry.FINDFIRST THEN BEGIN
            UpdateDimSetup(TableID,No,DefaultDim."Table ID",DefaultDim."No.",LastAddedTableID);
            TableAdded := TRUE;
          END;
        UNTIL (DefaultDim.NEXT = 0) OR TableAdded;
    END;

    LOCAL PROCEDURE UpdateDimSetup@89(VAR TableID@1000 : ARRAY [10] OF Integer;VAR No@1005 : ARRAY [10] OF Code[20];NewTableID@1001 : Integer;NewNo@1006 : Code[20];VAR LastAddedTableID@1002 : Integer);
    VAR
      TableAlreadyAdded@1004 : Boolean;
      i@1003 : Integer;
    BEGIN
      FOR i := 1 TO LastAddedTableID DO
        IF TableID[i] = NewTableID THEN
          TableAlreadyAdded := TRUE;

      IF NOT TableAlreadyAdded THEN BEGIN
        LastAddedTableID += 1;
        TableID[LastAddedTableID] := NewTableID;
        No[LastAddedTableID] := NewNo;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignHeaderValues@134(VAR ServiceLine@1000 : Record 5902;ServiceHeader@1001 : Record 5900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignStdTxtValues@135(VAR ServiceLine@1000 : Record 5902;StandardText@1001 : Record 7);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignGLAccountValues@138(VAR ServiceLine@1000 : Record 5902;GLAccount@1001 : Record 15);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignServCostValues@137(VAR ServiceLine@1000 : Record 5902;ServiceCost@1001 : Record 5905);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignItemValues@136(VAR ServiceLine@1000 : Record 5902;Item@1001 : Record 27);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignServItemValues@99(VAR ServiceLine@1003 : Record 5902;ServiceItem@1001 : Record 5940;ServiceItemComp@1000 : Record 5941);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignResourceValues@139(VAR ServiceLine@1000 : Record 5902;Resource@1001 : Record 156);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateUnitPrice@126(VAR ServiceLine@1000 : Record 5902;xServiceLine@1001 : Record 5902;CalledByFieldNo@1002 : Integer;CurrFieldNo@1003 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeUpdateUnitPrice@127(VAR ServiceLine@1003 : Record 5902;xServiceLine@1002 : Record 5902;CalledByFieldNo@1001 : Integer;CurrFieldNo@1000 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitOutstandingAmount@132(VAR ServiceLine@1000 : Record 5902;ServiceHeader@1001 : Record 5900;Currency@1002 : Record 4);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitQtyToInvoice@128(VAR ServiceLine@1000 : Record 5902;CurrFieldNo@1001 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitQtyToShip@129(VAR ServiceLine@1000 : Record 5902;CurrFieldNo@1001 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitQtyToConsume@130(VAR ServiceLine@1000 : Record 5902;CurrFieldNo@1001 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@17(VAR ServiceLine@1000 : Record 5902;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    BEGIN
    END.
  }
}

