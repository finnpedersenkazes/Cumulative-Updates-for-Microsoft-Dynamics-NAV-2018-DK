OBJECT Page 149 Vendor Posting Group Card
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kreditorbogf›ringsgruppekort;
               ENU=Vendor Posting Group Card];
    SourceTable=Table93;
    PageType=Card;
    OnOpenPage=BEGIN
                 SetAccountVisibility(PmtToleranceVisible,PmtDiscountVisible,InvRoundingVisible,ApplnRoundingVisible);
               END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et id for kreditorbogf›ringsgruppen.;
                           ENU=Specifies an identifier for the vendor posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af kreditorbogf›ringsgruppen.;
                           ENU=Specifies the description for the vendor posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer betalinger til kreditorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post payables due to vendors in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payables Account";
                ShowMandatory=TRUE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer servicegebyrer til kreditorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post service charges due to vendors in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Service Charge Acc.";
                Importance=Additional }

    { 8   ;2   ;Group     ;
                Name=Discounts;
                GroupType=Group }

    { 9   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer betalingsneds‘ttelser, som er modtaget fra kreditorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post reductions in payment discounts received from vendors in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Disc. Debit Acc.";
                Importance=Additional;
                Visible=PmtDiscountVisible }

    { 10  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer betalingsrabatter, som er modtaget fra kreditorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post payment discounts received from vendors in this posting group.];
                OptionCaptionML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer betalingsrabatter, som er modtaget fra kreditorer i denne bogf›ringsgruppe.;
                                 ENU=Specifies the general ledger account to use when you post payment discounts received from vendors in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Disc. Credit Acc.";
                Importance=Additional;
                Visible=PmtDiscountVisible }

    { 11  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, du skal bruge, n†r du bogf›rer k›bstolerancebel›b og betalinger for k›b, Dette g‘lder denne specielle kombination af virksomheds- og produktbogf›ringsgruppe.;
                           ENU=Specifies the general ledger account number to use when you post purchase tolerance amounts and payments for purchases. This applies to this particular combination of business posting group and product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Tolerance Debit Acc.";
                Importance=Additional;
                Visible=PmtToleranceVisible }

    { 12  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, du skal bruge, n†r du bogf›rer k›bstolerancebel›b og betalinger for k›b, Dette g‘lder denne specielle kombination af virksomheds- og produktbogf›ringsgruppe.;
                           ENU=Specifies the general ledger account number to use when you post purchase tolerance amounts and payments for purchases. This applies to this particular combination of business posting group and product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Tolerance Credit Acc.";
                Importance=Additional;
                Visible=PmtToleranceVisible }

    { 13  ;2   ;Group     ;
                Name=Rounding;
                GroupType=Group }

    { 14  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, du skal bruge, n†r du bogf›rer bel›b, der skyldes fakturaafrunding, n†r du bogf›rer kreditortransaktioner.;
                           ENU=Specifies the general ledger account to use when amounts result from invoice rounding when you post transactions that involve vendors.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoice Rounding Account";
                Importance=Additional;
                Visible=InvRoundingVisible }

    { 15  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer afrundingsdifferencer fra et restbel›b.;
                           ENU=Specifies the general ledger account number to use when you post rounding differences from a remaining amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Rounding Account";
                Importance=Additional }

    { 16  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer afrundingsdifferencer fra et restbel›b.;
                           ENU=Specifies the general ledger account number to use when you post rounding differences from a remaining amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Rounding Account";
                Importance=Additional }

    { 17  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, du skal bruge, n†r du bogf›rer afrundingsdifferencen. Disse forskelle kan forekomme, n†r du anvender poster i forskellige valutaer.;
                           ENU=Specifies the general ledger account to use when you post rounding differences. These differences can occur when you apply entries in different currencies to one another.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Curr. Appln. Rndg. Acc.";
                Importance=Additional;
                Visible=ApplnRoundingVisible }

    { 18  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, du skal bruge, n†r du bogf›rer afrundingsdifferencen. Disse forskelle kan forekomme, n†r du anvender poster i forskellige valutaer.;
                           ENU=Specifies the general ledger account to use when you post rounding differences. These differences can occur when you apply entries in different currencies to one another.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Curr. Appln. Rndg. Acc.";
                Importance=Additional;
                Visible=ApplnRoundingVisible }

  }
  CODE
  {
    VAR
      PmtDiscountVisible@1003 : Boolean;
      PmtToleranceVisible@1002 : Boolean;
      InvRoundingVisible@1001 : Boolean;
      ApplnRoundingVisible@1000 : Boolean;

    BEGIN
    END.
  }
}

