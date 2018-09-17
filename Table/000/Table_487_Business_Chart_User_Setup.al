OBJECT Table 487 Business Chart User Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opsëtning af virksomhedsdiagrambruger;
               ENU=Business Chart User Setup];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Text132       ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Object Type         ;Option        ;CaptionML=[DAN=Objekttype;
                                                              ENU=Object Type];
                                                   OptionCaptionML=[DAN=" ,Tabel,,Rapport,,Codeunit,XMLport,,Side";
                                                                    ENU=" ,Table,,Report,,Codeunit,XMLport,,Page"];
                                                   OptionString=[ ,Table,,Report,,Codeunit,XMLport,,Page] }
    { 3   ;   ;Object ID           ;Integer       ;TableRelation=IF (Object Type=FILTER(>' ')) AllObj."Object ID" WHERE (Object Type=FIELD(Object Type));
                                                   CaptionML=[DAN=Objekt-id;
                                                              ENU=Object ID] }
    { 4   ;   ;Period Length       ;Option        ;CaptionML=[DAN=Periodelëngde;
                                                              ENU=Period Length];
                                                   OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr,Regnskabsperiode,Ingen;
                                                                    ENU=Day,Week,Month,Quarter,Year,Accounting Period,None];
                                                   OptionString=Day,Week,Month,Quarter,Year,Accounting Period,None }
  }
  KEYS
  {
    {    ;User ID,Object Type,Object ID           ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE InitSetupPage@3(PageID@1001 : Integer);
    BEGIN
      IF GET(USERID,"Object Type"::Page,PageID) THEN
        EXIT;

      "User ID" := USERID;
      "Object Type" := "Object Type"::Page;
      "Object ID" := PageID;
      CASE "Object ID" OF
        PAGE::"Aged Acc. Receivable Chart":
          "Period Length" := "Period Length"::Week;
      END;
      INSERT;
    END;

    [External]
    PROCEDURE InitSetupCU@2(CodeunitID@1000 : Integer);
    BEGIN
      IF GET(USERID,"Object Type"::Codeunit,CodeunitID) THEN
        EXIT;

      "User ID" := USERID;
      "Object Type" := "Object Type"::Codeunit;
      "Object ID" := CodeunitID;
      CASE "Object ID" OF
        CODEUNIT::"Aged Acc. Receivable",CODEUNIT::"Aged Acc. Payable":
          "Period Length" := "Period Length"::Week;
      END;
      INSERT;
    END;

    [External]
    PROCEDURE SaveSetupPage@4(BusChartUserSetup@1000 : Record 487;PageID@1001 : Integer);
    BEGIN
      IF NOT GET(USERID,"Object Type"::Page,PageID) THEN
        InitSetupPage(PageID);
      TRANSFERFIELDS(BusChartUserSetup,FALSE);
      MODIFY;
    END;

    [External]
    PROCEDURE SaveSetupCU@5(BusChartUserSetup@1001 : Record 487;CodeunitID@1000 : Integer);
    BEGIN
      IF NOT GET(USERID,"Object Type"::Codeunit,CodeunitID) THEN
        InitSetupCU(CodeunitID);
      TRANSFERFIELDS(BusChartUserSetup,FALSE);
      MODIFY;
    END;

    BEGIN
    END.
  }
}

