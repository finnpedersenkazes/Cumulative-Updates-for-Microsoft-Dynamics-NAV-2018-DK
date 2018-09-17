OBJECT Page 2118 O365 Payment History List
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
    SourceTable=Table2105;
    PageType=List;
    SourceTableTemporary=Yes;
    RefreshOnActivate=Yes;
    ShowFilter=No;
    OnFindRecord=BEGIN
                   IF OldO365PaymentHistoryBuffer."Ledger Entry No." <> 0 THEN
                     Rec := OldO365PaymentHistoryBuffer;
                   EXIT(FIND(Which));
                 END;

    OnNextRecord=BEGIN
                   IF OldO365PaymentHistoryBuffer."Ledger Entry No." <> 0 THEN
                     Rec := OldO365PaymentHistoryBuffer;
                   EXIT(NEXT(Steps));
                 END;

    OnAfterGetRecord=BEGIN
                       OldO365PaymentHistoryBuffer := Rec;
                       IF Type = Type::Payment THEN
                         AmountStyleExpr := 'Favorable'
                       ELSE BEGIN
                         AmountStyleExpr := 'Strong';
                         "Payment Method" := ''; // Affects FIND/NEXT if user sorted on this column
                       END;
                     END;

    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Action    ;
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
                      Visible=False;
                      Image=DocumentEdit;
                      OnAction=BEGIN
                                 PAGE.RUNMODAL(PAGE::"O365 Payment History Card",Rec);
                                 FillPaymentHistory(SalesInvoiceDocNo,TRUE);
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

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverf›rsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Payment Method" }

  }
  CODE
  {
    VAR
      OldO365PaymentHistoryBuffer@1002 : Record 2105;
      SalesInvoiceDocNo@1001 : Code[20];
      ARecordHasBeenDeleted@1004 : Boolean;
      AmountStyleExpr@1000 : Text;

    [External]
    PROCEDURE ShowHistory@1(SalesInvoiceDocumentNo@1000 : Code[20]);
    BEGIN
      SalesInvoiceDocNo := SalesInvoiceDocumentNo;
      FillPaymentHistory(SalesInvoiceDocumentNo,TRUE);
    END;

    LOCAL PROCEDURE MarkPaymentAsUnpaid@2();
    BEGIN
      IF CancelPayment THEN BEGIN
        FillPaymentHistory(SalesInvoiceDocNo,TRUE);
        ARecordHasBeenDeleted := TRUE;
      END
    END;

    PROCEDURE RecordDeleted@3() : Boolean;
    BEGIN
      EXIT(ARecordHasBeenDeleted);
    END;

    BEGIN
    END.
  }
}

