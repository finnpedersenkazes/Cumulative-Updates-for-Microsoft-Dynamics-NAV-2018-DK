OBJECT Table 167 Job
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Description;
    OnInsert=BEGIN
               JobsSetup.GET;

               IF "No." = '' THEN BEGIN
                 JobsSetup.TESTFIELD("Job Nos.");
                 NoSeriesMgt.InitSeries(JobsSetup."Job Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;

               IF GETFILTER("Bill-to Customer No.") <> '' THEN
                 IF GETRANGEMIN("Bill-to Customer No.") = GETRANGEMAX("Bill-to Customer No.") THEN
                   VALIDATE("Bill-to Customer No.",GETRANGEMIN("Bill-to Customer No."));

               IF NOT "Apply Usage Link" THEN
                 VALIDATE("Apply Usage Link",JobsSetup."Apply Usage Link by Default");
               IF NOT "Allow Schedule/Contract Lines" THEN
                 VALIDATE("Allow Schedule/Contract Lines",JobsSetup."Allow Sched/Contract Lines Def");
               IF "WIP Method" = '' THEN
                 VALIDATE("WIP Method",JobsSetup."Default WIP Method");
               IF "Job Posting Group" = '' THEN
                 VALIDATE("Job Posting Group",JobsSetup."Default Job Posting Group");
               VALIDATE("WIP Posting Method",JobsSetup."Default WIP Posting Method");

               DimMgt.UpdateDefaultDim(
                 DATABASE::Job,"No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");
               InitWIPFields;

               "Creation Date" := TODAY;
               "Last Date Modified" := "Creation Date";

               IF ("Project Manager" <> '') AND (Status = Status::Open) THEN
                 AddToMyJobs("Project Manager");
             END;

    OnModify=BEGIN
               "Last Date Modified" := TODAY;

               IF (("Project Manager" <> xRec."Project Manager") AND (xRec."Project Manager" <> '')) OR (Status <> Status::Open) THEN
                 RemoveFromMyJobs;

               IF ("Project Manager" <> '') AND (xRec."Project Manager" <> "Project Manager") THEN
                 IF Status = Status::Open THEN
                   AddToMyJobs("Project Manager");
             END;

    OnDelete=VAR
               CommentLine@1004 : Record 97;
               JobTask@1000 : Record 1001;
               JobResPrice@1001 : Record 1012;
               JobItemPrice@1002 : Record 1013;
               JobGLAccPrice@1003 : Record 1014;
             BEGIN
               MoveEntries.MoveJobEntries(Rec);

               JobTask.SETCURRENTKEY("Job No.");
               JobTask.SETRANGE("Job No.","No.");
               JobTask.DELETEALL(TRUE);

               JobResPrice.SETRANGE("Job No.","No.");
               JobResPrice.DELETEALL;

               JobItemPrice.SETRANGE("Job No.","No.");
               JobItemPrice.DELETEALL;

               JobGLAccPrice.SETRANGE("Job No.","No.");
               JobGLAccPrice.DELETEALL;

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Job);
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;

               DimMgt.DeleteDefaultDim(DATABASE::Job,"No.");

               IF "Project Manager" <> '' THEN
                 RemoveFromMyJobs;
             END;

    OnRename=BEGIN
               UpdateJobNoInReservationEntries;
               "Last Date Modified" := TODAY;
             END;

    CaptionML=[DAN=Sag;
               ENU=Job];
    LookupPageID=Page89;
    DrillDownPageID=Page89;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  JobsSetup.GET;
                                                                  NoSeriesMgt.TestManual(JobsSetup."Job Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   AltSearchField=Search Description;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Search Description  ;Code50        ;CaptionML=[DAN=S�gebeskrivelse;
                                                              ENU=Search Description] }
    { 3   ;   ;Description         ;Text50        ;OnValidate=BEGIN
                                                                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                                                                  "Search Description" := Description;
                                                              END;

                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 5   ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   OnValidate=BEGIN
                                                                IF ("Bill-to Customer No." = '') OR ("Bill-to Customer No." <> xRec."Bill-to Customer No.") THEN
                                                                  IF JobLedgEntryExist OR JobPlanningLineExist THEN
                                                                    ERROR(AssociatedEntriesExistErr,FIELDCAPTION("Bill-to Customer No."),TABLECAPTION);
                                                                UpdateCust;
                                                              END;

                                                   CaptionML=[DAN=Faktureres til kundenr.;
                                                              ENU=Bill-to Customer No.] }
    { 12  ;   ;Creation Date       ;Date          ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Creation Date];
                                                   Editable=No }
    { 13  ;   ;Starting Date       ;Date          ;OnValidate=BEGIN
                                                                CheckDate;
                                                              END;

                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 14  ;   ;Ending Date         ;Date          ;OnValidate=BEGIN
                                                                CheckDate;
                                                              END;

                                                   CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date] }
    { 19  ;   ;Status              ;Option        ;InitValue=Open;
                                                   OnValidate=VAR
                                                                JobPlanningLine@1000 : Record 1003;
                                                              BEGIN
                                                                IF xRec.Status <> Status THEN BEGIN
                                                                  IF Status = Status::Completed THEN
                                                                    VALIDATE(Complete,TRUE);
                                                                  IF xRec.Status = xRec.Status::Completed THEN
                                                                    IF DIALOG.CONFIRM(StatusChangeQst) THEN
                                                                      VALIDATE(Complete,FALSE)
                                                                    ELSE
                                                                      Status := xRec.Status;
                                                                  MODIFY;
                                                                  JobPlanningLine.SETCURRENTKEY("Job No.");
                                                                  JobPlanningLine.SETRANGE("Job No.","No.");
                                                                  JobPlanningLine.MODIFYALL(Status,Status);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Planl�gning,Tilbud,�ben,Afsluttet;
                                                                    ENU=Planning,Quote,Open,Completed];
                                                   OptionString=Planning,Quote,Open,Completed }
    { 20  ;   ;Person Responsible  ;Code20        ;TableRelation=Resource WHERE (Type=CONST(Person));
                                                   CaptionML=[DAN=Ansvarlig;
                                                              ENU=Person Responsible] }
    { 21  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 22  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 23  ;   ;Job Posting Group   ;Code20        ;TableRelation="Job Posting Group";
                                                   CaptionML=[DAN=Sagsbogf�ringsgruppe;
                                                              ENU=Job Posting Group] }
    { 24  ;   ;Blocked             ;Option        ;CaptionML=[DAN=Sp�rret;
                                                              ENU=Blocked];
                                                   OptionCaptionML=[DAN=" ,Bogf�ring,Alle";
                                                                    ENU=" ,Posting,All"];
                                                   OptionString=[ ,Posting,All] }
    { 29  ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified];
                                                   Editable=No }
    { 30  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Comment Line" WHERE (Table Name=CONST(Job),
                                                                                           No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 31  ;   ;Customer Disc. Group;Code20        ;TableRelation="Customer Discount Group";
                                                   CaptionML=[DAN=Debitorrabatgruppe;
                                                              ENU=Customer Disc. Group] }
    { 32  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   CaptionML=[DAN=Debitorprisgruppe;
                                                              ENU=Customer Price Group] }
    { 41  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 49  ;   ;Scheduled Res. Qty. ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line"."Quantity (Base)" WHERE (Job No.=FIELD(No.),
                                                                                                                Schedule Line=CONST(Yes),
                                                                                                                Type=CONST(Resource),
                                                                                                                No.=FIELD(Resource Filter),
                                                                                                                Planning Date=FIELD(Planning Date Filter)));
                                                   CaptionML=[DAN=Planlagt ressourceantal;
                                                              ENU=Scheduled Res. Qty.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 50  ;   ;Resource Filter     ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Resource;
                                                   CaptionML=[DAN=Ressourcefilter;
                                                              ENU=Resource Filter] }
    { 51  ;   ;Posting Date Filter ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Bogf�ringsdatofilter;
                                                              ENU=Posting Date Filter] }
    { 55  ;   ;Resource Gr. Filter ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Resource Group";
                                                   CaptionML=[DAN=Ressourcegrp.filter;
                                                              ENU=Resource Gr. Filter] }
    { 56  ;   ;Scheduled Res. Gr. Qty.;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line"."Quantity (Base)" WHERE (Job No.=FIELD(No.),
                                                                                                                Schedule Line=CONST(Yes),
                                                                                                                Type=CONST(Resource),
                                                                                                                Resource Group No.=FIELD(Resource Gr. Filter),
                                                                                                                Planning Date=FIELD(Planning Date Filter)));
                                                   CaptionML=[DAN=Planlagt ress.grp.antal;
                                                              ENU=Scheduled Res. Gr. Qty.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 57  ;   ;Picture             ;BLOB          ;CaptionML=[DAN=Billede;
                                                              ENU=Picture];
                                                   SubType=Bitmap }
    { 58  ;   ;Bill-to Name        ;Text50        ;CaptionML=[DAN=Faktureringsnavn;
                                                              ENU=Bill-to Name] }
    { 59  ;   ;Bill-to Address     ;Text50        ;CaptionML=[DAN=Faktureringsadresse;
                                                              ENU=Bill-to Address] }
    { 60  ;   ;Bill-to Address 2   ;Text50        ;CaptionML=[DAN=Faktureringsadresse 2;
                                                              ENU=Bill-to Address 2] }
    { 61  ;   ;Bill-to City        ;Text30        ;TableRelation=IF (Bill-to Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Bill-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Bill-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(
                                                                  "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Faktureringsby;
                                                              ENU=Bill-to City] }
    { 63  ;   ;Bill-to County      ;Text30        ;CaptionML=[DAN=Faktureringsamt;
                                                              ENU=Bill-to County] }
    { 64  ;   ;Bill-to Post Code   ;Code20        ;TableRelation=IF (Bill-to Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Bill-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Bill-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(
                                                                  "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Faktureringspostnr.;
                                                              ENU=Bill-to Post Code] }
    { 66  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 67  ;   ;Bill-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode til fakturering;
                                                              ENU=Bill-to Country/Region Code];
                                                   Editable=Yes }
    { 68  ;   ;Bill-to Name 2      ;Text50        ;CaptionML=[DAN=Faktureringsnavn 2;
                                                              ENU=Bill-to Name 2] }
    { 117 ;   ;Reserve             ;Option        ;AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Reserver;
                                                              ENU=Reserve];
                                                   OptionCaptionML=[DAN=Aldrig,Eventuelt,Altid;
                                                                    ENU=Never,Optional,Always];
                                                   OptionString=Never,Optional,Always }
    { 140 ;   ;Image               ;Media         ;CaptionML=[DAN=Grafik;
                                                              ENU=Image] }
    { 1000;   ;WIP Method          ;Code20        ;TableRelation="Job WIP Method".Code WHERE (Valid=CONST(Yes));
                                                   OnValidate=VAR
                                                                JobTask@1000 : Record 1001;
                                                                JobWIPMethod@1001 : Record 1006;
                                                              BEGIN
                                                                IF "WIP Posting Method" = "WIP Posting Method"::"Per Job Ledger Entry" THEN BEGIN
                                                                  JobWIPMethod.GET("WIP Method");
                                                                  IF NOT JobWIPMethod."WIP Cost" THEN
                                                                    ERROR(WIPPostMethodErr,FIELDCAPTION("WIP Posting Method"),FIELDCAPTION("WIP Method"),JobWIPMethod.FIELDCAPTION("WIP Cost"));
                                                                  IF NOT JobWIPMethod."WIP Sales" THEN
                                                                    ERROR(WIPPostMethodErr,FIELDCAPTION("WIP Posting Method"),FIELDCAPTION("WIP Method"),JobWIPMethod.FIELDCAPTION("WIP Sales"));
                                                                END;

                                                                JobTask.SETRANGE("Job No.","No.");
                                                                JobTask.SETRANGE("WIP-Total",JobTask."WIP-Total"::Total);
                                                                IF JobTask.FINDFIRST THEN
                                                                  IF CONFIRM(WIPMethodQst,TRUE,JobTask.FIELDCAPTION("WIP Method"),JobTask.TABLECAPTION,JobTask."WIP-Total") THEN
                                                                    JobTask.MODIFYALL("WIP Method","WIP Method",TRUE);
                                                              END;

                                                   CaptionML=[DAN=VIA-metode;
                                                              ENU=WIP Method] }
    { 1001;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                IF "Currency Code" <> xRec."Currency Code" THEN
                                                                  IF NOT JobLedgEntryExist THEN BEGIN
                                                                    CurrencyUpdatePlanningLines;
                                                                    CurrencyUpdatePurchLines;
                                                                  END ELSE
                                                                    ERROR(AssociatedEntriesExistErr,FIELDCAPTION("Currency Code"),TABLECAPTION);
                                                                CurrencyCheck;
                                                              END;

                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 1002;   ;Bill-to Contact No. ;Code20        ;OnValidate=BEGIN
                                                                IF ("Bill-to Contact No." <> xRec."Bill-to Contact No.") AND
                                                                   (xRec."Bill-to Contact No." <> '')
                                                                THEN
                                                                  IF ("Bill-to Contact No." = '') AND ("Bill-to Customer No." = '') THEN BEGIN
                                                                    INIT;
                                                                    "No. Series" := xRec."No. Series";
                                                                    VALIDATE(Description,xRec.Description);
                                                                  END;

                                                                IF ("Bill-to Customer No." <> '') AND ("Bill-to Contact No." <> '') THEN BEGIN
                                                                  Cont.GET("Bill-to Contact No.");
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Bill-to Customer No.") THEN
                                                                    IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                                                                      ERROR(ContactBusRelDiffCompErr,Cont."No.",Cont.Name,"Bill-to Customer No.");
                                                                END;
                                                                UpdateBillToCust("Bill-to Contact No.");
                                                              END;

                                                   OnLookup=BEGIN
                                                              IF ("Bill-to Customer No." <> '') AND Cont.GET("Bill-to Contact No.") THEN
                                                                Cont.SETRANGE("Company No.",Cont."Company No.")
                                                              ELSE
                                                                IF Cust.GET("Bill-to Customer No.") THEN BEGIN
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Bill-to Customer No.") THEN
                                                                    Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.");
                                                                END ELSE
                                                                  Cont.SETFILTER("Company No.",'<>%1','''');

                                                              IF "Bill-to Contact No." <> '' THEN
                                                                IF Cont.GET("Bill-to Contact No.") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                                                                xRec := Rec;
                                                                VALIDATE("Bill-to Contact No.",Cont."No.");
                                                              END;
                                                            END;

                                                   AccessByPermission=TableData 5050=R;
                                                   CaptionML=[DAN=Faktureres attentionnr.;
                                                              ENU=Bill-to Contact No.] }
    { 1003;   ;Bill-to Contact     ;Text50        ;CaptionML=[DAN=Faktureres attention;
                                                              ENU=Bill-to Contact] }
    { 1004;   ;Planning Date Filter;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Planl�gningsdatofilter;
                                                              ENU=Planning Date Filter] }
    { 1005;   ;Total WIP Cost Amount;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Job WIP Entry"."WIP Entry Amount" WHERE (Job No.=FIELD(No.),
                                                                                                              Job Complete=CONST(No),
                                                                                                              Type=FILTER(Accrued Costs|Applied Costs|Recognized Costs)));
                                                   CaptionML=[DAN=VIA-kostbel�b i alt;
                                                              ENU=Total WIP Cost Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1006;   ;Total WIP Cost G/L Amount;Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Job WIP G/L Entry"."WIP Entry Amount" WHERE (Job No.=FIELD(No.),
                                                                                                                  Reversed=CONST(No),
                                                                                                                  Job Complete=CONST(No),
                                                                                                                  Type=FILTER(Accrued Costs|Applied Costs|Recognized Costs)));
                                                   CaptionML=[DAN=Samlet VIA-kostbel�b i Finans;
                                                              ENU=Total WIP Cost G/L Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1007;   ;WIP Entries Exist   ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Job WIP Entry" WHERE (Job No.=FIELD(No.)));
                                                   CaptionML=[DAN=Der findes VIA-poster;
                                                              ENU=WIP Entries Exist] }
    { 1008;   ;WIP Posting Date    ;Date          ;CaptionML=[DAN=VIA-bogf�ringsdato;
                                                              ENU=WIP Posting Date];
                                                   Editable=No }
    { 1009;   ;WIP G/L Posting Date;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Min("Job WIP G/L Entry"."WIP Posting Date" WHERE (Reversed=CONST(No),
                                                                                                                 Job No.=FIELD(No.)));
                                                   CaptionML=[DAN=VIA-finansbogf�ringsdato;
                                                              ENU=WIP G/L Posting Date];
                                                   Editable=No }
    { 1011;   ;Invoice Currency Code;Code10       ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                CurrencyCheck;
                                                              END;

                                                   CaptionML=[DAN=Faktureringsvalutakode;
                                                              ENU=Invoice Currency Code] }
    { 1012;   ;Exch. Calculation (Cost);Option    ;CaptionML=[DAN=Kursberegning (kostbel�b);
                                                              ENU=Exch. Calculation (Cost)];
                                                   OptionCaptionML=[DAN=Fast UV,Fast RV;
                                                                    ENU=Fixed FCY,Fixed LCY];
                                                   OptionString=Fixed FCY,Fixed LCY }
    { 1013;   ;Exch. Calculation (Price);Option   ;CaptionML=[DAN=Kursberegning (salgsbel�b);
                                                              ENU=Exch. Calculation (Price)];
                                                   OptionCaptionML=[DAN=Fast UV,Fast RV;
                                                                    ENU=Fixed FCY,Fixed LCY];
                                                   OptionString=Fixed FCY,Fixed LCY }
    { 1014;   ;Allow Schedule/Contract Lines;Boolean;
                                                   CaptionML=[DAN=Tillad budget/fakturerbare linjer;
                                                              ENU=Allow Budget/Billable Lines] }
    { 1015;   ;Complete            ;Boolean       ;OnValidate=BEGIN
                                                                IF Complete <> xRec.Complete THEN
                                                                  ChangeJobCompletionStatus;
                                                              END;

                                                   CaptionML=[DAN=Afsluttet;
                                                              ENU=Complete] }
    { 1017;   ;Recog. Sales Amount ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Job WIP Entry"."WIP Entry Amount" WHERE (Job No.=FIELD(No.),
                                                                                                              Type=FILTER(Recognized Sales)));
                                                   CaptionML=[DAN=Realiseret salgsbel�b;
                                                              ENU=Recog. Sales Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1018;   ;Recog. Sales G/L Amount;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Job WIP G/L Entry"."WIP Entry Amount" WHERE (Job No.=FIELD(No.),
                                                                                                                  Reversed=CONST(No),
                                                                                                                  Type=FILTER(Recognized Sales)));
                                                   CaptionML=[DAN=Realiseret bogf�rt salgsbel�b;
                                                              ENU=Recog. Sales G/L Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1019;   ;Recog. Costs Amount ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job WIP Entry"."WIP Entry Amount" WHERE (Job No.=FIELD(No.),
                                                                                                             Type=FILTER(Recognized Costs)));
                                                   CaptionML=[DAN=Realiseret kostbel�b;
                                                              ENU=Recog. Costs Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1020;   ;Recog. Costs G/L Amount;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job WIP G/L Entry"."WIP Entry Amount" WHERE (Job No.=FIELD(No.),
                                                                                                                 Reversed=CONST(No),
                                                                                                                 Type=FILTER(Recognized Costs)));
                                                   CaptionML=[DAN=Realiseret bogf�rt kostbel�b;
                                                              ENU=Recog. Costs G/L Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1021;   ;Total WIP Sales Amount;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job WIP Entry"."WIP Entry Amount" WHERE (Job No.=FIELD(No.),
                                                                                                             Job Complete=CONST(No),
                                                                                                             Type=FILTER(Accrued Sales|Applied Sales|Recognized Sales)));
                                                   CaptionML=[DAN=VIA-salgsbel�b i alt;
                                                              ENU=Total WIP Sales Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1022;   ;Total WIP Sales G/L Amount;Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job WIP G/L Entry"."WIP Entry Amount" WHERE (Job No.=FIELD(No.),
                                                                                                                 Reversed=CONST(No),
                                                                                                                 Job Complete=CONST(No),
                                                                                                                 Type=FILTER(Accrued Sales|Applied Sales|Recognized Sales)));
                                                   CaptionML=[DAN=Bogf�rt VIA-salgsbel�b i alt;
                                                              ENU=Total WIP Sales G/L Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1023;   ;WIP Completion Calculated;Boolean  ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Job WIP Entry" WHERE (Job No.=FIELD(No.),
                                                                                            Job Complete=CONST(Yes)));
                                                   CaptionML=[DAN=VIA-afslutning beregnet;
                                                              ENU=WIP Completion Calculated] }
    { 1024;   ;Next Invoice Date   ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Min("Job Planning Line"."Planning Date" WHERE (Job No.=FIELD(No.),
                                                                                                              Contract Line=CONST(Yes),
                                                                                                              Qty. to Invoice=FILTER(<>0)));
                                                   CaptionML=[DAN=N�ste faktureringsdato;
                                                              ENU=Next Invoice Date] }
    { 1025;   ;Apply Usage Link    ;Boolean       ;OnValidate=VAR
                                                                JobPlanningLine@1000 : Record 1003;
                                                                JobLedgerEntry@1001 : Record 169;
                                                                JobUsageLink@1002 : Record 1020;
                                                              BEGIN
                                                                IF "Apply Usage Link" THEN BEGIN
                                                                  JobLedgerEntry.SETCURRENTKEY("Job No.");
                                                                  JobLedgerEntry.SETRANGE("Job No.","No.");
                                                                  JobLedgerEntry.SETRANGE("Entry Type",JobLedgerEntry."Entry Type"::Usage);
                                                                  IF JobLedgerEntry.FINDFIRST THEN BEGIN
                                                                    JobUsageLink.SETRANGE("Entry No.",JobLedgerEntry."Entry No.");
                                                                    IF JobUsageLink.ISEMPTY THEN
                                                                      ERROR(ApplyUsageLinkErr,TABLECAPTION);
                                                                  END;

                                                                  JobPlanningLine.SETCURRENTKEY("Job No.");
                                                                  JobPlanningLine.SETRANGE("Job No.","No.");
                                                                  JobPlanningLine.SETRANGE("Schedule Line",TRUE);
                                                                  IF JobPlanningLine.FINDSET THEN
                                                                    REPEAT
                                                                      JobPlanningLine.VALIDATE("Usage Link",TRUE);
                                                                      IF JobPlanningLine."Planning Date" = 0D THEN
                                                                        JobPlanningLine.VALIDATE("Planning Date",WORKDATE);
                                                                      JobPlanningLine.MODIFY(TRUE);
                                                                    UNTIL JobPlanningLine.NEXT = 0;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Anvend anvendelseslink;
                                                              ENU=Apply Usage Link] }
    { 1026;   ;WIP Warnings        ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Job WIP Warning" WHERE (Job No.=FIELD(No.)));
                                                   CaptionML=[DAN=VIA-advarsler;
                                                              ENU=WIP Warnings];
                                                   Editable=No }
    { 1027;   ;WIP Posting Method  ;Option        ;OnValidate=VAR
                                                                JobLedgerEntry@1000 : Record 169;
                                                                JobWIPEntry@1001 : Record 1004;
                                                                JobWIPMethod@1002 : Record 1006;
                                                              BEGIN
                                                                IF xRec."WIP Posting Method" = "WIP Posting Method"::"Per Job Ledger Entry" THEN BEGIN
                                                                  JobLedgerEntry.SETRANGE("Job No.","No.");
                                                                  JobLedgerEntry.SETFILTER("Amt. Posted to G/L",'<>%1',0);
                                                                  IF NOT JobLedgerEntry.ISEMPTY THEN
                                                                    ERROR(WIPAlreadyPostedErr,FIELDCAPTION("WIP Posting Method"),xRec."WIP Posting Method");
                                                                END;

                                                                JobWIPEntry.SETRANGE("Job No.","No.");
                                                                IF NOT JobWIPEntry.ISEMPTY THEN
                                                                  ERROR(WIPAlreadyAssociatedErr,FIELDCAPTION("WIP Posting Method"));

                                                                IF "WIP Posting Method" = "WIP Posting Method"::"Per Job Ledger Entry" THEN BEGIN
                                                                  JobWIPMethod.GET("WIP Method");
                                                                  IF NOT JobWIPMethod."WIP Cost" THEN
                                                                    ERROR(WIPPostMethodErr,FIELDCAPTION("WIP Posting Method"),FIELDCAPTION("WIP Method"),JobWIPMethod.FIELDCAPTION("WIP Cost"));
                                                                  IF NOT JobWIPMethod."WIP Sales" THEN
                                                                    ERROR(WIPPostMethodErr,FIELDCAPTION("WIP Posting Method"),FIELDCAPTION("WIP Method"),JobWIPMethod.FIELDCAPTION("WIP Sales"));
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=VIA-bogf�ringsmetode;
                                                              ENU=WIP Posting Method];
                                                   OptionCaptionML=[DAN=Pr. sag,Pr. sagspost;
                                                                    ENU=Per Job,Per Job Ledger Entry];
                                                   OptionString=Per Job,Per Job Ledger Entry }
    { 1028;   ;Applied Costs G/L Amount;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Job WIP G/L Entry"."WIP Entry Amount" WHERE (Job No.=FIELD(No.),
                                                                                                                  Reverse=CONST(No),
                                                                                                                  Job Complete=CONST(No),
                                                                                                                  Type=FILTER(Applied Costs)));
                                                   CaptionML=[DAN=Anvendt finanskostbel�b;
                                                              ENU=Applied Costs G/L Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1029;   ;Applied Sales G/L Amount;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Job WIP G/L Entry"."WIP Entry Amount" WHERE (Job No.=FIELD(No.),
                                                                                                                  Reverse=CONST(No),
                                                                                                                  Job Complete=CONST(No),
                                                                                                                  Type=FILTER(Applied Sales)));
                                                   CaptionML=[DAN=Anvendt finanssalgsbel�b;
                                                              ENU=Applied Sales G/L Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1030;   ;Calc. Recog. Sales Amount;Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Task"."Recognized Sales Amount" WHERE (Job No.=FIELD(No.)));
                                                   CaptionML=[DAN=Ber. reg. salgsbel�b;
                                                              ENU=Calc. Recog. Sales Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1031;   ;Calc. Recog. Costs Amount;Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Task"."Recognized Costs Amount" WHERE (Job No.=FIELD(No.)));
                                                   CaptionML=[DAN=Ber. reg. kostbel�b;
                                                              ENU=Calc. Recog. Costs Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1032;   ;Calc. Recog. Sales G/L Amount;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Task"."Recognized Sales G/L Amount" WHERE (Job No.=FIELD(No.)));
                                                   CaptionML=[DAN=Ber. reg. finanssalgsbel�b;
                                                              ENU=Calc. Recog. Sales G/L Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1033;   ;Calc. Recog. Costs G/L Amount;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Task"."Recognized Costs G/L Amount" WHERE (Job No.=FIELD(No.)));
                                                   CaptionML=[DAN=Ber. reg. finanskostbel�b;
                                                              ENU=Calc. Recog. Costs G/L Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1034;   ;WIP Completion Posted;Boolean      ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Job WIP G/L Entry" WHERE (Job No.=FIELD(No.),
                                                                                                Job Complete=CONST(Yes)));
                                                   CaptionML=[DAN=VIA-afslutning bogf�rt;
                                                              ENU=WIP Completion Posted] }
    { 1035;   ;Over Budget         ;Boolean       ;CaptionML=[DAN=Over budget;
                                                              ENU=Over Budget] }
    { 1036;   ;Project Manager     ;Code50        ;TableRelation="User Setup";
                                                   CaptionML=[DAN=Projektleder;
                                                              ENU=Project Manager] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Search Description                       }
    {    ;Bill-to Customer No.                     }
    {    ;Description                              }
    {    ;Status                                   }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Description,Bill-to Customer No.,Starting Date,Status }
    { 2   ;Brick               ;No.,Description,Bill-to Customer No.,Starting Date,Status,Image }
  }
  CODE
  {
    VAR
      AssociatedEntriesExistErr@1000 : TextConst '@@@="%1 = Name of field used in the error; %2 = The name of the Job table";DAN=Du kan ikke slette %1, fordi en eller flere poster er tilknyttet denne %2.;ENU=You cannot change %1 because one or more entries are associated with this %2.';
      JobsSetup@1004 : Record 315;
      PostCode@1015 : Record 225;
      Job@1014 : Record 167;
      Cust@1006 : Record 18;
      Cont@1005 : Record 5050;
      ContBusinessRelation@1001 : Record 5054;
      NoSeriesMgt@1010 : Codeunit 396;
      DimMgt@1012 : Codeunit 408;
      StatusChangeQst@1017 : TextConst 'DAN=Alle VIA-poster, der ikke er bogf�rt for denne sag, vil blive slettet. Det betyder, at du kan annullere afslutningsposterne for denne sag.\\Vil du forts�tte?;ENU=This will delete any unposted WIP entries for this job and allow you to reverse the completion postings for this job.\\Do you wish to continue?';
      ContactBusRelDiffCompErr@1019 : TextConst '@@@="%1 = The contact number; %2 = The contact''s name; %3 = The Bill-To Customer Number associated with this job";DAN=Kontakten %1 %2 er knyttet til en anden virksomhed end debitoren %3.;ENU=Contact %1 %2 is related to a different company than customer %3.';
      ContactBusRelErr@1018 : TextConst '@@@="%1 = The contact number; %2 = The contact''s name; %3 = The Bill-To Customer Number associated with this job";DAN=Kontakten %1 %2 er ikke knyttet til debitoren %3.;ENU=Contact %1 %2 is not related to customer %3.';
      ContactBusRelMissingErr@1009 : TextConst '@@@="%1 = The contact number; %2 = The contact''s name";DAN=Kontakten %1 %2 er ikke knyttet til en debitor.;ENU=Contact %1 %2 is not related to a customer.';
      TestBlockedErr@1002 : TextConst '@@@="%1 = The Job table name; %2 = The Job number; %3 = The value of the Blocked field";DAN=%1 %2 m� ikke sp�rres med type %3.;ENU=%1 %2 must not be blocked with type %3.';
      ReverseCompletionEntriesMsg@1008 : TextConst '@@@="%1 = The name of the Job Post WIP to G/L report";DAN=Du skal k�re funktionen %1 for at annullere afslutningsposterne, som allerede er bogf�rt for denne sag.;ENU=You must run the %1 function to reverse the completion entries that have already been posted for this job.';
      MoveEntries@1003 : Codeunit 361;
      OnlineMapMsg@1007 : TextConst 'DAN=Vinduet Ops�tning af Online Map skal udfyldes, f�r du kan bruge Online Map.\Se Ops�tning af Online Map i Hj�lp.;ENU=Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
      CheckDateErr@1023 : TextConst '@@@="%1 = The job''s starting date; %2 = The job''s ending date";DAN=%1 skal v�re lig med eller tidligere end %2.;ENU=%1 must be equal to or earlier than %2.';
      BlockedCustErr@1011 : TextConst '@@@="%1 = The Bill-to Customer No. field name; %2 = The job''s Bill-to Customer No. value; %3 = The Customer table name; %4 = The Blocked field name; %5 = The job''s customer''s Blocked value";DAN=Du kan ikke angive %1 til %2, da denne %3 har angivet %4 til %5.;ENU=You cannot set %1 to %2, as this %3 has set %4 to %5.';
      ApplyUsageLinkErr@1013 : TextConst '@@@="%1 = The name of the Job table";DAN=Der kan ikke aktiveres et forbrugslink til hele %1, da forbrug uden forbrugslinket allerede er bogf�rt.;ENU=A usage link cannot be enabled for the entire %1 because usage without the usage link already has been posted.';
      WIPMethodQst@1016 : TextConst '@@@="%1 = The WIP Method field name; %2 = The name of the Job Task table; %3 = The current job task''s WIP Total type";DAN=Vil du angive %1 for enhver %2 af typen %3?;ENU=Do you want to set the %1 on every %2 of type %3?';
      WIPAlreadyPostedErr@1020 : TextConst '@@@="%1 = The name of the WIP Posting Method field; %2 = The previous WIP Posting Method value of this job";DAN=%1 skal angives til %2, da finansposters igangv�rende arbejder for en sag allerede er bogf�rt med denne indstilling.;ENU=%1 must be %2 because job WIP general ledger entries already were posted with this setting.';
      WIPAlreadyAssociatedErr@1021 : TextConst '@@@="%1 = The name of the WIP Posting Method field";DAN=%1 kan ikke redigeres, da sagen har tilknyttede VIA-poster for sagen.;ENU=%1 cannot be modified because the job has associated job WIP entries.';
      WIPPostMethodErr@1024 : TextConst '@@@="%1 = The name of the WIP Posting Method field; %2 = The name of the WIP Method field; %3 = The field caption represented by the value of this job''s WIP method";DAN=Den valgte %1 kr�ver, at %2 har %3 aktiveret.;ENU=The selected %1 requires the %2 to have %3 enabled.';
      EndingDateChangedMsg@1025 : TextConst '@@@="%1 = The name of the Ending Date field; %2 = This job''s Ending Date value";DAN=%1 er sat til %2.;ENU=%1 is set to %2.';
      UpdateJobTaskDimQst@1026 : TextConst 'DAN=Du har �ndret en dimension.\\Vil du opdatere linjerne?;ENU=You have changed a dimension.\\Do you want to update the lines?';
      DocTxt@1027 : TextConst 'DAN=Antal i tilbud;ENU=Job Quote';
      RunWIPFunctionsQst@1028 : TextConst '@@@="%1 = The name of the Job Calculate WIP report";DAN=Du skal k�re funktionen %1 for at oprette afslutningsposter til denne sag. \Vil du k�re denne funktion nu?;ENU=You must run the %1 function to create completion entries for this job. \Do you want to run this function now?';
      DifferentCurrenciesErr@1022 : TextConst 'DAN=Du kan ikke planl�gge og fakturere en sag i forskellige valutaer.;ENU=You cannot plan and invoice a job in different currencies.';

    [External]
    PROCEDURE AssistEdit@2(OldJob@1000 : Record 167) : Boolean;
    BEGIN
      WITH Job DO BEGIN
        Job := Rec;
        JobsSetup.GET;
        JobsSetup.TESTFIELD("Job Nos.");
        IF NoSeriesMgt.SelectSeries(JobsSetup."Job Nos.",OldJob."No. Series","No. Series") THEN BEGIN
          NoSeriesMgt.SetSeries("No.");
          Rec := Job;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Job,"No.",FieldNumber,ShortcutDimCode);
      UpdateJobTaskDimension(FieldNumber,ShortcutDimCode);
      MODIFY;
    END;

    LOCAL PROCEDURE UpdateBillToCont@27(CustomerNo@1000 : Code[20]);
    VAR
      ContBusRel@1003 : Record 5054;
      Cust@1001 : Record 18;
    BEGIN
      IF Cust.GET(CustomerNo) THEN BEGIN
        IF Cust."Primary Contact No." <> '' THEN
          "Bill-to Contact No." := Cust."Primary Contact No."
        ELSE BEGIN
          ContBusRel.RESET;
          ContBusRel.SETCURRENTKEY("Link to Table","No.");
          ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
          ContBusRel.SETRANGE("No.","Bill-to Customer No.");
          IF ContBusRel.FINDFIRST THEN
            "Bill-to Contact No." := ContBusRel."Contact No.";
        END;
        "Bill-to Contact" := Cust.Contact;
      END;
    END;

    LOCAL PROCEDURE JobLedgEntryExist@5() : Boolean;
    VAR
      JobLedgEntry@1000 : Record 169;
    BEGIN
      CLEAR(JobLedgEntry);
      JobLedgEntry.SETCURRENTKEY("Job No.");
      JobLedgEntry.SETRANGE("Job No.","No.");
      EXIT(JobLedgEntry.FINDFIRST);
    END;

    LOCAL PROCEDURE JobPlanningLineExist@3() : Boolean;
    VAR
      JobPlanningLine@1000 : Record 1003;
    BEGIN
      JobPlanningLine.INIT;
      JobPlanningLine.SETRANGE("Job No.","No.");
      EXIT(JobPlanningLine.FINDFIRST);
    END;

    LOCAL PROCEDURE UpdateBillToCust@26(ContactNo@1000 : Code[20]);
    VAR
      ContBusinessRelation@1005 : Record 5054;
      Cust@1004 : Record 18;
      Cont@1003 : Record 5050;
    BEGIN
      IF Cont.GET(ContactNo) THEN BEGIN
        "Bill-to Contact No." := Cont."No.";
        IF Cont.Type = Cont.Type::Person THEN
          "Bill-to Contact" := Cont.Name
        ELSE
          IF Cust.GET("Bill-to Customer No.") THEN
            "Bill-to Contact" := Cust.Contact
          ELSE
            "Bill-to Contact" := '';
      END ELSE BEGIN
        "Bill-to Contact" := '';
        EXIT;
      END;

      IF ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."Company No.") THEN BEGIN
        IF "Bill-to Customer No." = '' THEN
          VALIDATE("Bill-to Customer No.",ContBusinessRelation."No.")
        ELSE
          IF "Bill-to Customer No." <> ContBusinessRelation."No." THEN
            ERROR(ContactBusRelErr,Cont."No.",Cont.Name,"Bill-to Customer No.");
      END ELSE
        ERROR(ContactBusRelMissingErr,Cont."No.",Cont.Name);
    END;

    LOCAL PROCEDURE UpdateCust@4();
    BEGIN
      IF "Bill-to Customer No." <> '' THEN BEGIN
        Cust.GET("Bill-to Customer No.");
        Cust.TESTFIELD("Customer Posting Group");
        Cust.TESTFIELD("Bill-to Customer No.",'');
        IF Cust."Privacy Blocked" THEN
          ERROR(Cust.GetPrivacyBlockedGenericErrorText(Cust));
        IF Cust.Blocked = Cust.Blocked::All THEN
          ERROR(
            BlockedCustErr,
            FIELDCAPTION("Bill-to Customer No."),
            "Bill-to Customer No.",
            Cust.TABLECAPTION,
            FIELDCAPTION(Blocked),
            Cust.Blocked);
        "Bill-to Name" := Cust.Name;
        "Bill-to Name 2" := Cust."Name 2";
        "Bill-to Address" := Cust.Address;
        "Bill-to Address 2" := Cust."Address 2";
        "Bill-to City" := Cust.City;
        "Bill-to Post Code" := Cust."Post Code";
        "Bill-to Country/Region Code" := Cust."Country/Region Code";
        "Invoice Currency Code" := Cust."Currency Code";
        IF "Invoice Currency Code" <> '' THEN
          IF "Currency Code" <> "Invoice Currency Code" THEN
            "Currency Code" := '';
        "Customer Disc. Group" := Cust."Customer Disc. Group";
        "Customer Price Group" := Cust."Customer Price Group";
        "Language Code" := Cust."Language Code";
        "Bill-to County" := Cust.County;
        Reserve := Cust.Reserve;
        UpdateBillToCont("Bill-to Customer No.");
      END ELSE BEGIN
        "Bill-to Name" := '';
        "Bill-to Name 2" := '';
        "Bill-to Address" := '';
        "Bill-to Address 2" := '';
        "Bill-to City" := '';
        "Bill-to Post Code" := '';
        "Bill-to Country/Region Code" := '';
        "Invoice Currency Code" := '';
        "Customer Disc. Group" := '';
        "Customer Price Group" := '';
        "Language Code" := '';
        "Bill-to County" := '';
        VALIDATE("Bill-to Contact No.",'');
      END;

      OnAfterUpdateBillToCust(Rec);
    END;

    [External]
    PROCEDURE InitWIPFields@1();
    BEGIN
      "WIP Posting Date" := 0D;
      "WIP G/L Posting Date" := 0D;
    END;

    [External]
    PROCEDURE TestBlocked@6();
    BEGIN
      IF Blocked = Blocked::" " THEN
        EXIT;
      ERROR(TestBlockedErr,TABLECAPTION,"No.",Blocked);
    END;

    [External]
    PROCEDURE CurrencyUpdatePlanningLines@10();
    VAR
      JobPlanningLine@1000 : Record 1003;
    BEGIN
      JobPlanningLine.SETRANGE("Job No.","No.");
      IF JobPlanningLine.FIND('-') THEN
        REPEAT
          JobPlanningLine.CALCFIELDS("Qty. Transferred to Invoice");
          IF JobPlanningLine."Qty. Transferred to Invoice" <> 0 THEN
            ERROR(AssociatedEntriesExistErr,FIELDCAPTION("Currency Code"),TABLECAPTION);
          JobPlanningLine.VALIDATE("Currency Code","Currency Code");
          JobPlanningLine.VALIDATE("Currency Date");
          JobPlanningLine.MODIFY;
        UNTIL JobPlanningLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CurrencyUpdatePurchLines@17();
    VAR
      PurchLine@1000 : Record 39;
    BEGIN
      MODIFY;
      PurchLine.SETRANGE("Job No.","No.");
      IF PurchLine.FINDSET THEN
        REPEAT
          PurchLine.VALIDATE("Job Currency Code","Currency Code");
          PurchLine.VALIDATE("Job Task No.");
          PurchLine.MODIFY;
        UNTIL PurchLine.NEXT = 0;
    END;

    LOCAL PROCEDURE ChangeJobCompletionStatus@7();
    VAR
      JobCalcWIP@1001 : Codeunit 1000;
    BEGIN
      IF Complete THEN BEGIN
        VALIDATE("Ending Date",CalcEndingDate);
        MESSAGE(EndingDateChangedMsg,FIELDCAPTION("Ending Date"),"Ending Date");
      END ELSE BEGIN
        JobCalcWIP.ReOpenJob("No.");
        "WIP Posting Date" := 0D;
        MESSAGE(ReverseCompletionEntriesMsg,GetReportCaption(REPORT::"Job Post WIP to G/L"));
      END;

      OnAfterChangeJobCompletionStatus(Rec,xRec)
    END;

    [Internal]
    PROCEDURE DisplayMap@8();
    VAR
      OnlineMapSetup@1001 : Record 800;
      OnlineMapManagement@1000 : Codeunit 802;
    BEGIN
      IF OnlineMapSetup.FINDFIRST THEN
        OnlineMapManagement.MakeSelection(DATABASE::Job,GETPOSITION)
      ELSE
        MESSAGE(OnlineMapMsg);
    END;

    [External]
    PROCEDURE GetQuantityAvailable@9(ItemNo@1000 : Code[20];LocationCode@1001 : Code[10];VariantCode@1002 : Code[10];InEntryType@1004 : 'Usage,Sale,Both';Direction@1005 : 'Positive,Negative,Both') QtyBase : Decimal;
    VAR
      JobLedgEntry@1003 : Record 169;
    BEGIN
      CLEAR(JobLedgEntry);
      JobLedgEntry.SETCURRENTKEY("Job No.","Entry Type",Type,"No.");
      JobLedgEntry.SETRANGE("Job No.","No.");
      IF NOT (InEntryType = InEntryType::Both) THEN
        JobLedgEntry.SETRANGE("Entry Type",InEntryType);
      JobLedgEntry.SETRANGE(Type,JobLedgEntry.Type::Item);
      JobLedgEntry.SETRANGE("No.",ItemNo);
      IF JobLedgEntry.FINDSET THEN
        REPEAT
          IF (JobLedgEntry."Location Code" = LocationCode) AND
             (JobLedgEntry."Variant Code" = VariantCode) AND
             ((Direction = Direction::Both) OR
              ((Direction = Direction::Positive) AND (JobLedgEntry."Quantity (Base)" > 0)) OR
              ((Direction = Direction::Negative) AND (JobLedgEntry."Quantity (Base)" < 0)))
          THEN
            QtyBase := QtyBase + JobLedgEntry."Quantity (Base)";

        UNTIL JobLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDate@30();
    BEGIN
      IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
        ERROR(CheckDateErr,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"));
    END;

    [External]
    PROCEDURE CalcAccWIPCostsAmount@15() : Decimal;
    BEGIN
      EXIT("Total WIP Cost Amount" + "Applied Costs G/L Amount");
    END;

    [External]
    PROCEDURE CalcAccWIPSalesAmount@16() : Decimal;
    BEGIN
      EXIT("Total WIP Sales Amount" - "Applied Sales G/L Amount");
    END;

    [External]
    PROCEDURE CalcRecognizedProfitAmount@11() : Decimal;
    BEGIN
      EXIT("Calc. Recog. Sales Amount" - "Calc. Recog. Costs Amount");
    END;

    [External]
    PROCEDURE CalcRecognizedProfitPercentage@12() : Decimal;
    BEGIN
      IF "Calc. Recog. Sales Amount" <> 0 THEN
        EXIT((CalcRecognizedProfitAmount / "Calc. Recog. Sales Amount") * 100);
      EXIT(0);
    END;

    [External]
    PROCEDURE CalcRecognizedProfitGLAmount@14() : Decimal;
    BEGIN
      EXIT("Calc. Recog. Sales G/L Amount" - "Calc. Recog. Costs G/L Amount");
    END;

    [External]
    PROCEDURE CalcRecognProfitGLPercentage@13() : Decimal;
    BEGIN
      IF "Calc. Recog. Sales G/L Amount" <> 0 THEN
        EXIT((CalcRecognizedProfitGLAmount / "Calc. Recog. Sales G/L Amount") * 100);
      EXIT(0);
    END;

    PROCEDURE CurrencyCheck@36();
    BEGIN
      IF ("Invoice Currency Code" <> "Currency Code") AND ("Invoice Currency Code" <> '') AND ("Currency Code" <> '') THEN
        ERROR(DifferentCurrenciesErr);
    END;

    [External]
    PROCEDURE PercentCompleted@19() : Decimal;
    VAR
      JobCalcStatistics@1000 : Codeunit 1008;
      CL@1001 : ARRAY [16] OF Decimal;
    BEGIN
      JobCalcStatistics.JobCalculateCommonFilters(Rec);
      JobCalcStatistics.CalculateAmounts;
      JobCalcStatistics.GetLCYCostAmounts(CL);
      IF CL[4] <> 0 THEN
        EXIT((CL[8] / CL[4]) * 100);
      EXIT(0);
    END;

    [External]
    PROCEDURE PercentInvoiced@20() : Decimal;
    VAR
      JobCalcStatistics@1000 : Codeunit 1008;
      PL@1002 : ARRAY [16] OF Decimal;
    BEGIN
      JobCalcStatistics.JobCalculateCommonFilters(Rec);
      JobCalcStatistics.CalculateAmounts;
      JobCalcStatistics.GetLCYPriceAmounts(PL);
      IF PL[12] <> 0 THEN
        EXIT((PL[16] / PL[12]) * 100);
      EXIT(0);
    END;

    [External]
    PROCEDURE PercentOverdue@18() : Decimal;
    VAR
      JobPlanningLine@1000 : Record 1003;
      QtyOverdue@1001 : Decimal;
      QtyOnSchedule@1002 : Decimal;
      QtyTotal@1003 : Decimal;
    BEGIN
      JobPlanningLine.SETRANGE("Job No.","No.");
      IF JobPlanningLine.FINDSET THEN
        REPEAT
          IF (JobPlanningLine."Planning Date" < WORKDATE) AND (JobPlanningLine."Remaining Qty." > 0) THEN
            QtyOverdue += 1
          ELSE
            QtyOnSchedule += 1;
        UNTIL JobPlanningLine.NEXT = 0;
      QtyTotal := QtyOverdue + QtyOnSchedule;
      IF QtyTotal <> 0 THEN
        EXIT((QtyOverdue / QtyTotal) * 100);
      EXIT(0);
    END;

    LOCAL PROCEDURE UpdateJobNoInReservationEntries@21();
    VAR
      ReservEntry@1001 : Record 337;
    BEGIN
      ReservEntry.SETFILTER("Source Type",'%1|%2',DATABASE::"Job Planning Line",DATABASE::"Job Journal Line");
      ReservEntry.SETRANGE("Source ID",xRec."No.");
      ReservEntry.MODIFYALL("Source ID","No.",TRUE);
    END;

    LOCAL PROCEDURE UpdateJobTaskDimension@22(FieldNumber@1001 : Integer;ShortcutDimCode@1000 : Code[20]);
    VAR
      JobTask@1002 : Record 1001;
    BEGIN
      IF GUIALLOWED THEN
        IF NOT CONFIRM(UpdateJobTaskDimQst,FALSE) THEN
          EXIT;

      JobTask.SETRANGE("Job No.","No.");
      IF JobTask.FINDSET(TRUE) THEN
        REPEAT
          CASE FieldNumber OF
            1:
              JobTask.VALIDATE("Global Dimension 1 Code",ShortcutDimCode);
            2:
              JobTask.VALIDATE("Global Dimension 2 Code",ShortcutDimCode);
          END;
          JobTask.MODIFY;
        UNTIL JobTask.NEXT = 0;
    END;

    [External]
    PROCEDURE UpdateOverBudgetValue@23(JobNo@1002 : Code[20];Usage@1001 : Boolean;Cost@1007 : Decimal);
    VAR
      JobLedgerEntry@1003 : Record 169;
      JobPlanningLine@1004 : Record 1003;
      UsageCost@1005 : Decimal;
      ScheduleCost@1006 : Decimal;
      NewOverBudget@1000 : Boolean;
    BEGIN
      IF "No." <> JobNo THEN
        IF NOT GET(JobNo) THEN
          EXIT;

      JobLedgerEntry.SETRANGE("Job No.",JobNo);
      JobLedgerEntry.CALCSUMS("Total Cost (LCY)");
      IF JobLedgerEntry."Total Cost (LCY)" = 0 THEN
        EXIT;

      UsageCost := JobLedgerEntry."Total Cost (LCY)";

      JobPlanningLine.SETRANGE("Job No.",JobNo);
      JobPlanningLine.SETRANGE("Schedule Line",TRUE);
      JobPlanningLine.CALCSUMS("Total Cost (LCY)");
      ScheduleCost := JobPlanningLine."Total Cost (LCY)";

      IF Usage THEN
        UsageCost += Cost
      ELSE
        ScheduleCost += Cost;
      NewOverBudget := UsageCost > ScheduleCost;
      IF NewOverBudget <> "Over Budget" THEN BEGIN
        "Over Budget" := NewOverBudget;
        MODIFY;
      END;
    END;

    [External]
    PROCEDURE IsJobSimplificationAvailable@24() : Boolean;
    BEGIN
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE AddToMyJobs@25(ProjectManager@1000 : Code[50]);
    VAR
      MyJob@1001 : Record 9154;
    BEGIN
      IF Status = Status::Open THEN BEGIN
        MyJob.INIT;
        MyJob."User ID" := ProjectManager;
        MyJob."Job No." := "No.";
        MyJob.Description := Description;
        MyJob.Status := Status;
        MyJob."Bill-to Name" := "Bill-to Name";
        MyJob."Percent Completed" := PercentCompleted;
        MyJob."Percent Invoiced" := PercentInvoiced;
        MyJob."Exclude from Business Chart" := FALSE;
        MyJob.INSERT;
      END;
    END;

    LOCAL PROCEDURE RemoveFromMyJobs@28();
    VAR
      MyJob@1001 : Record 9154;
    BEGIN
      MyJob.SETFILTER("Job No.",'=%1',"No.");
      IF MyJob.FINDSET THEN
        REPEAT
          MyJob.DELETE;
        UNTIL MyJob.NEXT = 0;
    END;

    [Internal]
    PROCEDURE SendRecords@34();
    VAR
      DocumentSendingProfile@1001 : Record 60;
      DummyReportSelections@1000 : Record 77;
    BEGIN
      DocumentSendingProfile.SendCustomerRecords(
        DummyReportSelections.Usage::JQ,Rec,DocTxt,"Bill-to Customer No.","No.",
        FIELDNO("Bill-to Customer No."),FIELDNO("No."));
    END;

    [External]
    PROCEDURE SendProfile@33(VAR DocumentSendingProfile@1000 : Record 60);
    VAR
      ReportSelections@1003 : Record 77;
    BEGIN
      DocumentSendingProfile.Send(
        ReportSelections.Usage::JQ,Rec,"No.","Bill-to Customer No.",
        DocTxt,FIELDNO("Bill-to Customer No."),FIELDNO("No."));
    END;

    [External]
    PROCEDURE PrintRecords@32(ShowRequestForm@1000 : Boolean);
    VAR
      DocumentSendingProfile@1002 : Record 60;
      ReportSelections@1001 : Record 77;
    BEGIN
      DocumentSendingProfile.TrySendToPrinter(
        ReportSelections.Usage::JQ,Rec,FIELDNO("Bill-to Customer No."),ShowRequestForm);
    END;

    [Internal]
    PROCEDURE EmailRecords@31(ShowDialog@1000 : Boolean);
    VAR
      DocumentSendingProfile@1003 : Record 60;
      ReportSelections@1001 : Record 77;
    BEGIN
      DocumentSendingProfile.TrySendToEMail(
        ReportSelections.Usage::JQ,Rec,FIELDNO("No."),DocTxt,FIELDNO("Bill-to Customer No."),ShowDialog);
    END;

    PROCEDURE RecalculateJobWIP@48();
    VAR
      Job@1000 : Record 167;
      Confirmed@1001 : Boolean;
      WIPQst@1002 : Text;
    BEGIN
      Job.GET("No.");
      IF Job."WIP Method" = '' THEN
        EXIT;

      Job.SETRECFILTER;
      WIPQst := STRSUBSTNO(RunWIPFunctionsQst,GetReportCaption(REPORT::"Job Calculate WIP"));
      Confirmed := CONFIRM(WIPQst);
      COMMIT;
      REPORT.RUNMODAL(REPORT::"Job Calculate WIP",NOT Confirmed,FALSE,Job);
    END;

    LOCAL PROCEDURE GetReportCaption@41(ReportID@1000 : Integer) : Text;
    VAR
      AllObjWithCaption@1001 : Record 2000000058;
    BEGIN
      AllObjWithCaption.GET(AllObjWithCaption."Object Type"::Report,ReportID);
      EXIT(AllObjWithCaption."Object Caption");
    END;

    LOCAL PROCEDURE CalcEndingDate@35() EndingDate : Date;
    VAR
      JobLedgerEntry@1001 : Record 169;
    BEGIN
      IF "Ending Date" = 0D THEN
        EndingDate := WORKDATE
      ELSE
        EndingDate := "Ending Date";

      JobLedgerEntry.SETRANGE("Job No.","No.");
      REPEAT
        IF JobLedgerEntry."Posting Date" > EndingDate THEN
          EndingDate := JobLedgerEntry."Posting Date";
      UNTIL JobLedgerEntry.NEXT = 0;

      IF "Ending Date" >= EndingDate THEN
        EndingDate := "Ending Date";
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateBillToCust@1001(VAR Job@1000 : Record 167);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterChangeJobCompletionStatus@1002(VAR Job@1000 : Record 167;VAR xJob@1001 : Record 167);
    BEGIN
    END;

    BEGIN
    END.
  }
}

