OBJECT Page 6630 Sales Return Order
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572,NAVDK11.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Salgsreturvareordre;
               ENU=Sales Return Order];
    SourceTable=Table36;
    SourceTableView=WHERE(Document Type=FILTER(Return Order));
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Godkend,Frigiv,Bogfõring,Forbered,Faktura,Anmod om godkendelse;
                                ENU=New,Process,Report,Approve,Release,Posting,Prepare,Invoice,Request Approval];
    OnInit=VAR
             SalesReceivablesSetup@1000 : Record 311;
           BEGIN
             SellToCustomerUsesOIOUBL := CustomerUsesOIOUBL("Sell-to Customer No.");
             JobQueueUsed := SalesReceivablesSetup.JobQueueActive;
           END;

    OnOpenPage=BEGIN
                 IF UserMgt.GetSalesFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
                   FILTERGROUP(0);
                 END;

                 SetDocNoVisible;
                 IF ("No." <> '') AND ("Sell-to Customer No." = '') THEN
                   DocumentIsPosted := (NOT GET("Document Type","No."));
               END;

    OnAfterGetRecord=BEGIN
                       SetControlAppearance;
                     END;

    OnNewRecord=BEGIN
                  "Responsibility Center" := UserMgt.GetSalesFilter;
                  IF (NOT DocNoVisible) AND ("No." = '') THEN
                    SetSellToCustomerFromFilter;
                END;

    OnInsertRecord=BEGIN
                     IF DocNoVisible THEN
                       CheckCreditMaxBeforeInsert;
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
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
                           SellToCustomerUsesOIOUBL := CustomerUsesOIOUBL("Sell-to Customer No.");
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(RECORDID);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Returvareordre;
                                 ENU=&Return Order];
                      Image=Return }
      { 51      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 Handled@1000 : Boolean;
                               BEGIN
                                 OnBeforeStatisticsAction(Rec,Handled);
                                 IF NOT Handled THEN BEGIN
                                   OpenSalesOrderStatistics;
                                   SalesCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                                 END
                               END;
                                }
      { 52      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om debitoren i salgsbilaget.;
                                 ENU=View or edit detailed information about the customer on the sales document.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Sell-to Customer No.);
                      Promoted=Yes;
                      Enabled=IsCustomerOrContactNotEmpty;
                      PromotedIsBig=No;
                      Image=EditLines;
                      PromotedOnly=Yes }
      { 105     ;2   ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Promoted=No;
                      Enabled="No." <> '';
                      PromotedIsBig=No;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 140     ;2   ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1000 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Sales Header","Document Type","No.");
                               END;
                                }
      { 53      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=CONST(Return Order),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 5801    ;2   ;Action    ;
                      CaptionML=[DAN=Returvaremodtagelse;
                                 ENU=Return Receipts];
                      ToolTipML=[DAN=Vis en liste over bogfõrte returvaremodtagelser for ordren.;
                                 ENU=View a list of posted return receipts for the order.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 6662;
                      RunPageView=SORTING(Return Order No.);
                      RunPageLink=Return Order No.=FIELD(No.);
                      Image=ReturnReceipt }
      { 5802    ;2   ;Action    ;
                      CaptionML=[DAN=Kred&itnotaer;
                                 ENU=Cred&it Memos];
                      ToolTipML=[DAN=Vis en liste med igangvërende kreditnotaer for ordren.;
                                 ENU=View a list of ongoing credit memos for the order.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 144;
                      RunPageView=SORTING(Return Order No.);
                      RunPageLink=Return Order No.=FIELD(No.);
                      Image=CreditMemo }
      { 131     ;2   ;Separator  }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 130     ;2   ;Action    ;
                      CaptionML=[DAN=L&ëg-pÜ-lager/pluklinjer (lag.);
                                 ENU=In&vt. Put-away/Pick Lines];
                      ToolTipML=[DAN=FÜ vist ind- eller udgÜende varer pÜ lëg-pÜ-lager- eller lagerplukningsbilag for overflytningsordren.;
                                 ENU=View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5774;
                      RunPageView=SORTING(Source Document,Source No.,Location Code);
                      RunPageLink=Source Document=CONST(Sales Return Order),
                                  Source No.=FIELD(No.);
                      Image=PickLines }
      { 120     ;2   ;Action    ;
                      CaptionML=[DAN=Lagermodtagelseslinjer;
                                 ENU=Whse. Receipt Lines];
                      ToolTipML=[DAN=Vis igangvërende lagermodtagelser for bilaget, i avancerede lageropsëtninger.;
                                 ENU=View ongoing warehouse receipts for the document, in advanced warehouse configurations.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7342;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(37),
                                  Source Subtype=FIELD(Document Type),
                                  Source No.=FIELD(No.);
                      Image=ReceiptLines }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 27      ;2   ;Action    ;
                      Name=Approve;
                      CaptionML=[DAN=Godkend;
                                 ENU=Approve];
                      ToolTipML=[DAN=Godkend de anmodede ëndringer.;
                                 ENU=Approve the requested changes.];
                      ApplicationArea=#SalesReturnOrder;
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
      { 25      ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Afvis;
                                 ENU=Reject];
                      ToolTipML=[DAN=Afvis godkendelsesanmodningen.;
                                 ENU=Reject the approval request.];
                      ApplicationArea=#SalesReturnOrder;
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
      { 23      ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsen til en stedfortrëdende godkender.;
                                 ENU=Delegate the approval to a substitute approver.];
                      ApplicationArea=#SalesReturnOrder;
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
      { 21      ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bemërkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#All;
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
      { 119     ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Gõr dig klar til at udskrive bilaget. Der Übnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages pÜ udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 DocPrint.PrintSalesHeader(Rec);
                               END;
                                }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 112     ;2   ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleaseSalesDoc@1000 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 113     ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen for at ëndre det, efter at det er blevet godkendt. Godkendte bilag har status Frigivet og skal Übnes, fõr de kan ëndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Enabled=Status <> Status::Open;
                      Image=ReOpen;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleaseSalesDoc@1001 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 600     ;2   ;Separator  }
      { 54      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 55      ;2   ;Action    ;
                      Name=CalculateInvoiceDiscount;
                      AccessByPermission=TableData 19=R;
                      CaptionML=[DAN=&Beregn fakturarabat;
                                 ENU=Calculate &Invoice Discount];
                      ToolTipML=[DAN=Beregn fakturarabatten for salgsreturordren.;
                                 ENU=Calculate the invoice discount that applies to the sales return order.];
                      ApplicationArea=#SalesReturnOrder;
                      Image=CalculateInvoiceDiscount;
                      OnAction=BEGIN
                                 ApproveCalcInvDisc;
                                 SalesCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 132     ;2   ;Separator  }
      { 93      ;2   ;Action    ;
                      ShortCutKey=Shift+F11;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udlign;
                                 ENU=Apply Entries];
                      ToolTipML=[DAN=Vëlg en eller flere finansposter, denne record skal anvendes pÜ, sÜ de relaterede, bogfõrte dokumenter lukkes som betalte eller refunderede.;
                                 ENU=Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Image=ApplyEntries;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Sales Header Apply",Rec);
                               END;
                                }
      { 115     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Opret returrelaterede dokumenter;
                                 ENU=Create Return-Related &Documents];
                      ToolTipML=[DAN=Forbered dig pÜ at fÜ oprettet relaterede bilag automatisk, f.eks. en erstatningssalgsordre, en kõbsreturvareordre eller en erstatningskõbsordre.;
                                 ENU=Prepare to automatically create related documents, such as a replacement sales order, a purchase return order, or a replacement purchase order.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Image=ApplyEntries;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CLEAR(CreateRetRelDocs);
                                 CreateRetRelDocs.SetSalesHeader(Rec);
                                 CreateRetRelDocs.RUNMODAL;
                                 CreateRetRelDocs.ShowDocuments;
                               END;
                                }
      { 133     ;2   ;Separator  }
      { 56      ;2   ;Action    ;
                      Name=CopyDocument;
                      Ellipsis=Yes;
                      CaptionML=[DAN=KopiÇr dokument;
                                 ENU=Copy Document];
                      ToolTipML=[DAN=KopiÇr linjer og sidehovedoplysninger fra et andet salgsbilag til dette bilag. Du kan kopiere en bogfõrt salgsfaktura til en ny salgsfaktura, hvis du hurtigt vil oprette et lignende bilag.;
                                 ENU=Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.];
                      ApplicationArea=#Suite;
                      Image=CopyDocument;
                      OnAction=BEGIN
                                 CopySalesDoc.SetSalesHeader(Rec);
                                 CopySalesDoc.RUNMODAL;
                                 CLEAR(CopySalesDoc);
                                 IF GET("Document Type","No.") THEN;
                               END;
                                }
      { 118     ;2   ;Action    ;
                      Name=MoveNegativeLines;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Flyt negative linjer;
                                 ENU=Move Negative Lines];
                      ToolTipML=[DAN=Gõr dig klar til at oprette en erstatningssalgsordre i en salgsreturproces.;
                                 ENU=Prepare to create a replacement sales order in a sales return process.];
                      ApplicationArea=#SalesReturnOrder;
                      Image=MoveNegativeLines;
                      OnAction=BEGIN
                                 CLEAR(MoveNegSalesLines);
                                 MoveNegSalesLines.SetSalesHeader(Rec);
                                 MoveNegSalesLines.RUNMODAL;
                                 MoveNegSalesLines.ShowDocument;
                               END;
                                }
      { 62      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden fërdiggõres og forberedes til udskrivning. Vërdierne og antallene bogfõres pÜ de relaterede konti. Du fÜr vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Sales-Post + Print");
                               END;
                                }
      { 139     ;2   ;Action    ;
                      Name=GetPostedDocumentLinesToReverse;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent bogfõrte bilagslinje&r, der skal tilbagefõres;
                                 ENU=Get Posted Doc&ument Lines to Reverse];
                      ToolTipML=[DAN=KopiÇr en eller flere bogfõrte salgsbilagslinjer for at tilbagefõre den oprindelige ordre.;
                                 ENU=Copy one or more posted sales document lines in order to reverse the original order.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReverseLines;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 GetPstdDocLinesToRevere;
                               END;
                                }
      { 145     ;2   ;Action    ;
                      CaptionML=[DAN=Arkiver dokument;
                                 ENU=Archive Document];
                      ToolTipML=[DAN=Send bilaget til arkivet, f.eks. fordi det er for tidligt at slette det. Senere skal du slette eller genbehandle det arkiverede bilag.;
                                 ENU=Send the document to the archive, for example because it is too soon to delete it. Later, you delete or reprocess the archived document.];
                      ApplicationArea=#Advanced;
                      Image=Archive;
                      OnAction=BEGIN
                                 ArchiveManagement.ArchiveSalesDocument(Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 31      ;2   ;Action    ;
                      AccessByPermission=TableData 410=R;
                      CaptionML=[DAN=Send IC-returvareordrebekrëftelse;
                                 ENU=Send IC Return Order Cnfmn.];
                      ApplicationArea=#Intercompany;
                      Image=IntercompanyOrder;
                      OnAction=VAR
                                 ICInOutboxMgt@1000 : Codeunit 427;
                                 ApprovalsMgmt@1003 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
                                   ICInOutboxMgt.SendSalesDoc(Rec,FALSE);
                               END;
                                }
      { 135     ;2   ;Separator  }
      { 61      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Bogfõr;
                                 ENU=P&ost];
                      ToolTipML=[DAN=Fërdiggõr bilaget eller kladden ved at bogfõre belõb og antal pÜ de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Sales-Post (Yes/No)");
                               END;
                                }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Vis bogfõring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, nÜr du bogfõrer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Image=ViewPostedOrder;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowPreview;
                               END;
                                }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 136     ;2   ;Separator  }
      { 122     ;2   ;Action    ;
                      AccessByPermission=TableData 7316=R;
                      CaptionML=[DAN=Opr&et lagermodtagelse;
                                 ENU=Create &Whse. Receipt];
                      ToolTipML=[DAN=Opret en lagermodtagelse for at starte en lëg-pÜ-lager-proces i henhold til en avanceret lageropsëtning.;
                                 ENU=Create a warehouse receipt to start a receive and put-away process according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=NewReceipt;
                      OnAction=VAR
                                 GetSourceDocInbound@1000 : Codeunit 5751;
                               BEGIN
                                 GetSourceDocInbound.CreateFromSalesReturnOrder(Rec);
                               END;
                                }
      { 121     ;2   ;Action    ;
                      AccessByPermission=TableData 7340=R;
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
      { 30      ;2   ;Separator  }
      { 59      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&osting];
                      Image=Post }
      { 60      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, sÜ du kan finde og rette eventuelle fejl, fõr du udfõrer den faktiske bogfõring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#SalesReturnOrder;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintSalesHeader(Rec);
                               END;
                                }
      { 63      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Massebogfõr;
                                 ENU=Post &Batch];
                      ToolTipML=[DAN=Bogfõr flere bilag pÜ Çn gang. Der Übnes et anmodningsvindue, hvor du kan angive, hvilke bilag der skal bogfõres.;
                                 ENU=Post several documents at once. A report request window opens where you can specify which documents to post.];
                      ApplicationArea=#Advanced;
                      Promoted=No;
                      Image=PostBatch;
                      PromotedOnly=No;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Batch Post Sales Return Orders",TRUE,TRUE,Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 3       ;2   ;Action    ;
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
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 142     ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send go&dkendelsesanmodning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af bilaget.;
                                 ENU=Request approval of the document.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckSalesApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                               END;
                                }
      { 143     ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesan&modning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord;
                      PromotedIsBig=Yes;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
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
                ApplicationArea=#All;
                SourceExpr="No.";
                Visible=DocNoVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 41  ;2   ;Field     ;
                CaptionML=[DAN=Debitornr.;
                           ENU=Customer No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, der er tilknyttet salgsreturvaren.;
                           ENU=Specifies the number of the customer associated with the sales return.];
                ApplicationArea=#SalesReturnOrder;
                NotBlank=Yes;
                SourceExpr="Sell-to Customer No.";
                Importance=Additional;
                OnValidate=BEGIN
                             SelltoCustomerNoOnAfterValidate(Rec,xRec);
                             CurrPage.UPDATE;
                           END;
                            }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Debitornavn;
                           ENU=Customer Name];
                ToolTipML=[DAN=Angiver navnet pÜ debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Customer Name";
                Importance=Promoted;
                OnValidate=BEGIN
                             SelltoCustomerNoOnAfterValidate(Rec,xRec);

                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);

                             SellToCustomerUsesOIOUBL := CustomerUsesOIOUBL("Sell-to Customer No.");

                             CurrPage.UPDATE;
                           END;

                ShowMandatory=TRUE }

    { 35  ;2   ;Group     ;
                CaptionML=[DAN=Kunde;
                           ENU=Sell-to];
                GroupType=Group }

    { 65  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver debitorens adresse.;
                           ENU=Specifies the customer's address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Address";
                Importance=Additional }

    { 67  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af debitorens adresse.;
                           ENU=Specifies an additional part of the customer's address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Address 2";
                Importance=Additional }

    { 70  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret i debitorens adresse.;
                           ENU=Specifies the postal code of the customer's address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Post Code";
                Importance=Additional }

    { 69  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen i debitorens adresse.;
                           ENU=Specifies the city of the customer's address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to City";
                Importance=Additional }

    { 117 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the number of the contact person at the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact No.";
                Importance=Additional;
                OnValidate=BEGIN
                             IF GETFILTER("Sell-to Contact No.") = xRec."Sell-to Contact No." THEN
                               IF "Sell-to Contact No." <> xRec."Sell-to Contact No." THEN
                                 SETRANGE("Sell-to Contact No.");
                           END;

                ShowMandatory=SellToCustomerUsesOIOUBL }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the name of the contact person at the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Contact";
                Editable="Sell-to Customer No." <> '' }

    { 1101100003;2;Field  ;
                CaptionML=[DAN=Kontaktens telefonnummer;
                           ENU=Contact Phone No.];
                ToolTipML=[DAN=Angiver telefonnummeret pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the telephone number of the contact person at the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Contact Phone No." }

    { 1101100004;2;Field  ;
                CaptionML=[DAN=Kontaktens faxnummer;
                           ENU=Contact Fax No.];
                ToolTipML=[DAN="Angiver faxnummeret pÜ kontaktpersonen hos debitoren. ";
                           ENU="Specifies the fax number of the contact person at the customer. "];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Contact Fax No." }

    { 1101100006;2;Field  ;
                CaptionML=[DAN=Kontaktens mailadresse;
                           ENU=Contact Email];
                ToolTipML=[DAN=Angiver mailadressen pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the email address of the contact person at the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Contact E-Mail" }

    { 1101100009;2;Field  ;
                CaptionML=[DAN=Kontaktens rolle;
                           ENU=Contact Role];
                ToolTipML=[DAN=Angiver rollen for kontaktpersonen hos debitoren.;
                           ENU=Specifies the role of the contact person at the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Contact Role" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Document Date";
                Importance=Additional }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor salgsbilaget blev bogfõrt.;
                           ENU=Specifies the date when the sales document was posted.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Posting Date";
                Importance=Promoted }

    { 125 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ordren blev oprettet.;
                           ENU=Specifies the date when the order was created.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Order Date";
                Importance=Promoted;
                QuickEntry=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="External Document No.";
                Importance=Promoted;
                ShowMandatory=SellToCustomerUsesOIOUBL }

    { 147 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange arkiverede versioner der findes af dette bilag.;
                           ENU=Specifies the number of archived versions for this document.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Archived Versions" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den sëlger, der er tildelt til debitoren.;
                           ENU=Specifies the name of the salesperson who is assigned to the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Salesperson Code";
                Importance=Additional;
                OnValidate=BEGIN
                             SalespersonCodeOnAfterValidate;
                           END;

                QuickEntry=FALSE }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kampagne, bilaget er knyttet til.;
                           ENU=Specifies the campaign number the document is linked to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Campaign No." }

    { 107 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 141 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Assigned User ID" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for en opgavekõpost eller opgave, der hÜndterer bogfõring af salgsreturvareordrer.;
                           ENU=Specifies the status of a job queue entry or task that handles the posting of sales return orders.];
                ApplicationArea=#All;
                SourceExpr="Job Queue Status";
                Importance=Additional;
                Visible=JobQueueUsed }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bilaget er Übent, venter pÜ godkendelse, er faktureret til forudbetaling eller er frigivet til nëste fase i behandlingen.;
                           ENU=Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Status;
                Importance=Promoted;
                QuickEntry=FALSE }

    { 48  ;1   ;Part      ;
                Name=SalesLines;
                ApplicationArea=#SalesReturnOrder;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page6631;
                Enabled="Sell-to Customer No." <> '';
                Editable="Sell-to Customer No." <> '';
                PartType=Page;
                UpdatePropagation=Both }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Currency Code";
                Importance=Promoted;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
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

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             PricesIncludingVATOnAfterValid;
                           END;
                            }

    { 137 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="VAT Bus. Posting Group" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget reprësenterer med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Transaction Type" }

    { 74  ;2   ;Field     ;
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

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipment Date";
                Importance=Promoted }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogfõrt bilag, som dette bilag eller denne kladdelinje udlignes med, nÜr du bogfõrer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Applies-to Doc. Type";
                Importance=Promoted }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det bogfõrte bilag, som dette bilag eller denne kladdelinje udlignes pÜ, nÜr du bogfõrer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Applies-to Doc. No.";
                Importance=Promoted }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id for poster, der udlignes, nÜr du vëlger handlingen Udlign poster.;
                           ENU=Specifies the ID of entries that will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Applies-to ID" }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Forsendelse og fakturering;
                           ENU=Shipping and Billing];
                GroupType=Group }

    { 47  ;2   ;Group     ;
                CaptionML=[DAN=Leveringsform;
                           ENU=Shipment Method];
                GroupType=Group }

    { 45  ;3   ;Field     ;
                CaptionML=[DAN=Speditõr;
                           ENU=Agent];
                ToolTipML=[DAN=Angiver, hvilken speditõr der bruges til at transportere varerne pÜ salgsbilaget til debitoren.;
                           ENU=Specifies which shipping agent is used to transport the items on the sales document to the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipping Agent Code";
                Importance=Additional }

    { 43  ;3   ;Field     ;
                CaptionML=[DAN=Speditõrservice;
                           ENU=Agent Service];
                ToolTipML=[DAN=Angiver, hvilken speditõrservice der bruges til at transportere varerne pÜ salgsbilaget til debitoren.;
                           ENU=Specifies which shipping agent service is used to transport the items on the sales document to the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipping Agent Service Code";
                Importance=Additional }

    { 4   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver speditõrens pakkenummer.;
                           ENU=Specifies the shipping agent's package number.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Package Tracking No.";
                Importance=Additional }

    { 18  ;2   ;Group     ;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                GroupType=Group }

    { 50  ;3   ;Field     ;
                CaptionML=[DAN=Sted;
                           ENU=Location];
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren pÜ salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Location Code";
                Importance=Promoted }

    { 32  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet, som produkter i salgsbilaget skal leveres til.;
                           ENU=Specifies the name that products on the sales document will be shipped to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Name" }

    { 34  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som produkter i salgsbilaget skal leveres til.;
                           ENU=Specifies the address that products on the sales document will be shipped to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Address" }

    { 36  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen.;
                           ENU=Specifies an additional part of the shipping address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Address 2" }

    { 83  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret i leveringsadressen.;
                           ENU=Specifies the postal code of the shipping address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Post Code" }

    { 38  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen i leveringsadressen.;
                           ENU=Specifies the city of the shipping address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to City" }

    { 40  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ leveringsadressen.;
                           ENU=Specifies the name of the contact person at the shipping address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Contact" }

    { 37  ;2   ;Group     ;
                CaptionML=[DAN=Faktureres til;
                           ENU=Bill-to];
                GroupType=Group }

    { 20  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver den debitor, du vil sende salgsfakturaen til, nÜr det er til en anden debitor end den, du sëlger til.;
                           ENU=Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Name";
                Importance=Promoted;
                OnValidate=BEGIN
                             IF GETFILTER("Bill-to Customer No.") = xRec."Bill-to Customer No." THEN
                               IF "Bill-to Customer No." <> xRec."Bill-to Customer No." THEN
                                 SETRANGE("Bill-to Customer No.");

                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);

                             CurrPage.UPDATE;
                           END;
                            }

    { 22  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den debitor, som du vil sende fakturaen til.;
                           ENU=Specifies the address of the customer that you will send the invoice to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Address";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 24  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af faktureringsadressen.;
                           ENU=Specifies an additional part of the billing address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Address 2";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 75  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret i faktureringsadressen.;
                           ENU=Specifies the postal code of the billing address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Post Code";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 26  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen i faktureringsadressen.;
                           ENU=Specifies the city of the billing address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to City";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 128 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonen pÜ faktureringsadressen.;
                           ENU=Specifies the number of the contact person at the billing address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Contact No.";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 28  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ faktureringsadressen.;
                           ENU=Specifies the name of the contact person at the billing address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Contact" }

    { 1101100012;2;Field  ;
                ToolTipML=[DAN=Angiver EAN-lokationsnummeret for debitoren.;
                           ENU=Specifies the EAN location number for the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="EAN No." }

    { 1101100014;2;Field  ;
                ToolTipML=[DAN=Angiver kontokoden for debitoren.;
                           ENU=Specifies the account code of the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Account Code";
                OnValidate=BEGIN
                             AccountCodeOnAfterValidate;
                           END;
                            }

    { 1060000;2;Field     ;
                ToolTipML=[DAN=Angiver betalingsmetoden Offentlig Information Online UBL (OIOUBL) for bilaget.;
                           ENU=Specifies the Offentlig Information Online UBL (OIOUBL) payment method for the document.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Payment Channel";
                ShowMandatory=SellToCustomerUsesOIOUBL }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="EU 3-Party Trade" }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Transaction Specification" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportmÜden ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Transport Method" }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udfõrselssted, hvor varerne blev udfõrt af landet/omrÜdet med henblik pÜ rapportering til Intrastat.;
                           ENU=Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Exit Point" }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omrÜde med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Area }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 19  ;1   ;Part      ;
                ApplicationArea=#SalesReturnOrder;
                SubPageLink=Table ID=CONST(36),
                            Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.);
                PagePartID=Page9103;
                Visible=OpenApprovalEntriesExistForCurrUser;
                PartType=Page }

    { 1903720907;1;Part   ;
                ApplicationArea=#SalesReturnOrder;
                SubPageLink=No.=FIELD(Sell-to Customer No.);
                PagePartID=Page9080;
                PartType=Page }

    { 1907234507;1;Part   ;
                ApplicationArea=#SalesReturnOrder;
                SubPageLink=No.=FIELD(Sell-to Customer No.);
                PagePartID=Page9081;
                Visible=FALSE;
                PartType=Page }

    { 1902018507;1;Part   ;
                ApplicationArea=#SalesReturnOrder;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9082;
                Visible=FALSE;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#SalesReturnOrder;
                SubPageLink=No.=FIELD(Sell-to Customer No.);
                PagePartID=Page9084;
                PartType=Page }

    { 1906127307;1;Part   ;
                ApplicationArea=#SalesReturnOrder;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(Document No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9087;
                ProviderID=48;
                Visible=FALSE;
                PartType=Page }

    { 1906354007;1;Part   ;
                Name=ApprovalFactBox;
                ApplicationArea=#SalesReturnOrder;
                PagePartID=Page9092;
                Visible=FALSE;
                PartType=Page }

    { 1907012907;1;Part   ;
                ApplicationArea=#SalesReturnOrder;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page9108;
                ProviderID=48;
                Visible=FALSE;
                PartType=Page }

    { 33  ;1   ;Part      ;
                Name=WorkflowStatus;
                ApplicationArea=#SalesReturnOrder;
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
      ApplicationAreaSetup@1022 : Record 9178;
      CopySalesDoc@1003 : Report 292;
      MoveNegSalesLines@1009 : Report 6699;
      CreateRetRelDocs@1000 : Report 6697;
      ReportPrint@1004 : Codeunit 228;
      DocPrint@1008 : Codeunit 229;
      UserMgt@1005 : Codeunit 5700;
      ArchiveManagement@1006 : Codeunit 5063;
      SalesCalcDiscByType@1010 : Codeunit 56;
      ChangeExchangeRate@1002 : Page 511;
      JobQueueVisible@1001 : Boolean INDATASET;
      JobQueueUsed@1017 : Boolean INDATASET;
      DocNoVisible@1007 : Boolean;
      SellToCustomerUsesOIOUBL@1060000 : Boolean;
      OpenApprovalEntriesExistForCurrUser@1015 : Boolean;
      OpenApprovalEntriesExist@1014 : Boolean;
      ShowWorkflowStatus@1011 : Boolean;
      CanCancelApprovalForRecord@1012 : Boolean;
      DocumentIsPosted@1013 : Boolean;
      OpenPostedSalesReturnOrderQst@1016 : TextConst 'DAN=Returvareordren er blevet bogfõrt og flyttet til vinduet Bogfõrte salgskreditnotaer.\\Vil du Übne den bogfõrte kreditnota?;ENU=The return order has been posted and moved to the Posted Sales Credit Memos window.\\Do you want to open the posted credit memo?';
      IsCustomerOrContactNotEmpty@1018 : Boolean;

    LOCAL PROCEDURE Post@4(PostingCodeunitID@1000 : Integer);
    VAR
      SalesHeader@1001 : Record 36;
      InstructionMgt@1002 : Codeunit 1330;
    BEGIN
      SendToPosting(PostingCodeunitID);

      DocumentIsPosted := NOT SalesHeader.GET("Document Type","No.");

      IF "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting" THEN
        CurrPage.CLOSE;
      CurrPage.UPDATE(FALSE);

      IF PostingCodeunitID <> CODEUNIT::"Sales-Post (Yes/No)" THEN
        EXIT;

      IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
        ShowPostedConfirmationMessage;
    END;

    LOCAL PROCEDURE ApproveCalcInvDisc@1();
    BEGIN
      CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    END;

    LOCAL PROCEDURE SalespersonCodeOnAfterValidate@19011896();
    BEGIN
      CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ShortcutDimension1CodeOnAfterV@19029405();
    BEGIN
      CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ShortcutDimension2CodeOnAfterV@19008725();
    BEGIN
      CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE PricesIncludingVATOnAfterValid@19009096();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE AccountCodeOnAfterValidate@19007267();
    BEGIN
      CurrPage.SalesLines.PAGE.UpdateForm(TRUE)
    END;

    LOCAL PROCEDURE SetDocNoVisible@2();
    VAR
      DocumentNoVisibility@1001 : Codeunit 1400;
      DocType@1000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Reminder,FinChMemo';
    BEGIN
      DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::"Return Order","No.");
    END;

    LOCAL PROCEDURE CustomerUsesOIOUBL@1060002(CustomerNo@1060000 : Code[20]) : Boolean;
    VAR
      Customer@1060001 : Record 18;
    BEGIN
      IF Customer.GET(CustomerNo) THEN
        EXIT (Customer."OIOUBL Profile Code" <> '');
      EXIT(FALSE)
    END;

    [Internal]
    PROCEDURE ShowPreview@3();
    VAR
      SalesPostYesNo@1001 : Codeunit 81;
    BEGIN
      SalesPostYesNo.Preview(Rec);
    END;

    LOCAL PROCEDURE SetControlAppearance@6();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
    BEGIN
      JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";

      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
      IsCustomerOrContactNotEmpty := ("Sell-to Customer No." <> '') OR ("Sell-to Contact No." <> '');
    END;

    LOCAL PROCEDURE ShowPostedConfirmationMessage@17();
    VAR
      ReturnOrderSalesHeader@1003 : Record 36;
      SalesCrMemoHeader@1000 : Record 114;
      InstructionMgt@1002 : Codeunit 1330;
    BEGIN
      IF NOT ReturnOrderSalesHeader.GET("Document Type","No.") THEN BEGIN
        SalesCrMemoHeader.SETRANGE("No.","Last Posting No.");
        IF SalesCrMemoHeader.FINDFIRST THEN
          IF InstructionMgt.ShowConfirm(OpenPostedSalesReturnOrderQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
            PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
      END;
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeStatisticsAction@5(VAR SalesHeader@1000 : Record 36;VAR Handled@1001 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

