OBJECT Page 9311 Purchase Return Order List
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
    CaptionML=[DAN=K�bsreturvareordrer;
               ENU=Purchase Return Orders];
    SourceTable=Table38;
    SourceTableView=WHERE(Document Type=CONST(Return Order));
    DataCaptionFields=Buy-from Vendor No.;
    PageType=List;
    CardPageID=Purchase Return Order;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport�r,Returvareordre,Anmod om godkendelse,Frigiv;
                                ENU=New,Process,Report,Return Order,Request Approval,Release];
    OnOpenPage=VAR
                 PurchasesPayablesSetup@1000 : Record 312;
               BEGIN
                 SetSecurityFilterOnRespCenter;

                 JobQueueActive := PurchasesPayablesSetup.JobQueueActive;

                 CopyBuyFromVendorFilter;
               END;

    OnAfterGetCurrRecord=BEGIN
                           SetControlAppearance;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601025;1 ;ActionGroup;
                      CaptionML=[DAN=&Returvareordre;
                                 ENU=&Return Order];
                      Image=Return }
      { 1102601027;2 ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger som f.eks. v�rdien for bogf�rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 OpenPurchaseOrderStatistics;
                               END;
                                }
      { 1102601032;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 14      ;2   ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=F� vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvorn�r den blev sendt og hvorn�r den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#PurchReturnOrder;
                      Image=Approvals;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1000 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Purchase Header","Document Type","No.");
                               END;
                                }
      { 1102601029;2 ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 66;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Promoted=Yes;
                      Image=ViewComments;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 1102601030;2 ;Action    ;
                      CaptionML=[DAN=Returvareleverance;
                                 ENU=Return Shipments];
                      ToolTipML=[DAN=�bn de bogf�rte returvareleverancer, der er relateret til ordren.;
                                 ENU=Open the posted return shipments related to this order.];
                      ApplicationArea=#PurchReturnOrder;
                      RunObject=Page 6652;
                      RunPageView=SORTING(Return Order No.);
                      RunPageLink=Return Order No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Shipment;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 1102601031;2 ;Action    ;
                      CaptionML=[DAN=Kred&itnotaer;
                                 ENU=Cred&it Memos];
                      ToolTipML=[DAN=Vis en liste med igangv�rende kreditnotaer for ordren.;
                                 ENU=View a list of ongoing credit memos for the order.];
                      ApplicationArea=#PurchReturnOrder;
                      RunObject=Page 147;
                      RunPageView=SORTING(Return Order No.);
                      RunPageLink=Return Order No.=FIELD(No.);
                      Promoted=Yes;
                      Image=CreditMemo;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 1102601034;2 ;Separator  }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 1102601036;2 ;Action    ;
                      CaptionML=[DAN=L&�g-p�-lager/pluklinjer (lag.);
                                 ENU=In&vt. Put-away/Pick Lines];
                      ToolTipML=[DAN=F� vist ind- eller udg�ende varer p� l�g-p�-lager- eller lagerplukningsbilag for overflytningsordren.;
                                 ENU=View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5774;
                      RunPageView=SORTING(Source Document,Source No.,Location Code);
                      RunPageLink=Source Document=CONST(Purchase Return Order),
                                  Source No.=FIELD(No.);
                      Image=PickLines }
      { 1102601035;2 ;Action    ;
                      CaptionML=[DAN=Lagerleverancelinjer;
                                 ENU=Whse. Shipment Lines];
                      ToolTipML=[DAN=Vis igangv�rende lagerleverancer for bilaget, i avancerede lagerops�tninger.;
                                 ENU=View ongoing warehouse shipments for the document, in advanced warehouse configurations.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7341;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(39),
                                  Source Subtype=FIELD(Document Type),
                                  Source No.=FIELD(No.);
                      Image=ShipmentLines }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 55      ;1   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G�r dig klar til at udskrive bilaget. Der �bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p� udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 DocPrint.PrintPurchHeader(Rec);
                               END;
                                }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 1102601021;2 ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til n�ste behandlingstrin. N�r et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal gen�bne bilaget, f�r du kan foretage �ndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleasePurchDoc@1000 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 1102601022;2 ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&�bn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=�bn dokumentet igen for at �ndre det, efter at det er blevet godkendt. Godkendte dokumenter har status Frigivet og skal �bnes, f�r de kan �ndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=ReOpen;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleasePurchDoc@1001 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 1102601023;2 ;Separator  }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1102601013;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent bogf�rte bilagslinje&r, der skal tilbagef�res;
                                 ENU=Get Posted Doc&ument Lines to Reverse];
                      ToolTipML=[DAN=Kopi�r en eller flere bogf�rte indk�bsdokumentlinjer for at tilbagef�re den oprindelige ordre.;
                                 ENU=Copy one or more posted purchase document lines in order to reverse the original order.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=ReverseLines;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 GetPstdDocLinesToRevere;
                               END;
                                }
      { 1102601020;2 ;Separator  }
      { 1102601024;2 ;Action    ;
                      AccessByPermission=TableData 410=R;
                      CaptionML=[DAN=Send IC-returvareordre;
                                 ENU=Send IC Return Order];
                      ToolTipML=[DAN=Send bilaget til den koncerninterne udbakke eller direkte til den koncerninterne partner, hvis automatisk transaktionsafsendelse er aktiveret.;
                                 ENU=Send the document to the intercompany outbox or directly to the intercompany partner if automatic transaction sending is enabled.];
                      ApplicationArea=#Intercompany;
                      Image=IntercompanyOrder;
                      OnAction=VAR
                                 ICInOutMgt@1000 : Codeunit 427;
                                 ApprovalsMgmt@1003 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                   ICInOutMgt.SendPurchDoc(Rec,FALSE);
                               END;
                                }
      { 1102601014;2 ;Separator  }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 1102601016;2 ;Action    ;
                      AccessByPermission=TableData 7342=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret l&�g-p�-lager (lager)/pluk (lager);
                                 ENU=Create Inventor&y Put-away/Pick];
                      ToolTipML=[DAN=Opret en l�g-p�-lager-aktivitet eller et lagerpluk til h�ndtering af varer p� bilaget i overensstemmelse med en grundl�ggende lagerops�tning, der ikke kr�ver lagermodtagelse eller leverancedokumenter.;
                                 ENU=Create an inventory put-away or inventory pick to handle items on the document according to a basic warehouse configuration that does not require warehouse receipt or shipment documents.];
                      ApplicationArea=#Warehouse;
                      Image=CreatePutawayPick;
                      OnAction=BEGIN
                                 CreateInvtPutAwayPick;
                               END;
                                }
      { 1102601015;2 ;Action    ;
                      AccessByPermission=TableData 7320=R;
                      CaptionML=[DAN=Opre&t lagerleverance;
                                 ENU=Create &Whse. Shipment];
                      ToolTipML=[DAN=Opret en lagerleverance for at starte et pluk eller en leveringsproces i henhold til en avanceret lagerops�tning.;
                                 ENU=Create a warehouse shipment to start a pick a ship process according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=NewShipment;
                      OnAction=VAR
                                 GetSourceDocOutbound@1000 : Codeunit 5752;
                               BEGIN
                                 GetSourceDocOutbound.CreateFromPurchaseReturnOrder(Rec);
                               END;
                                }
      { 1102601017;2 ;Separator  }
      { 50      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf�ring;
                                 ENU=P&osting];
                      Image=Post }
      { 51      ;2   ;Action    ;
                      Name=TestReport;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s� du kan finde og rette eventuelle fejl, f�r du udf�rer den faktiske bogf�ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=TestReport;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ReportPrint.PrintPurchHeader(Rec);
                               END;
                                }
      { 52      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=B&ogf�r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden ved at bogf�re bel�b og antal p� de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 SendToPosting(CODEUNIT::"Purch.-Post (Yes/No)");
                               END;
                                }
      { 20      ;2   ;Action    ;
                      Name=PostSelected;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf�r &valgte;
                                 ENU=Post S&elected];
                      ToolTipML=[DAN=F�rdigg�r de valgte bilag ved at bogf�re bel�b og antal p� de relaterede konti i regnskaberne.;
                                 ENU=Finalize the selected documents by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Image=PostBatch;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 PurchaseHeader@1000 : Record 38;
                                 PurchaseBatchPostMgt@1002 : Codeunit 1372;
                                 BatchProcessingMgt@1001 : Codeunit 1380;
                                 BatchPostParameterTypes@1003 : Codeunit 1370;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(PurchaseHeader);

                                 BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Invoice,TRUE);
                                 BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Ship,TRUE);

                                 PurchaseBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
                                 PurchaseBatchPostMgt.RunWithUI(PurchaseHeader,COUNT,ReadyToPostQst);
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf�ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n�r du bogf�rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=ViewPostedOrder;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 PurchPostYesNo@1001 : Codeunit 91;
                               BEGIN
                                 PurchPostYesNo.Preview(Rec);
                               END;
                                }
      { 53      ;2   ;Action    ;
                      Name=PostAndPrint;
                      ShortCutKey=Shift+F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf�r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden f�rdigg�res og forberedes til udskrivning. V�rdierne og antallene bogf�res p� de relaterede konti. Du f�r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 SendToPosting(CODEUNIT::"Purch.-Post + Print");
                               END;
                                }
      { 54      ;2   ;Action    ;
                      Name=PostBatch;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Masse&bogf�r;
                                 ENU=Post &Batch];
                      ToolTipML=[DAN=Bogf�r flere bilag p� �n gang. Der �bnes et anmodningsvindue, hvor du kan angive, hvilke bilag der skal bogf�res.;
                                 ENU=Post several documents at once. A report request window opens where you can specify which documents to post.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=PostBatch;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Batch Post Purch. Ret. Orders",TRUE,TRUE,Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 3       ;2   ;Action    ;
                      Name=RemoveFromJobQueue;
                      CaptionML=[DAN=Fjern fra opgavek�;
                                 ENU=Remove From Job Queue];
                      ToolTipML=[DAN=Fjern den planlagte behandling af denne record fra jobk�en.;
                                 ENU=Remove the scheduled processing of this record from the job queue.];
                      ApplicationArea=#PurchReturnOrder;
                      Visible=JobQueueActive;
                      Image=RemoveLine;
                      OnAction=BEGIN
                                 CancelBackgroundPosting;
                               END;
                                }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 19      ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send go&dkendelsesanmodning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af bilaget.;
                                 ENU=Request approval of the document.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                               END;
                                }
      { 18      ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesan&modning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord;
                      PromotedIsBig=Yes;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
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
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kreditor, der leverede varerne.;
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
                ToolTipML=[DAN=Angiver navnet p� den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Vendor Name" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kompensationsaftalens identifikationsnummer, som nogle gange kaldes RMA-nummeret (Returns Materials Authorization).;
                           ENU=Specifies the compensation agreement identification number, sometimes referred to as the RMA No. (Returns Materials Authorization).];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Vendor Authorization No." }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p� den kreditor, der leverede varerne.;
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
                ToolTipML=[DAN=Angiver navnet p� kontaktpersonen hos den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the contact person at the vendor who delivered the items.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Contact";
                Visible=FALSE }

    { 163 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the number of the vendor that you received the invoice from.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Vendor No.";
                Visible=FALSE }

    { 161 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kreditor, du har modtaget fakturaen fra.;
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
                ToolTipML=[DAN=Angiver adressens lande-/omr�dekode.;
                           ENU=Specifies the country/region code of the address.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Country/Region Code";
                Visible=FALSE }

    { 151 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kontaktperson hos kreditoren, som fakturaen er sendt fra.;
                           ENU=Specifies the name of the person to contact about an invoice from this vendor.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Contact";
                Visible=FALSE }

    { 147 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs� i tilf�lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 145 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� debitoren p� den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p� den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omr�dekoden p� den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 135 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� kontaktpersonen p� den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 131 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf�ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Location Code" }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indk�ber der er tilknyttet kreditoren.;
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

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Specifies if the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.;
                           ENU=Specifies if the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=Status }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Specifies when the purchase invoice is due for payment.;
                           ENU=Specifies when the purchase invoice is due for payment.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Due Date";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Payment Discount %";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Specifies the delivery conditions of the related shipment, such as free on board (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Shipment Method Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Specifies if all the items on the order have been shipped or, in the case of inbound items, completely received.;
                           ENU=Specifies if all the items on the order have been shipped or, in the case of inbound items, completely received.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Completely Received";
                Visible=FALSE }

    { 1102601003;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret p� den kampagne, bilaget er knyttet til.;
                           ENU=Specifies the campaign number the document is linked to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Campaign No.";
                Visible=FALSE }

    { 1102601005;2;Field  ;
                ToolTipML=[DAN=Angiver den type bogf�rt bilag, som dette bilag eller denne kladdelinje udlignes med, n�r du bogf�rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Applies-to Doc. Type";
                Visible=FALSE }

    { 1102601007;2;Field  ;
                ToolTipML=[DAN="Angiver den dato, hvor du forventer, at varerne er tilg�ngelige p� lageret. Hvis du lader feltet v�re tomt, bliver det beregnet p� f�lgende m�de: Planlagt modtagelsesdato + Sikkerhedstid + Indg�ende lagerekspeditionstid = Forventet modtagelsesdato.";
                           ENU="Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date."];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Expected Receipt Date";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for en opgavek�post, der h�ndterer bogf�ring af k�bsreturvareordrer.;
                           ENU=Specifies the status of a job queue entry that handles the posting of purchase return orders.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Job Queue Status";
                Visible=JobQueueActive }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Specifies the sum of amounts in the Line Amount field on the purchase return order lines.;
                           ENU=Specifies the sum of amounts in the Line Amount field on the purchase return order lines.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=Amount;
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Specifies the total of the amounts, including VAT, on all the lines in the document.;
                           ENU=Specifies the total of the amounts, including VAT, on all the lines in the document.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Amount Including VAT";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1901138007;1;Part   ;
                ApplicationArea=#PurchReturnOrder;
                SubPageLink=No.=FIELD(Buy-from Vendor No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9093;
                PartType=Page }

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
      DocPrint@1102601001 : Codeunit 229;
      ReportPrint@1102601000 : Codeunit 228;
      JobQueueActive@1001 : Boolean INDATASET;
      OpenApprovalEntriesExist@1003 : Boolean;
      CanCancelApprovalForRecord@1002 : Boolean;
      ReadyToPostQst@1000 : TextConst '@@@=%1 - selected count, %2 - total count;DAN=%1 ud af %2 valgte returvareordrer er klar til bogf�ring. \Vil du forts�tte og bogf�re dem?;ENU=%1 out of %2 selected return orders are ready for post. \Do you want to continue and post them?';

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1000 : Codeunit 1535;
    BEGIN
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
    END;

    BEGIN
    END.
  }
}

