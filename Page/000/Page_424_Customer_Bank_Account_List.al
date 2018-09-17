OBJECT Page 424 Customer Bank Account List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Debitors bankkontooversigt;
               ENU=Customer Bank Account List];
    SourceTable=Table287;
    DataCaptionFields=Customer No.;
    PageType=List;
    CardPageID=Customer Bank Account Card;
    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Direct Debit-betalingsaftaler;
                                 ENU=Direct Debit Mandates];
                      ToolTipML=[DAN=Se eller rediger den Direct Debit-betalingsaftale med debitorer om opkr‘vning af fakturabetalinger fra deres bankkonto.;
                                 ENU=View or edit direct-debit mandates that you set up to reflect agreements with customers to collect invoice payments from their bank account.];
                      ApplicationArea=#Suite;
                      RunObject=Page 1230;
                      RunPageLink=Customer No.=FIELD(Customer No.),
                                  Customer Bank Account Code=FIELD(Code);
                      Promoted=Yes;
                      Image=MakeAgreement;
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
                ToolTipML=[DAN=Angiver en kode til identifikation af debitorbankkonto.;
                           ENU=Specifies a code to identify this customer bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den bank, hvor debitoren har bankkontoen.;
                           ENU=Specifies the name of the bank where the customer has the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Advanced;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver telefonnummeret p† den bank, hvor debitoren har bankkontoen.;
                           ENU=Specifies the telephone number of the bank where the customer has the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 93  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det faxnummer, der er tilknyttet adressen.;
                           ENU=Specifies the fax number associated with the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Fax No.";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den person i banken, der som regel kontaktes i forbindelse med denne konto.;
                           ENU=Specifies the name of the bank employee regularly contacted in connection with this bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

    { 105 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den bankkonto, der benyttes af banken.;
                           ENU=Specifies the number used by the bank for the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver SWIFT-koden (internationalt bank-id) p† den bank, hvor debitoren har bankkontoen.;
                           ENU=Specifies the SWIFT code (international bank identifier code) of the bank where the customer has the account.];
                ApplicationArea=#Advanced;
                SourceExpr="SWIFT Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankkontoens internationale bankkontonummer.;
                           ENU=Specifies the bank account's international bank account number.];
                ApplicationArea=#Advanced;
                SourceExpr=IBAN;
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den relevante valutakode til bankkontoen.;
                           ENU=Specifies the relevant currency code for the bank account.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code";
                Visible=FALSE }

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

