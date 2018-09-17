OBJECT Page 1206 Credit Transfer Reg. Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Poster i kreditoverf›rselsjournal;
               ENU=Credit Transfer Reg. Entries];
    SourceTable=Table1206;
    PageType=List;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som modtog betaling med kreditoverf›rslen. Hvis typen er Debitor, var kreditoverf›rslen en refusion.;
                           ENU=Specifies the type of account that received payment with the credit transfer. If the type is Debitor, then the credit transfer was a refund.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Type" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor eller debitor, som modtog betaling med kreditoverf›rslen. Hvis feltet Kontotype viser Debitor, var kreditoverf›rslen en refusion.;
                           ENU=Specifies the number of the vendor, or debitor, who received payment with the credit transfer. If the Account Type field contains Debitor, then the credit transfer was a refund.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l›benummeret p† k›bsfakturaen, som blev anvendt til kreditorposten bag denne kreditoverf›rsel.;
                           ENU=Specifies the entry number of the purchase invoice that the vendor ledger entry behind this credit transfer was applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Entry No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r SEPA Kreditoverf›rsel blev udf›rt. V‘rdien kopieres fra feltet Bogf›ringsdato p† betalingslinjen for k›bsfakturaen.;
                           ENU=Specifies when the SEPA credit transfer is made. The value is copied from the Posting Date field on the payment line for the purchase invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transfer Date" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valuta, som SEPA Kreditoverf›rslen blev foretaget i. Betalinger via SEPA Kreditoverf›rsel behandles ved at angive valutaen p† k›bsfakturaen i EURO.;
                           ENU=Specifies the currency that the SEPA credit transfer was made in. To process payments using SEPA Credit Transfer, the currency on the purchase invoice must be EURO.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som betales med SEPA Kreditoverf›rsel.;
                           ENU=Specifies the amount that is paid with the SEPA credit transfer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transfer Amount" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den eksporterede betalingsfil for denne kreditoverf›rselsjournalpost er blevet annulleret.;
                           ENU=Specifies if the exported payment file for this credit transfer register entry has been canceled.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Canceled }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et p† kreditoverf›rslen. Id'et defineres ud fra den v‘rdi i identifikationsfeltet i feltet Kreditoverf›rselsjournal samt v‘rdien i feltet L›benummer, som er adskilt af en skr†streg, f.eks. DABA00113/3.;
                           ENU=Specifies the ID of the credit transfer. The ID is defined from the value in the Identifier field in the Credit Transfer Register field plus the value in the Entry No. field, divided by a slash. For example, DABA00113/3.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction ID" }

    { 14  ;2   ;Field     ;
                CaptionML=[DAN=Modtagers navn;
                           ENU=Recipient Name];
                ToolTipML=[DAN=Angiver modtageren p† den eksporterede kreditoverf›rslen, som normalt er en kreditor.;
                           ENU=Specifies the recipient of the exported credit transfer, typically a vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CreditorName }

    { 10  ;2   ;Field     ;
                Name=RecipientIBAN;
                CaptionML=[DAN=Modtagers IBAN;
                           ENU=Recipient IBAN];
                ToolTipML=[DAN=Angiver IBAN-nummeret p† den kreditorbankkonto, som blev anvendt p† betalingskladdelinjen, hvorfra denne kreditoverf›rsel blev eksporteret.;
                           ENU=Specifies the IBAN of the creditor bank account that was used on the payment journal line that this credit transfer file was exported from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetRecipientIBANOrBankAccNo(TRUE) }

    { 13  ;2   ;Field     ;
                CaptionML=[DAN=Modtagers bankkontonr.;
                           ENU=Recipient Bank Acc. No.];
                ToolTipML=[DAN=Angiver nummeret p† den kreditorbankkonto, som blev anvendt p† betalingskladdelinjen, hvorfra denne kreditoverf›rsel blev eksporteret.;
                           ENU=Specifies the number of the creditor bank account that was used on the payment journal line that this credit transfer file was exported from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetRecipientIBANOrBankAccNo(FALSE) }

    { 11  ;2   ;Field     ;
                CaptionML=[DAN=Meddelelse til modtager;
                           ENU=Message to Recipient];
                ToolTipML=[DAN=Angiver den tekst, som blev indtastet i feltet Meddelelse til modtager p† betalingskladdelinjen, hvorfra denne kreditoverf›rsel blev eksporteret.;
                           ENU=Specifies the text that was entered in the Message to Recipient field on the payment journal line that this credit transfer file was exported from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Message to Recipient" }

    { 15  ;2   ;Field     ;
                CaptionML=[DAN=Dokumentnr. p† udligningspost;
                           ENU=Applies-to Entry Document No.];
                ToolTipML=[DAN=Angiver l›benummeret p† k›bsfakturaen, som blev anvendt til kreditorposten bag denne kreditoverf›rsel.;
                           ENU=Specifies the entry number of the purchase invoice that the vendor ledger entry behind this credit transfer was applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliesToEntryDocumentNo }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Bogf›ringsdato for udligningspost;
                           ENU=Applies-to Entry Posting Date];
                ToolTipML=[DAN=Angiver, hvorn†r k›bsfakturaen blev bogf›rt, og som anvendes til kreditorposten bag denne kreditoverf›rsel.;
                           ENU=Specifies when the purchase invoice that the vendor ledger entry behind this credit transfer entry applies to was posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliesToEntryPostingDate }

    { 16  ;2   ;Field     ;
                CaptionML=[DAN=Beskrivelse af udligningspost;
                           ENU=Applies-to Entry Description];
                ToolTipML=[DAN=Angiver beskrivelsen p† k›bsfakturaen, som anvendes til kreditorposten bag denne kreditoverf›rsel.;
                           ENU=Specifies the description of the purchase invoice that the vendor ledger entry behind this credit transfer entry applies to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliesToEntryDescription }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Valutakode for udligningspost;
                           ENU=Applies-to Entry Currency Code];
                ToolTipML=[DAN=Angiver valutaen p† k›bsfakturaen, som anvendes til kreditorposten bag denne kreditoverf›rsel.;
                           ENU=Specifies the currency of the purchase invoice that the vendor ledger entry behind this credit transfer entry applies to.];
                ApplicationArea=#Suite;
                SourceExpr=AppliesToEntryCurrencyCode }

    { 19  ;2   ;Field     ;
                CaptionML=[DAN=Bel›b for udligningspost;
                           ENU=Applies-to Entry Amount];
                ToolTipML=[DAN=Angiver betalingsbel›bet p† k›bsfakturaen, som anvendes til kreditorposten bag denne kreditoverf›rsel.;
                           ENU=Specifies the payment amount on the purchase invoice that the vendor ledger entry behind this credit transfer entry applies to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliesToEntryAmount }

    { 20  ;2   ;Field     ;
                CaptionML=[DAN=Restbel›b for udligningspost;
                           ENU=Applies-to Entry Remaining Amount];
                ToolTipML=[DAN=Angiver det bel›b, der mangler at blive betalt, p† k›bsfakturaen, som anvendes til kreditorposten bag denne kreditoverf›rsel.;
                           ENU=Specifies the amount that remains to be paid on the purchase invoice that the vendor ledger entry behind this credit transfer entry applies to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliesToEntryRemainingAmount }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kreditoverf›rselsjournalposten i vinduet Kreditoverf›rselspost, som kreditoverf›rselsposten er knyttet til.;
                           ENU=Specifies the number of the credit-transfer register entry in the Credit Transfer Registers window that the credit transfer entry relates to.];
                ApplicationArea=#Advanced;
                SourceExpr="Credit Transfer Register No.";
                Visible=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

