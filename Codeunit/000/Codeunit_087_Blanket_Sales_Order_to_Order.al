OBJECT Codeunit 87 Blanket Sales Order to Order
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    TableNo=36;
    OnRun=VAR
            Cust@1001 : Record 18;
            TempSalesLine@1002 : TEMPORARY Record 37;
            SalesCommentLine@1011 : Record 44;
            ATOLink@1000 : Record 904;
            Resource@1007 : Record 156;
            PrepmtMgt@1004 : Codeunit 441;
            RecordLinkManagement@1009 : Codeunit 447;
            SalesCalcDiscountByType@1003 : Codeunit 56;
            SalesLineReserve@1010 : Codeunit 99000832;
            Reservation@1005 : Page 498;
            ShouldRedistributeInvoiceAmount@1006 : Boolean;
            CreditLimitExceeded@1008 : Boolean;
          BEGIN
            TESTFIELD("Document Type","Document Type"::"Blanket Order");
            ShouldRedistributeInvoiceAmount := SalesCalcDiscountByType.ShouldRedistributeInvoiceDiscountAmount(Rec);

            Cust.GET("Sell-to Customer No.");
            Cust.CheckBlockedCustOnDocs(Cust,"Document Type"::Order,TRUE,FALSE);

            ValidateSalesPersonOnSalesHeader(Rec,TRUE,FALSE);

            IF QtyToShipIsZero THEN
              ERROR(Text002);

            SalesSetup.GET;

            CheckAvailability(Rec);

            CreditLimitExceeded := CreateSalesHeader(Rec,Cust."Prepayment %");

            BlanketOrderSalesLine.RESET;
            BlanketOrderSalesLine.SETRANGE("Document Type","Document Type");
            BlanketOrderSalesLine.SETRANGE("Document No.","No.");
            IF BlanketOrderSalesLine.FINDSET THEN BEGIN
              TempSalesLine.DELETEALL;
              REPEAT
                IF BlanketOrderSalesLine.Type = BlanketOrderSalesLine.Type::Resource THEN
                  IF BlanketOrderSalesLine."No." <> '' THEN
                    IF Resource.GET(BlanketOrderSalesLine."No.") THEN BEGIN
                      Resource.CheckResourcePrivacyBlocked(FALSE);
                      Resource.TESTFIELD(Blocked,FALSE);
                    END;
                IF (BlanketOrderSalesLine.Type = BlanketOrderSalesLine.Type::" ") OR (BlanketOrderSalesLine."Qty. to Ship" <> 0) THEN BEGIN
                  SalesLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
                  SalesLine.SETRANGE("Blanket Order No.",BlanketOrderSalesLine."Document No.");
                  SalesLine.SETRANGE("Blanket Order Line No.",BlanketOrderSalesLine."Line No.");
                  QuantityOnOrders := 0;
                  IF SalesLine.FINDSET THEN
                    REPEAT
                      IF (SalesLine."Document Type" = SalesLine."Document Type"::"Return Order") OR
                         ((SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo") AND
                          (SalesLine."Return Receipt No." = ''))
                      THEN
                        QuantityOnOrders := QuantityOnOrders - SalesLine."Outstanding Qty. (Base)"
                      ELSE
                        IF (SalesLine."Document Type" = SalesLine."Document Type"::Order) OR
                           ((SalesLine."Document Type" = SalesLine."Document Type"::Invoice) AND
                            (SalesLine."Shipment No." = ''))
                        THEN
                          QuantityOnOrders := QuantityOnOrders + SalesLine."Outstanding Qty. (Base)";
                    UNTIL SalesLine.NEXT = 0;
                  IF (ABS(BlanketOrderSalesLine."Qty. to Ship (Base)" + QuantityOnOrders +
                        BlanketOrderSalesLine."Qty. Shipped (Base)") >
                      ABS(BlanketOrderSalesLine."Quantity (Base)")) OR
                     (BlanketOrderSalesLine."Quantity (Base)" * BlanketOrderSalesLine."Outstanding Qty. (Base)" < 0)
                  THEN
                    ERROR(
                      QuantityCheckErr,
                      BlanketOrderSalesLine.FIELDCAPTION("Qty. to Ship (Base)"),
                      BlanketOrderSalesLine.Type,BlanketOrderSalesLine."No.",
                      BlanketOrderSalesLine.FIELDCAPTION("Line No."),BlanketOrderSalesLine."Line No.",
                      BlanketOrderSalesLine."Outstanding Qty. (Base)" - QuantityOnOrders,
                      STRSUBSTNO(
                        Text001,
                        BlanketOrderSalesLine.FIELDCAPTION("Outstanding Qty. (Base)"),
                        BlanketOrderSalesLine.FIELDCAPTION("Qty. to Ship (Base)")),
                      BlanketOrderSalesLine."Outstanding Qty. (Base)",QuantityOnOrders);
                  SalesOrderLine := BlanketOrderSalesLine;
                  ResetQuantityFields(SalesOrderLine);
                  SalesOrderLine."Document Type" := SalesOrderHeader."Document Type";
                  SalesOrderLine."Document No." := SalesOrderHeader."No.";
                  SalesOrderLine."Blanket Order No." := "No.";
                  SalesOrderLine."Blanket Order Line No." := BlanketOrderSalesLine."Line No.";
                  IF (SalesOrderLine."No." <> '') AND (SalesOrderLine.Type <> 0) THEN BEGIN
                    SalesOrderLine.Amount := 0;
                    SalesOrderLine."Amount Including VAT" := 0;
                    SalesOrderLine.VALIDATE(Quantity,BlanketOrderSalesLine."Qty. to Ship");
                    SalesOrderLine.VALIDATE("Shipment Date",BlanketOrderSalesLine."Shipment Date");
                    SalesOrderLine.VALIDATE("Unit Price",BlanketOrderSalesLine."Unit Price");
                    SalesOrderLine."Allow Invoice Disc." := BlanketOrderSalesLine."Allow Invoice Disc.";
                    SalesOrderLine."Allow Line Disc." := BlanketOrderSalesLine."Allow Line Disc.";
                    SalesOrderLine.VALIDATE("Line Discount %",BlanketOrderSalesLine."Line Discount %");
                    IF SalesOrderLine.Quantity <> 0 THEN
                      SalesOrderLine.VALIDATE("Inv. Discount Amount",BlanketOrderSalesLine."Inv. Discount Amount");
                    SalesLineReserve.TransferSaleLineToSalesLine(
                      BlanketOrderSalesLine,SalesOrderLine,BlanketOrderSalesLine."Outstanding Qty. (Base)");
                  END;

                  IF Cust."Prepayment %" <> 0 THEN
                    SalesOrderLine."Prepayment %" := Cust."Prepayment %";
                  PrepmtMgt.SetSalesPrepaymentPct(SalesOrderLine,SalesOrderHeader."Posting Date");
                  SalesOrderLine.VALIDATE("Prepayment %");

                  SalesOrderLine."Shortcut Dimension 1 Code" := BlanketOrderSalesLine."Shortcut Dimension 1 Code";
                  SalesOrderLine."Shortcut Dimension 2 Code" := BlanketOrderSalesLine."Shortcut Dimension 2 Code";
                  SalesOrderLine."Dimension Set ID" := BlanketOrderSalesLine."Dimension Set ID";
                  IF ATOLink.AsmExistsForSalesLine(BlanketOrderSalesLine) THEN BEGIN
                    SalesOrderLine."Qty. to Assemble to Order" := SalesOrderLine.Quantity;
                    SalesOrderLine."Qty. to Asm. to Order (Base)" := SalesOrderLine."Quantity (Base)";
                  END;
                  SalesOrderLine.DefaultDeferralCode;
                  IF IsSalesOrderLineToBeInserted(SalesOrderLine) THEN BEGIN
                    OnBeforeInsertSalesOrderLine(SalesOrderLine,SalesOrderHeader,BlanketOrderSalesLine,Rec);
                    SalesOrderLine.INSERT;
                    OnAfterInsertSalesOrderLine(SalesOrderLine,SalesOrderHeader,BlanketOrderSalesLine,Rec);
                  END;

                  IF ATOLink.AsmExistsForSalesLine(BlanketOrderSalesLine) THEN
                    ATOLink.MakeAsmOrderLinkedToSalesOrderLine(BlanketOrderSalesLine,SalesOrderLine);

                  IF BlanketOrderSalesLine."Qty. to Ship" <> 0 THEN BEGIN
                    BlanketOrderSalesLine.VALIDATE("Qty. to Ship",0);
                    BlanketOrderSalesLine.MODIFY;
                    AutoReserve(SalesOrderLine,TempSalesLine);
                  END;
                END;
              UNTIL BlanketOrderSalesLine.NEXT = 0;
            END;

            OnAfterInsertAllSalesOrderLines(Rec,SalesOrderHeader);

            IF SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" THEN BEGIN
              SalesOrderHeader."Posting Date" := 0D;
              SalesOrderHeader.MODIFY;
            END;

            IF SalesSetup."Copy Comments Blanket to Order" THEN BEGIN
              SalesCommentLine.CopyComments(
                SalesCommentLine."Document Type"::"Blanket Order",SalesOrderHeader."Document Type","No.",SalesOrderHeader."No.");
              RecordLinkManagement.CopyLinks(Rec,SalesOrderHeader);
            END;

            IF NOT ShouldRedistributeInvoiceAmount THEN
              SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(SalesOrderHeader);

            IF (NOT HideValidationDialog) AND (NOT CreditLimitExceeded) THEN
              CustCheckCreditLimit.BlanketSalesOrderToOrderCheck(SalesOrderHeader);

            COMMIT;

            IF TempSalesLine.FIND('-') THEN
              IF CONFIRM(Text003,TRUE) THEN
                REPEAT
                  CLEAR(Reservation);
                  Reservation.SetSalesLine(TempSalesLine);
                  Reservation.RUNMODAL;
                  FIND;
                UNTIL TempSalesLine.NEXT = 0;

            CLEAR(CustCheckCreditLimit);
            CLEAR(ItemCheckAvail);
          END;

  }
  CODE
  {
    VAR
      QuantityCheckErr@1000 : TextConst '@@@="%1: FIELDCAPTION(""Qty. to Ship (Base)""); %2: Field(Type); %3: Field(No.); %4: FIELDCAPTION(""Line No.""); %5: Field(Line No.); %6: Decimal Qty Difference; %7: Text001; %8: Field(Outstanding Qty. (Base)); %9: Decimal Quantity On Orders";DAN="%1 af %2 %3 i %4 %5 kan ikke v�re mere end %6.\%7\%8 - %9 = %6.";ENU="%1 of %2 %3 in %4 %5 cannot be more than %6.\%7\%8 - %9 = %6."';
      Text001@1001 : TextConst 'DAN="%1 - Ikkebogf�rte %1 = Mulige %2";ENU="%1 - Unposted %1 = Possible %2"';
      BlanketOrderSalesLine@1003 : Record 37;
      SalesLine@1004 : Record 37;
      SalesOrderHeader@1005 : Record 36;
      SalesOrderLine@1006 : Record 37;
      SalesSetup@1009 : Record 311;
      CustCheckCreditLimit@1010 : Codeunit 312;
      ItemCheckAvail@1011 : Codeunit 311;
      HideValidationDialog@1014 : Boolean;
      QuantityOnOrders@1015 : Decimal;
      Text002@1002 : TextConst 'DAN=Der er intet at oprette.;ENU=There is nothing to create.';
      Text003@1017 : TextConst 'DAN=Fuldautomatisk reservation er ikke mulig.\Vil du reservere varerne manuelt?;ENU=Full automatic reservation was not possible.\Reserve items manually?';

    LOCAL PROCEDURE CreateSalesHeader@4(SalesHeader@1000 : Record 36;PrepmtPercent@1001 : Decimal) CreditLimitExceeded : Boolean;
    BEGIN
      WITH SalesHeader DO BEGIN
        SalesOrderHeader := SalesHeader;
        SalesOrderHeader."Document Type" := SalesOrderHeader."Document Type"::Order;
        IF NOT HideValidationDialog THEN
          CreditLimitExceeded := CustCheckCreditLimit.SalesHeaderCheck(SalesOrderHeader);

        SalesOrderHeader."No. Printed" := 0;
        SalesOrderHeader.Status := SalesOrderHeader.Status::Open;
        SalesOrderHeader."No." := '';

        SalesOrderLine.LOCKTABLE;
        OnBeforeInsertSalesOrderHeader(SalesOrderHeader,SalesHeader);
        SalesOrderHeader.INSERT(TRUE);

        IF "Order Date" = 0D THEN
          SalesOrderHeader."Order Date" := WORKDATE
        ELSE
          SalesOrderHeader."Order Date" := "Order Date";
        IF "Posting Date" <> 0D THEN
          SalesOrderHeader."Posting Date" := "Posting Date";
        IF SalesOrderHeader."Posting Date" = 0D THEN
          SalesOrderHeader."Posting Date" := WORKDATE;

        SalesOrderHeader.InitFromSalesHeader(SalesHeader);
        SalesOrderHeader.VALIDATE("Posting Date");
        SalesOrderHeader."Outbound Whse. Handling Time" := "Outbound Whse. Handling Time";
        SalesOrderHeader.Reserve := Reserve;

        SalesOrderHeader."Prepayment %" := PrepmtPercent;

        OnBeforeSalesOrderHeaderModify(SalesOrderHeader,SalesHeader);
        SalesOrderHeader.MODIFY;
      END;
    END;

    LOCAL PROCEDURE ResetQuantityFields@1(VAR TempSalesLine@1000 : Record 37);
    BEGIN
      TempSalesLine.Quantity := 0;
      TempSalesLine."Quantity (Base)" := 0;
      TempSalesLine."Qty. Shipped Not Invoiced" := 0;
      TempSalesLine."Quantity Shipped" := 0;
      TempSalesLine."Quantity Invoiced" := 0;
      TempSalesLine."Qty. Shipped Not Invd. (Base)" := 0;
      TempSalesLine."Qty. Shipped (Base)" := 0;
      TempSalesLine."Qty. Invoiced (Base)" := 0;
      TempSalesLine."Outstanding Quantity" := 0;
      TempSalesLine."Outstanding Qty. (Base)" := 0;
    END;

    [External]
    PROCEDURE GetSalesOrderHeader@2(VAR SalesHeader@1000 : Record 36);
    BEGIN
      SalesHeader := SalesOrderHeader;
    END;

    [External]
    PROCEDURE SetHideValidationDialog@14(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    LOCAL PROCEDURE AutoReserve@11(VAR SalesLine@1000 : Record 37;VAR TempSalesLine@1003 : TEMPORARY Record 37);
    VAR
      ReservMgt@1001 : Codeunit 99000845;
      FullAutoReservation@1002 : Boolean;
    BEGIN
      WITH SalesLine DO
        IF (Type = Type::Item) AND
           (Reserve = Reserve::Always) AND
           ("No." <> '')
        THEN BEGIN
          TESTFIELD("Shipment Date");
          ReservMgt.SetSalesLine(SalesLine);
          ReservMgt.AutoReserve(FullAutoReservation,'',"Shipment Date","Qty. to Ship","Qty. to Ship (Base)");
          FIND;
          IF NOT FullAutoReservation THEN BEGIN
            TempSalesLine.TRANSFERFIELDS(SalesLine);
            TempSalesLine.INSERT;
          END;
        END;
    END;

    LOCAL PROCEDURE CheckAvailability@3(BlanketOrderSalesHeader@1000 : Record 36);
    VAR
      ATOLink@1001 : Record 904;
    BEGIN
      WITH BlanketOrderSalesLine DO BEGIN
        SETRANGE("Document Type",BlanketOrderSalesHeader."Document Type");
        SETRANGE("Document No.",BlanketOrderSalesHeader."No.");
        SETRANGE(Type,Type::Item);
        SETFILTER("No.",'<>%1','');
        IF FINDSET THEN
          REPEAT
            IF "Qty. to Ship" > 0 THEN BEGIN
              SalesLine := BlanketOrderSalesLine;
              ResetQuantityFields(SalesLine);
              SalesLine.Quantity := "Qty. to Ship";
              SalesLine."Quantity (Base)" := ROUND(SalesLine.Quantity * SalesLine."Qty. per Unit of Measure",0.00001);
              SalesLine."Qty. to Ship" := SalesLine.Quantity;
              SalesLine."Qty. to Ship (Base)" := SalesLine."Quantity (Base)";
              SalesLine.InitOutstanding;
              IF ATOLink.AsmExistsForSalesLine(BlanketOrderSalesLine) THEN BEGIN
                SalesLine."Qty. to Assemble to Order" := SalesLine.Quantity;
                SalesLine."Qty. to Asm. to Order (Base)" := SalesLine."Quantity (Base)";
                SalesLine."Outstanding Quantity" -= SalesLine."Qty. to Assemble to Order";
                SalesLine."Outstanding Qty. (Base)" -= SalesLine."Qty. to Asm. to Order (Base)";
              END;
              IF SalesLine.Reserve <> SalesLine.Reserve::Always THEN
                IF NOT HideValidationDialog THEN
                  IF ItemCheckAvail.SalesLineCheck(SalesLine) THEN
                    ItemCheckAvail.RaiseUpdateInterruptedError;
            END;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE IsSalesOrderLineToBeInserted@5(SalesOrderLine@1000 : Record 37) : Boolean;
    VAR
      AttachedToSalesLine@1001 : Record 37;
    BEGIN
      IF SalesOrderLine."Attached to Line No." = 0 THEN
        EXIT(TRUE);
      EXIT(
        AttachedToSalesLine.GET(
          SalesOrderLine."Document Type",SalesOrderLine."Document No.",SalesOrderLine."Attached to Line No."));
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertSalesOrderHeader@6(VAR SalesOrderHeader@1000 : Record 36;BlanketOrderSalesHeader@1001 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertSalesOrderLine@8(VAR SalesOrderLine@1000 : Record 37;SalesOrderHeader@1001 : Record 36;BlanketOrderSalesLine@1002 : Record 37;BlanketOrderSalesHeader@1003 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertSalesOrderLine@7(VAR SalesOrderLine@1000 : Record 37;SalesOrderHeader@1001 : Record 36;BlanketOrderSalesLine@1002 : Record 37;BlanketOrderSalesHeader@1003 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertAllSalesOrderLines@10(BlanketOrderSalesHeader@1000 : Record 36;OrderSalesHeader@1001 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeSalesOrderHeaderModify@9(VAR SalesOrderHeader@1000 : Record 36;BlanketOrderSalesHeader@1001 : Record 36);
    BEGIN
    END;

    BEGIN
    END.
  }
}

