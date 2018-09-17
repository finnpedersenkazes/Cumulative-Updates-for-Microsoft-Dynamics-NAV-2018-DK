OBJECT Page 110 Customer Posting Groups
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debitorbogf�ringsgrupper;
               ENU=Customer Posting Groups];
    SourceTable=Table92;
    PageType=List;
    CardPageID=Customer Posting Group Card;
    OnOpenPage=VAR
                 ReminderTerms@1000 : Record 292;
               BEGIN
                 SetAccountVisibility(PmtToleranceVisible,PmtDiscountVisible,InvRoundingVisible,ApplnRoundingVisible);
                 ReminderTerms.SetAccountVisibility(InterestAccountVisible,AddFeeAccountVisible,AddFeePerLineAccountVisible);
                 UpdateAccountVisibilityBasedOnFinChargeTerms(InterestAccountVisible,AddFeeAccountVisible);
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for kundebogf�ringsgruppen. Dette er, hvad du v�lger, n�r du tildeler gruppen til en enhed eller et dokument.;
                           ENU=Specifies the identifier for the customer posting group. This is what you choose when you assign the group to an entity or document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af debitorbogf�ringsgruppen.;
                           ENU=Specifies the description for the customer posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� finanskontoen, du skal bruge, n�r du bogf�rer tilgodehavender fra debitorer i denne bogf�ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post receivables from customers in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Receivables Account";
                ShowMandatory=TRUE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� finanskontoen, du skal bruge, n�r du bogf�rer servicegebyrer fra debitorer i denne bogf�ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post service charges for customers in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Service Charge Acc.";
                Importance=Additional }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� finanskontoen, du skal bruge, n�r du bogf�rer kontantrabatter, som er tildelt debitorer i denne bogf�ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post payment discounts granted to customers in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Disc. Debit Acc.";
                Importance=Additional;
                Visible=PmtDiscountVisible }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� finanskontoen, du skal bruge, n�r du bogf�rer betalingsneds�ttelser, som er tildelt debitorer i denne bogf�ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post reductions in payment discounts granted to customers in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Disc. Credit Acc.";
                Importance=Additional;
                Visible=PmtDiscountVisible }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� finanskontoen, du skal bruge, n�r du bogf�rer renter fra rykkere og rentenotaer for debitorer i denne bogf�ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post interest from reminders and finance charge memos for customers in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Interest Account";
                Importance=Additional;
                Visible=InterestAccountVisible }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� finanskontoen, du skal bruge, n�r du bogf�rer yderligere gebyrer fra rykkere og rentenotaer for debitorer i denne bogf�ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post additional fees from reminders and finance charge memos for customers in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Additional Fee Account";
                Importance=Additional;
                Visible=AddFeeAccountVisible }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, der skal bruges til ekstra gebyrer.;
                           ENU=Specifies the general ledger account that additional fees are posted to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Add. Fee per Line Account";
                Importance=Additional;
                Visible=AddFeePerLineAccountVisible }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, du skal bruge, n�r du bogf�rer bel�b, der skyldes fakturaafrunding, n�r du bogf�rer debitortransaktioner.;
                           ENU=Specifies the general ledger account to use when you post amounts that result from invoice rounding when you post transactions for customers.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoice Rounding Account";
                Importance=Additional;
                Visible=InvRoundingVisible }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den finanskonto, du skal bruge, n�r du bogf�rer afrundingsdifferencen. Disse forskelle kan forekomme, n�r du anvender poster i forskellige valutaer.;
                           ENU=Specifies the general ledger account to use when you post rounding differences. These differences can occur when you apply entries in different currencies to one another.];
                ApplicationArea=#Suite;
                SourceExpr="Debit Curr. Appln. Rndg. Acc.";
                Importance=Additional;
                Visible=ApplnRoundingVisible }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den finanskonto, du skal bruge, n�r du bogf�rer afrundingsdifferencen. Disse forskelle kan forekomme, n�r du anvender poster i forskellige valutaer.;
                           ENU=Specifies the general ledger account to use when you post rounding differences. These differences can occur when you apply entries in different currencies to one another.];
                ApplicationArea=#Suite;
                SourceExpr="Credit Curr. Appln. Rndg. Acc.";
                Importance=Additional;
                Visible=ApplnRoundingVisible }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, du skal bruge, n�r du bogf�rer afrundingsdifferencer fra et restbel�b.;
                           ENU=Specifies the general ledger account to use when you post rounding differences from a remaining amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Rounding Account";
                Importance=Additional }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, du skal bruge, n�r du bogf�rer afrundingsdifferencer fra et restbel�b.;
                           ENU=Specifies the general ledger account to use when you post rounding differences from a remaining amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Rounding Account";
                Importance=Additional }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den finanskonto, du skal bruge, n�r du bogf�rer betalingstolerance og betalinger for salg. Dette g�lder denne s�rlige kombination af virksomheds- og produktbogf�ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post payment tolerance and payments for sales. This applies to this particular combination of business group and product group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Tolerance Debit Acc.";
                Importance=Additional;
                Visible=PmtToleranceVisible }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den finanskonto, du skal bruge, n�r du bogf�rer betalingstolerance og betalinger for salg. Dette g�lder denne s�rlige kombination af virksomheds- og produktbogf�ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post payment tolerance and payments for sales. This applies to this particular combination of business group and product group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Tolerance Credit Acc.";
                Importance=Additional;
                Visible=PmtToleranceVisible }

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
      PmtDiscountVisible@1005 : Boolean;
      PmtToleranceVisible@1001 : Boolean;
      InvRoundingVisible@1002 : Boolean;
      ApplnRoundingVisible@1003 : Boolean;
      InterestAccountVisible@1004 : Boolean;
      AddFeeAccountVisible@1000 : Boolean;
      AddFeePerLineAccountVisible@1006 : Boolean;

    LOCAL PROCEDURE UpdateAccountVisibilityBasedOnFinChargeTerms@1(VAR InterestAccountVisible@1000 : Boolean;VAR AddFeeAccountVisible@1001 : Boolean);
    VAR
      FinanceChargeTerms@1002 : Record 5;
    BEGIN
      FinanceChargeTerms.SETRANGE("Post Interest",TRUE);
      InterestAccountVisible := InterestAccountVisible OR NOT FinanceChargeTerms.ISEMPTY;

      FinanceChargeTerms.SETRANGE("Post Interest");
      FinanceChargeTerms.SETRANGE("Post Additional Fee",TRUE);
      AddFeeAccountVisible := AddFeeAccountVisible OR NOT FinanceChargeTerms.ISEMPTY;
    END;

    BEGIN
    END.
  }
}

