OBJECT Page 1292 Payment Application
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Betalingsudligning;
               ENU=Payment Application];
    DeleteAllowed=No;
    SourceTable=Table1293;
    DelayedInsert=Yes;
    SourceTableView=SORTING(Sorting Order)
                    ORDER(Ascending);
    PageType=Worksheet;
    SourceTableTemporary=Yes;
    OnOpenPage=BEGIN
                 CODEUNIT.RUN(CODEUNIT::"Get Bank Stmt. Line Candidates",Rec);
                 SETCURRENTKEY("Sorting Order","Stmt To Rem. Amount Difference");
                 ASCENDING(TRUE);

                 IF FINDFIRST THEN;
               END;

    OnNewRecord=BEGIN
                  TransferFromBankAccReconLine(BankAccReconLine);
                END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateTotals;
                           LineEditable := "Applies-to Entry No." = 0;
                         END;

    ActionList=ACTIONS
    {
      { 43      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 38      ;1   ;ActionGroup;
                      CaptionML=[DAN=Detaljer;
                                 ENU=Details] }
      { 42      ;2   ;Action    ;
                      Name=ShowBankTransactionDetails;
                      CaptionML=[DAN=Banktransaktionsdetaljer;
                                 ENU=Bank Transaction Details];
                      ToolTipML=[DAN=Vis bankkontooplysninger for den valgte linje. Detaljerne omfatter de vërdier, som findes i en importeret bankkontoudtogsfil.;
                                 ENU=View the bank statement details for the selected line. The details include the values that exist in an imported bank statement file.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ExternalDocument;
                      OnAction=VAR
                                 DataExchField@1001 : Record 1221;
                               BEGIN
                                 DataExchField.SETRANGE("Data Exch. No.",BankAccReconLine."Data Exch. Entry No.");
                                 DataExchField.SETRANGE("Line No.",BankAccReconLine."Data Exch. Line No.");
                                 PAGE.RUN(PAGE::"Bank Statement Line Details",DataExchField);
                               END;
                                }
      { 7       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=Gennemse;
                                 ENU=Review] }
      { 9       ;2   ;Action    ;
                      Name=Accept;
                      CaptionML=[DAN=AcceptÇr udligninger;
                                 ENU=Accept Applications];
                      ToolTipML=[DAN=AcceptÇr en betalingsudligning efter gennemsyn eller manuel udligning med poster. Dermed lukkes betalingsudligningen, og Matchtillid indstilles til Accepteret.;
                                 ENU=Accept a payment application after reviewing it or manually applying it to entries. This closes the payment application and sets the Match Confidence to Accepted.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Approve;
                      OnAction=BEGIN
                                 IF BankAccReconLine.Difference * BankAccReconLine."Applied Amount" > 0 THEN
                                   IF BankAccReconLine."Account Type" = BankAccReconLine."Account Type"::"Bank Account" THEN
                                     ERROR(ExcessiveAmountErr,BankAccReconLine.Difference);

                                 BankAccReconLine.AcceptApplication;
                                 CurrPage.CLOSE;
                               END;
                                }
      { 8       ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Fjern udligninger;
                                 ENU=Remove Applications];
                      ToolTipML=[DAN=Fjern en betalingsudligning fra en post. Udligningen af betalingen annulleres.;
                                 ENU=Remove a payment application from an entry. This unapplies the payment.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Reject;
                      OnAction=BEGIN
                                 IF CONFIRM(RemoveApplicationsQst) THEN
                                   RemoveApplications;
                               END;
                                }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Vis;
                                 ENU=Show] }
      { 35      ;2   ;Action    ;
                      Name=AllOpenEntries;
                      CaptionML=[DAN=Alle Übne poster;
                                 ENU=All Open Entries];
                      ToolTipML=[DAN=Viser alle Übne poster, som betalingen kan udlignes med.;
                                 ENU=Show all open entries that the payment can be applied to.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewDetails;
                      OnAction=BEGIN
                                 SETRANGE(Applied);
                                 SETRANGE("Account Type");
                                 SETRANGE("Account No.");
                                 SETRANGE(Type,Type::"Bank Account Ledger Entry",Type::"Check Ledger Entry");

                                 IF FINDFIRST THEN;
                               END;
                                }
      { 37      ;2   ;Action    ;
                      Name=RelatedPartyOpenEntries;
                      CaptionML=[DAN=Relateret parts Übne poster;
                                 ENU=Related-Party Open Entries];
                      ToolTipML=[DAN=Vis kun Übne poster, der gëlder specifikt for den relaterede part i feltet Kontonr. Dette begrënser listen til de Übne poster, der med stõrst sandsynlighed relaterer til betalingen.;
                                 ENU=Show only open entries that are specifically for the related party in the Account No. field. This limits the list to those open entries that are most likely to relate to the payment.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewDocumentLine;
                      OnAction=BEGIN
                                 SETRANGE(Applied);

                                 BankAccReconLine.GET(
                                   BankAccReconLine."Statement Type",BankAccReconLine."Bank Account No.",
                                   BankAccReconLine."Statement No.",BankAccReconLine."Statement Line No.");

                                 IF BankAccReconLine."Account No." <> '' THEN BEGIN
                                   SETRANGE("Account No.",BankAccReconLine."Account No.");
                                   SETRANGE("Account Type",BankAccReconLine."Account Type");
                                 END;
                                 SETRANGE(Type,Type::"Bank Account Ledger Entry",Type::"Check Ledger Entry");

                                 IF FINDFIRST THEN;
                               END;
                                }
      { 36      ;2   ;Action    ;
                      Name=AppliedEntries;
                      CaptionML=[DAN=Udlignede poster;
                                 ENU=Applied Entries];
                      ToolTipML=[DAN=Se finansposter, der er godkendt for denne record.;
                                 ENU=View the ledger entries that have been applied to this record.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewRegisteredOrder;
                      OnAction=BEGIN
                                 SETRANGE(Applied,TRUE);
                                 SETRANGE("Account Type");
                                 SETRANGE("Account No.");
                                 SETRANGE(Type,Type::"Bank Account Ledger Entry",Type::"Check Ledger Entry");

                                 IF FINDFIRST THEN;
                               END;
                                }
      { 46      ;2   ;Action    ;
                      Name=AllOpenBankTransactions;
                      CaptionML=[DAN=Alle Übne banktransaktioner;
                                 ENU=All Open Bank Transactions];
                      ToolTipML=[DAN=Vis alle Übne bankposter, som betalingen kan udlignes med.;
                                 ENU=View all open bank entries that the payment can be applied to.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewPostedOrder;
                      OnAction=BEGIN
                                 SETRANGE(Applied);
                                 SETRANGE("Account Type","Account Type"::"Bank Account");
                                 SETRANGE("Account No.");
                                 SETRANGE(Type,Type::"Bank Account Ledger Entry");

                                 IF FINDFIRST THEN;
                               END;
                                }
      { 47      ;2   ;Action    ;
                      Name=AllOpenPayments;
                      CaptionML=[DAN=Alle Übne betalinger;
                                 ENU=All Open Payments];
                      ToolTipML=[DAN=Viser alle Übne checks, som betalingen kan udlignes med.;
                                 ENU=Show all open checks that the payment can be applied to.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewCheck;
                      OnAction=BEGIN
                                 SETRANGE(Applied);
                                 SETRANGE("Account Type","Account Type"::"Bank Account");
                                 SETRANGE("Account No.");
                                 SETRANGE(Type,Type::"Check Ledger Entry");
                                 IF FINDFIRST THEN;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 29  ;0   ;Container ;
                ContainerType=ContentArea }

    { 30  ;1   ;Group     ;
                Name=PaymentInformation;
                CaptionML=[DAN=Betalingsoplysninger;
                           ENU=Payment Information];
                GroupType=Group }

    { 39  ;2   ;Field     ;
                Name=PaymentStatus;
                CaptionML=[DAN=Betalingsstatus;
                           ENU=Payment Status];
                ToolTipML=[DAN=Angiver udligningens status for betalingen, herunder oplysninger om matchtilliden for de betalinger, der er udlignet automatisk.;
                           ENU=Specifies the application status of the payment, including information about the match confidence of payments that are applied automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Status;
                Editable=FALSE;
                Style=Strong;
                StyleExpr=TRUE }

    { 31  ;2   ;Field     ;
                Name=TransactionDate;
                CaptionML=[DAN=Transaktionsdato;
                           ENU=Transaction Date];
                ToolTipML=[DAN=Angiver den dato, hvor betalingen blev registreret pÜ bankkontoen.;
                           ENU=Specifies the date when the payment was recorded in the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BankAccReconLine."Transaction Date";
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                Name=TransactionAmount;
                CaptionML=[DAN=Transaktionsbelõb;
                           ENU=Transaction Amount];
                ToolTipML=[DAN=Angiver det betalingsbelõb, som blev registreret pÜ den elektroniske bankkonto.;
                           ENU=Specifies the payment amount that was recorded on the electronic bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BankAccReconLine."Statement Amount";
                Editable=FALSE }

    { 33  ;2   ;Field     ;
                Name=BankAccReconLineDescription;
                CaptionML=[DAN=Transaktionstekst;
                           ENU=Transaction Text];
                ToolTipML=[DAN=Angiver den tekst, der blev indtastet for betalingen, da betalingen blev foretaget til den elektroniske bankkonto.;
                           ENU=Specifies the text that was entered on the payment when the payment was made to the electronic bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BankAccReconLine."Transaction Text";
                Editable=FALSE }

    { 34  ;1   ;Group     ;
                CaptionML=[DAN=èbne poster;
                           ENU=Open Entries];
                GroupType=Group }

    { 28  ;2   ;Group     ;
                CaptionML=[DAN=èbne poster;
                           ENU=Open Entries];
                GroupType=Repeater }

    { 19  ;3   ;Field     ;
                Name=AppliedAmount;
                CaptionML=[DAN=Udligningsbelõb;
                           ENU=Applied Amount];
                ToolTipML=[DAN=Angiver betalingsbelõbet uden vërdien i feltet Afstemt kontantrabat, som udlignes med den Übne post.;
                           ENU=Specifies the payment amount, excluding the value in the Applied Pmt. Discount field, that is applied to the open entry.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Applied Amt. Incl. Discount";
                Style=Strong;
                StyleExpr=TRUE;
                OnValidate=BEGIN
                             UpdateAfterChangingApplication;
                           END;
                            }

    { 20  ;3   ;Field     ;
                Name=Applied;
                ToolTipML=[DAN=Angiver, at den betaling, der er angivet pÜ hovedet i vinduet Betalingsudligning, er udlignet med den Übne post.;
                           ENU=Specifies that the payment specified on the header of the Payment Application window is applied to the open entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Applied;
                OnValidate=BEGIN
                             UpdateAfterChangingApplication;
                           END;
                            }

    { 17  ;3   ;Field     ;
                Name=RemainingAmountAfterPosting;
                CaptionML=[DAN=Restbelõb (efter bogfõring);
                           ENU=Remaining Amount After Posting];
                ToolTipML=[DAN=Angiver det belõb, der endnu ikke er betalt for den Übne post, efter du har bogfõrt betalingen i vinduet Betalingsudligningskladde.;
                           ENU=Specifies the amount that remains to be paid for the open entry after you have posted the payment in the Payment Reconciliation Journal window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetRemainingAmountAfterPostingValue }

    { 14  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor- eller kreditorpost, som betalingen udlignes med, nÜr du bogfõrer betalingsudligningskladdelinjen.;
                           ENU=Specifies the number of the customer or vendor ledger entry that the payment will be applied to when you post the payment reconciliation journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Entry No.";
                Editable=FALSE;
                OnDrillDown=BEGIN
                              AppliesToEntryNoDrillDown;
                            END;
                             }

    { 12  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen for den Übne post.;
                           ENU=Specifies the due date of the open entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Editable=FALSE }

    { 24  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, der er relateret til den Übne post.;
                           ENU=Specifies the type of document that is related to the open entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type";
                Editable=FALSE }

    { 23  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det bilag, der er relateret til den Übne post.;
                           ENU=Specifies the number of the document that is related to the open entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                Editable=FALSE }

    { 22  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No.";
                Editable=FALSE }

    { 21  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af den Übne post.;
                           ENU=Specifies the description of the open entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Editable=FALSE }

    { 44  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der mangler at blive betalt for den Übne post.;
                           ENU=Specifies the amount that remains to be paid for the open entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Remaining Amount";
                Visible=FALSE;
                Enabled=FALSE;
                Editable=FALSE }

    { 41  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der endnu ikke er betalt for den Übne post, minus enhver tildelt kontantrabat.;
                           ENU=Specifies the amount that remains to be paid for the open entry, minus any granted payment discount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amt. Incl. Discount";
                Enabled=FALSE;
                Editable=FALSE }

    { 16  ;3   ;Field     ;
                CaptionML=[DAN=Kont.rabatdato;
                           ENU=Pmt. Discount Date];
                ToolTipML=[DAN=Angiver den dato, hvor restbelõbet for den Übne post skal vëre betalt, for at der kan tildeles en kontantrabat.;
                           ENU=Specifies the date on which the remaining amount on the open entry must be paid to grant a discount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Disc. Due Date";
                OnValidate=BEGIN
                             UpdateAfterChangingApplication;
                           END;
                            }

    { 45  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den seneste dato, hvor belõbet i posten skal vëre betalt, for at der kan opnÜs kontantrabattolerance.;
                           ENU=Specifies the latest date the amount in the entry must be paid in order for payment discount tolerance to be granted.];
                ApplicationArea=#Advanced;
                SourceExpr="Pmt. Disc. Tolerance Date";
                Visible=FALSE }

    { 15  ;3   ;Field     ;
                CaptionML=[DAN=Mulig restkontantrabat;
                           ENU=Remaining Pmt. Discount Possible];
                ToolTipML=[DAN=Angiver, hvor meget rabat du kan tildele for betalingen, hvis du udligner den med den Übne post.;
                           ENU=Specifies how much discount you can grant for the payment if you apply it to the open entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Pmt. Disc. Possible";
                OnValidate=BEGIN
                             UpdateAfterChangingApplication;
                           END;
                            }

    { 40  ;3   ;Field     ;
                Name=AccountName;
                CaptionML=[DAN=Kontonavn;
                           ENU=Account Name];
                ToolTipML=[DAN=Angiver navnet pÜ den konto, som betalingen udlignes med i vinduet Betalingsudligningskladde.;
                           ENU=Specifies the name of the account that the payment is applied to in the Payment Reconciliation Journal window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetAccountName;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              AccountNameDrillDown;
                            END;
                             }

    { 27  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som betalingsudligningen vil blive bogfõrt til, nÜr du bogfõrer betalingsudligningskladden.;
                           ENU=Specifies the type of account that the payment application will be posted to when you post the payment reconciliation journal.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Type";
                Editable=LineEditable }

    { 26  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det kontonummer, som betalingsudligningen vil blive bogfõrt til, nÜr du bogfõrer betalingudligningskladden.;
                           ENU=Specifies the account number the payment application will be posted to when you post the payment reconciliation journal.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account No.";
                Editable=LineEditable;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 25  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver bogfõringsdatoen for den Übne post.;
                           ENU=Specifies the posting date of the open entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date";
                Visible=FALSE;
                Editable=FALSE }

    { 13  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kvaliteten af tilknytningen mellem betalingen og den Übne post til betalingsafstemningsformÜl.;
                           ENU=Specifies the quality of the match between the payment and the open entry for payment application purposes.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Match Confidence" }

    { 18  ;3   ;Field     ;
                CaptionML=[DAN=Valutakode for post;
                           ENU=Entry Currency Code];
                ToolTipML=[DAN=Angiver valutakoden for den Übne post.;
                           ENU=Specifies the currency code of the open entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 5   ;1   ;Group     ;
                GroupType=Group }

    { 6   ;2   ;Field     ;
                Name=TotalAppliedAmount;
                CaptionML=[DAN=Udligningsbelõb;
                           ENU=Applied Amount];
                ToolTipML=[DAN=Angiver summen af vërdierne i feltet Udligningsbelõb pÜ alle linjerne i vinduet Betalingsudligning.;
                           ENU=Specifies the sum of the values in the Applied Amount field on lines in the Payment Application window.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=BankAccReconLine."Applied Amount";
                AutoFormatType=1;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                Name=TotalRemainingAmount;
                CaptionML=[DAN=Difference;
                           ENU=Difference];
                ToolTipML=[DAN=Angiver, hvor stor en del af betalingsbelõbet der endnu ikke er udlignet med Übne poster i vinduet Betalingsudligning.;
                           ENU=Specifies how much of the payment amount remains to be applied to open entries in the Payment Application window.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=BankAccReconLine."Statement Amount" - BankAccReconLine."Applied Amount";
                AutoFormatType=1;
                Editable=FALSE;
                StyleExpr=RemAmtToApplyStyleExpr }

    { 3   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 2   ;1   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Bank Account No.=FIELD(Bank Account No.),
                            Statement No.=FIELD(Statement No.),
                            Statement Line No.=FIELD(Statement Line No.),
                            Statement Type=FIELD(Statement Type),
                            Account Type=FIELD(Account Type),
                            Account No.=FIELD(Account No.),
                            Applies-to Entry No.=FIELD(Applies-to Entry No.),
                            Match Confidence=FIELD(Match Confidence),
                            Quality=FIELD(Quality);
                PagePartID=Page1288;
                PartType=Page }

    { 1   ;1   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Bank Account No.=FIELD(Bank Account No.),
                            Statement No.=FIELD(Statement No.),
                            Statement Line No.=FIELD(Statement Line No.),
                            Statement Type=FIELD(Statement Type);
                PagePartID=Page1289;
                PartType=Page }

  }
  CODE
  {
    VAR
      BankAccReconLine@1000 : Record 274;
      RemAmtToApplyStyleExpr@1001 : Text;
      RemoveApplicationsQst@1002 : TextConst 'DAN=Er du sikker pÜ, at du vil fjerne alle udligninger?;ENU=Are you sure you want to remove all applications?';
      Status@1003 : Text;
      AppliedManuallyStatusTxt@1004 : TextConst 'DAN=Afstemt manuelt;ENU=Applied Manually';
      NoApplicationStatusTxt@1005 : TextConst 'DAN=Ikke afstemt;ENU=Not Applied';
      AppliedAutomaticallyStatusTxt@1006 : TextConst 'DAN=Afstemt automatisk - matchtillid: %1;ENU=Applied Automatically - Match Confidence: %1';
      AcceptedStatusTxt@1007 : TextConst 'DAN=Accepteret;ENU=Accepted';
      LineEditable@1008 : Boolean;
      ExcessiveAmountErr@1010 : TextConst '@@@=%1 is the amount that is not applied (there is filed on the page named Remaining Amount To Apply);DAN=Restbelõbet til udligning er %1.;ENU=The remaining amount to apply is %1.';

    [External]
    PROCEDURE SetBankAccReconcLine@3(NewBankAccReconLine@1000 : Record 274);
    BEGIN
      BankAccReconLine := NewBankAccReconLine;
      TransferFromBankAccReconLine(NewBankAccReconLine);

      OnSetBankAccReconcLine(BankAccReconLine);
    END;

    LOCAL PROCEDURE UpdateTotals@7();
    BEGIN
      BankAccReconLine.GET(
        BankAccReconLine."Statement Type",BankAccReconLine."Bank Account No.",
        BankAccReconLine."Statement No.",BankAccReconLine."Statement Line No.");

      BankAccReconLine.CALCFIELDS("Match Confidence");
      CASE BankAccReconLine."Match Confidence" OF
        BankAccReconLine."Match Confidence"::None:
          Status := NoApplicationStatusTxt;
        BankAccReconLine."Match Confidence"::Accepted:
          Status := AcceptedStatusTxt;
        BankAccReconLine."Match Confidence"::Manual:
          Status := AppliedManuallyStatusTxt;
        ELSE
          Status := STRSUBSTNO(AppliedAutomaticallyStatusTxt,BankAccReconLine."Match Confidence");
      END;

      UpdateRemAmtToApplyStyle;
    END;

    LOCAL PROCEDURE UpdateRemAmtToApplyStyle@6();
    BEGIN
      IF BankAccReconLine."Statement Amount" = BankAccReconLine."Applied Amount" THEN
        RemAmtToApplyStyleExpr := 'Favorable'
      ELSE
        RemAmtToApplyStyleExpr := 'Unfavorable';
    END;

    LOCAL PROCEDURE UpdateAfterChangingApplication@13();
    VAR
      MatchBankPayments@1000 : Codeunit 1255;
    BEGIN
      BankAccReconLine.SetManualApplication;
      UpdateToSystemMatchConfidence;
      UpdateTotals;
      MatchBankPayments.UpdateType(BankAccReconLine);
    END;

    LOCAL PROCEDURE UpdateToSystemMatchConfidence@1();
    VAR
      BankPmtApplRule@1001 : Record 1252;
    BEGIN
      IF ("Match Confidence" = "Match Confidence"::Accepted) OR ("Match Confidence" = "Match Confidence"::Manual) THEN
        "Match Confidence" := BankPmtApplRule.GetMatchConfidence(Quality);
    END;

    [Integration(TRUE)]
    PROCEDURE OnSetBankAccReconcLine@2(BankAccReconciliationLine@1000 : Record 274);
    BEGIN
    END;

    BEGIN
    END.
  }
}

