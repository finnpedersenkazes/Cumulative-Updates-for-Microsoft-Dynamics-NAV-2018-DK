OBJECT Table 1001 Job Task
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    OnInsert=VAR
               Job@1000 : Record 167;
               Cust@1001 : Record 18;
             BEGIN
               LOCKTABLE;
               Job.GET("Job No.");
               IF Job.Blocked = Job.Blocked::All THEN
                 Job.TestBlocked;
               Job.TESTFIELD("Bill-to Customer No.");
               Cust.GET(Job."Bill-to Customer No.");

               DimMgt.InsertJobTaskDim("Job No.","Job Task No.","Global Dimension 1 Code","Global Dimension 2 Code");

               CALCFIELDS(
                 "Schedule (Total Cost)",
                 "Usage (Total Cost)");
               Job.UpdateOverBudgetValue("Job No.",TRUE,"Usage (Total Cost)");
               Job.UpdateOverBudgetValue("Job No.",FALSE,"Schedule (Total Cost)");
             END;

    OnModify=BEGIN
               CALCFIELDS("Schedule (Total Cost)","Usage (Total Cost)");
               Job.UpdateOverBudgetValue("Job No.",TRUE,"Usage (Total Cost)");
               Job.UpdateOverBudgetValue("Job No.",FALSE,"Schedule (Total Cost)");
             END;

    OnDelete=VAR
               JobPlanningLine@1000 : Record 1003;
               JobWIPTotal@1002 : Record 1021;
               JobTaskDim@1001 : Record 1002;
             BEGIN
               IF JobLedgEntriesExist THEN
                 ERROR(CannotDeleteAssociatedEntriesErr,TABLECAPTION);

               JobPlanningLine.SETCURRENTKEY("Job No.","Job Task No.");
               JobPlanningLine.SETRANGE("Job No.","Job No.");
               JobPlanningLine.SETRANGE("Job Task No.","Job Task No.");
               JobPlanningLine.DELETEALL(TRUE);

               JobWIPTotal.DeleteEntriesForJobTask(Rec);

               JobTaskDim.SETRANGE("Job No.","Job No.");
               JobTaskDim.SETRANGE("Job Task No.","Job Task No.");
               IF NOT JobTaskDim.ISEMPTY THEN
                 JobTaskDim.DELETEALL;

               CALCFIELDS(
                 "Schedule (Total Cost)",
                 "Usage (Total Cost)");
               Job.UpdateOverBudgetValue("Job No.",TRUE,"Usage (Total Cost)");
               Job.UpdateOverBudgetValue("Job No.",FALSE,"Schedule (Total Cost)");
             END;

    CaptionML=[DAN=Sagsopgave;
               ENU=Job Task];
    LookupPageID=Page1002;
    DrillDownPageID=Page1002;
  }
  FIELDS
  {
    { 1   ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.];
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 2   ;   ;Job Task No.        ;Code20        ;OnValidate=VAR
                                                                Job@1000 : Record 167;
                                                                Cust@1001 : Record 18;
                                                              BEGIN
                                                                IF "Job Task No." = '' THEN
                                                                  EXIT;
                                                                Job.GET("Job No.");
                                                                Job.TESTFIELD("Bill-to Customer No.");
                                                                Cust.GET(Job."Bill-to Customer No.");
                                                                "Job Posting Group" := Job."Job Posting Group";
                                                              END;

                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.];
                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;Job Task Type       ;Option        ;OnValidate=BEGIN
                                                                IF (xRec."Job Task Type" = "Job Task Type"::Posting) AND
                                                                   ("Job Task Type" <> "Job Task Type"::Posting)
                                                                THEN
                                                                  IF JobLedgEntriesExist OR JobPlanningLinesExist THEN
                                                                    ERROR(CannotChangeAssociatedEntriesErr,FIELDCAPTION("Job Task Type"),TABLECAPTION);

                                                                IF "Job Task Type" <> "Job Task Type"::Posting THEN BEGIN
                                                                  "Job Posting Group" := '';
                                                                  IF "WIP-Total" = "WIP-Total"::Excluded THEN
                                                                    "WIP-Total" := "WIP-Total"::" ";
                                                                END;

                                                                Totaling := '';
                                                              END;

                                                   CaptionML=[DAN=Sagsopgavetype;
                                                              ENU=Job Task Type];
                                                   OptionCaptionML=[DAN=Konto,Overskrift,Sum,Fra-sum,Til-sum;
                                                                    ENU=Posting,Heading,Total,Begin-Total,End-Total];
                                                   OptionString=Posting,Heading,Total,Begin-Total,End-Total }
    { 6   ;   ;WIP-Total           ;Option        ;OnValidate=VAR
                                                                Job@1003 : Record 167;
                                                              BEGIN
                                                                CASE "WIP-Total" OF
                                                                  "WIP-Total"::Total:
                                                                    BEGIN
                                                                      Job.GET("Job No.");
                                                                      "WIP Method" := Job."WIP Method";
                                                                    END;
                                                                  "WIP-Total"::Excluded:
                                                                    BEGIN
                                                                      TESTFIELD("Job Task Type","Job Task Type"::Posting);
                                                                      "WIP Method" := ''
                                                                    END;
                                                                  ELSE
                                                                    "WIP Method" := ''
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=VIA i alt;
                                                              ENU=WIP-Total];
                                                   OptionCaptionML=[DAN=" ,I alt,Udelukket";
                                                                    ENU=" ,Total,Excluded"];
                                                   OptionString=[ ,Total,Excluded] }
    { 7   ;   ;Job Posting Group   ;Code20        ;TableRelation="Job Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Job Posting Group" <> '' THEN
                                                                  TESTFIELD("Job Task Type","Job Task Type"::Posting);
                                                              END;

                                                   CaptionML=[DAN=Sagsbogf�ringsgruppe;
                                                              ENU=Job Posting Group] }
    { 9   ;   ;WIP Method          ;Code20        ;TableRelation="Job WIP Method".Code WHERE (Valid=CONST(Yes));
                                                   OnValidate=BEGIN
                                                                IF "WIP Method" <> '' THEN
                                                                  TESTFIELD("WIP-Total","WIP-Total"::Total);
                                                              END;

                                                   CaptionML=[DAN=VIA-metode;
                                                              ENU=WIP Method] }
    { 10  ;   ;Schedule (Total Cost);Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line"."Total Cost (LCY)" WHERE (Job No.=FIELD(Job No.),
                                                                                                                 Job Task No.=FIELD(Job Task No.),
                                                                                                                 Job Task No.=FIELD(FILTER(Totaling)),
                                                                                                                 Schedule Line=CONST(Yes),
                                                                                                                 Planning Date=FIELD(Planning Date Filter)));
                                                   CaptionML=[DAN=Budget (kostbel�b);
                                                              ENU=Budget (Total Cost)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 11  ;   ;Schedule (Total Price);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line"."Line Amount (LCY)" WHERE (Job No.=FIELD(Job No.),
                                                                                                                  Job Task No.=FIELD(Job Task No.),
                                                                                                                  Job Task No.=FIELD(FILTER(Totaling)),
                                                                                                                  Schedule Line=CONST(Yes),
                                                                                                                  Planning Date=FIELD(Planning Date Filter)));
                                                   CaptionML=[DAN=Budget (salgsbel�b);
                                                              ENU=Budget (Total Price)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 12  ;   ;Usage (Total Cost)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE (Job No.=FIELD(Job No.),
                                                                                                                Job Task No.=FIELD(Job Task No.),
                                                                                                                Job Task No.=FIELD(FILTER(Totaling)),
                                                                                                                Entry Type=CONST(Usage),
                                                                                                                Posting Date=FIELD(Posting Date Filter)));
                                                   CaptionML=[DAN=Forbrug (kostbel�b);
                                                              ENU=Usage (Total Cost)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 13  ;   ;Usage (Total Price) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Ledger Entry"."Line Amount (LCY)" WHERE (Job No.=FIELD(Job No.),
                                                                                                                 Job Task No.=FIELD(Job Task No.),
                                                                                                                 Job Task No.=FIELD(FILTER(Totaling)),
                                                                                                                 Entry Type=CONST(Usage),
                                                                                                                 Posting Date=FIELD(Posting Date Filter)));
                                                   CaptionML=[DAN=Forbrug (salgsbel�b);
                                                              ENU=Usage (Total Price)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 14  ;   ;Contract (Total Cost);Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line"."Total Cost (LCY)" WHERE (Job No.=FIELD(Job No.),
                                                                                                                 Job Task No.=FIELD(Job Task No.),
                                                                                                                 Job Task No.=FIELD(FILTER(Totaling)),
                                                                                                                 Contract Line=CONST(Yes),
                                                                                                                 Planning Date=FIELD(Planning Date Filter)));
                                                   CaptionML=[DAN=Fakturerbar (kostbel�b i alt);
                                                              ENU=Billable (Total Cost)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 15  ;   ;Contract (Total Price);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line"."Line Amount (LCY)" WHERE (Job No.=FIELD(Job No.),
                                                                                                                  Job Task No.=FIELD(Job Task No.),
                                                                                                                  Job Task No.=FIELD(FILTER(Totaling)),
                                                                                                                  Contract Line=CONST(Yes),
                                                                                                                  Planning Date=FIELD(Planning Date Filter)));
                                                   CaptionML=[DAN=Fakturerbar (pris i alt);
                                                              ENU=Billable (Total Price)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 16  ;   ;Contract (Invoiced Price);Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Job Ledger Entry"."Line Amount (LCY)" WHERE (Job No.=FIELD(Job No.),
                                                                                                                  Job Task No.=FIELD(Job Task No.),
                                                                                                                  Job Task No.=FIELD(FILTER(Totaling)),
                                                                                                                  Entry Type=CONST(Sale),
                                                                                                                  Posting Date=FIELD(Posting Date Filter)));
                                                   CaptionML=[DAN=Fakturerbar (faktureret pris);
                                                              ENU=Billable (Invoiced Price)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 17  ;   ;Contract (Invoiced Cost);Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE (Job No.=FIELD(Job No.),
                                                                                                                 Job Task No.=FIELD(Job Task No.),
                                                                                                                 Job Task No.=FIELD(FILTER(Totaling)),
                                                                                                                 Entry Type=CONST(Sale),
                                                                                                                 Posting Date=FIELD(Posting Date Filter)));
                                                   CaptionML=[DAN=Fakturerbar (faktureret kostpris);
                                                              ENU=Billable (Invoiced Cost)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 19  ;   ;Posting Date Filter ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Bogf�ringsdatofilter;
                                                              ENU=Posting Date Filter] }
    { 20  ;   ;Planning Date Filter;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Planl�gningsdatofilter;
                                                              ENU=Planning Date Filter] }
    { 21  ;   ;Totaling            ;Text250       ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   OnValidate=BEGIN
                                                                IF Totaling <> '' THEN
                                                                  IF NOT ("Job Task Type" IN ["Job Task Type"::Total,"Job Task Type"::"End-Total"]) THEN
                                                                    FIELDERROR("Job Task Type");
                                                                VALIDATE("WIP-Total");
                                                                CALCFIELDS(
                                                                  "Schedule (Total Cost)",
                                                                  "Schedule (Total Price)",
                                                                  "Usage (Total Cost)",
                                                                  "Usage (Total Price)",
                                                                  "Contract (Total Cost)",
                                                                  "Contract (Total Price)",
                                                                  "Contract (Invoiced Price)",
                                                                  "Contract (Invoiced Cost)");
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Samment�lling;
                                                              ENU=Totaling] }
    { 22  ;   ;New Page            ;Boolean       ;CaptionML=[DAN=Sideskift;
                                                              ENU=New Page] }
    { 23  ;   ;No. of Blank Lines  ;Integer       ;CaptionML=[DAN=Antal tomme linjer;
                                                              ENU=No. of Blank Lines];
                                                   MinValue=0;
                                                   BlankZero=Yes }
    { 24  ;   ;Indentation         ;Integer       ;CaptionML=[DAN=Indrykning;
                                                              ENU=Indentation];
                                                   MinValue=0 }
    { 34  ;   ;Recognized Sales Amount;Decimal    ;CaptionML=[DAN=Realiseret salgsbel�b;
                                                              ENU=Recognized Sales Amount];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 37  ;   ;Recognized Costs Amount;Decimal    ;CaptionML=[DAN=Realiseret kostbel�b;
                                                              ENU=Recognized Costs Amount];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 56  ;   ;Recognized Sales G/L Amount;Decimal;CaptionML=[DAN=Realiseret salgsfinansbel�b;
                                                              ENU=Recognized Sales G/L Amount];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 57  ;   ;Recognized Costs G/L Amount;Decimal;CaptionML=[DAN=Realiseret omkostningsfinansbel�b;
                                                              ENU=Recognized Costs G/L Amount];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 60  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 61  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 62  ;   ;Outstanding Orders  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Amt. Ex. VAT (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                           Job No.=FIELD(Job No.),
                                                                                                                           Job Task No.=FIELD(Job Task No.),
                                                                                                                           Job Task No.=FIELD(FILTER(Totaling))));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Udest�ende ordrer;
                                                              ENU=Outstanding Orders] }
    { 63  ;   ;Amt. Rcd. Not Invoiced;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."A. Rcd. Not Inv. Ex. VAT (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                           Job No.=FIELD(Job No.),
                                                                                                                           Job Task No.=FIELD(Job Task No.),
                                                                                                                           Job Task No.=FIELD(FILTER(Totaling))));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Modt. bel�b (ufakt.);
                                                              ENU=Amt. Rcd. Not Invoiced] }
    { 64  ;   ;Remaining (Total Cost);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line"."Remaining Total Cost (LCY)" WHERE (Job No.=FIELD(Job No.),
                                                                                                                           Job Task No.=FIELD(Job Task No.),
                                                                                                                           Job Task No.=FIELD(FILTER(Totaling)),
                                                                                                                           Schedule Line=CONST(Yes),
                                                                                                                           Planning Date=FIELD(Planning Date Filter)));
                                                   CaptionML=[DAN=Resterende (kostbel�b);
                                                              ENU=Remaining (Total Cost)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 65  ;   ;Remaining (Total Price);Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line"."Remaining Line Amount (LCY)" WHERE (Job No.=FIELD(Job No.),
                                                                                                                            Job Task No.=FIELD(Job Task No.),
                                                                                                                            Job Task No.=FIELD(FILTER(Totaling)),
                                                                                                                            Schedule Line=CONST(Yes),
                                                                                                                            Planning Date=FIELD(Planning Date Filter)));
                                                   CaptionML=[DAN=Resterende (salgsbel�b);
                                                              ENU=Remaining (Total Price)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 66  ;   ;Start Date          ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Min("Job Planning Line"."Planning Date" WHERE (Job No.=FIELD(Job No.),
                                                                                                              Job Task No.=FIELD(Job Task No.)));
                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Start Date];
                                                   Editable=No }
    { 67  ;   ;End Date            ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Max("Job Planning Line"."Planning Date" WHERE (Job No.=FIELD(Job No.),
                                                                                                              Job Task No.=FIELD(Job Task No.)));
                                                   CaptionML=[DAN=Slutdato;
                                                              ENU=End Date];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Job No.,Job Task No.                    ;SumIndexFields=Recognized Sales Amount,Recognized Costs Amount,Recognized Sales G/L Amount,Recognized Costs G/L Amount;
                                                   Clustered=Yes }
    {    ;Job Task No.                             }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Job Task No.,Description,Job Task Type   }
  }
  CODE
  {
    VAR
      CannotDeleteAssociatedEntriesErr@1000 : TextConst '@@@="%1=The job task table name.";DAN=Du kan ikke slette %1, fordi der er tilknyttet en eller flere poster.;ENU=You cannot delete %1 because one or more entries are associated.';
      CannotChangeAssociatedEntriesErr@1002 : TextConst '@@@="%1 = The field name you are trying to change; %2 = The job task table name.";DAN=Du kan ikke slette %1, fordi en eller flere poster er tilknyttet denne %2.;ENU=You cannot change %1 because one or more entries are associated with this %2.';
      Job@1003 : Record 167;
      DimMgt@1001 : Codeunit 408;

    [External]
    PROCEDURE CalcEACTotalCost@6() : Decimal;
    BEGIN
      IF "Job No." <> Job."No." THEN
        IF NOT Job.GET("Job No.") THEN
          EXIT(0);

      IF Job."Apply Usage Link" THEN
        EXIT("Usage (Total Cost)" + "Remaining (Total Cost)");

      EXIT(0);
    END;

    [External]
    PROCEDURE CalcEACTotalPrice@7() : Decimal;
    BEGIN
      IF "Job No." <> Job."No." THEN
        IF NOT Job.GET("Job No.") THEN
          EXIT(0);

      IF Job."Apply Usage Link" THEN
        EXIT("Usage (Total Price)" + "Remaining (Total Price)");

      EXIT(0);
    END;

    LOCAL PROCEDURE JobLedgEntriesExist@2() : Boolean;
    VAR
      JobLedgEntry@1001 : Record 169;
    BEGIN
      JobLedgEntry.SETCURRENTKEY("Job No.","Job Task No.");
      JobLedgEntry.SETRANGE("Job No.","Job No.");
      JobLedgEntry.SETRANGE("Job Task No.","Job Task No.");
      EXIT(JobLedgEntry.FINDFIRST)
    END;

    LOCAL PROCEDURE JobPlanningLinesExist@5() : Boolean;
    VAR
      JobPlanningLine@1000 : Record 1003;
    BEGIN
      JobPlanningLine.SETCURRENTKEY("Job No.","Job Task No.");
      JobPlanningLine.SETRANGE("Job No.","Job No.");
      JobPlanningLine.SETRANGE("Job Task No.","Job Task No.");
      EXIT(JobPlanningLine.FINDFIRST)
    END;

    [External]
    PROCEDURE Caption@3() : Text[250];
    VAR
      Job@1000 : Record 167;
    BEGIN
      IF NOT Job.GET("Job No.") THEN
        EXIT('');
      EXIT(STRSUBSTNO('%1 %2 %3 %4',
          Job."No.",
          Job.Description,
          "Job Task No.",
          Description));
    END;

    [External]
    PROCEDURE InitWIPFields@13();
    VAR
      JobWIPTotal@1000 : Record 1021;
    BEGIN
      JobWIPTotal.SETRANGE("Job No.","Job No.");
      JobWIPTotal.SETRANGE("Job Task No.","Job Task No.");
      JobWIPTotal.SETRANGE("Posted to G/L",FALSE);
      JobWIPTotal.DELETEALL(TRUE);

      "Recognized Sales Amount" := 0;
      "Recognized Costs Amount" := 0;

      MODIFY;
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;ShortcutDimCode@1001 : Code[20]);
    VAR
      JobTask2@1002 : Record 1001;
    BEGIN
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      IF JobTask2.GET("Job No.","Job Task No.") THEN BEGIN
        DimMgt.SaveJobTaskDim("Job No.","Job Task No.",FieldNumber,ShortcutDimCode);
        MODIFY;
      END ELSE
        DimMgt.SaveJobTaskTempDim(FieldNumber,ShortcutDimCode);
    END;

    [External]
    PROCEDURE ClearTempDim@1();
    BEGIN
      DimMgt.DeleteJobTaskTempDim;
    END;

    PROCEDURE ApplyPurchaseLineFilters@4(VAR PurchLine@1000 : Record 39);
    BEGIN
      PurchLine.SETCURRENTKEY("Document Type","Job No.","Job Task No.");
      PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
      PurchLine.SETRANGE("Job No.","Job No.");
      IF "Job Task Type" IN ["Job Task Type"::Total,"Job Task Type"::"End-Total"] THEN
        PurchLine.SETFILTER("Job Task No.",Totaling)
      ELSE
        PurchLine.SETRANGE("Job Task No.","Job Task No.");
    END;

    BEGIN
    END.
  }
}

