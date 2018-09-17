OBJECT Table 99000830 Planning Routing Line
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
               IF "Next Operation No." = '' THEN
                 SetNextOperations;
             END;

    OnDelete=BEGIN
               ProdOrderCapNeed.SETCURRENTKEY("Worksheet Template Name","Worksheet Batch Name","Worksheet Line No.");
               ProdOrderCapNeed.SETRANGE("Worksheet Template Name","Worksheet Template Name");
               ProdOrderCapNeed.SETRANGE("Worksheet Batch Name","Worksheet Batch Name");
               ProdOrderCapNeed.SETRANGE("Worksheet Line No.","Worksheet Line No.");
               ProdOrderCapNeed.SETRANGE("Operation No.","Operation No.");
               ProdOrderCapNeed.DELETEALL;
             END;

    OnRename=BEGIN
               SetRecalcStatus;
             END;

    CaptionML=[DAN=Planl�gning - rutelinje;
               ENU=Planning Routing Line];
    LookupPageID=Page99000863;
    DrillDownPageID=Page99000863;
  }
  FIELDS
  {
    { 1   ;   ;Worksheet Template Name;Code10     ;TableRelation="Req. Wksh. Template";
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Worksheet Template Name];
                                                   Editable=No }
    { 2   ;   ;Worksheet Batch Name;Code10        ;TableRelation="Requisition Wksh. Name".Name WHERE (Worksheet Template Name=FIELD(Worksheet Template Name));
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Worksheet Batch Name] }
    { 3   ;   ;Worksheet Line No.  ;Integer       ;TableRelation="Requisition Line"."Line No." WHERE (Worksheet Template Name=FIELD(Worksheet Template Name),
                                                                                                      Journal Batch Name=FIELD(Worksheet Batch Name));
                                                   CaptionML=[DAN=Kladdelinjenr.;
                                                              ENU=Worksheet Line No.] }
    { 4   ;   ;Operation No.       ;Code10        ;OnValidate=BEGIN
                                                                SetRecalcStatus;

                                                                GetLine;
                                                                "Starting Time" := ReqLine."Starting Time";
                                                                "Ending Time" := ReqLine."Ending Time";
                                                                "Starting Date" := ReqLine."Starting Date";
                                                                "Ending Date" := ReqLine."Ending Date";
                                                              END;

                                                   CaptionML=[DAN=Operationsnr.;
                                                              ENU=Operation No.];
                                                   NotBlank=Yes }
    { 5   ;   ;Next Operation No.  ;Code30        ;OnValidate=BEGIN
                                                                SetRecalcStatus;

                                                                GetLine;
                                                                ReqLine.TESTFIELD("Routing Type",ReqLine."Routing Type"::Serial);
                                                              END;

                                                   CaptionML=[DAN=N�ste operationsnr.;
                                                              ENU=Next Operation No.] }
    { 6   ;   ;Previous Operation No.;Code30      ;OnValidate=BEGIN
                                                                SetRecalcStatus;
                                                              END;

                                                   CaptionML=[DAN=Forrige operationsnr.;
                                                              ENU=Previous Operation No.] }
    { 7   ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                "No." := '';
                                                                "Work Center No." := '';
                                                                "Work Center Group Code" := '';

                                                                ModifyCapNeedEntries;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Arbejdscenter,Produktionsressource;
                                                                    ENU=Work Center,Machine Center];
                                                   OptionString=Work Center,Machine Center }
    { 8   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(Work Center)) "Work Center"
                                                                 ELSE IF (Type=CONST(Machine Center)) "Machine Center";
                                                   OnValidate=BEGIN
                                                                SetRecalcStatus;

                                                                IF "No." = '' THEN
                                                                  EXIT;

                                                                CASE Type OF
                                                                  Type::"Work Center":
                                                                    BEGIN
                                                                      WorkCenter.GET("No.");
                                                                      WorkCenter.TESTFIELD(Blocked,FALSE);
                                                                      WorkCenterTransferfields;
                                                                    END;
                                                                  Type::"Machine Center":
                                                                    BEGIN
                                                                      MachineCenter.GET("No.");
                                                                      MachineCenter.TESTFIELD(Blocked,FALSE);
                                                                      MachineCtrTransferfields;
                                                                    END;
                                                                END;
                                                                GetLine;
                                                                IF ReqLine."Routing Type" = ReqLine."Routing Type"::Serial THEN
                                                                  CalcStartingEndingDates;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 9   ;   ;Work Center No.     ;Code20        ;TableRelation="Work Center";
                                                   CaptionML=[DAN=Arbejdscenternr.;
                                                              ENU=Work Center No.];
                                                   Editable=No }
    { 10  ;   ;Work Center Group Code;Code10      ;TableRelation="Work Center Group";
                                                   CaptionML=[DAN=Arbejdscentergruppekode;
                                                              ENU=Work Center Group Code];
                                                   Editable=No }
    { 11  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 12  ;   ;Setup Time          ;Decimal       ;OnValidate=BEGIN
                                                                CalcStartingEndingDates;
                                                              END;

                                                   CaptionML=[DAN=Opstillingstid;
                                                              ENU=Setup Time];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 13  ;   ;Run Time            ;Decimal       ;OnValidate=BEGIN
                                                                CalcStartingEndingDates;
                                                              END;

                                                   CaptionML=[DAN=Operationstid;
                                                              ENU=Run Time];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 14  ;   ;Wait Time           ;Decimal       ;OnValidate=BEGIN
                                                                CalcStartingEndingDates;
                                                              END;

                                                   CaptionML=[DAN=Ventetid;
                                                              ENU=Wait Time];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 15  ;   ;Move Time           ;Decimal       ;OnValidate=BEGIN
                                                                CalcStartingEndingDates;
                                                              END;

                                                   CaptionML=[DAN=Transporttid;
                                                              ENU=Move Time];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 16  ;   ;Fixed Scrap Quantity;Decimal       ;OnValidate=BEGIN
                                                                SetRecalcStatus;
                                                              END;

                                                   CaptionML=[DAN=Fast spildantal;
                                                              ENU=Fixed Scrap Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 17  ;   ;Lot Size            ;Decimal       ;CaptionML=[DAN=Lotst�rrelse;
                                                              ENU=Lot Size];
                                                   DecimalPlaces=0:5 }
    { 18  ;   ;Scrap Factor %      ;Decimal       ;OnValidate=BEGIN
                                                                SetRecalcStatus;
                                                              END;

                                                   CaptionML=[DAN=Spildfaktorpct.;
                                                              ENU=Scrap Factor %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 19  ;   ;Setup Time Unit of Meas. Code;Code10;
                                                   TableRelation="Capacity Unit of Measure";
                                                   OnValidate=BEGIN
                                                                CalcStartingEndingDates;
                                                              END;

                                                   CaptionML=[DAN=Opstillingstidsenhedskode;
                                                              ENU=Setup Time Unit of Meas. Code] }
    { 20  ;   ;Run Time Unit of Meas. Code;Code10 ;TableRelation="Capacity Unit of Measure";
                                                   OnValidate=BEGIN
                                                                CalcStartingEndingDates;
                                                              END;

                                                   CaptionML=[DAN=Operationstidsenhedskode;
                                                              ENU=Run Time Unit of Meas. Code] }
    { 21  ;   ;Wait Time Unit of Meas. Code;Code10;TableRelation="Capacity Unit of Measure";
                                                   OnValidate=BEGIN
                                                                CalcStartingEndingDates;
                                                              END;

                                                   CaptionML=[DAN=Ventetidsenhedskode;
                                                              ENU=Wait Time Unit of Meas. Code] }
    { 22  ;   ;Move Time Unit of Meas. Code;Code10;TableRelation="Capacity Unit of Measure";
                                                   OnValidate=BEGIN
                                                                CalcStartingEndingDates;
                                                              END;

                                                   CaptionML=[DAN=Transporttidsenhedskode;
                                                              ENU=Move Time Unit of Meas. Code] }
    { 27  ;   ;Minimum Process Time;Decimal       ;CaptionML=[DAN=Min.procestid;
                                                              ENU=Minimum Process Time];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 28  ;   ;Maximum Process Time;Decimal       ;CaptionML=[DAN=Maks.procestid;
                                                              ENU=Maximum Process Time];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 30  ;   ;Concurrent Capacities;Decimal      ;InitValue=1;
                                                   OnValidate=BEGIN
                                                                CalcStartingEndingDates;
                                                              END;

                                                   CaptionML=[DAN=Samtidige kapaciteter;
                                                              ENU=Concurrent Capacities];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 31  ;   ;Send-Ahead Quantity ;Decimal       ;OnValidate=BEGIN
                                                                CalcStartingEndingDates;
                                                              END;

                                                   CaptionML=[DAN=Send-ahead-antal;
                                                              ENU=Send-Ahead Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 34  ;   ;Routing Link Code   ;Code10        ;TableRelation="Routing Link";
                                                   CaptionML=[DAN=Rutebindingskode;
                                                              ENU=Routing Link Code] }
    { 35  ;   ;Standard Task Code  ;Code10        ;TableRelation="Standard Task";
                                                   OnValidate=VAR
                                                                StandardTask@1000 : Record 99000778;
                                                              BEGIN
                                                                IF "Standard Task Code" = '' THEN
                                                                  EXIT;

                                                                StandardTask.GET("Standard Task Code");
                                                                Description := StandardTask.Description;
                                                              END;

                                                   CaptionML=[DAN=Standardoperationskode;
                                                              ENU=Standard Task Code] }
    { 40  ;   ;Unit Cost per       ;Decimal       ;CaptionML=[DAN=Kostpris pr.;
                                                              ENU=Unit Cost per];
                                                   MinValue=0;
                                                   AutoFormatType=1 }
    { 41  ;   ;Recalculate         ;Boolean       ;CaptionML=[DAN=Genberegn;
                                                              ENU=Recalculate];
                                                   Editable=No }
    { 50  ;   ;Sequence No.(Forward);Integer      ;CaptionML=[DAN=R�kkef�lgenr. (fremad);
                                                              ENU=Sequence No.(Forward)];
                                                   Editable=No }
    { 51  ;   ;Sequence No.(Backward);Integer     ;CaptionML=[DAN=R�kkef�lgenr. (bagud);
                                                              ENU=Sequence No.(Backward)];
                                                   Editable=No }
    { 52  ;   ;Fixed Scrap Qty. (Accum.);Decimal  ;CaptionML=[DAN=Fast spildantal (akkum.);
                                                              ENU=Fixed Scrap Qty. (Accum.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 53  ;   ;Scrap Factor % (Accumulated);Decimal;
                                                   CaptionML=[DAN=Spildfaktorpct. (akkum.);
                                                              ENU=Scrap Factor % (Accumulated)];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 55  ;   ;Sequence No. (Actual);Integer      ;CaptionML=[DAN=R�kkef�lgenr. (faktisk);
                                                              ENU=Sequence No. (Actual)];
                                                   Editable=No }
    { 56  ;   ;Direct Unit Cost    ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Indirect Cost %");
                                                              END;

                                                   CaptionML=[DAN=K�bspris;
                                                              ENU=Direct Unit Cost];
                                                   DecimalPlaces=2:5 }
    { 57  ;   ;Indirect Cost %     ;Decimal       ;OnValidate=BEGIN
                                                                GetGLSetup;
                                                                "Unit Cost per" :=
                                                                  ROUND("Direct Unit Cost" * (1 + "Indirect Cost %" / 100) + "Overhead Rate",GLSetup."Unit-Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Indir. omkost.pct.;
                                                              ENU=Indirect Cost %];
                                                   DecimalPlaces=0:5 }
    { 58  ;   ;Overhead Rate       ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Indirect Cost %");
                                                              END;

                                                   CaptionML=[DAN=IPO-bidrag;
                                                              ENU=Overhead Rate];
                                                   DecimalPlaces=0:5 }
    { 61  ;   ;Output Quantity     ;Decimal       ;CaptionML=[DAN=Afgangsantal;
                                                              ENU=Output Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 70  ;   ;Starting Time       ;Time          ;OnValidate=BEGIN
                                                                MODIFY;

                                                                PlanningRtngLine.GET(
                                                                  "Worksheet Template Name",
                                                                  "Worksheet Batch Name","Worksheet Line No.","Operation No.");

                                                                PlanningRoutingMgt.CalcSequenceFromActual(PlanningRtngLine,0,ReqLine);
                                                                PlanningRtngLine.SETCURRENTKEY(
                                                                  "Worksheet Template Name",
                                                                  "Worksheet Batch Name",
                                                                  "Worksheet Line No.","Sequence No. (Actual)");

                                                                PlngLnMgt.CalculateRoutingFromActual(PlanningRtngLine,0,FALSE);

                                                                CalculateRoutingBack;
                                                                CalculateRoutingForward;

                                                                GET(
                                                                  "Worksheet Template Name",
                                                                  "Worksheet Batch Name","Worksheet Line No.","Operation No.");

                                                                UpdateDatetime;
                                                              END;

                                                   CaptionML=[DAN=Starttidspunkt;
                                                              ENU=Starting Time] }
    { 71  ;   ;Starting Date       ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Starting Time");
                                                              END;

                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 72  ;   ;Ending Time         ;Time          ;OnValidate=BEGIN
                                                                MODIFY;

                                                                PlanningRtngLine.GET(
                                                                  "Worksheet Template Name",
                                                                  "Worksheet Batch Name","Worksheet Line No.","Operation No.");

                                                                PlanningRoutingMgt.CalcSequenceFromActual(PlanningRtngLine,1,ReqLine);
                                                                PlanningRtngLine.SETCURRENTKEY(
                                                                  "Worksheet Template Name",
                                                                  "Worksheet Batch Name",
                                                                  "Worksheet Line No.","Sequence No. (Actual)");
                                                                PlngLnMgt.CalculateRoutingFromActual(PlanningRtngLine,1,FALSE);

                                                                CalculateRoutingBack;
                                                                CalculateRoutingForward;

                                                                GET(
                                                                  "Worksheet Template Name",
                                                                  "Worksheet Batch Name","Worksheet Line No.","Operation No.");
                                                              END;

                                                   CaptionML=[DAN=Sluttidspunkt;
                                                              ENU=Ending Time] }
    { 73  ;   ;Ending Date         ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Ending Time");
                                                              END;

                                                   CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date] }
    { 76  ;   ;Unit Cost Calculation;Option       ;CaptionML=[DAN=Kostprisberegning;
                                                              ENU=Unit Cost Calculation];
                                                   OptionCaptionML=[DAN=Tid,Enheder;
                                                                    ENU=Time,Units];
                                                   OptionString=Time,Units }
    { 77  ;   ;Input Quantity      ;Decimal       ;CaptionML=[DAN=Tilgangsantal;
                                                              ENU=Input Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 78  ;   ;Critical Path       ;Boolean       ;CaptionML=[DAN=Kritisk rute;
                                                              ENU=Critical Path];
                                                   Editable=No }
    { 98  ;   ;Starting Date-Time  ;DateTime      ;OnValidate=BEGIN
                                                                "Starting Date" := DT2DATE("Starting Date-Time");
                                                                "Starting Time" := DT2TIME("Starting Date-Time");
                                                                VALIDATE("Starting Time");
                                                              END;

                                                   CaptionML=[DAN=Startdato/-tidspunkt;
                                                              ENU=Starting Date-Time] }
    { 99  ;   ;Ending Date-Time    ;DateTime      ;OnValidate=BEGIN
                                                                "Ending Date" := DT2DATE("Ending Date-Time");
                                                                "Ending Time" := DT2TIME("Ending Date-Time");
                                                                VALIDATE("Ending Time");
                                                              END;

                                                   CaptionML=[DAN=Slutdato/-tidspunkt;
                                                              ENU=Ending Date-Time] }
    { 99000909;;Expected Operation Cost Amt.;Decimal;
                                                   CaptionML=[DAN=Forventede operationsomkostninger;
                                                              ENU=Expected Operation Cost Amt.];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 99000910;;Expected Capacity Ovhd. Cost;Decimal;
                                                   CaptionML=[DAN=Forventet indir. kap.kostpris;
                                                              ENU=Expected Capacity Ovhd. Cost];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 99000911;;Expected Capacity Need;Decimal    ;CaptionML=[DAN=Forventet kapacitetsbehov;
                                                              ENU=Expected Capacity Need];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Worksheet Template Name,Worksheet Batch Name,Worksheet Line No.,Operation No.;
                                                   SumIndexFields=Expected Operation Cost Amt.;
                                                   MaintainSIFTIndex=No;
                                                   Clustered=Yes }
    {    ;Worksheet Template Name,Worksheet Batch Name,Worksheet Line No.,Sequence No.(Forward);
                                                   MaintainSQLIndex=No }
    {    ;Worksheet Template Name,Worksheet Batch Name,Worksheet Line No.,Sequence No.(Backward);
                                                   MaintainSQLIndex=No }
    {    ;Worksheet Template Name,Worksheet Batch Name,Worksheet Line No.,Sequence No. (Actual);
                                                   MaintainSQLIndex=No }
    {    ;Worksheet Template Name,Worksheet Batch Name,Type,No.,Starting Date;
                                                   MaintainSQLIndex=No }
    {    ;Work Center No.                          }
    {    ;Type,No.                                 }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Denne rutelinje kan ikke flyttes pga. kritiske arbejdscentre i tidligere operationer;ENU=This routing line cannot be moved because of critical work centers in previous operations';
      Text001@1001 : TextConst 'DAN=Denne rutelinje kan ikke flyttes pga. kritiske arbejdscentre i de f�lgende operationer;ENU=This routing line cannot be moved because of critical work centers in next operations';
      WorkCenter@1004 : Record 99000754;
      MachineCenter@1005 : Record 99000758;
      ReqLine@1006 : Record 246;
      PlanningRtngLine@1007 : Record 99000830;
      ProdOrderCapNeed@1008 : Record 5410;
      GLSetup@1002 : Record 98;
      PlngLnMgt@1009 : Codeunit 99000809;
      PlanningRoutingMgt@1010 : Codeunit 99000808;
      HasGLSetup@1020 : Boolean;

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

    LOCAL PROCEDURE GetLine@14();
    BEGIN
      IF (ReqLine."Worksheet Template Name" <> "Worksheet Template Name") OR
         (ReqLine."Journal Batch Name" <> "Worksheet Batch Name") OR
         (ReqLine."Line No." <> "Worksheet Line No.")
      THEN
        ReqLine.GET("Worksheet Template Name","Worksheet Batch Name","Worksheet Line No.");
    END;

    LOCAL PROCEDURE WorkCenterTransferfields@2();
    BEGIN
      "Work Center No." := WorkCenter."No.";
      "Work Center Group Code" := WorkCenter."Work Center Group Code";
      "Setup Time Unit of Meas. Code" := WorkCenter."Unit of Measure Code";
      "Run Time Unit of Meas. Code" := WorkCenter."Unit of Measure Code";
      "Wait Time Unit of Meas. Code" := WorkCenter."Unit of Measure Code";
      "Move Time Unit of Meas. Code" := WorkCenter."Unit of Measure Code";
      Description := WorkCenter.Name;
      "Unit Cost per" := WorkCenter."Unit Cost";
      "Direct Unit Cost" := WorkCenter."Direct Unit Cost";
      "Indirect Cost %" := WorkCenter."Indirect Cost %";
      "Overhead Rate" := WorkCenter."Overhead Rate";

      OnAfterWorkCenterTransferFields(Rec,WorkCenter);
    END;

    LOCAL PROCEDURE MachineCtrTransferfields@1();
    BEGIN
      WorkCenter.GET(MachineCenter."Work Center No.");
      WorkCenterTransferfields;

      Description := MachineCenter.Name;
      "Setup Time" := MachineCenter."Setup Time";
      "Wait Time" := MachineCenter."Wait Time";
      "Move Time" := MachineCenter."Move Time";
      "Fixed Scrap Quantity" := MachineCenter."Fixed Scrap Quantity";
      "Scrap Factor %" := MachineCenter."Scrap %";
      "Minimum Process Time" := MachineCenter."Minimum Process Time";
      "Maximum Process Time" := MachineCenter."Maximum Process Time";
      "Concurrent Capacities" := MachineCenter."Concurrent Capacities";
      "Send-Ahead Quantity" := MachineCenter."Send-Ahead Quantity";
      "Setup Time Unit of Meas. Code" := MachineCenter."Setup Time Unit of Meas. Code";
      "Wait Time Unit of Meas. Code" := MachineCenter."Wait Time Unit of Meas. Code";
      "Move Time Unit of Meas. Code" := MachineCenter."Move Time Unit of Meas. Code";
      "Unit Cost per" := MachineCenter."Unit Cost";
      "Direct Unit Cost" := MachineCenter."Direct Unit Cost";
      "Indirect Cost %" := MachineCenter."Indirect Cost %";
      "Overhead Rate" := MachineCenter."Overhead Rate";

      OnAfterMachineCtrTransferFields(Rec,WorkCenter,MachineCenter);
    END;

    [External]
    PROCEDURE SetRecalcStatus@4();
    BEGIN
      Recalculate := TRUE;
    END;

    [External]
    PROCEDURE RunTimePer@7() : Decimal;
    BEGIN
      IF "Lot Size" = 0 THEN
        "Lot Size" := 1;

      EXIT(ROUND("Run Time" / "Lot Size",0.00001));
    END;

    LOCAL PROCEDURE CalcStartingEndingDates@17();
    BEGIN
      MODIFY;

      PlanningRtngLine.GET(
        "Worksheet Template Name",
        "Worksheet Batch Name","Worksheet Line No.","Operation No.");

      PlanningRoutingMgt.CalcSequenceFromActual(PlanningRtngLine,0,ReqLine);
      PlanningRtngLine.SETCURRENTKEY(
        "Worksheet Template Name",
        "Worksheet Batch Name",
        "Worksheet Line No.","Sequence No. (Actual)");

      PlngLnMgt.CalculateRoutingFromActual(PlanningRtngLine,0,FALSE);

      CalculateRoutingBack;
      CalculateRoutingForward;

      GET(
        "Worksheet Template Name",
        "Worksheet Batch Name","Worksheet Line No.","Operation No.");
    END;

    LOCAL PROCEDURE CalculateRoutingBack@10();
    BEGIN
      IF "Previous Operation No." = '' THEN
        EXIT;

      GetLine;

      PlanningRtngLine.RESET;
      PlanningRtngLine.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      PlanningRtngLine.SETRANGE("Worksheet Batch Name","Worksheet Batch Name");
      PlanningRtngLine.SETRANGE("Worksheet Line No.","Worksheet Line No.");
      PlanningRtngLine.SETFILTER("Operation No.","Previous Operation No.");

      IF PlanningRtngLine.FIND('-') THEN
        REPEAT
          PlanningRtngLine.SETCURRENTKEY(
            "Worksheet Template Name",
            "Worksheet Batch Name",
            "Worksheet Line No.","Sequence No. (Actual)");
          WorkCenter.GET(PlanningRtngLine."Work Center No.");

          CASE WorkCenter."Simulation Type" OF
            WorkCenter."Simulation Type"::Moves:
              BEGIN
                PlanningRoutingMgt.CalcSequenceFromActual(PlanningRtngLine,1,ReqLine);
                PlngLnMgt.CalculateRoutingFromActual(PlanningRtngLine,1,TRUE);
              END;
            WorkCenter."Simulation Type"::"Moves When Necessary":
              BEGIN
                IF (PlanningRtngLine."Ending Date" > "Starting Date") OR
                   ((PlanningRtngLine."Ending Date" = "Starting Date") AND
                    (PlanningRtngLine."Ending Time" > "Starting Time"))
                THEN BEGIN
                  PlanningRoutingMgt.CalcSequenceFromActual(PlanningRtngLine,1,ReqLine);
                  PlngLnMgt.CalculateRoutingFromActual(PlanningRtngLine,1,TRUE);
                END;
              END;
            WorkCenter."Simulation Type"::Critical:
              BEGIN
                IF (PlanningRtngLine."Ending Date" > "Starting Date") OR
                   ((PlanningRtngLine."Ending Date" = "Starting Date") AND
                    (PlanningRtngLine."Ending Time" > "Starting Time"))
                THEN
                  ERROR(Text000);
              END;
          END;
          PlanningRtngLine.SETCURRENTKEY(
            "Worksheet Template Name",
            "Worksheet Batch Name","Worksheet Line No.","Operation No.");
        UNTIL PlanningRtngLine.NEXT = 0;

      PlngLnMgt.CalculatePlanningLineDates(ReqLine);
      AdjustComponents(ReqLine);
    END;

    LOCAL PROCEDURE CalculateRoutingForward@9();
    BEGIN
      IF "Next Operation No." = '' THEN
        EXIT;

      GetLine;

      PlanningRtngLine.RESET;
      PlanningRtngLine.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      PlanningRtngLine.SETRANGE("Worksheet Batch Name","Worksheet Batch Name");
      PlanningRtngLine.SETRANGE("Worksheet Line No.","Worksheet Line No.");
      PlanningRtngLine.SETFILTER("Operation No.","Next Operation No.");

      IF PlanningRtngLine.FIND('-') THEN
        REPEAT
          PlanningRtngLine.SETCURRENTKEY(
            "Worksheet Template Name",
            "Worksheet Batch Name",
            "Worksheet Line No.","Sequence No. (Actual)");
          WorkCenter.GET(PlanningRtngLine."Work Center No.");
          CASE WorkCenter."Simulation Type" OF
            WorkCenter."Simulation Type"::Moves:
              BEGIN
                PlanningRoutingMgt.CalcSequenceFromActual(PlanningRtngLine,0,ReqLine);
                PlngLnMgt.CalculateRoutingFromActual(PlanningRtngLine,0,TRUE);
              END;
            WorkCenter."Simulation Type"::"Moves When Necessary":
              BEGIN
                IF (PlanningRtngLine."Starting Date" < "Ending Date") OR
                   ((PlanningRtngLine."Starting Date" = "Ending Date") AND
                    (PlanningRtngLine."Starting Time" < "Ending Time"))
                THEN BEGIN
                  PlanningRoutingMgt.CalcSequenceFromActual(PlanningRtngLine,0,ReqLine);
                  PlngLnMgt.CalculateRoutingFromActual(PlanningRtngLine,0,TRUE);
                END;
              END;
            WorkCenter."Simulation Type"::Critical:
              BEGIN
                IF (PlanningRtngLine."Starting Date" < "Ending Date") OR
                   ((PlanningRtngLine."Starting Date" = "Ending Date") AND
                    (PlanningRtngLine."Starting Time" < "Ending Time"))
                THEN
                  ERROR(Text001);
              END;
          END;
          PlanningRtngLine.SETCURRENTKEY(
            "Worksheet Template Name",
            "Worksheet Batch Name","Worksheet Line No.","Operation No.");
        UNTIL PlanningRtngLine.NEXT = 0;

      PlngLnMgt.CalculatePlanningLineDates(ReqLine);
      AdjustComponents(ReqLine);
    END;

    LOCAL PROCEDURE ModifyCapNeedEntries@12();
    BEGIN
      ProdOrderCapNeed.SETCURRENTKEY("Worksheet Template Name","Worksheet Batch Name","Worksheet Line No.");
      ProdOrderCapNeed.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      ProdOrderCapNeed.SETRANGE("Worksheet Batch Name","Worksheet Batch Name");
      ProdOrderCapNeed.SETRANGE("Worksheet Line No.","Worksheet Line No.");
      ProdOrderCapNeed.SETRANGE("Operation No.","Operation No.");
      IF ProdOrderCapNeed.FIND('-') THEN
        REPEAT
          ProdOrderCapNeed."No." := "No.";
          ProdOrderCapNeed."Work Center No." := "Work Center No.";
          ProdOrderCapNeed."Work Center Group Code" := "Work Center Group Code";
          ProdOrderCapNeed.MODIFY;
        UNTIL ProdOrderCapNeed.NEXT = 0;
    END;

    LOCAL PROCEDURE AdjustComponents@13(VAR ReqLine@1000 : Record 246);
    VAR
      PlanningComponent@1001 : Record 99000829;
    BEGIN
      PlanningComponent.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      PlanningComponent.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
      PlanningComponent.SETRANGE("Worksheet Line No.",ReqLine."Line No.");

      IF PlanningComponent.FIND('-') THEN
        REPEAT
          PlanningComponent.VALIDATE("Routing Link Code");
          PlanningComponent.MODIFY;
        UNTIL PlanningComponent.NEXT = 0;
    END;

    [External]
    PROCEDURE TransferFromProdOrderRouting@3(VAR ProdOrderRoutingLine@1000 : Record 5409);
    BEGIN
      ProdOrderRoutingLine.TESTFIELD(Recalculate,FALSE);
      "Operation No." := ProdOrderRoutingLine."Operation No.";
      "Next Operation No." := ProdOrderRoutingLine."Next Operation No.";
      "Previous Operation No." := ProdOrderRoutingLine."Previous Operation No.";
      Type := ProdOrderRoutingLine.Type;
      "No." := ProdOrderRoutingLine."No.";
      Description := ProdOrderRoutingLine.Description;
      "Work Center No." := ProdOrderRoutingLine."Work Center No.";
      "Work Center Group Code" := ProdOrderRoutingLine."Work Center Group Code";
      "Setup Time" := ProdOrderRoutingLine."Setup Time";
      "Run Time" := ProdOrderRoutingLine."Run Time";
      "Wait Time" := ProdOrderRoutingLine."Wait Time";
      "Move Time" := ProdOrderRoutingLine."Move Time";
      "Fixed Scrap Quantity" := ProdOrderRoutingLine."Fixed Scrap Quantity";
      "Lot Size" := ProdOrderRoutingLine."Lot Size";
      "Scrap Factor %" := ProdOrderRoutingLine."Scrap Factor %";
      "Setup Time Unit of Meas. Code" := ProdOrderRoutingLine."Setup Time Unit of Meas. Code";
      "Run Time Unit of Meas. Code" := ProdOrderRoutingLine."Run Time Unit of Meas. Code";
      "Wait Time Unit of Meas. Code" := ProdOrderRoutingLine."Wait Time Unit of Meas. Code";
      "Move Time Unit of Meas. Code" := ProdOrderRoutingLine."Move Time Unit of Meas. Code";
      "Minimum Process Time" := ProdOrderRoutingLine."Minimum Process Time";
      "Maximum Process Time" := ProdOrderRoutingLine."Maximum Process Time";
      "Concurrent Capacities" := ProdOrderRoutingLine."Concurrent Capacities";
      "Send-Ahead Quantity" := ProdOrderRoutingLine."Send-Ahead Quantity";
      "Direct Unit Cost" := ProdOrderRoutingLine."Direct Unit Cost";
      "Unit Cost per" := ProdOrderRoutingLine."Unit Cost per";
      "Unit Cost Calculation" := ProdOrderRoutingLine."Unit Cost Calculation";
      "Indirect Cost %" := ProdOrderRoutingLine."Indirect Cost %";
      "Overhead Rate" := ProdOrderRoutingLine."Overhead Rate";
      VALIDATE("Routing Link Code",ProdOrderRoutingLine."Routing Link Code");
      "Standard Task Code" := ProdOrderRoutingLine."Standard Task Code";
      "Sequence No.(Forward)" := ProdOrderRoutingLine."Sequence No. (Forward)";
      "Sequence No.(Backward)" := ProdOrderRoutingLine."Sequence No. (Backward)";
      "Fixed Scrap Qty. (Accum.)" := ProdOrderRoutingLine."Fixed Scrap Qty. (Accum.)";
      "Scrap Factor % (Accumulated)" := ProdOrderRoutingLine."Scrap Factor % (Accumulated)";
      "Starting Time" := ProdOrderRoutingLine."Starting Time";
      "Starting Date" := ProdOrderRoutingLine."Starting Date";
      "Ending Time" := ProdOrderRoutingLine."Ending Time";
      "Ending Date" := ProdOrderRoutingLine."Ending Date";
      UpdateDatetime;
      VALIDATE("Unit Cost per");

      OnAfterTransferFromProdOrderRouting(Rec,ProdOrderRoutingLine);
    END;

    [External]
    PROCEDURE UpdateDatetime@11();
    BEGIN
      "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time");
      "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
    END;

    [External]
    PROCEDURE SetNextOperations@6();
    VAR
      PlanningRtngLine2@1003 : Record 99000830;
    BEGIN
      PlanningRtngLine2.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      PlanningRtngLine2.SETRANGE("Worksheet Batch Name","Worksheet Batch Name");
      PlanningRtngLine2.SETRANGE("Worksheet Line No.","Worksheet Line No.");
      PlanningRtngLine2.SETFILTER("Operation No.",'>%1',"Operation No.");

      IF PlanningRtngLine2.FINDFIRST THEN
        "Next Operation No." := PlanningRtngLine2."Operation No."
      ELSE BEGIN
        PlanningRtngLine2.SETFILTER("Operation No.",'');
        PlanningRtngLine2.SETRANGE("Next Operation No.",'');
        IF PlanningRtngLine2.FINDFIRST THEN BEGIN
          PlanningRtngLine2."Next Operation No." := "Operation No.";
          PlanningRtngLine2.MODIFY;
        END;
      END;
    END;

    LOCAL PROCEDURE GetGLSetup@1022();
    BEGIN
      IF NOT HasGLSetup THEN BEGIN
        HasGLSetup := TRUE;
        GLSetup.GET;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterWorkCenterTransferFields@1023(VAR PlanningRoutingLine@1000 : Record 99000830;WorkCenter@1001 : Record 99000754);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterMachineCtrTransferFields@1024(VAR PlanningRoutingLine@1000 : Record 99000830;WorkCenter@1001 : Record 99000754;MachineCenter@1002 : Record 99000758);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferFromProdOrderRouting@1025(VAR PlanningRoutingLine@1000 : Record 99000830;VAR ProdOrderRtngLine@1001 : Record 5409);
    BEGIN
    END;

    BEGIN
    END.
  }
}

