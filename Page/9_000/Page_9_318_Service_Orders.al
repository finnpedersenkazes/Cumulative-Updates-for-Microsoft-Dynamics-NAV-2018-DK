OBJECT Page 9318 Service Orders
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Serviceordrer;
               ENU=Service Orders];
    SourceTable=Table5900;
    SourceTableView=WHERE(Document Type=CONST(Order));
    DataCaptionFields=Customer No.;
    PageType=List;
    CardPageID=Service Order;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Lagersted;
                                ENU=New,Process,Report,Warehouse];
    OnOpenPage=BEGIN
                 SetSecurityFilterOnRespCenter;

                 CopyCustomerFilter;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=&Ordre;
                                 ENU=O&rder];
                      Image=Order }
      { 1102601009;2 ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=D&ebitorkort;
                                 ENU=&Customer Card];
                      ToolTipML=[DAN=F† vist detaljerede oplysninger om debitoren.;
                                 ENU=View detailed information about the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Customer No.);
                      Image=Customer }
      { 1102601010;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=&Dimensioner;
                                 ENU=&Dimensions];
                      ToolTipML=[DAN=F† vist eller rediger dimensioner som f.eks. omr†de, projekt eller afdeling, som du kan tildele til kladdelinjer for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to journal lines to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 1102601003;2 ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Serviceposter;
                                 ENU=Service Ledger E&ntries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogf›ringstransaktioner i servicedokumenter.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents.];
                      ApplicationArea=#Service;
                      RunObject=Page 5912;
                      RunPageView=SORTING(Service Order No.,Service Item No. (Serviced),Entry Type,Moved from Prepaid Acc.,Posting Date,Open,Type);
                      RunPageLink=Service Order No.=FIELD(No.);
                      Image=ServiceLedger }
      { 1102601019;2 ;Action    ;
                      CaptionML=[DAN=Mail&k›;
                                 ENU=Email &Queue];
                      ToolTipML=[DAN=Vis oversigten over mails, der venter p† at blive sendt automatisk for at underrette debitorer om deres serviceartikel.;
                                 ENU=View the list of emails that are waiting to be sent automatically to notify customers about their service item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5961;
                      RunPageView=SORTING(Document Type,Document No.);
                      RunPageLink=Document Type=CONST(Service Order),
                                  Document No.=FIELD(No.);
                      Image=Email }
      { 1102601012;2 ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=Table Name=CONST(Service Header),
                                  Table Subtype=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Type=CONST(General);
                      Image=ViewComments }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      Image=Statistics }
      { 1102601016;2 ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
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
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 1102601013;2 ;Action    ;
                      CaptionML=[DAN=Le&verancer;
                                 ENU=S&hipments];
                      ToolTipML=[DAN=F† vist relaterede bogf›rte serviceleverancer.;
                                 ENU=View related posted service shipments.];
                      ApplicationArea=#Service;
                      RunObject=Page 5974;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Image=Shipment }
      { 1102601014;2 ;Action    ;
                      CaptionML=[DAN=Fakturaer;
                                 ENU=Invoices];
                      ToolTipML=[DAN=Vis en liste med igangv‘rende salgsfakturaer for ordren.;
                                 ENU=View a list of ongoing sales invoices for the order.];
                      ApplicationArea=#Service;
                      RunObject=Page 5977;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Image=Invoice }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Lagersted;
                                 ENU=W&arehouse];
                      Image=Warehouse }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Lagerleverancelinjer;
                                 ENU=Whse. Shipment Lines];
                      ToolTipML=[DAN=Vis igangv‘rende lagerleverancer for bilaget, i avancerede lagerops‘tninger.;
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
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 1102601018;2 ;Action    ;
                      CaptionML=[DAN=&Servicedokumentlog;
                                 ENU=Service Document Lo&g];
                      ToolTipML=[DAN=F† vist en liste over de ‘ndringer i servicedokumentet, der er registreret. I programmet oprettes der poster i vinduet, f.eks. n†r svartiden eller serviceordrens status er ‘ndret, en ressource er allokeret, en serviceordre er leveret eller faktureret osv. Hver linje i vinduet identificerer den h‘ndelse, der er forekommet i servicedokumentet. Linjen indeholder oplysninger om det felt, der er ‘ndret, dets gamle og nye v‘rdi, datoen og tidspunktet for, hvorn†r ‘ndringen fandt sted, og id'et for den bruger, som foretog ‘ndringerne.;
                                 ENU=View a list of the service document changes that have been logged. The program creates entries in the window when, for example, the response time or service order status changed, a resource was allocated, a service order was shipped or invoiced, and so on. Each line in this window identifies the event that occurred to the service document. The line contains the information about the field that was changed, its old and new value, the date and time when the change took place, and the ID of the user who actually made the changes.];
                      ApplicationArea=#Service;
                      Image=Log;
                      OnAction=VAR
                                 ServDocLog@1001 : Record 5912;
                               BEGIN
                                 ServDocLog.ShowServDocLog(Rec);
                               END;
                                }
      { 1102601004;2 ;Action    ;
                      CaptionML=[DAN=&Garantiposter;
                                 ENU=&Warranty Ledger Entries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogf›ringstransaktioner i servicedokumenter, der indeholder garantiaftaler.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents that contain warranty agreements.];
                      ApplicationArea=#Service;
                      RunObject=Page 5913;
                      RunPageView=SORTING(Service Order No.,Posting Date,Document No.);
                      RunPageLink=Service Order No.=FIELD(No.);
                      Image=WarrantyLedger }
      { 1102601005;2 ;Action    ;
                      CaptionML=[DAN=&Sagsposter;
                                 ENU=&Job Ledger Entries];
                      ToolTipML=[DAN=Vis alle sagsposter, der stammer fra bogf›ringstransaktioner i servicedokumentet, som omfatter en sag.;
                                 ENU=View all the job ledger entries that result from posting transactions in the service document that involve a job.];
                      ApplicationArea=#Service;
                      RunObject=Page 92;
                      RunPageView=SORTING(Service Order No.,Posting Date)
                                  WHERE(Entry Type=CONST(Usage));
                      RunPageLink=Service Order No.=FIELD(No.);
                      Image=JobLedger }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 50      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 51      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s† du kan finde og rette eventuelle fejl, f›r du udf›rer den faktiske bogf›ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Service;
                      Image=TestReport;
                      OnAction=VAR
                                 ReportPrint@1001 : Codeunit 228;
                               BEGIN
                                 ReportPrint.PrintServiceHeader(Rec);
                               END;
                                }
      { 52      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=B&ogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ServPostYesNo@1002 : Codeunit 5981;
                               BEGIN
                                 ServHeader.GET("Document Type","No.");
                                 ServPostYesNo.PostDocument(ServHeader);
                               END;
                                }
      { 21      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf›ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n†r du bogf›rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Service;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 ServPostYesNo@1000 : Codeunit 5981;
                               BEGIN
                                 ServHeader.GET("Document Type","No.");
                                 ServPostYesNo.PreviewDocument(ServHeader);
                               END;
                                }
      { 53      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden f‘rdigg›res og forberedes til udskrivning. V‘rdierne og antallene bogf›res p† de relaterede konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
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
      { 54      ;2   ;Action    ;
                      Name=PostBatch;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Masse&bogf›r;
                                 ENU=Post &Batch];
                      ToolTipML=[DAN=Bogf›r flere bilag p† ‚n gang. Der †bnes et anmodningsvindue, hvor du kan angive, hvilke bilag der skal bogf›res.;
                                 ENU=Post several documents at once. A report request window opens where you can specify which documents to post.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=PostBatch;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CLEAR(ServHeader);
                                 ServHeader.SETRANGE(Status,ServHeader.Status::Finished);
                                 REPORT.RUNMODAL(REPORT::"Batch Post Service Orders",TRUE,TRUE,ServHeader);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 55      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
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
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Lagersted;
                                 ENU=W&arehouse];
                      Image=Warehouse }
      { 11      ;2   ;Action    ;
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
      { 7       ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&bn igen;
                                 ENU=Reopen];
                      ToolTipML=[DAN=Aktiv‚r serviceordren igen, efter at den er blevet frigivet til lagerekspedition.;
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
      { 8       ;2   ;Action    ;
                      Name=Create Whse Shipment;
                      AccessByPermission=TableData 7320=R;
                      CaptionML=[DAN=Opret lagerleverance;
                                 ENU=Create Whse. Shipment];
                      ToolTipML=[DAN=Forbered plukning og levering af serviceartiklen.;
                                 ENU=Prepare to pick and ship the service item.];
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

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serviceordrens status, som afspejler reparations- eller vedligeholdelsesstatus for alle serviceartikler i serviceordren.;
                           ENU=Specifies the service order status, which reflects the repair or maintenance status of all service items on the service order.];
                ApplicationArea=#Service;
                SourceExpr=Status }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ordren blev oprettet.;
                           ENU=Specifies the date when the order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor serviceordren blev oprettet.;
                           ENU=Specifies the time when the service order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Time" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som ejer varerne i servicedokumentet.;
                           ENU=Specifies the number of the customer who owns the items in the service document.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, som varerne i bilaget skal leveres til.;
                           ENU=Specifies the name of the customer to whom the items on the document will be shipped.];
                ApplicationArea=#Service;
                SourceExpr=Name }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for lokationen (f.eks. lagersted eller distributionscenter) for de varer, der er angivet p† serviceartikellinjerne.;
                           ENU=Specifies the code of the location (for example, warehouse or distribution center) of the items specified on the service item lines.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ansl†ede dato, hvor arbejdet p† ordren skal p†begyndes, dvs. n†r serviceordrens status ‘ndres fra Igangsat til I arbejde.;
                           ENU=Specifies the estimated date when work on the order should start, that is, when the service order status changes from Pending, to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Response Date" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det ansl†ede klokkesl‘t, hvor arbejdet p† ordren begynder, dvs. n†r serviceordrens status ‘ndres fra Igangsat til I arbejde.;
                           ENU=Specifies the estimated time when work on the order starts, that is, when the service order status changes from Pending, to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Response Time" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prioriteten for serviceordren.;
                           ENU=Specifies the priority of the service order.];
                ApplicationArea=#Service;
                SourceExpr=Priority }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varer i vinduet Servicelinjer er klar til h†ndtering i lageraktiviteter.;
                           ENU=Specifies if items in the Service Lines window are ready to be handled in warehouse activities.];
                ApplicationArea=#Service;
                SourceExpr="Release Status" }

    { 121 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Service;
                SourceExpr="Assigned User ID" }

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver, hvordan debitoren ›nsker at modtage notifikationer om f‘rdigg›relse af servicen.;
                           ENU=Specifies how the customer wants to receive notifications about service completion.];
                ApplicationArea=#Service;
                SourceExpr="Notify Customer";
                Visible=FALSE }

    { 1102601007;2;Field  ;
                ToolTipML=[DAN=Angiver typen for serviceordren.;
                           ENU=Specifies the type of this service order.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Type";
                Visible=FALSE }

    { 1102601020;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret p† den kontrakt, som er knyttet til ordren.;
                           ENU=Specifies the number of the contract associated with the order.];
                ApplicationArea=#Service;
                SourceExpr="Contract No.";
                Visible=FALSE }

    { 1102601022;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Service;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 1102601024;2;Field  ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Service;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 1102601026;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn†r fakturaen er forfalden.;
                           ENU=Specifies when the invoice is due.];
                ApplicationArea=#Service;
                SourceExpr="Due Date";
                Visible=FALSE }

    { 1102601028;2;Field  ;
                ToolTipML=[DAN=Angiver kontantrabatprocent, der gives, hvis debitoren betaler inden den dato, der er angivet i feltet Kont.rabatdato.;
                           ENU=Specifies the percentage of payment discount given, if the customer pays by the date entered in the Pmt. Discount Date field.];
                ApplicationArea=#Service;
                SourceExpr="Payment Discount %";
                Visible=FALSE }

    { 1102601030;2;Field  ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverf›rsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Service;
                SourceExpr="Payment Method Code";
                Visible=FALSE }

    { 1102601032;2;Field  ;
                ToolTipML=[DAN=Angiver oplysninger, om debitoren vil acceptere en delvis leverance af ordren.;
                           ENU=Specifies information about whether the customer will accept a partial shipment of the order.];
                ApplicationArea=#Service;
                SourceExpr="Shipping Advice";
                Visible=FALSE }

    { 1102601034;2;Field  ;
                ToolTipML=[DAN=Angiver advarselsstatus for svartiden p† ordren.;
                           ENU=Specifies the response time warning status for the order.];
                ApplicationArea=#Service;
                SourceExpr="Warning Status";
                Visible=FALSE }

    { 1102601036;2;Field  ;
                ToolTipML=[DAN=Angiver antallet af timer, der er allokeret til varerne i serviceordren.;
                           ENU=Specifies the number of hours allocated to the items in this service order.];
                ApplicationArea=#Service;
                SourceExpr="Allocated Hours";
                Visible=FALSE }

    { 1102601038;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor servicen p† ordren forventes at v‘re f‘rdig.;
                           ENU=Specifies the date when service on the order is expected to be finished.];
                ApplicationArea=#Service;
                SourceExpr="Expected Finishing Date";
                Visible=FALSE }

    { 1102601040;2;Field  ;
                ToolTipML=[DAN=Angiver startdatoen for servicen, dvs. den dato, hvor serviceordrens status ‘ndres fra Igangsat til I arbejde for f›rste gang.;
                           ENU=Specifies the starting date of the service, that is, the date when the order status changes from Pending, to In Process for the first time.];
                ApplicationArea=#Service;
                SourceExpr="Starting Date";
                Visible=FALSE }

    { 1102601042;2;Field  ;
                ToolTipML=[DAN=Angiver f‘rdigg›relsesdatoen for servicen, dvs. den dato, hvor feltet Status ‘ndres til Udf›rt.;
                           ENU=Specifies the finishing date of the service, that is, the date when the Status field changes to Finished.];
                ApplicationArea=#Service;
                SourceExpr="Finishing Date";
                Visible=FALSE }

    { 1102601044;2;Field  ;
                ToolTipML=[DAN=Angiver den samlede tid i timer, som den angivne service i ordren har varet.;
                           ENU=Specifies the total time in hours that the service specified in the order has taken.];
                ApplicationArea=#Service;
                SourceExpr="Service Time (Hours)";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1902018507;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Bill-to Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9082;
                Visible=TRUE;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9084;
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
      ServHeader@1102601000 : Record 5900;

    BEGIN
    END.
  }
}

