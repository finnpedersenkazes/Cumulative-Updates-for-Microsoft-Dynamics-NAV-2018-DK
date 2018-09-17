OBJECT Table 5617 FA Register
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Anl‘gsjournal;
               ENU=FA Register];
    LookupPageID=Page5627;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;From Entry No.      ;Integer       ;TableRelation="FA Ledger Entry";
                                                   CaptionML=[DAN=Fra l›benr.;
                                                              ENU=From Entry No.] }
    { 3   ;   ;To Entry No.        ;Integer       ;TableRelation="FA Ledger Entry";
                                                   CaptionML=[DAN=Til l›benr.;
                                                              ENU=To Entry No.] }
    { 4   ;   ;Creation Date       ;Date          ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Creation Date] }
    { 5   ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 6   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 7   ;   ;Journal Batch Name  ;Code10        ;CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 8   ;   ;Journal Type        ;Option        ;CaptionML=[DAN=Kladdeart;
                                                              ENU=Journal Type];
                                                   OptionCaptionML=[DAN=Finans,Anl‘g;
                                                                    ENU=G/L,Fixed Asset];
                                                   OptionString=G/L,Fixed Asset }
    { 9   ;   ;G/L Register No.    ;Integer       ;TableRelation="G/L Register";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Finansjournalnr.;
                                                              ENU=G/L Register No.];
                                                   BlankZero=Yes }
    { 10  ;   ;From Maintenance Entry No.;Integer ;TableRelation="Maintenance Ledger Entry";
                                                   CaptionML=[DAN=Fra reparationsl›benr.;
                                                              ENU=From Maintenance Entry No.] }
    { 11  ;   ;To Maintenance Entry No.;Integer   ;TableRelation="Maintenance Ledger Entry";
                                                   CaptionML=[DAN=Til reparationsl›benr.;
                                                              ENU=To Maintenance Entry No.] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Creation Date                            }
    {    ;Source Code,Journal Batch Name,Creation Date }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

