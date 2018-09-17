OBJECT Codeunit 97 Blanket Purch. Order to Order
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    TableNo=38;
    OnRun=VAR
            Vend@1001 : Record 23;
            PurchCommentLine@1005 : Record 43;
            PrepmtMgt@1003 : Codeunit 441;
            RecordLinkManagement@1004 : Codeunit 447;
            PurchCalcDiscByType@1006 : Codeunit 66;
            ShouldRedistributeInvoiceAmount@1000 : Boolean;
          BEGIN
            TESTFIELD("Document Type","Document Type"::"Blanket Order");
            ShouldRedistributeInvoiceAmount := PurchCalcDiscByType.ShouldRedistributeInvoiceDiscountAmount(Rec);

            Vend.GET("Buy-from Vendor No.");
            Vend.CheckBlockedVendOnDocs(Vend,FALSE);

            IF QtyToReceiveIsZero THEN
              ERROR(Text002);

            PurchSetup.GET;

            CreatePurchHeader(Rec,Vend."Prepayment %");

            PurchBlanketOrderLine.RESET;
            PurchBlanketOrderLine.SETRANGE("Document Type","Document Type");
            PurchBlanketOrderLine.SETRANGE("Document No.","No.");
            IF PurchBlanketOrderLine.FINDSET THEN
              REPEAT
                IF (PurchBlanketOrderLine.Type = PurchBlanketOrderLine.Type::" ") OR
                   (PurchBlanketOrderLine."Qty. to Receive" <> 0)
                THEN BEGIN
                  PurchLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
                  PurchLine.SETRANGE("Blanket Order No.",PurchBlanketOrderLine."Document No.");
                  PurchLine.SETRANGE("Blanket Order Line No.",PurchBlanketOrderLine."Line No.");
                  QuantityOnOrders := 0;
                  IF PurchLine.FINDSET THEN
                    REPEAT
                      IF (PurchLine."Document Type" = PurchLine."Document Type"::"Return Order") OR
                         ((PurchLine."Document Type" = PurchLine."Document Type"::"Credit Memo") AND
                          (PurchLine."Return Shipment No." = ''))
                      THEN
                        QuantityOnOrders := QuantityOnOrders - PurchLine."Outstanding Qty. (Base)"
                      ELSE
                        IF (PurchLine."Document Type" = PurchLine."Document Type"::Order) OR
                           ((PurchLine."Document Type" = PurchLine."Document Type"::Invoice) AND
                            (PurchLine."Receipt No." = ''))
                        THEN
                          QuantityOnOrders := QuantityOnOrders + PurchLine."Outstanding Qty. (Base)";
                    UNTIL PurchLine.NEXT = 0;
                  IF (ABS(PurchBlanketOrderLine."Qty. to Receive (Base)" + QuantityOnOrders +
                        PurchBlanketOrderLine."Qty. Received (Base)") >
                      ABS(PurchBlanketOrderLine."Quantity (Base)")) OR
                     (PurchBlanketOrderLine."Quantity (Base)" * PurchBlanketOrderLine."Outstanding Qty. (Base)" < 0)
                  THEN
                    ERROR(
                      QuantityCheckErr,
                      PurchBlanketOrderLine.FIELDCAPTION("Qty. to Receive (Base)"),
                      PurchBlanketOrderLine.Type,PurchBlanketOrderLine."No.",
                      PurchBlanketOrderLine.FIELDCAPTION("Line No."),PurchBlanketOrderLine."Line No.",
                      PurchBlanketOrderLine."Outstanding Qty. (Base)" - QuantityOnOrders,
                      STRSUBSTNO(
                        Text001,
                        PurchBlanketOrderLine.FIELDCAPTION("Outstanding Qty. (Base)"),
                        PurchBlanketOrderLine.FIELDCAPTION("Qty. to Receive (Base)")),
                      PurchBlanketOrderLine."Outstanding Qty. (Base)",QuantityOnOrders);

                  PurchOrderLine := PurchBlanketOrderLine;
                  ResetQuantityFields(PurchOrderLine);
                  PurchOrderLine."Document Type" := PurchOrderHeader."Document Type";
                  PurchOrderLine."Document No." := PurchOrderHeader."No.";
                  PurchOrderLine."Blanket Order No." := "No.";
                  PurchOrderLine."Blanket Order Line No." := PurchBlanketOrderLine."Line No.";

                  IF (PurchOrderLine."No." <> '') AND (PurchOrderLine.Type <> 0)THEN BEGIN
                    PurchOrderLine.Amount := 0;
                    PurchOrderLine."Amount Including VAT" := 0;
                    PurchOrderLine.VALIDATE(Quantity,PurchBlanketOrderLine."Qty. to Receive");
                    IF PurchBlanketOrderLine."Expected Receipt Date" <> 0D THEN
                      PurchOrderLine.VALIDATE("Expected Receipt Date",PurchBlanketOrderLine."Expected Receipt Date")
                    ELSE
                      PurchOrderLine.VALIDATE("Order Date",PurchOrderHeader."Order Date");
                    PurchOrderLine.VALIDATE("Direct Unit Cost",PurchBlanketOrderLine."Direct Unit Cost");
                    PurchOrderLine.VALIDATE("Line Discount %",PurchBlanketOrderLine."Line Discount %");
                    IF PurchOrderLine.Quantity <> 0 THEN
                      PurchOrderLine.VALIDATE("Inv. Discount Amount",PurchBlanketOrderLine."Inv. Discount Amount");
                    PurchBlanketOrderLine.CALCFIELDS("Reserved Qty. (Base)");
                    IF PurchBlanketOrderLine."Reserved Qty. (Base)" <> 0 THEN
                      ReservePurchLine.TransferPurchLineToPurchLine(
                        PurchBlanketOrderLine,PurchOrderLine,-PurchBlanketOrderLine."Qty. to Receive (Base)");
                  END;

                  IF Vend."Prepayment %" <> 0 THEN
                    PurchOrderLine."Prepayment %" := Vend."Prepayment %";
                  PrepmtMgt.SetPurchPrepaymentPct(PurchOrderLine,PurchOrderHeader."Posting Date");
                  PurchOrderLine.VALIDATE("Prepayment %");

                  PurchOrderLine."Shortcut Dimension 1 Code" := PurchBlanketOrderLine."Shortcut Dimension 1 Code";
                  PurchOrderLine."Shortcut Dimension 2 Code" := PurchBlanketOrderLine."Shortcut Dimension 2 Code";
                  PurchOrderLine."Dimension Set ID" := PurchBlanketOrderLine."Dimension Set ID";
                  PurchOrderLine.DefaultDeferralCode;
                  IF IsPurchOrderLineToBeInserted(PurchOrderLine) THEN BEGIN
                    OnBeforeInsertPurchOrderLine(PurchOrderLine,PurchOrderHeader,PurchBlanketOrderLine,Rec);
                    PurchOrderLine.INSERT;
                    OnAfterPurchOrderLineInsert(PurchOrderLine);
                  END;

                  IF PurchBlanketOrderLine."Qty. to Receive" <> 0 THEN BEGIN
                    PurchBlanketOrderLine.VALIDATE("Qty. to Receive",0);
                    PurchBlanketOrderLine.MODIFY;
                  END;
                END;
              UNTIL PurchBlanketOrderLine.NEXT = 0;

            IF PurchSetup."Default Posting Date" = PurchSetup."Default Posting Date"::"No Date" THEN BEGIN
              PurchOrderHeader."Posting Date" := 0D;
              PurchOrderHeader.MODIFY;
            END;

            IF PurchSetup."Copy Comments Blanket to Order" THEN BEGIN
              PurchCommentLine.CopyComments(
                PurchCommentLine."Document Type"::"Blanket Order",PurchOrderHeader."Document Type","No.",PurchOrderHeader."No.");
              RecordLinkManagement.CopyLinks(Rec,PurchOrderHeader);
            END;

            IF NOT ShouldRedistributeInvoiceAmount THEN
              PurchCalcDiscByType.ResetRecalculateInvoiceDisc(PurchOrderHeader);
            COMMIT;
          END;

  }
  CODE
  {
    VAR
      QuantityCheckErr@1000 : TextConst '@@@="%1: FIELDCAPTION(""Qty. to Receive (Base)""); %2: Field(Type); %3: Field(No.); %4: FIELDCAPTION(""Line No.""); %5: Field(Line No.); %6: Decimal Qty Difference; %7: Text001; %8: Field(Outstanding Qty. (Base)); %9: Decimal Quantity On Orders";DAN="%1 af %2 %3 i %4 %5 kan ikke v�re mere end %6.\%7\%8 - %9 = %6.";ENU="%1 of %2 %3 in %4 %5 cannot be more than %6.\%7\%8 - %9 = %6."';
      Text001@1001 : TextConst 'DAN="%1 - Ikkebogf�rte %1 = Mulige %2";ENU="%1 - Unposted %1 = Possible %2"';
      PurchBlanketOrderLine@1003 : Record 39;
      PurchOrderHeader@1004 : Record 38;
      PurchOrderLine@1005 : Record 39;
      PurchSetup@1008 : Record 312;
      PurchLine@1009 : Record 39;
      ReservePurchLine@1010 : Codeunit 99000834;
      QuantityOnOrders@1012 : Decimal;
      Text002@1002 : TextConst 'DAN=Der er intet at oprette.;ENU=There is nothing to create.';

    LOCAL PROCEDURE CreatePurchHeader@3(PurchHeader@1000 : Record 38;PrepmtPercent@1001 : Decimal);
    BEGIN
      WITH PurchHeader DO BEGIN
        PurchOrderHeader := PurchHeader;
        PurchOrderHeader."Document Type" := PurchOrderHeader."Document Type"::Order;
        PurchOrderHeader."No. Printed" := 0;
        PurchOrderHeader.Status := PurchOrderHeader.Status::Open;
        PurchOrderHeader."No." := '';
        PurchOrderHeader.InitRecord;

        PurchOrderLine.LOCKTABLE;
        PurchOrderHeader.INSERT(TRUE);

        IF "Order Date" = 0D THEN
          PurchOrderHeader."Order Date" := WORKDATE
        ELSE
          PurchOrderHeader."Order Date" := "Order Date";
        IF "Posting Date" <> 0D THEN
          PurchOrderHeader."Posting Date" := "Posting Date";
        IF PurchOrderHeader."Posting Date" = 0D THEN
          PurchOrderHeader."Posting Date" := WORKDATE;

        PurchOrderHeader.InitFromPurchHeader(PurchHeader);
        PurchOrderHeader.VALIDATE("Posting Date");

        PurchOrderHeader."Prepayment %" := PrepmtPercent;
        OnBeforeInsertPurchOrderHeader(PurchOrderHeader,PurchHeader);
        PurchOrderHeader.MODIFY;
      END;
    END;

    LOCAL PROCEDURE ResetQuantityFields@1(VAR TempPurchLine@1000 : Record 39);
    BEGIN
      TempPurchLine.Quantity := 0;
      TempPurchLine."Quantity (Base)" := 0;
      TempPurchLine."Qty. Rcd. Not Invoiced" := 0;
      TempPurchLine."Quantity Received" := 0;
      TempPurchLine."Quantity Invoiced" := 0;
      TempPurchLine."Qty. Rcd. Not Invoiced (Base)" := 0;
      TempPurchLine."Qty. Received (Base)" := 0;
      TempPurchLine."Qty. Invoiced (Base)" := 0;
    END;

    [External]
    PROCEDURE GetPurchOrderHeader@2(VAR PurchHeader@1000 : Record 38);
    BEGIN
      PurchHeader := PurchOrderHeader;
    END;

    LOCAL PROCEDURE IsPurchOrderLineToBeInserted@4(PurchOrderLine@1000 : Record 39) : Boolean;
    VAR
      AttachedToPurchaseLine@1001 : Record 39;
    BEGIN
      IF PurchOrderLine."Attached to Line No." = 0 THEN
        EXIT(TRUE);
      EXIT(
        AttachedToPurchaseLine.GET(
          PurchOrderLine."Document Type",PurchOrderLine."Document No.",PurchOrderLine."Attached to Line No."));
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPurchOrderLineInsert@8(VAR PurchaseLine@1000 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertPurchOrderHeader@6(VAR PurchOrderHeader@1000 : Record 38;BlanketOrderPurchHeader@1001 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertPurchOrderLine@7(VAR PurchOrderLine@1000 : Record 39;PurchOrderHeader@1001 : Record 38;BlanketOrderPurchLine@1002 : Record 39;BlanketOrderPurchHeader@1003 : Record 38);
    BEGIN
    END;

    BEGIN
    END.
  }
}

