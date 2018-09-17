OBJECT Page 2105 O365 Monthly Customer Listpart
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
    CaptionML=[DAN=Fakturerede debitorer;
               ENU=Customers invoiced];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table2107;
    SourceTableView=SORTING(Inv. Amounts (LCY))
                    ORDER(Descending);
    PageType=ListPart;
    SourceTableTemporary=Yes;
    OnOpenPage=BEGIN
                 SETRANGE("Date Filter",0D,WORKDATE - 1); // Calculating overdue abount (Balance Due (LCY))
                 OverdueBalanceAutoFormatExpr := STRSUBSTNO(AutoFormatExprWithPrefixTxt,OverdueTxt);
               END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 5       ;1   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Vis;
                                 ENU=View];
                      ToolTipML=[DAN=èbn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=False;
                      Image=ViewDetails;
                      OnAction=VAR
                                 O365SalesDocument@1000 : Record 2103;
                               BEGIN
                                 O365SalesDocument.SETRANGE("Sell-to Customer Name",Name);
                                 O365SalesDocument.SETRANGE(Posted,TRUE);
                                 O365SalesDocument.SETRANGE("Document Date",StartOfMonthDate,EndOfMonthDate);
                                 PAGE.RUNMODAL(PAGE::"O365 Customer Sales Documents",O365SalesDocument);
                               END;

                      Gesture=None }
    }
  }
  CONTROLS
  {
    { 1900000001;;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens navn. Navnet vises pÜ alle debitorens salgsbilag. Du kan bruge op til 50 tegn (bÜde tal og bogstaver).;
                           ENU=Specifies the customer's name. This name will appear on all sales documents for the customer. You can enter a maximum of 50 characters, both numbers and letters.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Name }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den person, som du regelmëssigt kontakter, nÜr du gõr forretninger med debitoren.;
                           ENU=Specifies the name of the person you regularly contact when you do business with this customer.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Contact }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalinger fra debitoren, der er forfaldne pr. dags dato.;
                           ENU=Specifies payments from the customer that are overdue per today's date.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                BlankZero=Yes;
                SourceExpr="Balance Due (LCY)";
                AutoFormatType=10;
                AutoFormatExpr=OverdueBalanceAutoFormatExpr;
                Style=Attention;
                StyleExpr=TRUE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det betalingsbelõb, som debitoren skylder for afsluttede salg. Vërdien kaldes ogsÜ debitorsaldo.;
                           ENU=Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer's balance.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Balance (LCY)";
                AutoFormatType=10;
                AutoFormatExpr='1' }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det betalingsbelõb, som debitoren skylder for afsluttede salg. Vërdien kaldes ogsÜ debitorsaldo.;
                           ENU=Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer's balance.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Inv. Amounts (LCY)";
                AutoFormatType=10;
                AutoFormatExpr='1' }

  }
  CODE
  {
    VAR
      AutoFormatExprWithPrefixTxt@1000 : TextConst '@@@={Locked};DAN=1,,%1;ENU=1,,%1';
      OverdueTxt@1001 : TextConst 'DAN=Forfalden:;ENU=Overdue:';
      EndOfMonthDate@1004 : Date;
      StartOfMonthDate@1005 : Date;
      OverdueBalanceAutoFormatExpr@1002 : Text;
      CurrentMonth@1003 : Integer;

    [External]
    PROCEDURE InsertData@2(Month@1000 : Integer);
    VAR
      Customer@1001 : Record 18;
      O365SalesStatistics@1002 : Codeunit 2100;
      CurrentMonthDateFormula@1003 : DateFormula;
    BEGIN
      CurrentMonth := Month;
      IF NOT O365SalesStatistics.GenerateMonthlyCustomers(Month,Customer) THEN
        EXIT;

      IF NOT Customer.FINDSET THEN
        EXIT;
      StartOfMonthDate := DMY2DATE(1,CurrentMonth,DATE2DMY(WORKDATE,3));
      EVALUATE(CurrentMonthDateFormula,'<CM>');
      EndOfMonthDate := CALCDATE(CurrentMonthDateFormula,StartOfMonthDate);
      Customer.SETRANGE("Date Filter",StartOfMonthDate,EndOfMonthDate);

      DELETEALL;

      REPEAT
        Customer.CALCFIELDS("Net Change (LCY)");
        TRANSFERFIELDS(Customer,TRUE);
        "Inv. Amounts (LCY)" := Customer."Net Change (LCY)";
        INSERT(TRUE);
      UNTIL Customer.NEXT = 0;

      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

