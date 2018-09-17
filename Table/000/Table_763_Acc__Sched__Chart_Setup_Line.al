OBJECT Table 763 Acc. Sched. Chart Setup Line
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfigurationslinje for kontoskemadiagram;
               ENU=Acc. Sched. Chart Setup Line];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Text132       ;TableRelation="Account Schedules Chart Setup"."User ID" WHERE (Name=FIELD(Name));
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 2   ;   ;Name                ;Text30        ;TableRelation="Account Schedules Chart Setup".Name WHERE (User ID=FIELD(User ID));
                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   Editable=No }
    { 3   ;   ;Account Schedule Name;Code10       ;TableRelation="Acc. Schedule Name".Name;
                                                   CaptionML=[DAN=Kontoskemanavn;
                                                              ENU=Account Schedule Name];
                                                   Editable=No }
    { 4   ;   ;Account Schedule Line No.;Integer  ;TableRelation="Acc. Schedule Line"."Line No." WHERE (Schedule Name=FIELD(Account Schedule Name));
                                                   CaptionML=[DAN=Kontoskemalinjenr.;
                                                              ENU=Account Schedule Line No.];
                                                   Editable=No }
    { 5   ;   ;Column Layout Name  ;Code10        ;TableRelation="Column Layout Name".Name;
                                                   CaptionML=[DAN=Kolonneformatnavn;
                                                              ENU=Column Layout Name];
                                                   Editable=No }
    { 6   ;   ;Column Layout Line No.;Integer     ;TableRelation="Column Layout"."Line No." WHERE (Column Layout Name=FIELD(Column Layout Name));
                                                   CaptionML=[DAN=Kolonneformatlinjenr.;
                                                              ENU=Column Layout Line No.];
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
                                                                AccountSchedulesChartSetup@1001 : Record 762;
                                                                AccSchedChartSetupLine@1000 : Record 763;
                                                                BusinessChartBuffer@1003 : Record 485;
                                                                ActualNumMeasures@1004 : Integer;
                                                              BEGIN
                                                                IF ("Chart Type" <> "Chart Type"::" ") AND IsMeasure THEN BEGIN
                                                                  AccountSchedulesChartSetup.GET("User ID",Name);
                                                                  AccountSchedulesChartSetup.SetLinkToMeasureLines(AccSchedChartSetupLine);
                                                                  AccSchedChartSetupLine.SETFILTER("Chart Type",'<>%1',AccSchedChartSetupLine."Chart Type"::" ");
                                                                  ActualNumMeasures := 0;
                                                                  IF AccSchedChartSetupLine.FINDSET THEN
                                                                    REPEAT
                                                                      IF (AccSchedChartSetupLine."Account Schedule Line No." <> "Account Schedule Line No.") OR
                                                                         (AccSchedChartSetupLine."Column Layout Line No." <> "Column Layout Line No.")
                                                                      THEN
                                                                        ActualNumMeasures += 1;
                                                                    UNTIL AccSchedChartSetupLine.NEXT = 0;
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
    {    ;User ID,Name,Account Schedule Line No.,Column Layout Line No.;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE IsMeasure@1() Result : Boolean;
    VAR
      AccountSchedulesChartSetup@1000 : Record 762;
    BEGIN
      AccountSchedulesChartSetup.GET("User ID",Name);
      CASE AccountSchedulesChartSetup."Base X-Axis on" OF
        AccountSchedulesChartSetup."Base X-Axis on"::Period:
          Result := TRUE;
        AccountSchedulesChartSetup."Base X-Axis on"::"Acc. Sched. Line":
          IF "Account Schedule Line No." = 0 THEN
            Result := TRUE;
        AccountSchedulesChartSetup."Base X-Axis on"::"Acc. Sched. Column":
          IF "Column Layout Line No." = 0 THEN
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

