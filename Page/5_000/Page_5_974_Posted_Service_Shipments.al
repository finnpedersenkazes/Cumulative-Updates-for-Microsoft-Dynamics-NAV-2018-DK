OBJECT Page 5974 Posted Service Shipments
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
    CaptionML=[DAN=Bogf›rte serviceleverancer;
               ENU=Posted Service Shipments];
    SourceTable=Table5990;
    PageType=List;
    CardPageID=Posted Service Shipment;
    OnOpenPage=BEGIN
                 SetSecurityFilterOnRespCenter;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Leverance;
                                 ENU=&Shipment];
                      Image=Shipment }
      { 28      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 6032;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=No.=FIELD(No.),
                                  Table Name=CONST(Service Shipment Header),
                                  Type=CONST(General);
                      Image=ViewComments }
      { 1102601001;2 ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Serviceposter;
                                 ENU=Service Ledger E&ntries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogf›ringstransaktioner i servicedokumenter.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents.];
                      ApplicationArea=#Service;
                      RunObject=Page 5912;
                      RunPageLink=Document Type=CONST(Shipment),
                                  Document No.=FIELD(No.);
                      Image=ServiceLedger }
      { 1102601002;2 ;Action    ;
                      CaptionML=[DAN=&Garantiposter;
                                 ENU=&Warranty Ledger Entries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogf›ringstransaktioner i servicedokumenter, der indeholder garantiaftaler.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents that contain warranty agreements.];
                      ApplicationArea=#Service;
                      RunObject=Page 5913;
                      RunPageView=SORTING(Document No.,Posting Date);
                      RunPageLink=Document No.=FIELD(No.);
                      Image=WarrantyLedger }
      { 1102601003;2 ;Action    ;
                      CaptionML=[DAN=&Sagsposter;
                                 ENU=&Job Ledger Entries];
                      ToolTipML=[DAN=Vis alle sagsposter, der stammer fra bogf›ringstransaktioner i servicedokumentet, som omfatter en sag.;
                                 ENU=View all the job ledger entries that result from posting transactions in the service document that involve a job.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 92;
                      RunPageLink=Document No.=FIELD(No.);
                      Image=JobLedger }
      { 1102601006;2 ;Action    ;
                      CaptionML=[DAN=Alloke&ringer;
                                 ENU=&Allocations];
                      ToolTipML=[DAN=Vis allokering af ressourcer, f.eks. teknikere, til serviceartikler i serviceordrer.;
                                 ENU=View allocation of resources, such as technicians, to service items in service orders.];
                      ApplicationArea=#Service;
                      RunObject=Page 6001;
                      RunPageView=SORTING(Status,Document Type,Document No.,Service Item Line No.,Allocation Date,Starting Time,Posted);
                      RunPageLink=Document Type=CONST(Order),
                                  Document No.=FIELD(Order No.);
                      Image=Allocations }
      { 1102601009;2 ;Action    ;
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
      { 1102601012;2 ;Action    ;
                      CaptionML=[DAN=S&ervicemailk›;
                                 ENU=Service Email &Queue];
                      ToolTipML=[DAN=Vis de mails, der venter p† at blive sendt for at underrette debitorer om, at deres serviceartikel er klar.;
                                 ENU=View the emails that are waiting to be sent to notify customers that their service item is ready.];
                      ApplicationArea=#Service;
                      RunObject=Page 5961;
                      RunPageView=SORTING(Document Type,Document No.);
                      RunPageLink=Document Type=CONST(Service Order),
                                  Document No.=FIELD(Order No.);
                      Image=Email }
      { 5       ;2   ;Action    ;
                      Name=CertificateOfSupplyDetails;
                      CaptionML=[DAN=Leveringscertifikatdetaljer;
                                 ENU=Certificate of Supply Details];
                      ToolTipML=[DAN=Vis det leveringscertifikat, der skal sendes til signatur hos din debitor som bekr‘ftelse p† modtagelsen. Du skal udskrive et leveringscertifikat, hvis leverancen benytter en kombination af momsvirksomheds- og momsproduktbogf›ringsgruppe, der er markeret til at kr‘ve et leveringscertifikat i vinduet Ops‘tning af momsbogf›ring.;
                                 ENU=View the certificate of supply that you must send to your customer for signature as confirmation of receipt. You must print a certificate of supply if the shipment uses a combination of VAT business posting group and VAT product posting group that have been marked to require a certificate of supply in the VAT Posting Setup window.];
                      ApplicationArea=#Service;
                      RunObject=Page 780;
                      RunPageLink=Document Type=FILTER(Service Shipment),
                                  Document No.=FIELD(No.);
                      Image=Certificate }
      { 7       ;2   ;Action    ;
                      Name=PrintCertificateofSupply;
                      CaptionML=[DAN=Udskriv leveringscertifikat;
                                 ENU=Print Certificate of Supply];
                      ToolTipML=[DAN=Udskriv det leveringscertifikat, der skal sendes til signatur hos din debitor som bekr‘ftelse p† modtagelsen.;
                                 ENU=Print the certificate of supply that you must send to your customer for signature as confirmation of receipt.];
                      ApplicationArea=#Service;
                      Image=PrintReport;
                      OnAction=VAR
                                 CertificateOfSupply@1000 : Record 780;
                               BEGIN
                                 CertificateOfSupply.SETRANGE("Document Type",CertificateOfSupply."Document Type"::"Service Shipment");
                                 CertificateOfSupply.SETRANGE("Document No.","No.");
                                 CertificateOfSupply.Print;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 21      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(ServShptHeader);
                                 ServShptHeader.PrintRecords(TRUE);
                               END;
                                }
      { 22      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
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
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som ejer varerne p† serviceordren.;
                           ENU=Specifies the number of the customer who owns the items on the service order.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#Service;
                SourceExpr=Name }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Service;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Service;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen i debitorens virksomhed.;
                           ENU=Specifies the name of the contact person at the customer company.];
                ApplicationArea=#Service;
                SourceExpr="Contact Name";
                Visible=FALSE }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Customer No.";
                Visible=FALSE }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Name";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Post Code";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omr†dekoden for debitorens faktureringsadresse.;
                           ENU=Specifies the country/region code of the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Country/Region Code";
                Visible=FALSE }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact";
                Visible=FALSE }

    { 83  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omr†dekoden p† den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor leverancen blev bogf›rt.;
                           ENU=Specifies the date when the shipment was posted.];
                ApplicationArea=#Service;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger, der er knyttet til serviceordren.;
                           ENU=Specifies the code of the salesperson assigned to the service order.];
                ApplicationArea=#Service;
                SourceExpr="Salesperson Code";
                Visible=FALSE }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for de forskellige bel›b p† leverancen.;
                           ENU=Specifies the currency code for various amounts on the shipment.];
                ApplicationArea=#Service;
                SourceExpr="Currency Code" }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationen, eksempelvis lagerstedet eller distributionscenteret, hvorfra varerne p† ordren blev sendt.;
                           ENU=Specifies the location, such as warehouse or distribution center, from where the items on the order were shipped.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=TRUE }

    { 1102601005;2;Field  ;
                ToolTipML=[DAN=Angiver, hvordan debitoren vil modtage notifikationer, n†r servicen er fuldf›rt.;
                           ENU=Specifies in what way the customer wants to receive notifications about the service completed.];
                ApplicationArea=#Service;
                SourceExpr="Notify Customer";
                Visible=FALSE }

    { 1102601011;2;Field  ;
                ToolTipML=[DAN=Angiver typen for den serviceordre, som leverancen blev oprettet fra.;
                           ENU=Specifies the type of the service order from which the shipment was created.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Type";
                Visible=FALSE }

    { 1102601014;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret p† den kontrakt, som er knyttet til serviceordren.;
                           ENU=Specifies the number of the contract associated with the service order.];
                ApplicationArea=#Service;
                SourceExpr="Contract No.";
                Visible=FALSE }

    { 1102601016;2;Field  ;
                ToolTipML=[DAN=Angiver den ansl†ede dato, hvor arbejdet p† serviceordren blev p†begyndt.;
                           ENU=Specifies the approximate date when work on the service order started.];
                ApplicationArea=#Service;
                SourceExpr="Response Date";
                Visible=FALSE }

    { 1102601018;2;Field  ;
                ToolTipML=[DAN=Angiver prioriteten for den bogf›rte serviceordre.;
                           ENU=Specifies the priority of the posted service order.];
                ApplicationArea=#Service;
                SourceExpr=Priority;
                Visible=FALSE }

    { 1102601020;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Service;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 1102601022;2;Field  ;
                ToolTipML=[DAN=Angiver advarselsstatus for svartiden i den oprindelige serviceordre.;
                           ENU=Specifies the warning status for the response time on the original service order.];
                ApplicationArea=#Service;
                SourceExpr="Warning Status";
                Visible=FALSE }

    { 1102601024;2;Field  ;
                ToolTipML=[DAN=Angiver antallet af timer, der er allokeret til varerne i den bogf›rte serviceordre.;
                           ENU=Specifies the number of hours allocated to the items within the posted service order.];
                ApplicationArea=#Service;
                SourceExpr="Allocated Hours";
                Visible=FALSE }

    { 1102601026;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede ordre blev oprettet.;
                           ENU=Specifies the date when the related order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Date";
                Visible=FALSE }

    { 1102601028;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor servicen p† ordren forventes at v‘re f‘rdig.;
                           ENU=Specifies the date when service on the order is expected to be finished.];
                ApplicationArea=#Service;
                SourceExpr="Expected Finishing Date";
                Visible=FALSE }

    { 1102601030;2;Field  ;
                ToolTipML=[DAN=Angiver startdatoen for servicen i leverancen.;
                           ENU=Specifies the starting date of the service on the shipment.];
                ApplicationArea=#Service;
                SourceExpr="Starting Date";
                Visible=FALSE }

    { 1102601032;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor servicen er fuldf›rt.;
                           ENU=Specifies the date when the service is finished.];
                ApplicationArea=#Service;
                SourceExpr="Finishing Date";
                Visible=FALSE }

    { 1102601034;2;Field  ;
                ToolTipML=[DAN=Angiver den samlede tid i timer, som servicen p† serviceordren har varet.;
                           ENU=Specifies the total time in hours that the service on the service order has taken.];
                ApplicationArea=#Service;
                SourceExpr="Service Time (Hours)";
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
      ServShptHeader@1000 : Record 5990;

    BEGIN
    END.
  }
}

