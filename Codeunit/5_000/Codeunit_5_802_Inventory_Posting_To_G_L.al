OBJECT Codeunit 5802 Inventory Posting To G/L
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    TableNo=5802;
    Permissions=TableData 48=rimd,
                TableData 5802=r,
                TableData 5823=rimd;
    OnRun=VAR
            GenJnlLine@1000 : Record 81;
          BEGIN
            IF GlobalPostPerPostGroup THEN
              PostInvtPostBuf(Rec,"Document No.",'','',TRUE)
            ELSE
              PostInvtPostBuf(
                Rec,
                "Document No.",
                "External Document No.",
                COPYSTR(
                  STRSUBSTNO(Text000,"Entry Type","Source No.","Posting Date"),
                  1,MAXSTRLEN(GenJnlLine.Description)),
                FALSE);
          END;

  }
  CODE
  {
    VAR
      GLSetup@1009 : Record 98;
      InvtSetup@1008 : Record 313;
      Currency@1007 : Record 4;
      SourceCodeSetup@1006 : Record 242;
      GlobalInvtPostBuf@1005 : TEMPORARY Record 48;
      TempInvtPostBuf@1029 : ARRAY [4] OF TEMPORARY Record 48;
      TempInvtPostToGLTestBuf@1014 : TEMPORARY Record 5822;
      TempGLItemLedgRelation@1026 : TEMPORARY Record 5823;
      GenJnlPostLine@1002 : Codeunit 12;
      GenJnlCheckLine@1004 : Codeunit 11;
      DimMgt@1019 : Codeunit 408;
      COGSAmt@1048 : Decimal;
      InvtAdjmtAmt@1047 : Decimal;
      DirCostAmt@1046 : Decimal;
      OvhdCostAmt@1045 : Decimal;
      VarPurchCostAmt@1044 : Decimal;
      VarMfgDirCostAmt@1049 : Decimal;
      VarMfgOvhdCostAmt@1039 : Decimal;
      WIPInvtAmt@1038 : Decimal;
      InvtAmt@1037 : Decimal;
      TotalCOGSAmt@1036 : Decimal;
      TotalInvtAdjmtAmt@1035 : Decimal;
      TotalDirCostAmt@1034 : Decimal;
      TotalOvhdCostAmt@1033 : Decimal;
      TotalVarPurchCostAmt@1032 : Decimal;
      TotalVarMfgDirCostAmt@1040 : Decimal;
      TotalVarMfgOvhdCostAmt@1017 : Decimal;
      TotalWIPInvtAmt@1016 : Decimal;
      TotalInvtAmt@1015 : Decimal;
      GlobalInvtPostBufEntryNo@1025 : Integer;
      PostBufDimNo@1030 : Integer;
      GLSetupRead@1012 : Boolean;
      SourceCodeSetupRead@1011 : Boolean;
      InvtSetupRead@1010 : Boolean;
      Text000@1000 : TextConst 'DAN=%1 %2 p� %3;ENU=%1 %2 on %3';
      Text001@1031 : TextConst 'DAN=%1 - %2, %3,%4,%5,%6;ENU=%1 - %2, %3,%4,%5,%6';
      Text002@1018 : TextConst 'DAN="F�lgende kombination %1 = %2, %3 = %4 og %5 = %6 er ugyldig.";ENU="The following combination %1 = %2, %3 = %4, and %5 = %6 is not allowed."';
      RunOnlyCheck@1003 : Boolean;
      RunOnlyCheckSaved@1022 : Boolean;
      CalledFromItemPosting@1021 : Boolean;
      CalledFromTestReport@1013 : Boolean;
      GlobalPostPerPostGroup@1023 : Boolean;
      Text003@1020 : TextConst 'DAN=%1 %2;ENU=%1 %2';

    [External]
    PROCEDURE Initialize@31(PostPerPostGroup@1002 : Boolean);
    BEGIN
      GlobalPostPerPostGroup := PostPerPostGroup;
      GlobalInvtPostBufEntryNo := 0;
    END;

    [External]
    PROCEDURE SetRunOnlyCheck@17(SetCalledFromItemPosting@1002 : Boolean;SetCheckOnly@1000 : Boolean;SetCalledFromTestReport@1001 : Boolean);
    BEGIN
      CalledFromItemPosting := SetCalledFromItemPosting;
      RunOnlyCheck := SetCheckOnly;
      CalledFromTestReport := SetCalledFromTestReport;

      TempGLItemLedgRelation.RESET;
      TempGLItemLedgRelation.DELETEALL;
    END;

    [External]
    PROCEDURE BufferInvtPosting@1(VAR ValueEntry@1000 : Record 5802) : Boolean;
    VAR
      CostToPost@1003 : Decimal;
      CostToPostACY@1004 : Decimal;
      ExpCostToPost@1001 : Decimal;
      ExpCostToPostACY@1002 : Decimal;
      PostToGL@1005 : Boolean;
    BEGIN
      WITH ValueEntry DO BEGIN
        GetGLSetup;
        GetInvtSetup;
        IF (NOT InvtSetup."Expected Cost Posting to G/L") AND
           ("Expected Cost Posted to G/L" = 0) AND
           "Expected Cost"
        THEN
          EXIT(FALSE);

        IF NOT ("Entry Type" IN ["Entry Type"::"Direct Cost","Entry Type"::Revaluation]) AND
           NOT CalledFromTestReport
        THEN BEGIN
          TESTFIELD("Expected Cost",FALSE);
          TESTFIELD("Cost Amount (Expected)",0);
          TESTFIELD("Cost Amount (Expected) (ACY)",0);
        END;

        IF InvtSetup."Expected Cost Posting to G/L" THEN BEGIN
          CalcCostToPost(ExpCostToPost,"Cost Amount (Expected)","Expected Cost Posted to G/L",PostToGL);
          CalcCostToPost(ExpCostToPostACY,"Cost Amount (Expected) (ACY)","Exp. Cost Posted to G/L (ACY)",PostToGL);
        END;
        CalcCostToPost(CostToPost,"Cost Amount (Actual)","Cost Posted to G/L",PostToGL);
        CalcCostToPost(CostToPostACY,"Cost Amount (Actual) (ACY)","Cost Posted to G/L (ACY)",PostToGL);
        OnAfterCalcCostToPostFromBuffer(ValueEntry,CostToPost,CostToPostACY,ExpCostToPost,ExpCostToPostACY);
        PostBufDimNo := 0;

        RunOnlyCheckSaved := RunOnlyCheck;
        IF NOT PostToGL THEN
          EXIT(FALSE);

        CASE "Item Ledger Entry Type" OF
          "Item Ledger Entry Type"::Purchase:
            BufferPurchPosting(ValueEntry,CostToPost,CostToPostACY,ExpCostToPost,ExpCostToPostACY);
          "Item Ledger Entry Type"::Sale:
            BufferSalesPosting(ValueEntry,CostToPost,CostToPostACY,ExpCostToPost,ExpCostToPostACY);
          "Item Ledger Entry Type"::"Positive Adjmt.",
          "Item Ledger Entry Type"::"Negative Adjmt.",
          "Item Ledger Entry Type"::Transfer:
            BufferAdjmtPosting(ValueEntry,CostToPost,CostToPostACY,ExpCostToPost,ExpCostToPostACY);
          "Item Ledger Entry Type"::Consumption:
            BufferConsumpPosting(ValueEntry,CostToPost,CostToPostACY);
          "Item Ledger Entry Type"::Output:
            BufferOutputPosting(ValueEntry,CostToPost,CostToPostACY,ExpCostToPost,ExpCostToPostACY);
          "Item Ledger Entry Type"::"Assembly Consumption":
            BufferAsmConsumpPosting(ValueEntry,CostToPost,CostToPostACY);
          "Item Ledger Entry Type"::"Assembly Output":
            BufferAsmOutputPosting(ValueEntry,CostToPost,CostToPostACY);
          "Item Ledger Entry Type"::" ":
            BufferCapPosting(ValueEntry,CostToPost,CostToPostACY);
          ELSE
            ErrorNonValidCombination(ValueEntry);
        END;
      END;

      IF UpdateGlobalInvtPostBuf(ValueEntry."Entry No.") THEN
        EXIT(TRUE);
      EXIT(CalledFromTestReport);
    END;

    LOCAL PROCEDURE BufferPurchPosting@5(ValueEntry@1000 : Record 5802;CostToPost@1004 : Decimal;CostToPostACY@1003 : Decimal;ExpCostToPost@1002 : Decimal;ExpCostToPostACY@1001 : Decimal);
    BEGIN
      WITH ValueEntry DO
        CASE "Entry Type" OF
          "Entry Type"::"Direct Cost":
            BEGIN
              IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::"Inventory (Interim)",
                  GlobalInvtPostBuf."Account Type"::"Invt. Accrual (Interim)",
                  ExpCostToPost,ExpCostToPostACY,TRUE);
              IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Direct Cost Applied",
                  CostToPost,CostToPostACY,FALSE);
            END;
          "Entry Type"::"Indirect Cost":
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"Overhead Applied",
              CostToPost,CostToPostACY,FALSE);
          "Entry Type"::Variance:
            BEGIN
              TESTFIELD("Variance Type","Variance Type"::Purchase);
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."Account Type"::Inventory,
                GlobalInvtPostBuf."Account Type"::"Purchase Variance",
                CostToPost,CostToPostACY,FALSE);
            END;
          "Entry Type"::Revaluation:
            BEGIN
              IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::"Inventory (Interim)",
                  GlobalInvtPostBuf."Account Type"::"Invt. Accrual (Interim)",
                  ExpCostToPost,ExpCostToPostACY,TRUE);
              IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
                  CostToPost,CostToPostACY,FALSE);
            END;
          "Entry Type"::Rounding:
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
              CostToPost,CostToPostACY,FALSE);
          ELSE
            ErrorNonValidCombination(ValueEntry);
        END;
    END;

    LOCAL PROCEDURE BufferSalesPosting@6(ValueEntry@1000 : Record 5802;CostToPost@1004 : Decimal;CostToPostACY@1003 : Decimal;ExpCostToPost@1002 : Decimal;ExpCostToPostACY@1001 : Decimal);
    BEGIN
      WITH ValueEntry DO
        CASE "Entry Type" OF
          "Entry Type"::"Direct Cost":
            BEGIN
              IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::"Inventory (Interim)",
                  GlobalInvtPostBuf."Account Type"::"COGS (Interim)",
                  ExpCostToPost,ExpCostToPostACY,TRUE);
              IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::COGS,
                  CostToPost,CostToPostACY,FALSE);
            END;
          "Entry Type"::Revaluation:
            BEGIN
              IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::"Inventory (Interim)",
                  GlobalInvtPostBuf."Account Type"::"COGS (Interim)",
                  ExpCostToPost,ExpCostToPostACY,TRUE);
              IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
                  CostToPost,CostToPostACY,FALSE);
            END;
          "Entry Type"::Rounding:
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
              CostToPost,CostToPostACY,FALSE);
          ELSE
            ErrorNonValidCombination(ValueEntry);
        END;
    END;

    LOCAL PROCEDURE BufferOutputPosting@9(ValueEntry@1000 : Record 5802;CostToPost@1004 : Decimal;CostToPostACY@1003 : Decimal;ExpCostToPost@1002 : Decimal;ExpCostToPostACY@1001 : Decimal);
    BEGIN
      WITH ValueEntry DO
        CASE "Entry Type" OF
          "Entry Type"::"Direct Cost":
            BEGIN
              IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::"Inventory (Interim)",
                  GlobalInvtPostBuf."Account Type"::"WIP Inventory",
                  ExpCostToPost,ExpCostToPostACY,TRUE);
              IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"WIP Inventory",
                  CostToPost,CostToPostACY,FALSE);
            END;
          "Entry Type"::"Indirect Cost":
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"Overhead Applied",
              CostToPost,CostToPostACY,FALSE);
          "Entry Type"::Variance:
            CASE "Variance Type" OF
              "Variance Type"::Material:
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Material Variance",
                  CostToPost,CostToPostACY,FALSE);
              "Variance Type"::Capacity:
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Capacity Variance",
                  CostToPost,CostToPostACY,FALSE);
              "Variance Type"::Subcontracted:
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Subcontracted Variance",
                  CostToPost,CostToPostACY,FALSE);
              "Variance Type"::"Capacity Overhead":
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Cap. Overhead Variance",
                  CostToPost,CostToPostACY,FALSE);
              "Variance Type"::"Manufacturing Overhead":
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Mfg. Overhead Variance",
                  CostToPost,CostToPostACY,FALSE);
              ELSE
                ErrorNonValidCombination(ValueEntry);
            END;
          "Entry Type"::Revaluation:
            BEGIN
              IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::"Inventory (Interim)",
                  GlobalInvtPostBuf."Account Type"::"WIP Inventory",
                  ExpCostToPost,ExpCostToPostACY,TRUE);
              IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
                  CostToPost,CostToPostACY,FALSE);
            END;
          "Entry Type"::Rounding:
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
              CostToPost,CostToPostACY,FALSE);
          ELSE
            ErrorNonValidCombination(ValueEntry);
        END;
    END;

    LOCAL PROCEDURE BufferConsumpPosting@34(ValueEntry@1000 : Record 5802;CostToPost@1004 : Decimal;CostToPostACY@1003 : Decimal);
    BEGIN
      WITH ValueEntry DO
        CASE "Entry Type" OF
          "Entry Type"::"Direct Cost":
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"WIP Inventory",
              CostToPost,CostToPostACY,FALSE);
          "Entry Type"::Revaluation,
          "Entry Type"::Rounding:
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
              CostToPost,CostToPostACY,FALSE);
          ELSE
            ErrorNonValidCombination(ValueEntry);
        END;
    END;

    LOCAL PROCEDURE BufferCapPosting@16(ValueEntry@1000 : Record 5802;CostToPost@1004 : Decimal;CostToPostACY@1003 : Decimal);
    BEGIN
      WITH ValueEntry DO
        IF "Order Type" = "Order Type"::Assembly THEN
          CASE "Entry Type" OF
            "Entry Type"::"Direct Cost":
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
                GlobalInvtPostBuf."Account Type"::"Direct Cost Applied",
                CostToPost,CostToPostACY,FALSE);
            "Entry Type"::"Indirect Cost":
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
                GlobalInvtPostBuf."Account Type"::"Overhead Applied",
                CostToPost,CostToPostACY,FALSE);
            ELSE
              ErrorNonValidCombination(ValueEntry);
          END
        ELSE
          CASE "Entry Type" OF
            "Entry Type"::"Direct Cost":
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."Account Type"::"WIP Inventory",
                GlobalInvtPostBuf."Account Type"::"Direct Cost Applied",
                CostToPost,CostToPostACY,FALSE);
            "Entry Type"::"Indirect Cost":
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."Account Type"::"WIP Inventory",
                GlobalInvtPostBuf."Account Type"::"Overhead Applied",
                CostToPost,CostToPostACY,FALSE);
            ELSE
              ErrorNonValidCombination(ValueEntry);
          END;
    END;

    LOCAL PROCEDURE BufferAsmOutputPosting@36(ValueEntry@1000 : Record 5802;CostToPost@1004 : Decimal;CostToPostACY@1003 : Decimal);
    BEGIN
      WITH ValueEntry DO
        CASE "Entry Type" OF
          "Entry Type"::"Direct Cost":
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
              CostToPost,CostToPostACY,FALSE);
          "Entry Type"::"Indirect Cost":
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"Overhead Applied",
              CostToPost,CostToPostACY,FALSE);
          "Entry Type"::Variance:
            CASE "Variance Type" OF
              "Variance Type"::Material:
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Material Variance",
                  CostToPost,CostToPostACY,FALSE);
              "Variance Type"::Capacity:
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Capacity Variance",
                  CostToPost,CostToPostACY,FALSE);
              "Variance Type"::Subcontracted:
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Subcontracted Variance",
                  CostToPost,CostToPostACY,FALSE);
              "Variance Type"::"Capacity Overhead":
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Cap. Overhead Variance",
                  CostToPost,CostToPostACY,FALSE);
              "Variance Type"::"Manufacturing Overhead":
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Mfg. Overhead Variance",
                  CostToPost,CostToPostACY,FALSE);
              ELSE
                ErrorNonValidCombination(ValueEntry);
            END;
          "Entry Type"::Revaluation:
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
              CostToPost,CostToPostACY,FALSE);
          "Entry Type"::Rounding:
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
              CostToPost,CostToPostACY,FALSE);
          ELSE
            ErrorNonValidCombination(ValueEntry);
        END;
    END;

    LOCAL PROCEDURE BufferAsmConsumpPosting@38(ValueEntry@1000 : Record 5802;CostToPost@1004 : Decimal;CostToPostACY@1003 : Decimal);
    BEGIN
      WITH ValueEntry DO
        CASE "Entry Type" OF
          "Entry Type"::"Direct Cost":
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
              CostToPost,CostToPostACY,FALSE);
          "Entry Type"::Revaluation,
          "Entry Type"::Rounding:
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
              CostToPost,CostToPostACY,FALSE);
          ELSE
            ErrorNonValidCombination(ValueEntry);
        END;
    END;

    LOCAL PROCEDURE BufferAdjmtPosting@39(ValueEntry@1000 : Record 5802;CostToPost@1004 : Decimal;CostToPostACY@1003 : Decimal;ExpCostToPost@1002 : Decimal;ExpCostToPostACY@1001 : Decimal);
    BEGIN
      WITH ValueEntry DO
        CASE "Entry Type" OF
          "Entry Type"::"Direct Cost":
            BEGIN
              // Posting adjustments to Interim accounts (Service)
              IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::"Inventory (Interim)",
                  GlobalInvtPostBuf."Account Type"::"COGS (Interim)",
                  ExpCostToPost,ExpCostToPostACY,TRUE);
              IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
                  CostToPost,CostToPostACY,FALSE);
            END;
          "Entry Type"::Revaluation,
          "Entry Type"::Rounding:
            InitInvtPostBuf(
              ValueEntry,
              GlobalInvtPostBuf."Account Type"::Inventory,
              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
              CostToPost,CostToPostACY,FALSE);
          ELSE
            ErrorNonValidCombination(ValueEntry);
        END;
    END;

    LOCAL PROCEDURE GetGLSetup@14();
    BEGIN
      IF NOT GLSetupRead THEN BEGIN
        GLSetup.GET;
        IF GLSetup."Additional Reporting Currency" <> '' THEN
          Currency.GET(GLSetup."Additional Reporting Currency");
      END;
      GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE GetInvtSetup@4();
    BEGIN
      IF NOT InvtSetupRead THEN
        InvtSetup.GET;
      InvtSetupRead := TRUE;
    END;

    LOCAL PROCEDURE CalcCostToPost@8(VAR CostToPost@1000 : Decimal;AdjdCost@1001 : Decimal;VAR PostedCost@1002 : Decimal;VAR PostToGL@1005 : Boolean);
    BEGIN
      CostToPost := AdjdCost - PostedCost;

      IF CostToPost <> 0 THEN BEGIN
        IF NOT RunOnlyCheck THEN
          PostedCost := AdjdCost;
        PostToGL := TRUE;
      END;
    END;

    LOCAL PROCEDURE InitInvtPostBuf@10(ValueEntry@1000 : Record 5802;AccType@1001 : Option;BalAccType@1002 : Option;CostToPost@1004 : Decimal;CostToPostACY@1003 : Decimal;InterimAccount@1007 : Boolean);
    BEGIN
      PostBufDimNo := PostBufDimNo + 1;
      SetAccNo(TempInvtPostBuf[PostBufDimNo],ValueEntry,AccType,BalAccType);
      SetPostBufAmounts(TempInvtPostBuf[PostBufDimNo],CostToPost,CostToPostACY,InterimAccount);
      TempInvtPostBuf[PostBufDimNo]."Dimension Set ID" := ValueEntry."Dimension Set ID";

      PostBufDimNo := PostBufDimNo + 1;
      SetAccNo(TempInvtPostBuf[PostBufDimNo],ValueEntry,BalAccType,AccType);
      SetPostBufAmounts(TempInvtPostBuf[PostBufDimNo],-CostToPost,-CostToPostACY,InterimAccount);
      TempInvtPostBuf[PostBufDimNo]."Dimension Set ID" := ValueEntry."Dimension Set ID";
    END;

    LOCAL PROCEDURE SetAccNo@18(VAR InvtPostBuf@1001 : Record 48;ValueEntry@1006 : Record 5802;AccType@1005 : Option;BalAccType@1000 : Option);
    VAR
      InvtPostSetup@1003 : Record 5813;
      GenPostingSetup@1004 : Record 252;
      GLAccount@1002 : Record 15;
    BEGIN
      WITH InvtPostBuf DO BEGIN
        "Account No." := '';
        "Account Type" := AccType;
        "Bal. Account Type" := BalAccType;
        "Location Code" := ValueEntry."Location Code";
        "Inventory Posting Group" :=
          GetInvPostingGroupCode(ValueEntry,AccType = "Account Type"::"WIP Inventory",ValueEntry."Inventory Posting Group");
        "Gen. Bus. Posting Group" := ValueEntry."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := ValueEntry."Gen. Prod. Posting Group";
        "Posting Date" := ValueEntry."Posting Date";

        IF UseInvtPostSetup THEN BEGIN
          IF CalledFromItemPosting THEN
            InvtPostSetup.GET("Location Code","Inventory Posting Group")
          ELSE
            IF NOT InvtPostSetup.GET("Location Code","Inventory Posting Group") THEN
              EXIT;
        END ELSE BEGIN
          IF CalledFromItemPosting THEN
            GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group")
          ELSE
            IF NOT GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group") THEN
              EXIT;
        END;

        CASE "Account Type" OF
          "Account Type"::Inventory:
            IF CalledFromItemPosting THEN
              "Account No." := InvtPostSetup.GetInventoryAccount
            ELSE
              "Account No." := InvtPostSetup."Inventory Account";
          "Account Type"::"Inventory (Interim)":
            IF CalledFromItemPosting THEN
              "Account No." := InvtPostSetup.GetInventoryAccountInterim
            ELSE
              "Account No." := InvtPostSetup."Inventory Account (Interim)";
          "Account Type"::"WIP Inventory":
            IF CalledFromItemPosting THEN
              "Account No." := InvtPostSetup.GetWIPAccount
            ELSE
              "Account No." := InvtPostSetup."WIP Account";
          "Account Type"::"Material Variance":
            IF CalledFromItemPosting THEN
              "Account No." := InvtPostSetup.GetMaterialVarianceAccount
            ELSE
              "Account No." := InvtPostSetup."Material Variance Account";
          "Account Type"::"Capacity Variance":
            IF CalledFromItemPosting THEN
              "Account No." := InvtPostSetup.GetCapacityVarianceAccount
            ELSE
              "Account No." := InvtPostSetup."Capacity Variance Account";
          "Account Type"::"Subcontracted Variance":
            IF CalledFromItemPosting THEN
              "Account No." := InvtPostSetup.GetSubcontractedVarianceAccount
            ELSE
              "Account No." := InvtPostSetup."Subcontracted Variance Account";
          "Account Type"::"Cap. Overhead Variance":
            IF CalledFromItemPosting THEN
              "Account No." := InvtPostSetup.GetCapOverheadVarianceAccount
            ELSE
              "Account No." := InvtPostSetup."Cap. Overhead Variance Account";
          "Account Type"::"Mfg. Overhead Variance":
            IF CalledFromItemPosting THEN
              "Account No." := InvtPostSetup.GetMfgOverheadVarianceAccount
            ELSE
              "Account No." := InvtPostSetup."Mfg. Overhead Variance Account";
          "Account Type"::"Inventory Adjmt.":
            IF CalledFromItemPosting THEN
              "Account No." := GenPostingSetup.GetInventoryAdjmtAccount
            ELSE
              "Account No." := GenPostingSetup."Inventory Adjmt. Account";
          "Account Type"::"Direct Cost Applied":
            IF CalledFromItemPosting THEN
              "Account No." := GenPostingSetup.GetDirectCostAppliedAccount
            ELSE
              "Account No." := GenPostingSetup."Direct Cost Applied Account";
          "Account Type"::"Overhead Applied":
            IF CalledFromItemPosting THEN
              "Account No." := GenPostingSetup.GetOverheadAppliedAccount
            ELSE
              "Account No." := GenPostingSetup."Overhead Applied Account";
          "Account Type"::"Purchase Variance":
            IF CalledFromItemPosting THEN
              "Account No." := GenPostingSetup.GetPurchaseVarianceAccount
            ELSE
              "Account No." := GenPostingSetup."Purchase Variance Account";
          "Account Type"::COGS:
            IF CalledFromItemPosting THEN
              "Account No." := GenPostingSetup.GetCOGSAccount
            ELSE
              "Account No." := GenPostingSetup."COGS Account";
          "Account Type"::"COGS (Interim)":
            IF CalledFromItemPosting THEN
              "Account No." := GenPostingSetup.GetCOGSInterimAccount
            ELSE
              "Account No." := GenPostingSetup."COGS Account (Interim)";
          "Account Type"::"Invt. Accrual (Interim)":
            IF CalledFromItemPosting THEN
              "Account No." := GenPostingSetup.GetInventoryAccrualAccount
            ELSE
              "Account No." := GenPostingSetup."Invt. Accrual Acc. (Interim)";
        END;
        IF "Account No." <> '' THEN BEGIN
          GLAccount.GET("Account No.");
          IF GLAccount.Blocked THEN BEGIN
            IF CalledFromItemPosting THEN
              GLAccount.TESTFIELD(Blocked,FALSE);
            IF NOT CalledFromTestReport THEN
              "Account No." := '';
          END;
        END;
        OnAfterSetAccNo(InvtPostBuf,ValueEntry);
      END;
    END;

    LOCAL PROCEDURE SetPostBufAmounts@30(VAR InvtPostBuf@1004 : Record 48;CostToPost@1000 : Decimal;CostToPostACY@1001 : Decimal;InterimAccount@1003 : Boolean);
    BEGIN
      WITH InvtPostBuf DO BEGIN
        "Interim Account" := InterimAccount;
        Amount := CostToPost;
        "Amount (ACY)" := CostToPostACY;
      END;
    END;

    LOCAL PROCEDURE UpdateGlobalInvtPostBuf@28(ValueEntryNo@1002 : Integer) : Boolean;
    VAR
      i@1000 : Integer;
    BEGIN
      WITH GlobalInvtPostBuf DO BEGIN
        IF NOT CalledFromTestReport THEN
          FOR i := 1 TO PostBufDimNo DO
            IF TempInvtPostBuf[i]."Account No." = '' THEN BEGIN
              CLEAR(TempInvtPostBuf);
              EXIT(FALSE);
            END;
        FOR i := 1 TO PostBufDimNo DO BEGIN
          GlobalInvtPostBuf := TempInvtPostBuf[i];
          "Dimension Set ID" := TempInvtPostBuf[i]."Dimension Set ID";
          Negative := (TempInvtPostBuf[i].Amount < 0) OR (TempInvtPostBuf[i]."Amount (ACY)" < 0);

          UpdateReportAmounts;
          IF FIND THEN BEGIN
            Amount := Amount + TempInvtPostBuf[i].Amount;
            "Amount (ACY)" := "Amount (ACY)" + TempInvtPostBuf[i]."Amount (ACY)";
            MODIFY;
          END ELSE BEGIN
            GlobalInvtPostBufEntryNo := GlobalInvtPostBufEntryNo + 1;
            "Entry No." := GlobalInvtPostBufEntryNo;
            INSERT;
          END;

          IF NOT (RunOnlyCheck OR CalledFromTestReport) THEN BEGIN
            TempGLItemLedgRelation.INIT;
            TempGLItemLedgRelation."G/L Entry No." := "Entry No.";
            TempGLItemLedgRelation."Value Entry No." := ValueEntryNo;
            TempGLItemLedgRelation.INSERT;
          END;
        END;
      END;
      CLEAR(TempInvtPostBuf);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE UpdateReportAmounts@24();
    BEGIN
      WITH GlobalInvtPostBuf DO
        CASE "Account Type" OF
          "Account Type"::Inventory,"Account Type"::"Inventory (Interim)":
            InvtAmt += Amount;
          "Account Type"::"WIP Inventory":
            WIPInvtAmt += Amount;
          "Account Type"::"Inventory Adjmt.":
            InvtAdjmtAmt += Amount;
          "Account Type"::"Invt. Accrual (Interim)":
            InvtAdjmtAmt += Amount;
          "Account Type"::"Direct Cost Applied":
            DirCostAmt += Amount;
          "Account Type"::"Overhead Applied":
            OvhdCostAmt += Amount;
          "Account Type"::"Purchase Variance":
            VarPurchCostAmt += Amount;
          "Account Type"::COGS:
            COGSAmt += Amount;
          "Account Type"::"COGS (Interim)":
            COGSAmt += Amount;
          "Account Type"::"Material Variance","Account Type"::"Capacity Variance",
          "Account Type"::"Subcontracted Variance","Account Type"::"Cap. Overhead Variance":
            VarMfgDirCostAmt += Amount;
          "Account Type"::"Mfg. Overhead Variance":
            VarMfgOvhdCostAmt += Amount;
        END;
    END;

    LOCAL PROCEDURE ErrorNonValidCombination@2(ValueEntry@1000 : Record 5802);
    BEGIN
      WITH ValueEntry DO
        IF CalledFromTestReport THEN
          InsertTempInvtPostToGLTestBuf2(ValueEntry)
        ELSE
          ERROR(
            Text002,
            FIELDCAPTION("Item Ledger Entry Type"),"Item Ledger Entry Type",
            FIELDCAPTION("Entry Type"),"Entry Type",
            FIELDCAPTION("Expected Cost"),"Expected Cost")
    END;

    LOCAL PROCEDURE InsertTempInvtPostToGLTestBuf2@23(ValueEntry@1000 : Record 5802);
    BEGIN
      WITH ValueEntry DO BEGIN
        TempInvtPostToGLTestBuf."Line No." := GetNextLineNo;
        TempInvtPostToGLTestBuf."Posting Date" := "Posting Date";
        TempInvtPostToGLTestBuf.Description := STRSUBSTNO(Text003,TABLECAPTION,"Entry No.");
        TempInvtPostToGLTestBuf.Amount := "Cost Amount (Actual)";
        TempInvtPostToGLTestBuf."Value Entry No." := "Entry No.";
        TempInvtPostToGLTestBuf."Dimension Set ID" := "Dimension Set ID";
        TempInvtPostToGLTestBuf.INSERT;
      END;
    END;

    LOCAL PROCEDURE GetNextLineNo@26() : Integer;
    VAR
      InvtPostToGLTestBuffer@1000 : Record 5822;
      LastLineNo@1001 : Integer;
    BEGIN
      InvtPostToGLTestBuffer := TempInvtPostToGLTestBuf;
      IF TempInvtPostToGLTestBuf.FINDLAST THEN
        LastLineNo := TempInvtPostToGLTestBuf."Line No." + 10000
      ELSE
        LastLineNo := 10000;
      TempInvtPostToGLTestBuf := InvtPostToGLTestBuffer;
      EXIT(LastLineNo);
    END;

    [External]
    PROCEDURE PostInvtPostBufPerEntry@20(VAR ValueEntry@1001 : Record 5802);
    VAR
      DummyGenJnlLine@1002 : Record 81;
    BEGIN
      WITH ValueEntry DO
        PostInvtPostBuf(
          ValueEntry,
          "Document No.",
          "External Document No.",
          COPYSTR(
            STRSUBSTNO(Text000,"Entry Type","Source No.","Posting Date"),
            1,MAXSTRLEN(DummyGenJnlLine.Description)),
          FALSE);
    END;

    [Internal]
    PROCEDURE PostInvtPostBufPerPostGrp@19(DocNo@1001 : Code[20];Desc@1000 : Text[50]);
    VAR
      ValueEntry@1003 : Record 5802;
    BEGIN
      PostInvtPostBuf(ValueEntry,DocNo,'',Desc,TRUE);
    END;

    LOCAL PROCEDURE PostInvtPostBuf@3(VAR ValueEntry@1008 : Record 5802;DocNo@1002 : Code[20];ExternalDocNo@1007 : Code[35];Desc@1003 : Text[50];PostPerPostGrp@1001 : Boolean);
    VAR
      GenJnlLine@1004 : Record 81;
    BEGIN
      WITH GlobalInvtPostBuf DO BEGIN
        RESET;
        IF NOT FINDSET THEN
          EXIT;

        GenJnlLine.INIT;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."External Document No." := ExternalDocNo;
        GenJnlLine.Description := Desc;
        GetSourceCodeSetup;
        GenJnlLine."Source Code" := SourceCodeSetup."Inventory Post Cost";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Job No." := ValueEntry."Job No.";
        GenJnlLine."Reason Code" := ValueEntry."Reason Code";
        REPEAT
          GenJnlLine.VALIDATE("Posting Date","Posting Date");
          IF SetAmt(GenJnlLine,Amount,"Amount (ACY)") THEN BEGIN
            IF PostPerPostGrp THEN
              SetDesc(GenJnlLine,GlobalInvtPostBuf);
            GenJnlLine."Account No." := "Account No.";
            GenJnlLine."Dimension Set ID" := "Dimension Set ID";
            DimMgt.UpdateGlobalDimFromDimSetID(
              "Dimension Set ID",GenJnlLine."Shortcut Dimension 1 Code",
              GenJnlLine."Shortcut Dimension 2 Code");
            IF NOT CalledFromTestReport THEN
              IF NOT RunOnlyCheck THEN BEGIN
                IF NOT CalledFromItemPosting THEN
                  GenJnlPostLine.SetOverDimErr;
                OnBeforePostInvtPostBuf(GenJnlLine,GlobalInvtPostBuf,ValueEntry);
                GenJnlPostLine.RunWithCheck(GenJnlLine)
              END ELSE
                GenJnlCheckLine.RunCheck(GenJnlLine)
            ELSE
              InsertTempInvtPostToGLTestBuf(GenJnlLine,ValueEntry);
          END;
          IF NOT CalledFromTestReport AND NOT RunOnlyCheck THEN
            CreateGLItemLedgRelation(ValueEntry);
        UNTIL NEXT = 0;
        RunOnlyCheck := RunOnlyCheckSaved;
        DELETEALL;
      END;
    END;

    LOCAL PROCEDURE GetSourceCodeSetup@15();
    BEGIN
      IF NOT SourceCodeSetupRead THEN
        SourceCodeSetup.GET;
      SourceCodeSetupRead := TRUE;
    END;

    LOCAL PROCEDURE SetAmt@22(VAR GenJnlLine@1000 : Record 81;Amt@1001 : Decimal;AmtACY@1002 : Decimal) : Boolean;
    BEGIN
      WITH GenJnlLine DO BEGIN
        "Additional-Currency Posting" := "Additional-Currency Posting"::None;
        VALIDATE(Amount,Amt);

        GetGLSetup;
        IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
          "Source Currency Code" := GLSetup."Additional Reporting Currency";
          "Source Currency Amount" := AmtACY;
          IF (Amount = 0) AND ("Source Currency Amount" <> 0) THEN BEGIN
            "Additional-Currency Posting" :=
              "Additional-Currency Posting"::"Additional-Currency Amount Only";
            VALIDATE(Amount,"Source Currency Amount");
            "Source Currency Amount" := 0;
          END;
        END;
      END;

      EXIT((Amt <> 0) OR (AmtACY <> 0));
    END;

    [External]
    PROCEDURE SetDesc@27(VAR GenJnlLine@1006 : Record 81;InvtPostBuf@1004 : Record 48);
    BEGIN
      WITH InvtPostBuf DO
        GenJnlLine.Description :=
          COPYSTR(
            STRSUBSTNO(
              Text001,
              "Account Type","Bal. Account Type",
              "Location Code","Inventory Posting Group",
              "Gen. Bus. Posting Group","Gen. Prod. Posting Group"),
            1,MAXSTRLEN(GenJnlLine.Description));
    END;

    LOCAL PROCEDURE InsertTempInvtPostToGLTestBuf@25(GenJnlLine@1000 : Record 81;ValueEntry@1001 : Record 5802);
    BEGIN
      WITH GenJnlLine DO BEGIN
        TempInvtPostToGLTestBuf.INIT;
        TempInvtPostToGLTestBuf."Line No." := GetNextLineNo;
        TempInvtPostToGLTestBuf."Posting Date" := "Posting Date";
        TempInvtPostToGLTestBuf."Document No." := "Document No.";
        TempInvtPostToGLTestBuf.Description := Description;
        TempInvtPostToGLTestBuf."Account No." := "Account No.";
        TempInvtPostToGLTestBuf.Amount := Amount;
        TempInvtPostToGLTestBuf."Source Code" := "Source Code";
        TempInvtPostToGLTestBuf."System-Created Entry" := TRUE;
        TempInvtPostToGLTestBuf."Value Entry No." := ValueEntry."Entry No.";
        TempInvtPostToGLTestBuf."Additional-Currency Posting" := "Additional-Currency Posting";
        TempInvtPostToGLTestBuf."Source Currency Code" := "Source Currency Code";
        TempInvtPostToGLTestBuf."Source Currency Amount" := "Source Currency Amount";
        TempInvtPostToGLTestBuf."Inventory Account Type" := GlobalInvtPostBuf."Account Type";
        TempInvtPostToGLTestBuf."Dimension Set ID" := "Dimension Set ID";
        IF GlobalInvtPostBuf.UseInvtPostSetup THEN BEGIN
          TempInvtPostToGLTestBuf."Location Code" := GlobalInvtPostBuf."Location Code";
          TempInvtPostToGLTestBuf."Invt. Posting Group Code" :=
            GetInvPostingGroupCode(
              ValueEntry,
              TempInvtPostToGLTestBuf."Inventory Account Type" = TempInvtPostToGLTestBuf."Inventory Account Type"::"WIP Inventory",
              GlobalInvtPostBuf."Inventory Posting Group")
        END ELSE BEGIN
          TempInvtPostToGLTestBuf."Gen. Bus. Posting Group" := GlobalInvtPostBuf."Gen. Bus. Posting Group";
          TempInvtPostToGLTestBuf."Gen. Prod. Posting Group" := GlobalInvtPostBuf."Gen. Prod. Posting Group";
        END;
        TempInvtPostToGLTestBuf.INSERT;
      END;
    END;

    LOCAL PROCEDURE CreateGLItemLedgRelation@33(VAR ValueEntry@1000 : Record 5802);
    VAR
      GLReg@1001 : Record 45;
    BEGIN
      GenJnlPostLine.GetGLReg(GLReg);
      IF GlobalPostPerPostGroup THEN BEGIN
        TempGLItemLedgRelation.RESET;
        TempGLItemLedgRelation.SETRANGE("G/L Entry No.",GlobalInvtPostBuf."Entry No.");
        TempGLItemLedgRelation.FINDSET;
        REPEAT
          ValueEntry.GET(TempGLItemLedgRelation."Value Entry No.");
          UpdateValueEntry(ValueEntry);
          CreateGLItemLedgRelationEntry(GLReg);
        UNTIL TempGLItemLedgRelation.NEXT = 0;
      END ELSE BEGIN
        UpdateValueEntry(ValueEntry);
        CreateGLItemLedgRelationEntry(GLReg);
      END;
    END;

    LOCAL PROCEDURE CreateGLItemLedgRelationEntry@35(GLReg@1003 : Record 45);
    VAR
      GLItemLedgRelation@1002 : Record 5823;
    BEGIN
      GLItemLedgRelation.INIT;
      GLItemLedgRelation."G/L Entry No." := GLReg."To Entry No.";
      GLItemLedgRelation."Value Entry No." := TempGLItemLedgRelation."Value Entry No.";
      GLItemLedgRelation."G/L Register No." := GLReg."No.";
      GLItemLedgRelation.INSERT;
      TempGLItemLedgRelation."G/L Entry No." := GlobalInvtPostBuf."Entry No.";
      TempGLItemLedgRelation.DELETE;
    END;

    LOCAL PROCEDURE UpdateValueEntry@13(VAR ValueEntry@1000 : Record 5802);
    BEGIN
      WITH ValueEntry DO BEGIN
        IF GlobalInvtPostBuf."Interim Account" THEN BEGIN
          "Expected Cost Posted to G/L" := "Cost Amount (Expected)";
          "Exp. Cost Posted to G/L (ACY)" := "Cost Amount (Expected) (ACY)";
        END ELSE BEGIN
          "Cost Posted to G/L" := "Cost Amount (Actual)";
          "Cost Posted to G/L (ACY)" := "Cost Amount (Actual) (ACY)";
        END;
        IF NOT CalledFromItemPosting THEN
          MODIFY;
      END;
    END;

    [External]
    PROCEDURE GetTempInvtPostToGLTestBuf@29(VAR InvtPostToGLTestBuf@1001 : Record 5822);
    BEGIN
      InvtPostToGLTestBuf.DELETEALL;
      IF NOT TempInvtPostToGLTestBuf.FINDSET THEN
        EXIT;

      REPEAT
        InvtPostToGLTestBuf := TempInvtPostToGLTestBuf;
        InvtPostToGLTestBuf.INSERT;
      UNTIL TempInvtPostToGLTestBuf.NEXT = 0;
    END;

    [External]
    PROCEDURE GetAmtToPost@11(VAR NewCOGSAmt@1000 : Decimal;VAR NewInvtAdjmtAmt@1001 : Decimal;VAR NewDirCostAmt@1002 : Decimal;VAR NewOvhdCostAmt@1003 : Decimal;VAR NewVarPurchCostAmt@1004 : Decimal;VAR NewVarMfgDirCostAmt@1013 : Decimal;VAR NewVarMfgOvhdCostAmt@1008 : Decimal;VAR NewWIPInvtAmt@1009 : Decimal;VAR NewInvtAmt@1010 : Decimal;GetTotal@1007 : Boolean);
    BEGIN
      GetAmt(NewInvtAdjmtAmt,InvtAdjmtAmt,TotalInvtAdjmtAmt,GetTotal);
      GetAmt(NewDirCostAmt,DirCostAmt,TotalDirCostAmt,GetTotal);
      GetAmt(NewOvhdCostAmt,OvhdCostAmt,TotalOvhdCostAmt,GetTotal);
      GetAmt(NewVarPurchCostAmt,VarPurchCostAmt,TotalVarPurchCostAmt,GetTotal);
      GetAmt(NewVarMfgDirCostAmt,VarMfgDirCostAmt,TotalVarMfgDirCostAmt,GetTotal);
      GetAmt(NewVarMfgOvhdCostAmt,VarMfgOvhdCostAmt,TotalVarMfgOvhdCostAmt,GetTotal);
      GetAmt(NewWIPInvtAmt,WIPInvtAmt,TotalWIPInvtAmt,GetTotal);
      GetAmt(NewCOGSAmt,COGSAmt,TotalCOGSAmt,GetTotal);
      GetAmt(NewInvtAmt,InvtAmt,TotalInvtAmt,GetTotal);
    END;

    LOCAL PROCEDURE GetAmt@21(VAR NewAmt@1000 : Decimal;VAR Amt@1001 : Decimal;VAR TotalAmt@1002 : Decimal;GetTotal@1003 : Boolean);
    BEGIN
      IF GetTotal THEN
        NewAmt := TotalAmt
      ELSE BEGIN
        NewAmt := Amt;
        TotalAmt := TotalAmt + Amt;
        Amt := 0;
      END;
    END;

    [External]
    PROCEDURE GetInvtPostBuf@7(VAR InvtPostBuf@1000 : Record 48);
    BEGIN
      InvtPostBuf.DELETEALL;

      GlobalInvtPostBuf.RESET;
      IF GlobalInvtPostBuf.FINDSET THEN
        REPEAT
          InvtPostBuf := GlobalInvtPostBuf;
          InvtPostBuf.INSERT;
        UNTIL GlobalInvtPostBuf.NEXT = 0;
    END;

    LOCAL PROCEDURE GetInvPostingGroupCode@32(ValueEntry@1000 : Record 5802;WIPInventory@1001 : Boolean;InvPostingGroupCode@1002 : Code[20]) : Code[20];
    VAR
      Item@1003 : Record 27;
    BEGIN
      IF WIPInventory THEN
        IF ValueEntry."Source No." <> ValueEntry."Item No." THEN
          IF Item.GET(ValueEntry."Source No.") THEN
            EXIT(Item."Inventory Posting Group");

      EXIT(InvPostingGroupCode);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCalcCostToPostFromBuffer@37(VAR ValueEntry@1000 : Record 5802;VAR CostToPost@1001 : Decimal;VAR CostToPostACY@1002 : Decimal;VAR ExpCostToPost@1003 : Decimal;VAR ExpCostToPostACY@1004 : Decimal);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterSetAccNo@40(VAR InvtPostingBuffer@1000 : Record 48;ValueEntry@1001 : Record 5802);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostInvtPostBuf@41(VAR GenJournalLine@1000 : Record 81;InvtPostingBuffer@1001 : Record 48;ValueEntry@1002 : Record 5802);
    BEGIN
    END;

    BEGIN
    END.
  }
}

