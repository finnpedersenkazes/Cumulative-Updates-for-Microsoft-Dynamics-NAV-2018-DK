OBJECT Page 1163 Sales Invoices Due Next Week
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
    CaptionML=[DAN=Salgsfakturaer, der forfalder n‘ste uge;
               ENU=Sales Invoices Due Next Week];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table112;
    SourceTableView=SORTING(Posting Date)
                    ORDER(Descending);
    PageType=CardPart;
    ShowFilter=No;
    OnOpenPage=BEGIN
                 SETRANGE(Closed,FALSE);
                 SETFILTER("Due Date",'%1..%2',CALCDATE('<1D>',WORKDATE),CALCDATE('<1W>',WORKDATE));
                 ASCENDING := FALSE;
               END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r salgsfakturaerne skal betales.;
                           ENU=Specifies when the sales invoices must be paid.];
                ApplicationArea=#All;
                SourceExpr="Due Date" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#All;
                SourceExpr="Sell-to Customer Name" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, der mangler at blive betalt for de salgsfakturaer, som forfalder i n‘ste uge.;
                           ENU=Specifies the amount that remains to be paid on the sales invoices that are due next week.];
                ApplicationArea=#All;
                SourceExpr="Remaining Amount";
                OnDrillDown=VAR
                              HyperLinkUrl@1000 : Text[250];
                            BEGIN
                              HyperLinkUrl := GETURL(CLIENTTYPE::Web,COMPANYNAME,OBJECTTYPE::Page,573) +
                                STRSUBSTNO(FilterForRemAmountDrillDwnTxt,"Cust. Ledger Entry No.");
                              HYPERLINK(HyperLinkUrl);
                            END;
                             }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den relevante valutakode til salgsfakturaerne.;
                           ENU=Specifies the relevant currency code for the sales invoices.];
                ApplicationArea=#All;
                SourceExpr="Currency Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om salgsfakturaen p† linjen er blevet lukket.;
                           ENU=Specifies whether or not the sales invoice on the line has been closed.];
                ApplicationArea=#All;
                SourceExpr=Closed;
                OnDrillDown=VAR
                              HyperLinkUrl@1000 : Text[250];
                            BEGIN
                              HyperLinkUrl := GETURL(CLIENTTYPE::Web,COMPANYNAME,OBJECTTYPE::Page,25) +
                                STRSUBSTNO(FilterForClosedDrillDwnTxt,"Cust. Ledger Entry No.");
                              HYPERLINK(HyperLinkUrl);
                            END;
                             }

  }
  CODE
  {
    VAR
      FilterForClosedDrillDwnTxt@1000 : TextConst '@@@=%1 - Customer ledger Entry No. for sales invoice header.;DAN="&filter=''Cust. Ledger Entry''.''Entry No.'' IS ''%1'' AND ''Cust. Ledger Entry''.Open IS ''1''";ENU="&filter=''Cust. Ledger Entry''.''Entry No.'' IS ''%1'' AND ''Cust. Ledger Entry''.Open IS ''1''"';
      FilterForRemAmountDrillDwnTxt@1001 : TextConst '@@@=%1 - Customer ledger Entry No. for sales invoice header.;DAN="&filter=''Detailed Cust. Ledg. Entry''.''Cust. Ledger Entry No.'' IS ''%1''";ENU="&filter=''Detailed Cust. Ledg. Entry''.''Cust. Ledger Entry No.'' IS ''%1''"';

    BEGIN
    END.
  }
}

