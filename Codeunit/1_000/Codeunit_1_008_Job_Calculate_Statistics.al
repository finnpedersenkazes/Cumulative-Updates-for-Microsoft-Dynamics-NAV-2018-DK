OBJECT Codeunit 1008 Job Calculate Statistics
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      JobLedgEntry@1000 : Record 169;
      JobLedgEntry2@1003 : Record 169;
      JobPlanningLine@1001 : Record 1003;
      JobPlanningLine2@1004 : Record 1003;
      AmountType@1052 : 'TotalCostLCY,LineAmountLCY,TotalCost,LineAmount';
      PlanLineType@1054 : 'Schedule,Contract';
      JobLedgAmounts@1002 : ARRAY [10,4,4] OF Decimal;
      JobPlanAmounts@1051 : ARRAY [10,4,4] OF Decimal;
      Text000@1053 : TextConst 'DAN=Budgetpris,Forbrugssalgsbel›b,Fakturerbar pris,Fakt.pris,Budgetteret kostpris.,Forbrugsomkostning,Fakturerbar omkostning,Fakt. kostp.,Budget (avance),Forbrugsavancebel›b,Fakturerbar avance,Fakt. avance;ENU=Budget Price,Usage Price,Billable Price,Inv. Price,Budget Cost,Usage Cost,Billable Cost,Inv. Cost,Budget Profit,Usage Profit,Billable Profit,Inv. Profit';

    [External]
    PROCEDURE ReportAnalysis@10(VAR Job2@1000 : Record 167;VAR JT@1001 : Record 1001;VAR Amt@1008 : ARRAY [8] OF Decimal;AmountField@1002 : ARRAY [8] OF ' ,SchPrice,UsagePrice,ContractPrice,InvoicedPrice,SchCost,UsageCost,ContractCost,InvoicedCost,SchProfit,UsageProfit,ContractProfit,InvoicedProfit';CurrencyField@1003 : ARRAY [8] OF 'LCY,FCY';JobLevel@1010 : Boolean);
    VAR
      PL@1004 : ARRAY [16] OF Decimal;
      CL@1005 : ARRAY [16] OF Decimal;
      P@1006 : ARRAY [16] OF Decimal;
      C@1007 : ARRAY [16] OF Decimal;
      I@1009 : Integer;
    BEGIN
      IF JobLevel THEN
        JobCalculateCommonFilters(Job2)
      ELSE
        JTCalculateCommonFilters(JT,Job2,TRUE);
      CalculateAmounts;
      GetLCYCostAmounts(CL);
      GetCostAmounts(C);
      GetLCYPriceAmounts(PL);
      GetPriceAmounts(P);
      CLEAR(Amt);
      FOR I := 1 TO 8 DO BEGIN
        IF AmountField[I] = AmountField[I]::SchPrice THEN
          IF CurrencyField[I] = CurrencyField[I]::LCY THEN
            Amt[I] := PL[4]
          ELSE
            Amt[I] := P[4];
        IF AmountField[I] = AmountField[I]::UsagePrice THEN
          IF CurrencyField[I] = CurrencyField[I]::LCY THEN
            Amt[I] := PL[8]
          ELSE
            Amt[I] := P[8];
        IF AmountField[I] = AmountField[I]::ContractPrice THEN
          IF CurrencyField[I] = CurrencyField[I]::LCY THEN
            Amt[I] := PL[12]
          ELSE
            Amt[I] := P[12];
        IF AmountField[I] = AmountField[I]::InvoicedPrice THEN
          IF CurrencyField[I] = CurrencyField[I]::LCY THEN
            Amt[I] := PL[16]
          ELSE
            Amt[I] := P[16];

        IF AmountField[I] = AmountField[I]::SchCost THEN
          IF CurrencyField[I] = CurrencyField[I]::LCY THEN
            Amt[I] := CL[4]
          ELSE
            Amt[I] := C[4];
        IF AmountField[I] = AmountField[I]::UsageCost THEN
          IF CurrencyField[I] = CurrencyField[I]::LCY THEN
            Amt[I] := CL[8]
          ELSE
            Amt[I] := C[8];
        IF AmountField[I] = AmountField[I]::ContractCost THEN
          IF CurrencyField[I] = CurrencyField[I]::LCY THEN
            Amt[I] := CL[12]
          ELSE
            Amt[I] := C[12];
        IF AmountField[I] = AmountField[I]::InvoicedCost THEN
          IF CurrencyField[I] = CurrencyField[I]::LCY THEN
            Amt[I] := CL[16]
          ELSE
            Amt[I] := C[16];

        IF AmountField[I] = AmountField[I]::SchProfit THEN
          IF CurrencyField[I] = CurrencyField[I]::LCY THEN
            Amt[I] := PL[4] - CL[4]
          ELSE
            Amt[I] := P[4] - C[4];
        IF AmountField[I] = AmountField[I]::UsageProfit THEN
          IF CurrencyField[I] = CurrencyField[I]::LCY THEN
            Amt[I] := PL[8] - CL[8]
          ELSE
            Amt[I] := P[8] - C[8];
        IF AmountField[I] = AmountField[I]::ContractProfit THEN
          IF CurrencyField[I] = CurrencyField[I]::LCY THEN
            Amt[I] := PL[12] - CL[12]
          ELSE
            Amt[I] := P[12] - C[12];
        IF AmountField[I] = AmountField[I]::InvoicedProfit THEN
          IF CurrencyField[I] = CurrencyField[I]::LCY THEN
            Amt[I] := PL[16] - CL[16]
          ELSE
            Amt[I] := P[16] - C[16];
      END;
    END;

    [External]
    PROCEDURE ReportSuggBilling@12(VAR Job2@1004 : Record 167;VAR JT@1003 : Record 1001;VAR Amt@1002 : ARRAY [8] OF Decimal;CurrencyField@1000 : ARRAY [8] OF 'LCY,FCY');
    VAR
      AmountField@1005 : ARRAY [8] OF ' ,SchPrice,UsagePrice,ContractPrice,InvoicedPrice,SchCost,UsageCost,ContractCost,InvoicedCost,SchProfit,UsageProfit,ContractProfit,InvoicedProfit';
    BEGIN
      AmountField[1] := AmountField[1]::ContractCost;
      AmountField[2] := AmountField[2]::ContractPrice;
      AmountField[3] := AmountField[3]::InvoicedCost;
      AmountField[4] := AmountField[4]::InvoicedPrice;
      ReportAnalysis(Job2,JT,Amt,AmountField,CurrencyField,FALSE);
      Amt[5] := Amt[1] - Amt[3];
      Amt[6] := Amt[2] - Amt[4];
    END;

    [External]
    PROCEDURE RepJobCustomer@14(VAR Job2@1004 : Record 167;VAR Amt@1002 : ARRAY [8] OF Decimal);
    VAR
      JT@1000 : Record 1001;
      AmountField@1005 : ARRAY [8] OF ' ,SchPrice,UsagePrice,ContractPrice,InvoicedPrice,SchCost,UsageCost,ContractCost,InvoicedCost,SchProfit,UsageProfit,ContractProfit,InvoicedProfit';
      CurrencyField@1001 : ARRAY [8] OF 'LCY,FCY';
    BEGIN
      CLEAR(Amt);
      IF Job2."No." = '' THEN
        EXIT;
      AmountField[1] := AmountField[1]::SchPrice;
      AmountField[2] := AmountField[2]::UsagePrice;
      AmountField[3] := AmountField[3]::InvoicedPrice;
      AmountField[4] := AmountField[4]::ContractPrice;
      ReportAnalysis(Job2,JT,Amt,AmountField,CurrencyField,TRUE);
      Amt[5] := 0;
      Amt[6] := 0;
      IF Amt[1] <> 0 THEN
        Amt[5] := ROUND(Amt[2] / Amt[1] * 100);
      IF Amt[4] <> 0 THEN
        Amt[6] := ROUND(Amt[3] / Amt[4] * 100);
    END;

    [External]
    PROCEDURE JobCalculateCommonFilters@8(VAR Job@1001 : Record 167);
    BEGIN
      CLEARALL;
      JobPlanningLine.SETCURRENTKEY("Job No.","Job Task No.");
      JobLedgEntry.SETCURRENTKEY("Job No.","Job Task No.","Entry Type");
      JobPlanningLine.FILTERGROUP(2);
      JobLedgEntry.SETRANGE("Job No.",Job."No.");
      JobPlanningLine.SETRANGE("Job No.",Job."No.");
      JobPlanningLine.FILTERGROUP(0);
      JobLedgEntry.SETFILTER("Posting Date",Job.GETFILTER("Posting Date Filter"));
      JobPlanningLine.SETFILTER("Planning Date",Job.GETFILTER("Planning Date Filter"));
    END;

    [External]
    PROCEDURE JTCalculateCommonFilters@1(VAR JT2@1005 : Record 1001;VAR Job2@1001 : Record 167;UseJobFilter@1002 : Boolean);
    VAR
      JT@1000 : Record 1001;
    BEGIN
      CLEARALL;
      JT := JT2;
      JobPlanningLine.FILTERGROUP(2);
      JobPlanningLine.SETCURRENTKEY("Job No.","Job Task No.");
      JobLedgEntry.SETCURRENTKEY("Job No.","Job Task No.","Entry Type");
      JobLedgEntry.SETRANGE("Job No.",JT."Job No.");
      JobPlanningLine.SETRANGE("Job No.",JT."Job No.");
      JobPlanningLine.FILTERGROUP(0);
      IF JT."Job Task No." <> '' THEN
        IF JT.Totaling <> '' THEN BEGIN
          JobLedgEntry.SETFILTER("Job Task No.",JT.Totaling);
          JobPlanningLine.SETFILTER("Job Task No.",JT.Totaling);
        END ELSE BEGIN
          JobLedgEntry.SETRANGE("Job Task No.",JT."Job Task No.");
          JobPlanningLine.SETRANGE("Job Task No.",JT."Job Task No.");
        END;

      IF NOT UseJobFilter THEN BEGIN
        JobLedgEntry.SETFILTER("Posting Date",JT2.GETFILTER("Posting Date Filter"));
        JobPlanningLine.SETFILTER("Planning Date",JT2.GETFILTER("Planning Date Filter"));
      END ELSE BEGIN
        JobLedgEntry.SETFILTER("Posting Date",Job2.GETFILTER("Posting Date Filter"));
        JobPlanningLine.SETFILTER("Planning Date",Job2.GETFILTER("Planning Date Filter"));
      END;
    END;

    [External]
    PROCEDURE CalculateAmounts@5();
    BEGIN
      CalcJobLedgAmounts(JobLedgEntry."Entry Type"::Usage,JobLedgEntry.Type::Resource);
      CalcJobLedgAmounts(JobLedgEntry."Entry Type"::Usage,JobLedgEntry.Type::Item);
      CalcJobLedgAmounts(JobLedgEntry."Entry Type"::Usage,JobLedgEntry.Type::"G/L Account");
      CalcJobLedgAmounts(JobLedgEntry."Entry Type"::Sale,JobLedgEntry.Type::Resource);
      CalcJobLedgAmounts(JobLedgEntry."Entry Type"::Sale,JobLedgEntry.Type::Item);
      CalcJobLedgAmounts(JobLedgEntry."Entry Type"::Sale,JobLedgEntry.Type::"G/L Account");

      CalcJobPlanAmounts(PlanLineType::Contract,JobPlanningLine.Type::Resource);
      CalcJobPlanAmounts(PlanLineType::Contract,JobPlanningLine.Type::Item);
      CalcJobPlanAmounts(PlanLineType::Contract,JobPlanningLine.Type::"G/L Account");
      CalcJobPlanAmounts(PlanLineType::Schedule,JobPlanningLine.Type::Resource);
      CalcJobPlanAmounts(PlanLineType::Schedule,JobPlanningLine.Type::Item);
      CalcJobPlanAmounts(PlanLineType::Schedule,JobPlanningLine.Type::"G/L Account");
    END;

    LOCAL PROCEDURE CalcJobLedgAmounts@16(EntryTypeParm@1000 : Option;TypeParm@1001 : Option);
    BEGIN
      JobLedgEntry2.COPY(JobLedgEntry);
      WITH JobLedgEntry2 DO BEGIN
        SETRANGE("Entry Type",EntryTypeParm);
        SETRANGE(Type,TypeParm);
        CALCSUMS("Total Cost (LCY)","Line Amount (LCY)","Total Cost","Line Amount");
        JobLedgAmounts[1 + EntryTypeParm,1 + TypeParm,1 + AmountType::TotalCostLCY] := "Total Cost (LCY)";
        JobLedgAmounts[1 + EntryTypeParm,1 + TypeParm,1 + AmountType::LineAmountLCY] := "Line Amount (LCY)";
        JobLedgAmounts[1 + EntryTypeParm,1 + TypeParm,1 + AmountType::TotalCost] := "Total Cost";
        JobLedgAmounts[1 + EntryTypeParm,1 + TypeParm,1 + AmountType::LineAmount] := "Line Amount";
      END;
    END;

    LOCAL PROCEDURE CalcJobPlanAmounts@20(PlanLineTypeParm@1000 : Option;TypeParm@1001 : Option);
    BEGIN
      JobPlanningLine2.COPY(JobPlanningLine);
      WITH JobPlanningLine2 DO BEGIN
        SETRANGE("Schedule Line");
        SETRANGE("Contract Line");
        IF PlanLineTypeParm = PlanLineType::Schedule THEN
          SETRANGE("Schedule Line",TRUE)
        ELSE
          SETRANGE("Contract Line",TRUE);
        SETRANGE(Type,TypeParm);
        CALCSUMS("Total Cost (LCY)","Line Amount (LCY)","Total Cost","Line Amount");
        JobPlanAmounts[1 + PlanLineTypeParm,1 + TypeParm,1 + AmountType::TotalCostLCY] := "Total Cost (LCY)";
        JobPlanAmounts[1 + PlanLineTypeParm,1 + TypeParm,1 + AmountType::LineAmountLCY] := "Line Amount (LCY)";
        JobPlanAmounts[1 + PlanLineTypeParm,1 + TypeParm,1 + AmountType::TotalCost] := "Total Cost";
        JobPlanAmounts[1 + PlanLineTypeParm,1 + TypeParm,1 + AmountType::LineAmount] := "Line Amount";
      END;
    END;

    [External]
    PROCEDURE GetLCYCostAmounts@2(VAR Amt@1000 : ARRAY [16] OF Decimal);
    BEGIN
      GetArrayAmounts(Amt,AmountType::TotalCostLCY);
    END;

    [External]
    PROCEDURE GetCostAmounts@6(VAR Amt@1000 : ARRAY [16] OF Decimal);
    BEGIN
      GetArrayAmounts(Amt,AmountType::TotalCost);
    END;

    [External]
    PROCEDURE GetLCYPriceAmounts@4(VAR Amt@1000 : ARRAY [16] OF Decimal);
    BEGIN
      GetArrayAmounts(Amt,AmountType::LineAmountLCY);
    END;

    [External]
    PROCEDURE GetPriceAmounts@7(VAR Amt@1000 : ARRAY [16] OF Decimal);
    BEGIN
      GetArrayAmounts(Amt,AmountType::LineAmount);
    END;

    LOCAL PROCEDURE GetArrayAmounts@23(VAR Amt@1000 : ARRAY [16] OF Decimal;AmountTypeParm@1001 : Option);
    BEGIN
      Amt[1] := JobPlanAmounts[1 + PlanLineType::Schedule,1 + JobPlanningLine.Type::Resource,1 + AmountTypeParm];
      Amt[2] := JobPlanAmounts[1 + PlanLineType::Schedule,1 + JobPlanningLine.Type::Item,1 + AmountTypeParm];
      Amt[3] := JobPlanAmounts[1 + PlanLineType::Schedule,1 + JobPlanningLine.Type::"G/L Account",1 + AmountTypeParm];
      Amt[4] := Amt[1] + Amt[2] + Amt[3];
      Amt[5] := JobLedgAmounts[1 + JobLedgEntry."Entry Type"::Usage,1 + JobLedgEntry.Type::Resource,1 + AmountTypeParm];
      Amt[6] := JobLedgAmounts[1 + JobLedgEntry."Entry Type"::Usage,1 + JobLedgEntry.Type::Item,1 + AmountTypeParm];
      Amt[7] := JobLedgAmounts[1 + JobLedgEntry."Entry Type"::Usage,1 + JobLedgEntry.Type::"G/L Account",1 + AmountTypeParm];
      Amt[8] := Amt[5] + Amt[6] + Amt[7];
      Amt[9] := JobPlanAmounts[1 + PlanLineType::Contract,1 + JobPlanningLine.Type::Resource,1 + AmountTypeParm];
      Amt[10] := JobPlanAmounts[1 + PlanLineType::Contract,1 + JobPlanningLine.Type::Item,1 + AmountTypeParm];
      Amt[11] := JobPlanAmounts[1 + PlanLineType::Contract,1 + JobPlanningLine.Type::"G/L Account",1 + AmountTypeParm];
      Amt[12] := Amt[9] + Amt[10] + Amt[11];
      Amt[13] := -JobLedgAmounts[1 + JobLedgEntry."Entry Type"::Sale,1 + JobLedgEntry.Type::Resource,1 + AmountTypeParm];
      Amt[14] := -JobLedgAmounts[1 + JobLedgEntry."Entry Type"::Sale,1 + JobLedgEntry.Type::Item,1 + AmountTypeParm];
      Amt[15] := -JobLedgAmounts[1 + JobLedgEntry."Entry Type"::Sale,1 + JobLedgEntry.Type::"G/L Account",1 + AmountTypeParm];
      Amt[16] := Amt[13] + Amt[14] + Amt[15];
    END;

    [External]
    PROCEDURE ShowPlanningLine@3(Showfield@1003 : Integer;JobType@1001 : ' ,Resource,Item,GL';Schedule@1000 : Boolean);
    VAR
      PlanningList@1002 : Page 1007;
    BEGIN
      WITH JobPlanningLine DO BEGIN
        FILTERGROUP(2);
        SETRANGE("Contract Line");
        SETRANGE("Schedule Line");
        SETRANGE(Type);
        IF JobType > 0 THEN
          SETRANGE(Type,JobType - 1);
        IF Schedule THEN
          SETRANGE("Schedule Line",TRUE)
        ELSE
          SETRANGE("Contract Line",TRUE);
        FILTERGROUP(0);
        PlanningList.SETTABLEVIEW(JobPlanningLine);
        PlanningList.SetActiveField(Showfield);
        PlanningList.RUN;
      END;
    END;

    [External]
    PROCEDURE ShowLedgEntry@9(Showfield@1003 : Integer;JobType@1001 : ' ,Resource,Item,GL';Usage@1000 : Boolean);
    VAR
      JobLedgEntryList@1002 : Page 92;
    BEGIN
      JobLedgEntry.SETRANGE(Type);
      IF Usage THEN
        JobLedgEntry.SETRANGE("Entry Type",JobLedgEntry."Entry Type"::Usage)
      ELSE
        JobLedgEntry.SETRANGE("Entry Type",JobLedgEntry."Entry Type"::Sale);
      IF JobType > 0 THEN
        JobLedgEntry.SETRANGE(Type,JobType - 1);
      JobLedgEntryList.SETTABLEVIEW(JobLedgEntry);
      JobLedgEntryList.SetActiveField(Showfield);
      JobLedgEntryList.RUN;
    END;

    [External]
    PROCEDURE GetHeadLineText@11(AmountField@1002 : ARRAY [8] OF ' ,SchPrice,UsagePrice,BillablePrice,InvoicedPrice,SchCost,UsageCost,BillableCost,InvoicedCost,SchProfit,UsageProfit,BillableProfit,InvoicedProfit';CurrencyField@1001 : ARRAY [8] OF 'LCY,FCY';VAR HeadLineText@1000 : ARRAY [8] OF Text[50];Job@1004 : Record 167);
    VAR
      GLSetup@1005 : Record 98;
      I@1003 : Integer;
      Txt@1006 : Text[30];
    BEGIN
      CLEAR(HeadLineText);
      GLSetup.GET;

      FOR I := 1 TO 8 DO BEGIN
        Txt := '';
        IF CurrencyField[I] > 0 THEN
          Txt := Job."Currency Code";
        IF Txt = '' THEN
          Txt := GLSetup."LCY Code";
        IF AmountField[I] > 0 THEN
          HeadLineText[I] := SELECTSTR(AmountField[I],Text000) + '\' + Txt;
      END;
    END;

    BEGIN
    END.
  }
}

