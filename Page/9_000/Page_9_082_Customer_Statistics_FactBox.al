OBJECT Page 9082 Customer Statistics FactBox
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debitorstatistik;
               ENU=Customer Statistics];
    SourceTable=Table18;
    PageType=CardPart;
    OnInit=BEGIN
             ShowCustomerNo := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       FILTERGROUP(4);
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 19  ;1   ;Field     ;
                CaptionML=[DAN=Debitornr.;
                           ENU=Customer No.];
                ToolTipML=[DAN=Angiver debitorens nummer. Feltet udfyldes enten automatisk fra en defineret nummerserie, eller du kan indtaste nummeret manuelt, fordi du har aktiveret manuel nummerindtastning i ops‘tningen af nummerserier.;
                           ENU=Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Visible=ShowCustomerNo;
                OnDrillDown=BEGIN
                              ShowDetails;
                            END;
                             }

    { 13  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver det betalingsbel›b, som debitoren skylder for afsluttede salg samt salg, der stadig er igangv‘rende. V‘rdien kaldes ogs† debitorsaldo.;
                           ENU=Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer's balance.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance (LCY)";
                OnDrillDown=VAR
                              DtldCustLedgEntry@1000 : Record 379;
                              CustLedgEntry@1001 : Record 21;
                            BEGIN
                              DtldCustLedgEntry.SETRANGE("Customer No.","No.");
                              COPYFILTER("Global Dimension 1 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 1");
                              COPYFILTER("Global Dimension 2 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 2");
                              COPYFILTER("Currency Filter",DtldCustLedgEntry."Currency Code");
                              CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                            END;
                             }

    { 5   ;1   ;Group     ;
                Name=Sales;
                CaptionML=[DAN=Salg;
                           ENU=Sales];
                GroupType=Group }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dine forventede salgsindt‘gter fra debitoren i RV baseret p† igangv‘rende salgsordrer.;
                           ENU=Specifies your expected sales income from the customer in LCY based on ongoing sales orders.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Outstanding Orders (LCY)" }

    { 15  ;2   ;Field     ;
                CaptionML=[DAN=Leveret ikke faktureret (RV);
                           ENU=Shipped Not Invd. (LCY)];
                ToolTipML=[DAN=Angiver dine forventede salgsindt‘gter fra debitoren i RV baseret p† igangv‘rende salgsordrer, hvor varerne er blevet afsendt.;
                           ENU=Specifies your expected sales income from the customer in LCY based on ongoing sales orders where items have been shipped.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipped Not Invoiced (LCY)" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dine forventede salgsindt‘gter fra debitoren i RV baseret p† ubetalte salgsfakturaer.;
                           ENU=Specifies your expected sales income from the customer in LCY based on unpaid sales invoices.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Outstanding Invoices (LCY)" }

    { 1   ;1   ;Group     ;
                Name=Service;
                CaptionML=[DAN=Service;
                           ENU=Service];
                GroupType=Group }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dine forventede serviceindt‘gter fra debitoren i RV baseret p† igangv‘rende serviceordrer.;
                           ENU=Specifies your expected service income from the customer in LCY based on ongoing service orders.];
                ApplicationArea=#Service;
                SourceExpr="Outstanding Serv. Orders (LCY)" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dine forventede serviceindt‘gter fra debitoren i RV baseret p† serviceordrer, som er sendt, men ikke faktureret.;
                           ENU=Specifies your expected service income from the customer in LCY based on service orders that are shipped but not invoiced.];
                ApplicationArea=#Service;
                SourceExpr="Serv Shipped Not Invoiced(LCY)" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dine forventede serviceindt‘gter fra debitoren i RV baseret p† ubetalte servicefakturaer.;
                           ENU=Specifies your expected service income from the customer in LCY based on unpaid service invoices.];
                ApplicationArea=#Service;
                SourceExpr="Outstanding Serv.Invoices(LCY)" }

    { 10  ;1   ;Field     ;
                Name=Total (LCY);
                AccessByPermission=TableData 37=R;
                CaptionML=[DAN=I alt (RV);
                           ENU=Total (LCY)];
                ToolTipML=[DAN=Angiver det betalingsbel›b, som debitoren skylder for afsluttede salg samt salg, der stadig er igangv‘rende.;
                           ENU=Specifies the payment amount that the customer owes for completed sales plus sales that are still ongoing.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetTotalAmountLCY;
                AutoFormatType=1;
                Importance=Promoted;
                Style=Strong;
                StyleExpr=TRUE }

    { 11  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver det maksimale bel›b, som du tillader, at debitoren overskrider betalingssaldoen med, f›r der udstedes advarsler.;
                           ENU=Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Limit (LCY)" }

    { 12  ;1   ;Field     ;
                Name=Balance Due (LCY);
                CaptionML=[DAN=Balance Due (LCY);
                           ENU=Balance Due (LCY)];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CalcOverdueBalance;
                CaptionClass=FORMAT(STRSUBSTNO(Text000,FORMAT(WORKDATE)));
                OnDrillDown=VAR
                              DtldCustLedgEntry@1000 : Record 379;
                              CustLedgEntry@1001 : Record 21;
                            BEGIN
                              DtldCustLedgEntry.SETFILTER("Customer No.","No.");
                              COPYFILTER("Global Dimension 1 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 1");
                              COPYFILTER("Global Dimension 2 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 2");
                              COPYFILTER("Currency Filter",DtldCustLedgEntry."Currency Code");
                              CustLedgEntry.DrillDownOnOverdueEntries(DtldCustLedgEntry);
                            END;
                             }

    { 4   ;1   ;Field     ;
                Name=Sales (LCY);
                CaptionML=[DAN=Samlet salg (RV);
                           ENU=Total Sales (LCY)];
                ToolTipML=[DAN=Angiver den samlede salgsoms‘tning med debitoren i det aktuelle regnskabs†r. Den beregnes ud fra bel›bene, ekskl. moms, p† alle afsluttede og †bne salgsfakturaer og kreditnotaer.;
                           ENU=Specifies your total sales turnover with the customer in the current fiscal year. It is calculated from amounts excluding VAT on all completed and open sales invoices and credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetSalesLCY;
                OnDrillDown=VAR
                              CustLedgEntry@1000 : Record 21;
                              AccountingPeriod@1001 : Record 50;
                            BEGIN
                              CustLedgEntry.RESET;
                              CustLedgEntry.SETRANGE("Customer No.","No.");
                              CustLedgEntry.SETRANGE(
                                "Posting Date",AccountingPeriod.GetFiscalYearStartDate(WORKDATE),AccountingPeriod.GetFiscalYearEndDate(WORKDATE));
                              PAGE.RUNMODAL(PAGE::"Customer Ledger Entries",CustLedgEntry);
                            END;
                             }

    { 8   ;1   ;Field     ;
                AccessByPermission=TableData 37=R;
                CaptionML=[DAN=Faktureret forudbetalingsbel›b (RV);
                           ENU=Invoiced Prepayment Amount (LCY)];
                ToolTipML=[DAN=Angiver dine salgsindt‘gter fra debitoren baseret p† fakturerede forudbetalinger.;
                           ENU=Specifies your sales income from the customer, based on invoiced prepayments.];
                ApplicationArea=#Prepayments;
                SourceExpr=GetInvoicedPrepmtAmountLCY }

  }
  CODE
  {
    VAR
      Text000@1024 : TextConst 'DAN=Forfaldne bel›b (RV) pr. %1;ENU=Overdue Amounts (LCY) as of %1';
      ShowCustomerNo@1000 : Boolean;

    LOCAL PROCEDURE ShowDetails@1102601000();
    BEGIN
      PAGE.RUN(PAGE::"Customer Card",Rec);
    END;

    [External]
    PROCEDURE SetCustomerNoVisibility@1(Visible@1000 : Boolean);
    BEGIN
      ShowCustomerNo := Visible;
    END;

    BEGIN
    END.
  }
}

