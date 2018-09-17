OBJECT Table 5969 Contract Gain/Loss Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 5969=rimd;
    CaptionML=[DAN=Gevinst-/tabspost for kontrakt;
               ENU=Contract Gain/Loss Entry];
    LookupPageID=Page6064;
    DrillDownPageID=Page6064;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Contract No.        ;Code20        ;TableRelation="Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract));
                                                   CaptionML=[DAN=Kontraktnr.;
                                                              ENU=Contract No.] }
    { 3   ;   ;Contract Group Code ;Code10        ;TableRelation="Contract Group";
                                                   CaptionML=[DAN=Kontraktgruppekode;
                                                              ENU=Contract Group Code] }
    { 4   ;   ;Change Date         ;Date          ;CaptionML=[DAN=�ndringsdato;
                                                              ENU=Change Date] }
    { 5   ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=�rsagskode;
                                                              ENU=Reason Code] }
    { 6   ;   ;Type of Change      ;Option        ;CaptionML=[DAN=�ndringstype;
                                                              ENU=Type of Change];
                                                   OptionCaptionML=[DAN=Linje tilf�jet,Linje slettet,Kontrakt underskr.,Kontrakt annulleret,Manuel opdatering,Prisregulering;
                                                                    ENU=Line Added,Line Deleted,Contract Signed,Contract Canceled,Manual Update,Price Update];
                                                   OptionString=Line Added,Line Deleted,Contract Signed,Contract Canceled,Manual Update,Price Update }
    { 8   ;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
    { 9   ;   ;Customer No.        ;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Debitornr.;
                                                              ENU=Customer No.] }
    { 10  ;   ;Ship-to Code        ;Code10        ;TableRelation="Ship-to Address".Code WHERE (Customer No.=FIELD(Customer No.));
                                                   CaptionML=[DAN=Leveringsadressekode;
                                                              ENU=Ship-to Code] }
    { 11  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 12  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Contract No.,Change Date,Reason Code    ;SumIndexFields=Amount }
    {    ;Contract Group Code,Change Date         ;SumIndexFields=Amount }
    {    ;Customer No.,Ship-to Code,Change Date   ;SumIndexFields=Amount }
    {    ;Reason Code,Change Date                 ;SumIndexFields=Amount }
    {    ;Responsibility Center,Change Date       ;SumIndexFields=Amount }
    {    ;Responsibility Center,Type of Change,Reason Code }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ContractGainLossEntry@1000 : Record 5969;

    [External]
    PROCEDURE AddEntry@1(ChangeStatus@1000 : Integer;ContractType@1006 : Integer;ContractNo@1001 : Code[20];ChangeAmount@1002 : Decimal;ReasonCode@1003 : Code[10]);
    VAR
      ServContract@1005 : Record 5965;
      NextLine@1004 : Integer;
    BEGIN
      ContractGainLossEntry.RESET;
      ContractGainLossEntry.LOCKTABLE;
      IF ContractGainLossEntry.FINDLAST THEN
        NextLine := ContractGainLossEntry."Entry No." + 1
      ELSE
        NextLine := 1;

      IF ContractNo <> '' THEN
        ServContract.GET(ContractType,ContractNo)
      ELSE
        CLEAR(ServContract);

      ContractGainLossEntry.INIT;
      ContractGainLossEntry."Entry No." := NextLine;
      ContractGainLossEntry."Contract No." := ContractNo;
      ContractGainLossEntry."Contract Group Code" := ServContract."Contract Group Code";
      ContractGainLossEntry."Change Date" := TODAY;
      ContractGainLossEntry."Type of Change" := ChangeStatus;
      ContractGainLossEntry."Responsibility Center" := ServContract."Responsibility Center";
      ContractGainLossEntry."Customer No." := ServContract."Customer No.";
      ContractGainLossEntry."Ship-to Code" := ServContract."Ship-to Code";
      ContractGainLossEntry."User ID" := USERID;
      ContractGainLossEntry.Amount := ChangeAmount;
      ContractGainLossEntry."Reason Code" := ReasonCode;
      ContractGainLossEntry.INSERT;
    END;

    BEGIN
    END.
  }
}

