OBJECT Codeunit 393 Reminder-Issue
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 21=rm,
                TableData 297=rimd,
                TableData 298=rimd,
                TableData 300=rimd;
    OnRun=VAR
            CustLedgEntry@1001 : Record 21;
            CustLedgEntry2@1004 : Record 21;
            CustPostingGr@1003 : Record 92;
            ReminderLine@1002 : Record 296;
            ReminderFinChargeEntry@1007 : Record 300;
            ReminderCommentLine@1006 : Record 299;
          BEGIN
            OnBeforeIssueReminder(ReminderHeader);

            WITH ReminderHeader DO BEGIN
              UpdateReminderRounding(ReminderHeader);
              IF (PostingDate <> 0D) AND (ReplacePostingDate OR ("Posting Date" = 0D)) THEN
                VALIDATE("Posting Date",PostingDate);
              TESTFIELD("Customer No.");
              CheckIfBlocked("Customer No.");

              TESTFIELD("Posting Date");
              TESTFIELD("Document Date");
              TESTFIELD("Due Date");
              TESTFIELD("Customer Posting Group");
              IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
                ERROR(
                  DimensionCombinationIsBlockedErr,
                  TABLECAPTION,"No.",DimMgt.GetDimCombErr);

              TableID[1] := DATABASE::Customer;
              No[1] := "Customer No.";
              IF NOT DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") THEN
                ERROR(
                  Text003,
                  TABLECAPTION,"No.",DimMgt.GetDimValuePostingErr);

              CustPostingGr.GET("Customer Posting Group");
              CALCFIELDS("Interest Amount","Additional Fee","Remaining Amount","Add. Fee per Line");
              IF ("Interest Amount" = 0) AND ("Additional Fee" = 0) AND ("Add. Fee per Line" = 0) AND ("Remaining Amount" = 0) THEN
                ERROR(Text000);
              SourceCodeSetup.GET;
              SourceCodeSetup.TESTFIELD(Reminder);
              SrcCode := SourceCodeSetup.Reminder;

              IF ("Issuing No." = '') AND ("No. Series" <> "Issuing No. Series") THEN BEGIN
                TESTFIELD("Issuing No. Series");
                "Issuing No." := NoSeriesMgt.GetNextNo("Issuing No. Series","Posting Date",TRUE);
                MODIFY;
                COMMIT;
              END;
              IF "Issuing No." <> '' THEN
                DocNo := "Issuing No."
              ELSE
                DocNo := "No.";

              ReminderLine.SETRANGE("Reminder No.","No.");
              IF ReminderLine.FIND('-') THEN
                REPEAT
                  CASE ReminderLine.Type OF
                    ReminderLine.Type::" ":
                      ReminderLine.TESTFIELD(Amount,0);
                    ReminderLine.Type::"G/L Account":
                      IF "Post Additional Fee" THEN
                        InsertGenJnlLineForFee(ReminderLine);
                    ReminderLine.Type::"Customer Ledger Entry":
                      BEGIN
                        ReminderLine.TESTFIELD("Entry No.");
                        ReminderInterestAmount := ReminderInterestAmount + ReminderLine.Amount;
                        ReminderInterestVATAmount := ReminderInterestVATAmount + ReminderLine."VAT Amount";
                      END;
                    ReminderLine.Type::"Line Fee":
                      IF "Post Add. Fee per Line" THEN BEGIN
                        CheckLineFee(ReminderLine,ReminderHeader);
                        InsertGenJnlLineForFee(ReminderLine);
                      END;
                  END;
                UNTIL ReminderLine.NEXT = 0;

              IF (ReminderInterestAmount <> 0) AND "Post Interest" THEN BEGIN
                IF ReminderInterestAmount < 0 THEN
                  ERROR(Text001);
                InitGenJnlLine(GenJnlLine."Account Type"::"G/L Account",CustPostingGr.GetInterestAccount,TRUE);
                GenJnlLine.VALIDATE("VAT Bus. Posting Group","VAT Bus. Posting Group");
                GenJnlLine.VALIDATE(Amount,-ReminderInterestAmount - ReminderInterestVATAmount);
                GenJnlLine.UpdateLineBalance;
                TotalAmount := TotalAmount - GenJnlLine.Amount;
                TotalAmountLCY := TotalAmountLCY - GenJnlLine."Balance (LCY)";
                GenJnlLine."Bill-to/Pay-to No." := "Customer No.";
                GenJnlLine.INSERT;
              END;

              IF (TotalAmount <> 0) OR (TotalAmountLCY <> 0) THEN BEGIN
                InitGenJnlLine(GenJnlLine."Account Type"::Customer,"Customer No.",TRUE);
                GenJnlLine.VALIDATE(Amount,TotalAmount);
                GenJnlLine.VALIDATE("Amount (LCY)",TotalAmountLCY);
                GenJnlLine.INSERT;
              END;

              CLEAR(GenJnlPostLine);
              IF GenJnlLine.FIND('-') THEN
                REPEAT
                  GenJnlLine2 := GenJnlLine;
                  GenJnlLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                  GenJnlLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                  GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                  GenJnlPostLine.RUN(GenJnlLine2);
                UNTIL GenJnlLine.NEXT = 0;

              GenJnlLine.DELETEALL;

              IF (ReminderInterestAmount <> 0) AND "Post Interest" THEN BEGIN
                TESTFIELD("Fin. Charge Terms Code");
                FinChrgTerms.GET("Fin. Charge Terms Code");
                IF FinChrgTerms."Interest Calculation" IN
                   [FinChrgTerms."Interest Calculation"::"Closed Entries",
                    FinChrgTerms."Interest Calculation"::"All Entries"]
                THEN BEGIN
                  ReminderLine.SETRANGE(Type,ReminderLine.Type::"Customer Ledger Entry");
                  IF ReminderLine.FIND('-') THEN
                    REPEAT
                      CustLedgEntry.GET(ReminderLine."Entry No.");
                      CustLedgEntry.TESTFIELD("Currency Code","Currency Code");
                      CustLedgEntry.CALCFIELDS("Remaining Amount");
                      IF CustLedgEntry."Remaining Amount" = 0 THEN BEGIN
                        CustLedgEntry."Calculate Interest" := FALSE;
                        CustLedgEntry.MODIFY;
                      END;
                      CustLedgEntry2.SETCURRENTKEY("Closed by Entry No.");
                      CustLedgEntry2.SETRANGE("Closed by Entry No.",CustLedgEntry."Entry No.");
                      CustLedgEntry2.SETRANGE("Closing Interest Calculated",FALSE);
                      CustLedgEntry2.MODIFYALL("Closing Interest Calculated",TRUE);
                    UNTIL ReminderLine.NEXT = 0;
                  ReminderLine.SETRANGE(Type);
                END;
              END;

              InsertIssuedReminderHeader(ReminderHeader,IssuedReminderHeader);

              IF NextEntryNo = 0 THEN BEGIN
                ReminderFinChargeEntry.LOCKTABLE;
                IF ReminderFinChargeEntry.FINDLAST THEN
                  NextEntryNo := ReminderFinChargeEntry."Entry No." + 1
                ELSE
                  NextEntryNo := 1;
              END;

              ReminderCommentLine.CopyComments(
                ReminderCommentLine.Type::Reminder,ReminderCommentLine.Type::"Issued Reminder","No.",IssuedReminderHeader."No.");

              IF ReminderLine.FINDSET THEN
                REPEAT
                  IF (ReminderLine.Type = ReminderLine.Type::"Customer Ledger Entry") AND
                     (ReminderLine."Entry No." <> 0)
                  THEN BEGIN
                    InsertReminderEntry(ReminderHeader,ReminderLine);
                    NextEntryNo := NextEntryNo + 1;
                  END;
                  InsertIssuedReminderLine(ReminderLine,IssuedReminderHeader."No.");
                UNTIL ReminderLine.NEXT = 0;
              ReminderLine.DELETEALL;
              DELETE;
            END;

            OnAfterIssueReminder(ReminderHeader,IssuedReminderHeader."No.");
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Der er ikke noget at udstede.;ENU=There is nothing to issue.';
      Text001@1001 : TextConst 'DAN=Renter skal v�re positivtal eller 0;ENU=Interests must be positive or 0';
      DimensionCombinationIsBlockedErr@1002 : TextConst '@@@="%1: TABLECAPTION(Reminder Header); %2: Field(No.); %3: Text GetDimCombErr";DAN=Kombinationen af dimensioner, der bliver brugt i %1 %2, er sp�rret. %3.;ENU=The combination of dimensions used in %1 %2 is blocked. %3.';
      Text003@1003 : TextConst 'DAN=En dimension, der bliver brugt i %1 %2, har for�rsaget en fejl. %3;ENU=A dimension used in %1 %2 has caused an error. %3';
      SourceCodeSetup@1004 : Record 242;
      FinChrgTerms@1006 : Record 5;
      ReminderHeader@1007 : Record 295;
      IssuedReminderHeader@1009 : Record 297;
      IssuedReminderLine@1010 : Record 298;
      GenJnlLine@1016 : TEMPORARY Record 81;
      GenJnlLine2@1017 : Record 81;
      SourceCode@1018 : Record 230;
      DimMgt@1022 : Codeunit 408;
      NoSeriesMgt@1023 : Codeunit 396;
      GenJnlPostLine@1024 : Codeunit 12;
      DocNo@1025 : Code[20];
      NextEntryNo@1026 : Integer;
      ReplacePostingDate@1027 : Boolean;
      PostingDate@1028 : Date;
      SrcCode@1029 : Code[10];
      ReminderInterestAmount@1030 : Decimal;
      ReminderInterestVATAmount@1031 : Decimal;
      TotalAmount@1032 : Decimal;
      TotalAmountLCY@1033 : Decimal;
      TableID@1034 : ARRAY [10] OF Integer;
      No@1035 : ARRAY [10] OF Code[20];
      Text004@1036 : TextConst '@@@="%1 = Field name, %2 = field value, %3 = table caption, %4 customer number";DAN=%1 m� ikke v�re %2 i %3 %4.;ENU=%1 must not be %2 in %3 %4.';
      LineFeeAmountErr@1019 : TextConst '@@@="%1 = Document Type, %2 = Document No.. E.g. Line Fee amount must be positive and non-zero for Line Fee applied to Invoice 102421";DAN=Linjegebyrbel�bet skal v�re positivt og m� ikke v�re nul i linjegebyret, der anvendes p� %1 %2.;ENU=Line Fee amount must be positive and non-zero for Line Fee applied to %1 %2.';
      AppliesToDocErr@1020 : TextConst 'DAN=Linjegebyr skal anvendes p� et �bent, forfaldent dokument.;ENU=Line Fee has to be applied to an open overdue document.';
      EntryNotOverdueErr@1037 : TextConst '@@@="%1 = Document Type, %2 = Document No., %3 = Table name. E.g. Invoice 12313 in Cust. Ledger Entry is not overdue.";DAN=%1 %2 i %3 er ikke forfalden.;ENU=%1 %2 in %3 is not overdue.';
      LineFeeAlreadyIssuedErr@1038 : TextConst '@@@="%1 = Document Type, %2 = Document No. %3 = Reminder Level. E.g. The Line Fee for Invoice 141232 on reminder level 2 has already been issued.";DAN=Linjegebyret for %1 %2 p� rykkerniveau %3 er allerede udstedt.;ENU=The Line Fee for %1 %2 on reminder level %3 has already been issued.';
      MultipleLineFeesSameDocErr@1040 : TextConst '@@@="%1 = Document Type, %2 = Document No. E.g. You cannot issue multiple line fees for the same level for the same document. Error with line fees for Invoice 1312312.";DAN=Du kan ikke udstede flere linjegebyrer p� samme niveau i det samme dokument. Der er en fejl i linjegebyrerne for %1 %2.;ENU=You cannot issue multiple line fees for the same level for the same document. Error with line fees for %1 %2.';

    [External]
    PROCEDURE Set@2(VAR NewReminderHeader@1000 : Record 295;NewReplacePostingDate@1001 : Boolean;NewPostingDate@1002 : Date);
    BEGIN
      ReminderHeader := NewReminderHeader;
      ReplacePostingDate := NewReplacePostingDate;
      PostingDate := NewPostingDate;
    END;

    [External]
    PROCEDURE GetIssuedReminder@3(VAR NewIssuedReminderHeader@1000 : Record 297);
    BEGIN
      NewIssuedReminderHeader := IssuedReminderHeader;
    END;

    LOCAL PROCEDURE InitGenJnlLine@4(AccType@1000 : Integer;AccNo@1001 : Code[20];SystemCreatedEntry@1002 : Boolean);
    BEGIN
      WITH ReminderHeader DO BEGIN
        GenJnlLine.INIT;
        GenJnlLine."Line No." := GenJnlLine."Line No." + 1;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Reminder;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Posting Date" := "Posting Date";
        GenJnlLine."Document Date" := "Document Date";
        GenJnlLine."Account Type" := AccType;
        GenJnlLine."Account No." := AccNo;
        GenJnlLine.VALIDATE("Account No.");
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account" THEN BEGIN
          GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Sale;
          GenJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
          GenJnlLine."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
        END;
        GenJnlLine.VALIDATE("Currency Code","Currency Code");
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN BEGIN
          GenJnlLine.VALIDATE(Amount,TotalAmount);
          GenJnlLine.VALIDATE("Amount (LCY)",TotalAmountLCY);
          GenJnlLine."Due Date" := "Due Date";
        END;
        GenJnlLine.Description := "Posting Description";
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source No." := "Customer No.";
        GenJnlLine."Source Code" := SrcCode;
        GenJnlLine."Reason Code" := "Reason Code";
        GenJnlLine."System-Created Entry" := SystemCreatedEntry;
        GenJnlLine."Posting No. Series" := "Issuing No. Series";
        GenJnlLine."Salespers./Purch. Code" := '';
        GenJnlLine."Country/Region Code" := "Country/Region Code";
      END;
    END;

    [External]
    PROCEDURE DeleteIssuedReminderLines@1(IssuedReminderHeader@1000 : Record 297);
    VAR
      IssuedReminderLine@1001 : Record 298;
    BEGIN
      IssuedReminderLine.SETRANGE("Reminder No.",IssuedReminderHeader."No.");
      IssuedReminderLine.DELETEALL;
    END;

    [External]
    PROCEDURE IncrNoPrinted@5(VAR IssuedReminderHeader@1000 : Record 297);
    BEGIN
      WITH IssuedReminderHeader DO BEGIN
        FIND;
        "No. Printed" := "No. Printed" + 1;
        MODIFY;
        COMMIT;
      END;
    END;

    [External]
    PROCEDURE TestDeleteHeader@19(ReminderHeader@1000 : Record 295;VAR IssuedReminderHeader@1001 : Record 297);
    BEGIN
      WITH ReminderHeader DO BEGIN
        CLEAR(IssuedReminderHeader);
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD("Deleted Document");
        SourceCode.GET(SourceCodeSetup."Deleted Document");

        IF ("Issuing No. Series" <> '') AND
           (("Issuing No." <> '') OR ("No. Series" = "Issuing No. Series"))
        THEN BEGIN
          IssuedReminderHeader.TRANSFERFIELDS(ReminderHeader);
          IF "Issuing No." <> '' THEN
            IssuedReminderHeader."No." := "Issuing No.";
          IssuedReminderHeader."Pre-Assigned No. Series" := "No. Series";
          IssuedReminderHeader."Pre-Assigned No." := "No.";
          IssuedReminderHeader."Posting Date" := TODAY;
          IssuedReminderHeader."User ID" := USERID;
          IssuedReminderHeader."Source Code" := SourceCode.Code;
        END;
      END;
    END;

    [External]
    PROCEDURE DeleteHeader@18(ReminderHeader@1000 : Record 295;VAR IssuedReminderHeader@1001 : Record 297);
    BEGIN
      WITH ReminderHeader DO BEGIN
        TestDeleteHeader(ReminderHeader,IssuedReminderHeader);
        IF IssuedReminderHeader."No." <> '' THEN BEGIN
          IssuedReminderHeader."Shortcut Dimension 1 Code" := '';
          IssuedReminderHeader."Shortcut Dimension 2 Code" := '';
          IssuedReminderHeader.INSERT;
          IssuedReminderLine.INIT;
          IssuedReminderLine."Reminder No." := "No.";
          IssuedReminderLine."Line No." := 10000;
          IssuedReminderLine.Description := SourceCode.Description;
          IssuedReminderLine.INSERT;
        END;
      END;
    END;

    [External]
    PROCEDURE ChangeDueDate@20(VAR ReminderEntry2@1102601000 : Record 300;NewDueDate@1102601001 : Date;OldDueDate@1102601002 : Date);
    BEGIN
      ReminderEntry2."Due Date" := ReminderEntry2."Due Date" + (NewDueDate - OldDueDate);
      ReminderEntry2.MODIFY;
    END;

    LOCAL PROCEDURE InsertIssuedReminderHeader@10(ReminderHeader@1001 : Record 295;VAR IssuedReminderHeader@1000 : Record 297);
    BEGIN
      IssuedReminderHeader.INIT;
      IssuedReminderHeader.TRANSFERFIELDS(ReminderHeader);
      IssuedReminderHeader."No." := DocNo;
      IssuedReminderHeader."Pre-Assigned No." := ReminderHeader."No.";
      IssuedReminderHeader."Source Code" := SrcCode;
      IssuedReminderHeader."User ID" := USERID;
      IssuedReminderHeader.INSERT;
    END;

    LOCAL PROCEDURE InsertIssuedReminderLine@15(ReminderLine@1000 : Record 296;IssuedReminderNo@1001 : Code[20]);
    VAR
      IssuedReminderLine@1002 : Record 298;
    BEGIN
      IssuedReminderLine.INIT;
      IssuedReminderLine.TRANSFERFIELDS(ReminderLine);
      IssuedReminderLine."Reminder No." := IssuedReminderNo;
      IssuedReminderLine.INSERT;
    END;

    LOCAL PROCEDURE InsertGenJnlLineForFee@1000(VAR ReminderLine@1000 : Record 296);
    BEGIN
      WITH ReminderHeader DO
        IF ReminderLine.Amount <> 0 THEN BEGIN
          ReminderLine.TESTFIELD("No.");
          InitGenJnlLine(GenJnlLine."Account Type"::"G/L Account",
            ReminderLine."No.",
            ReminderLine."Line Type" = ReminderLine."Line Type"::Rounding);
          GenJnlLine."Gen. Prod. Posting Group" := ReminderLine."Gen. Prod. Posting Group";
          GenJnlLine."VAT Prod. Posting Group" := ReminderLine."VAT Prod. Posting Group";
          GenJnlLine."VAT Calculation Type" := ReminderLine."VAT Calculation Type";
          IF ReminderLine."VAT Calculation Type" =
             ReminderLine."VAT Calculation Type"::"Sales Tax"
          THEN BEGIN
            GenJnlLine."Tax Area Code" := "Tax Area Code";
            GenJnlLine."Tax Liable" := "Tax Liable";
            GenJnlLine."Tax Group Code" := ReminderLine."Tax Group Code";
          END;
          GenJnlLine."VAT %" := ReminderLine."VAT %";
          GenJnlLine.VALIDATE(Amount,-ReminderLine.Amount - ReminderLine."VAT Amount");
          GenJnlLine."VAT Amount" := -ReminderLine."VAT Amount";
          GenJnlLine.UpdateLineBalance;
          TotalAmount := TotalAmount - GenJnlLine.Amount;
          TotalAmountLCY := TotalAmountLCY - GenJnlLine."Balance (LCY)";
          GenJnlLine."Bill-to/Pay-to No." := "Customer No.";
          GenJnlLine.INSERT;
        END;
    END;

    LOCAL PROCEDURE InsertReminderEntry@13(ReminderHeader@1000 : Record 295;ReminderLine@1002 : Record 296);
    VAR
      ReminderFinChargeEntry@1001 : Record 300;
    BEGIN
      WITH ReminderFinChargeEntry DO BEGIN
        INIT;
        "Entry No." := NextEntryNo;
        Type := Type::Reminder;
        "No." := IssuedReminderHeader."No.";
        "Posting Date" := ReminderHeader."Posting Date";
        "Document Date" := ReminderHeader."Document Date";
        "Due Date" := IssuedReminderHeader."Due Date";
        "Customer No." := ReminderHeader."Customer No.";
        "Customer Entry No." := ReminderLine."Entry No.";
        "Document Type" := ReminderLine."Document Type";
        "Document No." := ReminderLine."Document No.";
        "Reminder Level" := ReminderLine."No. of Reminders";
        "Remaining Amount" := ReminderLine."Remaining Amount";
        "Interest Amount" := ReminderLine.Amount;
        "Interest Posted" :=
          (ReminderInterestAmount <> 0) AND ReminderHeader."Post Interest";
        "User ID" := USERID;
        INSERT;
      END;
      IF ReminderLine."Line Type" <> ReminderLine."Line Type"::"Not Due" THEN
        UpdateCustLedgEntryLastIssuedReminderLevel(ReminderFinChargeEntry);
    END;

    LOCAL PROCEDURE CheckLineFee@6(VAR ReminderLine@1000 : Record 296;VAR ReminderHeader@1001 : Record 295);
    VAR
      CustLedgEntry3@1003 : Record 21;
      ReminderLine2@1002 : Record 296;
    BEGIN
      IF ReminderLine.Amount <= 0 THEN
        ERROR(LineFeeAmountErr,ReminderLine."Applies-to Document Type",ReminderLine."Applies-to Document No.");
      IF ReminderLine."Applies-to Document No." = '' THEN
        ERROR(AppliesToDocErr);

      WITH CustLedgEntry3 DO BEGIN
        SETRANGE("Document Type",ReminderLine."Applies-to Document Type");
        SETRANGE("Document No.",ReminderLine."Applies-to Document No.");
        SETRANGE("Customer No.",ReminderHeader."Customer No.");
        FINDFIRST;
        IF "Due Date" >= ReminderHeader."Document Date" THEN
          ERROR(
            EntryNotOverdueErr,FIELDCAPTION("Document No."),ReminderLine."Applies-to Document No.",TABLENAME);
      END;

      WITH IssuedReminderLine DO BEGIN
        RESET;
        SETRANGE("Applies-To Document Type",ReminderLine."Applies-to Document Type");
        SETRANGE("Applies-To Document No.",ReminderLine."Applies-to Document No.");
        SETRANGE(Type,Type::"Line Fee");
        SETRANGE("No. of Reminders",ReminderLine."No. of Reminders");
        IF FINDFIRST THEN
          ERROR(
            LineFeeAlreadyIssuedErr,ReminderLine."Applies-to Document Type",ReminderLine."Applies-to Document No.",
            ReminderLine."No. of Reminders");
      END;

      WITH ReminderLine2 DO BEGIN
        RESET;
        SETRANGE("Applies-to Document Type",ReminderLine."Applies-to Document Type");
        SETRANGE("Applies-to Document No.",ReminderLine."Applies-to Document No.");
        SETRANGE(Type,IssuedReminderLine.Type::"Line Fee");
        SETRANGE("No. of Reminders",ReminderLine."No. of Reminders");
        IF COUNT > 1 THEN
          ERROR(MultipleLineFeesSameDocErr,ReminderLine."Applies-to Document Type",ReminderLine."Applies-to Document No.");
      END;
    END;

    [External]
    PROCEDURE UpdateCustLedgEntryLastIssuedReminderLevel@7(ReminderFinChargeEntry@1000 : Record 300);
    VAR
      CustLedgEntry@1001 : Record 21;
    BEGIN
      CustLedgEntry.LOCKTABLE;
      CustLedgEntry.GET(ReminderFinChargeEntry."Customer Entry No.");
      CustLedgEntry."Last Issued Reminder Level" := ReminderFinChargeEntry."Reminder Level";
      CustLedgEntry.MODIFY;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterIssueReminder@9(VAR ReminderHeader@1000 : Record 295;IssuedReminderNo@1001 : Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeIssueReminder@8(VAR ReminderHeader@1000 : Record 295);
    BEGIN
    END;

    LOCAL PROCEDURE CheckIfBlocked@50(CustomerNo@1000 : Code[20]);
    VAR
      Customer@1001 : Record 18;
    BEGIN
      Customer.GET(CustomerNo);

      IF Customer."Privacy Blocked" THEN
        ERROR(Text004,Customer.FIELDCAPTION("Privacy Blocked"),Customer."Privacy Blocked",Customer.TABLECAPTION,CustomerNo);

      IF Customer.Blocked = Customer.Blocked::All THEN
        ERROR(Text004,Customer.FIELDCAPTION(Blocked),Customer.Blocked,Customer.TABLECAPTION,CustomerNo);
    END;

    BEGIN
    END.
  }
}

