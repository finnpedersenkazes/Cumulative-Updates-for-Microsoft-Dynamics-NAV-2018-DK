OBJECT Page 9095 Vendor Hist. Buy-from FactBox
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Leverand›roversigt;
               ENU=Buy-from Vendor History];
    SourceTable=Table23;
    PageType=CardPart;
    OnInit=BEGIN
             ShowVendorNo := TRUE;
           END;

    OnOpenPage=VAR
                 OfficeManagement@1000 : Codeunit 1630;
               BEGIN
                 RegularFastTabVisible := ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Windows;
                 CuesVisible := (NOT RegularFastTabVisible) OR OfficeManagement.IsAvailable;
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 21  ;1   ;Field     ;
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

    { 23  ;1   ;Group     ;
                Visible=RegularFastTabVisible;
                GroupType=Group }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Rekvisition;
                           ENU=Quotes];
                ToolTipML=[DAN=Angiver antallet af k›bsrekvisitioner, der findes for kreditoren.;
                           ENU=Specifies the number of purchase quotes that exist for the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Quotes";
                DrillDownPageID=Purchase Quotes }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Rammeordrer;
                           ENU=Blanket Orders];
                ToolTipML=[DAN=Angiver antallet af k›bsrammeordrer, der findes for kreditoren.;
                           ENU=Specifies the number of purchase blanket orders that exist for the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Blanket Orders";
                DrillDownPageID=Blanket Purchase Orders }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Ordrer;
                           ENU=Orders];
                ToolTipML=[DAN=Angiver antallet af k›bsordrer, der findes for kreditoren.;
                           ENU=Specifies the number of purchase orders that exist for the vendor.];
                ApplicationArea=#Suite;
                SourceExpr="No. of Orders";
                DrillDownPageID=Purchase Order List }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Fakturaer;
                           ENU=Invoices];
                ToolTipML=[DAN=Angiver antallet af ikke-bogf›rte k›bsfakturaer, der findes for kreditoren.;
                           ENU=Specifies the number of unposted purchase invoices that exist for the vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Invoices";
                DrillDownPageID=Purchase Invoices }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Returvareordrer;
                           ENU=Return Orders];
                ToolTipML=[DAN=Angiver antallet af k›bsreturvareordrer, der findes for kreditoren.;
                           ENU=Specifies the number of purchase return orders that exist for the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Return Orders";
                DrillDownPageID=Purchase Return Order List }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Kreditnotaer;
                           ENU=Credit Memos];
                ToolTipML=[DAN=Angiver antallet af ikke-bogf›rte k›bskreditnotaer, der findes for kreditoren.;
                           ENU=Specifies the number of unposted purchase credit memos that exist for the vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Credit Memos";
                DrillDownPageID=Purchase Credit Memos }

    { 14  ;2   ;Field     ;
                CaptionML=[DAN=Bogf. returvareleverancer;
                           ENU=Pstd. Return Shipments];
                ToolTipML=[DAN=Angiver antallet af bogf›rte returvareleverancer, der findes for kreditoren.;
                           ENU=Specifies the number of posted return shipments that exist for the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Pstd. Return Shipments" }

    { 16  ;2   ;Field     ;
                CaptionML=[DAN=Bogf. modtagelser;
                           ENU=Pstd. Receipts];
                ToolTipML=[DAN=Angiver antallet af bogf›rte k›bsmodtagelser, der findes for kreditoren.;
                           ENU=Specifies the number of posted purchase receipts that exist for the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Pstd. Receipts" }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Bogf. fakturaer;
                           ENU=Pstd. Invoices];
                ToolTipML=[DAN=Angiver antallet af bogf›rte k›bsfakturaer, der findes for kreditoren.;
                           ENU=Specifies the number of posted purchase invoices that exist for the vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Pstd. Invoices" }

    { 20  ;2   ;Field     ;
                CaptionML=[DAN=Bogf. kreditnotaer;
                           ENU=Pstd. Credit Memos];
                ToolTipML=[DAN=Angiver antallet af bogf›rte k›bskreditnotaer, der findes for kreditoren.;
                           ENU=Specifies the number of posted purchase credit memos that exist for the vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Pstd. Credit Memos" }

    { 25  ;2   ;Field     ;
                Name=NoOfIncomingDocuments;
                CaptionML=[DAN=Indg†ende bilag;
                           ENU=Incoming Documents];
                ToolTipML=[DAN=Angiver indg†ende bilag, f.eks. kreditorfakturaer i PDF- eller billedfiler, som kan bruges til manuel eller automatisk konvertering til bilagsrecords, f.eks. k›bsfakturaer. De eksterne filer, der repr‘senterer indg†ende bilag, kan knyttes til ethvert procestrin, herunder bogf›rte bilag og de resulterende kreditor-, debitor- og finansposter.;
                           ENU=Specifies incoming documents, such as vendor invoices in PDF or as image files, that you can manually or automatically convert to document records, such as purchase invoices. The external files that represent incoming documents can be attached at any process stage, including to posted documents and to the resulting vendor, customer, and general ledger entries.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Incoming Documents" }

    { 1   ;1   ;Group     ;
                Visible=CuesVisible;
                GroupType=CueGroup }

    { 22  ;2   ;Field     ;
                Name=CueQuotes;
                CaptionML=[DAN=Tilbud;
                           ENU=Quotes];
                ToolTipML=[DAN=Angiver antallet af k›bsrekvisitioner, der findes for kreditoren.;
                           ENU=Specifies the number of purchase quotes that exist for the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Quotes";
                DrillDownPageID=Purchase Quotes }

    { 19  ;2   ;Field     ;
                Name=CueBlanketOrders;
                CaptionML=[DAN=Rammeordrer;
                           ENU=Blanket Orders];
                ToolTipML=[DAN=Angiver antallet af k›bsrammeordrer, der findes for kreditoren.;
                           ENU=Specifies the number of purchase blanket orders that exist for the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Blanket Orders";
                DrillDownPageID=Blanket Purchase Orders }

    { 17  ;2   ;Field     ;
                Name=CueOrders;
                CaptionML=[DAN=Ordrer;
                           ENU=Orders];
                ToolTipML=[DAN=Angiver antallet af k›bsordrer, der findes for kreditoren.;
                           ENU=Specifies the number of purchase orders that exist for the vendor.];
                ApplicationArea=#Suite;
                SourceExpr="No. of Orders";
                DrillDownPageID=Purchase Order List }

    { 15  ;2   ;Field     ;
                Name=CueInvoices;
                CaptionML=[DAN=Fakturaer;
                           ENU=Invoices];
                ToolTipML=[DAN=Angiver antallet af ikke-bogf›rte k›bsfakturaer, der findes for kreditoren.;
                           ENU=Specifies the number of unposted purchase invoices that exist for the vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Invoices";
                DrillDownPageID=Purchase Invoices }

    { 13  ;2   ;Field     ;
                Name=CueReturnOrders;
                CaptionML=[DAN=Returvareordrer;
                           ENU=Return Orders];
                ToolTipML=[DAN=Angiver antallet af k›bsreturvareordrer, der findes for kreditoren.;
                           ENU=Specifies the number of purchase return orders that exist for the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Return Orders";
                DrillDownPageID=Purchase Return Order List }

    { 11  ;2   ;Field     ;
                Name=CueCreditMemos;
                CaptionML=[DAN=Kreditnotaer;
                           ENU=Credit Memos];
                ToolTipML=[DAN=Angiver antallet af ikke-bogf›rte k›bskreditnotaer, der findes for kreditoren.;
                           ENU=Specifies the number of unposted purchase credit memos that exist for the vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Credit Memos";
                DrillDownPageID=Purchase Credit Memos }

    { 9   ;2   ;Field     ;
                Name=CuePostedRetShip;
                CaptionML=[DAN=Bogf›rte returvareleverancer;
                           ENU=Pstd. Return Shipments];
                ToolTipML=[DAN=Angiver antallet af bogf›rte returvareleverancer, der findes for kreditoren.;
                           ENU=Specifies the number of posted return shipments that exist for the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Pstd. Return Shipments" }

    { 7   ;2   ;Field     ;
                Name=CuePostedReceipts;
                CaptionML=[DAN=Bogf›rte modtagelser;
                           ENU=Pstd. Receipts];
                ToolTipML=[DAN=Angiver antallet af bogf›rte k›bsmodtagelser, der findes for kreditoren.;
                           ENU=Specifies the number of posted purchase receipts that exist for the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Pstd. Receipts" }

    { 5   ;2   ;Field     ;
                Name=CuePostedInvoices;
                CaptionML=[DAN=Bogf›rte fakturaer;
                           ENU=Pstd. Invoices];
                ToolTipML=[DAN=Angiver antallet af bogf›rte k›bsfakturaer, der findes for kreditoren.;
                           ENU=Specifies the number of posted purchase invoices that exist for the vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Pstd. Invoices" }

    { 3   ;2   ;Field     ;
                Name=CuePostedCreditMemos;
                CaptionML=[DAN=Bogf›rte kreditnotaer;
                           ENU=Pstd. Credit Memos];
                ToolTipML=[DAN=Angiver antallet af bogf›rte k›bskreditnotaer, der findes for kreditoren.;
                           ENU=Specifies the number of posted purchase credit memos that exist for the vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Pstd. Credit Memos" }

    { 24  ;2   ;Field     ;
                Name=CueIncomingDocuments;
                CaptionML=[DAN=Indg†ende bilag;
                           ENU=Incoming Documents];
                ToolTipML=[DAN=Angiver indg†ende bilag, f.eks. kreditorfakturaer i PDF- eller billedfiler, som kan bruges til manuel eller automatisk konvertering til bilagsrecords, f.eks. k›bsfakturaer. De eksterne filer, der repr‘senterer indg†ende bilag, kan knyttes til ethvert procestrin, herunder bogf›rte bilag og de resulterende kreditor-, debitor- og finansposter.;
                           ENU=Specifies incoming documents, such as vendor invoices in PDF or as image files, that you can manually or automatically convert to document records, such as purchase invoices. The external files that represent incoming documents can be attached at any process stage, including to posted documents and to the resulting vendor, customer, and general ledger entries.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Incoming Documents" }

  }
  CODE
  {
    VAR
      ClientTypeManagement@1077 : Codeunit 4;
      RegularFastTabVisible@1010 : Boolean;
      CuesVisible@1011 : Boolean;
      ShowVendorNo@1012 : Boolean;

    LOCAL PROCEDURE ShowDetails@1102601000();
    BEGIN
      PAGE.RUN(PAGE::"Vendor Card",Rec);
    END;

    [External]
    PROCEDURE SetVendorNoVisibility@1(Visible@1000 : Boolean);
    BEGIN
      ShowVendorNo := Visible;
    END;

    BEGIN
    END.
  }
}

