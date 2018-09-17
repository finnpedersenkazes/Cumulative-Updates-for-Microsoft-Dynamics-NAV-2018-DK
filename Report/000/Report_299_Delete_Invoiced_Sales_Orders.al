OBJECT Report 299 Delete Invoiced Sales Orders
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Slet fakturerede salgsordrer;
               ENU=Delete Invoiced Sales Orders];
    ProcessingOnly=Yes;
  }
  DATASET
  {
    { 6640;    ;DataItem;                    ;
               DataItemTable=Table36;
               DataItemTableView=SORTING(Document Type,No.)
                                 WHERE(Document Type=CONST(Order));
               ReqFilterHeadingML=[DAN=Salgsordre;
                                   ENU=Sales Order];
               OnPreDataItem=BEGIN
                               Window.OPEN(Text000);
                             END;

               OnAfterGetRecord=VAR
                                  ATOLink@1001 : Record 904;
                                  ReserveSalesLine@1000 : Codeunit 99000832;
                                  ApprovalsMgmt@1002 : Codeunit 1535;
                                  PostSalesDelete@1003 : Codeunit 363;
                                BEGIN
                                  Window.UPDATE(1,"No.");

                                  AllLinesDeleted := TRUE;
                                  ItemChargeAssgntSales.RESET;
                                  ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
                                  ItemChargeAssgntSales.SETRANGE("Document No.","No.");
                                  SalesOrderLine.RESET;
                                  SalesOrderLine.SETRANGE("Document Type","Document Type");
                                  SalesOrderLine.SETRANGE("Document No.","No.");
                                  SalesOrderLine.SETFILTER("Quantity Invoiced",'<>0');
                                  IF SalesOrderLine.FIND('-') THEN BEGIN
                                    SalesOrderLine.SETRANGE("Quantity Invoiced");
                                    SalesOrderLine.SETFILTER("Outstanding Quantity",'<>0');
                                    IF NOT SalesOrderLine.FIND('-') THEN BEGIN
                                      SalesOrderLine.SETRANGE("Outstanding Quantity");
                                      SalesOrderLine.SETFILTER("Qty. Shipped Not Invoiced",'<>0');
                                      IF NOT SalesOrderLine.FIND('-') THEN BEGIN
                                        SalesOrderLine.LOCKTABLE;
                                        IF NOT SalesOrderLine.FIND('-') THEN BEGIN
                                          SalesOrderLine.SETRANGE("Qty. Shipped Not Invoiced");
                                          IF SalesOrderLine.FIND('-') THEN
                                            REPEAT
                                              SalesOrderLine.CALCFIELDS("Qty. Assigned");
                                              IF (SalesOrderLine."Qty. Assigned" = SalesOrderLine."Quantity Invoiced") OR
                                                 (SalesOrderLine.Type <> SalesOrderLine.Type::"Charge (Item)")
                                              THEN BEGIN
                                                IF SalesOrderLine.Type = SalesOrderLine.Type::"Charge (Item)" THEN BEGIN
                                                  ItemChargeAssgntSales.SETRANGE("Document Line No.",SalesOrderLine."Line No.");
                                                  ItemChargeAssgntSales.DELETEALL;
                                                END;
                                                IF SalesOrderLine.Type = SalesOrderLine.Type::Item THEN
                                                  ATOLink.DeleteAsmFromSalesLine(SalesOrderLine);
                                                IF SalesOrderLine.HASLINKS THEN
                                                  SalesOrderLine.DELETELINKS;
                                                SalesOrderLine.DELETE;
                                                OnAfterDeleteSalesLine(SalesOrderLine);
                                              END ELSE
                                                AllLinesDeleted := FALSE;
                                              UpdateAssPurchOrder;
                                            UNTIL SalesOrderLine.NEXT = 0;

                                          IF AllLinesDeleted THEN BEGIN
                                            PostSalesDelete.DeleteHeader(
                                              "Sales Header",SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,ReturnRcptHeader,
                                              PrepmtSalesInvHeader,PrepmtSalesCrMemoHeader);

                                            ReserveSalesLine.DeleteInvoiceSpecFromHeader("Sales Header");

                                            SalesCommentLine.SETRANGE("Document Type","Document Type");
                                            SalesCommentLine.SETRANGE("No.","No.");
                                            SalesCommentLine.DELETEALL;

                                            WhseRequest.SETRANGE("Source Type",DATABASE::"Sales Line");
                                            WhseRequest.SETRANGE("Source Subtype","Document Type");
                                            WhseRequest.SETRANGE("Source No.","No.");
                                            IF NOT WhseRequest.ISEMPTY THEN
                                              WhseRequest.DELETEALL(TRUE);

                                            ApprovalsMgmt.DeleteApprovalEntries(RECORDID);

                                            IF HASLINKS THEN
                                              DELETELINKS;
                                            DELETE;
                                          END;
                                          COMMIT;
                                        END;
                                      END;
                                    END;
                                  END;
                                END;

               ReqFilterFields=No.,Sell-to Customer No.,Bill-to Customer No. }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
    }
    CONTROLS
    {
    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Salgsordrerne gennemg�s #1##########;ENU=Processing sales orders #1##########';
      SalesOrderLine@1001 : Record 37;
      SalesShptHeader@1009 : Record 110;
      SalesInvHeader@1010 : Record 112;
      SalesCrMemoHeader@1011 : Record 114;
      ReturnRcptHeader@1012 : Record 6660;
      PrepmtSalesInvHeader@1013 : Record 112;
      PrepmtSalesCrMemoHeader@1014 : Record 114;
      SalesCommentLine@1002 : Record 44;
      ItemChargeAssgntSales@1007 : Record 5809;
      WhseRequest@1008 : Record 5765;
      Window@1004 : Dialog;
      AllLinesDeleted@1006 : Boolean;

    LOCAL PROCEDURE UpdateAssPurchOrder@1001();
    VAR
      PurchLine@1001 : Record 39;
    BEGIN
      WITH PurchLine DO BEGIN
        IF SalesOrderLine."Special Order" THEN
          IF GET(
               "Document Type"::Order,SalesOrderLine."Special Order Purchase No.",SalesOrderLine."Special Order Purch. Line No.")
          THEN BEGIN
            "Special Order Sales No." := '';
            "Special Order Sales Line No." := 0;
            MODIFY;
          END;

        IF SalesOrderLine."Drop Shipment" THEN
          IF GET(
               "Document Type"::Order,SalesOrderLine."Purchase Order No.",SalesOrderLine."Purch. Order Line No.")
          THEN BEGIN
            "Sales Order No." := '';
            "Sales Order Line No." := 0;
            MODIFY;
          END;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterDeleteSalesLine@1000(VAR SalesLine@1000 : Record 37);
    BEGIN
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

