OBJECT Table 45 G/L Register
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finansjournal;
               ENU=G/L Register];
    LookupPageID=Page116;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;From Entry No.      ;Integer       ;TableRelation="G/L Entry";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Fra l›benr.;
                                                              ENU=From Entry No.] }
    { 3   ;   ;To Entry No.        ;Integer       ;TableRelation="G/L Entry";
                                                   TestTableRelation=No;
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
    { 8   ;   ;From VAT Entry No.  ;Integer       ;TableRelation="VAT Entry";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Fra momsl›benr.;
                                                              ENU=From VAT Entry No.] }
    { 9   ;   ;To VAT Entry No.    ;Integer       ;TableRelation="VAT Entry";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Til momsl›benr.;
                                                              ENU=To VAT Entry No.] }
    { 10  ;   ;Reversed            ;Boolean       ;CaptionML=[DAN=Tilbagef›rt;
                                                              ENU=Reversed] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Creation Date                            }
    {    ;Source Code,Journal Batch Name,Creation Date }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,From Entry No.,To Entry No.,Creation Date,Source Code }
  }
  CODE
  {

    BEGIN
    END.
  }
}

