OBJECT Page 5164 Purchase Quote Archive
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
    CaptionML=[DAN=K›bsrekvisitionsarkiv;
               ENU=Purchase Quote Archive];
    DeleteAllowed=No;
    SourceTable=Table5109;
    SourceTableView=WHERE(Document Type=CONST(Quote));
    PageType=Document;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 94      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ver&sion;
                                 ENU=Ver&sion];
                      Image=Versions }
      { 100     ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 26;
                      RunPageLink=No.=FIELD(Buy-from Vendor No.);
                      Image=EditLines }
      { 101     ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 123     ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5179;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0),
                                  Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                  Version No.=FIELD(Version No.);
                      Image=ViewComments }
      { 118     ;2   ;Action    ;
                      CaptionML=[DAN=Udskriv;
                                 ENU=Print];
                      ToolTipML=[DAN=Udskriv oplysningerne i vinduet. Du f†r vist et anmodningsvindue for udskrivningen, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Print the information in the window. A print request window opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Advanced;
                      Image=Print;
                      OnAction=BEGIN
                                 DocPrint.PrintPurchHeaderArch(Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Vendor No." }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen hos den kreditor, der leverede varerne.;
                           ENU=Specifies the number of the contact person at the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Contact No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Vendor Name" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den kreditor, der leverede varerne.;
                           ENU=Specifies the address of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Address" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af adressen p† den leverand›r, der leverede varerne.;
                           ENU=Specifies an additional part of the address of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Address 2" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den kreditor, der leverede varerne.;
                           ENU=Specifies the post code of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Post Code" }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for den kreditor, der leverede varerne.;
                           ENU=Specifies the city of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from City" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen hos den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the contact person at the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Contact" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede ordre blev oprettet.;
                           ENU=Specifies the date when the related order was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Date" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kreditoren skal levere p† leveringsadressen.;
                           ENU=Specifies the date that you want the vendor to deliver to the ship-to address.];
                ApplicationArea=#Advanced;
                SourceExpr="Requested Receipt Date" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens ordrenummer.;
                           ENU=Specifies the vendor's order number.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Order No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens leverancenummer. Det inds‘ttes i det tilsvarende felt p† kildedokumentet ved bogf›ringen.;
                           ENU=Specifies the vendor's shipment number. It is inserted in the corresponding field on the source document during posting.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Shipment No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Address Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indk›ber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchaser Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om recorden er †ben, afventer godkendelse, er faktureret til forudbetaling eller er frigivet til n‘ste fase i behandlingen.;
                           ENU=Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.];
                ApplicationArea=#Advanced;
                SourceExpr=Status }

    { 93  ;1   ;Part      ;
                Name=PurchLinesArchive;
                ApplicationArea=#Advanced;
                SubPageLink=Document No.=FIELD(No.),
                            Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                            Version No.=FIELD(Version No.);
                PagePartID=Page5165;
                PartType=Page }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the number of the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Vendor No." }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† en kontaktperson hos den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the number of the person to contact about an invoice from this vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Contact No." }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the name of the vendor who you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Name" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the address of the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Address" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en yderligere del af adressen p† den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies an additional part of the address of the vendor that the invoice was received from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Address 2" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret for den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the post code of the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Post Code" }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the city of the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to City" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kontaktperson hos kreditoren, som fakturaen er sendt fra.;
                           ENU=Specifies the name of the person to contact about an invoice from this vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Contact" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Terms Code" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r den relaterede k›bsfaktura skal betales.;
                           ENU=Specifies when the related purchase invoice must be paid.];
                ApplicationArea=#Advanced;
                SourceExpr="Due Date" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis betaling gennemf›res f›r eller p† den dato, der er angivet i feltet Kontantrabatdato.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bel›bet i posten skal v‘re betalt, for at der kan opn†s kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Advanced;
                SourceExpr="Pmt. Discount Date" }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverf›rsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Method Code" }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den tilknyttede post repr‘senterer en ubetalt faktura, som der findes et betalingsforslag, en rykker eller en rentenota til.;
                           ENU=Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.];
                ApplicationArea=#Advanced;
                SourceExpr="On Hold" }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebel›b p† bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Prices Including VAT" }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name" }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den adresse, som varerne leveres til.;
                           ENU=Specifies the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address" }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address 2" }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code" }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to City" }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact" }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code" }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code" }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor de fakturerede varer blev forventet modtaget.;
                           ENU=Specifies the date on which the invoiced items were expected.];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Receipt Date" }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code" }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget repr‘senterer med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Type" }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportm†den ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method" }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det indf›rselssted, hvor varerne kom ind i landet/omr†det, for rapportering til Intrastat.;
                           ENU=Specifies the code of the port of entry where the items pass into your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry Point" }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omr†de med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 1904291901;1;Group  ;
                CaptionML=[DAN=Version;
                           ENU=Version] }

    { 105 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver versionsnummeret p† det arkiverede salgsbilag.;
                           ENU=Specifies the version number of the archived document.];
                ApplicationArea=#Advanced;
                SourceExpr="Version No." }

    { 107 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bruger-id'et for den person, der arkiverede dokumentet.;
                           ENU=Specifies the user ID of the person who archived this document.];
                ApplicationArea=#Advanced;
                SourceExpr="Archived By" }

    { 109 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor dokumentet blev arkiveret.;
                           ENU=Specifies the date when the document was archived.];
                ApplicationArea=#Advanced;
                SourceExpr="Date Archived" }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tidspunkt, hvor bilaget blev arkiveret.;
                           ENU=Specifies what time the document was archived.];
                ApplicationArea=#Advanced;
                SourceExpr="Time Archived" }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at det arkiverede dokument er knyttet til en interaktionslogpost.;
                           ENU=Specifies that the archived document is linked to an interaction log entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Interaction Exist" }

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
    VAR
      DocPrint@1000 : Codeunit 229;

    BEGIN
    END.
  }
}

