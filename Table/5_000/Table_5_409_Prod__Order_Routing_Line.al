OBJECT Table 5409 Prod. Order Routing Line
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Permissions=TableData 5410=rimd;
    OnInsert=BEGIN
               TESTFIELD("Routing No.");
               IF Status = Status::Finished THEN
                 ERROR(Text006,Status,TABLECAPTION);

               IF "Next Operation No." = '' THEN
                 SetNextOperations(Rec);

               UpdateComponentsBin(0); // from trigger = insert
             END;

    OnModify=BEGIN
               IF Status = Status::Finished THEN
                 ERROR(Text006,Status,TABLECAPTION);

               UpdateComponentsBin(1); // from trigger = modify
             END;

    OnDelete=VAR
               CapLedgEntry@1000 : Record 5832;
             BEGIN
               IF Status = Status::Finished THEN
                 ERROR(Text006,Status,TABLECAPTION);

               IF Status = Status::Released THEN BEGIN
                 CapLedgEntry.SETRANGE("Order Type",CapLedgEntry."Order Type"::Production);
                 CapLedgEntry.SETRANGE("Order No.","Prod. Order No.");
                 CapLedgEntry.SETRANGE("Routing Reference No.","Routing Reference No.");
                 CapLedgEntry.SETRANGE("Routing No.","Routing No.");
                 CapLedgEntry.SETRANGE("Operation No.","Operation No.");
                 IF NOT CapLedgEntry.ISEMPTY THEN
                   ERROR(
                     Text000,
                     Status,TABLECAPTION,"Operation No.",CapLedgEntry.TABLECAPTION);
               END;

               IF SubcontractPurchOrderExist THEN
                 ERROR(
                   Text000,
                   Status,TABLECAPTION,"Operation No.",PurchLine.TABLECAPTION);

               DeleteRelations;

               UpdateComponentsBin(2); // from trigger = delete
             END;

    OnRename=BEGIN
               ERROR(Text001,TABLECAPTION);
             END;

    CaptionML=[DAN=Prod.ordrerutelinje;
               ENU=Prod. Order Routing Line];
    LookupPageID=Page99000817;
    DrillDownPageID=Page99000817;
  }
  FIELDS
  {
    { 1   ;   ;Routing No.         ;Code20        ;TableRelation="Routing Header";
                                                   CaptionML=[DAN=Rutenr.;
                                                              ENU=Routing No.] }
    { 3   ;   ;Routing Reference No.;Integer      ;CaptionML=[DAN=Rutereferencenr.;
                                                              ENU=Routing Reference No.];
                                                   Editable=No }
    { 4   ;   ;Operation No.       ;Code10        ;OnValidate=BEGIN
                                                                SetRecalcStatus;

                                                                GetLine;
                                                                "Starting Time" := ProdOrderLine."Starting Time";
                                                                "Ending Time" := ProdOrderLine."Ending Time";
                                                                "Starting Date" := ProdOrderLine."Starting Date";
                                                                "Ending Date" := ProdOrderLine."Ending Date";
                                                              END;

                                                   CaptionML=[DAN=Operationsnr.;
                                                              ENU=Operation No.];
                                                   NotBlank=Yes }
    { 5   ;   ;Next Operation No.  ;Code30        ;OnValidate=BEGIN
                                                                SetRecalcStatus;
                                                                GetLine;
                                                              END;

                                                   CaptionML=[DAN=N�ste operationsnr.;
                                                              ENU=Next Operation No.] }
    { 6   ;   ;Previous Operation No.;Code30      ;OnValidate=BEGIN
                                                                SetRecalcStatus;
                                                              END;

                                                   CaptionML=[DAN=Forrige operationsnr.;
                                                              ENU=Previous Operation No.] }
    { 7   ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                SetRecalcStatus;

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
                                                                IF ("No." <> xRec."No.") AND (xRec."No." <> '') THEN
                                                                  IF SubcontractPurchOrderExist THEN
                                                                    ERROR(
                                                                      Text007,
                                                                      FIELDCAPTION("No."),PurchLine.TABLECAPTION,Status,TABLECAPTION,"Operation No.");

                                                                SetRecalcStatus;

                                                                IF "No." = '' THEN
                                                                  EXIT;

                                                                CASE Type OF
                                                                  Type::"Work Center":
                                                                    BEGIN
                                                                      WorkCenter.GET("No.");
                                                                      WorkCenter.TESTFIELD(Blocked,FALSE);
                                                                      WorkCenterTransferFields;
                                                                    END;
                                                                  Type::"Machine Center":
                                                                    BEGIN
                                                                      MachineCenter.GET("No.");
                                                                      MachineCenter.TESTFIELD(Blocked,FALSE);
                                                                      MachineCtrTransferFields;
                                                                    END;
                                                                END;
                                                                ModifyCapNeedEntries;

                                                                GetLine;
                                                                IF (ProdOrderLine."Routing Type" = ProdOrderLine."Routing Type"::Serial) OR (xRec."No." <> '') THEN
                                                                  CalcStartingEndingDates(Direction::Forward);
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
                                                                CalcStartingEndingDates(Direction::Forward);
                                                              END;

                                                   CaptionML=[DAN=Opstillingstid;
                                                              ENU=Setup Time];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 13  ;   ;Run Time            ;Decimal       ;OnValidate=BEGIN
                                                                CalcStartingEndingDates(Direction::Forward);
                                                              END;

                                                   CaptionML=[DAN=Operationstid;
                                                              ENU=Run Time];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 14  ;   ;Wait Time           ;Decimal       ;OnValidate=BEGIN
                                                                CalcStartingEndingDates(Direction::Forward);
                                                              END;

                                                   CaptionML=[DAN=Ventetid;
                                                              ENU=Wait Time];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 15  ;   ;Move Time           ;Decimal       ;OnValidate=BEGIN
                                                                CalcStartingEndingDates(Direction::Forward);
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
                                                                CalcStartingEndingDates(Direction::Forward);
                                                              END;

                                                   CaptionML=[DAN=Opstillingstidsenhedskode;
                                                              ENU=Setup Time Unit of Meas. Code] }
    { 20  ;   ;Run Time Unit of Meas. Code;Code10 ;TableRelation="Capacity Unit of Measure";
                                                   OnValidate=BEGIN
                                                                CalcStartingEndingDates(Direction::Forward);
                                                              END;

                                                   CaptionML=[DAN=Operationstidsenhedskode;
                                                              ENU=Run Time Unit of Meas. Code] }
    { 21  ;   ;Wait Time Unit of Meas. Code;Code10;TableRelation="Capacity Unit of Measure";
                                                   OnValidate=BEGIN
                                                                CalcStartingEndingDates(Direction::Forward);
                                                              END;

                                                   CaptionML=[DAN=Ventetidsenhedskode;
                                                              ENU=Wait Time Unit of Meas. Code] }
    { 22  ;   ;Move Time Unit of Meas. Code;Code10;TableRelation="Capacity Unit of Measure";
                                                   OnValidate=BEGIN
                                                                CalcStartingEndingDates(Direction::Forward);
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
                                                                CalcStartingEndingDates(Direction::Forward);
                                                              END;

                                                   CaptionML=[DAN=Samtidige kapaciteter;
                                                              ENU=Concurrent Capacities];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 31  ;   ;Send-Ahead Quantity ;Decimal       ;OnValidate=BEGIN
                                                                CalcStartingEndingDates(Direction::Forward);
                                                              END;

                                                   CaptionML=[DAN=Send-ahead-antal;
                                                              ENU=Send-Ahead Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 34  ;   ;Routing Link Code   ;Code10        ;TableRelation="Routing Link";
                                                   CaptionML=[DAN=Rutebindingskode;
                                                              ENU=Routing Link Code];
                                                   Editable=No }
    { 35  ;   ;Standard Task Code  ;Code10        ;TableRelation="Standard Task";
                                                   OnValidate=VAR
                                                                StandardTask@1000 : Record 99000778;
                                                                StdTaskTool@1001 : Record 99000781;
                                                                StdTaskPersonnel@1002 : Record 99000782;
                                                                StdTaskQltyMeasure@1003 : Record 99000784;
                                                                StdTaskComment@1004 : Record 99000783;
                                                              BEGIN
                                                                IF "Standard Task Code" = '' THEN
                                                                  EXIT;

                                                                StandardTask.GET("Standard Task Code");
                                                                Description := StandardTask.Description;

                                                                DeleteRelations;

                                                                StdTaskTool.SETRANGE("Standard Task Code","Standard Task Code");
                                                                IF StdTaskTool.FIND('-') THEN
                                                                  REPEAT
                                                                    ProdOrderRoutTool.Status := Status;
                                                                    ProdOrderRoutTool."Prod. Order No." := "Prod. Order No.";
                                                                    ProdOrderRoutTool."Routing Reference No." := "Routing Reference No.";
                                                                    ProdOrderRoutTool."Routing No." := "Routing No.";
                                                                    ProdOrderRoutTool."Operation No." := "Operation No.";
                                                                    ProdOrderRoutTool."Line No." := StdTaskTool."Line No.";
                                                                    ProdOrderRoutTool."No." := StdTaskTool."No.";
                                                                    ProdOrderRoutTool.Description := StdTaskTool.Description;
                                                                    ProdOrderRoutTool.INSERT;
                                                                  UNTIL StdTaskTool.NEXT = 0;

                                                                StdTaskPersonnel.SETRANGE("Standard Task Code","Standard Task Code");
                                                                IF StdTaskPersonnel.FIND('-') THEN
                                                                  REPEAT
                                                                    ProdOrderRtngPersonnel.Status := Status;
                                                                    ProdOrderRtngPersonnel."Prod. Order No." := "Prod. Order No.";
                                                                    ProdOrderRtngPersonnel."Routing Reference No." := "Routing Reference No.";
                                                                    ProdOrderRtngPersonnel."Routing No." := "Routing No.";
                                                                    ProdOrderRtngPersonnel."Operation No." := "Operation No.";
                                                                    ProdOrderRtngPersonnel."Line No." := StdTaskPersonnel."Line No.";
                                                                    ProdOrderRtngPersonnel."No." := StdTaskPersonnel."No.";
                                                                    ProdOrderRtngPersonnel.Description := StdTaskPersonnel.Description;
                                                                    ProdOrderRtngPersonnel.INSERT;
                                                                  UNTIL StdTaskPersonnel.NEXT = 0;

                                                                StdTaskQltyMeasure.SETRANGE("Standard Task Code","Standard Task Code");
                                                                IF StdTaskQltyMeasure.FIND('-') THEN
                                                                  REPEAT
                                                                    ProdOrderRtngQltyMeas.Status := Status;
                                                                    ProdOrderRtngQltyMeas."Prod. Order No." := "Prod. Order No.";
                                                                    ProdOrderRtngQltyMeas."Routing Reference No." := "Routing Reference No.";
                                                                    ProdOrderRtngQltyMeas."Routing No." := "Routing No.";
                                                                    ProdOrderRtngQltyMeas."Operation No." := "Operation No.";
                                                                    ProdOrderRtngQltyMeas."Line No." := StdTaskQltyMeasure."Line No.";
                                                                    ProdOrderRtngQltyMeas."Qlty Measure Code" := StdTaskQltyMeasure."Qlty Measure Code";
                                                                    ProdOrderRtngQltyMeas.Description := StdTaskQltyMeasure.Description;
                                                                    ProdOrderRtngQltyMeas."Min. Value" := StdTaskQltyMeasure."Min. Value";
                                                                    ProdOrderRtngQltyMeas."Max. Value" := StdTaskQltyMeasure."Max. Value";
                                                                    ProdOrderRtngQltyMeas."Mean Tolerance" := StdTaskQltyMeasure."Mean Tolerance";
                                                                    ProdOrderRtngQltyMeas.INSERT;
                                                                  UNTIL StdTaskQltyMeasure.NEXT = 0;

                                                                StdTaskComment.SETRANGE("Standard Task Code","Standard Task Code");
                                                                IF StdTaskComment.FIND('-') THEN
                                                                  REPEAT
                                                                    ProdOrderRtngComment.Status := Status;
                                                                    ProdOrderRtngComment."Prod. Order No." := "Prod. Order No.";
                                                                    ProdOrderRtngComment."Routing Reference No." := "Routing Reference No.";
                                                                    ProdOrderRtngComment."Routing No." := "Routing No.";
                                                                    ProdOrderRtngComment."Operation No." := "Operation No.";
                                                                    ProdOrderRtngComment."Line No." := StdTaskComment."Line No.";
                                                                    ProdOrderRtngComment.Comment := StdTaskComment.Text;
                                                                    ProdOrderRtngComment.INSERT;
                                                                  UNTIL StdTaskComment.NEXT = 0;
                                                              END;

                                                   CaptionML=[DAN=Standardoperationskode;
                                                              ENU=Standard Task Code] }
    { 40  ;   ;Unit Cost per       ;Decimal       ;OnValidate=BEGIN
                                                                GLSetup.GET;
                                                                "Direct Unit Cost" :=
                                                                  ROUND(
                                                                    ("Unit Cost per" - "Overhead Rate") /
                                                                    (1 + "Indirect Cost %" / 100),
                                                                    GLSetup."Unit-Amount Rounding Precision");

                                                                CalcStartingEndingDates(Direction::Forward);
                                                              END;

                                                   CaptionML=[DAN=Kostpris pr.;
                                                              ENU=Unit Cost per];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 41  ;   ;Recalculate         ;Boolean       ;CaptionML=[DAN=Genberegn;
                                                              ENU=Recalculate] }
    { 50  ;   ;Sequence No. (Forward);Integer     ;CaptionML=[DAN=R�kkef�lgenr. (fremad);
                                                              ENU=Sequence No. (Forward)];
                                                   Editable=No }
    { 51  ;   ;Sequence No. (Backward);Integer    ;CaptionML=[DAN=R�kkef�lgenr. (bagud);
                                                              ENU=Sequence No. (Backward)];
                                                   Editable=No }
    { 52  ;   ;Fixed Scrap Qty. (Accum.);Decimal  ;CaptionML=[DAN=Fast spildantal (akkum.);
                                                              ENU=Fixed Scrap Qty. (Accum.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 53  ;   ;Scrap Factor % (Accumulated);Decimal;
                                                   CaptionML=[DAN=Spildfaktorpct. (akkum.);
                                                              ENU=Scrap Factor % (Accumulated)];
                                                   DecimalPlaces=0:5;
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
                                                                GLSetup.GET;
                                                                "Unit Cost per" :=
                                                                  ROUND(
                                                                    "Direct Unit Cost" * (1 + "Indirect Cost %" / 100) + "Overhead Rate",
                                                                    GLSetup."Unit-Amount Rounding Precision");
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
    { 70  ;   ;Starting Time       ;Time          ;OnValidate=BEGIN
                                                                CalcStartingEndingDates(Direction::Forward);
                                                              END;

                                                   CaptionML=[DAN=Starttidspunkt;
                                                              ENU=Starting Time] }
    { 71  ;   ;Starting Date       ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Starting Time");
                                                              END;

                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 72  ;   ;Ending Time         ;Time          ;OnValidate=BEGIN
                                                                CalcStartingEndingDates(Direction::Backward);
                                                              END;

                                                   CaptionML=[DAN=Sluttidspunkt;
                                                              ENU=Ending Time] }
    { 73  ;   ;Ending Date         ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Ending Time");
                                                              END;

                                                   CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date] }
    { 74  ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Simuleret,Planlagt,Fastlagt,Frigivet,Udf�rt;
                                                                    ENU=Simulated,Planned,Firm Planned,Released,Finished];
                                                   OptionString=Simulated,Planned,Firm Planned,Released,Finished }
    { 75  ;   ;Prod. Order No.     ;Code20        ;TableRelation="Production Order".No. WHERE (Status=FIELD(Status));
                                                   CaptionML=[DAN=Prod.ordrenr.;
                                                              ENU=Prod. Order No.];
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 76  ;   ;Unit Cost Calculation;Option       ;CaptionML=[DAN=Kostprisberegning;
                                                              ENU=Unit Cost Calculation];
                                                   OptionCaptionML=[DAN=Tid,Enheder;
                                                                    ENU=Time,Units];
                                                   OptionString=Time,Units }
    { 77  ;   ;Input Quantity      ;Decimal       ;CaptionML=[DAN=Tilgangsantal;
                                                              ENU=Input Quantity];
                                                   DecimalPlaces=0:5 }
    { 78  ;   ;Critical Path       ;Boolean       ;CaptionML=[DAN=Kritisk rute;
                                                              ENU=Critical Path];
                                                   Editable=No }
    { 79  ;   ;Routing Status      ;Option        ;OnValidate=VAR
                                                                ProdOrderCapacityNeed@1000 : Record 5410;
                                                              BEGIN
                                                                IF (xRec."Routing Status" = xRec."Routing Status"::Finished) AND (xRec."Routing Status" <> "Routing Status") THEN
                                                                  ERROR(Text008,FIELDCAPTION("Routing Status"),xRec."Routing Status","Routing Status");

                                                                IF ("Routing Status" = "Routing Status"::Finished) AND (xRec."Routing Status" <> "Routing Status") THEN BEGIN
                                                                  IF NOT CONFIRM(Text009,FALSE,FIELDCAPTION("Routing Status"),"Routing Status") THEN
                                                                    ERROR('');

                                                                  ProdOrderCapacityNeed.SETCURRENTKEY(
                                                                    Status,"Prod. Order No.","Requested Only","Routing No.","Routing Reference No.","Operation No.","Line No.");
                                                                  ProdOrderCapacityNeed.SETRANGE(Status,Status);
                                                                  ProdOrderCapacityNeed.SETRANGE("Prod. Order No.","Prod. Order No.");
                                                                  ProdOrderCapacityNeed.SETRANGE("Requested Only",FALSE);
                                                                  ProdOrderCapacityNeed.SETRANGE("Routing No.","Routing No.");
                                                                  ProdOrderCapacityNeed.SETRANGE("Routing Reference No.","Routing Reference No.");
                                                                  ProdOrderCapacityNeed.SETRANGE("Operation No.","Operation No.");
                                                                  ProdOrderCapacityNeed.MODIFYALL("Allocated Time",0);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Rutestatus;
                                                              ENU=Routing Status];
                                                   OptionCaptionML=[DAN=" ,Planlagt,Igangsat,Udf�rt";
                                                                    ENU=" ,Planned,In Progress,Finished"];
                                                   OptionString=[ ,Planned,In Progress,Finished] }
    { 81  ;   ;Flushing Method     ;Option        ;InitValue=Manual;
                                                   CaptionML=[DAN=Tr�kmetode;
                                                              ENU=Flushing Method];
                                                   OptionCaptionML=[DAN=Manuel,Forl�ns,Bagl�ns;
                                                                    ENU=Manual,Forward,Backward];
                                                   OptionString=Manual,Forward,Backward }
    { 90  ;   ;Expected Operation Cost Amt.;Decimal;
                                                   CaptionML=[DAN=Forventede operationsomkostninger;
                                                              ENU=Expected Operation Cost Amt.];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 91  ;   ;Expected Capacity Need;Decimal     ;FieldClass=Normal;
                                                   CaptionML=[DAN=Forventet kapacitetsbehov;
                                                              ENU=Expected Capacity Need];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 96  ;   ;Expected Capacity Ovhd. Cost;Decimal;
                                                   CaptionML=[DAN=Forventet indir. kap.kostpris;
                                                              ENU=Expected Capacity Ovhd. Cost];
                                                   Editable=No;
                                                   AutoFormatType=1 }
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
    { 100 ;   ;Schedule Manually   ;Boolean       ;CaptionML=[DAN=Planl�g manuelt;
                                                              ENU=Schedule Manually] }
    { 101 ;   ;Location Code       ;Code10        ;AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code];
                                                   Editable=No }
    { 7301;   ;Open Shop Floor Bin Code;Code20    ;AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=�ben prod.placeringskode;
                                                              ENU=Open Shop Floor Bin Code];
                                                   Editable=No }
    { 7302;   ;To-Production Bin Code;Code20      ;AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Til-produktionsplaceringskode;
                                                              ENU=To-Production Bin Code];
                                                   Editable=No }
    { 7303;   ;From-Production Bin Code;Code20    ;AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Fra-produktionsplaceringskode;
                                                              ENU=From-Production Bin Code];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Status,Prod. Order No.,Routing Reference No.,Routing No.,Operation No.;
                                                   SumIndexFields=Expected Operation Cost Amt.,Expected Capacity Need,Expected Capacity Ovhd. Cost;
                                                   Clustered=Yes }
    {    ;Prod. Order No.,Routing Reference No.,Status,Routing No.,Operation No.;
                                                   MaintainSIFTIndex=No }
    {    ;Status,Prod. Order No.,Routing Reference No.,Routing No.,Sequence No. (Forward) }
    {    ;Status,Prod. Order No.,Routing Reference No.,Routing No.,Sequence No. (Backward) }
    {    ;Status,Prod. Order No.,Routing Reference No.,Routing No.,Sequence No. (Actual) }
    {    ;Work Center No.                         ;SumIndexFields=Expected Operation Cost Amt.;
                                                   MaintainSIFTIndex=No }
    {    ;Type,No.,Starting Date                  ;SumIndexFields=Expected Operation Cost Amt.;
                                                   MaintainSIFTIndex=No }
    {    ;Status,Work Center No.                   }
    {    ;Prod. Order No.,Status,Flushing Method   }
    {    ;Starting Date,Starting Time             ;MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    {    ;Ending Date,Ending Time                 ;MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst '@@@="%1 = Document status; %2 = Table Caption; %3 = Field Value; %4 = Table Caption";DAN=Du kan ikke slette %1 %2 %3, fordi der er tilknyttet mindst �n %4.;ENU=You cannot delete %1 %2 %3 because there is at least one %4 associated with it.';
      Text001@1001 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text002@1002 : TextConst 'DAN=Denne rutelinje kan ikke flyttes pga. kritiske arbejdscentre i tidligere operationer;ENU=This routing line cannot be moved because of critical work centers in previous operations';
      Text003@1003 : TextConst 'DAN=Denne rutelinje kan ikke flyttes pga. kritiske arbejdscentre i de f�lgende operationer;ENU=This routing line cannot be moved because of critical work centers in next operations';
      WorkCenter@1006 : Record 99000754;
      MachineCenter@1007 : Record 99000758;
      ProdOrderLine@1008 : Record 5406;
      ProdOrderRtngLine@1009 : Record 5409;
      ProdOrderRoutTool@1010 : Record 5411;
      ProdOrderRtngPersonnel@1011 : Record 5412;
      ProdOrderRtngQltyMeas@1012 : Record 5413;
      ProdOrderRtngComment@1013 : Record 5415;
      GLSetup@1005 : Record 98;
      ProdOrderCapNeed@1014 : Record 5410;
      PurchLine@1021 : Record 39;
      CalcProdOrder@1015 : Codeunit 99000773;
      ProdOrderRouteMgt@1016 : Codeunit 99000772;
      Text004@1019 : TextConst 'DAN=Nogle rutelinjer refererer til den operation, der lige er blevet slettet. Referencerne findes\i felterne %1 og %2.\\Det skal muligvis rettes, da en rutelinje, der refererer til en ikkeeksisterende\operation, vil for�rsage alvorlige fejl i kapacitetsplanl�gningen.\\Vil du have vist en oversigt over de p�g�ldende linjer?\(G� til kolonnerne N�ste operationsnr. og Forrige operationsnr.).;ENU=Some routing lines are referring to the operation just deleted. The references are\in the fields %1 and %2.\\This may have to be corrected as a routing line referring to a non-existent\operation will lead to serious errors in capacity planning.\\Do you want to see a list of the lines in question?\(Access the columns Next Operation No. and Previous Operation No.)';
      Text005@1004 : TextConst 'DAN=Rutelinjer, der refererer til den slettede operation nr. %1;ENU=Routing Lines referring to deleted Operation No. %1';
      Text006@1020 : TextConst 'DAN=%1 %2 kan ikke inds�ttes, �ndres eller slettes.;ENU=A %1 %2 can not be inserted, modified, or deleted.';
      Direction@1018 : 'Forward,Backward';
      Text007@1022 : TextConst 'DAN=Du kan ikke �ndre %1, fordi der er mindst �n/�t %2 knyttet til %3 %4 %5.;ENU=You cannot change %1, because there is at least one %2 associated with %3 %4 %5.';
      Text008@1023 : TextConst 'DAN=Du kan ikke �ndre %1 fra %2 til %3.;ENU=You cannot change the %1 from %2 to %3.';
      Text009@1024 : TextConst 'DAN=Hvis du �ndrer %1 til %2, slettes hele den relaterede allokerede kapacitet, og du kan ikke �ndre %1 for operationen igen.\\Er du sikker p�, at du vil forts�tte?;ENU=If you change the %1 to %2, then all related allocated capacity will be deleted, and you will not be able to change the %1 of the operation again.\\Are you sure that you want to continue?';
      SkipUpdateOfCompBinCodes@1017 : Boolean;

    [External]
    PROCEDURE Caption@12() : Text[100];
    VAR
      ProdOrder@1000 : Record 5405;
    BEGIN
      IF GETFILTERS = '' THEN
        EXIT('');

      IF NOT ProdOrder.GET(Status,"Prod. Order No.") THEN
        EXIT('');

      EXIT(
        STRSUBSTNO('%1 %2 %3',
          "Prod. Order No.",ProdOrder.Description,"Routing No."));
    END;

    LOCAL PROCEDURE GetLine@15();
    BEGIN
      ProdOrderLine.SETRANGE(Status,Status);
      ProdOrderLine.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderLine.SETRANGE("Routing No.","Routing No.");
      ProdOrderLine.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderLine.FIND('-');
    END;

    LOCAL PROCEDURE DeleteRelations@3();
    BEGIN
      ProdOrderRoutTool.SETRANGE(Status,Status);
      ProdOrderRoutTool.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderRoutTool.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderRoutTool.SETRANGE("Routing No.","Routing No.");
      ProdOrderRoutTool.SETRANGE("Operation No.","Operation No.");
      ProdOrderRoutTool.DELETEALL;

      ProdOrderRtngPersonnel.SETRANGE(Status,Status);
      ProdOrderRtngPersonnel.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderRtngPersonnel.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderRtngPersonnel.SETRANGE("Routing No.","Routing No.");
      ProdOrderRtngPersonnel.SETRANGE("Operation No.","Operation No.");
      ProdOrderRtngPersonnel.DELETEALL;

      ProdOrderRtngQltyMeas.SETRANGE(Status,Status);
      ProdOrderRtngQltyMeas.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderRtngQltyMeas.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderRtngQltyMeas.SETRANGE("Routing No.","Routing No.");
      ProdOrderRtngQltyMeas.SETRANGE("Operation No.","Operation No.");
      ProdOrderRtngQltyMeas.DELETEALL;

      ProdOrderRtngComment.SETRANGE(Status,Status);
      ProdOrderRtngComment.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderRtngComment.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderRtngComment.SETRANGE("Routing No.","Routing No.");
      ProdOrderRtngComment.SETRANGE("Operation No.","Operation No.");
      ProdOrderRtngComment.DELETEALL;

      ProdOrderCapNeed.SETRANGE(Status,Status);
      ProdOrderCapNeed.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderCapNeed.SETRANGE("Routing No.","Routing No.");
      ProdOrderCapNeed.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderCapNeed.SETRANGE("Operation No.","Operation No.");
      ProdOrderCapNeed.DELETEALL;
    END;

    LOCAL PROCEDURE WorkCenterTransferFields@2();
    BEGIN
      "Work Center No." := WorkCenter."No.";
      "Work Center Group Code" := WorkCenter."Work Center Group Code";
      "Setup Time Unit of Meas. Code" := WorkCenter."Unit of Measure Code";
      "Run Time Unit of Meas. Code" := WorkCenter."Unit of Measure Code";
      "Wait Time Unit of Meas. Code" := WorkCenter."Unit of Measure Code";
      "Move Time Unit of Meas. Code" := WorkCenter."Unit of Measure Code";
      Description := WorkCenter.Name;
      "Flushing Method" := WorkCenter."Flushing Method";
      "Unit Cost per" := WorkCenter."Unit Cost";
      "Direct Unit Cost" := WorkCenter."Direct Unit Cost";
      "Indirect Cost %" := WorkCenter."Indirect Cost %";
      "Overhead Rate" := WorkCenter."Overhead Rate";
      "Unit Cost Calculation" := WorkCenter."Unit Cost Calculation";
      FillDefaultLocationAndBins;
      OnAfterWorkCenterTransferFields(Rec,WorkCenter);
    END;

    LOCAL PROCEDURE MachineCtrTransferFields@1();
    BEGIN
      WorkCenter.GET(MachineCenter."Work Center No.");
      WorkCenterTransferFields;

      Description := MachineCenter.Name;
      "Setup Time" := MachineCenter."Setup Time";
      "Wait Time" := MachineCenter."Wait Time";
      "Move Time" := MachineCenter."Move Time";
      "Fixed Scrap Quantity" := MachineCenter."Fixed Scrap Quantity";
      "Scrap Factor %" := MachineCenter."Scrap %";
      "Minimum Process Time" := MachineCenter."Minimum Process Time";
      "Maximum Process Time" := MachineCenter."Maximum Process Time";
      "Concurrent Capacities" := MachineCenter."Concurrent Capacities";
      IF "Concurrent Capacities" = 0 THEN
        "Concurrent Capacities" := 1;
      "Send-Ahead Quantity" := MachineCenter."Send-Ahead Quantity";
      "Setup Time Unit of Meas. Code" := MachineCenter."Setup Time Unit of Meas. Code";
      "Wait Time Unit of Meas. Code" := MachineCenter."Wait Time Unit of Meas. Code";
      "Move Time Unit of Meas. Code" := MachineCenter."Move Time Unit of Meas. Code";
      "Flushing Method" := MachineCenter."Flushing Method";
      "Unit Cost per" := MachineCenter."Unit Cost";
      "Direct Unit Cost" := MachineCenter."Direct Unit Cost";
      "Indirect Cost %" := MachineCenter."Indirect Cost %";
      "Overhead Rate" := MachineCenter."Overhead Rate";
      FillDefaultLocationAndBins;
      OnAfterMachineCtrTransferFields(Rec,WorkCenter,MachineCenter);
    END;

    [External]
    PROCEDURE FillDefaultLocationAndBins@8();
    BEGIN
      GetLine;
      "Location Code" := ProdOrderLine."Location Code";
      CASE Type OF
        Type::"Work Center":
          BEGIN
            IF WorkCenter."No." <> "No." THEN
              WorkCenter.GET("No.");
            IF WorkCenter."Location Code" = "Location Code" THEN BEGIN
              "Open Shop Floor Bin Code" := WorkCenter."Open Shop Floor Bin Code";
              "To-Production Bin Code" := WorkCenter."To-Production Bin Code";
              "From-Production Bin Code" := WorkCenter."From-Production Bin Code";
            END;
          END;
        Type::"Machine Center":
          BEGIN
            IF MachineCenter."No." <> "No." THEN
              MachineCenter.GET("No.");
            IF MachineCenter."Location Code" = "Location Code" THEN BEGIN
              "Open Shop Floor Bin Code" := MachineCenter."Open Shop Floor Bin Code";
              "To-Production Bin Code" := MachineCenter."To-Production Bin Code";
              "From-Production Bin Code" := MachineCenter."From-Production Bin Code";
            END;
            IF WorkCenter."No." <> MachineCenter."Work Center No." THEN
              WorkCenter.GET(MachineCenter."Work Center No.");
            IF WorkCenter."Location Code" = "Location Code" THEN BEGIN
              IF "Open Shop Floor Bin Code" = '' THEN
                "Open Shop Floor Bin Code" := WorkCenter."Open Shop Floor Bin Code";
              IF "To-Production Bin Code" = '' THEN
                "To-Production Bin Code" := WorkCenter."To-Production Bin Code";
              IF "From-Production Bin Code" = '' THEN
                "From-Production Bin Code" := WorkCenter."From-Production Bin Code";
            END;
          END;
      END;
    END;

    LOCAL PROCEDURE CalcStartingEndingDates@17(Direction1@1000 : 'Forward,Backward');
    VAR
      ReservationCheckDateConfl@1001 : Codeunit 99000815;
    BEGIN
      IF "Routing Status" = "Routing Status"::Finished THEN
        FIELDERROR("Routing Status");

      MODIFY(TRUE);

      ProdOrderRtngLine.GET(Status,"Prod. Order No.","Routing Reference No.","Routing No.","Operation No.");

      ProdOrderRouteMgt.CalcSequenceFromActual(ProdOrderRtngLine,Direction1);
      ProdOrderRtngLine.GET(Status,"Prod. Order No.","Routing Reference No.","Routing No.","Operation No.");
      ProdOrderRtngLine.SETCURRENTKEY(
        Status,"Prod. Order No.","Routing Reference No.","Routing No.","Sequence No. (Actual)");
      CalcProdOrder.CalculateRoutingFromActual(ProdOrderRtngLine,Direction1,FALSE);

      CalculateRoutingBack;
      CalculateRoutingForward;

      GET(Status,"Prod. Order No.","Routing Reference No.","Routing No.","Operation No.");
      GetLine;
      ReservationCheckDateConfl.ProdOrderLineCheck(ProdOrderLine,TRUE);
    END;

    [External]
    PROCEDURE SetRecalcStatus@5();
    BEGIN
      Recalculate := TRUE;
    END;

    [External]
    PROCEDURE RunTimePer@7() : Decimal;
    BEGIN
      IF "Lot Size" = 0 THEN
        "Lot Size" := 1;

      EXIT("Run Time" / "Lot Size");
    END;

    LOCAL PROCEDURE CalculateRoutingBack@10();
    VAR
      ProdOrderLine@1000 : Record 5406;
      ProdOrderRtngLine@1001 : Record 5409;
    BEGIN
      IF "Previous Operation No." <> '' THEN BEGIN
        ProdOrderRtngLine.SETRANGE(Status,Status);
        ProdOrderRtngLine.SETRANGE("Prod. Order No.","Prod. Order No.");
        ProdOrderRtngLine.SETRANGE("Routing Reference No.","Routing Reference No.");
        ProdOrderRtngLine.SETRANGE("Routing No.","Routing No.");
        ProdOrderRtngLine.SETFILTER("Operation No.","Previous Operation No.");
        ProdOrderRtngLine.SETFILTER("Routing Status",'<>%1',ProdOrderRtngLine."Routing Status"::Finished);

        IF ProdOrderRtngLine.FIND('-') THEN
          REPEAT
            ProdOrderRtngLine.SETCURRENTKEY(Status,"Prod. Order No.","Routing Reference No.",
              "Routing No.","Sequence No. (Actual)");
            WorkCenter.GET(ProdOrderRtngLine."Work Center No.");
            CASE WorkCenter."Simulation Type" OF
              WorkCenter."Simulation Type"::Moves:
                BEGIN
                  ProdOrderRouteMgt.CalcSequenceFromActual(ProdOrderRtngLine,Direction::Backward);
                  CalcProdOrder.CalculateRoutingFromActual(ProdOrderRtngLine,Direction::Backward,TRUE);
                END;
              WorkCenter."Simulation Type"::"Moves When Necessary":
                IF (ProdOrderRtngLine."Ending Date" > "Starting Date") OR
                   ((ProdOrderRtngLine."Ending Date" = "Starting Date") AND
                    (ProdOrderRtngLine."Ending Time" > "Starting Time"))
                THEN BEGIN
                  ProdOrderRouteMgt.CalcSequenceFromActual(ProdOrderRtngLine,Direction::Backward);
                  CalcProdOrder.CalculateRoutingFromActual(ProdOrderRtngLine,Direction::Backward,TRUE);
                END;
              WorkCenter."Simulation Type"::Critical:
                BEGIN
                  IF (ProdOrderRtngLine."Ending Date" > "Starting Date") OR
                     ((ProdOrderRtngLine."Ending Date" = "Starting Date") AND
                      (ProdOrderRtngLine."Ending Time" > "Starting Time"))
                  THEN
                    ERROR(Text002);
                END;
            END;
            ProdOrderRtngLine.SETCURRENTKEY(Status,"Prod. Order No.","Routing Reference No.",
              "Routing No.","Operation No.");
          UNTIL ProdOrderRtngLine.NEXT = 0;
      END;

      ProdOrderLine.SETRANGE(Status,Status);
      ProdOrderLine.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderLine.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderLine.SETRANGE("Routing No.","Routing No.");
      IF ProdOrderLine.FIND('-') THEN
        REPEAT
          CalcProdOrder.CalculateProdOrderDates(ProdOrderLine,TRUE);
          AdjustComponents(ProdOrderLine);
        UNTIL ProdOrderLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CalculateRoutingForward@9();
    VAR
      ProdOrderLine@1000 : Record 5406;
      ProdOrderRtngLine@1001 : Record 5409;
    BEGIN
      IF "Next Operation No." <> '' THEN BEGIN
        ProdOrderRtngLine.SETRANGE(Status,Status);
        ProdOrderRtngLine.SETRANGE("Prod. Order No.","Prod. Order No.");
        ProdOrderRtngLine.SETRANGE("Routing Reference No.","Routing Reference No.");
        ProdOrderRtngLine.SETRANGE("Routing No.","Routing No.");
        ProdOrderRtngLine.SETFILTER("Operation No.","Next Operation No.");
        ProdOrderRtngLine.SETFILTER("Routing Status",'<>%1',ProdOrderRtngLine."Routing Status"::Finished);

        IF ProdOrderRtngLine.FIND('-') THEN
          REPEAT
            ProdOrderRtngLine.SETCURRENTKEY(Status,"Prod. Order No.","Routing Reference No.",
              "Routing No.","Sequence No. (Actual)");
            WorkCenter.GET(ProdOrderRtngLine."Work Center No.");
            CASE WorkCenter."Simulation Type" OF
              WorkCenter."Simulation Type"::Moves:
                BEGIN
                  ProdOrderRouteMgt.CalcSequenceFromActual(ProdOrderRtngLine,Direction::Forward);
                  CalcProdOrder.CalculateRoutingFromActual(ProdOrderRtngLine,Direction::Forward,TRUE);
                END;
              WorkCenter."Simulation Type"::"Moves When Necessary":
                IF (ProdOrderRtngLine."Starting Date" < "Ending Date") OR
                   ((ProdOrderRtngLine."Starting Date" = "Ending Date") AND
                    (ProdOrderRtngLine."Starting Time" < "Ending Time"))
                THEN BEGIN
                  ProdOrderRouteMgt.CalcSequenceFromActual(ProdOrderRtngLine,Direction::Forward);
                  CalcProdOrder.CalculateRoutingFromActual(ProdOrderRtngLine,Direction::Forward,TRUE);
                END;
              WorkCenter."Simulation Type"::Critical:
                BEGIN
                  IF (ProdOrderRtngLine."Starting Date" < "Ending Date") OR
                     ((ProdOrderRtngLine."Starting Date" = "Ending Date") AND
                      (ProdOrderRtngLine."Starting Time" < "Ending Time"))
                  THEN
                    ERROR(Text003);
                END;
            END;
            ProdOrderRtngLine.SETCURRENTKEY(Status,"Prod. Order No.","Routing Reference No.",
              "Routing No.","Operation No.");
          UNTIL ProdOrderRtngLine.NEXT = 0;
      END;

      ProdOrderLine.SETRANGE(Status,Status);
      ProdOrderLine.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderLine.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderLine.SETRANGE("Routing No.","Routing No.");
      IF ProdOrderLine.FIND('-') THEN
        REPEAT
          CalcProdOrder.CalculateProdOrderDates(ProdOrderLine,TRUE);
          AdjustComponents(ProdOrderLine);
        UNTIL ProdOrderLine.NEXT = 0;
      CalcProdOrder.CalculateComponents;
    END;

    LOCAL PROCEDURE ModifyCapNeedEntries@13();
    BEGIN
      ProdOrderCapNeed.SETRANGE(Status,Status);
      ProdOrderCapNeed.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderCapNeed.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderCapNeed.SETRANGE("Routing No.","Routing No.");
      ProdOrderCapNeed.SETRANGE("Operation No.","Operation No.");
      ProdOrderCapNeed.SETRANGE("Requested Only",FALSE);
      IF ProdOrderCapNeed.FIND('-') THEN
        REPEAT
          ProdOrderCapNeed."No." := "No.";
          ProdOrderCapNeed."Work Center No." := "Work Center No.";
          ProdOrderCapNeed."Work Center Group Code" := "Work Center Group Code";
          ProdOrderCapNeed.MODIFY;
        UNTIL ProdOrderCapNeed.NEXT = 0;
    END;

    LOCAL PROCEDURE AdjustComponents@14(VAR ProdOrderLine@1000 : Record 5406);
    VAR
      ProdOrderComp@1001 : Record 5407;
    BEGIN
      ProdOrderComp.SETRANGE(Status,Status);
      ProdOrderComp.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderComp.SETRANGE("Prod. Order Line No.",ProdOrderLine."Line No.");

      IF ProdOrderComp.FIND('-') THEN
        REPEAT
          ProdOrderComp.VALIDATE("Routing Link Code");
          ProdOrderComp.MODIFY;
        UNTIL ProdOrderComp.NEXT = 0;
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
    PROCEDURE CheckPreviousAndNext@18();
    VAR
      ProdOrderRtngLine@1001 : Record 5409;
      TempDeletedProdOrderRtngLine@1002 : TEMPORARY Record 5409;
      TempRemainingProdOrderRtngLine@1003 : TEMPORARY Record 5409;
      ProdOrderRoutingForm@1006 : Page 99000817;
      ErrorOnNext@1004 : Boolean;
      ErrorOnPrevious@1005 : Boolean;
    BEGIN
      TempDeletedProdOrderRtngLine := Rec;
      TempDeletedProdOrderRtngLine.INSERT;

      ProdOrderRtngLine.SETRANGE(Status,Status);
      ProdOrderRtngLine.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderRtngLine.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderRtngLine.SETRANGE("Routing No.","Routing No.");
      ProdOrderRtngLine.SETFILTER("Operation No.",'<>%1',"Operation No.");
      ProdOrderRtngLine.SETFILTER("Routing Status",'<>%1',ProdOrderRtngLine."Routing Status"::Finished);

      IF ProdOrderRtngLine.FIND('-') THEN
        REPEAT
          IF ProdOrderRtngLine."Next Operation No." <> '' THEN BEGIN
            TempDeletedProdOrderRtngLine.SETFILTER("Operation No.",ProdOrderRtngLine."Next Operation No.");
            ErrorOnNext := TempDeletedProdOrderRtngLine.FINDFIRST;
          END ELSE
            ErrorOnNext := FALSE;

          IF ProdOrderRtngLine."Previous Operation No." <> '' THEN BEGIN
            TempDeletedProdOrderRtngLine.SETFILTER("Operation No.",ProdOrderRtngLine."Previous Operation No.");
            ErrorOnPrevious := TempDeletedProdOrderRtngLine.FINDFIRST;
          END ELSE
            ErrorOnPrevious := FALSE;

          IF ErrorOnNext OR ErrorOnPrevious THEN BEGIN
            TempRemainingProdOrderRtngLine := ProdOrderRtngLine;
            TempRemainingProdOrderRtngLine.INSERT;
          END
        UNTIL ProdOrderRtngLine.NEXT = 0;

      IF TempRemainingProdOrderRtngLine.FIND('-') THEN BEGIN
        COMMIT;
        IF NOT CONFIRM(
             STRSUBSTNO(Text004,FIELDCAPTION("Next Operation No."),FIELDCAPTION("Previous Operation No.")),
             TRUE)
        THEN
          EXIT;
        ProdOrderRoutingForm.Initialize(STRSUBSTNO(Text005,"Operation No."));
        REPEAT
          TempRemainingProdOrderRtngLine.MARK(TRUE);
        UNTIL TempRemainingProdOrderRtngLine.NEXT = 0;
        TempRemainingProdOrderRtngLine.MARKEDONLY(TRUE);
        ProdOrderRoutingForm.SETTABLEVIEW(TempRemainingProdOrderRtngLine);
        ProdOrderRoutingForm.RUNMODAL;
      END;
    END;

    [External]
    PROCEDURE SetNextOperations@4(VAR RtngLine@1001 : Record 5409);
    VAR
      RtngLine2@1003 : Record 5409;
    BEGIN
      RtngLine2.SETRANGE(Status,RtngLine.Status);
      RtngLine2.SETRANGE("Prod. Order No.",RtngLine."Prod. Order No.");
      RtngLine2.SETRANGE("Routing Reference No.",RtngLine."Routing Reference No.");
      RtngLine2.SETRANGE("Routing No.",RtngLine."Routing No.");
      RtngLine2.SETFILTER("Operation No.",'>%1',RtngLine."Operation No.");

      IF RtngLine2.FINDFIRST THEN
        RtngLine."Next Operation No." := RtngLine2."Operation No."
      ELSE BEGIN
        RtngLine2.SETFILTER("Operation No.",'');
        RtngLine2.SETRANGE("Next Operation No.",'');
        IF RtngLine2.FINDFIRST THEN BEGIN
          RtngLine2."Next Operation No." := RtngLine."Operation No.";
          RtngLine2.MODIFY;
        END;
      END;
    END;

    LOCAL PROCEDURE SubcontractPurchOrderExist@6() : Boolean;
    BEGIN
      IF Status <> Status::Released THEN
        EXIT(FALSE);

      ProdOrderLine.RESET;
      ProdOrderLine.SETRANGE(Status,Status);
      ProdOrderLine.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderLine.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderLine.SETRANGE("Routing No.","Routing No.");
      IF ProdOrderLine.FIND('-') THEN
        REPEAT
          PurchLine.SETCURRENTKEY(
            "Document Type",Type,"Prod. Order No.","Prod. Order Line No.","Routing No.","Operation No.");
          PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
          PurchLine.SETRANGE(Type,PurchLine.Type::Item);
          PurchLine.SETRANGE("Prod. Order No.","Prod. Order No.");
          PurchLine.SETRANGE("Prod. Order Line No.",ProdOrderLine."Line No.");
          PurchLine.SETRANGE("Operation No.","Operation No.");
          IF NOT PurchLine.ISEMPTY THEN
            EXIT(TRUE);
        UNTIL ProdOrderLine.NEXT = 0;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE UpdateComponentsBin@16(FromTrigger@1000 : 'Insert,Modify,Delete');
    VAR
      TempProdOrderRtngLine@1001 : TEMPORARY Record 5409;
    BEGIN
      IF SkipUpdateOfCompBinCodes THEN
        EXIT;

      IF NOT UpdateOfComponentsBinRequired(FromTrigger) THEN
        EXIT;

      PopulateNewRoutingLineSet(TempProdOrderRtngLine,FromTrigger);
      ProdOrderRouteMgt.UpdateComponentsBin(TempProdOrderRtngLine,FALSE);
    END;

    LOCAL PROCEDURE UpdateOfComponentsBinRequired@19(FromTrigger@1000 : 'Insert,Modify,Delete') : Boolean;
    BEGIN
      IF ("No." = '') AND (xRec."No." = "No.") THEN // bin codes are and were empty
        EXIT(FALSE);

      CASE FromTrigger OF
        FromTrigger::Insert,FromTrigger::Delete:
          EXIT(("Previous Operation No." = '') OR ("Routing Link Code" <> ''));
        FromTrigger::Modify:
          EXIT(
            ((xRec."Previous Operation No." = '') AND ("Previous Operation No." <> '')) OR
            ((xRec."Previous Operation No." <> '') AND ("Previous Operation No." = '')) OR
            (xRec."Routing Link Code" <> "Routing Link Code") OR
            ((("Previous Operation No." = '') OR ("Routing Link Code" <> '')) AND
             ((xRec."To-Production Bin Code" <> "To-Production Bin Code") OR
              (xRec."Open Shop Floor Bin Code" <> "Open Shop Floor Bin Code"))));
      END;
    END;

    LOCAL PROCEDURE PopulateNewRoutingLineSet@20(VAR ProdOrderRtngLineTmp@1000 : Record 5409;FromTrigger@1001 : 'Insert,Modify,Delete');
    VAR
      ProdOrderRtngLine2@1002 : Record 5409;
    BEGIN
      // copy existing routings for this prod. order to temporary table
      ProdOrderRtngLineTmp.DELETEALL;
      ProdOrderRtngLine2.SETCURRENTKEY(Status,"Prod. Order No.","Routing Reference No.","Routing No.","Operation No.");
      ProdOrderRtngLine2.SETRANGE(Status,Status);
      ProdOrderRtngLine2.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderRtngLine2.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderRtngLine2.SETRANGE("Routing No.","Routing No.");
      IF ProdOrderRtngLine2.FINDSET(FALSE) THEN
        REPEAT
          ProdOrderRtngLineTmp := ProdOrderRtngLine2;
          ProdOrderRtngLineTmp.INSERT;
        UNTIL ProdOrderRtngLine2.NEXT = 0;

      // update the recordset with the current change
      ProdOrderRtngLineTmp := Rec;
      CASE FromTrigger OF
        FromTrigger::Insert:
          ProdOrderRtngLineTmp.INSERT;
        FromTrigger::Modify:
          ProdOrderRtngLineTmp.MODIFY;
        FromTrigger::Delete:
          ProdOrderRtngLineTmp.DELETE;
      END;
    END;

    [External]
    PROCEDURE SetSkipUpdateOfCompBinCodes@21(Setting@1000 : Boolean);
    BEGIN
      SkipUpdateOfCompBinCodes := Setting;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterWorkCenterTransferFields@22(VAR ProdOrderRoutingLine@1000 : Record 5409;WorkCenter@1001 : Record 99000754);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterMachineCtrTransferFields@23(VAR ProdOrderRoutingLine@1000 : Record 5409;WorkCenter@1001 : Record 99000754;MachineCenter@1002 : Record 99000758);
    BEGIN
    END;

    BEGIN
    END.
  }
}

