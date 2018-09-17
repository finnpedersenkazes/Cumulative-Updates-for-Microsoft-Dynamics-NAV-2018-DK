OBJECT Table 771 Analysis Report Chart Line
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Analyserapportdiagramlinje;
               ENU=Analysis Report Chart Line];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Text132       ;TableRelation="Analysis Report Chart Setup"."User ID" WHERE (Name=FIELD(Name),
                                                                                                                Analysis Area=FIELD(Analysis Area));
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 2   ;   ;Name                ;Text30        ;TableRelation="Analysis Report Chart Setup".Name WHERE (User ID=FIELD(User ID),
                                                                                                           Analysis Area=FIELD(Analysis Area));
                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   Editable=No }
    { 3   ;   ;Analysis Line Line No.;Integer     ;TableRelation="Analysis Line"."Line No." WHERE (Analysis Area=FIELD(Analysis Area),
                                                                                                   Analysis Line Template Name=FIELD(Analysis Line Template Name));
                                                   CaptionML=[DAN=Linjenr. p� analyselinje;
                                                              ENU=Analysis Line Line No.];
                                                   Editable=No }
    { 4   ;   ;Analysis Column Line No.;Integer   ;TableRelation="Analysis Column"."Line No." WHERE (Analysis Area=FIELD(Analysis Area),
                                                                                                     Analysis Column Template=FIELD(Analysis Column Template Name));
                                                   CaptionML=[DAN=Analysekolonnelinjenr.;
                                                              ENU=Analysis Column Line No.];
                                                   Editable=No }
    { 6   ;   ;Analysis Area       ;Option        ;TableRelation="Analysis Report Chart Setup"."Analysis Area" WHERE (User ID=FIELD(User ID),
                                                                                                                      Name=FIELD(Name));
                                                   CaptionML=[DAN=Analyseomr�de;
                                                              ENU=Analysis Area];
                                                   OptionCaptionML=[DAN=Salg,K�b,Lager;
                                                                    ENU=Sales,Purchase,Inventory];
                                                   OptionString=Sales,Purchase,Inventory;
                                                   Editable=No }
    { 7   ;   ;Analysis Line Template Name;Code10 ;TableRelation="Analysis Report Chart Setup"."Analysis Line Template Name" WHERE (User ID=FIELD(User ID),
                                                                                                                                    Analysis Area=FIELD(Analysis Area),
                                                                                                                                    Name=FIELD(Name));
                                                   CaptionML=[DAN=Analyselinjeskabelonnavn;
                                                              ENU=Analysis Line Template Name];
                                                   Editable=No }
    { 8   ;   ;Analysis Column Template Name;Code10;
                                                   TableRelation="Analysis Report Chart Setup"."Analysis Column Template Name" WHERE (User ID=FIELD(User ID),
                                                                                                                                      Analysis Area=FIELD(Analysis Area),
                                                                                                                                      Name=FIELD(Name));
                                                   CaptionML=[DAN=Analysekolonneskabelonnavn;
                                                              ENU=Analysis Column Template Name];
                                                   Editable=No }
    { 10  ;   ;Original Measure Name;Text111      ;CaptionML=[DAN=Navn p� oprindeligt m�l;
                                                              ENU=Original Measure Name];
                                                   Editable=No }
    { 15  ;   ;Measure Name        ;Text111       ;OnValidate=BEGIN
                                                                TESTFIELD("Measure Name");
                                                              END;

                                                   CaptionML=[DAN=Navn p� m�l;
                                                              ENU=Measure Name] }
    { 20  ;   ;Measure Value       ;Text30        ;CaptionML=[DAN=M�lev�rdi;
                                                              ENU=Measure Value];
                                                   Editable=No }
    { 40  ;   ;Chart Type          ;Option        ;OnValidate=VAR
                                                                AnalysisReportChartSetup@1001 : Record 770;
                                                                AnalysisReportChartLine@1000 : Record 771;
                                                                BusinessChartBuffer@1003 : Record 485;
                                                                ActualNumMeasures@1004 : Integer;
                                                              BEGIN
                                                                IF ("Chart Type" <> "Chart Type"::" ") AND IsMeasure THEN BEGIN
                                                                  AnalysisReportChartSetup.GET("User ID","Analysis Area",Name);
                                                                  AnalysisReportChartSetup.SetLinkToMeasureLines(AnalysisReportChartLine);
                                                                  AnalysisReportChartLine.SETFILTER("Chart Type",'<>%1',AnalysisReportChartLine."Chart Type"::" ");
                                                                  ActualNumMeasures := 0;
                                                                  IF AnalysisReportChartLine.FINDSET THEN
                                                                    REPEAT
                                                                      IF (AnalysisReportChartLine."Analysis Line Line No." <> "Analysis Line Line No.") OR
                                                                         (AnalysisReportChartLine."Analysis Column Line No." <> "Analysis Column Line No.")
                                                                      THEN
                                                                        ActualNumMeasures += 1;
                                                                    UNTIL AnalysisReportChartLine.NEXT = 0;
                                                                  IF ActualNumMeasures >= BusinessChartBuffer.GetMaxNumberOfMeasures THEN
                                                                    BusinessChartBuffer.RaiseErrorMaxNumberOfMeasuresExceeded;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Diagramtype;
                                                              ENU=Chart Type];
                                                   OptionCaptionML=[DAN=" ,Linje,Trinlinje,Kolonne,Stablet s�jlediagram";
                                                                    ENU=" ,Line,StepLine,Column,StackedColumn"];
                                                   OptionString=[ ,Line,StepLine,Column,StackedColumn] }
  }
  KEYS
  {
    {    ;User ID,Analysis Area,Name,Analysis Line Line No.,Analysis Column Line No.;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE IsMeasure@1() Result : Boolean;
    VAR
      AnalysisReportChartSetup@1000 : Record 770;
    BEGIN
      AnalysisReportChartSetup.GET("User ID","Analysis Area",Name);
      CASE AnalysisReportChartSetup."Base X-Axis on" OF
        AnalysisReportChartSetup."Base X-Axis on"::Period:
          Result := TRUE;
        AnalysisReportChartSetup."Base X-Axis on"::Line:
          IF "Analysis Line Line No." = 0 THEN
            Result := TRUE;
        AnalysisReportChartSetup."Base X-Axis on"::Column:
          IF "Analysis Column Line No." = 0 THEN
            Result := TRUE;
      END;
    END;

    [External]
    PROCEDURE GetDefaultChartType@2() : Integer;
    BEGIN
      EXIT("Chart Type"::Column);
    END;

    BEGIN
    END.
  }
}
