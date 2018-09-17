OBJECT Page 111 Vendor Posting Groups
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kreditorbogf›ringsgrupper;
               ENU=Vendor Posting Groups];
    SourceTable=Table93;
    PageType=List;
    CardPageID=Vendor Posting Group Card;
    OnOpenPage=BEGIN
                 SetAccountVisibility(PmtToleranceVisible,PmtDiscountVisible,InvRoundingVisible,ApplnRoundingVisible);
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et id for produktbogf›ringsgruppen.;
                           ENU=Specifies an identifier for the vendor posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 3   ;2   ;Field     ;
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

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer servicegebyrer til kreditorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post service charges due to vendors in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Service Charge Acc." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer betalingsneds‘ttelser, som er modtaget fra kreditorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post reductions in payment discounts received from vendors in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Disc. Debit Acc.";
                Visible=PmtDiscountVisible }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer betalingsrabatter, som er modtaget fra kreditorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post payment discounts received from vendors in this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Disc. Credit Acc.";
                Visible=PmtDiscountVisible }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, du skal bruge, n†r du bogf›rer bel›b, der skyldes fakturaafrunding, n†r du bogf›rer kreditortransaktioner.;
                           ENU=Specifies the general ledger account to use when amounts result from invoice rounding when you post transactions that involve vendors.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoice Rounding Account";
                Visible=InvRoundingVisible }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, du skal bruge, n†r du bogf›rer afrundingsdifferencen. Disse forskelle kan forekomme, n†r du anvender poster i forskellige valutaer.;
                           ENU=Specifies the general ledger account to use when you post rounding differences. These differences can occur when you apply entries in different currencies to one another.];
                ApplicationArea=#Suite;
                SourceExpr="Debit Curr. Appln. Rndg. Acc.";
                Visible=ApplnRoundingVisible }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, du skal bruge, n†r du bogf›rer afrundingsdifferencen. Disse forskelle kan forekomme, n†r du anvender poster i forskellige valutaer.;
                           ENU=Specifies the general ledger account to use when you post rounding differences. These differences can occur when you apply entries in different currencies to one another.];
                ApplicationArea=#Suite;
                SourceExpr="Credit Curr. Appln. Rndg. Acc.";
                Visible=ApplnRoundingVisible }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer afrundingsdifferencer fra et restbel›b.;
                           ENU=Specifies the general ledger account number to use when you post rounding differences from a remaining amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Rounding Account" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer afrundingsdifferencer fra et restbel›b.;
                           ENU=Specifies the general ledger account number to use when you post rounding differences from a remaining amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Rounding Account" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, du skal bruge, n†r du bogf›rer k›bstolerancebel›b og betalinger for k›b, Dette g‘lder denne specielle kombination af virksomheds- og produktbogf›ringsgruppe.;
                           ENU=Specifies the general ledger account number to use when you post purchase tolerance amounts and payments for purchases. This applies to this particular combination of business posting group and product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Tolerance Debit Acc.";
                Visible=PmtToleranceVisible }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, du skal bruge, n†r du bogf›rer k›bstolerancebel›b og betalinger for k›b, Dette g‘lder denne specielle kombination af virksomheds- og produktbogf›ringsgruppe.;
                           ENU=Specifies the general ledger account number to use when you post purchase tolerance amounts and payments for purchases. This applies to this particular combination of business posting group and product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Tolerance Credit Acc.";
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
      PmtDiscountVisible@1003 : Boolean;
      PmtToleranceVisible@1002 : Boolean;
      InvRoundingVisible@1001 : Boolean;
      ApplnRoundingVisible@1000 : Boolean;

    BEGIN
    END.
  }
}

