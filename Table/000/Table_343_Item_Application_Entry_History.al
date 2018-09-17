OBJECT Table 343 Item Application Entry History
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Historik for vareudligning;
               ENU=Item Application Entry History];
    LookupPageID=Page523;
    DrillDownPageID=Page523;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Item Ledger Entry No.;Integer      ;TableRelation="Item Ledger Entry";
                                                   CaptionML=[DAN=Varepostl›benr.;
                                                              ENU=Item Ledger Entry No.] }
    { 3   ;   ;Inbound Item Entry No.;Integer     ;TableRelation="Item Ledger Entry";
                                                   CaptionML=[DAN=Indg†ende varepostl›benr.;
                                                              ENU=Inbound Item Entry No.] }
    { 4   ;   ;Outbound Item Entry No.;Integer    ;TableRelation="Item Ledger Entry";
                                                   CaptionML=[DAN=Udg†ende varepostl›benr.;
                                                              ENU=Outbound Item Entry No.] }
    { 9   ;   ;Primary Entry No.   ;Integer       ;CaptionML=[DAN=Prim‘rt l›benr.;
                                                              ENU=Primary Entry No.] }
    { 11  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 21  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 23  ;   ;Transferred-from Entry No.;Integer ;TableRelation="Item Ledger Entry";
                                                   CaptionML=[DAN=Overf›rt-fra l›benr.;
                                                              ENU=Transferred-from Entry No.] }
    { 25  ;   ;Creation Date       ;DateTime      ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Creation Date] }
    { 26  ;   ;Created By User     ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Created By User");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Oprettet af bruger;
                                                              ENU=Created By User] }
    { 27  ;   ;Last Modified Date  ;DateTime      ;CaptionML=[DAN=Dato for sidste ‘ndring;
                                                              ENU=Last Modified Date] }
    { 28  ;   ;Last Modified By User;Code50       ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Last Modified By User");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Sidst ‘ndret af bruger;
                                                              ENU=Last Modified By User] }
    { 29  ;   ;Deleted Date        ;DateTime      ;CaptionML=[DAN=Sletningsdato;
                                                              ENU=Deleted Date] }
    { 30  ;   ;Deleted By User     ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Deleted By User");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Slettet af bruger;
                                                              ENU=Deleted By User] }
    { 5800;   ;Cost Application    ;Boolean       ;CaptionML=[DAN=Kostprisudligning;
                                                              ENU=Cost Application] }
    { 5804;   ;Output Completely Invd. Date;Date  ;CaptionML=[DAN=Afgang fuldt faktureret - dato;
                                                              ENU=Output Completely Invd. Date] }
  }
  KEYS
  {
    {    ;Primary Entry No.                       ;Clustered=Yes }
    {    ;Entry No.                                }
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

