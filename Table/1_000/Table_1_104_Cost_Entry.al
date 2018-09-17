OBJECT Table 1104 Cost Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningspost;
               ENU=Cost Entry];
    LookupPageID=Page1103;
    DrillDownPageID=Page1103;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=Lõbenr.;
                                                              ENU=Entry No.] }
    { 4   ;   ;Cost Type No.       ;Code20        ;TableRelation="Cost Type";
                                                   CaptionML=[DAN=Omkostningstypenr.;
                                                              ENU=Cost Type No.] }
    { 5   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date];
                                                   ClosingDates=Yes }
    { 7   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 8   ;   ;Description         ;Text80        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 16  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   BlankZero=Yes }
    { 17  ;   ;Debit Amount        ;Decimal       ;CaptionML=[DAN=Debetbelõb;
                                                              ENU=Debit Amount];
                                                   BlankZero=Yes }
    { 18  ;   ;Credit Amount       ;Decimal       ;CaptionML=[DAN=Kreditbelõb;
                                                              ENU=Credit Amount];
                                                   BlankZero=Yes }
    { 20  ;   ;Cost Center Code    ;Code20        ;TableRelation="Cost Center";
                                                   CaptionML=[DAN=Omkostningsstedskode;
                                                              ENU=Cost Center Code] }
    { 21  ;   ;Cost Object Code    ;Code20        ;TableRelation="Cost Object";
                                                   CaptionML=[DAN=Omkostningsemnekode;
                                                              ENU=Cost Object Code] }
    { 27  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 28  ;   ;G/L Account         ;Code20        ;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Finanskonto;
                                                              ENU=G/L Account] }
    { 29  ;   ;G/L Entry No.       ;Integer       ;TableRelation="G/L Entry";
                                                   CaptionML=[DAN=Finanslõbenr.;
                                                              ENU=G/L Entry No.];
                                                   Editable=No }
    { 30  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 31  ;   ;System-Created Entry;Boolean       ;CaptionML=[DAN=Automatisk oprettet;
                                                              ENU=System-Created Entry];
                                                   Editable=No }
    { 32  ;   ;Allocated           ;Boolean       ;CaptionML=[DAN=Fordelt;
                                                              ENU=Allocated] }
    { 33  ;   ;Allocated with Journal No.;Integer ;CaptionML=[DAN=Fordelt med kladdenr.;
                                                              ENU=Allocated with Journal No.] }
    { 40  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 41  ;   ;Batch Name          ;Code10        ;TableRelation="Gen. Journal Batch";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Batch Name] }
    { 50  ;   ;Allocation Description;Text80      ;CaptionML=[DAN=Fordelingsbeskrivelse;
                                                              ENU=Allocation Description] }
    { 51  ;   ;Allocation ID       ;Code10        ;TableRelation="Cost Allocation Source";
                                                   CaptionML=[DAN=Fordelings-id;
                                                              ENU=Allocation ID] }
    { 68  ;   ;Additional-Currency Amount;Decimal ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Ekstra valuta (belõb);
                                                              ENU=Additional-Currency Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 69  ;   ;Add.-Currency Debit Amount;Decimal ;CaptionML=[DAN=Debetbelõb i ekstra valuta;
                                                              ENU=Add.-Currency Debit Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 70  ;   ;Add.-Currency Credit Amount;Decimal;CaptionML=[DAN=Kreditbelõb i ekstra valuta;
                                                              ENU=Add.-Currency Credit Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Cost Type No.,Posting Date              ;SumIndexFields=Amount,Debit Amount,Credit Amount,Additional-Currency Amount,Add.-Currency Debit Amount,Add.-Currency Credit Amount }
    {    ;Cost Type No.,Cost Center Code,Cost Object Code,Allocated,Posting Date;
                                                   SumIndexFields=Amount,Debit Amount,Credit Amount,Additional-Currency Amount,Add.-Currency Debit Amount,Add.-Currency Credit Amount }
    {    ;Cost Center Code,Cost Type No.,Allocated,Posting Date;
                                                   SumIndexFields=Amount }
    {    ;Cost Object Code,Cost Type No.,Allocated,Posting Date;
                                                   SumIndexFields=Amount }
    {    ;Allocation ID,Posting Date               }
    {    ;Document No.,Posting Date                }
    {    ;Allocated with Journal No.               }
    {    ;Cost Type No.,Posting Date,Cost Center Code,Cost Object Code;
                                                   SumIndexFields=Amount,Debit Amount,Credit Amount }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Description,Posting Date,Amount }
  }
  CODE
  {

    [External]
    PROCEDURE GetCurrencyCode@1() : Code[10];
    VAR
      GLSetup@1000 : Record 98;
    BEGIN
      GLSetup.GET;
      EXIT(GLSetup."Additional Reporting Currency");
    END;

    BEGIN
    END.
  }
}

