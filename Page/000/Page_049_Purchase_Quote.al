OBJECT Page 49 Purchase Quote
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kõbsrekvisition;
               ENU=Purchase Quote];
    SourceTable=Table38;
    SourceTableView=WHERE(Document Type=FILTER(Quote));
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=New,Process,Report,Approve,Request Approval;
                                ENU=New,Process,Report,Approve,Request Approval];
    OnInit=BEGIN
             ShowShippingOptionsWithLocation := DummyApplicationAreaSetup.IsLocationEnabled OR DummyApplicationAreaSetup.IsAllDisabled;
           END;

    OnOpenPage=BEGIN
                 IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
                   FILTERGROUP(0);
                 END;

                 SetDocNoVisible;
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
      { 59      ;1   ;ActionGroup;
                      CaptionML=[DAN=R&ekvisition;
                                 ENU=&Quote];
                      Image=Quote }
      { 61      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CalcInvDiscForHeader;
                                 COMMIT;
                                 PAGE.RUNMODAL(PAGE::"Purchase Statistics",Rec);
                                 PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 62      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kreditor;
                                 ENU=Vendor];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om kreditoren i kõbsdokumentet.;
                                 ENU=View or edit detailed information about the vendor on the purchase document.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 26;
                      RunPageLink=No.=FIELD(Buy-from Vendor No.);
                      Enabled="Buy-from Vendor No." <> '';
                      Image=Vendor }
      { 63      ;2   ;Action    ;
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
      { 111     ;2   ;Action    ;
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
      { 37      ;2   ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Advanced;
                      Image=Approvals;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1001 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Purchase Header","Document Type","No.");
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 21      ;2   ;Action    ;
                      Name=Approve;
                      CaptionML=[DAN=Godkend;
                                 ENU=Approve];
                      ToolTipML=[DAN=Godkend de anmodede ëndringer.;
                                 ENU=Approve the requested changes.];
                      ApplicationArea=#Advanced;
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
      { 18      ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Afvis;
                                 ENU=Reject];
                      ToolTipML=[DAN=Afvis at godkende det indgÜende bilag. Bemërk, at dette ikke har noget at gõre med godkendelsesworkflows.;
                                 ENU=Reject to approve the incoming document. Note that this is not related to approval workflows.];
                      ApplicationArea=#Advanced;
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
      { 17      ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsen til en stedfortrëdende godkender.;
                                 ENU=Delegate the approval to a substitute approver.];
                      ApplicationArea=#Advanced;
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
      { 15      ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bemërkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
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
      { 70      ;1   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Gõr dig klar til at udskrive bilaget. Der Übnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages pÜ udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 LinesInstructionMgt@1000 : Codeunit 1320;
                               BEGIN
                                 IF DummyApplicationAreaSetup.IsFoundationEnabled THEN
                                   LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

                                 DocPrint.PrintPurchHeader(Rec);
                               END;
                                }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 148     ;2   ;Separator  }
      { 118     ;2   ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=F&rigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Advanced;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 ReleasePurchDoc@1000 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 119     ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen for at ëndre det, efter at det er blevet godkendt. Godkendte bilag har status Frigivet og skal Übnes, fõr de kan ëndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=Status <> Status::Open;
                      Image=ReOpen;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ReleasePurchDoc@1001 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 64      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 65      ;2   ;Action    ;
                      Name=CalculateInvoiceDiscount;
                      AccessByPermission=TableData 24=R;
                      CaptionML=[DAN=&Beregn fakturarabat;
                                 ENU=Calculate &Invoice Discount];
                      ToolTipML=[DAN=Beregn fakturarabatten for kõbsrekvisitionen.;
                                 ENU=Calculate the invoice discount for the purchase quote.];
                      ApplicationArea=#Advanced;
                      Image=CalculateInvoiceDiscount;
                      OnAction=BEGIN
                                 ApproveCalcInvDisc;
                                 PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 144     ;2   ;Separator  }
      { 143     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent s&td.kred.kõbskoder;
                                 ENU=Get St&d. Vend. Purchase Codes];
                      ToolTipML=[DAN=Vis en liste over standardkõbslinjer, som den aktuelle kreditor er blevet tildelt til brug ved tilbagevendende kõb.;
                                 ENU=View a list of the standard purchase lines that have been assigned to the vendor to be used for recurring purchases.];
                      ApplicationArea=#Advanced;
                      Image=VendorCode;
                      OnAction=VAR
                                 StdVendPurchCode@1000 : Record 175;
                               BEGIN
                                 StdVendPurchCode.InsertPurchLines(Rec);
                               END;
                                }
      { 146     ;2   ;Separator  }
      { 66      ;2   ;Action    ;
                      Name=CopyDocument;
                      Ellipsis=Yes;
                      CaptionML=[DAN=KopiÇr dokument;
                                 ENU=Copy Document];
                      ToolTipML=[DAN=KopiÇr linjer og sidehovedoplysninger fra et andet salgsbilag til dette bilag. Du kan kopiere en bogfõrt salgsfaktura til en ny salgsfaktura, hvis du hurtigt vil oprette et lignende bilag.;
                                 ENU=Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.];
                      ApplicationArea=#Advanced;
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
      { 138     ;2   ;Action    ;
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
      { 35      ;2   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 33      ;3   ;Action    ;
                      Name=IncomingDocCard;
                      CaptionML=[DAN=Vis indgÜende bilag;
                                 ENU=View Incoming Document];
                      ToolTipML=[DAN=FÜ vist indgÜende bilagsrecords og vedhëftede filer, der findes for posten eller bilaget, f.eks. i forbindelse med revision.;
                                 ENU=View any incoming document records and file attachments that exist for the entry or document, for example for auditing purposes];
                      ApplicationArea=#Advanced;
                      Enabled=HasIncomingDocument;
                      Image=ViewOrder;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                               END;
                                }
      { 31      ;3   ;Action    ;
                      Name=SelectIncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=Vëlg indgÜende bilag;
                                 ENU=Select Incoming Document];
                      ToolTipML=[DAN=Vëlg en indgÜende bilagsrecord og vedhëftet fil, der skal knyttes til posten eller dokumentet.;
                                 ENU=Select an incoming document record and file attachment that you want to link to the entry or document.];
                      ApplicationArea=#Advanced;
                      Image=SelectLineToApply;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 VALIDATE("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RECORDID));
                               END;
                                }
      { 29      ;3   ;Action    ;
                      Name=IncomingDocAttachFile;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret indgÜende bilag ud fra fil;
                                 ENU=Create Incoming Document from File];
                      ToolTipML=[DAN=Opret en indgÜende bilagsrecord ved at vëlge en fil, der skal vedhëftes, og knyt derefter den indgÜende bilagsrecord til posten eller bilaget.;
                                 ENU=Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.];
                      ApplicationArea=#Advanced;
                      Enabled=CreateIncomingDocumentEnabled;
                      Image=Attach;
                      OnAction=VAR
                                 IncomingDocumentAttachment@1000 : Record 133;
                               BEGIN
                                 IncomingDocumentAttachment.NewAttachmentFromPurchaseDocument(Rec);
                               END;
                                }
      { 25      ;3   ;Action    ;
                      Name=RemoveIncomingDoc;
                      CaptionML=[DAN=Fjern indgÜende bilag;
                                 ENU=Remove Incoming Document];
                      ToolTipML=[DAN=Fjern eventuelle indgÜende bilagsrecords og vedhëftede filer.;
                                 ENU=Remove any incoming document records and file attachments.];
                      ApplicationArea=#Advanced;
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
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 153     ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send godkendelsesan&modning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af bilaget.;
                                 ENU=Request approval of the document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF  ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                               END;
                                }
      { 154     ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godk&endelsesanmodning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord;
                      PromotedIsBig=Yes;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                               END;
                                }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Lav ordre;
                                 ENU=Make Order];
                      Image=MakeOrder }
      { 69      ;2   ;Action    ;
                      Name=MakeOrder;
                      CaptionML=[DAN=Lav &ordre;
                                 ENU=Make &Order];
                      ToolTipML=[DAN=Konverter kõbsrekvisitionen til en kõbsordre.;
                                 ENU=Convert the purchase quote to a purchase order.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=MakeOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                   CODEUNIT.RUN(CODEUNIT::"Purch.-Quote to Order (Yes/No)",Rec);
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
                ApplicationArea=#Advanced;
                SourceExpr="No.";
                Importance=Additional;
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
                ApplicationArea=#Advanced;
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
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Vendor Name";
                Importance=Promoted;
                OnValidate=BEGIN
                             OnAfterValidateBuyFromVendorNo(Rec,xRec);

                             CurrPage.UPDATE;
                           END;
                            }

    { 43  ;2   ;Group     ;
                CaptionML=[DAN=Leverandõr;
                           ENU=Buy-from];
                GroupType=Group }

    { 72  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den kreditor, der leverede varerne.;
                           ENU=Specifies the address of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Address";
                Importance=Additional }

    { 74  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af adressen pÜ den leverandõr, der leverede varerne.;
                           ENU=Specifies an additional part of the address of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Address 2";
                Importance=Additional }

    { 77  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret pÜ den kreditor, der leverede varerne.;
                           ENU=Specifies the post code of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Post Code";
                Importance=Additional }

    { 76  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for den kreditor, der leverede varerne.;
                           ENU=Specifies the city of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from City";
                Importance=Additional }

    { 139 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonen hos den kreditor, der leverede varerne.;
                           ENU=Specifies the number of contact person of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Contact No.";
                Importance=Additional }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver kontaktpersonen hos den kreditor, der leverede varerne.;
                           ENU=Specifies the contact person at the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Contact";
                Editable="Buy-from Vendor No." <> '' }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr den relaterede kõbsfaktura skal betales.;
                           ENU=Specifies when the related purchase invoice must be paid.];
                ApplicationArea=#Advanced;
                SourceExpr="Due Date";
                Importance=Promoted }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede ordre blev oprettet.;
                           ENU=Specifies the date when the related order was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Date";
                Importance=Promoted }

    { 136 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange arkiverede versioner der findes af dette bilag.;
                           ENU=Specifies the number of archived versions for this document.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Archived Versions";
                Importance=Additional }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som du har bedt kreditoren om at levere ordren pÜ til leveringsadressen. Vërdien i feltet bruges til at beregne, hvilken dato du senest kan bestille varerne, hvis de skal vëre leveret pÜ den õnskede modtagelsesdato. Hvis det ikke er nõdvendigt med levering pÜ en bestemt dato, kan du lade feltet stÜ tomt.;
                           ENU=Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested receipt date. If you do not need delivery on a specific date, you can leave the field blank.];
                ApplicationArea=#Advanced;
                SourceExpr="Requested Receipt Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens ordrenummer.;
                           ENU=Specifies the vendor's order number.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Order No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens leverancenummer.;
                           ENU=Specifies the vendor's shipment number.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Shipment No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indkõber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchaser Code";
                OnValidate=BEGIN
                             PurchaserCodeOnAfterValidate;
                           END;
                            }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kampagne, som bilaget er tilknyttet.;
                           ENU=Specifies the number of the campaign that the document is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Campaign No.";
                Importance=Additional }

    { 81  ;2   ;Field     ;
                CaptionML=[DAN=Alternativ kreditoradressekode;
                           ENU=Alternate Vendor Address Code];
                ToolTipML=[DAN="Angiver koden for en alternativ adresse, som du kan sende FRQ til, hvis den primëre adresse ikke er aktiv. ";
                           ENU="Specifies the code for an alternate address, which you can send the FRQ to is the primary address is not active. "];
                ApplicationArea=#Advanced;
                SourceExpr="Order Address Code";
                Importance=Additional }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID";
                Importance=Additional }

    { 107 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om recorden er Üben, afventer godkendelse, er faktureret til forudbetaling eller er frigivet til nëste fase i behandlingen.;
                           ENU=Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.];
                ApplicationArea=#Advanced;
                SourceExpr=Status;
                Importance=Promoted }

    { 58  ;1   ;Part      ;
                Name=PurchLines;
                ApplicationArea=#Advanced;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page97;
                Enabled="Buy-from Vendor No." <> '';
                Editable="Buy-from Vendor No." <> '';
                UpdatePropagation=Both }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code";
                Importance=Promoted;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                           END;

                OnAssistEdit=BEGIN
                               CLEAR(ChangeExchangeRate);
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                                 CurrPage.UPDATE;
                               END;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den dato, hvor du forventer, at varerne er tilgëngelige pÜ lageret. Hvis du lader feltet vëre tomt, bliver det beregnet pÜ fõlgende mÜde: Planlagt modtagelsesdato + Sikkerhedstid + IndgÜende lagerekspeditionstid = Forventet modtagelsesdato.";
                           ENU="Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date."];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Receipt Date";
                Importance=Promoted }

    { 116 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             PricesIncludingVATOnAfterValid;
                           END;
                            }

    { 150 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Group" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverfõrsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Method Code" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget reprësenterer med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Type" }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                OnValidate=BEGIN
                             ShortcutDimension1CodeOnAfterV;
                           END;
                            }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                OnValidate=BEGIN
                             ShortcutDimension2CodeOnAfterV;
                           END;
                            }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis betaling gennemfõres fõr eller pÜ den dato, der er angivet i feltet Kontantrabatdato.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor belõbet i posten skal vëre betalt, for at der kan opnÜs kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Advanced;
                SourceExpr="Pmt. Discount Date";
                Importance=Additional }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalingen for kõbsfakturaen.;
                           ENU=Specifies the payment of the purchase invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Reference" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ kreditoren.;
                           ENU=Specifies the number of the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Creditor No." }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den tilknyttede post reprësenterer en ubetalt faktura, som der findes et betalingsforslag, en rykker eller en rentenota til.;
                           ENU=Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.];
                ApplicationArea=#Advanced;
                SourceExpr="On Hold" }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Forsendelse og betaling;
                           ENU=Shipping and Payment];
                GroupType=Group }

    { 45  ;2   ;Group     ;
                GroupType=Group }

    { 20  ;3   ;Group     ;
                GroupType=Group }

    { 53  ;4   ;Field     ;
                Name=ShippingOptionWithLocation;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                ToolTipML=[DAN=Angiver den adresse, som produkter i kõbsbilaget skal leveres til. Standard (firmaadresse): Det samme som den firmaadresse, der er angivet i vinduet Virksomhedsoplysninger. Lokation: ên af virksomhedens lokationsadresser. Brugerdefineret adresse: En vilkÜrlig leveringsadresse, som du angiver i nedenstÜende felter.;
                           ENU=Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Location: One of the company's location addresses. Custom Address: Any ship-to address that you specify in the fields below.];
                OptionCaptionML=[DAN=Standard (firmaadresse),lokation,Brugerdefineret adresse;
                                 ENU=Default (Company Address),Location,Custom Address];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShipToOptions;
                Visible=ShowShippingOptionsWithLocation;
                OnValidate=BEGIN
                             ValidateShippingOption;
                           END;
                            }

    { 49  ;4   ;Field     ;
                Name=ShippingOptionWithoutLocation;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                ToolTipML=[DAN=Angiver den adresse, som produkter i kõbsbilaget skal leveres til. Standard (firmaadresse): Det samme som den firmaadresse, der er angivet i vinduet Virksomhedsoplysninger. Brugerdefineret adresse: En vilkÜrlig leveringsadresse, som du angiver i nedenstÜende felter.;
                           ENU=Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Custom Address: Any ship-to address that you specify in the fields below.];
                OptionCaptionML=[DAN=Standard (firmaadresse),,Brugerdefineret adresse;
                                 ENU=Default (Company Address),,Custom Address];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShipToOptions;
                Visible=NOT ShowShippingOptionsWithLocation;
                HideValue=ShowShippingOptionsWithLocation AND (ShipToOptions = ShipToOptions::Location);
                OnValidate=BEGIN
                             ValidateShippingOption
                           END;
                            }

    { 57  ;4   ;Group     ;
                GroupType=Group }

    { 55  ;5   ;Group     ;
                Visible=ShipToOptions = ShipToOptions::Location;
                GroupType=Group }

    { 89  ;6   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Promoted }

    { 40  ;5   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, som varerne pÜ kõbsordren blev sendt til, som en direkte levering.;
                           ENU=Specifies the name of the customer that items on the purchase order were shipped to, as a drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 42  ;5   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som varerne i kõbsordren blev leveret til, som en direkte levering.;
                           ENU=Specifies the address that items on the purchase order were shipped to, as a drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 44  ;5   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en yderligere del af den adresse, som varerne i kõbsordren blev leveret til, som en direkte levering.;
                           ENU=Specifies an additional part of the address that items on the purchase order were shipped to, as a drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address 2";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 94  ;5   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret, som varerne i kõbsordren blev leveret til, som en direkte levering.;
                           ENU=Specifies the post code that items on the purchase order were shipped to, as a drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 46  ;5   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver den by, som varerne i kõbsordren blev leveret til, som en direkte levering.;
                           ENU=Specifies the city that items on the purchase order were shipped to, as a drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to City";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 48  ;5   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver kontaktpersonen hos den debitor, som varerne pÜ kõbsordren blev sendt til, som en direkte levering.;
                           ENU=Specifies the contact person at the customer that items on the purchase order were shipped to, as a drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 51  ;2   ;Group     ;
                GroupType=Group }

    { 60  ;3   ;Field     ;
                Name=PayToOptions;
                CaptionML=[DAN=Faktureres til;
                           ENU=Pay-to];
                ToolTipML=[DAN=Angiver den kreditor, som kõbsbilaget skal betales til. Standard (kreditor): Den samme som kreditoren pÜ kõbsbilaget. En anden kreditor: Enhver kreditor, som du angiver i nedenstÜende felter.;
                           ENU=Specifies the vendor that the purchase document will be paid to. Default (Vendor): The same as the vendor on the purchase document. Another Vendor: Any vendor that you specify in the fields below.];
                OptionCaptionML=[DAN=Standard (kreditor),en anden kreditor;
                                 ENU=Default (Vendor),Another Vendor];
                ApplicationArea=#Advanced;
                SourceExpr=PayToOptions;
                OnValidate=BEGIN
                             IF PayToOptions = PayToOptions::"Default (Vendor)" THEN
                               VALIDATE("Pay-to Vendor No.","Buy-from Vendor No.");
                           END;
                            }

    { 67  ;3   ;Group     ;
                Visible=PayToOptions = PayToOptions::"Another Vendor";
                GroupType=Group }

    { 22  ;4   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the name of the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Name";
                OnValidate=BEGIN
                             IF GETFILTER("Pay-to Vendor No.") = xRec."Pay-to Vendor No." THEN
                               IF "Pay-to Vendor No." <> xRec."Pay-to Vendor No." THEN
                                 SETRANGE("Pay-to Vendor No.");

                             CurrPage.UPDATE;
                           END;
                            }

    { 24  ;4   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the address of the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Address";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 26  ;4   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en yderligere del af adressen pÜ den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies an additional part of the address of the vendor that the invoice was received from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Address 2";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 82  ;4   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret for den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the post code of the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Post Code";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 28  ;4   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the city of the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to City";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 141 ;4   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som er knyttet til kõbstilbuddet.;
                           ENU=Specifies the number of the customer associated with the purchase quote.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Contact No.";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 30  ;4   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver kontaktpersonen hos den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the contact person at the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Contact";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportmÜden ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det indfõrselssted, hvor varerne kom ind i landet/omrÜdet, for rapportering til Intrastat.;
                           ENU=Specifies the code of the port of entry where the items pass into your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry Point" }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omrÜde med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 13  ;1   ;Part      ;
                ApplicationArea=#Advanced;
                SubPageLink=Table ID=CONST(38),
                            Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.);
                PagePartID=Page9103;
                Visible=OpenApprovalEntriesExistForCurrUser;
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

    { 5   ;1   ;Part      ;
                ApplicationArea=#Advanced;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(Document No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9100;
                ProviderID=58;
                PartType=Page }

    { 1906354007;1;Part   ;
                Name=ApprovalFactBox;
                ApplicationArea=#Advanced;
                PagePartID=Page9092;
                Visible=FALSE;
                PartType=Page }

    { 27  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Advanced;
                PagePartID=Page193;
                Visible=FALSE;
                PartType=Page;
                ShowFilter=No }

    { 41  ;1   ;Part      ;
                Name=WorkflowStatus;
                ApplicationArea=#Advanced;
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
      DummyApplicationAreaSetup@1016 : Record 9178;
      CopyPurchDoc@1002 : Report 492;
      DocPrint@1003 : Codeunit 229;
      UserMgt@1004 : Codeunit 5700;
      ArchiveManagement@1005 : Codeunit 5063;
      PurchCalcDiscByType@1006 : Codeunit 66;
      ChangeExchangeRate@1001 : Page 511;
      ShipToOptions@1014 : 'Default (Company Address),Location,Custom Address';
      PayToOptions@1013 : 'Default (Vendor),Another Vendor';
      HasIncomingDocument@1008 : Boolean;
      DocNoVisible@1000 : Boolean;
      OpenApprovalEntriesExistForCurrUser@1012 : Boolean;
      OpenApprovalEntriesExist@1011 : Boolean;
      ShowWorkflowStatus@1007 : Boolean;
      CanCancelApprovalForRecord@1009 : Boolean;
      CreateIncomingDocumentEnabled@1010 : Boolean;
      ShowShippingOptionsWithLocation@1015 : Boolean;

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

    LOCAL PROCEDURE SetDocNoVisible@2();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
      DocType@1003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Reminder,FinChMemo';
    BEGIN
      DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::Quote,"No.");
    END;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
    BEGIN
      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
      HasIncomingDocument := "Incoming Document Entry No." <> 0;
      CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND ("No." <> '')
    END;

    LOCAL PROCEDURE ValidateShippingOption@8();
    BEGIN
      CASE ShipToOptions OF
        ShipToOptions::"Default (Company Address)",
        ShipToOptions::"Custom Address":
          VALIDATE("Location Code",'');
        ShipToOptions::Location:
          VALIDATE("Location Code");
      END;
    END;

    LOCAL PROCEDURE CalculateCurrentShippingAndPayToOption@36();
    BEGIN
      IF "Location Code" <> '' THEN
        ShipToOptions := ShipToOptions::Location
      ELSE
        IF ShipToAddressEqualsCompanyShipToAddress THEN
          ShipToOptions := ShipToOptions::"Default (Company Address)"
        ELSE
          ShipToOptions := ShipToOptions::"Custom Address";

      IF "Pay-to Vendor No." = "Buy-from Vendor No." THEN
        PayToOptions := PayToOptions::"Default (Vendor)"
      ELSE
        PayToOptions := PayToOptions::"Another Vendor";
    END;

    BEGIN
    END.
  }
}

