OBJECT Codeunit 5805 Item Charge Assgnt. (Purch.)
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    Permissions=TableData 38=r,
                TableData 39=r,
                TableData 121=r,
                TableData 5805=imd,
                TableData 6651=r;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Ligeligt,Efter bel�b,Efter v�gt,Efter volumen;ENU=Equally,By Amount,By Weight,By Volume';
      SuggestItemChargeMsg@1001 : TextConst 'DAN=V�lg, hvordan det tildelte varegebyr skal fordeles, n�r bilaget indeholder mere end �n linje af typen Vare.;ENU=Select how to distribute the assigned item charge when the document has more than one line of type Item.';

    [External]
    PROCEDURE InsertItemChargeAssgnt@1(ItemChargeAssgntPurch@1000 : Record 5805;ApplToDocType@1001 : Option;ApplToDocNo2@1002 : Code[20];ApplToDocLineNo2@1003 : Integer;ItemNo2@1004 : Code[20];Description2@1005 : Text[50];VAR NextLineNo@1006 : Integer);
    BEGIN
      InsertItemChargeAssgntWithAssignValues(
        ItemChargeAssgntPurch,ApplToDocType,ApplToDocNo2,ApplToDocLineNo2,ItemNo2,Description2,0,0,NextLineNo);
    END;

    PROCEDURE InsertItemChargeAssgntWithAssignValues@19(FromItemChargeAssgntPurch@1000 : Record 5805;ApplToDocType@1001 : Option;FromApplToDocNo@1002 : Code[20];FromApplToDocLineNo@1003 : Integer;FromItemNo@1004 : Code[20];FromDescription@1005 : Text[50];QtyToAssign@1008 : Decimal;AmountToAssign@1009 : Decimal;VAR NextLineNo@1006 : Integer);
    VAR
      ItemChargeAssgntPurch@1007 : Record 5805;
    BEGIN
      NextLineNo := NextLineNo + 10000;

      // TODO: try to use InsertPurchChargeAssignLine from COD103492 if possibile
      ItemChargeAssgntPurch."Document No." := FromItemChargeAssgntPurch."Document No.";
      ItemChargeAssgntPurch."Document Type" := FromItemChargeAssgntPurch."Document Type";
      ItemChargeAssgntPurch."Document Line No." := FromItemChargeAssgntPurch."Document Line No.";
      ItemChargeAssgntPurch."Item Charge No." := FromItemChargeAssgntPurch."Item Charge No.";
      ItemChargeAssgntPurch."Line No." := NextLineNo;
      ItemChargeAssgntPurch."Applies-to Doc. No." := FromApplToDocNo;
      ItemChargeAssgntPurch."Applies-to Doc. Type" := ApplToDocType;
      ItemChargeAssgntPurch."Applies-to Doc. Line No." := FromApplToDocLineNo;
      ItemChargeAssgntPurch."Item No." := FromItemNo;
      ItemChargeAssgntPurch.Description := FromDescription;
      ItemChargeAssgntPurch."Unit Cost" := FromItemChargeAssgntPurch."Unit Cost";
      IF QtyToAssign <> 0 THEN BEGIN
        ItemChargeAssgntPurch."Amount to Assign" := AmountToAssign;
        ItemChargeAssgntPurch.VALIDATE("Qty. to Assign",QtyToAssign);
      END;
      ItemChargeAssgntPurch.INSERT;
    END;

    [External]
    PROCEDURE CreateDocChargeAssgnt@2(LastItemChargeAssgntPurch@1000 : Record 5805;ReceiptNo@1001 : Code[20]);
    VAR
      FromPurchLine@1002 : Record 39;
      ItemChargeAssgntPurch@1003 : Record 5805;
      NextLineNo@1004 : Integer;
    BEGIN
      WITH LastItemChargeAssgntPurch DO BEGIN
        FromPurchLine.SETRANGE("Document Type","Document Type");
        FromPurchLine.SETRANGE("Document No.","Document No.");
        FromPurchLine.SETRANGE(Type,FromPurchLine.Type::Item);
        IF FromPurchLine.FIND('-') THEN BEGIN
          NextLineNo := "Line No.";
          ItemChargeAssgntPurch.RESET;
          ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
          ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
          ItemChargeAssgntPurch.SETRANGE("Document Line No.","Document Line No.");
          ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.","Document No.");
          REPEAT
            IF (FromPurchLine.Quantity <> 0) AND
               (FromPurchLine.Quantity <> FromPurchLine."Quantity Invoiced") AND
               (FromPurchLine."Work Center No." = '') AND
               ((ReceiptNo = '') OR (FromPurchLine."Receipt No." = ReceiptNo)) AND
               FromPurchLine."Allow Item Charge Assignment"
            THEN BEGIN
              ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.",FromPurchLine."Line No.");
              IF NOT ItemChargeAssgntPurch.FINDFIRST THEN
                InsertItemChargeAssgnt(
                  LastItemChargeAssgntPurch,FromPurchLine."Document Type",
                  FromPurchLine."Document No.",FromPurchLine."Line No.",
                  FromPurchLine."No.",FromPurchLine.Description,NextLineNo);
            END;
          UNTIL FromPurchLine.NEXT = 0;
        END;
      END;

      OnAfterCreateDocChargeAssgnt(LastItemChargeAssgntPurch,ReceiptNo);
    END;

    [External]
    PROCEDURE CreateRcptChargeAssgnt@3(VAR FromPurchRcptLine@1000 : Record 121;ItemChargeAssgntPurch@1001 : Record 5805);
    VAR
      ItemChargeAssgntPurch2@1002 : Record 5805;
      NextLine@1003 : Integer;
    BEGIN
      FromPurchRcptLine.TESTFIELD("Work Center No.",'');
      NextLine := ItemChargeAssgntPurch."Line No.";
      ItemChargeAssgntPurch2.SETRANGE("Document Type",ItemChargeAssgntPurch."Document Type");
      ItemChargeAssgntPurch2.SETRANGE("Document No.",ItemChargeAssgntPurch."Document No.");
      ItemChargeAssgntPurch2.SETRANGE("Document Line No.",ItemChargeAssgntPurch."Document Line No.");
      ItemChargeAssgntPurch2.SETRANGE(
        "Applies-to Doc. Type",ItemChargeAssgntPurch2."Applies-to Doc. Type"::Receipt);
      REPEAT
        ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. No.",FromPurchRcptLine."Document No.");
        ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. Line No.",FromPurchRcptLine."Line No.");
        IF NOT ItemChargeAssgntPurch2.FINDFIRST THEN
          InsertItemChargeAssgnt(ItemChargeAssgntPurch,ItemChargeAssgntPurch2."Applies-to Doc. Type"::Receipt,
            FromPurchRcptLine."Document No.",FromPurchRcptLine."Line No.",
            FromPurchRcptLine."No.",FromPurchRcptLine.Description,NextLine);
      UNTIL FromPurchRcptLine.NEXT = 0;
    END;

    [External]
    PROCEDURE CreateTransferRcptChargeAssgnt@4(VAR FromTransRcptLine@1000 : Record 5747;ItemChargeAssgntPurch@1001 : Record 5805);
    VAR
      ItemChargeAssgntPurch2@1002 : Record 5805;
      NextLine@1003 : Integer;
    BEGIN
      NextLine := ItemChargeAssgntPurch."Line No.";
      ItemChargeAssgntPurch2.SETRANGE("Document Type",ItemChargeAssgntPurch."Document Type");
      ItemChargeAssgntPurch2.SETRANGE("Document No.",ItemChargeAssgntPurch."Document No.");
      ItemChargeAssgntPurch2.SETRANGE("Document Line No.",ItemChargeAssgntPurch."Document Line No.");
      ItemChargeAssgntPurch2.SETRANGE(
        "Applies-to Doc. Type",ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Transfer Receipt");
      REPEAT
        ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. No.",FromTransRcptLine."Document No.");
        ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. Line No.",FromTransRcptLine."Line No.");
        IF NOT ItemChargeAssgntPurch2.FINDFIRST THEN
          InsertItemChargeAssgnt(ItemChargeAssgntPurch,ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Transfer Receipt",
            FromTransRcptLine."Document No.",FromTransRcptLine."Line No.",
            FromTransRcptLine."Item No.",FromTransRcptLine.Description,NextLine);
      UNTIL FromTransRcptLine.NEXT = 0;
    END;

    [External]
    PROCEDURE CreateShptChargeAssgnt@6(VAR FromReturnShptLine@1000 : Record 6651;ItemChargeAssgntPurch@1001 : Record 5805);
    VAR
      ItemChargeAssgntPurch2@1002 : Record 5805;
      NextLine@1003 : Integer;
    BEGIN
      FromReturnShptLine.TESTFIELD("Job No.",'');
      NextLine := ItemChargeAssgntPurch."Line No.";
      ItemChargeAssgntPurch2.SETRANGE("Document Type",ItemChargeAssgntPurch."Document Type");
      ItemChargeAssgntPurch2.SETRANGE("Document No.",ItemChargeAssgntPurch."Document No.");
      ItemChargeAssgntPurch2.SETRANGE("Document Line No.",ItemChargeAssgntPurch."Document Line No.");
      ItemChargeAssgntPurch2.SETRANGE(
        "Applies-to Doc. Type",ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Return Shipment");
      REPEAT
        ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. No.",FromReturnShptLine."Document No.");
        ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. Line No.",FromReturnShptLine."Line No.");
        IF NOT ItemChargeAssgntPurch2.FINDFIRST THEN
          InsertItemChargeAssgnt(ItemChargeAssgntPurch,ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Return Shipment",
            FromReturnShptLine."Document No.",FromReturnShptLine."Line No.",
            FromReturnShptLine."No.",FromReturnShptLine.Description,NextLine);
      UNTIL FromReturnShptLine.NEXT = 0;
    END;

    [External]
    PROCEDURE CreateSalesShptChargeAssgnt@8(VAR FromSalesShptLine@1000 : Record 111;ItemChargeAssgntPurch@1001 : Record 5805);
    VAR
      ItemChargeAssgntPurch2@1002 : Record 5805;
      NextLine@1003 : Integer;
    BEGIN
      FromSalesShptLine.TESTFIELD("Job No.",'');
      NextLine := ItemChargeAssgntPurch."Line No.";
      ItemChargeAssgntPurch2.SETRANGE("Document Type",ItemChargeAssgntPurch."Document Type");
      ItemChargeAssgntPurch2.SETRANGE("Document No.",ItemChargeAssgntPurch."Document No.");
      ItemChargeAssgntPurch2.SETRANGE("Document Line No.",ItemChargeAssgntPurch."Document Line No.");
      ItemChargeAssgntPurch2.SETRANGE(
        "Applies-to Doc. Type",ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Sales Shipment");
      REPEAT
        ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. No.",FromSalesShptLine."Document No.");
        ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. Line No.",FromSalesShptLine."Line No.");
        IF NOT ItemChargeAssgntPurch2.FINDFIRST THEN
          InsertItemChargeAssgnt(ItemChargeAssgntPurch,ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Sales Shipment",
            FromSalesShptLine."Document No.",FromSalesShptLine."Line No.",
            FromSalesShptLine."No.",FromSalesShptLine.Description,NextLine);
      UNTIL FromSalesShptLine.NEXT = 0;
    END;

    [External]
    PROCEDURE CreateReturnRcptChargeAssgnt@7(VAR FromReturnRcptLine@1000 : Record 6661;ItemChargeAssgntPurch@1001 : Record 5805);
    VAR
      ItemChargeAssgntPurch2@1002 : Record 5805;
      NextLine@1003 : Integer;
    BEGIN
      FromReturnRcptLine.TESTFIELD("Job No.",'');
      NextLine := ItemChargeAssgntPurch."Line No.";
      ItemChargeAssgntPurch2.SETRANGE("Document Type",ItemChargeAssgntPurch."Document Type");
      ItemChargeAssgntPurch2.SETRANGE("Document No.",ItemChargeAssgntPurch."Document No.");
      ItemChargeAssgntPurch2.SETRANGE("Document Line No.",ItemChargeAssgntPurch."Document Line No.");
      ItemChargeAssgntPurch2.SETRANGE(
        "Applies-to Doc. Type",ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Return Receipt");
      REPEAT
        ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. No.",FromReturnRcptLine."Document No.");
        ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. Line No.",FromReturnRcptLine."Line No.");
        IF NOT ItemChargeAssgntPurch2.FINDFIRST THEN
          InsertItemChargeAssgnt(ItemChargeAssgntPurch,ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Return Receipt",
            FromReturnRcptLine."Document No.",FromReturnRcptLine."Line No.",
            FromReturnRcptLine."No.",FromReturnRcptLine.Description,NextLine);
      UNTIL FromReturnRcptLine.NEXT = 0;
    END;

    [Internal]
    PROCEDURE SuggestAssgnt@5(PurchLine@1000 : Record 39;TotalQtyToAssign@1001 : Decimal;TotalAmtToAssign@1003 : Decimal);
    VAR
      ItemChargeAssgntPurch@1004 : Record 5805;
      Selection@1002 : Integer;
    BEGIN
      WITH PurchLine DO BEGIN
        TESTFIELD("Qty. to Invoice");
        ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
        ItemChargeAssgntPurch.SETRANGE("Document Line No.","Line No.");
      END;
      IF ItemChargeAssgntPurch.ISEMPTY THEN
        EXIT;

      ItemChargeAssgntPurch.SETFILTER("Applies-to Doc. Type",'<>%1',ItemChargeAssgntPurch."Applies-to Doc. Type"::"Transfer Receipt");

      Selection := 1;
      IF ItemChargeAssgntPurch.COUNT > 1 THEN
        Selection := STRMENU(Text000,2,SuggestItemChargeMsg);

      IF Selection = 0 THEN
        EXIT;

      SuggestAssgnt2(PurchLine,TotalQtyToAssign,TotalAmtToAssign,Selection);
    END;

    [External]
    PROCEDURE SuggestAssgnt2@9(PurchLine@1000 : Record 39;TotalQtyToAssign@1001 : Decimal;TotalAmtToAssign@1021 : Decimal;Selection@1018 : Integer);
    VAR
      Currency@1014 : Record 4;
      PurchHeader@1003 : Record 38;
      ItemChargeAssgntPurch@1007 : Record 5805;
    BEGIN
      PurchLine.TESTFIELD("Qty. to Invoice");
      PurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.");

      IF NOT Currency.GET(PurchHeader."Currency Code") THEN
        Currency.InitRoundingPrecision;

      ItemChargeAssgntPurch.SETRANGE("Document Type",PurchLine."Document Type");
      ItemChargeAssgntPurch.SETRANGE("Document No.",PurchLine."Document No.");
      ItemChargeAssgntPurch.SETRANGE("Document Line No.",PurchLine."Line No.");
      IF ItemChargeAssgntPurch.FINDFIRST THEN
        CASE Selection OF
          1:
            AssignEqually(ItemChargeAssgntPurch,Currency,TotalQtyToAssign,TotalAmtToAssign);
          2:
            AssignByAmount(ItemChargeAssgntPurch,Currency,PurchHeader,TotalQtyToAssign,TotalAmtToAssign);
          3:
            AssignByWeight(ItemChargeAssgntPurch,Currency,TotalQtyToAssign);
          4:
            AssignByVolume(ItemChargeAssgntPurch,Currency,TotalQtyToAssign);
        END;
    END;

    LOCAL PROCEDURE AssignEqually@26(VAR ItemChargeAssgntPurch@1000 : Record 5805;Currency@1003 : Record 4;TotalQtyToAssign@1005 : Decimal;TotalAmtToAssign@1004 : Decimal);
    VAR
      TempItemChargeAssgntPurch@1001 : TEMPORARY Record 5805;
      RemainingNumOfLines@1002 : Integer;
    BEGIN
      REPEAT
        IF NOT ItemChargeAssgntPurch.PurchLineInvoiced THEN BEGIN
          TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
          TempItemChargeAssgntPurch.INSERT;
        END;
      UNTIL ItemChargeAssgntPurch.NEXT = 0;

      IF TempItemChargeAssgntPurch.FINDSET(TRUE) THEN BEGIN
        RemainingNumOfLines := TempItemChargeAssgntPurch.COUNT;
        REPEAT
          ItemChargeAssgntPurch.GET(
            TempItemChargeAssgntPurch."Document Type",
            TempItemChargeAssgntPurch."Document No.",
            TempItemChargeAssgntPurch."Document Line No.",
            TempItemChargeAssgntPurch."Line No.");
          ItemChargeAssgntPurch."Qty. to Assign" := ROUND(TotalQtyToAssign / RemainingNumOfLines,0.00001);
          ItemChargeAssgntPurch."Amount to Assign" :=
            ROUND(
              ItemChargeAssgntPurch."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
              Currency."Amount Rounding Precision");
          TotalQtyToAssign -= ItemChargeAssgntPurch."Qty. to Assign";
          TotalAmtToAssign -= ItemChargeAssgntPurch."Amount to Assign";
          RemainingNumOfLines := RemainingNumOfLines - 1;
          ItemChargeAssgntPurch.MODIFY;
        UNTIL TempItemChargeAssgntPurch.NEXT = 0;
      END;
      TempItemChargeAssgntPurch.DELETEALL;
    END;

    LOCAL PROCEDURE AssignByAmount@27(VAR ItemChargeAssgntPurch@1003 : Record 5805;Currency@1002 : Record 4;PurchHeader@1008 : Record 38;TotalQtyToAssign@1001 : Decimal;TotalAmtToAssign@1000 : Decimal);
    VAR
      TempItemChargeAssgntPurch@1004 : TEMPORARY Record 5805;
      PurchLine@1005 : Record 39;
      PurchRcptLine@1006 : Record 121;
      CurrExchRate@1009 : Record 330;
      ReturnRcptLine@1010 : Record 6661;
      ReturnShptLine@1011 : Record 6651;
      SalesShptLine@1012 : Record 111;
      CurrencyCode@1007 : Code[10];
      TotalAppliesToDocLineAmount@1013 : Decimal;
    BEGIN
      REPEAT
        IF NOT ItemChargeAssgntPurch.PurchLineInvoiced THEN BEGIN
          TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
          CASE ItemChargeAssgntPurch."Applies-to Doc. Type" OF
            ItemChargeAssgntPurch."Applies-to Doc. Type"::Quote,
            ItemChargeAssgntPurch."Applies-to Doc. Type"::Order,
            ItemChargeAssgntPurch."Applies-to Doc. Type"::Invoice,
            ItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Order",
            ItemChargeAssgntPurch."Applies-to Doc. Type"::"Credit Memo":
              BEGIN
                PurchLine.GET(
                  ItemChargeAssgntPurch."Applies-to Doc. Type",
                  ItemChargeAssgntPurch."Applies-to Doc. No.",
                  ItemChargeAssgntPurch."Applies-to Doc. Line No.");
                TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                  ABS(PurchLine."Line Amount");
              END;
            ItemChargeAssgntPurch."Applies-to Doc. Type"::Receipt:
              BEGIN
                PurchRcptLine.GET(
                  ItemChargeAssgntPurch."Applies-to Doc. No.",
                  ItemChargeAssgntPurch."Applies-to Doc. Line No.");
                CurrencyCode := PurchRcptLine.GetCurrencyCodeFromHeader;
                IF CurrencyCode = PurchHeader."Currency Code" THEN
                  TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                    ABS(PurchRcptLine."Item Charge Base Amount")
                ELSE
                  TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      PurchHeader."Posting Date",CurrencyCode,PurchHeader."Currency Code",
                      ABS(PurchRcptLine."Item Charge Base Amount"));
              END;
            ItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Shipment":
              BEGIN
                ReturnShptLine.GET(
                  ItemChargeAssgntPurch."Applies-to Doc. No.",
                  ItemChargeAssgntPurch."Applies-to Doc. Line No.");
                CurrencyCode := ReturnShptLine.GetCurrencyCode;
                IF CurrencyCode = PurchHeader."Currency Code" THEN
                  TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                    ABS(ReturnShptLine."Item Charge Base Amount")
                ELSE
                  TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      PurchHeader."Posting Date",CurrencyCode,PurchHeader."Currency Code",
                      ABS(ReturnShptLine."Item Charge Base Amount"));
              END;
            ItemChargeAssgntPurch."Applies-to Doc. Type"::"Sales Shipment":
              BEGIN
                SalesShptLine.GET(
                  ItemChargeAssgntPurch."Applies-to Doc. No.",
                  ItemChargeAssgntPurch."Applies-to Doc. Line No.");
                CurrencyCode := SalesShptLine.GetCurrencyCode;
                IF CurrencyCode = PurchHeader."Currency Code" THEN
                  TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                    ABS(SalesShptLine."Item Charge Base Amount")
                ELSE
                  TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      PurchHeader."Posting Date",CurrencyCode,PurchHeader."Currency Code",
                      ABS(SalesShptLine."Item Charge Base Amount"));
              END;
            ItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Receipt":
              BEGIN
                ReturnRcptLine.GET(
                  ItemChargeAssgntPurch."Applies-to Doc. No.",
                  ItemChargeAssgntPurch."Applies-to Doc. Line No.");
                CurrencyCode := ReturnRcptLine.GetCurrencyCode;
                IF CurrencyCode = PurchHeader."Currency Code" THEN
                  TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                    ABS(ReturnRcptLine."Item Charge Base Amount")
                ELSE
                  TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      PurchHeader."Posting Date",CurrencyCode,PurchHeader."Currency Code",
                      ABS(ReturnRcptLine."Item Charge Base Amount"));
              END;
          END;
          IF TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" <> 0 THEN
            TempItemChargeAssgntPurch.INSERT
          ELSE BEGIN
            ItemChargeAssgntPurch."Amount to Assign" := 0;
            ItemChargeAssgntPurch."Qty. to Assign" := 0;
            ItemChargeAssgntPurch.MODIFY;
          END;
          TotalAppliesToDocLineAmount += TempItemChargeAssgntPurch."Applies-to Doc. Line Amount";
        END;
      UNTIL ItemChargeAssgntPurch.NEXT = 0;

      IF TempItemChargeAssgntPurch.FINDSET(TRUE) THEN
        REPEAT
          ItemChargeAssgntPurch.GET(
            TempItemChargeAssgntPurch."Document Type",
            TempItemChargeAssgntPurch."Document No.",
            TempItemChargeAssgntPurch."Document Line No.",
            TempItemChargeAssgntPurch."Line No.");
          IF TotalQtyToAssign <> 0 THEN BEGIN
            ItemChargeAssgntPurch."Qty. to Assign" :=
              ROUND(
                TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" / TotalAppliesToDocLineAmount * TotalQtyToAssign,
                0.00001);
            ItemChargeAssgntPurch."Amount to Assign" :=
              ROUND(
                ItemChargeAssgntPurch."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                Currency."Amount Rounding Precision");
            TotalQtyToAssign -= ItemChargeAssgntPurch."Qty. to Assign";
            TotalAmtToAssign -= ItemChargeAssgntPurch."Amount to Assign";
            TotalAppliesToDocLineAmount -= TempItemChargeAssgntPurch."Applies-to Doc. Line Amount";
            ItemChargeAssgntPurch.MODIFY;
          END;
        UNTIL TempItemChargeAssgntPurch.NEXT = 0;
      TempItemChargeAssgntPurch.DELETEALL;
    END;

    LOCAL PROCEDURE AssignByWeight@29(VAR ItemChargeAssgntPurch@1003 : Record 5805;Currency@1002 : Record 4;TotalQtyToAssign@1001 : Decimal);
    VAR
      TempItemChargeAssgntPurch@1004 : TEMPORARY Record 5805;
      LineAray@1005 : ARRAY [3] OF Decimal;
      TotalGrossWeight@1006 : Decimal;
      QtyRemainder@1007 : Decimal;
      AmountRemainder@1008 : Decimal;
    BEGIN
      REPEAT
        IF NOT ItemChargeAssgntPurch.PurchLineInvoiced THEN BEGIN
          TempItemChargeAssgntPurch.INIT;
          TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
          TempItemChargeAssgntPurch.INSERT;
          GetItemValues(TempItemChargeAssgntPurch,LineAray);
          TotalGrossWeight := TotalGrossWeight + (LineAray[2] * LineAray[1]);
        END;
      UNTIL ItemChargeAssgntPurch.NEXT = 0;

      IF TempItemChargeAssgntPurch.FINDSET(TRUE) THEN
        REPEAT
          GetItemValues(TempItemChargeAssgntPurch,LineAray);
          IF TotalGrossWeight <> 0 THEN
            TempItemChargeAssgntPurch."Qty. to Assign" :=
              (TotalQtyToAssign * LineAray[2] * LineAray[1]) / TotalGrossWeight + QtyRemainder
          ELSE
            TempItemChargeAssgntPurch."Qty. to Assign" := 0;
          AssignPurchItemCharge(ItemChargeAssgntPurch,TempItemChargeAssgntPurch,Currency,QtyRemainder,AmountRemainder);
        UNTIL TempItemChargeAssgntPurch.NEXT = 0;
      TempItemChargeAssgntPurch.DELETEALL;
    END;

    LOCAL PROCEDURE AssignByVolume@28(VAR ItemChargeAssgntPurch@1003 : Record 5805;Currency@1002 : Record 4;TotalQtyToAssign@1001 : Decimal);
    VAR
      TempItemChargeAssgntPurch@1004 : TEMPORARY Record 5805;
      LineAray@1005 : ARRAY [3] OF Decimal;
      TotalUnitVolume@1006 : Decimal;
      QtyRemainder@1007 : Decimal;
      AmountRemainder@1008 : Decimal;
    BEGIN
      REPEAT
        IF NOT ItemChargeAssgntPurch.PurchLineInvoiced THEN BEGIN
          TempItemChargeAssgntPurch.INIT;
          TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
          TempItemChargeAssgntPurch.INSERT;
          GetItemValues(TempItemChargeAssgntPurch,LineAray);
          TotalUnitVolume := TotalUnitVolume + (LineAray[3] * LineAray[1]);
        END;
      UNTIL ItemChargeAssgntPurch.NEXT = 0;

      IF TempItemChargeAssgntPurch.FINDSET(TRUE) THEN
        REPEAT
          GetItemValues(TempItemChargeAssgntPurch,LineAray);
          IF TotalUnitVolume <> 0 THEN
            TempItemChargeAssgntPurch."Qty. to Assign" :=
              (TotalQtyToAssign * LineAray[3] * LineAray[1]) / TotalUnitVolume + QtyRemainder
          ELSE
            TempItemChargeAssgntPurch."Qty. to Assign" := 0;
          AssignPurchItemCharge(ItemChargeAssgntPurch,TempItemChargeAssgntPurch,Currency,QtyRemainder,AmountRemainder);
        UNTIL TempItemChargeAssgntPurch.NEXT = 0;
      TempItemChargeAssgntPurch.DELETEALL;
    END;

    LOCAL PROCEDURE AssignPurchItemCharge@12(VAR ItemChargeAssgntPurch@1000 : Record 5805;ItemChargeAssgntPurch2@1001 : Record 5805;Currency@1002 : Record 4;VAR QtyRemainder@1004 : Decimal;VAR AmountRemainder@1003 : Decimal);
    BEGIN
      ItemChargeAssgntPurch.GET(
        ItemChargeAssgntPurch2."Document Type",
        ItemChargeAssgntPurch2."Document No.",
        ItemChargeAssgntPurch2."Document Line No.",
        ItemChargeAssgntPurch2."Line No.");
      ItemChargeAssgntPurch."Qty. to Assign" := ROUND(ItemChargeAssgntPurch2."Qty. to Assign",0.00001);
      ItemChargeAssgntPurch."Amount to Assign" :=
        ItemChargeAssgntPurch."Qty. to Assign" * ItemChargeAssgntPurch."Unit Cost" + AmountRemainder;
      AmountRemainder := ItemChargeAssgntPurch."Amount to Assign" -
        ROUND(ItemChargeAssgntPurch."Amount to Assign",Currency."Amount Rounding Precision");
      QtyRemainder := ItemChargeAssgntPurch2."Qty. to Assign" - ItemChargeAssgntPurch."Qty. to Assign";
      ItemChargeAssgntPurch."Amount to Assign" :=
        ROUND(ItemChargeAssgntPurch."Amount to Assign",Currency."Amount Rounding Precision");
      ItemChargeAssgntPurch.MODIFY;
    END;

    PROCEDURE GetItemValues@35(TempItemChargeAssgntPurch@1000 : TEMPORARY Record 5805;VAR DecimalArray@1001 : ARRAY [3] OF Decimal);
    VAR
      PurchLine@1002 : Record 39;
      PurchRcptLine@1003 : Record 121;
      ReturnShptLine@1004 : Record 6651;
      TransferRcptLine@1005 : Record 5747;
      SalesShptLine@1006 : Record 111;
      ReturnRcptLine@1007 : Record 6661;
    BEGIN
      CLEAR(DecimalArray);
      WITH TempItemChargeAssgntPurch DO
        CASE "Applies-to Doc. Type" OF
          "Applies-to Doc. Type"::Order,
          "Applies-to Doc. Type"::Invoice,
          "Applies-to Doc. Type"::"Return Order",
          "Applies-to Doc. Type"::"Credit Memo":
            BEGIN
              PurchLine.GET("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
              DecimalArray[1] := PurchLine.Quantity;
              DecimalArray[2] := PurchLine."Gross Weight";
              DecimalArray[3] := PurchLine."Unit Volume";
            END;
          "Applies-to Doc. Type"::Receipt:
            BEGIN
              PurchRcptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
              DecimalArray[1] := PurchRcptLine.Quantity;
              DecimalArray[2] := PurchRcptLine."Gross Weight";
              DecimalArray[3] := PurchRcptLine."Unit Volume";
            END;
          "Applies-to Doc. Type"::"Return Receipt":
            BEGIN
              ReturnRcptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
              DecimalArray[1] := ReturnRcptLine.Quantity;
              DecimalArray[2] := ReturnRcptLine."Gross Weight";
              DecimalArray[3] := ReturnRcptLine."Unit Volume";
            END;
          "Applies-to Doc. Type"::"Return Shipment":
            BEGIN
              ReturnShptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
              DecimalArray[1] := ReturnShptLine.Quantity;
              DecimalArray[2] := ReturnShptLine."Gross Weight";
              DecimalArray[3] := ReturnShptLine."Unit Volume";
            END;
          "Applies-to Doc. Type"::"Transfer Receipt":
            BEGIN
              TransferRcptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
              DecimalArray[1] := TransferRcptLine.Quantity;
              DecimalArray[2] := TransferRcptLine."Gross Weight";
              DecimalArray[3] := TransferRcptLine."Unit Volume";
            END;
          "Applies-to Doc. Type"::"Sales Shipment":
            BEGIN
              SalesShptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
              DecimalArray[1] := SalesShptLine.Quantity;
              DecimalArray[2] := SalesShptLine."Gross Weight";
              DecimalArray[3] := SalesShptLine."Unit Volume";
            END;
        END;
    END;

    [External]
    PROCEDURE SuggestAssgntFromLine@11(VAR FromItemChargeAssignmentPurch@1000 : Record 5805);
    VAR
      Currency@1014 : Record 4;
      PurchHeader@1003 : Record 38;
      ItemChargeAssignmentPurch@1007 : Record 5805;
      TempItemChargeAssgntPurch@1008 : TEMPORARY Record 5805;
      TotalAmountToAssign@1013 : Decimal;
      TotalQtyToAssign@1012 : Decimal;
      ItemChargeAssgntLineAmt@1001 : Decimal;
      ItemChargeAssgntLineQty@1011 : Decimal;
    BEGIN
      WITH FromItemChargeAssignmentPurch DO BEGIN
        PurchHeader.GET("Document Type","Document No.");
        IF NOT Currency.GET(PurchHeader."Currency Code") THEN
          Currency.InitRoundingPrecision;

        GetItemChargeAssgntLineAmounts(
          "Document Type","Document No.","Document Line No.",
          ItemChargeAssgntLineQty,ItemChargeAssgntLineAmt);

        IF NOT ItemChargeAssignmentPurch.GET("Document Type","Document No.","Document Line No.","Line No.") THEN
          EXIT;

        ItemChargeAssignmentPurch."Qty. to Assign" := "Qty. to Assign";
        ItemChargeAssignmentPurch."Amount to Assign" := "Amount to Assign";
        ItemChargeAssignmentPurch.MODIFY;

        ItemChargeAssignmentPurch.SETRANGE("Document Type","Document Type");
        ItemChargeAssignmentPurch.SETRANGE("Document No.","Document No.");
        ItemChargeAssignmentPurch.SETRANGE("Document Line No.","Document Line No.");
        ItemChargeAssignmentPurch.CALCSUMS("Qty. to Assign","Amount to Assign");
        TotalQtyToAssign := ItemChargeAssignmentPurch."Qty. to Assign";
        TotalAmountToAssign := ItemChargeAssignmentPurch."Amount to Assign";

        IF TotalAmountToAssign = ItemChargeAssgntLineAmt THEN
          EXIT;

        IF TotalQtyToAssign = ItemChargeAssgntLineQty THEN BEGIN
          TotalAmountToAssign := ItemChargeAssgntLineAmt;
          ItemChargeAssignmentPurch.FINDSET;
          REPEAT
            IF NOT ItemChargeAssignmentPurch.PurchLineInvoiced THEN BEGIN
              TempItemChargeAssgntPurch := ItemChargeAssignmentPurch;
              TempItemChargeAssgntPurch.INSERT;
            END;
          UNTIL ItemChargeAssignmentPurch.NEXT = 0;

          IF TempItemChargeAssgntPurch.FINDSET THEN BEGIN
            REPEAT
              ItemChargeAssignmentPurch.GET(
                TempItemChargeAssgntPurch."Document Type",
                TempItemChargeAssgntPurch."Document No.",
                TempItemChargeAssgntPurch."Document Line No.",
                TempItemChargeAssgntPurch."Line No.");
              IF TotalQtyToAssign <> 0 THEN BEGIN
                ItemChargeAssignmentPurch."Amount to Assign" :=
                  ROUND(
                    ItemChargeAssignmentPurch."Qty. to Assign" / TotalQtyToAssign * TotalAmountToAssign,
                    Currency."Amount Rounding Precision");
                TotalQtyToAssign -= ItemChargeAssignmentPurch."Qty. to Assign";
                TotalAmountToAssign -= ItemChargeAssignmentPurch."Amount to Assign";
                ItemChargeAssignmentPurch.MODIFY;
              END;
            UNTIL TempItemChargeAssgntPurch.NEXT = 0;
          END;
        END;

        ItemChargeAssignmentPurch.GET("Document Type","Document No.","Document Line No.","Line No.");
      END;

      FromItemChargeAssignmentPurch := ItemChargeAssignmentPurch;
    END;

    LOCAL PROCEDURE GetItemChargeAssgntLineAmounts@14(DocumentType@1000 : Option;DocumentNo@1001 : Code[20];DocumentLineNo@1002 : Integer;VAR ItemChargeAssgntLineQty@1003 : Decimal;VAR ItemChargeAssgntLineAmt@1004 : Decimal);
    VAR
      PurchLine@1005 : Record 39;
      PurchHeader@1006 : Record 38;
      Currency@1007 : Record 4;
    BEGIN
      PurchHeader.GET(DocumentType,DocumentNo);
      IF NOT Currency.GET(PurchHeader."Currency Code") THEN
        Currency.InitRoundingPrecision;

      WITH PurchLine DO BEGIN
        GET(DocumentType,DocumentNo,DocumentLineNo);
        TESTFIELD(Type,Type::"Charge (Item)");
        TESTFIELD("No.");
        TESTFIELD(Quantity);

        IF ("Inv. Discount Amount" = 0) AND
           ("Line Discount Amount" = 0) AND
           (NOT PurchHeader."Prices Including VAT")
        THEN
          ItemChargeAssgntLineAmt := "Line Amount"
        ELSE
          IF PurchHeader."Prices Including VAT" THEN
            ItemChargeAssgntLineAmt :=
              ROUND(("Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
                Currency."Amount Rounding Precision")
          ELSE
            ItemChargeAssgntLineAmt := "Line Amount" - "Inv. Discount Amount";

        ItemChargeAssgntLineAmt :=
          ROUND(
            ItemChargeAssgntLineAmt * ("Qty. to Invoice" / Quantity),
            Currency."Amount Rounding Precision");
        ItemChargeAssgntLineQty := "Qty. to Invoice";
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDocChargeAssgnt@15(VAR LastItemChargeAssgntPurch@1000 : Record 5805;VAR ReceiptNo@1001 : Code[20]);
    BEGIN
    END;

    BEGIN
    END.
  }
}

