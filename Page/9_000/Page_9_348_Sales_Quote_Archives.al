OBJECT Page 9348 Sales Quote Archives
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
    CaptionML=[DAN=Salgstilbudsarkiver;
               ENU=Sales Quote Archives];
    SourceTable=Table5107;
    SourceTableView=WHERE(Document Type=CONST(Quote));
    PageType=List;
    CardPageID=Sales Quote Archive;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=Ver&sion;
                                 ENU=Ver&sion];
                      Image=Versions }
      { 1102601003;2 ;Action    ;
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
                               END;
                                }
      { 1102601004;2 ;Action    ;
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
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver versionsnummeret p† det arkiverede salgsdokument.;
                           ENU=Specifies the version number of the archived document.];
                ApplicationArea=#Advanced;
                SourceExpr="Version No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor dokumentet blev arkiveret.;
                           ENU=Specifies the date when the document was archived.];
                ApplicationArea=#Advanced;
                SourceExpr="Date Archived" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tidspunkt, hvor dokumentet blev arkiveret.;
                           ENU=Specifies what time the document was archived.];
                ApplicationArea=#Advanced;
                SourceExpr="Time Archived" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bruger-id'et for den person, der arkiverede dokumentet.;
                           ENU=Specifies the user ID of the person who archived this document.];
                ApplicationArea=#Advanced;
                SourceExpr="Archived By" }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at det arkiverede dokument er knyttet til en interaktionslogpost.;
                           ENU=Specifies that the archived document is linked to an interaction log entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Interaction Exist" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer Name" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Advanced;
                SourceExpr="External Document No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens prim‘re adresse.;
                           ENU=Specifies the name of the contact person at the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens prim‘re adresse.;
                           ENU=Specifies the postal code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Post Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om salgstilbud, k›bstilbud eller k›bsordrer fra tidligere versioner af dokumentet.;
                           ENU=Specifies information about sales quotes, purchase quotes, or orders in earlier versions of the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Country/Region Code" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the number of the contact person at the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Post Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omr†dekoden for debitorens faktureringsadresse.;
                           ENU=Specifies the country/region code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Country/Region Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Code" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omr†dekoden p† den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Country/Region Code" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om salgstilbud, k›bstilbud eller k›bsordrer fra tidligere versioner af dokumentet.;
                           ENU=Specifies information about sales quotes, purchase quotes, or orders in earlier versions of the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om salgstilbud, k›bstilbud eller k›bsordrer fra tidligere versioner af dokumentet.;
                           ENU=Specifies information about sales quotes, purchase quotes, or orders in earlier versions of the document.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om salgstilbud, k›bstilbud eller k›bsordrer fra tidligere versioner af dokumentet.;
                           ENU=Specifies information about sales quotes, purchase quotes, or orders in earlier versions of the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om salgstilbud, k›bstilbud eller k›bsordrer fra tidligere versioner af dokumentet.;
                           ENU=Specifies information about sales quotes, purchase quotes, or orders in earlier versions of the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code" }

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 1102601005;2;Field  ;
                ToolTipML=[DAN=Angiver oplysninger om salgstilbud, k›bstilbud eller k›bsordrer fra tidligere versioner af dokumentet.;
                           ENU=Specifies information about sales quotes, purchase quotes, or orders in earlier versions of the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Requested Delivery Date";
                Visible=FALSE }

    { 1102601007;2;Field  ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 1102601009;2;Field  ;
                ToolTipML=[DAN=Angiver oplysninger om salgstilbud, k›bstilbud eller k›bsordrer fra tidligere versioner af dokumentet.;
                           ENU=Specifies information about sales quotes, purchase quotes, or orders in earlier versions of the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Due Date";
                Visible=FALSE }

    { 1102601011;2;Field  ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis betaling gennemf›res f›r eller p† den dato, der er angivet i feltet Kontantrabatdato.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %";
                Visible=FALSE }

    { 1102601013;2;Field  ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code";
                Visible=FALSE }

    { 1102601015;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Date";
                Visible=FALSE }

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

