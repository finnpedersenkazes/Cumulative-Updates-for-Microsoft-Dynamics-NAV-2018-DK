OBJECT Table 432 Handled IC Outbox Purch. Hdr
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnDelete=VAR
               HndlICOutboxPurchLine@1002 : Record 433;
               DimMgt@1000 : Codeunit 408;
             BEGIN
               HndlICOutboxPurchLine.SETRANGE("IC Partner Code","IC Partner Code");
               HndlICOutboxPurchLine.SETRANGE("IC Transaction No.","IC Transaction No.");
               HndlICOutboxPurchLine.SETRANGE("Transaction Source","Transaction Source");
               IF HndlICOutboxPurchLine.FINDFIRST THEN
                 HndlICOutboxPurchLine.DELETEALL(TRUE);
               DimMgt.DeleteICDocDim(
                 DATABASE::"Handled IC Outbox Purch. Hdr","IC Transaction No.","IC Partner Code","Transaction Source",0);
             END;

    CaptionML=[DAN=H�ndteret k�bshoved for IC-udbakke;
               ENU=Handled IC Outbox Purch. Hdr];
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Ordre,Faktura,Kreditnotat,,Returvareordre";
                                                                    ENU=" ,Order,Invoice,Credit Memo,,Return Order"];
                                                   OptionString=[ ,Order,Invoice,Credit Memo,,Return Order];
                                                   Editable=No }
    { 2   ;   ;Buy-from Vendor No. ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Leverand�rnr.;
                                                              ENU=Buy-from Vendor No.];
                                                   Editable=No }
    { 3   ;   ;No.                 ;Code20        ;CaptionML=[DAN=Nummer;
                                                              ENU=No.];
                                                   Editable=No }
    { 4   ;   ;Pay-to Vendor No.   ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Faktureringsleverand�rnr.;
                                                              ENU=Pay-to Vendor No.];
                                                   Editable=No }
    { 11  ;   ;Your Reference      ;Text35        ;CaptionML=[DAN=Reference;
                                                              ENU=Your Reference] }
    { 13  ;   ;Ship-to Name        ;Text50        ;CaptionML=[DAN=Leveringsnavn;
                                                              ENU=Ship-to Name];
                                                   Editable=No }
    { 15  ;   ;Ship-to Address     ;Text50        ;CaptionML=[DAN=Leveringsadresse;
                                                              ENU=Ship-to Address];
                                                   Editable=No }
    { 16  ;   ;Ship-to Address 2   ;Text50        ;CaptionML=[DAN=Leveringsadresse 2;
                                                              ENU=Ship-to Address 2];
                                                   Editable=No }
    { 17  ;   ;Ship-to City        ;Text30        ;CaptionML=[DAN=Leveringsby;
                                                              ENU=Ship-to City];
                                                   Editable=No }
    { 20  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date];
                                                   Editable=No }
    { 21  ;   ;Expected Receipt Date;Date         ;CaptionML=[DAN=Forventet modt.dato;
                                                              ENU=Expected Receipt Date];
                                                   Editable=No }
    { 24  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date];
                                                   Editable=No }
    { 25  ;   ;Payment Discount %  ;Decimal       ;CaptionML=[DAN=Kontantrabatpct.;
                                                              ENU=Payment Discount %];
                                                   Editable=No }
    { 26  ;   ;Pmt. Discount Date  ;Date          ;CaptionML=[DAN=Kont.rabatdato;
                                                              ENU=Pmt. Discount Date];
                                                   Editable=No }
    { 32  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code];
                                                   Editable=No }
    { 35  ;   ;Prices Including VAT;Boolean       ;CaptionML=[DAN=Priser inkl. moms;
                                                              ENU=Prices Including VAT] }
    { 68  ;   ;Vendor Invoice No.  ;Code35        ;CaptionML=[DAN=Kreditors fakturanr.;
                                                              ENU=Vendor Invoice No.];
                                                   Editable=No }
    { 69  ;   ;Vendor Cr. Memo No. ;Code35        ;CaptionML=[DAN=Kreditors kr.notanr.;
                                                              ENU=Vendor Cr. Memo No.];
                                                   Editable=No }
    { 72  ;   ;Sell-to Customer No.;Code20        ;CaptionML=[DAN=Kundenr.;
                                                              ENU=Sell-to Customer No.];
                                                   Editable=No }
    { 91  ;   ;Ship-to Post Code   ;Code20        ;CaptionML=[DAN=Leveringspostnr.;
                                                              ENU=Ship-to Post Code];
                                                   Editable=No }
    { 92  ;   ;Ship-to County      ;Text30        ;CaptionML=[DAN=Leveringsamt;
                                                              ENU=Ship-to County] }
    { 93  ;   ;Ship-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode for levering;
                                                              ENU=Ship-to Country/Region Code] }
    { 99  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date];
                                                   Editable=No }
    { 125 ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   CaptionML=[DAN=IC-partner kode;
                                                              ENU=IC Partner Code];
                                                   Editable=No }
    { 201 ;   ;IC Transaction No.  ;Integer       ;CaptionML=[DAN=IC-transaktionsnr.;
                                                              ENU=IC Transaction No.];
                                                   Editable=No }
    { 202 ;   ;Transaction Source  ;Option        ;CaptionML=[DAN=Transaktionskilde;
                                                              ENU=Transaction Source];
                                                   OptionCaptionML=[DAN=Afvist af aktuelt regnskab,Oprettet af aktuelt regnskab;
                                                                    ENU=Rejected by Current Company,Created by Current Company];
                                                   OptionString=Rejected by Current Company,Created by Current Company;
                                                   Editable=No }
    { 5790;   ;Requested Receipt Date;Date        ;CaptionML=[DAN=�nsket modtagelsesdato;
                                                              ENU=Requested Receipt Date];
                                                   Editable=No }
    { 5791;   ;Promised Receipt Date;Date         ;CaptionML=[DAN=Bekr�ftet modtagelsesdato;
                                                              ENU=Promised Receipt Date];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;IC Transaction No.,IC Partner Code,Transaction Source;
                                                   Clustered=Yes }
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

