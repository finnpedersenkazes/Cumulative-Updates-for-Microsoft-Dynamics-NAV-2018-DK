OBJECT Table 5810 Rounding Residual Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Afrundingsbuffer;
               ENU=Rounding Residual Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Item Ledger Entry No.;Integer      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varepostl�benr.;
                                                              ENU=Item Ledger Entry No.] }
    { 2   ;   ;Adjusted Cost       ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Reguleret kostv�rdi;
                                                              ENU=Adjusted Cost] }
    { 3   ;   ;Adjusted Cost (ACY) ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Reguleret kostv�rdi (EV);
                                                              ENU=Adjusted Cost (ACY)] }
    { 4   ;   ;Completely Invoiced ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Fuldt faktureret;
                                                              ENU=Completely Invoiced] }
    { 5   ;   ;No. of Hits         ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal hit;
                                                              ENU=No. of Hits] }
  }
  KEYS
  {
    {    ;Item Ledger Entry No.                   ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE AddAdjustedCost@1(NewInboundEntryNo@1000 : Integer;NewAdjustedCost@1001 : Decimal;NewAdjustedCostACY@1002 : Decimal;NewCompletelyInvoiced@1003 : Boolean);
    BEGIN
      IF NOT HasNewCost(NewAdjustedCost,NewAdjustedCostACY) AND NewCompletelyInvoiced THEN BEGIN
        Retrieve(NewInboundEntryNo);
        EXIT;
      END;

      IF Retrieve(NewInboundEntryNo) THEN BEGIN
        "Adjusted Cost" := "Adjusted Cost" + NewAdjustedCost;
        "Adjusted Cost (ACY)" := "Adjusted Cost (ACY)" + NewAdjustedCostACY;
        IF NOT NewCompletelyInvoiced THEN
          "Completely Invoiced" := FALSE;
        MODIFY;
      END ELSE BEGIN
        INIT;
        "Adjusted Cost" := NewAdjustedCost;
        "Adjusted Cost (ACY)" := NewAdjustedCostACY;
        "Completely Invoiced" := NewCompletelyInvoiced;
        INSERT;
      END;
    END;

    [External]
    PROCEDURE UpdRoundingCheck@2(NewInboundEntryNo@1000 : Integer;NewAdjustedCost@1001 : Decimal;NewAdjustedCostACY@1002 : Decimal;RdngPrecision@1004 : Decimal;RndngPrecisionACY@1005 : Decimal);
    BEGIN
      IF NOT HasNewCost(NewAdjustedCost,NewAdjustedCostACY) THEN BEGIN
        Retrieve(NewInboundEntryNo);
        EXIT;
      END;

      IF Retrieve(NewInboundEntryNo) THEN BEGIN
        IF ((RdngPrecision >= NewAdjustedCost) OR
            (RndngPrecisionACY >= NewAdjustedCostACY)) AND
           (("Adjusted Cost" * NewAdjustedCost <= 0) AND
            ("Adjusted Cost (ACY)" * NewAdjustedCostACY <= 0))
        THEN
          "No. of Hits" := "No. of Hits" + 1
        ELSE
          "No. of Hits" := 0;

        "Adjusted Cost" := NewAdjustedCost;
        "Adjusted Cost (ACY)" := NewAdjustedCostACY;
        MODIFY;
      END ELSE BEGIN
        INIT;
        "Adjusted Cost" := NewAdjustedCost;
        "Adjusted Cost (ACY)" := NewAdjustedCostACY;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE Retrieve@72(NewInboundEntryNo@1000 : Integer) : Boolean;
    BEGIN
      RESET;
      "Item Ledger Entry No." := NewInboundEntryNo;
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

    BEGIN
    END.
  }
}

