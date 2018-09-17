OBJECT Table 5629 Ins. Coverage Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Forsikringspost;
               ENU=Ins. Coverage Ledger Entry];
    LookupPageID=Page5647;
    DrillDownPageID=Page5647;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=Lõbenr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Insurance No.       ;Code20        ;TableRelation=Insurance;
                                                   CaptionML=[DAN=Forsikringsnr.;
                                                              ENU=Insurance No.] }
    { 3   ;   ;Disposed FA         ;Boolean       ;CaptionML=[DAN=Solgt anlëg;
                                                              ENU=Disposed FA] }
    { 4   ;   ;FA No.              ;Code20        ;TableRelation="Fixed Asset";
                                                   CaptionML=[DAN=Anlëgsnr.;
                                                              ENU=FA No.] }
    { 5   ;   ;FA Description      ;Text50        ;CaptionML=[DAN=Anlëgsbeskrivelse;
                                                              ENU=FA Description] }
    { 6   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
    { 7   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 8   ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 9   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 10  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 14  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 16  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 17  ;   ;FA Class Code       ;Code10        ;TableRelation="FA Class";
                                                   CaptionML=[DAN=Anlëgsartskode;
                                                              ENU=FA Class Code] }
    { 18  ;   ;FA Subclass Code    ;Code10        ;TableRelation="FA Subclass";
                                                   CaptionML=[DAN=Anlëgsgruppekode;
                                                              ENU=FA Subclass Code] }
    { 19  ;   ;FA Location Code    ;Code10        ;TableRelation="FA Location";
                                                   CaptionML=[DAN=Anlëgslokationskode;
                                                              ENU=FA Location Code] }
    { 20  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 21  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 22  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 23  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 24  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 25  ;   ;Journal Batch Name  ;Code10        ;CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 26  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 27  ;   ;Index Entry         ;Boolean       ;CaptionML=[DAN=Indekspost;
                                                              ENU=Index Entry] }
    { 28  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Insurance No.,Posting Date              ;SumIndexFields=Amount }
    {    ;Insurance No.,Disposed FA,Posting Date  ;SumIndexFields=Amount }
    {    ;FA No.,Insurance No.,Disposed FA,Posting Date;
                                                   SumIndexFields=Amount }
    {    ;FA No.,Disposed FA,Posting Date          }
    {    ;Document No.,Posting Date                }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Insurance No.,FA No.,FA Description,Posting Date }
  }
  CODE
  {
    VAR
      DimMgt@1000 : Codeunit 408;

    [External]
    PROCEDURE ShowDimensions@1();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    BEGIN
    END.
  }
}

