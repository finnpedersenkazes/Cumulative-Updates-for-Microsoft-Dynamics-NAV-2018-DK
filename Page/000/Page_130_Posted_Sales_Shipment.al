OBJECT Page 130 Posted Sales Shipment
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    Permissions=TableData 110=m;
    CaptionML=[DAN=Bogfõrt salgsleverance;
               ENU=Posted Sales Shipment];
    InsertAllowed=No;
    SourceTable=Table110;
    PageType=Document;
    OnOpenPage=BEGIN
                 SetSecurityFilterOnRespCenter;
               END;

    OnModifyRecord=BEGIN
                     CODEUNIT.RUN(CODEUNIT::"Shipment Header - Edit",Rec);
                     EXIT(FALSE);
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=L&everance;
                                 ENU=&Shipment];
                      Image=Shipment }
      { 10      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 396;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 78      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=CONST(Shipment),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 80      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 107     ;2   ;Action    ;
                      AccessByPermission=TableData 456=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Image=Approvals;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.ShowPostedApprovalEntries(RECORDID);
                               END;
                                }
      { 3       ;2   ;Action    ;
                      Name=CertificateOfSupplyDetails;
                      CaptionML=[DAN=Leveringscertifikatdetaljer;
                                 ENU=Certificate of Supply Details];
                      ToolTipML=[DAN=Vis det leveringscertifikat, der skal sendes til signatur hos din debitor som bekrëftelse pÜ modtagelsen. Du skal udskrive et leveringscertifikat, hvis leverancen benytter en kombination af momsvirksomheds- og momsproduktbogfõringsgruppe, der er markeret til at krëve et leveringscertifikat i vinduet Opsëtning af momsbogfõring.;
                                 ENU=View the certificate of supply that you must send to your customer for signature as confirmation of receipt. You must print a certificate of supply if the shipment uses a combination of VAT business posting group and VAT product posting group that have been marked to require a certificate of supply in the VAT Posting Setup window.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 780;
                      RunPageLink=Document Type=FILTER(Sales Shipment),
                                  Document No.=FIELD(No.);
                      Image=Certificate }
      { 5       ;2   ;Action    ;
                      Name=PrintCertificateofSupply;
                      CaptionML=[DAN=Udskriv leveringscertifikat;
                                 ENU=Print Certificate of Supply];
                      ToolTipML=[DAN=Udskriv det leveringscertifikat, der skal sendes til signatur hos din debitor som bekrëftelse pÜ modtagelsen.;
                                 ENU=Print the certificate of supply that you must send to your customer for signature as confirmation of receipt.];
                      ApplicationArea=#Advanced;
                      Promoted=No;
                      Image=PrintReport;
                      OnAction=VAR
                                 CertificateOfSupply@1002 : Record 780;
                               BEGIN
                                 CertificateOfSupply.SETRANGE("Document Type",CertificateOfSupply."Document Type"::"Sales Shipment");
                                 CertificateOfSupply.SETRANGE("Document No.","No.");
                                 CertificateOfSupply.Print;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 74      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 79      ;2   ;Action    ;
                      CaptionML=[DAN=&Pakkesporing;
                                 ENU=&Track Package];
                      ToolTipML=[DAN="èbn speditõrens sporingsside for at spore pakken. ";
                                 ENU="Open the shipping agent's tracking page to track the package. "];
                      ApplicationArea=#Advanced;
                      Image=ItemTracking;
                      OnAction=BEGIN
                                 StartTrackingSite;
                               END;
                                }
      { 49      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Udskriv speditõrmeddelelsen.;
                                 ENU=Print the shipping notice.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(SalesShptHeader);
                                 SalesShptHeader.PrintRecords(TRUE);
                               END;
                                }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=N&aviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Advanced;
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
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ recorden.;
                           ENU=Specifies the number of the record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Importance=Promoted;
                Editable=FALSE }

    { 52  ;2   ;Field     ;
                CaptionML=[DAN=Debitor;
                           ENU=Customer];
                ToolTipML=[DAN=Angiver navnet pÜ debitoren pÜ kundeadressen.;
                           ENU=Specifies the name of customer at the sell-to address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Customer Name";
                Editable=FALSE }

    { 6   ;2   ;Group     ;
                CaptionML=[DAN=Kunde;
                           ENU=Sell-to];
                GroupType=Group }

    { 54  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver debitorens kundeadresse.;
                           ENU=Specifies the customer's sell-to address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Address";
                Importance=Additional;
                Editable=FALSE }

    { 56  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver debitorens udvidede kundeadresse.;
                           ENU=Specifies the customer's extended sell-to address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Address 2";
                Importance=Additional;
                Editable=FALSE }

    { 8   ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret i debitorens kundeadresse.;
                           ENU=Specifies the post code of the customer's sell-to address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Post Code";
                Importance=Additional;
                Editable=FALSE }

    { 58  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to City";
                Importance=Additional;
                Editable=FALSE }

    { 112 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver kontaktnummeret.;
                           ENU=Specifies the contact number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact No.";
                Importance=Additional;
                Editable=FALSE }

    { 60  ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ kundeadressen.;
                           ENU=Specifies the name of the contact at the customer's sell-to address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact";
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Advanced;
                SourceExpr="No. Printed";
                Importance=Additional;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogfõringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Importance=Promoted;
                Editable=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogfõringsdatoen for bilaget.;
                           ENU=Specifies the posting date of the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Importance=Additional;
                Editable=FALSE }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Indeholder den dato, hvor debitoren har õnsket varerne leveret.;
                           ENU=Specifies the date that the customer has asked for the order to be delivered.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Requested Delivery Date";
                Editable=FALSE }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du har lovet at levere ordren som resultat af funktionen Beregning af leveringstid.;
                           ENU=Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.];
                ApplicationArea=#Advanced;
                SourceExpr="Promised Delivery Date";
                Editable=FALSE }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ salgstilbudsdokumentet, hvis salgsprocessen tager udgangspunkt i et tilbud.;
                           ENU=Specifies the number of the sales quote document if a quote was used to start the sales process.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Quote No.";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den salgsordre, hvorfra fakturaen blev bogfõrt.;
                           ENU=Specifies the number of the sales order that this invoice was posted from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order No.";
                Importance=Promoted;
                Editable=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som debitoren anvender i deres eget system til at henvise til dette salgsdokument.;
                           ENU=Specifies the number that the customer uses in their own system to refer to this sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No.";
                Importance=Additional;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den sëlger, der normalt hÜndterer denne debitorkonto.;
                           ENU=Specifies a code for the salesperson who normally handles this customer's account.];
                ApplicationArea=#Suite;
                SourceExpr="Salesperson Code";
                Importance=Additional;
                Editable=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det ansvarscenter, der betjener den pÜgëldende debitor pÜ dette salgsdokument.;
                           ENU=Specifies the code for the responsibility center that serves the customer on this sales document.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional;
                Editable=FALSE }

    { 46  ;1   ;Part      ;
                Name=SalesShipmLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page131 }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping];
                GroupType=Group }

    { 30  ;2   ;Field     ;
                CaptionML=[DAN=Adressekode;
                           ENU=Address Code];
                ToolTipML=[DAN=Angiver koden for debitorens yderligere leveringsadresse.;
                           ENU=Specifies the code for the customer's additional shipment address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Code";
                Importance=Promoted;
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, som varerne er leveret til.;
                           ENU=Specifies the name of the customer that you delivered the items to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Name";
                Editable=FALSE }

    { 34  ;2   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som varerne er leveret til.;
                           ENU=Specifies the address that you delivered the items to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address";
                Editable=FALSE }

    { 36  ;2   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver den udvidede adresse, som varerne er leveret til.;
                           ENU=Specifies the extended address that you delivered the items to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address 2";
                Editable=FALSE }

    { 69  ;2   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret i debitorens leveringsadresse.;
                           ENU=Specifies the post code of the customer's ship-to address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Post Code";
                Importance=Promoted;
                Editable=FALSE }

    { 38  ;2   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to City";
                Editable=FALSE }

    { 40  ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den person, du normalt kontakter pÜ den adresse, som varerne er leveret til.;
                           ENU=Specifies the name of the person you regularly contact at the address that the items were shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Contact";
                Editable=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren pÜ salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Promoted;
                Editable=FALSE }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver en datoformel for den tid, det tager at gõre varerne klar til forsendelse fra denne lokation. Tidselementet anvendes ved beregning af leveringsdatoen pÜ fõlgende mÜde: Afsendelsesdato + UdgÜende lagerekspeditionstid = Planlagt afsendelsesdato + Transporttid = Planlagt leveringsdato.";
                           ENU="Specifies a date formula for the time it takes to get items ready to ship from this location. The time element is used in the calculation of the delivery date as follows: Shipment Date + Outbound Warehouse Handling Time = Planned Shipment Date + Shipping Time = Planned Delivery Date."];
                ApplicationArea=#Warehouse;
                SourceExpr="Outbound Whse. Handling Time";
                Editable=FALSE }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid der gÜr, fra varerne er sendt fra lageret, til de er leveret.;
                           ENU=Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Time";
                Editable=FALSE }

    { 7   ;2   ;Group     ;
                CaptionML=[DAN=Leveringsform;
                           ENU=Shipment Method];
                GroupType=Group }

    { 42  ;3   ;Field     ;
                CaptionML=[DAN=Kode;
                           ENU=Code];
                ToolTipML=[DAN=Angiver leveringsformen for leverancen.;
                           ENU=Specifies the shipment method for the shipment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Method Code";
                Editable=FALSE }

    { 62  ;3   ;Field     ;
                CaptionML=[DAN=Speditõr;
                           ENU=Agent];
                ToolTipML=[DAN=Angiver, hvilken speditõr der bruges til at transportere varerne pÜ salgsbilaget til debitoren.;
                           ENU=Specifies which shipping agent is used to transport the items on the sales document to the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Importance=Additional }

    { 93  ;3   ;Field     ;
                CaptionML=[DAN=Speditõrservice;
                           ENU=Agent Service];
                ToolTipML=[DAN=Angiver, hvilken speditõrservice der bruges til at transportere varerne pÜ salgsbilaget til debitoren.;
                           ENU=Specifies which shipping agent service is used to transport the items on the sales document to the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Service Code";
                Importance=Additional }

    { 72  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver speditõrens pakkenummer.;
                           ENU=Specifies the shipping agent's package number.];
                ApplicationArea=#Suite;
                SourceExpr="Package Tracking No.";
                Importance=Additional }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Date";
                Importance=Promoted;
                Editable=FALSE }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Billing];
                GroupType=Group }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Debitornr.;
                           ENU=Customer No.];
                ToolTipML=[DAN=Angiver debitorens nummer pÜ faktureringsadressen.;
                           ENU=Specifies the number of the customer at the billing address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Customer No.";
                Importance=Additional;
                Editable=FALSE }

    { 20  ;2   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, fakturaen er sendt til.;
                           ENU=Specifies the name of the customer that you sent the invoice to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Name";
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, fakturaen er sendt til.;
                           ENU=Specifies the address that you sent the invoice to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Address";
                Importance=Additional;
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver den udvidede adresse, fakturaen er sendt til.;
                           ENU=Specifies the extended address that you sent the invoice to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Address 2";
                Importance=Additional;
                Editable=FALSE }

    { 67  ;2   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the post code of the customer's bill-to address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Post Code";
                Importance=Additional;
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to City";
                Importance=Additional;
                Editable=FALSE }

    { 114 ;2   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonen pÜ debitorens faktureringsadresse.;
                           ENU=Specifies the number of the contact at the customer's bill-to address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Contact No.";
                Importance=Additional;
                Editable=FALSE }

    { 28  ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den kontaktperson, du normalt har kontakt med hos den debitor, du har sendt fakturaen til.;
                           ENU=Specifies the name of the person you regularly contact at the customer to whom you sent the invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Contact";
                Editable=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Editable=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      SalesShptHeader@1000 : Record 110;

    BEGIN
    END.
  }
}

