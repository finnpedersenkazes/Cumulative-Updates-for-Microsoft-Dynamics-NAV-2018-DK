OBJECT Page 379 Bank Acc. Reconciliation
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bankkontoafstemning;
               ENU=Bank Acc. Reconciliation];
    SaveValues=No;
    SourceTable=Table273;
    SourceTableView=WHERE(Statement Type=CONST(Bank Reconciliation));
    PageType=Document;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Bank,Matching;
                                ENU=New,Process,Report,Bank,Matching];
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Afstem;
                                 ENU=&Recon.];
                      Image=BankAccountRec }
      { 26      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=&Kort;
                                 ENU=&Card];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om den record, der behandles p† kladdelinjen.;
                                 ENU=View or change detailed information about the record that is being processed on the journal line.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 370;
                      RunPageLink=No.=FIELD(Bank Account No.);
                      Image=EditLines }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 14      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 16      ;2   ;Action    ;
                      Name=SuggestLines;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Foresl† linjer;
                                 ENU=Suggest Lines];
                      ToolTipML=[DAN=Opret forslag til bankkontoposter, og inds‘t dem automatisk.;
                                 ENU=Create bank account ledger entries suggestions and enter them automatically.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SuggestLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SuggestBankAccStatement.SetStmt(Rec);
                                 SuggestBankAccStatement.RUNMODAL;
                                 CLEAR(SuggestBankAccStatement);
                               END;
                                }
      { 24      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Overf›r til finanskladde;
                                 ENU=Transfer to General Journal];
                      ToolTipML=[DAN=Overf›r linjerne fra det aktuelle vindue til finanskladden.;
                                 ENU=Transfer the lines from the current window to the general journal.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=TransferToGeneralJournal;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TransferToGLJnl.SetBankAccRecon(Rec);
                                 TransferToGLJnl.RUN;
                               END;
                                }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ba&nk;
                                 ENU=Ba&nk];
                      ActionContainerType=NewDocumentItems }
      { 3       ;2   ;Action    ;
                      Name=ImportBankStatement;
                      CaptionML=[DAN=Import‚r bankkontoudtog;
                                 ENU=Import Bank Statement];
                      ToolTipML=[DAN=Import‚r elektroniske bankkontoudtog fra banken for at udfylde med data om faktiske banktransaktioner.;
                                 ENU=Import electronic bank statements from your bank to populate with data about actual bank transactions.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 CurrPage.UPDATE;
                                 ImportBankStatement;
                               END;
                                }
      { 12      ;1   ;ActionGroup;
                      CaptionML=[DAN=M&atching;
                                 ENU=M&atching] }
      { 4       ;2   ;Action    ;
                      Name=MatchAutomatically;
                      CaptionML=[DAN=Match automatisk;
                                 ENU=Match Automatically];
                      ToolTipML=[DAN=S›g automatisk efter, og afstem bankkontoudtogslinjer.;
                                 ENU=Automatically search for and match bank statement lines.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=MapAccounts;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 SETRANGE("Statement Type","Statement Type");
                                 SETRANGE("Bank Account No.","Bank Account No.");
                                 SETRANGE("Statement No.","Statement No.");
                                 REPORT.RUN(REPORT::"Match Bank Entries",TRUE,TRUE,Rec);
                               END;
                                }
      { 18      ;2   ;Action    ;
                      Name=MatchManually;
                      CaptionML=[DAN=Match manuelt;
                                 ENU=Match Manually];
                      ToolTipML=[DAN=Afstem udvalgte linjer manuelt i begge ruder for at knytte alle bankkontoudtogslinjer til ‚n eller flere relaterede bankkontoposter.;
                                 ENU=Manually match selected lines in both panes to link each bank statement line to one or more related bank account ledger entries.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CheckRulesSyntax;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 TempBankAccReconciliationLine@1001 : TEMPORARY Record 274;
                                 TempBankAccountLedgerEntry@1000 : TEMPORARY Record 271;
                                 MatchBankRecLines@1002 : Codeunit 1252;
                               BEGIN
                                 CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                                 CurrPage.ApplyBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                                 MatchBankRecLines.MatchManually(TempBankAccReconciliationLine,TempBankAccountLedgerEntry);
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=RemoveMatch;
                      CaptionML=[DAN=Fjern match;
                                 ENU=Remove Match];
                      ToolTipML=[DAN=Fjern markeringen af afstemte bankkontoudtogslinjer.;
                                 ENU=Remove selection of matched bank statement lines.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=RemoveContacts;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 TempBankAccReconciliationLine@1002 : TEMPORARY Record 274;
                                 TempBankAccountLedgerEntry@1001 : TEMPORARY Record 271;
                                 MatchBankRecLines@1000 : Codeunit 1252;
                               BEGIN
                                 CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                                 CurrPage.ApplyBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                                 MatchBankRecLines.RemoveMatch(TempBankAccReconciliationLine,TempBankAccountLedgerEntry);
                               END;
                                }
      { 10      ;2   ;Action    ;
                      Name=All;
                      CaptionML=[DAN=Vis alle;
                                 ENU=Show All];
                      ToolTipML=[DAN=Vis alle bankkontoudtogslinjer.;
                                 ENU=Show all bank statement lines.];
                      ApplicationArea=#Basic,#Suite;
                      Image=AddWatch;
                      OnAction=BEGIN
                                 CurrPage.StmtLine.PAGE.ToggleMatchedFilter(FALSE);
                                 CurrPage.ApplyBankLedgerEntries.PAGE.ToggleMatchedFilter(FALSE);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=NotMatched;
                      CaptionML=[DAN=Vis ikke-matchede;
                                 ENU=Show Nonmatched];
                      ToolTipML=[DAN=Vis alle bankkontoudtogslinjer, der endnu ikke er afstemt.;
                                 ENU=Show all bank statement lines that have not yet been matched.];
                      ApplicationArea=#Basic,#Suite;
                      Image=AddWatch;
                      OnAction=BEGIN
                                 CurrPage.StmtLine.PAGE.ToggleMatchedFilter(TRUE);
                                 CurrPage.ApplyBankLedgerEntries.PAGE.ToggleMatchedFilter(TRUE);
                               END;
                                }
      { 1       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 15      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kon&troller;
                                 ENU=&Test Report];
                      ToolTipML=[DAN=Vis eksempel p† de resulterende bankkontoafstemninger for at se konsekvenserne, f›r du udf›rer den faktiske bogf›ring.;
                                 ENU=Preview the resulting bank account reconciliations to see the consequences before you perform the actual posting.];
                      ApplicationArea=#Basic,#Suite;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintBankAccRecon(Rec);
                               END;
                                }
      { 17      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 371;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process }
      { 9       ;2   ;Action    ;
                      Name=PostAndPrint;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden, og forbered udskrivning. V‘rdierne og m‘ngderne bogf›res p† de relevante konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 372;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 5   ;2   ;Field     ;
                Name=BankAccountNo;
                CaptionML=[DAN=Bankkontonr.;
                           ENU=Bank Account No.];
                ToolTipML=[DAN=Angiver nummeret p† den konto, du vil afstemme med bankens kontoudtog.;
                           ENU=Specifies the number of the bank account that you want to reconcile with the bank's statement.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account No." }

    { 20  ;2   ;Field     ;
                Name=StatementNo;
                CaptionML=[DAN=Kontoudtogsnr.;
                           ENU=Statement No.];
                ToolTipML=[DAN=Angiver nummeret p† bankkontoudtoget.;
                           ENU=Specifies the number of the bank account statement.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Statement No." }

    { 22  ;2   ;Field     ;
                Name=StatementDate;
                CaptionML=[DAN=Kontoudtogsdato;
                           ENU=Statement Date];
                ToolTipML=[DAN=Angiver datoen p† bankkontoudtoget.;
                           ENU=Specifies the date on the bank account statement.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Statement Date" }

    { 28  ;2   ;Field     ;
                Name=BalanceLastStatement;
                CaptionML=[DAN=Sidste kontoudtog - saldo;
                           ENU=Balance Last Statement];
                ToolTipML=[DAN=Angiver slutsaldoen p† det forrige bankkontoudtog, der blev benyttet i den sidst bogf›rte afstemning af bankkontoen.;
                           ENU=Specifies the ending balance shown on the last bank statement, which was used in the last posted bank reconciliation for this bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance Last Statement" }

    { 30  ;2   ;Field     ;
                Name=StatementEndingBalance;
                CaptionML=[DAN=Kontoudtogs slutsaldo;
                           ENU=Statement Ending Balance];
                ToolTipML=[DAN=Angiver slutsaldoen fra bankens kontoudtog, som du afstemmer med bankkontoen.;
                           ENU=Specifies the ending balance shown on the bank's statement that you want to reconcile with the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Statement Ending Balance" }

    { 8   ;1   ;Group     ;
                GroupType=Group }

    { 11  ;2   ;Part      ;
                Name=StmtLine;
                CaptionML=[DAN=Bankkontoudtogslinjer;
                           ENU=Bank Statement Lines];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Bank Account No.=FIELD(Bank Account No.),
                            Statement No.=FIELD(Statement No.);
                PagePartID=Page380;
                PartType=Page }

    { 6   ;2   ;Part      ;
                Name=ApplyBankLedgerEntries;
                CaptionML=[DAN=Bankkontoposter;
                           ENU=Bank Account Ledger Entries];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Bank Account No.=FIELD(Bank Account No.),
                            Open=CONST(Yes),
                            Statement Status=FILTER(Open|Bank Acc. Entry Applied|Check Entry Applied),
                            Reversed=FILTER(No);
                PagePartID=Page381;
                PartType=Page }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

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
      SuggestBankAccStatement@1000 : Report 1496;
      TransferToGLJnl@1001 : Report 1497;
      ReportPrint@1002 : Codeunit 228;

    BEGIN
    END.
  }
}

