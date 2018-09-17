OBJECT Table 5820 Cost Element Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kostelementbuffer;
               ENU=Cost Element Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Type                ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=K�bspris,V�rdiregulering,Afrunding,Indir. omkostning,Afvigelse,I alt;
                                                                    ENU=Direct Cost,Revaluation,Rounding,Indirect Cost,Variance,Total];
                                                   OptionString=Direct Cost,Revaluation,Rounding,Indirect Cost,Variance,Total }
    { 2   ;   ;Variance Type       ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afvigelsestype;
                                                              ENU=Variance Type];
                                                   OptionCaptionML=[DAN=" ,K�b,Materiale,Kapacitet,Indirekte kap.kostpris,Indirekte prod.kostpris,Underleverand�r";
                                                                    ENU=" ,Purchase,Material,Capacity,Capacity Overhead,Manufacturing Overhead,Subcontracted"];
                                                   OptionString=[ ,Purchase,Material,Capacity,Capacity Overhead,Manufacturing Overhead,Subcontracted] }
    { 3   ;   ;Actual Cost         ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Faktisk kostpris;
                                                              ENU=Actual Cost];
                                                   AutoFormatType=1 }
    { 4   ;   ;Actual Cost (ACY)   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Faktisk kostpris (EV);
                                                              ENU=Actual Cost (ACY)];
                                                   AutoFormatType=1 }
    { 5   ;   ;Rounding Residual   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Restv�rdi ved afrunding;
                                                              ENU=Rounding Residual];
                                                   AutoFormatType=1 }
    { 6   ;   ;Rounding Residual (ACY);Decimal    ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Restv�rdi ved afrunding (EV);
                                                              ENU=Rounding Residual (ACY)];
                                                   AutoFormatType=1 }
    { 7   ;   ;Expected Cost       ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Forventet kostpris;
                                                              ENU=Expected Cost];
                                                   AutoFormatType=1 }
    { 8   ;   ;Expected Cost (ACY) ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Forventet kostpris (EV);
                                                              ENU=Expected Cost (ACY)];
                                                   AutoFormatType=1 }
    { 9   ;   ;Invoiced Quantity   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Faktureret antal;
                                                              ENU=Invoiced Quantity] }
    { 10  ;   ;Remaining Quantity  ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Restantal;
                                                              ENU=Remaining Quantity] }
    { 11  ;   ;Inbound Completely Invoiced;Boolean;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indg�ende fuldt faktureret;
                                                              ENU=Inbound Completely Invoiced] }
    { 12  ;   ;Last Valid Value Entry No;Integer  ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sidste gyldige v�rdil�benr.;
                                                              ENU=Last Valid Value Entry No] }
  }
  KEYS
  {
    {    ;Type,Variance Type                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE AddActualCost@1(NewType@1000 : Option;NewVarianceType@1003 : Option;NewActualCost@1001 : Decimal;NewActualCostACY@1002 : Decimal);
    BEGIN
      IF NOT HasNewCost(NewActualCost,NewActualCostACY) THEN BEGIN
        Retrieve(NewType,NewVarianceType);
        EXIT;
      END;
      IF Retrieve(NewType,NewVarianceType) THEN BEGIN
        "Actual Cost" := "Actual Cost" + NewActualCost;
        "Actual Cost (ACY)" := "Actual Cost (ACY)" + NewActualCostACY;
        MODIFY;
      END ELSE BEGIN
        "Actual Cost" := NewActualCost;
        "Actual Cost (ACY)" := NewActualCostACY;
        INSERT;
      END;
    END;

    [External]
    PROCEDURE AddExpectedCost@2(NewType@1000 : Option;NewVarianceType@1003 : Option;NewExpectedCost@1001 : Decimal;NewExpectedCostACY@1002 : Decimal);
    BEGIN
      IF NOT HasNewCost(NewExpectedCost,NewExpectedCostACY) THEN BEGIN
        Retrieve(NewType,NewVarianceType);
        EXIT;
      END;
      IF Retrieve(NewType,NewVarianceType) THEN BEGIN
        "Expected Cost" := "Expected Cost" + NewExpectedCost;
        "Expected Cost (ACY)" := "Expected Cost (ACY)" + NewExpectedCostACY;
        MODIFY;
      END ELSE BEGIN
        "Expected Cost" := NewExpectedCost;
        "Expected Cost (ACY)" := NewExpectedCostACY;
        INSERT;
      END;
    END;

    [External]
    PROCEDURE RoundActualCost@77(ShareOfTotalCost@1003 : Decimal;AmtRndgPrec@1001 : Decimal;AmtRndgPrecACY@1002 : Decimal);
    BEGIN
      "Actual Cost" := ROUND("Actual Cost" * ShareOfTotalCost,AmtRndgPrec);
      "Actual Cost (ACY)" := ROUND("Actual Cost (ACY)" * ShareOfTotalCost,AmtRndgPrecACY);
    END;

    [External]
    PROCEDURE ExcludeEntryFromAvgCostCalc@69(ValueEntry@1001 : Record 5802);
    BEGIN
      "Remaining Quantity" := "Remaining Quantity" - ValueEntry."Item Ledger Entry Quantity";
      "Actual Cost" := "Actual Cost" - ValueEntry."Cost Amount (Actual)" - ValueEntry."Cost Amount (Expected)";
      "Actual Cost (ACY)" :=
        "Actual Cost (ACY)" - ValueEntry."Cost Amount (Actual) (ACY)" - ValueEntry."Cost Amount (Expected) (ACY)";
    END;

    [External]
    PROCEDURE ExcludeBufFromAvgCostCalc@6(InvtAdjmtBuffer@1001 : Record 5895);
    BEGIN
      "Remaining Quantity" := "Remaining Quantity" - InvtAdjmtBuffer."Item Ledger Entry Quantity";
      "Actual Cost" := "Actual Cost" - InvtAdjmtBuffer."Cost Amount (Actual)" - InvtAdjmtBuffer."Cost Amount (Expected)";
      "Actual Cost (ACY)" :=
        "Actual Cost (ACY)" - InvtAdjmtBuffer."Cost Amount (Actual) (ACY)" - InvtAdjmtBuffer."Cost Amount (Expected) (ACY)";
    END;

    [External]
    PROCEDURE Retrieve@72(NewType@1001 : Option;NewVarianceType@1000 : Option) : Boolean;
    BEGIN
      RESET;
      Type := NewType;
      "Variance Type" := NewVarianceType;
      IF NOT FIND THEN BEGIN
        INIT;
        EXIT(FALSE);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE HasNewCost@54(NewCost@1000 : Decimal;NewCostACY@1001 : Decimal) : Boolean;
    BEGIN
      EXIT((NewCost <> 0) OR (NewCostACY <> 0));
    END;

    [External]
    PROCEDURE DeductOutbndValueEntryFromBuf@8(OutbndValueEntry@1000 : Record 5802;CostElementBuf@1001 : Record 5820;IsAvgCostCalcTypeItem@1002 : Boolean);
    BEGIN
      IF "Remaining Quantity" + OutbndValueEntry."Valued Quantity" <= 0 THEN
        EXIT;

      IF (OutbndValueEntry."Item Ledger Entry Type" = OutbndValueEntry."Item Ledger Entry Type"::Transfer) AND
         IsAvgCostCalcTypeItem
      THEN
        EXIT;

      "Remaining Quantity" += OutbndValueEntry."Valued Quantity";
      "Actual Cost" += CostElementBuf."Actual Cost";
      "Actual Cost (ACY)" += CostElementBuf."Actual Cost (ACY)";
    END;

    [External]
    PROCEDURE UpdateAvgCostBuffer@4(CostElementBuf@1000 : Record 5820;LastValidEntryNo@1001 : Integer);
    BEGIN
      "Actual Cost" := CostElementBuf."Actual Cost";
      "Actual Cost (ACY)" := CostElementBuf."Actual Cost (ACY)";
      "Last Valid Value Entry No" := LastValidEntryNo;
      "Remaining Quantity" := CostElementBuf."Remaining Quantity";
    END;

    [External]
    PROCEDURE UpdateCostElementBuffer@5(AvgCostBuf@1000 : Record 5820);
    BEGIN
      "Remaining Quantity" := AvgCostBuf."Remaining Quantity";
      "Actual Cost" := AvgCostBuf."Actual Cost";
      "Actual Cost (ACY)" := AvgCostBuf."Actual Cost (ACY)";
      "Rounding Residual" := AvgCostBuf."Rounding Residual";
      "Rounding Residual (ACY)" := AvgCostBuf."Rounding Residual (ACY)";
    END;

    BEGIN
    END.
  }
}

