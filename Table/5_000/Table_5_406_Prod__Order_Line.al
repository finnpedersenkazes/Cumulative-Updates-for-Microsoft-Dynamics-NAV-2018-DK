OBJECT Table 5406 Prod. Order Line
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    DataCaptionFields=Prod. Order No.;
    OnInsert=BEGIN
               IF Status = Status::Finished THEN
                 ERROR(Text000,Status,TABLECAPTION);

               ReserveProdOrderLine.VerifyQuantity(Rec,xRec);
               IF "Routing Reference No." < 0 THEN
                 "Routing Reference No." := "Line No.";
             END;

    OnModify=BEGIN
               IF Status = Status::Finished THEN
                 ERROR(Text000,Status,TABLECAPTION);

               ReserveProdOrderLine.VerifyChange(Rec,xRec);
             END;

    OnDelete=VAR
               ItemLedgEntry@1000 : Record 32;
               CapLedgEntry@1001 : Record 5832;
               PurchLine@1002 : Record 39;
             BEGIN
               IF Status = Status::Finished THEN
                 ERROR(Text000,Status,TABLECAPTION);

               IF Status = Status::Released THEN BEGIN
                 ItemLedgEntry.SETRANGE("Order Type",ItemLedgEntry."Order Type"::Production);
                 ItemLedgEntry.SETRANGE("Order No.","Prod. Order No.");
                 ItemLedgEntry.SETRANGE("Order Line No.","Line No.");
                 IF NOT ItemLedgEntry.ISEMPTY THEN
                   ERROR(
                     Text99000000,
                     TABLECAPTION,"Line No.",ItemLedgEntry.TABLECAPTION);

                 IF CheckCapLedgEntry THEN
                   ERROR(
                     Text99000000,
                     TABLECAPTION,"Line No.",CapLedgEntry.TABLECAPTION);

                 IF CheckSubcontractPurchOrder THEN
                   ERROR(
                     Text99000000,
                     TABLECAPTION,"Line No.",PurchLine.TABLECAPTION);
               END;

               ReserveProdOrderLine.DeleteLine(Rec);

               CALCFIELDS("Reserved Qty. (Base)");
               TESTFIELD("Reserved Qty. (Base)",0);
               WhseValidateSourceLine.ProdOrderLineDelete(Rec);

               DeleteRelations;
             END;

    OnRename=BEGIN
               ERROR(Text99000001,TABLECAPTION);
             END;

    CaptionML=[DAN=Prod.ordrelinje;
               ENU=Prod. Order Line];
    LookupPageID=Page5406;
    DrillDownPageID=Page5406;
  }
  FIELDS
  {
    { 1   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Simuleret,Planlagt,Fastlagt,Frigivet,Udf�rt;
                                                                    ENU=Simulated,Planned,Firm Planned,Released,Finished];
                                                   OptionString=Simulated,Planned,Firm Planned,Released,Finished }
    { 2   ;   ;Prod. Order No.     ;Code20        ;TableRelation="Production Order".No. WHERE (Status=FIELD(Status));
                                                   CaptionML=[DAN=Prod.ordrenr.;
                                                              ENU=Prod. Order No.] }
    { 3   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 11  ;   ;Item No.            ;Code20        ;TableRelation=Item WHERE (Type=CONST(Inventory));
                                                   OnValidate=BEGIN
                                                                ReserveProdOrderLine.VerifyChange(Rec,xRec);
                                                                TESTFIELD("Finished Quantity",0);
                                                                CALCFIELDS("Reserved Quantity");
                                                                TESTFIELD("Reserved Quantity",0);
                                                                WhseValidateSourceLine.ProdOrderLineVerifyChange(Rec,xRec);
                                                                IF "Item No." <> xRec."Item No." THEN BEGIN
                                                                  DeleteRelations;
                                                                  "Variant Code" := '';
                                                                END;
                                                                IF "Item No." = '' THEN
                                                                  INIT
                                                                ELSE BEGIN
                                                                  ProdOrder.GET(Status,"Prod. Order No.");
                                                                  "Starting Date" := ProdOrder."Starting Date";
                                                                  "Starting Time" := ProdOrder."Starting Time";
                                                                  "Ending Date" := ProdOrder."Ending Date";
                                                                  "Ending Time" := ProdOrder."Ending Time";
                                                                  "Due Date" := ProdOrder."Due Date";
                                                                  "Location Code" := ProdOrder."Location Code";
                                                                  "Bin Code" := ProdOrder."Bin Code";
                                                                  IF "Bin Code" = '' THEN
                                                                    GetDefaultBin;

                                                                  GetItem;
                                                                  Item.TESTFIELD("Inventory Posting Group");
                                                                  "Inventory Posting Group" := Item."Inventory Posting Group";

                                                                  Description := Item.Description;
                                                                  "Description 2" := Item."Description 2";
                                                                  "Production BOM No." := Item."Production BOM No.";
                                                                  "Routing No." := Item."Routing No.";

                                                                  "Scrap %" := Item."Scrap %";
                                                                  "Unit Cost" := Item."Unit Cost";
                                                                  "Indirect Cost %" := Item."Indirect Cost %";
                                                                  "Overhead Rate" := Item."Overhead Rate";
                                                                  IF "Item No." <> xRec."Item No." THEN BEGIN
                                                                    VALIDATE("Production BOM No.",Item."Production BOM No.");
                                                                    VALIDATE("Routing No.",Item."Routing No.");
                                                                    VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");
                                                                  END;
                                                                  IF ProdOrder."Source Type" = ProdOrder."Source Type"::Family THEN
                                                                    "Routing Reference No." := 0
                                                                  ELSE
                                                                    IF "Line No." = 0 THEN
                                                                      "Routing Reference No." := -10000
                                                                    ELSE
                                                                      "Routing Reference No." := "Line No.";
                                                                END;
                                                                IF "Item No." <> xRec."Item No." THEN
                                                                  VALIDATE(Quantity);
                                                                GetUpdateFromSKU;

                                                                CreateDim(DATABASE::Item,"Item No.");
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 12  ;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.),
                                                                                            Code=FIELD(Variant Code));
                                                   OnValidate=BEGIN
                                                                ReserveProdOrderLine.VerifyChange(Rec,xRec);
                                                                TESTFIELD("Finished Quantity",0);
                                                                CALCFIELDS("Reserved Quantity");
                                                                TESTFIELD("Reserved Quantity",0);
                                                                WhseValidateSourceLine.ProdOrderLineVerifyChange(Rec,xRec);

                                                                IF "Variant Code" = '' THEN BEGIN
                                                                  VALIDATE("Item No.");
                                                                  EXIT;
                                                                END;
                                                                ItemVariant.GET("Item No.","Variant Code");
                                                                Description := ItemVariant.Description;
                                                                "Description 2" := ItemVariant."Description 2";
                                                                GetUpdateFromSKU;
                                                                GetDefaultBin;
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 13  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 14  ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 20  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                ReserveProdOrderLine.VerifyChange(Rec,xRec);
                                                                WhseValidateSourceLine.ProdOrderLineVerifyChange(Rec,xRec);
                                                                GetUpdateFromSKU;
                                                                GetDefaultBin;
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 21  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 22  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 23  ;   ;Bin Code            ;Code20        ;TableRelation=IF (Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                          Item No.=FIELD(Item No.),
                                                                                                                          Variant Code=FIELD(Variant Code))
                                                                                                                          ELSE Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=VAR
                                                                WMSManagement@1000 : Codeunit 7302;
                                                                WhseIntegrationMgt@1001 : Codeunit 7317;
                                                              BEGIN
                                                                IF "Bin Code" <> '' THEN BEGIN
                                                                  IF Quantity < 0 THEN
                                                                    WMSManagement.FindBinContent("Location Code","Bin Code","Item No.","Variant Code",'')
                                                                  ELSE
                                                                    WMSManagement.FindBin("Location Code","Bin Code",'');
                                                                  WhseIntegrationMgt.CheckBinTypeCode(DATABASE::"Prod. Order Line",
                                                                    FIELDCAPTION("Bin Code"),
                                                                    "Location Code",
                                                                    "Bin Code",0);
                                                                  CheckBin;
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              WMSManagement@1000 : Codeunit 7302;
                                                              BinCode@1001 : Code[20];
                                                            BEGIN
                                                              IF Quantity < 0 THEN
                                                                BinCode := WMSManagement.BinContentLookUp("Location Code","Item No.","Variant Code",'',"Bin Code")
                                                              ELSE
                                                                BinCode := WMSManagement.BinLookUp("Location Code","Item No.","Variant Code",'');

                                                              IF BinCode <> '' THEN
                                                                VALIDATE("Bin Code",BinCode);
                                                            END;

                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 40  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
                                                                "Remaining Quantity" := Quantity - "Finished Quantity";
                                                                IF "Remaining Quantity" < 0 THEN
                                                                  "Remaining Quantity" := 0;
                                                                "Remaining Qty. (Base)" := "Remaining Quantity" * "Qty. per Unit of Measure";
                                                                ReserveProdOrderLine.VerifyQuantity(Rec,xRec);
                                                                WhseValidateSourceLine.ProdOrderLineVerifyChange(Rec,xRec);

                                                                UpdateProdOrderComp(xRec."Qty. per Unit of Measure");

                                                                IF CurrFieldNo <> 0 THEN
                                                                  VALIDATE("Ending Time");
                                                                "Cost Amount" := ROUND(Quantity * "Unit Cost");
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 41  ;   ;Finished Quantity   ;Decimal       ;CaptionML=[DAN=F�rdigt antal;
                                                              ENU=Finished Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   Editable=No }
    { 42  ;   ;Remaining Quantity  ;Decimal       ;CaptionML=[DAN=Restantal;
                                                              ENU=Remaining Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   Editable=No }
    { 45  ;   ;Scrap %             ;Decimal       ;CaptionML=[DAN=Spildpct.;
                                                              ENU=Scrap %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 47  ;   ;Due Date            ;Date          ;OnValidate=BEGIN
                                                                CheckEndingDate(CurrFieldNo <> 0);
                                                              END;

                                                   CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date];
                                                   Editable=No }
    { 48  ;   ;Starting Date       ;Date          ;OnValidate=BEGIN
                                                                IF "Ending Date" < "Starting Date" THEN
                                                                  "Ending Date" := "Starting Date";

                                                                VALIDATE("Starting Time");
                                                              END;

                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 49  ;   ;Starting Time       ;Time          ;OnValidate=BEGIN
                                                                IF ProdOrderLine.GET(Status,"Prod. Order No.","Line No.") THEN BEGIN
                                                                  MODIFY;

                                                                  CalcProdOrder.Recalculate(Rec,0,TRUE);

                                                                  GET(Status,"Prod. Order No.","Line No.");
                                                                END;
                                                                IF CurrFieldNo <> 0 THEN
                                                                  VALIDATE("Due Date");

                                                                UpdateDatetime;
                                                              END;

                                                   CaptionML=[DAN=Starttidspunkt;
                                                              ENU=Starting Time] }
    { 50  ;   ;Ending Date         ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Ending Time");
                                                              END;

                                                   CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date] }
    { 51  ;   ;Ending Time         ;Time          ;OnValidate=BEGIN
                                                                IF ProdOrderLine.GET(Status,"Prod. Order No.","Line No.") THEN BEGIN
                                                                  MODIFY;

                                                                  CalcProdOrder.Recalculate(Rec,1,TRUE);

                                                                  GET(Status,"Prod. Order No.","Line No.");
                                                                END;
                                                                IF CurrFieldNo <> 0 THEN
                                                                  VALIDATE("Due Date");

                                                                UpdateDatetime;
                                                              END;

                                                   CaptionML=[DAN=Sluttidspunkt;
                                                              ENU=Ending Time] }
    { 52  ;   ;Planning Level Code ;Integer       ;CaptionML=[DAN=Planl�gningsniveaukode;
                                                              ENU=Planning Level Code];
                                                   Editable=No }
    { 53  ;   ;Priority            ;Integer       ;CaptionML=[DAN=Prioritet;
                                                              ENU=Priority] }
    { 60  ;   ;Production BOM No.  ;Code20        ;TableRelation="Production BOM Header".No.;
                                                   OnValidate=BEGIN
                                                                "Production BOM Version Code" := '';
                                                                IF "Production BOM No." = '' THEN
                                                                  EXIT;

                                                                VALIDATE("Production BOM Version Code",VersionMgt.GetBOMVersion("Production BOM No.","Due Date",TRUE));
                                                                IF "Production BOM Version Code" = '' THEN BEGIN
                                                                  ProdBOMHeader.GET("Production BOM No.");
                                                                  ProdBOMHeader.TESTFIELD(Status,ProdBOMHeader.Status::Certified);
                                                                  VALIDATE("Unit of Measure Code",ProdBOMHeader."Unit of Measure Code");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Produktionsstyklistenr.;
                                                              ENU=Production BOM No.] }
    { 61  ;   ;Routing No.         ;Code20        ;TableRelation="Routing Header".No.;
                                                   OnValidate=VAR
                                                                CapLedgEntry@1001 : Record 5832;
                                                                PurchLine@1000 : Record 39;
                                                              BEGIN
                                                                "Routing Version Code" := '';

                                                                IF "Routing No." <> xRec."Routing No." THEN BEGIN
                                                                  IF Status = Status::Released THEN BEGIN
                                                                    IF CheckCapLedgEntry THEN
                                                                      ERROR(
                                                                        Text99000004Err,
                                                                        FIELDCAPTION("Routing No."),xRec."Routing No.",CapLedgEntry.TABLECAPTION);

                                                                    IF CheckSubcontractPurchOrder THEN
                                                                      ERROR(
                                                                        Text99000004Err,
                                                                        FIELDCAPTION("Routing No."),xRec."Routing No.",PurchLine.TABLECAPTION);
                                                                  END;

                                                                  ProdOrderRtngLine.SETRANGE(Status,Status);
                                                                  ProdOrderRtngLine.SETRANGE("Prod. Order No.","Prod. Order No.");
                                                                  ProdOrderRtngLine.SETRANGE("Routing No.",xRec."Routing No.");
                                                                  ProdOrderRtngLine.SETRANGE("Routing Reference No.","Line No.");
                                                                  ProdOrderRtngLine.DELETEALL(TRUE);
                                                                END;
                                                                IF "Routing No." = '' THEN
                                                                  EXIT;

                                                                VALIDATE("Routing Version Code",VersionMgt.GetRtngVersion("Routing No.","Due Date",TRUE));
                                                                IF "Routing Version Code" = '' THEN BEGIN
                                                                  RtngHeader.GET("Routing No.");
                                                                  RtngHeader.TESTFIELD(Status,RtngHeader.Status::Certified);
                                                                  "Routing Type" := RtngHeader.Type;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Rutenr.;
                                                              ENU=Routing No.] }
    { 62  ;   ;Inventory Posting Group;Code20     ;TableRelation="Inventory Posting Group";
                                                   CaptionML=[DAN=Varebogf�ringsgruppe;
                                                              ENU=Inventory Posting Group] }
    { 63  ;   ;Routing Reference No.;Integer      ;CaptionML=[DAN=Rutereferencenr.;
                                                              ENU=Routing Reference No.];
                                                   Editable=No }
    { 65  ;   ;Unit Cost           ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Item No.");
                                                                GetItem;
                                                                Item.TESTFIELD("Inventory Value Zero",FALSE);
                                                                IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
                                                                  IF CurrFieldNo = FIELDNO("Unit Cost") THEN
                                                                    ERROR(
                                                                      Text99000002,
                                                                      FIELDCAPTION("Unit Cost"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");

                                                                  IF GetSKU THEN
                                                                    "Unit Cost" := SKU."Unit Cost" * "Qty. per Unit of Measure"
                                                                  ELSE
                                                                    "Unit Cost" := Item."Unit Cost" * "Qty. per Unit of Measure";
                                                                END;

                                                                "Cost Amount" := ROUND(Quantity * "Unit Cost");
                                                              END;

                                                   CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   AutoFormatType=2 }
    { 67  ;   ;Cost Amount         ;Decimal       ;CaptionML=[DAN=Kostbel�b;
                                                              ENU=Cost Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 68  ;   ;Reserved Quantity   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Prod. Order No.),
                                                                                                       Source Ref. No.=CONST(0),
                                                                                                       Source Type=CONST(5406),
                                                                                                       Source Subtype=FIELD(Status),
                                                                                                       Source Batch Name=CONST(),
                                                                                                       Source Prod. Order Line=FIELD(Line No.),
                                                                                                       Reservation Status=CONST(Reservation)));
                                                   CaptionML=[DAN=Reserveret antal;
                                                              ENU=Reserved Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 70  ;   ;Capacity Type Filter;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Kapacitetstypefilter;
                                                              ENU=Capacity Type Filter];
                                                   OptionCaptionML=[DAN=Arbejdscenter,Produktionsressource;
                                                                    ENU=Work Center,Machine Center];
                                                   OptionString=Work Center,Machine Center }
    { 71  ;   ;Capacity No. Filter ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=IF (Capacity Type Filter=CONST(Work Center)) "Work Center"
                                                                 ELSE IF (Capacity Type Filter=CONST(Machine Center)) "Machine Center";
                                                   CaptionML=[DAN=Kapacitetsnr.filter;
                                                              ENU=Capacity No. Filter] }
    { 72  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 80  ;   ;Unit of Measure Code;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=BEGIN
                                                                GetItem;
                                                                GetGLSetup;
                                                                WhseValidateSourceLine.ProdOrderLineVerifyChange(Rec,xRec);
                                                                "Unit Cost" := Item."Unit Cost";

                                                                "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");

                                                                "Unit Cost" :=
                                                                  ROUND(Item."Unit Cost" * "Qty. per Unit of Measure",
                                                                    GLSetup."Unit-Amount Rounding Precision");

                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 81  ;   ;Quantity (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE(Quantity,"Quantity (Base)");
                                                                "Remaining Quantity" := Quantity - "Finished Quantity";

                                                                VALIDATE("Ending Time");

                                                                "Cost Amount" := ROUND(Quantity * "Unit Cost");
                                                              END;

                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 82  ;   ;Finished Qty. (Base);Decimal       ;CaptionML=[DAN=F�rdigt antal (basis);
                                                              ENU=Finished Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 83  ;   ;Remaining Qty. (Base);Decimal      ;CaptionML=[DAN=Restantal (basis);
                                                              ENU=Remaining Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 84  ;   ;Reserved Qty. (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(Prod. Order No.),
                                                                                                                Source Ref. No.=CONST(0),
                                                                                                                Source Type=CONST(5406),
                                                                                                                Source Subtype=FIELD(Status),
                                                                                                                Source Batch Name=CONST(),
                                                                                                                Source Prod. Order Line=FIELD(Line No.),
                                                                                                                Reservation Status=CONST(Reservation)));
                                                   CaptionML=[DAN=Reserveret antal (basis);
                                                              ENU=Reserved Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 90  ;   ;Expected Operation Cost Amt.;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Routing Line"."Expected Operation Cost Amt." WHERE (Status=FIELD(Status),
                                                                                                                                    Prod. Order No.=FIELD(Prod. Order No.),
                                                                                                                                    Routing No.=FIELD(Routing No.),
                                                                                                                                    Routing Reference No.=FIELD(Routing Reference No.)));
                                                   CaptionML=[DAN=Forventede operationsomkostninger;
                                                              ENU=Expected Operation Cost Amt.];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 91  ;   ;Total Exp. Oper. Output (Qty.);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Line".Quantity WHERE (Status=FIELD(Status),
                                                                                                      Prod. Order No.=FIELD(Prod. Order No.),
                                                                                                      Routing No.=FIELD(Routing No.),
                                                                                                      Routing Reference No.=FIELD(Routing Reference No.),
                                                                                                      Ending Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Forv. op.afgang i alt (antal);
                                                              ENU=Total Exp. Oper. Output (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 94  ;   ;Expected Component Cost Amt.;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Component"."Cost Amount" WHERE (Status=FIELD(Status),
                                                                                                                Prod. Order No.=FIELD(Prod. Order No.),
                                                                                                                Prod. Order Line No.=FIELD(Line No.),
                                                                                                                Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Forventet komponentomkostning;
                                                              ENU=Expected Component Cost Amt.];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 198 ;   ;Starting Date-Time  ;DateTime      ;OnValidate=BEGIN
                                                                "Starting Date" := DT2DATE("Starting Date-Time");
                                                                "Starting Time" := DT2TIME("Starting Date-Time");
                                                                VALIDATE("Starting Time");
                                                              END;

                                                   CaptionML=[DAN=Startdato/-tidspunkt;
                                                              ENU=Starting Date-Time] }
    { 199 ;   ;Ending Date-Time    ;DateTime      ;OnValidate=BEGIN
                                                                "Ending Date" := DT2DATE("Ending Date-Time");
                                                                "Ending Time" := DT2TIME("Ending Date-Time");
                                                                VALIDATE("Ending Time");
                                                              END;

                                                   CaptionML=[DAN=Slutdato/-tidspunkt;
                                                              ENU=Ending Date-Time] }
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
    { 5831;   ;Cost Amount (ACY)   ;Decimal       ;CaptionML=[DAN=Kostbel�b (EV);
                                                              ENU=Cost Amount (ACY)];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 5832;   ;Unit Cost (ACY)     ;Decimal       ;CaptionML=[DAN=Kostpris (EV);
                                                              ENU=Unit Cost (ACY)];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 99000750;;Production BOM Version Code;Code20;TableRelation="Production BOM Version"."Version Code" WHERE (Production BOM No.=FIELD(Production BOM No.));
                                                   OnValidate=BEGIN
                                                                IF "Production BOM Version Code" = '' THEN
                                                                  EXIT;

                                                                ProdBOMVersion.GET("Production BOM No.","Production BOM Version Code");
                                                                ProdBOMVersion.TESTFIELD(Status,ProdBOMVersion.Status::Certified);
                                                                VALIDATE("Unit of Measure Code",ProdBOMVersion."Unit of Measure Code");
                                                              END;

                                                   CaptionML=[DAN=Prod.styklisteversionskode;
                                                              ENU=Production BOM Version Code] }
    { 99000751;;Routing Version Code;Code20       ;TableRelation="Routing Version"."Version Code" WHERE (Routing No.=FIELD(Routing No.));
                                                   OnValidate=BEGIN
                                                                IF "Routing Version Code" = '' THEN
                                                                  EXIT;

                                                                RtngVersion.GET("Routing No.","Routing Version Code");
                                                                RtngVersion.TESTFIELD(Status,RtngVersion.Status::Certified);
                                                                "Routing Type" := RtngVersion.Type;
                                                              END;

                                                   CaptionML=[DAN=Ruteversionskode;
                                                              ENU=Routing Version Code] }
    { 99000752;;Routing Type       ;Option        ;CaptionML=[DAN=Rutetype;
                                                              ENU=Routing Type];
                                                   OptionCaptionML=[DAN=Seriel,Parallel;
                                                                    ENU=Serial,Parallel];
                                                   OptionString=Serial,Parallel }
    { 99000753;;Qty. per Unit of Measure;Decimal  ;CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000754;;MPS Order          ;Boolean       ;CaptionML=[DAN=Hovedplansordre;
                                                              ENU=MPS Order] }
    { 99000755;;Planning Flexibility;Option       ;OnValidate=BEGIN
                                                                IF "Planning Flexibility" <> xRec."Planning Flexibility" THEN
                                                                  ReserveProdOrderLine.UpdatePlanningFlexibility(Rec);
                                                              END;

                                                   CaptionML=[DAN=Planl�gningsfleksibilitet;
                                                              ENU=Planning Flexibility];
                                                   OptionCaptionML=[DAN=Ubegr�nset,Ingen;
                                                                    ENU=Unlimited,None];
                                                   OptionString=Unlimited,None }
    { 99000764;;Indirect Cost %    ;Decimal       ;CaptionML=[DAN=Indir. omkost.pct.;
                                                              ENU=Indirect Cost %];
                                                   DecimalPlaces=0:5 }
    { 99000765;;Overhead Rate      ;Decimal       ;CaptionML=[DAN=IPO-bidrag;
                                                              ENU=Overhead Rate];
                                                   AutoFormatType=2 }
  }
  KEYS
  {
    {    ;Status,Prod. Order No.,Line No.         ;Clustered=Yes }
    {    ;Prod. Order No.,Line No.,Status          }
    {    ;Status,Item No.,Variant Code,Location Code,Ending Date;
                                                   SumIndexFields=Remaining Qty. (Base),Cost Amount }
    {    ;Status,Item No.,Variant Code,Location Code,Starting Date;
                                                   SumIndexFields=Remaining Qty. (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Status,Item No.,Variant Code,Location Code,Due Date;
                                                   SumIndexFields=Remaining Qty. (Base);
                                                   MaintainSIFTIndex=No }
    { No ;Status,Item No.,Variant Code,Shortcut Dimension 1 Code,Shortcut Dimension 2 Code,Location Code,Due Date;
                                                   SumIndexFields=Remaining Qty. (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Status,Prod. Order No.,Item No.          }
    {    ;Status,Prod. Order No.,Routing No.,Routing Reference No.;
                                                   SumIndexFields=Quantity,Finished Quantity;
                                                   MaintainSIFTIndex=No }
    {    ;Status,Prod. Order No.,Planning Level Code }
    { No ;Planning Level Code,Priority             }
    {    ;Item No.,Variant Code,Location Code,Status,Ending Date;
                                                   SumIndexFields=Remaining Qty. (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Item No.,Variant Code,Location Code,Status,Due Date;
                                                   SumIndexFields=Remaining Qty. (Base);
                                                   MaintainSIFTIndex=No }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1034 : TextConst 'DAN=%1 %2 kan ikke inds�ttes, redigeres eller slettes.;ENU=A %1 %2 cannot be inserted, modified, or deleted.';
      Text99000000@1000 : TextConst '@@@="%1 = Table Caption; %2 = Field Value; %3 = Table Caption";DAN=Du kan ikke slette %1 %2, fordi der er tilknyttet mindst �n %3.;ENU=You cannot delete %1 %2 because there is at least one %3 associated with it.';
      Text99000001@1001 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text99000002@1002 : TextConst 'DAN=Du kan ikke �ndre %1, n�r %2 er %3.;ENU=You cannot change %1 when %2 is %3.';
      Text99000004Err@1003 : TextConst '@@@="%1 = Field Caption; %2 = Field Value; %3 = Table Caption";DAN=Du kan ikke redigere %1 %2, fordi der er tilknyttet mindst �n %3.;ENU=You cannot modify %1 %2 because there is at least one %3 associated with it.';
      Item@1004 : Record 27;
      SKU@1021 : Record 5700;
      ItemVariant@1005 : Record 5401;
      ReservEntry@1006 : Record 337;
      ProdBOMHeader@1007 : Record 99000771;
      ProdBOMVersion@1008 : Record 99000779;
      RtngHeader@1009 : Record 99000763;
      RtngVersion@1010 : Record 99000786;
      ProdOrder@1011 : Record 5405;
      ProdOrderLine@1012 : Record 5406;
      ProdOrderComp@1013 : Record 5407;
      ProdOrderRtngLine@1014 : Record 5409;
      GLSetup@1031 : Record 98;
      Location@1022 : Record 14;
      ReservEngineMgt@1016 : Codeunit 99000831;
      ReserveProdOrderLine@1017 : Codeunit 99000837;
      WhseValidateSourceLine@1030 : Codeunit 5777;
      UOMMgt@1018 : Codeunit 5402;
      VersionMgt@1019 : Codeunit 99000756;
      CalcProdOrder@1020 : Codeunit 99000773;
      DimMgt@1023 : Codeunit 408;
      Reservation@1026 : Page 498;
      Blocked@1032 : Boolean;
      GLSetupRead@1033 : Boolean;
      IgnoreErrors@1015 : Boolean;
      ErrorOccured@1024 : Boolean;
      CalledFromComponent@1025 : Boolean;

    [External]
    PROCEDURE DeleteRelations@1();
    VAR
      WhseOutputProdRelease@1000 : Codeunit 7325;
    BEGIN
      ProdOrderLine.SETRANGE(Status,Status);
      ProdOrderLine.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderLine.SETRANGE("Routing No.","Routing No.");
      ProdOrderLine.SETFILTER("Line No.",'<>%1',"Line No.");
      ProdOrderLine.SETRANGE("Routing Reference No.","Routing Reference No.");
      IF NOT ProdOrderLine.FINDFIRST THEN BEGIN
        ProdOrderRtngLine.SETRANGE(Status,Status);
        ProdOrderRtngLine.SETRANGE("Prod. Order No.","Prod. Order No.");
        ProdOrderRtngLine.SETRANGE("Routing No.","Routing No.");
        ProdOrderRtngLine.SETRANGE("Routing Reference No.","Routing Reference No.");
        IF ProdOrderRtngLine.FINDSET(TRUE) THEN
          REPEAT
            ProdOrderRtngLine.SetSkipUpdateOfCompBinCodes(TRUE);
            ProdOrderRtngLine.DELETE(TRUE);
          UNTIL ProdOrderRtngLine.NEXT = 0;
      END;

      ProdOrderComp.RESET;
      ProdOrderComp.SETRANGE(Status,Status);
      ProdOrderComp.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderComp.SETRANGE("Prod. Order Line No.","Line No.");
      ProdOrderComp.DELETEALL(TRUE);

      IF NOT CalledFromComponent THEN BEGIN
        ProdOrderComp.SETRANGE("Prod. Order Line No.");
        ProdOrderComp.SETRANGE("Supplied-by Line No.","Line No.");
        IF ProdOrderComp.FIND('-') THEN
          REPEAT
            ProdOrderComp."Supplied-by Line No." := 0;
            ProdOrderComp."Planning Level Code" -= 1;
            ProdOrderComp.MODIFY;
          UNTIL ProdOrderComp.NEXT = 0;
      END;

      WhseOutputProdRelease.DeleteLine(Rec);
    END;

    [External]
    PROCEDURE ShowReservation@8();
    BEGIN
      TESTFIELD("Item No.");
      CLEAR(Reservation);
      Reservation.SetProdOrderLine(Rec);
      Reservation.RUNMODAL;
    END;

    [External]
    PROCEDURE ShowReservationEntries@21(Modal@1000 : Boolean);
    BEGIN
      TESTFIELD("Item No.");
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
      ReserveProdOrderLine.FilterReservFor(ReservEntry,Rec);
      IF Modal THEN
        PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
      ELSE
        PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    END;

    [External]
    PROCEDURE CheckEndingDate@4(ShowWarning@1000 : Boolean);
    VAR
      CheckDateConflict@1001 : Codeunit 99000815;
    BEGIN
      IF NOT Blocked THEN BEGIN
        CheckDateConflict.ProdOrderLineCheck(Rec,ShowWarning);
        ReserveProdOrderLine.AssignForPlanning(Rec);
      END;
    END;

    [External]
    PROCEDURE BlockDynamicTracking@17(SetBlock@1000 : Boolean);
    BEGIN
      Blocked := SetBlock;
      ReserveProdOrderLine.Block(Blocked);
      CalcProdOrder.BlockDynamicTracking(Blocked);
    END;

    LOCAL PROCEDURE CreateDim@6(Type1@1000 : Integer;No1@1001 : Code[20]);
    VAR
      TableID@1002 : ARRAY [10] OF Integer;
      No@1003 : ARRAY [10] OF Code[20];
    BEGIN
      TableID[1] := Type1;
      No[1] := No1;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,'',
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",ProdOrder."Dimension Set ID",DATABASE::Item);
    END;

    [External]
    PROCEDURE IsInbound@15() : Boolean;
    BEGIN
      EXIT("Quantity (Base)" > 0);
    END;

    [External]
    PROCEDURE OpenItemTrackingLines@6500();
    BEGIN
      ReserveProdOrderLine.CallItemTracking(Rec);
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@7(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    VAR
      OldDimSetID@1002 : Integer;
    BEGIN
      OldDimSetID := "Dimension Set ID";
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
      IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
        MODIFY;
        IF ProdOrderCompExist THEN
          UpdateProdOrderCompDim("Dimension Set ID",OldDimSetID);
      END;
    END;

    [External]
    PROCEDURE LookupShortcutDimCode@9(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE ShowShortcutDimCode@10(VAR ShortcutDimCode@1000 : ARRAY [8] OF Code[20]);
    BEGIN
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    END;

    LOCAL PROCEDURE GetItem@5();
    BEGIN
      IF Item."No." <> "Item No." THEN
        Item.GET("Item No.");
    END;

    LOCAL PROCEDURE GetSKU@5802() : Boolean;
    BEGIN
      IF (SKU."Location Code" = "Location Code") AND
         (SKU."Item No." = "Item No.") AND
         (SKU."Variant Code" = "Variant Code")
      THEN
        EXIT(TRUE);
      EXIT(SKU.GET("Location Code","Item No.","Variant Code"));
    END;

    LOCAL PROCEDURE GetUpdateFromSKU@12();
    BEGIN
      GetItem;
      IF GetSKU THEN
        "Unit Cost" := SKU."Unit Cost"
      ELSE
        "Unit Cost" := Item."Unit Cost";
    END;

    [External]
    PROCEDURE UpdateDatetime@11();
    BEGIN
      IF ("Starting Date" <> 0D) AND ("Starting Time" <> 0T) THEN
        "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time")
      ELSE
        "Starting Date-Time" := 0DT;

      IF ("Ending Date" <> 0D) AND ("Ending Time" <> 0T) THEN
        "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time")
      ELSE
        "Ending Date-Time" := 0DT;
    END;

    [External]
    PROCEDURE ShowDimensions@25();
    VAR
      OldDimSetID@1000 : Integer;
    BEGIN
      OldDimSetID := "Dimension Set ID";
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2 %3',Status,"Prod. Order No.","Line No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
        MODIFY;
        IF ProdOrderCompExist THEN
          UpdateProdOrderCompDim("Dimension Set ID",OldDimSetID);
      END;
    END;

    LOCAL PROCEDURE GetGLSetup@14();
    BEGIN
      IF NOT GLSetupRead THEN
        GLSetup.GET;
      GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE GetCurrencyCode@13() : Code[10];
    BEGIN
      IF NOT GLSetupRead THEN BEGIN
        GLSetup.GET;
        GLSetupRead := TRUE;
      END;
      EXIT(GLSetup."Additional Reporting Currency");
    END;

    [External]
    PROCEDURE RowID1@44() : Text[250];
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;
    BEGIN
      EXIT(
        ItemTrackingMgt.ComposeRowID(DATABASE::"Prod. Order Line",Status,
          "Prod. Order No.",'',"Line No.",0));
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
      WMSManagement@1000 : Codeunit 7302;
    BEGIN
      IF (Quantity * xRec.Quantity > 0) AND
         ("Item No." = xRec."Item No.") AND
         ("Location Code" = xRec."Location Code") AND
         ("Variant Code" = xRec."Variant Code")
      THEN
        EXIT;

      "Bin Code" := '';
      IF ("Location Code" <> '') AND ("Item No." <> '') THEN BEGIN
        "Bin Code" := WMSManagement.GetLastOperationFromBinCode("Routing No.","Routing Version Code","Location Code",FALSE,0);
        GetLocation("Location Code");
        IF "Bin Code" = '' THEN
          "Bin Code" := Location."From-Production Bin Code";
        IF ("Bin Code" = '') AND Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
          WMSManagement.GetDefaultBin("Item No.","Variant Code","Location Code","Bin Code");
      END;
      VALIDATE("Bin Code");
    END;

    LOCAL PROCEDURE CheckBin@3();
    VAR
      BinContent@1000 : Record 7302;
      Bin@1001 : Record 7354;
    BEGIN
      IF "Bin Code" <> '' THEN BEGIN
        GetLocation("Location Code");
        IF NOT Location."Directed Put-away and Pick" THEN
          EXIT;

        IF BinContent.GET(
             "Location Code","Bin Code",
             "Item No.","Variant Code","Unit of Measure Code")
        THEN BEGIN
          IF NOT BinContent.CheckWhseClass(IgnoreErrors) THEN
            ErrorOccured := TRUE;
        END ELSE BEGIN
          Bin.GET("Location Code","Bin Code");
          IF NOT Bin.CheckWhseClass("Item No.",IgnoreErrors) THEN
            ErrorOccured := TRUE;
        END;
      END;
      IF ErrorOccured THEN
        "Bin Code" := '';
    END;

    [External]
    PROCEDURE FilterLinesWithItemToPlan@70(VAR Item@1000 : Record 27;IncludeFirmPlanned@1001 : Boolean);
    BEGIN
      RESET;
      SETCURRENTKEY("Item No.","Variant Code","Location Code",Status,"Due Date");
      IF IncludeFirmPlanned THEN
        SETRANGE(Status,Status::Planned,Status::Released)
      ELSE
        SETFILTER(Status,'%1|%2',Status::Planned,Status::Released);
      SETRANGE("Item No.",Item."No.");
      SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
      SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
      SETFILTER("Due Date",Item.GETFILTER("Date Filter"));
      SETFILTER("Shortcut Dimension 1 Code",Item.GETFILTER("Global Dimension 1 Filter"));
      SETFILTER("Shortcut Dimension 2 Code",Item.GETFILTER("Global Dimension 2 Filter"));
      SETFILTER("Remaining Qty. (Base)",'<>0');
    END;

    [External]
    PROCEDURE FindLinesWithItemToPlan@68(VAR Item@1000 : Record 27;IncludeFirmPlanned@1001 : Boolean) : Boolean;
    BEGIN
      FilterLinesWithItemToPlan(Item,IncludeFirmPlanned);
      EXIT(FIND('-'));
    END;

    [External]
    PROCEDURE LinesWithItemToPlanExist@67(VAR Item@1000 : Record 27;IncludeFirmPlanned@1001 : Boolean) : Boolean;
    BEGIN
      FilterLinesWithItemToPlan(Item,IncludeFirmPlanned);
      EXIT(NOT ISEMPTY);
    END;

    [External]
    PROCEDURE SetIgnoreErrors@16();
    BEGIN
      IgnoreErrors := TRUE;
    END;

    [External]
    PROCEDURE SetCalledFromComponent@2(NewCalledFromComponent@1000 : Boolean);
    BEGIN
      CalledFromComponent := NewCalledFromComponent;
    END;

    [External]
    PROCEDURE HasErrorOccured@18() : Boolean;
    BEGIN
      EXIT(ErrorOccured);
    END;

    [External]
    PROCEDURE UpdateProdOrderComp@19(QtyPerUnitOfMeasure@1000 : Decimal);
    VAR
      ProdOrderComp@1001 : Record 5407;
    BEGIN
      ProdOrderComp.SETRANGE(Status,Status);
      ProdOrderComp.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderComp.SETRANGE("Prod. Order Line No.","Line No.");
      IF ProdOrderComp.FIND('-') THEN
        REPEAT
          IF QtyPerUnitOfMeasure <> 0 THEN
            ProdOrderComp.VALIDATE(
              "Quantity per",
              ProdOrderComp."Quantity per" * "Qty. per Unit of Measure" /
              QtyPerUnitOfMeasure)
          ELSE
            ProdOrderComp.VALIDATE("Quantity per","Qty. per Unit of Measure" );
          ProdOrderComp.MODIFY;
        UNTIL ProdOrderComp.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckCapLedgEntry@1002() : Boolean;
    VAR
      CapLedgEntry@1001 : Record 5832;
    BEGIN
      CapLedgEntry.SETCURRENTKEY("Order Type","Order No.","Order Line No.");
      CapLedgEntry.SETRANGE("Order Type",CapLedgEntry."Order Type"::Production);
      CapLedgEntry.SETRANGE("Order No.","Prod. Order No.");
      CapLedgEntry.SETRANGE("Order Line No.","Line No.");

      EXIT(NOT CapLedgEntry.ISEMPTY);
    END;

    LOCAL PROCEDURE CheckSubcontractPurchOrder@1003() : Boolean;
    VAR
      PurchLine@1001 : Record 39;
    BEGIN
      PurchLine.SETCURRENTKEY(
        "Document Type",Type,"Prod. Order No.","Prod. Order Line No.","Routing No.","Operation No.");
      PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
      PurchLine.SETRANGE(Type,PurchLine.Type::Item);
      PurchLine.SETRANGE("Prod. Order No.","Prod. Order No.");
      PurchLine.SETRANGE("Prod. Order Line No.","Line No.");

      EXIT(NOT PurchLine.ISEMPTY);
    END;

    LOCAL PROCEDURE ProdOrderCompExist@22() : Boolean;
    VAR
      ProdOrderComp@1000 : Record 5407;
    BEGIN
      ProdOrderComp.SETRANGE(Status,Status);
      ProdOrderComp.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderComp.SETRANGE("Prod. Order Line No.","Line No.");
      EXIT(NOT ProdOrderComp.ISEMPTY);
    END;

    [External]
    PROCEDURE UpdateProdOrderCompDim@26(NewDimSetID@1000 : Integer;OldDimSetID@1001 : Integer);
    VAR
      NewCompDimSetID@1002 : Integer;
    BEGIN
      IF NewDimSetID = OldDimSetID THEN
        EXIT;

      ProdOrderComp.RESET;
      ProdOrderComp.SETRANGE(Status,Status);
      ProdOrderComp.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderComp.SETRANGE("Prod. Order Line No.","Line No.");
      ProdOrderComp.LOCKTABLE;
      IF ProdOrderComp.FINDSET THEN
        REPEAT
          NewCompDimSetID := DimMgt.GetDeltaDimSetID(ProdOrderComp."Dimension Set ID",NewDimSetID,OldDimSetID);
          IF ProdOrderComp."Dimension Set ID" <> NewCompDimSetID THEN BEGIN
            ProdOrderComp."Dimension Set ID" := NewCompDimSetID;
            DimMgt.UpdateGlobalDimFromDimSetID(
              ProdOrderComp."Dimension Set ID",ProdOrderComp."Shortcut Dimension 1 Code",ProdOrderComp."Shortcut Dimension 2 Code");
            ProdOrderComp.MODIFY;
          END;
        UNTIL ProdOrderComp.NEXT = 0;
    END;

    [External]
    PROCEDURE ShowRouting@20();
    VAR
      ProdOrderRtngLine@1000 : Record 5409;
    BEGIN
      ProdOrderRtngLine.SETRANGE(Status,Status);
      ProdOrderRtngLine.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderRtngLine.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderRtngLine.SETRANGE("Routing No.","Routing No.");

      PAGE.RUNMODAL(PAGE::"Prod. Order Routing",ProdOrderRtngLine);
      CalcProdOrder.FindAndSetProdOrderLineBinCodeFromProdRtngLines(Status,"Prod. Order No.","Line No.");
    END;

    [External]
    PROCEDURE SetFilterByReleasedOrderNo@27(OrderNo@1000 : Code[20]);
    BEGIN
      RESET;
      SETCURRENTKEY(Status,"Prod. Order No.","Line No.","Item No.");
      SETRANGE(Status,Status::Released);
      SETRANGE("Prod. Order No.",OrderNo);
    END;

    [External]
    PROCEDURE TestItemFields@61(ItemNo@1000 : Code[20];VariantCode@1001 : Code[10];LocationCode@1002 : Code[10]);
    BEGIN
      TESTFIELD("Item No.",ItemNo);
      TESTFIELD("Variant Code",VariantCode);
      TESTFIELD("Location Code",LocationCode);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@138(VAR ProdOrderLine@1000 : Record 5406;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    BEGIN
    END.
  }
}

