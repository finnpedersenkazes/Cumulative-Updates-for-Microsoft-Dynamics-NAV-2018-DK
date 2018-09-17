OBJECT Page 5900 Service Order
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Serviceordre;
               ENU=Service Order];
    SourceTable=Table5900;
    SourceTableView=WHERE(Document Type=FILTER(Order));
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport�r,Lagersted;
                                ENU=New,Process,Report,Warehouse];
    OnOpenPage=BEGIN
                 IF UserMgt.GetServiceFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetServiceFilter);
                   FILTERGROUP(0);
                 END;
                 IF ("No." <> '') AND ("Customer No." = '') THEN
                   DocumentIsPosted := (NOT GET("Document Type","No."));
               END;

    OnNewRecord=BEGIN
                  "Document Type" := "Document Type"::Order;
                  "Responsibility Center" := UserMgt.GetServiceFilter;
                  IF "No." = '' THEN
                    SetCustomerFromFilter;
                END;

    OnDeleteRecord=BEGIN
                     CurrPage.SAVERECORD;
                     CLEAR(ServLogMgt);
                     ServLogMgt.ServHeaderManualDelete(Rec);
                     EXIT(ConfirmDeletion);
                   END;

    OnQueryClosePage=BEGIN
                       IF NOT DocumentIsPosted THEN
                         EXIT(ConfirmCloseUnposted);
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 138     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Ordre;
                                 ENU=O&rder];
                      Image=Order }
      { 137     ;2   ;Action    ;
                      CaptionML=[DAN=Behovsoversigt;
                                 ENU=Demand Overview];
                      ToolTipML=[DAN=F� et overblik over behovet for dine varer ved planl�gning af salg, produktion, sager eller servicestyring, og hvorn�r de er tilg�ngelige.;
                                 ENU=Get an overview of demand for your items when planning sales, production, jobs, or service management and when they will be available.];
                      ApplicationArea=#Planning;
                      Image=Forecast;
                      OnAction=VAR
                                 DemandOverview@1000 : Page 5830;
                               BEGIN
                                 DemandOverview.SetCalculationParameter(TRUE);
                                 DemandOverview.Initialize(0D,4,"No.",'','');
                                 DemandOverview.RUNMODAL;
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=<Action7>;
                      AccessByPermission=TableData 99000880=R;
                      CaptionML=[DAN=Beregning af leveringstid;
                                 ENU=Order Promising];
                      ToolTipML=[DAN=Beregn afsendelses- og leveringsdatoerne ud fra varens kendte og forventede tilg�ngelighedsdatoer, og oplys derefter datoerne til debitoren.;
                                 ENU=Calculate the shipment and delivery dates based on the item's known and expected availability dates, and then promise the dates to the customer.];
                      ApplicationArea=#Planning;
                      Image=OrderPromising;
                      OnAction=VAR
                                 OrderPromisingLine@1001 : Record 99000880;
                                 OrderPromisingLines@1000 : Page 99000959;
                               BEGIN
                                 CLEAR(OrderPromisingLines);
                                 OrderPromisingLines.SetSourceType(12); // Service order
                                 CLEAR(OrderPromisingLine);
                                 OrderPromisingLine.SETRANGE("Source Type",OrderPromisingLine."Source Type"::"Service Order");
                                 OrderPromisingLine.SETRANGE("Source ID","No.");
                                 OrderPromisingLines.SETTABLEVIEW(OrderPromisingLine);
                                 OrderPromisingLines.RUNMODAL;
                               END;
                                }
      { 131     ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=D&ebitorkort;
                                 ENU=&Customer Card];
                      ToolTipML=[DAN=F� vist detaljerede oplysninger om debitoren.;
                                 ENU=View detailed information about the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Customer No.);
                      Image=Customer }
      { 206     ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=&Dimensioner;
                                 ENU=&Dimensions];
                      ToolTipML=[DAN=F� vist eller rediger dimensioner som f.eks. omr�de, projekt eller afdeling, som du kan tildele til kladdelinjer for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to journal lines to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Enabled="No." <> '';
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Servicedokument&log;
                                 ENU=Service Document Lo&g];
                      ToolTipML=[DAN=F� vist en liste over de �ndringer i servicedokumentet, der er registreret. I programmet oprettes der poster i vinduet, f.eks. n�r svartiden eller serviceordrens status er �ndret, en ressource er allokeret, en serviceordre er leveret eller faktureret osv. Hver linje i vinduet identificerer den h�ndelse, der er forekommet i servicedokumentet. Linjen indeholder oplysninger om det felt, der er �ndret, dets gamle og nye v�rdi, datoen og tidspunktet for, hvorn�r �ndringen fandt sted, og id'et for den bruger, som foretog �ndringerne.;
                                 ENU=View a list of the service document changes that have been logged. The program creates entries in the window when, for example, the response time or service order status changed, a resource was allocated, a service order was shipped or invoiced, and so on. Each line in this window identifies the event that occurred to the service document. The line contains the information about the field that was changed, its old and new value, the date and time when the change took place, and the ID of the user who actually made the changes.];
                      ApplicationArea=#Service;
                      Image=Log;
                      OnAction=VAR
                                 ServDocLog@1001 : Record 5912;
                               BEGIN
                                 ServDocLog.ShowServDocLog(Rec);
                               END;
                                }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Mail&k�;
                                 ENU=Email &Queue];
                      ToolTipML=[DAN=Vis oversigten over mails, der venter p� at blive sendt automatisk for at underrette debitorer om deres serviceartikel.;
                                 ENU=View the list of emails that are waiting to be sent automatically to notify customers about their service item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5961;
                      RunPageView=SORTING(Document Type,Document No.);
                      RunPageLink=Document Type=CONST(Service Order),
                                  Document No.=FIELD(No.);
                      Image=Email }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=Table Name=CONST(Service Header),
                                  Table Subtype=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Type=CONST(General);
                      Image=ViewComments }
      { 36      ;1   ;ActionGroup;
                      Name=<Action36>;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      Image=Statistics }
      { 102     ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger om recorden, f.eks. v�rdien af bogf�rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SalesSetup@1000 : Record 311;
                                 ServLine@1001 : Record 5902;
                                 ServLines@1003 : Page 5905;
                               BEGIN
                                 SalesSetup.GET;
                                 IF SalesSetup."Calc. Inv. Discount" THEN BEGIN
                                   ServLine.RESET;
                                   ServLine.SETRANGE("Document Type","Document Type");
                                   ServLine.SETRANGE("Document No.","No.");
                                   IF ServLine.FINDFIRST THEN BEGIN
                                     ServLines.SETTABLEVIEW(ServLine);
                                     ServLines.CalcInvDisc(ServLine);
                                     COMMIT
                                   END;
                                 END;
                                 PAGE.RUNMODAL(PAGE::"Service Order Statistics",Rec);
                               END;
                                }
      { 37      ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=L&everancer;
                                 ENU=S&hipments];
                      ToolTipML=[DAN=F� vist relaterede bogf�rte serviceleverancer.;
                                 ENU=View related posted service shipments.];
                      ApplicationArea=#Service;
                      RunObject=Page 5974;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Shipment;
                      PromotedCategory=Process }
      { 60      ;2   ;Action    ;
                      CaptionML=[DAN=Fakturaer;
                                 ENU=Invoices];
                      ToolTipML=[DAN=Vis en liste med igangv�rende salgsfakturaer for ordren.;
                                 ENU=View a list of ongoing sales invoices for the order.];
                      ApplicationArea=#Service;
                      RunObject=Page 5977;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Image=Invoice }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Lagersted;
                                 ENU=W&arehouse];
                      Image=Warehouse }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Lagerleverancelinjer;
                                 ENU=Whse. Shipment Lines];
                      ToolTipML=[DAN=Vis igangv�rende lagerleverancer for bilaget, i avancerede lagerops�tninger.;
                                 ENU=View ongoing warehouse shipments for the document, in advanced warehouse configurations.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7341;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(5902),
                                  Source Subtype=FIELD(Document Type),
                                  Source No.=FIELD(No.);
                      Promoted=Yes;
                      Image=ShipmentLines;
                      PromotedCategory=Category4 }
      { 35      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 155     ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Servi&ceposter;
                                 ENU=Service Ledger E&ntries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogf�ringstransaktioner i servicedokumenter.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents.];
                      ApplicationArea=#Service;
                      RunObject=Page 5912;
                      RunPageView=SORTING(Service Order No.,Service Item No. (Serviced),Entry Type,Moved from Prepaid Acc.,Posting Date,Open,Type);
                      RunPageLink=Service Order No.=FIELD(No.);
                      Image=ServiceLedger }
      { 142     ;2   ;Action    ;
                      CaptionML=[DAN=&Garantiposter;
                                 ENU=&Warranty Ledger Entries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogf�ringstransaktioner i servicedokumenter, der indeholder garantiaftaler.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents that contain warranty agreements.];
                      ApplicationArea=#Service;
                      RunObject=Page 5913;
                      RunPageView=SORTING(Service Order No.,Posting Date,Document No.);
                      RunPageLink=Service Order No.=FIELD(No.);
                      Image=WarrantyLedger }
      { 105     ;2   ;Action    ;
                      CaptionML=[DAN=&Sagsposter;
                                 ENU=&Job Ledger Entries];
                      ToolTipML=[DAN=Vis alle sagsposter, der stammer fra bogf�ringstransaktioner i servicedokumentet, som omfatter en sag.;
                                 ENU=View all the job ledger entries that result from posting transactions in the service document that involve a job.];
                      ApplicationArea=#Service;
                      RunObject=Page 92;
                      RunPageView=SORTING(Service Order No.,Posting Date)
                                  WHERE(Entry Type=CONST(Usage));
                      RunPageLink=Service Order No.=FIELD(No.);
                      Image=JobLedger }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 152     ;2   ;Action    ;
                      Name=Create Customer;
                      CaptionML=[DAN=&Opret debitor;
                                 ENU=&Create Customer];
                      ToolTipML=[DAN=Opret et nyt debitorkort for debitoren i servicedokumentet.;
                                 ENU=Create a new customer card for the customer on the service document.];
                      ApplicationArea=#Service;
                      Image=NewCustomer;
                      OnAction=BEGIN
                                 CLEAR(ServOrderMgt);
                                 ServOrderMgt.CreateNewCustomer(Rec);
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 27      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Lagersted;
                                 ENU=W&arehouse];
                      Image=Warehouse }
      { 12      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=Frigiv til levering;
                                 ENU=Release to Ship];
                      ToolTipML=[DAN=Giv lagermedarbejderne besked om, at serviceartiklen er klar til at blive plukket og leveret til debitorens adresse.;
                                 ENU=Signal to warehouse workers that the service item is ready to be picked and shipped to the customer's address.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=ReleaseShipment;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ReleaseServiceDocument@1000 : Codeunit 416;
                               BEGIN
                                 ReleaseServiceDocument.PerformManualRelease(Rec);
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&�bn igen;
                                 ENU=Reopen];
                      ToolTipML=[DAN=Aktiv�r serviceordren igen, efter at den er blevet frigivet til lagerekspedition.;
                                 ENU=Reactivate the service order after it has been released for warehouse handling.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=ReOpen;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ReleaseServiceDocument@1000 : Codeunit 416;
                               BEGIN
                                 ReleaseServiceDocument.PerformManualReopen(Rec);
                               END;
                                }
      { 14      ;2   ;Action    ;
                      Name=Create Whse Shipment;
                      AccessByPermission=TableData 7320=R;
                      CaptionML=[DAN=Opret lagerleverance;
                                 ENU=Create Whse. Shipment];
                      ToolTipML=[DAN="Forbered plukning og levering af serviceartiklen. ";
                                 ENU="Prepare to pick and ship the service item. "];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=NewShipment;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 GetSourceDocOutbound@1000 : Codeunit 5752;
                               BEGIN
                                 GetSourceDocOutbound.CreateFromServiceOrder(Rec);
                                 IF NOT FIND('=><') THEN
                                   INIT;
                               END;
                                }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf�ring;
                                 ENU=P&osting];
                      Image=Post }
      { 86      ;2   ;Action    ;
                      Name=TestReport;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s� du kan finde og rette eventuelle fejl, f�r du udf�rer den faktiske bogf�ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Service;
                      Image=TestReport;
                      OnAction=VAR
                                 ReportPrint@1001 : Codeunit 228;
                               BEGIN
                                 ReportPrint.PrintServiceHeader(Rec);
                               END;
                                }
      { 87      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Bogf�r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden ved at bogf�re bel�b og antal p� de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ServPostYesNo@1002 : Codeunit 5981;
                                 InstructionMgt@1000 : Codeunit 1330;
                               BEGIN
                                 ServHeader.GET("Document Type","No.");
                                 ServPostYesNo.PostDocument(ServHeader);
                                 DocumentIsPosted := NOT ServHeader.GET("Document Type","No.");
                                 IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
                                   ShowPostedConfirmationMessage;
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 30      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf�ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n�r du bogf�rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Service;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 ServPostYesNo@1000 : Codeunit 5981;
                               BEGIN
                                 ServHeader.GET("Document Type","No.");
                                 ServPostYesNo.PreviewDocument(ServHeader);
                                 DocumentIsPosted := NOT ServHeader.GET("Document Type","No.");
                               END;
                                }
      { 114     ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf�r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden f�rdigg�res og forberedes til udskrivning. V�rdierne og antallene bogf�res p� de relaterede konti. Du f�r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ServPostPrint@1001 : Codeunit 5982;
                               BEGIN
                                 ServHeader.GET("Document Type","No.");
                                 ServPostPrint.PostDocument(ServHeader);
                               END;
                                }
      { 115     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Massebogf�r;
                                 ENU=Post &Batch];
                      ToolTipML=[DAN=Bogf�r flere bilag p� �n gang. Der �bnes et anmodningsvindue, hvor du kan angive, hvilke bilag der skal bogf�res.;
                                 ENU=Post several documents at once. A report request window opens where you can specify which documents to post.];
                      ApplicationArea=#Service;
                      Image=PostBatch;
                      OnAction=BEGIN
                                 CLEAR(ServHeader);
                                 ServHeader.SETRANGE(Status,ServHeader.Status::Finished);
                                 REPORT.RUNMODAL(REPORT::"Batch Post Service Orders",TRUE,TRUE,ServHeader);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 4       ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G�r dig klar til at udskrive bilaget. Der �bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p� udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 DocPrint@1001 : Codeunit 229;
                               BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 DocPrint.PrintServiceHeader(Rec);
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

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No.";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af servicedokumentet, f.eks Ordre 2001.;
                           ENU=Specifies a short description of the service document, such as Order 2001.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, som ejer varerne i servicedokumentet.;
                           ENU=Specifies the number of the customer who owns the items in the service document.];
                ApplicationArea=#Service;
                SourceExpr="Customer No.";
                Importance=Promoted;
                OnValidate=BEGIN
                             CustomerNoOnAfterValidate;
                           END;
                            }

    { 146 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den kontakt, som servicen skal leveres til.;
                           ENU=Specifies the number of the contact to whom you will deliver the service.];
                ApplicationArea=#Service;
                SourceExpr="Contact No.";
                OnValidate=BEGIN
                             IF GETFILTER("Contact No.") = xRec."Contact No." THEN
                               IF "Contact No." <> xRec."Contact No." THEN
                                 SETRANGE("Contact No.");
                           END;
                            }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den debitor, som varerne i bilaget skal leveres til.;
                           ENU=Specifies the name of the customer to whom the items on the document will be shipped.];
                ApplicationArea=#Service;
                SourceExpr=Name }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p� den debitor, som servicen skal leveres til.;
                           ENU=Specifies the address of the customer to whom the service will be shipped.];
                ApplicationArea=#Service;
                SourceExpr=Address }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Service;
                SourceExpr="Address 2";
                Importance=Additional }

    { 120 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Service;
                SourceExpr="Post Code" }

    { 156 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr=City }

    { 126 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kontakt, som vil modtage servicen.;
                           ENU=Specifies the name of the contact who will receive the service.];
                ApplicationArea=#Service;
                SourceExpr="Contact Name" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver telefonnummeret til debitoren i serviceordren.;
                           ENU=Specifies the phone number of the customer in this service order.];
                ApplicationArea=#Service;
                SourceExpr="Phone No." }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens alternative telefonnummer.;
                           ENU=Specifies your customer's alternate phone number.];
                ApplicationArea=#Service;
                SourceExpr="Phone No. 2";
                Importance=Additional }

    { 63  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver mailadressen til debitoren i serviceordren.;
                           ENU=Specifies the email address of the customer in this service order.];
                ApplicationArea=#Service;
                SourceExpr="E-Mail" }

    { 1101100004;2;Field  ;
                ToolTipML=[DAN=Angiver rollen for kontaktpersonen hos debitoren.;
                           ENU=Specifies the role of the contact person at the customer.];
                SourceExpr="Contact Role" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan debitoren �nsker at modtage notifikationer om f�rdigg�relse af servicen.;
                           ENU=Specifies how the customer wants to receive notifications about service completion.];
                ApplicationArea=#Service;
                SourceExpr="Notify Customer";
                Importance=Additional }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for serviceordren.;
                           ENU=Specifies the type of this service order.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Type" }

    { 190 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den kontrakt, som er knyttet til ordren.;
                           ENU=Specifies the number of the contract associated with the order.];
                ApplicationArea=#Service;
                SourceExpr="Contract No." }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ansl�ede dato, hvor arbejdet p� ordren skal p�begyndes, dvs. n�r serviceordrens status �ndres fra Igangsat til I arbejde.;
                           ENU=Specifies the estimated date when work on the order should start, that is, when the service order status changes from Pending, to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Response Date";
                Importance=Promoted }

    { 134 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det ansl�ede klokkesl�t, hvor arbejdet p� ordren begynder, dvs. n�r serviceordrens status �ndres fra Igangsat til I arbejde.;
                           ENU=Specifies the estimated time when work on the order starts, that is, when the service order status changes from Pending, to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Response Time" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prioriteten for serviceordren.;
                           ENU=Specifies the priority of the service order.];
                ApplicationArea=#Service;
                SourceExpr=Priority;
                Importance=Promoted }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serviceordrens status, som afspejler reparations- eller vedligeholdelsesstatus for alle serviceartikler i serviceordren.;
                           ENU=Specifies the service order status, which reflects the repair or maintenance status of all service items on the service order.];
                ApplicationArea=#Service;
                SourceExpr=Status }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional }

    { 217 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Service;
                SourceExpr="Assigned User ID";
                Importance=Additional }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varer i vinduet Servicelinjer er klar til h�ndtering i lageraktiviteter.;
                           ENU=Specifies if items in the Service Lines window are ready to be handled in warehouse activities.];
                ApplicationArea=#Service;
                SourceExpr="Release Status";
                Importance=Promoted }

    { 1101100006;2;Field  ;
                ToolTipML=[DAN=Angiver debitorens reference.;
                           ENU=Specifies the customer's reference.];
                ApplicationArea=#Service;
                SourceExpr="Your Reference" }

    { 46  ;1   ;Part      ;
                Name=ServItemLines;
                ApplicationArea=#Service;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page5902;
                PartType=Page }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Customer No.";
                Importance=Promoted;
                OnValidate=BEGIN
                             BilltoCustomerNoOnAfterValidat;
                           END;
                            }

    { 164 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� kontaktpersonen p� debitorens faktureringsadresse.;
                           ENU=Specifies the number of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact No." }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Name" }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p� den debitor, som du vil sende fakturaen til.;
                           ENU=Specifies the address of the customer to whom you will send the invoice.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address" }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende linje i adressen.;
                           ENU=Specifies an additional line of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address 2";
                Importance=Additional }

    { 107 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Post Code" }

    { 109 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to City" }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� kontaktpersonen p� debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact" }

    { 135 ;2   ;Field     ;
                Name=Your Reference2;
                ToolTipML=[DAN=Angiver debitorens reference.;
                           ENU=Specifies the customer's reference.];
                ApplicationArea=#Service;
                SourceExpr="Your Reference" }

    { 175 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s�lger, der er tilknyttet servicedokumentet.;
                           ENU=Specifies the code of the salesperson assigned to this service document.];
                ApplicationArea=#Service;
                SourceExpr="Salesperson Code" }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den maksimale enhedspris, der kan angives for en ressource (f.eks. en tekniker) p� alle servicelinjer, som er knyttet til ordren.;
                           ENU=Specifies the maximum unit price that can be set for a resource (for example, a technician) on all service lines linked to this order.];
                ApplicationArea=#Service;
                SourceExpr="Max. Labor Unit Price";
                Importance=Additional;
                OnValidate=BEGIN
                             MaxLaborUnitPriceOnAfterValida;
                           END;
                            }

    { 1101100000;2;Field  ;
                ToolTipML=[DAN=Angiver EAN-lokationsnummeret for debitoren.;
                           ENU=Specifies the EAN location number for the customer.];
                ApplicationArea=#Service;
                SourceExpr="EAN No." }

    { 1101100002;2;Field  ;
                ToolTipML=[DAN=Angiver kontokoden for debitoren.;
                           ENU=Specifies the account code of the customer.];
                ApplicationArea=#Service;
                SourceExpr="Account Code" }

    { 1060001;2;Field     ;
                ToolTipML=[DAN=Angiver den profil, som debitoren kr�ver til elektroniske dokumenter.;
                           ENU=Specifies the profile that this customer requires for electronic documents.];
                ApplicationArea=#Service;
                SourceExpr="OIOUBL Profile Code" }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicedokumentet skal bogf�res.;
                           ENU=Specifies the date when the service document should be posted.];
                ApplicationArea=#Service;
                SourceExpr="Posting Date" }

    { 118 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Service;
                SourceExpr="Document Date" }

    { 180 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 195 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel�b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Service;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 196 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r den relaterede faktura skal betales.;
                           ENU=Specifies when the related invoice must be paid.];
                ApplicationArea=#Service;
                SourceExpr="Due Date";
                Importance=Promoted }

    { 197 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontantrabatprocent, der gives, hvis debitoren betaler inden den dato, der er angivet i feltet Kont.rabatdato.;
                           ENU=Specifies the percentage of payment discount given, if the customer pays by the date entered in the Pmt. Discount Date field.];
                ApplicationArea=#Service;
                SourceExpr="Payment Discount %" }

    { 198 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bel�bet i posten skal v�re betalt, for at der kan opn�s kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Service;
                SourceExpr="Pmt. Discount Date" }

    { 200 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverf�rsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Service;
                SourceExpr="Payment Method Code" }

    { 1060000;2;Field     ;
                ToolTipML=[DAN=Angiver betalingsmetoden Offentlig Information Online UBL (OIOUBL) for bilaget.;
                           ENU=Specifies the Offentlig Information Online UBL (OIOUBL) payment method for the document.];
                ApplicationArea=#Service;
                SourceExpr="Payment Channel" }

    { 168 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for de forskellige bel�b p� servicelinjerne.;
                           ENU=Specifies the currency code for various amounts on the service lines.];
                ApplicationArea=#Service;
                SourceExpr="Currency Code";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               CLEAR(ChangeExchangeRate);
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                                 CurrPage.UPDATE;
                               END;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 202 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebel�b p� bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Service;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             PricesIncludingVATOnAfterValid;
                           END;
                            }

    { 205 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf�ringsops�tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Service;
                SourceExpr="VAT Bus. Posting Group" }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs� i tilf�lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code";
                Importance=Promoted;
                OnValidate=BEGIN
                             ShiptoCodeOnAfterValidate;
                           END;
                            }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� debitoren p� den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Name" }

    { 133 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den adresse, som varerne leveres til.;
                           ENU=Specifies the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address" }

    { 141 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address 2";
                Importance=Additional }

    { 147 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p� den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Post Code";
                Importance=Promoted }

    { 149 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to City" }

    { 157 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� kontaktpersonen p� den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Contact";
                Importance=Promoted }

    { 159 ;2   ;Field     ;
                CaptionML=[DAN=Levering/telefon;
                           ENU=Ship-to Phone];
                ToolTipML=[DAN=Angiver telefonnummeret p� den adresse, hvor serviceartiklerne i ordren er placeret.;
                           ENU=Specifies the phone number of the address where the service items in the order are located.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Phone" }

    { 123 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et supplerende telefonnummer p� den adresse, som varerne leveres til.;
                           ENU=Specifies an additional phone number at address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Phone 2";
                Importance=Additional }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver mailadressen for den adresse, som varerne leveres til.;
                           ENU=Specifies the email address at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to E-Mail" }

    { 207 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for lokationen (f.eks. lagersted eller distributionscenter) for de varer, der er angivet p� serviceartikellinjerne.;
                           ENU=Specifies the code of the location (for example, warehouse or distribution center) of the items specified on the service item lines.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 161 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger, om debitoren vil acceptere en delvis leverance af ordren.;
                           ENU=Specifies information about whether the customer will accept a partial shipment of the order.];
                ApplicationArea=#Service;
                SourceExpr="Shipping Advice" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Service;
                SourceExpr="Shipment Method Code" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit�r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Service;
                SourceExpr="Shipping Agent Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit�ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Service;
                SourceExpr="Shipping Agent Service Code" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid der g�r, fra varerne er sendt fra lageret, til de er leveret.;
                           ENU=Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.];
                ApplicationArea=#Service;
                SourceExpr="Shipping Time" }

    { 1901902601;1;Group  ;
                CaptionML=[DAN=Detaljer;
                           ENU=Details] }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver advarselsstatus for svartiden p� ordren.;
                           ENU=Specifies the response time warning status for the order.];
                ApplicationArea=#Service;
                SourceExpr="Warning Status";
                Importance=Promoted }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at servicelinjerne for varer og ressourcer skal knyttes til en serviceartikellinje.;
                           ENU=Specifies that service lines for items and resources must be linked to a service item line.];
                ApplicationArea=#Service;
                SourceExpr="Link Service to Service Item" }

    { 124 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af timer, der er allokeret til varerne i serviceordren.;
                           ENU=Specifies the number of hours allocated to the items in this service order.];
                ApplicationArea=#Service;
                SourceExpr="Allocated Hours" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af ressourceallokeringer til serviceartiklerne i ordren.;
                           ENU=Specifies the number of resource allocations to service items in this order.];
                ApplicationArea=#Service;
                SourceExpr="No. of Allocations" }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af serviceartikler i ordren, som ikke er allokeret til ressourcer.;
                           ENU=Specifies the number of service items in this order that are not allocated to resources.];
                ApplicationArea=#Service;
                SourceExpr="No. of Unallocated Items" }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver servicezonekoden for debitorens leveringsadresse i serviceordren.;
                           ENU=Specifies the service zone code of the customer's ship-to address in the service order.];
                ApplicationArea=#Service;
                SourceExpr="Service Zone Code" }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ordren blev oprettet.;
                           ENU=Specifies the date when the order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Date";
                OnValidate=BEGIN
                             OrderDateOnAfterValidate;
                           END;
                            }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl�t, hvor serviceordren blev oprettet.;
                           ENU=Specifies the time when the service order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Time";
                OnValidate=BEGIN
                             OrderTimeOnAfterValidate;
                           END;
                            }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicen p� ordren forventes at v�re f�rdig.;
                           ENU=Specifies the date when service on the order is expected to be finished.];
                ApplicationArea=#Service;
                SourceExpr="Expected Finishing Date" }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for servicen, dvs. den dato, hvor serviceordrens status �ndres fra Igangsat til I arbejde for f�rste gang.;
                           ENU=Specifies the starting date of the service, that is, the date when the order status changes from Pending, to In Process for the first time.];
                ApplicationArea=#Service;
                SourceExpr="Starting Date";
                Importance=Promoted }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl�ttet for servicen, dvs. det klokkesl�t hvor serviceordrens status �ndres fra Igangsat til I arbejde for f�rste gang.;
                           ENU=Specifies the starting time of the service, that is, the time when the order status changes from Pending, to In Process for the first time.];
                ApplicationArea=#Service;
                SourceExpr="Starting Time" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af timer fra ordreoprettelsen til det tidspunkt, hvor serviceordrens status �ndres fra Igangsat til I arbejde.;
                           ENU=Specifies the number of hours from order creation, to when the service order status changes from Pending, to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Actual Response Time (Hours)" }

    { 182 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver f�rdigg�relsesdatoen for servicen, dvs. den dato, hvor feltet Status �ndres til Udf�rt.;
                           ENU=Specifies the finishing date of the service, that is, the date when the Status field changes to Finished.];
                ApplicationArea=#Service;
                SourceExpr="Finishing Date" }

    { 184 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver f�rdigg�relsesklokkesl�ttet for servicen, dvs. det klokkesl�t, hvor feltet Status �ndres til Udf�rt.;
                           ENU=Specifies the finishing time of the service, that is, the time when the Status field changes to Finished.];
                ApplicationArea=#Service;
                SourceExpr="Finishing Time";
                OnValidate=BEGIN
                             FinishingTimeOnAfterValidate;
                           END;
                            }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede tid i timer, som den angivne service i ordren har varet.;
                           ENU=Specifies the total time in hours that the service specified in the order has taken.];
                ApplicationArea=#Service;
                SourceExpr="Service Time (Hours)" }

    { 1903873101;1;Group  ;
                CaptionML=[DAN=" Udenrigshandel";
                           ENU=" Foreign Trade"] }

    { 179 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#Service;
                SourceExpr="EU 3-Party Trade" }

    { 186 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget repr�senterer med henblik p� rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Service;
                SourceExpr="Transaction Type" }

    { 189 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik p� rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Service;
                SourceExpr="Transaction Specification" }

    { 187 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportm�den ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Service;
                SourceExpr="Transport Method" }

    { 188 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udf�rselssted, hvor varerne blev udf�rt af landet/omr�det med henblik p� rapportering til Intrastat.;
                           ENU=Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.];
                ApplicationArea=#Service;
                SourceExpr="Exit Point" }

    { 192 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omr�de med henblik p� rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Service;
                SourceExpr=Area }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1902018507;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9082;
                Visible=FALSE;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Customer No.);
                PagePartID=Page9084;
                Visible=FALSE;
                PartType=Page }

    { 1907829707;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Customer No.);
                PagePartID=Page9085;
                Visible=TRUE;
                PartType=Page }

    { 1902613707;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9086;
                Visible=FALSE;
                PartType=Page }

    { 1906530507;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(Document No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9088;
                ProviderID=46;
                Visible=TRUE;
                PartType=Page }

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
      ServHeader@1004 : Record 5900;
      ServOrderMgt@1008 : Codeunit 5900;
      ServLogMgt@1009 : Codeunit 5906;
      UserMgt@1013 : Codeunit 5700;
      ChangeExchangeRate@1002 : Page 511;
      DocumentIsPosted@1000 : Boolean;
      OpenPostedServiceOrderQst@1001 : TextConst 'DAN=Ordren er blevet bogf�rt og flyttet til vinduet Bogf�rte servicefakturaer.\\Vil du �bne den bogf�rte faktura?;ENU=The order has been posted and moved to the Posted Service Invoices window.\\Do you want to open the posted invoice?';

    LOCAL PROCEDURE CustomerNoOnAfterValidate@19016267();
    BEGIN
      IF GETFILTER("Customer No.") = xRec."Customer No." THEN
        IF "Customer No." <> xRec."Customer No." THEN
          SETRANGE("Customer No.");
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE BilltoCustomerNoOnAfterValidat@19044114();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE MaxLaborUnitPriceOnAfterValida@19060830();
    BEGIN
      CurrPage.SAVERECORD;
    END;

    LOCAL PROCEDURE PricesIncludingVATOnAfterValid@19009096();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ShiptoCodeOnAfterValidate@19065015();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE OrderTimeOnAfterValidate@19056033();
    BEGIN
      UpdateResponseDateTime;
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE OrderDateOnAfterValidate@19077772();
    BEGIN
      UpdateResponseDateTime;
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE FinishingTimeOnAfterValidate@19010371();
    BEGIN
      CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE ShowPostedConfirmationMessage@17();
    VAR
      OrderServiceHeader@1003 : Record 5900;
      ServiceInvoiceHeader@1000 : Record 5992;
      InstructionMgt@1002 : Codeunit 1330;
    BEGIN
      IF NOT OrderServiceHeader.GET("Document Type","No.") THEN BEGIN
        ServiceInvoiceHeader.SETRANGE("No.",ServHeader."Last Posting No.");
        IF ServiceInvoiceHeader.FINDFIRST THEN
          IF InstructionMgt.ShowConfirm(OpenPostedServiceOrderQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
            PAGE.RUN(PAGE::"Posted Service Invoice",ServiceInvoiceHeader);
      END;
    END;

    BEGIN
    END.
  }
}

