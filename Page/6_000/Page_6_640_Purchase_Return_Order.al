OBJECT Page 6640 Purchase Return Order
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kõbsreturvareordre;
               ENU=Purchase Return Order];
    SourceTable=Table38;
    SourceTableView=WHERE(Document Type=FILTER(Return Order));
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Godkend,Frigiv,Bogfõring,Forbered,Faktura,Anmod om godkendelse;
                                ENU=New,Process,Report,Approve,Release,Posting,Prepare,Invoice,Request Approval];
    OnInit=VAR
             PurchasesPayablesSetup@1000 : Record 312;
           BEGIN
             JobQueueUsed := PurchasesPayablesSetup.JobQueueActive;
           END;

    OnOpenPage=BEGIN
                 SetDocNoVisible;

                 IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
                   FILTERGROUP(0);
                 END;
                 IF ("No." <> '') AND ("Buy-from Vendor No." = '') THEN
                   DocumentIsPosted := (NOT GET("Document Type","No."));
               END;

    OnAfterGetRecord=BEGIN
                       CalculateCurrentShippingOption;
                     END;

    OnNewRecord=BEGIN
                  "Responsibility Center" := UserMgt.GetPurchasesFilter;
                  IF (NOT DocNoVisible) AND ("No." = '') THEN
                    SetBuyFromVendorFromFilter;
                END;

    OnDeleteRecord=BEGIN
                     CurrPage.SAVERECORD;
                     EXIT(ConfirmDeletion);
                   END;

    OnQueryClosePage=BEGIN
                       IF NOT DocumentIsPosted THEN
                         EXIT(ConfirmCloseUnposted);
                     END;

    OnAfterGetCurrRecord=BEGIN
                           SetControlAppearance;
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Returvareordre;
                                 ENU=&Return Order];
                      Image=Return }
      { 49      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 OpenPurchaseOrderStatistics;
                                 PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 50      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kreditor;
                                 ENU=Vendor];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om kreditoren i kõbsdokumentet.;
                                 ENU=View or edit detailed information about the vendor on the purchase document.];
                      ApplicationArea=#PurchReturnOrder;
                      RunObject=Page 26;
                      RunPageLink=No.=FIELD(Buy-from Vendor No.);
                      Enabled="Buy-from Vendor No." <> '';
                      Image=Vendor }
      { 105     ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Enabled="No." <> '';
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 33      ;2   ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#PurchReturnOrder;
                      Image=Approvals;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1000 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Purchase Header","Document Type","No.");
                               END;
                                }
      { 51      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 66;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 5801    ;2   ;Action    ;
                      CaptionML=[DAN=Returvareleverance;
                                 ENU=Return Shipments];
                      ToolTipML=[DAN=èbn de bogfõrte returvareleverancer, der er relateret til ordren.;
                                 ENU=Open the posted return shipments related to this order.];
                      ApplicationArea=#PurchReturnOrder;
                      RunObject=Page 6652;
                      RunPageView=SORTING(Return Order No.);
                      RunPageLink=Return Order No.=FIELD(No.);
                      Image=Shipment }
      { 117     ;2   ;Action    ;
                      CaptionML=[DAN=Kred&itnotaer;
                                 ENU=Cred&it Memos];
                      ToolTipML=[DAN=Vis en liste med igangvërende kreditnotaer for ordren.;
                                 ENU=View a list of ongoing credit memos for the order.];
                      ApplicationArea=#PurchReturnOrder;
                      RunObject=Page 147;
                      RunPageView=SORTING(Return Order No.);
                      RunPageLink=Return Order No.=FIELD(No.);
                      Image=CreditMemo }
      { 136     ;2   ;Separator  }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 114     ;2   ;Action    ;
                      CaptionML=[DAN=Lagerleverancelinjer;
                                 ENU=Whse. Shipment Lines];
                      ToolTipML=[DAN=Vis igangvërende lagerleverancer for bilaget, i avancerede lageropsëtninger.;
                                 ENU=View ongoing warehouse shipments for the document, in advanced warehouse configurations.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7341;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(39),
                                  Source Subtype=FIELD(Document Type),
                                  Source No.=FIELD(No.);
                      Image=ShipmentLines }
      { 129     ;2   ;Action    ;
                      CaptionML=[DAN=L&ëg-pÜ-lager/pluklinjer (lag.);
                                 ENU=In&vt. Put-away/Pick Lines];
                      ToolTipML=[DAN=FÜ vist ind- eller udgÜende varer pÜ lëg-pÜ-lager- eller lagerplukningsbilag for overflytningsordren.;
                                 ENU=View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5774;
                      RunPageView=SORTING(Source Document,Source No.,Location Code);
                      RunPageLink=Source Document=CONST(Purchase Return Order),
                                  Source No.=FIELD(No.);
                      Image=PickLines }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 29      ;2   ;Action    ;
                      Name=Approve;
                      CaptionML=[DAN=Godkend;
                                 ENU=Approve];
                      ToolTipML=[DAN=Godkend de anmodede ëndringer.;
                                 ENU=Approve the requested changes.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 27      ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Afvis;
                                 ENU=Reject];
                      ToolTipML=[DAN=Afvis de anmodede ëndringer.;
                                 ENU=Reject the requested changes.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 25      ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger de anmodede ëndringer til den stedfortrëdende godkender.;
                                 ENU=Delegate the requested changes to the substitute approver.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=Delegate;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 23      ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bemërkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=ViewComments;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.GetApprovalComment(Rec);
                               END;
                                }
      { 104     ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du fÜr vist anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 DocPrint.PrintPurchHeader(Rec);
                               END;
                                }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 112     ;2   ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleasePurchDoc@1000 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 113     ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen for at ëndre det, efter at det er blevet godkendt. Godkendte bilag har status Frigivet og skal Übnes, fõr de kan ëndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Enabled=Status <> Status::Open;
                      Image=ReOpen;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleasePurchDoc@1001 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 690     ;2   ;Separator  }
      { 52      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 285     ;2   ;Action    ;
                      Name=GetPostedDocumentLinesToReverse;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent bogfõrte bilagslinje&r, der skal tilbagefõres;
                                 ENU=Get Posted Doc&ument Lines to Reverse];
                      ToolTipML=[DAN=KopiÇr en eller flere bogfõrte indkõbsdokumentlinjer for at tilbagefõre den oprindelige ordre.;
                                 ENU=Copy one or more posted purchase document lines in order to reverse the original order.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReverseLines;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 GetPstdDocLinesToRevere;
                               END;
                                }
      { 119     ;2   ;Action    ;
                      ShortCutKey=Shift+F11;
                      CaptionML=[DAN=Udlign;
                                 ENU=Apply Entries];
                      ToolTipML=[DAN=Udlign Übne poster for den relevante kontotype.;
                                 ENU=Apply open entries for the relevant account type.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ApplyEntries;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Purchase Header Apply",Rec);
                               END;
                                }
      { 130     ;2   ;Separator  }
      { 53      ;2   ;Action    ;
                      Name=CalculateInvoiceDiscount;
                      AccessByPermission=TableData 24=R;
                      CaptionML=[DAN=&Beregn fakturarabat;
                                 ENU=Calculate &Invoice Discount];
                      ToolTipML=[DAN=Beregn den rabat, der kan tildeles, pÜ grundlag af alle linjer i kõbsbilaget.;
                                 ENU=Calculate the discount that can be granted based on all lines in the purchase document.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=CalculateInvoiceDiscount;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ApproveCalcInvDisc;
                                 PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 132     ;2   ;Separator  }
      { 54      ;2   ;Action    ;
                      Name=CopyDocument;
                      Ellipsis=Yes;
                      CaptionML=[DAN=KopiÇr dokument;
                                 ENU=Copy Document];
                      ToolTipML=[DAN=KopiÇr bilagslinjer og sidehovedoplysninger fra et andet kõbsbilag til dette bilag. Du kan kopiere en bogfõrt kõbsfaktura til en ny kõbsfaktura, hvis du hurtigt vil oprette et lignende bilag.;
                                 ENU=Copy document lines and header information from another purchase document to this document. You can copy a posted purchase invoice into a new purchase invoice to quickly create a similar document.];
                      ApplicationArea=#PurchReturnOrder;
                      Image=CopyDocument;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CopyPurchDoc.SetPurchHeader(Rec);
                                 CopyPurchDoc.RUNMODAL;
                                 CLEAR(CopyPurchDoc);
                                 IF GET("Document Type","No.") THEN;
                               END;
                                }
      { 120     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Flyt negative linjer;
                                 ENU=Move Negative Lines];
                      ToolTipML=[DAN=Gõr dig klar til at oprette en erstatningssalgsordre i en salgsreturproces.;
                                 ENU=Prepare to create a replacement sales order in a sales return process.];
                      ApplicationArea=#Advanced;
                      Image=MoveNegativeLines;
                      OnAction=BEGIN
                                 CLEAR(MoveNegPurchLines);
                                 MoveNegPurchLines.SetPurchHeader(Rec);
                                 MoveNegPurchLines.RUNMODAL;
                                 MoveNegPurchLines.ShowDocument;
                               END;
                                }
      { 142     ;2   ;Action    ;
                      CaptionML=[DAN=Arkiver dokument;
                                 ENU=Archive Document];
                      ToolTipML=[DAN=Send bilaget til arkivet, f.eks. fordi det er for tidligt at slette det. Senere skal du slette eller genbehandle det arkiverede bilag.;
                                 ENU=Send the document to the archive, for example because it is too soon to delete it. Later, you delete or reprocess the archived document.];
                      ApplicationArea=#Advanced;
                      Image=Archive;
                      OnAction=BEGIN
                                 ArchiveManagement.ArchivePurchDocument(Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 138     ;2   ;Action    ;
                      AccessByPermission=TableData 410=R;
                      CaptionML=[DAN=Send IC-returvareordre;
                                 ENU=Send IC Return Order];
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
      { 134     ;2   ;Separator  }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=Approval }
      { 37      ;2   ;Action    ;
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
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                               END;
                                }
      { 35      ;2   ;Action    ;
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
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                               END;
                                }
      { 137     ;2   ;Separator  }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 93      ;2   ;Action    ;
                      AccessByPermission=TableData 7320=R;
                      CaptionML=[DAN=Opre&t lagerleverance;
                                 ENU=Create &Whse. Shipment];
                      ToolTipML=[DAN=Opret en lagerleverance for at starte et pluk eller en leveringsproces i henhold til en avanceret lageropsëtning.;
                                 ENU=Create a warehouse shipment to start a pick a ship process according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=NewShipment;
                      OnAction=VAR
                                 GetSourceDocOutbound@1000 : Codeunit 5752;
                               BEGIN
                                 GetSourceDocOutbound.CreateFromPurchaseReturnOrder(Rec);
                               END;
                                }
      { 118     ;2   ;Action    ;
                      AccessByPermission=TableData 7342=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret l&ëg-pÜ-lager (lager)/pluk (lager);
                                 ENU=Create Inventor&y Put-away/Pick];
                      ToolTipML=[DAN=Opret en lëg-pÜ-lager-aktivitet eller et lagerpluk til hÜndtering af varer pÜ bilaget i overensstemmelse med en grundlëggende lageropsëtning, der ikke krëver lagermodtagelse eller leverancedokumenter.;
                                 ENU=Create an inventory put-away or inventory pick to handle items on the document according to a basic warehouse configuration that does not require warehouse receipt or shipment documents.];
                      ApplicationArea=#Warehouse;
                      Image=CreateInventoryPickup;
                      OnAction=BEGIN
                                 CreateInvtPutAwayPick;
                               END;
                                }
      { 135     ;2   ;Separator  }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&osting];
                      Image=Post }
      { 59      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Bogfõr;
                                 ENU=P&ost];
                      ToolTipML=[DAN=Fërdiggõr bilaget eller kladden ved at bogfõre belõb og antal pÜ de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Purch.-Post (Yes/No)");
                               END;
                                }
      { 17      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogfõring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, nÜr du bogfõrer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=ViewPostedOrder;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 PurchPostYesNo@1000 : Codeunit 91;
                               BEGIN
                                 PurchPostYesNo.Preview(Rec);
                               END;
                                }
      { 58      ;2   ;Action    ;
                      Name=TestReport;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, sÜ du kan finde og rette eventuelle fejl, fõr du udfõrer den faktiske bogfõring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      Image=TestReport;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ReportPrint.PrintPurchHeader(Rec);
                               END;
                                }
      { 60      ;2   ;Action    ;
                      Name=PostAndPrint;
                      ShortCutKey=Shift+F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Fërdiggõr bilaget eller kladden, og forbered udskrivning. Vërdierne og mëngderne bogfõres pÜ de relevante konti. Du fÜr vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#PurchReturnOrder;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Purch.-Post + Print");
                               END;
                                }
      { 61      ;2   ;Action    ;
                      Name=PostBatch;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Massebogfõr;
                                 ENU=Post &Batch];
                      ToolTipML=[DAN=Bogfõr flere bilag pÜ Çn gang. Der Übnes et anmodningsvindue, hvor du kan angive, hvilke bilag der skal bogfõres.;
                                 ENU=Post several documents at once. A report request window opens where you can specify which documents to post.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=PostBatch;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Batch Post Purch. Ret. Orders",TRUE,TRUE,Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=RemoveFromJobQueue;
                      CaptionML=[DAN=Fjern fra opgavekõ;
                                 ENU=Remove From Job Queue];
                      ToolTipML=[DAN=Fjern den planlagte behandling af denne record fra jobkõen.;
                                 ENU=Remove the scheduled processing of this record from the job queue.];
                      ApplicationArea=#All;
                      Visible=JobQueueVisible;
                      Image=RemoveLine;
                      OnAction=BEGIN
                                 CancelBackgroundPosting;
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
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="No.";
                Importance=Promoted;
                Visible=DocNoVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Kreditornr.;
                           ENU=Vendor No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kreditor, der returnerer produkterne.;
                           ENU=Specifies the number of the vendor who returns the products.];
                ApplicationArea=#PurchReturnOrder;
                NotBlank=Yes;
                SourceExpr="Buy-from Vendor No.";
                Importance=Additional;
                OnValidate=BEGIN
                             OnAfterValidateBuyFromVendorNo(Rec,xRec);
                             CurrPage.UPDATE;
                           END;
                            }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Kreditornavn;
                           ENU=Vendor Name];
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, der returnerer produkterne.;
                           ENU=Specifies the name of the vendor who returns the products.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Vendor Name";
                Importance=Promoted;
                OnValidate=BEGIN
                             OnAfterValidateBuyFromVendorNo(Rec,xRec);

                             CurrPage.UPDATE;
                           END;

                ShowMandatory=TRUE }

    { 43  ;2   ;Group     ;
                CaptionML=[DAN=Leverandõr;
                           ENU=Buy-from];
                GroupType=Group }

    { 63  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver leverandõrens adresse.;
                           ENU=Specifies the vendor's buy-from address.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Address";
                Importance=Additional }

    { 65  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af leverandõrens adresse.;
                           ENU=Specifies an additional part of the vendor's buy-from address.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Address 2";
                Importance=Additional }

    { 68  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Post Code";
                Importance=Additional }

    { 67  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsbilaget.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from City";
                Importance=Additional }

    { 125 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ din kontakt hos kreditoren.;
                           ENU=Specifies the number of your contact at the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Contact No.";
                Importance=Additional }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen for en ordre hos denne kreditor.;
                           ENU=Specifies the name of the person to contact about an order from this vendor.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Contact";
                Editable="Buy-from Vendor No." <> '' }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Document Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogfõringsdatoen for recorden.;
                           ENU=Specifies the posting date of the record.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Posting Date";
                Importance=Additional }

    { 146 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange arkiverede versioner der findes af dette bilag.;
                           ENU=Specifies the number of archived versions for this document.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Archived Versions";
                Importance=Additional }

    { 121 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ordren blev oprettet.;
                           ENU=Specifies the date when the order was created.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Order Date";
                Importance=Additional }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kompensationsaftalens identifikationsnummer. Det kaldes nogle gange kaldes RMA-nummeret (Returns Materials Authorization).;
                           ENU=Specifies the identification number of a compensation agreement. This number is sometimes referred to as the RMA No.(Returns Materials Authorization).];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Vendor Authorization No.";
                Importance=Additional }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som kreditoren bruger til den kreditnota, du er ved at oprette i denne kõbsreturordre.;
                           ENU=Specifies the number that the vendor uses for the credit memo you are creating in this purchase return order.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Vendor Cr. Memo No.";
                Importance=Promoted;
                ShowMandatory=TRUE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indkõber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Purchaser Code";
                OnValidate=BEGIN
                             PurchaserCodeOnAfterValidate;
                           END;
                            }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kampagne, bilaget er knyttet til.;
                           ENU=Specifies the campaign number the document is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Campaign No." }

    { 107 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID";
                Importance=Additional }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for en opgavekõpost, der hÜndterer bogfõring af kõbsreturvareordrer.;
                           ENU=Specifies the status of a job queue entry that handles the posting of purchase return orders.];
                ApplicationArea=#All;
                SourceExpr="Job Queue Status";
                Importance=Additional;
                Visible=JobQueueUsed }

    { 101 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bilaget har status som Übent, frigivet, udestÜende godkendelse eller afventer forudbetaling.;
                           ENU=Specifies whether the document is open, released, pending approval, or pending prepayment.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=Status;
                Importance=Promoted }

    { 46  ;1   ;Part      ;
                Name=PurchLines;
                ApplicationArea=#PurchReturnOrder;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page6641;
                Enabled="Buy-from Vendor No." <> '';
                Editable="Buy-from Vendor No." <> '';
                PartType=Page;
                UpdatePropagation=Both }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Currency Code";
                Importance=Additional;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                           END;

                OnAssistEdit=BEGIN
                               IF "Posting Date" <> 0D THEN
                                 ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date")
                               ELSE
                                 ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                                 CurrPage.UPDATE;
                               END;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den dato, hvor du forventer, at varerne er tilgëngelige pÜ lageret. Hvis du lader feltet vëre tomt, bliver det beregnet pÜ fõlgende mÜde: Planlagt modtagelsesdato + Sikkerhedstid + IndgÜende lagerekspeditionstid = Forventet modtagelsesdato.";
                           ENU="Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date."];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Expected Receipt Date";
                Importance=Promoted }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             PricesIncludingVATOnAfterValid;
                           END;
                            }

    { 139 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="VAT Bus. Posting Group" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget reprësenterer med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Type" }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                OnValidate=BEGIN
                             ShortcutDimension1CodeOnAfterV;
                           END;
                            }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                OnValidate=BEGIN
                             ShortcutDimension2CodeOnAfterV;
                           END;
                            }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Promoted }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogfõrt bilag, som dette bilag eller denne kladdelinje udlignes med, nÜr du bogfõrer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Applies-to Doc. Type";
                Importance=Promoted }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det bogfõrte bilag, som dette bilag eller denne kladdelinje udlignes pÜ, nÜr du bogfõrer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Applies-to Doc. No.";
                Importance=Promoted }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id for poster, der udlignes, nÜr du vëlger handlingen Udlign poster.;
                           ENU=Specifies the ID of entries that will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Applies-to ID" }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Forsendelse og betaling;
                           ENU=Shipping and Payment];
                GroupType=Group }

    { 45  ;2   ;Group     ;
                GroupType=Group }

    { 55  ;3   ;Field     ;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                ToolTipML=[DAN=Angiver den adresse, som produkter i kõbsbilaget skal leveres til. Standard (firmaadresse): Det samme som den firmaadresse, der er angivet i vinduet Virksomhedsoplysninger. Lokation: ên af virksomhedens lokationsadresser. Brugerdefineret adresse: En vilkÜrlig leveringsadresse, som du angiver i nedenstÜende felter.;
                           ENU=Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Location: One of the company's location addresses. Custom Address: Any ship-to address that you specify in the fields below.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=ShipToOptions;
                OnValidate=BEGIN
                             ValidateShippingOption;
                           END;
                            }

    { 48  ;2   ;Group     ;
                Visible=ShipToOptions = ShipToOptions::"Alternate Vendor Address";
                GroupType=Group }

    { 72  ;3   ;Field     ;
                CaptionML=[DAN=Alternativ kreditoradressekode;
                           ENU=Alternate Vendor Address Code];
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Order Address Code" }

    { 62  ;2   ;Group     ;
                GroupType=Group }

    { 32  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, ordren er sendt fra.;
                           ENU=Specifies the name of the vendor sending the order.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Name";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 34  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver leverandõrens adresse.;
                           ENU=Specifies the vendor's buy-from address.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Address";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 36  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af leverandõrens adresse.;
                           ENU=Specifies an additional part of the vendor's buy-from address.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Address 2";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 83  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Post Code";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 38  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsbilaget.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to City";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 40  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen for en ordre hos denne kreditor.;
                           ENU=Specifies the name of the person to contact about an order from this vendor.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Ship-to Contact";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 20  ;2   ;Group     ;
                CaptionML=[DAN=Faktureres til;
                           ENU=Pay-to];
                GroupType=Group }

    { 22  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, ordren er sendt fra.;
                           ENU=Specifies the name of the vendor sending the order.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Name";
                Importance=Promoted }

    { 24  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver leverandõrens adresse.;
                           ENU=Specifies the vendor's buy-from address.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Address";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 26  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af leverandõrens adresse.;
                           ENU=Specifies an additional part of the vendor's buy-from address.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Address 2";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 73  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Post Code";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 28  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsbilaget.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to City";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 127 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, der sender fakturaen.;
                           ENU=Specifies the number of the contact who sends the invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Contact No.";
                Importance=Additional;
                Visible="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 30  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen for en ordre hos denne kreditor.;
                           ENU=Specifies the name of the person to contact about an order from this vendor.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Pay-to Contact";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportmÜden ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method" }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det indfõrselssted, hvor varerne kom ind i landet/omrÜdet, for rapportering til Intrastat.;
                           ENU=Specifies the code of the port of entry where the items pass into your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry Point" }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omrÜde med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 21  ;1   ;Part      ;
                ApplicationArea=#PurchReturnOrder;
                SubPageLink=Table ID=CONST(38),
                            Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.);
                PagePartID=Page9103;
                Visible=OpenApprovalEntriesExistForCurrUser;
                PartType=Page }

    { 1906354007;1;Part   ;
                Name=ApprovalFactBox;
                ApplicationArea=#Advanced;
                PagePartID=Page9092;
                Visible=FALSE;
                PartType=Page }

    { 1901138007;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Buy-from Vendor No.);
                PagePartID=Page9093;
                Visible=FALSE;
                PartType=Page }

    { 1904651607;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Pay-to Vendor No.);
                PagePartID=Page9094;
                PartType=Page }

    { 1903435607;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Buy-from Vendor No.);
                PagePartID=Page9095;
                PartType=Page }

    { 1906949207;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Pay-to Vendor No.);
                PagePartID=Page9096;
                Visible=FALSE;
                PartType=Page }

    { 3   ;1   ;Part      ;
                ApplicationArea=#PurchReturnOrder;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(Document No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9100;
                ProviderID=46;
                PartType=Page }

    { 41  ;1   ;Part      ;
                Name=WorkflowStatus;
                ApplicationArea=#PurchReturnOrder;
                PagePartID=Page1528;
                Visible=ShowWorkflowStatus;
                Enabled=FALSE;
                Editable=FALSE;
                PartType=Page;
                ShowFilter=No }

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
      CopyPurchDoc@1002 : Report 492;
      MoveNegPurchLines@1006 : Report 6698;
      DocPrint@1005 : Codeunit 229;
      ReportPrint@1003 : Codeunit 228;
      UserMgt@1004 : Codeunit 5700;
      ArchiveManagement@1007 : Codeunit 5063;
      PurchCalcDiscByType@1009 : Codeunit 66;
      ChangeExchangeRate@1001 : Page 511;
      ShipToOptions@1018 : 'Default (Vendor Address),Alternate Vendor Address,Custom Address';
      JobQueueVisible@1000 : Boolean INDATASET;
      JobQueueUsed@1016 : Boolean INDATASET;
      DocNoVisible@1008 : Boolean;
      OpenApprovalEntriesExist@1010 : Boolean;
      OpenApprovalEntriesExistForCurrUser@1012 : Boolean;
      ShowWorkflowStatus@1011 : Boolean;
      CanCancelApprovalForRecord@1013 : Boolean;
      DocumentIsPosted@1014 : Boolean;
      OpenPostedPurchaseReturnOrderQst@1015 : TextConst 'DAN=Returvareordren er blevet bogfõrt og flyttet til vinduet Bogfõrte kõbskreditnotaer.\\Vil du Übne den bogfõrte kreditnota?;ENU=The return order has been posted and moved to the Posted Purchase Credit Memos window.\\Do you want to open the posted credit memo?';

    LOCAL PROCEDURE Post@4(PostingCodeunitID@1000 : Integer);
    VAR
      PurchaseHeader@1001 : Record 38;
      InstructionMgt@1002 : Codeunit 1330;
    BEGIN
      SendToPosting(PostingCodeunitID);

      DocumentIsPosted := NOT PurchaseHeader.GET("Document Type","No.");

      IF "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting" THEN
        CurrPage.CLOSE;
      CurrPage.UPDATE(FALSE);

      IF PostingCodeunitID <> CODEUNIT::"Purch.-Post (Yes/No)" THEN
        EXIT;

      IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
        ShowPostedConfirmationMessage;
    END;

    LOCAL PROCEDURE ApproveCalcInvDisc@1();
    BEGIN
      CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
    END;

    LOCAL PROCEDURE PurchaserCodeOnAfterValidate@19046120();
    BEGIN
      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ShortcutDimension1CodeOnAfterV@19029405();
    BEGIN
      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ShortcutDimension2CodeOnAfterV@19008725();
    BEGIN
      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE PricesIncludingVATOnAfterValid@19009096();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE SetDocNoVisible@2();
    VAR
      DocumentNoVisibility@1001 : Codeunit 1400;
      DocType@1000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Reminder,FinChMemo';
    BEGIN
      DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::"Return Order","No.");
    END;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
    BEGIN
      JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";

      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
    END;

    LOCAL PROCEDURE ShowPostedConfirmationMessage@17();
    VAR
      ReturnOrderPurchaseHeader@1003 : Record 38;
      PurchCrMemoHdr@1000 : Record 124;
      InstructionMgt@1002 : Codeunit 1330;
    BEGIN
      IF NOT ReturnOrderPurchaseHeader.GET("Document Type","No.") THEN BEGIN
        PurchCrMemoHdr.SETRANGE("No.","Last Posting No.");
        IF PurchCrMemoHdr.FINDFIRST THEN
          IF InstructionMgt.ShowConfirm(OpenPostedPurchaseReturnOrderQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
            PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
      END;
    END;

    LOCAL PROCEDURE ValidateShippingOption@8();
    BEGIN
      CASE ShipToOptions OF
        ShipToOptions::"Default (Vendor Address)":
          BEGIN
            VALIDATE("Order Address Code",'');
            VALIDATE("Buy-from Vendor No.");
          END;
        ShipToOptions::"Alternate Vendor Address":
          VALIDATE("Order Address Code",'');
      END;
    END;

    LOCAL PROCEDURE CalculateCurrentShippingOption@36();
    BEGIN
      CASE TRUE OF
        "Order Address Code" <> '':
          ShipToOptions := ShipToOptions::"Alternate Vendor Address";
        BuyFromAddressEqualsShipToAddress:
          ShipToOptions := ShipToOptions::"Default (Vendor Address)";
        ELSE
          ShipToOptions := ShipToOptions::"Custom Address";
      END;
    END;

    BEGIN
    END.
  }
}

