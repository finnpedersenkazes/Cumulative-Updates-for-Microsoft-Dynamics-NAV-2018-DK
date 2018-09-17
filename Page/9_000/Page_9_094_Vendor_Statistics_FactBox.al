OBJECT Page 9094 Vendor Statistics FactBox
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kreditorstatistik;
               ENU=Vendor Statistics];
    SourceTable=Table23;
    PageType=CardPart;
    OnInit=BEGIN
             ShowVendorNo := TRUE;
           END;

    OnFindRecord=BEGIN
                   TotalAmountLCY := 0;

                   EXIT(FIND(Which));
                 END;

    OnAfterGetRecord=BEGIN
                       FILTERGROUP(4);
                       DateFilterSet := GETFILTER("Date Filter") <> '';
                       SETAUTOCALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Amt. Rcd. Not Invoiced (LCY)","Outstanding Invoices (LCY)");
                       TotalAmountLCY := "Balance (LCY)" + "Outstanding Orders (LCY)" + "Amt. Rcd. Not Invoiced (LCY)" + "Outstanding Invoices (LCY)";
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 13  ;1   ;Field     ;
                CaptionML=[DAN=Leverand›rnr.;
                           ENU=Vendor No.];
                ToolTipML=[DAN=Angiver kreditorens nummer. Feltet udfyldes enten automatisk fra en defineret nummerserie, eller du kan indtaste nummeret manuelt, fordi du har aktiveret manuel nummerindtastning i ops‘tningen af nummerserier.;
                           ENU=Specifies the number of the vendor. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Visible=ShowVendorNo;
                OnDrillDown=BEGIN
                              ShowDetails;
                            END;
                             }

    { 4   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede v‘rdi af dine gennemf›rte k›b fra kreditoren i det aktuelle regnskabs†r. Den beregnes ud fra bel›bene, ekskl. moms, p† alle afsluttede og †bne k›bsfakturaer og kreditnotaer.;
                           ENU=Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all completed purchase invoices and credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance (LCY)";
                OnDrillDown=VAR
                              VendLedgEntry@1001 : Record 25;
                              DtldVendLedgEntry@1000 : Record 380;
                            BEGIN
                              DtldVendLedgEntry.SETRANGE("Vendor No.","No.");
                              COPYFILTER("Global Dimension 1 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 1");
                              COPYFILTER("Global Dimension 2 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 2");
                              COPYFILTER("Currency Filter",DtldVendLedgEntry."Currency Code");
                              VendLedgEntry.DrillDownOnEntries(DtldVendLedgEntry);
                            END;
                             }

    { 5   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver summen af udest†ende ordrer (i RV) for denne kreditor.;
                           ENU=Specifies the sum of outstanding orders (in LCY) to this vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Outstanding Orders (LCY)";
                HideValue=DateFilterSet }

    { 6   ;1   ;Field     ;
                CaptionML=[DAN=Modt. bel›b ufakt. (RV);
                           ENU=Amt. Rcd. Not Invd. (LCY)];
                ToolTipML=[DAN=Angiver det samlede fakturabel›b (i RV) for varer, du har modtaget, men endnu ikke er faktureret for.;
                           ENU=Specifies the total invoice amount (in LCY) for the items you have received but not yet been invoiced for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amt. Rcd. Not Invoiced (LCY)";
                HideValue=DateFilterSet }

    { 7   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver summen af kreditors udest†ende k›bsfakturaer i RV.;
                           ENU=Specifies the sum of the vendor's outstanding purchase invoices in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Outstanding Invoices (LCY)";
                HideValue=DateFilterSet }

    { 9   ;1   ;Field     ;
                CaptionML=[DAN=I alt (RV);
                           ENU=Total (LCY)];
                ToolTipML=[DAN=Angiver det betalingsbel›b, du skylder kreditoren for gennemf›rte k›b plus igangv‘rende k›b.;
                           ENU=Specifies the payment amount that you owe the vendor for completed purchases plus purchases that are still ongoing.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TotalAmountLCY;
                AutoFormatType=1;
                HideValue=DateFilterSet }

    { 12  ;1   ;Field     ;
                Name=Balance Due (LCY);
                CaptionML=[DAN=Forf. bel›b (RV);
                           ENU=Balance Due (LCY)];
                ApplicationArea=#Advanced;
                SourceExpr=CalcOverDueBalance;
                CaptionClass=FORMAT(STRSUBSTNO(Text000,FORMAT(WORKDATE)));
                OnDrillDown=VAR
                              VendLedgEntry@1001 : Record 25;
                              DtldVendLedgEntry@1000 : Record 380;
                            BEGIN
                              DtldVendLedgEntry.SETFILTER("Vendor No.","No.");
                              COPYFILTER("Global Dimension 1 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 1");
                              COPYFILTER("Global Dimension 2 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 2");
                              COPYFILTER("Currency Filter",DtldVendLedgEntry."Currency Code");
                              VendLedgEntry.DrillDownOnOverdueEntries(DtldVendLedgEntry);
                            END;
                             }

    { 1   ;1   ;Field     ;
                CaptionML=[DAN=Faktureret forudbetalingsbel›b (RV);
                           ENU=Invoiced Prepayment Amount (LCY)];
                ToolTipML=[DAN=Angiver dine betalinger til kreditoren baseret p† fakturerede forudbetalinger.;
                           ENU=Specifies your payments to the vendor, based on invoiced prepayments.];
                ApplicationArea=#Prepayments;
                SourceExpr=GetInvoicedPrepmtAmountLCY;
                HideValue=DateFilterSet }

  }
  CODE
  {
    VAR
      TotalAmountLCY@1014 : Decimal;
      Text000@1018 : TextConst 'DAN=Forfaldne bel›b (RV) pr. %1;ENU=Overdue Amounts (LCY) as of %1';
      ShowVendorNo@1000 : Boolean;
      DateFilterSet@1001 : Boolean;

    LOCAL PROCEDURE ShowDetails@1102601000();
    BEGIN
      PAGE.RUN(PAGE::"Vendor Card",Rec);
    END;

    [External]
    PROCEDURE SetVendorNoVisibility@2(Visible@1000 : Boolean);
    BEGIN
      ShowVendorNo := Visible;
    END;

    BEGIN
    END.
  }
}

