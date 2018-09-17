OBJECT Table 7313 Warehouse Register
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lagerjournal;
               ENU=Warehouse Register];
    LookupPageID=Page7325;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;From Entry No.      ;Integer       ;TableRelation="Warehouse Entry";
                                                   CaptionML=[DAN=Fra l�benr.;
                                                              ENU=From Entry No.] }
    { 3   ;   ;To Entry No.        ;Integer       ;TableRelation="Warehouse Entry";
                                                   CaptionML=[DAN=Til l�benr.;
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
    { 7   ;   ;Journal Batch Name  ;Code10        ;TableRelation="Item Journal Batch".Name;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Source Code                              }
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

