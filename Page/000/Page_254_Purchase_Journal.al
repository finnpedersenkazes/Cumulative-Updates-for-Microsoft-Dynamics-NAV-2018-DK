OBJECT Page 254 Purchase Journal
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=K›bskladde;
               ENU=Purchase Journal];
    SaveValues=Yes;
    SourceTable=Table81;
    DataCaptionExpr=DataCaption;
    DelayedInsert=Yes;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Side;
                                ENU=New,Process,Report,Page];
    OnInit=BEGIN
             TotalBalanceVisible := TRUE;
             BalanceVisible := TRUE;
             AmountVisible := TRUE;
           END;

    OnOpenPage=VAR
                 ServerConfigSettingHandler@1001 : Codeunit 6723;
                 JnlSelected@1000 : Boolean;
               BEGIN
                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::ODataV4 THEN
                   EXIT;

                 BalAccName := '';
                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 GenJnlManagement.TemplateSelection(PAGE::"Purchase Journal",2,FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);

                 ShowAmounts;
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  UpdateBalance;
                  EnableApplyEntriesAction;
                  SetUpNewLine(xRec,Balance,BelowxRec);
                  CLEAR(ShortcutDimCode);
                END;

    OnAfterGetCurrRecord=BEGIN
                           HasIncomingDocument := "Incoming Document Entry No." <> 0;
                           GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                           UpdateBalance;
                           EnableApplyEntriesAction;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 67      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 68      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 41      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 42      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 15;
                      Image=EditLines }
      { 43      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 14;
                      Promoted=No;
                      Image=GLRegisters;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 44      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 7       ;2   ;Action    ;
                      CaptionML=[DAN=Renummerer bilagsnumre;
                                 ENU=Renumber Document Numbers];
                      ToolTipML=[DAN=Omsorter tallene i kolonnen Bilagsnr. for at undg† bogf›ringsfejl, der skyldes, at bilagsnumrene ikke st†r i korrekt r‘kkef›lge. Efterudligninger og linjegrupperinger fastholdes.;
                                 ENU=Resort the numbers in the Document No. column to avoid posting errors because the document numbers are not in sequence. Entry applications and line groupings are preserved.];
                      ApplicationArea=#Basic,#Suite;
                      Image=EditLines;
                      OnAction=BEGIN
                                 RenumberDocumentNo
                               END;
                                }
      { 97      ;2   ;Action    ;
                      ShortCutKey=Shift+F11;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udlign;
                                 ENU=Apply Entries];
                      ToolTipML=[DAN=Anvend betalingsbel›bet p† en kladdelinje til et salgs- eller k›bsbilag, som allerede er bogf›rt for en debitor eller kreditor. Dette opdaterer bel›bet p† det bogf›rte bilag, og bilaget kan herefter delvist betales eller lukkes om betalt eller refunderet.;
                                 ENU=Apply the payment amount on a journal line to a sales or purchase document that was already posted for a customer or vendor. This updates the amount on the posted document, and the document can either be partially paid, or closed as paid or refunded.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 225;
                      Promoted=Yes;
                      Enabled=ApplyEntriesActionEnabled;
                      Image=ApplyEntries;
                      PromotedCategory=Process }
      { 98      ;2   ;Action    ;
                      CaptionML=[DAN=Inds‘t konv. RV-afrund.linjer;
                                 ENU=Insert Conv. LCY Rndg. Lines];
                      ToolTipML=[DAN=Inds‘t en afrundingslinjer i kladden. Denne afrundingslinjer afstemmes i RV, hvis bel›b i den udenlandske valuta og afstemmes. Derefter kan du bogf›re kladden.;
                                 ENU=Insert a rounding correction line in the journal. This rounding correction line will balance in LCY when amounts in the foreign currency also balance. You can then post the journal.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 407;
                      Image=InsertCurrency }
      { 21      ;2   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=Indg†ende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 19      ;3   ;Action    ;
                      Name=IncomingDocCard;
                      CaptionML=[DAN=Vis indg†ende bilag;
                                 ENU=View Incoming Document];
                      ToolTipML=[DAN=Se alle indg†ende bilagsrecords og vedh‘ftede filer, der findes for posten eller bilaget.;
                                 ENU=View any incoming document records and file attachments that exist for the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=HasIncomingDocument;
                      Image=ViewOrder;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                               END;
                                }
      { 17      ;3   ;Action    ;
                      Name=SelectIncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=V‘lg indg†ende bilag;
                                 ENU=Select Incoming Document];
                      ToolTipML=[DAN=V‘lg en indg†ende bilagsrecord og vedh‘ftet fil, der skal knyttes til posten eller bilaget.;
                                 ENU=Select an incoming document record and file attachment that you want to link to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Image=SelectLineToApply;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 VALIDATE("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RECORDID));
                               END;
                                }
      { 15      ;3   ;Action    ;
                      Name=IncomingDocAttachFile;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret indg†ende bilag ud fra fil;
                                 ENU=Create Incoming Document from File];
                      ToolTipML=[DAN=Opret en indg†ende bilagsrecord ved at v‘lge en fil, der skal vedh‘ftes, og knyt derefter den indg†ende bilagsrecord til posten eller bilaget.;
                                 ENU=Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NOT HasIncomingDocument;
                      Image=Attach;
                      OnAction=VAR
                                 IncomingDocumentAttachment@1000 : Record 133;
                               BEGIN
                                 IncomingDocumentAttachment.NewAttachmentFromGenJnlLine(Rec);
                               END;
                                }
      { 13      ;3   ;Action    ;
                      Name=RemoveIncomingDoc;
                      CaptionML=[DAN=Fjern indg†ende bilag;
                                 ENU=Remove Incoming Document];
                      ToolTipML=[DAN=Fjern eventuelle indg†ende bilagsrecords og vedh‘ftede filer.;
                                 ENU=Remove any incoming document records and file attachments.];
                      ApplicationArea=#Basic,#Suite;
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
      { 45      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 46      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F11;
                      CaptionML=[DAN=Afstem;
                                 ENU=Reconcile];
                      ToolTipML=[DAN=F† vist saldi for alle bankkonti, der er markeret til afstemning, normalt likviditetskonti.;
                                 ENU=View the balances on bank accounts that are marked for reconciliation, usually liquid accounts.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Reconcile;
                      OnAction=BEGIN
                                 GLReconcile.SetGenJnlLine(Rec);
                                 GLReconcile.RUN;
                               END;
                                }
      { 47      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=F† vist en testrapport, s† du kan finde og rette eventuelle fejl, f›r du udf›rer den faktiske bogf›ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Basic,#Suite;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintGenJnlLine(Rec);
                               END;
                                }
      { 48      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf›ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n†r du bogf›rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 GenJnlPost@1001 : Codeunit 231;
                               BEGIN
                                 GenJnlPost.Preview(Rec);
                               END;
                                }
      { 49      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden, og forbered udskrivning. V‘rdierne og m‘ngderne bogf›res p† de relevante konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=Side;
                                 ENU=Page] }
      { 23      ;2   ;Action    ;
                      Name=EditInExcel;
                      CaptionML=[DAN=Rediger i Excel;
                                 ENU=Edit in Excel];
                      ToolTipML=[DAN=Send dataene i kladden til en Excel-fil til analyse eller redigering.;
                                 ENU=Send the data in the journal to an Excel file for analysis or editing.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaasExcelAddinEnabled;
                      PromotedIsBig=Yes;
                      Image=Excel;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ODataUtility@1000 : Codeunit 6710;
                               BEGIN
                                 ODataUtility.EditJournalWorksheetInExcel(CurrPage.CAPTION,CurrPage.OBJECTID(FALSE),"Journal Batch Name","Journal Template Name");
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 37  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som kladden er baseret p†.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             GenJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           GenJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type bilag posten p† kladdelinjen er.;
                           ENU=Specifies the type of document that the entry on the journal line is.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det indg†ende bilag, som denne finanskladdelinje er oprettet til.;
                           ENU=Specifies the number of the incoming document that this general journal line is created for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Incoming Document Entry No.";
                Visible=FALSE;
                OnAssistEdit=BEGIN
                               IF "Incoming Document Entry No." > 0 THEN
                                 HYPERLINK(GetIncomingDocumentURL);
                             END;
                              }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No.";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som posten i kladdelinjen skal inds‘ttes p†.;
                           ENU=Specifies the type of account that the entry on the journal line will be posted to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Type";
                OnValidate=BEGIN
                             GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                             EnableApplyEntriesAction;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kontonummer, som posten i kladdelinjen skal inds‘ttes p†.;
                           ENU=Specifies the account number that the entry on the journal line will be posted to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account No.";
                OnValidate=BEGIN
                             GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den s‘lger eller indk›ber, der er tilknyttet kladdelinjen.;
                           ENU=Specifies the salesperson or purchaser who is linked to the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Salespers./Purch. Code";
                Visible=FALSE }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, som kladdelinjen er tilknyttet.;
                           ENU=Specifies the number of the campaign that the journal line is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver valutakoden for bel›bene p† kladdelinjen.;
                           ENU=Specifies the code of the currency for the amounts on the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Visible=FALSE;
                OnAssistEdit=BEGIN
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);

                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transaktionstypen.;
                           ENU=Specifies the type of transaction.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Posting Type" }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens handelstype for at knytte transaktioner, der er foretaget for denne kreditoren, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Bus. Posting Group" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Prod. Posting Group" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Group";
                Visible=FALSE }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bruttobel›b (bel›b inkl. moms), der er indeholdt i kladdelinjen.;
                           ENU=Specifies the total amount (including VAT) that the journal line consists of.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount;
                Visible=AmountVisible }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bruttobel›b i lokal valuta (bel›b inkl. moms), der er indeholdt i kladdelinjen.;
                           ENU=Specifies the total amount in local currency (including VAT) that the journal line consists of.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount (LCY)";
                Visible=AmountVisible }

    { 1000;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount";
                Visible=DebitCreditVisible }

    { 1001;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount";
                Visible=DebitCreditVisible }

    { 105 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsbel›bet, som er inkluderet i totalbel›bet.;
                           ENU=Specifies the amount of VAT that is included in the total amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Amount";
                Visible=FALSE }

    { 109 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem det beregnede momsbel›b og et momsbel›b, du har angivet manuelt.;
                           ENU=Specifies the difference between the calculated VAT amount and a VAT amount that you have entered manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Difference";
                Visible=FALSE }

    { 107 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som modkontomoms, som er inkluderet i totalbel›bet.;
                           ENU=Specifies the amount of Bal. VAT included in the total amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. VAT Amount";
                Visible=FALSE }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem det beregnede momsbel›b og det momsbel›b, du har angivet manuelt.;
                           ENU=Specifies the difference between the calculate VAT amount and the VAT amount that you have entered manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. VAT Difference";
                Visible=FALSE }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf›res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account Type";
                OnValidate=BEGIN
                             EnableApplyEntriesAction;
                           END;
                            }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf›res til, f.eks. en kassekonto ved kontantk›b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account No.";
                OnValidate=BEGIN
                             GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringstype, der er knyttet til den modkonto, som vil blive brugt, n†r du bogf›rer posten p† kladdelinjen.;
                           ENU=Specifies the general posting type associated with the balancing account that will be used when you post the entry on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Gen. Posting Type" }

    { 83  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den virksomhedsbogf›ringsgruppe, der er knyttet til den modkonto, som vil blive brugt, n†r du bogf›rer posten.;
                           ENU=Specifies the general business posting group code associated with the balancing account that will be used when you post the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Gen. Bus. Posting Group" }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den produktbogf›ringsgruppe, der er knyttet til den modkonto, der vil blive brugt, n†r du bogf›rer posten.;
                           ENU=Specifies the general product posting group code associated with the balancing account that will be used when you post the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Gen. Prod. Posting Group" }

    { 93  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for momsvirksomhedsbogf›ringsgruppen, som vil blive brugt, n†r du bogf›rer posten p† kladdelinjen.;
                           ENU=Specifies the code of the VAT business posting group that will be used when you post the entry on the journal line.];
                ApplicationArea=#Advanced;
                SourceExpr="Bal. VAT Bus. Posting Group";
                Visible=FALSE }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den momsproduktbogf›ringsgruppe, der vil blive brugt, n†r du bogf›rer posten p† kladdelinjen.;
                           ENU=Specifies the code of the VAT product posting group that will be used when you post the entry on the journal line.];
                ApplicationArea=#Advanced;
                SourceExpr="Bal. VAT Prod. Posting Group";
                Visible=FALSE }

    { 101 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den faktureringsdebitor eller -kreditor, som posten er tilknyttet.;
                           ENU=Specifies the number of the bill-to customer or pay-to vendor that the entry is linked to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to/Pay-to No.";
                Visible=FALSE }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressekoden for leveringen til debitoren eller ordren fra kreditoren, som posten er tilknyttet.;
                           ENU=Specifies the address code of the ship-to customer or order-from vendor that the entry is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to/Order Address Code";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[3];
                CaptionClass='1,2,3';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                           END;
                            }

    { 302 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[4];
                CaptionClass='1,2,4';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                           END;
                            }

    { 304 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[5];
                CaptionClass='1,2,5';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(5),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                           END;
                            }

    { 306 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[6];
                CaptionClass='1,2,6';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(6),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                           END;
                            }

    { 308 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[7];
                CaptionClass='1,2,7';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(7),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                           END;
                            }

    { 310 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[8];
                CaptionClass='1,2,8';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(8),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                           END;
                            }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjens nettobel›b (bel›b ekskl. moms), hvis du bruger denne kladdelinje til en faktura.;
                           ENU=Specifies the line's net amount (the amount excluding VAT) if you are using this journal line for an invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales/Purch. (LCY)";
                Visible=FALSE }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for fakturarabatten, hvis det er en faktura, der registreres i denne kladdelinje.;
                           ENU=Specifies the amount of the invoice discount if you are using this journal line for an invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inv. Discount (LCY)";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens forfaldsdato.;
                           ENU=Specifies the due date on the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Visible=FALSE }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bel›bet i posten skal v‘re betalt, for at der kan opn†s kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Discount Date";
                Visible=FALSE }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis betaling gennemf›res f›r eller p† den dato, der er angivet i feltet Kontantrabatdato.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Discount %";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogf›rt bilag, som dette bilag eller denne kladdelinje udlignes p†, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Doc. Type" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det bogf›rte bilag, som dette bilag eller denne kladdelinje udlignes p†, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Doc. No." }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id for poster, der udlignes, n†r du v‘lger handlingen Udlign poster.;
                           ENU=Specifies the ID of entries that will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to ID";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den tilknyttede post repr‘senterer en ubetalt faktura, som der findes et betalingsforslag, en rykker eller en rentenota til.;
                           ENU=Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="On Hold" }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at posten skal v‘re en rettelsespost. Du kan bruge feltet, hvis du har brug for at postere en rettelse til en konto.;
                           ENU=Specifies the entry as a corrective entry. You can use the field if you need to post a corrective entry to an account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Correction }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kommentar, der er relateret til registrering af en betaling.;
                           ENU=Specifies a comment related to registering a payment.];
                ApplicationArea=#Advanced;
                SourceExpr=Comment;
                Visible=FALSE }

    { 28  ;1   ;Group      }

    { 1902205001;2;Group  ;
                GroupType=FixedLayout }

    { 1901652501;3;Group  ;
                CaptionML=[DAN=Kontonavn;
                           ENU=Account Name] }

    { 33  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontoen.;
                           ENU=Specifies the name of the account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AccName;
                Editable=FALSE;
                ShowCaption=No }

    { 1903867901;3;Group  ;
                CaptionML=[DAN=Modkontonavn;
                           ENU=Bal. Account Name] }

    { 89  ;4   ;Field     ;
                CaptionML=[DAN=Modkontonavn;
                           ENU=Bal. Account Name];
                ToolTipML=[DAN=Angiver navnet p† den modkonto, der er indsat p† kladdelinjen.;
                           ENU=Specifies the name of the balancing account that has been entered on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BalAccName;
                Editable=FALSE }

    { 1903866901;3;Group  ;
                CaptionML=[DAN=Saldo;
                           ENU=Balance] }

    { 29  ;4   ;Field     ;
                Name=Balance;
                CaptionML=[DAN=Saldo;
                           ENU=Balance];
                ToolTipML=[DAN=Angiver den saldo, der er akkumuleret i k›bskladden p† den linje, hvor mark›ren er placeret.;
                           ENU=Specifies the balance that has accumulated in the purchase journal on the line where the cursor is.];
                ApplicationArea=#All;
                SourceExpr=Balance + "Balance (LCY)" - xRec."Balance (LCY)";
                AutoFormatType=1;
                Visible=BalanceVisible;
                Editable=FALSE }

    { 1902759701;3;Group  ;
                CaptionML=[DAN=Total balance;
                           ENU=Total Balance] }

    { 31  ;4   ;Field     ;
                Name=TotalBalance;
                CaptionML=[DAN=Total balance;
                           ENU=Total Balance];
                ToolTipML=[DAN=Viser den totale saldo i k›bskladden.;
                           ENU=Specifies the total balance in the purchase journal.];
                ApplicationArea=#All;
                SourceExpr=TotalBalance + "Balance (LCY)" - xRec."Balance (LCY)";
                AutoFormatType=1;
                Visible=TotalBalanceVisible;
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900919607;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Dimension Set ID=FIELD(Dimension Set ID);
                PagePartID=Page699;
                PartType=Page }

    { 11  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page193;
                PartType=Page;
                ShowFilter=No }

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
      GenJnlManagement@1002 : Codeunit 230;
      ReportPrint@1003 : Codeunit 228;
      ClientTypeManagement@1077 : Codeunit 4;
      ChangeExchangeRate@1001 : Page 511;
      GLReconcile@1000 : Page 345;
      CurrentJnlBatchName@1004 : Code[10];
      AccName@1005 : Text[50];
      BalAccName@1006 : Text[50];
      Balance@1007 : Decimal;
      TotalBalance@1008 : Decimal;
      ShowBalance@1009 : Boolean;
      ShowTotalBalance@1010 : Boolean;
      ShortcutDimCode@1011 : ARRAY [8] OF Code[20];
      HasIncomingDocument@1014 : Boolean;
      ApplyEntriesActionEnabled@1012 : Boolean;
      BalanceVisible@1015 : Boolean INDATASET;
      TotalBalanceVisible@1016 : Boolean INDATASET;
      AmountVisible@1018 : Boolean;
      DebitCreditVisible@1017 : Boolean;
      IsSaasExcelAddinEnabled@1013 : Boolean;

    LOCAL PROCEDURE UpdateBalance@1();
    BEGIN
      GenJnlManagement.CalcBalance(
        Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
      BalanceVisible := ShowBalance;
      TotalBalanceVisible := ShowTotalBalance;
    END;

    LOCAL PROCEDURE EnableApplyEntriesAction@2();
    BEGIN
      ApplyEntriesActionEnabled :=
        ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) OR
        ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]);
    END;

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ShowAmounts@8();
    VAR
      GLSetup@1000 : Record 98;
    BEGIN
      GLSetup.GET;
      AmountVisible := NOT (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
      DebitCreditVisible := NOT (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
    END;

    BEGIN
    END.
  }
}

