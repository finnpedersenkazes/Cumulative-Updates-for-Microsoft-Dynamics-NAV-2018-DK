OBJECT Codeunit 212 Res. Jnl.-Post Line
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    TableNo=207;
    Permissions=TableData 203=imd,
                TableData 240=imd,
                TableData 951=m,
                TableData 952=m;
    OnRun=BEGIN
            GetGLSetup;
            RunWithCheck(Rec);
          END;

  }
  CODE
  {
    VAR
      GLSetup@1010 : Record 98;
      ResJnlLine@1000 : Record 207;
      ResLedgEntry@1001 : Record 203;
      Res@1002 : Record 156;
      ResReg@1003 : Record 240;
      GenPostingSetup@1004 : Record 252;
      ResUOM@1011 : Record 205;
      ResJnlCheckLine@1006 : Codeunit 211;
      NextEntryNo@1008 : Integer;
      GLSetupRead@1009 : Boolean;

    [External]
    PROCEDURE RunWithCheck@3(VAR ResJnlLine2@1000 : Record 207);
    BEGIN
      ResJnlLine.COPY(ResJnlLine2);
      Code;
      ResJnlLine2 := ResJnlLine;
    END;

    LOCAL PROCEDURE Code@1();
    BEGIN
      WITH ResJnlLine DO BEGIN
        IF EmptyLine THEN
          EXIT;

        ResJnlCheckLine.RunCheck(ResJnlLine);

        IF NextEntryNo = 0 THEN BEGIN
          ResLedgEntry.LOCKTABLE;
          IF ResLedgEntry.FINDLAST THEN
            NextEntryNo := ResLedgEntry."Entry No.";
          NextEntryNo := NextEntryNo + 1;
        END;

        IF "Document Date" = 0D THEN
          "Document Date" := "Posting Date";

        IF ResReg."No." = 0 THEN BEGIN
          ResReg.LOCKTABLE;
          IF (NOT ResReg.FINDLAST) OR (ResReg."To Entry No." <> 0) THEN BEGIN
            ResReg.INIT;
            ResReg."No." := ResReg."No." + 1;
            ResReg."From Entry No." := NextEntryNo;
            ResReg."To Entry No." := NextEntryNo;
            ResReg."Creation Date" := TODAY;
            ResReg."Source Code" := "Source Code";
            ResReg."Journal Batch Name" := "Journal Batch Name";
            ResReg."User ID" := USERID;
            ResReg.INSERT;
          END;
        END;
        ResReg."To Entry No." := NextEntryNo;
        ResReg.MODIFY;

        Res.GET("Resource No.");
        Res.CheckResourcePrivacyBlocked(TRUE);
        Res.TESTFIELD(Blocked,FALSE);

        IF (GenPostingSetup."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") OR
           (GenPostingSetup."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group")
        THEN
          GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");

        "Resource Group No." := Res."Resource Group No.";

        ResLedgEntry.INIT;
        ResLedgEntry.CopyFromResJnlLine(ResJnlLine);

        GetGLSetup;
        ResLedgEntry."Total Cost" := ROUND(ResLedgEntry."Total Cost");
        ResLedgEntry."Total Price" := ROUND(ResLedgEntry."Total Price");
        IF ResLedgEntry."Entry Type" = ResLedgEntry."Entry Type"::Sale THEN BEGIN
          ResLedgEntry.Quantity := -ResLedgEntry.Quantity;
          ResLedgEntry."Total Cost" := -ResLedgEntry."Total Cost";
          ResLedgEntry."Total Price" := -ResLedgEntry."Total Price";
        END;
        ResLedgEntry."Direct Unit Cost" := ROUND(ResLedgEntry."Direct Unit Cost",GLSetup."Unit-Amount Rounding Precision");
        ResLedgEntry."User ID" := USERID;
        ResLedgEntry."Entry No." := NextEntryNo;
        ResUOM.GET(ResLedgEntry."Resource No.",ResLedgEntry."Unit of Measure Code");
        IF ResUOM."Related to Base Unit of Meas." THEN
          ResLedgEntry."Quantity (Base)" := ResLedgEntry.Quantity * ResLedgEntry."Qty. per Unit of Measure";

        IF ResLedgEntry."Entry Type" = ResLedgEntry."Entry Type"::Usage THEN BEGIN
          PostTimeSheetDetail(ResJnlLine,ResLedgEntry."Quantity (Base)");
          ResLedgEntry.Chargeable := IsChargable(ResJnlLine,ResLedgEntry.Chargeable);
        END;

        OnBeforeResLedgEntryInsert(ResLedgEntry,ResJnlLine);

        ResLedgEntry.INSERT(TRUE);

        NextEntryNo := NextEntryNo + 1;
      END;
    END;

    LOCAL PROCEDURE GetGLSetup@14();
    BEGIN
      IF NOT GLSetupRead THEN
        GLSetup.GET;
      GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE PostTimeSheetDetail@4(ResJnlLine2@1002 : Record 207;QtyToPost@1003 : Decimal);
    VAR
      TimeSheetLine@1001 : Record 951;
      TimeSheetDetail@1000 : Record 952;
      TimeSheetMgt@1004 : Codeunit 950;
    BEGIN
      WITH ResJnlLine2 DO
        IF "Time Sheet No." <> '' THEN BEGIN
          TimeSheetDetail.GET("Time Sheet No.","Time Sheet Line No.","Time Sheet Date");
          TimeSheetDetail."Posted Quantity" += QtyToPost;
          TimeSheetDetail.Posted := TimeSheetDetail.Quantity = TimeSheetDetail."Posted Quantity";
          TimeSheetDetail.MODIFY;
          TimeSheetLine.GET("Time Sheet No.","Time Sheet Line No.");
          TimeSheetMgt.CreateTSPostingEntry(TimeSheetDetail,Quantity,"Posting Date","Document No.",TimeSheetLine.Description);

          TimeSheetDetail.SETRANGE("Time Sheet No.","Time Sheet No.");
          TimeSheetDetail.SETRANGE("Time Sheet Line No.","Time Sheet Line No.");
          TimeSheetDetail.SETRANGE(Posted,FALSE);
          IF TimeSheetDetail.ISEMPTY THEN BEGIN
            TimeSheetLine.Posted := TRUE;
            TimeSheetLine.MODIFY;
          END;
        END;
    END;

    LOCAL PROCEDURE IsChargable@6(ResJournalLine@1000 : Record 207;Chargeable@1002 : Boolean) : Boolean;
    VAR
      TimeSheetLine@1001 : Record 951;
    BEGIN
      IF ResJournalLine."Time Sheet No." <> '' THEN BEGIN
        TimeSheetLine.GET(ResJournalLine."Time Sheet No.",ResJournalLine."Time Sheet Line No.");
        EXIT(TimeSheetLine.Chargeable);
      END;
      EXIT(Chargeable);
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeResLedgEntryInsert@7(VAR ResLedgerEntry@1000 : Record 203;ResJournalLine@1001 : Record 207);
    BEGIN
    END;

    BEGIN
    END.
  }
}

