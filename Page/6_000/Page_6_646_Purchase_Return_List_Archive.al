OBJECT Page 6646 Purchase Return List Archive
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
    CaptionML=[DAN=K›bsreturvarelistearkiv;
               ENU=Purchase Return List Archive];
    SourceTable=Table5109;
    SourceTableView=WHERE(Document Type=CONST(Return Order));
    DataCaptionFields=Document Type;
    PageType=List;
    CardPageID=Purchase Return Order Archive;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 7       ;1   ;ActionGroup;
                      Name=<Action1102601000>;
                      CaptionML=[DAN=Ver&sion;
                                 ENU=Ver&sion];
                      Image=Versions }
      { 5       ;2   ;Action    ;
                      Name=<Action1102601003>;
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
      { 3       ;2   ;Action    ;
                      Name=<Page Sales Archive Comment Sheet>;
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
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Vendor No." }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Order Address Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Vendor Name" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kompensationsaftalens identifikationsnummer. Det kaldes nogle gange kaldes RMA-nummeret (Returns Materials Authorization).;
                           ENU=Specifies the identification number of a compensation agreement. This number is sometimes referred to as the RMA No.(Returns Materials Authorization).];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Vendor Authorization No." }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den kreditor, der leverede varerne.;
                           ENU=Specifies the post code of the vendor who delivered the items.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Post Code";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for den kreditor, der leverede varerne.;
                           ENU=Specifies the city of the vendor who delivered the items.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Country/Region Code";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen hos den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the contact person at the vendor who delivered the items.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Contact";
                Visible=FALSE }

    { 163 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the number of the vendor that you received the invoice from.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Vendor No.";
                Visible=FALSE }

    { 161 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the name of the vendor who you received the invoice from.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Name";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret for den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the post code of the vendor that you received the invoice from.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Post Code";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens lande-/omr†dekode.;
                           ENU=Specifies the country/region code of the address.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Country/Region Code";
                Visible=FALSE }

    { 151 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kontaktperson hos kreditoren, som fakturaen er sendt fra.;
                           ENU=Specifies the name of the person to contact about an invoice from this vendor.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Contact";
                Visible=FALSE }

    { 147 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 145 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omr†dekoden p† den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 135 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 131 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Location Code";
                Visible=TRUE }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indk›ber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Purchaser Code";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Assigned User ID" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Currency Code";
                Visible=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

