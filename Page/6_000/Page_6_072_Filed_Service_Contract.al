OBJECT Page 6072 Filed Service Contract
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
    CaptionML=[DAN=Arkiveret servicekontrakt;
               ENU=Filed Service Contract];
    InsertAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table5970;
    DataCaptionExpr=FORMAT("Contract Type") + ' ' + "Contract No.";
    PageType=Document;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den servicekontrakt eller det servicekontrakttilbud, der er arkiveret.;
                           ENU=Specifies the number of the filed service contract or service contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Contract No.";
                Editable=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies a description of the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 161 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som ejer varerne i den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the number of the customer who owns the items in the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, som vil modtage servicekontraktleverancen.;
                           ENU=Specifies the number of the contact who will receive the service contract delivery.];
                ApplicationArea=#Service;
                SourceExpr="Contact No." }

    { 120 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren i den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the name of the customer in the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr=Name }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen pÜ debitoren i den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the address of the customer in the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr=Address }

    { 163 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Service;
                SourceExpr="Address 2" }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Service;
                SourceExpr="Post Code" }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr=City }

    { 165 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den person, du normalt kontakter, nÜr du handler med debitoren i den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the name of the person you regularly contact when you do business with the customer in the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Contact Name" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens telefonnummer.;
                           ENU=Specifies the customer phone number.];
                ApplicationArea=#Service;
                SourceExpr="Phone No." }

    { 16  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver debitorens mailadresse.;
                           ENU=Specifies the customer's email address.];
                ApplicationArea=#Service;
                SourceExpr="E-Mail" }

    { 167 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontraktgruppekoden for den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the contract group code of the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Contract Group Code" }

    { 169 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den sëlger, der er tildelt den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the code of the salesperson assigned to the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Salesperson Code" }

    { 173 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for den servicekontrakt eller det kontrakttilbud, der er arkiveret.;
                           ENU=Specifies the starting date of the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Starting Date" }

    { 175 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den arkiverede servicekontrakt udlõber.;
                           ENU=Specifies the date when the filed service contract expires.];
                ApplicationArea=#Service;
                SourceExpr="Expiration Date" }

    { 177 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for den servicekontrakt eller det kontrakttilbud, der er arkiveret.;
                           ENU=Specifies the status of the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr=Status }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om servicekontrakten eller servicekontrakttilbuddet var Übent eller lÜst for ëndringer pÜ arkiveringstidspunktet.;
                           ENU=Specifies if the service contract or the service contract quote was open or locked for changes at the moment of filing.];
                ApplicationArea=#Service;
                SourceExpr="Change Status" }

    { 93  ;1   ;Part      ;
                ApplicationArea=#Service;
                SubPageView=SORTING(Entry No.,Line No.);
                SubPageLink=Entry No.=FIELD(Entry No.);
                PagePartID=Page6074;
                Editable=FALSE;
                PartType=Page }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Customer No." }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonen pÜ debitorens faktureringsadresse.;
                           ENU=Specifies the number of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact No." }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Name" }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen pÜ den debitor, som du vil sende fakturaen til.;
                           ENU=Specifies the address of the customer to whom you will send the invoice.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende linje i adressen.;
                           ENU=Specifies an additional line of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address 2" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Post Code" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to City" }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact" }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens referencenummer.;
                           ENU=Specifies the customer's reference number.];
                ApplicationArea=#Service;
                SourceExpr="Your Reference" }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den servicekontraktkontogruppe, som den arkiverede servicekontrakt er tilknyttet.;
                           ENU=Specifies the code of the service contract account group that the filed service contract is associated with.];
                ApplicationArea=#Service;
                SourceExpr="Serv. Contract Acc. Gr. Code" }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Service;
                SourceExpr="Payment Terms Code" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for belõbene i den arkiverede servicekontrakt og det arkiverede kontrakttilbud.;
                           ENU=Specifies the currency code of the amounts in the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Currency Code" }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogsÜ i tilfëlde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Name" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den adresse, som varerne leveres til.;
                           ENU=Specifies the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address 2" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Post Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to City" }

    { 1902138501;1;Group  ;
                CaptionML=[DAN=Service;
                           ENU=Service] }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicezonen for debitorens leveringsadresse.;
                           ENU=Specifies the code of the service zone of the customer's ship-to address.];
                ApplicationArea=#Service;
                SourceExpr="Service Zone Code" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardserviceperioden for serviceartiklerne i den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the default service period for the service items in the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Service Period" }

    { 189 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for den fõrste forventede service pÜ serviceartiklerne i den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the date of the first expected service for the service items in the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="First Service Date" }

    { 191 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardsvartiden for serviceartiklerne i den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the default response time for the service items in the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Response Time (Hours)" }

    { 193 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den serviceordretype, der tildeles de serviceordrer, som er knyttet til den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the service order type assigned to service orders linked to this filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Type" }

    { 1905361901;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details] }

    { 219 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der blev faktureret pr. Ür, fõr servicekontrakten eller kontrakttilbuddet blev arkiveret.;
                           ENU=Specifies the amount that was invoiced annually before the service contract or contract quote was filed.];
                ApplicationArea=#Service;
                SourceExpr="Annual Amount" }

    { 233 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om feltet èrligt belõb pÜ kontrakten eller tilbuddet ëndres automatisk eller manuelt.;
                           ENU=Specifies whether the Annual Amount field on the contract or quote is modified automatically or manually.];
                ApplicationArea=#Service;
                SourceExpr="Allow Unbalanced Amounts" }

    { 21  ;2   ;Field     ;
                Name=Calcd. Annual Amount;
                ToolTipML=[DAN=Angiver summen af vërdierne i feltet Linjebelõb pÜ alle kontraktlinjer, der er tilknyttet den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the sum of the Line Amount field values on all contract lines associated with the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Calcd. Annual Amount" }

    { 223 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver faktureringsperioden for den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the invoice period for the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Invoice Period" }

    { 225 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nëste faktureringsdato for den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the next invoice date for this filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Next Invoice Date" }

    { 227 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der vil blive faktureret for hver faktureringsperiode for den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the amount that will be invoiced for each invoice period for the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Amount per Period" }

    { 221 ;2   ;Field     ;
                CaptionML=[DAN=Nëste faktureringsperiode;
                           ENU=Next Invoice Period];
                ToolTipML=[DAN=Angiver den nëste faktureringsperiode for de arkiverede servicekontraktaftaler mellem debitorerne og din virksomhed.;
                           ENU=Specifies the next invoice period for the filed service contract agreements between your customers and your company.];
                ApplicationArea=#Service;
                SourceExpr=NextInvoicePeriod }

    { 229 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den fakturadato, hvor den arkiverede servicekontrakt sidst blev faktureret.;
                           ENU=Specifies the invoice date when this filed service contract was last invoiced.];
                ApplicationArea=#Service;
                SourceExpr="Last Invoice Date" }

    { 245 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den arkiverede servicekontrakt eller det arkiverede kontrakttilbud er forudbetalt.;
                           ENU=Specifies that this filed service contract or contract quote is prepaid.];
                ApplicationArea=#Service;
                SourceExpr=Prepaid }

    { 287 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der oprettes en kreditnota, nÜr du fjerner en kontraktlinje fra den arkiverede servicekontrakt.;
                           ENU=Specifies that you want a credit memo created when you remove a contract line from the filed service contract.];
                ApplicationArea=#Service;
                SourceExpr="Automatic Credit Memos" }

    { 239 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du kun kan fakturere kontrakten, hvis du har bogfõrt en serviceordre, siden du sidst fakturerede kontrakten.;
                           ENU=Specifies you can only invoice the contract if you have posted a service order since last time you invoiced the contract.];
                ApplicationArea=#Service;
                SourceExpr="Invoice after Service" }

    { 237 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du vil kombinere fakturaer for den arkiverede servicekontrakt med fakturaer for andre servicekontrakter med samme faktureringsdebitor.;
                           ENU=Specifies you want to combine invoices for this filed service contract with invoices for other service contracts with the same bill-to customer.];
                ApplicationArea=#Service;
                SourceExpr="Combine Invoices" }

    { 235 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at kontraktlinjerne for servicekontrakten skal vises som tekst pÜ den faktura, der oprettes, nÜr du fakturerer kontrakten.;
                           ENU=Specifies that you want the contract lines for this service contract to appear as text on the invoice created when you invoice the contract.];
                ApplicationArea=#Service;
                SourceExpr="Contract Lines on Invoice" }

    { 1904390801;1;Group  ;
                CaptionML=[DAN=Prisregulering;
                           ENU=Price Update] }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisopdateringsperioden for den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the price update period for this filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Price Update Period" }

    { 257 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nëste dato, hvor kontraktpriserne skal opdateres.;
                           ENU=Specifies the next date when you want contract prices to be updated.];
                ApplicationArea=#Service;
                SourceExpr="Next Price Update Date" }

    { 259 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den prisopdateringsprocent, du brugte ved den seneste opdatering af kontraktpriserne.;
                           ENU=Specifies the price update percentage you used when you last updated the contract prices.];
                ApplicationArea=#Service;
                SourceExpr="Last Price Update %" }

    { 261 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du sidst opdaterede servicekontraktpriserne.;
                           ENU=Specifies the date when you last updated the service contract prices.];
                ApplicationArea=#Service;
                SourceExpr="Last Price Update Date" }

    { 215 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at prisforhõjelsesteksten udskrives pÜ fakturaer for denne kontrakt, og informerer debitoren om, hvilke priser der er blevet opdateret.;
                           ENU=Specifies that the price increase text is printed on invoices for this contract, informing the customer which prices have been updated.];
                ApplicationArea=#Service;
                SourceExpr="Print Increase Text" }

    { 213 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den standardtekstkode, der skal udskrives pÜ servicefakturaer for den arkiverede servicekontrakt, og informerer debitoren om, hvilke priser der er blevet opdateret.;
                           ENU=Specifies the standard text code to print on service invoices for this filed service contract, informing the customer which prices have been updated.];
                ApplicationArea=#Service;
                SourceExpr="Price Inv. Increase Code" }

    { 1906484701;1;Group  ;
                CaptionML=[DAN=Detaljer;
                           ENU=Detail] }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den annulleringsÜrsagskode, der er angivet i en servicekontrakt eller et kontrakttilbud pÜ arkiveringstidspunktet.;
                           ENU=Specifies the cancel reason code specified in a service contract or a contract quote at the moment of filing.];
                ApplicationArea=#Service;
                SourceExpr="Cancel Reason Code" }

    { 285 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den maksimale enhedspris, der kan angives for en ressource pÜ alle serviceordrelinjer for den arkiverede servicekontrakt eller det arkiverede kontrakttilbud.;
                           ENU=Specifies the maximum unit price that can be set for a resource on all service order lines for to the filed service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Max. Labor Unit Price" }

    { 1904882701;1;Group  ;
                CaptionML=[DAN=Arkivering;
                           ENU=Filed Detail] }

    { 289 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Service;
                SourceExpr="Entry No." }

    { 291 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicekontrakten eller kontrakttilbuddet bliver arkiveret.;
                           ENU=Specifies the date when service contract or contract quote is filed.];
                ApplicationArea=#Service;
                SourceExpr="File Date" }

    { 293 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkeslët, hvor servicekontrakten eller kontrakttilbuddet bliver arkiveret.;
                           ENU=Specifies the time when the service contract or contract quote is filed.];
                ApplicationArea=#Service;
                SourceExpr="File Time" }

    { 297 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Ürsagen til arkiveringen af servicekontrakten eller kontrakttilbuddet.;
                           ENU=Specifies the reason for filing the service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Reason for Filing" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

