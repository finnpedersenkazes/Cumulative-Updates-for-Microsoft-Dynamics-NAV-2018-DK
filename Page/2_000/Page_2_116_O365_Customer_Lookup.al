OBJECT Page 2116 O365 Customer Lookup
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
    CaptionML=[DAN=Debitorer;
               ENU=Customers];
    SourceTable=Table18;
    SourceTableView=SORTING(Name)
                    WHERE(Blocked=CONST(" "));
    PageType=List;
    CardPageID=O365 Sales Customer Card;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 SETRANGE("Date Filter",0D,WORKDATE);
                 OverdueBalanceAutoFormatExpr := STRSUBSTNO(AutoFormatExprWithPrefixTxt,OverdueTxt);
               END;

    OnAfterGetRecord=BEGIN
                       "Balance Due (LCY)" := CalcOverdueBalance;
                     END;

    ActionList=ACTIONS
    {
      { 35      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
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
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens navn. Navnet vises p† alle debitorens salgsbilag. Du kan bruge op til 50 tegn (b†de tal og bogstaver).;
                           ENU=Specifies the customer's name. This name will appear on all sales documents for the customer. You can enter a maximum of 50 characters, both numbers and letters.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens telefonnummer.;
                           ENU=Specifies the customer's telephone number.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Phone No." }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den person, som du regelm‘ssigt kontakter, n†r du g›r forretninger med debitoren.;
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
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              OpenCustomerLedgerEntries(TRUE);
                            END;
                             }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede nettobel›b for salg til debitoren i RV.;
                           ENU=Specifies the total net amount of sales to the customer in LCY.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Sales (LCY)";
                AutoFormatType=10;
                AutoFormatExpr='1' }

    { 5   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 3   ;1   ;Part      ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page2193;
                PartType=Page }

  }
  CODE
  {
    VAR
      AutoFormatExprWithPrefixTxt@1000 : TextConst '@@@={Locked};DAN=1,,%1;ENU=1,,%1';
      OverdueTxt@1001 : TextConst 'DAN=Forfalden:;ENU=Overdue:';
      OverdueBalanceAutoFormatExpr@1002 : Text;

    BEGIN
    END.
  }
}

