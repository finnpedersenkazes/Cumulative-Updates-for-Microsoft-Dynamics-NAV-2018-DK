OBJECT Page 1290 Payment Reconciliation Journal
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Betalingsudligningskladde;
               ENU=Payment Reconciliation Journal];
    LinksAllowed=No;
    SourceTable=Table274;
    DataCaptionExpr="Bank Account No.";
    DelayedInsert=Yes;
    SourceTableView=WHERE(Statement Type=CONST(Payment Application));
    PageType=Worksheet;
    AutoSplitKey=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Manuel udligning,Gennemse,Detaljer,Vis,Side;
                                ENU=New,Process,Report,Manual Application,Review,Details,View,Page];
    OnOpenPage=VAR
                 ServerConfigSettingHandler@1000 : Codeunit 6723;
               BEGIN
                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 PageClosedByPosting := FALSE;
               END;

    OnAfterGetRecord=VAR
                       PaymentMatchingDetails@1000 : Record 1299;
                     BEGIN
                       MatchDetails := PaymentMatchingDetails.MergeMessages(Rec);

                       GetAppliedPmtData(AppliedPmtEntry,RemainingAmountAfterPosting,StatementToRemAmtDifference,PmtAppliedToTxt);
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  SetUpNewLine;
                  AppliedPmtEntry.INIT;
                  StatementToRemAmtDifference := 0;
                  RemainingAmountAfterPosting := 0;
                END;

    OnAfterGetCurrRecord=BEGIN
                           IF NOT IsBankAccReconInitialized THEN BEGIN
                             BankAccReconciliation.GET("Statement Type","Bank Account No.","Statement No.");
                             IsBankAccReconInitialized := TRUE;
                           END;

                           FinanceChargeMemoEnabled := "Account Type" = "Account Type"::Customer;
                           BankAccReconciliation.CALCFIELDS("Total Balance on Bank Account","Total Unposted Applied Amount","Total Transaction Amount",
                             "Total Applied Amount","Total Outstd Bank Transactions","Total Outstd Payments","Total Applied Amount Payments");

                           OutstandingTransactions := BankAccReconciliation."Total Outstd Bank Transactions" -
                             (BankAccReconciliation."Total Applied Amount" - BankAccReconciliation."Total Unposted Applied Amount") +
                             BankAccReconciliation."Total Applied Amount Payments";
                           OutstandingPayments := BankAccReconciliation."Total Outstd Payments" - BankAccReconciliation."Total Applied Amount Payments";

                           UpdateBalanceAfterPostingStyleExpr;

                           TestIfFiltershaveBeenRemovedWithRefreshAndClose;
                         END;

    ActionList=ACTIONS
    {
      { 45      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=Proces;
                                 ENU=Process] }
      { 22      ;2   ;Action    ;
                      Name=ImportBankTransactions;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&ImportÇr banktransaktioner;
                                 ENU=&Import Bank Transactions];
                      ToolTipML=[DAN=ImportÇr en fil til de transaktionsbetalinger, der blev foretaget fra din bankkonto, og udlign betalingerne med posten. Filnavnet skal ende pÜ .csv, .txt, asc, eller .xml.;
                                 ENU=Import a file for transaction payments that was made from your bank account and apply the payments to the entry. The file name must end in .csv, .txt, asc, or .xml.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SubscriberInvoked@1000 : Boolean;
                               BEGIN
                                 OnAfterImportBankTransactions(SubscriberInvoked);
                                 IF NOT SubscriberInvoked THEN BEGIN
                                   BankAccReconciliation.GET("Statement Type","Bank Account No.","Statement No.");
                                   BankAccReconciliation.ImportBankStatement;
                                   IF BankAccReconciliation.FIND THEN;
                                 END;
                               END;
                                }
      { 29      ;2   ;Action    ;
                      Name=ApplyAutomatically;
                      CaptionML=[DAN=Udlign automatisk;
                                 ENU=Apply Automatically];
                      ToolTipML=[DAN=Udlign betalinger med deres relaterede Übne poster ud fra datatilknytningerne mellem banktransaktionens tekst og postoplysningerne.;
                                 ENU=Apply payments to their related open entries based on data matches between bank transaction text and entry information.];
                      ApplicationArea=#Basic,#Suite;
                      RunPageOnRec=Yes;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=MapAccounts;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 BankAccReconciliation@1000 : Record 273;
                                 AppliedPaymentEntry@1001 : Record 1294;
                                 SubscriberInvoked@1002 : Boolean;
                               BEGIN
                                 AppliedPaymentEntry.SETRANGE("Statement Type","Statement Type");
                                 AppliedPaymentEntry.SETRANGE("Bank Account No.","Bank Account No.");
                                 AppliedPaymentEntry.SETRANGE("Statement No.","Statement No.");

                                 IF AppliedPaymentEntry.COUNT > 0 THEN
                                   IF NOT CONFIRM(RemoveExistingApplicationsQst) THEN
                                     EXIT;

                                 BankAccReconciliation.GET("Statement Type","Bank Account No.","Statement No.");
                                 OnAtActionApplyAutomatically(BankAccReconciliation,SubscriberInvoked);
                                 IF NOT SubscriberInvoked THEN
                                   CODEUNIT.RUN(CODEUNIT::"Match Bank Pmt. Appl.",BankAccReconciliation);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 58      ;2   ;ActionGroup;
                      CaptionML=[DAN=Bogfõr;
                                 ENU=Post];
                      Image=Post }
      { 72      ;3   ;Action    ;
                      Name=TestReport;
                      CaptionML=[DAN=Kon&troller;
                                 ENU=&Test Report];
                      ToolTipML=[DAN=Vis de resulterende betalingsafstemninger for at se konsekvenserne, fõr du udfõrer den faktiske bogfõring.;
                                 ENU=Preview the resulting payment reconciliations to see the consequences before you perform the actual posting.];
                      ApplicationArea=#Basic,#Suite;
                      Image=TestReport;
                      OnAction=VAR
                                 TestReportPrint@1001 : Codeunit 228;
                               BEGIN
                                 BankAccReconciliation.GET("Statement Type","Bank Account No.","Statement No.");
                                 TestReportPrint.PrintBankAccRecon(BankAccReconciliation);
                               END;
                                }
      { 35      ;3   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr betalinger og afstem bankkonti;
                                 ENU=Post Payments and Reconcile Bank Account];
                      ToolTipML=[DAN=Afstem bankkontoen for de betalinger, du bogfõrer, med kladden, og luk de relaterede finansposter.;
                                 ENU=Reconcile the bank account for payments that you post with the journal and close related ledger entries.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostApplication;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 InvokePost(FALSE)
                               END;
                                }
      { 60      ;3   ;Action    ;
                      Name=PostPaymentsOnly;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr kun betalinger;
                                 ENU=Post Payments Only];
                      ToolTipML=[DAN=Bogfõr betalingerne, men luk ikke bankkontoens finansposter eller afstem ikke bankkontoen.;
                                 ENU=Post payments but do not close related bank account ledger entries or reconcile the bank account.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PaymentJournal;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 InvokePost(TRUE)
                               END;
                                }
      { 42      ;1   ;ActionGroup;
                      CaptionML=[DAN=Nye dokumenter;
                                 ENU=New Documents] }
      { 20      ;2   ;Action    ;
                      Name=FinanceChargeMemo;
                      CaptionML=[DAN=Ny rentenota;
                                 ENU=New Finance Charge Memo];
                      ToolTipML=[DAN=Definer et notat, der indeholder oplysninger om den beregnede rente pÜ en kontos udestÜende saldi. Du kan derefter sende notatet i en mail til debitoren.;
                                 ENU=Define a memo that includes information about the calculated interest on outstanding balances of an account. You can then send the memo in an email to the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 446;
                      RunPageLink=Customer No.=FIELD(Account No.);
                      Enabled=FinanceChargeMemoEnabled;
                      PromotedIsBig=Yes;
                      Image=FinChargeMemo;
                      RunPageMode=Create }
      { 41      ;2   ;Action    ;
                      Name=OpenGenJnl;
                      CaptionML=[DAN=Kassekladde;
                                 ENU=General Journal];
                      ToolTipML=[DAN=èbn finanskladden, for eksempel for at registrere eller bogfõre en betaling, der ikke har et tilknyttet bilag.;
                                 ENU=Open the general journal, for example, to record or post a payment that has no related document.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 39;
                      PromotedIsBig=Yes;
                      Image=GLRegisters }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Udbetalingskladde;
                                 ENU=Payment Journal];
                      ToolTipML=[DAN=Se eller rediger den udbetalingskladde, hvor du kan registrere betalinger til kreditorer.;
                                 ENU=View or edit the payment journal where you can register payments to vendors.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 256;
                      PromotedIsBig=Yes;
                      Image=PaymentJournal }
      { 63      ;1   ;ActionGroup;
                      CaptionML=[DAN=Manuel udligning;
                                 ENU=Manual Application] }
      { 59      ;2   ;Action    ;
                      Name=TransferDiffToAccount;
                      CaptionML=[DAN=Overfõr difference til konto;
                                 ENU=Transfer Difference to Account];
                      ToolTipML=[DAN=Angiv den modkonto, hvor du vil bogfõre ikke-udlignede betalingsbelõb pÜ en betalingsudligningskladdelinje, nÜr du bogfõrer kladden.;
                                 ENU=Specify the balancing account to which you want a non-applicable payment amount on a payment reconciliation journal line to be posted when you post the journal.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=TransferToGeneralJournal;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 MatchBankPayments@1001 : Codeunit 1255;
                               BEGIN
                                 MatchBankPayments.TransferDiffToAccount(Rec,TempGenJournalLine)
                               END;
                                }
      { 30      ;2   ;Action    ;
                      Name=AddMappingRule;
                      CaptionML=[DAN=Knyt tekst til konto;
                                 ENU=Map Text to Account];
                      ToolTipML=[DAN=Tilknyt tekst pÜ betalinger med debet-, kredit- og modkonti, sÜ betalingerne bogfõres til disse konti. Betalingerne udlignes ikke med fakturaer eller kreditnotaer og egner sig til gentagne kontantbetalinger eller udgifter.;
                                 ENU=Associate text on payments with debit, credit, and balancing accounts, so payments are posted to the accounts when you post payments. The payments are not applied to invoices or credit memos, and are suited for recurring cash receipts or expenses.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Add;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 TextToAccMapping@1000 : Record 1251;
                                 MatchBankPayments@1001 : Codeunit 1255;
                               BEGIN
                                 TextToAccMapping.InsertRecFromBankAccReconciliationLine(Rec);
                                 MatchBankPayments.RerunTextMapper(Rec);
                               END;
                                }
      { 31      ;2   ;Action    ;
                      Name=ApplyEntries;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udlign manuelt;
                                 ENU=&Apply Manually];
                      ToolTipML=[DAN=Gennemse og udlign betalinger, der er udlignet automatisk med forkerte Übne poster eller slet ikke er blevet udlignet.;
                                 ENU=Review and apply payments that were applied automatically to wrong open entries or not applied at all.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ApplyEntries;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 DisplayApplication;
                                 GetAppliedPmtData(AppliedPmtEntry,RemainingAmountAfterPosting,StatementToRemAmtDifference,PmtAppliedToTxt);
                               END;
                                }
      { 44      ;1   ;ActionGroup;
                      CaptionML=[DAN=Gennemse;
                                 ENU=Review] }
      { 36      ;2   ;Action    ;
                      Name=Accept;
                      CaptionML=[DAN=AcceptÇr udligninger;
                                 ENU=Accept Applications];
                      ToolTipML=[DAN=AcceptÇr en betalingsudligning efter gennemsyn eller manuel udligning med poster. Dermed lukkes betalingsudligningen, og Matchtillid indstilles til Accepteret.;
                                 ENU=Accept a payment application after reviewing it or manually applying it to entries. This closes the payment application and sets the Match Confidence to Accepted.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 BankAccReconciliationLine@1000 : Record 274;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(BankAccReconciliationLine);
                                 BankAccReconciliationLine.AcceptAppliedPaymentEntriesSelectedLines;
                               END;
                                }
      { 37      ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Fjern udligninger;
                                 ENU=Remove Applications];
                      ToolTipML=[DAN=Fjern en betalingsudligning fra en post. Udligningen af betalingen annulleres.;
                                 ENU=Remove a payment application from an entry. This unapplies the payment.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 BankAccReconciliationLine@1000 : Record 274;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(BankAccReconciliationLine);
                                 BankAccReconciliationLine.RejectAppliedPaymentEntriesSelectedLines;
                               END;
                                }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Brugerdefineret sortering;
                                 ENU=Custom Sorting] }
      { 56      ;2   ;Action    ;
                      Name=ShowNonAppliedLines;
                      CaptionML=[DAN=Vis ikke-afstemte linjer;
                                 ENU=Show Non-Applied Lines];
                      ToolTipML=[DAN=Vis kun de betalinger pÜ listen, som ikke er blevet udlignet.;
                                 ENU=Display only payments in the list that have not been applied.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=FilterLines;
                      PromotedCategory=Category7;
                      OnAction=BEGIN
                                 SETFILTER(Difference,'<>0');
                                 CurrPage.UPDATE;
                               END;
                                }
      { 55      ;2   ;Action    ;
                      Name=ShowAllLines;
                      CaptionML=[DAN=Vis alle linjer;
                                 ENU=Show All Lines];
                      ToolTipML=[DAN=Vis alle betalinger pÜ listen uanset deres status.;
                                 ENU=Show all payments in the list no matter what their status is.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=AllLines;
                      PromotedCategory=Category7;
                      OnAction=BEGIN
                                 SETRANGE(Difference);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 32      ;2   ;Action    ;
                      Name=SortForReviewDescending;
                      CaptionML=[DAN=SortÇr for gennemsyn faldende;
                                 ENU=Sort for Review Descending];
                      ToolTipML=[DAN=SortÇr linjerne i stigende rëkkefõlge.;
                                 ENU=Sort the lines in ascending order.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=MoveDown;
                      PromotedCategory=Category7;
                      OnAction=BEGIN
                                 UpdateSorting(FALSE);
                               END;
                                }
      { 34      ;2   ;Action    ;
                      Name=SortForReviewAscending;
                      CaptionML=[DAN=SortÇr for gennemsyn stigende;
                                 ENU=Sort for Review Ascending];
                      ToolTipML=[DAN=SortÇr linjerne i faldende rëkkefõlge.;
                                 ENU=Sort the lines in descending order.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=MoveUp;
                      PromotedCategory=Category7;
                      OnAction=BEGIN
                                 UpdateSorting(TRUE);
                               END;
                                }
      { 39      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 38      ;1   ;Action    ;
                      Name=Dimensions;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 BankAccReconciliation.GET("Statement Type","Bank Account No.","Statement No.");
                                 BankAccReconciliation.ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 6       ;1   ;Action    ;
                      Name=LineDimensions;
                      CaptionML=[DAN=Linjedimensioner;
                                 ENU=Line Dimensions];
                      ToolTipML=[DAN=Se eller rediger de linjedimensionsgrupper, der er oprettet for den aktuelle linje.;
                                 ENU=View or edit the line dimensions sets that are set up for the current line.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 21      ;1   ;Action    ;
                      CaptionML=[DAN=Bankkontokort;
                                 ENU=Bank Account Card];
                      ToolTipML=[DAN=Se eller rediger oplysninger om den bankkonto, der er relateret til betalingsudligningskladden.;
                                 ENU=View or edit information about the bank account that is related to the payment reconciliation journal.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1283;
                      RunPageLink=No.=FIELD(Bank Account No.);
                      Image=BankAccount }
      { 53      ;1   ;ActionGroup;
                      CaptionML=[DAN=Detaljer;
                                 ENU=Details] }
      { 27      ;2   ;Action    ;
                      Name=ShowBankTransactionDetails;
                      CaptionML=[DAN=Banktransaktionsdetaljer;
                                 ENU=Bank Transaction Details];
                      ToolTipML=[DAN=FÜ vist vërdierne, som findes i en importeret bankkontoudtogsfil for den valgte linje.;
                                 ENU=View the values that exist in an imported bank statement file for the selected line.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1221;
                      RunPageLink=Data Exch. No.=FIELD(Data Exch. Entry No.),
                                  Line No.=FIELD(Data Exch. Line No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ExternalDocument;
                      PromotedCategory=Category6 }
      { 74      ;1   ;ActionGroup;
                      CaptionML=[DAN=Side;
                                 ENU=Page] }
      { 73      ;2   ;Action    ;
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
                                 ODataUtility.EditWorksheetInExcel(CurrPage.CAPTION,CurrPage.OBJECTID(FALSE),'');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater;
                FreezeColumnID=Statement Amount }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kvaliteten af den automatiske betalingsudligning pÜ kladdelinjen.;
                           ENU=Specifies the quality of the automatic payment application on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Match Confidence";
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DisplayApplication;
                            END;
                             }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor betalingen, der er reprësenteret af kladdelinjen, blev registreret pÜ bankkontoen.;
                           ENU=Specifies the date when the payment represented by the journal line was recorded in the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction Date" }

    { 16  ;2   ;Field     ;
                Width=40;
                ToolTipML=[DAN=Angiver den tekst, som debitoren eller kreditoren har angivet pÜ den betalingstransaktion, der er reprësenteret af kladdelinjen.;
                           ENU=Specifies the text that the customer or vendor entered on that payment transaction that is represented by the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction Text" }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den importerede banktransaktion.;
                           ENU=Specifies the ID of the imported bank transaction.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction ID";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Transaktionsbelõb;
                           ENU=Transaction Amount];
                ToolTipML=[DAN=Angiver det belõb, der blev betalt til bankkontoen og derefter importeret som en bankkontoudtogslinje, blev registreret pÜ bankkontoen.;
                           ENU=Specifies the amount that was paid into the bank account and then imported as a bank statement line represented by the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Statement Amount";
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             CurrPage.UPDATE(FALSE)
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der er udlignet med en eller flere Übne poster.;
                           ENU=Specifies the amount that has been applied to one or more open entries.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applied Amount" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem belõbet i feltet Kontoudtogsbelõb og belõbet i feltet Udligningsbelõb pÜ denne linje.;
                           ENU=Specifies the difference between the amount in the Statement Amount field and the amount in the Applied Amount field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Difference;
                Editable=FALSE;
                Style=Unfavorable }

    { 52  ;2   ;Field     ;
                Name=StatementToRemAmtDifference;
                CaptionML=[DAN=Difference fra restbelõb;
                           ENU=Difference from Remaining Amount];
                ToolTipML=[DAN=Angiver differencen mellem vërdierne i felterne Kontoudtogsbelõb og Restbelõb efter bogfõring.;
                           ENU=Specifies the difference between the values in the Statement Amount and the Remaining Amount After Posting fields.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=StatementToRemAmtDifference;
                Visible=FALSE;
                Enabled=FALSE }

    { 49  ;2   ;Field     ;
                CaptionML=[DAN=Bilagsnr.;
                           ENU=Document No.];
                ToolTipML=[DAN=Angiver bilagsnummeret for den Übne post, som betalingen er udlignet med.;
                           ENU=Specifies the document number of the open entry that the payment is applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetAppliedToDocumentNo }

    { 47  ;2   ;Field     ;
                Name=DescAppliedEntry;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description];
                ToolTipML=[DAN=Angiver beskrivelsen for den Übne post, som betalingen er udlignet med.;
                           ENU=Specifies the description on the open entry that the payment is applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliedPmtEntry.Description;
                Editable=FALSE }

    { 50  ;2   ;Field     ;
                Name=DueDateAppliedEntry;
                CaptionML=[DAN=Forfaldsdato;
                           ENU=Due Date];
                ToolTipML=[DAN=Angiver forfaldsdatoen for den Übne post, som betalingen er udlignet med.;
                           ENU=Specifies the due date on the open entry that the payment is applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliedPmtEntry."Due Date" }

    { 43  ;2   ;Field     ;
                Name=AccountName;
                CaptionML=[DAN=Kontonavn;
                           ENU=Account Name];
                ToolTipML=[DAN=Angiver navnet pÜ den debitor eller kreditor, som betalingen er udlignet med.;
                           ENU=Specifies the name of the customer or vendor that the payment is applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetAppliedToName;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              AppliedToDrillDown;
                            END;
                             }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som betalingsudligningen vil blive bogfõrt til, nÜr du bogfõrer kladden.;
                           ENU=Specifies the type of account that the payment application will be posted to when you post the worksheet.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Type" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontonummer, som betalingsudligningen vil blive bogfõrt til, nÜr du bogfõrer kladden.;
                           ENU=Specifies the account number that the payment application will be posted to when you post the worksheet.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account No.";
                OnValidate=BEGIN
                             CurrPage.UPDATE;
                             IF Difference > 0 THEN
                               TransferRemainingAmountToAccount;
                           END;
                            }

    { 46  ;2   ;Field     ;
                Name=PostingDateAppliedEntry;
                CaptionML=[DAN=Bogfõringsdato;
                           ENU=Posting Date];
                ToolTipML=[DAN=Angiver bogfõringsdatoen for den Übne post, som betalingen er udlignet med.;
                           ENU=Specifies the posting date on the open entry that the payment is applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliedPmtEntry."Posting Date";
                Visible=FALSE;
                Editable=FALSE }

    { 51  ;2   ;Field     ;
                CaptionML=[DAN=Valutakode for post;
                           ENU=Entry Currency Code];
                ToolTipML=[DAN=Angiver valutakoden for den Übne post, som betalingen er udlignet med.;
                           ENU=Specifies the currency code on the open entry that the payment is applied to.];
                ApplicationArea=#Suite;
                SourceExpr=AppliedPmtEntry."Currency Code";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                Name=Match Details;
                CaptionML=[DAN=Matchdetaljer;
                           ENU=Match Details];
                ToolTipML=[DAN=Angiver detaljer om betalingsudligningen pÜ kladdelinjen.;
                           ENU=Specifies details about the payment application on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=MatchDetails;
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DisplayApplication;
                            END;
                             }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver for den kladdelinje, hvor betalingen er udlignet, hvor mange poster betalingen er udlignet med.;
                           ENU=Specifies for a journal line where the payment has been applied, how many entries the payment has been applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applied Entries";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                Name=RemainingAmount;
                CaptionML=[DAN=Restbelõb (efter bogfõring);
                           ENU=Remaining Amount After Posting];
                ToolTipML=[DAN=Angiver det belõb, som mangler at blive betalt for den Übne post, som betalingen er udlignet med.;
                           ENU=Specifies the amount that remains to be paid on the open entry that the payment is applied to.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=RemainingAmountAfterPosting;
                Visible=FALSE;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                Width=40;
                ToolTipML=[DAN=Angiver flere oplysninger om bankkontoudtogslinjen for betalingen.;
                           ENU=Specifies additional information on the bank statement line for the payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Additional Transaction Info";
                Visible=FALSE;
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                Width=30;
                ToolTipML=[DAN=Angiver adressen pÜ den debitor eller kreditor, som foretog den betaling, der er reprësenteret af kladdelinjen.;
                           ENU=Specifies the address of the customer or vendor who made the payment that is represented by the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Related-Party Address";
                Visible=FALSE;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                Width=20;
                ToolTipML=[DAN=Angiver bankkontonummeret for den debitor eller kreditor, som har foretaget betalingen.;
                           ENU=Specifies the bank account number of the customer or vendor who made the payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Related-Party Bank Acc. No.";
                Visible=FALSE;
                Editable=FALSE }

    { 19  ;2   ;Field     ;
                Width=10;
                ToolTipML=[DAN=Angiver bynavnet pÜ debitoren eller kreditoren.;
                           ENU=Specifies the city name of the customer or vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Related-Party City";
                Visible=FALSE;
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                Width=30;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor eller kreditor, som foretog betalingen, der er reprësenteret af kladdelinjen.;
                           ENU=Specifies the name of the customer or vendor who made the payment that is represented by the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Related-Party Name";
                Visible=FALSE;
                Editable=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsvërdikode, der er knyttet til kladdelinjen.;
                           ENU=Specifies the dimension value code linked to the journal line.];
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

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsvërdikode, der er knyttet til kladdelinjen.;
                           ENU=Specifies the dimension value code linked to the journal line.];
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

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsvërdikode, der er knyttet til kladdelinjen.;
                           ENU=Specifies the dimension value code linked to the journal line.];
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

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsvërdikode, der er knyttet til kladdelinjen.;
                           ENU=Specifies the dimension value code linked to the journal line.];
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

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsvërdikode, der er knyttet til kladdelinjen.;
                           ENU=Specifies the dimension value code linked to the journal line.];
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

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsvërdikode, der er knyttet til kladdelinjen.;
                           ENU=Specifies the dimension value code linked to the journal line.];
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

    { 28  ;1   ;Group     ;
                GroupType=Group }

    { 33  ;2   ;Group     ;
                Editable=FALSE;
                GroupType=Group }

    { 25  ;3   ;Field     ;
                Name=BalanceOnBankAccount;
                CaptionML=[DAN=Saldo pÜ bankkonto;
                           ENU=Balance on Bank Account];
                ToolTipML=[DAN=Angiver bankkontoens saldo pÜ det seneste tidspunkt, hvor du afstemte bankkontoen.;
                           ENU=Specifies the balance of the bank account per the last time you reconciled the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BankAccReconciliation."Total Balance on Bank Account";
                AutoFormatType=1;
                OnDrillDown=BEGIN
                              BankAccReconciliation.DrillDownOnBalanceOnBankAccount;
                            END;
                             }

    { 26  ;3   ;Field     ;
                Name=TotalTransactionAmount;
                CaptionML=[DAN=Transaktionsbelõb i alt;
                           ENU=Total Transaction Amount];
                ToolTipML=[DAN=Angiver summen af vërdierne i feltet Kontoudtogsbelõb pÜ alle linjerne i vinduet Betalingsudligningskladde.;
                           ENU=Specifies the sum of values in the Statement Amount field on all the lines in the Payment Reconciliation Journal window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BankAccReconciliation."Total Transaction Amount";
                AutoFormatType=1 }

    { 24  ;3   ;Field     ;
                Name=BalanceOnBankAccountAfterPosting;
                CaptionML=[DAN=Saldo pÜ bankkonto efter bogfõring;
                           ENU=Balance on Bank Account After Posting];
                ToolTipML=[DAN=Angiver det samlede belõb, der findes pÜ bankkontoen som resultat af de betalingsudligninger, som du bogfõrer i vinduet Betalingsudligningskladde.;
                           ENU=Specifies the total amount that will exist on the bank account as a result of payment applications that you post in the Payment Reconciliation Journal window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BankAccReconciliation."Total Balance on Bank Account" + BankAccReconciliation."Total Unposted Applied Amount";
                AutoFormatType=1;
                StyleExpr=BalanceAfterPostingStyleExpr }

    { 3   ;2   ;Group     ;
                GroupType=Group }

    { 54  ;3   ;Field     ;
                Name=OutstandingTransactions;
                CaptionML=[DAN=UdestÜende transaktioner;
                           ENU=Outstanding Transactions];
                ToolTipML=[DAN=Angiver de udestÜende banktransaktioner, der ikke er blevet udlignet.;
                           ENU=Specifies the outstanding bank transactions that have not been applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=OutstandingTransactions;
                Editable=FALSE;
                OnDrillDown=VAR
                              DummyOutstandingBankTransaction@1001 : Record 1284;
                            BEGIN
                              DummyOutstandingBankTransaction.DrillDown("Bank Account No.",
                                DummyOutstandingBankTransaction.Type::"Bank Account Ledger Entry","Statement Type","Statement No.");
                            END;
                             }

    { 61  ;3   ;Field     ;
                Name=OutstandingPayments;
                CaptionML=[DAN=UdestÜende betalinger;
                           ENU=Outstanding Payments];
                ToolTipML=[DAN=Angiver de udestÜende checktransaktioner, der ikke er blevet udlignet.;
                           ENU=Specifies the outstanding check transactions that have not been applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=OutstandingPayments;
                Editable=FALSE;
                OnDrillDown=VAR
                              DummyOutstandingBankTransaction@1001 : Record 1284;
                            BEGIN
                              DummyOutstandingBankTransaction.DrillDown("Bank Account No.",
                                DummyOutstandingBankTransaction.Type::"Check Ledger Entry","Statement Type","Statement No.");
                            END;
                             }

    { 23  ;3   ;Field     ;
                Name=StatementEndingBalance;
                CaptionML=[DAN=Kontoudtogs slutsaldo;
                           ENU=Statement Ending Balance];
                ToolTipML=[DAN=Angiver saldoen pÜ din faktiske bankkonto, efter banken har behandlet de betalinger, som du har importeret med bankkontoudtogsfilen.;
                           ENU=Specifies the balance on your actual bank account after the bank has processed the payments that you have imported with the bank statement file.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BankAccReconciliation."Statement Ending Balance";
                AutoFormatType=1;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      BankAccReconciliation@1000 : Record 273;
      AppliedPmtEntry@1007 : Record 1294;
      TempGenJournalLine@1009 : TEMPORARY Record 81;
      MatchDetails@1002 : Text;
      PmtAppliedToTxt@1003 : TextConst '@@@="%1=integer value for number of entries";DAN=Betalingen er afstemt med %1 poster.;ENU=The payment has been applied to %1 entries.';
      IsBankAccReconInitialized@1004 : Boolean;
      StatementToRemAmtDifference@1005 : Decimal;
      FinanceChargeMemoEnabled@1001 : Boolean;
      RemainingAmountAfterPosting@1006 : Decimal;
      RemoveExistingApplicationsQst@1008 : TextConst 'DAN=NÜr du kõrer handlingen Udlign automatisk, annulleres alle tidligere udligninger.\\Vil du fortsëtte?;ENU=When you run the Apply Automatically action, it will undo all previous applications.\\Do you want to continue?';
      BalanceAfterPostingStyleExpr@1010 : Text;
      PageMustCloseMsg@1011 : TextConst 'DAN=Vinduet Betalingsudligningskladde er blevet lukket, fordi forbindelsen blev afbrudt.;ENU=The Payment Reconciliation Journal window has been closed because the connection was suspended.';
      PageClosedByPosting@1012 : Boolean;
      OutstandingTransactions@1015 : Decimal;
      OutstandingPayments@1014 : Decimal;
      ShortcutDimCode@1013 : ARRAY [8] OF Code[20];
      IsSaasExcelAddinEnabled@1016 : Boolean;

    LOCAL PROCEDURE UpdateSorting@4(IsAscending@1003 : Boolean);
    VAR
      BankAccReconciliationLine@1005 : Record 274;
      PaymentMatchingDetails@1000 : Record 1299;
      AppliedPaymentEntry2@1002 : Record 1294;
      AmountDifference@1001 : Decimal;
      ScoreRange@1004 : Integer;
      SubscriberInvoked@1006 : Boolean;
    BEGIN
      BankAccReconciliationLine.SETRANGE("Statement Type","Statement Type");
      BankAccReconciliationLine.SETRANGE("Bank Account No.","Bank Account No.");
      BankAccReconciliationLine.SETRANGE("Statement No.","Statement No.");
      BankAccReconciliationLine.SETAUTOCALCFIELDS("Match Confidence");

      IF BankAccReconciliationLine.FINDSET THEN BEGIN
        REPEAT
          ScoreRange := 10000;
          BankAccReconciliationLine."Sorting Order" := BankAccReconciliationLine."Match Confidence" * ScoreRange;

          // Update sorting for same match confidence based onother criteria
          GetAppliedPmtData(AppliedPaymentEntry2,RemainingAmountAfterPosting,AmountDifference,PmtAppliedToTxt);

          ScoreRange := ScoreRange / 10;
          IF AmountDifference <> 0 THEN
            BankAccReconciliationLine."Sorting Order" -= ScoreRange;

          ScoreRange := ScoreRange / 10;
          IF Difference <> 0 THEN
            BankAccReconciliationLine."Sorting Order" -= ScoreRange;

          ScoreRange := ScoreRange / 10;
          IF PaymentMatchingDetails.MergeMessages(Rec) <> '' THEN
            BankAccReconciliationLine."Sorting Order" -= ScoreRange;

          BankAccReconciliationLine.MODIFY;
        UNTIL BankAccReconciliationLine.NEXT = 0;

        OnUpdateSorting(BankAccReconciliation,SubscriberInvoked);
        IF NOT SubscriberInvoked THEN
          SETCURRENTKEY("Sorting Order");
        ASCENDING(IsAscending);

        CurrPage.UPDATE(FALSE);
        FINDFIRST;
      END;
    END;

    LOCAL PROCEDURE InvokePost@2(OnlyPayments@1000 : Boolean);
    VAR
      BankAccReconciliation@1001 : Record 273;
      BankAccReconPostYesNo@1002 : Codeunit 371;
    BEGIN
      BankAccReconciliation.GET("Statement Type","Bank Account No.","Statement No.");
      BankAccReconciliation."Post Payments Only" := OnlyPayments;

      IF BankAccReconPostYesNo.BankAccReconPostYesNo(BankAccReconciliation) THEN BEGIN
        RESET;
        PageClosedByPosting := TRUE;
        CurrPage.CLOSE;
      END;
    END;

    LOCAL PROCEDURE UpdateBalanceAfterPostingStyleExpr@3();
    BEGIN
      WITH BankAccReconciliation DO
        IF "Total Balance on Bank Account" + "Total Unposted Applied Amount" <> "Statement Ending Balance" THEN
          BalanceAfterPostingStyleExpr := 'Unfavorable'
        ELSE
          BalanceAfterPostingStyleExpr := 'Favorable';
    END;

    LOCAL PROCEDURE TestIfFiltershaveBeenRemovedWithRefreshAndClose@5();
    BEGIN
      FILTERGROUP := 2;
      IF NOT PageClosedByPosting THEN
        IF GETFILTER("Bank Account No.") + GETFILTER("Statement Type") + GETFILTER("Statement No.") = '' THEN BEGIN
          MESSAGE(PageMustCloseMsg);
          CurrPage.CLOSE;
        END;
      FILTERGROUP := 0;
    END;

    [Integration]
    PROCEDURE OnAtActionApplyAutomatically@1(BankAccReconciliation@1000 : Record 273;VAR SubscriberInvoked@1001 : Boolean);
    BEGIN
    END;

    [Integration(TRUE)]
    PROCEDURE OnUpdateSorting@7(BankAccReconciliation@1001 : Record 273;VAR SubscriberInvoked@1000 : Boolean);
    BEGIN
    END;

    [Integration]
    PROCEDURE OnAfterImportBankTransactions@9(VAR SubscriberInvoked@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

