OBJECT Table 740 VAT Report Header
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "No." = '' THEN
                 NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series",WORKDATE,"No.","No. Series");

               InitRecord;
             END;

    OnModify=BEGIN
               CheckDates;
             END;

    OnDelete=VAR
               VATStatementReportLine@1000 : Record 742;
               VATReportLineRelation@1001 : Record 744;
             BEGIN
               TESTFIELD(Status,Status::Open);
               VATStatementReportLine.SETRANGE("VAT Report No.","No.");
               VATStatementReportLine.SETRANGE("VAT Report Config. Code","VAT Report Config. Code");
               VATStatementReportLine.DELETEALL;
               VATReportLineRelation.SETRANGE("VAT Report No.","No.");
               VATReportLineRelation.DELETEALL;
             END;

    OnRename=BEGIN
               ERROR(Text004);
             END;

    CaptionML=[DAN=Momsrapporthoved;
               ENU=VAT Report Header];
    LookupPageID=Page744;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  NoSeriesMgt.TestManual(GetNoSeriesCode);
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;VAT Report Config. Code;Option     ;TableRelation="VAT Reports Configuration"."VAT Report Type";
                                                   OnValidate=BEGIN
                                                                CheckEditingAllowed;
                                                              END;

                                                   CaptionML=[DAN=Momsrapportkonfig.kode;
                                                              ENU=VAT Report Config. Code];
                                                   OptionCaptionML=[DAN=Oversigt over EU-salg,Momsangivelse;
                                                                    ENU=EC Sales List,VAT Return];
                                                   OptionString=EC Sales List,VAT Return;
                                                   Editable=Yes }
    { 3   ;   ;VAT Report Type     ;Option        ;OnValidate=BEGIN
                                                                CheckEditingAllowed;

                                                                CASE "VAT Report Type" OF
                                                                  "VAT Report Type"::Standard:
                                                                    "Original Report No." := '';
                                                                  "VAT Report Type"::Corrective,"VAT Report Type"::Supplementary:
                                                                    BEGIN
                                                                      VATReportSetup.GET;
                                                                      IF VATReportSetup."Modify Submitted Reports" THEN
                                                                        ERROR(Text001,VATReportSetup.FIELDCAPTION("Modify Submitted Reports"),VATReportSetup.TABLECAPTION);
                                                                    END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Momsrapporttype;
                                                              ENU=VAT Report Type];
                                                   OptionCaptionML=[DAN=Standard,Korrigerende,Supplerende;
                                                                    ENU=Standard,Corrective,Supplementary];
                                                   OptionString=Standard,Corrective,Supplementary }
    { 4   ;   ;Start Date          ;Date          ;OnValidate=BEGIN
                                                                CheckEditingAllowed;
                                                                TESTFIELD("Start Date");
                                                                HandleDateInput;
                                                              END;

                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Start Date] }
    { 5   ;   ;End Date            ;Date          ;OnValidate=BEGIN
                                                                CheckEditingAllowed;
                                                                TESTFIELD("End Date");
                                                                CheckEndDate;
                                                                HandleDateInput;
                                                              END;

                                                   CaptionML=[DAN=Slutdato;
                                                              ENU=End Date] }
    { 6   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=�ben,Frigivet,Sendt,Accepteret,Lukket,Afvist,Annulleret;
                                                                    ENU=Open,Released,Submitted,Accepted,Closed,Rejected,Canceled];
                                                   OptionString=Open,Released,Submitted,Accepted,Closed,Rejected,Canceled;
                                                   Editable=No }
    { 8   ;   ;No. Series          ;Code20        ;OnValidate=BEGIN
                                                                CheckEditingAllowed;
                                                              END;

                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 9   ;   ;Original Report No. ;Code20        ;OnValidate=VAR
                                                                VATReportHeader@1000 : Record 740;
                                                              BEGIN
                                                                CheckEditingAllowed;

                                                                CASE "VAT Report Type" OF
                                                                  "VAT Report Type"::Standard:
                                                                    BEGIN
                                                                      IF "Original Report No." <> '' THEN
                                                                        ERROR(Text006,"VAT Report Type");
                                                                    END;
                                                                  "VAT Report Type"::Corrective,"VAT Report Type"::Supplementary:
                                                                    BEGIN
                                                                      TESTFIELD("Original Report No.");
                                                                      IF "Original Report No." = "No." THEN
                                                                        ERROR(Text005);
                                                                      VATReportHeader.GET("VAT Report Config. Code","Original Report No.");
                                                                      "Start Date" := VATReportHeader."Start Date";
                                                                      "End Date" := VATReportHeader."End Date";
                                                                    END;
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              LookupVATReportHeader@1001 : Record 740;
                                                              VATReportList@1000 : Page 744;
                                                              ShowLookup@1002 : Boolean;
                                                              TypeFilterText@1004 : Text[1024];
                                                            BEGIN
                                                              TypeFilterText := '';
                                                              ShowLookup := FALSE;

                                                              CASE "VAT Report Type" OF
                                                                "VAT Report Type"::Corrective,"VAT Report Type"::Supplementary:
                                                                  ShowLookup := TRUE;
                                                              END;

                                                              IF ShowLookup THEN BEGIN
                                                                LookupVATReportHeader.SETFILTER("No.",'<>' + "No.");
                                                                LookupVATReportHeader.SETRANGE(Status,Status::Accepted);
                                                                LookupVATReportHeader.SETFILTER("VAT Report Type",TypeFilterText);
                                                                VATReportList.SETTABLEVIEW(LookupVATReportHeader);
                                                                VATReportList.LOOKUPMODE(TRUE);
                                                                IF VATReportList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                                                  VATReportList.GETRECORD(LookupVATReportHeader);
                                                                  VALIDATE("Original Report No.",LookupVATReportHeader."No.");
                                                                END;
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Nummer p� oprindelig rapport;
                                                              ENU=Original Report No.] }
    { 10  ;   ;Period Type         ;Option        ;OnValidate=BEGIN
                                                                IF "Period Type" = "Period Type"::Year THEN
                                                                  "Period No." := 1;

                                                                HandlePeriodInput;
                                                              END;

                                                   CaptionML=[DAN=Periodetype;
                                                              ENU=Period Type];
                                                   OptionCaptionML=[DAN=" ,,M�ned,Kvartal,�r";
                                                                    ENU=" ,,Month,Quarter,Year"];
                                                   OptionString=[ ,,Month,Quarter,Year] }
    { 11  ;   ;Period No.          ;Integer       ;TableRelation="Date Lookup Buffer"."Period No." WHERE (Period Type=FIELD(Period Type));
                                                   OnValidate=BEGIN
                                                                HandlePeriodInput;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Periodenr.;
                                                              ENU=Period No.] }
    { 12  ;   ;Period Year         ;Integer       ;OnValidate=BEGIN
                                                                HandlePeriodInput;
                                                              END;

                                                   CaptionML=[DAN=Periode�r;
                                                              ENU=Period Year] }
    { 13  ;   ;Message Id          ;Text250       ;CaptionML=[DAN=Meddelelses-id;
                                                              ENU=Message Id] }
    { 14  ;   ;Statement Template Name;Code10     ;TableRelation="VAT Statement Template";
                                                   CaptionML=[DAN=Angivelsestypenavn;
                                                              ENU=Statement Template Name] }
    { 15  ;   ;Statement Name      ;Code10        ;TableRelation="VAT Statement Name".Name WHERE (Statement Template Name=FIELD(Statement Template Name));
                                                   CaptionML=[DAN=Angivelsesnavn;
                                                              ENU=Statement Name] }
    { 16  ;   ;VAT Report Version  ;Code10        ;TableRelation="VAT Reports Configuration"."VAT Report Version" WHERE (VAT Report Type=FIELD(VAT Report Config. Code));
                                                   CaptionML=[DAN=Momsrapportversion;
                                                              ENU=VAT Report Version] }
    { 17  ;   ;Submitted By        ;GUID          ;TableRelation=User."User Security ID";
                                                   DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Sendt af;
                                                              ENU=Submitted By] }
    { 18  ;   ;Submitted Date      ;Date          ;CaptionML=[DAN=Sendt dato;
                                                              ENU=Submitted Date] }
  }
  KEYS
  {
    {    ;VAT Report Config. Code,No.             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      VATReportSetup@1000 : Record 743;
      Text001@1002 : TextConst 'DAN=V�rdien af feltet %1 i vinduet %2 tillader ikke denne indstilling.;ENU=The value of %1 field in the %2 window does not allow this option.';
      Text002@1001 : TextConst 'DAN=Redigering er ikke tilladt, da rapporten er markeret som %1.;ENU=Editing is not allowed because the report is marked as %1.';
      Text003@1003 : TextConst 'DAN=Slutdatoen m� ikke ligge f�r startdatoen.;ENU=The end date cannot be earlier than the start date.';
      NoSeriesMgt@1004 : Codeunit 396;
      Text004@1005 : TextConst 'DAN=Du kan ikke omd�be rapporten, da den er blevet tildelt et rapportnummer.;ENU=You cannot rename the report because it has been assigned a report number.';
      Text005@1006 : TextConst 'DAN=Du kan ikke angive den samme rapport som referencerapporten.;ENU=You cannot specify the same report as the reference report.';
      Text006@1007 : TextConst 'DAN=Du kan ikke angive en oprindelig rapport for en rapport af typen %1.;ENU=You cannot specify an original report for a report of type %1.';
      Text007@1008 : TextConst 'DAN=Dette er ikke tilladt p� grund af konfigurationen i vinduet %1.;ENU=This is not allowed because of the setup in the %1 window.';
      Text008@1010 : TextConst 'DAN=Du skal angive en oprindelig rapport for en rapport af typen %1.;ENU=You must specify an original report for a report of type %1.';

    [External]
    PROCEDURE GetNoSeriesCode@1() : Code[20];
    BEGIN
      VATReportSetup.GET;
      IF "VAT Report Config. Code" = "VAT Report Config. Code"::"VAT Return" THEN BEGIN
        VATReportSetup.TESTFIELD("VAT Return No. Series");
        EXIT(VATReportSetup."VAT Return No. Series");
      END;

      VATReportSetup.TESTFIELD("No. Series");
      EXIT(VATReportSetup."No. Series");
    END;

    [External]
    PROCEDURE AssistEdit@2(OldVATReportHeader@1001 : Record 740) : Boolean;
    BEGIN
      IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldVATReportHeader."No. Series","No. Series") THEN BEGIN
        NoSeriesMgt.SetSeries("No.");
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE InitRecord@3();
    VAR
      VATReportsConfiguration@1011 : Record 746;
      date@1000 : Date;
    BEGIN
      IF ("VAT Report Config. Code" = "VAT Report Config. Code"::"EC Sales List") OR
         ("VAT Report Config. Code" = "VAT Report Config. Code"::"VAT Return")
      THEN BEGIN
        date := CALCDATE('<-1M>',WORKDATE);
        VALIDATE("Period Year",DATE2DMY(date,3));
        VALIDATE("Period Type","Period Type"::Month);
        VALIDATE("Period No.",DATE2DMY(date,2));
      END ELSE BEGIN
        "Start Date" := WORKDATE;
        "End Date" := WORKDATE;
      END;

      VATReportsConfiguration.SETRANGE("VAT Report Type","VAT Report Config. Code");
      IF VATReportsConfiguration.FINDFIRST AND (VATReportsConfiguration.COUNT = 1) THEN
        "VAT Report Version" := VATReportsConfiguration."VAT Report Version";
    END;

    [External]
    PROCEDURE CheckEditingAllowed@4();
    BEGIN
      IF Status <> Status::Open THEN
        ERROR(Text002,FORMAT(Status));
    END;

    [External]
    PROCEDURE CheckDates@5();
    BEGIN
      TESTFIELD("Start Date");
      TESTFIELD("End Date");
      CheckEndDate;
    END;

    [External]
    PROCEDURE CheckEndDate@6();
    BEGIN
      IF "End Date" < "Start Date" THEN
        ERROR(Text003);
    END;

    [External]
    PROCEDURE CheckIfCanBeSubmitted@7();
    BEGIN
      TESTFIELD(Status,Status::Released);
    END;

    [External]
    PROCEDURE CheckIfCanBeReopened@8(VATReportHeader@1000 : Record 740);
    BEGIN
      IF VATReportHeader.Status <> VATReportHeader.Status::Released THEN
        ERROR(Text007,VATReportSetup.TABLECAPTION);
    END;

    [External]
    PROCEDURE CheckIfCanBeReleased@9(VATReportHeader@1000 : Record 740);
    BEGIN
      VATReportHeader.TESTFIELD(Status,VATReportHeader.Status::Open);

      IF VATReportHeader."VAT Report Type" IN ["VAT Report Type"::Corrective,"VAT Report Type"::Supplementary] THEN
        IF VATReportHeader."Original Report No." = '' THEN
          ERROR(Text008,FORMAT(VATReportHeader."VAT Report Type"));
    END;

    [External]
    PROCEDURE PeriodToDate@10();
    BEGIN
      IF NOT IsPeriodValid THEN
        EXIT;

      IF "Period Type" = "Period Type"::Month THEN BEGIN
        "Start Date" := DMY2DATE(1,"Period No.","Period Year");
        "End Date" := CALCDATE('<1M-1D>',"Start Date");
      END;

      IF "Period Type" = "Period Type"::Quarter THEN BEGIN
        "Start Date" := DMY2DATE(1,1 + ("Period No." - 1) * 3,"Period Year");
        "End Date" := CALCDATE('<+3M-1D>',"Start Date");
      END;

      IF "Period Type" = "Period Type"::Year THEN BEGIN
        "Start Date" := DMY2DATE(1,1,"Period Year");
        "End Date" := DMY2DATE(31,12,"Period Year");
      END;
    END;

    LOCAL PROCEDURE HandleDateInput@11();
    BEGIN
      CLEAR("Period No.");
      CLEAR("Period Type");
      CLEAR("Period Year");
    END;

    LOCAL PROCEDURE HandlePeriodInput@12();
    BEGIN
      CLEAR("Start Date");
      CLEAR("End Date");

      IF NOT IsPeriodValid THEN
        EXIT;

      PeriodToDate;
    END;

    [External]
    PROCEDURE IsPeriodValid@13() : Boolean;
    BEGIN
      IF ("Period Year" = 0) OR ("Period Type" = "Period Type"::" ") OR ("Period No." = 0) THEN
        EXIT(FALSE);

      IF ("Period Type" = "Period Type"::Quarter) AND
         (("Period No." < 1) OR ("Period No." > 4))
      THEN
        EXIT(FALSE);

      IF ("Period Type" = "Period Type"::Month) AND
         (("Period No." < 1) OR ("Period No." > 12))
      THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    BEGIN
    END.
  }
}

