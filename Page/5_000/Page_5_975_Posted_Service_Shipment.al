OBJECT Page 5975 Posted Service Shipment
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogf›rt serviceleverance;
               ENU=Posted Service Shipment];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table5990;
    PageType=Document;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 SetSecurityFilterOnRespCenter;
               END;

    OnFindRecord=BEGIN
                   IF FIND(Which) THEN
                     EXIT(TRUE);
                   SETRANGE("No.");
                   EXIT(FIND(Which));
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
                      CaptionML=[DAN=&Leverance;
                                 ENU=&Shipment];
                      Image=Shipment }
      { 14      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Servicepos&ter;
                                 ENU=Service Ledger E&ntries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogf›ringstransaktioner i servicedokumenter.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents.];
                      ApplicationArea=#Service;
                      RunObject=Page 5912;
                      RunPageLink=Document Type=CONST(Shipment),
                                  Document No.=FIELD(No.);
                      Image=ServiceLedger }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=&Garantiposter;
                                 ENU=&Warranty Ledger Entries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogf›ringstransaktioner i servicedokumenter, der indeholder garantiaftaler.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents that contain warranty agreements.];
                      ApplicationArea=#Service;
                      RunObject=Page 5913;
                      RunPageView=SORTING(Document No.,Posting Date);
                      RunPageLink=Document No.=FIELD(No.);
                      Image=WarrantyLedger }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=&Sagsposter;
                                 ENU=&Job Ledger Entries];
                      ToolTipML=[DAN=Vis alle sagsposter, der stammer fra bogf›ringstransaktioner i servicedokumentet, som omfatter en sag.;
                                 ENU=View all the job ledger entries that result from posting transactions in the service document that involve a job.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 92;
                      RunPageLink=Document No.=FIELD(No.);
                      Image=JobLedger }
      { 149     ;2   ;Action    ;
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
      { 10      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=S&tatistik;
                                 ENU=S&tatistics];
                      ToolTipML=[DAN=Vis oplysninger om det fysiske indhold af leverancen, f.eks. antallet af leverede varer, ressourcetidsforbrug eller omkostninger samt de leverede varers v‘gt og rumfang.;
                                 ENU=View information about the physical contents of the shipment, such as quantity of the shipped items, resource hours or costs, and weight and volume of the shipped items.];
                      ApplicationArea=#Service;
                      RunObject=Page 6032;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 78      ;2   ;Action    ;
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
      { 80      ;2   ;Action    ;
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
      { 151     ;2   ;Action    ;
                      CaptionML=[DAN=Servicedokumentlo&g;
                                 ENU=Service Document Lo&g];
                      ToolTipML=[DAN=F† vist en liste over de ‘ndringer i servicedokumentet, der er registreret. I programmet oprettes der poster i vinduet, f.eks. n†r svartiden eller serviceordrens status er ‘ndret, en ressource er allokeret, en serviceordre er leveret eller faktureret osv. Hver linje i vinduet identificerer den h‘ndelse, der er forekommet i servicedokumentet. Linjen indeholder oplysninger om det felt, der er ‘ndret, dets gamle og nye v‘rdi, datoen og tidspunktet for, hvorn†r ‘ndringen fandt sted, og id'et for den bruger, som foretog ‘ndringerne.;
                                 ENU=View a list of the service document changes that have been logged. The program creates entries in the window when, for example, the response time or service order status changed, a resource was allocated, a service order was shipped or invoiced, and so on. Each line in this window identifies the event that occurred to the service document. The line contains the information about the field that was changed, its old and new value, the date and time when the change took place, and the ID of the user who actually made the changes.];
                      ApplicationArea=#Service;
                      Image=Log;
                      OnAction=VAR
                                 TempServDocLog@1000 : TEMPORARY Record 5912;
                               BEGIN
                                 TempServDocLog.RESET;
                                 TempServDocLog.DELETEALL;
                                 TempServDocLog.CopyServLog(TempServDocLog."Document Type"::Shipment,"No.");
                                 TempServDocLog.CopyServLog(TempServDocLog."Document Type"::Order,"Order No.");

                                 TempServDocLog.RESET;
                                 TempServDocLog.SETCURRENTKEY("Change Date","Change Time");
                                 TempServDocLog.ASCENDING(FALSE);

                                 PAGE.RUN(0,TempServDocLog);
                               END;
                                }
      { 152     ;2   ;Action    ;
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
      { 3       ;2   ;Action    ;
                      Name=CertificateOfSupplyDetails;
                      CaptionML=[DAN=Leveringscertifikatdetaljer;
                                 ENU=Certificate of Supply Details];
                      ToolTipML=[DAN=Vis det leveringscertifikat, der skal sendes til signatur hos din debitor som bekr‘ftelse p† modtagelsen. Du skal udskrive et leveringscertifikat, hvis leverancen benytter en kombination af momsvirksomheds- og momsproduktbogf›ringsgruppe, der er markeret til at kr‘ve et leveringscertifikat i vinduet Ops‘tning af momsbogf›ring.;
                                 ENU=View the certificate of supply that you must send to your customer for signature as confirmation of receipt. You must print a certificate of supply if the shipment uses a combination of VAT business posting group and VAT product posting group that have been marked to require a certificate of supply in the VAT Posting Setup window.];
                      ApplicationArea=#Service;
                      RunObject=Page 780;
                      RunPageLink=Document Type=FILTER(Service Shipment),
                                  Document No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Certificate;
                      PromotedCategory=Process }
      { 5       ;2   ;Action    ;
                      Name=PrintCertificateofSupply;
                      CaptionML=[DAN=Udskriv leveringscertifikat;
                                 ENU=Print Certificate of Supply];
                      ToolTipML=[DAN=Udskriv det leveringscertifikat, der skal sendes til signatur hos din debitor som bekr‘ftelse p† modtagelsen.;
                                 ENU=Print the certificate of supply that you must send to your customer for signature as confirmation of receipt.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=PrintReport;
                      PromotedCategory=Process;
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
      { 49      ;1   ;Action    ;
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
      { 50      ;1   ;Action    ;
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
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No.";
                Importance=Promoted;
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af den ordre, som leverancen blev bogf›rt fra.;
                           ENU=Specifies a description of the order from which the shipment was posted.];
                ApplicationArea=#Service;
                SourceExpr=Description;
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som ejer varerne p† serviceordren.;
                           ENU=Specifies the number of the customer who owns the items on the service order.];
                ApplicationArea=#Service;
                SourceExpr="Customer No.";
                Importance=Promoted;
                Editable=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen p† debitorens adresse.;
                           ENU=Specifies the number of the contact person at the customer's site.];
                ApplicationArea=#Service;
                SourceExpr="Contact No.";
                Editable=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#Service;
                SourceExpr=Name;
                Editable=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† debitoren i den bogf›rte serviceleverance.;
                           ENU=Specifies the address of the customer of the posted service shipment.];
                ApplicationArea=#Service;
                SourceExpr=Address;
                Editable=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Service;
                SourceExpr="Address 2";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Service;
                SourceExpr="Post Code";
                Editable=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen i debitorens virksomhed.;
                           ENU=Specifies the name of the contact person at the customer company.];
                ApplicationArea=#Service;
                SourceExpr="Contact Name";
                Editable=FALSE }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens telefonnummer.;
                           ENU=Specifies the customer phone number.];
                ApplicationArea=#Service;
                SourceExpr="Phone No.";
                Editable=FALSE }

    { 86  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver mailadressen for debitoren.;
                           ENU=Specifies the email address of the customer.];
                ApplicationArea=#Service;
                SourceExpr="E-Mail";
                Editable=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr=City;
                Editable=FALSE }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens alternative telefonnummer.;
                           ENU=Specifies your customer's alternate phone number.];
                ApplicationArea=#Service;
                SourceExpr="Phone No. 2";
                Editable=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan debitoren vil modtage notifikationer, n†r servicen er fuldf›rt.;
                           ENU=Specifies in what way the customer wants to receive notifications about the service completed.];
                ApplicationArea=#Service;
                SourceExpr="Notify Customer";
                Editable=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for den serviceordre, som leverancen blev oprettet fra.;
                           ENU=Specifies the type of the service order from which the shipment was created.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Type";
                Editable=FALSE }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kontrakt, som er knyttet til serviceordren.;
                           ENU=Specifies the number of the contract associated with the service order.];
                ApplicationArea=#Service;
                SourceExpr="Contract No.";
                Editable=FALSE }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ansl†ede dato, hvor arbejdet p† serviceordren blev p†begyndt.;
                           ENU=Specifies the approximate date when work on the service order started.];
                ApplicationArea=#Service;
                SourceExpr="Response Date";
                Editable=FALSE }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det ansl†ede klokkesl‘t, hvor arbejdet p† serviceordren blev p†begyndt.;
                           ENU=Specifies the approximate time when work on the service order started.];
                ApplicationArea=#Service;
                SourceExpr="Response Time";
                Editable=FALSE }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prioriteten for den bogf›rte serviceordre.;
                           ENU=Specifies the priority of the posted service order.];
                ApplicationArea=#Service;
                SourceExpr=Priority;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den serviceordre, som leverancen blev oprettet fra.;
                           ENU=Specifies the number of the service order from which the shipment was created.];
                ApplicationArea=#Service;
                SourceExpr="Order No.";
                Editable=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Editable=FALSE }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Service;
                SourceExpr="No. Printed";
                Editable=FALSE }

    { 46  ;1   ;Part      ;
                Name=ServShipmentItemLines;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page5976 }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Customer No.";
                Importance=Promoted;
                Editable=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Name";
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den debitor, du har sendt fakturaen til.;
                           ENU=Specifies the address of the customer to whom you sent the invoice.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address";
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende linje i adressen.;
                           ENU=Specifies an additional line of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address 2";
                Editable=FALSE }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Post Code";
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to City";
                Editable=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact";
                Editable=FALSE }

    { 105 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en reference til debitoren.;
                           ENU=Specifies a reference to the customer.];
                ApplicationArea=#Service;
                SourceExpr="Your Reference";
                Editable=FALSE }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger, der er knyttet til serviceordren.;
                           ENU=Specifies the code of the salesperson assigned to the service order.];
                ApplicationArea=#Service;
                SourceExpr="Salesperson Code";
                Editable=FALSE }

    { 101 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor leverancen blev bogf›rt.;
                           ENU=Specifies the date when the shipment was posted.];
                ApplicationArea=#Service;
                SourceExpr="Posting Date";
                Importance=Promoted;
                Editable=FALSE }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Service;
                SourceExpr="Document Date";
                Editable=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Editable=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Editable=FALSE }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code";
                Importance=Promoted;
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Name";
                Editable=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den adresse, som varerne leveres til.;
                           ENU=Specifies the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address";
                Editable=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address 2";
                Editable=FALSE }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Post Code";
                Importance=Promoted;
                Editable=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to City";
                Editable=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Contact";
                Editable=FALSE }

    { 112 ;2   ;Field     ;
                CaptionML=[DAN=Leveringstlf./telefon 2;
                           ENU=Ship-to Phone/Phone 2];
                ToolTipML=[DAN=Angiver debitorens telefonnummer.;
                           ENU=Specifies the customer phone number.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Phone";
                Editable=FALSE }

    { 114 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et supplerende telefonnummer p† den adresse, som varerne leveres til.;
                           ENU=Specifies an additional phone number at address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Phone 2";
                Editable=FALSE }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver mailadressen for den adresse, som varerne leveres til.;
                           ENU=Specifies the email address at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to E-Mail";
                Editable=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationen, eksempelvis lagerstedet eller distributionscenteret, hvorfra varerne p† ordren blev sendt.;
                           ENU=Specifies the location, such as warehouse or distribution center, from where the items on the order were shipped.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Promoted;
                Editable=FALSE }

    { 1901902601;1;Group  ;
                CaptionML=[DAN=Detaljer;
                           ENU=Details] }

    { 139 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver advarselsstatus for svartiden i den oprindelige serviceordre.;
                           ENU=Specifies the warning status for the response time on the original service order.];
                ApplicationArea=#Service;
                SourceExpr="Warning Status";
                Importance=Promoted;
                Editable=FALSE }

    { 135 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘rdien i dette felt ved at hente den fra feltet Sammenk‘d service med artikel i servicehovedet.;
                           ENU=Specifies the value in this field from the Link Service to Service Item field on the service header.];
                ApplicationArea=#Service;
                SourceExpr="Link Service to Service Item";
                Editable=FALSE }

    { 132 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af timer, der er allokeret til varerne i den bogf›rte serviceordre.;
                           ENU=Specifies the number of hours allocated to the items within the posted service order.];
                ApplicationArea=#Service;
                SourceExpr="Allocated Hours";
                Editable=FALSE }

    { 129 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den servicezone, der er knyttet til debitoren.;
                           ENU=Specifies the service zone code assigned to the customer.];
                ApplicationArea=#Service;
                SourceExpr="Service Zone Code";
                Editable=FALSE }

    { 141 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede ordre blev oprettet.;
                           ENU=Specifies the date when the related order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Date";
                Importance=Promoted;
                Editable=FALSE }

    { 133 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor serviceordren blev oprettet.;
                           ENU=Specifies the time when the service order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Time";
                Editable=FALSE }

    { 130 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicen p† ordren forventes at v‘re f‘rdig.;
                           ENU=Specifies the date when service on the order is expected to be finished.];
                ApplicationArea=#Service;
                SourceExpr="Expected Finishing Date";
                Editable=FALSE }

    { 127 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for servicen i leverancen.;
                           ENU=Specifies the starting date of the service on the shipment.];
                ApplicationArea=#Service;
                SourceExpr="Starting Date";
                Editable=FALSE }

    { 125 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl‘ttet for servicen i leverancen.;
                           ENU=Specifies the starting time of the service on the shipment.];
                ApplicationArea=#Service;
                SourceExpr="Starting Time";
                Editable=FALSE }

    { 123 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af timer fra oprettelsen af serviceordren til det tidspunkt, hvor ordrens status blev ‘ndret fra Igangsat til I arbejde.;
                           ENU=Specifies the hours since the creation of the service order, to the time when the order status was changed from Pending to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Actual Response Time (Hours)";
                Editable=FALSE }

    { 121 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicen er fuldf›rt.;
                           ENU=Specifies the date when the service is finished.];
                ApplicationArea=#Service;
                SourceExpr="Finishing Date";
                Editable=FALSE }

    { 118 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor servicen er fuldf›rt.;
                           ENU=Specifies the time when the service is finished.];
                ApplicationArea=#Service;
                SourceExpr="Finishing Time";
                Editable=FALSE }

    { 117 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede tid i timer, som servicen p† serviceordren har varet.;
                           ENU=Specifies the total time in hours that the service on the service order has taken.];
                ApplicationArea=#Service;
                SourceExpr="Service Time (Hours)";
                Editable=FALSE }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 145 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for de forskellige bel›b p† leverancen.;
                           ENU=Specifies the currency code for various amounts on the shipment.];
                ApplicationArea=#Service;
                SourceExpr="Currency Code";
                Editable=FALSE }

    { 143 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#Service;
                SourceExpr="EU 3-Party Trade";
                Editable=FALSE }

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

