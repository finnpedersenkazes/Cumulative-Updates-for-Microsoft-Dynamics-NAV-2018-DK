OBJECT Table 246 Requisition Line
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    Permissions=TableData 5410=imd;
    DataCaptionFields=Journal Batch Name,Line No.;
    OnInsert=VAR
               Rec2@1000 : Record 246;
             BEGIN
               IF CURRENTKEY <> Rec2.CURRENTKEY THEN BEGIN
                 Rec2 := Rec;
                 Rec2.SETRECFILTER;
                 Rec2.SETRANGE("Line No.");
                 IF Rec2.FINDLAST THEN
                   "Line No." := Rec2."Line No." + 10000;
               END;

               ReserveReqLine.VerifyQuantity(Rec,xRec);

               ReqWkshTmpl.GET("Worksheet Template Name");
               ReqWkshName.GET("Worksheet Template Name","Journal Batch Name");

               ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
               ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
             END;

    OnModify=BEGIN
               ReserveReqLine.VerifyChange(Rec,xRec);
             END;

    OnDelete=BEGIN
               ReqLine.RESET;
               ReqLine.GET("Worksheet Template Name","Journal Batch Name","Line No.");
               WHILE (ReqLine.NEXT <> 0) AND (ReqLine.Level > Level) DO
                 ReqLine.DELETE(TRUE);

               ReserveReqLine.DeleteLine(Rec);

               CALCFIELDS("Reserved Qty. (Base)");
               TESTFIELD("Reserved Qty. (Base)",0);

               DeleteRelations;
             END;

    OnRename=BEGIN
               ERROR(Text004,TABLECAPTION);
             END;

    CaptionML=[DAN=Rekvisitionslinje;
               ENU=Requisition Line];
    LookupPageID=Page517;
    DrillDownPageID=Page517;
  }
  FIELDS
  {
    { 1   ;   ;Worksheet Template Name;Code10     ;TableRelation="Req. Wksh. Template";
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Worksheet Template Name] }
    { 2   ;   ;Journal Batch Name  ;Code10        ;TableRelation="Requisition Wksh. Name".Name WHERE (Worksheet Template Name=FIELD(Worksheet Template Name));
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 3   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 4   ;   ;Type                ;Option        ;OnValidate=VAR
                                                                NewType@1000 : Option;
                                                              BEGIN
                                                                IF Type <> xRec.Type THEN BEGIN
                                                                  NewType := Type;

                                                                  DeleteRelations;
                                                                  "Dimension Set ID" := 0;
                                                                  "No." := '';
                                                                  "Variant Code" := '';
                                                                  "Location Code" := '';
                                                                  "Prod. Order No." := '';
                                                                  ReserveReqLine.VerifyChange(Rec,xRec);
                                                                  AddOnIntegrMgt.ResetReqLineFields(Rec);
                                                                  INIT;
                                                                  Type := NewType;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Vare";
                                                                    ENU=" ,G/L Account,Item"];
                                                   OptionString=[ ,G/L Account,Item] }
    { 5   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Type=CONST(Item)) Item WHERE (Type=CONST(Inventory));
                                                   OnValidate=VAR
                                                                TempSKU@1000 : TEMPORARY Record 5700;
                                                              BEGIN
                                                                CheckActionMessageNew;
                                                                ReserveReqLine.VerifyChange(Rec,xRec);
                                                                DeleteRelations;

                                                                IF "No." = '' THEN BEGIN
                                                                  CreateDim(
                                                                    DimMgt.TypeToTableID3(Type),
                                                                    "No.",DATABASE::Vendor,"Vendor No.");
                                                                  INIT;
                                                                  Type := xRec.Type;
                                                                  EXIT;
                                                                END;

                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  "Variant Code" := '';
                                                                  "Prod. Order No." := '';
                                                                  AddOnIntegrMgt.ResetReqLineFields(Rec);
                                                                END;

                                                                TESTFIELD(Type);
                                                                CASE Type OF
                                                                  Type::"G/L Account":
                                                                    BEGIN
                                                                      GLAcc.GET("No.");
                                                                      GLAcc.CheckGLAcc;
                                                                      GLAcc.TESTFIELD("Direct Posting",TRUE);
                                                                      Description := GLAcc.Name;
                                                                    END;
                                                                  Type::Item:
                                                                    BEGIN
                                                                      GetItem;
                                                                      VALIDATE("Vendor No.",Item."Vendor No.");
                                                                      IF PlanningResiliency AND Item.Blocked THEN
                                                                        TempPlanningErrorLog.SetError(
                                                                          STRSUBSTNO(Text031,Item.TABLECAPTION,Item."No."),
                                                                          DATABASE::Item,Item.GETPOSITION);
                                                                      Item.TESTFIELD(Blocked,FALSE);
                                                                      UpdateDescription;
                                                                      "Low-Level Code" := Item."Low-Level Code";
                                                                      "Scrap %" := Item."Scrap %";
                                                                      "Item Category Code" := Item."Item Category Code";
                                                                      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                                                                      "Gen. Business Posting Group" := '';
                                                                      IF PlanningResiliency AND (Item."Base Unit of Measure" = '') THEN
                                                                        TempPlanningErrorLog.SetError(
                                                                          STRSUBSTNO(Text032,Item.TABLECAPTION,Item."No.",
                                                                            Item.FIELDCAPTION("Base Unit of Measure")),
                                                                          DATABASE::Item,Item.GETPOSITION);
                                                                      Item.TESTFIELD("Base Unit of Measure");
                                                                      "Indirect Cost %" := Item."Indirect Cost %";
                                                                      GetPlanningParameters.AtSKU(TempSKU,"No.","Variant Code","Location Code");
                                                                      IF Subcontracting THEN
                                                                        TempSKU."Replenishment System" := TempSKU."Replenishment System"::"Prod. Order";
                                                                      VALIDATE("Replenishment System",TempSKU."Replenishment System");
                                                                      "Accept Action Message" := TRUE;
                                                                      "Product Group Code" := Item."Product Group Code";
                                                                      GetDirectCost(FIELDNO("No."));
                                                                      SetFromBinCode;
                                                                    END;
                                                                END;

                                                                IF "Planning Line Origin" <> "Planning Line Origin"::"Order Planning" THEN
                                                                  IF ("Replenishment System" = "Replenishment System"::Purchase) AND
                                                                     (Item."Purch. Unit of Measure" <> '')
                                                                  THEN
                                                                    VALIDATE("Unit of Measure Code",Item."Purch. Unit of Measure")
                                                                  ELSE
                                                                    VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");

                                                                CreateDim(
                                                                  DimMgt.TypeToTableID3(Type),
                                                                  "No.",DATABASE::Vendor,"Vendor No.");
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 6   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 7   ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 8   ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                "Quantity (Base)" := CalcBaseQty(Quantity);
                                                                IF Type = Type::Item THEN BEGIN
                                                                  GetDirectCost(FIELDNO(Quantity));
                                                                  "Remaining Quantity" := Quantity - "Finished Quantity";
                                                                  "Remaining Qty. (Base)" := "Remaining Quantity" * "Qty. per Unit of Measure";

                                                                  IF (CurrFieldNo = FIELDNO(Quantity)) OR (CurrentFieldNo = FIELDNO(Quantity)) THEN
                                                                    SetActionMessage;

                                                                  "Net Quantity (Base)" := (Quantity - "Original Quantity") * "Qty. per Unit of Measure";

                                                                  VALIDATE("Unit Cost");
                                                                  IF ValidateFields THEN
                                                                    IF "Ending Date" <> 0D THEN
                                                                      VALIDATE("Ending Time")
                                                                    ELSE BEGIN
                                                                      IF "Starting Date" = 0D THEN
                                                                        "Starting Date" := WORKDATE;
                                                                      VALIDATE("Starting Time");
                                                                    END;
                                                                  ReserveReqLine.VerifyQuantity(Rec,xRec);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 9   ;   ;Vendor No.          ;Code20        ;TableRelation=Vendor;
                                                   OnValidate=VAR
                                                                TempSKU@1000 : TEMPORARY Record 5700;
                                                              BEGIN
                                                                CheckActionMessageNew;
                                                                IF "Vendor No." <> '' THEN
                                                                  IF Vend.GET("Vendor No.") THEN BEGIN
                                                                    IF Vend."Privacy Blocked" THEN BEGIN
                                                                      IF PlanningResiliency THEN
                                                                        TempPlanningErrorLog.SetError(
                                                                          STRSUBSTNO(Text031,Vend.TABLECAPTION,Vend."No."),
                                                                          DATABASE::Vendor,Vend.GETPOSITION);
                                                                      Vend.VendPrivacyBlockedErrorMessage(Vend,FALSE);
                                                                    END;
                                                                    IF Vend.Blocked = Vend.Blocked::All THEN BEGIN
                                                                      IF PlanningResiliency THEN
                                                                        TempPlanningErrorLog.SetError(
                                                                          STRSUBSTNO(Text031,Vend.TABLECAPTION,Vend."No."),
                                                                          DATABASE::Vendor,Vend.GETPOSITION);
                                                                      Vend.VendBlockedErrorMessage(Vend,FALSE);
                                                                    END;
                                                                    IF "Order Date" = 0D THEN
                                                                      VALIDATE("Order Date",WORKDATE);

                                                                    VALIDATE("Currency Code",Vend."Currency Code");
                                                                    IF Type = Type::Item THEN
                                                                      UpdateDescription;
                                                                    VALIDATE(Quantity);
                                                                  END ELSE BEGIN
                                                                    IF ValidateFields THEN
                                                                      ERROR(Text005,FIELDCAPTION("Vendor No."),"Vendor No.");
                                                                    "Vendor No." := '';
                                                                  END
                                                                ELSE
                                                                  UpdateDescription;

                                                                GetLocationCode;

                                                                "Order Address Code" := '';

                                                                IF (Type = Type::Item) AND ("No." <> '') AND ("Prod. Order No." = '') THEN BEGIN
                                                                  IF ItemVend.GET("Vendor No.","No.","Variant Code") THEN BEGIN
                                                                    "Vendor Item No." := ItemVend."Vendor Item No.";
                                                                    UpdateOrderReceiptDate(ItemVend."Lead Time Calculation");
                                                                  END ELSE BEGIN
                                                                    GetPlanningParameters.AtSKU(TempSKU,"No.","Variant Code","Location Code");
                                                                    IF "Vendor No." = TempSKU."Vendor No." THEN
                                                                      "Vendor Item No." := TempSKU."Vendor Item No."
                                                                    ELSE
                                                                      "Vendor Item No." := '';
                                                                  END;
                                                                  GetDirectCost(FIELDNO("Vendor No."))
                                                                END;
                                                                "Supply From" := "Vendor No.";

                                                                CreateDim(
                                                                  DATABASE::Vendor,"Vendor No.",
                                                                  DimMgt.TypeToTableID3(Type),"No.");
                                                              END;

                                                   OnLookup=BEGIN
                                                              IF LookupVendor(Vend,TRUE) THEN
                                                                VALIDATE("Vendor No.",Vend."No.");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Leverand�rnr.;
                                                              ENU=Vendor No.] }
    { 10  ;   ;Direct Unit Cost    ;Decimal       ;CaptionML=[DAN=K�bspris;
                                                              ENU=Direct Unit Cost];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 12  ;   ;Due Date            ;Date          ;OnValidate=BEGIN
                                                                IF (CurrFieldNo = FIELDNO("Due Date")) OR (CurrentFieldNo = FIELDNO("Due Date")) THEN
                                                                  SetActionMessage;

                                                                IF "Due Date" = 0D THEN
                                                                  EXIT;

                                                                IF (CurrFieldNo = FIELDNO("Due Date")) OR (CurrentFieldNo = FIELDNO("Due Date")) THEN
                                                                  IF (Type = Type::Item) AND
                                                                     ("Planning Level" = 0)
                                                                  THEN
                                                                    VALIDATE(
                                                                      "Ending Date",
                                                                      LeadTimeMgt.PlannedEndingDate("No.","Location Code","Variant Code","Due Date",'',"Ref. Order Type"))
                                                                  ELSE
                                                                    VALIDATE("Ending Date","Due Date");

                                                                CheckDueDateToDemandDate;
                                                              END;

                                                   CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 13  ;   ;Requester ID        ;Code50        ;TableRelation=User."User Name";
                                                   OnValidate=VAR
                                                                UserMgt@1000 : Codeunit 418;
                                                              BEGIN
                                                                UserMgt.ValidateUserID("Requester ID");
                                                              END;

                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Requester ID");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Bestiller-id;
                                                              ENU=Requester ID] }
    { 14  ;   ;Confirmed           ;Boolean       ;CaptionML=[DAN=Godkendt;
                                                              ENU=Confirmed] }
    { 15  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 16  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 17  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=VAR
                                                                TempSKU@1000 : TEMPORARY Record 5700;
                                                              BEGIN
                                                                ValidateLocationChange;
                                                                CheckActionMessageNew;
                                                                "Bin Code" := '';
                                                                ReserveReqLine.VerifyChange(Rec,xRec);

                                                                IF Type = Type::Item THEN BEGIN
                                                                  GetPlanningParameters.AtSKU(TempSKU,"No.","Variant Code","Location Code");
                                                                  IF Subcontracting THEN
                                                                    TempSKU."Replenishment System" := TempSKU."Replenishment System"::"Prod. Order";
                                                                  VALIDATE("Replenishment System",TempSKU."Replenishment System");
                                                                  IF "Location Code" <> xRec."Location Code" THEN
                                                                    IF ("Location Code" <> '') AND ("No." <> '') AND NOT IsDropShipment THEN BEGIN
                                                                      GetLocation("Location Code");
                                                                      IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
                                                                        WMSManagement.GetDefaultBin("No.","Variant Code","Location Code","Bin Code");
                                                                    END;
                                                                  IF ItemVend.GET("Vendor No.","No.","Variant Code") THEN
                                                                    "Vendor Item No." := ItemVend."Vendor Item No.";
                                                                END;
                                                                GetDirectCost(FIELDNO("Location Code"));
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 18  ;   ;Recurring Method    ;Option        ;CaptionML=[DAN=Gentagelsesprincip;
                                                              ENU=Recurring Method];
                                                   OptionCaptionML=[DAN=,Fast,Variabel;
                                                                    ENU=,Fixed,Variable];
                                                   OptionString=,Fixed,Variable;
                                                   BlankZero=Yes }
    { 19  ;   ;Expiration Date     ;Date          ;CaptionML=[DAN=Udl�bsdato;
                                                              ENU=Expiration Date] }
    { 20  ;   ;Recurring Frequency ;DateFormula   ;CaptionML=[DAN=Gentagelsesinterval;
                                                              ENU=Recurring Frequency] }
    { 21  ;   ;Order Date          ;Date          ;OnValidate=BEGIN
                                                                "Starting Date" := "Order Date";

                                                                GetDirectCost(FIELDNO("Order Date"));

                                                                IF CurrFieldNo = FIELDNO("Order Date") THEN
                                                                  VALIDATE("Starting Date");
                                                              END;

                                                   CaptionML=[DAN=Ordredato;
                                                              ENU=Order Date] }
    { 22  ;   ;Vendor Item No.     ;Text20        ;CaptionML=[DAN=Leverand�rs varenr.;
                                                              ENU=Vendor Item No.] }
    { 23  ;   ;Sales Order No.     ;Code20        ;TableRelation="Sales Header".No. WHERE (Document Type=CONST(Order));
                                                   OnValidate=BEGIN
                                                                ReserveReqLine.VerifyChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Salgsordrenr.;
                                                              ENU=Sales Order No.];
                                                   Editable=No }
    { 24  ;   ;Sales Order Line No.;Integer       ;OnValidate=BEGIN
                                                                ReserveReqLine.VerifyChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Salgsordrelinjenr.;
                                                              ENU=Sales Order Line No.];
                                                   Editable=No }
    { 25  ;   ;Sell-to Customer No.;Code20        ;TableRelation=Customer;
                                                   OnValidate=BEGIN
                                                                IF "Sell-to Customer No." = '' THEN
                                                                  "Ship-to Code" := ''
                                                                ELSE
                                                                  VALIDATE("Ship-to Code",'');

                                                                ReserveReqLine.VerifyChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Kundenr.;
                                                              ENU=Sell-to Customer No.];
                                                   Editable=No }
    { 26  ;   ;Ship-to Code        ;Code10        ;TableRelation="Ship-to Address".Code WHERE (Customer No.=FIELD(Sell-to Customer No.));
                                                   OnValidate=BEGIN
                                                                IF "Ship-to Code" <> '' THEN BEGIN
                                                                  ShipToAddr.GET("Sell-to Customer No.","Ship-to Code");
                                                                  "Location Code" := ShipToAddr."Location Code";
                                                                END ELSE BEGIN
                                                                  Cust.GET("Sell-to Customer No.");
                                                                  "Location Code" := Cust."Location Code";
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Leveringsadressekode;
                                                              ENU=Ship-to Code];
                                                   Editable=No }
    { 28  ;   ;Order Address Code  ;Code10        ;TableRelation="Order Address".Code WHERE (Vendor No.=FIELD(Vendor No.));
                                                   CaptionML=[DAN=Bestillingsadressekode;
                                                              ENU=Order Address Code] }
    { 29  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                GetCurrency;
                                                                IF "Currency Code" <> '' THEN BEGIN
                                                                  TESTFIELD("Order Date");
                                                                  IF PlanningResiliency THEN
                                                                    CheckExchRate;
                                                                  VALIDATE(
                                                                    "Currency Factor",CurrExchRate.ExchangeRate(
                                                                      "Order Date","Currency Code"));
                                                                END ELSE
                                                                  VALIDATE("Currency Factor",0);
                                                                GetDirectCost(FIELDNO("Currency Code"));
                                                              END;

                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 30  ;   ;Currency Factor     ;Decimal       ;OnValidate=BEGIN
                                                                IF "Currency Code" <> '' THEN
                                                                  TESTFIELD("Currency Factor");
                                                                IF "Currency Factor" <> xRec."Currency Factor" THEN BEGIN
                                                                  IF xRec."Currency Factor" <> 0 THEN
                                                                    "Direct Unit Cost" :=
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        "Order Date",xRec."Currency Code","Direct Unit Cost",xRec."Currency Factor");
                                                                  IF "Currency Factor" <> 0 THEN
                                                                    "Direct Unit Cost" :=
                                                                      CurrExchRate.ExchangeAmtLCYToFCY(
                                                                        "Order Date","Currency Code","Direct Unit Cost","Currency Factor");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Valutafaktor;
                                                              ENU=Currency Factor];
                                                   DecimalPlaces=0:15;
                                                   MinValue=0 }
    { 31  ;   ;Reserved Quantity   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Worksheet Template Name),
                                                                                                       Source Ref. No.=FIELD(Line No.),
                                                                                                       Source Type=CONST(246),
                                                                                                       Source Subtype=CONST(0),
                                                                                                       Source Batch Name=FIELD(Journal Batch Name),
                                                                                                       Source Prod. Order Line=CONST(0),
                                                                                                       Reservation Status=CONST(Reservation)));
                                                   CaptionML=[DAN=Reserveret antal;
                                                              ENU=Reserved Quantity];
                                                   DecimalPlaces=0:5;
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
    { 5401;   ;Prod. Order No.     ;Code20        ;TableRelation="Production Order".No. WHERE (Status=CONST(Released));
                                                   OnValidate=BEGIN
                                                                AddOnIntegrMgt.ValidateProdOrderOnReqLine(Rec);
                                                                VALIDATE("Unit of Measure Code");
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Prod.ordrenr.;
                                                              ENU=Prod. Order No.];
                                                   Editable=No }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   OnValidate=VAR
                                                                TempSKU@1000 : TEMPORARY Record 5700;
                                                              BEGIN
                                                                IF "Variant Code" <> '' THEN
                                                                  TESTFIELD(Type,Type::Item);
                                                                CheckActionMessageNew;
                                                                ReserveReqLine.VerifyChange(Rec,xRec);

                                                                CALCFIELDS("Reserved Qty. (Base)");
                                                                TESTFIELD("Reserved Qty. (Base)",0);

                                                                GetDirectCost(FIELDNO("Variant Code"));
                                                                IF "Variant Code" <> '' THEN BEGIN
                                                                  UpdateDescription;
                                                                  GetPlanningParameters.AtSKU(TempSKU,"No.","Variant Code","Location Code");
                                                                  IF Subcontracting THEN
                                                                    TempSKU."Replenishment System" := TempSKU."Replenishment System"::"Prod. Order";
                                                                  VALIDATE("Replenishment System",TempSKU."Replenishment System");
                                                                  IF "Variant Code" <> xRec."Variant Code" THEN BEGIN
                                                                    "Bin Code" := '';
                                                                    IF ("Location Code" <> '') AND ("No." <> '') THEN BEGIN
                                                                      GetLocation("Location Code");
                                                                      IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
                                                                        WMSManagement.GetDefaultBin("No.","Variant Code","Location Code","Bin Code")
                                                                    END;
                                                                  END;
                                                                  IF ItemVend.GET("Vendor No.","No.","Variant Code") THEN
                                                                    "Vendor Item No." := ItemVend."Vendor Item No.";
                                                                END ELSE
                                                                  VALIDATE("No.");
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5403;   ;Bin Code            ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                 Item Filter=FIELD(No.),
                                                                                 Variant Filter=FIELD(Variant Code));
                                                   OnValidate=BEGIN
                                                                CheckActionMessageNew;
                                                                IF (CurrFieldNo = FIELDNO("Bin Code")) AND
                                                                   ("Action Message" <> "Action Message"::" ")
                                                                THEN
                                                                  TESTFIELD("Action Message","Action Message"::New);
                                                                TESTFIELD(Type,Type::Item);
                                                                TESTFIELD("Location Code");
                                                                IF ("Bin Code" <> xRec."Bin Code") AND ("Bin Code" <> '') THEN BEGIN
                                                                  GetLocation("Location Code");
                                                                  Location.TESTFIELD("Bin Mandatory");
                                                                  Location.TESTFIELD("Directed Put-away and Pick",FALSE);
                                                                  GetBin("Location Code","Bin Code");
                                                                  TESTFIELD("Location Code",Bin."Location Code");
                                                                END;
                                                                ReserveReqLine.VerifyChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 5404;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5407;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE "Unit of Measure";
                                                   OnValidate=BEGIN
                                                                CheckActionMessageNew;
                                                                IF (Type = Type::Item) AND
                                                                   ("No." <> '') AND
                                                                   ("Prod. Order No." = '')
                                                                THEN BEGIN
                                                                  GetItem;
                                                                  "Unit Cost" := Item."Unit Cost";
                                                                  "Overhead Rate" := Item."Overhead Rate";
                                                                  "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                                                                  IF "Unit of Measure Code" <> '' THEN BEGIN
                                                                    "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                                                                    "Unit Cost" := ROUND(Item."Unit Cost" * "Qty. per Unit of Measure",0.00001);
                                                                    "Overhead Rate" := ROUND(Item."Overhead Rate" * "Qty. per Unit of Measure",0.00001);
                                                                  END ELSE
                                                                    "Qty. per Unit of Measure" := 1;
                                                                END ELSE
                                                                  IF "Prod. Order No." = '' THEN
                                                                    "Qty. per Unit of Measure" := 1
                                                                  ELSE
                                                                    "Qty. per Unit of Measure" := 0;
                                                                GetDirectCost(FIELDNO("Unit of Measure Code"));

                                                                IF "Planning Line Origin" = "Planning Line Origin"::"Order Planning" THEN
                                                                  SetSupplyQty("Demand Quantity (Base)","Needed Quantity (Base)")
                                                                ELSE
                                                                  VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 5408;   ;Quantity (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Prod. Order No.",'');
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE(Quantity,"Quantity (Base)");
                                                              END;

                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 5431;   ;Reserved Qty. (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(Worksheet Template Name),
                                                                                                                Source Ref. No.=FIELD(Line No.),
                                                                                                                Source Type=CONST(246),
                                                                                                                Source Subtype=CONST(0),
                                                                                                                Source Batch Name=FIELD(Journal Batch Name),
                                                                                                                Source Prod. Order Line=CONST(0),
                                                                                                                Reservation Status=CONST(Reservation)));
                                                   CaptionML=[DAN=Reserveret antal (basis);
                                                              ENU=Reserved Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5520;   ;Demand Type         ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Table));
                                                   CaptionML=[DAN=Behovstype;
                                                              ENU=Demand Type];
                                                   Editable=No }
    { 5521;   ;Demand Subtype      ;Option        ;CaptionML=[DAN=Behovsundertype;
                                                              ENU=Demand Subtype];
                                                   OptionCaptionML=[DAN=0,1,2,3,4,5,6,7,8,9;
                                                                    ENU=0,1,2,3,4,5,6,7,8,9];
                                                   OptionString=0,1,2,3,4,5,6,7,8,9;
                                                   Editable=No }
    { 5522;   ;Demand Order No.    ;Code20        ;CaptionML=[DAN=Behovsordrenr.;
                                                              ENU=Demand Order No.];
                                                   Editable=No }
    { 5525;   ;Demand Line No.     ;Integer       ;CaptionML=[DAN=Behovslinjenr.;
                                                              ENU=Demand Line No.];
                                                   Editable=No }
    { 5526;   ;Demand Ref. No.     ;Integer       ;CaptionML=[DAN=Behovsreferencenr.;
                                                              ENU=Demand Ref. No.];
                                                   Editable=No }
    { 5527;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=0,1,2,3,4,5,6,7,8,9,10;
                                                                    ENU=0,1,2,3,4,5,6,7,8,9,10];
                                                   OptionString=0,1,2,3,4,5,6,7,8,9,10;
                                                   Editable=No }
    { 5530;   ;Demand Date         ;Date          ;CaptionML=[DAN=Behovsdato;
                                                              ENU=Demand Date];
                                                   Editable=No }
    { 5532;   ;Demand Quantity     ;Decimal       ;CaptionML=[DAN=Behovsm�ngde;
                                                              ENU=Demand Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5533;   ;Demand Quantity (Base);Decimal     ;CaptionML=[DAN=Behovsm�ngde (basis);
                                                              ENU=Demand Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5538;   ;Needed Quantity     ;Decimal       ;CaptionML=[DAN=N�dvendigt antal;
                                                              ENU=Needed Quantity];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 5539;   ;Needed Quantity (Base);Decimal     ;CaptionML=[DAN=N�dvendigt antal (basis);
                                                              ENU=Needed Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 5540;   ;Reserve             ;Boolean       ;OnValidate=BEGIN
                                                                GetItem;
                                                                IF Item.Reserve <> Item.Reserve::Optional THEN
                                                                  TESTFIELD(Reserve,Item.Reserve = Item.Reserve::Always);
                                                                IF Reserve AND
                                                                   ("Demand Type" = DATABASE::"Prod. Order Component") AND
                                                                   ("Demand Subtype" = ProdOrderCapNeed.Status::Planned)
                                                                THEN
                                                                  ERROR(Text030);
                                                                TESTFIELD("Planning Level",0);
                                                                TESTFIELD("Planning Line Origin","Planning Line Origin"::"Order Planning");
                                                              END;

                                                   CaptionML=[DAN=Reserver;
                                                              ENU=Reserve] }
    { 5541;   ;Qty. per UOM (Demand);Decimal      ;CaptionML=[DAN=M�ngde pr. enhed (behov);
                                                              ENU=Qty. per UOM (Demand)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5542;   ;Unit Of Measure Code (Demand);Code10;
                                                   TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
                                                   CaptionML=[DAN=Enhedskode (behov);
                                                              ENU=Unit Of Measure Code (Demand)];
                                                   Editable=No }
    { 5552;   ;Supply From         ;Code20        ;TableRelation=IF (Replenishment System=CONST(Purchase)) Vendor
                                                                 ELSE IF (Replenishment System=CONST(Transfer)) Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                CASE "Replenishment System" OF
                                                                  "Replenishment System"::Purchase:
                                                                    VALIDATE("Vendor No.","Supply From");
                                                                  "Replenishment System"::Transfer:
                                                                    VALIDATE("Transfer-from Code","Supply From");
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              CASE "Replenishment System" OF
                                                                "Replenishment System"::Purchase:
                                                                  IF LookupVendor(Vend,TRUE) THEN
                                                                    VALIDATE("Supply From",Vend."No.");
                                                                "Replenishment System"::Transfer:
                                                                  IF LookupFromLocation(Location) THEN
                                                                    VALIDATE("Supply From",Location.Code);
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Forsyning fra;
                                                              ENU=Supply From] }
    { 5553;   ;Original Item No.   ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Oprindeligt varenr.;
                                                              ENU=Original Item No.];
                                                   Editable=No }
    { 5554;   ;Original Variant Code;Code10       ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Original Item No.));
                                                   CaptionML=[DAN=Oprindelig variantkode;
                                                              ENU=Original Variant Code];
                                                   Editable=No }
    { 5560;   ;Level               ;Integer       ;CaptionML=[DAN=Niveau;
                                                              ENU=Level];
                                                   Editable=No }
    { 5563;   ;Demand Qty. Available;Decimal      ;CaptionML=[DAN=Tilg�ngelig behovsm�ngde;
                                                              ENU=Demand Qty. Available];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5590;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 5701;   ;Item Category Code  ;Code20        ;TableRelation=IF (Type=CONST(Item)) "Item Category";
                                                   CaptionML=[DAN=Varekategorikode;
                                                              ENU=Item Category Code] }
    { 5702;   ;Nonstock            ;Boolean       ;CaptionML=[DAN=Katalogvare;
                                                              ENU=Nonstock] }
    { 5703;   ;Purchasing Code     ;Code10        ;TableRelation=Purchasing;
                                                   CaptionML=[DAN=Indk�bskode;
                                                              ENU=Purchasing Code] }
    { 5705;   ;Product Group Code  ;Code10        ;TableRelation="Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
                                                   ValidateTableRelation=No;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Product Groups became first level children of Item Categories.;
                                                   CaptionML=[DAN=Produktgruppekode;
                                                              ENU=Product Group Code] }
    { 5706;   ;Transfer-from Code  ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                CheckActionMessageNew;
                                                                "Supply From" := "Transfer-from Code";
                                                              END;

                                                   CaptionML=[DAN=Overflyt fra-kode;
                                                              ENU=Transfer-from Code];
                                                   Editable=No }
    { 5707;   ;Transfer Shipment Date;Date        ;AccessByPermission=TableData 5740=R;
                                                   CaptionML=[DAN=Afsendelsesdato for overflytning;
                                                              ENU=Transfer Shipment Date];
                                                   Editable=No }
    { 7002;   ;Line Discount %     ;Decimal       ;CaptionML=[DAN=Linjerabatpct.;
                                                              ENU=Line Discount %];
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 7100;   ;Blanket Purch. Order Exists;Boolean;FieldClass=FlowField;
                                                   CalcFormula=Exist("Purchase Line" WHERE (Document Type=CONST(Blanket Order),
                                                                                            Type=CONST(Item),
                                                                                            No.=FIELD(No.),
                                                                                            Outstanding Quantity=FILTER(<>0)));
                                                   CaptionML=[DAN=Rammek�bsordrenr. findes;
                                                              ENU=Blanket Purch. Order Exists];
                                                   Editable=No }
    { 99000750;;Routing No.        ;Code20        ;TableRelation="Routing Header";
                                                   OnValidate=VAR
                                                                RtngDate@1000 : Date;
                                                              BEGIN
                                                                CheckActionMessageNew;
                                                                "Routing Version Code" := '';

                                                                IF "Routing No." = '' THEN
                                                                  EXIT;

                                                                IF CurrFieldNo = FIELDNO("Starting Date") THEN
                                                                  RtngDate := "Starting Date"
                                                                ELSE
                                                                  RtngDate := "Ending Date";
                                                                IF RtngDate = 0D THEN
                                                                  RtngDate := "Order Date";

                                                                VALIDATE("Routing Version Code",VersionMgt.GetRtngVersion("Routing No.",RtngDate,TRUE));
                                                                IF "Routing Version Code" = '' THEN BEGIN
                                                                  RtngHeader.GET("Routing No.");
                                                                  IF PlanningResiliency AND (RtngHeader.Status <> RtngHeader.Status::Certified) THEN
                                                                    TempPlanningErrorLog.SetError(
                                                                      STRSUBSTNO(Text033,RtngHeader.TABLECAPTION,RtngHeader.FIELDCAPTION("No."),RtngHeader."No."),
                                                                      DATABASE::"Routing Header",RtngHeader.GETPOSITION);
                                                                  RtngHeader.TESTFIELD(Status,RtngHeader.Status::Certified);
                                                                  "Routing Type" := RtngHeader.Type;
                                                                END;
                                                              END;

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
                                                                  "Routing No.","Operation No.");

                                                                ProdOrderRtngLine.TESTFIELD(
                                                                  Type,
                                                                  ProdOrderRtngLine.Type::"Work Center");

                                                                "Due Date" := ProdOrderRtngLine."Ending Date";
                                                                CheckDueDateToDemandDate;

                                                                VALIDATE("Work Center No.",ProdOrderRtngLine."No.");

                                                                VALIDATE("Direct Unit Cost",ProdOrderRtngLine."Direct Unit Cost");
                                                              END;

                                                   CaptionML=[DAN=Operationsnr.;
                                                              ENU=Operation No.] }
    { 99000752;;Work Center No.    ;Code20        ;TableRelation="Work Center";
                                                   OnValidate=BEGIN
                                                                GetWorkCenter;
                                                                VALIDATE("Vendor No.",WorkCenter."Subcontractor No.");
                                                              END;

                                                   CaptionML=[DAN=Arbejdscenternr.;
                                                              ENU=Work Center No.] }
    { 99000754;;Prod. Order Line No.;Integer      ;TableRelation="Prod. Order Line"."Line No." WHERE (Status=CONST(Finished),
                                                                                                      Prod. Order No.=FIELD(Prod. Order No.));
                                                   CaptionML=[DAN=Prod.ordrelinjenr.;
                                                              ENU=Prod. Order Line No.];
                                                   Editable=No }
    { 99000755;;MPS Order          ;Boolean       ;CaptionML=[DAN=Hovedplansordre;
                                                              ENU=MPS Order] }
    { 99000756;;Planning Flexibility;Option       ;OnValidate=BEGIN
                                                                IF "Planning Flexibility" <> xRec."Planning Flexibility" THEN
                                                                  ReserveReqLine.UpdatePlanningFlexibility(Rec);
                                                              END;

                                                   CaptionML=[DAN=Planl�gningsfleksibilitet;
                                                              ENU=Planning Flexibility];
                                                   OptionCaptionML=[DAN=Ubegr�nset,Ingen;
                                                                    ENU=Unlimited,None];
                                                   OptionString=Unlimited,None }
    { 99000757;;Routing Reference No.;Integer     ;CaptionML=[DAN=Rutereferencenr.;
                                                              ENU=Routing Reference No.] }
    { 99000882;;Gen. Prod. Posting Group;Code20   ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 99000883;;Gen. Business Posting Group;Code20;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Business Posting Group] }
    { 99000884;;Low-Level Code     ;Integer       ;AccessByPermission=TableData 5405=R;
                                                   CaptionML=[DAN=Laveste-niveau-kode;
                                                              ENU=Low-Level Code];
                                                   Editable=No }
    { 99000885;;Production BOM Version Code;Code20;TableRelation="Production BOM Version"."Version Code" WHERE (Production BOM No.=FIELD(Production BOM No.));
                                                   OnValidate=BEGIN
                                                                CheckActionMessageNew;
                                                                IF "Production BOM Version Code" = '' THEN
                                                                  EXIT;

                                                                ProdBOMVersion.GET("Production BOM No.","Production BOM Version Code");
                                                                IF PlanningResiliency AND (ProdBOMVersion.Status <> ProdBOMVersion.Status::Certified) THEN
                                                                  TempPlanningErrorLog.SetError(
                                                                    STRSUBSTNO(
                                                                      Text034,ProdBOMVersion.TABLECAPTION,
                                                                      ProdBOMVersion.FIELDCAPTION("Production BOM No."),ProdBOMVersion."Production BOM No.",
                                                                      ProdBOMVersion.FIELDCAPTION("Version Code"),ProdBOMVersion."Version Code"),
                                                                    DATABASE::"Production BOM Version",ProdBOMVersion.GETPOSITION);
                                                                ProdBOMVersion.TESTFIELD(Status,ProdBOMVersion.Status::Certified);
                                                              END;

                                                   CaptionML=[DAN=Prod.styklisteversionskode;
                                                              ENU=Production BOM Version Code] }
    { 99000886;;Routing Version Code;Code20       ;TableRelation="Routing Version"."Version Code" WHERE (Routing No.=FIELD(Routing No.));
                                                   OnValidate=BEGIN
                                                                CheckActionMessageNew;
                                                                IF "Routing Version Code" = '' THEN
                                                                  EXIT;

                                                                RtngVersion.GET("Routing No.","Routing Version Code");
                                                                IF PlanningResiliency AND (RtngVersion.Status <> RtngVersion.Status::Certified) THEN
                                                                  TempPlanningErrorLog.SetError(
                                                                    STRSUBSTNO(
                                                                      Text034,RtngVersion.TABLECAPTION,
                                                                      RtngVersion.FIELDCAPTION("Routing No."),RtngVersion."Routing No.",
                                                                      RtngVersion.FIELDCAPTION("Version Code"),RtngVersion."Version Code"),
                                                                    DATABASE::"Routing Version",RtngVersion.GETPOSITION);
                                                                RtngVersion.TESTFIELD(Status,RtngVersion.Status::Certified);
                                                                "Routing Type" := RtngVersion.Type;
                                                              END;

                                                   CaptionML=[DAN=Ruteversionskode;
                                                              ENU=Routing Version Code] }
    { 99000887;;Routing Type       ;Option        ;CaptionML=[DAN=Rutetype;
                                                              ENU=Routing Type];
                                                   OptionCaptionML=[DAN=Seriel,Parallel;
                                                                    ENU=Serial,Parallel];
                                                   OptionString=Serial,Parallel }
    { 99000888;;Original Quantity  ;Decimal       ;CaptionML=[DAN=Oprindeligt antal;
                                                              ENU=Original Quantity];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 99000889;;Finished Quantity  ;Decimal       ;CaptionML=[DAN=F�rdigt antal;
                                                              ENU=Finished Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   Editable=No }
    { 99000890;;Remaining Quantity ;Decimal       ;CaptionML=[DAN=Restantal;
                                                              ENU=Remaining Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   Editable=No }
    { 99000891;;Original Due Date  ;Date          ;CaptionML=[DAN=Oprindelig forfaldsdato;
                                                              ENU=Original Due Date];
                                                   Editable=No }
    { 99000892;;Scrap %            ;Decimal       ;AccessByPermission=TableData 5405=R;
                                                   CaptionML=[DAN=Spildpct.;
                                                              ENU=Scrap %];
                                                   DecimalPlaces=0:5 }
    { 99000894;;Starting Date      ;Date          ;OnValidate=BEGIN
                                                                IF Type = Type::Item THEN BEGIN
                                                                  GetWorkCenter;
                                                                  IF NOT Subcontracting THEN BEGIN
                                                                    VALIDATE("Production BOM No.");
                                                                    VALIDATE("Routing No.");
                                                                  END;
                                                                  VALIDATE("Starting Time");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 99000895;;Starting Time      ;Time          ;OnValidate=BEGIN
                                                                TESTFIELD(Type,Type::Item);
                                                                IF ReqLine.GET("Worksheet Template Name","Journal Batch Name","Line No.") THEN
                                                                  PlngLnMgt.RecalculateWithOptionalModify(Rec,0,FALSE)
                                                                ELSE
                                                                  CalcEndingDate('');

                                                                CheckEndingDate(ValidateFields);
                                                                SetDueDate;
                                                                SetActionMessage;
                                                                UpdateDatetime;
                                                              END;

                                                   CaptionML=[DAN=Starttidspunkt;
                                                              ENU=Starting Time] }
    { 99000896;;Ending Date        ;Date          ;OnValidate=BEGIN
                                                                CheckEndingDate(ValidateFields);

                                                                IF Type = Type::Item THEN BEGIN
                                                                  VALIDATE("Ending Time");
                                                                  GetWorkCenter;
                                                                  IF NOT Subcontracting THEN BEGIN
                                                                    VALIDATE("Production BOM No.");
                                                                    VALIDATE("Routing No.");
                                                                  END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date] }
    { 99000897;;Ending Time        ;Time          ;OnValidate=BEGIN
                                                                TESTFIELD(Type,Type::Item);
                                                                IF ReqLine.GET("Worksheet Template Name","Journal Batch Name","Line No.") THEN
                                                                  PlngLnMgt.RecalculateWithOptionalModify(Rec,1,FALSE)
                                                                ELSE
                                                                  CalcStartingDate('');

                                                                IF (CurrFieldNo IN [FIELDNO("Ending Date"),FIELDNO("Ending Date-Time")]) AND (CurrentFieldNo <> FIELDNO("Due Date")) THEN
                                                                  SetDueDate;
                                                                SetActionMessage;
                                                                IF "Ending Time" = 0T THEN BEGIN
                                                                  MfgSetup.GET;
                                                                  "Ending Time" := MfgSetup."Normal Ending Time";
                                                                END;
                                                                UpdateDatetime;
                                                              END;

                                                   CaptionML=[DAN=Sluttidspunkt;
                                                              ENU=Ending Time] }
    { 99000898;;Production BOM No. ;Code20        ;TableRelation="Production BOM Header".No.;
                                                   OnValidate=VAR
                                                                BOMDate@1000 : Date;
                                                              BEGIN
                                                                TESTFIELD(Type,Type::Item);
                                                                CheckActionMessageNew;
                                                                "Production BOM Version Code" := '';
                                                                IF "Production BOM No." = '' THEN
                                                                  EXIT;

                                                                IF CurrFieldNo = FIELDNO("Starting Date") THEN
                                                                  BOMDate := "Starting Date"
                                                                ELSE BEGIN
                                                                  BOMDate := "Ending Date";
                                                                  IF BOMDate = 0D THEN
                                                                    BOMDate := "Order Date";
                                                                END;

                                                                VALIDATE("Production BOM Version Code",VersionMgt.GetBOMVersion("Production BOM No.",BOMDate,TRUE));
                                                                IF "Production BOM Version Code" = '' THEN BEGIN
                                                                  ProdBOMHeader.GET("Production BOM No.");
                                                                  IF PlanningResiliency AND (ProdBOMHeader.Status <> ProdBOMHeader.Status::Certified) THEN
                                                                    TempPlanningErrorLog.SetError(
                                                                      STRSUBSTNO(
                                                                        Text033,
                                                                        ProdBOMHeader.TABLECAPTION,
                                                                        ProdBOMHeader.FIELDCAPTION("No."),ProdBOMHeader."No."),
                                                                      DATABASE::"Production BOM Header",ProdBOMHeader.GETPOSITION);

                                                                  ProdBOMHeader.TESTFIELD(Status,ProdBOMHeader.Status::Certified);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Produktionsstyklistenr.;
                                                              ENU=Production BOM No.] }
    { 99000899;;Indirect Cost %    ;Decimal       ;CaptionML=[DAN=Indir. omkost.pct.;
                                                              ENU=Indirect Cost %];
                                                   DecimalPlaces=0:5 }
    { 99000900;;Overhead Rate      ;Decimal       ;CaptionML=[DAN=IPO-bidrag;
                                                              ENU=Overhead Rate];
                                                   DecimalPlaces=0:5 }
    { 99000901;;Unit Cost          ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD(Type,Type::Item);
                                                                TESTFIELD("No.");

                                                                Item.GET("No.");
                                                                IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
                                                                  IF CurrFieldNo = FIELDNO("Unit Cost") THEN
                                                                    ERROR(
                                                                      Text006,
                                                                      FIELDCAPTION("Unit Cost"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");
                                                                  "Unit Cost" := Item."Unit Cost" * "Qty. per Unit of Measure";
                                                                END;
                                                                "Cost Amount" := ROUND("Unit Cost" * Quantity);
                                                              END;

                                                   CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 99000902;;Cost Amount        ;Decimal       ;CaptionML=[DAN=Kostbel�b;
                                                              ENU=Cost Amount];
                                                   MinValue=0;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 99000903;;Replenishment System;Option       ;OnValidate=VAR
                                                                TempSKU@1002 : TEMPORARY Record 5700;
                                                                AsmHeader@1000 : Record 900;
                                                                NoSeriesMgt@1001 : Codeunit 396;
                                                              BEGIN
                                                                TESTFIELD(Type,Type::Item);
                                                                CheckActionMessageNew;
                                                                IF ValidateFields AND
                                                                   ("Replenishment System" = xRec."Replenishment System") AND
                                                                   ("No." = xRec."No.") AND
                                                                   ("Location Code" = xRec."Location Code") AND
                                                                   ("Variant Code" = xRec."Variant Code")
                                                                THEN
                                                                  EXIT;

                                                                TESTFIELD(Type,Type::Item);
                                                                TESTFIELD("No.");
                                                                GetItem;
                                                                GetPlanningParameters.AtSKU(TempSKU,"No.","Variant Code","Location Code");
                                                                IF Subcontracting THEN
                                                                  TempSKU."Replenishment System" := TempSKU."Replenishment System"::"Prod. Order";

                                                                "Supply From" := '';

                                                                CASE "Replenishment System" OF
                                                                  "Replenishment System"::Purchase:
                                                                    BEGIN
                                                                      "Ref. Order Type" := "Ref. Order Type"::Purchase;
                                                                      CLEAR("Ref. Order Status");
                                                                      "Ref. Order No." := '';
                                                                      DeleteRelations;
                                                                      VALIDATE("Production BOM No.",'');
                                                                      VALIDATE("Routing No.",'');
                                                                      IF Item."Purch. Unit of Measure" <> '' THEN
                                                                        VALIDATE("Unit of Measure Code",Item."Purch. Unit of Measure");
                                                                      VALIDATE("Transfer-from Code",'');
                                                                      IF TempSKU."Vendor No." = '' THEN
                                                                        VALIDATE("Vendor No.")
                                                                      ELSE
                                                                        VALIDATE("Vendor No.",TempSKU."Vendor No.");
                                                                    END;
                                                                  "Replenishment System"::"Prod. Order":
                                                                    BEGIN
                                                                      IF ReqWkshTmpl.GET("Worksheet Template Name") AND (ReqWkshTmpl.Type = ReqWkshTmpl.Type::"Req.") AND
                                                                         (ReqWkshTmpl.Name <> '') AND NOT SourceDropShipment
                                                                      THEN
                                                                        ERROR(ReplenishmentErr);
                                                                      IF PlanningResiliency AND (Item."Base Unit of Measure" = '') THEN
                                                                        TempPlanningErrorLog.SetError(
                                                                          STRSUBSTNO(
                                                                            Text032,Item.TABLECAPTION,Item."No.",
                                                                            Item.FIELDCAPTION("Base Unit of Measure")),
                                                                          DATABASE::Item,Item.GETPOSITION);
                                                                      Item.TESTFIELD("Base Unit of Measure");
                                                                      IF "Ref. Order No." = '' THEN BEGIN
                                                                        "Ref. Order Type" := "Ref. Order Type"::"Prod. Order";
                                                                        "Ref. Order Status" := "Ref. Order Status"::Planned;

                                                                        MfgSetup.GET;
                                                                        IF PlanningResiliency AND (MfgSetup."Planned Order Nos." = '') THEN
                                                                          TempPlanningErrorLog.SetError(
                                                                            STRSUBSTNO(Text032,MfgSetup.TABLECAPTION,'',
                                                                              MfgSetup.FIELDCAPTION("Planned Order Nos.")),
                                                                            DATABASE::"Manufacturing Setup",MfgSetup.GETPOSITION);
                                                                        MfgSetup.TESTFIELD("Planned Order Nos.");

                                                                        IF PlanningResiliency THEN
                                                                          CheckNoSeries(MfgSetup."Planned Order Nos.","Due Date");
                                                                        IF NOT Subcontracting THEN
                                                                          NoSeriesMgt.InitSeries(
                                                                            MfgSetup."Planned Order Nos.",xRec."No. Series","Due Date","Ref. Order No.","No. Series");
                                                                      END;
                                                                      VALIDATE("Vendor No.",'');

                                                                      IF NOT Subcontracting THEN BEGIN
                                                                        VALIDATE("Production BOM No.",Item."Production BOM No.");
                                                                        VALIDATE("Routing No.",Item."Routing No.");
                                                                      END ELSE BEGIN
                                                                        "Production BOM No." := Item."Production BOM No.";
                                                                        "Routing No." := Item."Routing No.";
                                                                      END;
                                                                      VALIDATE("Transfer-from Code",'');
                                                                      VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");

                                                                      IF ("Planning Line Origin" = "Planning Line Origin"::"Order Planning") AND
                                                                         ValidateFields
                                                                      THEN
                                                                        PlngLnMgt.Calculate(Rec,1,TRUE,TRUE,0);
                                                                    END;
                                                                  "Replenishment System"::Assembly:
                                                                    BEGIN
                                                                      IF PlanningResiliency AND (Item."Base Unit of Measure" = '') THEN
                                                                        TempPlanningErrorLog.SetError(
                                                                          STRSUBSTNO(
                                                                            Text032,Item.TABLECAPTION,Item."No.",
                                                                            Item.FIELDCAPTION("Base Unit of Measure")),
                                                                          DATABASE::Item,Item.GETPOSITION);
                                                                      Item.TESTFIELD("Base Unit of Measure");
                                                                      IF "Ref. Order No." = '' THEN BEGIN
                                                                        "Ref. Order Type" := "Ref. Order Type"::Assembly;
                                                                        "Ref. Order Status" := AsmHeader."Document Type"::Order;
                                                                      END;
                                                                      VALIDATE("Vendor No.",'');
                                                                      VALIDATE("Production BOM No.",'');
                                                                      VALIDATE("Routing No.",'');
                                                                      VALIDATE("Transfer-from Code",'');
                                                                      VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");

                                                                      IF ("Planning Line Origin" = "Planning Line Origin"::"Order Planning") AND
                                                                         ValidateFields
                                                                      THEN
                                                                        PlngLnMgt.Calculate(Rec,1,TRUE,TRUE,0);
                                                                    END;
                                                                  "Replenishment System"::Transfer:
                                                                    BEGIN
                                                                      "Ref. Order Type" := "Ref. Order Type"::Transfer;
                                                                      CLEAR("Ref. Order Status");
                                                                      "Ref. Order No." := '';
                                                                      DeleteRelations;
                                                                      VALIDATE("Vendor No.",'');
                                                                      VALIDATE("Production BOM No.",'');
                                                                      VALIDATE("Routing No.",'');
                                                                      VALIDATE("Transfer-from Code",TempSKU."Transfer-from Code");
                                                                      VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");
                                                                    END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Genbestillingssystem;
                                                              ENU=Replenishment System];
                                                   OptionCaptionML=[DAN="K�b,Prod.ordre,Overf�rsel,Montage, ";
                                                                    ENU="Purchase,Prod. Order,Transfer,Assembly, "];
                                                   OptionString=[Purchase,Prod. Order,Transfer,Assembly, ] }
    { 99000904;;Ref. Order No.     ;Code20        ;TableRelation=IF (Ref. Order Type=CONST(Prod. Order)) "Production Order".No. WHERE (Status=FIELD(Ref. Order Status))
                                                                 ELSE IF (Ref. Order Type=CONST(Purchase)) "Purchase Header".No. WHERE (Document Type=CONST(Order))
                                                                 ELSE IF (Ref. Order Type=CONST(Transfer)) "Transfer Header".No. WHERE (No.=FIELD(Ref. Order No.))
                                                                 ELSE IF (Ref. Order Type=CONST(Assembly)) "Assembly Header".No. WHERE (Document Type=CONST(Order));
                                                   OnLookup=VAR
                                                              PurchHeader@1000 : Record 38;
                                                              ProdOrder@1001 : Record 5405;
                                                              TransHeader@1002 : Record 5740;
                                                              AsmHeader@1003 : Record 900;
                                                            BEGIN
                                                              CASE "Ref. Order Type" OF
                                                                "Ref. Order Type"::Purchase:
                                                                  IF PurchHeader.GET(PurchHeader."Document Type"::Order,"Ref. Order No.") THEN
                                                                    PAGE.RUN(PAGE::"Purchase Order",PurchHeader)
                                                                  ELSE
                                                                    MESSAGE(Text007,PurchHeader.TABLECAPTION);
                                                                "Ref. Order Type"::"Prod. Order":
                                                                  IF ProdOrder.GET("Ref. Order Status","Ref. Order No.") THEN
                                                                    CASE ProdOrder.Status OF
                                                                      ProdOrder.Status::Planned:
                                                                        PAGE.RUN(PAGE::"Planned Production Order",ProdOrder);
                                                                      ProdOrder.Status::"Firm Planned":
                                                                        PAGE.RUN(PAGE::"Firm Planned Prod. Order",ProdOrder);
                                                                      ProdOrder.Status::Released:
                                                                        PAGE.RUN(PAGE::"Released Production Order",ProdOrder);
                                                                    END
                                                                  ELSE
                                                                    MESSAGE(Text007,ProdOrder.TABLECAPTION);
                                                                "Ref. Order Type"::Transfer:
                                                                  IF TransHeader.GET("Ref. Order No.") THEN
                                                                    PAGE.RUN(PAGE::"Transfer Order",TransHeader)
                                                                  ELSE
                                                                    MESSAGE(Text007,TransHeader.TABLECAPTION);
                                                                "Ref. Order Type"::Assembly:
                                                                  IF AsmHeader.GET("Ref. Order Status","Ref. Order No.") THEN
                                                                    PAGE.RUN(PAGE::"Assembly Order",AsmHeader)
                                                                  ELSE
                                                                    MESSAGE(Text007,AsmHeader.TABLECAPTION);
                                                                ELSE
                                                                  MESSAGE(Text008);
                                                              END;
                                                            END;

                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Referenceordrenr.;
                                                              ENU=Ref. Order No.];
                                                   Editable=No }
    { 99000905;;Ref. Order Type    ;Option        ;CaptionML=[DAN=Referenceordretype;
                                                              ENU=Ref. Order Type];
                                                   OptionCaptionML=[DAN=" ,K�b,Prod. ordre,Overf�rsel,Montage";
                                                                    ENU=" ,Purchase,Prod. Order,Transfer,Assembly"];
                                                   OptionString=[ ,Purchase,Prod. Order,Transfer,Assembly];
                                                   Editable=No }
    { 99000906;;Ref. Order Status  ;Option        ;CaptionML=[DAN=Referenceordrestatus;
                                                              ENU=Ref. Order Status];
                                                   OptionCaptionML=[DAN=,Planlagt,Fastlagt,Frigivet;
                                                                    ENU=,Planned,Firm Planned,Released];
                                                   OptionString=,Planned,Firm Planned,Released;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 99000907;;Ref. Line No.      ;Integer       ;CaptionML=[DAN=Referencelinjenr.;
                                                              ENU=Ref. Line No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 99000908;;No. Series         ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 99000909;;Expected Operation Cost Amt.;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Planning Routing Line"."Expected Operation Cost Amt." WHERE (Worksheet Template Name=FIELD(Worksheet Template Name),
                                                                                                                                 Worksheet Batch Name=FIELD(Journal Batch Name),
                                                                                                                                 Worksheet Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Forventede operationsomkostninger;
                                                              ENU=Expected Operation Cost Amt.];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 99000910;;Expected Component Cost Amt.;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Planning Component"."Cost Amount" WHERE (Worksheet Template Name=FIELD(Worksheet Template Name),
                                                                                                             Worksheet Batch Name=FIELD(Journal Batch Name),
                                                                                                             Worksheet Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Forventet komponentomkostning;
                                                              ENU=Expected Component Cost Amt.];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 99000911;;Finished Qty. (Base);Decimal      ;CaptionML=[DAN=F�rdigt antal (basis);
                                                              ENU=Finished Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000912;;Remaining Qty. (Base);Decimal     ;CaptionML=[DAN=Restantal (basis);
                                                              ENU=Remaining Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000913;;Related to Planning Line;Integer  ;CaptionML=[DAN=Relateret til planl.linje;
                                                              ENU=Related to Planning Line];
                                                   Editable=No }
    { 99000914;;Planning Level     ;Integer       ;CaptionML=[DAN=Planl�gningsniveau;
                                                              ENU=Planning Level];
                                                   Editable=No }
    { 99000915;;Planning Line Origin;Option       ;CaptionML=[DAN=Oprindelig planl�gningslinje;
                                                              ENU=Planning Line Origin];
                                                   OptionCaptionML=[DAN=" ,Aktionsmeddelelse,Planl�gning,Ordreplanl�gning";
                                                                    ENU=" ,Action Message,Planning,Order Planning"];
                                                   OptionString=[ ,Action Message,Planning,Order Planning];
                                                   Editable=No }
    { 99000916;;Action Message     ;Option        ;OnValidate=BEGIN
                                                                IF ("Action Message" = xRec."Action Message") OR
                                                                   (("Action Message" IN ["Action Message"::" ","Action Message"::New]) AND
                                                                    (xRec."Action Message" IN ["Action Message"::" ","Action Message"::New]))
                                                                THEN
                                                                  EXIT;
                                                                TESTFIELD("Action Message",xRec."Action Message");
                                                              END;

                                                   CaptionML=[DAN=Aktionsmeddelelse;
                                                              ENU=Action Message];
                                                   OptionCaptionML=[DAN=" ,Ny,Ret antal,Omplanl�g,Omplanl�g & ret antal,Annuller";
                                                                    ENU=" ,New,Change Qty.,Reschedule,Resched. & Chg. Qty.,Cancel"];
                                                   OptionString=[ ,New,Change Qty.,Reschedule,Resched. & Chg. Qty.,Cancel] }
    { 99000917;;Accept Action Message;Boolean     ;OnValidate=BEGIN
                                                                IF "Action Message" = "Action Message"::" " THEN
                                                                  VALIDATE("Action Message","Action Message"::New);
                                                              END;

                                                   CaptionML=[DAN=Accepter aktionsmeddelelse;
                                                              ENU=Accept Action Message] }
    { 99000918;;Net Quantity (Base);Decimal       ;CaptionML=[DAN=Nettoantal (basis);
                                                              ENU=Net Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000919;;Starting Date-Time ;DateTime      ;OnValidate=BEGIN
                                                                "Starting Date" := DT2DATE("Starting Date-Time");
                                                                "Starting Time" := DT2TIME("Starting Date-Time");

                                                                VALIDATE("Starting Date");
                                                              END;

                                                   CaptionML=[DAN=Startdato/-tidspunkt;
                                                              ENU=Starting Date-Time] }
    { 99000920;;Ending Date-Time   ;DateTime      ;OnValidate=BEGIN
                                                                "Ending Date" := DT2DATE("Ending Date-Time");
                                                                "Ending Time" := DT2TIME("Ending Date-Time");

                                                                VALIDATE("Ending Date");
                                                              END;

                                                   CaptionML=[DAN=Slutdato/-tidspunkt;
                                                              ENU=Ending Date-Time] }
    { 99000921;;Order Promising ID ;Code20        ;CaptionML=[DAN=Id for beregn. af leveringstid;
                                                              ENU=Order Promising ID] }
    { 99000922;;Order Promising Line No.;Integer  ;CaptionML=[DAN=Linjenr. for lev.tid.beregn.;
                                                              ENU=Order Promising Line No.] }
    { 99000923;;Order Promising Line ID;Integer   ;CaptionML=[DAN=Linje-id for lev.tid.beregn.;
                                                              ENU=Order Promising Line ID] }
  }
  KEYS
  {
    {    ;Worksheet Template Name,Journal Batch Name,Line No.;
                                                   Clustered=Yes }
    {    ;Worksheet Template Name,Journal Batch Name,Vendor No.,Sell-to Customer No.,Ship-to Code,Order Address Code,Currency Code,Ref. Order Type,Ref. Order Status,Ref. Order No.,Location Code,Transfer-from Code,Purchasing Code;
                                                   MaintainSQLIndex=No }
    {    ;Type,No.,Variant Code,Location Code,Sales Order No.,Planning Line Origin,Due Date;
                                                   SumIndexFields=Quantity (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Type,No.,Variant Code,Location Code,Sales Order No.,Order Date;
                                                   SumIndexFields=Quantity (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Type,No.,Variant Code,Location Code,Starting Date;
                                                   SumIndexFields=Quantity (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Worksheet Template Name,Journal Batch Name,Type,No.,Due Date;
                                                   MaintainSQLIndex=No }
    {    ;Ref. Order Type,Ref. Order Status,Ref. Order No.,Ref. Line No. }
    {    ;Replenishment System,Type,No.,Variant Code,Transfer-from Code,Transfer Shipment Date;
                                                   SumIndexFields=Quantity (Base);
                                                   MaintainSQLIndex=No }
    {    ;Order Promising ID,Order Promising Line ID,Order Promising Line No. }
    {    ;User ID,Demand Type,Worksheet Template Name,Journal Batch Name,Line No. }
    {    ;User ID,Demand Type,Demand Subtype,Demand Order No.,Demand Line No.,Demand Ref. No. }
    {    ;User ID,Worksheet Template Name,Journal Batch Name,Line No.;
                                                   MaintainSQLIndex=No }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text004@1001 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text005@1002 : TextConst 'DAN=%1 %2 findes ikke.;ENU=%1 %2 does not exist.';
      Text006@1003 : TextConst 'DAN=Du kan ikke �ndre %1, n�r %2 er %3.;ENU=You cannot change %1 when %2 is %3.';
      Text007@1004 : TextConst 'DAN=%1 mangler for denne linje.;ENU=There is no %1 for this line.';
      Text008@1005 : TextConst 'DAN=Der findes ingen genbestillingsordre til denne linje.;ENU=There is no replenishment order for this line.';
      ReqWkshTmpl@1006 : Record 244;
      ReqWkshName@1007 : Record 245;
      ReqLine@1008 : Record 246;
      Item@1010 : Record 27;
      GLAcc@1012 : Record 15;
      Vend@1013 : Record 23;
      ItemVend@1015 : Record 99;
      ItemTranslation@1016 : Record 30;
      Cust@1017 : Record 18;
      ShipToAddr@1018 : Record 222;
      Currency@1019 : Record 4;
      CurrExchRate@1020 : Record 330;
      ReservEntry@1021 : Record 337;
      ItemVariant@1022 : Record 5401;
      WorkCenter@1023 : Record 99000754;
      TransHeader@1024 : Record 5740;
      PlanningComponent@1047 : Record 99000829;
      PlanningRtngLine@1046 : Record 99000830;
      ProdOrderCapNeed@1045 : Record 5410;
      ProdBOMHeader@1044 : Record 99000771;
      ProdBOMVersion@1043 : Record 99000779;
      RtngHeader@1042 : Record 99000763;
      RtngVersion@1041 : Record 99000786;
      MfgSetup@1040 : Record 99000765;
      Location@1056 : Record 14;
      Bin@1058 : Record 7354;
      PlanningElement@1070 : Record 99000855;
      TempPlanningErrorLog@1030 : TEMPORARY Record 5430;
      PurchPriceCalcMgt@1014 : Codeunit 7010;
      ReservEngineMgt@1031 : Codeunit 99000831;
      ReserveReqLine@1032 : Codeunit 99000833;
      UOMMgt@1033 : Codeunit 5402;
      AddOnIntegrMgt@1034 : Codeunit 5403;
      DimMgt@1035 : Codeunit 408;
      LeadTimeMgt@1038 : Codeunit 5404;
      GetPlanningParameters@1039 : Codeunit 99000855;
      VersionMgt@1048 : Codeunit 99000756;
      PlngLnMgt@1049 : Codeunit 99000809;
      WMSManagement@1057 : Codeunit 7302;
      Reservation@1009 : Page 498;
      CurrentFieldNo@1000 : Integer;
      BlockReservation@1052 : Boolean;
      Text028@1055 : TextConst 'DAN=%1 p� denne %2 skal v�re identisk med %1 p� den salgsordrelinje, som den er relateret til.;ENU=The %1 on this %2 must match the %1 on the sales order line it is associated with.';
      Subcontracting@1029 : Boolean;
      Text029@1036 : TextConst 'DAN=Linje %1 har %2, der overskrider %3.;ENU=Line %1 has a %2 that exceeds the %3.';
      Text030@1037 : TextConst 'DAN=Du kan ikke reservere komponenter med status Planlagt.;ENU=You cannot reserve components with status Planned.';
      PlanningResiliency@1063 : Boolean;
      Text031@1059 : TextConst 'DAN=%1 %2 er sp�rret.;ENU=%1 %2 is blocked.';
      Text032@1060 : TextConst 'DAN=Der er ikke defineret %3 for %1 %2.;ENU=%1 %2 has no %3 defined.';
      Text033@1068 : TextConst 'DAN=%1 %2 %3 er ikke godkendt.;ENU=%1 %2 %3 is not certified.';
      Text034@1053 : TextConst 'DAN=%1 %2 %3 %4 %5 er ikke godkendt.;ENU=%1 %2 %3 %4 %5 is not certified.';
      Text035@1071 : TextConst 'DAN=%1 %2 %3, der er angivet p� %4 %5, findes ikke.;ENU=%1 %2 %3 specified on %4 %5 does not exist.';
      Text036@1072 : TextConst 'DAN=%1 %2 %3 tillader ikke standardnummerering.;ENU=%1 %2 %3 does not allow default numbering.';
      Text037@1065 : TextConst 'DAN=Der er ikke angivet en %5 for valutakursen for %1 %2, som leverand�ren %3 bruger p� ordredatoen %4.;ENU=The currency exchange rate for the %1 %2 that vendor %3 uses on the order date %4, does not have an %5 specified.';
      Text038@1067 : TextConst 'DAN=Valutakursen for %1 %2, som leverand�ren %3 bruger p� ordredatoen %4, findes ikke.;ENU=The currency exchange rate for the %1 %2 that vendor %3 uses on the order date %4, does not exist.';
      Text039@1066 : TextConst 'DAN=Du kan ikke tildele nye numre fra nummerserien %1 p� %2.;ENU=You cannot assign new numbers from the number series %1 on %2.';
      Text040@1064 : TextConst 'DAN=Du kan ikke tildele nye numre fra nummerserien %1.;ENU=You cannot assign new numbers from the number series %1.';
      Text041@1062 : TextConst 'DAN=Du kan ikke tildele nye numre fra nummerserien %1 p� en dato f�r %2.;ENU=You cannot assign new numbers from the number series %1 on a date before %2.';
      Text042@1054 : TextConst 'DAN=Du kan ikke tildele nye numre fra nummerserien %1 linje %2, fordi %3 ikke er defineret.;ENU=You cannot assign new numbers from the number series %1 line %2 because the %3 is not defined.';
      Text043@1061 : TextConst 'DAN=Nummeret %1 p� nummerserien %2 kan ikke udvides til mere end 20 tegn.;ENU=The number %1 on number series %2 cannot be extended to more than 20 characters.';
      Text044@1069 : TextConst 'DAN=Du kan ikke tildele numre st�rre end %1 fra nummerserien %2.;ENU=You cannot assign numbers greater than %1 from the number series %2.';
      ReplenishmentErr@1073 : TextConst 'DAN=Indk�bskladden kan ikke bruges til at oprette genbestilling af produktionsordre.;ENU=Requisition Worksheet cannot be used to create Prod. Order replenishment.';
      SourceDropShipment@1026 : Boolean;

    LOCAL PROCEDURE CalcBaseQty@14(Qty@1000 : Decimal) : Decimal;
    BEGIN
      IF "Prod. Order No." = '' THEN
        TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    END;

    LOCAL PROCEDURE GetCurrency@3();
    BEGIN
      IF "Currency Code" = '' THEN BEGIN
        CLEAR(Currency);
        Currency.InitRoundingPrecision;
      END ELSE
        IF "Currency Code" <> Currency.Code THEN
          Currency.GET("Currency Code");
    END;

    LOCAL PROCEDURE GetItem@1();
    BEGIN
      TESTFIELD("No.");
      IF "No." <> Item."No." THEN
        Item.GET("No.");
    END;

    [External]
    PROCEDURE ShowReservation@4();
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      CLEAR(Reservation);
      Reservation.SetReqLine(Rec);
      Reservation.RUNMODAL;
    END;

    [External]
    PROCEDURE ShowReservationEntries@6(Modal@1000 : Boolean);
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
      ReserveReqLine.FilterReservFor(ReservEntry,Rec);
      IF Modal THEN
        PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
      ELSE
        PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    END;

    LOCAL PROCEDURE UpdateOrderReceiptDate@5(LeadTimeCalc@1000 : DateFormula);
    BEGIN
      CALCFIELDS("Reserved Qty. (Base)");
      IF "Reserved Qty. (Base)" = 0 THEN BEGIN
        IF "Order Date" <> 0D THEN
          "Starting Date" := "Order Date"
        ELSE BEGIN
          "Starting Date" := WORKDATE;
          "Order Date" := "Starting Date";
        END;
        CalcEndingDate(FORMAT(LeadTimeCalc));
        CheckEndingDate(ValidateFields);
        SetDueDate;
      END ELSE
        IF (FORMAT(LeadTimeCalc) = '') OR ("Due Date" = 0D) THEN
          "Order Date" := 0D
        ELSE
          IF "Due Date" <> 0D THEN BEGIN
            "Ending Date" :=
              LeadTimeMgt.PlannedEndingDate(
                "No.","Location Code","Variant Code","Due Date",'',"Ref. Order Type");
            CalcStartingDate(FORMAT(LeadTimeCalc));
          END;

      SetActionMessage;
      UpdateDatetime;
    END;

    [External]
    PROCEDURE LookupVendor@43(VAR Vend@1000 : Record 23;PreferItemVendorCatalog@1002 : Boolean) : Boolean;
    VAR
      LookupThroughItemVendorCatalog@1001 : Boolean;
    BEGIN
      IF (Type = Type::Item) AND ItemVend.READPERMISSION THEN BEGIN
        ItemVend.INIT;
        ItemVend.SETRANGE("Item No.","No.");
        ItemVend.SETRANGE("Vendor No.","Vendor No.");
        IF "Variant Code" <> '' THEN
          ItemVend.SETRANGE("Variant Code","Variant Code");
        IF NOT ItemVend.FINDLAST THEN BEGIN
          ItemVend."Item No." := "No.";
          ItemVend."Variant Code" := "Variant Code";
          ItemVend."Vendor No." := "Vendor No.";
        END;
        ItemVend.SETRANGE("Vendor No.");
        LookupThroughItemVendorCatalog := NOT ItemVend.ISEMPTY OR PreferItemVendorCatalog;
      END;

      IF LookupThroughItemVendorCatalog THEN BEGIN
        IF PAGE.RUNMODAL(0,ItemVend) = ACTION::LookupOK THEN
          EXIT(Vend.GET(ItemVend."Vendor No."));
      END ELSE BEGIN
        Vend."No." := "Vendor No.";
        EXIT(PAGE.RUNMODAL(0,Vend) = ACTION::LookupOK);
      END;
    END;

    LOCAL PROCEDURE LookupFromLocation@44(VAR Location@1001 : Record 14) : Boolean;
    BEGIN
      Location.Code := "Transfer-from Code";
      Location.SETRANGE("Use As In-Transit",FALSE);
      EXIT(PAGE.RUNMODAL(0,Location) = ACTION::LookupOK);
    END;

    PROCEDURE UpdateDescription@8();
    VAR
      ItemCrossRef@1001 : Record 5717;
      SalesLine@1000 : Record 37;
    BEGIN
      IF (Type <> Type::Item) OR ("No." = '') THEN
        EXIT;
      IF "Variant Code" = '' THEN BEGIN
        GetItem;
        Description := Item.Description;
        "Description 2" := Item."Description 2";
      END ELSE BEGIN
        ItemVariant.GET("No.","Variant Code");
        Description := ItemVariant.Description;
        "Description 2" := ItemVariant."Description 2";
      END;

      IF SalesLine.GET(SalesLine."Document Type"::Order,"Sales Order No.","Sales Order Line No.") THEN BEGIN
        Description := SalesLine.Description;
        "Description 2" := SalesLine."Description 2";
      END;

      IF "Vendor No." <> '' THEN
        IF ItemCrossRef.GetItemDescription(
             Description,"No.","Variant Code","Unit of Measure Code",ItemCrossRef."Cross-Reference Type"::Vendor,"Vendor No.")
        THEN
          "Description 2" := ''
        ELSE BEGIN
          Vend.GET("Vendor No.");
          IF Vend."Language Code" <> '' THEN
            IF ItemTranslation.GET("No.","Variant Code",Vend."Language Code") THEN BEGIN
              Description := ItemTranslation.Description;
              "Description 2" := ItemTranslation."Description 2";
            END;
        END;
    END;

    [External]
    PROCEDURE BlockDynamicTracking@17(SetBlock@1000 : Boolean);
    BEGIN
      ReserveReqLine.Block(SetBlock);
    END;

    [External]
    PROCEDURE BlockDynamicTrackingOnComp@29(SetBlock@1000 : Boolean);
    BEGIN
      BlockReservation := SetBlock;
    END;

    LOCAL PROCEDURE CreateDim@2(Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20]);
    VAR
      SourceCodeSetup@1004 : Record 242;
      TableID@1005 : ARRAY [10] OF Integer;
      No@1006 : ARRAY [10] OF Code[20];
    BEGIN
      SourceCodeSetup.GET;
      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup.Purchases,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);

      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");

      IF "Ref. Order No." <> '' THEN
        GetDimFromRefOrderLine(TRUE);

      OnAfterCreateDim(Rec,xRec);
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@9(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE LookupShortcutDimCode@10(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE ShowShortcutDimCode@11(VAR ShortcutDimCode@1000 : ARRAY [8] OF Code[20]);
    BEGIN
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    END;

    [External]
    PROCEDURE OpenItemTrackingLines@6500();
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      TESTFIELD("Quantity (Base)");
      ReserveReqLine.CallItemTracking(Rec);
    END;

    [External]
    PROCEDURE DeleteRelations@35();
    BEGIN
      IF Type <> Type::Item THEN
        EXIT;
      PlanningComponent.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      PlanningComponent.SETRANGE("Worksheet Batch Name","Journal Batch Name");
      PlanningComponent.SETRANGE("Worksheet Line No.","Line No.");
      IF PlanningComponent.FIND('-') THEN
        REPEAT
          PlanningComponent.BlockDynamicTracking(BlockReservation);
          PlanningComponent.DELETE(TRUE);
        UNTIL PlanningComponent.NEXT = 0;

      PlanningRtngLine.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      PlanningRtngLine.SETRANGE("Worksheet Batch Name","Journal Batch Name");
      PlanningRtngLine.SETRANGE("Worksheet Line No.","Line No.");
      IF PlanningRtngLine.FINDFIRST THEN
        PlanningRtngLine.DELETEALL;

      ProdOrderCapNeed.RESET;
      ProdOrderCapNeed.SETCURRENTKEY("Worksheet Template Name","Worksheet Batch Name","Worksheet Line No.");
      ProdOrderCapNeed.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      ProdOrderCapNeed.SETRANGE("Worksheet Batch Name","Journal Batch Name");
      ProdOrderCapNeed.SETRANGE("Worksheet Line No.","Line No.");
      IF ProdOrderCapNeed.FINDFIRST THEN
        ProdOrderCapNeed.DELETEALL;
      ProdOrderCapNeed.RESET;
      ProdOrderCapNeed.SETCURRENTKEY(Status,"Prod. Order No.",Active);
      ProdOrderCapNeed.SETRANGE(Status,"Ref. Order Status");
      ProdOrderCapNeed.SETRANGE("Prod. Order No.","Ref. Order No.");
      ProdOrderCapNeed.SETRANGE(Active,FALSE);
      IF ProdOrderCapNeed.FINDFIRST THEN
        ProdOrderCapNeed.MODIFYALL(Active,TRUE);

      PlanningElement.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      PlanningElement.SETRANGE("Worksheet Batch Name","Journal Batch Name");
      PlanningElement.SETRANGE("Worksheet Line No.","Line No.");
      IF NOT PlanningElement.ISEMPTY THEN
        PlanningElement.DELETEALL;
    END;

    [External]
    PROCEDURE DeleteMultiLevel@34();
    VAR
      ReqLine2@1000 : Record 246;
    BEGIN
      ReqLine2.SETCURRENTKEY("Ref. Order Type","Ref. Order Status","Ref. Order No.","Ref. Line No.");
      ReqLine2.SETRANGE("Ref. Order Type","Ref. Order Type");
      ReqLine2.SETRANGE("Ref. Order Status","Ref. Order Status");
      ReqLine2.SETRANGE("Ref. Order No.","Ref. Order No.");
      ReqLine2.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      ReqLine2.SETRANGE("Journal Batch Name","Journal Batch Name");
      ReqLine2.SETFILTER("Line No.",'<>%1',"Line No.");
      ReqLine2.SETFILTER("Planning Level",'>0');
      IF ReqLine2.FIND('-') THEN
        REPEAT
          ReserveReqLine.DeleteLine(ReqLine2);
          ReqLine2.CALCFIELDS("Reserved Qty. (Base)");
          ReqLine2.TESTFIELD("Reserved Qty. (Base)",0);
          ReqLine2.DeleteRelations;
          ReqLine2.DELETE;
        UNTIL ReqLine2.NEXT = 0;
    END;

    [External]
    PROCEDURE SetUpNewLine@32(LastReqLine@1000 : Record 246);
    BEGIN
      ReqWkshTmpl.GET("Worksheet Template Name");
      ReqWkshName.GET("Worksheet Template Name","Journal Batch Name");
      ReqLine.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      ReqLine.SETRANGE("Journal Batch Name","Journal Batch Name");
      IF ReqLine.FIND('-') THEN BEGIN
        "Order Date" := LastReqLine."Order Date";
      END ELSE
        "Order Date" := WORKDATE;

      "Recurring Method" := LastReqLine."Recurring Method";
    END;

    LOCAL PROCEDURE CheckEndingDate@26(ShowWarning@1000 : Boolean);
    VAR
      CheckDateConflict@1001 : Codeunit 99000815;
    BEGIN
      CheckDateConflict.ReqLineCheck(Rec,ShowWarning);
      ReserveReqLine.VerifyChange(Rec,xRec);
    END;

    [External]
    PROCEDURE SetDueDate@25();
    BEGIN
      IF "Ending Date" = 0D THEN
        EXIT;
      IF (Type = Type::Item) AND
         ("Planning Level" = 0)
      THEN
        "Due Date" :=
          LeadTimeMgt.PlannedDueDate("No.","Location Code","Variant Code","Ending Date",'',"Ref. Order Type")
      ELSE
        "Due Date" := "Ending Date";

      CheckDueDateToDemandDate;
    END;

    [External]
    PROCEDURE SetCurrFieldNo@63(NewCurrFieldNo@1000 : Integer);
    BEGIN
      CurrentFieldNo := NewCurrFieldNo;
    END;

    LOCAL PROCEDURE CheckDueDateToDemandDate@41();
    BEGIN
      IF ("Planning Line Origin" = "Planning Line Origin"::"Order Planning") AND
         ("Due Date" > "Demand Date") AND
         ("Demand Date" <> 0D) AND
         ValidateFields
      THEN
        MESSAGE(Text029,"Line No.",FIELDCAPTION("Due Date"),FIELDCAPTION("Demand Date"));
    END;

    LOCAL PROCEDURE CheckActionMessageNew@24();
    BEGIN
      IF "Action Message" <> "Action Message"::" " THEN
        IF CurrFieldNo IN [FIELDNO(Type),
                           FIELDNO("No."),
                           FIELDNO("Variant Code"),
                           FIELDNO("Location Code"),
                           FIELDNO("Bin Code"),
                           FIELDNO("Production BOM Version Code"),
                           FIELDNO("Routing Version Code"),
                           FIELDNO("Production BOM No."),
                           FIELDNO("Routing No."),
                           FIELDNO("Replenishment System"),
                           FIELDNO("Unit of Measure Code"),
                           FIELDNO("Vendor No."),
                           FIELDNO("Transfer-from Code")]
        THEN
          TESTFIELD("Action Message","Action Message"::New);
    END;

    [External]
    PROCEDURE SetActionMessage@23();
    BEGIN
      IF ValidateFields AND
         ("Action Message" <> "Action Message"::" ") AND
         ("Action Message" <> "Action Message"::New)
      THEN BEGIN
        IF (Quantity <> xRec.Quantity) AND ("Original Quantity" = 0) THEN
          "Original Quantity" := xRec.Quantity;
        IF ("Due Date" <> xRec."Due Date") AND ("Original Due Date" = 0D) THEN
          "Original Due Date" := xRec."Due Date";
        IF Quantity = 0 THEN
          "Action Message" := "Action Message"::Cancel
        ELSE
          IF "Original Quantity" <> 0 THEN
            IF "Original Due Date" <> 0D THEN
              "Action Message" := "Action Message"::"Resched. & Chg. Qty."
            ELSE
              "Action Message" := "Action Message"::"Change Qty."
          ELSE
            IF "Original Due Date" <> 0D THEN
              "Action Message" := "Action Message"::Reschedule;

        IF "Action Message" <> xRec."Action Message" THEN
          CLEAR("Planning Line Origin");
      END;
    END;

    LOCAL PROCEDURE ValidateFields@65() : Boolean;
    BEGIN
      EXIT((CurrFieldNo <> 0) OR (CurrentFieldNo <> 0));
    END;

    [External]
    PROCEDURE GetProdOrderLine@22(ProdOrderLine@1000 : Record 5406);
    VAR
      ProdOrder@1001 : Record 5405;
    BEGIN
      ProdOrderLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
      ProdOrder.GET(ProdOrderLine.Status,ProdOrderLine."Prod. Order No.");
      Item.GET(ProdOrderLine."Item No.");

      TransferFromProdOrderLine(ProdOrderLine);
    END;

    [External]
    PROCEDURE GetPurchOrderLine@21(PurchOrderLine@1000 : Record 39);
    VAR
      PurchHeader2@1001 : Record 38;
    BEGIN
      IF PurchOrderLine.Type <> PurchOrderLine.Type::Item THEN
        EXIT;
      PurchOrderLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
      PurchHeader2.GET(PurchOrderLine."Document Type",PurchOrderLine."Document No.");
      Item.GET(PurchOrderLine."No.");

      TransferFromPurchaseLine(PurchOrderLine);
    END;

    [External]
    PROCEDURE GetTransLine@27(TransLine@1000 : Record 5741);
    BEGIN
      TransLine.CALCFIELDS(
        "Reserved Quantity Inbnd.",
        "Reserved Quantity Outbnd.",
        "Reserved Qty. Inbnd. (Base)",
        "Reserved Qty. Outbnd. (Base)");
      TransHeader.GET(TransLine."Document No.");
      Item.GET(TransLine."Item No.");

      TransferFromTransLine(TransLine);
    END;

    [External]
    PROCEDURE GetAsmHeader@54(AsmHeader@1000 : Record 900);
    VAR
      AsmHeader2@1001 : Record 900;
    BEGIN
      AsmHeader.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
      AsmHeader2.GET(AsmHeader."Document Type",AsmHeader."No.");
      Item.GET(AsmHeader."Item No.");

      TransferFromAsmHeader(AsmHeader);
    END;

    [External]
    PROCEDURE GetActionMessages@19();
    VAR
      GetActionMsgReport@1000 : Report 99001023;
    BEGIN
      GetActionMsgReport.SetTemplAndWorksheet("Worksheet Template Name","Journal Batch Name");
      GetActionMsgReport.RUNMODAL;
    END;

    [External]
    PROCEDURE SetRefFilter@61(RefOrderType@1000 : Option;RefOrderStatus@1001 : Option;RefOrderNo@1002 : Code[20];RefLineNo@1003 : Integer);
    BEGIN
      SETCURRENTKEY("Ref. Order Type","Ref. Order Status","Ref. Order No.","Ref. Line No.");
      SETRANGE("Ref. Order Type",RefOrderType);
      SETRANGE("Ref. Order Status",RefOrderStatus);
      SETRANGE("Ref. Order No.",RefOrderNo);
      SETRANGE("Ref. Line No.",RefLineNo);
    END;

    [External]
    PROCEDURE TransferFromProdOrderLine@18(VAR ProdOrderLine@1000 : Record 5406);
    VAR
      ProdOrder@1001 : Record 5405;
    BEGIN
      ProdOrder.GET(ProdOrderLine.Status,ProdOrderLine."Prod. Order No.");

      Type := Type::Item;
      "No." := ProdOrderLine."Item No.";
      "Variant Code" := ProdOrderLine."Variant Code";
      Description := ProdOrderLine.Description;
      "Description 2" := ProdOrderLine."Description 2";
      "Location Code" := ProdOrderLine."Location Code";
      "Dimension Set ID" := ProdOrderLine."Dimension Set ID";
      "Shortcut Dimension 1 Code" := ProdOrderLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := ProdOrderLine."Shortcut Dimension 2 Code";
      "Bin Code" := ProdOrderLine."Bin Code";
      "Gen. Prod. Posting Group" := ProdOrder."Gen. Prod. Posting Group";
      "Gen. Business Posting Group" := ProdOrder."Gen. Bus. Posting Group";
      "Scrap %" := ProdOrderLine."Scrap %";
      "Order Date" := ProdOrder."Creation Date";
      "Starting Time" := ProdOrderLine."Starting Time";
      "Starting Date" := ProdOrderLine."Starting Date";
      "Ending Time" := ProdOrderLine."Ending Time";
      "Ending Date" := ProdOrderLine."Ending Date";
      "Due Date" := ProdOrderLine."Due Date";
      "Production BOM No." := ProdOrderLine."Production BOM No.";
      "Routing No." := ProdOrderLine."Routing No.";
      "Production BOM Version Code" := ProdOrderLine."Production BOM Version Code";
      "Routing Version Code" := ProdOrderLine."Routing Version Code";
      "Routing Type" := ProdOrderLine."Routing Type";
      "Replenishment System" := "Replenishment System"::"Prod. Order";
      Quantity := ProdOrderLine.Quantity;
      "Finished Quantity" := ProdOrderLine."Finished Quantity";
      "Remaining Quantity" := ProdOrderLine."Remaining Quantity";
      "Unit Cost" := ProdOrderLine."Unit Cost";
      "Cost Amount" := ProdOrderLine."Cost Amount";
      "Low-Level Code" := ProdOrder."Low-Level Code";
      "Planning Level" := ProdOrderLine."Planning Level Code";
      "Unit of Measure Code" := ProdOrderLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := ProdOrderLine."Qty. per Unit of Measure";
      "Quantity (Base)" := ProdOrderLine."Quantity (Base)";
      "Finished Qty. (Base)" := ProdOrderLine."Finished Qty. (Base)";
      "Remaining Qty. (Base)" := ProdOrderLine."Remaining Qty. (Base)";
      "Indirect Cost %" := ProdOrderLine."Indirect Cost %";
      "Overhead Rate" := ProdOrderLine."Overhead Rate";
      "Expected Operation Cost Amt." := ProdOrderLine."Expected Operation Cost Amt.";
      "Expected Component Cost Amt." := ProdOrderLine."Expected Component Cost Amt.";
      "MPS Order" := ProdOrderLine."MPS Order";
      "Planning Flexibility" := ProdOrderLine."Planning Flexibility";
      "Ref. Order No." := ProdOrderLine."Prod. Order No.";
      "Ref. Order Type" := "Ref. Order Type"::"Prod. Order";
      "Ref. Order Status" := ProdOrderLine.Status;
      "Ref. Line No." := ProdOrderLine."Line No.";

      GetDimFromRefOrderLine(FALSE);
    END;

    [External]
    PROCEDURE TransferFromPurchaseLine@15(VAR PurchLine@1000 : Record 39);
    VAR
      PurchHeader@1001 : Record 38;
    BEGIN
      PurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.");
      Item.GET(PurchLine."No.");

      Type := Type::Item;
      "No." := PurchLine."No.";
      "Variant Code" := PurchLine."Variant Code";
      Description := PurchLine.Description;
      "Description 2" := PurchLine."Description 2";
      "Location Code" := PurchLine."Location Code";
      "Dimension Set ID" := PurchLine."Dimension Set ID";
      "Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
      "Bin Code" := PurchLine."Bin Code";
      "Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
      "Gen. Business Posting Group" := PurchLine."Gen. Bus. Posting Group";
      "Low-Level Code" := Item."Low-Level Code";
      "Order Date" := PurchHeader."Order Date";
      "Starting Date" := "Order Date";
      "Ending Date" := PurchLine."Planned Receipt Date";
      "Due Date" := PurchLine."Expected Receipt Date";
      Quantity := PurchLine.Quantity;
      "Finished Quantity" := PurchLine."Quantity Received";
      "Remaining Quantity" := PurchLine."Outstanding Quantity";
      BlockDynamicTracking(TRUE);
      VALIDATE("Unit Cost",PurchLine."Unit Cost (LCY)");
      BlockDynamicTracking(FALSE);
      "Indirect Cost %" := PurchLine."Indirect Cost %";
      "Overhead Rate" := PurchLine."Overhead Rate";
      "Unit of Measure Code" := PurchLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := PurchLine."Qty. per Unit of Measure";
      "Quantity (Base)" := PurchLine."Quantity (Base)";
      "Finished Qty. (Base)" := PurchLine."Qty. Received (Base)";
      "Remaining Qty. (Base)" := PurchLine."Outstanding Qty. (Base)";
      "Routing No." := PurchLine."Routing No.";
      "Replenishment System" := "Replenishment System"::Purchase;
      "MPS Order" := PurchLine."MPS Order";
      "Planning Flexibility" := PurchLine."Planning Flexibility";
      "Ref. Order No." := PurchLine."Document No.";
      "Ref. Order Type" := "Ref. Order Type"::Purchase;
      "Ref. Line No." := PurchLine."Line No.";
      "Vendor No." := PurchLine."Buy-from Vendor No.";

      GetDimFromRefOrderLine(FALSE);
    END;

    [External]
    PROCEDURE TransferFromAsmHeader@52(VAR AsmHeader@1000 : Record 900);
    BEGIN
      Item.GET(AsmHeader."Item No.");

      Type := Type::Item;
      "No." := AsmHeader."Item No.";
      "Variant Code" := AsmHeader."Variant Code";
      Description := AsmHeader.Description;
      "Description 2" := AsmHeader."Description 2";
      "Location Code" := AsmHeader."Location Code";
      "Dimension Set ID" := AsmHeader."Dimension Set ID";
      "Shortcut Dimension 1 Code" := AsmHeader."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := AsmHeader."Shortcut Dimension 2 Code";
      "Bin Code" := AsmHeader."Bin Code";
      "Gen. Prod. Posting Group" := AsmHeader."Gen. Prod. Posting Group";
      "Low-Level Code" := Item."Low-Level Code";
      "Order Date" := AsmHeader."Due Date";
      "Starting Date" := "Order Date";
      "Ending Date" := AsmHeader."Due Date";
      "Due Date" := AsmHeader."Due Date";
      Quantity := AsmHeader.Quantity;
      "Finished Quantity" := AsmHeader."Assembled Quantity";
      "Remaining Quantity" := AsmHeader."Remaining Quantity";
      BlockDynamicTracking(TRUE);
      VALIDATE("Unit Cost",AsmHeader."Unit Cost");
      BlockDynamicTracking(FALSE);
      "Indirect Cost %" := AsmHeader."Indirect Cost %";
      "Overhead Rate" := AsmHeader."Overhead Rate";
      "Unit of Measure Code" := AsmHeader."Unit of Measure Code";
      "Qty. per Unit of Measure" := AsmHeader."Qty. per Unit of Measure";
      "Quantity (Base)" := AsmHeader."Quantity (Base)";
      "Finished Qty. (Base)" := AsmHeader."Assembled Quantity (Base)";
      "Remaining Qty. (Base)" := AsmHeader."Remaining Quantity (Base)";
      "Replenishment System" := "Replenishment System"::Assembly;
      "MPS Order" := AsmHeader."MPS Order";
      "Planning Flexibility" := AsmHeader."Planning Flexibility";
      "Ref. Order Type" := "Ref. Order Type"::Assembly;
      "Ref. Order Status" := AsmHeader."Document Type";
      "Ref. Order No." := AsmHeader."No.";
      "Ref. Line No." := 0;

      GetDimFromRefOrderLine(FALSE);
    END;

    [External]
    PROCEDURE TransferFromTransLine@28(VAR TransLine@1000 : Record 5741);
    BEGIN
      TransHeader.GET(TransLine."Document No.");
      Item.GET(TransLine."Item No.");
      Type := Type::Item;
      "No." := TransLine."Item No.";
      "Variant Code" := TransLine."Variant Code";
      Description := TransLine.Description;
      "Description 2" := TransLine."Description 2";
      "Location Code" := TransLine."Transfer-to Code";
      "Dimension Set ID" := TransLine."Dimension Set ID";
      "Shortcut Dimension 1 Code" := TransLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := TransLine."Shortcut Dimension 2 Code";
      "Gen. Prod. Posting Group" := TransLine."Gen. Prod. Posting Group";
      "Low-Level Code" := Item."Low-Level Code";
      "Starting Date" := CALCDATE(TransLine."Outbound Whse. Handling Time",TransLine."Shipment Date");
      "Ending Date" := CALCDATE(TransLine."Shipping Time","Starting Date");
      "Due Date" := TransLine."Receipt Date";
      Quantity := TransLine.Quantity;
      "Finished Quantity" := TransLine."Quantity Received";
      "Remaining Quantity" := TransLine."Outstanding Quantity";
      BlockDynamicTracking(FALSE);
      "Unit of Measure Code" := TransLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
      "Quantity (Base)" := TransLine."Quantity (Base)";
      "Finished Qty. (Base)" := TransLine."Qty. Received (Base)";
      "Remaining Qty. (Base)" := TransLine."Outstanding Qty. (Base)";
      "Replenishment System" := "Replenishment System"::Transfer;
      "Ref. Order No." := TransLine."Document No.";
      "Ref. Order Type" := "Ref. Order Type"::Transfer;
      "Ref. Line No." := TransLine."Line No.";
      "Transfer-from Code" := TransLine."Transfer-from Code";
      "Transfer Shipment Date" := TransLine."Shipment Date";
      GetDimFromRefOrderLine(FALSE);
    END;

    [External]
    PROCEDURE GetDimFromRefOrderLine@30(AddToExisting@1000 : Boolean);
    VAR
      PurchLine@1001 : Record 39;
      ProdOrderLine@1002 : Record 5406;
      TransferLine@1003 : Record 5741;
      AsmHeader@1006 : Record 900;
      DimSetIDArr@1004 : ARRAY [10] OF Integer;
      i@1005 : Integer;
    BEGIN
      IF AddToExisting THEN BEGIN
        i := 1;
        DimSetIDArr[i] := "Dimension Set ID";
      END;
      i := i + 1;

      CASE "Ref. Order Type" OF
        "Ref. Order Type"::Purchase:
          BEGIN
            IF PurchLine.GET(PurchLine."Document Type"::Order,"Ref. Order No.","Ref. Line No.") THEN
              DimSetIDArr[i] := PurchLine."Dimension Set ID"
          END;
        "Ref. Order Type"::"Prod. Order":
          BEGIN
            IF ProdOrderLine.GET("Ref. Order Status","Ref. Order No.","Ref. Line No.") THEN
              DimSetIDArr[i] := ProdOrderLine."Dimension Set ID"
          END;
        "Ref. Order Type"::Transfer:
          BEGIN
            IF TransferLine.GET("Ref. Order No.","Ref. Line No.") THEN
              DimSetIDArr[i] := TransferLine."Dimension Set ID"
          END;
        "Ref. Order Type"::Assembly:
          BEGIN
            IF AsmHeader.GET(AsmHeader."Document Type"::Order,"Ref. Order No.") THEN
              DimSetIDArr[i] := AsmHeader."Dimension Set ID"
          END;
      END;
      "Dimension Set ID" := DimMgt.GetCombinedDimensionSetID(DimSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE TransferFromActionMessage@13(VAR ActionMessageEntry@1000 : Record 99000849);
    VAR
      ReservEntry@1001 : Record 337;
      EndDate@1002 : Date;
    BEGIN
      IF NOT ReservEntry.GET(ActionMessageEntry."Reservation Entry",TRUE) THEN
        ReservEntry.GET(ActionMessageEntry."Reservation Entry",FALSE);
      BlockDynamicTracking(TRUE);
      Type := Type::Item;
      VALIDATE("No.",ReservEntry."Item No.");
      BlockDynamicTracking(FALSE);
      VALIDATE("Variant Code",ReservEntry."Variant Code");
      VALIDATE("Location Code",ReservEntry."Location Code");
      Description := ReservEntry.Description;

      IF ReservEntry.Positive THEN
        EndDate := ReservEntry."Expected Receipt Date"
      ELSE
        EndDate := ReservEntry."Shipment Date";

      IF EndDate <> 0D THEN
        "Due Date" := EndDate
      ELSE
        "Due Date" := WORKDATE;

      CASE ReservEntry."Source Type" OF
        DATABASE::"Transfer Line",
        DATABASE::"Prod. Order Line",
        DATABASE::"Purchase Line",
        DATABASE::"Requisition Line",
        DATABASE::"Assembly Header":
          "Ending Date" :=
            LeadTimeMgt.PlannedEndingDate(
              ReservEntry."Item No.",
              ReservEntry."Location Code",
              ReservEntry."Variant Code",
              "Due Date",
              "Vendor No.",
              "Ref. Order Type");
      END;
    END;

    [External]
    PROCEDURE TransferToTrackingEntry@16(VAR TrkgReservEntry@1000 : Record 337;PointerOnly@1001 : Boolean);
    BEGIN
      TrkgReservEntry."Source Type" := DATABASE::"Requisition Line";
      TrkgReservEntry."Source Subtype" := 0;
      TrkgReservEntry."Source ID" := "Worksheet Template Name";
      TrkgReservEntry."Source Batch Name" := "Journal Batch Name";
      TrkgReservEntry."Source Prod. Order Line" := 0;
      TrkgReservEntry."Source Ref. No." := "Line No.";

      IF PointerOnly THEN
        EXIT;
      TrkgReservEntry."Item No." := "No.";
      TrkgReservEntry."Location Code" := "Location Code";
      TrkgReservEntry.Description := '';
      TrkgReservEntry."Creation Date" := TODAY;
      TrkgReservEntry."Created By" := USERID;
      TrkgReservEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
      TrkgReservEntry."Variant Code" := "Variant Code";
      CALCFIELDS("Reserved Quantity");
      TrkgReservEntry.Quantity := "Remaining Quantity" - "Reserved Quantity";
      TrkgReservEntry."Quantity (Base)" := TrkgReservEntry.Quantity * TrkgReservEntry."Qty. per Unit of Measure";

      TrkgReservEntry.Positive := TrkgReservEntry."Quantity (Base)" > 0;

      IF "Planning Level" > 0 THEN
        TrkgReservEntry."Reservation Status" := TrkgReservEntry."Reservation Status"::Reservation
      ELSE
        TrkgReservEntry."Reservation Status" := TrkgReservEntry."Reservation Status"::Tracking;

      IF TrkgReservEntry.Positive THEN
        TrkgReservEntry."Expected Receipt Date" := "Due Date"
      ELSE
        TrkgReservEntry."Shipment Date" := "Due Date";
    END;

    [External]
    PROCEDURE UpdateDatetime@20();
    BEGIN
      "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time");
      "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
    END;

    LOCAL PROCEDURE GetDirectCost@12(CalledByFieldNo@1000 : Integer);
    BEGIN
      GetWorkCenter;
      IF ("Replenishment System" = "Replenishment System"::Purchase) AND NOT Subcontracting THEN BEGIN
        PurchPriceCalcMgt.FindReqLineDisc(Rec);
        PurchPriceCalcMgt.FindReqLinePrice(Rec,CalledByFieldNo);
      END;
    END;

    LOCAL PROCEDURE ValidateLocationChange@33();
    VAR
      Purchasing@1000 : Record 5721;
      SalesOrderLine@1001 : Record 37;
    BEGIN
      CASE TRUE OF
        "Location Code" = xRec."Location Code":
          EXIT;
        "Purchasing Code" = '':
          EXIT;
        NOT Purchasing.GET("Purchasing Code"):
          EXIT;
        NOT Purchasing."Special Order":
          EXIT;
        NOT SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Sales Order No.","Sales Order Line No."):
          EXIT;
        "Location Code" = SalesOrderLine."Location Code":
          EXIT;
      END;

      ERROR(Text028,FIELDCAPTION("Location Code"),TABLECAPTION);
    END;

    [External]
    PROCEDURE RowID1@49() : Text[250];
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;
    BEGIN
      EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Requisition Line",0,"Worksheet Template Name",
          "Journal Batch Name",0,"Line No."));
    END;

    [External]
    PROCEDURE CalcEndingDate@37(LeadTime@1000 : Code[20]);
    BEGIN
      CASE "Ref. Order Type" OF
        "Ref. Order Type"::Purchase:
          IF LeadTime = '' THEN
            LeadTime := LeadTimeMgt.PurchaseLeadTime("No.","Location Code","Variant Code","Vendor No.");
        "Ref. Order Type"::"Prod. Order",
        "Ref. Order Type"::Assembly:
          BEGIN
            IF RoutingLineExists THEN
              EXIT;

            IF LeadTime = '' THEN
              LeadTime := LeadTimeMgt.ManufacturingLeadTime("No.","Location Code","Variant Code");
          END;
        "Ref. Order Type"::Transfer:
          CalcTransferShipmentDate;
        ELSE
          EXIT;
      END;

      "Ending Date" :=
        LeadTimeMgt.PlannedEndingDate2(
          "No.","Location Code","Variant Code","Vendor No.",LeadTime,"Ref. Order Type","Starting Date");
    END;

    [External]
    PROCEDURE CalcStartingDate@51(LeadTime@1000 : Code[20]);
    BEGIN
      CASE "Ref. Order Type" OF
        "Ref. Order Type"::Purchase:
          IF LeadTime = '' THEN
            LeadTime :=
              LeadTimeMgt.PurchaseLeadTime(
                "No.","Location Code","Variant Code","Vendor No.");
        "Ref. Order Type"::"Prod. Order",
        "Ref. Order Type"::Assembly:
          BEGIN
            IF RoutingLineExists THEN
              EXIT;

            IF LeadTime = '' THEN
              LeadTime := LeadTimeMgt.ManufacturingLeadTime("No.","Location Code","Variant Code");
          END;
        "Ref. Order Type"::" ":
          EXIT;
      END;

      "Starting Date" :=
        LeadTimeMgt.PlannedStartingDate(
          "No.","Location Code","Variant Code","Vendor No.",LeadTime,"Ref. Order Type","Ending Date");

      VALIDATE("Order Date","Starting Date");

      IF "Ref. Order Type" = "Ref. Order Type"::Transfer THEN
        CalcTransferShipmentDate;
    END;

    LOCAL PROCEDURE CalcTransferShipmentDate@31();
    VAR
      TransferRoute@1001 : Record 5742;
      DateFormula@1000 : DateFormula;
    BEGIN
      EVALUATE(DateFormula,LeadTimeMgt.WhseOutBoundHandlingTime("Transfer-from Code"));
      TransferRoute.CalcShipmentDateBackward("Transfer Shipment Date","Starting Date",DateFormula,"Transfer-from Code");
    END;

    LOCAL PROCEDURE GetLocation@7300(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        CLEAR(Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE GetBin@7301(LocationCode@1000 : Code[10];BinCode@1001 : Code[20]);
    BEGIN
      IF BinCode = '' THEN
        CLEAR(Bin)
      ELSE
        IF Bin.Code <> BinCode THEN
          Bin.GET(LocationCode,BinCode);
    END;

    [External]
    PROCEDURE SetSubcontracting@38(IsSubcontracting@1000 : Boolean);
    BEGIN
      Subcontracting := IsSubcontracting;
    END;

    [External]
    PROCEDURE TransferFromUnplannedDemand@46(VAR UnplannedDemand@1000 : Record 5520);
    BEGIN
      INIT;
      "Line No." := "Line No." + 10000;
      "Planning Line Origin" := "Planning Line Origin"::"Order Planning";

      Type := Type::Item;
      "No." := UnplannedDemand."Item No.";
      "Location Code" := UnplannedDemand."Location Code";
      "Bin Code" := UnplannedDemand."Bin Code";
      VALIDATE("No.");
      VALIDATE("Variant Code",UnplannedDemand."Variant Code");
      UpdateDescription;
      "Unit Of Measure Code (Demand)" := UnplannedDemand."Unit of Measure Code";
      "Qty. per UOM (Demand)" := UnplannedDemand."Qty. per Unit of Measure";
      Reserve := UnplannedDemand.Reserve;

      CASE UnplannedDemand."Demand Type" OF
        UnplannedDemand."Demand Type"::Sales:
          "Demand Type" := DATABASE::"Sales Line";
        UnplannedDemand."Demand Type"::Production:
          "Demand Type" := DATABASE::"Prod. Order Component";
        UnplannedDemand."Demand Type"::Service:
          "Demand Type" := DATABASE::"Service Line";
        UnplannedDemand."Demand Type"::Job:
          "Demand Type" := DATABASE::"Job Planning Line";
        UnplannedDemand."Demand Type"::Assembly:
          "Demand Type" := DATABASE::"Assembly Line";
      END;
      "Demand Subtype" := UnplannedDemand."Demand SubType";
      "Demand Order No." := UnplannedDemand."Demand Order No.";
      "Demand Line No." := UnplannedDemand."Demand Line No.";
      "Demand Ref. No." := UnplannedDemand."Demand Ref. No.";

      Status := UnplannedDemand.Status;

      Level := 1;
      "Action Message" := ReqLine."Action Message"::New;
      "User ID" := USERID;
    END;

    [External]
    PROCEDURE SetSupplyDates@45(DemandDate@1000 : Date);
    VAR
      LeadTimeMgt@1001 : Codeunit 5404;
    BEGIN
      "Demand Date" := DemandDate;
      "Starting Date" := "Demand Date";
      "Order Date" := "Demand Date";
      VALIDATE("Due Date","Demand Date");

      IF "Planning Level" = 0 THEN BEGIN
        VALIDATE(
          "Ending Date",
          LeadTimeMgt.PlannedEndingDate(
            "No.","Location Code","Variant Code","Due Date",'',"Ref. Order Type"));
        IF ("Replenishment System" = "Replenishment System"::"Prod. Order") AND ("Starting Time" = 0T) THEN BEGIN
          MfgSetup.GET;
          "Starting Time" := MfgSetup."Normal Starting Time";
        END;
      END ELSE BEGIN
        VALIDATE("Ending Date","Due Date");
        VALIDATE("Ending Time",0T);
      END;
    END;

    [External]
    PROCEDURE SetSupplyQty@42(DemandQtyBase@1002 : Decimal;NeededQtyBase@1001 : Decimal);
    BEGIN
      IF "Qty. per Unit of Measure" = 0 THEN
        "Qty. per Unit of Measure" := 1;

      "Demand Quantity" := ROUND(DemandQtyBase / "Qty. per Unit of Measure",0.00001);
      "Demand Quantity (Base)" := DemandQtyBase;
      "Needed Quantity" := ROUND(NeededQtyBase / "Qty. per Unit of Measure",0.00001);
      IF "Needed Quantity" < NeededQtyBase / "Qty. per Unit of Measure" THEN
        "Needed Quantity" := ROUND(NeededQtyBase / "Qty. per Unit of Measure",0.00001,'>');
      "Needed Quantity (Base)" := NeededQtyBase;
      "Demand Qty. Available" :=
        ROUND((DemandQtyBase - NeededQtyBase) / "Qty. per Unit of Measure",0.00001);
      VALIDATE(Quantity,"Needed Quantity");
    END;

    [External]
    PROCEDURE SetResiliencyOn@48(WkshTemplName@1001 : Code[10];JnlBatchName@1000 : Code[10];ItemNo@1002 : Code[20]);
    BEGIN
      PlanningResiliency := TRUE;
      TempPlanningErrorLog.SetJnlBatch(WkshTemplName,JnlBatchName,ItemNo);
    END;

    [External]
    PROCEDURE GetResiliencyError@47(VAR PlanningErrorLog@1000 : Record 5430) : Boolean;
    BEGIN
      EXIT(TempPlanningErrorLog.GetError(PlanningErrorLog));
    END;

    [External]
    PROCEDURE SetResiliencyError@39(TheError@1002 : Text[250];TheTableID@1001 : Integer;TheTablePosition@1000 : Text[250]);
    BEGIN
      TempPlanningErrorLog.SetError(TheError,TheTableID,TheTablePosition);
    END;

    LOCAL PROCEDURE CheckExchRate@50();
    VAR
      CurrExchRate@1001 : Record 330;
    BEGIN
      CurrExchRate.SETRANGE("Currency Code","Currency Code");
      CurrExchRate.SETRANGE("Starting Date",0D,"Order Date");
      CASE TRUE OF
        NOT CurrExchRate.FINDLAST:
          TempPlanningErrorLog.SetError(
            STRSUBSTNO(
              Text038,
              Currency.TABLECAPTION,Currency.Code,"Vendor No.","Order Date"),
            DATABASE::Currency,Currency.GETPOSITION);
        CurrExchRate."Exchange Rate Amount" = 0:
          TempPlanningErrorLog.SetError(
            STRSUBSTNO(
              Text037,
              Currency.TABLECAPTION,Currency.Code,"Vendor No.",
              "Order Date",CurrExchRate.FIELDCAPTION("Exchange Rate Amount")),
            DATABASE::Currency,Currency.GETPOSITION);
        CurrExchRate."Relational Exch. Rate Amount" = 0:
          TempPlanningErrorLog.SetError(
            STRSUBSTNO(
              Text037,
              Currency.TABLECAPTION,Currency.Code,"Vendor No.",
              "Order Date",CurrExchRate.FIELDCAPTION("Relational Exch. Rate Amount")),
            DATABASE::Currency,Currency.GETPOSITION);
      END;
    END;

    LOCAL PROCEDURE CheckNoSeries@53(NoSeriesCode@1000 : Code[20];SeriesDate@1001 : Date);
    VAR
      NoSeries@1003 : Record 308;
      NoSeriesLine@1004 : Record 309;
      NoSeriesMgt@1002 : Codeunit 396;
    BEGIN
      CASE TRUE OF
        NOT NoSeries.GET(NoSeriesCode):
          TempPlanningErrorLog.SetError(
            STRSUBSTNO(
              Text035,
              NoSeries.TABLECAPTION,NoSeries.FIELDCAPTION(Code),NoSeriesCode,
              MfgSetup.TABLECAPTION,MfgSetup.FIELDCAPTION("Planned Order Nos.")),
            DATABASE::"No. Series",NoSeries.GETPOSITION);
        NOT NoSeries."Default Nos.":
          TempPlanningErrorLog.SetError(
            STRSUBSTNO(Text036,NoSeries.TABLECAPTION,NoSeries.FIELDCAPTION(Code),NoSeries.Code),
            DATABASE::"No. Series",NoSeries.GETPOSITION);
        ELSE
          IF SeriesDate = 0D THEN
            SeriesDate := WORKDATE;

          NoSeriesMgt.SetNoSeriesLineFilter(NoSeriesLine,NoSeriesCode,SeriesDate);
          IF NOT NoSeriesLine.FINDFIRST THEN BEGIN
            NoSeriesLine.SETRANGE("Starting Date");
            IF NoSeriesLine.FINDFIRST THEN BEGIN
              TempPlanningErrorLog.SetError(
                STRSUBSTNO(Text039,NoSeriesCode,SeriesDate),DATABASE::"No. Series",NoSeries.GETPOSITION);
              EXIT;
            END;
            TempPlanningErrorLog.SetError(
              STRSUBSTNO(Text040,NoSeriesCode),DATABASE::"No. Series",NoSeries.GETPOSITION);
            EXIT;
          END;

          IF NoSeries."Date Order" AND (SeriesDate < NoSeriesLine."Last Date Used") THEN BEGIN
            TempPlanningErrorLog.SetError(
              STRSUBSTNO(Text041,NoSeries.Code,NoSeriesLine."Last Date Used"),
              DATABASE::"No. Series",NoSeries.GETPOSITION);
            EXIT;
          END;
          NoSeriesLine."Last Date Used" := SeriesDate;
          IF NoSeriesLine."Last No. Used" = '' THEN BEGIN
            IF NoSeriesLine."Starting No." = '' THEN BEGIN
              TempPlanningErrorLog.SetError(
                STRSUBSTNO(
                  Text042,
                  NoSeries.Code,NoSeriesLine."Line No.",NoSeriesLine.FIELDCAPTION("Starting No.")),
                DATABASE::"No. Series",NoSeries.GETPOSITION);
              EXIT;
            END;
            NoSeriesLine."Last No. Used" := NoSeriesLine."Starting No.";
          END ELSE
            IF NoSeriesLine."Increment-by No." <= 1 THEN BEGIN
              IF STRLEN(INCSTR(NoSeriesLine."Last No. Used")) > 20 THEN BEGIN
                TempPlanningErrorLog.SetError(
                  STRSUBSTNO(
                    Text043,NoSeriesLine."Last No. Used",NoSeriesCode),
                  DATABASE::"No. Series",NoSeries.GETPOSITION);
                EXIT;
              END;
              NoSeriesLine."Last No. Used" := INCSTR(NoSeriesLine."Last No. Used")
            END ELSE
              IF NOT IncrementNoText(NoSeriesLine."Last No. Used",NoSeriesLine."Increment-by No.") THEN BEGIN
                TempPlanningErrorLog.SetError(
                  STRSUBSTNO(
                    Text043,NoSeriesLine."Last No. Used",NoSeriesCode),
                  DATABASE::"No. Series",NoSeries.GETPOSITION);
                EXIT;
              END;
          IF (NoSeriesLine."Ending No." <> '') AND
             (NoSeriesLine."Last No. Used" > NoSeriesLine."Ending No.")
          THEN
            TempPlanningErrorLog.SetError(
              STRSUBSTNO(Text044,NoSeriesLine."Ending No.",NoSeriesCode),
              DATABASE::"No. Series",NoSeries.GETPOSITION);
      END;
    END;

    LOCAL PROCEDURE IncrementNoText@56(VAR No@1000 : Code[20];IncrementByNo@1001 : Decimal) : Boolean;
    VAR
      DecimalNo@1002 : Decimal;
      StartPos@1003 : Integer;
      EndPos@1004 : Integer;
      NewNo@1005 : Text[30];
    BEGIN
      GetIntegerPos(No,StartPos,EndPos);
      EVALUATE(DecimalNo,COPYSTR(No,StartPos,EndPos - StartPos + 1));
      NewNo := FORMAT(DecimalNo + IncrementByNo,0,1);
      IF NOT ReplaceNoText(No,NewNo,0,StartPos,EndPos) THEN
        EXIT(FALSE);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ReplaceNoText@55(VAR No@1000 : Code[20];NewNo@1001 : Code[20];FixedLength@1002 : Integer;StartPos@1003 : Integer;EndPos@1004 : Integer) : Boolean;
    VAR
      StartNo@1005 : Code[20];
      EndNo@1006 : Code[20];
      ZeroNo@1007 : Code[20];
      NewLength@1008 : Integer;
      OldLength@1009 : Integer;
    BEGIN
      IF StartPos > 1 THEN
        StartNo := COPYSTR(No,1,StartPos - 1);
      IF EndPos < STRLEN(No) THEN
        EndNo := COPYSTR(No,EndPos + 1);
      NewLength := STRLEN(NewNo);
      OldLength := EndPos - StartPos + 1;
      IF FixedLength > OldLength THEN
        OldLength := FixedLength;
      IF OldLength > NewLength THEN
        ZeroNo := PADSTR('',OldLength - NewLength,'0');
      IF STRLEN(StartNo) + STRLEN(ZeroNo) + STRLEN(NewNo) + STRLEN(EndNo) > 20 THEN
        EXIT(FALSE);
      No := StartNo + ZeroNo + NewNo + EndNo;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetIntegerPos@57(No@1000 : Code[20];VAR StartPos@1001 : Integer;VAR EndPos@1002 : Integer);
    VAR
      IsDigit@1003 : Boolean;
      i@1004 : Integer;
    BEGIN
      StartPos := 0;
      EndPos := 0;
      IF No <> '' THEN BEGIN
        i := STRLEN(No);
        REPEAT
          IsDigit := No[i] IN ['0'..'9'];
          IF IsDigit THEN BEGIN
            IF EndPos = 0 THEN
              EndPos := i;
            StartPos := i;
          END;
          i := i - 1;
        UNTIL (i = 0) OR (StartPos <> 0) AND NOT IsDigit;
      END;
    END;

    LOCAL PROCEDURE FilterLinesWithItemToPlan@70(VAR Item@1000 : Record 27);
    BEGIN
      RESET;
      SETCURRENTKEY(Type,"No.");
      SETRANGE(Type,Type::Item);
      SETRANGE("No.",Item."No.");
      SETRANGE("Sales Order No.",'');
      SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
      SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
      SETFILTER("Due Date",Item.GETFILTER("Date Filter"));
      Item.COPYFILTER("Global Dimension 1 Filter","Shortcut Dimension 1 Code");
      Item.COPYFILTER("Global Dimension 2 Filter","Shortcut Dimension 2 Code");
      SETRANGE("Planning Line Origin","Planning Line Origin"::" ");
      SETFILTER("Quantity (Base)",'<>0');
    END;

    [External]
    PROCEDURE FindLinesWithItemToPlan@68(VAR Item@1000 : Record 27) : Boolean;
    BEGIN
      FilterLinesWithItemToPlan(Item);
      EXIT(FIND('-'));
    END;

    [External]
    PROCEDURE FindCurrForecastName@40(VAR ForecastName@1001 : Code[10]) : Boolean;
    VAR
      UntrackedPlngElement@1000 : Record 99000855;
    BEGIN
      IF (Type <> Type::Item) OR
         ("Planning Line Origin" <> "Planning Line Origin"::Planning)
      THEN
        EXIT(FALSE);
      UntrackedPlngElement.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      UntrackedPlngElement.SETRANGE("Worksheet Batch Name","Journal Batch Name");
      UntrackedPlngElement.SETRANGE("Item No.","No.");
      UntrackedPlngElement.SETRANGE("Source Type",DATABASE::"Production Forecast Entry");
      IF UntrackedPlngElement.FINDFIRST THEN BEGIN
        ForecastName := COPYSTR(UntrackedPlngElement."Source ID",1,10);
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE ShowDimensions@88();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Worksheet Template Name","Journal Batch Name","Line No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE ShowTimeline@7(ReqLine@1000 : Record 246);
    VAR
      ItemAvailByTimeline@1001 : Page 5540;
    BEGIN
      ReqLine.TESTFIELD(Type,Type::Item);
      ReqLine.TESTFIELD("No.");

      Item.GET("No.");
      Item.SETRANGE("No.",Item."No.");
      Item.SETRANGE("Variant Filter",ReqLine."Variant Code");
      Item.SETRANGE("Location Filter",ReqLine."Location Code");

      ItemAvailByTimeline.SetItem(Item);
      ItemAvailByTimeline.SetWorksheet(ReqLine."Worksheet Template Name",ReqLine."Journal Batch Name");
      ItemAvailByTimeline.RUN;
    END;

    [External]
    PROCEDURE GetOriginalQtyBase@36() : Decimal;
    BEGIN
      EXIT(CalcBaseQty("Original Quantity"));
    END;

    LOCAL PROCEDURE SetFromBinCode@62();
    BEGIN
      IF ("Location Code" <> '') AND ("No." <> '') THEN BEGIN
        GetLocation("Location Code");
        CASE "Ref. Order Type" OF
          "Ref. Order Type"::"Prod. Order":
            BEGIN
              IF "Bin Code" = '' THEN
                "Bin Code" := WMSManagement.GetLastOperationFromBinCode("Routing No.","Routing Version Code","Location Code",FALSE,0);
              IF "Bin Code" = '' THEN
                "Bin Code" := Location."From-Production Bin Code";
            END;
          "Ref. Order Type"::Assembly:
            IF "Bin Code" = '' THEN
              "Bin Code" := Location."From-Assembly Bin Code";
        END;
        IF ("Bin Code" = '') AND Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
          WMSManagement.GetDefaultBin("No.","Variant Code","Location Code","Bin Code")
      END;
    END;

    [External]
    PROCEDURE SetDropShipment@58(NewDropShipment@1000 : Boolean);
    BEGIN
      SourceDropShipment := NewDropShipment;
    END;

    LOCAL PROCEDURE IsDropShipment@59() : Boolean;
    VAR
      SalesLine@1000 : Record 37;
    BEGIN
      IF SourceDropShipment THEN
        EXIT(TRUE);

      IF "Replenishment System" = "Replenishment System"::Purchase THEN
        IF SalesLine.GET(SalesLine."Document Type"::Order,"Sales Order No.","Sales Order Line No.") THEN
          EXIT(SalesLine."Drop Shipment");
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetLocationCode@75();
    BEGIN
      IF IsLocationCodeAlterable THEN BEGIN
        IF NOT IsDropShipmentOrSpecialOrder THEN
          IF "Vendor No." <> '' THEN
            "Location Code" := Vend."Location Code"
          ELSE
            "Location Code" := '';
      END;
    END;

    LOCAL PROCEDURE IsDropShipmentOrSpecialOrder@67() : Boolean;
    VAR
      SalesLine@1000 : Record 37;
    BEGIN
      IF "Replenishment System" = "Replenishment System"::Purchase THEN
        IF SalesLine.GET(SalesLine."Document Type"::Order,"Sales Order No.","Sales Order Line No.") THEN
          EXIT(SalesLine."Drop Shipment" OR SalesLine."Special Order");
    END;

    LOCAL PROCEDURE IsLocationCodeAlterable@66() : Boolean;
    BEGIN
      IF (CurrFieldNo = 0) AND (CurrentFieldNo = 0) THEN
        EXIT(FALSE);

      IF (CurrFieldNo = FIELDNO("Location Code")) OR (CurrentFieldNo = FIELDNO("Location Code")) THEN
        EXIT(FALSE);

      IF (CurrFieldNo = FIELDNO("Replenishment System")) OR (CurrentFieldNo = FIELDNO("Replenishment System")) THEN
        EXIT(FALSE);

      IF "Planning Line Origin" <> "Planning Line Origin"::" " THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetWorkCenter@71();
    BEGIN
      IF WorkCenter."No." = "Work Center No." THEN
        EXIT;

      CLEAR(WorkCenter);
      IF WorkCenter.GET("Work Center No.") THEN
        SetSubcontracting(WorkCenter."Subcontractor No." <> '')
      ELSE
        SetSubcontracting(FALSE);
    END;

    LOCAL PROCEDURE RoutingLineExists@60() : Boolean;
    VAR
      RoutingLine@1000 : Record 99000764;
    BEGIN
      IF "Routing No." <> '' THEN BEGIN
        RoutingLine.SETRANGE("Routing No.","Routing No.");
        EXIT(NOT RoutingLine.ISEMPTY);
      END;

      EXIT(FALSE);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDim@165(VAR ReqLine@1000 : Record 246;xReqLine@1001 : Record 246);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@164(VAR RequisitionLine@1000 : Record 246;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    BEGIN
    END.
  }
}

