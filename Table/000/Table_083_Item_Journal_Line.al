OBJECT Table 83 Item Journal Line
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               LOCKTABLE;
               ItemJnlTemplate.GET("Journal Template Name");
               ItemJnlBatch.GET("Journal Template Name","Journal Batch Name");

               ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
               ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
               ValidateNewShortcutDimCode(1,"New Shortcut Dimension 1 Code");
               ValidateNewShortcutDimCode(2,"New Shortcut Dimension 2 Code");

               CheckPlanningAssignment;
             END;

    OnModify=BEGIN
               OnBeforeVerifyReservedQty(Rec,xRec,0);
               ReserveItemJnlLine.VerifyChange(Rec,xRec);
               CheckPlanningAssignment;
             END;

    OnDelete=BEGIN
               ReserveItemJnlLine.DeleteLine(Rec);

               CALCFIELDS("Reserved Qty. (Base)");
               TESTFIELD("Reserved Qty. (Base)",0);
             END;

    OnRename=BEGIN
               ReserveItemJnlLine.RenameLine(Rec,xRec);
             END;

    CaptionML=[DAN=Varekladdelinje;
               ENU=Item Journal Line];
    LookupPageID=Page519;
    DrillDownPageID=Page519;
  }
  FIELDS
  {
    { 1   ;   ;Journal Template Name;Code10       ;TableRelation="Item Journal Template";
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Journal Template Name] }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   OnValidate=VAR
                                                                ProdOrderLine@1001 : Record 5406;
                                                                ProdOrderComp@1000 : Record 5407;
                                                              BEGIN
                                                                IF "Item No." <> xRec."Item No." THEN BEGIN
                                                                  "Variant Code" := '';
                                                                  "Bin Code" := '';
                                                                  IF CurrFieldNo <> 0 THEN
                                                                    WMSManagement.CheckItemJnlLineFieldChange(Rec,xRec,FIELDCAPTION("Item No."));
                                                                  IF ("Location Code" <> '') AND ("Item No." <> '') THEN BEGIN
                                                                    GetLocation("Location Code");
                                                                    IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
                                                                      WMSManagement.GetDefaultBin("Item No.","Variant Code","Location Code","Bin Code")
                                                                  END;
                                                                  IF ("Entry Type" = "Entry Type"::Transfer) AND ("Location Code" = "New Location Code") THEN
                                                                    "New Bin Code" := "Bin Code";
                                                                END;

                                                                IF "Entry Type" IN ["Entry Type"::Consumption,"Entry Type"::Output] THEN
                                                                  WhseValidateSourceLine.ItemLineVerifyChange(Rec,xRec);

                                                                IF "Item No." = '' THEN BEGIN
                                                                  CreateDim(
                                                                    DATABASE::Item,"Item No.",
                                                                    DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                                                                    DATABASE::"Work Center","Work Center No.");
                                                                  EXIT;
                                                                END;

                                                                GetItem;
                                                                Item.TESTFIELD(Blocked,FALSE);
                                                                Item.TESTFIELD(Type,Item.Type::Inventory);
                                                                IF "Value Entry Type" = "Value Entry Type"::Revaluation THEN
                                                                  Item.TESTFIELD("Inventory Value Zero",FALSE);
                                                                Description := Item.Description;
                                                                "Inventory Posting Group" := Item."Inventory Posting Group";
                                                                "Item Category Code" := Item."Item Category Code";
                                                                "Product Group Code" := Item."Product Group Code";

                                                                IF ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") OR
                                                                   ("Item Charge No." <> '')
                                                                THEN BEGIN
                                                                  IF "Item No." <> xRec."Item No." THEN BEGIN
                                                                    TESTFIELD("Partial Revaluation",FALSE);
                                                                    RetrieveCosts;
                                                                    "Indirect Cost %" := 0;
                                                                    "Overhead Rate" := 0;
                                                                    "Inventory Value Per" := "Inventory Value Per"::" ";
                                                                    VALIDATE("Applies-to Entry",0);
                                                                    "Partial Revaluation" := FALSE;
                                                                  END;
                                                                END ELSE BEGIN
                                                                  "Indirect Cost %" := Item."Indirect Cost %";
                                                                  "Overhead Rate" := Item."Overhead Rate";
                                                                  IF NOT "Phys. Inventory" OR (Item."Costing Method" = Item."Costing Method"::Standard) THEN BEGIN
                                                                    RetrieveCosts;
                                                                    "Unit Cost" := UnitCost;
                                                                  END ELSE
                                                                    UnitCost := "Unit Cost";
                                                                END;

                                                                IF (("Entry Type" = "Entry Type"::Output) AND (WorkCenter."No." = '') AND (MachineCenter."No." = '')) OR
                                                                   ("Entry Type" <> "Entry Type"::Output) OR
                                                                   ("Value Entry Type" = "Value Entry Type"::Revaluation)
                                                                THEN
                                                                  "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";

                                                                CASE "Entry Type" OF
                                                                  "Entry Type"::Purchase,
                                                                  "Entry Type"::Output,
                                                                  "Entry Type"::"Assembly Output":
                                                                    PurchPriceCalcMgt.FindItemJnlLinePrice(Rec,FIELDNO("Item No."));
                                                                  "Entry Type"::"Positive Adjmt.",
                                                                  "Entry Type"::"Negative Adjmt.",
                                                                  "Entry Type"::Consumption,
                                                                  "Entry Type"::"Assembly Consumption":
                                                                    "Unit Amount" := UnitCost;
                                                                  "Entry Type"::Sale:
                                                                    SalesPriceCalcMgt.FindItemJnlLinePrice(Rec,FIELDNO("Item No."));
                                                                  "Entry Type"::Transfer:
                                                                    BEGIN
                                                                      "Unit Amount" := 0;
                                                                      "Unit Cost" := 0;
                                                                      Amount := 0;
                                                                    END;
                                                                END;

                                                                CASE "Entry Type" OF
                                                                  "Entry Type"::Purchase:
                                                                    "Unit of Measure Code" := Item."Purch. Unit of Measure";
                                                                  "Entry Type"::Sale:
                                                                    "Unit of Measure Code" := Item."Sales Unit of Measure";
                                                                  "Entry Type"::Output:
                                                                    BEGIN
                                                                      Item.TESTFIELD("Inventory Value Zero",FALSE);
                                                                      ProdOrderLine.SetFilterByReleasedOrderNo("Order No.");
                                                                      ProdOrderLine.SETRANGE("Item No.","Item No.");
                                                                      IF ProdOrderLine.FINDFIRST THEN BEGIN
                                                                        "Routing No." := ProdOrderLine."Routing No.";
                                                                        "Source Type" := "Source Type"::Item;
                                                                        "Source No." := ProdOrderLine."Item No.";
                                                                      END ELSE
                                                                        IF ("Value Entry Type" <> "Value Entry Type"::Revaluation) AND
                                                                           (CurrFieldNo <> 0)
                                                                        THEN
                                                                          ERROR(Text031,"Item No.","Order No.");
                                                                      IF ProdOrderLine.COUNT = 1 THEN BEGIN
                                                                        VALIDATE("Order Line No.",ProdOrderLine."Line No.");
                                                                        "Unit of Measure Code" := ProdOrderLine."Unit of Measure Code";
                                                                        "Location Code" := ProdOrderLine."Location Code";
                                                                        VALIDATE("Variant Code",ProdOrderLine."Variant Code");
                                                                        VALIDATE("Bin Code",ProdOrderLine."Bin Code");
                                                                      END ELSE
                                                                        "Unit of Measure Code" := Item."Base Unit of Measure";
                                                                    END;
                                                                  "Entry Type"::Consumption:
                                                                    BEGIN
                                                                      ProdOrderComp.SetFilterByReleasedOrderNo("Order No.");
                                                                      ProdOrderComp.SETRANGE("Item No.","Item No.");
                                                                      IF ProdOrderComp.COUNT = 1 THEN BEGIN
                                                                        ProdOrderComp.FINDFIRST;
                                                                        VALIDATE("Order Line No.",ProdOrderComp."Prod. Order Line No.");
                                                                        VALIDATE("Prod. Order Comp. Line No.",ProdOrderComp."Line No.");
                                                                        "Unit of Measure Code" := ProdOrderComp."Unit of Measure Code";
                                                                        "Location Code" := ProdOrderComp."Location Code";
                                                                        VALIDATE("Variant Code",ProdOrderComp."Variant Code");
                                                                        VALIDATE("Bin Code",ProdOrderComp."Bin Code");
                                                                      END ELSE BEGIN
                                                                        "Unit of Measure Code" := Item."Base Unit of Measure";
                                                                        VALIDATE("Prod. Order Comp. Line No.",0);
                                                                      END;
                                                                    END;
                                                                  ELSE
                                                                    "Unit of Measure Code" := Item."Base Unit of Measure";
                                                                END;

                                                                IF "Value Entry Type" = "Value Entry Type"::Revaluation THEN
                                                                  "Unit of Measure Code" := Item."Base Unit of Measure";
                                                                VALIDATE("Unit of Measure Code");
                                                                IF "Variant Code" <> '' THEN
                                                                  VALIDATE("Variant Code");

                                                                OnAfterOnValidateItemNoAssignByEntryType(ItemJnlLine,Item);

                                                                CheckItemAvailable(FIELDNO("Item No."));

                                                                IF ((NOT ("Order Type" IN ["Order Type"::Production,"Order Type"::Assembly])) OR ("Order No." = '')) AND NOT "Phys. Inventory"
                                                                THEN
                                                                  CreateDim(
                                                                    DATABASE::Item,"Item No.",
                                                                    DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                                                                    DATABASE::"Work Center","Work Center No.");

                                                                OnBeforeVerifyReservedQty(Rec,xRec,FIELDNO("Item No."));
                                                                ReserveItemJnlLine.VerifyChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 4   ;   ;Posting Date        ;Date          ;OnValidate=VAR
                                                                CheckDateConflict@1000 : Codeunit 99000815;
                                                              BEGIN
                                                                VALIDATE("Document Date","Posting Date");
                                                                CheckDateConflict.ItemJnlLineCheck(Rec,CurrFieldNo <> 0);
                                                              END;

                                                   CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 5   ;   ;Entry Type          ;Option        ;OnValidate=BEGIN
                                                                IF NOT ("Entry Type" IN ["Entry Type"::"Positive Adjmt.","Entry Type"::"Negative Adjmt."]) THEN
                                                                  TESTFIELD("Phys. Inventory",FALSE);

                                                                IF CurrFieldNo <> 0 THEN
                                                                  WMSManagement.CheckItemJnlLineFieldChange(Rec,xRec,FIELDCAPTION("Entry Type"));

                                                                CASE "Entry Type" OF
                                                                  "Entry Type"::Purchase:
                                                                    IF UserMgt.GetRespCenter(1,'') <> '' THEN
                                                                      "Location Code" := UserMgt.GetLocation(1,'',UserMgt.GetPurchasesFilter);
                                                                  "Entry Type"::Sale:
                                                                    BEGIN
                                                                      IF UserMgt.GetRespCenter(0,'') <> '' THEN
                                                                        "Location Code" := UserMgt.GetLocation(0,'',UserMgt.GetSalesFilter);
                                                                      CheckItemAvailable(FIELDNO("Entry Type"));
                                                                    END;
                                                                  "Entry Type"::Consumption,"Entry Type"::Output:
                                                                    VALIDATE("Order Type","Order Type"::Production);
                                                                  "Entry Type"::"Assembly Consumption","Entry Type"::"Assembly Output":
                                                                    VALIDATE("Order Type","Order Type"::Assembly);
                                                                END;

                                                                IF xRec."Location Code" = '' THEN
                                                                  IF Location.GET("Location Code") THEN
                                                                    IF  Location."Directed Put-away and Pick" THEN
                                                                      "Location Code" := '';

                                                                IF "Item No." <> '' THEN
                                                                  VALIDATE("Location Code");

                                                                VALIDATE("Item No.");
                                                                IF "Entry Type" <> "Entry Type"::Transfer THEN BEGIN
                                                                  "New Location Code" := '';
                                                                  "New Bin Code" := '';
                                                                END;

                                                                IF "Entry Type" <> "Entry Type"::Output THEN
                                                                  Type := Type::" ";

                                                                ReserveItemJnlLine.VerifyChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=K�b,Salg,Opregulering,Nedregulering,Overf�rsel,Forbrug,Afgang, ,Montageforbrug,Montageoutput;
                                                                    ENU=Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output];
                                                   OptionString=Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output }
    { 6   ;   ;Source No.          ;Code20        ;TableRelation=IF (Source Type=CONST(Customer)) Customer
                                                                 ELSE IF (Source Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Source Type=CONST(Item)) Item;
                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.];
                                                   Editable=No }
    { 7   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 8   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 9   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   OnValidate=BEGIN
                                                                IF "Entry Type" <= "Entry Type"::Transfer THEN
                                                                  TESTFIELD("Item No.");

                                                                IF ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND
                                                                   ("Item Charge No." = '') AND
                                                                   ("No." = '')
                                                                THEN BEGIN
                                                                  GetUnitAmount(FIELDNO("Location Code"));
                                                                  "Unit Cost" := UnitCost;
                                                                  VALIDATE("Unit Amount");
                                                                  CheckItemAvailable(FIELDNO("Location Code"));
                                                                END;

                                                                IF "Entry Type" IN ["Entry Type"::Consumption,"Entry Type"::Output] THEN
                                                                  WhseValidateSourceLine.ItemLineVerifyChange(Rec,xRec);

                                                                IF "Location Code" <> xRec."Location Code" THEN BEGIN
                                                                  "Bin Code" := '';
                                                                  IF CurrFieldNo <> 0 THEN
                                                                    WMSManagement.CheckItemJnlLineFieldChange(Rec,xRec,FIELDCAPTION("Location Code"));
                                                                  IF ("Location Code" <> '') AND ("Item No." <> '') THEN BEGIN
                                                                    GetLocation("Location Code");
                                                                    IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
                                                                      WMSManagement.GetDefaultBin("Item No.","Variant Code","Location Code","Bin Code");
                                                                  END;
                                                                  IF "Entry Type" = "Entry Type"::Transfer THEN BEGIN
                                                                    "New Location Code" := "Location Code";
                                                                    "New Bin Code" := "Bin Code";
                                                                  END;
                                                                END;

                                                                VALIDATE("Unit of Measure Code");

                                                                ReserveItemJnlLine.VerifyChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 10  ;   ;Inventory Posting Group;Code20     ;TableRelation="Inventory Posting Group";
                                                   CaptionML=[DAN=Varebogf�ringsgruppe;
                                                              ENU=Inventory Posting Group];
                                                   Editable=No }
    { 11  ;   ;Source Posting Group;Code20        ;TableRelation=IF (Source Type=CONST(Customer)) "Customer Posting Group"
                                                                 ELSE IF (Source Type=CONST(Vendor)) "Vendor Posting Group"
                                                                 ELSE IF (Source Type=CONST(Item)) "Inventory Posting Group";
                                                   CaptionML=[DAN=Kildebogf.gruppe;
                                                              ENU=Source Posting Group];
                                                   Editable=No }
    { 13  ;   ;Quantity            ;Decimal       ;OnValidate=VAR
                                                                CallWhseCheck@1000 : Boolean;
                                                              BEGIN
                                                                IF ("Entry Type" <= "Entry Type"::Transfer) AND (Quantity <> 0) THEN
                                                                  TESTFIELD("Item No.");

                                                                IF NOT PhysInvtEntered THEN
                                                                  TESTFIELD("Phys. Inventory",FALSE);

                                                                CallWhseCheck :=
                                                                  ("Entry Type" = "Entry Type"::"Assembly Consumption") OR
                                                                  ("Entry Type" = "Entry Type"::Consumption) OR
                                                                  ("Entry Type" = "Entry Type"::Output) AND
                                                                  LastOutputOperation(Rec);
                                                                IF CallWhseCheck THEN
                                                                  WhseValidateSourceLine.ItemLineVerifyChange(Rec,xRec);

                                                                IF CurrFieldNo <> 0 THEN
                                                                  WMSManagement.CheckItemJnlLineFieldChange(Rec,xRec,FIELDCAPTION(Quantity));

                                                                "Quantity (Base)" := CalcBaseQty(Quantity);
                                                                IF ("Entry Type" = "Entry Type"::Output) AND
                                                                   ("Value Entry Type" <> "Value Entry Type"::Revaluation)
                                                                THEN
                                                                  "Invoiced Quantity" := 0
                                                                ELSE
                                                                  "Invoiced Quantity" := Quantity;
                                                                "Invoiced Qty. (Base)" := CalcBaseQty("Invoiced Quantity");

                                                                GetUnitAmount(FIELDNO(Quantity));
                                                                UpdateAmount;

                                                                CheckItemAvailable(FIELDNO(Quantity));

                                                                IF "Entry Type" = "Entry Type"::Transfer THEN BEGIN
                                                                  "Qty. (Calculated)" := 0;
                                                                  "Qty. (Phys. Inventory)" := 0;
                                                                  "Last Item Ledger Entry No." := 0;
                                                                END;

                                                                CALCFIELDS("Reserved Qty. (Base)");
                                                                IF ABS("Quantity (Base)") < ABS("Reserved Qty. (Base)") THEN
                                                                  ERROR(Text001,FIELDCAPTION("Reserved Qty. (Base)"));

                                                                IF Item."Item Tracking Code" <> '' THEN
                                                                  ReserveItemJnlLine.VerifyQuantity(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 15  ;   ;Invoiced Quantity   ;Decimal       ;CaptionML=[DAN=Faktureret antal;
                                                              ENU=Invoiced Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 16  ;   ;Unit Amount         ;Decimal       ;OnValidate=BEGIN
                                                                UpdateAmount;
                                                                IF "Item No." <> '' THEN
                                                                  IF "Value Entry Type" = "Value Entry Type"::Revaluation THEN
                                                                    "Unit Cost" := "Unit Amount"
                                                                  ELSE
                                                                    CASE "Entry Type" OF
                                                                      "Entry Type"::Purchase,
                                                                      "Entry Type"::"Positive Adjmt.",
                                                                      "Entry Type"::"Assembly Output":
                                                                        BEGIN
                                                                          IF "Entry Type" = "Entry Type"::"Positive Adjmt." THEN BEGIN
                                                                            GetItem;
                                                                            IF (CurrFieldNo = FIELDNO("Unit Amount")) AND
                                                                               (Item."Costing Method" = Item."Costing Method"::Standard)
                                                                            THEN
                                                                              ERROR(
                                                                                Text002,
                                                                                FIELDCAPTION("Unit Amount"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");
                                                                          END;

                                                                          ReadGLSetup;
                                                                          IF "Entry Type" = "Entry Type"::Purchase THEN
                                                                            "Unit Cost" := "Unit Amount";
                                                                          IF "Entry Type" = "Entry Type"::"Positive Adjmt." THEN
                                                                            "Unit Cost" :=
                                                                              ROUND(
                                                                                "Unit Amount" * (1 + "Indirect Cost %" / 100),GLSetup."Unit-Amount Rounding Precision") +
                                                                              "Overhead Rate" * "Qty. per Unit of Measure";
                                                                          IF ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND
                                                                             ("Item Charge No." = '')
                                                                          THEN
                                                                            VALIDATE("Unit Cost");
                                                                        END;
                                                                      "Entry Type"::"Negative Adjmt.",
                                                                      "Entry Type"::Consumption,
                                                                      "Entry Type"::"Assembly Consumption":
                                                                        BEGIN
                                                                          GetItem;
                                                                          IF (CurrFieldNo = FIELDNO("Unit Amount")) AND
                                                                             (Item."Costing Method" = Item."Costing Method"::Standard)
                                                                          THEN
                                                                            ERROR(
                                                                              Text002,
                                                                              FIELDCAPTION("Unit Amount"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");
                                                                          "Unit Cost" := "Unit Amount";
                                                                          IF ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND
                                                                             ("Item Charge No." = '')
                                                                          THEN
                                                                            VALIDATE("Unit Cost");
                                                                        END;
                                                                    END;
                                                              END;

                                                   CaptionML=[DAN=Pris;
                                                              ENU=Unit Amount];
                                                   AutoFormatType=2 }
    { 17  ;   ;Unit Cost           ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Item No.");
                                                                RetrieveCosts;
                                                                IF "Entry Type" IN ["Entry Type"::Purchase,"Entry Type"::"Positive Adjmt.","Entry Type"::Consumption] THEN
                                                                  IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
                                                                    IF CurrFieldNo = FIELDNO("Unit Cost") THEN
                                                                      ERROR(
                                                                        Text002,
                                                                        FIELDCAPTION("Unit Cost"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");
                                                                    "Unit Cost" := ROUND(UnitCost * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
                                                                  END;

                                                                IF ("Item Charge No." = '') AND
                                                                   ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND
                                                                   (CurrFieldNo = FIELDNO("Unit Cost"))
                                                                THEN BEGIN
                                                                  CASE "Entry Type" OF
                                                                    "Entry Type"::Purchase:
                                                                      "Unit Amount" := "Unit Cost";
                                                                    "Entry Type"::"Positive Adjmt.",
                                                                    "Entry Type"::"Assembly Output":
                                                                      BEGIN
                                                                        ReadGLSetup;
                                                                        "Unit Amount" :=
                                                                          ROUND(
                                                                            ("Unit Cost" - "Overhead Rate" * "Qty. per Unit of Measure") / (1 + "Indirect Cost %" / 100),
                                                                            GLSetup."Unit-Amount Rounding Precision")
                                                                      END;
                                                                    "Entry Type"::"Negative Adjmt.",
                                                                    "Entry Type"::Consumption,
                                                                    "Entry Type"::"Assembly Consumption":
                                                                      BEGIN
                                                                        IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                                                                          ERROR(
                                                                            Text002,
                                                                            FIELDCAPTION("Unit Cost"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");
                                                                        "Unit Amount" := "Unit Cost";
                                                                      END;
                                                                  END;
                                                                  UpdateAmount;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   AutoFormatType=2 }
    { 18  ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD(Quantity);
                                                                "Unit Amount" := Amount / Quantity;
                                                                VALIDATE("Unit Amount");
                                                                ReadGLSetup;
                                                                "Unit Amount" := ROUND("Unit Amount",GLSetup."Unit-Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 22  ;   ;Discount Amount     ;Decimal       ;CaptionML=[DAN=Rabatbel�b;
                                                              ENU=Discount Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 23  ;   ;Salespers./Purch. Code;Code20      ;TableRelation=Salesperson/Purchaser;
                                                   OnValidate=BEGIN
                                                                IF ("Order Type" <> "Order Type"::Production) OR ("Order No." = '') THEN
                                                                  CreateDim(
                                                                    DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                                                                    DATABASE::Item,"Item No.",
                                                                    DATABASE::"Work Center","Work Center No.");
                                                              END;

                                                   CaptionML=[DAN=S�lger/indk�berkode;
                                                              ENU=Salespers./Purch. Code] }
    { 26  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code];
                                                   Editable=No }
    { 29  ;   ;Applies-to Entry    ;Integer       ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                                ItemTrackingLines@1001 : Page 6510;
                                                              BEGIN
                                                                IF "Applies-to Entry" <> 0 THEN BEGIN
                                                                  ItemLedgEntry.GET("Applies-to Entry");

                                                                  IF "Value Entry Type" = "Value Entry Type"::Revaluation THEN BEGIN
                                                                    IF "Inventory Value Per" <> "Inventory Value Per"::" " THEN
                                                                      ERROR(Text006,FIELDCAPTION("Applies-to Entry"));

                                                                    IF "Inventory Value Per" = "Inventory Value Per"::" " THEN
                                                                      IF NOT RevaluationPerEntryAllowed("Item No.") THEN
                                                                        ERROR(Text034);

                                                                    InitRevalJnlLine(ItemLedgEntry);
                                                                    ItemLedgEntry.TESTFIELD(Positive,TRUE);
                                                                  END ELSE BEGIN
                                                                    TESTFIELD(Quantity);
                                                                    IF Signed(Quantity) * ItemLedgEntry.Quantity > 0 THEN BEGIN
                                                                      IF Quantity > 0 THEN
                                                                        FIELDERROR(Quantity,Text030);
                                                                      IF Quantity < 0 THEN
                                                                        FIELDERROR(Quantity,Text029);
                                                                    END;
                                                                    IF ItemLedgEntry.TrackingExists THEN
                                                                      ERROR(Text033,FIELDCAPTION("Applies-to Entry"),ItemTrackingLines.CAPTION);

                                                                    IF NOT ItemLedgEntry.Open THEN
                                                                      MESSAGE(Text032,"Applies-to Entry");

                                                                    IF "Entry Type" = "Entry Type"::Output THEN BEGIN
                                                                      ItemLedgEntry.TESTFIELD("Order Type","Order Type"::Production);
                                                                      ItemLedgEntry.TESTFIELD("Order No.","Order No.");
                                                                      ItemLedgEntry.TESTFIELD("Order Line No.","Order Line No.");
                                                                      ItemLedgEntry.TESTFIELD("Entry Type","Entry Type");
                                                                    END;
                                                                  END;

                                                                  "Location Code" := ItemLedgEntry."Location Code";
                                                                  "Variant Code" := ItemLedgEntry."Variant Code";
                                                                END ELSE
                                                                  IF "Value Entry Type" = "Value Entry Type"::Revaluation THEN BEGIN
                                                                    VALIDATE("Unit Amount",0);
                                                                    VALIDATE(Quantity,0);
                                                                    "Inventory Value (Calculated)" := 0;
                                                                    "Inventory Value (Revalued)" := 0;
                                                                    "Location Code" := '';
                                                                    "Variant Code" := '';
                                                                    "Bin Code" := '';
                                                                  END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              SelectItemEntry(FIELDNO("Applies-to Entry"));
                                                            END;

                                                   CaptionML=[DAN=Udlign.postl�benr.;
                                                              ENU=Applies-to Entry] }
    { 32  ;   ;Item Shpt. Entry No.;Integer       ;CaptionML=[DAN=Varelev.postl�benr.;
                                                              ENU=Item Shpt. Entry No.];
                                                   Editable=No }
    { 34  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 35  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 37  ;   ;Indirect Cost %     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Item No.");
                                                                TESTFIELD("Value Entry Type","Value Entry Type"::"Direct Cost");
                                                                TESTFIELD("Item Charge No.",'');
                                                                IF "Entry Type" IN ["Entry Type"::Sale,"Entry Type"::"Negative Adjmt."] THEN
                                                                  ERROR(
                                                                    Text002,
                                                                    FIELDCAPTION("Indirect Cost %"),FIELDCAPTION("Entry Type"),"Entry Type");

                                                                GetItem;
                                                                IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                                                                  ERROR(
                                                                    Text002,
                                                                    FIELDCAPTION("Indirect Cost %"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");

                                                                IF "Entry Type" <> "Entry Type"::Purchase THEN
                                                                  "Unit Cost" :=
                                                                    ROUND(
                                                                      "Unit Amount" * (1 + "Indirect Cost %" / 100) +
                                                                      "Overhead Rate" * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Indir. omkost.pct.;
                                                              ENU=Indirect Cost %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 39  ;   ;Source Type         ;Option        ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,Vare";
                                                                    ENU=" ,Customer,Vendor,Item"];
                                                   OptionString=[ ,Customer,Vendor,Item];
                                                   Editable=No }
    { 41  ;   ;Journal Batch Name  ;Code10        ;TableRelation="Item Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Template Name));
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 42  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=�rsagskode;
                                                              ENU=Reason Code] }
    { 43  ;   ;Recurring Method    ;Option        ;CaptionML=[DAN=Gentagelsesprincip;
                                                              ENU=Recurring Method];
                                                   OptionCaptionML=[DAN=,Fast,Variabel;
                                                                    ENU=,Fixed,Variable];
                                                   OptionString=,Fixed,Variable;
                                                   BlankZero=Yes }
    { 44  ;   ;Expiration Date     ;Date          ;CaptionML=[DAN=Udl�bsdato;
                                                              ENU=Expiration Date] }
    { 45  ;   ;Recurring Frequency ;DateFormula   ;CaptionML=[DAN=Gentagelsesinterval;
                                                              ENU=Recurring Frequency] }
    { 46  ;   ;Drop Shipment       ;Boolean       ;AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=Direkte levering;
                                                              ENU=Drop Shipment];
                                                   Editable=No }
    { 47  ;   ;Transaction Type    ;Code10        ;TableRelation="Transaction Type";
                                                   CaptionML=[DAN=Transaktionsart;
                                                              ENU=Transaction Type] }
    { 48  ;   ;Transport Method    ;Code10        ;TableRelation="Transport Method";
                                                   CaptionML=[DAN=Transportm�de;
                                                              ENU=Transport Method] }
    { 49  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode;
                                                              ENU=Country/Region Code] }
    { 50  ;   ;New Location Code   ;Code10        ;TableRelation=Location;
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Entry Type","Entry Type"::Transfer);
                                                                IF "New Location Code" <> xRec."New Location Code" THEN BEGIN
                                                                  "New Bin Code" := '';
                                                                  IF ("New Location Code" <> '') AND ("Item No." <> '') THEN BEGIN
                                                                    GetLocation("New Location Code");
                                                                    IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
                                                                      WMSManagement.GetDefaultBin("Item No.","Variant Code","New Location Code","New Bin Code")
                                                                  END;
                                                                END;

                                                                ReserveItemJnlLine.VerifyChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Ny lokationskode;
                                                              ENU=New Location Code] }
    { 51  ;   ;New Shortcut Dimension 1 Code;Code20;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Entry Type","Entry Type"::Transfer);
                                                                ValidateNewShortcutDimCode(1,"New Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Ny genvejsdimension 1-kode;
                                                              ENU=New Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1,' + Text007 }
    { 52  ;   ;New Shortcut Dimension 2 Code;Code20;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Entry Type","Entry Type"::Transfer);
                                                                ValidateNewShortcutDimCode(2,"New Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Ny genvejsdimension 2-kode;
                                                              ENU=New Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2,' + Text007 }
    { 53  ;   ;Qty. (Calculated)   ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Qty. (Phys. Inventory)");
                                                              END;

                                                   CaptionML=[DAN=Antal (beregnet);
                                                              ENU=Qty. (Calculated)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 54  ;   ;Qty. (Phys. Inventory);Decimal     ;OnValidate=BEGIN
                                                                TESTFIELD("Phys. Inventory",TRUE);

                                                                IF CurrFieldNo <> 0 THEN
                                                                  WMSManagement.CheckItemJnlLineFieldChange(Rec,xRec,FIELDCAPTION("Qty. (Phys. Inventory)"));

                                                                PhysInvtEntered := TRUE;
                                                                Quantity := 0;
                                                                IF "Qty. (Phys. Inventory)" >= "Qty. (Calculated)" THEN BEGIN
                                                                  VALIDATE("Entry Type","Entry Type"::"Positive Adjmt.");
                                                                  VALIDATE(Quantity,"Qty. (Phys. Inventory)" - "Qty. (Calculated)");
                                                                END ELSE BEGIN
                                                                  VALIDATE("Entry Type","Entry Type"::"Negative Adjmt.");
                                                                  VALIDATE(Quantity,"Qty. (Calculated)" - "Qty. (Phys. Inventory)");
                                                                END;
                                                                PhysInvtEntered := FALSE;
                                                              END;

                                                   CaptionML=[DAN=Antal (optalt);
                                                              ENU=Qty. (Phys. Inventory)];
                                                   DecimalPlaces=0:5 }
    { 55  ;   ;Last Item Ledger Entry No.;Integer ;TableRelation="Item Ledger Entry";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Sidste varepostl�benr.;
                                                              ENU=Last Item Ledger Entry No.];
                                                   Editable=No }
    { 56  ;   ;Phys. Inventory     ;Boolean       ;CaptionML=[DAN=Lageropg�relse;
                                                              ENU=Phys. Inventory];
                                                   Editable=No }
    { 57  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 58  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 59  ;   ;Entry/Exit Point    ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=[DAN=Indf�rsels-/udf�rselssted;
                                                              ENU=Entry/Exit Point] }
    { 60  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 62  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 63  ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=[DAN=Omr�de;
                                                              ENU=Area] }
    { 64  ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=[DAN=Transaktionsspecifikation;
                                                              ENU=Transaction Specification] }
    { 65  ;   ;Posting No. Series  ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Bogf�ringsnummerserie;
                                                              ENU=Posting No. Series] }
    { 68  ;   ;Reserved Quantity   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Journal Template Name),
                                                                                                       Source Ref. No.=FIELD(Line No.),
                                                                                                       Source Type=CONST(83),
                                                                                                       Source Subtype=FIELD(Entry Type),
                                                                                                       Source Batch Name=FIELD(Journal Batch Name),
                                                                                                       Source Prod. Order Line=CONST(0),
                                                                                                       Reservation Status=CONST(Reservation)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Reserveret antal;
                                                              ENU=Reserved Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 72  ;   ;Unit Cost (ACY)     ;Decimal       ;CaptionML=[DAN=Kostpris (EV);
                                                              ENU=Unit Cost (ACY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 73  ;   ;Source Currency Code;Code10        ;TableRelation=Currency;
                                                   AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=Kildevalutakode;
                                                              ENU=Source Currency Code];
                                                   Editable=No }
    { 79  ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Salgsleverance,Salgsfaktura,Salgsreturvarekvittering,Salgskreditnota,K�bsleverance,K�bsfaktura,K�bsreturvarekvittering,K�bskreditnota,Overf�rselsleverance,Overf�rselskvittering,Serviceleverance,Servicefaktura,Servicekreditnota,Bogf�rt montage";
                                                                    ENU=" ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly"];
                                                   OptionString=[ ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly] }
    { 80  ;   ;Document Line No.   ;Integer       ;CaptionML=[DAN=Dokumentlinjenr.;
                                                              ENU=Document Line No.] }
    { 90  ;   ;Order Type          ;Option        ;OnValidate=BEGIN
                                                                IF "Order Type" = xRec."Order Type" THEN
                                                                  EXIT;
                                                                VALIDATE("Order No.",'');
                                                                "Order Line No." := 0;
                                                              END;

                                                   CaptionML=[DAN=Ordretype;
                                                              ENU=Order Type];
                                                   OptionCaptionML=[DAN=" ,Produktion,Overf�rsel,Service,Montage";
                                                                    ENU=" ,Production,Transfer,Service,Assembly"];
                                                   OptionString=[ ,Production,Transfer,Service,Assembly];
                                                   Editable=No }
    { 91  ;   ;Order No.           ;Code20        ;TableRelation=IF (Order Type=CONST(Production)) "Production Order".No. WHERE (Status=CONST(Released));
                                                   OnValidate=VAR
                                                                AssemblyHeader@1000 : Record 900;
                                                                ProdOrder@1001 : Record 5405;
                                                                ProdOrderLine@1002 : Record 5406;
                                                              BEGIN
                                                                CASE "Order Type" OF
                                                                  "Order Type"::Production,"Order Type"::Assembly:
                                                                    BEGIN
                                                                      IF "Order No." = '' THEN BEGIN
                                                                        CASE "Order Type" OF
                                                                          "Order Type"::Production:
                                                                            CreateProdDim;
                                                                          "Order Type"::Assembly:
                                                                            CreateAssemblyDim;
                                                                        END;
                                                                        EXIT;
                                                                      END;

                                                                      CASE "Order Type" OF
                                                                        "Order Type"::Production:
                                                                          BEGIN
                                                                            GetMfgSetup;
                                                                            IF MfgSetup."Doc. No. Is Prod. Order No." THEN
                                                                              "Document No." := "Order No.";
                                                                            ProdOrder.GET(ProdOrder.Status::Released,"Order No.");
                                                                            ProdOrder.TESTFIELD(Blocked,FALSE);
                                                                            Description := ProdOrder.Description;
                                                                          END;
                                                                        "Order Type"::Assembly:
                                                                          BEGIN
                                                                            AssemblyHeader.GET(AssemblyHeader."Document Type"::Order,"Order No.");
                                                                            Description := AssemblyHeader.Description;
                                                                          END;
                                                                      END;

                                                                      "Gen. Bus. Posting Group" := ProdOrder."Gen. Bus. Posting Group";
                                                                      CASE TRUE OF
                                                                        "Entry Type" = "Entry Type"::Output:
                                                                          BEGIN
                                                                            "Inventory Posting Group" := ProdOrder."Inventory Posting Group";
                                                                            "Gen. Prod. Posting Group" := ProdOrder."Gen. Prod. Posting Group";
                                                                          END;
                                                                        "Entry Type" = "Entry Type"::"Assembly Output":
                                                                          BEGIN
                                                                            "Inventory Posting Group" := AssemblyHeader."Inventory Posting Group";
                                                                            "Gen. Prod. Posting Group" := AssemblyHeader."Gen. Prod. Posting Group";
                                                                          END;
                                                                        "Entry Type" = "Entry Type"::Consumption:
                                                                          BEGIN
                                                                            ProdOrderLine.SetFilterByReleasedOrderNo("Order No.");
                                                                            IF ProdOrderLine.COUNT = 1 THEN BEGIN
                                                                              ProdOrderLine.FINDFIRST;
                                                                              VALIDATE("Order Line No.",ProdOrderLine."Line No.");
                                                                            END;
                                                                          END;
                                                                      END;

                                                                      IF ("Order No." <> xRec."Order No.") OR ("Order Type" <> xRec."Order Type") THEN
                                                                        CASE "Order Type" OF
                                                                          "Order Type"::Production:
                                                                            CreateProdDim;
                                                                          "Order Type"::Assembly:
                                                                            CreateAssemblyDim;
                                                                        END;
                                                                    END;
                                                                  "Order Type"::Transfer,"Order Type"::Service,"Order Type"::" ":
                                                                    ERROR(Text002,FIELDCAPTION("Order No."),FIELDCAPTION("Order Type"),"Order Type");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Ordrenr.;
                                                              ENU=Order No.] }
    { 92  ;   ;Order Line No.      ;Integer       ;TableRelation=IF (Order Type=CONST(Production)) "Prod. Order Line"."Line No." WHERE (Status=CONST(Released),
                                                                                                                                        Prod. Order No.=FIELD(Order No.));
                                                   OnValidate=VAR
                                                                ProdOrderLine@1000 : Record 5406;
                                                              BEGIN
                                                                TESTFIELD("Order No.");
                                                                CASE "Order Type" OF
                                                                  "Order Type"::Production,"Order Type"::Assembly:
                                                                    BEGIN
                                                                      IF "Order Type" = "Order Type"::Production THEN BEGIN
                                                                        ProdOrderLine.SetFilterByReleasedOrderNo("Order No.");
                                                                        ProdOrderLine.SETRANGE("Line No.","Order Line No.");
                                                                        IF ProdOrderLine.FINDFIRST THEN BEGIN
                                                                          "Source Type" := "Source Type"::Item;
                                                                          "Source No." := ProdOrderLine."Item No.";
                                                                          "Order Line No." := ProdOrderLine."Line No.";
                                                                          "Routing No." := ProdOrderLine."Routing No.";
                                                                          "Routing Reference No." := ProdOrderLine."Routing Reference No.";
                                                                          IF "Entry Type" = "Entry Type"::Output THEN BEGIN
                                                                            "Location Code" := ProdOrderLine."Location Code";
                                                                            "Bin Code" := ProdOrderLine."Bin Code";
                                                                          END;
                                                                        END;
                                                                      END;

                                                                      IF "Order Line No." <> xRec."Order Line No." THEN
                                                                        CASE "Order Type" OF
                                                                          "Order Type"::Production:
                                                                            CreateProdDim;
                                                                          "Order Type"::Assembly:
                                                                            CreateAssemblyDim;
                                                                        END;
                                                                    END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Ordrelinjenr.;
                                                              ENU=Order Line No.] }
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
    { 481 ;   ;New Dimension Set ID;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Nyt dimensionsgruppe-id;
                                                              ENU=New Dimension Set ID];
                                                   Editable=No }
    { 904 ;   ;Assemble to Order   ;Boolean       ;CaptionML=[DAN=Montage til ordre;
                                                              ENU=Assemble to Order];
                                                   Editable=No }
    { 1000;   ;Job No.             ;Code20        ;CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 1001;   ;Job Task No.        ;Code20        ;CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.] }
    { 1002;   ;Job Purchase        ;Boolean       ;CaptionML=[DAN=K�b af sag;
                                                              ENU=Job Purchase] }
    { 1030;   ;Job Contract Entry No.;Integer     ;CaptionML=[DAN=L�benr. for sagskontrakt;
                                                              ENU=Job Contract Entry No.];
                                                   Editable=No }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=BEGIN
                                                                IF "Entry Type" IN ["Entry Type"::Consumption,"Entry Type"::Output] THEN
                                                                  WhseValidateSourceLine.ItemLineVerifyChange(Rec,xRec);

                                                                IF "Variant Code" <> xRec."Variant Code" THEN BEGIN
                                                                  "Bin Code" := '';
                                                                  IF CurrFieldNo <> 0 THEN
                                                                    WMSManagement.CheckItemJnlLineFieldChange(Rec,xRec,FIELDCAPTION("Variant Code"));
                                                                  IF ("Location Code" <> '') AND ("Item No." <> '') THEN BEGIN
                                                                    GetLocation("Location Code");
                                                                    IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
                                                                      WMSManagement.GetDefaultBin("Item No.","Variant Code","Location Code","Bin Code")
                                                                  END;
                                                                  IF ("Entry Type" = "Entry Type"::Transfer) AND ("Location Code" = "New Location Code") THEN
                                                                    "New Bin Code" := "Bin Code";
                                                                END;
                                                                IF ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND
                                                                   ("Item Charge No." = '')
                                                                THEN BEGIN
                                                                  GetUnitAmount(FIELDNO("Variant Code"));
                                                                  "Unit Cost" := UnitCost;
                                                                  VALIDATE("Unit Amount");
                                                                  VALIDATE("Unit of Measure Code");
                                                                  ReserveItemJnlLine.VerifyChange(Rec,xRec);
                                                                END;

                                                                IF "Variant Code" <> '' THEN BEGIN
                                                                  ItemVariant.GET("Item No.","Variant Code");
                                                                  Description := ItemVariant.Description;
                                                                END ELSE BEGIN
                                                                  GetItem;
                                                                  Description := Item.Description;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5403;   ;Bin Code            ;Code20        ;TableRelation=IF (Entry Type=FILTER(Purchase|Positive Adjmt.|Output),
                                                                     Quantity=FILTER(>=0)) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                           Item Filter=FIELD(Item No.),
                                                                                                           Variant Filter=FIELD(Variant Code))
                                                                                                           ELSE IF (Entry Type=FILTER(Purchase|Positive Adjmt.|Output),
                                                                                                                    Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                         Item No.=FIELD(Item No.),
                                                                                                                                                                         Variant Code=FIELD(Variant Code))
                                                                                                                                                                         ELSE IF (Entry Type=FILTER(Sale|Negative Adjmt.|Transfer|Consumption),
                                                                                                                                                                                  Quantity=FILTER(>0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                                                                                       Item No.=FIELD(Item No.),
                                                                                                                                                                                                                                       Variant Code=FIELD(Variant Code))
                                                                                                                                                                                                                                       ELSE IF (Entry Type=FILTER(Sale|Negative Adjmt.|Transfer|Consumption),
                                                                                                                                                                                                                                                Quantity=FILTER(<=0)) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                                                                                                                                      Item Filter=FIELD(Item No.),
                                                                                                                                                                                                                                                                                      Variant Filter=FIELD(Variant Code));
                                                   OnValidate=VAR
                                                                ProdOrderComp@1001 : Record 5407;
                                                                WhseIntegrationMgt@1000 : Codeunit 7317;
                                                              BEGIN
                                                                IF "Bin Code" <> xRec."Bin Code" THEN BEGIN
                                                                  TESTFIELD("Location Code");
                                                                  IF "Bin Code" <> '' THEN BEGIN
                                                                    GetBin("Location Code","Bin Code");
                                                                    GetLocation("Location Code");
                                                                    Location.TESTFIELD("Bin Mandatory");
                                                                    IF CurrFieldNo <> 0 THEN
                                                                      WMSManagement.CheckItemJnlLineFieldChange(Rec,xRec,FIELDCAPTION("Bin Code"));
                                                                    TESTFIELD("Location Code",Bin."Location Code");
                                                                    WhseIntegrationMgt.CheckBinTypeCode(DATABASE::"Item Journal Line",
                                                                      FIELDCAPTION("Bin Code"),
                                                                      "Location Code",
                                                                      "Bin Code",
                                                                      "Entry Type");
                                                                  END;
                                                                  IF ("Entry Type" = "Entry Type"::Transfer) AND ("Location Code" = "New Location Code") THEN
                                                                    "New Bin Code" := "Bin Code";

                                                                  IF ("Entry Type" = "Entry Type"::Consumption) AND
                                                                     ("Bin Code" <> '') AND ("Prod. Order Comp. Line No." <> 0)
                                                                  THEN BEGIN
                                                                    TESTFIELD("Order Type","Order Type"::Production);
                                                                    TESTFIELD("Order No.");
                                                                    ProdOrderComp.GET(ProdOrderComp.Status::Released,"Order No.","Order Line No.","Prod. Order Comp. Line No.");
                                                                    IF (ProdOrderComp."Bin Code" <> '') AND (ProdOrderComp."Bin Code" <> "Bin Code") THEN
                                                                      IF NOT CONFIRM(
                                                                           Text021,
                                                                           FALSE,
                                                                           "Bin Code",
                                                                           ProdOrderComp."Bin Code",
                                                                           "Order No.")
                                                                      THEN
                                                                        ERROR(UpdateInterruptedErr);
                                                                  END;
                                                                END;

                                                                ReserveItemJnlLine.VerifyChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 5404;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5406;   ;New Bin Code        ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(New Location Code),
                                                                                 Item Filter=FIELD(Item No.),
                                                                                 Variant Filter=FIELD(Variant Code));
                                                   OnValidate=VAR
                                                                WhseIntegrationMgt@1000 : Codeunit 7317;
                                                              BEGIN
                                                                TESTFIELD("Entry Type","Entry Type"::Transfer);
                                                                IF "New Bin Code" <> xRec."New Bin Code" THEN BEGIN
                                                                  TESTFIELD("New Location Code");
                                                                  IF "New Bin Code" <> '' THEN BEGIN
                                                                    GetBin("New Location Code","New Bin Code");
                                                                    GetLocation("New Location Code");
                                                                    Location.TESTFIELD("Bin Mandatory");
                                                                    IF CurrFieldNo <> 0 THEN
                                                                      WMSManagement.CheckItemJnlLineFieldChange(Rec,xRec,FIELDCAPTION("New Bin Code"));
                                                                    TESTFIELD("New Location Code",Bin."Location Code");
                                                                    WhseIntegrationMgt.CheckBinTypeCode(DATABASE::"Item Journal Line",
                                                                      FIELDCAPTION("New Bin Code"),
                                                                      "New Location Code",
                                                                      "New Bin Code",
                                                                      "Entry Type");
                                                                  END;
                                                                END;

                                                                ReserveItemJnlLine.VerifyChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Ny placeringskode;
                                                              ENU=New Bin Code] }
    { 5407;   ;Unit of Measure Code;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=BEGIN
                                                                GetItem;
                                                                "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");

                                                                IF "Entry Type" IN ["Entry Type"::Consumption,"Entry Type"::Output] THEN
                                                                  WhseValidateSourceLine.ItemLineVerifyChange(Rec,xRec);

                                                                IF CurrFieldNo <> 0 THEN
                                                                  WMSManagement.CheckItemJnlLineFieldChange(Rec,xRec,FIELDCAPTION("Unit of Measure Code"));

                                                                GetUnitAmount(FIELDNO("Unit of Measure Code"));
                                                                IF "Value Entry Type" = "Value Entry Type"::Revaluation THEN
                                                                  TESTFIELD("Qty. per Unit of Measure",1);

                                                                ReadGLSetup;
                                                                "Unit Cost" := ROUND(UnitCost * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");

                                                                IF "Entry Type" = "Entry Type"::Consumption THEN BEGIN
                                                                  "Indirect Cost %" := ROUND(Item."Indirect Cost %" * "Qty. per Unit of Measure",1);
                                                                  "Overhead Rate" :=
                                                                    ROUND(Item."Overhead Rate" * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
                                                                  "Unit Amount" := ROUND(UnitCost * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
                                                                END;

                                                                IF "No." <> '' THEN
                                                                  VALIDATE("Cap. Unit of Measure Code");

                                                                VALIDATE("Unit Amount");

                                                                IF "Entry Type" = "Entry Type"::Output THEN BEGIN
                                                                  VALIDATE("Output Quantity");
                                                                  VALIDATE("Scrap Quantity");
                                                                END ELSE
                                                                  VALIDATE(Quantity);

                                                                CheckItemAvailable(FIELDNO("Unit of Measure Code"));
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 5408;   ;Derived from Blanket Order;Boolean ;CaptionML=[DAN=Afledt fra rammeordre;
                                                              ENU=Derived from Blanket Order];
                                                   Editable=No }
    { 5413;   ;Quantity (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE(Quantity,"Quantity (Base)");
                                                              END;

                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 5415;   ;Invoiced Qty. (Base);Decimal       ;CaptionML=[DAN=Fakt. antal (basis);
                                                              ENU=Invoiced Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5468;   ;Reserved Qty. (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(Journal Template Name),
                                                                                                                Source Ref. No.=FIELD(Line No.),
                                                                                                                Source Type=CONST(83),
                                                                                                                Source Subtype=FIELD(Entry Type),
                                                                                                                Source Batch Name=FIELD(Journal Batch Name),
                                                                                                                Source Prod. Order Line=CONST(0),
                                                                                                                Reservation Status=CONST(Reservation)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Reserveret antal (basis);
                                                              ENU=Reserved Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5560;   ;Level               ;Integer       ;CaptionML=[DAN=Niveau;
                                                              ENU=Level];
                                                   Editable=No }
    { 5561;   ;Flushing Method     ;Option        ;CaptionML=[DAN=Tr�kmetode;
                                                              ENU=Flushing Method];
                                                   OptionCaptionML=[DAN=Manuelt,Forl�ns,Bagl�ns,Pluk + Forl�ns,Pluk + Bagl�ns;
                                                                    ENU=Manual,Forward,Backward,Pick + Forward,Pick + Backward];
                                                   OptionString=Manual,Forward,Backward,Pick + Forward,Pick + Backward;
                                                   Editable=No }
    { 5562;   ;Changed by User     ;Boolean       ;CaptionML=[DAN=�ndret af brugeren;
                                                              ENU=Changed by User];
                                                   Editable=No }
    { 5700;   ;Cross-Reference No. ;Code20        ;CaptionML=[DAN=Varereferencenr.;
                                                              ENU=Cross-Reference No.] }
    { 5701;   ;Originally Ordered No.;Code20      ;TableRelation=Item;
                                                   AccessByPermission=TableData 5715=R;
                                                   CaptionML=[DAN=Oprindeligt bestilt nr.;
                                                              ENU=Originally Ordered No.] }
    { 5702;   ;Originally Ordered Var. Code;Code10;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Originally Ordered No.));
                                                   AccessByPermission=TableData 5715=R;
                                                   CaptionML=[DAN=Oprind. bestilt variantkode;
                                                              ENU=Originally Ordered Var. Code] }
    { 5703;   ;Out-of-Stock Substitution;Boolean  ;CaptionML=[DAN=Erstatningsvare;
                                                              ENU=Out-of-Stock Substitution] }
    { 5704;   ;Item Category Code  ;Code20        ;TableRelation="Item Category";
                                                   CaptionML=[DAN=Varekategorikode;
                                                              ENU=Item Category Code] }
    { 5705;   ;Nonstock            ;Boolean       ;CaptionML=[DAN=Katalogvare;
                                                              ENU=Nonstock] }
    { 5706;   ;Purchasing Code     ;Code10        ;TableRelation=Purchasing;
                                                   AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=Indk�bskode;
                                                              ENU=Purchasing Code] }
    { 5707;   ;Product Group Code  ;Code10        ;TableRelation="Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
                                                   ValidateTableRelation=No;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Product Groups became first level children of Item Categories.;
                                                   CaptionML=[DAN=Produktgruppekode;
                                                              ENU=Product Group Code] }
    { 5791;   ;Planned Delivery Date;Date         ;CaptionML=[DAN=Planlagt leveringsdato;
                                                              ENU=Planned Delivery Date] }
    { 5793;   ;Order Date          ;Date          ;CaptionML=[DAN=Ordredato;
                                                              ENU=Order Date] }
    { 5800;   ;Value Entry Type    ;Option        ;CaptionML=[DAN=V�rdiposttype;
                                                              ENU=Value Entry Type];
                                                   OptionCaptionML=[DAN=K�bspris,V�rdiregulering,Afrunding,Indir. omkostning,Afvigelse;
                                                                    ENU=Direct Cost,Revaluation,Rounding,Indirect Cost,Variance];
                                                   OptionString=Direct Cost,Revaluation,Rounding,Indirect Cost,Variance }
    { 5801;   ;Item Charge No.     ;Code20        ;TableRelation="Item Charge";
                                                   CaptionML=[DAN=Varegebyrnr.;
                                                              ENU=Item Charge No.] }
    { 5802;   ;Inventory Value (Calculated);Decimal;
                                                   OnValidate=BEGIN
                                                                ReadGLSetup;
                                                                "Unit Cost (Calculated)" :=
                                                                  ROUND("Inventory Value (Calculated)" / Quantity,GLSetup."Unit-Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Lagerv�rdi (beregnet);
                                                              ENU=Inventory Value (Calculated)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5803;   ;Inventory Value (Revalued);Decimal ;OnValidate=BEGIN
                                                                TESTFIELD("Value Entry Type","Value Entry Type"::Revaluation);
                                                                VALIDATE(Amount,"Inventory Value (Revalued)" - "Inventory Value (Calculated)");
                                                                ReadGLSetup;
                                                                IF ("Unit Cost (Revalued)" <> xRec."Unit Cost (Revalued)") OR
                                                                   ("Inventory Value (Revalued)" <> xRec."Inventory Value (Revalued)")
                                                                THEN BEGIN
                                                                  IF CurrFieldNo <> FIELDNO("Unit Cost (Revalued)") THEN
                                                                    "Unit Cost (Revalued)" :=
                                                                      ROUND("Inventory Value (Revalued)" / Quantity,GLSetup."Unit-Amount Rounding Precision");

                                                                  IF CurrFieldNo <> 0 THEN
                                                                    ClearSingleAndRolledUpCosts;
                                                                END
                                                              END;

                                                   CaptionML=[DAN=Lagerv�rdi (reguleret);
                                                              ENU=Inventory Value (Revalued)];
                                                   MinValue=0;
                                                   AutoFormatType=1 }
    { 5804;   ;Variance Type       ;Option        ;CaptionML=[DAN=Afvigelsestype;
                                                              ENU=Variance Type];
                                                   OptionCaptionML=[DAN=" ,K�b,Materiale,Kapacitet,Indirekte kap.kostpris,Indirekte prod.kostpris";
                                                                    ENU=" ,Purchase,Material,Capacity,Capacity Overhead,Manufacturing Overhead"];
                                                   OptionString=[ ,Purchase,Material,Capacity,Capacity Overhead,Manufacturing Overhead] }
    { 5805;   ;Inventory Value Per ;Option        ;CaptionML=[DAN=Lagerv�rdi pr.;
                                                              ENU=Inventory Value Per];
                                                   OptionCaptionML=[DAN=" ,Vare,Lokation,Variant,Lokation og variant";
                                                                    ENU=" ,Item,Location,Variant,Location and Variant"];
                                                   OptionString=[ ,Item,Location,Variant,Location and Variant];
                                                   Editable=No }
    { 5806;   ;Partial Revaluation ;Boolean       ;CaptionML=[DAN=Delvis v�rdiregulering;
                                                              ENU=Partial Revaluation];
                                                   Editable=No }
    { 5807;   ;Applies-from Entry  ;Integer       ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                                ItemTrackingLines@1001 : Page 6510;
                                                              BEGIN
                                                                IF "Applies-from Entry" <> 0 THEN BEGIN
                                                                  TESTFIELD(Quantity);
                                                                  IF Signed(Quantity) < 0 THEN BEGIN
                                                                    IF Quantity > 0 THEN
                                                                      FIELDERROR(Quantity,Text030);
                                                                    IF Quantity < 0 THEN
                                                                      FIELDERROR(Quantity,Text029);
                                                                  END;
                                                                  ItemLedgEntry.GET("Applies-from Entry");
                                                                  ItemLedgEntry.TESTFIELD(Positive,FALSE);
                                                                  IF ItemLedgEntry.TrackingExists THEN
                                                                    ERROR(Text033,FIELDCAPTION("Applies-from Entry"),ItemTrackingLines.CAPTION);
                                                                  "Unit Cost" := CalcUnitCost(ItemLedgEntry);
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              SelectItemEntry(FIELDNO("Applies-from Entry"));
                                                            END;

                                                   CaptionML=[DAN=Udlign fra-post;
                                                              ENU=Applies-from Entry];
                                                   MinValue=0 }
    { 5808;   ;Invoice No.         ;Code20        ;CaptionML=[DAN=Fakturanr.;
                                                              ENU=Invoice No.] }
    { 5809;   ;Unit Cost (Calculated);Decimal     ;OnValidate=BEGIN
                                                                TESTFIELD("Value Entry Type","Value Entry Type"::Revaluation);
                                                              END;

                                                   CaptionML=[DAN=Kostpris (beregnet);
                                                              ENU=Unit Cost (Calculated)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 5810;   ;Unit Cost (Revalued);Decimal       ;OnValidate=BEGIN
                                                                ReadGLSetup;
                                                                TESTFIELD("Value Entry Type","Value Entry Type"::Revaluation);
                                                                IF "Unit Cost (Revalued)" <> xRec."Unit Cost (Revalued)" THEN
                                                                  VALIDATE(
                                                                    "Inventory Value (Revalued)",
                                                                    ROUND(
                                                                      "Unit Cost (Revalued)" * Quantity,GLSetup."Amount Rounding Precision"));
                                                              END;

                                                   CaptionML=[DAN=Kostpris (reguleret);
                                                              ENU=Unit Cost (Revalued)];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 5811;   ;Applied Amount      ;Decimal       ;CaptionML=[DAN=Udligningsbel�b;
                                                              ENU=Applied Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5812;   ;Update Standard Cost;Boolean       ;OnValidate=BEGIN
                                                                TESTFIELD("Inventory Value Per");
                                                                GetItem;
                                                                Item.TESTFIELD("Costing Method",Item."Costing Method"::Standard);
                                                              END;

                                                   CaptionML=[DAN=Opdater kostpris (standard);
                                                              ENU=Update Standard Cost] }
    { 5813;   ;Amount (ACY)        ;Decimal       ;CaptionML=[DAN=Bel�b (EV);
                                                              ENU=Amount (ACY)];
                                                   AutoFormatType=1 }
    { 5817;   ;Correction          ;Boolean       ;CaptionML=[DAN=Rettelse;
                                                              ENU=Correction] }
    { 5818;   ;Adjustment          ;Boolean       ;CaptionML=[DAN=Regulering;
                                                              ENU=Adjustment] }
    { 5819;   ;Applies-to Value Entry;Integer     ;CaptionML=[DAN=Udligningsv�rdipost;
                                                              ENU=Applies-to Value Entry] }
    { 5820;   ;Invoice-to Source No.;Code20       ;TableRelation=IF (Source Type=CONST(Customer)) Customer
                                                                 ELSE IF (Source Type=CONST(Vendor)) Vendor;
                                                   CaptionML=[DAN=Kildenr. for fakturer-til;
                                                              ENU=Invoice-to Source No.] }
    { 5830;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                IF Type = Type::Resource THEN
                                                                  TESTFIELD("Entry Type","Entry Type"::"Assembly Output")
                                                                ELSE
                                                                  TESTFIELD("Entry Type","Entry Type"::Output);
                                                                VALIDATE("No.",'');
                                                              END;

                                                   AccessByPermission=TableData 99000758=R;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Arbejdscenter,Produktionsressource, ,Ressource;
                                                                    ENU=Work Center,Machine Center, ,Resource];
                                                   OptionString=Work Center,Machine Center, ,Resource }
    { 5831;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(Machine Center)) "Machine Center"
                                                                 ELSE IF (Type=CONST(Work Center)) "Work Center"
                                                                 ELSE IF (Type=CONST(Resource)) Resource;
                                                   OnValidate=VAR
                                                                Resource@1000 : Record 156;
                                                              BEGIN
                                                                IF Type = Type::Resource THEN
                                                                  TESTFIELD("Entry Type","Entry Type"::"Assembly Output")
                                                                ELSE
                                                                  TESTFIELD("Entry Type","Entry Type"::Output);
                                                                IF "No." = '' THEN BEGIN
                                                                  "Work Center No." := '';
                                                                  "Work Center Group Code" := '';
                                                                  VALIDATE("Item No.");
                                                                  IF Type IN [Type::"Work Center",Type::"Machine Center"] THEN
                                                                    CreateDimWithProdOrderLine
                                                                  ELSE
                                                                    CreateDim(
                                                                      DATABASE::"Work Center","Work Center No.",
                                                                      DATABASE::Item,"Item No.",
                                                                      DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code");
                                                                  EXIT;
                                                                END;

                                                                CASE Type OF
                                                                  Type::"Work Center":
                                                                    BEGIN
                                                                      WorkCenter.GET("No.");
                                                                      WorkCenter.TESTFIELD(Blocked,FALSE);
                                                                      "Work Center No." := WorkCenter."No.";
                                                                      Description := WorkCenter.Name;
                                                                      "Gen. Prod. Posting Group" := WorkCenter."Gen. Prod. Posting Group";
                                                                      "Unit Cost Calculation" := WorkCenter."Unit Cost Calculation";
                                                                    END;
                                                                  Type::"Machine Center":
                                                                    BEGIN
                                                                      MachineCenter.GET("No.");
                                                                      MachineCenter.TESTFIELD(Blocked,FALSE);
                                                                      "Work Center No." := MachineCenter."Work Center No.";
                                                                      Description := MachineCenter.Name;
                                                                      WorkCenter.GET("Work Center No.");
                                                                      WorkCenter.TESTFIELD(Blocked,FALSE);
                                                                      "Gen. Prod. Posting Group" := MachineCenter."Gen. Prod. Posting Group";
                                                                      "Unit Cost Calculation" := "Unit Cost Calculation"::Time;
                                                                    END;
                                                                  Type::Resource:
                                                                    BEGIN
                                                                      Resource.GET("No.");
                                                                      Resource.TESTFIELD(Blocked,FALSE);
                                                                    END;
                                                                END;

                                                                IF Type IN [Type::"Work Center",Type::"Machine Center"] THEN BEGIN
                                                                  "Work Center No." := WorkCenter."No.";
                                                                  "Work Center Group Code" := WorkCenter."Work Center Group Code"; // NAVCZ
                                                                  VALIDATE("Cap. Unit of Measure Code",WorkCenter."Unit of Measure Code");
                                                                END;

                                                                IF "Work Center No." <> '' THEN
                                                                  CreateDimWithProdOrderLine;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 5838;   ;Operation No.       ;Code10        ;TableRelation=IF (Order Type=CONST(Production)) "Prod. Order Routing Line"."Operation No." WHERE (Status=CONST(Released),
                                                                                                                                                     Prod. Order No.=FIELD(Order No.),
                                                                                                                                                     Routing No.=FIELD(Routing No.),
                                                                                                                                                     Routing Reference No.=FIELD(Routing Reference No.));
                                                   OnValidate=VAR
                                                                ProdOrderRtngLine@1000 : Record 5409;
                                                              BEGIN
                                                                TESTFIELD("Entry Type","Entry Type"::Output);
                                                                IF "Operation No." = '' THEN
                                                                  EXIT;

                                                                TESTFIELD("Order Type","Order Type"::Production);
                                                                TESTFIELD("Order No.");
                                                                TESTFIELD("Item No.");

                                                                ConfirmOutputOnFinishedOperation;
                                                                GetProdOrderRtngLine(ProdOrderRtngLine);

                                                                CASE ProdOrderRtngLine.Type OF
                                                                  ProdOrderRtngLine.Type::"Work Center":
                                                                    Type := Type::"Work Center";
                                                                  ProdOrderRtngLine.Type::"Machine Center":
                                                                    Type := Type::"Machine Center";
                                                                END;
                                                                VALIDATE("No.",ProdOrderRtngLine."No.");
                                                                Description := ProdOrderRtngLine.Description;
                                                              END;

                                                   CaptionML=[DAN=Operationsnr.;
                                                              ENU=Operation No.] }
    { 5839;   ;Work Center No.     ;Code20        ;TableRelation="Work Center";
                                                   CaptionML=[DAN=Arbejdscenternr.;
                                                              ENU=Work Center No.];
                                                   Editable=No }
    { 5841;   ;Setup Time          ;Decimal       ;OnValidate=BEGIN
                                                                IF SubcontractingWorkCenterUsed AND ("Setup Time" <> 0) THEN
                                                                  ERROR(STRSUBSTNO(SubcontractedErr,FIELDCAPTION("Setup Time"),"Line No."));
                                                                "Setup Time (Base)" := CalcBaseTime("Setup Time");
                                                              END;

                                                   AccessByPermission=TableData 99000758=R;
                                                   CaptionML=[DAN=Opstillingstid;
                                                              ENU=Setup Time];
                                                   DecimalPlaces=0:5 }
    { 5842;   ;Run Time            ;Decimal       ;OnValidate=BEGIN
                                                                IF SubcontractingWorkCenterUsed AND ("Run Time" <> 0) THEN
                                                                  ERROR(STRSUBSTNO(SubcontractedErr,FIELDCAPTION("Run Time"),"Line No."));

                                                                "Run Time (Base)" := CalcBaseTime("Run Time");
                                                              END;

                                                   AccessByPermission=TableData 99000758=R;
                                                   CaptionML=[DAN=Operationstid;
                                                              ENU=Run Time];
                                                   DecimalPlaces=0:5 }
    { 5843;   ;Stop Time           ;Decimal       ;OnValidate=BEGIN
                                                                "Stop Time (Base)" := CalcBaseTime("Stop Time");
                                                              END;

                                                   AccessByPermission=TableData 99000758=R;
                                                   CaptionML=[DAN=Stoptid;
                                                              ENU=Stop Time];
                                                   DecimalPlaces=0:5 }
    { 5846;   ;Output Quantity     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Entry Type","Entry Type"::Output);
                                                                IF SubcontractingWorkCenterUsed AND ("Output Quantity" <> 0) THEN
                                                                  ERROR(STRSUBSTNO(SubcontractedErr,FIELDCAPTION("Output Quantity"),"Line No."));

                                                                ConfirmOutputOnFinishedOperation;

                                                                IF LastOutputOperation(Rec) THEN
                                                                  WhseValidateSourceLine.ItemLineVerifyChange(Rec,xRec);

                                                                "Output Quantity (Base)" := CalcBaseQty("Output Quantity");

                                                                VALIDATE(Quantity,"Output Quantity");
                                                              END;

                                                   AccessByPermission=TableData 99000758=R;
                                                   CaptionML=[DAN=Afgangsantal;
                                                              ENU=Output Quantity];
                                                   DecimalPlaces=0:5 }
    { 5847;   ;Scrap Quantity      ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Entry Type","Entry Type"::Output);
                                                                "Scrap Quantity (Base)" := CalcBaseQty("Scrap Quantity");
                                                              END;

                                                   AccessByPermission=TableData 99000758=R;
                                                   CaptionML=[DAN=Spildantal;
                                                              ENU=Scrap Quantity];
                                                   DecimalPlaces=0:5 }
    { 5849;   ;Concurrent Capacity ;Decimal       ;OnValidate=VAR
                                                                TotalTime@1000 : Integer;
                                                              BEGIN
                                                                TESTFIELD("Entry Type","Entry Type"::Output);
                                                                IF "Concurrent Capacity" = 0 THEN
                                                                  EXIT;

                                                                TESTFIELD("Starting Time");
                                                                TESTFIELD("Ending Time");
                                                                TotalTime := CalendarMgt.CalcTimeDelta("Ending Time","Starting Time");
                                                                IF "Ending Time" < "Starting Time" THEN
                                                                  TotalTime := TotalTime + 86400000;
                                                                TESTFIELD("Work Center No.");
                                                                WorkCenter.GET("Work Center No.");
                                                                VALIDATE("Setup Time",0);
                                                                VALIDATE(
                                                                  "Run Time",
                                                                  ROUND(
                                                                    TotalTime / CalendarMgt.TimeFactor("Cap. Unit of Measure Code") *
                                                                    "Concurrent Capacity",WorkCenter."Calendar Rounding Precision"));
                                                              END;

                                                   AccessByPermission=TableData 99000758=R;
                                                   CaptionML=[DAN=Samtidig kapacitet;
                                                              ENU=Concurrent Capacity];
                                                   DecimalPlaces=0:5 }
    { 5851;   ;Setup Time (Base)   ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Cap. Unit of Measure",1);
                                                                VALIDATE("Setup Time","Setup Time (Base)");
                                                              END;

                                                   CaptionML=[DAN=Opstillingstid (basis);
                                                              ENU=Setup Time (Base)];
                                                   DecimalPlaces=0:5 }
    { 5852;   ;Run Time (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Cap. Unit of Measure",1);
                                                                VALIDATE("Run Time","Run Time (Base)");
                                                              END;

                                                   CaptionML=[DAN=Operationstid (basis);
                                                              ENU=Run Time (Base)];
                                                   DecimalPlaces=0:5 }
    { 5853;   ;Stop Time (Base)    ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Cap. Unit of Measure",1);
                                                                VALIDATE("Stop Time","Stop Time (Base)");
                                                              END;

                                                   CaptionML=[DAN=Stoptid (basis);
                                                              ENU=Stop Time (Base)];
                                                   DecimalPlaces=0:5 }
    { 5856;   ;Output Quantity (Base);Decimal     ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE("Output Quantity","Output Quantity (Base)");
                                                              END;

                                                   CaptionML=[DAN=Afgangsantal (basis);
                                                              ENU=Output Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 5857;   ;Scrap Quantity (Base);Decimal      ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE("Scrap Quantity","Scrap Quantity (Base)");
                                                              END;

                                                   CaptionML=[DAN=Spildantal (basis);
                                                              ENU=Scrap Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 5858;   ;Cap. Unit of Measure Code;Code10   ;TableRelation=IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.))
                                                                 ELSE "Capacity Unit of Measure";
                                                   OnValidate=VAR
                                                                ProdOrderRtngLine@1000 : Record 5409;
                                                              BEGIN
                                                                IF Type <> Type::Resource THEN BEGIN
                                                                  "Qty. per Cap. Unit of Measure" :=
                                                                    ROUND(
                                                                      CalendarMgt.QtyperTimeUnitofMeasure(
                                                                        "Work Center No.","Cap. Unit of Measure Code"),
                                                                      0.00001);

                                                                  VALIDATE("Setup Time");
                                                                  VALIDATE("Run Time");
                                                                  VALIDATE("Stop Time");
                                                                END;

                                                                IF "Order No." <> '' THEN
                                                                  CASE "Order Type" OF
                                                                    "Order Type"::Production:
                                                                      BEGIN
                                                                        GetProdOrderRtngLine(ProdOrderRtngLine);
                                                                        "Unit Cost" := ProdOrderRtngLine."Unit Cost per";

                                                                        CostCalcMgt.RoutingCostPerUnit(
                                                                          Type,"No.","Unit Amount","Indirect Cost %","Overhead Rate","Unit Cost","Unit Cost Calculation");
                                                                      END;
                                                                    "Order Type"::Assembly:
                                                                      CostCalcMgt.ResourceCostPerUnit("No.","Unit Amount","Indirect Cost %","Overhead Rate","Unit Cost");
                                                                  END;

                                                                ReadGLSetup;
                                                                "Unit Cost" :=
                                                                  ROUND("Unit Cost" * "Qty. per Cap. Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
                                                                "Unit Amount" :=
                                                                  ROUND("Unit Amount" * "Qty. per Cap. Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
                                                                VALIDATE("Unit Amount");
                                                              END;

                                                   CaptionML=[DAN=Kapacitetsenhedskode;
                                                              ENU=Cap. Unit of Measure Code] }
    { 5859;   ;Qty. per Cap. Unit of Measure;Decimal;
                                                   CaptionML=[DAN=Antal pr. kapacitetsenhed;
                                                              ENU=Qty. per Cap. Unit of Measure];
                                                   DecimalPlaces=0:5 }
    { 5873;   ;Starting Time       ;Time          ;OnValidate=BEGIN
                                                                IF "Ending Time" < "Starting Time" THEN
                                                                  "Ending Time" := "Starting Time";

                                                                VALIDATE("Concurrent Capacity");
                                                              END;

                                                   AccessByPermission=TableData 99000758=R;
                                                   CaptionML=[DAN=Starttidspunkt;
                                                              ENU=Starting Time] }
    { 5874;   ;Ending Time         ;Time          ;OnValidate=BEGIN
                                                                VALIDATE("Concurrent Capacity");
                                                              END;

                                                   AccessByPermission=TableData 99000758=R;
                                                   CaptionML=[DAN=Sluttidspunkt;
                                                              ENU=Ending Time] }
    { 5882;   ;Routing No.         ;Code20        ;TableRelation="Routing Header";
                                                   CaptionML=[DAN=Rutenr.;
                                                              ENU=Routing No.];
                                                   Editable=No }
    { 5883;   ;Routing Reference No.;Integer      ;CaptionML=[DAN=Rutereferencenr.;
                                                              ENU=Routing Reference No.] }
    { 5884;   ;Prod. Order Comp. Line No.;Integer ;TableRelation=IF (Order Type=CONST(Production)) "Prod. Order Component"."Line No." WHERE (Status=CONST(Released),
                                                                                                                                             Prod. Order No.=FIELD(Order No.),
                                                                                                                                             Prod. Order Line No.=FIELD(Order Line No.));
                                                   OnValidate=BEGIN
                                                                IF "Prod. Order Comp. Line No." <> xRec."Prod. Order Comp. Line No." THEN
                                                                  CreateProdDim;
                                                              END;

                                                   CaptionML=[DAN=Prod.ordrekomponentlinjenr.;
                                                              ENU=Prod. Order Comp. Line No.] }
    { 5885;   ;Finished            ;Boolean       ;AccessByPermission=TableData 99000758=R;
                                                   CaptionML=[DAN=F�rdig;
                                                              ENU=Finished] }
    { 5887;   ;Unit Cost Calculation;Option       ;CaptionML=[DAN=Kostprisberegning;
                                                              ENU=Unit Cost Calculation];
                                                   OptionCaptionML=[DAN=Tid,Enheder;
                                                                    ENU=Time,Units];
                                                   OptionString=Time,Units }
    { 5888;   ;Subcontracting      ;Boolean       ;CaptionML=[DAN=Underleverance;
                                                              ENU=Subcontracting] }
    { 5895;   ;Stop Code           ;Code10        ;TableRelation=Stop;
                                                   CaptionML=[DAN=Stopkode;
                                                              ENU=Stop Code] }
    { 5896;   ;Scrap Code          ;Code10        ;TableRelation=Scrap;
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Type,Type::"Machine Center");
                                                              END;

                                                   CaptionML=[DAN=Spildkode;
                                                              ENU=Scrap Code] }
    { 5898;   ;Work Center Group Code;Code10      ;TableRelation="Work Center Group";
                                                   CaptionML=[DAN=Arbejdscentergruppekode;
                                                              ENU=Work Center Group Code];
                                                   Editable=No }
    { 5899;   ;Work Shift Code     ;Code10        ;TableRelation="Work Shift";
                                                   CaptionML=[DAN=Arbejdsskiftskode;
                                                              ENU=Work Shift Code] }
    { 6500;   ;Serial No.          ;Code20        ;CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.];
                                                   Editable=No }
    { 6501;   ;Lot No.             ;Code20        ;CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot No.];
                                                   Editable=No }
    { 6502;   ;Warranty Date       ;Date          ;CaptionML=[DAN=Garantioph�r den;
                                                              ENU=Warranty Date];
                                                   Editable=No }
    { 6503;   ;New Serial No.      ;Code20        ;CaptionML=[DAN=Nyt serienr.;
                                                              ENU=New Serial No.];
                                                   Editable=No }
    { 6504;   ;New Lot No.         ;Code20        ;CaptionML=[DAN=Nyt lotnr.;
                                                              ENU=New Lot No.];
                                                   Editable=No }
    { 6505;   ;New Item Expiration Date;Date      ;CaptionML=[DAN=Ny vareudl�bsdato;
                                                              ENU=New Item Expiration Date] }
    { 6506;   ;Item Expiration Date;Date          ;CaptionML=[DAN=Vareudl�bsdato;
                                                              ENU=Item Expiration Date];
                                                   Editable=No }
    { 6600;   ;Return Reason Code  ;Code10        ;TableRelation="Return Reason";
                                                   CaptionML=[DAN=Retur�rsagskode;
                                                              ENU=Return Reason Code] }
    { 7315;   ;Warehouse Adjustment;Boolean       ;CaptionML=[DAN=Lagerregulering;
                                                              ENU=Warehouse Adjustment] }
    { 7380;   ;Phys Invt Counting Period Code;Code10;
                                                   TableRelation="Phys. Invt. Counting Period";
                                                   CaptionML=[DAN=Lageropg.-opt�llingsperiodekode;
                                                              ENU=Phys Invt Counting Period Code];
                                                   Editable=No }
    { 7381;   ;Phys Invt Counting Period Type;Option;
                                                   CaptionML=[DAN=Lageropg.-opt�llingsperiodetype;
                                                              ENU=Phys Invt Counting Period Type];
                                                   OptionCaptionML=[DAN=" ,Vare,Lagervare";
                                                                    ENU=" ,Item,SKU"];
                                                   OptionString=[ ,Item,SKU];
                                                   Editable=No }
    { 99000755;;Overhead Rate      ;Decimal       ;OnValidate=BEGIN
                                                                IF ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") OR
                                                                   ("Item Charge No." <> '')
                                                                THEN BEGIN
                                                                  "Overhead Rate" := 0;
                                                                  VALIDATE("Indirect Cost %",0);
                                                                END ELSE
                                                                  VALIDATE("Indirect Cost %");
                                                              END;

                                                   CaptionML=[DAN=IPO-bidrag;
                                                              ENU=Overhead Rate];
                                                   DecimalPlaces=0:5 }
    { 99000756;;Single-Level Material Cost;Decimal;CaptionML=[DAN=Materialekostpris (enkeltniv.);
                                                              ENU=Single-Level Material Cost];
                                                   AutoFormatType=1 }
    { 99000757;;Single-Level Capacity Cost;Decimal;CaptionML=[DAN=Kapacitetskostpris (enkeltniv);
                                                              ENU=Single-Level Capacity Cost];
                                                   AutoFormatType=1 }
    { 99000758;;Single-Level Subcontrd. Cost;Decimal;
                                                   CaptionML=[DAN=Underlev.kostpris (enkeltniv.);
                                                              ENU=Single-Level Subcontrd. Cost];
                                                   AutoFormatType=1 }
    { 99000759;;Single-Level Cap. Ovhd Cost;Decimal;
                                                   CaptionML=[DAN=Ind. kap.kostpris (enkeltniv.);
                                                              ENU=Single-Level Cap. Ovhd Cost];
                                                   AutoFormatType=1 }
    { 99000760;;Single-Level Mfg. Ovhd Cost;Decimal;
                                                   CaptionML=[DAN=Ind. prod.kostpris (enkeltniv);
                                                              ENU=Single-Level Mfg. Ovhd Cost];
                                                   AutoFormatType=1 }
    { 99000761;;Rolled-up Material Cost;Decimal   ;CaptionML=[DAN=Akkum. materialekostpris;
                                                              ENU=Rolled-up Material Cost];
                                                   AutoFormatType=1 }
    { 99000762;;Rolled-up Capacity Cost;Decimal   ;CaptionML=[DAN=Akkum. kapacitetskostpris;
                                                              ENU=Rolled-up Capacity Cost];
                                                   AutoFormatType=1 }
    { 99000763;;Rolled-up Subcontracted Cost;Decimal;
                                                   CaptionML=[DAN=Underlev.kostpris (akkum.);
                                                              ENU=Rolled-up Subcontracted Cost];
                                                   AutoFormatType=1 }
    { 99000764;;Rolled-up Mfg. Ovhd Cost;Decimal  ;CaptionML=[DAN=Ind. prod.kostpris (akkum.);
                                                              ENU=Rolled-up Mfg. Ovhd Cost];
                                                   AutoFormatType=1 }
    { 99000765;;Rolled-up Cap. Overhead Cost;Decimal;
                                                   CaptionML=[DAN=Faste omkostninger (akkum.);
                                                              ENU=Rolled-up Cap. Overhead Cost];
                                                   AutoFormatType=1 }
  }
  KEYS
  {
    {    ;Journal Template Name,Journal Batch Name,Line No.;
                                                   MaintainSIFTIndex=No;
                                                   Clustered=Yes }
    {    ;Entry Type,Item No.,Variant Code,Location Code,Bin Code,Posting Date;
                                                   SumIndexFields=Quantity (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Entry Type,Item No.,Variant Code,New Location Code,New Bin Code,Posting Date;
                                                   SumIndexFields=Quantity (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Item No.,Posting Date                    }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'DAN=%1 skal reduceres.;ENU=%1 must be reduced.';
      Text002@1002 : TextConst 'DAN=Du kan ikke �ndre %1, n�r %2 er %3.;ENU=You cannot change %1 when %2 is %3.';
      Text006@1005 : TextConst 'DAN=Du m� ikke angive %1 p� en v�rdireguleringsbel�bslinje.;ENU=You must not enter %1 in a revaluation sum line.';
      ItemJnlTemplate@1007 : Record 82;
      ItemJnlBatch@1008 : Record 233;
      ItemJnlLine@1009 : Record 83;
      Item@1010 : Record 27;
      ItemVariant@1012 : Record 5401;
      GLSetup@1014 : Record 98;
      MfgSetup@1034 : Record 99000765;
      WorkCenter@1040 : Record 99000754;
      MachineCenter@1039 : Record 99000758;
      Location@1048 : Record 14;
      Bin@1030 : Record 7354;
      ItemCheckAvail@1021 : Codeunit 311;
      ReserveItemJnlLine@1022 : Codeunit 99000835;
      NoSeriesMgt@1023 : Codeunit 396;
      UOMMgt@1024 : Codeunit 5402;
      DimMgt@1027 : Codeunit 408;
      UserMgt@1033 : Codeunit 5700;
      CalendarMgt@1041 : Codeunit 99000755;
      CostCalcMgt@1042 : Codeunit 5836;
      PurchPriceCalcMgt@1020 : Codeunit 7010;
      SalesPriceCalcMgt@1025 : Codeunit 7000;
      WMSManagement@1026 : Codeunit 7302;
      WhseValidateSourceLine@1032 : Codeunit 5777;
      PhysInvtEntered@1028 : Boolean;
      GLSetupRead@1029 : Boolean;
      MfgSetupRead@1035 : Boolean;
      UnitCost@1031 : Decimal;
      Text007@1006 : TextConst 'DAN="Ny ";ENU="New "';
      UpdateInterruptedErr@1045 : TextConst 'DAN=Opdateringen er afbrudt p� grund af advarslen.;ENU=The update has been interrupted to respect the warning.';
      Text021@1051 : TextConst 'DAN=Den angivne placeringskode %1 er en anden end placeringskoden %2 i produktionsordrekomponenten %3.\\Er du sikker p�, at du vil bogf�re forbruget fra placeringskoden %1?;ENU=The entered bin code %1 is different from the bin code %2 in production order component %3.\\Are you sure that you want to post the consumption from bin code %1?';
      Text029@1047 : TextConst 'DAN=skal v�re positiv;ENU=must be positive';
      Text030@1046 : TextConst 'DAN=skal v�re negativ;ENU=must be negative';
      Text031@1043 : TextConst 'DAN=Du kan ikke inds�tte varenummer %1, fordi varen ikke produceres i den frigivne produktionsordre %2.;ENU=You can not insert item number %1 because it is not produced on released production order %2.';
      Text032@1000 : TextConst 'DAN=N�r posten bogf�res, �bnes %1 f�rst.;ENU=When posting, the entry %1 will be opened first.';
      Text033@1049 : TextConst 'DAN=Hvis varen har serie- eller lotnumre, skal du bruge feltet %1 i vinduet %2.;ENU=If the item carries serial or lot numbers, then you must use the %1 field in the %2 window.';
      Text034@1050 : TextConst 'DAN=Du kan ikke regulere vareposter for varer, der bruger den gennemsnitlige kostprisberegningsmetode.;ENU=You cannot revalue individual item ledger entries for items that use the average costing method.';
      SubcontractedErr@1003 : TextConst '@@@=%1 - Field Caption, %2 - Line No.;DAN=%1 skal v�re nul i linjenummer %2, fordi det er tilknyttet underleverand�rens arbejdscenter.;ENU=%1 must be zero in line number %2 because it is linked to the subcontracted work center.';
      FinishedOutputQst@1004 : TextConst 'DAN=Handlingen er udf�rt. Vil du bogf�re resultatet af den f�rdige handling?;ENU=The operation has been finished. Do you want to post output for the finished operation?';

    [External]
    PROCEDURE EmptyLine@5() : Boolean;
    BEGIN
      EXIT(
        (Quantity = 0) AND
        ((TimeIsEmpty AND ("Item No." = '')) OR
         ("Value Entry Type" = "Value Entry Type"::Revaluation)));
    END;

    [External]
    PROCEDURE IsValueEntryForDeletedItem@22() : Boolean;
    BEGIN
      EXIT(
        (("Entry Type" = "Entry Type"::Output) OR ("Value Entry Type" = "Value Entry Type"::Rounding)) AND
        ("Item No." = '') AND ("Item Charge No." = '') AND ("Invoiced Qty. (Base)" <> 0));
    END;

    LOCAL PROCEDURE CalcBaseQty@14(Qty@1000 : Decimal) : Decimal;
    BEGIN
      TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    END;

    LOCAL PROCEDURE CalcBaseTime@28(Qty@1000 : Decimal) : Decimal;
    BEGIN
      IF "Run Time" <> 0 THEN
        TESTFIELD("Qty. per Cap. Unit of Measure");
      EXIT(ROUND(Qty * "Qty. per Cap. Unit of Measure",0.00001));
    END;

    LOCAL PROCEDURE UpdateAmount@23();
    BEGIN
      Amount := ROUND(Quantity * "Unit Amount");

      OnAfterUpdateAmount(Rec);
    END;

    LOCAL PROCEDURE SelectItemEntry@3(CurrentFieldNo@1000 : Integer);
    VAR
      ItemLedgEntry@1001 : Record 32;
      ItemJnlLine2@1002 : Record 83;
    BEGIN
      IF ("Entry Type" = "Entry Type"::Output) AND
         ("Value Entry Type" <> "Value Entry Type"::Revaluation) AND
         (CurrentFieldNo = FIELDNO("Applies-to Entry"))
      THEN BEGIN
        ItemLedgEntry.SETCURRENTKEY(
          "Order Type","Order No.","Order Line No.","Entry Type","Prod. Order Comp. Line No.");
        ItemLedgEntry.SETRANGE("Order Type","Order Type"::Production);
        ItemLedgEntry.SETRANGE("Order No.","Order No.");
        ItemLedgEntry.SETRANGE("Order Line No.","Order Line No.");
        ItemLedgEntry.SETRANGE("Entry Type","Entry Type");
        ItemLedgEntry.SETRANGE("Prod. Order Comp. Line No.",0);
      END ELSE BEGIN
        ItemLedgEntry.SETCURRENTKEY("Item No.",Positive);
        ItemLedgEntry.SETRANGE("Item No.","Item No.");
      END;

      IF "Location Code" <> '' THEN
        ItemLedgEntry.SETRANGE("Location Code","Location Code");

      IF CurrentFieldNo = FIELDNO("Applies-to Entry") THEN BEGIN
        ItemLedgEntry.SETRANGE(Positive,(Signed(Quantity) < 0) OR ("Value Entry Type" = "Value Entry Type"::Revaluation));
        IF "Value Entry Type" <> "Value Entry Type"::Revaluation THEN BEGIN
          ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
          ItemLedgEntry.SETRANGE(Open,TRUE);
        END;
      END ELSE
        ItemLedgEntry.SETRANGE(Positive,FALSE);

      IF PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
        ItemJnlLine2 := Rec;
        IF CurrentFieldNo = FIELDNO("Applies-to Entry") THEN
          ItemJnlLine2.VALIDATE("Applies-to Entry",ItemLedgEntry."Entry No.")
        ELSE
          ItemJnlLine2.VALIDATE("Applies-from Entry",ItemLedgEntry."Entry No.");
        CheckItemAvailable(CurrentFieldNo);
        Rec := ItemJnlLine2;
      END;
    END;

    LOCAL PROCEDURE CheckItemAvailable@1(CalledByFieldNo@1000 : Integer);
    BEGIN
      IF (CurrFieldNo = 0) OR (CurrFieldNo <> CalledByFieldNo) THEN // Prevent two checks on quantity
        EXIT;

      IF (CurrFieldNo <> 0) AND ("Item No." <> '') AND (Quantity <> 0) AND
         ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND ("Item Charge No." = '')
      THEN
        IF ItemCheckAvail.ItemJnlCheckLine(Rec) THEN
          ItemCheckAvail.RaiseUpdateInterruptedError;
    END;

    LOCAL PROCEDURE GetItem@2();
    BEGIN
      IF Item."No." <> "Item No." THEN
        Item.GET("Item No.");
    END;

    [External]
    PROCEDURE SetUpNewLine@8(LastItemJnlLine@1000 : Record 83);
    BEGIN
      MfgSetup.GET;
      ItemJnlTemplate.GET("Journal Template Name");
      ItemJnlBatch.GET("Journal Template Name","Journal Batch Name");
      ItemJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
      ItemJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
      IF ItemJnlLine.FINDFIRST THEN BEGIN
        "Posting Date" := LastItemJnlLine."Posting Date";
        "Document Date" := LastItemJnlLine."Posting Date";
        IF (ItemJnlTemplate.Type IN
            [ItemJnlTemplate.Type::Consumption,ItemJnlTemplate.Type::Output])
        THEN BEGIN
          IF NOT MfgSetup."Doc. No. Is Prod. Order No." THEN
            "Document No." := LastItemJnlLine."Document No."
        END ELSE
          "Document No." := LastItemJnlLine."Document No.";
      END ELSE BEGIN
        "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
        IF ItemJnlBatch."No. Series" <> '' THEN BEGIN
          CLEAR(NoSeriesMgt);
          "Document No." := NoSeriesMgt.TryGetNextNo(ItemJnlBatch."No. Series","Posting Date");
        END;
        IF (ItemJnlTemplate.Type IN
            [ItemJnlTemplate.Type::Consumption,ItemJnlTemplate.Type::Output]) AND
           NOT MfgSetup."Doc. No. Is Prod. Order No."
        THEN
          IF ItemJnlBatch."No. Series" <> '' THEN BEGIN
            CLEAR(NoSeriesMgt);
            "Document No." := NoSeriesMgt.GetNextNo(ItemJnlBatch."No. Series","Posting Date",FALSE);
          END;
      END;
      "Recurring Method" := LastItemJnlLine."Recurring Method";
      "Entry Type" := LastItemJnlLine."Entry Type";
      "Source Code" := ItemJnlTemplate."Source Code";
      "Reason Code" := ItemJnlBatch."Reason Code";
      "Posting No. Series" := ItemJnlBatch."Posting No. Series";
      IF ItemJnlTemplate.Type = ItemJnlTemplate.Type::Revaluation THEN BEGIN
        "Value Entry Type" := "Value Entry Type"::Revaluation;
        "Entry Type" := "Entry Type"::"Positive Adjmt.";
      END;

      CASE "Entry Type" OF
        "Entry Type"::Purchase:
          "Location Code" := UserMgt.GetLocation(1,'',UserMgt.GetPurchasesFilter);
        "Entry Type"::Sale:
          "Location Code" := UserMgt.GetLocation(0,'',UserMgt.GetSalesFilter);
        "Entry Type"::Output:
          CLEAR(DimMgt);
      END;

      IF Location.GET("Location Code") THEN
        IF  Location."Directed Put-away and Pick" THEN
          "Location Code" := '';

      OnAfterSetupNewLine(Rec,LastItemJnlLine);
    END;

    [External]
    PROCEDURE SetDocNos@165(DocType@1000 : Option;DocNo@1001 : Code[20];ExtDocNo@1002 : Text[35];PostingNos@1003 : Code[20]);
    BEGIN
      "Document Type" := DocType;
      "Document No." := DocNo;
      "External Document No." := ExtDocNo;
      "Posting No. Series" := PostingNos;
    END;

    LOCAL PROCEDURE GetUnitAmount@6(CalledByFieldNo@1000 : Integer);
    VAR
      UnitCostValue@1001 : Decimal;
    BEGIN
      RetrieveCosts;
      IF ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") OR
         ("Item Charge No." <> '')
      THEN
        EXIT;

      UnitCostValue := UnitCost;
      IF (CalledByFieldNo = FIELDNO(Quantity)) AND
         (Item."No." <> '') AND (Item."Costing Method" <> Item."Costing Method"::Standard)
      THEN
        UnitCostValue := "Unit Cost" / UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");

      CASE "Entry Type" OF
        "Entry Type"::Purchase:
          PurchPriceCalcMgt.FindItemJnlLinePrice(Rec,CalledByFieldNo);
        "Entry Type"::Sale:
          SalesPriceCalcMgt.FindItemJnlLinePrice(Rec,CalledByFieldNo);
        "Entry Type"::"Positive Adjmt.":
          "Unit Amount" :=
            ROUND(
              ((UnitCostValue - "Overhead Rate") * "Qty. per Unit of Measure") / (1 + "Indirect Cost %" / 100),
              GLSetup."Unit-Amount Rounding Precision");
        "Entry Type"::"Negative Adjmt.":
          "Unit Amount" := UnitCostValue * "Qty. per Unit of Measure";
        "Entry Type"::Transfer:
          "Unit Amount" := 0;
      END;
    END;

    [External]
    PROCEDURE Signed@20(Value@1000 : Decimal) : Decimal;
    BEGIN
      CASE "Entry Type" OF
        "Entry Type"::Purchase,
        "Entry Type"::"Positive Adjmt.",
        "Entry Type"::Output,
        "Entry Type"::"Assembly Output":
          EXIT(Value);
        "Entry Type"::Sale,
        "Entry Type"::"Negative Adjmt.",
        "Entry Type"::Consumption,
        "Entry Type"::Transfer,
        "Entry Type"::"Assembly Consumption":
          EXIT(-Value);
      END;
    END;

    [External]
    PROCEDURE IsInbound@31() : Boolean;
    BEGIN
      EXIT((Signed(Quantity) > 0) OR (Signed("Invoiced Quantity") > 0));
    END;

    [External]
    PROCEDURE OpenItemTrackingLines@6500(IsReclass@1000 : Boolean);
    BEGIN
      ReserveItemJnlLine.CallItemTracking(Rec,IsReclass);
    END;

    LOCAL PROCEDURE PickDimension@48(TableArray@1005 : ARRAY [10] OF Integer;CodeArray@1004 : ARRAY [10] OF Code[20];InheritFromDimSetID@1003 : Integer;InheritFromTableNo@1002 : Integer);
    VAR
      ItemJournalTemplate@1001 : Record 82;
      SourceCode@1000 : Code[10];
    BEGIN
      SourceCode := "Source Code";
      IF SourceCode = '' THEN
        IF ItemJournalTemplate.GET("Journal Template Name") THEN
          SourceCode := ItemJournalTemplate."Source Code";

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableArray,CodeArray,SourceCode,
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",InheritFromDimSetID,InheritFromTableNo);
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");

      IF "Entry Type" = "Entry Type"::Transfer THEN BEGIN
        "New Dimension Set ID" := "Dimension Set ID";
        "New Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        "New Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
      END;
    END;

    LOCAL PROCEDURE CreateCodeArray@55(VAR CodeArray@1003 : ARRAY [10] OF Code[20];No1@1002 : Code[20];No2@1001 : Code[20];No3@1000 : Code[20]);
    BEGIN
      CLEAR(CodeArray);
      CodeArray[1] := No1;
      CodeArray[2] := No2;
      CodeArray[3] := No3;
    END;

    LOCAL PROCEDURE CreateTableArray@56(VAR TableID@1001 : ARRAY [10] OF Integer;Type1@1000 : Integer;Type2@1002 : Integer;Type3@1007 : Integer);
    BEGIN
      CLEAR(TableID);
      TableID[1] := Type1;
      TableID[2] := Type2;
      TableID[3] := Type3;
    END;

    LOCAL PROCEDURE CreateDim@13(Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1007 : Integer;No3@1006 : Code[20]);
    VAR
      TableID@1004 : ARRAY [10] OF Integer;
      No@1005 : ARRAY [10] OF Code[20];
    BEGIN
      CreateTableArray(TableID,Type1,Type2,Type3);
      CreateCodeArray(No,No1,No2,No3);
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);
      PickDimension(TableID,No,0,0);
    END;

    [External]
    PROCEDURE CopyDim@46(DimesionSetID@1000 : Integer);
    VAR
      DimSetEntry@1002 : Record 480;
    BEGIN
      ReadGLSetup;
      "Dimension Set ID" := DimesionSetID;
      DimSetEntry.SETRANGE("Dimension Set ID",DimesionSetID);
      DimSetEntry.SETRANGE("Dimension Code",GLSetup."Global Dimension 1 Code");
      IF DimSetEntry.FINDFIRST THEN
        "Shortcut Dimension 1 Code" := DimSetEntry."Dimension Value Code"
      ELSE
        "Shortcut Dimension 1 Code" := '';
      DimSetEntry.SETRANGE("Dimension Code",GLSetup."Global Dimension 2 Code");
      IF DimSetEntry.FINDFIRST THEN
        "Shortcut Dimension 2 Code" := DimSetEntry."Dimension Value Code"
      ELSE
        "Shortcut Dimension 2 Code" := '';
    END;

    LOCAL PROCEDURE CreateProdDim@25();
    VAR
      ProdOrder@1008 : Record 5405;
      ProdOrderLine@1009 : Record 5406;
      ProdOrderComp@1010 : Record 5407;
      DimSetIDArr@1001 : ARRAY [10] OF Integer;
      i@1000 : Integer;
    BEGIN
      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" := 0;
      IF ("Order Type" <> "Order Type"::Production) OR ("Order No." = '') THEN
        EXIT;
      ProdOrder.GET(ProdOrder.Status::Released,"Order No.");
      i := 1;
      DimSetIDArr[i] := ProdOrder."Dimension Set ID";
      IF "Order Line No." <> 0 THEN BEGIN
        i := i + 1;
        ProdOrderLine.GET(ProdOrderLine.Status::Released,"Order No.","Order Line No.");
        DimSetIDArr[i] := ProdOrderLine."Dimension Set ID";
      END;
      IF "Prod. Order Comp. Line No." <> 0 THEN BEGIN
        i := i + 1;
        ProdOrderComp.GET(ProdOrderLine.Status::Released,"Order No.","Order Line No.","Prod. Order Comp. Line No.");
        DimSetIDArr[i] := ProdOrderComp."Dimension Set ID";
      END;
      "Dimension Set ID" := DimMgt.GetCombinedDimensionSetID(DimSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    LOCAL PROCEDURE CreateAssemblyDim@42();
    VAR
      AssemblyHeader@1008 : Record 900;
      AssemblyLine@1009 : Record 901;
      DimSetIDArr@1001 : ARRAY [10] OF Integer;
      i@1000 : Integer;
    BEGIN
      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" := 0;
      IF ("Order Type" <> "Order Type"::Assembly) OR ("Order No." = '') THEN
        EXIT;
      AssemblyHeader.GET(AssemblyHeader."Document Type"::Order,"Order No.");
      i := 1;
      DimSetIDArr[i] := AssemblyHeader."Dimension Set ID";
      IF "Order Line No." <> 0 THEN BEGIN
        i := i + 1;
        AssemblyLine.GET(AssemblyLine."Document Type"::Order,"Order No.","Order Line No.");
        DimSetIDArr[i] := AssemblyLine."Dimension Set ID";
      END;
      "Dimension Set ID" := DimMgt.GetCombinedDimensionSetID(DimSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    LOCAL PROCEDURE CreateDimWithProdOrderLine@54();
    VAR
      ProdOrderLine@1005 : Record 5406;
      InheritFromDimSetID@1004 : Integer;
      TableID@1001 : ARRAY [10] OF Integer;
      No@1000 : ARRAY [10] OF Code[20];
    BEGIN
      IF "Order Type" = "Order Type"::Production THEN
        IF ProdOrderLine.GET(ProdOrderLine.Status::Released,"Order No.","Order Line No.") THEN
          InheritFromDimSetID := ProdOrderLine."Dimension Set ID";

      CreateTableArray(TableID,DATABASE::"Work Center",DATABASE::"Salesperson/Purchaser",0);
      CreateCodeArray(No,"Work Center No.","Salespers./Purch. Code",'');
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);
      PickDimension(TableID,No,InheritFromDimSetID,DATABASE::Item);
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@9(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE LookupShortcutDimCode@18(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE ShowShortcutDimCode@15(VAR ShortcutDimCode@1000 : ARRAY [8] OF Code[20]);
    BEGIN
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    END;

    [External]
    PROCEDURE ValidateNewShortcutDimCode@19(FieldNumber@1000 : Integer;VAR NewShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,NewShortcutDimCode,"New Dimension Set ID");
    END;

    [External]
    PROCEDURE LookupNewShortcutDimCode@21(FieldNumber@1000 : Integer;VAR NewShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.LookupDimValueCode(FieldNumber,NewShortcutDimCode);
      DimMgt.ValidateShortcutDimValues(FieldNumber,NewShortcutDimCode,"New Dimension Set ID");
    END;

    [External]
    PROCEDURE ShowNewShortcutDimCode@16(VAR NewShortcutDimCode@1000 : ARRAY [8] OF Code[20]);
    BEGIN
      DimMgt.GetShortcutDimensions("New Dimension Set ID",NewShortcutDimCode);
    END;

    LOCAL PROCEDURE InitRevalJnlLine@5800(ItemLedgEntry2@1000 : Record 32);
    VAR
      ItemApplnEntry@1002 : Record 339;
      ValueEntry@1001 : Record 5802;
      CostAmtActual@1003 : Decimal;
    BEGIN
      IF "Value Entry Type" <> "Value Entry Type"::Revaluation THEN
        EXIT;

      ItemLedgEntry2.TESTFIELD("Item No.","Item No.");
      ItemLedgEntry2.TESTFIELD("Completely Invoiced",TRUE);
      ItemLedgEntry2.TESTFIELD(Positive,TRUE);
      ItemApplnEntry.CheckAppliedFromEntryToAdjust(ItemLedgEntry2."Entry No.");

      VALIDATE("Entry Type",ItemLedgEntry2."Entry Type");
      "Posting Date" := ItemLedgEntry2."Posting Date";
      VALIDATE("Unit Amount",0);
      VALIDATE(Quantity,ItemLedgEntry2."Invoiced Quantity");

      ValueEntry.RESET;
      ValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
      ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntry2."Entry No.");
      ValueEntry.SETFILTER("Entry Type",'<>%1',ValueEntry."Entry Type"::Rounding);
      ValueEntry.FIND('-');
      REPEAT
        IF NOT (ValueEntry."Expected Cost" OR ValueEntry."Partial Revaluation") THEN
          CostAmtActual := CostAmtActual + ValueEntry."Cost Amount (Actual)";
      UNTIL ValueEntry.NEXT = 0;

      VALIDATE("Inventory Value (Calculated)",CostAmtActual);
      VALIDATE("Inventory Value (Revalued)",CostAmtActual);

      "Location Code" := ItemLedgEntry2."Location Code";
      "Variant Code" := ItemLedgEntry2."Variant Code";
      "Applies-to Entry" := ItemLedgEntry2."Entry No.";
      CopyDim(ItemLedgEntry2."Dimension Set ID");
    END;

    [External]
    PROCEDURE CopyDocumentFields@129(DocType@1004 : Option;DocNo@1003 : Code[20];ExtDocNo@1002 : Text[35];SourceCode@1001 : Code[10];NoSeriesCode@1000 : Code[20]);
    BEGIN
      "Document Type" := DocType;
      "Document No." := DocNo;
      "External Document No." := ExtDocNo;
      "Source Code" := SourceCode;
      IF NoSeriesCode <> '' THEN
        "Posting No. Series" := NoSeriesCode;
    END;

    [External]
    PROCEDURE CopyFromSalesHeader@58(SalesHeader@1000 : Record 36);
    BEGIN
      "Posting Date" := SalesHeader."Posting Date";
      "Document Date" := SalesHeader."Document Date";
      "Order Date" := SalesHeader."Order Date";
      "Source Posting Group" := SalesHeader."Customer Posting Group";
      "Salespers./Purch. Code" := SalesHeader."Salesperson Code";
      "Reason Code" := SalesHeader."Reason Code";
      "Source Currency Code" := SalesHeader."Currency Code";

      OnAfterCopyItemJnlLineFromSalesHeader(Rec,SalesHeader);
    END;

    [External]
    PROCEDURE CopyFromSalesLine@12(SalesLine@1000 : Record 37);
    BEGIN
      "Item No." := SalesLine."No.";
      Description := SalesLine.Description;
      "Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := SalesLine."Dimension Set ID";
      "Location Code" := SalesLine."Location Code";
      "Bin Code" := SalesLine."Bin Code";
      "Variant Code" := SalesLine."Variant Code";
      "Inventory Posting Group" := SalesLine."Posting Group";
      "Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
      "Transaction Type" := SalesLine."Transaction Type";
      "Transport Method" := SalesLine."Transport Method";
      "Entry/Exit Point" := SalesLine."Exit Point";
      Area := SalesLine.Area;
      "Transaction Specification" := SalesLine."Transaction Specification";
      "Drop Shipment" := SalesLine."Drop Shipment";
      "Entry Type" := "Entry Type"::Sale;
      "Unit of Measure Code" := SalesLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
      "Derived from Blanket Order" := SalesLine."Blanket Order No." <> '';
      "Cross-Reference No." := SalesLine."Cross-Reference No.";
      "Originally Ordered No." := SalesLine."Originally Ordered No.";
      "Originally Ordered Var. Code" := SalesLine."Originally Ordered Var. Code";
      "Out-of-Stock Substitution" := SalesLine."Out-of-Stock Substitution";
      "Item Category Code" := SalesLine."Item Category Code";
      Nonstock := SalesLine.Nonstock;
      "Purchasing Code" := SalesLine."Purchasing Code";
      "Product Group Code" := SalesLine."Product Group Code";
      "Return Reason Code" := SalesLine."Return Reason Code";
      "Planned Delivery Date" := SalesLine."Planned Delivery Date";
      "Document Line No." := SalesLine."Line No.";
      "Unit Cost" := SalesLine."Unit Cost (LCY)";
      "Unit Cost (ACY)" := SalesLine."Unit Cost";
      "Value Entry Type" := "Value Entry Type"::"Direct Cost";
      "Source Type" := "Source Type"::Customer;
      "Source No." := SalesLine."Sell-to Customer No.";
      "Invoice-to Source No." := SalesLine."Bill-to Customer No.";

      OnAfterCopyItemJnlLineFromSalesLine(Rec,SalesLine);
    END;

    [External]
    PROCEDURE CopyFromPurchHeader@57(PurchHeader@1000 : Record 38);
    BEGIN
      "Posting Date" := PurchHeader."Posting Date";
      "Document Date" := PurchHeader."Document Date";
      "Source Posting Group" := PurchHeader."Vendor Posting Group";
      "Salespers./Purch. Code" := PurchHeader."Purchaser Code";
      "Country/Region Code" := PurchHeader."Buy-from Country/Region Code";
      "Reason Code" := PurchHeader."Reason Code";
      "Source Currency Code" := PurchHeader."Currency Code";

      OnAfterCopyItemJnlLineFromPurchHeader(Rec,PurchHeader);
    END;

    [External]
    PROCEDURE CopyFromPurchLine@160(PurchLine@1000 : Record 39);
    BEGIN
      "Item No." := PurchLine."No.";
      Description := PurchLine.Description;
      "Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := PurchLine."Dimension Set ID";
      "Location Code" := PurchLine."Location Code";
      "Bin Code" := PurchLine."Bin Code";
      "Variant Code" := PurchLine."Variant Code";
      "Item Category Code" := PurchLine."Item Category Code";
      "Product Group Code" := PurchLine."Product Group Code";
      "Inventory Posting Group" := PurchLine."Posting Group";
      "Gen. Bus. Posting Group" := PurchLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
      "Job No." := PurchLine."Job No.";
      "Job Task No." := PurchLine."Job Task No.";
      IF "Job No." <> '' THEN
        "Job Purchase" := TRUE;
      "Applies-to Entry" := PurchLine."Appl.-to Item Entry";
      "Transaction Type" := PurchLine."Transaction Type";
      "Transport Method" := PurchLine."Transport Method";
      "Entry/Exit Point" := PurchLine."Entry Point";
      Area := PurchLine.Area;
      "Transaction Specification" := PurchLine."Transaction Specification";
      "Drop Shipment" := PurchLine."Drop Shipment";
      "Entry Type" := "Entry Type"::Purchase;
      IF PurchLine."Prod. Order No." <> '' THEN BEGIN
        "Order Type" := "Order Type"::Production;
        "Order No." := PurchLine."Prod. Order No.";
        "Order Line No." := PurchLine."Prod. Order Line No.";
      END;
      "Unit of Measure Code" := PurchLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := PurchLine."Qty. per Unit of Measure";
      "Cross-Reference No." := PurchLine."Cross-Reference No.";
      "Document Line No." := PurchLine."Line No.";
      "Unit Cost" := PurchLine."Unit Cost (LCY)";
      "Unit Cost (ACY)" := PurchLine."Unit Cost";
      "Value Entry Type" := "Value Entry Type"::"Direct Cost";
      "Source Type" := "Source Type"::Vendor;
      "Source No." := PurchLine."Buy-from Vendor No.";
      "Invoice-to Source No." := PurchLine."Pay-to Vendor No.";
      "Purchasing Code" := PurchLine."Purchasing Code";
      "Indirect Cost %" := PurchLine."Indirect Cost %";
      "Overhead Rate" := PurchLine."Overhead Rate";
      "Return Reason Code" := PurchLine."Return Reason Code";

      OnAfterCopyItemJnlLineFromPurchLine(Rec,PurchLine);
    END;

    [External]
    PROCEDURE CopyFromServHeader@59(ServiceHeader@1000 : Record 5900);
    BEGIN
      "Document Date" := ServiceHeader."Document Date";
      "Order Date" := ServiceHeader."Order Date";
      "Source Posting Group" := ServiceHeader."Customer Posting Group";
      "Salespers./Purch. Code" := ServiceHeader."Salesperson Code";
      "Country/Region Code" := ServiceHeader."VAT Country/Region Code";
      "Reason Code" := ServiceHeader."Reason Code";
      "Source Type" := "Source Type"::Customer;
      "Source No." := ServiceHeader."Customer No.";

      OnAfterCopyItemJnlLineFromServHeader(Rec,ServiceHeader);
    END;

    [External]
    PROCEDURE CopyFromServLine@17(ServiceLine@1000 : Record 5902);
    BEGIN
      "Item No." := ServiceLine."No.";
      "Posting Date" := ServiceLine."Posting Date";
      Description := ServiceLine.Description;
      "Shortcut Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := ServiceLine."Dimension Set ID";
      "Location Code" := ServiceLine."Location Code";
      "Bin Code" := ServiceLine."Bin Code";
      "Variant Code" := ServiceLine."Variant Code";
      "Inventory Posting Group" := ServiceLine."Posting Group";
      "Gen. Bus. Posting Group" := ServiceLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := ServiceLine."Gen. Prod. Posting Group";
      "Applies-to Entry" := ServiceLine."Appl.-to Item Entry";
      "Transaction Type" := ServiceLine."Transaction Type";
      "Transport Method" := ServiceLine."Transport Method";
      "Entry/Exit Point" := ServiceLine."Exit Point";
      Area := ServiceLine.Area;
      "Transaction Specification" := ServiceLine."Transaction Specification";
      "Entry Type" := "Entry Type"::Sale;
      "Unit of Measure Code" := ServiceLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := ServiceLine."Qty. per Unit of Measure";
      "Derived from Blanket Order" := FALSE;
      "Item Category Code" := ServiceLine."Item Category Code";
      Nonstock := ServiceLine.Nonstock;
      "Product Group Code" := ServiceLine."Product Group Code";
      "Return Reason Code" := ServiceLine."Return Reason Code";
      "Order Type" := "Order Type"::Service;
      "Order No." := ServiceLine."Document No.";
      "Order Line No." := ServiceLine."Line No.";
      "Job No." := ServiceLine."Job No.";
      "Job Task No." := ServiceLine."Job Task No.";

      OnAfterCopyItemJnlLineFromServLine(Rec,ServiceLine);
    END;

    [External]
    PROCEDURE CopyFromServShptHeader@53(ServShptHeader@1000 : Record 5990);
    BEGIN
      "Document Date" := ServShptHeader."Document Date";
      "Order Date" := ServShptHeader."Order Date";
      "Country/Region Code" := ServShptHeader."VAT Country/Region Code";
      "Source Posting Group" := ServShptHeader."Customer Posting Group";
      "Salespers./Purch. Code" := ServShptHeader."Salesperson Code";
      "Reason Code" := ServShptHeader."Reason Code";

      OnAfterCopyItemJnlLineFromServShptHeader(Rec,ServShptHeader);
    END;

    [External]
    PROCEDURE CopyFromServShptLine@51(ServShptLine@1000 : Record 5991);
    BEGIN
      "Item No." := ServShptLine."No.";
      Description := ServShptLine.Description;
      "Gen. Bus. Posting Group" := ServShptLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := ServShptLine."Gen. Prod. Posting Group";
      "Inventory Posting Group" := ServShptLine."Posting Group";
      "Location Code" := ServShptLine."Location Code";
      "Unit of Measure Code" := ServShptLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := ServShptLine."Qty. per Unit of Measure";
      "Variant Code" := ServShptLine."Variant Code";
      "Bin Code" := ServShptLine."Bin Code";
      "Shortcut Dimension 1 Code" := ServShptLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := ServShptLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := ServShptLine."Dimension Set ID";
      "Entry/Exit Point" := ServShptLine."Exit Point";
      "Value Entry Type" := ItemJnlLine."Value Entry Type"::"Direct Cost";
      "Transaction Type" := ServShptLine."Transaction Type";
      "Transport Method" := ServShptLine."Transport Method";
      Area := ServShptLine.Area;
      "Transaction Specification" := ServShptLine."Transaction Specification";
      "Qty. per Unit of Measure" := ServShptLine."Qty. per Unit of Measure";
      "Item Category Code" := ServShptLine."Item Category Code";
      Nonstock := ServShptLine.Nonstock;
      "Product Group Code" := ServShptLine."Product Group Code";
      "Return Reason Code" := ServShptLine."Return Reason Code";

      OnAfterCopyItemJnlLineFromServShptLine(Rec,ServShptLine);
    END;

    [External]
    PROCEDURE CopyFromServShptLineUndo@60(ServShptLine@1000 : Record 5991);
    BEGIN
      "Item No." := ServShptLine."No.";
      "Posting Date" := ServShptLine."Posting Date";
      "Order Date" := ServShptLine."Order Date";
      "Inventory Posting Group" := ServShptLine."Posting Group";
      "Gen. Bus. Posting Group" := ServShptLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := ServShptLine."Gen. Prod. Posting Group";
      "Location Code" := ServShptLine."Location Code";
      "Variant Code" := ServShptLine."Variant Code";
      "Bin Code" := ServShptLine."Bin Code";
      "Entry/Exit Point" := ServShptLine."Exit Point";
      "Shortcut Dimension 1 Code" := ServShptLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := ServShptLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := ServShptLine."Dimension Set ID";
      "Value Entry Type" := "Value Entry Type"::"Direct Cost";
      "Item No." := ServShptLine."No.";
      Description := ServShptLine.Description;
      "Location Code" := ServShptLine."Location Code";
      "Variant Code" := ServShptLine."Variant Code";
      "Transaction Type" := ServShptLine."Transaction Type";
      "Transport Method" := ServShptLine."Transport Method";
      Area := ServShptLine.Area;
      "Transaction Specification" := ServShptLine."Transaction Specification";
      "Unit of Measure Code" := ServShptLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := ServShptLine."Qty. per Unit of Measure";
      "Derived from Blanket Order" := FALSE;
      "Item Category Code" := ServShptLine."Item Category Code";
      Nonstock := ServShptLine.Nonstock;
      "Product Group Code" := ServShptLine."Product Group Code";
      "Return Reason Code" := ServShptLine."Return Reason Code";

      OnAfterCopyItemJnlLineFromServShptLineUndo(Rec,ServShptLine);
    END;

    [External]
    PROCEDURE CopyFromJobJnlLine@76(JobJnlLine@1000 : Record 210);
    BEGIN
      "Line No." := JobJnlLine."Line No.";
      "Item No." := JobJnlLine."No.";
      "Posting Date" := JobJnlLine."Posting Date";
      "Document Date" := JobJnlLine."Document Date";
      "Document No." := JobJnlLine."Document No.";
      "External Document No." := JobJnlLine."External Document No.";
      Description := JobJnlLine.Description;
      "Location Code" := JobJnlLine."Location Code";
      "Applies-to Entry" := JobJnlLine."Applies-to Entry";
      "Applies-from Entry" := JobJnlLine."Applies-from Entry";
      "Shortcut Dimension 1 Code" := JobJnlLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := JobJnlLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := JobJnlLine."Dimension Set ID";
      "Country/Region Code" := JobJnlLine."Country/Region Code";
      "Entry Type" := "Entry Type"::"Negative Adjmt.";
      "Source Code" := JobJnlLine."Source Code";
      "Gen. Bus. Posting Group" := JobJnlLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := JobJnlLine."Gen. Prod. Posting Group";
      "Posting No. Series" := JobJnlLine."Posting No. Series";
      "Variant Code" := JobJnlLine."Variant Code";
      "Bin Code" := JobJnlLine."Bin Code";
      "Unit of Measure Code" := JobJnlLine."Unit of Measure Code";
      "Reason Code" := JobJnlLine."Reason Code";
      "Transaction Type" := JobJnlLine."Transaction Type";
      "Transport Method" := JobJnlLine."Transport Method";
      "Entry/Exit Point" := JobJnlLine."Entry/Exit Point";
      Area := JobJnlLine.Area;
      "Transaction Specification" := JobJnlLine."Transaction Specification";
      "Invoiced Quantity" := JobJnlLine.Quantity;
      "Invoiced Qty. (Base)" := JobJnlLine."Quantity (Base)";
      "Source Currency Code" := JobJnlLine."Source Currency Code";
      Quantity := JobJnlLine.Quantity;
      "Quantity (Base)" := JobJnlLine."Quantity (Base)";
      "Qty. per Unit of Measure" := JobJnlLine."Qty. per Unit of Measure";
      "Unit Cost" := JobJnlLine."Unit Cost (LCY)";
      "Unit Cost (ACY)" := JobJnlLine."Unit Cost";
      Amount := JobJnlLine."Total Cost (LCY)";
      "Amount (ACY)" := JobJnlLine."Total Cost";
      "Value Entry Type" := "Value Entry Type"::"Direct Cost";
      "Job No." := JobJnlLine."Job No.";
      "Job Task No." := JobJnlLine."Job Task No.";

      OnAfterCopyItemJnlLineFromJobJnlLine(Rec,JobJnlLine);
    END;

    LOCAL PROCEDURE ReadGLSetup@5801();
    BEGIN
      IF NOT GLSetupRead THEN BEGIN
        GLSetup.GET;
        GLSetupRead := TRUE;
      END;
    END;

    LOCAL PROCEDURE RetrieveCosts@5803();
    VAR
      StockkeepingUnit@1000 : Record 5700;
    BEGIN
      IF ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") OR
         ("Item Charge No." <> '')
      THEN
        EXIT;

      ReadGLSetup;
      GetItem;
      IF StockkeepingUnit.GET("Location Code","Item No.","Variant Code") THEN
        UnitCost := StockkeepingUnit."Unit Cost"
      ELSE
        UnitCost := Item."Unit Cost";

      IF "Entry Type" = "Entry Type"::Transfer THEN
        UnitCost := 0
      ELSE
        IF Item."Costing Method" <> Item."Costing Method"::Standard THEN
          UnitCost := ROUND(UnitCost,GLSetup."Unit-Amount Rounding Precision");
    END;

    LOCAL PROCEDURE CalcUnitCost@5804(ItemLedgEntry@1000 : Record 32) : Decimal;
    VAR
      ValueEntry@1001 : Record 5802;
      UnitCost@1002 : Decimal;
    BEGIN
      WITH ValueEntry DO BEGIN
        RESET;
        SETCURRENTKEY("Item Ledger Entry No.");
        SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
        CALCSUMS("Cost Amount (Expected)","Cost Amount (Actual)");
        UnitCost :=
          ("Cost Amount (Expected)" + "Cost Amount (Actual)") / ItemLedgEntry.Quantity;
      END;
      EXIT(ABS(UnitCost * "Qty. per Unit of Measure"));
    END;

    LOCAL PROCEDURE ClearSingleAndRolledUpCosts@4();
    BEGIN
      "Single-Level Material Cost" := "Unit Cost (Revalued)";
      "Single-Level Capacity Cost" := 0;
      "Single-Level Subcontrd. Cost" := 0;
      "Single-Level Cap. Ovhd Cost" := 0;
      "Single-Level Mfg. Ovhd Cost" := 0;
      "Rolled-up Material Cost" := "Unit Cost (Revalued)";
      "Rolled-up Capacity Cost" := 0;
      "Rolled-up Subcontracted Cost" := 0;
      "Rolled-up Mfg. Ovhd Cost" := 0;
      "Rolled-up Cap. Overhead Cost" := 0;
    END;

    LOCAL PROCEDURE GetMfgSetup@7();
    BEGIN
      IF NOT MfgSetupRead THEN
        MfgSetup.GET;
      MfgSetupRead := TRUE;
    END;

    LOCAL PROCEDURE GetProdOrderRtngLine@27(VAR ProdOrderRtngLine@1000 : Record 5409);
    BEGIN
      TESTFIELD("Order Type","Order Type"::Production);
      TESTFIELD("Order No.");
      TESTFIELD("Operation No.");

      ProdOrderRtngLine.GET(
        ProdOrderRtngLine.Status::Released,
        "Order No.","Routing Reference No.","Routing No.","Operation No.");
    END;

    [External]
    PROCEDURE OnlyStopTime@24() : Boolean;
    BEGIN
      EXIT(("Setup Time" = 0) AND ("Run Time" = 0) AND ("Stop Time" <> 0));
    END;

    [External]
    PROCEDURE OutputValuePosting@29() : Boolean;
    BEGIN
      EXIT(TimeIsEmpty AND ("Invoiced Quantity" <> 0) AND NOT Subcontracting);
    END;

    [External]
    PROCEDURE TimeIsEmpty@26() : Boolean;
    BEGIN
      EXIT(("Setup Time" = 0) AND ("Run Time" = 0) AND ("Stop Time" = 0));
    END;

    [External]
    PROCEDURE RowID1@44() : Text[250];
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;
    BEGIN
      EXIT(
        ItemTrackingMgt.ComposeRowID(DATABASE::"Item Journal Line","Entry Type",
          "Journal Template Name","Journal Batch Name",0,"Line No."));
    END;

    LOCAL PROCEDURE GetLocation@7300(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        CLEAR(Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE GetBin@36(LocationCode@1000 : Code[10];BinCode@1001 : Code[20]);
    BEGIN
      IF BinCode = '' THEN
        CLEAR(Bin)
      ELSE
        IF (Bin.Code <> BinCode) OR (Bin."Location Code" <> LocationCode) THEN
          Bin.GET(LocationCode,BinCode);
    END;

    [External]
    PROCEDURE ItemPosting@33() : Boolean;
    VAR
      ProdOrderRtngLine@1000 : Record 5409;
    BEGIN
      IF ("Entry Type" = "Entry Type"::Output) AND
         ("Output Quantity" <> 0) AND
         ("Operation No." <> '')
      THEN BEGIN
        ProdOrderRtngLine.GET(
          ProdOrderRtngLine.Status::Released,
          "Order No.",
          "Routing Reference No.",
          "Routing No.",
          "Operation No.");
        EXIT(ProdOrderRtngLine."Next Operation No." = '');
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckPlanningAssignment@34();
    BEGIN
      IF ("Quantity (Base)" <> 0) AND ("Item No." <> '') AND ("Posting Date" <> 0D) AND
         ("Entry Type" IN ["Entry Type"::"Negative Adjmt.","Entry Type"::"Positive Adjmt.","Entry Type"::Transfer])
      THEN BEGIN
        IF ("Entry Type" = "Entry Type"::Transfer) AND ("Location Code" = "New Location Code") THEN
          EXIT;

        ReserveItemJnlLine.AssignForPlanning(Rec);
      END;
    END;

    [External]
    PROCEDURE LastOutputOperation@35(ItemJnlLine@1000 : Record 83) : Boolean;
    VAR
      ProdOrderRtngLine@1002 : Record 5409;
      ItemJnlPostLine@1001 : Codeunit 22;
      Operation@1003 : Boolean;
    BEGIN
      WITH ItemJnlLine DO BEGIN
        IF "Operation No." <> '' THEN BEGIN
          TESTFIELD("Routing No.");
          IF NOT ProdOrderRtngLine.GET(
               ProdOrderRtngLine.Status::Released,"Order No.",
               "Routing Reference No.","Routing No.","Operation No.")
          THEN
            ProdOrderRtngLine.GET(
              ProdOrderRtngLine.Status::Finished,"Order No.",
              "Routing Reference No.","Routing No.","Operation No.");
          IF Finished THEN
            ProdOrderRtngLine."Routing Status" := ProdOrderRtngLine."Routing Status"::Finished
          ELSE
            ProdOrderRtngLine."Routing Status" := ProdOrderRtngLine."Routing Status"::"In Progress";
          Operation := NOT ItemJnlPostLine.NextOperationExist(ProdOrderRtngLine);
        END ELSE
          Operation := TRUE;
      END;
      EXIT(Operation);
    END;

    [External]
    PROCEDURE LookupItemNo@37();
    VAR
      ItemList@1000 : Page 31;
    BEGIN
      CASE "Entry Type" OF
        "Entry Type"::Consumption:
          LookupProdOrderComp;
        "Entry Type"::Output:
          LookupProdOrderLine;
        ELSE BEGIN
          ItemList.LOOKUPMODE := TRUE;
          IF ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ItemList.GETRECORD(Item);
            VALIDATE("Item No.",Item."No.");
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE LookupProdOrderLine@32();
    VAR
      ProdOrderLine@1004 : Record 5406;
      ProdOrderLineList@1001 : Page 5406;
    BEGIN
      ProdOrderLine.SetFilterByReleasedOrderNo("Order No.");
      ProdOrderLine.Status := ProdOrderLine.Status::Released;
      ProdOrderLine."Prod. Order No." := "Order No.";
      ProdOrderLine."Line No." := "Order Line No.";
      ProdOrderLine."Item No." := "Item No.";

      ProdOrderLineList.LOOKUPMODE(TRUE);
      ProdOrderLineList.SETTABLEVIEW(ProdOrderLine);
      ProdOrderLineList.SETRECORD(ProdOrderLine);

      IF ProdOrderLineList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        ProdOrderLineList.GETRECORD(ProdOrderLine);
        VALIDATE("Item No.",ProdOrderLine."Item No.");
        IF "Order Line No." <> ProdOrderLine."Line No." THEN
          VALIDATE("Order Line No.",ProdOrderLine."Line No.");
      END;
    END;

    LOCAL PROCEDURE LookupProdOrderComp@11();
    VAR
      ProdOrderComp@1004 : Record 5407;
      ProdOrderCompLineList@1001 : Page 5407;
    BEGIN
      ProdOrderComp.SetFilterByReleasedOrderNo("Order No.");
      IF "Order Line No." <> 0 THEN
        ProdOrderComp.SETRANGE("Prod. Order Line No.","Order Line No.");
      ProdOrderComp.Status := ProdOrderComp.Status::Released;
      ProdOrderComp."Prod. Order No." := "Order No.";
      ProdOrderComp."Prod. Order Line No." := "Order Line No.";
      ProdOrderComp."Line No." := "Prod. Order Comp. Line No.";
      ProdOrderComp."Item No." := "Item No.";

      ProdOrderCompLineList.LOOKUPMODE(TRUE);
      ProdOrderCompLineList.SETTABLEVIEW(ProdOrderComp);
      ProdOrderCompLineList.SETRECORD(ProdOrderComp);

      IF ProdOrderCompLineList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        ProdOrderCompLineList.GETRECORD(ProdOrderComp);
        IF "Prod. Order Comp. Line No." <> ProdOrderComp."Line No." THEN BEGIN
          VALIDATE("Item No.",ProdOrderComp."Item No.");
          VALIDATE("Prod. Order Comp. Line No.",ProdOrderComp."Line No.");
        END;
      END;
    END;

    [Internal]
    PROCEDURE RecalculateUnitAmount@38();
    VAR
      ItemJnlLine1@1000 : Record 83;
    BEGIN
      GetItem;

      IF ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") OR
         ("Item Charge No." <> '')
      THEN BEGIN
        "Indirect Cost %" := 0;
        "Overhead Rate" := 0;
      END ELSE BEGIN
        "Indirect Cost %" := Item."Indirect Cost %";
        "Overhead Rate" := Item."Overhead Rate";
      END;

      "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
      GetUnitAmount(FIELDNO("Unit of Measure Code"));

      ReadGLSetup;

      UpdateAmount;

      CASE "Entry Type" OF
        "Entry Type"::Purchase:
          BEGIN
            ItemJnlLine1.COPY(Rec);
            PurchPriceCalcMgt.FindItemJnlLinePrice(ItemJnlLine1,FIELDNO("Unit of Measure Code"));
            "Unit Cost" := ROUND(ItemJnlLine1."Unit Amount" * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
          END;
        "Entry Type"::Sale:
          "Unit Cost" := ROUND(UnitCost * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
        "Entry Type"::"Positive Adjmt.":
          "Unit Cost" :=
            ROUND(
              "Unit Amount" * (1 + "Indirect Cost %" / 100),GLSetup."Unit-Amount Rounding Precision") +
            "Overhead Rate" * "Qty. per Unit of Measure";
        "Entry Type"::"Negative Adjmt.":
          IF NOT "Phys. Inventory" THEN
            "Unit Cost" := UnitCost * "Qty. per Unit of Measure";
      END;

      IF "Entry Type" IN ["Entry Type"::Purchase,"Entry Type"::"Positive Adjmt."] THEN BEGIN
        IF Item."Costing Method" = Item."Costing Method"::Standard THEN
          "Unit Cost" := ROUND(UnitCost * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
      END;
    END;

    [External]
    PROCEDURE IsReclass@40(ItemJnlLine@1000 : Record 83) : Boolean;
    BEGIN
      IF (ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Transfer) AND
         ((ItemJnlLine."Order Type" <> ItemJnlLine."Order Type"::Transfer) OR (ItemJnlLine."Order No." = ''))
      THEN
        EXIT(TRUE);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE CheckWhse@39(LocationCode@1000 : Code[20];VAR QtyToPost@1002 : Decimal);
    VAR
      Location@1001 : Record 14;
    BEGIN
      Location.GET(LocationCode);
      IF Location."Require Put-away" AND
         (NOT Location."Directed Put-away and Pick") AND
         (NOT Location."Require Receive")
      THEN
        QtyToPost := 0;
    END;

    [External]
    PROCEDURE ShowDimensions@41();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE ShowReclasDimensions@30();
    BEGIN
      DimMgt.EditReclasDimensionSet2(
        "Dimension Set ID","New Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."),
        "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","New Shortcut Dimension 1 Code","New Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE PostingItemJnlFromProduction@43(Print@1000 : Boolean);
    VAR
      ProductionOrder@1001 : Record 5405;
    BEGIN
      IF ("Order Type" = "Order Type"::Production) AND ("Order No." <> '') THEN
        ProductionOrder.GET(ProductionOrder.Status::Released,"Order No.");
      IF Print THEN
        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post+Print",Rec)
      ELSE
        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post",Rec);
    END;

    [External]
    PROCEDURE IsAssemblyResourceConsumpLine@87() : Boolean;
    BEGIN
      EXIT(("Entry Type" = "Entry Type"::"Assembly Output") AND (Type = Type::Resource));
    END;

    [External]
    PROCEDURE IsAssemblyOutputLine@89() : Boolean;
    BEGIN
      EXIT(("Entry Type" = "Entry Type"::"Assembly Output") AND (Type = Type::" "));
    END;

    [External]
    PROCEDURE IsATOCorrection@10() : Boolean;
    VAR
      ItemLedgEntry@1000 : Record 32;
      PostedATOLink@1001 : Record 914;
    BEGIN
      IF NOT Correction THEN
        EXIT(FALSE);
      IF "Entry Type" <> "Entry Type"::Sale THEN
        EXIT(FALSE);
      IF NOT ItemLedgEntry.GET("Applies-to Entry") THEN
        EXIT(FALSE);
      IF ItemLedgEntry."Entry Type" <> ItemLedgEntry."Entry Type"::Sale THEN
        EXIT(FALSE);
      PostedATOLink.SETCURRENTKEY("Document Type","Document No.","Document Line No.");
      PostedATOLink.SETRANGE("Document Type",PostedATOLink."Document Type"::"Sales Shipment");
      PostedATOLink.SETRANGE("Document No.",ItemLedgEntry."Document No.");
      PostedATOLink.SETRANGE("Document Line No.",ItemLedgEntry."Document Line No.");
      EXIT(NOT PostedATOLink.ISEMPTY);
    END;

    LOCAL PROCEDURE RevaluationPerEntryAllowed@45(ItemNo@1000 : Code[20]) : Boolean;
    VAR
      ValueEntry@1001 : Record 5802;
    BEGIN
      GetItem;
      IF Item."Costing Method" <> Item."Costing Method"::Average THEN
        EXIT(TRUE);

      ValueEntry.SETRANGE("Item No.",ItemNo);
      ValueEntry.SETRANGE("Entry Type",ValueEntry."Entry Type"::Revaluation);
      ValueEntry.SETRANGE("Partial Revaluation",TRUE);
      EXIT(ValueEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE ClearTracking@63();
    BEGIN
      "Serial No." := '';
      "Lot No." := '';
    END;

    [External]
    PROCEDURE CopyTrackingFromSpec@62(TrackingSpecification@1000 : Record 336);
    BEGIN
      "Serial No." := TrackingSpecification."Serial No.";
      "Lot No." := TrackingSpecification."Lot No.";
    END;

    [External]
    PROCEDURE TrackingExists@47() : Boolean;
    BEGIN
      EXIT(("Serial No." <> '') OR ("Lot No." <> ''));
    END;

    [External]
    PROCEDURE TestItemFields@61(ItemNo@1000 : Code[20];VariantCode@1001 : Code[10];LocationCode@1002 : Code[10]);
    BEGIN
      TESTFIELD("Item No.",ItemNo);
      TESTFIELD("Variant Code",VariantCode);
      TESTFIELD("Location Code",LocationCode);
    END;

    [External]
    PROCEDURE IsPurchaseReturn@49() : Boolean;
    BEGIN
      EXIT(
        ("Document Type" IN ["Document Type"::"Purchase Credit Memo",
                             "Document Type"::"Purchase Return Shipment",
                             "Document Type"::"Purchase Invoice",
                             "Document Type"::"Purchase Receipt"]) AND
        (Quantity < 0));
    END;

    [External]
    PROCEDURE IsOpenedFromBatch@50() : Boolean;
    VAR
      ItemJournalBatch@1002 : Record 233;
      TemplateFilter@1001 : Text;
      BatchFilter@1000 : Text;
    BEGIN
      BatchFilter := GETFILTER("Journal Batch Name");
      IF BatchFilter <> '' THEN BEGIN
        TemplateFilter := GETFILTER("Journal Template Name");
        IF TemplateFilter <> '' THEN
          ItemJournalBatch.SETFILTER("Journal Template Name",TemplateFilter);
        ItemJournalBatch.SETFILTER(Name,BatchFilter);
        ItemJournalBatch.FINDFIRST;
      END;

      EXIT((("Journal Batch Name" <> '') AND ("Journal Template Name" = '')) OR (BatchFilter <> ''));
    END;

    [External]
    PROCEDURE SubcontractingWorkCenterUsed@52() : Boolean;
    VAR
      WorkCenter@1000 : Record 99000754;
    BEGIN
      IF Type = Type::"Work Center" THEN
        IF WorkCenter.GET("Work Center No.") THEN
          EXIT(WorkCenter."Subcontractor No." <> '');

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE CheckItemJournalLineRestriction@161();
    BEGIN
      OnCheckItemJournalLinePostRestrictions;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterSetupNewLine@71(VAR ItemJournalLine@1000 : Record 83;VAR LastItemJournalLine@1001 : Record 83);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyItemJnlLineFromSalesHeader@64(VAR ItemJnlLine@1001 : Record 83;SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyItemJnlLineFromSalesLine@65(VAR ItemJnlLine@1001 : Record 83;SalesLine@1000 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyItemJnlLineFromPurchHeader@66(VAR ItemJnlLine@1001 : Record 83;PurchHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyItemJnlLineFromPurchLine@67(VAR ItemJnlLine@1001 : Record 83;PurchLine@1000 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyItemJnlLineFromServHeader@69(VAR ItemJnlLine@1001 : Record 83;ServHeader@1000 : Record 5900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyItemJnlLineFromServLine@70(VAR ItemJnlLine@1001 : Record 83;ServLine@1000 : Record 5902);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyItemJnlLineFromServShptHeader@72(VAR ItemJnlLine@1001 : Record 83;ServShptHeader@1000 : Record 5990);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyItemJnlLineFromServShptLine@73(VAR ItemJnlLine@1001 : Record 83;ServShptLine@1000 : Record 5991);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyItemJnlLineFromServShptLineUndo@74(VAR ItemJnlLine@1001 : Record 83;ServShptLine@1000 : Record 5991);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyItemJnlLineFromJobJnlLine@75(VAR ItemJournalLine@1001 : Record 83;JobJournalLine@1000 : Record 210);
    BEGIN
    END;

    [Integration(DEFAULT,TRUE)]
    LOCAL PROCEDURE OnAfterOnValidateItemNoAssignByEntryType@68(VAR ItemJournalLine@1000 : Record 83;VAR Item@1001 : Record 27);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@164(VAR ItemJournalLine@1000 : Record 83;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateAmount@78(VAR ItemJournalLine@1000 : Record 83);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeVerifyReservedQty@77(VAR ItemJournalLine@1000 : Record 83;xItemJournalLine@1001 : Record 83;CalledByFieldNo@1002 : Integer);
    BEGIN
    END;

    LOCAL PROCEDURE ConfirmOutputOnFinishedOperation@79();
    VAR
      ProdOrderRtngLine@1000 : Record 5409;
    BEGIN
      IF ("Entry Type" <> "Entry Type"::Output) OR ("Output Quantity" = 0) THEN
        EXIT;

      IF NOT ProdOrderRtngLine.GET(
           ProdOrderRtngLine.Status::Released,"Order No.","Routing Reference No.","Routing No.","Operation No.")
      THEN
        EXIT;

      IF ProdOrderRtngLine."Routing Status" <> ProdOrderRtngLine."Routing Status"::Finished THEN
        EXIT;

      IF NOT CONFIRM(FinishedOutputQst) THEN
        ERROR(UpdateInterruptedErr);
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnCheckItemJournalLinePostRestrictions@90();
    BEGIN
    END;

    BEGIN
    END.
  }
}

