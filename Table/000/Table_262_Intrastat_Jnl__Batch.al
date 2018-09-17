OBJECT Table 262 Intrastat Jnl. Batch
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=Name,Description;
    OnInsert=BEGIN
               LOCKTABLE;
               IntraJnlTemplate.GET("Journal Template Name");
             END;

    OnDelete=BEGIN
               IntrastatJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
               IntrastatJnlLine.SETRANGE("Journal Batch Name",Name);
               IntrastatJnlLine.DELETEALL;
             END;

    OnRename=BEGIN
               IntrastatJnlLine.SETRANGE("Journal Template Name",xRec."Journal Template Name");
               IntrastatJnlLine.SETRANGE("Journal Batch Name",xRec.Name);
               WHILE IntrastatJnlLine.FINDFIRST DO
                 IntrastatJnlLine.RENAME("Journal Template Name",Name,IntrastatJnlLine."Line No.");
             END;

    CaptionML=[DAN=Intrastatkladdenavn;
               ENU=Intrastat Jnl. Batch];
    LookupPageID=Page327;
  }
  FIELDS
  {
    { 1   ;   ;Journal Template Name;Code10       ;TableRelation="Intrastat Jnl. Template";
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Journal Template Name];
                                                   NotBlank=Yes }
    { 2   ;   ;Name                ;Code10        ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 13  ;   ;Reported            ;Boolean       ;CaptionML=[DAN=Rapporteret;
                                                              ENU=Reported] }
    { 14  ;   ;Statistics Period   ;Code10        ;OnValidate=BEGIN
                                                                TESTFIELD(Reported,FALSE);
                                                                IF STRLEN("Statistics Period") <> 4 THEN
                                                                  ERROR(
                                                                    Text000,
                                                                    FIELDCAPTION("Statistics Period"));
                                                                EVALUATE(Month,COPYSTR("Statistics Period",3,2));
                                                                IF (Month < 1) OR (Month > 12) THEN
                                                                  ERROR(Text001);
                                                              END;

                                                   CaptionML=[DAN=Statistikperiode;
                                                              ENU=Statistics Period] }
    { 15  ;   ;Amounts in Add. Currency;Boolean   ;OnValidate=BEGIN
                                                                TESTFIELD(Reported,FALSE);
                                                              END;

                                                   AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Bel›b i ekstra valuta;
                                                              ENU=Amounts in Add. Currency] }
    { 16  ;   ;Currency Identifier ;Code10        ;OnValidate=BEGIN
                                                                TESTFIELD(Reported,FALSE);
                                                              END;

                                                   AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Valuta-id;
                                                              ENU=Currency Identifier] }
  }
  KEYS
  {
    {    ;Journal Template Name,Name              ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 skal v‘re 4 tegn, f.eks. 9410 for oktober 1994.;ENU=%1 must be 4 characters, for example, 9410 for October, 1994.';
      Text001@1001 : TextConst 'DAN=M†nedsnummeret er forkert.;ENU=Please check the month number.';
      IntraJnlTemplate@1002 : Record 261;
      IntrastatJnlLine@1003 : Record 263;
      Month@1004 : Integer;

    PROCEDURE GetStatisticsStartDate@1() : Date;
    VAR
      Century@1000 : Integer;
      Year@1001 : Integer;
      Month@1002 : Integer;
    BEGIN
      TESTFIELD("Statistics Period");
      Century := DATE2DMY(WORKDATE,3) DIV 100;
      EVALUATE(Year,COPYSTR("Statistics Period",1,2));
      Year := Year + Century * 100;
      EVALUATE(Month,COPYSTR("Statistics Period",3,2));
      EXIT(DMY2DATE(1,Month,Year));
    END;

    BEGIN
    END.
  }
}

