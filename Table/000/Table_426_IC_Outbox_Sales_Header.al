OBJECT Table 426 IC Outbox Sales Header
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
               ICOutboxSalesLine@1000 : Record 427;
               DimMgt@1002 : Codeunit 408;
             BEGIN
               ICOutboxSalesLine.SETRANGE("IC Partner Code","IC Partner Code");
               ICOutboxSalesLine.SETRANGE("IC Transaction No.","IC Transaction No.");
               ICOutboxSalesLine.SETRANGE("Transaction Source","Transaction Source");
               IF ICOutboxSalesLine.FINDFIRST THEN
                 ICOutboxSalesLine.DELETEALL(TRUE);
               DimMgt.DeleteICDocDim(
                 DATABASE::"IC Outbox Sales Header","IC Transaction No.","IC Partner Code","Transaction Source",0);
             END;

    CaptionML=[DAN=Salgshoved for IC-udbakke;
               ENU=IC Outbox Sales Header];
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Ordre,Faktura,Kreditnotat,,Returvareordre";
                                                                    ENU=" ,Order,Invoice,Credit Memo,,Return Order"];
                                                   OptionString=[ ,Order,Invoice,Credit Memo,,Return Order];
                                                   Editable=No }
    { 2   ;   ;Sell-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Kundenr.;
                                                              ENU=Sell-to Customer No.];
                                                   Editable=No }
    { 3   ;   ;No.                 ;Code20        ;CaptionML=[DAN=Nummer;
                                                              ENU=No.];
                                                   Editable=No }
    { 4   ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Faktureres til kundenr.;
                                                              ENU=Bill-to Customer No.];
                                                   Editable=No }
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
    { 20  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
    { 24  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
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
    { 44  ;   ;Order No.           ;Code20        ;CaptionML=[DAN=Ordrenr.;
                                                              ENU=Order No.] }
    { 91  ;   ;Ship-to Post Code   ;Code20        ;CaptionML=[DAN=Leveringspostnr.;
                                                              ENU=Ship-to Post Code];
                                                   Editable=No }
    { 92  ;   ;Ship-to County      ;Text30        ;CaptionML=[DAN=Leveringsamt;
                                                              ENU=Ship-to County] }
    { 93  ;   ;Ship-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode for levering;
                                                              ENU=Ship-to Country/Region Code] }
    { 99  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 100 ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
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
    { 5790;   ;Requested Delivery Date;Date       ;AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=ùnsket leveringsdato;
                                                              ENU=Requested Delivery Date];
                                                   Editable=No }
    { 5791;   ;Promised Delivery Date;Date        ;CaptionML=[DAN=Bekrëftet leveringsdato;
                                                              ENU=Promised Delivery Date];
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

