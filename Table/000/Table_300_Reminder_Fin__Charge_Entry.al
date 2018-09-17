OBJECT Table 300 Reminder/Fin. Charge Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rykker-/rentenotapost;
               ENU=Reminder/Fin. Charge Entry];
    LookupPageID=Page444;
    DrillDownPageID=Page444;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.];
                                                   NotBlank=Yes }
    { 2   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Rykker,Rentenota;
                                                                    ENU=Reminder,Finance Charge Memo];
                                                   OptionString=Reminder,Finance Charge Memo }
    { 3   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(Reminder)) "Issued Reminder Header"
                                                                 ELSE IF (Type=CONST(Finance Charge Memo)) "Issued Fin. Charge Memo Header";
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 4   ;   ;Reminder Level      ;Integer       ;CaptionML=[DAN=Rykkerniveau;
                                                              ENU=Reminder Level] }
    { 5   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 6   ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 7   ;   ;Interest Posted     ;Boolean       ;CaptionML=[DAN=Rente bogf›rt;
                                                              ENU=Interest Posted] }
    { 8   ;   ;Interest Amount     ;Decimal       ;CaptionML=[DAN=Rentebel›b;
                                                              ENU=Interest Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 9   ;   ;Customer Entry No.  ;Integer       ;TableRelation="Cust. Ledger Entry";
                                                   CaptionML=[DAN=Debitorpostl›benr.;
                                                              ENU=Customer Entry No.] }
    { 10  ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 11  ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 12  ;   ;Remaining Amount    ;Decimal       ;CaptionML=[DAN=Restbel›b;
                                                              ENU=Remaining Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 13  ;   ;Customer No.        ;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Debitornr.;
                                                              ENU=Customer No.] }
    { 14  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 15  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Customer No.                             }
    {    ;Customer Entry No.,Type                  }
    {    ;Type,No.                                 }
    {    ;Document No.,Posting Date                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE Navigate@1();
    VAR
      NavigateForm@1000 : Page 344;
    BEGIN
      NavigateForm.SetDoc("Posting Date","No.");
      NavigateForm.RUN;
    END;

    LOCAL PROCEDURE GetCurrencyCode@2() : Code[10];
    VAR
      CustLedgEntry@1000 : Record 21;
    BEGIN
      IF "Customer Entry No." = CustLedgEntry."Entry No." THEN
        EXIT(CustLedgEntry."Currency Code");

      IF CustLedgEntry.GET("Customer Entry No.") THEN
        EXIT(CustLedgEntry."Currency Code");

      EXIT('');
    END;

    BEGIN
    END.
  }
}

