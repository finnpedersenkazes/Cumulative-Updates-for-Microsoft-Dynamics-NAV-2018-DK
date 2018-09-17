OBJECT Page 2108 O365 Outstanding Customer List
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
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table18;
    SourceTableView=SORTING(Name);
    PageType=List;
    OnOpenPage=BEGIN
                 SETRANGE("Date Filter",0D,WORKDATE);
                 OverdueBalanceAutoFormatExpr := STRSUBSTNO(AutoFormatExprWithPrefixTxt,OverdueTxt);
               END;

    OnAfterGetRecord=BEGIN
                       SETRANGE("Date Filter",0D,WORKDATE - 1);
                       CALCFIELDS("Balance Due (LCY)");
                       SETRANGE("Date Filter",0D,WORKDATE);
                     END;

    OnDeleteRecord=BEGIN
                     BlockCustomerAndDeleteContact;
                     EXIT(FALSE);
                   END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 5       ;1   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Vis;
                                 ENU=View];
                      ToolTipML=[DAN=�bn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Image=ViewDetails;
                      OnAction=VAR
                                 O365SalesDocument@1000 : Record 2103;
                               BEGIN
                                 O365SalesDocument.SETRANGE(Posted,TRUE);
                                 O365SalesDocument.SETFILTER("Outstanding Amount",'>0');
                                 O365SalesDocument.SETFILTER("Sell-to Customer No.","No.");
                                 O365SalesDocument.SetSortByDocDate;

                                 PAGE.RUN(PAGE::"O365 Customer Sales Documents",O365SalesDocument);
                               END;

                      Gesture=None }
      { 7       ;1   ;Action    ;
                      Name=NewSalesInvoice;
                      CaptionML=[DAN=Ny faktura;
                                 ENU=New Invoice];
                      ToolTipML=[DAN=Opret en ny faktura til debitoren.;
                                 ENU=Create a new invoice for the customer.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NewSalesInvoice;
                      Scope=Repeater;
                      OnAction=VAR
                                 SalesHeader@1000 : Record 36;
                               BEGIN
                                 SalesHeader.INIT;
                                 SalesHeader.VALIDATE("Document Type",SalesHeader."Document Type"::Invoice);
                                 SalesHeader.VALIDATE("Sell-to Customer No.","No.");
                                 SalesHeader.INSERT(TRUE);
                                 COMMIT;

                                 PAGE.RUN(PAGE::"O365 Sales Invoice",SalesHeader);
                               END;

                      Gesture=LeftSwipe }
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
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens navn. Navnet vises p� alle debitorens salgsbilag. Du kan bruge op til 50 tegn (b�de tal og bogstaver).;
                           ENU=Specifies the customer's name. This name will appear on all sales documents for the customer. You can enter a maximum of 50 characters, both numbers and letters.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens telefonnummer.;
                           ENU=Specifies the customer's telephone number.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Phone No." }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den person, som du regelm�ssigt kontakter, n�r du g�r forretninger med debitoren.;
                           ENU=Specifies the name of the person you regularly contact when you do business with this customer.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Contact }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det betalingsbel�b, som debitoren skylder for afsluttede salg. V�rdien kaldes ogs� debitorsaldo.;
                           ENU=Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer's balance.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Balance (LCY)";
                AutoFormatType=10;
                AutoFormatExpr='1';
                OnDrillDown=BEGIN
                              OpenCustomerLedgerEntries(FALSE);
                            END;
                             }

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
                ToolTipML=[DAN=Angiver det samlede nettobel�b i RV for salg til debitoren.;
                           ENU=Specifies the total net amount of sales to the customer in LCY.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Sales (LCY)";
                AutoFormatType=10;
                AutoFormatExpr='1' }

  }
  CODE
  {
    VAR
      AutoFormatExprWithPrefixTxt@1000 : TextConst '@@@={Locked};DAN=1,,%1;ENU=1,,%1';
      OverdueTxt@1001 : TextConst 'DAN=Forfalden:;ENU=Overdue:';
      OverdueBalanceAutoFormatExpr@1002 : Text;

    LOCAL PROCEDURE BlockCustomerAndDeleteContact@1();
    VAR
      CustContUpdate@1000 : Codeunit 5056;
    BEGIN
      Blocked := Blocked::All;
      MODIFY(TRUE);
      CustContUpdate.DeleteCustomerContacts(Rec);
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

