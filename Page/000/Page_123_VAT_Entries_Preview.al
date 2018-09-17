OBJECT Page 123 VAT Entries Preview
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
    CaptionML=[DAN=Vis momsposter;
               ENU=VAT Entries Preview];
    SourceTable=Table254;
    PageType=List;
    SourceTableTemporary=Yes;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momspostens bogf›ringsdato.;
                           ENU=Specifies the VAT entry's posting date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† momsposten.;
                           ENU=Specifies the document number on the VAT entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dokumenttype, som momsposten tilh›rer.;
                           ENU=Specifies the document type that the VAT entry belongs to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momspostens type.;
                           ENU=Specifies the type of the VAT entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som momsbel›bet (det bel›b, der vises i feltet Bel›b) er beregnet ud fra.;
                           ENU=Specifies the amount that the VAT amount (the amount shown in the Amount field) is calculated from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Base }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for momsposten i regnskabsvalutaen.;
                           ENU=Specifies the amount of the VAT entry in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem det beregnede momsbel›b og et momsbel›b, du har angivet manuelt.;
                           ENU=Specifies the difference between the calculated VAT amount and a VAT amount that you have entered manually.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Difference";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som momsposten er beregnet fra, hvis du bogf›rer i en ekstra rapporteringsvaluta.;
                           ENU=Specifies the amount that the VAT amount is calculated from if you post in an additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Additional-Currency Base";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for momsposten. Bel›bet vises i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the amount of the VAT entry. The amount is in the additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Additional-Currency Amount";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver (i den ekstra rapporteringsvaluta) den momsdifference, der opst†r, n†r du retter et momsbel›b p† et salgs- eller k›bsbilag.;
                           ENU=Specifies, in the additional reporting currency, the VAT difference that arises when you make a correction to a VAT amount on a sales or purchase document.];
                ApplicationArea=#Advanced;
                SourceExpr="Add.-Curr. VAT Difference";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan moms skal beregnes ved k›b eller salg af varer med den aktuelle kombination af momsvirksomheds- og momsproduktbogf›ringsgruppe.;
                           ENU=Specifies how VAT will be calculated for purchases or sales of items with this particular combination of VAT business posting group and VAT product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Calculation Type" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den faktureringsdebitor eller -kreditor, som posten er tilknyttet.;
                           ENU=Specifies the number of the bill-to customer or pay-to vendor that the entry is linked to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to/Pay-to No." }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver CVR-nummeret p† den debitor eller kreditor, som posten er tilknyttet.;
                           ENU=Specifies the VAT registration number of the customer or vendor that the entry is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Registration No.";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressekoden for leveringen til debitoren eller ordren fra kreditoren, som posten er tilknyttet.;
                           ENU=Specifies the address code of the ship-to customer or order-from vendor that the entry is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to/Order Address Code";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#Advanced;
                SourceExpr="EU 3-Party Trade" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om momsposten er blevet lukket af k›rslen Afregn moms.;
                           ENU=Specifies whether the VAT entry has been closed by the Calc. and Post VAT Settlement batch job.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Closed }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den momspost, der har lukket posten, hvis momsposten er blevet lukket ved hj‘lp af k›rslen Afregn moms.;
                           ENU=Specifies the number of the VAT entry that has closed the entry, if the VAT entry was closed with the Calc. and Post VAT Settlement batch job.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Closed by Entry No." }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjens interne referencenummer.;
                           ENU=Specifies the internal reference number for the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Internal Ref. No." }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten har v‘ret en del af en tilbagef›rt transaktion.;
                           ENU=Specifies if the entry has been part of a reverse transaction.];
                ApplicationArea=#Advanced;
                SourceExpr=Reversed;
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den korrigerende post. Hvis feltet angiver et nummer, kan posten ikke tilbagef›res.;
                           ENU=Specifies the number of the correcting entry. If the field Specifies a number, the entry cannot be reversed again.];
                ApplicationArea=#Advanced;
                SourceExpr="Reversed by Entry No.";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den oprindelige post, der blev annulleret ved tilbagef›rselstransaktionen.;
                           ENU=Specifies the number of the original entry that was undone by the reverse transaction.];
                ApplicationArea=#Advanced;
                SourceExpr="Reversed Entry No.";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om denne momspost skal rapporteres som en service i de periodiske momsrapporter.;
                           ENU=Specifies if this VAT entry is to be reported as a service in the periodic VAT reports.];
                ApplicationArea=#Advanced;
                SourceExpr="EU Service";
                Visible=FALSE }

  }
  CODE
  {

    [External]
    PROCEDURE Set@1(VAR TempVATEntry@1000 : TEMPORARY Record 254);
    BEGIN
      IF TempVATEntry.FINDSET THEN
        REPEAT
          Rec := TempVATEntry;
          INSERT;
        UNTIL TempVATEntry.NEXT = 0;
    END;

    BEGIN
    END.
  }
}

