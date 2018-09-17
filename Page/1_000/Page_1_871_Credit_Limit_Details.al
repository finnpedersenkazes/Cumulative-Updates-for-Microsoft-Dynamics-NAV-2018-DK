OBJECT Page 1871 Credit Limit Details
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Detaljer;
               ENU=Details];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table18;
    PageType=CardPart;
    OnOpenPage=BEGIN
                 IF GETFILTER("Date Filter") = '' THEN
                   SETFILTER("Date Filter",'..%1',WORKDATE);
                 CALCFIELDS("Balance (LCY)","Shipped Not Invoiced (LCY)","Serv Shipped Not Invoiced(LCY)");
               END;

  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 11  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Editable=FALSE }

    { 10  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens navn.;
                           ENU=Specifies the customer's name.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Editable=FALSE }

    { 2   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver det betalingsbel›b, som debitoren skylder for afsluttede salg. V‘rdien kaldes ogs† debitorsaldo.;
                           ENU=Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer's balance.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance (LCY)";
                OnDrillDown=BEGIN
                              OpenCustomerLedgerEntries(FALSE);
                            END;
                             }

    { 9   ;1   ;Field     ;
                Name=OutstandingAmtLCY;
                CaptionML=[DAN=Udest†ende bel›b (RV);
                           ENU=Outstanding Amt. (LCY)];
                ToolTipML=[DAN=Angiver bel›bet for salg til debitoren, som mangler at blive leveret. Bel›bet beregnes som Bel›b x Udest†ende antal/antal.;
                           ENU=Specifies the amount on sales to the customer that remains to be shipped. The amount is calculated as Amount x Outstanding Quantity / Quantity.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=OrderAmountTotalLCY;
                AutoFormatType=1;
                Editable=FALSE }

    { 8   ;1   ;Field     ;
                CaptionML=[DAN=Lev./Ret. modt. ufakt. (RV);
                           ENU=Shipped/Ret. Rcd. Not Invd. (LCY)];
                ToolTipML=[DAN=Angiver bel›bet for salgsreturneringer fra debitoren, som endnu ikke er refunderet;
                           ENU=Specifies the amount on sales returns from the customer that are not yet refunded];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShippedRetRcdNotIndLCY;
                Editable=FALSE }

    { 7   ;1   ;Field     ;
                CaptionML=[DAN=Aktuelt bel›b (RV);
                           ENU=Current Amount (LCY)];
                ToolTipML=[DAN=Angiver det totale bel›b for hele salgsdokumentet.;
                           ENU=Specifies the total amount the whole sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=OrderAmountThisOrderLCY;
                AutoFormatType=1;
                Editable=FALSE }

    { 6   ;1   ;Field     ;
                Name=TotalAmountLCY;
                CaptionML=[DAN=I alt (RV);
                           ENU=Total Amount (LCY)];
                ToolTipML=[DAN=Angiver summen af bel›bene i alle de ovenst†ende felter i vinduet.;
                           ENU=Specifies the sum of the amounts in all of the preceding fields in the window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CustCreditAmountLCY;
                AutoFormatType=1;
                Editable=FALSE }

    { 5   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver det maksimale bel›b, som du tillader, at debitoren overskrider betalingssaldoen med, f›r der udstedes advarsler.;
                           ENU=Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Limit (LCY)";
                Editable=FALSE }

    { 3   ;1   ;Field     ;
                Name=OverdueBalance;
                ToolTipML=[DAN=Angiver betalinger fra debitoren, der er forfaldne pr. dags dato.;
                           ENU=Specifies payments from the customer that are overdue per today's date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CalcOverdueBalance;
                CaptionClass=FORMAT(STRSUBSTNO(OverdueAmountsTxt,FORMAT(GETRANGEMAX("Date Filter"))));
                Editable=FALSE;
                OnDrillDown=VAR
                              DtldCustLedgEntry@1001 : Record 379;
                              CustLedgEntry@1000 : Record 21;
                            BEGIN
                              DtldCustLedgEntry.SETFILTER("Customer No.","No.");
                              COPYFILTER("Global Dimension 1 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 1");
                              COPYFILTER("Global Dimension 2 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 2");
                              COPYFILTER("Currency Filter",DtldCustLedgEntry."Currency Code");
                              CustLedgEntry.DrillDownOnOverdueEntries(DtldCustLedgEntry);
                            END;
                             }

    { 4   ;1   ;Field     ;
                CaptionML=[DAN=Faktureret forudbetalingsbel›b (RV);
                           ENU=Invoiced Prepayment Amount (LCY)];
                ToolTipML=[DAN=Angiver dine salgsindt‘gter fra debitoren baseret p† fakturerede forudbetalinger.;
                           ENU=Specifies your sales income from the customer based on invoiced prepayments.];
                ApplicationArea=#Prepayments;
                SourceExpr=GetInvoicedPrepmtAmountLCY;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      OrderAmountTotalLCY@1000 : Decimal;
      ShippedRetRcdNotIndLCY@1001 : Decimal;
      OrderAmountThisOrderLCY@1002 : Decimal;
      CustCreditAmountLCY@1003 : Decimal;
      OverdueAmountsTxt@1005 : TextConst '@@@="%1=Date on which the amounts arebeing calculated.";DAN=Forfaldne bel›b (RV) pr. %1;ENU=Overdue Amounts (LCY) as of %1';

    [External]
    PROCEDURE PopulateDataOnNotification@25(VAR CreditLimitNotification@1000 : Notification);
    BEGIN
      CreditLimitNotification.SETDATA(FIELDNAME("No."),FORMAT("No."));
      CreditLimitNotification.SETDATA('OrderAmountTotalLCY',FORMAT(OrderAmountTotalLCY));
      CreditLimitNotification.SETDATA('ShippedRetRcdNotIndLCY',FORMAT(ShippedRetRcdNotIndLCY));
      CreditLimitNotification.SETDATA('OrderAmountThisOrderLCY',FORMAT(OrderAmountThisOrderLCY));
      CreditLimitNotification.SETDATA('CustCreditAmountLCY',FORMAT(CustCreditAmountLCY));
    END;

    [External]
    PROCEDURE InitializeFromNotificationVar@7(CreditLimitNotification@1000 : Notification);
    VAR
      Customer@1001 : Record 18;
    BEGIN
      GET(CreditLimitNotification.GETDATA(Customer.FIELDNAME("No.")));
      SETRANGE("No.","No.");

      IF GETFILTER("Date Filter") = '' THEN
        SETFILTER("Date Filter",'..%1',WORKDATE);
      CALCFIELDS("Balance (LCY)","Shipped Not Invoiced (LCY)","Serv Shipped Not Invoiced(LCY)");

      EVALUATE(OrderAmountTotalLCY,CreditLimitNotification.GETDATA('OrderAmountTotalLCY'));
      EVALUATE(ShippedRetRcdNotIndLCY,CreditLimitNotification.GETDATA('ShippedRetRcdNotIndLCY'));
      EVALUATE(OrderAmountThisOrderLCY,CreditLimitNotification.GETDATA('OrderAmountThisOrderLCY'));
      EVALUATE(CustCreditAmountLCY,CreditLimitNotification.GETDATA('CustCreditAmountLCY'));
    END;

    [External]
    PROCEDURE SetCustomerNumber@16(Value@1000 : Code[20]);
    BEGIN
      GET(Value);
    END;

    [External]
    PROCEDURE SetOrderAmountTotalLCY@1(Value@1000 : Decimal);
    BEGIN
      OrderAmountTotalLCY := Value;
    END;

    [External]
    PROCEDURE SetShippedRetRcdNotIndLCY@2(Value@1000 : Decimal);
    BEGIN
      ShippedRetRcdNotIndLCY := Value;
    END;

    [External]
    PROCEDURE SetOrderAmountThisOrderLCY@3(Value@1000 : Decimal);
    BEGIN
      OrderAmountThisOrderLCY := Value;
    END;

    [External]
    PROCEDURE SetCustCreditAmountLCY@4(Value@1000 : Decimal);
    BEGIN
      CustCreditAmountLCY := Value;
    END;

    BEGIN
    END.
  }
}

