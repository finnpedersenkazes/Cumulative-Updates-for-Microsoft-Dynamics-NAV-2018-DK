OBJECT Page 2190 O365 Invoicing Sales Doc. List
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Fakturaer;
               ENU=Invoices];
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table2103;
    SourceTableView=SORTING(Sell-to Customer Name);
    PageType=List;
    SourceTableTemporary=Yes;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Fakturer;
                                ENU=New,Process,Report,Invoice];
    OnInit=BEGIN
             SetSortByDocDate;
           END;

    OnFindRecord=BEGIN
                   EXIT(OnFind(Which));
                 END;

    OnNextRecord=BEGIN
                   EXIT(OnNext(Steps));
                 END;

    OnAfterGetRecord=BEGIN
                       OutStandingStatusStyle := '';
                       IF IsOverduePostedInvoice THEN
                         OutStandingStatusStyle := 'Unfavorable'
                       ELSE
                         IF Posted AND NOT Canceled AND ("Outstanding Amount" <= 0) THEN
                           OutStandingStatusStyle := 'Favorable';
                     END;

    ActionList=ACTIONS
    {
      { 16      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 20      ;1   ;Action    ;
                      Name=Open;
                      ShortCutKey=Return;
                      CaptionML=[DAN=�bn;
                                 ENU=Open];
                      ToolTipML=[DAN=�bn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=FALSE;
                      Image=DocumentEdit;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 OpenInvoice;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Sell-to Customer Name" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Document Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede fakturerede bel�b.;
                           ENU=Specifies the total invoiced amount.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Total Invoiced Amount";
                Style=Ambiguous;
                StyleExpr=NOT Posted }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udest�ende bel�b, dvs. det bel�b, der ikke er betalt.;
                           ENU=Specifies the outstanding amount, meaning the amount not paid.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Outstanding Status";
                StyleExpr=OutStandingStatusStyle }

  }
  CODE
  {
    VAR
      OutStandingStatusStyle@1000 : Text[30];

    BEGIN
    END.
  }
}

