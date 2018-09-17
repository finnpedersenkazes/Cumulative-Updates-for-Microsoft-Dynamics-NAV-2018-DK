OBJECT Page 148 Customer Posting Group Card
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debitorbogf›ringsgruppekort;
               ENU=Customer Posting Group Card];
    SourceTable=Table92;
    PageType=Card;
    OnOpenPage=VAR
                 ReminderTerms@1000 : Record 292;
               BEGIN
                 SetAccountVisibility(PmtToleranceVisible,PmtDiscountVisible,InvRoundingVisible,ApplnRoundingVisible);
                 ReminderTerms.SetAccountVisibility(InterestAccountVisible,AddFeeAccountVisible,AddFeePerLineAccountVisible);
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
                ToolTipML=[DAN=Angiver id'et for debitorbogf›ringsgruppen. Dette er, hvad du v‘lger, n†r du tildeler gruppen til en enhed eller et dokument.;
                           ENU=Specifies the identifier for the customer posting group. This is what you choose when you assign the group to an entity or document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af debitorbogf›ringsgruppen.;
                           ENU=Specifies the description for the customer posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer tilgodehavender fra debitorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post receivables from customers in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Receivables Account";
                ShowMandatory=TRUE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer servicegebyrer fra debitorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post service charges for customers in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Service Charge Acc.";
                Importance=Additional }

    { 16  ;2   ;Group     ;
                Name=Discounts;
                GroupType=Group }

    { 9   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer kontantrabatter, som er tildelt debitorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post payment discounts granted to customers in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Disc. Debit Acc.";
                Importance=Additional;
                Visible=PmtDiscountVisible }

    { 10  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer betalingsneds‘ttelser, som er tildelt debitorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post reductions in payment discounts granted to customers in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Disc. Credit Acc.";
                Importance=Additional;
                Visible=PmtDiscountVisible }

    { 11  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, du skal bruge, n†r du bogf›rer betalingstolerance og betalinger for salg. Dette g‘lder denne s‘rlige kombination af virksomheds- og produktbogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post payment tolerance and payments for sales. This applies to this particular combination of business group and product group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Tolerance Debit Acc.";
                Importance=Additional;
                Visible=PmtToleranceVisible }

    { 12  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, du skal bruge, n†r du bogf›rer betalingstolerance og betalinger for salg. Dette g‘lder denne s‘rlige kombination af virksomheds- og produktbogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post payment tolerance and payments for sales. This applies to this particular combination of business group and product group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Tolerance Credit Acc.";
                Importance=Additional;
                Visible=PmtToleranceVisible }

    { 17  ;2   ;Group     ;
                Name=Rounding;
                GroupType=Group }

    { 20  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, du skal bruge, n†r du bogf›rer bel›b, der skyldes fakturaafrunding, n†r du bogf›rer debitortransaktioner.;
                           ENU=Specifies the general ledger account to use when you post amounts that result from invoice rounding when you post transactions for customers.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoice Rounding Account";
                Importance=Additional;
                Visible=InvRoundingVisible }

    { 21  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, du skal bruge, n†r du bogf›rer afrundingsdifferencer fra et restbel›b.;
                           ENU=Specifies the general ledger account to use when you post rounding differences from a remaining amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Rounding Account";
                Importance=Additional }

    { 22  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, du skal bruge, n†r du bogf›rer afrundingsdifferencer fra et restbel›b.;
                           ENU=Specifies the general ledger account to use when you post rounding differences from a remaining amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Rounding Account";
                Importance=Additional }

    { 23  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, du skal bruge, n†r du bogf›rer afrundingsdifferencen. Disse forskelle kan forekomme, n†r du anvender poster i forskellige valutaer.;
                           ENU=Specifies the general ledger account to use when you post rounding differences. These differences can occur when you apply entries in different currencies to one another.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Curr. Appln. Rndg. Acc.";
                Importance=Additional;
                Visible=ApplnRoundingVisible }

    { 24  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, du skal bruge, n†r du bogf›rer afrundingsdifferencen. Disse forskelle kan forekomme, n†r du anvender poster i forskellige valutaer.;
                           ENU=Specifies the general ledger account to use when you post rounding differences. These differences can occur when you apply entries in different currencies to one another.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Curr. Appln. Rndg. Acc.";
                Importance=Additional;
                Visible=ApplnRoundingVisible }

    { 19  ;2   ;Group     ;
                Name=Reminders;
                GroupType=Group }

    { 15  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer renter fra rykkere og rentenotaer for debitorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post interest from reminders and finance charge memos for customers in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Interest Account";
                Importance=Additional;
                Visible=InterestAccountVisible }

    { 13  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer yderligere gebyrer fra rykkere og rentenotaer for debitorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post additional fees from reminders and finance charge memos for customers in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Additional Fee Account";
                Importance=Additional;
                Visible=AddFeeAccountVisible }

    { 8   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, der skal bruges til ekstra gebyrer.;
                           ENU=Specifies the general ledger account that additional fees are posted to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Add. Fee per Line Account";
                Importance=Additional;
                Visible=AddFeePerLineAccountVisible }

  }
  CODE
  {
    VAR
      PmtDiscountVisible@1002 : Boolean;
      PmtToleranceVisible@1001 : Boolean;
      InvRoundingVisible@1000 : Boolean;
      ApplnRoundingVisible@1003 : Boolean;
      InterestAccountVisible@1004 : Boolean;
      AddFeeAccountVisible@1005 : Boolean;
      AddFeePerLineAccountVisible@1006 : Boolean;

    BEGIN
    END.
  }
}

