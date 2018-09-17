OBJECT Report 499 Delete Invoiced Purch. Orders
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Slet fakturerede k�bsordrer;
               ENU=Delete Invoiced Purch. Orders];
    ProcessingOnly=Yes;
  }
  DATASET
  {
    { 4458;    ;DataItem;                    ;
               DataItemTable=Table38;
               DataItemTableView=SORTING(Document Type,No.)
                                 WHERE(Document Type=CONST(Order));
               ReqFilterHeadingML=[DAN=K�bsordre;
                                   ENU=Purchase Order];
               OnPreDataItem=BEGIN
                               Window.OPEN(Text000);
                             END;

               OnAfterGetRecord=VAR
                                  ReservePurchLine@1000 : Codeunit 99000834;
                                  ApprovalsMgmt@1001 : Codeunit 1535;
                                  PostPurchDelete@1002 : Codeunit 364;
                                BEGIN
                                  Window.UPDATE(1,"No.");

                                  AllLinesDeleted := TRUE;
                                  ItemChargeAssgntPurch.RESET;
                                  ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
                                  ItemChargeAssgntPurch.SETRANGE("Document No.","No.");
                                  PurchLine.RESET;
                                  PurchLine.SETRANGE("Document Type","Document Type");
                                  PurchLine.SETRANGE("Document No.","No.");
                                  PurchLine.SETFILTER("Quantity Invoiced",'<>0');
                                  IF PurchLine.FIND('-') THEN BEGIN
                                    PurchLine.SETRANGE("Quantity Invoiced");
                                    PurchLine.SETFILTER("Outstanding Quantity",'<>0');
                                    IF NOT PurchLine.FIND('-') THEN BEGIN
                                      PurchLine.SETRANGE("Outstanding Quantity");
                                      PurchLine.SETFILTER("Qty. Rcd. Not Invoiced",'<>0');
                                      IF NOT PurchLine.FIND('-') THEN BEGIN
                                        PurchLine.LOCKTABLE;
                                        IF NOT PurchLine.FIND('-') THEN BEGIN
                                          PurchLine.SETRANGE("Qty. Rcd. Not Invoiced");
                                          IF PurchLine.FIND('-') THEN
                                            REPEAT
                                              PurchLine.CALCFIELDS("Qty. Assigned");
                                              IF (PurchLine."Qty. Assigned" = PurchLine."Quantity Invoiced") OR
                                                 (PurchLine.Type <> PurchLine.Type::"Charge (Item)")
                                              THEN BEGIN
                                                IF PurchLine.Type = PurchLine.Type::"Charge (Item)" THEN BEGIN
                                                  ItemChargeAssgntPurch.SETRANGE("Document Line No.",PurchLine."Line No.");
                                                  ItemChargeAssgntPurch.DELETEALL;
                                                END;
                                                IF PurchLine.HASLINKS THEN
                                                  PurchLine.DELETELINKS;

                                                OnBeforePurchLineDelete(PurchLine);
                                                PurchLine.DELETE;
                                              END ELSE
                                                AllLinesDeleted := FALSE;
                                              UpdateAssSalesOrder;
                                            UNTIL PurchLine.NEXT = 0;

                                          IF AllLinesDeleted THEN BEGIN
                                            PostPurchDelete.DeleteHeader(
                                              "Purchase Header",PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
                                              ReturnShptHeader,PrepmtPurchInvHeader,PrepmtPurchCrMemoHeader);

                                            ReservePurchLine.DeleteInvoiceSpecFromHeader("Purchase Header");

                                            PurchCommentLine.SETRANGE("Document Type","Document Type");
                                            PurchCommentLine.SETRANGE("No.","No.");
                                            PurchCommentLine.DELETEALL;

                                            WhseRequest.SETRANGE("Source Type",DATABASE::"Purchase Line");
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

               ReqFilterFields=No.,Buy-from Vendor No.,Pay-to Vendor No. }

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
      Text000@1000 : TextConst 'DAN=Genneml�ber k�bsordrer   #1##########;ENU=Processing purch. orders #1##########';
      PurchLine@1001 : Record 39;
      PurchRcptHeader@1011 : Record 120;
      PurchInvHeader@1010 : Record 122;
      PurchCrMemoHeader@1009 : Record 124;
      ReturnShptHeader@1008 : Record 6650;
      PrepmtPurchInvHeader@1014 : Record 122;
      PrepmtPurchCrMemoHeader@1013 : Record 124;
      PurchCommentLine@1002 : Record 43;
      ItemChargeAssgntPurch@1005 : Record 5805;
      WhseRequest@1007 : Record 5765;
      Window@1004 : Dialog;
      AllLinesDeleted@1006 : Boolean;

    LOCAL PROCEDURE UpdateAssSalesOrder@1001();
    VAR
      SalesLine@1001 : Record 37;
    BEGIN
      WITH SalesLine DO
        IF PurchLine."Special Order" THEN
          IF GET(
               "Document Type"::Order,PurchLine."Special Order Sales No.",PurchLine."Special Order Sales Line No.")
          THEN BEGIN
            "Special Order Purchase No." := '';
            "Special Order Purch. Line No." := 0;
            MODIFY;
          END;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePurchLineDelete@1002(VAR PurchLine@1000 : Record 39);
    BEGIN
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

