OBJECT Page 6652 Posted Return Shipments
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
    CaptionML=[DAN=Bogf›rte returvareleverancer;
               ENU=Posted Return Shipments];
    SourceTable=Table6650;
    PageType=List;
    CardPageID=Posted Return Shipment;
    OnOpenPage=BEGIN
                 SetSecurityFilterOnRespCenter;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=R&eturvarelev.;
                                 ENU=&Return Shpt.];
                      Image=Shipment }
      { 29      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#PurchReturnOrder;
                      RunObject=Page 6655;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#PurchReturnOrder;
                      RunObject=Page 66;
                      RunPageLink=Document Type=CONST(Posted Return Shipment),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1102601000;2 ;Action    ;
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
      { 5       ;2   ;Action    ;
                      Name=CertificateOfSupplyDetails;
                      CaptionML=[DAN=Leveringscertifikatdetaljer;
                                 ENU=Certificate of Supply Details];
                      ToolTipML=[DAN=Vis det leveringscertifikat, der skal sendes til signatur hos din debitor som bekr‘ftelse p† modtagelsen. Du skal udskrive et leveringscertifikat, hvis leverancen benytter en kombination af momsvirksomheds- og momsproduktbogf›ringsgruppe, der er markeret til at kr‘ve et leveringscertifikat i vinduet Ops‘tning af momsbogf›ring.;
                                 ENU=View the certificate of supply that you must send to your customer for signature as confirmation of receipt. You must print a certificate of supply if the shipment uses a combination of VAT business posting group and VAT product posting group that have been marked to require a certificate of supply in the VAT Posting Setup window.];
                      ApplicationArea=#PurchReturnOrder;
                      RunObject=Page 780;
                      RunPageLink=Document Type=FILTER(Return Shipment),
                                  Document No.=FIELD(No.);
                      Image=Certificate }
      { 7       ;2   ;Action    ;
                      Name=PrintCertificateofSupply;
                      CaptionML=[DAN=Udskriv leveringscertifikat;
                                 ENU=Print Certificate of Supply];
                      ToolTipML=[DAN=Udskriv det leveringscertifikat, der skal sendes til signatur hos din debitor som bekr‘ftelse p† modtagelsen.;
                                 ENU=Print the certificate of supply that you must send to your customer for signature as confirmation of receipt.];
                      ApplicationArea=#PurchReturnOrder;
                      Image=PrintReport;
                      OnAction=VAR
                                 CertificateOfSupply@1000 : Record 780;
                               BEGIN
                                 CertificateOfSupply.SETRANGE("Document Type",CertificateOfSupply."Document Type"::"Return Shipment");
                                 CertificateOfSupply.SETRANGE("Document No.","No.");
                                 CertificateOfSupply.Print;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 21      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(ReturnShptHeader);
                                 ReturnShptHeader.PrintRecords(TRUE);
                               END;
                                }
      { 22      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
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

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede debitor.;
                           ENU=Specifies the order address of the related customer.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Order Address Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Vendor Name" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den kreditor, der leverede varerne.;
                           ENU=Specifies the post code of the vendor who delivered the items.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Post Code";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for den kreditor, der leverede varerne.;
                           ENU=Specifies the city of the vendor who delivered the items.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Country/Region Code";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen hos den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the contact person at the vendor who delivered the items.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Contact";
                Visible=FALSE }

    { 127 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the number of the vendor that you received the invoice from.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Vendor No.";
                Visible=FALSE }

    { 125 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, du har modtaget fakturaen fra.;
                           ENU=Specifies the name of the customer who you received the invoice from.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Name";
                Visible=FALSE }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret for den debitor, du har modtaget fakturaen fra.;
                           ENU=Specifies the post code of the customer that you received the invoice from.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Post Code";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens lande-/omr†dekode.;
                           ENU=Specifies the country/region code of the address.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Country/Region Code";
                Visible=FALSE }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen hos den debitor, fakturaen er sendt fra.;
                           ENU=Specifies the name of the person to contact about an invoice from this customer.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Contact";
                Visible=FALSE }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 109 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omr†dekoden p† den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indk›ber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Purchaser Code";
                Visible=FALSE }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren p† salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Location Code";
                Visible=TRUE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="No. Printed" }

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 1102601003;2;Field  ;
                ToolTipML=[DAN=Angiver den type bogf›rt bilag, som dette bilag eller denne kladdelinje udlignes med, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Applies-to Doc. Type";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ReturnShptHeader@1000 : Record 6650;

    BEGIN
    END.
  }
}

