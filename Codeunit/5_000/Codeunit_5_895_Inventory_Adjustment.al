OBJECT Codeunit 5895 Inventory Adjustment
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    Permissions=TableData 27=rm,
                TableData 32=rm,
                TableData 339=rimd,
                TableData 5802=rim,
                TableData 5804=rimd,
                TableData 5896=rm;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Regulerer v�rdiposter...\\;ENU=Adjusting value entries...\\';
      Text001@1001 : TextConst 'DAN=Regl.niveau         #2######\;ENU=Adjmt. Level      #2######\';
      Text002@1002 : TextConst 'DAN=%1 %2;ENU=%1 %2';
      Text003@1003 : TextConst 'DAN=Reguler             #3######\;ENU=Adjust            #3######\';
      Text004@1004 : TextConst 'DAN=Kostreg.niv.        #4######\;ENU=Cost FW. Level    #4######\';
      Text005@1005 : TextConst 'DAN=L�benr.             #5######\;ENU=Entry No.         #5######\';
      Text006@1044 : TextConst 'DAN=Resterende poster   #6######;ENU=Remaining Entries #6######';
      Text007@1007 : TextConst 'DAN=Udlignet kostbel�b;ENU=Applied cost';
      Text008@1008 : TextConst 'DAN=Kostpris (gnsn.);ENU=Average cost';
      Item@1026 : Record 27;
      FilterItem@1040 : Record 27;
      GLSetup@1009 : Record 98;
      Currency@1010 : Record 4;
      InvtSetup@1011 : Record 313;
      SourceCodeSetup@1012 : Record 242;
      TempInvtAdjmtBuf@1030 : TEMPORARY Record 5895;
      RndgResidualBuf@1023 : TEMPORARY Record 5810;
      AppliedEntryToAdjustBuf@1006 : TEMPORARY Record 2000000026;
      AvgCostExceptionBuf@1029 : TEMPORARY Record 2000000026;
      AvgCostBuf@1028 : Record 5820;
      AvgCostRndgBuf@1025 : TEMPORARY Record 5810;
      RevaluationPoint@1022 : TEMPORARY Record 2000000026;
      TempFixApplBuffer@1046 : TEMPORARY Record 2000000026;
      TempOpenItemLedgEntry@1047 : TEMPORARY Record 2000000026;
      TempJobToAdjustBuf@1043 : TEMPORARY Record 167;
      ItemJnlPostLine@1015 : Codeunit 22;
      CostCalcMgt@1016 : Codeunit 5836;
      ItemCostMgt@1024 : Codeunit 5804;
      Window@1017 : Dialog;
      WindowUpdateDateTime@1013 : DateTime;
      PostingDateForClosedPeriod@1018 : Date;
      LevelNo@1019 : ARRAY [3] OF Integer;
      MaxLevels@1020 : Integer;
      LevelExceeded@1021 : Boolean;
      IsDeletedItem@1027 : Boolean;
      IsOnlineAdjmt@1031 : Boolean;
      PostToGL@1041 : Boolean;
      SkipUpdateJobItemCost@1042 : Boolean;
      WindowIsOpen@1037 : Boolean;
      WindowAdjmtLevel@1032 : Integer;
      WindowItem@1033 : Code[20];
      WindowAdjust@1036 : Text[20];
      WindowFWLevel@1035 : Integer;
      WindowEntry@1034 : Integer;
      Text009@1039 : TextConst 'DAN=VIA;ENU=WIP';
      Text010@1014 : TextConst 'DAN=Montage;ENU=Assembly';
      IsAvgCostCalcTypeItem@1038 : Boolean;
      WindowOutbndEntry@1045 : Integer;
      ConsumpAdjmtInPeriodWithOutput@1048 : Date;

    [External]
    PROCEDURE SetProperties@29(NewIsOnlineAdjmt@1001 : Boolean;NewPostToGL@1003 : Boolean);
    BEGIN
      IsOnlineAdjmt := NewIsOnlineAdjmt;
      PostToGL := NewPostToGL;
    END;

    [External]
    PROCEDURE SetFilterItem@16(VAR NewItem@1000 : Record 27);
    BEGIN
      FilterItem.COPYFILTERS(NewItem);
    END;

    [External]
    PROCEDURE MakeMultiLevelAdjmt@34();
    VAR
      TempItem@1004 : TEMPORARY Record 27;
      TempInventoryAdjmtEntryOrder@1000 : TEMPORARY Record 5896;
      IsFirstTime@1005 : Boolean;
    BEGIN
      InitializeAdjmt;

      IsFirstTime := TRUE;
      WHILE (InvtToAdjustExist(TempItem) OR IsFirstTime) AND NOT LevelExceeded DO BEGIN
        MakeSingleLevelAdjmt(TempItem);
        IF AssemblyToAdjustExists(TempInventoryAdjmtEntryOrder) THEN
          MakeAssemblyAdjmt(TempInventoryAdjmtEntryOrder);
        IF WIPToAdjustExist(TempInventoryAdjmtEntryOrder) THEN
          MakeWIPAdjmt(TempInventoryAdjmtEntryOrder);
        IsFirstTime := FALSE;
      END;

      SetAppliedEntryToAdjustFromBuf;
      FinalizeAdjmt;
      UpdateJobItemCost;
    END;

    LOCAL PROCEDURE InitializeAdjmt@37();
    BEGIN
      CLEAR(LevelNo);
      MaxLevels := 100;
      WindowUpdateDateTime := CURRENTDATETIME;
      IF NOT IsOnlineAdjmt THEN
        OpenWindow;

      CLEAR(ItemJnlPostLine);
      ItemJnlPostLine.SetCalledFromAdjustment(TRUE,PostToGL);

      InvtSetup.GET;
      GLSetup.GET;
      PostingDateForClosedPeriod := GLSetup.FirstAllowedPostingDate;
      GetAddReportingCurrency;

      SourceCodeSetup.GET;

      ItemCostMgt.SetProperties(TRUE,0);
      TempJobToAdjustBuf.DELETEALL;
    END;

    LOCAL PROCEDURE FinalizeAdjmt@85();
    BEGIN
      CLEAR(ItemJnlPostLine);
      CLEAR(CostCalcMgt);
      CLEAR(ItemCostMgt);
      AvgCostRndgBuf.DELETEALL;
      IF WindowIsOpen THEN
        Window.CLOSE;
      WindowIsOpen := FALSE;
    END;

    LOCAL PROCEDURE GetAddReportingCurrency@30();
    BEGIN
      IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
        Currency.GET(GLSetup."Additional Reporting Currency");
        Currency.CheckAmountRoundingPrecision;
      END;
    END;

    LOCAL PROCEDURE InvtToAdjustExist@64(VAR ToItem@1000 : Record 27) : Boolean;
    VAR
      Item@1001 : Record 27;
      ItemLedgEntry@1002 : Record 32;
    BEGIN
      WITH Item DO BEGIN
        RESET;
        COPYFILTERS(FilterItem);
        IF GETFILTER("No.") = '' THEN
          SETCURRENTKEY("Cost is Adjusted","Allow Online Adjustment");
        SETRANGE("Cost is Adjusted",FALSE);
        IF IsOnlineAdjmt THEN
          SETRANGE("Allow Online Adjustment",TRUE);

        CopyItemToItem(Item,ToItem);

        IF ItemLedgEntry.AppliedEntryToAdjustExists('') THEN
          InsertDeletedItem(ToItem);

        EXIT(NOT ToItem.ISEMPTY);
      END;
    END;

    LOCAL PROCEDURE MakeSingleLevelAdjmt@12(VAR TheItem@1001 : Record 27);
    VAR
      TempAvgCostAdjmtEntryPoint@1000 : TEMPORARY Record 5804;
    BEGIN
      LevelNo[1] := LevelNo[1] + 1;

      UpDateWindow(LevelNo[1],WindowItem,WindowAdjust,WindowFWLevel,WindowEntry,0);

      ConsumpAdjmtInPeriodWithOutput := 0D;

      TheItem.SETCURRENTKEY("Low-Level Code");
      IF TheItem.FINDLAST THEN
        TheItem.SETRANGE("Low-Level Code",TheItem."Low-Level Code");

      WITH Item DO
        IF TheItem.FINDSET THEN
          REPEAT
            Item := TheItem;
            GetItem("No.");
            UpDateWindow(WindowAdjmtLevel,"No.",WindowAdjust,WindowFWLevel,WindowEntry,0);

            TempAvgCostAdjmtEntryPoint.RESET;
            TempAvgCostAdjmtEntryPoint.DELETEALL;
            REPEAT
              LevelExceeded := FALSE;
              AdjustItemAppliedCost(TempAvgCostAdjmtEntryPoint);
            UNTIL NOT LevelExceeded;

            AdjustItemAvgCost(TempAvgCostAdjmtEntryPoint);
            PostAdjmtBuf;
            UpdateItemUnitCost(TempAvgCostAdjmtEntryPoint);
          UNTIL (TheItem.NEXT = 0) OR LevelExceeded;
    END;

    LOCAL PROCEDURE AdjustItemAppliedCost@4(VAR TempAvgCostAdjmtEntryPoint@1003 : TEMPORARY Record 5804);
    VAR
      ItemLedgEntry@1002 : Record 32;
      TempItemLedgEntry@1000 : TEMPORARY Record 32;
      AppliedQty@1001 : Decimal;
    BEGIN
      UpDateWindow(WindowAdjmtLevel,WindowItem,Text007,WindowFWLevel,WindowEntry,0);

      WITH ItemLedgEntry DO
        IF AppliedEntryToAdjustExists(Item."No.") THEN BEGIN
          CopyILEToILE(ItemLedgEntry,TempItemLedgEntry);
          TempItemLedgEntry.FINDSET;
          REPEAT
            GET(TempItemLedgEntry."Entry No.");
            UpDateWindow(WindowAdjmtLevel,WindowItem,WindowAdjust,WindowFWLevel,"Entry No.",0);

            RndgResidualBuf.AddAdjustedCost("Entry No.",0,0,"Completely Invoiced");

            AppliedQty := ForwardAppliedCost(ItemLedgEntry,FALSE,TempAvgCostAdjmtEntryPoint);

            EliminateRndgResidual(ItemLedgEntry,AppliedQty);
          UNTIL (TempItemLedgEntry.NEXT = 0) OR LevelExceeded;
        END;
    END;

    LOCAL PROCEDURE ForwardAppliedCost@1(ItemLedgEntry@1000 : Record 32;Recursion@1002 : Boolean;VAR TempAvgCostAdjmtEntryPoint@1001 : TEMPORARY Record 5804) AppliedQty : Decimal;
    VAR
      AppliedEntryToAdjust@1004 : Boolean;
    BEGIN
      WITH ItemLedgEntry DO BEGIN
        // Avoid stack overflow, if too many recursions
        IF Recursion THEN
          LevelNo[3] := LevelNo[3] + 1
        ELSE
          LevelNo[3] := 0;

        IF LevelNo[3] = MaxLevels THEN BEGIN
          SetAppliedEntryToAdjust(TRUE);
          LevelExceeded := TRUE;
          LevelNo[3] := 0;
          EXIT;
        END;

        UpDateWindow(WindowAdjmtLevel,WindowItem,WindowAdjust,LevelNo[3],WindowEntry,0);

        AppliedQty := ForwardCostToOutbndEntries(ItemLedgEntry,Recursion,AppliedEntryToAdjust,TempAvgCostAdjmtEntryPoint);

        ForwardCostToInbndTransEntries("Entry No.",Recursion,TempAvgCostAdjmtEntryPoint);

        ForwardCostToInbndEntries("Entry No.",TempAvgCostAdjmtEntryPoint);

        IF OutboundSalesEntryToAdjust(ItemLedgEntry) OR
           InboundTransferEntryToAdjust(ItemLedgEntry)
        THEN
          AppliedEntryToAdjust := TRUE;

        IF NOT IsOutbndConsump AND AppliedEntryToAdjust THEN
          UpdateAppliedEntryToAdjustBuf("Entry No.",AppliedEntryToAdjust);

        SetAppliedEntryToAdjust(FALSE);
      END;
    END;

    LOCAL PROCEDURE ForwardAppliedCostRecursion@61(ItemLedgEntry@1000 : Record 32;VAR TempAvgCostAdjmtEntryPoint@1001 : TEMPORARY Record 5804);
    BEGIN
      IF NOT ItemLedgEntry."Applied Entry to Adjust" THEN BEGIN
        ForwardAppliedCost(ItemLedgEntry,TRUE,TempAvgCostAdjmtEntryPoint);
        IF LevelNo[3] > 0 THEN
          LevelNo[3] := LevelNo[3] - 1;
      END;
    END;

    LOCAL PROCEDURE ForwardCostToOutbndEntries@27(ItemLedgEntry@1001 : Record 32;Recursion@1000 : Boolean;VAR AppliedEntryToAdjust@1004 : Boolean;VAR TempAvgCostAdjmtEntryPoint@1002 : TEMPORARY Record 5804) AppliedQty : Decimal;
    VAR
      ItemApplnEntry@1003 : Record 339;
      InboundCompletelyInvoiced@1005 : Boolean;
    BEGIN
      AppliedQty := 0;
      WITH ItemApplnEntry DO
        IF AppliedOutbndEntryExists(ItemLedgEntry."Entry No.",TRUE,ItemLedgEntry.Open) THEN
          REPEAT
            IF NOT AdjustAppliedOutbndEntries("Outbound Item Entry No.",Recursion,TempAvgCostAdjmtEntryPoint,InboundCompletelyInvoiced) THEN
              AppliedEntryToAdjust := InboundCompletelyInvoiced OR ItemLedgEntry.Open OR NOT ItemLedgEntry."Completely Invoiced";
            AppliedQty += Quantity;
          UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE AdjustAppliedOutbndEntries@2(OutbndItemLedgEntryNo@1000 : Integer;Recursion@1031 : Boolean;VAR TempAvgCostAdjmtEntryPoint@1007 : TEMPORARY Record 5804;VAR InboundCompletelyInvoiced@1009 : Boolean) : Boolean;
    VAR
      OutbndItemLedgEntry@1001 : Record 32;
      OutbndValueEntry@1003 : Record 5802;
      OutbndCostElementBuf@1002 : TEMPORARY Record 5820;
      OldCostElementBuf@1004 : TEMPORARY Record 5820;
      AdjustedCostElementBuf@1005 : TEMPORARY Record 5820;
      ItemApplnEntry@1006 : Record 339;
      StandardCostMirroring@1008 : Boolean;
    BEGIN
      OutbndItemLedgEntry.GET(OutbndItemLedgEntryNo);
      IF Item."Costing Method" = Item."Costing Method"::Standard THEN
        StandardCostMirroring := UseStandardCostMirroring(OutbndItemLedgEntry);
      WITH OutbndValueEntry DO BEGIN
        CalcOutbndCost(OutbndCostElementBuf,AdjustedCostElementBuf,OutbndItemLedgEntry,Recursion);

        // Adjust shipment
        SETCURRENTKEY("Item Ledger Entry No.","Document No.","Document Line No.");
        SETRANGE("Item Ledger Entry No.",OutbndItemLedgEntryNo);
        FINDSET;
        REPEAT
          IF NOT (Adjustment OR ExpCostIsCompletelyInvoiced(OutbndItemLedgEntry,OutbndValueEntry)) AND
             Inventoriable
          THEN BEGIN
            SETRANGE("Document No.","Document No.");
            SETRANGE("Document Line No.","Document Line No.");
            CalcOutbndDocOldCost(
              OldCostElementBuf,OutbndValueEntry,
              OutbndItemLedgEntry.IsExactCostReversingPurchase OR OutbndItemLedgEntry.IsExactCostReversingOutput);

            CalcCostPerUnit(OutbndValueEntry,OutbndCostElementBuf,OutbndItemLedgEntry.Quantity);

            IF NOT "Expected Cost" THEN BEGIN
              OldCostElementBuf.Retrieve(0,0);
              "Invoiced Quantity" := OldCostElementBuf."Invoiced Quantity";
              "Valued Quantity" := OldCostElementBuf."Invoiced Quantity";
            END;

            CalcOutbndDocNewCost(
              AdjustedCostElementBuf,OutbndCostElementBuf,
              OutbndValueEntry,OutbndItemLedgEntry.Quantity);

            IF "Expected Cost" THEN BEGIN
              OldCostElementBuf.Retrieve(OldCostElementBuf.Type::Total,OldCostElementBuf."Variance Type"::" ");
              AdjustedCostElementBuf."Actual Cost" := AdjustedCostElementBuf."Actual Cost" - OldCostElementBuf."Expected Cost";
              AdjustedCostElementBuf."Actual Cost (ACY)" :=
                AdjustedCostElementBuf."Actual Cost (ACY)" - OldCostElementBuf."Expected Cost (ACY)";
            END ELSE BEGIN
              OldCostElementBuf.Retrieve("Entry Type"::"Direct Cost",0);
              AdjustedCostElementBuf."Actual Cost" := AdjustedCostElementBuf."Actual Cost" - OldCostElementBuf."Actual Cost";
              AdjustedCostElementBuf."Actual Cost (ACY)" :=
                AdjustedCostElementBuf."Actual Cost (ACY)" - OldCostElementBuf."Actual Cost (ACY)";
            END;

            IF StandardCostMirroring AND NOT "Expected Cost" THEN
              CreateCostAdjmtBuf(
                OutbndValueEntry,AdjustedCostElementBuf,OutbndItemLedgEntry."Posting Date",
                "Entry Type"::Variance,TempAvgCostAdjmtEntryPoint)
            ELSE
              CreateCostAdjmtBuf(
                OutbndValueEntry,AdjustedCostElementBuf,OutbndItemLedgEntry."Posting Date",
                "Entry Type",TempAvgCostAdjmtEntryPoint);

            IF NOT "Expected Cost" THEN BEGIN
              CreateIndirectCostAdjmt(
                OldCostElementBuf,AdjustedCostElementBuf,OutbndValueEntry,"Entry Type"::"Indirect Cost",TempAvgCostAdjmtEntryPoint);
              CreateIndirectCostAdjmt(
                OldCostElementBuf,AdjustedCostElementBuf,OutbndValueEntry,"Entry Type"::Variance,TempAvgCostAdjmtEntryPoint);
            END;
            FINDLAST;
            SETRANGE("Document No.");
            SETRANGE("Document Line No.");
          END;
        UNTIL NEXT = 0;

        // Update transfers, consumptions
        IF IsUpdateCompletelyInvoiced(
             OutbndItemLedgEntry,OutbndCostElementBuf."Inbound Completely Invoiced")
        THEN
          OutbndItemLedgEntry.SetCompletelyInvoiced;

        ForwardAppliedCostRecursion(OutbndItemLedgEntry,TempAvgCostAdjmtEntryPoint);

        ItemApplnEntry.SetInboundToUpdated(OutbndItemLedgEntry);

        InboundCompletelyInvoiced := OutbndCostElementBuf."Inbound Completely Invoiced";
        EXIT(OutbndItemLedgEntry."Completely Invoiced");
      END;
    END;

    LOCAL PROCEDURE CalcCostPerUnit@41(VAR OutbndValueEntry@1001 : Record 5802;OutbndCostElementBuf@1000 : Record 5820;ItemLedgEntryQty@1002 : Decimal);
    BEGIN
      WITH OutbndCostElementBuf DO BEGIN
        IF (OutbndValueEntry."Cost per Unit" = 0) AND ("Remaining Quantity" <> 0) THEN
          OutbndValueEntry."Cost per Unit" := "Actual Cost" / (ItemLedgEntryQty - "Remaining Quantity");
        IF (OutbndValueEntry."Cost per Unit (ACY)" = 0) AND ("Remaining Quantity" <> 0) THEN
          OutbndValueEntry."Cost per Unit (ACY)" := "Actual Cost (ACY)" / (ItemLedgEntryQty - "Remaining Quantity");
      END;
    END;

    LOCAL PROCEDURE CalcOutbndCost@47(VAR OutbndCostElementBuf@1000 : Record 5820;VAR AdjustedCostElementBuf@1007 : Record 5820;OutbndItemLedgEntry@1004 : Record 32;Recursion@1003 : Boolean);
    VAR
      OutbndItemApplnEntry@1002 : Record 339;
    BEGIN
      AdjustedCostElementBuf.DELETEALL;
      WITH OutbndCostElementBuf DO BEGIN
        "Remaining Quantity" := OutbndItemLedgEntry.Quantity;
        "Inbound Completely Invoiced" := TRUE;

        OutbndItemApplnEntry.SETCURRENTKEY("Item Ledger Entry No.");
        OutbndItemApplnEntry.SETRANGE("Item Ledger Entry No.",OutbndItemLedgEntry."Entry No.");
        OutbndItemApplnEntry.FINDSET;
        REPEAT
          IF NOT
             CalcInbndEntryAdjustedCost(
               AdjustedCostElementBuf,
               OutbndItemApplnEntry,OutbndItemLedgEntry."Entry No.",
               OutbndItemApplnEntry."Inbound Item Entry No.",
               OutbndItemLedgEntry.IsExactCostReversingPurchase OR OutbndItemLedgEntry.IsExactCostReversingOutput,
               Recursion)
          THEN
            "Inbound Completely Invoiced" := FALSE;

          AdjustedCostElementBuf.Retrieve(Type::"Direct Cost","Variance Type"::" ");
          "Actual Cost" := "Actual Cost" + AdjustedCostElementBuf."Actual Cost";
          "Actual Cost (ACY)" := "Actual Cost (ACY)" + AdjustedCostElementBuf."Actual Cost (ACY)";
          "Remaining Quantity" := "Remaining Quantity" - OutbndItemApplnEntry.Quantity;
        UNTIL OutbndItemApplnEntry.NEXT = 0;

        IF "Inbound Completely Invoiced" THEN
          "Inbound Completely Invoiced" := "Remaining Quantity" = 0;
      END;
    END;

    LOCAL PROCEDURE CalcOutbndDocNewCost@46(VAR NewCostElementBuf@1007 : Record 5820;OutbndCostElementBuf@1000 : Record 5820;OutbndValueEntry@1005 : Record 5802;ItemLedgEntryQty@1006 : Decimal);
    VAR
      ShareOfTotalCost@1001 : Decimal;
    BEGIN
      ShareOfTotalCost := OutbndValueEntry."Valued Quantity" / ItemLedgEntryQty;
      WITH OutbndCostElementBuf DO BEGIN
        NewCostElementBuf.Retrieve(Type::"Direct Cost",0);
        "Actual Cost" := "Actual Cost" + OutbndValueEntry."Cost per Unit" * "Remaining Quantity";
        "Actual Cost (ACY)" := "Actual Cost (ACY)" + OutbndValueEntry."Cost per Unit (ACY)" * "Remaining Quantity";

        RoundCost(
          NewCostElementBuf."Actual Cost",NewCostElementBuf."Rounding Residual",
          "Actual Cost",ShareOfTotalCost,GLSetup."Amount Rounding Precision");
        RoundCost(
          NewCostElementBuf."Actual Cost (ACY)",NewCostElementBuf."Rounding Residual (ACY)",
          "Actual Cost (ACY)",ShareOfTotalCost,Currency."Amount Rounding Precision");

        IF NOT NewCostElementBuf.INSERT THEN
          NewCostElementBuf.MODIFY;
      END;
    END;

    LOCAL PROCEDURE CreateCostAdjmtBuf@92(OutbndValueEntry@1000 : Record 5802;CostElementBuf@1001 : Record 5820;ItemLedgEntryPostingDate@1003 : Date;EntryType@1004 : Option;VAR TempAvgCostAdjmtEntryPoint@1002 : TEMPORARY Record 5804) : Boolean;
    BEGIN
      WITH CostElementBuf DO
        IF UpdateAdjmtBuf(
             OutbndValueEntry,"Actual Cost","Actual Cost (ACY)",ItemLedgEntryPostingDate,EntryType,
             TempAvgCostAdjmtEntryPoint)
        THEN BEGIN
          UpdateAvgCostAdjmtEntryPoint(OutbndValueEntry,TempAvgCostAdjmtEntryPoint);
          EXIT(TRUE);
        END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CreateIndirectCostAdjmt@40(VAR CostElementBuf@1005 : Record 5820;VAR AdjustedCostElementBuf@1004 : Record 5820;OutbndValueEntry@1000 : Record 5802;EntryType@1001 : Option;VAR TempAvgCostAdjmtEntryPoint@1003 : TEMPORARY Record 5804);
    VAR
      ItemJnlLine@1008 : Record 83;
      OrigValueEntry@1002 : Record 5802;
      NewAdjustedCost@1006 : Decimal;
      NewAdjustedCostACY@1007 : Decimal;
    BEGIN
      WITH CostElementBuf DO BEGIN
        Retrieve(EntryType,0);
        AdjustedCostElementBuf.Retrieve(EntryType,0);
        NewAdjustedCost := AdjustedCostElementBuf."Actual Cost" - "Actual Cost";
        NewAdjustedCostACY := AdjustedCostElementBuf."Actual Cost (ACY)" - "Actual Cost (ACY)";
      END;

      IF HasNewCost(NewAdjustedCost,NewAdjustedCostACY) THEN BEGIN
        GetOrigValueEntry(OrigValueEntry,OutbndValueEntry,EntryType);
        InitAdjmtJnlLine(
          ItemJnlLine,OrigValueEntry,OrigValueEntry."Entry Type",OrigValueEntry."Variance Type");
        PostItemJnlLine(ItemJnlLine,OrigValueEntry,NewAdjustedCost,NewAdjustedCostACY);
        UpdateAvgCostAdjmtEntryPoint(OrigValueEntry,TempAvgCostAdjmtEntryPoint);
      END;
    END;

    LOCAL PROCEDURE ForwardCostToInbndTransEntries@39(ItemLedgEntryNo@1001 : Integer;Recursion@1000 : Boolean;VAR TempAvgCostAdjmtEntryPoint@1003 : TEMPORARY Record 5804);
    VAR
      ItemApplnEntry@1002 : Record 339;
    BEGIN
      WITH ItemApplnEntry DO
        IF AppliedInbndTransEntryExists(ItemLedgEntryNo,TRUE) THEN
          REPEAT
            AdjustAppliedInbndTransEntries(ItemApplnEntry,Recursion,TempAvgCostAdjmtEntryPoint);
          UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE AdjustAppliedInbndTransEntries@13(TransItemApplnEntry@1000 : Record 339;Recursion@1014 : Boolean;VAR TempAvgCostAdjmtEntryPoint@1004 : TEMPORARY Record 5804);
    VAR
      TransValueEntry@1002 : Record 5802;
      TransItemLedgEntry@1003 : Record 32;
      CostElementBuf@1001 : TEMPORARY Record 5820;
      AdjustedCostElementBuf@1006 : TEMPORARY Record 5820;
      EntryAdjusted@1007 : Boolean;
    BEGIN
      WITH TransItemApplnEntry DO BEGIN
        TransItemLedgEntry.GET("Item Ledger Entry No.");
        IF NOT TransItemLedgEntry."Completely Invoiced" THEN
          AdjustNotInvdRevaluation(TransItemLedgEntry,TransItemApplnEntry,TempAvgCostAdjmtEntryPoint);

        CalcTransEntryOldCost(CostElementBuf,TransValueEntry,"Item Ledger Entry No.");

        IF CalcInbndEntryAdjustedCost(
             AdjustedCostElementBuf,
             TransItemApplnEntry,TransItemLedgEntry."Entry No.",
             "Transferred-from Entry No.",
             FALSE,Recursion)
        THEN
          IF NOT TransItemLedgEntry."Completely Invoiced" THEN BEGIN
            TransItemLedgEntry.SetCompletelyInvoiced;
            EntryAdjusted := TRUE;
          END;

        IF UpdateAdjmtBuf(
             TransValueEntry,
             AdjustedCostElementBuf."Actual Cost" - CostElementBuf."Actual Cost",
             AdjustedCostElementBuf."Actual Cost (ACY)" - CostElementBuf."Actual Cost (ACY)",
             TransItemLedgEntry."Posting Date",
             TransValueEntry."Entry Type",
             TempAvgCostAdjmtEntryPoint)
        THEN
          EntryAdjusted := TRUE;

        IF EntryAdjusted THEN BEGIN
          UpdateAvgCostAdjmtEntryPoint(TransValueEntry,TempAvgCostAdjmtEntryPoint);
          ForwardAppliedCostRecursion(TransItemLedgEntry,TempAvgCostAdjmtEntryPoint);
        END;
      END;
    END;

    LOCAL PROCEDURE CalcTransEntryOldCost@56(VAR CostElementBuf@1001 : Record 5820;VAR TransValueEntry@1000 : Record 5802;ItemLedgEntryNo@1002 : Integer);
    VAR
      TransValueEntry2@1003 : Record 5802;
    BEGIN
      CLEAR(CostElementBuf);
      WITH CostElementBuf DO BEGIN
        TransValueEntry2 := TransValueEntry;
        TransValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
        TransValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntryNo);
        TransValueEntry.SETRANGE("Entry Type",TransValueEntry."Entry Type"::"Direct Cost");
        TransValueEntry.FIND('+');
        REPEAT
          IF TransValueEntry."Item Charge No." = '' THEN BEGIN
            IF TempInvtAdjmtBuf.GET(TransValueEntry."Entry No.") THEN
              TransValueEntry.AddCost(TempInvtAdjmtBuf);
            "Actual Cost" := "Actual Cost" + TransValueEntry."Cost Amount (Actual)";
            "Actual Cost (ACY)" := "Actual Cost (ACY)" + TransValueEntry."Cost Amount (Actual) (ACY)";
            TransValueEntry2 := TransValueEntry;
          END;
        UNTIL TransValueEntry.NEXT(-1) = 0;
        TransValueEntry := TransValueEntry2;
      END;
    END;

    LOCAL PROCEDURE ForwardCostToInbndEntries@48(ItemLedgEntryNo@1001 : Integer;VAR TempAvgCostAdjmtEntryPoint@1000 : TEMPORARY Record 5804);
    VAR
      ItemApplnEntry@1002 : Record 339;
    BEGIN
      WITH ItemApplnEntry DO
        IF AppliedInbndEntryExists(ItemLedgEntryNo,TRUE) THEN
          REPEAT
            AdjustAppliedInbndEntries(ItemApplnEntry,TempAvgCostAdjmtEntryPoint);
          UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE AdjustAppliedInbndEntries@9(VAR InbndItemApplnEntry@1000 : Record 339;VAR TempAvgCostAdjmtEntryPoint@1001 : TEMPORARY Record 5804);
    VAR
      OutbndItemLedgEntry@1003 : Record 32;
      InbndValueEntry@1004 : Record 5802;
      InbndItemLedgEntry@1005 : Record 32;
      DocCostElementBuf@1006 : TEMPORARY Record 5820;
      OldCostElementBuf@1013 : TEMPORARY Record 5820;
      EntryAdjusted@1009 : Boolean;
    BEGIN
      WITH InbndItemApplnEntry DO BEGIN
        OutbndItemLedgEntry.GET("Outbound Item Entry No.");
        CalcItemApplnEntryOldCost(OldCostElementBuf,OutbndItemLedgEntry,Quantity);

        InbndItemLedgEntry.GET("Item Ledger Entry No.");
        InbndValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Document No.");
        InbndValueEntry.SETRANGE("Item Ledger Entry No.","Item Ledger Entry No.");
        InbndValueEntry.FINDSET;
        REPEAT
          IF (InbndValueEntry."Entry Type" = InbndValueEntry."Entry Type"::"Direct Cost") AND
             (InbndValueEntry."Item Charge No." = '') AND
             NOT ExpCostIsCompletelyInvoiced(InbndItemLedgEntry,InbndValueEntry)
          THEN BEGIN
            InbndValueEntry.SETRANGE("Document No.",InbndValueEntry."Document No.");
            InbndValueEntry.SETRANGE("Document Line No.",InbndValueEntry."Document Line No.");
            CalcInbndDocOldCost(InbndValueEntry,DocCostElementBuf);

            IF NOT InbndValueEntry."Expected Cost" THEN BEGIN
              DocCostElementBuf.Retrieve(0,0);
              InbndValueEntry."Valued Quantity" := DocCostElementBuf."Invoiced Quantity";
              InbndValueEntry."Invoiced Quantity" := DocCostElementBuf."Invoiced Quantity";
            END;

            CalcInbndDocNewCost(
              DocCostElementBuf,OldCostElementBuf,InbndValueEntry."Expected Cost",
              InbndValueEntry."Valued Quantity" / InbndItemLedgEntry.Quantity);

            IF CreateCostAdjmtBuf(
                 InbndValueEntry,DocCostElementBuf,InbndItemLedgEntry."Posting Date",InbndValueEntry."Entry Type",
                 TempAvgCostAdjmtEntryPoint)
            THEN
              EntryAdjusted := TRUE;

            InbndValueEntry.FINDLAST;
            InbndValueEntry.SETRANGE("Document No.");
            InbndValueEntry.SETRANGE("Document Line No.");
          END;
        UNTIL InbndValueEntry.NEXT = 0;

        // Update transfers, consumptions
        IF IsUpdateCompletelyInvoiced(
             InbndItemLedgEntry,OutbndItemLedgEntry."Completely Invoiced")
        THEN BEGIN
          InbndItemLedgEntry.SetCompletelyInvoiced;
          EntryAdjusted := TRUE;
        END;

        IF EntryAdjusted THEN BEGIN
          UpdateAvgCostAdjmtEntryPoint(InbndValueEntry,TempAvgCostAdjmtEntryPoint);
          ForwardAppliedCostRecursion(InbndItemLedgEntry,TempAvgCostAdjmtEntryPoint);
        END;
      END;
    END;

    LOCAL PROCEDURE CalcItemApplnEntryOldCost@53(VAR OldCostElementBuf@1005 : Record 5820;OutbndItemLedgEntry@1000 : Record 32;ItemApplnEntryQty@1004 : Decimal);
    VAR
      OutbndValueEntry@1003 : Record 5802;
      ShareOfExpectedCost@1001 : Decimal;
    BEGIN
      ShareOfExpectedCost :=
        (OutbndItemLedgEntry.Quantity - OutbndItemLedgEntry."Invoiced Quantity") / OutbndItemLedgEntry.Quantity;

      CLEAR(OldCostElementBuf);
      WITH OldCostElementBuf DO BEGIN
        OutbndValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
        OutbndValueEntry.SETRANGE("Item Ledger Entry No.",OutbndItemLedgEntry."Entry No.");
        OutbndValueEntry.FINDSET;
        REPEAT
          IF TempInvtAdjmtBuf.GET(OutbndValueEntry."Entry No.") THEN
            OutbndValueEntry.AddCost(TempInvtAdjmtBuf);
          IF OutbndValueEntry."Expected Cost" THEN BEGIN
            "Actual Cost" := "Actual Cost" + OutbndValueEntry."Cost Amount (Expected)" * ShareOfExpectedCost;
            "Actual Cost (ACY)" := "Actual Cost (ACY)" + OutbndValueEntry."Cost Amount (Expected) (ACY)" * ShareOfExpectedCost;
          END ELSE BEGIN
            "Actual Cost" := "Actual Cost" + OutbndValueEntry."Cost Amount (Actual)";
            "Actual Cost (ACY)" := "Actual Cost (ACY)" + OutbndValueEntry."Cost Amount (Actual) (ACY)";
          END;
        UNTIL OutbndValueEntry.NEXT = 0;

        RoundActualCost(
          ItemApplnEntryQty / OutbndItemLedgEntry.Quantity,
          GLSetup."Amount Rounding Precision",Currency."Amount Rounding Precision");
      END;
    END;

    LOCAL PROCEDURE CalcInbndDocOldCost@63(InbndValueEntry@1000 : Record 5802;VAR CostElementBuf@1001 : Record 5820);
    BEGIN
      CostElementBuf.DELETEALL;

      InbndValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Document No.");
      InbndValueEntry.SETRANGE("Item Ledger Entry No.",InbndValueEntry."Item Ledger Entry No.");
      InbndValueEntry.SETRANGE("Document No.",InbndValueEntry."Document No.");
      InbndValueEntry.SETRANGE("Document Line No.",InbndValueEntry."Document Line No.");
      WITH CostElementBuf DO
        REPEAT
          IF (InbndValueEntry."Entry Type" = InbndValueEntry."Entry Type"::"Direct Cost") AND
             (InbndValueEntry."Item Charge No." = '')
          THEN BEGIN
            IF TempInvtAdjmtBuf.GET(InbndValueEntry."Entry No.") THEN
              InbndValueEntry.AddCost(TempInvtAdjmtBuf);
            IF InbndValueEntry."Expected Cost" THEN
              AddExpectedCost(0,0,InbndValueEntry."Cost Amount (Expected)",InbndValueEntry."Cost Amount (Expected) (ACY)")
            ELSE BEGIN
              AddActualCost(0,0,InbndValueEntry."Cost Amount (Actual)",InbndValueEntry."Cost Amount (Actual) (ACY)");
              IF InbndValueEntry."Invoiced Quantity" <> 0 THEN BEGIN
                "Invoiced Quantity" := "Invoiced Quantity" + InbndValueEntry."Invoiced Quantity";
                IF NOT MODIFY THEN
                  INSERT;
              END;
            END;
          END;
        UNTIL InbndValueEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CalcInbndDocNewCost@51(VAR NewCostElementBuf@1005 : Record 5820;OldCostElementBuf@1000 : Record 5820;Expected@1008 : Boolean;ShareOfTotalCost@1001 : Decimal);
    BEGIN
      OldCostElementBuf.RoundActualCost(
        ShareOfTotalCost,GLSetup."Amount Rounding Precision",Currency."Amount Rounding Precision");

      WITH NewCostElementBuf DO
        IF Expected THEN BEGIN
          "Actual Cost" := OldCostElementBuf."Actual Cost" - "Expected Cost";
          "Actual Cost (ACY)" := OldCostElementBuf."Actual Cost (ACY)" - "Expected Cost (ACY)";
        END ELSE BEGIN
          "Actual Cost" := OldCostElementBuf."Actual Cost" - "Actual Cost";
          "Actual Cost (ACY)" := OldCostElementBuf."Actual Cost (ACY)" - "Actual Cost (ACY)";
        END;
    END;

    LOCAL PROCEDURE IsUpdateCompletelyInvoiced@66(ItemLedgEntry@1000 : Record 32;CompletelyInvoiced@1001 : Boolean) : Boolean;
    BEGIN
      WITH ItemLedgEntry DO
        EXIT(
          ("Entry Type" IN ["Entry Type"::Transfer,"Entry Type"::Consumption]) AND
          NOT "Completely Invoiced" AND
          CompletelyInvoiced);
    END;

    LOCAL PROCEDURE CalcInbndEntryAdjustedCost@3(VAR AdjustedCostElementBuf@1014 : Record 5820;ItemApplnEntry@1000 : Record 339;OutbndItemLedgEntryNo@1002 : Integer;InbndItemLedgEntryNo@1001 : Integer;ExactCostReversing@1012 : Boolean;Recursion@1013 : Boolean) : Boolean;
    VAR
      InbndValueEntry@1007 : Record 5802;
      InbndItemLedgEntry@1008 : Record 32;
      QtyNotInvoiced@1009 : Decimal;
      ShareOfTotalCost@1003 : Decimal;
    BEGIN
      AdjustedCostElementBuf.DELETEALL;
      WITH InbndValueEntry DO BEGIN
        InbndItemLedgEntry.GET(InbndItemLedgEntryNo);
        SETCURRENTKEY("Item Ledger Entry No.");
        SETRANGE("Item Ledger Entry No.",InbndItemLedgEntryNo);
        QtyNotInvoiced := InbndItemLedgEntry.Quantity - InbndItemLedgEntry."Invoiced Quantity";

        FINDSET;
        REPEAT
          IF IncludedInCostCalculation(InbndValueEntry,OutbndItemLedgEntryNo) AND
             NOT ExpCostIsCompletelyInvoiced(InbndItemLedgEntry,InbndValueEntry)
          THEN BEGIN
            IF TempInvtAdjmtBuf.GET("Entry No.") THEN
              AddCost(TempInvtAdjmtBuf);
            CASE TRUE OF
              IsInterimRevaluation(InbndValueEntry):
                BEGIN
                  ShareOfTotalCost := InbndItemLedgEntry.Quantity / "Valued Quantity";
                  AdjustedCostElementBuf.AddActualCost(
                    AdjustedCostElementBuf.Type::"Direct Cost",AdjustedCostElementBuf."Variance Type"::" ",
                    ("Cost Amount (Expected)" + "Cost Amount (Actual)") * ShareOfTotalCost,
                    ("Cost Amount (Expected) (ACY)" + "Cost Amount (Actual) (ACY)") * ShareOfTotalCost);
                END;
              "Expected Cost":
                BEGIN
                  ShareOfTotalCost := QtyNotInvoiced / "Valued Quantity";
                  AdjustedCostElementBuf.AddActualCost(
                    AdjustedCostElementBuf.Type::"Direct Cost",AdjustedCostElementBuf."Variance Type"::" ",
                    "Cost Amount (Expected)" * ShareOfTotalCost,
                    "Cost Amount (Expected) (ACY)" * ShareOfTotalCost);
                END;
              "Partial Revaluation":
                BEGIN
                  ShareOfTotalCost := InbndItemLedgEntry.Quantity / "Valued Quantity";
                  AdjustedCostElementBuf.AddActualCost(
                    AdjustedCostElementBuf.Type::"Direct Cost",AdjustedCostElementBuf."Variance Type"::" ",
                    "Cost Amount (Actual)" * ShareOfTotalCost,
                    "Cost Amount (Actual) (ACY)" * ShareOfTotalCost);
                END;
              ("Entry Type" <= "Entry Type"::Revaluation) OR NOT ExactCostReversing:
                AdjustedCostElementBuf.AddActualCost(
                  AdjustedCostElementBuf.Type::"Direct Cost",AdjustedCostElementBuf."Variance Type"::" ",
                  "Cost Amount (Actual)","Cost Amount (Actual) (ACY)");
              "Entry Type" = "Entry Type"::"Indirect Cost":
                AdjustedCostElementBuf.AddActualCost(
                  AdjustedCostElementBuf.Type::"Indirect Cost",AdjustedCostElementBuf."Variance Type"::" ",
                  "Cost Amount (Actual)","Cost Amount (Actual) (ACY)");
              ELSE
                AdjustedCostElementBuf.AddActualCost(
                  AdjustedCostElementBuf.Type::Variance,AdjustedCostElementBuf."Variance Type"::" ",
                  "Cost Amount (Actual)","Cost Amount (Actual) (ACY)");
            END;
          END;
        UNTIL NEXT = 0;

        CalcNewAdjustedCost(AdjustedCostElementBuf,ItemApplnEntry.Quantity / InbndItemLedgEntry.Quantity);

        IF AdjustAppliedCostEntry(ItemApplnEntry,InbndItemLedgEntryNo,Recursion) THEN
          RndgResidualBuf.AddAdjustedCost(
            ItemApplnEntry."Inbound Item Entry No.",
            AdjustedCostElementBuf."Actual Cost",AdjustedCostElementBuf."Actual Cost (ACY)",
            ItemApplnEntry."Output Completely Invd. Date" <> 0D);
      END;
      EXIT(InbndItemLedgEntry."Completely Invoiced");
    END;

    LOCAL PROCEDURE CalcNewAdjustedCost@81(VAR AdjustedCostElementBuf@1003 : Record 5820;ShareOfTotalCost@1000 : Decimal);
    BEGIN
      WITH AdjustedCostElementBuf DO BEGIN
        IF FINDSET THEN
          REPEAT
            RoundActualCost(ShareOfTotalCost,GLSetup."Amount Rounding Precision",Currency."Amount Rounding Precision");
            MODIFY;
          UNTIL NEXT = 0;

        CALCSUMS("Actual Cost","Actual Cost (ACY)");
        AddActualCost(Type::Total,"Variance Type"::" ","Actual Cost","Actual Cost (ACY)");
      END;
    END;

    LOCAL PROCEDURE AdjustAppliedCostEntry@98(ItemApplnEntry@1002 : Record 339;ItemLedgEntryNo@1001 : Integer;Recursion@1000 : Boolean) : Boolean;
    BEGIN
      WITH ItemApplnEntry DO
        EXIT(
          ("Transferred-from Entry No." <> ItemLedgEntryNo) AND
          ("Inbound Item Entry No." = RndgResidualBuf."Item Ledger Entry No.") AND
          NOT Recursion);
    END;

    LOCAL PROCEDURE IncludedInCostCalculation@26(InbndValueEntry@1000 : Record 5802;OutbndItemLedgEntryNo@1001 : Integer) : Boolean;
    VAR
      OutbndValueEntry@1002 : Record 5802;
    BEGIN
      WITH InbndValueEntry DO BEGIN
        IF "Entry Type" = "Entry Type"::Revaluation THEN BEGIN
          IF "Applies-to Entry" <> 0 THEN BEGIN
            GET("Applies-to Entry");
            EXIT(IncludedInCostCalculation(InbndValueEntry,OutbndItemLedgEntryNo));
          END;
          IF "Partial Revaluation" THEN BEGIN
            OutbndValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
            OutbndValueEntry.SETRANGE("Item Ledger Entry No.",OutbndItemLedgEntryNo);
            OutbndValueEntry.SETFILTER("Item Ledger Entry Quantity",'<>0');
            OutbndValueEntry.FINDFIRST;
            EXIT(
              (OutbndValueEntry."Entry No." > "Entry No.") OR
              (OutbndValueEntry.GetValuationDate > "Valuation Date") OR
              (OutbndValueEntry."Entry No." = 0));
          END;
        END;
        EXIT("Entry Type" <> "Entry Type"::Rounding);
      END;
    END;

    LOCAL PROCEDURE CalcOutbndDocOldCost@20(VAR CostElementBuf@1007 : Record 5820;OutbndValueEntry@1000 : Record 5802;ExactCostReversing@1001 : Boolean);
    VAR
      ValueEntry@1008 : Record 5802;
    BEGIN
      CostElementBuf.DELETEALL;
      WITH ValueEntry DO BEGIN
        SETCURRENTKEY("Item Ledger Entry No.","Document No.","Document Line No.");
        SETRANGE("Item Ledger Entry No.",OutbndValueEntry."Item Ledger Entry No.");
        SETRANGE("Document No.",OutbndValueEntry."Document No.");
        SETRANGE("Document Line No.",OutbndValueEntry."Document Line No.");
        FINDSET;
        REPEAT
          IF TempInvtAdjmtBuf.GET("Entry No.") THEN
            AddCost(TempInvtAdjmtBuf);
          CostElementBuf.AddExpectedCost(
            CostElementBuf.Type::Total,0,"Cost Amount (Expected)","Cost Amount (Expected) (ACY)");
          IF NOT "Expected Cost" THEN
            CASE TRUE OF
              ("Entry Type" <= "Entry Type"::Revaluation) OR NOT ExactCostReversing:
                BEGIN
                  CostElementBuf.AddActualCost(
                    CostElementBuf.Type::"Direct Cost",CostElementBuf."Variance Type"::" ",
                    "Cost Amount (Actual)","Cost Amount (Actual) (ACY)");
                  IF "Invoiced Quantity" <> 0 THEN BEGIN
                    CostElementBuf."Invoiced Quantity" := CostElementBuf."Invoiced Quantity" + "Invoiced Quantity";
                    IF NOT CostElementBuf.MODIFY THEN
                      CostElementBuf.INSERT;
                  END;
                END;
              "Entry Type" = "Entry Type"::"Indirect Cost":
                CostElementBuf.AddActualCost(
                  CostElementBuf.Type::"Indirect Cost",CostElementBuf."Variance Type"::" ",
                  "Cost Amount (Actual)","Cost Amount (Actual) (ACY)");
              ELSE
                CostElementBuf.AddActualCost(
                  CostElementBuf.Type::Variance,CostElementBuf."Variance Type"::" ",
                  "Cost Amount (Actual)","Cost Amount (Actual) (ACY)");
            END;
        UNTIL NEXT = 0;

        CostElementBuf.CALCSUMS("Actual Cost","Actual Cost (ACY)");
        CostElementBuf.AddActualCost(
          CostElementBuf.Type::Total,0,CostElementBuf."Actual Cost",CostElementBuf."Actual Cost (ACY)");
      END;
    END;

    LOCAL PROCEDURE EliminateRndgResidual@15(InbndItemLedgEntry@1000 : Record 32;AppliedQty@1005 : Decimal);
    VAR
      ItemJnlLine@1001 : Record 83;
      ValueEntry@1002 : Record 5802;
      RndgCost@1003 : Decimal;
      RndgCostACY@1004 : Decimal;
    BEGIN
      IF IsRndgAllowed(InbndItemLedgEntry,AppliedQty) THEN
        WITH InbndItemLedgEntry DO BEGIN
          TempInvtAdjmtBuf.CalcItemLedgEntryCost("Entry No.",FALSE);
          ValueEntry.CalcItemLedgEntryCost("Entry No.",FALSE);
          ValueEntry.AddCost(TempInvtAdjmtBuf);

          RndgResidualBuf.SETRANGE("Item Ledger Entry No.","Entry No.");
          RndgResidualBuf.SETRANGE("Completely Invoiced",FALSE);
          IF RndgResidualBuf.ISEMPTY THEN BEGIN
            RndgResidualBuf.SETRANGE("Completely Invoiced");
            RndgResidualBuf.CALCSUMS("Adjusted Cost","Adjusted Cost (ACY)");
            RndgCost := -(ValueEntry."Cost Amount (Actual)" + RndgResidualBuf."Adjusted Cost");
            RndgCostACY := -(ValueEntry."Cost Amount (Actual) (ACY)" + RndgResidualBuf."Adjusted Cost (ACY)");

            IF HasNewCost(RndgCost,RndgCostACY) THEN BEGIN
              ValueEntry.RESET;
              ValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
              ValueEntry.SETRANGE("Item Ledger Entry No.","Entry No.");
              ValueEntry.SETRANGE("Entry Type",ValueEntry."Entry Type"::"Direct Cost");
              ValueEntry.SETRANGE("Item Charge No.",'');
              ValueEntry.SETRANGE(Adjustment,FALSE);
              ValueEntry.FINDLAST;
              InitRndgResidualItemJnlLine(ItemJnlLine,ValueEntry);
              PostItemJnlLine(ItemJnlLine,ValueEntry,RndgCost,RndgCostACY);
            END;
          END;
        END;

      RndgResidualBuf.RESET;
      RndgResidualBuf.DELETEALL;
    END;

    LOCAL PROCEDURE IsRndgAllowed@10(ItemLedgEntry@1000 : Record 32;AppliedQty@1001 : Decimal) : Boolean;
    BEGIN
      EXIT(
        NOT ItemLedgEntry.Open AND
        ItemLedgEntry."Completely Invoiced" AND
        ItemLedgEntry.Positive AND
        (AppliedQty = -ItemLedgEntry.Quantity) AND
        NOT LevelExceeded);
    END;

    LOCAL PROCEDURE InitRndgResidualItemJnlLine@6(VAR ItemJnlLine@1004 : Record 83;OrigValueEntry@1000 : Record 5802);
    BEGIN
      WITH OrigValueEntry DO BEGIN
        ItemJnlLine.INIT;
        ItemJnlLine."Value Entry Type" := ItemJnlLine."Value Entry Type"::Rounding;
        ItemJnlLine."Quantity (Base)" := 1;
        ItemJnlLine."Invoiced Qty. (Base)" := 1;
        ItemJnlLine."Source No." := "Source No.";
      END;
    END;

    LOCAL PROCEDURE AdjustItemAvgCost@8(VAR TempAvgCostAdjmtEntryPointToUpd@1006 : TEMPORARY Record 5804);
    VAR
      TempOutbndValueEntry@1002 : TEMPORARY Record 5802;
      TempExcludedValueEntry@1003 : TEMPORARY Record 5802;
      TempAvgCostAdjmtEntryPoint@1000 : TEMPORARY Record 5804;
      AvgCostAdjmtEntryPoint@1001 : Record 5804;
      RemainingOutbnd@1004 : Integer;
      Restart@1005 : Boolean;
    BEGIN
      IF NOT IsAvgCostItem THEN
        EXIT;

      UpDateWindow(WindowAdjmtLevel,WindowItem,Text008,WindowFWLevel,WindowEntry,0);

      TempFixApplBuffer.RESET;
      TempFixApplBuffer.DELETEALL;
      DeleteAvgBuffers(TempOutbndValueEntry,TempExcludedValueEntry);

      WITH AvgCostAdjmtEntryPoint DO
        WHILE AvgCostAdjmtEntryPointExist(TempAvgCostAdjmtEntryPoint) DO
          REPEAT
            Restart := FALSE;
            AvgCostAdjmtEntryPoint := TempAvgCostAdjmtEntryPoint;

            IF (ConsumpAdjmtInPeriodWithOutput <> 0D) AND
               (ConsumpAdjmtInPeriodWithOutput <= "Valuation Date")
            THEN
              EXIT;

            SetAvgCostAjmtFilter(TempAvgCostAdjmtEntryPoint);
            CopyAdjmtEntryPointToBuf(TempAvgCostAdjmtEntryPoint,TempAvgCostAdjmtEntryPointToUpd);
            TempAvgCostAdjmtEntryPoint.DELETEALL;
            TempAvgCostAdjmtEntryPoint.RESET;

            SetAvgCostAjmtFilter(AvgCostAdjmtEntryPoint);
            MODIFYALL("Cost Is Adjusted",TRUE);
            RESET;

            WHILE NOT Restart AND AvgValueEntriesToAdjustExist(
                    TempOutbndValueEntry,TempExcludedValueEntry,AvgCostAdjmtEntryPoint)
            DO BEGIN
              RemainingOutbnd := TempOutbndValueEntry.COUNT;
              TempOutbndValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
              TempOutbndValueEntry.FIND('-');

              REPEAT
                UpDateWindow(WindowAdjmtLevel,WindowItem,WindowAdjust,WindowFWLevel,WindowEntry,RemainingOutbnd);
                RemainingOutbnd -= 1;
                AdjustOutbndAvgEntry(TempOutbndValueEntry,TempExcludedValueEntry,TempAvgCostAdjmtEntryPointToUpd);
                UpdateConsumpAvgEntry(TempOutbndValueEntry);
              UNTIL TempOutbndValueEntry.NEXT = 0;

              SetAvgCostAjmtFilter(AvgCostAdjmtEntryPoint);
              Restart := FINDFIRST AND NOT "Cost Is Adjusted";
              "Valuation Date" := GetNextDate("Valuation Date");
            END;
          UNTIL (TempAvgCostAdjmtEntryPoint.NEXT = 0) OR Restart;
    END;

    LOCAL PROCEDURE AvgCostAdjmtEntryPointExist@80(VAR ToAvgCostAdjmtEntryPoint@1000 : Record 5804) : Boolean;
    VAR
      AvgCostAdjmtEntryPoint@1001 : Record 5804;
    BEGIN
      AvgCostAdjmtEntryPoint.SETCURRENTKEY("Item No.","Cost Is Adjusted","Valuation Date");
      AvgCostAdjmtEntryPoint.SETRANGE("Item No.",Item."No.");
      AvgCostAdjmtEntryPoint.SETRANGE("Cost Is Adjusted",FALSE);

      CopyAvgCostAdjmtToAvgCostAdjmt(AvgCostAdjmtEntryPoint,ToAvgCostAdjmtEntryPoint);
      ToAvgCostAdjmtEntryPoint.SETCURRENTKEY("Item No.","Cost Is Adjusted","Valuation Date");
      EXIT(ToAvgCostAdjmtEntryPoint.FINDFIRST);
    END;

    LOCAL PROCEDURE AvgValueEntriesToAdjustExist@79(VAR OutbndValueEntry@1003 : Record 5802;VAR ExcludedValueEntry@1000 : Record 5802;VAR AvgCostAdjmtEntryPoint@1001 : Record 5804) : Boolean;
    VAR
      ValueEntry@1002 : Record 5802;
      CalendarPeriod@1004 : Record 2000000007;
      FiscalYearAccPeriod@1005 : Record 50;
      FindNextRange@1006 : Boolean;
    BEGIN
      WITH ValueEntry DO BEGIN
        FindNextRange := FALSE;
        ResetAvgBuffers(OutbndValueEntry,ExcludedValueEntry);

        CalendarPeriod."Period Start" := AvgCostAdjmtEntryPoint."Valuation Date";
        AvgCostAdjmtEntryPoint.GetValuationPeriod(CalendarPeriod);

        SETCURRENTKEY("Item No.","Valuation Date","Location Code","Variant Code");
        SETRANGE("Item No.",AvgCostAdjmtEntryPoint."Item No.");
        IF AvgCostAdjmtEntryPoint.AvgCostCalcTypeIsChanged(CalendarPeriod."Period Start") THEN BEGIN
          AvgCostAdjmtEntryPoint.GetAvgCostCalcTypeIsChgPeriod(FiscalYearAccPeriod,CalendarPeriod."Period Start");
          SETRANGE("Valuation Date",CalendarPeriod."Period Start",CALCDATE('<-1D>',FiscalYearAccPeriod."Starting Date"));
        END ELSE
          SETRANGE("Valuation Date",CalendarPeriod."Period Start",DMY2DATE(31,12,9999));

        IsAvgCostCalcTypeItem := AvgCostAdjmtEntryPoint.IsAvgCostCalcTypeItem(CalendarPeriod."Period End");
        IF NOT IsAvgCostCalcTypeItem THEN BEGIN
          SETRANGE("Location Code",AvgCostAdjmtEntryPoint."Location Code");
          SETRANGE("Variant Code",AvgCostAdjmtEntryPoint."Variant Code");
        END;

        IF FINDFIRST THEN BEGIN
          FindNextRange := TRUE;

          IF "Valuation Date" > CalendarPeriod."Period End" THEN BEGIN
            AvgCostAdjmtEntryPoint."Valuation Date" := "Valuation Date";
            CalendarPeriod."Period Start" := "Valuation Date";
            AvgCostAdjmtEntryPoint.GetValuationPeriod(CalendarPeriod);
          END;

          IF NOT (AvgCostAdjmtEntryPoint.ValuationExists(ValueEntry) AND
                  AvgCostAdjmtEntryPoint.PrevValuationAdjusted(ValueEntry)) OR
             ((ConsumpAdjmtInPeriodWithOutput <> 0D) AND
              (ConsumpAdjmtInPeriodWithOutput <= AvgCostAdjmtEntryPoint."Valuation Date"))
          THEN BEGIN
            AvgCostAdjmtEntryPoint.UpdateValuationDate(ValueEntry);
            EXIT(FALSE);
          END;

          SETRANGE("Valuation Date",CalendarPeriod."Period Start",CalendarPeriod."Period End");
          IsAvgCostCalcTypeItem := AvgCostAdjmtEntryPoint.IsAvgCostCalcTypeItem(CalendarPeriod."Period End");
          IF NOT IsAvgCostCalcTypeItem THEN BEGIN
            SETRANGE("Location Code",AvgCostAdjmtEntryPoint."Location Code");
            SETRANGE("Variant Code",AvgCostAdjmtEntryPoint."Variant Code");
          END;

          OutbndValueEntry.COPY(ValueEntry);
          IF NOT OutbndValueEntry.ISEMPTY THEN BEGIN
            OutbndValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
            EXIT(TRUE);
          END;

          DeleteAvgBuffers(OutbndValueEntry,ExcludedValueEntry);
          FINDSET;
          REPEAT
            IF "Partial Revaluation" THEN BEGIN
              RevaluationPoint.Number := "Entry No.";
              IF RevaluationPoint.INSERT THEN ;
              FillFixApplBuffer("Item Ledger Entry No.");
            END;

            IF "Valued By Average Cost" AND NOT Adjustment AND ("Valued Quantity" < 0) THEN BEGIN
              OutbndValueEntry := ValueEntry;
              OutbndValueEntry.INSERT;
              FindNextRange := FALSE;
            END;

            IF NOT Adjustment THEN
              IF IsAvgCostException(IsAvgCostCalcTypeItem) THEN BEGIN
                AvgCostExceptionBuf.Number := "Entry No.";
                IF AvgCostExceptionBuf.INSERT THEN;
                AvgCostExceptionBuf.Number += 1;
                IF AvgCostExceptionBuf.INSERT THEN;
              END;

            ExcludedValueEntry := ValueEntry;
            ExcludedValueEntry.INSERT;
          UNTIL NEXT = 0;
          FetchOpenItemEntriesToExclude(AvgCostAdjmtEntryPoint,ExcludedValueEntry,TempOpenItemLedgEntry,CalendarPeriod);
        END;

        IF FindNextRange THEN BEGIN
          AvgCostAdjmtEntryPoint."Valuation Date" := GetNextDate(AvgCostAdjmtEntryPoint."Valuation Date");
          AvgValueEntriesToAdjustExist(OutbndValueEntry,ExcludedValueEntry,AvgCostAdjmtEntryPoint);
        END;

        EXIT(NOT OutbndValueEntry.ISEMPTY AND NOT ISEMPTY);
      END;
    END;

    LOCAL PROCEDURE GetNextDate@74(CurrentDate@1000 : Date) : Date;
    BEGIN
      IF CurrentDate = 0D THEN
        EXIT(01010002D);
      EXIT(CALCDATE('<+1D>',CurrentDate));
    END;

    LOCAL PROCEDURE AdjustOutbndAvgEntry@11(VAR OutbndValueEntry@1000 : Record 5802;VAR ExcludedValueEntry@1002 : Record 5802;VAR TempAvgCostAdjmtEntryPoint@1003 : TEMPORARY Record 5804);
    VAR
      OutbndItemLedgEntry@1007 : Record 32;
      OldCostElementBuf@1016 : TEMPORARY Record 5820;
      NewCostElementBuf@1001 : TEMPORARY Record 5820;
      EntryAdjusted@1009 : Boolean;
    BEGIN
      OutbndItemLedgEntry.GET(OutbndValueEntry."Item Ledger Entry No.");
      IF OutbndItemLedgEntry."Applies-to Entry" <> 0 THEN
        EXIT;
      IF ExpCostIsCompletelyInvoiced(OutbndItemLedgEntry,OutbndValueEntry) THEN
        EXIT;

      WITH NewCostElementBuf DO BEGIN
        UpDateWindow(
          WindowAdjmtLevel,WindowItem,WindowAdjust,WindowFWLevel,OutbndValueEntry."Item Ledger Entry No.",WindowOutbndEntry);

        EntryAdjusted := OutbndItemLedgEntry.SetAvgTransCompletelyInvoiced;

        IF CalcAvgCost(OutbndValueEntry,NewCostElementBuf,ExcludedValueEntry) THEN BEGIN
          CalcOutbndDocOldCost(OldCostElementBuf,OutbndValueEntry,FALSE);
          IF OutbndValueEntry."Expected Cost" THEN BEGIN
            "Actual Cost" := "Actual Cost" - OldCostElementBuf."Expected Cost";
            "Actual Cost (ACY)" := "Actual Cost (ACY)" - OldCostElementBuf."Expected Cost (ACY)";
          END ELSE BEGIN
            "Actual Cost" := "Actual Cost" - OldCostElementBuf."Actual Cost";
            "Actual Cost (ACY)" := "Actual Cost (ACY)" - OldCostElementBuf."Actual Cost (ACY)";
          END;
          IF UpdateAdjmtBuf(
               OutbndValueEntry,"Actual Cost","Actual Cost (ACY)",OutbndItemLedgEntry."Posting Date",
               OutbndValueEntry."Entry Type",TempAvgCostAdjmtEntryPoint)
          THEN
            EntryAdjusted := TRUE;
        END;

        IF EntryAdjusted THEN BEGIN
          IF OutbndItemLedgEntry."Entry Type" = OutbndItemLedgEntry."Entry Type"::Consumption THEN
            OutbndItemLedgEntry.SetAppliedEntryToAdjust(FALSE);

          ForwardAvgCostToInbndEntries(OutbndItemLedgEntry."Entry No.",TempAvgCostAdjmtEntryPoint);
        END;
      END;
    END;

    LOCAL PROCEDURE ExpCostIsCompletelyInvoiced@71(ItemLedgEntry@1002 : Record 32;ValueEntry@1000 : Record 5802) : Boolean;
    BEGIN
      WITH ItemLedgEntry DO
        EXIT(ValueEntry."Expected Cost" AND (Quantity = "Invoiced Quantity"));
    END;

    LOCAL PROCEDURE CalcAvgCost@5(OutbndValueEntry@1000 : Record 5802;VAR CostElementBuf@1001 : Record 5820;VAR ExcludedValueEntry@1002 : Record 5802) : Boolean;
    VAR
      ValueEntry@1009 : Record 5802;
    BEGIN
      WITH ValueEntry DO BEGIN
        IF OutbndValueEntry."Entry No." >= AvgCostBuf."Last Valid Value Entry No" THEN BEGIN
          SumCostsTillValuationDate(OutbndValueEntry);
          TempInvtAdjmtBuf.SumCostsTillValuationDate(OutbndValueEntry);
          CostElementBuf."Remaining Quantity" := "Item Ledger Entry Quantity";
          CostElementBuf."Actual Cost" :=
            "Cost Amount (Actual)" + "Cost Amount (Expected)" +
            TempInvtAdjmtBuf."Cost Amount (Actual)" + TempInvtAdjmtBuf."Cost Amount (Expected)";
          CostElementBuf."Actual Cost (ACY)" :=
            "Cost Amount (Actual) (ACY)" + "Cost Amount (Expected) (ACY)" +
            TempInvtAdjmtBuf."Cost Amount (Actual) (ACY)" + TempInvtAdjmtBuf."Cost Amount (Expected) (ACY)";

          ExcludeAvgCostOnValuationDate(CostElementBuf,OutbndValueEntry,ExcludedValueEntry);
          AvgCostBuf.UpdateAvgCostBuffer(
            CostElementBuf,GetLastValidValueEntry(OutbndValueEntry."Entry No."));
        END ELSE
          CostElementBuf.UpdateCostElementBuffer(AvgCostBuf);

        IF CostElementBuf."Remaining Quantity" > 0 THEN BEGIN
          CostElementBuf.RoundActualCost(
            OutbndValueEntry."Valued Quantity" / CostElementBuf."Remaining Quantity",
            GLSetup."Amount Rounding Precision",Currency."Amount Rounding Precision");

          AvgCostBuf.DeductOutbndValueEntryFromBuf(OutbndValueEntry,CostElementBuf,IsAvgCostCalcTypeItem);
        END;

        EXIT(CostElementBuf."Remaining Quantity" > 0);
      END;
    END;

    LOCAL PROCEDURE ExcludeAvgCostOnValuationDate@68(VAR CostElementBuf@1000 : Record 5820;OutbndValueEntry@1001 : Record 5802;VAR ExcludedValueEntry@1003 : Record 5802);
    VAR
      OutbndItemLedgEntry@1005 : Record 32;
      ItemApplnEntry@1002 : Record 339;
      ItemLedgEntryInChain@1004 : TEMPORARY Record 32;
      FirstValueEntry@1011 : Record 5802;
      AvgCostAdjmtEntryPoint@1013 : Record 5804;
      ExcludeILE@1008 : Boolean;
      ExcludeEntry@1006 : Boolean;
      FixedApplication@1007 : Boolean;
      PreviousILENo@1009 : Integer;
      RevalFixedApplnQty@1010 : Decimal;
      ExclusionFactor@1012 : Decimal;
    BEGIN
      WITH ExcludedValueEntry DO BEGIN
        SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
        OutbndItemLedgEntry.GET(OutbndValueEntry."Item Ledger Entry No.");
        ItemApplnEntry.GetVisitedEntries(OutbndItemLedgEntry,ItemLedgEntryInChain,TRUE);

        ItemLedgEntryInChain.RESET;
        ItemLedgEntryInChain.SETCURRENTKEY("Item No.",Positive,"Location Code","Variant Code");
        ItemLedgEntryInChain.SETRANGE("Item No.","Item No.");
        ItemLedgEntryInChain.SETRANGE(Positive,TRUE);
        IF NOT AvgCostAdjmtEntryPoint.IsAvgCostCalcTypeItem("Valuation Date") THEN BEGIN
          ItemLedgEntryInChain.SETRANGE("Location Code","Location Code");
          ItemLedgEntryInChain.SETRANGE("Variant Code","Variant Code");
        END;

        IF FINDSET THEN
          REPEAT
            // Execute this block for the first Value Entry for each ILE
            IF PreviousILENo <> "Item Ledger Entry No." THEN BEGIN
              // Calculate whether a Value Entry should be excluded from average cost calculation based on ILE information
              // All fixed application entries (except revaluation) are included in the buffer because the inbound and outbound entries cancel each other
              FixedApplication := FALSE;
              ExcludeILE := IsExcludeILEFromAvgCostCalc(ExcludedValueEntry,OutbndValueEntry,ItemLedgEntryInChain,FixedApplication);
              PreviousILENo := "Item Ledger Entry No.";
              IF ("Entry Type" = "Entry Type"::"Direct Cost") AND ("Item Charge No." = '') THEN
                FirstValueEntry := ExcludedValueEntry
              ELSE BEGIN
                FirstValueEntry.SETRANGE("Item Ledger Entry No.","Item Ledger Entry No.");
                FirstValueEntry.SETRANGE("Entry Type","Entry Type"::"Direct Cost");
                FirstValueEntry.SETRANGE("Item Charge No.",'');
                FirstValueEntry.FINDFIRST;
              END;
            END;

            ExcludeEntry := ExcludeILE;

            IF FixedApplication THEN BEGIN
              // If a revaluation entry should normally be excluded, but has a partial fixed application to an outbound, then the fixed applied portion should still be included in the buffer
              IF "Entry Type" = "Entry Type"::Revaluation THEN BEGIN
                IF IsExcludeFromAvgCostForRevalPoint(ExcludedValueEntry,OutbndValueEntry) THEN BEGIN
                  RevalFixedApplnQty := CalcRevalFixedApplnQty(ExcludedValueEntry);
                  IF RevalFixedApplnQty <> "Valued Quantity" THEN BEGIN
                    ExcludeEntry := TRUE;
                    ExclusionFactor := ("Valued Quantity" - RevalFixedApplnQty) / "Valued Quantity";
                    "Cost Amount (Actual)" := RoundAmt(ExclusionFactor * "Cost Amount (Actual)",GLSetup."Amount Rounding Precision");
                    "Cost Amount (Expected)" :=
                      RoundAmt(ExclusionFactor * "Cost Amount (Expected)",GLSetup."Amount Rounding Precision");
                    "Cost Amount (Actual) (ACY)" :=
                      RoundAmt(ExclusionFactor * "Cost Amount (Actual) (ACY)",Currency."Amount Rounding Precision");
                    "Cost Amount (Expected) (ACY)" :=
                      RoundAmt(ExclusionFactor * "Cost Amount (Expected) (ACY)",Currency."Amount Rounding Precision");
                  END;
                END;
              END
            END ELSE
              // For non-fixed applied entries
              // For each value entry, perform additional check if there has been a revaluation in the period
              IF NOT ExcludeEntry THEN
                // For non-revaluation entries, exclusion decision is based on the date of the first posted Direct Cost entry for the ILE to ensure all cost modifiers except revaluation
                // are included or excluded based on the original item posting date
                IF "Entry Type" = "Entry Type"::Revaluation THEN
                  ExcludeEntry := IsExcludeFromAvgCostForRevalPoint(ExcludedValueEntry,OutbndValueEntry)
                ELSE
                  ExcludeEntry := IsExcludeFromAvgCostForRevalPoint(FirstValueEntry,OutbndValueEntry);

            IF ExcludeEntry THEN BEGIN
              CostElementBuf.ExcludeEntryFromAvgCostCalc(ExcludedValueEntry);
              IF TempInvtAdjmtBuf.GET("Entry No.") THEN
                CostElementBuf.ExcludeBufFromAvgCostCalc(TempInvtAdjmtBuf);
            END;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE IsExcludeILEFromAvgCostCalc@36(ValueEntry@1000 : Record 5802;OutbndValueEntry@1001 : Record 5802;VAR ItemLedgEntryInChain@1003 : Record 32;VAR FixedApplication@1004 : Boolean) : Boolean;
    VAR
      ItemLedgEntry@1002 : Record 32;
    BEGIN
      WITH ValueEntry DO BEGIN
        IF TempOpenItemLedgEntry.GET("Item Ledger Entry No.") THEN
          EXIT(TRUE);

        // fixed application is taken out
        IF TempFixApplBuffer.GET("Item Ledger Entry No.") THEN BEGIN
          FixedApplication := TRUE;
          EXIT(FALSE);
        END;

        IF "Item Ledger Entry No." = OutbndValueEntry."Item Ledger Entry No." THEN
          EXIT(TRUE);

        ItemLedgEntry.GET("Item Ledger Entry No.");

        IF ItemLedgEntryInChain.GET("Item Ledger Entry No.") THEN
          EXIT(TRUE);

        IF NOT "Valued By Average Cost" THEN
          EXIT(FALSE);

        IF NOT ItemLedgEntryInChain.ISEMPTY THEN
          EXIT(TRUE);

        IF NOT ItemLedgEntry.Positive THEN
          EXIT("Item Ledger Entry No." > OutbndValueEntry."Item Ledger Entry No.");

        EXIT(FALSE);
      END;
    END;

    LOCAL PROCEDURE IsExcludeFromAvgCostForRevalPoint@43(VAR RevaluationCheckValueEntry@1000 : Record 5802;VAR OutbndValueEntry@1002 : Record 5802) : Boolean;
    BEGIN
      RevaluationPoint.SETRANGE(Number,RevaluationCheckValueEntry."Entry No.",OutbndValueEntry."Entry No.");
      IF NOT RevaluationPoint.ISEMPTY THEN
        EXIT(NOT IncludedInCostCalculation(RevaluationCheckValueEntry,OutbndValueEntry."Item Ledger Entry No."));

      RevaluationPoint.SETRANGE(Number,OutbndValueEntry."Entry No.",RevaluationCheckValueEntry."Entry No.");
      IF NOT RevaluationPoint.ISEMPTY THEN
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CalcRevalFixedApplnQty@44(RevaluationValueEntry@1000 : Record 5802) : Decimal;
    VAR
      ItemApplicationEntry@1001 : Record 339;
      FixedApplQty@1002 : Decimal;
    BEGIN
      ItemApplicationEntry.SETRANGE("Inbound Item Entry No.",RevaluationValueEntry."Item Ledger Entry No.");
      ItemApplicationEntry.SETFILTER("Outbound Item Entry No.",'<>%1',0);
      IF ItemApplicationEntry.FINDSET THEN
        REPEAT
          IF IncludedInCostCalculation(RevaluationValueEntry,ItemApplicationEntry."Outbound Item Entry No.") AND
             TempFixApplBuffer.GET(ItemApplicationEntry."Outbound Item Entry No.")
          THEN
            FixedApplQty -= ItemApplicationEntry.Quantity;
        UNTIL ItemApplicationEntry.NEXT = 0;

      EXIT(FixedApplQty);
    END;

    LOCAL PROCEDURE UpdateAvgCostAdjmtEntryPoint@7(ValueEntry@1000 : Record 5802;VAR TempAvgCostAdjmtEntryPoint@1002 : TEMPORARY Record 5804);
    VAR
      AvgCostAdjmtEntryPoint@1001 : Record 5804;
    BEGIN
      AvgCostAdjmtEntryPoint.UpdateValuationDate(ValueEntry);
      InsertEntryPointToUpdate(TempAvgCostAdjmtEntryPoint,ValueEntry."Item No.",ValueEntry."Variant Code",ValueEntry."Location Code");
    END;

    LOCAL PROCEDURE UpdateConsumpAvgEntry@21(ValueEntry@1000 : Record 5802);
    VAR
      ItemLedgEntry@1003 : Record 32;
      ConsumpItemLedgEntry@1004 : Record 32;
      AvgCostAdjmtPoint@1001 : Record 5804;
    BEGIN
      // Determine if average costed consumption is completely invoiced
      WITH ValueEntry DO BEGIN
        IF "Item Ledger Entry Type" <> "Item Ledger Entry Type"::Consumption THEN
          EXIT;

        ConsumpItemLedgEntry.GET("Item Ledger Entry No.");
        IF NOT ConsumpItemLedgEntry."Completely Invoiced" THEN
          IF NOT IsDeletedItem THEN BEGIN
            ItemLedgEntry.SETCURRENTKEY("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
            ItemLedgEntry.SETRANGE("Item No.","Item No.");
            IF NOT AvgCostAdjmtPoint.IsAvgCostCalcTypeItem("Valuation Date") THEN BEGIN
              ItemLedgEntry.SETRANGE("Variant Code","Variant Code");
              ItemLedgEntry.SETRANGE("Location Code","Location Code");
            END;
            ItemLedgEntry.SETRANGE("Posting Date",0D,"Valuation Date");
            ItemLedgEntry.CALCSUMS("Invoiced Quantity");
            IF ItemLedgEntry."Invoiced Quantity" >= 0 THEN BEGIN
              ConsumpItemLedgEntry.SetCompletelyInvoiced;
              ConsumpItemLedgEntry.SetAppliedEntryToAdjust(FALSE);
            END;
          END ELSE BEGIN
            ConsumpItemLedgEntry.SetCompletelyInvoiced;
            ConsumpItemLedgEntry.SetAppliedEntryToAdjust(FALSE);
          END;
      END;
    END;

    LOCAL PROCEDURE ForwardAvgCostToInbndEntries@83(ItemLedgEntryNo@1001 : Integer;VAR TempAvgCostAdjmtEntryPoint@1000 : TEMPORARY Record 5804);
    VAR
      ItemApplnEntry@1002 : Record 339;
    BEGIN
      WITH ItemApplnEntry DO BEGIN
        IF AppliedInbndEntryExists(ItemLedgEntryNo,TRUE) THEN
          REPEAT
            LevelNo[3] := 0;
            AdjustAppliedInbndEntries(ItemApplnEntry,TempAvgCostAdjmtEntryPoint);
            IF LevelExceeded THEN BEGIN
              LevelExceeded := FALSE;

              UpDateWindow(WindowAdjmtLevel,WindowItem,WindowAdjust,LevelNo[3],WindowEntry,WindowOutbndEntry);
              AdjustItemAppliedCost(TempAvgCostAdjmtEntryPoint);
              UpDateWindow(WindowAdjmtLevel,WindowItem,Text008,WindowFWLevel,WindowEntry,WindowOutbndEntry);
            END;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE WIPToAdjustExist@65(VAR ToInventoryAdjmtEntryOrder@1000 : Record 5896) : Boolean;
    VAR
      InventoryAdjmtEntryOrder@1001 : Record 5896;
    BEGIN
      WITH InventoryAdjmtEntryOrder DO BEGIN
        RESET;
        SETCURRENTKEY("Cost is Adjusted","Allow Online Adjustment");
        SETRANGE("Cost is Adjusted",FALSE);
        SETRANGE("Order Type","Order Type"::Production);
        SETRANGE("Is Finished",TRUE);
        IF IsOnlineAdjmt THEN
          SETRANGE("Allow Online Adjustment",TRUE);

        CopyOrderAdmtEntryToOrderAdjmt(InventoryAdjmtEntryOrder,ToInventoryAdjmtEntryOrder);
        EXIT(ToInventoryAdjmtEntryOrder.FINDFIRST);
      END;
    END;

    LOCAL PROCEDURE MakeWIPAdjmt@62(VAR SourceInvtAdjmtEntryOrder@1000 : Record 5896);
    VAR
      InvtAdjmtEntryOrder@1003 : Record 5896;
      CalcInventoryAdjmtOrder@1002 : Codeunit 5896;
      DoNotSkipItems@1001 : Boolean;
    BEGIN
      DoNotSkipItems := FilterItem.GETFILTERS = '';
      WITH SourceInvtAdjmtEntryOrder DO
        IF FINDSET THEN
          REPEAT
            IF TRUE IN [DoNotSkipItems,ItemInFilteredSetExists("Item No.",FilterItem)] THEN BEGIN
              GetItem("Item No.");
              UpDateWindow(WindowAdjmtLevel,"Item No.",Text009,0,0,0);

              InvtAdjmtEntryOrder := SourceInvtAdjmtEntryOrder;
              CalcInventoryAdjmtOrder.Calculate(SourceInvtAdjmtEntryOrder,TempInvtAdjmtBuf);
              PostOutputAdjmtBuf;

              IF NOT "Completely Invoiced" THEN BEGIN
                InvtAdjmtEntryOrder.GetUnitCostsFromItem;
                InvtAdjmtEntryOrder."Completely Invoiced" := TRUE;
              END;
              InvtAdjmtEntryOrder."Cost is Adjusted" := TRUE;
              InvtAdjmtEntryOrder."Allow Online Adjustment" := TRUE;
              InvtAdjmtEntryOrder.MODIFY;
            END;
          UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE ItemInFilteredSetExists@67(ItemNo@1000 : Code[20];VAR FilteredItem@1001 : Record 27) : Boolean;
    VAR
      TempItem@1002 : TEMPORARY Record 27;
      Item@1003 : Record 27;
    BEGIN
      WITH TempItem DO BEGIN
        IF NOT Item.GET(ItemNo) THEN
          EXIT(FALSE);
        COPYFILTERS(FilteredItem);
        TempItem := Item;
        INSERT;
        EXIT(NOT ISEMPTY);
      END;
    END;

    LOCAL PROCEDURE PostOutputAdjmtBuf@19();
    BEGIN
      WITH TempInvtAdjmtBuf DO BEGIN
        RESET;
        IF FINDSET THEN
          REPEAT
            PostOutput(TempInvtAdjmtBuf);
          UNTIL NEXT = 0;
        DELETEALL;
      END;
    END;

    LOCAL PROCEDURE PostOutput@28(InvtAdjmtBuf@1003 : Record 5895);
    VAR
      ItemJnlLine@1005 : Record 83;
      OrigItemLedgEntry@1001 : Record 32;
      OrigValueEntry@1000 : Record 5802;
    BEGIN
      OrigValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
      OrigValueEntry.SETRANGE("Item Ledger Entry No.",TempInvtAdjmtBuf."Item Ledger Entry No.");
      OrigValueEntry.FINDFIRST;

      WITH OrigValueEntry DO BEGIN
        ItemJnlLine.INIT;
        ItemJnlLine."Value Entry Type" := InvtAdjmtBuf."Entry Type";
        ItemJnlLine."Variance Type" := InvtAdjmtBuf."Variance Type";
        ItemJnlLine."Invoiced Quantity" := "Item Ledger Entry Quantity";
        ItemJnlLine."Invoiced Qty. (Base)" := "Item Ledger Entry Quantity";
        ItemJnlLine."Qty. per Unit of Measure" := 1;
        ItemJnlLine."Source Type" := "Source Type";
        ItemJnlLine."Source No." := "Source No.";
        ItemJnlLine.Description := Description;
        ItemJnlLine.Adjustment := "Order Type" = "Order Type"::Assembly;
        OrigItemLedgEntry.GET("Item Ledger Entry No.");
        ItemJnlLine.Adjustment := ("Order Type" = "Order Type"::Assembly) AND (OrigItemLedgEntry."Invoiced Quantity" <> 0);

        PostItemJnlLine(ItemJnlLine,OrigValueEntry,InvtAdjmtBuf."Cost Amount (Actual)",InvtAdjmtBuf."Cost Amount (Actual) (ACY)");

        OrigItemLedgEntry.GET("Item Ledger Entry No.");
        IF NOT OrigItemLedgEntry."Completely Invoiced" THEN
          OrigItemLedgEntry.SetCompletelyInvoiced;
      END;
    END;

    LOCAL PROCEDURE AssemblyToAdjustExists@89(VAR ToInventoryAdjmtEntryOrder@1000 : Record 5896) : Boolean;
    VAR
      InventoryAdjmtEntryOrder@1001 : Record 5896;
    BEGIN
      WITH InventoryAdjmtEntryOrder DO BEGIN
        RESET;
        SETCURRENTKEY("Cost is Adjusted","Allow Online Adjustment");
        SETRANGE("Cost is Adjusted",FALSE);
        SETRANGE("Order Type","Order Type"::Assembly);
        IF IsOnlineAdjmt THEN
          SETRANGE("Allow Online Adjustment",TRUE);

        CopyOrderAdmtEntryToOrderAdjmt(InventoryAdjmtEntryOrder,ToInventoryAdjmtEntryOrder);
        EXIT(ToInventoryAdjmtEntryOrder.FINDFIRST);
      END;
    END;

    LOCAL PROCEDURE MakeAssemblyAdjmt@77(VAR SourceInvtAdjmtEntryOrder@1000 : Record 5896);
    VAR
      InvtAdjmtEntryOrder@1003 : Record 5896;
      CalcInventoryAdjmtOrder@1002 : Codeunit 5896;
      DoNotSkipItems@1001 : Boolean;
    BEGIN
      DoNotSkipItems := FilterItem.GETFILTERS = '';
      WITH SourceInvtAdjmtEntryOrder DO
        IF FINDSET THEN
          REPEAT
            IF TRUE IN [DoNotSkipItems,ItemInFilteredSetExists("Item No.",FilterItem)] THEN BEGIN
              GetItem("Item No.");
              UpDateWindow(WindowAdjmtLevel,"Item No.",Text010,0,0,0);

              InvtAdjmtEntryOrder := SourceInvtAdjmtEntryOrder;
              CalcInventoryAdjmtOrder.Calculate(SourceInvtAdjmtEntryOrder,TempInvtAdjmtBuf);
              PostOutputAdjmtBuf;

              IF NOT "Completely Invoiced" THEN BEGIN
                InvtAdjmtEntryOrder.GetCostsFromItem(1);
                InvtAdjmtEntryOrder."Completely Invoiced" := TRUE;
              END;
              InvtAdjmtEntryOrder."Allow Online Adjustment" := TRUE;
              InvtAdjmtEntryOrder."Cost is Adjusted" := TRUE;
              InvtAdjmtEntryOrder.MODIFY;
            END;
          UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE UpdateAdjmtBuf@18(OrigValueEntry@1000 : Record 5802;NewAdjustedCost@1001 : Decimal;NewAdjustedCostACY@1002 : Decimal;ItemLedgEntryPostingDate@1005 : Date;EntryType@1007 : Option;VAR TempAvgCostAdjmtEntryPoint@1006 : TEMPORARY Record 5804) : Boolean;
    VAR
      ItemLedgEntry@1004 : Record 32;
      ItemApplnEntry@1003 : Record 339;
      SourceOrigValueEntry@1008 : Record 5802;
    BEGIN
      IF NOT HasNewCost(NewAdjustedCost,NewAdjustedCostACY) THEN
        EXIT(FALSE);

      InsertEntryPointToUpdate(
        TempAvgCostAdjmtEntryPoint,OrigValueEntry."Item No.",OrigValueEntry."Variant Code",OrigValueEntry."Location Code");

      IF OrigValueEntry."Valued By Average Cost" THEN BEGIN
        AvgCostRndgBuf.UpdRoundingCheck(
          OrigValueEntry."Item Ledger Entry No.",NewAdjustedCost,NewAdjustedCostACY,
          GLSetup."Amount Rounding Precision",Currency."Amount Rounding Precision");
        IF AvgCostRndgBuf."No. of Hits" > 42 THEN
          EXIT(FALSE);
      END;

      UpdateValuationPeriodHasOutput(OrigValueEntry);

      TempInvtAdjmtBuf.AddActualCostBuf(OrigValueEntry,NewAdjustedCost,NewAdjustedCostACY,ItemLedgEntryPostingDate);

      IF EntryType = OrigValueEntry."Entry Type"::Variance THEN BEGIN
        GetOrigValueEntry(SourceOrigValueEntry,OrigValueEntry,EntryType);
        TempInvtAdjmtBuf."Entry Type" := EntryType;
        TempInvtAdjmtBuf."Variance Type" := SourceOrigValueEntry."Variance Type";
        TempInvtAdjmtBuf.MODIFY;
      END;

      IF NOT OrigValueEntry."Expected Cost" AND
         (OrigValueEntry."Entry Type" = OrigValueEntry."Entry Type"::"Direct Cost")
      THEN BEGIN
        CalcExpectedCostToBalance(OrigValueEntry,NewAdjustedCost,NewAdjustedCostACY);
        IF HasNewCost(NewAdjustedCost,NewAdjustedCostACY) THEN
          TempInvtAdjmtBuf.AddBalanceExpectedCostBuf(OrigValueEntry,NewAdjustedCost,NewAdjustedCostACY);
      END;

      IF OrigValueEntry."Item Ledger Entry Quantity" >= 0 THEN BEGIN
        ItemLedgEntry.GET(OrigValueEntry."Item Ledger Entry No.");
        ItemApplnEntry.SetOutboundsNotUpdated(ItemLedgEntry);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CalcExpectedCostToBalance@22(OrigValueEntry@1003 : Record 5802;VAR ExpectedCost@1001 : Decimal;VAR ExpectedCostACY@1002 : Decimal);
    VAR
      ItemLedgEntry@1004 : Record 32;
      ShareOfTotalCost@1005 : Decimal;
    BEGIN
      ExpectedCost := 0;
      ExpectedCostACY := 0;
      ItemLedgEntry.GET(OrigValueEntry."Item Ledger Entry No.");

      WITH TempInvtAdjmtBuf DO BEGIN
        RESET;
        SETCURRENTKEY("Item Ledger Entry No.");
        SETRANGE("Item Ledger Entry No.",OrigValueEntry."Item Ledger Entry No.");
        IF FINDFIRST AND "Expected Cost" THEN BEGIN
          CALCSUMS("Cost Amount (Expected)","Cost Amount (Expected) (ACY)");

          IF ItemLedgEntry.Quantity = ItemLedgEntry."Invoiced Quantity" THEN BEGIN
            ExpectedCost := -"Cost Amount (Expected)";
            ExpectedCostACY := -"Cost Amount (Expected) (ACY)";
          END ELSE BEGIN
            ShareOfTotalCost := OrigValueEntry."Invoiced Quantity" / ItemLedgEntry.Quantity;
            ExpectedCost :=
              -RoundAmt("Cost Amount (Expected)" * ShareOfTotalCost,GLSetup."Amount Rounding Precision");
            ExpectedCostACY :=
              -RoundAmt("Cost Amount (Expected) (ACY)" * ShareOfTotalCost,Currency."Amount Rounding Precision");
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE PostAdjmtBuf@17();
    VAR
      ItemJnlLine@1001 : Record 83;
      OrigValueEntry@1000 : Record 5802;
    BEGIN
      WITH TempInvtAdjmtBuf DO BEGIN
        RESET;
        IF FINDSET THEN BEGIN
          REPEAT
            OrigValueEntry.GET("Entry No.");
            IF OrigValueEntry."Expected Cost" THEN BEGIN
              IF HasNewCost("Cost Amount (Expected)","Cost Amount (Expected) (ACY)") THEN BEGIN
                InitAdjmtJnlLine(ItemJnlLine,OrigValueEntry,"Entry Type","Variance Type");
                PostItemJnlLine(ItemJnlLine,OrigValueEntry,"Cost Amount (Expected)","Cost Amount (Expected) (ACY)");
              END;
            END ELSE
              IF HasNewCost("Cost Amount (Actual)","Cost Amount (Actual) (ACY)") THEN BEGIN
                InitAdjmtJnlLine(ItemJnlLine,OrigValueEntry,"Entry Type","Variance Type");
                PostItemJnlLine(ItemJnlLine,OrigValueEntry,"Cost Amount (Actual)","Cost Amount (Actual) (ACY)");
              END;
          UNTIL NEXT = 0;
          DELETEALL;
        END;
      END;
    END;

    LOCAL PROCEDURE InitAdjmtJnlLine@33(VAR ItemJnlLine@1003 : Record 83;OrigValueEntry@1000 : Record 5802;EntryType@1001 : Option;VarianceType@1002 : Option);
    BEGIN
      WITH OrigValueEntry DO BEGIN
        ItemJnlLine."Value Entry Type" := EntryType;
        ItemJnlLine."Partial Revaluation" := "Partial Revaluation";
        ItemJnlLine.Description := Description;
        ItemJnlLine."Source Posting Group" := "Source Posting Group";
        ItemJnlLine."Source No." := "Source No.";
        ItemJnlLine."Salespers./Purch. Code" := "Salespers./Purch. Code";
        ItemJnlLine."Source Type" := "Source Type";
        ItemJnlLine."Reason Code" := "Reason Code";
        ItemJnlLine."Drop Shipment" := "Drop Shipment";
        ItemJnlLine."Document Date" := "Document Date";
        ItemJnlLine."External Document No." := "External Document No.";
        ItemJnlLine."Quantity (Base)" := "Valued Quantity";
        ItemJnlLine."Invoiced Qty. (Base)" := "Invoiced Quantity";
        IF "Item Ledger Entry Type" = "Item Ledger Entry Type"::Output THEN
          ItemJnlLine."Output Quantity (Base)" := ItemJnlLine."Quantity (Base)";
        ItemJnlLine."Item Charge No." := "Item Charge No.";
        ItemJnlLine."Variance Type" := VarianceType;
        ItemJnlLine.Adjustment := TRUE;
        ItemJnlLine."Applies-to Value Entry" := "Entry No.";
        ItemJnlLine."Return Reason Code" := "Return Reason Code";
      END;
    END;

    LOCAL PROCEDURE PostItemJnlLine@35(ItemJnlLine@1001 : Record 83;OrigValueEntry@1000 : Record 5802;NewAdjustedCost@1004 : Decimal;NewAdjustedCostACY@1005 : Decimal);
    VAR
      InvtPeriod@1006 : Record 5814;
    BEGIN
      WITH OrigValueEntry DO BEGIN
        ItemJnlLine."Item No." := "Item No.";
        ItemJnlLine."Location Code" := "Location Code";
        ItemJnlLine."Variant Code" := "Variant Code";

        IF GLSetup.IsPostingAllowed("Posting Date") AND InvtPeriod.IsValidDate("Posting Date") THEN
          ItemJnlLine."Posting Date" := "Posting Date"
        ELSE
          ItemJnlLine."Posting Date" := PostingDateForClosedPeriod;

        ItemJnlLine."Entry Type" := "Item Ledger Entry Type";
        ItemJnlLine."Document No." := "Document No.";
        ItemJnlLine."Document Type" := "Document Type";
        ItemJnlLine."Document Line No." := "Document Line No.";
        ItemJnlLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
        ItemJnlLine."Source Code" := SourceCodeSetup."Adjust Cost";
        ItemJnlLine."Inventory Posting Group" := "Inventory Posting Group";
        ItemJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
        ItemJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
        ItemJnlLine."Order Type" := "Order Type";
        ItemJnlLine."Order No." := "Order No.";
        ItemJnlLine."Order Line No." := "Order Line No.";
        ItemJnlLine."Job No." := "Job No.";
        ItemJnlLine."Job Task No." := "Job Task No.";
        ItemJnlLine.Type := Type;
        IF ItemJnlLine."Value Entry Type" = ItemJnlLine."Value Entry Type"::"Direct Cost" THEN
          ItemJnlLine."Item Shpt. Entry No." := "Item Ledger Entry No."
        ELSE
          ItemJnlLine."Applies-to Entry" := "Item Ledger Entry No.";
        ItemJnlLine.Amount := NewAdjustedCost;
        ItemJnlLine."Amount (ACY)" := NewAdjustedCostACY;

        IF ItemJnlLine."Quantity (Base)" <> 0 THEN BEGIN
          ItemJnlLine."Unit Cost" :=
            RoundAmt(NewAdjustedCost / ItemJnlLine."Quantity (Base)",GLSetup."Unit-Amount Rounding Precision");
          ItemJnlLine."Unit Cost (ACY)" :=
            RoundAmt(NewAdjustedCostACY / ItemJnlLine."Quantity (Base)",Currency."Unit-Amount Rounding Precision");
        END;

        ItemJnlLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
        ItemJnlLine."Dimension Set ID" := "Dimension Set ID";

        IF NOT SkipUpdateJobItemCost AND ("Job No." <> '') THEN
          CopyJobToAdjustmentBuf("Job No.");

        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
      END;
    END;

    LOCAL PROCEDURE RoundCost@76(VAR Cost@1000 : Decimal;VAR RndgResidual@1001 : Decimal;TotalCost@1002 : Decimal;ShareOfTotalCost@1003 : Decimal;AmtRndgPrec@1004 : Decimal);
    VAR
      UnroundedCost@1005 : Decimal;
    BEGIN
      UnroundedCost := TotalCost * ShareOfTotalCost + RndgResidual;
      Cost := RoundAmt(UnroundedCost,AmtRndgPrec);
      RndgResidual := UnroundedCost - Cost;
    END;

    LOCAL PROCEDURE RoundAmt@72(Amt@1001 : Decimal;AmtRndgPrec@1000 : Decimal) : Decimal;
    BEGIN
      IF Amt = 0 THEN
        EXIT(0);
      EXIT(ROUND(Amt,AmtRndgPrec))
    END;

    LOCAL PROCEDURE GetOrigValueEntry@73(VAR OrigValueEntry@1001 : Record 5802;ValueEntry@1000 : Record 5802;ValueEntryType@1004 : Option);
    VAR
      Found@1002 : Boolean;
      IsLastEntry@1003 : Boolean;
    BEGIN
      WITH OrigValueEntry DO BEGIN
        SETCURRENTKEY("Item Ledger Entry No.","Document No.");
        SETRANGE("Item Ledger Entry No.",ValueEntry."Item Ledger Entry No.");
        SETRANGE("Document No.",ValueEntry."Document No.");

        IF FINDSET THEN
          REPEAT
            IF ("Expected Cost" = ValueEntry."Expected Cost") AND
               ("Entry Type" = ValueEntryType)
            THEN BEGIN
              Found := TRUE;
              "Valued Quantity" := ValueEntry."Valued Quantity";
              "Invoiced Quantity" := ValueEntry."Invoiced Quantity";
            END ELSE
              IsLastEntry := NEXT = 0;
          UNTIL Found OR IsLastEntry;

        IF NOT Found THEN BEGIN
          OrigValueEntry := ValueEntry;
          "Entry Type" := ValueEntryType;
          IF ValueEntryType = "Entry Type"::Variance THEN
            "Variance Type" := GetOrigVarianceType(ValueEntry);
        END;
      END;
    END;

    LOCAL PROCEDURE GetOrigVarianceType@60(ValueEntry@1000 : Record 5802) : Integer;
    BEGIN
      WITH ValueEntry DO BEGIN
        IF "Item Ledger Entry Type" IN
           ["Item Ledger Entry Type"::Output,"Item Ledger Entry Type"::"Assembly Output"]
        THEN
          EXIT("Variance Type"::Material);

        EXIT("Variance Type"::Purchase);
      END;
    END;

    LOCAL PROCEDURE UpdateAppliedEntryToAdjustBuf@58(ItemLedgEntryNo@1000 : Integer;AppliedEntryToAdjust@1001 : Boolean);
    BEGIN
      IF AppliedEntryToAdjust THEN
        IF NOT AppliedEntryToAdjustBuf.GET(ItemLedgEntryNo) THEN BEGIN
          AppliedEntryToAdjustBuf.Number := ItemLedgEntryNo;
          AppliedEntryToAdjustBuf.INSERT;
        END;
    END;

    LOCAL PROCEDURE SetAppliedEntryToAdjustFromBuf@38();
    VAR
      ItemLedgEntry@1000 : Record 32;
    BEGIN
      WITH AppliedEntryToAdjustBuf DO
        IF FINDSET THEN BEGIN
          REPEAT
            ItemLedgEntry.GET(Number);
            ItemLedgEntry.SetAppliedEntryToAdjust(TRUE);
          UNTIL NEXT = 0;
          DELETEALL;
        END;
    END;

    LOCAL PROCEDURE UpdateItemUnitCost@42(VAR TempAvgCostAdjmtEntryPoint@1001 : TEMPORARY Record 5804);
    VAR
      AvgCostAdjmtPoint@1000 : Record 5804;
      FilterSKU@1002 : Boolean;
    BEGIN
      WITH Item DO BEGIN
        IF IsDeletedItem THEN
          EXIT;

        LOCKTABLE;
        GET("No.");
        IF NOT LevelExceeded THEN BEGIN
          "Allow Online Adjustment" := TRUE;
          AvgCostAdjmtPoint.SETRANGE("Item No.","No.");
          AvgCostAdjmtPoint.SETRANGE("Cost Is Adjusted",FALSE);
          IF "Costing Method" <> "Costing Method"::Average THEN BEGIN
            IF AvgCostAdjmtPoint.FINDFIRST THEN
              AvgCostAdjmtPoint.MODIFYALL("Cost Is Adjusted",TRUE);
          END;
          "Cost is Adjusted" := AvgCostAdjmtPoint.ISEMPTY;
        END;

        IF "Costing Method" <> "Costing Method"::Standard THEN BEGIN
          IF TempAvgCostAdjmtEntryPoint.FINDSET THEN
            REPEAT
              FilterSKU := (TempAvgCostAdjmtEntryPoint."Location Code" <> '') AND (TempAvgCostAdjmtEntryPoint."Variant Code" <> '');
              ItemCostMgt.UpdateUnitCost(
                Item,TempAvgCostAdjmtEntryPoint."Location Code",TempAvgCostAdjmtEntryPoint."Variant Code",0,0,TRUE,FilterSKU,FALSE,0);
            UNTIL TempAvgCostAdjmtEntryPoint.NEXT = 0
          ELSE
            ItemCostMgt.UpdateUnitCost(Item,'','',0,0,TRUE,FALSE,FALSE,0);
        END ELSE
          MODIFY;
      END;
    END;

    LOCAL PROCEDURE GetItem@14(ItemNo@1001 : Code[20]);
    BEGIN
      IsDeletedItem := ItemNo = '';
      IF (Item."No." <> ItemNo) OR IsDeletedItem THEN
        IF NOT IsDeletedItem THEN
          Item.GET(ItemNo)
        ELSE BEGIN
          CLEAR(Item);
          Item.INIT;
        END;
    END;

    LOCAL PROCEDURE InsertDeletedItem@45(VAR Item@1000 : Record 27);
    BEGIN
      CLEAR(Item);
      Item.INIT;
      Item."Cost is Adjusted" := FALSE;
      Item."Costing Method" := Item."Costing Method"::FIFO;
      Item.INSERT;
    END;

    LOCAL PROCEDURE IsAvgCostItem@50() : Boolean;
    BEGIN
      EXIT(Item."Costing Method" = Item."Costing Method"::Average);
    END;

    LOCAL PROCEDURE HasNewCost@54(NewCost@1000 : Decimal;NewCostACY@1001 : Decimal) : Boolean;
    BEGIN
      EXIT((NewCost <> 0) OR (NewCostACY <> 0));
    END;

    LOCAL PROCEDURE OpenWindow@59();
    BEGIN
      Window.OPEN(
        Text000 +
        '#1########################\\' +
        Text001 +
        Text003 +
        Text004 +
        Text005 +
        Text006);
      WindowIsOpen := TRUE;
    END;

    LOCAL PROCEDURE UpDateWindow@31(NewWindowAdjmtLevel@1004 : Integer;NewWindowItem@1003 : Code[20];NewWindowAdjust@1001 : Text[20];NewWindowFWLevel@1000 : Integer;NewWindowEntry@1002 : Integer;NewWindowOutbndEntry@1005 : Integer);
    BEGIN
      WindowAdjmtLevel := NewWindowAdjmtLevel;
      WindowItem := NewWindowItem;
      WindowAdjust := NewWindowAdjust;
      WindowFWLevel := NewWindowFWLevel;
      WindowEntry := NewWindowEntry;
      WindowOutbndEntry := NewWindowOutbndEntry;

      IF IsTimeForUpdate THEN BEGIN
        IF NOT WindowIsOpen THEN
          OpenWindow;
        Window.UPDATE(1,STRSUBSTNO(Text002,TempInvtAdjmtBuf.FIELDCAPTION("Item No."),WindowItem));
        Window.UPDATE(2,WindowAdjmtLevel);
        Window.UPDATE(3,WindowAdjust);
        Window.UPDATE(4,WindowFWLevel);
        Window.UPDATE(5,WindowEntry);
        Window.UPDATE(6,WindowOutbndEntry);
      END;
    END;

    LOCAL PROCEDURE IsTimeForUpdate@69() : Boolean;
    BEGIN
      IF CURRENTDATETIME - WindowUpdateDateTime >= 1000 THEN BEGIN
        WindowUpdateDateTime := CURRENTDATETIME;
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CopyItemToItem@57(VAR FromItem@1001 : Record 27;VAR ToItem@1000 : Record 27);
    BEGIN
      WITH ToItem DO BEGIN
        RESET;
        DELETEALL;
        IF FromItem.FINDSET THEN
          REPEAT
            ToItem := FromItem;
            INSERT;
          UNTIL FromItem.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CopyILEToILE@49(VAR FromItemLedgEntry@1000 : Record 32;VAR ToItemLedgEntry@1001 : Record 32);
    BEGIN
      WITH ToItemLedgEntry DO BEGIN
        RESET;
        DELETEALL;
        IF FromItemLedgEntry.FINDSET THEN
          REPEAT
            ToItemLedgEntry := FromItemLedgEntry;
            INSERT;
          UNTIL FromItemLedgEntry.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CopyAvgCostAdjmtToAvgCostAdjmt@75(VAR FromAvgCostAdjmtEntryPoint@1000 : Record 5804;VAR ToAvgCostAdjmtEntryPoint@1001 : Record 5804);
    BEGIN
      WITH ToAvgCostAdjmtEntryPoint DO BEGIN
        RESET;
        DELETEALL;
        IF FromAvgCostAdjmtEntryPoint.FINDSET THEN
          REPEAT
            ToAvgCostAdjmtEntryPoint := FromAvgCostAdjmtEntryPoint;
            INSERT;
          UNTIL FromAvgCostAdjmtEntryPoint.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CopyOrderAdmtEntryToOrderAdjmt@120(VAR FromInventoryAdjmtEntryOrder@1000 : Record 5896;VAR ToInventoryAdjmtEntryOrder@1001 : Record 5896);
    BEGIN
      WITH ToInventoryAdjmtEntryOrder DO BEGIN
        RESET;
        DELETEALL;
        IF FromInventoryAdjmtEntryOrder.FINDSET THEN
          REPEAT
            ToInventoryAdjmtEntryOrder := FromInventoryAdjmtEntryOrder;
            INSERT;
          UNTIL FromInventoryAdjmtEntryOrder.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE AdjustNotInvdRevaluation@100(TransItemLedgEntry@1000 : Record 32;TransItemApplnEntry@1001 : Record 339;VAR TempAvgCostAdjmtEntryPoint@1006 : TEMPORARY Record 5804);
    VAR
      TransValueEntry@1002 : Record 5802;
      OrigItemLedgEntry@1003 : Record 32;
      CostElementBuf@1004 : Record 5820;
      AdjustedCostElementBuf@1005 : Record 5820;
    BEGIN
      WITH TransValueEntry DO
        IF NotInvdRevaluationExists(TransItemLedgEntry."Entry No.") THEN BEGIN
          GetOrigPosItemLedgEntryNo(TransItemApplnEntry);
          OrigItemLedgEntry.GET(TransItemApplnEntry."Item Ledger Entry No.");
          REPEAT
            CalcTransEntryNewRevAmt(OrigItemLedgEntry,TransValueEntry,AdjustedCostElementBuf);
            CalcTransEntryOldRevAmt(TransValueEntry,CostElementBuf);

            UpdateAdjmtBuf(
              TransValueEntry,
              AdjustedCostElementBuf."Actual Cost" - CostElementBuf."Actual Cost",
              AdjustedCostElementBuf."Actual Cost (ACY)" - CostElementBuf."Actual Cost (ACY)",
              TransItemLedgEntry."Posting Date",
              "Entry Type",
              TempAvgCostAdjmtEntryPoint);
          UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE GetOrigPosItemLedgEntryNo@101(VAR ItemApplnEntry@1000 : Record 339);
    BEGIN
      WITH ItemApplnEntry DO BEGIN
        SETCURRENTKEY("Inbound Item Entry No.","Item Ledger Entry No.");
        SETRANGE("Item Ledger Entry No.","Transferred-from Entry No.");
        SETRANGE("Inbound Item Entry No.","Transferred-from Entry No.");
        FINDFIRST;
        IF "Transferred-from Entry No." <> 0 THEN
          GetOrigPosItemLedgEntryNo(ItemApplnEntry);
      END;
    END;

    LOCAL PROCEDURE CalcTransEntryNewRevAmt@102(ItemLedgEntry@1000 : Record 32;TransValueEntry@1001 : Record 5802;VAR AdjustedCostElementBuf@1002 : Record 5820);
    VAR
      ValueEntry@1003 : Record 5802;
      InvdQty@1004 : Decimal;
      OrigInvdQty@1005 : Decimal;
      ShareOfRevExpAmt@1006 : Decimal;
      OrigShareOfRevExpAmt@1007 : Decimal;
    BEGIN
      WITH ValueEntry DO BEGIN
        SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
        SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
        SETRANGE("Entry Type","Entry Type"::"Direct Cost");
        SETRANGE("Item Charge No.",'');
        IF FINDSET THEN
          REPEAT
            InvdQty := InvdQty + "Invoiced Quantity";
            IF "Entry No." < TransValueEntry."Entry No." THEN
              OrigInvdQty := OrigInvdQty + "Invoiced Quantity";
          UNTIL NEXT = 0;
        ShareOfRevExpAmt := (ItemLedgEntry.Quantity - InvdQty) / ItemLedgEntry.Quantity;
        OrigShareOfRevExpAmt := (ItemLedgEntry.Quantity - OrigInvdQty) / ItemLedgEntry.Quantity;
      END;

      IF TempInvtAdjmtBuf.GET(TransValueEntry."Entry No.") THEN
        TransValueEntry.AddCost(TempInvtAdjmtBuf);
      AdjustedCostElementBuf."Actual Cost" := ROUND(
          (ShareOfRevExpAmt - OrigShareOfRevExpAmt) * TransValueEntry."Cost Amount (Actual)",GLSetup."Amount Rounding Precision");
      AdjustedCostElementBuf."Actual Cost (ACY)" := ROUND(
          (ShareOfRevExpAmt - OrigShareOfRevExpAmt) *
          TransValueEntry."Cost Amount (Actual) (ACY)",Currency."Amount Rounding Precision");
    END;

    LOCAL PROCEDURE CalcTransEntryOldRevAmt@103(TransValueEntry@1000 : Record 5802;VAR CostElementBuf@1001 : Record 5820);
    BEGIN
      CLEAR(CostElementBuf);
      WITH CostElementBuf DO BEGIN
        TransValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
        TransValueEntry.SETRANGE("Item Ledger Entry No.",TransValueEntry."Item Ledger Entry No.");
        TransValueEntry.SETRANGE("Entry Type",TransValueEntry."Entry Type"::Revaluation);
        TransValueEntry.SETRANGE("Applies-to Entry",TransValueEntry."Entry No.");
        IF TransValueEntry.FINDSET THEN
          REPEAT
            IF TempInvtAdjmtBuf.GET(TransValueEntry."Entry No.") THEN
              TransValueEntry.AddCost(TempInvtAdjmtBuf);
            "Actual Cost" := "Actual Cost" + TransValueEntry."Cost Amount (Actual)";
            "Actual Cost (ACY)" := "Actual Cost (ACY)" + TransValueEntry."Cost Amount (Actual) (ACY)";
          UNTIL TransValueEntry.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE IsInterimRevaluation@104(InbndValueEntry@1000 : Record 5802) : Boolean;
    BEGIN
      WITH InbndValueEntry DO
        EXIT(
          ("Entry Type" = "Entry Type"::Revaluation) AND (("Cost Amount (Expected)" <> 0) OR ("Cost Amount (Expected) (ACY)" <> 0)));
    END;

    LOCAL PROCEDURE OutboundSalesEntryToAdjust@5888(ItemLedgEntry@5890 : Record 32) : Boolean;
    VAR
      ItemApplnEntry@5892 : Record 339;
      InbndItemLedgEntry@5893 : Record 32;
    BEGIN
      IF NOT ItemLedgEntry.IsOutbndSale THEN
        EXIT(FALSE);

      WITH ItemApplnEntry DO BEGIN
        RESET;
        SETCURRENTKEY(
          "Outbound Item Entry No.","Item Ledger Entry No.","Cost Application","Transferred-from Entry No.");
        SETRANGE("Outbound Item Entry No.",ItemLedgEntry."Entry No.");
        SETFILTER("Item Ledger Entry No.",'<>%1',ItemLedgEntry."Entry No.");
        SETRANGE("Transferred-from Entry No.",0);
        IF FINDSET THEN
          REPEAT
            IF InbndItemLedgEntry.GET("Inbound Item Entry No.") THEN
              IF NOT InbndItemLedgEntry."Completely Invoiced" THEN
                EXIT(TRUE);
          UNTIL NEXT = 0;
      END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE InboundTransferEntryToAdjust@78(ItemLedgEntry@1000 : Record 32) : Boolean;
    VAR
      ItemApplnEntry@1001 : Record 339;
    BEGIN
      IF (ItemLedgEntry."Entry Type" <> ItemLedgEntry."Entry Type"::Transfer) OR NOT ItemLedgEntry.Positive OR
         ItemLedgEntry."Completely Invoiced"
      THEN
        EXIT(FALSE);

      WITH ItemApplnEntry DO BEGIN
        SETRANGE("Inbound Item Entry No.",ItemLedgEntry."Entry No.");
        SETFILTER("Item Ledger Entry No.",'<>%1',ItemLedgEntry."Entry No.");
        SETRANGE("Transferred-from Entry No.",0);
        EXIT(NOT ISEMPTY);
      END;
    END;

    [External]
    PROCEDURE SetJobUpdateProperties@70(SkipJobUpdate@1000 : Boolean);
    BEGIN
      SkipUpdateJobItemCost := SkipJobUpdate;
    END;

    LOCAL PROCEDURE GetLastValidValueEntry@52(ValueEntryNo@1000 : Integer) : Integer;
    VAR
      Integer@1002 : Record 2000000026;
    BEGIN
      WITH AvgCostExceptionBuf DO BEGIN
        SETFILTER(Number,'>%1',ValueEntryNo);
        IF NOT FINDFIRST THEN BEGIN
          Integer.FINDLAST;
          SETRANGE(Number);
          EXIT(Integer.Number);
        END;
        EXIT(Number);
      END;
    END;

    LOCAL PROCEDURE FillFixApplBuffer@23(ItemLedgerEntryNo@1000 : Integer);
    VAR
      ItemApplnEntry@1001 : Record 339;
    BEGIN
      WITH TempFixApplBuffer DO
        IF NOT GET(ItemLedgerEntryNo) THEN
          IF ItemApplnEntry.AppliedOutbndEntryExists(ItemLedgerEntryNo,TRUE,FALSE) THEN BEGIN
            Number := ItemLedgerEntryNo;
            INSERT;
            REPEAT
              // buffer is filled with couple of entries which are applied and contains revaluation
              Number := ItemApplnEntry."Item Ledger Entry No.";
              INSERT;
            UNTIL ItemApplnEntry.NEXT = 0;
          END;
    END;

    LOCAL PROCEDURE UpdateJobItemCost@82();
    VAR
      JobsSetup@1001 : Record 315;
      Job@1002 : Record 167;
      UpdateJobItemCost@1000 : Report 1095;
    BEGIN
      IF JobsSetup.FIND THEN
        IF JobsSetup."Automatic Update Job Item Cost" THEN BEGIN
          IF TempJobToAdjustBuf.FINDSET THEN
            REPEAT
              Job.SETRANGE("No.",TempJobToAdjustBuf."No.");
              CLEAR(UpdateJobItemCost);
              UpdateJobItemCost.SETTABLEVIEW(Job);
              UpdateJobItemCost.USEREQUESTPAGE := FALSE;
              UpdateJobItemCost.SetProperties(TRUE);
              UpdateJobItemCost.RUNMODAL;
            UNTIL TempJobToAdjustBuf.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE FetchOpenItemEntriesToExclude@32(AvgCostAdjmtEntryPoint@1003 : Record 5804;VAR ExcludedValueEntry@1002 : Record 5802;VAR OpenEntries@1001 : TEMPORARY Record 2000000026;CalendarPeriod@1006 : Record 2000000007);
    VAR
      OpenItemLedgEntry@1005 : Record 32;
      TempItemLedgEntryInChain@1004 : TEMPORARY Record 32;
      ItemApplnEntry@1007 : Record 339;
    BEGIN
      OpenEntries.RESET;
      OpenEntries.DELETEALL;

      WITH OpenItemLedgEntry DO BEGIN
        IF OpenOutbndItemLedgEntriesExist(OpenItemLedgEntry,AvgCostAdjmtEntryPoint,CalendarPeriod) THEN
          REPEAT
            CopyOpenItemLedgEntryToBuf(OpenEntries,ExcludedValueEntry,"Entry No.",CalendarPeriod."Period Start");
            ItemApplnEntry.GetVisitedEntries(OpenItemLedgEntry,TempItemLedgEntryInChain,FALSE);
            IF TempItemLedgEntryInChain.FINDSET THEN
              REPEAT
                CopyOpenItemLedgEntryToBuf(
                  OpenEntries,ExcludedValueEntry,TempItemLedgEntryInChain."Entry No.",CalendarPeriod."Period Start");
              UNTIL TempItemLedgEntryInChain.NEXT = 0;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE OpenOutbndItemLedgEntriesExist@25(VAR OpenItemLedgEntry@1000 : Record 32;AvgCostAdjmtEntryPoint@1001 : Record 5804;CalendarPeriod@1002 : Record 2000000007) : Boolean;
    BEGIN
      WITH OpenItemLedgEntry DO BEGIN
        SETCURRENTKEY("Item No.",Open,"Variant Code",Positive);
        SETRANGE("Item No.",AvgCostAdjmtEntryPoint."Item No.");
        SETRANGE(Open,TRUE);
        SETRANGE(Positive,FALSE);
        IF NOT AvgCostAdjmtEntryPoint.IsAvgCostCalcTypeItem(CalendarPeriod."Period End") THEN BEGIN
          SETRANGE("Location Code",AvgCostAdjmtEntryPoint."Location Code");
          SETRANGE("Variant Code",AvgCostAdjmtEntryPoint."Variant Code");
        END;
        EXIT(FINDSET);
      END;
    END;

    LOCAL PROCEDURE ResetAvgBuffers@88(VAR OutbndValueEntry@1001 : Record 5802;VAR ExcludedValueEntry@1000 : Record 5802);
    BEGIN
      OutbndValueEntry.RESET;
      ExcludedValueEntry.RESET;
      AvgCostExceptionBuf.RESET;
      RevaluationPoint.RESET;
      AvgCostBuf.INIT;
    END;

    LOCAL PROCEDURE DeleteAvgBuffers@90(VAR OutbndValueEntry@1001 : Record 5802;VAR ExcludedValueEntry@1000 : Record 5802);
    BEGIN
      ResetAvgBuffers(OutbndValueEntry,ExcludedValueEntry);
      OutbndValueEntry.DELETEALL;
      ExcludedValueEntry.DELETEALL;
      AvgCostExceptionBuf.DELETEALL;
      RevaluationPoint.DELETEALL;
    END;

    LOCAL PROCEDURE CopyAdjmtEntryPointToBuf@24(VAR AvgCostAdjmtEntryPoint@1000 : Record 5804;VAR TempAvgCostAdjmtEntryPoint@1001 : TEMPORARY Record 5804);
    BEGIN
      WITH AvgCostAdjmtEntryPoint DO
        IF FINDSET THEN
          REPEAT
            InsertEntryPointToUpdate(TempAvgCostAdjmtEntryPoint,"Item No.","Variant Code","Location Code");
          UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE InsertEntryPointToUpdate@55(VAR TempAvgCostAdjmtEntryPoint@1000 : TEMPORARY Record 5804;ItemNo@1001 : Code[20];VariantCode@1002 : Code[10];LocationCode@1003 : Code[10]);
    BEGIN
      WITH TempAvgCostAdjmtEntryPoint DO BEGIN
        "Item No." := ItemNo;
        "Variant Code" := VariantCode;
        "Location Code" := LocationCode;
        "Valuation Date" := 0D;
        IF INSERT THEN;
      END;
    END;

    LOCAL PROCEDURE UpdateValuationPeriodHasOutput@87(ValueEntry@1000 : Record 5802);
    VAR
      AvgCostAdjmtEntryPoint@1001 : Record 5804;
      OutputValueEntry@1002 : Record 5802;
      CalendarPeriod@1003 : Record 2000000007;
    BEGIN
      IF ValueEntry."Item Ledger Entry Type" IN
         [ValueEntry."Item Ledger Entry Type"::Consumption,
          ValueEntry."Item Ledger Entry Type"::"Assembly Consumption"]
      THEN
        IF AvgCostAdjmtEntryPoint.ValuationExists(ValueEntry) THEN BEGIN
          IF (ConsumpAdjmtInPeriodWithOutput <> 0D) AND
             (ConsumpAdjmtInPeriodWithOutput <= AvgCostAdjmtEntryPoint."Valuation Date")
          THEN
            EXIT;

          CalendarPeriod."Period Start" := AvgCostAdjmtEntryPoint."Valuation Date";
          AvgCostAdjmtEntryPoint.GetValuationPeriod(CalendarPeriod);

          WITH OutputValueEntry DO BEGIN
            SETCURRENTKEY("Item No.","Valuation Date");
            SETRANGE("Item No.",ValueEntry."Item No.");
            SETRANGE("Valuation Date",AvgCostAdjmtEntryPoint."Valuation Date",CalendarPeriod."Period End");

            SETFILTER(
              "Item Ledger Entry Type",'%1|%2',
              "Item Ledger Entry Type"::Output,
              "Item Ledger Entry Type"::"Assembly Output");
            IF FINDFIRST THEN
              ConsumpAdjmtInPeriodWithOutput := AvgCostAdjmtEntryPoint."Valuation Date";
          END;
        END;
    END;

    LOCAL PROCEDURE CopyOpenItemLedgEntryToBuf@91(VAR OpenEntries@1001 : TEMPORARY Record 2000000026;VAR ExcludedValueEntry@1002 : Record 5802;OpenItemLedgEntryNo@1000 : Integer;PeriodStart@1003 : Date);
    BEGIN
      IF CollectOpenValueEntries(ExcludedValueEntry,OpenItemLedgEntryNo,PeriodStart) THEN BEGIN
        OpenEntries.Number := OpenItemLedgEntryNo;
        IF OpenEntries.INSERT THEN;
      END;
    END;

    LOCAL PROCEDURE CollectOpenValueEntries@86(VAR ExcludedValueEntry@1002 : Record 5802;ItemLedgerEntryNo@1001 : Integer;PeriodStart@1003 : Date) FoundEntries : Boolean;
    VAR
      OpenValueEntry@1000 : Record 5802;
    BEGIN
      OpenValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgerEntryNo);
      OpenValueEntry.SETFILTER("Valuation Date",'<%1',PeriodStart);
      FoundEntries := OpenValueEntry.FINDSET;
      IF FoundEntries THEN
        REPEAT
          ExcludedValueEntry := OpenValueEntry;
          IF ExcludedValueEntry.INSERT THEN;
        UNTIL OpenValueEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CopyJobToAdjustmentBuf@94(JobNo@1000 : Code[20]);
    BEGIN
      TempJobToAdjustBuf."No." := JobNo;
      IF TempJobToAdjustBuf.INSERT THEN;
    END;

    LOCAL PROCEDURE UseStandardCostMirroring@112(ItemLedgEntry@1000 : Record 32) : Boolean;
    VAR
      ReturnShipmentLine@1002 : Record 6651;
      EntryNo@1003 : Integer;
    BEGIN
      WITH ItemLedgEntry DO BEGIN
        IF ("Entry Type" <> "Entry Type"::Purchase) OR
           ("Document Type" <> "Document Type"::"Purchase Return Shipment")
        THEN
          EXIT(FALSE);

        EntryNo := "Entry No.";
        RESET;
        SETRANGE("Document Type","Document Type");
        SETRANGE("Document No.","Document No.");
        SETFILTER("Document Line No.",'<>%1',"Document Line No.");
        SETRANGE("Item No.","Item No.");
        SETRANGE(Correction,TRUE);
        IF FINDSET THEN
          REPEAT
            ReturnShipmentLine.GET("Document No.","Document Line No.");
            IF ReturnShipmentLine."Appl.-to Item Entry" = EntryNo THEN
              EXIT(TRUE);
          UNTIL NEXT = 0;
      END;
      EXIT(FALSE);
    END;

    BEGIN
    END.
  }
}

