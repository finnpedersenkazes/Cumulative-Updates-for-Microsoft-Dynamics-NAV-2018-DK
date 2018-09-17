OBJECT Page 173 Standard Customer Sales Codes
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Tilbagevendende salgslinjer;
               ENU=Recurring Sales Lines];
    SourceTable=Table172;
    DataCaptionFields=Customer No.;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Salg;
                                 ENU=&Sales];
                      Image=Sales }
      { 13      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Suite;
                      RunObject=Page 170;
                      RunPageLink=Code=FIELD(Code);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=EditLines;
                      PromotedCategory=Process;
                      Scope=Repeater }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitornummeret p† den debitor, som standardsalgskoden er tildelt.;
                           ENU=Specifies the customer number of the customer to which the standard sales code is assigned.];
                ApplicationArea=#Advanced;
                SourceExpr="Customer No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en standardsalgskode fra tabellen Standardsalgskode.;
                           ENU=Specifies a standard sales code from the Standard Sales Code table.];
                ApplicationArea=#Suite;
                SourceExpr=Code }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af standardsalgskoden.;
                           ENU=Specifies a description of the standard sales code.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den f›rste dag, hvor k›rslen Opret tilbagevendende salgsfaktura kan bruges til at oprette salgsfakturaer.;
                           ENU=Specifies the first day when the Create Recurring Sales Inv. batch job can be used to create sales invoices.];
                ApplicationArea=#Advanced;
                SourceExpr="Valid From Date" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den sidste dag, hvor k›rslen Opret tilbagevendende salgsfaktura kan bruges til at oprette salgsfakturaer.;
                           ENU=Specifies the last day when the Create Recurring Sales Inv. batch job can be used to create sales invoices.];
                ApplicationArea=#Advanced;
                SourceExpr="Valid To date" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverf›rsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Method Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Terms Code" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den Direct Debit-betalingsaftale, som denne standarddebitorsalgskode bruger til at oprette salgsfakturaer for Direct Debit-opkr‘vning.;
                           ENU=Specifies the ID of the direct-debit mandate that this standard customer sales code uses to create sales invoices for direct debit collection.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Debit Mandate ID" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Advanced;
                SourceExpr=Blocked }

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

    [External]
    PROCEDURE GetSelected@3(VAR StdCustSalesCode@1000 : Record 172);
    BEGIN
      CurrPage.SETSELECTIONFILTER(StdCustSalesCode);
    END;

    BEGIN
    END.
  }
}

