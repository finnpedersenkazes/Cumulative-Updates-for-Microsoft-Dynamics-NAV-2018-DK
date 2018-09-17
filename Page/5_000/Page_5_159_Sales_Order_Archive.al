OBJECT Page 5159 Sales Order Archive
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Salgsordrearkiv;
               ENU=Sales Order Archive];
    DeleteAllowed=No;
    SourceTable=Table5107;
    SourceTableView=WHERE(Document Type=CONST(Order));
    PageType=Document;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 123     ;1   ;ActionGroup;
                      CaptionML=[DAN=Ver&sion;
                                 ENU=Ver&sion];
                      Image=Versions }
      { 126     ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Sell-to Customer No.);
                      Image=EditLines }
      { 127     ;2   ;Action    ;
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
      { 140     ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5180;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0),
                                  Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                  Version No.=FIELD(Version No.);
                      Image=ViewComments }
      { 137     ;2   ;Action    ;
                      CaptionML=[DAN=Udskriv;
                                 ENU=Print];
                      ToolTipML=[DAN=Udskriv oplysningerne i vinduet. Du f†r vist et anmodningsvindue for udskrivningen, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Print the information in the window. A print request window opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Advanced;
                      Image=Print;
                      OnAction=BEGIN
                                 DocPrint.PrintSalesHeaderArch(Rec);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 130     ;1   ;Action    ;
                      Name=Restore;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Gendan;
                                 ENU=&Restore];
                      ToolTipML=[DAN=Genopret det bogf›rte dokument, den blev arkiveret fra.;
                                 ENU=Recreate the posted document that it was archived from.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Restore;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ArchiveManagement@1000 : Codeunit 5063;
                               BEGIN
                                 ArchiveManagement.RestoreSalesDocument(Rec);
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
                ToolTipML=[DAN=Angiver nummeret p† debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer No." }

    { 132 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen p† debitorens prim‘re adresse.;
                           ENU=Specifies the number of the contact person at the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer Name" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens prim‘re adresse.;
                           ENU=Specifies the main address of the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Address" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del i adressen.;
                           ENU=Specifies an additional part of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Address 2" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens prim‘re adresse.;
                           ENU=Specifies the postal code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Post Code" }

    { 121 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i debitorens prim‘re adresse.;
                           ENU=Specifies the city of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to City" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens prim‘re adresse.;
                           ENU=Specifies the name of the contact person at the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact" }

    { 1060007;2;Field     ;
                ToolTipML=[DAN="Angiver telefonnummeret p† kontaktpersonen hos debitoren. ";
                           ENU="Specifies the telephone number of the contact person at the customer. "];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact Phone No." }

    { 1060005;2;Field     ;
                ToolTipML=[DAN=Angiver faxnummeret p† kontaktpersonen hos debitoren.;
                           ENU=Specifies the fax number of the contact person at the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact Fax No." }

    { 1060003;2;Field     ;
                ToolTipML=[DAN=Angiver mailadressen p† kontaktpersonen hos debitoren.;
                           ENU=Specifies the email address of the contact person at the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact E-Mail" }

    { 1060010;2;Field     ;
                ToolTipML=[DAN=Angiver rollen for kontaktpersonen hos debitoren.;
                           ENU=Specifies the role of the contact person at the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact Role" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ordren blev oprettet.;
                           ENU=Specifies the date when the order was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Date" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kr‘vede leveringsdato for salgsordren.;
                           ENU=Specifies the requested delivery date for the sales order.];
                ApplicationArea=#Advanced;
                SourceExpr="Requested Delivery Date" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du har lovet at levere ordren som resultat af funktionen Beregning af leveringstid.;
                           ENU=Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.];
                ApplicationArea=#Advanced;
                SourceExpr="Promised Delivery Date" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Advanced;
                SourceExpr="External Document No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken s‘lger der er tilknyttet salgsordren.;
                           ENU=Specifies which salesperson is associated with the sales order.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, bilaget er knyttet til.;
                           ENU=Specifies the campaign number the document is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Campaign No." }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bilaget er †bent, venter p† godkendelse, er faktureret til forudbetaling eller er frigivet til n‘ste fase i behandlingen.;
                           ENU=Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.];
                ApplicationArea=#Advanced;
                SourceExpr=Status }

    { 122 ;1   ;Part      ;
                Name=SalesLinesArchive;
                ApplicationArea=#Advanced;
                SubPageLink=Document No.=FIELD(No.),
                            Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                            Version No.=FIELD(Version No.);
                PagePartID=Page5160;
                PartType=Page }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Customer No." }

    { 134 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the number of the contact person at the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact No." }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Name" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den debitor, du har sendt fakturaen til.;
                           ENU=Specifies the address of the customer to whom you sent the invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Address" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende linje i adressen.;
                           ENU=Specifies an additional line of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Address 2" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Post Code" }

    { 120 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to City" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Terms Code" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r den relaterede salgsfaktura skal betales.;
                           ENU=Specifies when the related sales invoice must be paid.];
                ApplicationArea=#Advanced;
                SourceExpr="Due Date" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis betaling gennemf›res f›r eller p† den dato, der er angivet i feltet Kontantrabatdato.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %" }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bel›bet i posten skal v‘re betalt, for at der kan opn†s kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Advanced;
                SourceExpr="Pmt. Discount Date" }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverf›rsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Method Code" }

    { 1060000;2;Field     ;
                ToolTipML=[DAN=Angiver betalingsmetoden Offentlig Information Online UBL (OIOUBL) for bilaget.;
                           ENU=Specifies the Offentlig Information Online UBL (OIOUBL) payment method for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Channel" }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebel›b p† bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Prices Including VAT" }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Code" }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name" }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den adresse, som varerne leveres til.;
                           ENU=Specifies the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address" }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address 2" }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code" }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to City" }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact" }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren p† salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code" }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver en datoformel for den tid, det tager at g›re varerne klar til forsendelse fra denne lokation. Tidselementet anvendes ved beregning af leveringsdatoen p† f›lgende m†de: Afsendelsesdato + Udg†ende lagerekspeditionstid = Planlagt afsendelsesdato + Transporttid = Planlagt leveringsdato.";
                           ENU="Specifies a date formula for the time it takes to get items ready to ship from this location. The time element is used in the calculation of the delivery date as follows: Shipment Date + Outbound Warehouse Handling Time = Planned Shipment Date + Shipping Time = Planned Delivery Date."];
                ApplicationArea=#Warehouse;
                SourceExpr="Outbound Whse. Handling Time" }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code" }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit›r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Agent Code" }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit›ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Agent Service Code" }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid der g†r, fra varerne er sendt fra lageret, til de er leveret.;
                           ENU=Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Time" }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at leverancen af en eller flere linjer er blevet forsinket, eller at afsendelsesdatoen ligger f›r arbejdsdatoen.;
                           ENU=Specifies that the shipment of one or more lines has been delayed, or that the shipment date is before the work date.];
                ApplicationArea=#Advanced;
                SourceExpr="Late Order Shipping" }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver spedit›rens pakkenummer.;
                           ENU=Specifies the shipping agent's package number.];
                ApplicationArea=#Advanced;
                SourceExpr="Package Tracking No." }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Date" }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver afsendelsesadviset, som indeholder oplysninger om, hvorvidt delleverancer er acceptable.;
                           ENU=Specifies the shipping advice, which informs whether partial deliveries are acceptable.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Advice" }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code" }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#Advanced;
                SourceExpr="EU 3-Party Trade" }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget repr‘senterer med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Type" }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportm†den ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method" }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udf›rselssted, hvor varerne blev udf›rt af landet/omr†det med henblik p† rapportering til Intrastat.;
                           ENU=Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Exit Point" }

    { 108 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omr†de med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 1904291901;1;Group  ;
                CaptionML=[DAN=Version;
                           ENU=Version] }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver versionsnummeret p† det arkiverede salgsbilag.;
                           ENU=Specifies the version number of the archived document.];
                ApplicationArea=#Advanced;
                SourceExpr="Version No." }

    { 112 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bruger-id'et for den person, der arkiverede dokumentet.;
                           ENU=Specifies the user ID of the person who archived this document.];
                ApplicationArea=#Advanced;
                SourceExpr="Archived By" }

    { 114 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor dokumentet blev arkiveret.;
                           ENU=Specifies the date when the document was archived.];
                ApplicationArea=#Advanced;
                SourceExpr="Date Archived" }

    { 116 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tidspunkt, hvor bilaget blev arkiveret.;
                           ENU=Specifies what time the document was archived.];
                ApplicationArea=#Advanced;
                SourceExpr="Time Archived" }

    { 125 ;2   ;Field     ;
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

