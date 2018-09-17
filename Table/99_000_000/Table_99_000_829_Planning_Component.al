OBJECT Table 99000829 Planning Component
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               ReservePlanningComponent.VerifyQuantity(Rec,xRec);

               ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
               ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");

               GetReqLine;
               "Planning Line Origin" := ReqLine."Planning Line Origin";
               IF "Planning Line Origin" <> "Planning Line Origin"::"Order Planning" THEN
                 TESTFIELD("Worksheet Template Name");

               "Due Date" := ReqLine."Starting Date";
             END;

    OnModify=BEGIN
               ReservePlanningComponent.VerifyChange(Rec,xRec);
             END;

    OnDelete=BEGIN
               ReservePlanningComponent.DeleteLine(Rec);

               CALCFIELDS("Reserved Qty. (Base)");
               TESTFIELD("Reserved Qty. (Base)",0);
             END;

    OnRename=BEGIN
               ERROR(Text000,TABLECAPTION);
             END;

    CaptionML=[DAN=Planl�gning - komponent;
               ENU=Planning Component];
    LookupPageID=Page99000861;
    DrillDownPageID=Page99000861;
  }
  FIELDS
  {
    { 1   ;   ;Worksheet Template Name;Code10     ;TableRelation="Req. Wksh. Template";
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Worksheet Template Name] }
    { 2   ;   ;Worksheet Batch Name;Code10        ;TableRelation="Requisition Wksh. Name".Name WHERE (Worksheet Template Name=FIELD(Worksheet Template Name));
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Worksheet Batch Name] }
    { 3   ;   ;Worksheet Line No.  ;Integer       ;TableRelation="Requisition Line"."Line No." WHERE (Worksheet Template Name=FIELD(Worksheet Template Name),
                                                                                                      Journal Batch Name=FIELD(Worksheet Batch Name));
                                                   CaptionML=[DAN=Kladdelinjenr.;
                                                              ENU=Worksheet Line No.] }
    { 5   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.];
                                                   BlankZero=Yes }
    { 11  ;   ;Item No.            ;Code20        ;TableRelation=Item WHERE (Type=CONST(Inventory));
                                                   OnValidate=BEGIN
                                                                ReservePlanningComponent.VerifyChange(Rec,xRec);
                                                                CALCFIELDS("Reserved Qty. (Base)");
                                                                TESTFIELD("Reserved Qty. (Base)",0);

                                                                IF "Item No." = '' THEN BEGIN
                                                                  "Dimension Set ID" := 0;
                                                                  "Shortcut Dimension 1 Code" := '';
                                                                  "Shortcut Dimension 2 Code" := '';
                                                                  EXIT;
                                                                END;

                                                                GetItem;
                                                                Description := Item.Description;
                                                                VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");
                                                                GetUpdateFromSKU;
                                                                CreateDim(DATABASE::Item,"Item No.");
                                                              END;

                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 12  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 13  ;   ;Unit of Measure Code;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Item No.");

                                                                GetItem;
                                                                GetGLSetup;

                                                                "Unit Cost" := Item."Unit Cost";

                                                                IF "Unit of Measure Code" <> '' THEN BEGIN
                                                                  "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                                                                  "Unit Cost" :=
                                                                    ROUND(
                                                                      Item."Unit Cost" * "Qty. per Unit of Measure",
                                                                      GLSetup."Unit-Amount Rounding Precision");
                                                                END ELSE
                                                                  "Qty. per Unit of Measure" := 1;

                                                                "Indirect Cost %" := ROUND(Item."Indirect Cost %" * "Qty. per Unit of Measure",0.00001);

                                                                "Overhead Rate" :=
                                                                  ROUND(Item."Overhead Rate" * "Qty. per Unit of Measure",
                                                                    GLSetup."Unit-Amount Rounding Precision");

                                                                "Direct Unit Cost" :=
                                                                  ROUND(
                                                                    ("Unit Cost" - "Overhead Rate") / (1 + "Indirect Cost %" / 100),
                                                                    GLSetup."Unit-Amount Rounding Precision");

                                                                VALIDATE("Calculation Formula");
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 14  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 15  ;   ;Position            ;Code10        ;CaptionML=[DAN=Position;
                                                              ENU=Position] }
    { 16  ;   ;Position 2          ;Code10        ;CaptionML=[DAN=Position 2;
                                                              ENU=Position 2] }
    { 17  ;   ;Position 3          ;Code10        ;CaptionML=[DAN=Position 3;
                                                              ENU=Position 3] }
    { 18  ;   ;Lead-Time Offset    ;DateFormula   ;CaptionML=[DAN=Genneml�bstid;
                                                              ENU=Lead-Time Offset] }
    { 19  ;   ;Routing Link Code   ;Code10        ;TableRelation="Routing Link";
                                                   OnValidate=VAR
                                                                PlanningRtngLine@1001 : Record 99000830;
                                                              BEGIN
                                                                VALIDATE("Expected Quantity",Quantity * PlanningNeeds);

                                                                "Due Date" := ReqLine."Starting Date";
                                                                "Due Time" := ReqLine."Starting Time";
                                                                IF "Routing Link Code" <> '' THEN BEGIN
                                                                  PlanningRtngLine.SETRANGE("Worksheet Template Name","Worksheet Template Name");
                                                                  PlanningRtngLine.SETRANGE("Worksheet Batch Name","Worksheet Batch Name");
                                                                  PlanningRtngLine.SETRANGE("Worksheet Line No.","Worksheet Line No.");
                                                                  PlanningRtngLine.SETRANGE("Routing Link Code","Routing Link Code");
                                                                  IF PlanningRtngLine.FINDFIRST THEN BEGIN
                                                                    "Due Date" := PlanningRtngLine."Starting Date";
                                                                    "Due Time" := ReqLine."Starting Time";
                                                                  END;
                                                                END;
                                                                IF FORMAT("Lead-Time Offset") <> '' THEN BEGIN
                                                                  IF "Due Date" = 0D THEN
                                                                    "Due Date" := ReqLine."Ending Date";
                                                                  "Due Date" :=
                                                                    "Due Date" -
                                                                    (CALCDATE("Lead-Time Offset",WORKDATE) - WORKDATE);
                                                                  "Due Time" := 0T;
                                                                END;
                                                                VALIDATE("Due Date");
                                                              END;

                                                   CaptionML=[DAN=Rutebindingskode;
                                                              ENU=Routing Link Code] }
    { 20  ;   ;Scrap %             ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Expected Quantity",Quantity * PlanningNeeds);
                                                              END;

                                                   CaptionML=[DAN=Spildpct.;
                                                              ENU=Scrap %];
                                                   DecimalPlaces=0:5;
                                                   MaxValue=100;
                                                   BlankNumbers=BlankNeg }
    { 21  ;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=BEGIN
                                                                ReservePlanningComponent.VerifyChange(Rec,xRec);
                                                                CALCFIELDS("Reserved Qty. (Base)");
                                                                TESTFIELD("Reserved Qty. (Base)",0);
                                                                GetUpdateFromSKU;
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 25  ;   ;Expected Quantity   ;Decimal       ;OnValidate=BEGIN
                                                                IF Item.GET("Item No.") AND ("Ref. Order Type" <> "Ref. Order Type"::Assembly) THEN
                                                                  IF Item."Rounding Precision" > 0 THEN
                                                                    "Expected Quantity" := ROUND("Expected Quantity",Item."Rounding Precision",'>');
                                                                "Expected Quantity (Base)" := ROUND("Expected Quantity" * "Qty. per Unit of Measure",0.00001);
                                                                "Net Quantity (Base)" := "Expected Quantity (Base)" - "Original Expected Qty. (Base)";

                                                                ReservePlanningComponent.VerifyQuantity(Rec,xRec);

                                                                "Cost Amount" := ROUND("Expected Quantity" * "Unit Cost");
                                                                "Overhead Amount" :=
                                                                  ROUND(
                                                                    "Expected Quantity" *
                                                                    (("Direct Unit Cost" * "Indirect Cost %" / 100) + "Overhead Rate"));
                                                                "Direct Cost Amount" := ROUND("Expected Quantity" * "Direct Unit Cost");
                                                              END;

                                                   CaptionML=[DAN=Forventet antal;
                                                              ENU=Expected Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 28  ;   ;Flushing Method     ;Option        ;CaptionML=[DAN=Tr�kmetode;
                                                              ENU=Flushing Method];
                                                   OptionCaptionML=[DAN=Manuelt,Forl�ns,Bagl�ns,Pluk + Forl�ns,Pluk + Bagl�ns;
                                                                    ENU=Manual,Forward,Backward,Pick + Forward,Pick + Backward];
                                                   OptionString=Manual,Forward,Backward,Pick + Forward,Pick + Backward }
    { 30  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                ReservePlanningComponent.VerifyChange(Rec,xRec);
                                                                GetUpdateFromSKU;
                                                                GetDefaultBin;
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 31  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 32  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 33  ;   ;Bin Code            ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                ReservePlanningComponent.VerifyChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 35  ;   ;Supplied-by Line No.;Integer       ;TableRelation="Requisition Line"."Line No." WHERE (Worksheet Template Name=FIELD(Worksheet Template Name),
                                                                                                      Journal Batch Name=FIELD(Worksheet Batch Name),
                                                                                                      Line No.=FIELD(Supplied-by Line No.));
                                                   CaptionML=[DAN=Leveret-af-linjenr.;
                                                              ENU=Supplied-by Line No.] }
    { 36  ;   ;Planning Level Code ;Integer       ;CaptionML=[DAN=Planl�gningsniveaukode;
                                                              ENU=Planning Level Code];
                                                   Editable=No }
    { 37  ;   ;Ref. Order Status   ;Option        ;CaptionML=[DAN=Referenceordrestatus;
                                                              ENU=Ref. Order Status];
                                                   OptionCaptionML=[DAN=Simuleret,Planlagt,Fastlagt,Frigivet;
                                                                    ENU=Simulated,Planned,Firm Planned,Released];
                                                   OptionString=Simulated,Planned,Firm Planned,Released }
    { 38  ;   ;Ref. Order No.      ;Code20        ;CaptionML=[DAN=Referenceordrenr.;
                                                              ENU=Ref. Order No.] }
    { 39  ;   ;Ref. Order Line No. ;Integer       ;CaptionML=[DAN=Referenceordrelinjenr.;
                                                              ENU=Ref. Order Line No.] }
    { 40  ;   ;Length              ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Calculation Formula");
                                                              END;

                                                   CaptionML=[DAN=L�ngde;
                                                              ENU=Length];
                                                   DecimalPlaces=0:5 }
    { 41  ;   ;Width               ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Calculation Formula");
                                                              END;

                                                   CaptionML=[DAN=Bredde;
                                                              ENU=Width];
                                                   DecimalPlaces=0:5 }
    { 42  ;   ;Weight              ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Calculation Formula");
                                                              END;

                                                   CaptionML=[DAN=V�gt;
                                                              ENU=Weight];
                                                   DecimalPlaces=0:5 }
    { 43  ;   ;Depth               ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Calculation Formula");
                                                              END;

                                                   CaptionML=[DAN=Dybde;
                                                              ENU=Depth];
                                                   DecimalPlaces=0:5 }
    { 44  ;   ;Calculation Formula ;Option        ;OnValidate=BEGIN
                                                                CASE "Calculation Formula" OF
                                                                  "Calculation Formula"::" ":
                                                                    Quantity := "Quantity per";
                                                                  "Calculation Formula"::Length:
                                                                    Quantity := ROUND(Length * "Quantity per",0.00001);
                                                                  "Calculation Formula"::"Length * Width":
                                                                    Quantity := ROUND(Length * Width * "Quantity per",0.00001);
                                                                  "Calculation Formula"::"Length * Width * Depth":
                                                                    Quantity := ROUND(Length * Width * Depth * "Quantity per",0.00001);
                                                                  "Calculation Formula"::Weight:
                                                                    Quantity := ROUND(Weight * "Quantity per",0.00001);
                                                                END;
                                                                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
                                                                VALIDATE("Expected Quantity",Quantity * PlanningNeeds);
                                                              END;

                                                   CaptionML=[DAN=Beregningsformel;
                                                              ENU=Calculation Formula];
                                                   OptionCaptionML=[DAN=" ,L�ngde,L�ngde * Bredde,L�ngde * Bredde * Dybde,V�gt";
                                                                    ENU=" ,Length,Length * Width,Length * Width * Depth,Weight"];
                                                   OptionString=[ ,Length,Length * Width,Length * Width * Depth,Weight] }
    { 45  ;   ;Quantity per        ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Calculation Formula");
                                                              END;

                                                   CaptionML=[DAN=Antal pr.;
                                                              ENU=Quantity per];
                                                   DecimalPlaces=0:5 }
    { 46  ;   ;Ref. Order Type     ;Option        ;CaptionML=[DAN=Referenceordretype;
                                                              ENU=Ref. Order Type];
                                                   OptionCaptionML=[DAN=" ,K�b,Prod. ordre,Overf�rsel,Montage";
                                                                    ENU=" ,Purchase,Prod. Order,Transfer,Assembly"];
                                                   OptionString=[ ,Purchase,Prod. Order,Transfer,Assembly];
                                                   Editable=No }
    { 50  ;   ;Unit Cost           ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Item No.");

                                                                GetItem;
                                                                GetGLSetup;

                                                                IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
                                                                  IF CurrFieldNo = FIELDNO("Unit Cost") THEN
                                                                    ERROR(
                                                                      Text001,
                                                                      FIELDCAPTION("Unit Cost"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");

                                                                  "Unit Cost" :=
                                                                    ROUND(Item."Unit Cost" * "Qty. per Unit of Measure");
                                                                  "Indirect Cost %" :=
                                                                    ROUND(Item."Indirect Cost %" * "Qty. per Unit of Measure",0.00001);
                                                                  "Overhead Rate" :=
                                                                    ROUND(Item."Overhead Rate" * "Qty. per Unit of Measure",
                                                                      GLSetup."Unit-Amount Rounding Precision");
                                                                  "Direct Unit Cost" :=
                                                                    ROUND(("Unit Cost" - "Overhead Rate") / (1 + "Indirect Cost %" / 100),
                                                                      GLSetup."Unit-Amount Rounding Precision");
                                                                END;

                                                                VALIDATE("Expected Quantity");
                                                              END;

                                                   CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   AutoFormatType=1 }
    { 51  ;   ;Cost Amount         ;Decimal       ;CaptionML=[DAN=Kostbel�b;
                                                              ENU=Cost Amount];
                                                   AutoFormatType=2 }
    { 52  ;   ;Due Date            ;Date          ;OnValidate=VAR
                                                                CheckDateConflict@1000 : Codeunit 99000815;
                                                              BEGIN
                                                                CheckDateConflict.PlanningComponentCheck(Rec,CurrFieldNo <> 0);
                                                                UpdateDatetime;
                                                              END;

                                                   CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 53  ;   ;Due Time            ;Time          ;OnValidate=BEGIN
                                                                UpdateDatetime;
                                                              END;

                                                   CaptionML=[DAN=Forfaldstid;
                                                              ENU=Due Time] }
    { 55  ;   ;Direct Unit Cost    ;Decimal       ;CaptionML=[DAN=K�bspris;
                                                              ENU=Direct Unit Cost];
                                                   DecimalPlaces=2:5 }
    { 56  ;   ;Indirect Cost %     ;Decimal       ;OnValidate=BEGIN
                                                                "Direct Unit Cost" :=
                                                                  ROUND("Unit Cost" / (1 + "Indirect Cost %" / 100) - "Overhead Rate");
                                                              END;

                                                   CaptionML=[DAN=Indir. omkost.pct.;
                                                              ENU=Indirect Cost %];
                                                   DecimalPlaces=0:5 }
    { 57  ;   ;Overhead Rate       ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Indirect Cost %");
                                                              END;

                                                   CaptionML=[DAN=IPO-bidrag;
                                                              ENU=Overhead Rate];
                                                   DecimalPlaces=0:5 }
    { 58  ;   ;Direct Cost Amount  ;Decimal       ;CaptionML=[DAN=K�bsbel�b;
                                                              ENU=Direct Cost Amount];
                                                   DecimalPlaces=2:2 }
    { 59  ;   ;Overhead Amount     ;Decimal       ;CaptionML=[DAN=Indirekte kostbel�b;
                                                              ENU=Overhead Amount];
                                                   DecimalPlaces=2:2 }
    { 60  ;   ;Qty. per Unit of Measure;Decimal   ;CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 62  ;   ;Quantity (Base)     ;Decimal       ;CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 63  ;   ;Reserved Qty. (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(Worksheet Template Name),
                                                                                                                 Source Ref. No.=FIELD(Line No.),
                                                                                                                 Source Type=CONST(99000829),
                                                                                                                 Source Subtype=CONST(0),
                                                                                                                 Source Batch Name=FIELD(Worksheet Batch Name),
                                                                                                                 Source Prod. Order Line=FIELD(Worksheet Line No.),
                                                                                                                 Reservation Status=CONST(Reservation)));
                                                   CaptionML=[DAN=Reserveret antal (basis);
                                                              ENU=Reserved Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 71  ;   ;Reserved Quantity   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Worksheet Template Name),
                                                                                                        Source Ref. No.=FIELD(Line No.),
                                                                                                        Source Type=CONST(99000829),
                                                                                                        Source Subtype=CONST(0),
                                                                                                        Source Batch Name=FIELD(Worksheet Batch Name),
                                                                                                        Source Prod. Order Line=FIELD(Worksheet Line No.),
                                                                                                        Reservation Status=CONST(Reservation)));
                                                   CaptionML=[DAN=Reserveret antal;
                                                              ENU=Reserved Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 73  ;   ;Expected Quantity (Base);Decimal   ;CaptionML=[DAN=Forventet antal (basis);
                                                              ENU=Expected Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 74  ;   ;Original Expected Qty. (Base);Decimal;
                                                   CaptionML=[DAN=Opr. forv. antal (basis);
                                                              ENU=Original Expected Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 75  ;   ;Net Quantity (Base) ;Decimal       ;CaptionML=[DAN=Nettoantal (basis);
                                                              ENU=Net Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 76  ;   ;Due Date-Time       ;DateTime      ;OnValidate=BEGIN
                                                                "Due Date" := DT2DATE("Due Date-Time");
                                                                "Due Time" := DT2TIME("Due Date-Time");
                                                                VALIDATE("Due Date");
                                                              END;

                                                   CaptionML=[DAN=Forfaldsdato/-tidspunkt;
                                                              ENU=Due Date-Time] }
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
    { 99000875;;Critical           ;Boolean       ;CaptionML=[DAN=Kritisk;
                                                              ENU=Critical] }
    { 99000915;;Planning Line Origin;Option       ;CaptionML=[DAN=Oprindelig planl�gningslinje;
                                                              ENU=Planning Line Origin];
                                                   OptionCaptionML=[DAN=" ,Aktionsmeddelelse,Planl�gning,Ordreplanl�gning";
                                                                    ENU=" ,Action Message,Planning,Order Planning"];
                                                   OptionString=[ ,Action Message,Planning,Order Planning];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Worksheet Template Name,Worksheet Batch Name,Worksheet Line No.,Line No.;
                                                   SumIndexFields=Cost Amount;
                                                   MaintainSIFTIndex=No;
                                                   Clustered=Yes }
    {    ;Item No.,Variant Code,Location Code,Due Date,Planning Line Origin;
                                                   SumIndexFields=Expected Quantity (Base),Cost Amount;
                                                   MaintainSIFTIndex=No }
    { No ;Item No.,Variant Code,Location Code,Shortcut Dimension 1 Code,Shortcut Dimension 2 Code,Planning Line Origin,Due Date;
                                                   SumIndexFields=Expected Quantity (Base),Cost Amount;
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    {    ;Worksheet Template Name,Worksheet Batch Name,Worksheet Line No.,Item No.;
                                                   MaintainSQLIndex=No }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text001@1001 : TextConst 'DAN=Du kan ikke �ndre %1, n�r %2 er %3.;ENU=You cannot change %1 when %2 is %3.';
      Item@1003 : Record 27;
      ReservEntry@1004 : Record 337;
      GLSetup@1018 : Record 98;
      ReqLine@1011 : Record 246;
      Location@1006 : Record 14;
      ReservEngineMgt@1007 : Codeunit 99000831;
      ReservePlanningComponent@1008 : Codeunit 99000840;
      UOMMgt@1009 : Codeunit 5402;
      DimMgt@1019 : Codeunit 408;
      Reservation@1002 : Page 498;
      GLSetupRead@1005 : Boolean;

    [External]
    PROCEDURE Caption@5() : Text;
    VAR
      ReqWkshName@1000 : Record 245;
      ReqLine@1001 : Record 246;
    BEGIN
      IF GETFILTERS = '' THEN
        EXIT('');

      IF NOT ReqWkshName.GET("Worksheet Template Name","Worksheet Batch Name") THEN
        EXIT('');

      IF NOT ReqLine.GET("Worksheet Template Name","Worksheet Batch Name","Worksheet Line No.") THEN
        CLEAR(ReqLine);

      EXIT(
        STRSUBSTNO('%1 %2 %3 %4 %5',
          "Worksheet Batch Name",ReqWkshName.Description,ReqLine.Type,ReqLine."No.",ReqLine.Description));
    END;

    LOCAL PROCEDURE PlanningNeeds@1() : Decimal;
    VAR
      PlanningRtngLine@1001 : Record 99000830;
    BEGIN
      GetReqLine;

      "Due Date" := ReqLine."Starting Date";

      PlanningRtngLine.RESET;
      PlanningRtngLine.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      PlanningRtngLine.SETRANGE("Worksheet Batch Name","Worksheet Batch Name");
      PlanningRtngLine.SETRANGE("Worksheet Line No.","Worksheet Line No.");
      IF "Routing Link Code" <> '' THEN
        PlanningRtngLine.SETRANGE("Routing Link Code","Routing Link Code");
      IF PlanningRtngLine.FINDFIRST THEN
        EXIT(
          ReqLine.Quantity *
          (1 + ReqLine."Scrap %" / 100) *
          (1 + PlanningRtngLine."Scrap Factor % (Accumulated)") *
          (1 + "Scrap %" / 100) +
          PlanningRtngLine."Fixed Scrap Qty. (Accum.)");

      EXIT(ReqLine.Quantity * (1 + ReqLine."Scrap %" / 100) * (1 + "Scrap %" / 100));
    END;

    [External]
    PROCEDURE ShowReservation@8();
    BEGIN
      TESTFIELD("Item No.");
      CLEAR(Reservation);
      Reservation.SetPlanningComponent(Rec);
      Reservation.RUNMODAL;
    END;

    [External]
    PROCEDURE ShowReservationEntries@21(Modal@1000 : Boolean);
    BEGIN
      TESTFIELD("Item No.");
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
      ReservePlanningComponent.FilterReservFor(ReservEntry,Rec);
      IF Modal THEN
        PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
      ELSE
        PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    END;

    [External]
    PROCEDURE TransferFromComponent@3(VAR ProdOrderComp@1000 : Record 5407);
    BEGIN
      "Ref. Order Type" := "Ref. Order Type"::"Prod. Order";
      "Ref. Order Status" := ProdOrderComp.Status;
      "Ref. Order No." := ProdOrderComp."Prod. Order No.";
      "Ref. Order Line No." := ProdOrderComp."Prod. Order Line No.";
      "Line No." := ProdOrderComp."Line No.";
      "Item No." := ProdOrderComp."Item No.";
      Description := ProdOrderComp.Description;
      "Unit of Measure Code" := ProdOrderComp."Unit of Measure Code";
      "Quantity per" := ProdOrderComp."Quantity per";
      Quantity := ProdOrderComp.Quantity;
      Position := ProdOrderComp.Position;
      "Position 2" := ProdOrderComp."Position 2";
      "Position 3" := ProdOrderComp."Position 3";
      "Lead-Time Offset" := ProdOrderComp."Lead-Time Offset";
      "Routing Link Code" := ProdOrderComp."Routing Link Code";
      "Scrap %" := ProdOrderComp."Scrap %";
      "Variant Code" := ProdOrderComp."Variant Code";
      "Expected Quantity" := ProdOrderComp."Expected Quantity";
      "Location Code" := ProdOrderComp."Location Code";
      "Dimension Set ID" := ProdOrderComp."Dimension Set ID";
      "Shortcut Dimension 1 Code" := ProdOrderComp."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := ProdOrderComp."Shortcut Dimension 2 Code";
      "Bin Code" := ProdOrderComp."Bin Code";
      Length := ProdOrderComp.Length;
      Width := ProdOrderComp.Width;
      Weight := ProdOrderComp.Weight;
      Depth := ProdOrderComp.Depth;
      "Calculation Formula" := ProdOrderComp."Calculation Formula";
      "Planning Level Code" := ProdOrderComp."Planning Level Code";
      "Unit Cost" := ProdOrderComp."Unit Cost";
      "Cost Amount" := ProdOrderComp."Cost Amount";
      "Due Date" := ProdOrderComp."Due Date";
      "Direct Unit Cost" := ProdOrderComp."Direct Unit Cost";
      "Indirect Cost %" := ProdOrderComp."Indirect Cost %";
      "Overhead Rate" := ProdOrderComp."Overhead Rate";
      "Direct Cost Amount" := ProdOrderComp."Direct Cost Amount";
      "Overhead Amount" := ProdOrderComp."Overhead Amount";
      "Qty. per Unit of Measure" := ProdOrderComp."Qty. per Unit of Measure";
      "Quantity (Base)" := ProdOrderComp."Quantity (Base)";
      "Expected Quantity (Base)" := ProdOrderComp."Expected Qty. (Base)";
      "Original Expected Qty. (Base)" := ProdOrderComp."Expected Qty. (Base)";
      UpdateDatetime;

      OnAfterTransferFromComponent(Rec,ProdOrderComp);
    END;

    [External]
    PROCEDURE TransferFromAsmLine@11(VAR AsmLine@1000 : Record 901);
    BEGIN
      "Ref. Order Type" := "Ref. Order Type"::Assembly;
      "Ref. Order Status" := AsmLine."Document Type";
      "Ref. Order No." := AsmLine."Document No.";
      "Ref. Order Line No." := AsmLine."Line No.";
      "Line No." := AsmLine."Line No.";
      "Item No." := AsmLine."No.";
      Description := COPYSTR(AsmLine.Description,1,MAXSTRLEN(Description));
      "Unit of Measure Code" := AsmLine."Unit of Measure Code";
      "Quantity per" := AsmLine."Quantity per";
      Quantity := AsmLine."Quantity per";
      "Lead-Time Offset" := AsmLine."Lead-Time Offset";
      Position := AsmLine.Position;
      "Position 2" := AsmLine."Position 2";
      "Position 3" := AsmLine."Position 3";
      "Variant Code" := AsmLine."Variant Code";
      "Expected Quantity" := AsmLine.Quantity;
      "Location Code" := AsmLine."Location Code";
      "Dimension Set ID" := AsmLine."Dimension Set ID";
      "Shortcut Dimension 1 Code" := AsmLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := AsmLine."Shortcut Dimension 2 Code";
      "Bin Code" := AsmLine."Bin Code";
      "Unit Cost" := AsmLine."Unit Cost";
      "Cost Amount" := AsmLine."Cost Amount";
      "Due Date" := AsmLine."Due Date";
      "Qty. per Unit of Measure" := AsmLine."Qty. per Unit of Measure";
      "Quantity (Base)" := AsmLine."Quantity per";
      "Expected Quantity (Base)" := AsmLine."Quantity (Base)";
      "Original Expected Qty. (Base)" := AsmLine."Quantity (Base)";
      UpdateDatetime;

      OnAfterTransferFromAsmLine(Rec,AsmLine);
    END;

    LOCAL PROCEDURE GetUpdateFromSKU@4();
    VAR
      SKU@1000 : Record 5700;
      GetPlanningParameters@1001 : Codeunit 99000855;
    BEGIN
      GetPlanningParameters.AtSKU(SKU,"Item No.","Variant Code","Location Code");
      VALIDATE("Flushing Method",SKU."Flushing Method");
    END;

    [External]
    PROCEDURE BlockDynamicTracking@17(SetBlock@1000 : Boolean);
    BEGIN
      ReservePlanningComponent.Block(SetBlock);
    END;

    LOCAL PROCEDURE UpdateDatetime@20();
    BEGIN
      "Due Date-Time" := CREATEDATETIME("Due Date","Due Time");
    END;

    [External]
    PROCEDURE OpenItemTrackingLines@6500();
    BEGIN
      IF "Item No." <> '' THEN
        ReservePlanningComponent.CallItemTracking(Rec);
    END;

    LOCAL PROCEDURE CreateDim@12(Type1@1000 : Integer;No1@1001 : Code[20]);
    VAR
      TableID@1003 : ARRAY [10] OF Integer;
      No@1004 : ARRAY [10] OF Code[20];
      DimensionSetIDArr@1005 : ARRAY [10] OF Integer;
    BEGIN
      TableID[1] := Type1;
      No[1] := No1;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      GetReqLine;
      DimensionSetIDArr[1] :=
        DimMgt.GetRecDefaultDimID(Rec,CurrFieldNo,TableID,No,'',"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
      DimensionSetIDArr[2] := ReqLine."Dimension Set ID";
      "Dimension Set ID" :=
        DimMgt.GetCombinedDimensionSetID(DimensionSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@9(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    LOCAL PROCEDURE GetGLSetup@14();
    BEGIN
      IF NOT GLSetupRead THEN
        GLSetup.GET;
      GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE GetItem@2();
    BEGIN
      IF "Item No." <> Item."No." THEN
        Item.GET("Item No.");
    END;

    LOCAL PROCEDURE GetReqLine@6();
    BEGIN
      ReqLine.GET("Worksheet Template Name","Worksheet Batch Name","Worksheet Line No.");
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
    PROCEDURE GetDefaultBin@50();
    BEGIN
      IF (Quantity * xRec.Quantity > 0) AND
         ("Item No." = xRec."Item No.") AND
         ("Location Code" = xRec."Location Code") AND
         ("Variant Code" = xRec."Variant Code")
      THEN
        EXIT;

      "Bin Code" := '';
      IF ("Location Code" <> '') AND ("Item No." <> '') THEN
        VALIDATE("Bin Code",GetToBin);
    END;

    LOCAL PROCEDURE FindFirstRtngLine@16(VAR PlanningRoutingLine@1000 : Record 99000830;ReqLine@1001 : Record 246) : Boolean;
    BEGIN
      PlanningRoutingLine.RESET;
      PlanningRoutingLine.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      PlanningRoutingLine.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
      PlanningRoutingLine.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
      PlanningRoutingLine.SETFILTER("No.",'<>%1','');
      PlanningRoutingLine.SETRANGE("Previous Operation No.",'');
      IF "Routing Link Code" <> '' THEN BEGIN
        PlanningRoutingLine.SETRANGE("Routing Link Code","Routing Link Code");
        PlanningRoutingLine.SETRANGE("Previous Operation No.");
        IF PlanningRoutingLine.COUNT = 0 THEN BEGIN
          PlanningRoutingLine.SETRANGE("Routing Link Code");
          PlanningRoutingLine.SETRANGE("Previous Operation No.",'');
        END;
      END;

      EXIT(PlanningRoutingLine.FINDFIRST);
    END;

    LOCAL PROCEDURE FilterLinesWithItemToPlan@70(VAR Item@1000 : Record 27);
    BEGIN
      RESET;
      SETCURRENTKEY("Item No.");
      SETRANGE("Item No.",Item."No.");
      SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
      SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
      SETFILTER("Due Date",Item.GETFILTER("Date Filter"));
      Item.COPYFILTER("Global Dimension 1 Filter","Shortcut Dimension 1 Code");
      Item.COPYFILTER("Global Dimension 2 Filter","Shortcut Dimension 2 Code");
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
      UntrackedPlngElement.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      UntrackedPlngElement.SETRANGE("Worksheet Batch Name","Worksheet Batch Name");
      UntrackedPlngElement.SETRANGE("Item No.","Item No.");
      UntrackedPlngElement.SETRANGE("Source Type",DATABASE::"Production Forecast Entry");
      IF UntrackedPlngElement.FINDFIRST THEN BEGIN
        ForecastName := COPYSTR(UntrackedPlngElement."Source ID",1,10);
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE ShowDimensions@7();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",
          STRSUBSTNO(
            '%1 %2 %3',"Worksheet Template Name","Worksheet Batch Name",
            "Worksheet Line No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    LOCAL PROCEDURE GetToBin@15() BinCode : Code[20];
    BEGIN
      GetLocation("Location Code");
      GetReqLine;
      BinCode := GetRefOrderTypeBin;
      IF BinCode <> '' THEN
        EXIT;
      EXIT(GetWMSDefaultBin);
    END;

    LOCAL PROCEDURE GetRefOrderTypeBin@28() BinCode : Code[20];
    VAR
      PlanningRoutingLine@1000 : Record 99000830;
      WMSManagement@1001 : Codeunit 7302;
    BEGIN
      CASE ReqLine."Ref. Order Type" OF
        ReqLine."Ref. Order Type"::"Prod. Order":
          BEGIN
            IF "Location Code" = ReqLine."Location Code" THEN
              IF FindFirstRtngLine(PlanningRoutingLine,ReqLine) THEN
                BinCode := WMSManagement.GetProdCenterBinCode(
                    PlanningRoutingLine.Type,PlanningRoutingLine."No.","Location Code",TRUE,"Flushing Method");
            IF BinCode <> '' THEN
              EXIT(BinCode);
            BinCode := GetFlushingMethodBin;
          END;
        ReqLine."Ref. Order Type"::Assembly:
          BinCode := Location."To-Assembly Bin Code";
      END;
    END;

    LOCAL PROCEDURE GetFlushingMethodBin@23() : Code[20];
    BEGIN
      CASE "Flushing Method" OF
        "Flushing Method"::Manual,
        "Flushing Method"::"Pick + Forward",
        "Flushing Method"::"Pick + Backward":
          EXIT(Location."To-Production Bin Code");
        "Flushing Method"::Forward,
        "Flushing Method"::Backward:
          EXIT(Location."Open Shop Floor Bin Code");
      END;
    END;

    LOCAL PROCEDURE GetWMSDefaultBin@25() : Code[20];
    VAR
      WMSManagement@1002 : Codeunit 7302;
      BinCode@1000 : Code[20];
    BEGIN
      IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
        WMSManagement.GetDefaultBin("Item No.","Variant Code","Location Code",BinCode);
      EXIT(BinCode);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@138(VAR PlanningComponent@1000 : Record 99000829;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferFromComponent@139(VAR PlanningComponent@1000 : Record 99000829;VAR ProdOrderComp@1001 : Record 5407);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferFromAsmLine@140(VAR PlanningComponent@1000 : Record 99000829;AssemblyLine@1001 : Record 901);
    BEGIN
    END;

    BEGIN
    END.
  }
}

