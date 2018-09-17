OBJECT Page 39 General Journal
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finanskladde;
               ENU=General Journal];
    SaveValues=Yes;
    SourceTable=Table81;
    DataCaptionExpr=DataCaption;
    DelayedInsert=Yes;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Bank,Udligning,L›nningsliste,Godkend,Side;
                                ENU=New,Process,Report,Bank,Application,Payroll,Approve,Page];
    OnInit=BEGIN
             TotalBalanceVisible := TRUE;
             BalanceVisible := TRUE;
             AmountVisible := TRUE;
           END;

    OnOpenPage=VAR
                 ServerConfigSettingHandler@1001 : Codeunit 6723;
                 PermissionManager@1002 : Codeunit 9002;
                 JnlSelected@1000 : Boolean;
               BEGIN
                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::ODataV4 THEN
                   EXIT;

                 BalAccName := '';
                 SetConrolVisibility;
                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   SetControlAppearanceFromBatch;
                   EXIT;
                 END;
                 GenJnlManagement.TemplateSelection(PAGE::"General Journal",0,FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                 SetControlAppearanceFromBatch;

                 IsSaaS := PermissionManager.SoftwareAsAService;
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                       HasIncomingDocument := "Incoming Document Entry No." <> 0;
                       SetUserInteractions;
                     END;

    OnNewRecord=BEGIN
                  UpdateBalance;
                  EnableApplyEntriesAction;
                  SetUpNewLine(xRec,Balance,BelowxRec);
                  CLEAR(ShortcutDimCode);
                  CLEAR(AccName);
                  SetUserInteractions;
                END;

    OnModifyRecord=BEGIN
                     SetUserInteractions;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                           UpdateBalance;
                           EnableApplyEntriesAction;
                           SetControlAppearance;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 75      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 76      ;2   ;Action    ;
                      Name=Dimensions;
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
      { 43      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 44      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 15;
                      Image=EditLines }
      { 45      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Post&er;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 14;
                      Promoted=No;
                      Image=GLRegisters;
                      PromotedCategory=Process }
      { 66      ;1   ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=F† vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvorn†r den blev sendt og hvorn†r den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Image=Approvals;
                      OnAction=VAR
                                 GenJournalLine@1001 : Record 81;
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 GetCurrentlySelectedLines(GenJournalLine);
                                 ApprovalsMgmt.ShowJournalApprovalEntries(GenJournalLine);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 46      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 13      ;2   ;Action    ;
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
      { 92      ;2   ;Action    ;
                      CaptionML=[DAN=Inds‘t konv. RV-afrund.linjer;
                                 ENU=Insert Conv. LCY Rndg. Lines];
                      ToolTipML=[DAN=Inds‘t en afrundingslinjer i kladden. Denne afrundingslinjer afstemmes i RV, hvis bel›b i den udenlandske valuta og afstemmes. Derefter kan du bogf›re kladden.;
                                 ENU=Insert a rounding correction line in the journal. This rounding correction line will balance in LCY when amounts in the foreign currency also balance. You can then post the journal.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 407;
                      Image=InsertCurrency }
      { 107     ;2   ;Separator ;
                      CaptionML=[DAN=-;
                                 ENU=-] }
      { 109     ;2   ;Action    ;
                      Name=GetStandardJournals;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent standardkladder;
                                 ENU=&Get Standard Journals];
                      ToolTipML=[DAN=V‘lg en standardfinanskladde, der skal inds‘ttes.;
                                 ENU=Select a standard general journal to be inserted.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=GetStandardJournal;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 StdGenJnl@1000 : Record 750;
                               BEGIN
                                 StdGenJnl.FILTERGROUP := 2;
                                 StdGenJnl.SETRANGE("Journal Template Name","Journal Template Name");
                                 StdGenJnl.FILTERGROUP := 0;

                                 IF PAGE.RUNMODAL(PAGE::"Standard General Journals",StdGenJnl) = ACTION::LookupOK THEN BEGIN
                                   StdGenJnl.CreateGenJnlFromStdJnl(StdGenJnl,CurrentJnlBatchName);
                                   MESSAGE(Text000,StdGenJnl.Code);
                                 END;

                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 108     ;2   ;Action    ;
                      Name=SaveAsStandardJournal;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Gem &som standardkladde;
                                 ENU=&Save as Standard Journal];
                      ToolTipML=[DAN=Angive de kladdelinjer, som du vil bruge senere som en standardkladde, inden du bogf›rer kladden.;
                                 ENU=Define the journal lines that you want to use later as a standard journal before you post the journal.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=SaveasStandardJournal;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 GenJnlBatch@1001 : Record 232;
                                 GeneralJnlLines@1004 : Record 81;
                                 StdGenJnl@1002 : Record 750;
                                 SaveAsStdGenJnl@1003 : Report 750;
                               BEGIN
                                 GeneralJnlLines.SETFILTER("Journal Template Name","Journal Template Name");
                                 GeneralJnlLines.SETFILTER("Journal Batch Name",CurrentJnlBatchName);
                                 CurrPage.SETSELECTIONFILTER(GeneralJnlLines);
                                 GeneralJnlLines.COPYFILTERS(Rec);

                                 GenJnlBatch.GET("Journal Template Name",CurrentJnlBatchName);
                                 SaveAsStdGenJnl.Initialise(GeneralJnlLines,GenJnlBatch);
                                 SaveAsStdGenJnl.RUNMODAL;
                                 IF NOT SaveAsStdGenJnl.GetStdGeneralJournal(StdGenJnl) THEN
                                   EXIT;

                                 MESSAGE(Text001,StdGenJnl.Code);
                               END;
                                }
      { 49      ;2   ;Action    ;
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
      { 50      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      CaptionML=[DAN=B&ogf›r;
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
      { 48      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf›ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n†r du bogf›rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=No;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 GenJnlPost@1000 : Codeunit 231;
                               BEGIN
                                 GenJnlPost.Preview(Rec);
                               END;
                                }
      { 51      ;2   ;Action    ;
                      Name=PostAndPrint;
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
      { 58      ;2   ;Action    ;
                      Name=DeferralSchedule;
                      CaptionML=[DAN=Periodiseringsplan;
                                 ENU=Deferral Schedule];
                      ToolTipML=[DAN=F† vist eller rediger den periodiseringsplan, der styrer, hvordan udgifter eller indt‘gter periodiseres til forskellige regnskabsperioder, n†r kladdelinjen bogf›res.;
                                 ENU=View or edit the deferral schedule that governs how expenses or revenue are deferred to different accounting periods when the journal line is posted.];
                      ApplicationArea=#Suite;
                      Image=PaymentPeriod;
                      OnAction=BEGIN
                                 IF "Account Type" = "Account Type"::"Fixed Asset" THEN
                                   ERROR(AccTypeNotSupportedErr);

                                 ShowDeferrals("Posting Date","Currency Code");
                               END;
                                }
      { 56      ;2   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=Indg†ende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 54      ;3   ;Action    ;
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
      { 52      ;3   ;Action    ;
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
      { 47      ;3   ;Action    ;
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
      { 42      ;3   ;Action    ;
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
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=B&ank;
                                 ENU=B&ank] }
      { 11      ;2   ;Action    ;
                      Name=ImportBankStatement;
                      CaptionML=[DAN=Import‚r bankkontoudtog;
                                 ENU=Import Bank Statement];
                      ToolTipML=[DAN=Import‚r elektroniske bankkontoudtog fra banken for at udfylde med data om faktiske banktransaktioner.;
                                 ENU=Import electronic bank statements from your bank to populate with data about actual bank transactions.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Visible=FALSE;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IF FINDLAST THEN;
                                 ImportBankStatement;
                               END;
                                }
      { 21      ;2   ;Action    ;
                      Name=ShowStatementLineDetails;
                      CaptionML=[DAN=Oplysninger om bankkontoudtog;
                                 ENU=Bank Statement Details];
                      ToolTipML=[DAN=Vis indholdet af den importerede kontoudtogsfil, f.eks. et kontonummer, en bogf›ringsdato og bel›b.;
                                 ENU=View the content of the imported bank statement file, such as account number, posting date, and amounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1221;
                      RunPageLink=Data Exch. No.=FIELD(Data Exch. Entry No.),
                                  Line No.=FIELD(Data Exch. Line No.);
                      Promoted=Yes;
                      Visible=FALSE;
                      PromotedIsBig=Yes;
                      Image=ExternalDocument;
                      PromotedCategory=Category4 }
      { 23      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F11;
                      CaptionML=[DAN=Afstem;
                                 ENU=Reconcile];
                      ToolTipML=[DAN=F† vist saldi for alle bankkonti, der er markeret til afstemning, normalt likviditetskonti.;
                                 ENU=View the balances on bank accounts that are marked for reconciliation, usually liquid accounts.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Reconcile;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 GLReconcile.SetGenJnlLine(Rec);
                                 GLReconcile.RUN;
                               END;
                                }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=Udligning;
                                 ENU=Application] }
      { 91      ;2   ;Action    ;
                      Name=Apply Entries;
                      ShortCutKey=Shift+F11;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udlign poster;
                                 ENU=Apply Entries];
                      ToolTipML=[DAN=Anvend betalingsbel›bet p† en kladdelinje til et salgs- eller k›bsbilag, som allerede er bogf›rt for en debitor eller kreditor. Dette opdaterer bel›bet p† det bogf›rte bilag, og bilaget kan herefter delvist betales eller lukkes om betalt eller refunderet.;
                                 ENU=Apply the payment amount on a journal line to a sales or purchase document that was already posted for a customer or vendor. This updates the amount on the posted document, and the document can either be partially paid, or closed as paid or refunded.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 225;
                      Promoted=Yes;
                      Enabled=ApplyEntriesActionEnabled;
                      Image=ApplyEntries;
                      PromotedCategory=Category5 }
      { 27      ;2   ;Action    ;
                      Name=Match;
                      CaptionML=[DAN=Udlign automatisk;
                                 ENU=Apply Automatically];
                      ToolTipML=[DAN=Udlign betalinger med deres relaterede †bne poster ud fra datatilknytningerne mellem banktransaktionens tekst og postoplysningerne.;
                                 ENU=Apply payments to their related open entries based on data matches between bank transaction text and entry information.];
                      ApplicationArea=#Advanced;
                      RunObject=Codeunit 1250;
                      Promoted=Yes;
                      Visible=FALSE;
                      PromotedIsBig=Yes;
                      Image=MapAccounts;
                      PromotedCategory=Category5 }
      { 34      ;2   ;Action    ;
                      Name=AddMappingRule;
                      CaptionML=[DAN=Knyt tekst til konto;
                                 ENU=Map Text to Account];
                      ToolTipML=[DAN=Tilknyt tekst p† betalinger med debet-, kredit- og modkonti, s† betalingerne bogf›res til disse konti. Betalingerne udlignes ikke med fakturaer eller kreditnotaer og egner sig til tilbagevendende kontantbetalinger eller udgifter.;
                                 ENU=Associate text on payments with debit, credit, and balancing accounts, so payments are posted to the accounts when you post payments. The payments are not applied to invoices or credit memos, and are suited for recurring cash receipts or expenses.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Visible=FALSE;
                      PromotedIsBig=Yes;
                      Image=CheckRulesSyntax;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 TextToAccMapping@1000 : Record 1251;
                               BEGIN
                                 TextToAccMapping.InsertRec(Rec);
                               END;
                                }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=L›nningsli&ste;
                                 ENU=Payro&ll] }
      { 29      ;2   ;Action    ;
                      Name=ImportPayrollFile;
                      CaptionML=[DAN=Import‚r l›nfil;
                                 ENU=Import Payroll File];
                      ToolTipML=[DAN=Import‚r en l›nfil, som du v‘lger.;
                                 ENU=Import a payroll file that you select.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=FALSE;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Category6;
                      OnAction=VAR
                                 GeneralLedgerSetup@1000 : Record 98;
                                 ImportPayrollTransaction@1001 : Codeunit 1202;
                               BEGIN
                                 GeneralLedgerSetup.GET;
                                 GeneralLedgerSetup.TESTFIELD("Payroll Trans. Import Format");
                                 IF FINDLAST THEN;
                                 ImportPayrollTransaction.SelectAndImportPayrollDataToGL(Rec,GeneralLedgerSetup."Payroll Trans. Import Format");
                               END;
                                }
      { 96      ;2   ;Action    ;
                      Name=ImportPayrollTransactions;
                      CaptionML=[DAN=Import‚r l›ntransaktioner;
                                 ENU=Import Payroll Transactions];
                      ToolTipML=[DAN=Import‚r l›ntransaktioner;
                                 ENU=Import Payroll Transactions];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=ImportPayrollTransactionsAvailable;
                      PromotedIsBig=Yes;
                      Image=ImportChartOfAccounts;
                      PromotedCategory=Category6;
                      OnAction=BEGIN
                                 IF FINDLAST THEN;
                                 PayrollManagement.ImportPayroll(Rec);
                               END;
                                }
      { 64      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 82      ;2   ;ActionGroup;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send godkendelsesanmodning;
                                 ENU=Send Approval Request];
                      Image=SendApprovalRequest }
      { 62      ;3   ;Action    ;
                      Name=SendApprovalRequestJournalBatch;
                      CaptionML=[DAN=Kladdenavn;
                                 ENU=Journal Batch];
                      ToolTipML=[DAN=Send alle kladdelinjer til godkendelse. Ogs† dem, du muligvis ikke f†r vist p† grund af filtre.;
                                 ENU=Send all journal lines for approval, also those that you may not see because of filters.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NOT OpenApprovalEntriesOnBatchOrAnyJnlLineExist AND CanRequestFlowApprovalForBatchAndAllLines;
                      Image=SendApprovalRequest;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.TrySendJournalBatchApprovalRequest(Rec);
                                 SetControlAppearanceFromBatch;
                                 SetControlAppearance;
                               END;
                                }
      { 84      ;3   ;Action    ;
                      Name=SendApprovalRequestJournalLine;
                      CaptionML=[DAN=Markerede kladdelinjer;
                                 ENU=Selected Journal Lines];
                      ToolTipML=[DAN=Send de valgte kladdelinjer til godkendelse.;
                                 ENU=Send selected journal lines for approval.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NOT OpenApprovalEntriesOnBatchOrCurrJnlLineExist AND CanRequestFlowApprovalForBatchAndCurrentLine;
                      Image=SendApprovalRequest;
                      OnAction=VAR
                                 GenJournalLine@1001 : Record 81;
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 GetCurrentlySelectedLines(GenJournalLine);
                                 ApprovalsMgmt.TrySendJournalLineApprovalRequests(GenJournalLine);
                                 SetControlAppearanceFromBatch;
                               END;
                                }
      { 86      ;2   ;ActionGroup;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesanmodning;
                                 ENU=Cancel Approval Request];
                      Image=Cancel }
      { 60      ;3   ;Action    ;
                      Name=CancelApprovalRequestJournalBatch;
                      CaptionML=[DAN=Kladdenavn;
                                 ENU=Journal Batch];
                      ToolTipML=[DAN=Annuller afsendelse af alle kladdelinjer til godkendelse. Ogs† dem, du muligvis ikke f†r vist p† grund af filtre.;
                                 ENU=Cancel sending all journal lines for approval, also those that you may not see because of filters.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=CanCancelApprovalForJnlBatch OR CanCancelFlowApprovalForBatch;
                      Image=CancelApprovalRequest;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.TryCancelJournalBatchApprovalRequest(Rec);
                                 SetControlAppearance;
                                 SetControlAppearanceFromBatch;
                               END;
                                }
      { 88      ;3   ;Action    ;
                      Name=CancelApprovalRequestJournalLine;
                      CaptionML=[DAN=Markerede kladdelinjer;
                                 ENU=Selected Journal Lines];
                      ToolTipML=[DAN=Annuller afsendelse af valgte kladdelinjer til godkendelse.;
                                 ENU=Cancel sending selected journal lines for approval.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=CanCancelApprovalForJnlLine OR CanCancelFlowApprovalForLine;
                      Image=CancelApprovalRequest;
                      OnAction=VAR
                                 GenJournalLine@1001 : Record 81;
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 GetCurrentlySelectedLines(GenJournalLine);
                                 ApprovalsMgmt.TryCancelJournalLineApprovalRequests(GenJournalLine);
                               END;
                                }
      { 115     ;2   ;Action    ;
                      Name=CreateFlow;
                      CaptionML=[DAN=Opret et workflow;
                                 ENU=Create a Flow];
                      ToolTipML=[DAN=Opret et nyt workflow fra en liste over relevante workflowskabeloner.;
                                 ENU=Create a new Flow from a list of relevant Flow templates.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=IsSaaS;
                      Image=Flow;
                      OnAction=VAR
                                 FlowServiceManagement@1001 : Codeunit 6400;
                                 FlowTemplateSelector@1000 : Page 6400;
                               BEGIN
                                 // Opens page 6400 where the user can use filtered templates to create new flows.
                                 FlowTemplateSelector.SetSearchText(FlowServiceManagement.GetJournalTemplateFilter);
                                 FlowTemplateSelector.RUN;
                               END;
                                }
      { 116     ;2   ;Action    ;
                      Name=SeeFlows;
                      CaptionML=[DAN=Se mine workflows;
                                 ENU=See my Flows];
                      ToolTipML=[DAN=F† vist og konfigurer de workflowforekomster, du har oprettet.;
                                 ENU=View and configure Flows that you created.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 6401;
                      Image=Flow }
      { 78      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 74      ;2   ;Action    ;
                      Name=Approve;
                      CaptionML=[DAN=Godkend;
                                 ENU=Approve];
                      ToolTipML=[DAN=Godkend de anmodede ‘ndringer.;
                                 ENU=Approve the requested changes.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.ApproveGenJournalLineRequest(Rec);
                               END;
                                }
      { 72      ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Afvis;
                                 ENU=Reject];
                      ToolTipML=[DAN=Afvis godkendelsesanmodningen.;
                                 ENU=Reject the approval request.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.RejectGenJournalLineRequest(Rec);
                               END;
                                }
      { 70      ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsen til en stedfortr‘dende godkender.;
                                 ENU=Delegate the approval to a substitute approver.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=Delegate;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.DelegateGenJournalLineRequest(Rec);
                               END;
                                }
      { 68      ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bem‘rkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=ViewComments;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 GenJournalBatch@1001 : Record 232;
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 IF OpenApprovalEntriesOnJnlLineExist THEN
                                   ApprovalsMgmt.GetApprovalComment(Rec)
                                 ELSE
                                   IF OpenApprovalEntriesOnJnlBatchExist THEN
                                     IF GenJournalBatch.GET("Journal Template Name","Journal Batch Name") THEN
                                       ApprovalsMgmt.GetApprovalComment(GenJournalBatch);
                               END;
                                }
      { 98      ;1   ;ActionGroup;
                      CaptionML=[DAN=Startsaldo;
                                 ENU=Opening Balance] }
      { 100     ;2   ;ActionGroup;
                      Name=Prepare journal;
                      CaptionML=[DAN=Forbered kladde;
                                 ENU=Prepare journal];
                      Image=Journals }
      { 102     ;3   ;Action    ;
                      Name=[G/L Accounts Opening balance ];
                      CaptionML=[DAN=Finanskonti - startsaldo;
                                 ENU=G/L Accounts Opening balance];
                      ToolTipML=[DAN=Opretter en finanskladdelinje pr. finanskonto for at tillade manuel indtastning af †bne saldi p† finanskonti under konfiguration af en ny virksomhed;
                                 ENU=Creates general journal line per G/L account to enable manual entry of G/L account open balances during the setup of a new company];
                      ApplicationArea=#Basic,#Suite;
                      Image=TransferToGeneralJournal;
                      OnAction=VAR
                                 GLAccount@1002 : Record 15;
                                 CreateGLAccJournalLines@1000 : Report 8610;
                                 DocumentTypes@1001 : Option;
                               BEGIN
                                 GLAccount.SETRANGE("Account Type",GLAccount."Account Type"::Posting);
                                 GLAccount.SETRANGE("Income/Balance",GLAccount."Income/Balance"::"Balance Sheet");
                                 GLAccount.SETRANGE("Direct Posting",TRUE);
                                 GLAccount.SETRANGE(Blocked,FALSE);
                                 CreateGLAccJournalLines.SETTABLEVIEW(GLAccount);
                                 CreateGLAccJournalLines.InitializeRequest(DocumentTypes,TODAY,"Journal Template Name","Journal Batch Name",'');
                                 CreateGLAccJournalLines.USEREQUESTPAGE(FALSE);
                                 COMMIT;  // Commit is required for Create Lines.
                                 CreateGLAccJournalLines.RUN;
                               END;
                                }
      { 104     ;3   ;Action    ;
                      Name=Customers Opening balance;
                      CaptionML=[DAN=Startsaldo for debitorer;
                                 ENU=Customers Opening balance];
                      ToolTipML=[DAN=Opretter en finanskladdelinje pr. debitor for at tillade manuel indtastning af †bne saldi for kunden under konfiguration af en ny virksomhed;
                                 ENU=Creates general journal line per Customer to enable manual entry of Customer open balances during the setup of a new company];
                      ApplicationArea=#Basic,#Suite;
                      Image=TransferToGeneralJournal;
                      OnAction=VAR
                                 Customer@1000 : Record 18;
                                 CreateCustomerJournalLines@1002 : Report 8611;
                                 DocumentTypes@1001 : Option;
                               BEGIN
                                 Customer.SETRANGE(Blocked,Customer.Blocked::" ");
                                 CreateCustomerJournalLines.SETTABLEVIEW(Customer);
                                 CreateCustomerJournalLines.InitializeRequest(DocumentTypes,TODAY,TODAY);
                                 CreateCustomerJournalLines.InitializeRequestTemplate("Journal Template Name","Journal Batch Name",'');
                                 CreateCustomerJournalLines.USEREQUESTPAGE(FALSE);
                                 COMMIT;  // Commit is required for Create Lines.
                                 CreateCustomerJournalLines.RUN;
                               END;
                                }
      { 106     ;3   ;Action    ;
                      Name=Vendors Opening balance;
                      CaptionML=[DAN=Startsaldo for leverand›rer;
                                 ENU=Vendors Opening balance];
                      ToolTipML=[DAN=Opretter en finanskladdelinje for hver kreditor. Derved kan du manuelt angive †bne saldi for kreditorer, n†r du opretter en ny virksomhed.;
                                 ENU=Creates a general journal line for each vendor. This lets you manually enter open balances for vendors when you set up a new company.];
                      ApplicationArea=#Basic,#Suite;
                      Image=TransferToGeneralJournal;
                      OnAction=VAR
                                 Vendor@1002 : Record 23;
                                 CreateVendorJournalLines@1001 : Report 8612;
                                 DocumentTypes@1000 : Option;
                               BEGIN
                                 Vendor.SETRANGE(Blocked,Vendor.Blocked::" ");
                                 CreateVendorJournalLines.SETTABLEVIEW(Vendor);
                                 CreateVendorJournalLines.InitializeRequest(DocumentTypes,TODAY,TODAY);
                                 CreateVendorJournalLines.InitializeRequestTemplate("Journal Template Name","Journal Batch Name",'');
                                 CreateVendorJournalLines.USEREQUESTPAGE(FALSE);
                                 COMMIT;  // Commit is required for Create Lines.
                                 CreateVendorJournalLines.RUN;
                               END;
                                }
      { 110     ;1   ;ActionGroup;
                      CaptionML=[DAN=Side;
                                 ENU=Page] }
      { 111     ;2   ;Action    ;
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
                      PromotedCategory=Category8;
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

    { 39  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p† kladdek›rslen.;
                           ENU=Specifies the name of the journal batch.];
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
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                StyleExpr=StyleTxt }

    { 83  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato p† bilaget, der danner basis for posten p† kladdelinjen.;
                           ENU=Specifies the date on the document that provides the basis for the entry on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Visible=FALSE;
                StyleExpr=StyleTxt }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type bilag posten p† kladdelinjen er.;
                           ENU=Specifies the type of document that the entry on the journal line is.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type";
                StyleExpr=StyleTxt }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 19  ;2   ;Field     ;
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

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No.";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det eksterne bilagsnummer, der skal udl‘ses i betalingsfilen.;
                           ENU=Specifies the external document number that will be exported in the payment file.];
                ApplicationArea=#Advanced;
                SourceExpr="Applies-to Ext. Doc. No.";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som posten i kladdelinjen skal inds‘ttes p†.;
                           ENU=Specifies the type of account that the entry on the journal line will be posted to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Type";
                StyleExpr=StyleTxt;
                OnValidate=BEGIN
                             GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                             SetUserInteractions;
                             EnableApplyEntriesAction;
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kontonummer, som posten i kladdelinjen skal inds‘ttes p†.;
                           ENU=Specifies the account number that the entry on the journal line will be posted to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account No.";
                StyleExpr=StyleTxt;
                OnValidate=BEGIN
                             GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                             ShowShortcutDimCode(ShortcutDimCode);
                             SetUserInteractions;
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                StyleExpr=StyleTxt }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om indbetaler, der er importeret sammen med kontoudtogsfilen fra banken.;
                           ENU=Specifies payer information that is imported with the bank statement file.];
                ApplicationArea=#Advanced;
                SourceExpr="Payer Information";
                Visible=FALSE;
                StyleExpr=StyleTxt }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transaktionsoplysninger, der er importeret sammen med kontoudtogsfilen fra banken.;
                           ENU=Specifies transaction information that is imported with the bank statement file.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Information";
                Visible=FALSE;
                StyleExpr=StyleTxt }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den koncernvirksomhed, som posten er afledt fra i en konsolideret virksomhed.;
                           ENU=Specifies the code of the business unit that the entry derives from in a consolidated company.];
                ApplicationArea=#Advanced;
                SourceExpr="Business Unit Code";
                Visible=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den s‘lger eller indk›ber, der er tilknyttet kladdelinjen.;
                           ENU=Specifies the salesperson or purchaser who is linked to the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Salespers./Purch. Code";
                Visible=FALSE }

    { 93  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, som kladdelinjen er tilknyttet.;
                           ENU=Specifies the number of the campaign the journal line is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Visible=FALSE }

    { 67  ;2   ;Field     ;
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

    { 112 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten indg†r i en trekantshandel. Hvis den g›r, er feltet markeret.;
                           ENU=Specifies whether the entry was part of a 3-party trade. If it was, there is a check mark in the field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="EU 3-Party Trade" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringstype, der bliver brugt, n†r du bogf›rer posten p† denne kladdelinje.;
                           ENU=Specifies the general posting type that will be used when you post the entry on this journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Posting Type" }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Bus. Posting Group" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Prod. Posting Group" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den momsvirksomhedsbogf›ringsgruppe, der vil blive brugt, n†r du bogf›rer posten p† kladdelinjen.;
                           ENU=Specifies the VAT business posting group code that will be used when you post the entry on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group";
                Visible=FALSE }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsproduktbogf›ringsgruppen. Knytter forretningstransaktioner for varen, ressourcen eller finanskontoen til finansregnskabet for at g›re rede for momsbel›bet som f›lge af handlen med den p†g‘ldende record.;
                           ENU=Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der skal indg† i kladdelinjen.;
                           ENU=Specifies the quantity of items to be included on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Quantity;
                Visible=False }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bruttobel›b (bel›b inkl. moms), der er indeholdt i kladdelinjen.;
                           ENU=Specifies the total amount (including VAT) that the journal line consists of.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount;
                Visible=AmountVisible;
                StyleExpr=StyleTxt }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bruttobel›b i lokal valuta (bel›b inkl. moms), der er indeholdt i kladdelinjen.;
                           ENU=Specifies the total amount in local currency (including VAT) that the journal line consists of.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount (LCY)";
                Visible=AmountVisible }

    { 1000;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bruttobel›b (bel›b inkl. moms), som er indeholdt i kladdelinjen, hvis bel›bet er et debetbel›b.;
                           ENU=Specifies the total amount (including VAT) that the journal line consists of, if it is a debit amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount";
                Visible=DebitCreditVisible }

    { 1001;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bruttobel›b (bel›b inkl. moms), som er indeholdt i kladdelinjen, hvis bel›bet er et kreditbel›b.;
                           ENU=Specifies the total amount (including VAT) that the journal line consists of, if it is a credit amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount";
                Visible=DebitCreditVisible }

    { 101 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det momsbel›b, som er inkluderet i totalbel›bet.;
                           ENU=Specifies the amount of VAT included in the total amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Amount";
                Visible=FALSE }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem det beregnede momsbel›b og det momsbel›b, du har angivet manuelt.;
                           ENU=Specifies the difference between the calculate VAT amount and the VAT amount that you have entered manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Difference";
                Visible=FALSE }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som modkontomoms, som er inkluderet i totalbel›bet.;
                           ENU=Specifies the amount of Bal. VAT included in the total amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. VAT Amount";
                Visible=FALSE }

    { 105 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem det beregnede momsbel›b og det momsbel›b, du har angivet manuelt.;
                           ENU=Specifies the difference between the calculate VAT amount and the VAT amount that you have entered manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. VAT Difference";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den modkontotype, der skal bruges i denne kladdelinje.;
                           ENU=Specifies the code for the balancing account type that should be used in this journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account Type";
                StyleExpr=StyleTxt;
                OnValidate=BEGIN
                             EnableApplyEntriesAction;
                           END;
                            }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som posten i kladdelinjen skal modposteres p† (f.eks. Kasse ved kontantk›b).;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account to which a balancing entry for the journal line will posted (for example, a cash account for cash purchases).];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account No.";
                StyleExpr=StyleTxt;
                OnValidate=BEGIN
                             GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringstype, der er knyttet til den modkonto, som vil blive brugt, n†r du bogf›rer posten p† kladdelinjen.;
                           ENU=Specifies the general posting type associated with the balancing account that will be used when you post the entry on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Gen. Posting Type" }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den virksomhedsbogf›ringsgruppe, der er knyttet til den modkonto, som vil blive brugt, n†r du bogf›rer posten.;
                           ENU=Specifies the general business posting group code associated with the balancing account that will be used when you post the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Gen. Bus. Posting Group" }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den produktbogf›ringsgruppe, der er knyttet til den modkonto, der vil blive brugt, n†r du bogf›rer posten.;
                           ENU=Specifies the general product posting group code associated with the balancing account that will be used when you post the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Gen. Prod. Posting Group" }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den periodiseringsskabelon, der styrer, hvordan udgifter eller indt‘gter periodiseres til forskellige regnskabsperioder, n†r udgiften eller indt‘gten indtr‘ffer.;
                           ENU=Specifies the deferral template that governs how expenses or revenue are deferred to the different accounting periods when the expenses or revenue were incurred.];
                ApplicationArea=#Suite;
                SourceExpr="Deferral Code" }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for momsvirksomhedsbogf›ringsgruppen, som vil blive brugt, n†r du bogf›rer posten p† kladdelinjen.;
                           ENU=Specifies the code of the VAT business posting group that will be used when you post the entry on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. VAT Bus. Posting Group";
                Visible=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den momsproduktbogf›ringsgruppe, der vil blive brugt, n†r du bogf›rer posten p† kladdelinjen.;
                           ENU=Specifies the code of the VAT product posting group that will be used when you post the entry on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. VAT Prod. Posting Group";
                Visible=FALSE }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den faktureringsdebitor eller -kreditor, som posten er tilknyttet.;
                           ENU=Specifies the number of the bill-to customer or pay-to vendor that the entry is linked to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to/Pay-to No.";
                Visible=FALSE }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressekoden for leveringen til debitoren eller ordren fra kreditoren, som posten er tilknyttet.;
                           ENU=Specifies the address code of the ship-to customer or order-from vendor that the entry is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to/Order Address Code";
                Visible=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 63  ;2   ;Field     ;
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
                ToolTipML=[DAN=Angiver, hvilken kode der repr‘senterer de betalingsbetingelser, der g‘lder for posten p† kladdelinjen.;
                           ENU=Specifies the code that represents the payments terms that apply to the entry on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at finanskladdelinjen automatisk er udlignet med en tilsvarende betaling ved hj‘lp af funktionen Anvend automatisk.;
                           ENU=Specifies that the general journal line has been automatically applied with a matching payment using the Apply Automatically function.];
                ApplicationArea=#Advanced;
                SourceExpr="Applied Automatically";
                Visible=FALSE;
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                Name=Applied;
                CaptionML=[DAN=Udlignet;
                           ENU=Applied];
                ToolTipML=[DAN=Angiver, om recorden p† linjen er blevet udlignet.;
                           ENU=Specifies if the record on the line has been applied.];
                ApplicationArea=#Advanced;
                SourceExpr=IsApplied;
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogf›rt bilag, som dette bilag eller denne kladdelinje udlignes p†, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Doc. Type";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det bogf›rte bilag, som dette bilag eller denne kladdelinje udlignes p†, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Doc. No.";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id for poster, der udlignes, n†r du v‘lger handlingen Udlign poster.;
                           ENU=Specifies the ID of entries that will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to ID";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kladdelinjen er faktureret, og om du udf›rer k›rslen betalingsforslag eller opretter en rentenota eller en rykker.;
                           ENU=Specifies if the journal line has been invoiced, and you execute the payment suggestions batch job, or you create a finance charge memo or reminder.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="On Hold";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den betalingstype, der skal bruges for posten p† udbetalingskladdelinjen.;
                           ENU=Specifies the code for the payment type to be used for the entry on the payment journal line.];
                ApplicationArea=#Advanced;
                SourceExpr="Bank Payment Type";
                Visible=FALSE }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den †rsagskode, der er indtastet p† kladdelinerne.;
                           ENU=Specifies the reason code that has been entered on the journal lines.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 114 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at posten skal v‘re en rettelsespost. Du kan bruge feltet, hvis du har brug for at postere en rettelse til en konto.;
                           ENU=Specifies the entry as a corrective entry. You can use the field if you need to post a corrective entry to an account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Correction }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kommentar, der er relateret til registrering af en betaling.;
                           ENU=Specifies a comment related to registering a payment.];
                ApplicationArea=#Advanced;
                SourceExpr=Comment }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en identifikation af den Direct Debit-betalingsaftale, der bruges p† kladdelinjerne til behandling af Direct Debit-opkr‘vning.;
                           ENU=Specifies the identification of the direct-debit mandate that is being used on the journal lines to process a direct debit collection.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Debit Mandate ID";
                Visible=FALSE }

    { 30  ;1   ;Group      }

    { 1901776101;2;Group  ;
                GroupType=FixedLayout }

    { 1900545301;3;Group  ;
                CaptionML=[DAN=Kontonavn;
                           ENU=Account Name] }

    { 35  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontoen.;
                           ENU=Specifies the name of the account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AccName;
                Editable=FALSE;
                ShowCaption=No }

    { 1900295701;3;Group  ;
                CaptionML=[DAN=Modkontonavn;
                           ENU=Bal. Account Name] }

    { 37  ;4   ;Field     ;
                CaptionML=[DAN=Modkontonavn;
                           ENU=Bal. Account Name];
                ToolTipML=[DAN=Angiver navnet p† den modkonto, der er indtastet p† kladdelinjen.;
                           ENU=Specifies the name of the balancing account that has been entered on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BalAccName;
                Editable=FALSE }

    { 1902759701;3;Group  ;
                CaptionML=[DAN=Saldo;
                           ENU=Balance] }

    { 31  ;4   ;Field     ;
                Name=Balance;
                CaptionML=[DAN=Saldo;
                           ENU=Balance];
                ToolTipML=[DAN=Angiver den saldo, der er akkumuleret i finanskladden p† den linje, hvor mark›ren er placeret.;
                           ENU=Specifies the balance that has accumulated in the general journal on the line where the cursor is.];
                ApplicationArea=#All;
                SourceExpr=Balance + "Balance (LCY)" - xRec."Balance (LCY)";
                AutoFormatType=1;
                Visible=BalanceVisible;
                Editable=FALSE }

    { 1901652501;3;Group  ;
                CaptionML=[DAN=Total balance;
                           ENU=Total Balance] }

    { 33  ;4   ;Field     ;
                Name=TotalBalance;
                CaptionML=[DAN=Total balance;
                           ENU=Total Balance];
                ToolTipML=[DAN=Viser den totale saldo i finanskladden.;
                           ENU=Specifies the total balance in the general journal.];
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

    { 154 ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page193;
                PartType=Page;
                ShowFilter=No }

    { 94  ;1   ;Part      ;
                Name=WorkflowStatusBatch;
                CaptionML=[DAN=Kladdeworkflows;
                           ENU=Batch Workflows];
                ApplicationArea=#Suite;
                PagePartID=Page1528;
                Visible=ShowWorkflowStatusOnBatch;
                Enabled=FALSE;
                Editable=FALSE;
                PartType=Page;
                ShowFilter=No }

    { 90  ;1   ;Part      ;
                Name=WorkflowStatusLine;
                CaptionML=[DAN=Linjeworkflows;
                           ENU=Line Workflows];
                ApplicationArea=#Suite;
                PagePartID=Page1528;
                Visible=ShowWorkflowStatusOnLine;
                Enabled=FALSE;
                Editable=FALSE;
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
      PayrollManagement@1027 : Codeunit 1660;
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
      Text000@1012 : TextConst 'DAN=Der er indsat finanskladdelinjer fra standardfinanskladden %1.;ENU=General Journal lines have been successfully inserted from Standard General Journal %1.';
      Text001@1013 : TextConst 'DAN=Standardfinanskladden %1 er oprettet.;ENU=Standard General Journal %1 has been successfully created.';
      HasIncomingDocument@1018 : Boolean;
      ApplyEntriesActionEnabled@1026 : Boolean;
      BalanceVisible@19073040 : Boolean INDATASET;
      TotalBalanceVisible@19063333 : Boolean INDATASET;
      StyleTxt@1015 : Text;
      OpenApprovalEntriesExistForCurrUser@1014 : Boolean;
      AccTypeNotSupportedErr@1017 : TextConst 'DAN=Du kan ikke angive en periodiseringskode for denne kontotype.;ENU=You cannot specify a deferral code for this type of account.';
      OpenApprovalEntriesOnJnlBatchExist@1019 : Boolean;
      OpenApprovalEntriesOnJnlLineExist@1020 : Boolean;
      OpenApprovalEntriesOnBatchOrCurrJnlLineExist@1021 : Boolean;
      OpenApprovalEntriesOnBatchOrAnyJnlLineExist@1022 : Boolean;
      ShowWorkflowStatusOnBatch@1016 : Boolean;
      ShowWorkflowStatusOnLine@1023 : Boolean;
      CanCancelApprovalForJnlBatch@1024 : Boolean;
      CanCancelApprovalForJnlLine@1025 : Boolean;
      ImportPayrollTransactionsAvailable@1028 : Boolean;
      IsSaasExcelAddinEnabled@1029 : Boolean;
      CanRequestFlowApprovalForBatch@1030 : Boolean;
      CanRequestFlowApprovalForBatchAndAllLines@1031 : Boolean;
      CanRequestFlowApprovalForBatchAndCurrentLine@1032 : Boolean;
      CanCancelFlowApprovalForBatch@1033 : Boolean;
      CanCancelFlowApprovalForLine@1034 : Boolean;
      AmountVisible@1035 : Boolean;
      DebitCreditVisible@1036 : Boolean;
      IsSaaS@1037 : Boolean;

    LOCAL PROCEDURE UpdateBalance@1();
    BEGIN
      GenJnlManagement.CalcBalance(Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
      BalanceVisible := ShowBalance;
      TotalBalanceVisible := ShowTotalBalance;
    END;

    LOCAL PROCEDURE EnableApplyEntriesAction@4();
    BEGIN
      ApplyEntriesActionEnabled :=
        ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::Employee]) OR
        ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::Employee]);
    END;

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
      SetControlAppearanceFromBatch;
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE SetUserInteractions@2();
    BEGIN
      StyleTxt := GetStyle;
    END;

    LOCAL PROCEDURE GetCurrentlySelectedLines@3(VAR GenJournalLine@1000 : Record 81) : Boolean;
    BEGIN
      CurrPage.SETSELECTIONFILTER(GenJournalLine);
      EXIT(GenJournalLine.FINDSET);
    END;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
      WorkflowWebhookManagement@1000 : Codeunit 1543;
      CanRequestFlowApprovalForLine@1001 : Boolean;
    BEGIN
      OpenApprovalEntriesExistForCurrUser :=
        OpenApprovalEntriesExistForCurrUser OR
        ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);

      OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
      OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist OR OpenApprovalEntriesOnJnlLineExist;

      ShowWorkflowStatusOnLine := CurrPage.WorkflowStatusLine.PAGE.SetFilterOnWorkflowRecord(RECORDID);

      CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

      SetPayrollAppearance;

      WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestFlowApprovalForLine,CanCancelFlowApprovalForLine);
      CanRequestFlowApprovalForBatchAndCurrentLine := CanRequestFlowApprovalForBatch AND CanRequestFlowApprovalForLine;
    END;

    LOCAL PROCEDURE SetPayrollAppearance@7();
    VAR
      TempPayrollServiceConnection@1000 : TEMPORARY Record 1400;
    BEGIN
      PayrollManagement.OnRegisterPayrollService(TempPayrollServiceConnection);
      ImportPayrollTransactionsAvailable := NOT TempPayrollServiceConnection.ISEMPTY;
    END;

    LOCAL PROCEDURE SetControlAppearanceFromBatch@6();
    VAR
      GenJournalBatch@1000 : Record 232;
      ApprovalsMgmt@1001 : Codeunit 1535;
      WorkflowWebhookManagement@1002 : Codeunit 1543;
      CanRequestFlowApprovalForAllLines@1003 : Boolean;
    BEGIN
      IF ("Journal Template Name" <> '') AND ("Journal Batch Name" <> '') THEN
        GenJournalBatch.GET("Journal Template Name","Journal Batch Name")
      ELSE
        IF NOT GenJournalBatch.GET(GETRANGEMAX("Journal Template Name"),CurrentJnlBatchName) THEN
          EXIT;

      ShowWorkflowStatusOnBatch := CurrPage.WorkflowStatusBatch.PAGE.SetFilterOnWorkflowRecord(GenJournalBatch.RECORDID);
      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(GenJournalBatch.RECORDID);
      OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(GenJournalBatch.RECORDID);

      OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
        OpenApprovalEntriesOnJnlBatchExist OR
        ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries("Journal Template Name","Journal Batch Name");

      CanCancelApprovalForJnlBatch := ApprovalsMgmt.CanCancelApprovalForRecord(GenJournalBatch.RECORDID);

      WorkflowWebhookManagement.GetCanRequestAndCanCancelJournalBatch(
        GenJournalBatch,CanRequestFlowApprovalForBatch,CanCancelFlowApprovalForBatch,CanRequestFlowApprovalForAllLines);
      CanRequestFlowApprovalForBatchAndAllLines := CanRequestFlowApprovalForBatch AND CanRequestFlowApprovalForAllLines;
    END;

    LOCAL PROCEDURE SetConrolVisibility@8();
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

