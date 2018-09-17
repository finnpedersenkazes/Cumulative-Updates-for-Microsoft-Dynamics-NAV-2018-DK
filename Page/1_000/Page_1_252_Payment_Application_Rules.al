OBJECT Page 1252 Payment Application Rules
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Regler for betalingsudligning;
               ENU=Payment Application Rules];
    SourceTable=Table1252;
    DelayedInsert=Yes;
    PageType=List;
    OnOpenPage=BEGIN
                 SETCURRENTKEY(Score);
                 ASCENDING(FALSE);
               END;

    ActionList=ACTIONS
    {
      { 8       ;    ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 9       ;1   ;Action    ;
                      Name=RestoreDefaultRules;
                      CaptionML=[DAN=Gendan standardregler;
                                 ENU=Restore Default Rules];
                      ToolTipML=[DAN=Slet udligningsreglerne og erstat dem med standardreglerne, som bestemmer, om betalinger udlignes automatisk med †bne finansposter.;
                                 ENU=Delete the application rules and replace them with the default rules, which control whether payments are automatically applied to open ledger entries.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Restore;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF NOT CONFIRM(ResetToDefaultsQst) THEN
                                   EXIT;

                                 DELETEALL;
                                 InsertDefaultMatchingRules;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Rules;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver din tillid til den udligningsregel, som du har defineret med v‘rdierne i felterne Relateret part er matchet, Bilagsnr./Eksternt bilagsnr. er matchet og Matchende bel›b inkl. tolerance p† linjen i vinduet Regler for betalingsudligning.;
                           ENU=Specifies your confidence in the application rule that you defined by the values in the Related Party Matched, Doc. No./Ext. Doc. No. Matched, and Amount Incl. Tolerance Matched fields on the line in the Payment Application Rules window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Match Confidence" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prioriteten for udligningsreglen i relation til andre udligningsregler, der er defineret som linjer i vinduet Regler for betalingsudligning. "1" repr‘senterer den h›jeste prioritet.;
                           ENU=Specifies the priority of the application rule in relation to other application rules that are defined as lines in the Payment Application Rules window. 1 represents the highest priority.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Priority }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange oplysninger p† betalingsudligningskladdelinjen der skal stemme overens med den †bne post, f›r udligningsreglen udligner betalingen med den †bne post.;
                           ENU=Specifies how much information on the payment reconciliation journal line must match the open entry before the application rule will apply the payment to the open entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Related Party Matched" }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Bilagsnr./Eksternt bilagsnr. er matchet;
                           ENU=Document No./Ext. Document No. Matched];
                ToolTipML=[DAN=Angiver, om teksten p† betalingsudligningskladde skal stemme overens med v‘rdien i feltet Bilagsnr. eller Eksternt bilagsnr. p† den †bne post, f›r udligningsreglen udligner betalingen med den †bne post.;
                           ENU=Specifies if text on the payment reconciliation journal line must match with the value in the Document No. field or the External Document No. field on the open entry before the application rule will be used to automatically apply the payment to the open entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Doc. No./Ext. Doc. No. Matched" }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Antal fundne poster inden for tolerancebel›b;
                           ENU=Number of Entries Within Amount Tolerance Found];
                ToolTipML=[DAN=Angiver, hvor mange poster der skal stemme overens med bel›bet, herunder betalingstolerancen, f›r udligningsreglen anvendes til at udligne en betaling med den †bne post.;
                           ENU=Specifies how many entries must match the amount including payment tolerance, before the application rule will be used to apply a payment to the open entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Incl. Tolerance Matched" }

  }
  CODE
  {
    VAR
      ResetToDefaultsQst@1000 : TextConst 'DAN=Alle de aktuelle regler for betalingsudligning slettes og erstattes af standardreglerne for betalingsudligning.\\Vil du forts‘tte?;ENU=All current payment application rules will be deleted and replaced with the default payment application rules.\\Do you want to continue?';

    BEGIN
    END.
  }
}

