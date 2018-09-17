OBJECT Page 2119 O365 Payment History ListPart
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
    CaptionML=[DAN=Betalingshistorik;
               ENU=Payment History];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table2105;
    PageType=ListPart;
    SourceTableTemporary=Yes;
    ShowFilter=No;
    OnAfterGetRecord=BEGIN
                       IF Type = Type::Payment THEN
                         AmountStyleExpr := 'Favorable'
                       ELSE BEGIN
                         AmountStyleExpr := 'Strong';
                         "Payment Method" := '';
                       END;
                     END;

    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 8       ;1   ;Action    ;
                      Name=MarkAsUnpaid;
                      CaptionML=[DAN=Annuller betalingsregistrering;
                                 ENU=Cancel payment registration];
                      ToolTipML=[DAN=Annuller denne betalingsregistrering.;
                                 ENU=Cancel this payment registration.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 MarkPaymentAsUnpaid;
                               END;

                      Gesture=RightSwipe }
      { 9       ;1   ;Action    ;
                      Name=Open;
                      ShortCutKey=Return;
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=FALSE;
                      Image=DocumentEdit;
                      OnAction=BEGIN
                                 PAGE.RUN(PAGE::"O365 Payment History Card",Rec);
                                 FillPaymentHistory(SalesInvoiceDocNo,FALSE);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for posten.;
                           ENU=Specifies the type of the entry.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Type }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den modtagne betaling.;
                           ENU=Specifies the payment received.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Amount;
                StyleExpr=AmountStyleExpr }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor betalingen er modtaget.;
                           ENU=Specifies the date the payment is received.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Date Received" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverf›rsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Payment Method" }

  }
  CODE
  {
    VAR
      SalesInvoiceDocNo@1000 : Code[20];
      AmountStyleExpr@1001 : Text;

    PROCEDURE ShowHistory@1(SalesInvoiceDocumentNo@1000 : Code[20]) : Boolean;
    BEGIN
      SalesInvoiceDocNo := SalesInvoiceDocumentNo;
      FillPaymentHistory(SalesInvoiceDocumentNo,FALSE);
      EXIT(NOT ISEMPTY)
    END;

    LOCAL PROCEDURE MarkPaymentAsUnpaid@2();
    BEGIN
      IF CancelPayment THEN
        FillPaymentHistory(SalesInvoiceDocNo,FALSE);
    END;

    BEGIN
    END.
  }
}

