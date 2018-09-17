OBJECT Page 50 Purchase Order
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kõbsordre;
               ENU=Purchase Order];
    SourceTable=Table38;
    SourceTableView=WHERE(Document Type=FILTER(Order));
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Godkend,Frigiv,Bogfõring,Forbered,Faktura,Anmod om godkendelse,Udskriv;
                                ENU=New,Process,Report,Approve,Release,Posting,Prepare,Invoice,Request Approval,Print];
    OnInit=VAR
             PurchasesPayablesSetup@1000 : Record 312;
             DummyApplicationAreaSetup@1001 : Record 9178;
           BEGIN
             JobQueueUsed := PurchasesPayablesSetup.JobQueueActive;
             SetExtDocNoMandatoryCondition;
             ShowShippingOptionsWithLocation := DummyApplicationAreaSetup.IsLocationEnabled OR DummyApplicationAreaSetup.IsAllDisabled;
           END;

    OnOpenPage=VAR
                 PermissionManager@1000 : Codeunit 9002;
               BEGIN
                 SetDocNoVisible;
                 IsSaaS := PermissionManager.SoftwareAsAService;

                 IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
                   FILTERGROUP(0);
                 END;
                 IF ("No." <> '') AND ("Buy-from Vendor No." = '') THEN
                   DocumentIsPosted := (NOT GET("Document Type","No."));
               END;

    OnAfterGetRecord=BEGIN
                       CalculateCurrentShippingAndPayToOption;
                     END;

    OnNewRecord=BEGIN
                  "Responsibility Center" := UserMgt.GetPurchasesFilter;

                  IF (NOT DocNoVisible) AND ("No." = '') THEN
                    SetBuyFromVendorFromFilter;

                  CalculateCurrentShippingAndPayToOption;
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
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 61      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Ordre;
                                 ENU=O&rder];
                      Image=Order }
      { 129     ;2   ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=No;
                      Enabled="No." <> '';
                      PromotedIsBig=No;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 63      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 OpenPurchaseOrderStatistics;
                                 PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 64      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kreditor;
                                 ENU=Vendor];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om kreditoren i kõbsbilaget.;
                                 ENU=View or edit detailed information about the vendor on the purchase document.];
                      ApplicationArea=#Suite;
                      RunObject=Page 26;
                      RunPageLink=No.=FIELD(Buy-from Vendor No.);
                      Promoted=No;
                      Enabled="Buy-from Vendor No." <> '';
                      PromotedIsBig=No;
                      Image=EditLines }
      { 53      ;2   ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Image=Approvals;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1001 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Purchase Header","Document Type","No.");
                               END;
                                }
      { 65      ;2   ;Action    ;
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
      { 66      ;2   ;Action    ;
                      CaptionML=[DAN=Modtagelser;
                                 ENU=Receipts];
                      ToolTipML=[DAN=Vis en liste over bogfõrte kõbsmodtagelser for ordren.;
                                 ENU=View a list of posted purchase receipts for the order.];
                      ApplicationArea=#Suite;
                      RunObject=Page 145;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Image=PostedReceipts }
      { 67      ;2   ;Action    ;
                      CaptionML=[DAN=Fakturaer;
                                 ENU=Invoices];
                      ToolTipML=[DAN=Vis en liste med igangvërende kõbsfakturaer for ordren.;
                                 ENU=View a list of ongoing purchase invoices for the order.];
                      ApplicationArea=#Suite;
                      RunObject=Page 146;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Promoted=No;
                      PromotedIsBig=No;
                      Image=Invoice }
      { 205     ;2   ;Action    ;
                      Name=PostedPrepaymentInvoices;
                      CaptionML=[DAN=For&udbetalingsfakturaer;
                                 ENU=Prepa&yment Invoices];
                      ToolTipML=[DAN="Vis relaterede bogfõrte salgsfakturaer, der vedrõrer en forudbetaling. ";
                                 ENU="View related posted sales invoices that involve a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 146;
                      RunPageView=SORTING(Prepayment Order No.);
                      RunPageLink=Prepayment Order No.=FIELD(No.);
                      Image=PrepaymentInvoice }
      { 206     ;2   ;Action    ;
                      Name=PostedPrepaymentCrMemos;
                      CaptionML=[DAN=Forudbetalingskredi&tnotaer;
                                 ENU=Prepayment Credi&t Memos];
                      ToolTipML=[DAN="Vis relaterede bogfõrte kreditnotaer, der vedrõrer en forudbetaling. ";
                                 ENU="View related posted sales credit memos that involve a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 147;
                      RunPageView=SORTING(Prepayment Order No.);
                      RunPageLink=Prepayment Order No.=FIELD(No.);
                      Image=PrepaymentCreditMemo }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 181     ;2   ;Separator  }
      { 180     ;2   ;Action    ;
                      CaptionML=[DAN=L&ëg-pÜ-lager/pluklinjer (lag.);
                                 ENU=In&vt. Put-away/Pick Lines];
                      ToolTipML=[DAN=FÜ vist ind- eller udgÜende varer pÜ lëg-pÜ-lager- eller lagerplukningsbilag for overflytningsordren.;
                                 ENU=View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5774;
                      RunPageView=SORTING(Source Document,Source No.,Location Code);
                      RunPageLink=Source Document=CONST(Purchase Order),
                                  Source No.=FIELD(No.);
                      Image=PickLines }
      { 148     ;2   ;Action    ;
                      CaptionML=[DAN=Lagermodtagelseslinjer;
                                 ENU=Whse. Receipt Lines];
                      ToolTipML=[DAN=Vis igangvërende lagermodtagelser for bilaget, i avancerede lageropsëtninger.;
                                 ENU=View ongoing warehouse receipts for the document, in advanced warehouse configurations.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7342;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(39),
                                  Source Subtype=FIELD(Document Type),
                                  Source No.=FIELD(No.);
                      Image=ReceiptLines }
      { 182     ;2   ;Separator  }
      { 183     ;2   ;ActionGroup;
                      CaptionML=[DAN=Di&rekte levering;
                                 ENU=Dr&op Shipment];
                      Image=Delivery }
      { 226     ;3   ;Action    ;
                      Name=Warehouse_GetSalesOrder;
                      CaptionML=[DAN=Hent &salgsordre;
                                 ENU=Get &Sales Order];
                      ToolTipML=[DAN="Vëlg den salgsordre, der skal sammenkëdes med kõbsordren ved direkte levering eller specialordrer. ";
                                 ENU="Select the sales order that must be linked to the purchase order, for drop shipment or special order. "];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 76;
                      Image=Order }
      { 227     ;2   ;ActionGroup;
                      CaptionML=[DAN=Spe&cialordre;
                                 ENU=Speci&al Order];
                      Image=SpecialOrder }
      { 228     ;3   ;Action    ;
                      AccessByPermission=TableData 110=R;
                      CaptionML=[DAN=Hent &salgsordre;
                                 ENU=Get &Sales Order];
                      ToolTipML=[DAN="Vëlg den salgsordre, der skal sammenkëdes med kõbsordren ved direkte levering eller specialordrer. ";
                                 ENU="Select the sales order that must be linked to the purchase order, for drop shipment or special order. "];
                      ApplicationArea=#Advanced;
                      Image=Order;
                      OnAction=VAR
                                 PurchHeader@1000 : Record 38;
                                 DistIntegration@1001 : Codeunit 5702;
                               BEGIN
                                 PurchHeader.COPY(Rec);
                                 DistIntegration.GetSpecialOrders(PurchHeader);
                                 Rec := PurchHeader;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 37      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 35      ;2   ;Action    ;
                      Name=Approve;
                      CaptionML=[DAN=Godkend;
                                 ENU=Approve];
                      ToolTipML=[DAN=Godkend de anmodede ëndringer.;
                                 ENU=Approve the requested changes.];
                      ApplicationArea=#Suite;
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
      { 33      ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Afvis;
                                 ENU=Reject];
                      ToolTipML=[DAN=Afvis de anmodede ëndringer.;
                                 ENU=Reject the requested changes.];
                      ApplicationArea=#Suite;
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
      { 31      ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger de anmodede ëndringer til den stedfortrëdende godkender.;
                                 ENU=Delegate the requested changes to the substitute approver.];
                      ApplicationArea=#Suite;
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
      { 29      ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bemërkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Suite;
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
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 73      ;2   ;Separator  }
      { 137     ;2   ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ReleasePurchDoc@1000 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 138     ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen for at ëndre det, efter at det er blevet godkendt. Godkendte bilag har status Frigivet og skal Übnes, fõr de kan ëndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=Status <> Status::Open;
                      Image=ReOpen;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 ReleasePurchDoc@1001 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 611     ;2   ;Separator  }
      { 68      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 69      ;2   ;Action    ;
                      Name=CalculateInvoiceDiscount;
                      AccessByPermission=TableData 24=R;
                      CaptionML=[DAN=&Beregn fakturarabat;
                                 ENU=Calculate &Invoice Discount];
                      ToolTipML=[DAN=Beregn den rabat, der kan tildeles, pÜ grundlag af alle linjer i kõbsbilaget.;
                                 ENU=Calculate the discount that can be granted based on all lines in the purchase document.];
                      ApplicationArea=#Suite;
                      Image=CalculateInvoiceDiscount;
                      OnAction=BEGIN
                                 ApproveCalcInvDisc;
                                 PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 190     ;2   ;Separator  }
      { 179     ;2   ;Action    ;
                      Name=GetRecurringPurchaseLines;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent tilbagevendende kõbslinjer;
                                 ENU=Get Recurring Purchase Lines];
                      ToolTipML=[DAN=Indsët kõbsbilagslinjer, som du har angivet for kreditoren som tilbagevendende. Tilbagevendende kõbslinjer kan vëre en mÜnedlig genbestillingsordre eller en fast fragtudgift.;
                                 ENU=Insert purchase document lines that you have set up for the vendor as recurring. Recurring purchase lines could be for a monthly replenishment order or a fixed freight expense.];
                      ApplicationArea=#Suite;
                      Image=VendorCode;
                      OnAction=VAR
                                 StdVendPurchCode@1000 : Record 175;
                               BEGIN
                                 StdVendPurchCode.InsertPurchLines(Rec);
                               END;
                                }
      { 75      ;2   ;Separator  }
      { 70      ;2   ;Action    ;
                      Name=CopyDocument;
                      Ellipsis=Yes;
                      CaptionML=[DAN=KopiÇr dokument;
                                 ENU=Copy Document];
                      ToolTipML=[DAN=KopiÇr dokumentlinjer og sidehovedoplysninger fra et andet kõbsdokument til dette dokument. Du kan kopiere en bogfõrt kõbsfaktura til en ny kõbsfaktura, hvis du hurtigt vil oprette et lignende dokument.;
                                 ENU=Copy document lines and header information from another purchase document to this document. You can copy a posted purchase invoice into a new purchase invoice to quickly create a similar document.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=CopyDocument;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CopyPurchDoc.SetPurchHeader(Rec);
                                 CopyPurchDoc.RUNMODAL;
                                 CLEAR(CopyPurchDoc);
                                 IF GET("Document Type","No.") THEN;
                               END;
                                }
      { 142     ;2   ;Action    ;
                      Name=MoveNegativeLines;
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
      { 225     ;2   ;ActionGroup;
                      CaptionML=[DAN=Di&rekte levering;
                                 ENU=Dr&op Shipment];
                      Image=Delivery }
      { 184     ;3   ;Action    ;
                      Name=Functions_GetSalesOrder;
                      CaptionML=[DAN=Hent &salgsordre;
                                 ENU=Get &Sales Order];
                      ToolTipML=[DAN="Vëlg den salgsordre, der skal sammenkëdes med kõbsordren ved direkte levering eller specialordrer. ";
                                 ENU="Select the sales order that must be linked to the purchase order, for drop shipment or special order. "];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 76;
                      Image=Order }
      { 186     ;2   ;ActionGroup;
                      CaptionML=[DAN=Spe&cialordre;
                                 ENU=Speci&al Order];
                      Image=SpecialOrder }
      { 187     ;3   ;Action    ;
                      AccessByPermission=TableData 110=R;
                      CaptionML=[DAN=Hent &salgsordre;
                                 ENU=Get &Sales Order];
                      ToolTipML=[DAN="Vëlg den salgsordre, der skal sammenkëdes med kõbsordren ved direkte levering eller specialordrer. ";
                                 ENU="Select the sales order that must be linked to the purchase order, for drop shipment or special order. "];
                      ApplicationArea=#Advanced;
                      Image=Order;
                      OnAction=VAR
                                 PurchHeader@1000 : Record 38;
                                 DistIntegration@1001 : Codeunit 5702;
                               BEGIN
                                 PurchHeader.COPY(Rec);
                                 DistIntegration.GetSpecialOrders(PurchHeader);
                                 Rec := PurchHeader;
                               END;
                                }
      { 173     ;2   ;Action    ;
                      Name=Archive Document;
                      CaptionML=[DAN=&Arkiver dokument;
                                 ENU=Archi&ve Document];
                      ToolTipML=[DAN=Send bilaget til arkivet, f.eks. fordi det er for tidligt at slette det. Senere skal du slette eller genbehandle det arkiverede bilag.;
                                 ENU=Send the document to the archive, for example because it is too soon to delete it. Later, you delete or reprocess the archived document.];
                      ApplicationArea=#Advanced;
                      Image=Archive;
                      OnAction=BEGIN
                                 ArchiveManagement.ArchivePurchDocument(Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 195     ;2   ;Action    ;
                      AccessByPermission=TableData 410=R;
                      CaptionML=[DAN=Send koncernintern kõbsordre;
                                 ENU=Send Intercompany Purchase Order];
                      ToolTipML=[DAN=Send kõbsordren til den koncerninterne udbakke eller direkte til den koncerninterne partner, hvis automatisk transaktionsafsendelse er aktiveret.;
                                 ENU=Send the purchase order to the intercompany outbox or directly to the intercompany partner if automatic transaction sending is enabled.];
                      ApplicationArea=#Intercompany;
                      Image=IntercompanyOrder;
                      OnAction=VAR
                                 ICInOutboxMgt@1000 : Codeunit 427;
                                 ApprovalsMgmt@1003 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                   ICInOutboxMgt.SendPurchDoc(Rec,FALSE);
                               END;
                                }
      { 189     ;2   ;Separator  }
      { 51      ;2   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 47      ;3   ;Action    ;
                      Name=IncomingDocCard;
                      CaptionML=[DAN=Vis indgÜende bilag;
                                 ENU=View Incoming Document];
                      ToolTipML=[DAN=FÜ vist indgÜende bilagsrecords og vedhëftede filer, der findes for posten eller bilaget, f.eks. i forbindelse med revision.;
                                 ENU=View any incoming document records and file attachments that exist for the entry or document, for example for auditing purposes];
                      ApplicationArea=#Suite;
                      Enabled=HasIncomingDocument;
                      Image=ViewOrder;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                               END;
                                }
      { 45      ;3   ;Action    ;
                      Name=SelectIncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=Vëlg indgÜende bilag;
                                 ENU=Select Incoming Document];
                      ToolTipML=[DAN=Vëlg en indgÜende bilagsrecord og vedhëftet fil, der skal knyttes til posten eller dokumentet.;
                                 ENU=Select an incoming document record and file attachment that you want to link to the entry or document.];
                      ApplicationArea=#Suite;
                      Image=SelectLineToApply;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 VALIDATE("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RECORDID));
                               END;
                                }
      { 43      ;3   ;Action    ;
                      Name=IncomingDocAttachFile;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret indgÜende bilag ud fra fil;
                                 ENU=Create Incoming Document from File];
                      ToolTipML=[DAN=Opret et indgÜende bilag fra en fil, som du vëlger pÜ disken. Filen vedhëftes den indgÜende bilagrecord.;
                                 ENU=Create an incoming document from a file that you select from the disk. The file will be attached to the incoming document record.];
                      ApplicationArea=#Suite;
                      Enabled=CreateIncomingDocumentEnabled;
                      Image=Attach;
                      OnAction=VAR
                                 IncomingDocumentAttachment@1000 : Record 133;
                               BEGIN
                                 IncomingDocumentAttachment.NewAttachmentFromPurchaseDocument(Rec);
                               END;
                                }
      { 41      ;3   ;Action    ;
                      Name=RemoveIncomingDoc;
                      CaptionML=[DAN=Fjern indgÜende bilag;
                                 ENU=Remove Incoming Document];
                      ToolTipML=[DAN=Fjern eventuelle indgÜende bilagsrecords og vedhëftede filer.;
                                 ENU=Remove any incoming document records and file attachments.];
                      ApplicationArea=#Suite;
                      Enabled=HasIncomingDocument;
                      Image=RemoveLine;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IF IncomingDocument.GET("Incoming Document Entry No.") THEN
                                   IncomingDocument.RemoveLinkToRelatedRecord;
                                 "Incoming Document Entry No." := 0;
                                 MODIFY(TRUE);
                               END;
                                }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 57      ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send go&dkendelsesanmodning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af bilaget.;
                                 ENU=Request approval of the document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                               END;
                                }
      { 55      ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesan&modning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                      PromotedIsBig=Yes;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                                 WorkflowWebhookMgt@1000 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                                 WorkflowWebhookMgt.FindAndCancel(RECORDID);
                               END;
                                }
      { 86      ;2   ;ActionGroup;
                      CaptionML=[DAN=Flow;
                                 ENU=Flow];
                      Image=Flow }
      { 88      ;3   ;Action    ;
                      Name=CreateFlow;
                      CaptionML=[DAN=Opret et workflow;
                                 ENU=Create a Flow];
                      ToolTipML=[DAN=Opret et nyt workflow fra en liste over relevante workflowskabeloner.;
                                 ENU=Create a new Flow from a list of relevant Flow templates.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaaS;
                      Image=Flow;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 FlowServiceManagement@1000 : Codeunit 6400;
                                 FlowTemplateSelector@1001 : Page 6400;
                               BEGIN
                                 // Opens page 6400 where the user can use filtered templates to create new flows.
                                 FlowTemplateSelector.SetSearchText(FlowServiceManagement.GetPurchasingTemplateFilter);
                                 FlowTemplateSelector.RUN;
                               END;
                                }
      { 92      ;3   ;Action    ;
                      Name=SeeFlows;
                      CaptionML=[DAN=Se mine workflows;
                                 ENU=See my Flows];
                      ToolTipML=[DAN=FÜ vist og konfigurer de workflowforekomster, du har oprettet.;
                                 ENU=View and configure Flows that you created.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 6401;
                      Promoted=Yes;
                      Image=Flow;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 149     ;2   ;Action    ;
                      AccessByPermission=TableData 7316=R;
                      CaptionML=[DAN=Opr&et lagermodtagelse;
                                 ENU=Create &Whse. Receipt];
                      ToolTipML=[DAN=Opret en lagermodtagelse for at starte en lëg-pÜ-lager-proces i henhold til en avanceret lageropsëtning.;
                                 ENU=Create a warehouse receipt to start a receive and put-away process according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=NewReceipt;
                      OnAction=VAR
                                 GetSourceDocInbound@1001 : Codeunit 5751;
                               BEGIN
                                 GetSourceDocInbound.CreateFromPurchOrder(Rec);

                                 IF NOT FIND('=><') THEN
                                   INIT;
                               END;
                                }
      { 150     ;2   ;Action    ;
                      AccessByPermission=TableData 7340=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret l&ëg-pÜ-lager (lager)/pluk (lager);
                                 ENU=Create Inventor&y Put-away/Pick];
                      ToolTipML=[DAN=Opret en lëg-pÜ-lager-aktivitet eller et lagerpluk til hÜndtering af varer pÜ bilaget i overensstemmelse med en grundlëggende lageropsëtning, der ikke krëver lagermodtagelse eller leverancedokumenter.;
                                 ENU=Create an inventory put-away or inventory pick to handle items on the document according to a basic warehouse configuration that does not require warehouse receipt or shipment documents.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=CreateInventoryPickup;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CreateInvtPutAwayPick;

                                 IF NOT FIND('=><') THEN
                                   INIT;
                               END;
                                }
      { 74      ;2   ;Separator  }
      { 77      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&osting];
                      Image=Post }
      { 79      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=B&ogfõr;
                                 ENU=P&ost];
                      ToolTipML=[DAN=Fërdiggõr bilaget eller kladden ved at bogfõre belõb og antal pÜ de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Purch.-Post (Yes/No)");
                               END;
                                }
      { 21      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogfõring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, nÜr du bogfõrer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Suite;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 PurchPostYesNo@1000 : Codeunit 91;
                               BEGIN
                                 PurchPostYesNo.Preview(Rec);
                               END;
                                }
      { 80      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Fërdiggõr dokumentet eller kladden, og forbered udskrivning. Vërdierne og mëngderne bogfõres pÜ de relevante konti. Du fÜr vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Purch.-Post + Print");
                               END;
                                }
      { 78      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, sÜ du kan finde og rette eventuelle fejl, fõr du udfõrer den faktiske bogfõring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Advanced;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintPurchHeader(Rec);
                               END;
                                }
      { 81      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Masse&bogfõr;
                                 ENU=Post &Batch];
                      ToolTipML=[DAN=Bogfõr flere bilag pÜ Çn gang. Der Übnes et anmodningsvindue, hvor du kan angive, hvilke bilag der skal bogfõres.;
                                 ENU=Post several documents at once. A report request window opens where you can specify which documents to post.];
                      ApplicationArea=#Advanced;
                      Image=PostBatch;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Batch Post Purchase Orders",TRUE,TRUE,Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 5       ;2   ;Action    ;
                      CaptionML=[DAN=Fjern fra opgavekõ;
                                 ENU=Remove From Job Queue];
                      ToolTipML=[DAN=Fjern den planlagte behandling af denne record fra jobkõen.;
                                 ENU=Remove the scheduled processing of this record from the job queue.];
                      ApplicationArea=#Suite;
                      Visible=JobQueueVisible;
                      Image=RemoveLine;
                      OnAction=BEGIN
                                 CancelBackgroundPosting;
                               END;
                                }
      { 201     ;2   ;Separator  }
      { 209     ;2   ;ActionGroup;
                      CaptionML=[DAN=Forud&betaling;
                                 ENU=Prepa&yment];
                      Image=Prepayment }
      { 202     ;3   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Forudbetalingstest&rapport;
                                 ENU=Prepayment Test &Report];
                      ToolTipML=[DAN="Gennemse de forudbetalingstransaktioner, der kommer ud af at bogfõre salgsdokumentet som faktureret. ";
                                 ENU="Preview the prepayment transactions that will results from posting the sales document as invoiced. "];
                      ApplicationArea=#Prepayments;
                      Image=PrepaymentSimulation;
                      OnAction=BEGIN
                                 ReportPrint.PrintPurchHeaderPrepmt(Rec);
                               END;
                                }
      { 203     ;3   ;Action    ;
                      Name=PostPrepaymentInvoice;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr forudbetalings&faktura;
                                 ENU=Post Prepayment &Invoice];
                      ToolTipML=[DAN="Bogfõr de angivne forudbetalingsoplysninger. ";
                                 ENU="Post the specified prepayment information. "];
                      ApplicationArea=#Prepayments;
                      Image=PrepaymentPost;
                      OnAction=VAR
                                 ApprovalsMgmt@1002 : Codeunit 1535;
                                 PurchPostYNPrepmt@1000 : Codeunit 445;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                   PurchPostYNPrepmt.PostPrepmtInvoiceYN(Rec,FALSE);
                               END;
                                }
      { 210     ;3   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr og udskriv forudb&etalingsfaktura;
                                 ENU=Post and Print Prepmt. Invoic&e];
                      ToolTipML=[DAN="Bogfõr de angivne forudbetalingsoplysninger, og udskriv den relaterede rapport. ";
                                 ENU="Post the specified prepayment information and print the related report. "];
                      ApplicationArea=#Prepayments;
                      Image=PrepaymentPostPrint;
                      OnAction=VAR
                                 ApprovalsMgmt@1002 : Codeunit 1535;
                                 PurchPostYNPrepmt@1000 : Codeunit 445;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                   PurchPostYNPrepmt.PostPrepmtInvoiceYN(Rec,TRUE);
                               END;
                                }
      { 204     ;3   ;Action    ;
                      Name=PostPrepaymentCreditMemo;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr forudbetalings&kreditnota;
                                 ENU=Post Prepayment &Credit Memo];
                      ToolTipML=[DAN=Opret og bogfõr en kreditnota for de angivne forudbetalingsoplysninger.;
                                 ENU=Create and post a credit memo for the specified prepayment information.];
                      ApplicationArea=#Prepayments;
                      Image=PrepaymentPost;
                      OnAction=VAR
                                 ApprovalsMgmt@1002 : Codeunit 1535;
                                 PurchPostYNPrepmt@1000 : Codeunit 445;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                   PurchPostYNPrepmt.PostPrepmtCrMemoYN(Rec,FALSE);
                               END;
                                }
      { 211     ;3   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr og udskriv forudbetalingskreditn&ota;
                                 ENU=Post and Print Prepmt. Cr. Mem&o];
                      ToolTipML=[DAN=Opret og bogfõr en kreditnota for de angivne forudbetalingsoplysninger, og udskriv den relaterede rapport.;
                                 ENU=Create and post a credit memo for the specified prepayment information and print the related report.];
                      ApplicationArea=#Prepayments;
                      Image=PrepaymentPostPrint;
                      OnAction=VAR
                                 ApprovalsMgmt@1002 : Codeunit 1535;
                                 PurchPostYNPrepmt@1000 : Codeunit 445;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                   PurchPostYNPrepmt.PostPrepmtCrMemoYN(Rec,TRUE);
                               END;
                                }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Udskriv;
                                 ENU=Print];
                      Image=Print }
      { 82      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du fÜr vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Category10;
                      OnAction=VAR
                                 PurchaseHeader@1000 : Record 38;
                               BEGIN
                                 PurchaseHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                                 PurchaseHeader.PrintRecords(TRUE);
                               END;
                                }
      { 22      ;2   ;Action    ;
                      Name=SendCustom;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Send;
                                 ENU=Send];
                      ToolTipML=[DAN=Klargõr bilaget til afsendelse i henhold til kreditorens afsendelsesprofil, f.eks. vedhëftet til en mail. Vinduet Send dokument til vises, sÜ du kan bekrëfte eller vëlge en afsendelsesprofil fõrst.;
                                 ENU=Prepare to send the document according to the vendor's sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendToMultiple;
                      PromotedCategory=Category10;
                      OnAction=VAR
                                 PurchaseHeader@1000 : Record 38;
                               BEGIN
                                 PurchaseHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                                 PurchaseHeader.SendRecords;
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
                ApplicationArea=#Suite;
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
                ToolTipML=[DAN=Angiver nummeret pÜ den kreditor, der leverer produkterne.;
                           ENU=Specifies the number of the vendor who delivers the products.];
                ApplicationArea=#Suite;
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
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, der leverer produkterne.;
                           ENU=Specifies the name of the vendor who delivers the products.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Vendor Name";
                Importance=Promoted;
                OnValidate=BEGIN
                             OnAfterValidateBuyFromVendorNo(Rec,xRec);
                             CurrPage.UPDATE;
                           END;

                ShowMandatory=TRUE }

    { 62  ;2   ;Group     ;
                CaptionML=[DAN=Leverandõr;
                           ENU=Buy-from];
                GroupType=Group }

    { 89  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver kreditorens kõbsadresse.;
                           ENU=Specifies the vendor's buy-from address.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Address";
                Importance=Additional }

    { 91  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af kreditorens kõbsadresse.;
                           ENU=Specifies an additional part of the vendor's buy-from address.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Address 2";
                Importance=Additional }

    { 76  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Post Code";
                Importance=Additional }

    { 93  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from City";
                Importance=Additional }

    { 174 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonen pÜ leverandõrens kõbsadresse.;
                           ENU=Specifies the number of contact person of the vendor's buy-from.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Contact No.";
                Importance=Additional }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ en kontaktperson hos den kreditor, ordren er sendt fra.;
                           ENU=Specifies the name of the person to contact about an order from this vendor.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Contact";
                Editable="Buy-from Vendor No." <> '' }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Suite;
                SourceExpr="Document Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogfõringsdatoen for recorden.;
                           ENU=Specifies the posting date of the record.];
                ApplicationArea=#Suite;
                SourceExpr="Posting Date";
                Importance=Additional }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr den relaterede kõbsfaktura skal betales.;
                           ENU=Specifies when the related purchase invoice must be paid.];
                ApplicationArea=#Suite;
                SourceExpr="Due Date";
                Importance=Additional }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for det oprindelige bilag, du modtog fra kreditoren. Du kan krëve bilagsnummeret til bogfõring, eller du kan lade det vëre valgfrit. Det er pÜkrëvet som standard, sÜ dette bilag refererer til originalen. Det fjerner et trin fra bogfõringsprocessen at gõre bilagsnumre valgfri. Hvis du f.eks. vedhëfter den oprindelige faktura som en PDF-fil, behõver du mÜske ikke at angive dokumentnummeret. I vinduet Kõbsopsëtning kan du vëlge, om dokumentnumre er pÜkrëvet ved at vëlge eller rydde markeringen i afkrydsningsfeltet Eksternt bilagsnr. obl.;
                           ENU=Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it's required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.];
                ApplicationArea=#Suite;
                SourceExpr="Vendor Invoice No.";
                ShowMandatory=VendorInvoiceNoMandatory }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indkõber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Suite;
                SourceExpr="Purchaser Code";
                Importance=Additional;
                OnValidate=BEGIN
                             PurchaserCodeOnAfterValidate;
                           END;
                            }

    { 171 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange arkiverede versioner der findes af dette bilag.;
                           ENU=Specifies the number of archived versions for this document.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Archived Versions";
                Importance=Additional }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ordren blev oprettet.;
                           ENU=Specifies the date when the order was created.];
                ApplicationArea=#Suite;
                SourceExpr="Order Date";
                Importance=Additional }

    { 237 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tilbudsnummeret til kõbsordren.;
                           ENU=Specifies the quote number for the purchase order.];
                ApplicationArea=#Advanced;
                SourceExpr="Quote No.";
                Importance=Additional }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens ordrenummer.;
                           ENU=Specifies the vendor's order number.];
                ApplicationArea=#Suite;
                SourceExpr="Vendor Order No.";
                Importance=Additional }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens leverancenummer.;
                           ENU=Specifies the vendor's shipment number.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Shipment No." }

    { 96  ;2   ;Field     ;
                CaptionML=[DAN=Alternativ kreditoradressekode;
                           ENU=Alternate Vendor Address Code];
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#Suite;
                SourceExpr="Order Address Code";
                Importance=Additional }

    { 131 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID";
                Importance=Additional }

    { 133 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om recorden er Üben, afventer godkendelse, er faktureret til forudbetaling eller er frigivet til nëste fase i behandlingen.;
                           ENU=Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.];
                ApplicationArea=#Suite;
                SourceExpr=Status;
                Importance=Additional }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for en opgavekõpost, der hÜndterer bogfõring af kõbsordrer.;
                           ENU=Specifies the status of a job queue entry that handles the posting of purchase orders.];
                ApplicationArea=#All;
                SourceExpr="Job Queue Status";
                Importance=Additional;
                Visible=JobQueueUsed }

    { 60  ;1   ;Part      ;
                Name=PurchLines;
                ApplicationArea=#Suite;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page54;
                Enabled="Buy-from Vendor No." <> '';
                Editable="Buy-from Vendor No." <> '';
                PartType=Page;
                UpdatePropagation=Both }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutaen for belõbene i kõbsbilaget.;
                           ENU=Specifies the currency of amounts on the purchase document.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Additional;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                           END;

                OnAssistEdit=BEGIN
                               CLEAR(ChangeExchangeRate);
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

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den dato, hvor du forventer, at varerne er tilgëngelige pÜ lageret. Hvis du lader feltet vëre tomt, bliver det beregnet pÜ fõlgende mÜde: Planlagt modtagelsesdato + Sikkerhedstid + IndgÜende lagerekspeditionstid = Forventet modtagelsesdato.";
                           ENU="Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date."];
                ApplicationArea=#Suite;
                SourceExpr="Expected Receipt Date";
                Importance=Promoted }

    { 135 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Suite;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             PricesIncludingVATOnAfterValid;
                           END;
                            }

    { 191 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Suite;
                SourceExpr="VAT Bus. Posting Group" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Suite;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 117 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverfõrsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Suite;
                SourceExpr="Payment Method Code";
                Importance=Additional }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget reprësenterer med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction Type" }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                OnValidate=BEGIN
                             ShortcutDimension1CodeOnAfterV;
                           END;
                            }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                OnValidate=BEGIN
                             ShortcutDimension2CodeOnAfterV;
                           END;
                            }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis betaling gennemfõres fõr eller pÜ den dato, der er angivet i feltet Kontantrabatdato.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor belõbet i posten skal vëre betalt, for at der kan opnÜs kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Suite;
                SourceExpr="Pmt. Discount Date";
                Importance=Additional }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalingen for kõbsfakturaen.;
                           ENU=Specifies the payment of the purchase invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Reference" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ kreditoren.;
                           ENU=Specifies the number of the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Creditor No." }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den tilknyttede post reprësenterer en ubetalt faktura, som der findes et betalingsforslag, en rykker eller en rentenota til.;
                           ENU=Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.];
                ApplicationArea=#Advanced;
                SourceExpr="On Hold" }

    { 144 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tid, det tager at gõre varer tilgëngelige fra lageret, efter varerne er bogfõrt som modtaget.;
                           ENU=Specifies the time it takes to make items part of available inventory, after the items have been posted as received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Inbound Whse. Handling Time";
                Importance=Additional }

    { 146 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en datoformel for det tidsrum, det tager at genbestille varen.;
                           ENU=Specifies a date formula for the amount of time it takes to replenish the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Lead Time Calculation";
                Importance=Additional }

    { 127 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kreditoren skal levere pÜ leveringsadressen.;
                           ENU=Specifies the date that you want the vendor to deliver to the ship-to address.];
                ApplicationArea=#Advanced;
                SourceExpr="Requested Receipt Date" }

    { 139 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som kreditoren har lovet at levere ordren.;
                           ENU=Specifies the date that the vendor has promised to deliver the order.];
                ApplicationArea=#Advanced;
                SourceExpr="Promised Receipt Date" }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Forsendelse og betaling;
                           ENU=Shipping and Payment];
                GroupType=Group }

    { 83  ;2   ;Group     ;
                GroupType=Group }

    { 94  ;3   ;Group     ;
                GroupType=Group }

    { 90  ;4   ;Field     ;
                Name=ShippingOptionWithLocation;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                ToolTipML=[DAN=Angiver den adresse, som produkter i kõbsbilaget skal leveres til. Standard (firmaadresse): Det samme som den firmaadresse, der er angivet i vinduet Virksomhedsoplysninger. Lokation: ên af virksomhedens lokationsadresser. Brugerdefineret adresse: En vilkÜrlig leveringsadresse, som du angiver i nedenstÜende felter.;
                           ENU=Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Location: One of the company's location addresses. Custom Address: Any ship-to address that you specify in the fields below.];
                OptionCaptionML=[DAN=Standard (firmaadresse),lokation,Debitoradresse,Brugerdefineret adresse;
                                 ENU=Default (Company Address),Location,Customer Address,Custom Address];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShipToOptions;
                Visible=ShowShippingOptionsWithLocation;
                OnValidate=BEGIN
                             ValidateShippingOption;
                           END;
                            }

    { 84  ;4   ;Field     ;
                Name=ShippingOptionWithoutLocation;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                ToolTipML=[DAN=Angiver den adresse, som produkter i kõbsbilaget skal leveres til. Standard (firmaadresse): Det samme som den firmaadresse, der er angivet i vinduet Virksomhedsoplysninger. Brugerdefineret adresse: En vilkÜrlig leveringsadresse, som du angiver i nedenstÜende felter.;
                           ENU=Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Custom Address: Any ship-to address that you specify in the fields below.];
                OptionCaptionML=[DAN=Standard (firmaadresse),,Debitoradresse,Brugerdefineret adresse;
                                 ENU=Default (Company Address),,Customer Address,Custom Address];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShipToOptions;
                Visible=NOT ShowShippingOptionsWithLocation;
                HideValue=ShowShippingOptionsWithLocation AND (ShipToOptions = ShipToOptions::Location);
                OnValidate=BEGIN
                             ValidateShippingOption
                           END;
                            }

    { 99  ;4   ;Group     ;
                GroupType=Group }

    { 98  ;5   ;Group     ;
                Visible=ShipToOptions = ShipToOptions::Location;
                GroupType=Group }

    { 104 ;6   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Promoted }

    { 101 ;5   ;Group     ;
                Visible=ShipToOptions = ShipToOptions::"Customer Address";
                GroupType=Group }

    { 87  ;6   ;Field     ;
                CaptionML=[DAN=Debitor;
                           ENU=Customer];
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som varerne sendes til direkte fra din kreditor, som en direkte levering.;
                           ENU=Specifies the number of the customer that the items are shipped to directly from your vendor, as a drop shipment.];
                ApplicationArea=#Suite;
                SourceExpr="Sell-to Customer No." }

    { 85  ;6   ;Field     ;
                ToolTipML=[DAN=Angiver koden for en anden leveringsadresse end kreditorens egen adresse, som angives som standard.;
                           ENU=Specifies the code for another delivery address than the vendor's own address, which is entered by default.];
                ApplicationArea=#Suite;
                SourceExpr="Ship-to Code";
                Editable="Sell-to Customer No." <> '' }

    { 42  ;5   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ firmaet med den adresse, som varerne pÜ kõbsbilaget skal leveres til.;
                           ENU=Specifies the name of the company at the address that you want the items on the purchase document to be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Name";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 44  ;5   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som varerne pÜ kõbsbilaget skal leveres til.;
                           ENU=Specifies the address that you want the items on the purchase document to be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 46  ;5   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address 2";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 109 ;5   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret pÜ firmaet med den adresse, som varerne pÜ kõbsbilaget skal leveres til.;
                           ENU=Specifies the postal code of the address that you want the items on the purchase document to be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Post Code";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 48  ;5   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to City";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 105 ;5   ;Field     ;
                CaptionML=[DAN=Land/omrÜde;
                           ENU=Country/Region];
                ToolTipML=[DAN=Angiver lande-/omrÜdekoden for den adresse, som varerne pÜ kõbsbilaget skal leveres til.;
                           ENU=Specifies the country/region code of the address that you want the items on the purchase document to be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Country/Region Code";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 50  ;5   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ en kontaktperson pÜ den adresse, som varerne pÜ kõbsbilaget skal leveres til.;
                           ENU=Specifies the name of a contact person for the address of the address that you want the items on the purchase document to be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Contact";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 71  ;2   ;Group     ;
                GroupType=Group }

    { 103 ;3   ;Field     ;
                Name=PayToOptions;
                CaptionML=[DAN=Faktureres til;
                           ENU=Pay-to];
                ToolTipML=[DAN=Angiver den kreditor, som kõbsbilaget skal betales til. Standard (kreditor): Den samme som kreditoren pÜ kõbsbilaget. En anden kreditor: Enhver kreditor, som du angiver i nedenstÜende felter.;
                           ENU=Specifies the vendor that the purchase document will be paid to. Default (Vendor): The same as the vendor on the purchase document. Another Vendor: Any vendor that you specify in the fields below.];
                OptionCaptionML=[DAN=Standard (kreditor),en anden kreditor;
                                 ENU=Default (Vendor),Another Vendor];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=PayToOptions;
                OnValidate=BEGIN
                             IF PayToOptions = PayToOptions::"Default (Vendor)" THEN
                               VALIDATE("Pay-to Vendor No.","Buy-from Vendor No.");
                           END;
                            }

    { 95  ;3   ;Group     ;
                Visible=PayToOptions = PayToOptions::"Another Vendor";
                GroupType=Group }

    { 24  ;4   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the name of the vendor sending the invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Name";
                Importance=Promoted }

    { 26  ;4   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the address of the vendor sending the invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Address";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 28  ;4   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Address 2";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 97  ;4   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Post Code";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 30  ;4   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to City";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 176 ;4   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonen pÜ leverandõrens kõbsadresse.;
                           ENU=Specifies the number of contact person of the vendor's buy-from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Contact No.";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 32  ;4   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ en kontaktperson hos den kreditor, ordren er sendt fra.;
                           ENU=Specifies the name of the person to contact about an order from this vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Contact";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportmÜden ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method" }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det indfõrselssted, hvor varerne kom ind i landet/omrÜdet, for rapportering til Intrastat.;
                           ENU=Specifies the code of the port of entry where the items pass into your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry Point" }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omrÜde med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 1900201301;1;Group  ;
                CaptionML=[DAN=Forudbetaling;
                           ENU=Prepayment] }

    { 197 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forudbetalingsprocenten, der skal bruges til at beregne forudbetalingen for salg.;
                           ENU=Specifies the prepayment percentage to use to calculate the prepayment for sales.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepayment %";
                Importance=Promoted;
                OnValidate=BEGIN
                             Prepayment37OnAfterValidate;
                           END;
                            }

    { 199 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at forudbetalinger pÜ kõbsordren kombineres, hvis de har samme finanskonto for forudbetalinger eller samme dimensioner.;
                           ENU=Specifies that prepayments on the purchase order are combined if they have the same general ledger account for prepayments or the same dimensions.];
                ApplicationArea=#Prepayments;
                SourceExpr="Compress Prepayment" }

    { 215 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der reprësenterer betalingsbetingelserne for de forudbetalingsfakturaer, der hõrer til kõbsbilaget.;
                           ENU=Specifies the code that represents the payment terms for prepayment invoices related to the purchase document.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt. Payment Terms Code" }

    { 212 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr forudbetalingsfakturaen for denne kõbsordre forfalder.;
                           ENU=Specifies when the prepayment invoice for this purchase order is due.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepayment Due Date";
                Importance=Promoted }

    { 217 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles pÜ forudbetalingen, hvis kreditoren betaler fõr eller pÜ den dato, der er angivet i feltet Forudb. - dato for kont.rabat.;
                           ENU=Specifies the payment discount percent granted on the prepayment if the vendor pays on or before the date entered in the Prepmt. Pmt. Discount Date field.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt. Payment Discount %" }

    { 196 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den sidste dato, hvor kreditoren kan betale forudbetalingsfakturaen og stadig opnÜ en kontantrabat pÜ det forudbetalte belõb.;
                           ENU=Specifies the last date the vendor can pay the prepayment invoice and still receive a payment discount on the prepayment amount.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt. Pmt. Discount Date" }

    { 207 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, som kreditoren bruger til kõbsordren.;
                           ENU=Specifies the number that the vendor uses for the purchase order.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Cr. Memo No." }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 23  ;1   ;Part      ;
                ApplicationArea=#Suite;
                SubPageLink=Table ID=CONST(38),
                            Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.);
                PagePartID=Page9103;
                Visible=OpenApprovalEntriesExistForCurrUser;
                PartType=Page }

    { 1903326807;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page9090;
                ProviderID=60;
                Visible=FALSE;
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

    { 39  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Advanced;
                PagePartID=Page193;
                Visible=FALSE;
                PartType=Page;
                ShowFilter=No }

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
                ApplicationArea=#Suite;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(Document No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9100;
                ProviderID=60;
                PartType=Page }

    { 59  ;1   ;Part      ;
                Name=WorkflowStatus;
                ApplicationArea=#Suite;
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
      ReportPrint@1003 : Codeunit 228;
      UserMgt@1005 : Codeunit 5700;
      ArchiveManagement@1007 : Codeunit 5063;
      PurchCalcDiscByType@1009 : Codeunit 66;
      ChangeExchangeRate@1001 : Page 511;
      ShipToOptions@1022 : 'Default (Company Address),Location,Customer Address,Custom Address';
      PayToOptions@1021 : 'Default (Vendor),Another Vendor';
      JobQueueVisible@1000 : Boolean INDATASET;
      JobQueueUsed@1004 : Boolean INDATASET;
      HasIncomingDocument@1012 : Boolean;
      DocNoVisible@1008 : Boolean;
      VendorInvoiceNoMandatory@1010 : Boolean;
      OpenApprovalEntriesExistForCurrUser@1011 : Boolean;
      OpenApprovalEntriesExist@1014 : Boolean;
      ShowWorkflowStatus@1013 : Boolean;
      CanCancelApprovalForRecord@1015 : Boolean;
      DocumentIsPosted@1016 : Boolean;
      OpenPostedPurchaseOrderQst@1017 : TextConst 'DAN=Ordren er blevet bogfõrt og flyttet til vinduet Bogfõrte kõbsfakturaer.\\Vil du Übne den bogfõrte faktura?;ENU=The order has been posted and moved to the Posted Purchase Invoices window.\\Do you want to open the posted invoice?';
      CreateIncomingDocumentEnabled@1018 : Boolean;
      CanRequestApprovalForFlow@1019 : Boolean;
      CanCancelApprovalForFlow@1020 : Boolean;
      ShowShippingOptionsWithLocation@1023 : Boolean;
      IsSaaS@1024 : Boolean;

    LOCAL PROCEDURE Post@4(PostingCodeunitID@1000 : Integer);
    VAR
      PurchaseHeader@1001 : Record 38;
      ApplicationAreaSetup@1004 : Record 9178;
      InstructionMgt@1002 : Codeunit 1330;
      LinesInstructionMgt@1005 : Codeunit 1320;
      IsScheduledPosting@1003 : Boolean;
    BEGIN
      IF ApplicationAreaSetup.IsFoundationEnabled THEN
        LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

      SendToPosting(PostingCodeunitID);

      IsScheduledPosting := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
      DocumentIsPosted := (NOT PurchaseHeader.GET("Document Type","No.")) OR IsScheduledPosting;

      IF IsScheduledPosting THEN
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
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ShortcutDimension2CodeOnAfterV@19008725();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE PricesIncludingVATOnAfterValid@19009096();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE Prepayment37OnAfterValidate@19040510();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE SetDocNoVisible@2();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
      DocType@1003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Reminder,FinChMemo';
    BEGIN
      DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::Order,"No.");
    END;

    LOCAL PROCEDURE SetExtDocNoMandatoryCondition@3();
    VAR
      PurchasesPayablesSetup@1000 : Record 312;
    BEGIN
      PurchasesPayablesSetup.GET;
      VendorInvoiceNoMandatory := PurchasesPayablesSetup."Ext. Doc. No. Mandatory"
    END;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
      WorkflowWebhookMgt@1000 : Codeunit 1543;
    BEGIN
      JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
      HasIncomingDocument := "Incoming Document Entry No." <> 0;
      CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND ("No." <> '');
      SetExtDocNoMandatoryCondition;

      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

      WorkflowWebhookMgt.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
    END;

    LOCAL PROCEDURE ShowPostedConfirmationMessage@17();
    VAR
      OrderPurchaseHeader@1003 : Record 38;
      PurchInvHeader@1000 : Record 122;
      InstructionMgt@1002 : Codeunit 1330;
    BEGIN
      IF NOT OrderPurchaseHeader.GET("Document Type","No.") THEN BEGIN
        PurchInvHeader.SETRANGE("No.","Last Posting No.");
        IF PurchInvHeader.FINDFIRST THEN
          IF InstructionMgt.ShowConfirm(OpenPostedPurchaseOrderQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
            PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
      END;
    END;

    LOCAL PROCEDURE ValidateShippingOption@8();
    BEGIN
      CASE ShipToOptions OF
        ShipToOptions::"Default (Company Address)",
        ShipToOptions::"Custom Address":
          BEGIN
            VALIDATE("Location Code",'');
            VALIDATE("Sell-to Customer No.",'');
          END;
        ShipToOptions::Location:
          BEGIN
            VALIDATE("Location Code");
            VALIDATE("Sell-to Customer No.",'');
          END;
        ShipToOptions::"Customer Address":
          BEGIN
            VALIDATE("Sell-to Customer No.");
            VALIDATE("Location Code",'');
          END;
      END;
    END;

    LOCAL PROCEDURE CalculateCurrentShippingAndPayToOption@36();
    BEGIN
      CASE TRUE OF
        "Sell-to Customer No." <> '':
          ShipToOptions := ShipToOptions::"Customer Address";
        "Location Code" <> '':
          ShipToOptions := ShipToOptions::Location;
        ELSE
          IF ShipToAddressEqualsCompanyShipToAddress THEN
            ShipToOptions := ShipToOptions::"Default (Company Address)"
          ELSE
            ShipToOptions := ShipToOptions::"Custom Address";
      END;

      IF "Pay-to Vendor No." = "Buy-from Vendor No." THEN
        PayToOptions := PayToOptions::"Default (Vendor)"
      ELSE
        PayToOptions := PayToOptions::"Another Vendor";
    END;

    BEGIN
    END.
  }
}

