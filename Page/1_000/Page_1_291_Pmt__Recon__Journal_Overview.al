OBJECT Page 1291 Pmt. Recon. Journal Overview
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Oversigt over betalingsudligningskladder;
               ENU=Payment Reconciliation Journal Overview];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table274;
    DataCaptionExpr="Bank Account No.";
    SourceTableView=WHERE(Statement Type=CONST(Payment Application));
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Gennemse,Detaljer,Brugerdefineret sortering;
                                ENU=New,Process,Report,Review,Details,Custom Sorting];
    OnOpenPage=BEGIN
                 SETFILTER(Difference,'<>0');
               END;

    OnAfterGetRecord=BEGIN
                       GetAppliedPmtData(AppliedPmtEntry,RemainingAmountAfterPosting,StatementToRemAmtDifference,PmtAppliedToTxt);
                     END;

    OnAfterGetCurrRecord=BEGIN
                           IF NOT IsBankAccReconInitialized THEN BEGIN
                             BankAccReconciliation.GET("Statement Type","Bank Account No.","Statement No.");
                             IsBankAccReconInitialized := TRUE;
                           END;

                           BankAccReconciliation.CALCFIELDS("Total Balance on Bank Account","Total Unposted Applied Amount","Total Transaction Amount");
                         END;

    ActionList=ACTIONS
    {
      { 45      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Brugerdefineret sortering;
                                 ENU=Custom Sorting] }
      { 56      ;2   ;Action    ;
                      Name=ShowNonAppliedLines;
                      CaptionML=[DAN=Vis ikke-afstemte linjer;
                                 ENU=Show Non-Applied Lines];
                      ToolTipML=[DAN=Vis kun de betalinger p† listen, som ikke er blevet udlignet.;
                                 ENU=Display only payments in the list that have not been applied.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=FilterLines;
                      PromotedCategory=Category6;
                      OnAction=BEGIN
                                 SETFILTER(Difference,'<>0');
                                 CurrPage.UPDATE;
                               END;
                                }
      { 55      ;2   ;Action    ;
                      Name=ShowAllLines;
                      CaptionML=[DAN=Vis alle linjer;
                                 ENU=Show All Lines];
                      ToolTipML=[DAN=Vis alle betalinger p† listen uanset deres status.;
                                 ENU=Show all payments in the list no matter what their status is.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=AllLines;
                      PromotedCategory=Category6;
                      OnAction=BEGIN
                                 SETRANGE(Difference);
                                 CurrPage.UPDATE;
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
                ToolTipML=[DAN=Angiver kvaliteten af den automatiske betalingsudligning p† kladdelinjen.;
                           ENU=Specifies the quality of the automatic payment application on the journal line.];
                ApplicationArea=#Advanced;
                SourceExpr="Match Confidence";
                Visible=FALSE;
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for bank- eller checkposten p† afstemningslinjen, n†r funktionen Foresl† linjer benyttes.;
                           ENU=Specifies the posting date of the bank account or check ledger entry on the reconciliation line when the Suggest Lines function is used.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction Date" }

    { 16  ;2   ;Field     ;
                Width=40;
                ToolTipML=[DAN=Angiver den tekst, som debitoren eller kreditoren har angivet p† den betalingstransaktion, der er repr‘senteret af kladdelinjen.;
                           ENU=Specifies the text that the customer or vendor entered on that payment transaction that is represented by the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction Text" }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Transaktionsbel›b;
                           ENU=Transaction Amount];
                ToolTipML=[DAN=Angiver bel›bet for transaktionen p† bankens kontoudtog p† afstemningslinjen.;
                           ENU=Specifies the amount of the transaction on the bank's statement shown on this reconciliation line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Statement Amount" }

    { 3   ;2   ;Field     ;
                Name=AccountName;
                CaptionML=[DAN=Afstemt med konto;
                           ENU=Applied to Account];
                ToolTipML=[DAN=Angiver den konto, som betalingen er udlignet med.;
                           ENU=Specifies the account that the payment is applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetAppliedToName;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              AppliedToDrillDown;
                            END;
                             }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for transaktionen p† afstemningslinjen, der er blevet udlignet med en bank- eller checkpost.;
                           ENU=Specifies the amount of the transaction on the reconciliation line that has been applied to a bank account or check ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applied Amount" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem bel›bet i feltet Kontoudtogsbel›b og bel›bet i feltet Udligningsbel›b p† denne linje.;
                           ENU=Specifies the difference between the amount in the Statement Amount field and the amount in the Applied Amount field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Difference;
                Editable=FALSE;
                Style=Unfavorable }

    { 52  ;2   ;Field     ;
                Name=StatementToRemAmtDifference;
                CaptionML=[DAN=Difference fra restbel›b;
                           ENU=Difference from Remaining Amount];
                ToolTipML=[DAN=Angiver differencen mellem v‘rdien i felterne Kontoudtogsbel›b i feltet Betalingsudligningskladde og v‘rdien i feltet Restbel›b efter bogf›ring i vinduet Betalingsudligning.;
                           ENU=Specifies the difference between the value in the Statement Amount in the Payment Reconciliation Journal field and the value in the Remaining Amount After Posting field in the Payment Application window.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=StatementToRemAmtDifference;
                Visible=FALSE;
                Enabled=FALSE }

    { 47  ;2   ;Field     ;
                Name=DescAppliedEntry;
                CaptionML=[DAN=Beskrivelse af afstemt post;
                           ENU=Applied Entry Description];
                ToolTipML=[DAN=Angiver beskrivelsen af den post, som betalingen er udlignet med.;
                           ENU=Specifies the description of the entry that the payment is applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliedPmtEntry.Description;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen p† bankens kontoudtog er blevet udlignet med en eller flere bank- eller checkposter.;
                           ENU=Specifies whether the transaction on the bank's statement has been applied to one or more bank account or check ledger entries.];
                ApplicationArea=#Advanced;
                SourceExpr="Applied Entries";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                Name=RemainingAmount;
                CaptionML=[DAN=Restbel›b efter bogf›ring;
                           ENU=Remaining Amount After Posting];
                ToolTipML=[DAN=Angiver det bel›b, der endnu ikke er betalt for den †bne post, efter du har bogf›rt betalingen i vinduet Betalingsudligningskladde.;
                           ENU=Specifies the amount that remains to be paid for the open entry, after you have posted the payment in the Payment Reconciliation Journal window.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=RemainingAmountAfterPosting;
                Visible=FALSE;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      BankAccReconciliation@1000 : Record 273;
      AppliedPmtEntry@1007 : Record 1294;
      PmtAppliedToTxt@1003 : TextConst '@@@=%1 - an integer number;DAN=Betalingen er afstemt med (%1) poster.;ENU=The payment has been applied to (%1) entries.';
      IsBankAccReconInitialized@1004 : Boolean;
      StatementToRemAmtDifference@1005 : Decimal;
      RemainingAmountAfterPosting@1006 : Decimal;

    BEGIN
    END.
  }
}

