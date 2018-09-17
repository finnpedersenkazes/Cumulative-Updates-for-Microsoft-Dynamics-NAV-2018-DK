OBJECT Table 5087 Profile Questionnaire Header
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    DataCaptionFields=Code,Description;
    OnDelete=BEGIN
               ProfileQuestnLine.RESET;
               ProfileQuestnLine.SETRANGE("Profile Questionnaire Code",Code);
               ProfileQuestnLine.DELETEALL(TRUE);
             END;

    CaptionML=[DAN=Sp›rgeskemahoved (profil);
               ENU=Profile Questionnaire Header];
    LookupPageID=Page5109;
    DrillDownPageID=Page5111;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text250       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 3   ;   ;Contact Type        ;Option        ;CaptionML=[DAN=Kontakttype;
                                                              ENU=Contact Type];
                                                   OptionCaptionML=[DAN=" ,Virksomheder,Personer";
                                                                    ENU=" ,Companies,People"];
                                                   OptionString=[ ,Companies,People] }
    { 4   ;   ;Business Relation Code;Code10      ;TableRelation="Business Relation";
                                                   CaptionML=[DAN=Forretningsrelationskode;
                                                              ENU=Business Relation Code] }
    { 5   ;   ;Priority            ;Option        ;InitValue=Normal;
                                                   OnValidate=VAR
                                                                ContProfileAnswer@1000 : Record 5089;
                                                              BEGIN
                                                                ContProfileAnswer.SETCURRENTKEY("Profile Questionnaire Code");
                                                                ContProfileAnswer.SETRANGE("Profile Questionnaire Code",Code);
                                                                ContProfileAnswer.MODIFYALL("Profile Questionnaire Priority",Priority);
                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Prioritet;
                                                              ENU=Priority];
                                                   OptionCaptionML=[DAN=Meget lav,Lav,Normal,H›j,Meget h›j;
                                                                    ENU=Very Low,Low,Normal,High,Very High];
                                                   OptionString=Very Low,Low,Normal,High,Very High }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ProfileQuestnLine@1000 : Record 5088;

    BEGIN
    END.
  }
}

