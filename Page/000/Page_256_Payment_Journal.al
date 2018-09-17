OBJECT Page 256 Payment Journal
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Udbetalingskladde;
               ENU=Payment Journal];
    SaveValues=Yes;
    SourceTable=Table81;
    DataCaptionExpr=DataCaption;
    DelayedInsert=Yes;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Bank,Klarg›r,Godkend,Side;
                                ENU=New,Process,Report,Bank,Prepare,Approve,Page];
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
                 IsSaaS := PermissionManager.SoftwareAsAService;
                 IF CURRENTCLIENTTYPE = CLIENTTYPE::ODataV4 THEN
                   EXIT;

                 BalAccName := '';

                 SetConrolVisibility;
                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   SetControlAppearanceFromBatch;
                   EXIT;
                 END;
                 GenJnlManagement.TemplateSelection(PAGE::"Payment Journal",4,FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                 SetControlAppearanceFromBatch;
               END;

    OnAfterGetRecord=BEGIN
                       StyleTxt := GetOverdueDateInteractions(OverdueWarningText);
                       ShowShortcutDimCode(ShortcutDimCode);
                       HasPmtFileErr := HasPaymentFileErrors;
                       RecipientBankAccountMandatory := IsAllowPaymentExport AND
                         (("Bal. Account Type" = "Bal. Account Type"::Vendor) OR ("Bal. Account Type" = "Bal. Account Type"::Customer));
                     END;

    OnNewRecord=BEGIN
                  HasPmtFileErr := FALSE;
                  UpdateBalance;
                  EnableApplyEntriesAction;
                  SetUpNewLine(xRec,Balance,BelowxRec);
                  CLEAR(ShortcutDimCode);
                END;

    OnModifyRecord=BEGIN
                     CheckForPmtJnlErrors;
                   END;

    OnAfterGetCurrRecord=VAR
                           GenJournalBatch@1000 : Record 232;
                           WorkflowEventHandling@1001 : Codeunit 1520;
                           WorkflowManagement@1002 : Codeunit 1501;
                         BEGIN
                           StyleTxt := GetOverdueDateInteractions(OverdueWarningText);
                           GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                           UpdateBalance;
                           EnableApplyEntriesAction;
                           SetControlAppearance;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

                           IF GenJournalBatch.GET("Journal Template Name","Journal Batch Name") THEN BEGIN
                             ShowWorkflowStatusOnBatch := CurrPage.WorkflowStatusBatch.PAGE.SetFilterOnWorkflowRecord(GenJournalBatch.RECORDID);
                             IsAllowPaymentExport := GenJournalBatch."Allow Payment Export";
                           END;
                           ShowWorkflowStatusOnLine := CurrPage.WorkflowStatusLine.PAGE.SetFilterOnWorkflowRecord(RECORDID);

                           EventFilter := WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode;
                           EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::"Gen. Journal Line",EventFilter);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 58      ;2   ;Action    ;
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
      { 92      ;2   ;Action    ;
                      Name=IncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=Indg†ende bilag;
                                 ENU=Incoming Document];
                      ToolTipML=[DAN=Se eller opret en indg†ende bilagsrecord, som er knyttet til posten eller bilaget.;
                                 ENU=View or create an incoming document record that is linked to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Document;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 VALIDATE("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RECORDID));
                               END;
                                }
      { 37      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 38      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 15;
                      Image=EditLines }
      { 39      ;2   ;Action    ;
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
      { 41      ;1   ;ActionGroup;
                      CaptionML=[DAN=Be&taling;
                                 ENU=&Payments];
                      Image=Payment }
      { 42      ;2   ;Action    ;
                      Name=SuggestVendorPayments;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Lav forslag;
                                 ENU=Suggest Vendor Payments];
                      ToolTipML=[DAN=Opret betalingsforslag som linjer i betalingskladden.;
                                 ENU=Create payment suggestions as lines in the payment journal.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SuggestVendorPayments;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SuggestVendorPayments@1001 : Report 393;
                               BEGIN
                                 CLEAR(SuggestVendorPayments);
                                 SuggestVendorPayments.SetGenJnlLine(Rec);
                                 SuggestVendorPayments.RUNMODAL;
                               END;
                                }
      { 112     ;2   ;Action    ;
                      Name=SuggestEmployeePayments;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Foresl† medarbejderbetalinger;
                                 ENU=Suggest Employee Payments];
                      ToolTipML=[DAN=Opret betalingsforslag som linjer i betalingskladden.;
                                 ENU=Create payment suggestions as lines in the payment journal.];
                      ApplicationArea=#BasicHR;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SuggestVendorPayments;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SuggestEmployeePayments@1001 : Report 394;
                               BEGIN
                                 CLEAR(SuggestEmployeePayments);
                                 SuggestEmployeePayments.SetGenJnlLine(Rec);
                                 SuggestEmployeePayments.RUNMODAL;
                               END;
                                }
      { 63      ;2   ;Action    ;
                      Name=PreviewCheck;
                      CaptionML=[DAN=&Se check;
                                 ENU=P&review Check];
                      ToolTipML=[DAN=F† vist en checken, f›r den udskrives.;
                                 ENU=Preview the check before printing it.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 404;
                      RunPageLink=Journal Template Name=FIELD(Journal Template Name),
                                  Journal Batch Name=FIELD(Journal Batch Name),
                                  Line No.=FIELD(Line No.);
                      Image=ViewCheck }
      { 64      ;2   ;Action    ;
                      Name=PrintCheck;
                      AccessByPermission=TableData 272=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udskriv check;
                                 ENU=Print Check];
                      ToolTipML=[DAN=Forbered udskrivning af checken.;
                                 ENU=Prepare to print the check.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=PrintCheck;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 GenJnlLine.RESET;
                                 GenJnlLine.COPY(Rec);
                                 GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
                                 GenJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
                                 DocPrint.PrintCheck(GenJnlLine);
                                 CODEUNIT.RUN(CODEUNIT::"Adjust Gen. Journal Balance",Rec);
                               END;
                                }
      { 106     ;2   ;ActionGroup;
                      CaptionML=[DAN=Elektroniske betalinger;
                                 ENU=Electronic Payments];
                      Image=ElectronicPayment }
      { 15      ;3   ;Action    ;
                      Name=ExportPaymentsToFile;
                      Ellipsis=Yes;
                      CaptionML=[DAN=E&ksport‚r;
                                 ENU=E&xport];
                      ToolTipML=[DAN=Eksport‚r en fil med betalingsoplysningerne p† kladdelinjerne.;
                                 ENU=Export a file with the payment information on the journal lines.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ExportFile;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 GenJnlLine@1001 : Record 81;
                               BEGIN
                                 CheckIfPrivacyBlocked;
                                 GenJnlLine.COPYFILTERS(Rec);
                                 IF GenJnlLine.FINDFIRST THEN
                                   GenJnlLine.ExportPaymentFile;
                               END;
                                }
      { 104     ;3   ;Action    ;
                      Name=VoidPayments;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Annuller;
                                 ENU=Void];
                      ToolTipML=[DAN=Annuller den eksporterede elektroniske betalingsfil.;
                                 ENU=Void the exported electronic payment file.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=VoidElectronicDocument;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 GenJnlLine.COPYFILTERS(Rec);
                                 IF GenJnlLine.FINDFIRST THEN
                                   GenJnlLine.VoidPaymentFile;
                               END;
                                }
      { 107     ;3   ;Action    ;
                      Name=TransmitPayments;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Overf›r;
                                 ENU=Transmit];
                      ToolTipML=[DAN=Overf›r den eksporterede elektroniske betalingsfil til banken.;
                                 ENU=Transmit the exported electronic payment file to the bank.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=TransmitElectronicDoc;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 GenJnlLine.COPYFILTERS(Rec);
                                 IF GenJnlLine.FINDFIRST THEN
                                   GenJnlLine.TransmitPaymentFile;
                               END;
                                }
      { 65      ;2   ;Action    ;
                      CaptionML=[DAN=Annuller check;
                                 ENU=Void Check];
                      ToolTipML=[DAN=Annuller checken, hvis den f.eks. ikke indl›ses af banken.;
                                 ENU=Void the check if, for example, the check is not cashed by the bank.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=VoidCheck;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TESTFIELD("Bank Payment Type","Bank Payment Type"::"Computer Check");
                                 TESTFIELD("Check Printed",TRUE);
                                 IF CONFIRM(Text000,FALSE,"Document No.") THEN
                                   CheckManagement.VoidCheck(Rec);
                               END;
                                }
      { 66      ;2   ;Action    ;
                      CaptionML=[DAN=A&nnuller alle check;
                                 ENU=Void &All Checks];
                      ToolTipML=[DAN=Annuller alle checks, hvis de f.eks. ikke indl›ses af banken.;
                                 ENU=Void all checks if, for example, the checks are not cashed by the bank.];
                      ApplicationArea=#Basic,#Suite;
                      Image=VoidAllChecks;
                      OnAction=BEGIN
                                 IF CONFIRM(Text001,FALSE) THEN BEGIN
                                   GenJnlLine.RESET;
                                   GenJnlLine.COPY(Rec);
                                   GenJnlLine.SETRANGE("Bank Payment Type","Bank Payment Type"::"Computer Check");
                                   GenJnlLine.SETRANGE("Check Printed",TRUE);
                                   IF GenJnlLine.FIND('-') THEN
                                     REPEAT
                                       GenJnlLine2 := GenJnlLine;
                                       CheckManagement.VoidCheck(GenJnlLine2);
                                     UNTIL GenJnlLine.NEXT = 0;
                                 END;
                               END;
                                }
      { 26      ;2   ;Action    ;
                      Name=CreditTransferRegEntries;
                      CaptionML=[DAN=Poster i kreditoverf›rselsjournal;
                                 ENU=Credit Transfer Reg. Entries];
                      ToolTipML=[DAN=F† vist eller rediger de kreditoverf›rselsposter, der er relateret til fileksport for kreditoverf›rsler.;
                                 ENU=View or edit the credit transfer entries that are related to file export for credit transfers.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 16;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ExportReceipt;
                      PromotedCategory=Category4 }
      { 23      ;2   ;Action    ;
                      Name=CreditTransferRegisters;
                      CaptionML=[DAN=Kreditoverf›rselsjournaler;
                                 ENU=Credit Transfer Registers];
                      ToolTipML=[DAN=F† vist eller rediger de betalingsfiler, der er blevet eksporteret i forbindelse med kreditoverf›rsler.;
                                 ENU=View or edit the payment files that have been exported in connection with credit transfers.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1205;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ExportElectronicDocument;
                      PromotedCategory=Category4 }
      { 54      ;1   ;Action    ;
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
      { 40      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 19      ;2   ;Action    ;
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
      { 93      ;2   ;Action    ;
                      Name=ApplyEntries;
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
      { 68      ;2   ;Action    ;
                      Name=CalculatePostingDate;
                      CaptionML=[DAN=Beregn bogf›ringsdato;
                                 ENU=Calculate Posting Date];
                      ToolTipML=[DAN=Beregn den dato, der skal vises som bogf›ringsdato p† kladdelinjerne.;
                                 ENU=Calculate the date that will appear as the posting date on the journal lines.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=CalcWorkCenterCalendar;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 CalculatePostingDate;
                               END;
                                }
      { 94      ;2   ;Action    ;
                      CaptionML=[DAN=Inds‘t konv. RV-afrund.linjer;
                                 ENU=Insert Conv. LCY Rndg. Lines];
                      ToolTipML=[DAN=Inds‘t en afrundingslinjer i kladden. Denne afrundingslinjer afstemmes i RV, hvis bel›b i den udenlandske valuta og afstemmes. Derefter kan du bogf›re kladden.;
                                 ENU=Insert a rounding correction line in the journal. This rounding correction line will balance in LCY when amounts in the foreign currency also balance. You can then post the journal.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 407;
                      Image=InsertCurrency }
      { 34      ;2   ;Action    ;
                      Name=PositivePayExport;
                      CaptionML=[DAN=Eksport af Positive Pay-betalingsposter;
                                 ENU=Positive Pay Export];
                      ToolTipML=[DAN=Eksport‚r en Positive Pay-fil med kreditoroplysninger, checknummer og betalingsbel›b, som du derefter kan sende til banken som reference ved behandling af betalinger for at sikre, at din bank kun godkender validerede checks og bel›b.;
                                 ENU=Export a Positive Pay file that contains vendor information, check number, and payment amount, which you send to the bank to make sure that your bank only clears validated checks and amounts when you process payments.];
                      ApplicationArea=#Advanced;
                      Visible=FALSE;
                      Image=Export;
                      OnAction=VAR
                                 GenJnlBatch@1000 : Record 232;
                                 BankAcc@1001 : Record 270;
                               BEGIN
                                 GenJnlBatch.GET("Journal Template Name",CurrentJnlBatchName);
                                 IF GenJnlBatch."Bal. Account Type" = GenJnlBatch."Bal. Account Type"::"Bank Account" THEN BEGIN
                                   BankAcc."No." := GenJnlBatch."Bal. Account No.";
                                   PAGE.RUN(PAGE::"Positive Pay Export",BankAcc);
                                 END;
                               END;
                                }
      { 43      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 48      ;2   ;Action    ;
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
      { 78      ;2   ;Action    ;
                      Name=PreCheck;
                      CaptionML=[DAN=Forudbetalingskladde for kreditor;
                                 ENU=Vendor Pre-Payment Journal];
                      ToolTipML=[DAN=Vis kladdelinjeposter, kontantrabatter, rabattolerancebel›b, betalingstolerance og eventuelle fejl, der er knyttet til posterne. Du kan bruge resultaterne af rapporten til at f† vist betalingskladdelinjer og til at gennemse resultaterne af bogf›ringen, f›r du bogf›rer.;
                                 ENU=View journal line entries, payment discounts, discount tolerance amounts, payment tolerance, and any errors associated with the entries. You can use the results of the report to review payment journal lines and to review the results of posting before you actually post.];
                      ApplicationArea=#Basic,#Suite;
                      Image=PreviewChecks;
                      OnAction=VAR
                                 GenJournalBatch@1000 : Record 232;
                               BEGIN
                                 GenJournalBatch.INIT;
                                 GenJournalBatch.SETRANGE("Journal Template Name","Journal Template Name");
                                 GenJournalBatch.SETRANGE(Name,"Journal Batch Name");
                                 REPORT.RUN(REPORT::"Vendor Pre-Payment Journal",TRUE,FALSE,GenJournalBatch);
                               END;
                                }
      { 45      ;2   ;Action    ;
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
      { 46      ;2   ;Action    ;
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
      { 32      ;2   ;Action    ;
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
      { 47      ;2   ;Action    ;
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
      { 36      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 86      ;2   ;ActionGroup;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send godkendelsesanmodning;
                                 ENU=Send Approval Request];
                      Image=SendApprovalRequest }
      { 76      ;3   ;Action    ;
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
      { 74      ;3   ;Action    ;
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
                               END;
                                }
      { 52      ;2   ;ActionGroup;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesanmodning;
                                 ENU=Cancel Approval Request];
                      Image=Cancel }
      { 50      ;3   ;Action    ;
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
                                 SetControlAppearanceFromBatch;
                                 SetControlAppearance;
                               END;
                                }
      { 96      ;3   ;Action    ;
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
      { 114     ;2   ;Action    ;
                      Name=CreateFlow;
                      CaptionML=[DAN=Opret et workflow;
                                 ENU=Create a Flow];
                      ToolTipML=[DAN=Opret et nyt workflow fra en liste over relevante workflowskabeloner.;
                                 ENU=Create a new Flow from a list of relevant Flow templates.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=IsSaaS;
                      Image=Flow;
                      OnAction=VAR
                                 FlowServiceManagement@1000 : Codeunit 6400;
                                 FlowTemplateSelector@1001 : Page 6400;
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
      { 98      ;1   ;ActionGroup;
                      CaptionML=[DAN=Workflow;
                                 ENU=Workflow] }
      { 90      ;2   ;Action    ;
                      Name=CreateApprovalWorkflow;
                      CaptionML=[DAN=Opret godkendelsesworkflow;
                                 ENU=Create Approval Workflow];
                      ToolTipML=[DAN=Opret et godkendelsesworkflow for betalingskladdelinjer ved at gennemg† et par sider med instruktioner.;
                                 ENU=Set up an approval workflow for payment journal lines, by going through a few pages that will guide you.];
                      ApplicationArea=#Suite;
                      Enabled=NOT EnabledApprovalWorkflowsExist;
                      Image=CreateWorkflow;
                      OnAction=VAR
                                 TempApprovalWorkflowWizard@1001 : TEMPORARY Record 1804;
                               BEGIN
                                 TempApprovalWorkflowWizard."Journal Batch Name" := "Journal Batch Name";
                                 TempApprovalWorkflowWizard."Journal Template Name" := "Journal Template Name";
                                 TempApprovalWorkflowWizard."For All Batches" := FALSE;
                                 TempApprovalWorkflowWizard.INSERT;

                                 PAGE.RUNMODAL(PAGE::"Pmt. App. Workflow Setup Wzrd.",TempApprovalWorkflowWizard);
                               END;
                                }
      { 102     ;2   ;Action    ;
                      Name=ManageApprovalWorkflows;
                      CaptionML=[DAN=Administrer godkendelsesworkflows;
                                 ENU=Manage Approval Workflows];
                      ToolTipML=[DAN=Se eller rediger eksisterende godkendelsesworkflows for betalingskladdelinjer.;
                                 ENU=View or edit existing approval workflows for payment journal lines.];
                      ApplicationArea=#Suite;
                      Enabled=EnabledApprovalWorkflowsExist;
                      Image=WorkflowSetup;
                      OnAction=VAR
                                 WorkflowManagement@1000 : Codeunit 1501;
                               BEGIN
                                 WorkflowManagement.NavigateToWorkflows(DATABASE::"Gen. Journal Line",EventFilter);
                               END;
                                }
      { 72      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 70      ;2   ;Action    ;
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
                      PromotedCategory=Category6;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.ApproveGenJournalLineRequest(Rec);
                               END;
                                }
      { 62      ;2   ;Action    ;
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
                      PromotedCategory=Category6;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.RejectGenJournalLineRequest(Rec);
                               END;
                                }
      { 60      ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsen til en stedfortr‘dende godkender.;
                                 ENU=Delegate the approval to a substitute approver.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=Delegate;
                      PromotedCategory=Category6;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.DelegateGenJournalLineRequest(Rec);
                               END;
                                }
      { 56      ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bem‘rkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=ViewComments;
                      PromotedCategory=Category6;
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
      { 109     ;1   ;ActionGroup;
                      CaptionML=[DAN=Side;
                                 ENU=Page] }
      { 108     ;2   ;Action    ;
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
                      PromotedCategory=Category7;
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

    { 33  ;1   ;Field     ;
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
                SourceExpr="Posting Date";
                Style=Attention;
                StyleExpr=HasPmtFileErr }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Visible=FALSE;
                Style=Attention;
                StyleExpr=HasPmtFileErr }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type bilag posten p† kladdelinjen er.;
                           ENU=Specifies the type of document that the entry on the journal line is.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type";
                Style=Attention;
                StyleExpr=HasPmtFileErr }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                Style=Attention;
                StyleExpr=HasPmtFileErr }

    { 9   ;2   ;Field     ;
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

    { 83  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No." }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det eksterne bilagsnummer, der skal udl‘ses i betalingsfilen.;
                           ENU=Specifies the external document number that will be exported in the payment file.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Ext. Doc. No.";
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
                Style=Attention;
                StyleExpr=HasPmtFileErr;
                OnValidate=BEGIN
                             GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;

                ShowMandatory=True }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bankkonto, som bel›bet skal overf›res til efter, at den er eksporteret fra udbetalingskladden.;
                           ENU=Specifies the bank account that the amount will be transferred to after it has been exported from the payment journal.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Recipient Bank Account";
                ShowMandatory=RecipientBankAccountMandatory }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den meddelelse, der eksporteres til betalingsfilen, n†r du bruger funktionen Eksport‚r betalinger til fil i vinduet Udbetalingskladde.;
                           ENU=Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Message to Recipient" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Style=Attention;
                StyleExpr=HasPmtFileErr }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den s‘lger eller indk›ber, der er tilknyttet kladdelinjen.;
                           ENU=Specifies the salesperson or purchaser who is linked to the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Salespers./Purch. Code";
                Visible=FALSE }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, som kladdelinjen er tilknyttet.;
                           ENU=Specifies the number of the campaign that the journal line is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Visible=FALSE }

    { 55  ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver valutakoden for bel›bene p† kladdelinjen.;
                           ENU=Specifies the code of the currency for the amounts on the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                OnAssistEdit=BEGIN
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);

                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transaktionstypen.;
                           ENU=Specifies the type of transaction.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Posting Type";
                Visible=FALSE }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Group";
                Visible=FALSE }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverf›rsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Method Code";
                ShowMandatory=True }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalingen for k›bsfakturaen.;
                           ENU=Specifies the payment of the purchase invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Reference" }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kreditor, som har sendt k›bsfakturaen.;
                           ENU=Specifies the vendor who sent the purchase invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Creditor No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bruttobel›b (bel›b inkl. moms), der er indeholdt i kladdelinjen.;
                           ENU=Specifies the total amount (including VAT) that the journal line consists of.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount;
                Visible=AmountVisible;
                Style=Attention;
                StyleExpr=HasPmtFileErr;
                ShowMandatory=True }

    { 111 ;2   ;Field     ;
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

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsbel›bet, som er inkluderet i totalbel›bet.;
                           ENU=Specifies the amount of VAT that is included in the total amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Amount";
                Visible=FALSE }

    { 101 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem det beregnede momsbel›b og et momsbel›b, du har angivet manuelt.;
                           ENU=Specifies the difference between the calculated VAT amount and a VAT amount that you have entered manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Difference";
                Visible=FALSE }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som modkontomoms, som er inkluderet i totalbel›bet.;
                           ENU=Specifies the amount of Bal. VAT included in the total amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. VAT Amount";
                Visible=FALSE }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem det beregnede momsbel›b og det momsbel›b, du har angivet manuelt.;
                           ENU=Specifies the difference between the calculate VAT amount and the VAT amount that you have entered manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. VAT Difference";
                Visible=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf›res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account Type";
                OnValidate=BEGIN
                             EnableApplyEntriesAction;
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf›res til, f.eks. en kassekonto ved kontantk›b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account No.";
                OnValidate=BEGIN
                             GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringstype, der er knyttet til den modkonto, som vil blive brugt, n†r du bogf›rer posten p† kladdelinjen.;
                           ENU=Specifies the general posting type associated with the balancing account that will be used when you post the entry on the journal line.];
                ApplicationArea=#Advanced;
                SourceExpr="Bal. Gen. Posting Type";
                Visible=FALSE }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den virksomhedsbogf›ringsgruppe, der er knyttet til den modkonto, som vil blive brugt, n†r du bogf›rer posten.;
                           ENU=Specifies the general business posting group code associated with the balancing account that will be used when you post the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Bal. Gen. Bus. Posting Group";
                Visible=FALSE }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den produktbogf›ringsgruppe, der er knyttet til den modkonto, der vil blive brugt, n†r du bogf›rer posten.;
                           ENU=Specifies the general product posting group code associated with the balancing account that will be used when you post the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Bal. Gen. Prod. Posting Group";
                Visible=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for momsvirksomhedsbogf›ringsgruppen, som vil blive brugt, n†r du bogf›rer posten p† kladdelinjen.;
                           ENU=Specifies the code of the VAT business posting group that will be used when you post the entry on the journal line.];
                ApplicationArea=#Advanced;
                SourceExpr="Bal. VAT Bus. Posting Group";
                Visible=FALSE }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den momsproduktbogf›ringsgruppe, der vil blive brugt, n†r du bogf›rer posten p† kladdelinjen.;
                           ENU=Specifies the code of the VAT product posting group that will be used when you post the entry on the journal line.];
                ApplicationArea=#Advanced;
                SourceExpr="Bal. VAT Prod. Posting Group";
                Visible=FALSE }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
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

    { 5   ;2   ;Field     ;
                Name=Applied (Yes/No);
                CaptionML=[DAN=Udlignet (ja/nej);
                           ENU=Applied (Yes/No)];
                ToolTipML=[DAN=Angiver, om betalingen er afstemt.;
                           ENU=Specifies if the payment has been applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=IsApplied }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogf›rt bilag, som dette bilag eller denne kladdelinje udlignes p†, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Doc. Type" }

    { 20  ;2   ;Field     ;
                Name=AppliesToDocNo;
                ToolTipML=[DAN=Angiver nummeret p† det bogf›rte bilag, som dette bilag eller denne kladdelinje udlignes p†, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Doc. No.";
                StyleExpr=StyleTxt }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id for poster, der udlignes, n†r du v‘lger handlingen Udlign poster.;
                           ENU=Specifies the ID of entries that will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to ID";
                Visible=FALSE;
                StyleExpr=StyleTxt }

    { 105 ;2   ;Field     ;
                Name=GetAppliesToDocDueDate;
                CaptionML=[DAN=Udligningsbilag. Forfaldsdato;
                           ENU=Applies-to Doc. Due Date];
                ToolTipML=[DAN=Angiver forfaldsdatoen fra udligningsbilaget p† kladdelinjen.;
                           ENU=Specifies the due date from the Applies-to Doc. on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetAppliesToDocDueDate;
                StyleExpr=StyleTxt }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den betalingstype, der skal bruges for posten p† kladdelinjen.;
                           ENU=Specifies the code for the payment type to be used for the entry on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Payment Type" }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der er udskrevet en check p† bel›bet i betalingskladdelinjen.;
                           ENU=Specifies whether a check has been printed for the amount on the payment journal line.];
                ApplicationArea=#Advanced;
                SourceExpr="Check Printed";
                Visible=FALSE }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 113 ;2   ;Field     ;
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

    { 290 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at betalingskladdelinjen blev eksporteret til en betalingsfil.;
                           ENU=Specifies that the payment journal line was exported to a payment file.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Exported to Payment File" }

    { 28  ;2   ;Field     ;
                Name=TotalExportedAmount;
                DrillDown=Yes;
                CaptionML=[DAN=Samlet eksporteret bel›b;
                           ENU=Total Exported Amount];
                ToolTipML=[DAN=Angiver bel›bet for betalingskladdelinjen, der er eksporteret til betalingsfiler, som ikke er blevet annulleret.;
                           ENU=Specifies the amount for the payment journal line that has been exported to payment files that are not canceled.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TotalExportedAmount;
                OnDrillDown=BEGIN
                              DrillDownExportedAmount
                            END;
                             }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der opstod en fejl, da du brugte funktionen Eksport‚r betalinger til fil i vinduet Udbetalingskladde.;
                           ENU=Specifies that an error occurred when you used the Export Payments to File function in the Payment Journal window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Has Payment Export Error" }

    { 24  ;1   ;Group      }

    { 80  ;2   ;Group     ;
                GroupType=FixedLayout }

    { 82  ;3   ;Group     ;
                GroupType=Group }

    { 84  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den tekst, der vises for forfaldende betalinger.;
                           ENU=Specifies the text that is displayed for overdue payments.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=OverdueWarningText;
                Style=Unfavorable;
                StyleExpr=TRUE }

    { 1903561801;2;Group  ;
                GroupType=FixedLayout }

    { 1903866901;3;Group  ;
                CaptionML=[DAN=Kontonavn;
                           ENU=Account Name] }

    { 29  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontoen.;
                           ENU=Specifies the name of the account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AccName;
                Editable=FALSE;
                ShowCaption=No }

    { 1902759701;3;Group  ;
                CaptionML=[DAN=Modkontonavn;
                           ENU=Bal. Account Name] }

    { 31  ;4   ;Field     ;
                CaptionML=[DAN=Modkontonavn;
                           ENU=Bal. Account Name];
                ToolTipML=[DAN=Angiver navnet p† den modkonto, der er indtastet p† kladdelinjen.;
                           ENU=Specifies the name of the balancing account that has been entered on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BalAccName;
                Editable=FALSE }

    { 1900545401;3;Group  ;
                CaptionML=[DAN=Saldo;
                           ENU=Balance] }

    { 25  ;4   ;Field     ;
                Name=Balance;
                CaptionML=[DAN=Saldo;
                           ENU=Balance];
                ToolTipML=[DAN=Angiver den saldo, der er akkumuleret i betalingskladden p† den linje, hvor mark›ren er placeret.;
                           ENU=Specifies the balance that has accumulated in the payment journal on the line where the cursor is.];
                ApplicationArea=#All;
                SourceExpr=Balance + "Balance (LCY)" - xRec."Balance (LCY)";
                AutoFormatType=1;
                Visible=BalanceVisible;
                Editable=FALSE }

    { 1900295801;3;Group  ;
                CaptionML=[DAN=Total balance;
                           ENU=Total Balance] }

    { 27  ;4   ;Field     ;
                Name=TotalBalance;
                CaptionML=[DAN=Total balance;
                           ENU=Total Balance];
                ToolTipML=[DAN=Viser den totale saldo i betalingskladden.;
                           ENU=Specifies the total balance in the payment journal.];
                ApplicationArea=#All;
                SourceExpr=TotalBalance + "Balance (LCY)" - xRec."Balance (LCY)";
                AutoFormatType=1;
                Visible=TotalBalanceVisible;
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 30  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page193;
                PartType=Page;
                ShowFilter=No }

    { 7   ;1   ;Part      ;
                CaptionML=[DAN=Fejl i betalingsfil;
                           ENU=Payment File Errors];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Journal Template Name=FIELD(Journal Template Name),
                            Journal Batch Name=FIELD(Journal Batch Name),
                            Journal Line No.=FIELD(Line No.);
                PagePartID=Page1228;
                PartType=Page }

    { 1900919607;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=Dimension Set ID=FIELD(Dimension Set ID);
                PagePartID=Page699;
                Visible=FALSE;
                PartType=Page }

    { 88  ;1   ;Part      ;
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

    { 44  ;1   ;Part      ;
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
      Text000@1000 : TextConst 'DAN=Annuller check %1?;ENU=Void Check %1?';
      Text001@1001 : TextConst 'DAN=Annuller alle udskrevne check?;ENU=Void all printed checks?';
      GenJnlLine@1003 : Record 81;
      GenJnlLine2@1004 : Record 81;
      GenJnlManagement@1007 : Codeunit 230;
      ReportPrint@1008 : Codeunit 228;
      DocPrint@1009 : Codeunit 229;
      CheckManagement@1010 : Codeunit 367;
      ChangeExchangeRate@1005 : Page 511;
      GLReconcile@1002 : Page 345;
      CurrentJnlBatchName@1011 : Code[10];
      AccName@1012 : Text[50];
      BalAccName@1013 : Text[50];
      Balance@1014 : Decimal;
      TotalBalance@1015 : Decimal;
      ShowBalance@1016 : Boolean;
      ShowTotalBalance@1017 : Boolean;
      HasPmtFileErr@1006 : Boolean;
      ShortcutDimCode@1018 : ARRAY [8] OF Code[20];
      ApplyEntriesActionEnabled@1031 : Boolean;
      BalanceVisible@19073040 : Boolean INDATASET;
      TotalBalanceVisible@19063333 : Boolean INDATASET;
      StyleTxt@1106 : Text;
      OverdueWarningText@1120 : Text;
      EventFilter@1029 : Text;
      OpenApprovalEntriesExistForCurrUser@1019 : Boolean;
      OpenApprovalEntriesExistForCurrUserBatch@1032 : Boolean;
      OpenApprovalEntriesOnJnlBatchExist@1024 : Boolean;
      OpenApprovalEntriesOnJnlLineExist@1023 : Boolean;
      OpenApprovalEntriesOnBatchOrCurrJnlLineExist@1022 : Boolean;
      OpenApprovalEntriesOnBatchOrAnyJnlLineExist@1021 : Boolean;
      ShowWorkflowStatusOnBatch@1020 : Boolean;
      ShowWorkflowStatusOnLine@1025 : Boolean;
      CanCancelApprovalForJnlBatch@1026 : Boolean;
      CanCancelApprovalForJnlLine@1027 : Boolean;
      EnabledApprovalWorkflowsExist@1028 : Boolean;
      IsAllowPaymentExport@1030 : Boolean;
      IsSaasExcelAddinEnabled@1033 : Boolean;
      RecipientBankAccountMandatory@1034 : Boolean;
      CanRequestFlowApprovalForBatch@1035 : Boolean;
      CanRequestFlowApprovalForBatchAndAllLines@1036 : Boolean;
      CanRequestFlowApprovalForBatchAndCurrentLine@1037 : Boolean;
      CanCancelFlowApprovalForBatch@1038 : Boolean;
      CanCancelFlowApprovalForLine@1039 : Boolean;
      AmountVisible@1040 : Boolean;
      IsSaaS@1042 : Boolean;
      DebitCreditVisible@1041 : Boolean;

    LOCAL PROCEDURE CheckForPmtJnlErrors@5();
    VAR
      BankAccount@1000 : Record 270;
      BankExportImportSetup@1001 : Record 1200;
    BEGIN
      IF HasPmtFileErr THEN
        IF ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") AND BankAccount.GET("Bal. Account No.") THEN
          IF BankExportImportSetup.GET(BankAccount."Payment Export Format") THEN
            IF BankExportImportSetup."Check Export Codeunit" > 0 THEN
              CODEUNIT.RUN(BankExportImportSetup."Check Export Codeunit",Rec);
    END;

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
      SetControlAppearanceFromBatch;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE GetCurrentlySelectedLines@3(VAR GenJournalLine@1000 : Record 81) : Boolean;
    BEGIN
      CurrPage.SETSELECTIONFILTER(GenJournalLine);
      EXIT(GenJournalLine.FINDSET);
    END;

    LOCAL PROCEDURE SetControlAppearanceFromBatch@4();
    VAR
      GenJournalBatch@1000 : Record 232;
      ApprovalsMgmt@1002 : Codeunit 1535;
      WorkflowWebhookManagement@1001 : Codeunit 1543;
      CanRequestFlowApprovalForAllLines@1003 : Boolean;
    BEGIN
      IF ("Journal Template Name" <> '') AND ("Journal Batch Name" <> '') THEN
        GenJournalBatch.GET("Journal Template Name","Journal Batch Name")
      ELSE
        IF NOT GenJournalBatch.GET(GETRANGEMAX("Journal Template Name"),CurrentJnlBatchName) THEN
          EXIT;

      CheckOpenApprovalEntries(GenJournalBatch.RECORDID);

      CanCancelApprovalForJnlBatch := ApprovalsMgmt.CanCancelApprovalForRecord(GenJournalBatch.RECORDID);

      WorkflowWebhookManagement.GetCanRequestAndCanCancelJournalBatch(
        GenJournalBatch,CanRequestFlowApprovalForBatch,CanCancelFlowApprovalForBatch,CanRequestFlowApprovalForAllLines);
      CanRequestFlowApprovalForBatchAndAllLines := CanRequestFlowApprovalForBatch AND CanRequestFlowApprovalForAllLines;
    END;

    LOCAL PROCEDURE CheckOpenApprovalEntries@7(BatchRecordId@1000 : RecordID);
    VAR
      ApprovalsMgmt@1001 : Codeunit 1535;
    BEGIN
      OpenApprovalEntriesExistForCurrUserBatch := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(BatchRecordId);

      OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(BatchRecordId);

      OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
        OpenApprovalEntriesOnJnlBatchExist OR
        ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries("Journal Template Name","Journal Batch Name");
    END;

    LOCAL PROCEDURE SetControlAppearance@6();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
      WorkflowWebhookManagement@1000 : Codeunit 1543;
      CanRequestFlowApprovalForLine@1001 : Boolean;
    BEGIN
      OpenApprovalEntriesExistForCurrUser :=
        OpenApprovalEntriesExistForCurrUserBatch OR ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);

      OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
      OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist OR OpenApprovalEntriesOnJnlLineExist;

      CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

      WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestFlowApprovalForLine,CanCancelFlowApprovalForLine);
      CanRequestFlowApprovalForBatchAndCurrentLine := CanRequestFlowApprovalForBatch AND CanRequestFlowApprovalForLine;
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

