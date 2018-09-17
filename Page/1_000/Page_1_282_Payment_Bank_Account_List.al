OBJECT Page 1282 Payment Bank Account List
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
    CaptionML=[DAN=Betalingsbankkontooversigt;
               ENU=Payment Bank Account List];
    SourceTable=Table270;
    PageType=List;
    CardPageID=Payment Bank Account Card;
    OnAfterGetRecord=BEGIN
                       Linked := IsLinkedToBankStatementServiceProvider;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           Linked := IsLinkedToBankStatementServiceProvider;
                         END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† din bank.;
                           ENU=Specifies the name of the bank where you have the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den relevante valutakode til bankkontoen.;
                           ENU=Specifies the relevant currency code for the bank account.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankkontoens aktuelle saldo i den relevante udenlandske valuta.;
                           ENU=Specifies the bank account's current balance denominated in the applicable foreign currency.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Balance }

    { 6   ;2   ;Field     ;
                Name=Linked;
                CaptionML=[DAN=Tilknyttet;
                           ENU=Linked];
                ToolTipML=[DAN=Angiver, at bankkontoen er tilknyttet dens relaterede online bankkonto.;
                           ENU=Specifies that the bank account is linked to its related online bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Linked }

  }
  CODE
  {
    VAR
      Linked@1000 : Boolean;

    BEGIN
    END.
  }
}

