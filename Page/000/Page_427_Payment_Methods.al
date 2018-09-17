OBJECT Page 427 Payment Methods
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Betalingsformer;
               ENU=Payment Methods];
    SourceTable=Table289;
    PageType=List;
    ActionList=ACTIONS
    {
      { 11      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=Ove&rs‘ttelse;
                                 ENU=T&ranslation];
                      ToolTipML=[DAN=F† vist eller rediger beskrivelser til hver betalingsmetode p† forskellige sprog.;
                                 ENU=View or edit descriptions for each payment method in different languages.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 758;
                      RunPageLink=Payment Method Code=FIELD(Code);
                      Promoted=Yes;
                      Image=Translation;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode til identifikation af betalingsmetoden.;
                           ENU=Specifies a code to identify this payment method.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af betalingsmetoden.;
                           ENU=Specifies a text that describes the payment method.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf›res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf›res til, f.eks. en kassekonto ved kontantk›b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account No." }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om betalingsmetoden bruges til Direct Debit-opkr‘vninger.;
                           ENU=Specifies if the payment method is used for direct debit collection.];
                ApplicationArea=#Suite;
                SourceExpr="Direct Debit" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de betalingsbetingelser, der bruges, n†r betalingsmetoden bruges til Direct Debit-opkr‘vning.;
                           ENU=Specifies the payment terms that will be used when the payment method is used for direct debit collection.];
                ApplicationArea=#Suite;
                SourceExpr="Direct Debit Pmt. Terms Code" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dataudvekslingsdefinitionen i dataudvekslingsstrukturen, der bruges til at eksportere betalinger.;
                           ENU=Specifies the data exchange definition in the Data Exchange Framework that is used to export payments.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Export Line Definition" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den betalingstype, der er p†kr‘vet af tjenesten til konvertering af bankdata, n†r du eksporterer betalinger med den valgte betalingsmetode.;
                           ENU=Specifies the payment type as required by the bank data conversion service when you export payments with the selected payment method.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Data Conversion Pmt. Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om betalingsvilk†rene bruges til faktureringsprogrammet.;
                           ENU=Specifies whether or not payment term is used for Invoicing app.];
                ApplicationArea=#Invoicing;
                SourceExpr="Use for Invoicing" }

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

    BEGIN
    END.
  }
}

