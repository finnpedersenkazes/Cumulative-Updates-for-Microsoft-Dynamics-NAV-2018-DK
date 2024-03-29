OBJECT Page 328 Intrastat Setup
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Intrastat, Ops�tning;
               ENU=Intrastat Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table247;
    OnOpenPage=BEGIN
                 INIT;
                 IF NOT GET THEN
                   INSERT(TRUE);
               END;

  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                Name=Container;
                ContainerType=ContentArea }

    { 6   ;1   ;Group     ;
                Name=General;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du skal inkludere tilgang af modtagede varer i Intrastatrapporter.;
                           ENU=Specifies that you must include arrivals of received goods in Intrastat reports.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report Receipts" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du skal inkludere leverancer af afsendte varer i Intrastatrapporter.;
                           ENU=Specifies that you must include shipments of dispatched items in Intrastat reports.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report Shipments" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Intrastat-kontakttypen.;
                           ENU=Specifies the Intrastat contact type.];
                OptionCaptionML=[DAN=" ,Kontakt,Kreditor";
                                 ENU=" ,Contact,Vendor"];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Intrastat Contact Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Intrastat-kontakten.;
                           ENU=Specifies the Intrastat contact.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Intrastat Contact No." }

    { 7   ;1   ;Group     ;
                Name=Default Transactions;
                CaptionML=[DAN=Standardtransaktioner;
                           ENU=Default Transactions];
                GroupType=Group }

    { 2   ;2   ;Field     ;
                Name=Default Transaction Type;
                ToolTipML=[DAN=Angiver standardtransaktionstypen i Intrastatrapporter for k�b og salg.;
                           ENU=Specifies the default transaction type in Intrastat reports for sales and purchases.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Default Trans. - Purchase" }

    { 3   ;2   ;Field     ;
                Name=Default Trans. Type - Returns;
                ToolTipML=[DAN=Angiver standardtransaktionstypen i Intrastatrapporter for indk�bsreturneringer og salg.;
                           ENU=Specifies the default transaction type in Intrastat reports for purchase returns and sales.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Default Trans. - Return" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

