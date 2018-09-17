OBJECT Table 5934 Service Register
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Servicejournal;
               ENU=Service Register];
    LookupPageID=Page5931;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;From Entry No.      ;Integer       ;TableRelation="Service Ledger Entry";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Fra l›benr.;
                                                              ENU=From Entry No.] }
    { 3   ;   ;To Entry No.        ;Integer       ;TableRelation="Service Ledger Entry";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Til l›benr.;
                                                              ENU=To Entry No.] }
    { 4   ;   ;From Warranty Entry No.;Integer    ;TableRelation="Warranty Ledger Entry";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Fra garantil›benr.;
                                                              ENU=From Warranty Entry No.] }
    { 5   ;   ;To Warranty Entry No.;Integer      ;TableRelation="Warranty Ledger Entry";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Til garantil›benr.;
                                                              ENU=To Warranty Entry No.] }
    { 6   ;   ;Creation Date       ;Date          ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Creation Date] }
    { 7   ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 8   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
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

