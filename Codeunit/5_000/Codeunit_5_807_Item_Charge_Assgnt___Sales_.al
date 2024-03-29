OBJECT Codeunit 5807 Item Charge Assgnt. (Sales)
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 36=r,
                TableData 37=r,
                TableData 111=r,
                TableData 5809=imd,
                TableData 6661=r;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Ligeligt,Efter bel�b,Efter v�gt,Efter volumen;ENU=Equally,By Amount,By Weight,By Volume';
      SuggestItemChargeMsg@1001 : TextConst 'DAN=V�lg, hvordan det tildelte varegebyr skal fordeles, n�r bilaget indeholder mere end �n linje af typen Vare.;ENU=Select how to distribute the assigned item charge when the document has more than one line of type Item.';

    [External]
    PROCEDURE InsertItemChargeAssgnt@1(ItemChargeAssgntSales@1000 : Record 5809;ApplToDocType@1001 : Option;ApplToDocNo2@1002 : Code[20];ApplToDocLineNo2@1003 : Integer;ItemNo2@1004 : Code[20];Description2@1005 : Text[50];VAR NextLineNo@1006 : Integer);
    BEGIN
      InsertItemChargeAssgntWithAssignValues(
        ItemChargeAssgntSales,ApplToDocType,ApplToDocNo2,ApplToDocLineNo2,ItemNo2,Description2,0,0,NextLineNo);
    END;

    [External]
    PROCEDURE InsertItemChargeAssgntWithAssignValues@19(FromItemChargeAssgntSales@1000 : Record 5809;ApplToDocType@1001 : Option;FromApplToDocNo@1002 : Code[20];FromApplToDocLineNo@1003 : Integer;FromItemNo@1004 : Code[20];FromDescription@1005 : Text[50];QtyToAssign@1008 : Decimal;AmountToAssign@1009 : Decimal;VAR NextLineNo@1006 : Integer);
    VAR
      ItemChargeAssgntSales@1007 : Record 5809;
    BEGIN
      NextLineNo := NextLineNo + 10000;

      ItemChargeAssgntSales."Document No." := FromItemChargeAssgntSales."Document No.";
      ItemChargeAssgntSales."Document Type" := FromItemChargeAssgntSales."Document Type";
      ItemChargeAssgntSales."Document Line No." := FromItemChargeAssgntSales."Document Line No.";
      ItemChargeAssgntSales."Item Charge No." := FromItemChargeAssgntSales."Item Charge No.";
      ItemChargeAssgntSales."Line No." := NextLineNo;
      ItemChargeAssgntSales."Applies-to Doc. No." := FromApplToDocNo;
      ItemChargeAssgntSales."Applies-to Doc. Type" := ApplToDocType;
      ItemChargeAssgntSales."Applies-to Doc. Line No." := FromApplToDocLineNo;
      ItemChargeAssgntSales."Item No." := FromItemNo;
      ItemChargeAssgntSales.Description := FromDescription;
      ItemChargeAssgntSales."Unit Cost" := FromItemChargeAssgntSales."Unit Cost";
      IF QtyToAssign <> 0 THEN BEGIN
        ItemChargeAssgntSales."Amount to Assign" := AmountToAssign;
        ItemChargeAssgntSales.VALIDATE("Qty. to Assign",QtyToAssign);
      END;
      ItemChargeAssgntSales.INSERT;
    END;

    [External]
    PROCEDURE CreateDocChargeAssgn@2(LastItemChargeAssgntSales@1000 : Record 5809;ShipmentNo@1001 : Code[20]);
    VAR
      FromSalesLine@1002 : Record 37;
      ItemChargeAssgntSales@1003 : Record 5809;
      NextLineNo@1004 : Integer;
    BEGIN
      WITH LastItemChargeAssgntSales DO BEGIN
        FromSalesLine.SETRANGE("Document Type","Document Type");
        FromSalesLine.SETRANGE("Document No.","Document No.");
        FromSalesLine.SETRANGE(Type,FromSalesLine.Type::Item);
        IF FromSalesLine.FIND('-') THEN BEGIN
          NextLineNo := "Line No.";
          ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
          ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
          ItemChargeAssgntSales.SETRANGE("Document Line No.","Document Line No.");
          ItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.","Document No.");
          REPEAT
            IF (FromSalesLine.Quantity <> 0) AND
               (FromSalesLine.Quantity <> FromSalesLine."Quantity Invoiced") AND
               (FromSalesLine."Job No." = '') AND
               ((ShipmentNo = '') OR (FromSalesLine."Shipment No." = ShipmentNo)) AND
               FromSalesLine."Allow Item Charge Assignment"
            THEN BEGIN
              ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.",FromSalesLine."Line No.");
              IF NOT ItemChargeAssgntSales.FINDFIRST THEN
                InsertItemChargeAssgnt(
                  LastItemChargeAssgntSales,FromSalesLine."Document Type",
                  FromSalesLine."Document No.",FromSalesLine."Line No.",
                  FromSalesLine."No.",FromSalesLine.Description,NextLineNo);
            END;
          UNTIL FromSalesLine.NEXT = 0;
        END;
      END;
    END;

    [External]
    PROCEDURE CreateShptChargeAssgnt@3(VAR FromSalesShptLine@1000 : Record 111;ItemChargeAssgntSales@1001 : Record 5809);
    VAR
      ItemChargeAssgntSales2@1002 : Record 5809;
      Nextline@1003 : Integer;
    BEGIN
      Nextline := ItemChargeAssgntSales."Line No.";
      ItemChargeAssgntSales2.SETRANGE("Document Type",ItemChargeAssgntSales."Document Type");
      ItemChargeAssgntSales2.SETRANGE("Document No.",ItemChargeAssgntSales."Document No.");
      ItemChargeAssgntSales2.SETRANGE("Document Line No.",ItemChargeAssgntSales."Document Line No.");
      ItemChargeAssgntSales2.SETRANGE(
        "Applies-to Doc. Type",ItemChargeAssgntSales2."Applies-to Doc. Type"::Shipment);
      REPEAT
        FromSalesShptLine.TESTFIELD("Job No.",'');
        ItemChargeAssgntSales2.SETRANGE("Applies-to Doc. No.",FromSalesShptLine."Document No.");
        ItemChargeAssgntSales2.SETRANGE("Applies-to Doc. Line No.",FromSalesShptLine."Line No.");
        IF NOT ItemChargeAssgntSales2.FINDFIRST THEN
          InsertItemChargeAssgnt(ItemChargeAssgntSales,ItemChargeAssgntSales2."Applies-to Doc. Type"::Shipment,
            FromSalesShptLine."Document No.",FromSalesShptLine."Line No.",
            FromSalesShptLine."No.",FromSalesShptLine.Description,Nextline);
      UNTIL FromSalesShptLine.NEXT = 0;
    END;

    [External]
    PROCEDURE CreateRcptChargeAssgnt@4(VAR FromReturnRcptLine@1000 : Record 6661;ItemChargeAssgntSales@1001 : Record 5809);
    VAR
      ItemChargeAssgntSales2@1002 : Record 5809;
      Nextline@1003 : Integer;
    BEGIN
      Nextline := ItemChargeAssgntSales."Line No.";
      ItemChargeAssgntSales2.SETRANGE("Document Type",ItemChargeAssgntSales."Document Type");
      ItemChargeAssgntSales2.SETRANGE("Document No.",ItemChargeAssgntSales."Document No.");
      ItemChargeAssgntSales2.SETRANGE("Document Line No.",ItemChargeAssgntSales."Document Line No.");
      ItemChargeAssgntSales2.SETRANGE(
        "Applies-to Doc. Type",ItemChargeAssgntSales2."Applies-to Doc. Type"::"Return Receipt");
      REPEAT
        FromReturnRcptLine.TESTFIELD("Job No.",'');
        ItemChargeAssgntSales2.SETRANGE("Applies-to Doc. No.",FromReturnRcptLine."Document No.");
        ItemChargeAssgntSales2.SETRANGE("Applies-to Doc. Line No.",FromReturnRcptLine."Line No.");
        IF NOT ItemChargeAssgntSales2.FINDFIRST THEN
          InsertItemChargeAssgnt(ItemChargeAssgntSales,ItemChargeAssgntSales2."Applies-to Doc. Type"::"Return Receipt",
            FromReturnRcptLine."Document No.",FromReturnRcptLine."Line No.",
            FromReturnRcptLine."No.",FromReturnRcptLine.Description,Nextline);
      UNTIL FromReturnRcptLine.NEXT = 0;
    END;

    [Internal]
    PROCEDURE SuggestAssignment@5(SalesLine@1000 : Record 37;TotalQtyToAssign@1001 : Decimal;TotalAmtToAssign@1002 : Decimal);
    VAR
      ItemChargeAssgntSales@1013 : Record 5809;
      Selection@1014 : Integer;
    BEGIN
      WITH SalesLine DO BEGIN
        TESTFIELD("Qty. to Invoice");
        ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
        ItemChargeAssgntSales.SETRANGE("Document Line No.","Line No.");
      END;
      IF ItemChargeAssgntSales.ISEMPTY THEN
        EXIT;

      Selection := 1;
      IF ItemChargeAssgntSales.COUNT > 1 THEN
        Selection := STRMENU(Text000,2,SuggestItemChargeMsg);

      IF Selection = 0 THEN
        EXIT;
      SuggestAssignment2(SalesLine,TotalQtyToAssign,TotalAmtToAssign,Selection);
    END;

    [External]
    PROCEDURE SuggestAssignment2@6(SalesLine@1000 : Record 37;TotalQtyToAssign@1001 : Decimal;TotalAmtToAssign@1011 : Decimal;Selection@1014 : Integer);
    VAR
      Currency@1016 : Record 4;
      SalesHeader@1003 : Record 36;
      ItemChargeAssgntSales@1007 : Record 5809;
    BEGIN
      SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.");
      IF NOT Currency.GET(SalesHeader."Currency Code") THEN
        Currency.InitRoundingPrecision;

      ItemChargeAssgntSales.SETRANGE("Document Type",SalesLine."Document Type");
      ItemChargeAssgntSales.SETRANGE("Document No.",SalesLine."Document No.");
      ItemChargeAssgntSales.SETRANGE("Document Line No.",SalesLine."Line No.");
      IF ItemChargeAssgntSales.FINDFIRST THEN
        CASE Selection OF
          1:
            AssignEqually(ItemChargeAssgntSales,Currency,TotalQtyToAssign,TotalAmtToAssign);
          2:
            AssignByAmount(ItemChargeAssgntSales,Currency,SalesHeader,TotalQtyToAssign,TotalAmtToAssign);
          3:
            AssignByWeight(ItemChargeAssgntSales,Currency,TotalQtyToAssign);
          4:
            AssignByVolume(ItemChargeAssgntSales,Currency,TotalQtyToAssign);
        END;
    END;

    LOCAL PROCEDURE AssignEqually@8(VAR ItemChargeAssignmentSales@1000 : Record 5809;Currency@1002 : Record 4;TotalQtyToAssign@1003 : Decimal;TotalAmtToAssign@1004 : Decimal);
    VAR
      TempItemChargeAssgntSales@1008 : TEMPORARY Record 5809;
      RemainingNumOfLines@1015 : Integer;
    BEGIN
      REPEAT
        IF NOT ItemChargeAssignmentSales.SalesLineInvoiced THEN BEGIN
          TempItemChargeAssgntSales.INIT;
          TempItemChargeAssgntSales := ItemChargeAssignmentSales;
          TempItemChargeAssgntSales.INSERT;
        END;
      UNTIL ItemChargeAssignmentSales.NEXT = 0;

      IF TempItemChargeAssgntSales.FINDSET(TRUE) THEN BEGIN
        RemainingNumOfLines := TempItemChargeAssgntSales.COUNT;
        REPEAT
          ItemChargeAssignmentSales.GET(
            TempItemChargeAssgntSales."Document Type",
            TempItemChargeAssgntSales."Document No.",
            TempItemChargeAssgntSales."Document Line No.",
            TempItemChargeAssgntSales."Line No.");
          ItemChargeAssignmentSales."Qty. to Assign" := ROUND(TotalQtyToAssign / RemainingNumOfLines,0.00001);
          ItemChargeAssignmentSales."Amount to Assign" :=
            ROUND(
              ItemChargeAssignmentSales."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
              Currency."Amount Rounding Precision");
          TotalQtyToAssign -= ItemChargeAssignmentSales."Qty. to Assign";
          TotalAmtToAssign -= ItemChargeAssignmentSales."Amount to Assign";
          RemainingNumOfLines := RemainingNumOfLines - 1;
          ItemChargeAssignmentSales.MODIFY;
        UNTIL TempItemChargeAssgntSales.NEXT = 0;
      END;
      TempItemChargeAssgntSales.DELETEALL;
    END;

    LOCAL PROCEDURE AssignByAmount@10(VAR ItemChargeAssignmentSales@1000 : Record 5809;Currency@1001 : Record 4;SalesHeader@1002 : Record 36;TotalQtyToAssign@1003 : Decimal;TotalAmtToAssign@1004 : Decimal);
    VAR
      TempItemChargeAssgntSales@1011 : TEMPORARY Record 5809;
      SalesLine@1005 : Record 37;
      SalesShptLine@1006 : Record 111;
      CurrExchRate@1007 : Record 330;
      ReturnRcptLine@1008 : Record 6661;
      CurrencyCode@1009 : Code[10];
      TotalAppliesToDocLineAmount@1010 : Decimal;
    BEGIN
      REPEAT
        IF NOT ItemChargeAssignmentSales.SalesLineInvoiced THEN BEGIN
          TempItemChargeAssgntSales.INIT;
          TempItemChargeAssgntSales := ItemChargeAssignmentSales;
          CASE ItemChargeAssignmentSales."Applies-to Doc. Type" OF
            ItemChargeAssignmentSales."Applies-to Doc. Type"::Quote,
            ItemChargeAssignmentSales."Applies-to Doc. Type"::Order,
            ItemChargeAssignmentSales."Applies-to Doc. Type"::Invoice,
            ItemChargeAssignmentSales."Applies-to Doc. Type"::"Return Order",
            ItemChargeAssignmentSales."Applies-to Doc. Type"::"Credit Memo":
              BEGIN
                SalesLine.GET(
                  ItemChargeAssignmentSales."Applies-to Doc. Type",
                  ItemChargeAssignmentSales."Applies-to Doc. No.",
                  ItemChargeAssignmentSales."Applies-to Doc. Line No.");
                TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                  ABS(SalesLine."Line Amount");
              END;
            ItemChargeAssignmentSales."Applies-to Doc. Type"::"Return Receipt":
              BEGIN
                ReturnRcptLine.GET(
                  ItemChargeAssignmentSales."Applies-to Doc. No.",
                  ItemChargeAssignmentSales."Applies-to Doc. Line No.");
                CurrencyCode := ReturnRcptLine.GetCurrencyCode;
                IF CurrencyCode = SalesHeader."Currency Code" THEN
                  TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                    ABS(ReturnRcptLine."Item Charge Base Amount")
                ELSE
                  TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      SalesHeader."Posting Date",CurrencyCode,SalesHeader."Currency Code",
                      ABS(ReturnRcptLine."Item Charge Base Amount"));
              END;
            ItemChargeAssignmentSales."Applies-to Doc. Type"::Shipment:
              BEGIN
                SalesShptLine.GET(
                  ItemChargeAssignmentSales."Applies-to Doc. No.",
                  ItemChargeAssignmentSales."Applies-to Doc. Line No.");
                CurrencyCode := SalesShptLine.GetCurrencyCode;
                IF CurrencyCode = SalesHeader."Currency Code" THEN
                  TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                    ABS(SalesShptLine."Item Charge Base Amount")
                ELSE
                  TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      SalesHeader."Posting Date",CurrencyCode,SalesHeader."Currency Code",
                      ABS(SalesShptLine."Item Charge Base Amount"));
              END;
          END;
          IF TempItemChargeAssgntSales."Applies-to Doc. Line Amount" <> 0 THEN
            TempItemChargeAssgntSales.INSERT
          ELSE BEGIN
            ItemChargeAssignmentSales."Amount to Assign" := 0;
            ItemChargeAssignmentSales."Qty. to Assign" := 0;
            ItemChargeAssignmentSales.MODIFY;
          END;
          TotalAppliesToDocLineAmount += TempItemChargeAssgntSales."Applies-to Doc. Line Amount";
        END;
      UNTIL ItemChargeAssignmentSales.NEXT = 0;

      IF TempItemChargeAssgntSales.FINDSET(TRUE) THEN
        REPEAT
          ItemChargeAssignmentSales.GET(
            TempItemChargeAssgntSales."Document Type",
            TempItemChargeAssgntSales."Document No.",
            TempItemChargeAssgntSales."Document Line No.",
            TempItemChargeAssgntSales."Line No.");
          IF TotalQtyToAssign <> 0 THEN BEGIN
            ItemChargeAssignmentSales."Qty. to Assign" :=
              ROUND(
                TempItemChargeAssgntSales."Applies-to Doc. Line Amount" / TotalAppliesToDocLineAmount * TotalQtyToAssign,
                0.00001);
            ItemChargeAssignmentSales."Amount to Assign" :=
              ROUND(
                ItemChargeAssignmentSales."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                Currency."Amount Rounding Precision");
            TotalQtyToAssign -= ItemChargeAssignmentSales."Qty. to Assign";
            TotalAmtToAssign -= ItemChargeAssignmentSales."Amount to Assign";
            TotalAppliesToDocLineAmount -= TempItemChargeAssgntSales."Applies-to Doc. Line Amount";
            ItemChargeAssignmentSales.MODIFY;
          END;
        UNTIL TempItemChargeAssgntSales.NEXT = 0;

      TempItemChargeAssgntSales.DELETEALL;
    END;

    LOCAL PROCEDURE AssignByWeight@15(VAR ItemChargeAssignmentSales@1000 : Record 5809;Currency@1001 : Record 4;TotalQtyToAssign@1003 : Decimal);
    VAR
      TempItemChargeAssgntSales@1004 : TEMPORARY Record 5809;
      LineArray@1005 : ARRAY [3] OF Decimal;
      TotalGrossWeight@1006 : Decimal;
      QtyRemaining@1007 : Decimal;
      AmountRemaining@1008 : Decimal;
    BEGIN
      REPEAT
        IF NOT ItemChargeAssignmentSales.SalesLineInvoiced THEN BEGIN
          TempItemChargeAssgntSales.INIT;
          TempItemChargeAssgntSales := ItemChargeAssignmentSales;
          TempItemChargeAssgntSales.INSERT;
          GetItemValues(TempItemChargeAssgntSales,LineArray);
          TotalGrossWeight := TotalGrossWeight + (LineArray[2] * LineArray[1]);
        END;
      UNTIL ItemChargeAssignmentSales.NEXT = 0;

      IF TempItemChargeAssgntSales.FINDSET(TRUE) THEN
        REPEAT
          GetItemValues(TempItemChargeAssgntSales,LineArray);
          IF TotalGrossWeight <> 0 THEN
            TempItemChargeAssgntSales."Qty. to Assign" :=
              (TotalQtyToAssign * LineArray[2] * LineArray[1]) / TotalGrossWeight + QtyRemaining
          ELSE
            TempItemChargeAssgntSales."Qty. to Assign" := 0;
          AssignSalesItemCharge(ItemChargeAssignmentSales,TempItemChargeAssgntSales,Currency,QtyRemaining,AmountRemaining);
        UNTIL TempItemChargeAssgntSales.NEXT = 0;
      TempItemChargeAssgntSales.DELETEALL;
    END;

    LOCAL PROCEDURE AssignByVolume@16(VAR ItemChargeAssignmentSales@1000 : Record 5809;Currency@1001 : Record 4;TotalQtyToAssign@1002 : Decimal);
    VAR
      TempItemChargeAssgntSales@1004 : TEMPORARY Record 5809;
      LineArray@1005 : ARRAY [3] OF Decimal;
      TotalUnitVolume@1009 : Decimal;
      QtyRemaining@1007 : Decimal;
      AmountRemaining@1008 : Decimal;
    BEGIN
      REPEAT
        IF NOT ItemChargeAssignmentSales.SalesLineInvoiced THEN BEGIN
          TempItemChargeAssgntSales.INIT;
          TempItemChargeAssgntSales := ItemChargeAssignmentSales;
          TempItemChargeAssgntSales.INSERT;
          GetItemValues(TempItemChargeAssgntSales,LineArray);
          TotalUnitVolume := TotalUnitVolume + (LineArray[3] * LineArray[1]);
        END;
      UNTIL ItemChargeAssignmentSales.NEXT = 0;

      IF TempItemChargeAssgntSales.FINDSET(TRUE) THEN
        REPEAT
          GetItemValues(TempItemChargeAssgntSales,LineArray);
          IF TotalUnitVolume <> 0 THEN
            TempItemChargeAssgntSales."Qty. to Assign" :=
              (TotalQtyToAssign * LineArray[3] * LineArray[1]) / TotalUnitVolume + QtyRemaining
          ELSE
            TempItemChargeAssgntSales."Qty. to Assign" := 0;
          AssignSalesItemCharge(ItemChargeAssignmentSales,TempItemChargeAssgntSales,Currency,QtyRemaining,AmountRemaining);
        UNTIL TempItemChargeAssgntSales.NEXT = 0;
      TempItemChargeAssgntSales.DELETEALL;
    END;

    LOCAL PROCEDURE AssignSalesItemCharge@17(VAR ItemChargeAssignmentSales@1000 : Record 5809;ItemChargeAssignmentSales2@1001 : Record 5809;Currency@1002 : Record 4;VAR QtyRemaining@1003 : Decimal;VAR AmountRemaining@1004 : Decimal);
    BEGIN
      ItemChargeAssignmentSales.GET(
        ItemChargeAssignmentSales2."Document Type",
        ItemChargeAssignmentSales2."Document No.",
        ItemChargeAssignmentSales2."Document Line No.",
        ItemChargeAssignmentSales2."Line No.");
      ItemChargeAssignmentSales."Qty. to Assign" := ROUND(ItemChargeAssignmentSales2."Qty. to Assign",0.00001);
      ItemChargeAssignmentSales."Amount to Assign" :=
        ItemChargeAssignmentSales."Qty. to Assign" * ItemChargeAssignmentSales."Unit Cost" + AmountRemaining;
      AmountRemaining := ItemChargeAssignmentSales."Amount to Assign" -
        ROUND(ItemChargeAssignmentSales."Amount to Assign",Currency."Amount Rounding Precision");
      QtyRemaining := ItemChargeAssignmentSales2."Qty. to Assign" - ItemChargeAssignmentSales."Qty. to Assign";
      ItemChargeAssignmentSales."Amount to Assign" :=
        ROUND(ItemChargeAssignmentSales."Amount to Assign",Currency."Amount Rounding Precision");
      ItemChargeAssignmentSales.MODIFY;
    END;

    PROCEDURE GetItemValues@35(TempItemChargeAssgntSales@1000 : TEMPORARY Record 5809;VAR DecimalArray@1001 : ARRAY [3] OF Decimal);
    VAR
      SalesLine@1002 : Record 37;
      SalesShptLine@1006 : Record 111;
      ReturnRcptLine@1007 : Record 6661;
    BEGIN
      CLEAR(DecimalArray);
      WITH TempItemChargeAssgntSales DO
        CASE "Applies-to Doc. Type" OF
          "Applies-to Doc. Type"::Order,
          "Applies-to Doc. Type"::Invoice,
          "Applies-to Doc. Type"::"Return Order",
          "Applies-to Doc. Type"::"Credit Memo":
            BEGIN
              SalesLine.GET("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
              DecimalArray[1] := SalesLine.Quantity;
              DecimalArray[2] := SalesLine."Gross Weight";
              DecimalArray[3] := SalesLine."Unit Volume";
            END;
          "Applies-to Doc. Type"::"Return Receipt":
            BEGIN
              ReturnRcptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
              DecimalArray[1] := ReturnRcptLine.Quantity;
              DecimalArray[2] := ReturnRcptLine."Gross Weight";
              DecimalArray[3] := ReturnRcptLine."Unit Volume";
            END;
          "Applies-to Doc. Type"::"Return Order":
            BEGIN
              SalesLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
              DecimalArray[1] := SalesLine.Quantity;
              DecimalArray[2] := SalesLine."Gross Weight";
              DecimalArray[3] := SalesLine."Unit Volume";
            END;
          "Applies-to Doc. Type"::Shipment:
            BEGIN
              SalesShptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
              DecimalArray[1] := SalesShptLine.Quantity;
              DecimalArray[2] := SalesShptLine."Gross Weight";
              DecimalArray[3] := SalesShptLine."Unit Volume";
            END;
        END;
    END;

    [External]
    PROCEDURE SuggestAssignmentFromLine@11(VAR FromItemChargeAssignmentSales@1000 : Record 5809);
    VAR
      Currency@1014 : Record 4;
      SalesHeader@1003 : Record 36;
      ItemChargeAssignmentSales@1007 : Record 5809;
      TempItemChargeAssgntSales@1008 : TEMPORARY Record 5809;
      TotalAmountToAssign@1013 : Decimal;
      TotalQtyToAssign@1012 : Decimal;
      ItemChargeAssgntLineAmt@1001 : Decimal;
      ItemChargeAssgntLineQty@1011 : Decimal;
    BEGIN
      WITH FromItemChargeAssignmentSales DO BEGIN
        SalesHeader.GET("Document Type","Document No.");
        IF NOT Currency.GET(SalesHeader."Currency Code") THEN
          Currency.InitRoundingPrecision;

        GetItemChargeAssgntLineAmounts(
          "Document Type","Document No.","Document Line No.",
          ItemChargeAssgntLineQty,ItemChargeAssgntLineAmt);

        IF NOT ItemChargeAssignmentSales.GET("Document Type","Document No.","Document Line No.","Line No.") THEN
          EXIT;

        ItemChargeAssignmentSales."Qty. to Assign" := "Qty. to Assign";
        ItemChargeAssignmentSales."Amount to Assign" := "Amount to Assign";
        ItemChargeAssignmentSales.MODIFY;

        ItemChargeAssignmentSales.SETRANGE("Document Type","Document Type");
        ItemChargeAssignmentSales.SETRANGE("Document No.","Document No.");
        ItemChargeAssignmentSales.SETRANGE("Document Line No.","Document Line No.");
        ItemChargeAssignmentSales.CALCSUMS("Qty. to Assign","Amount to Assign");
        TotalQtyToAssign := ItemChargeAssignmentSales."Qty. to Assign";
        TotalAmountToAssign := ItemChargeAssignmentSales."Amount to Assign";

        IF TotalAmountToAssign = ItemChargeAssgntLineAmt THEN
          EXIT;

        IF TotalQtyToAssign = ItemChargeAssgntLineQty THEN BEGIN
          TotalAmountToAssign := ItemChargeAssgntLineAmt;
          ItemChargeAssignmentSales.FINDSET;
          REPEAT
            IF NOT ItemChargeAssignmentSales.SalesLineInvoiced THEN BEGIN
              TempItemChargeAssgntSales := ItemChargeAssignmentSales;
              TempItemChargeAssgntSales.INSERT;
            END;
          UNTIL ItemChargeAssignmentSales.NEXT = 0;

          IF TempItemChargeAssgntSales.FINDSET THEN BEGIN
            REPEAT
              ItemChargeAssignmentSales.GET(
                TempItemChargeAssgntSales."Document Type",
                TempItemChargeAssgntSales."Document No.",
                TempItemChargeAssgntSales."Document Line No.",
                TempItemChargeAssgntSales."Line No.");
              IF TotalQtyToAssign <> 0 THEN BEGIN
                ItemChargeAssignmentSales."Amount to Assign" :=
                  ROUND(
                    ItemChargeAssignmentSales."Qty. to Assign" / TotalQtyToAssign * TotalAmountToAssign,
                    Currency."Amount Rounding Precision");
                TotalQtyToAssign -= ItemChargeAssignmentSales."Qty. to Assign";
                TotalAmountToAssign -= ItemChargeAssignmentSales."Amount to Assign";
                ItemChargeAssignmentSales.MODIFY;
              END;
            UNTIL TempItemChargeAssgntSales.NEXT = 0;
          END;
        END;

        ItemChargeAssignmentSales.GET("Document Type","Document No.","Document Line No.","Line No.");
      END;

      FromItemChargeAssignmentSales := ItemChargeAssignmentSales;
    END;

    LOCAL PROCEDURE GetItemChargeAssgntLineAmounts@14(DocumentType@1000 : Option;DocumentNo@1001 : Code[20];DocumentLineNo@1002 : Integer;VAR ItemChargeAssgntLineQty@1003 : Decimal;VAR ItemChargeAssgntLineAmt@1004 : Decimal);
    VAR
      SalesLine@1005 : Record 37;
      SalesHeader@1006 : Record 36;
      Currency@1007 : Record 4;
    BEGIN
      SalesHeader.GET(DocumentType,DocumentNo);
      IF SalesHeader."Currency Code" = '' THEN
        Currency.InitRoundingPrecision
      ELSE
        Currency.GET(SalesHeader."Currency Code");

      WITH SalesLine DO BEGIN
        GET(DocumentType,DocumentNo,DocumentLineNo);
        TESTFIELD(Type,Type::"Charge (Item)");
        TESTFIELD("No.");
        TESTFIELD(Quantity);

        IF ("Inv. Discount Amount" = 0) AND
           ("Line Discount Amount" = 0) AND
           (NOT SalesHeader."Prices Including VAT")
        THEN
          ItemChargeAssgntLineAmt := "Line Amount"
        ELSE
          IF SalesHeader."Prices Including VAT" THEN
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

    BEGIN
    END.
  }
}

