OBJECT Table 1232 Positive Pay Entry Detail
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Oplysning om Positive Pay-betalingspost;
               ENU=Positive Pay Entry Detail];
  }
  FIELDS
  {
    { 1   ;   ;Bank Account No.    ;Code20        ;TableRelation="Bank Account".No.;
                                                   CaptionML=[DAN=Bankkontonr.;
                                                              ENU=Bank Account No.] }
    { 2   ;   ;Upload Date-Time    ;DateTime      ;TableRelation="Positive Pay Entry"."Upload Date-Time" WHERE (Bank Account No.=FIELD(Bank Account No.));
                                                   CaptionML=[DAN=Uploadet dato/klokkesl‘t;
                                                              ENU=Upload Date-Time] }
    { 3   ;   ;No.                 ;Integer       ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 5   ;   ;Check No.           ;Code20        ;CaptionML=[DAN=Checknr.;
                                                              ENU=Check No.] }
    { 6   ;   ;Currency Code       ;Code10        ;TableRelation=Currency.Code;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 7   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=CHECK,ANNULLERET;
                                                                    ENU=CHECK,VOID];
                                                   OptionString=CHECK,VOID }
    { 8   ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 9   ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 10  ;   ;Payee               ;Text50        ;CaptionML=[DAN=Indbetalt til;
                                                              ENU=Payee] }
    { 11  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 12  ;   ;Update Date         ;Date          ;CaptionML=[DAN=Opdateret den;
                                                              ENU=Update Date] }
  }
  KEYS
  {
    {    ;Bank Account No.,Upload Date-Time,No.   ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE CopyFromPosPayEntryDetail@1(PosPayDetail@1001 : Record 1241;BankAcct@1002 : Code[20]);
    BEGIN
      "Bank Account No." := BankAcct;
      "No." := PosPayDetail."Entry No.";
      "Check No." := PosPayDetail."Check Number";
      "Currency Code" := PosPayDetail."Currency Code";
      IF PosPayDetail."Record Type Code" = 'V' THEN
        "Document Type" := "Document Type"::VOID
      ELSE
        "Document Type" := "Document Type"::CHECK;

      "Document Date" := PosPayDetail."Issue Date";
      Amount := PosPayDetail.Amount;
      Payee := PosPayDetail.Payee;
      "User ID" := USERID;
      "Update Date" := TODAY;
    END;

    BEGIN
    END.
  }
}

