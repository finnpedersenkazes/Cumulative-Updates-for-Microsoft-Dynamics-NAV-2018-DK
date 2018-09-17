OBJECT Codeunit 226 CustEntry-Apply Posted Entries
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=21;
    Permissions=TableData 21=rimd;
    EventSubscriberInstance=Manual;
    OnRun=BEGIN
            IF PreviewMode THEN
              CASE RunOptionPreviewContext OF
                RunOptionPreview::Apply:
                  Apply(Rec,DocumentNoPreviewContext,ApplicationDatePreviewContext);
                RunOptionPreview::Unapply:
                  PostUnApplyCustomer(DetailedCustLedgEntryPreviewContext,DocumentNoPreviewContext,ApplicationDatePreviewContext);
              END
            ELSE
              Apply(Rec,"Document No.",0D);
          END;

  }
  CODE
  {
    VAR
      PostingApplicationMsg@1000 : TextConst 'DAN=Udligningen bogf�res...;ENU=Posting application...';
      MustNotBeBeforeErr@1001 : TextConst 'DAN=Den angivne bogf�ringsdato m� ikke ligge f�r bogf�ringsdatoen i debitorposten.;ENU=The Posting Date entered must not be before the Posting Date on the Cust. Ledger Entry.';
      NoEntriesAppliedErr@1003 : TextConst '@@@=%1 - Caption of "Applies to ID" field of Gen. Journal Line;DAN=Der kan ikke bogf�res, fordi du ikke har angivet, hvilken post der skal udlignes. Du skal angive en post i feltet %1 for en eller flere �bne poster.;ENU=Cannot post because you did not specify which entry to apply. You must specify an entry in the %1 field for one or more open entries.';
      UnapplyPostedAfterThisEntryErr@1018 : TextConst 'DAN=F�r du kan annullere udligningen af denne post, skal du f�rst annullere udligningen af alle udligningsposter, der er bogf�rt efter denne post.;ENU=Before you can unapply this entry, you must first unapply all application entries that were posted after this entry.';
      NoApplicationEntryErr@1017 : TextConst 'DAN=Debitorpostl�benr. %1 har ikke en udligningspost.;ENU=Cust. Ledger Entry No. %1 does not have an application entry.';
      UnapplyingMsg@1015 : TextConst 'DAN=Annullerer udligning og bogf�rer...;ENU=Unapplying and posting...';
      UnapplyAllPostedAfterThisEntryErr@1019 : TextConst 'DAN=F�r du kan annullere udligningen af denne post, skal du f�rst annullere udligningen af alle udligningsposter i debitorpostl�benr. %1, der er bogf�rt efter denne post.;ENU=Before you can unapply this entry, you must first unapply all application entries in Cust. Ledger Entry No. %1 that were posted after this entry.';
      NotAllowedPostingDatesErr@1021 : TextConst 'DAN=Bogf�ringsdatoen er ikke inden for intervallet af tilladte bogf�ringsdatoer.;ENU=Posting date is not within the range of allowed posting dates.';
      LatestEntryMustBeAnApplicationErr@1024 : TextConst 'DAN=Det seneste transaktionsnr. skal v�re en udligning i debitorpostl�benr. %1.;ENU=The latest Transaction No. must be an application in Cust. Ledger Entry No. %1.';
      CannotUnapplyExchRateErr@1023 : TextConst 'DAN=Du kan ikke annullere udligningen af posten med bogf�ringsdato %1, fordi valutakursen for den ekstra rapporteringsvaluta er �ndret.;ENU=You cannot unapply the entry with the posting date %1, because the exchange rate for the additional reporting currency has been changed.';
      CannotUnapplyInReversalErr@1026 : TextConst 'DAN=Du kan ikke annullere udligning af debitorpostl�benr. %1, fordi posten indg�r i en tilbagef�rsel.;ENU=You cannot unapply Cust. Ledger Entry No. %1 because the entry is part of a reversal.';
      CannotApplyClosedEntriesErr@1102601000 : TextConst 'DAN=En eller flere af de valgte poster er lukket. Du kan ikke bruge en lukket post.;ENU=One or more of the entries that you selected is closed. You cannot apply closed entries.';
      DetailedCustLedgEntryPreviewContext@1008 : Record 379;
      ApplicationDatePreviewContext@1004 : Date;
      DocumentNoPreviewContext@1005 : Code[20];
      RunOptionPreview@1007 : 'Apply,Unapply';
      RunOptionPreviewContext@1009 : 'Apply,Unapply';
      PreviewMode@1002 : Boolean;

    [External]
    PROCEDURE Apply@17(CustLedgEntry@1000 : Record 21;DocumentNo@1001 : Code[20];ApplicationDate@1002 : Date) : Boolean;
    VAR
      PaymentToleranceMgt@1003 : Codeunit 426;
    BEGIN
      WITH CustLedgEntry DO BEGIN
        IF NOT PreviewMode THEN
          IF NOT PaymentToleranceMgt.PmtTolCust(CustLedgEntry) THEN
            EXIT(FALSE);
        GET("Entry No.");

        IF ApplicationDate = 0D THEN
          ApplicationDate := GetApplicationDate(CustLedgEntry)
        ELSE
          IF ApplicationDate < GetApplicationDate(CustLedgEntry) THEN
            ERROR(MustNotBeBeforeErr);

        IF DocumentNo = '' THEN
          DocumentNo := "Document No.";

        CustPostApplyCustLedgEntry(CustLedgEntry,DocumentNo,ApplicationDate);
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE GetApplicationDate@14(CustLedgEntry@1000 : Record 21) ApplicationDate : Date;
    VAR
      ApplyToCustLedgEntry@1001 : Record 21;
    BEGIN
      WITH CustLedgEntry DO BEGIN
        ApplicationDate := 0D;
        ApplyToCustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID");
        ApplyToCustLedgEntry.SETRANGE("Customer No.","Customer No.");
        ApplyToCustLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
        ApplyToCustLedgEntry.FINDSET;
        REPEAT
          IF ApplyToCustLedgEntry."Posting Date" > ApplicationDate THEN
            ApplicationDate := ApplyToCustLedgEntry."Posting Date";
        UNTIL ApplyToCustLedgEntry.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CustPostApplyCustLedgEntry@12(CustLedgEntry@1000 : Record 21;DocumentNo@1002 : Code[20];ApplicationDate@1003 : Date);
    VAR
      SourceCodeSetup@1004 : Record 242;
      GenJnlLine@1005 : Record 81;
      UpdateAnalysisView@1001 : Codeunit 410;
      GenJnlPostLine@1006 : Codeunit 12;
      GenJnlPostPreview@1011 : Codeunit 19;
      Window@1007 : Dialog;
      EntryNoBeforeApplication@1008 : Integer;
      EntryNoAfterApplication@1009 : Integer;
    BEGIN
      WITH CustLedgEntry DO BEGIN
        Window.OPEN(PostingApplicationMsg);

        SourceCodeSetup.GET;

        GenJnlLine.INIT;
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine."Posting Date" := ApplicationDate;
        GenJnlLine."Document Date" := GenJnlLine."Posting Date";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := "Customer No.";
        CALCFIELDS("Debit Amount","Credit Amount","Debit Amount (LCY)","Credit Amount (LCY)");
        GenJnlLine.Correction :=
          ("Debit Amount" < 0) OR ("Credit Amount" < 0) OR
          ("Debit Amount (LCY)" < 0) OR ("Credit Amount (LCY)" < 0);
        GenJnlLine.CopyCustLedgEntry(CustLedgEntry);
        GenJnlLine."Source Code" := SourceCodeSetup."Sales Entry Application";
        GenJnlLine."System-Created Entry" := TRUE;

        EntryNoBeforeApplication := FindLastApplDtldCustLedgEntry;

        OnBeforePostApplyCustLedgEntry(GenJnlLine,CustLedgEntry);
        GenJnlPostLine.CustPostApplyCustLedgEntry(GenJnlLine,CustLedgEntry);
        OnAfterPostApplyCustLedgEntry(GenJnlLine,CustLedgEntry);

        EntryNoAfterApplication := FindLastApplDtldCustLedgEntry;
        IF EntryNoAfterApplication = EntryNoBeforeApplication THEN
          ERROR(STRSUBSTNO(NoEntriesAppliedErr,GenJnlLine.FIELDCAPTION("Applies-to ID")));

        IF PreviewMode THEN
          GenJnlPostPreview.ThrowError;

        COMMIT;
        Window.CLOSE;
        UpdateAnalysisView.UpdateAll(0,TRUE);
      END;
    END;

    LOCAL PROCEDURE FindLastApplDtldCustLedgEntry@1() : Integer;
    VAR
      DtldCustLedgEntry@1000 : Record 379;
    BEGIN
      DtldCustLedgEntry.LOCKTABLE;
      IF DtldCustLedgEntry.FINDLAST THEN
        EXIT(DtldCustLedgEntry."Entry No.");

      EXIT(0);
    END;

    LOCAL PROCEDURE FindLastApplEntry@2(CustLedgEntryNo@1002 : Integer) : Integer;
    VAR
      DtldCustLedgEntry@1001 : Record 379;
      ApplicationEntryNo@1000 : Integer;
    BEGIN
      WITH DtldCustLedgEntry DO BEGIN
        SETCURRENTKEY("Cust. Ledger Entry No.","Entry Type");
        SETRANGE("Cust. Ledger Entry No.",CustLedgEntryNo);
        SETRANGE("Entry Type","Entry Type"::Application);
        SETRANGE(Unapplied,FALSE);
        ApplicationEntryNo := 0;
        IF FIND('-') THEN
          REPEAT
            IF "Entry No." > ApplicationEntryNo THEN
              ApplicationEntryNo := "Entry No.";
          UNTIL NEXT = 0;
      END;
      EXIT(ApplicationEntryNo);
    END;

    LOCAL PROCEDURE FindLastTransactionNo@6(CustLedgEntryNo@1002 : Integer) : Integer;
    VAR
      DtldCustLedgEntry@1001 : Record 379;
      LastTransactionNo@1000 : Integer;
    BEGIN
      WITH DtldCustLedgEntry DO BEGIN
        SETCURRENTKEY("Cust. Ledger Entry No.","Entry Type");
        SETRANGE("Cust. Ledger Entry No.",CustLedgEntryNo);
        SETRANGE(Unapplied,FALSE);
        SETFILTER("Entry Type",'<>%1&<>%2',"Entry Type"::"Unrealized Loss","Entry Type"::"Unrealized Gain");
        LastTransactionNo := 0;
        IF FINDSET THEN
          REPEAT
            IF LastTransactionNo < "Transaction No." THEN
              LastTransactionNo := "Transaction No.";
          UNTIL NEXT = 0;
      END;
      EXIT(LastTransactionNo);
    END;

    [External]
    PROCEDURE UnApplyDtldCustLedgEntry@3(DtldCustLedgEntry@1000 : Record 379);
    VAR
      ApplicationEntryNo@1001 : Integer;
    BEGIN
      DtldCustLedgEntry.TESTFIELD("Entry Type",DtldCustLedgEntry."Entry Type"::Application);
      DtldCustLedgEntry.TESTFIELD(Unapplied,FALSE);
      ApplicationEntryNo := FindLastApplEntry(DtldCustLedgEntry."Cust. Ledger Entry No.");

      IF DtldCustLedgEntry."Entry No." <> ApplicationEntryNo THEN
        ERROR(UnapplyPostedAfterThisEntryErr);
      CheckReversal(DtldCustLedgEntry."Cust. Ledger Entry No.");
      UnApplyCustomer(DtldCustLedgEntry);
    END;

    [External]
    PROCEDURE UnApplyCustLedgEntry@7(CustLedgEntryNo@1000 : Integer);
    VAR
      DtldCustLedgEntry@1002 : Record 379;
      ApplicationEntryNo@1001 : Integer;
    BEGIN
      CheckReversal(CustLedgEntryNo);
      ApplicationEntryNo := FindLastApplEntry(CustLedgEntryNo);
      IF ApplicationEntryNo = 0 THEN
        ERROR(NoApplicationEntryErr,CustLedgEntryNo);
      DtldCustLedgEntry.GET(ApplicationEntryNo);
      UnApplyCustomer(DtldCustLedgEntry);
    END;

    LOCAL PROCEDURE UnApplyCustomer@19(DtldCustLedgEntry@1000000000 : Record 379);
    VAR
      UnapplyCustEntries@1000 : Page 623;
    BEGIN
      WITH DtldCustLedgEntry DO BEGIN
        TESTFIELD("Entry Type","Entry Type"::Application);
        TESTFIELD(Unapplied,FALSE);
        UnapplyCustEntries.SetDtldCustLedgEntry("Entry No.");
        UnapplyCustEntries.LOOKUPMODE(TRUE);
        UnapplyCustEntries.RUNMODAL;
      END;
    END;

    [External]
    PROCEDURE PostUnApplyCustomer@4(DtldCustLedgEntry2@1007 : Record 379;DocNo@1000 : Code[20];PostingDate@1001 : Date);
    BEGIN
      PostUnApplyCustomerCommit(DtldCustLedgEntry2,DocNo,PostingDate,TRUE);
    END;

    [External]
    PROCEDURE PostUnApplyCustomerCommit@22(DtldCustLedgEntry2@1007 : Record 379;DocNo@1000 : Code[20];PostingDate@1001 : Date;CommitChanges@1020 : Boolean);
    VAR
      GLEntry@1019 : Record 17;
      CustLedgEntry@1018 : Record 21;
      SourceCodeSetup@1017 : Record 242;
      GenJnlLine@1016 : Record 81;
      DtldCustLedgEntry@1014 : Record 379;
      DateComprReg@1005 : Record 87;
      GenJnlPostLine@1002 : Codeunit 12;
      GenJnlPostPreview@1008 : Codeunit 19;
      Window@1012 : Dialog;
      LastTransactionNo@1003 : Integer;
      AddCurrChecked@1004 : Boolean;
      MaxPostingDate@1006 : Date;
    BEGIN
      MaxPostingDate := 0D;
      GLEntry.LOCKTABLE;
      DtldCustLedgEntry.LOCKTABLE;
      CustLedgEntry.LOCKTABLE;
      CustLedgEntry.GET(DtldCustLedgEntry2."Cust. Ledger Entry No.");
      CheckPostingDate(PostingDate,MaxPostingDate);
      IF PostingDate < DtldCustLedgEntry2."Posting Date" THEN
        ERROR(MustNotBeBeforeErr);
      IF DtldCustLedgEntry2."Transaction No." = 0 THEN BEGIN
        DtldCustLedgEntry.SETCURRENTKEY("Application No.","Customer No.","Entry Type");
        DtldCustLedgEntry.SETRANGE("Application No.",DtldCustLedgEntry2."Application No.");
      END ELSE BEGIN
        DtldCustLedgEntry.SETCURRENTKEY("Transaction No.","Customer No.","Entry Type");
        DtldCustLedgEntry.SETRANGE("Transaction No.",DtldCustLedgEntry2."Transaction No.");
      END;
      DtldCustLedgEntry.SETRANGE("Customer No.",DtldCustLedgEntry2."Customer No.");
      DtldCustLedgEntry.SETFILTER("Entry Type",'<>%1',DtldCustLedgEntry."Entry Type"::"Initial Entry");
      DtldCustLedgEntry.SETRANGE(Unapplied,FALSE);
      IF DtldCustLedgEntry.FIND('-') THEN
        REPEAT
          IF NOT AddCurrChecked THEN BEGIN
            CheckAdditionalCurrency(PostingDate,DtldCustLedgEntry."Posting Date");
            AddCurrChecked := TRUE;
          END;
          CheckReversal(DtldCustLedgEntry."Cust. Ledger Entry No.");
          IF DtldCustLedgEntry."Transaction No." <> 0 THEN BEGIN
            IF DtldCustLedgEntry."Entry Type" = DtldCustLedgEntry."Entry Type"::Application THEN BEGIN
              LastTransactionNo :=
                FindLastApplTransactionEntry(DtldCustLedgEntry."Cust. Ledger Entry No.");
              IF (LastTransactionNo <> 0) AND (LastTransactionNo <> DtldCustLedgEntry."Transaction No.") THEN
                ERROR(UnapplyAllPostedAfterThisEntryErr,DtldCustLedgEntry."Cust. Ledger Entry No.");
            END;
            LastTransactionNo := FindLastTransactionNo(DtldCustLedgEntry."Cust. Ledger Entry No.");
            IF (LastTransactionNo <> 0) AND (LastTransactionNo <> DtldCustLedgEntry."Transaction No.") THEN
              ERROR(LatestEntryMustBeAnApplicationErr,DtldCustLedgEntry."Cust. Ledger Entry No.");
          END;
        UNTIL DtldCustLedgEntry.NEXT = 0;

      DateComprReg.CheckMaxDateCompressed(MaxPostingDate,0);

      WITH DtldCustLedgEntry2 DO BEGIN
        SourceCodeSetup.GET;
        CustLedgEntry.GET("Cust. Ledger Entry No.");
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := "Customer No.";
        GenJnlLine.Correction := TRUE;
        GenJnlLine.CopyCustLedgEntry(CustLedgEntry);
        GenJnlLine."Source Code" := SourceCodeSetup."Unapplied Sales Entry Appln.";
        GenJnlLine."Source Currency Code" := "Currency Code";
        GenJnlLine."System-Created Entry" := TRUE;
        Window.OPEN(UnapplyingMsg);

        OnBeforePostUnapplyCustLedgEntry(GenJnlLine,CustLedgEntry,DtldCustLedgEntry2);
        GenJnlPostLine.UnapplyCustLedgEntry(GenJnlLine,DtldCustLedgEntry2);
        OnAfterPostUnapplyCustLedgEntry(GenJnlLine,CustLedgEntry,DtldCustLedgEntry2);

        IF PreviewMode THEN
          GenJnlPostPreview.ThrowError;

        IF CommitChanges THEN
          COMMIT;
        Window.CLOSE;
      END;
    END;

    LOCAL PROCEDURE CheckPostingDate@5(PostingDate@1001 : Date;VAR MaxPostingDate@1005 : Date);
    VAR
      GenJnlCheckLine@1000 : Codeunit 11;
    BEGIN
      IF GenJnlCheckLine.DateNotAllowed(PostingDate) THEN
        ERROR(NotAllowedPostingDatesErr);

      IF PostingDate > MaxPostingDate THEN
        MaxPostingDate := PostingDate;
    END;

    LOCAL PROCEDURE CheckAdditionalCurrency@8(OldPostingDate@1000 : Date;NewPostingDate@1001 : Date);
    VAR
      GLSetup@1002 : Record 98;
      CurrExchRate@1003 : Record 330;
    BEGIN
      IF OldPostingDate = NewPostingDate THEN
        EXIT;
      GLSetup.GET;
      IF GLSetup."Additional Reporting Currency" <> '' THEN
        IF CurrExchRate.ExchangeRate(OldPostingDate,GLSetup."Additional Reporting Currency") <>
           CurrExchRate.ExchangeRate(NewPostingDate,GLSetup."Additional Reporting Currency")
        THEN
          ERROR(CannotUnapplyExchRateErr,NewPostingDate);
    END;

    LOCAL PROCEDURE CheckReversal@9(CustLedgEntryNo@1000 : Integer);
    VAR
      CustLedgEntry@1001 : Record 21;
    BEGIN
      CustLedgEntry.GET(CustLedgEntryNo);
      IF CustLedgEntry.Reversed THEN
        ERROR(CannotUnapplyInReversalErr,CustLedgEntryNo);
    END;

    [External]
    PROCEDURE ApplyCustEntryFormEntry@10(VAR ApplyingCustLedgEntry@1000 : Record 21);
    VAR
      CustLedgEntry@1002 : Record 21;
      ApplyCustEntries@1001 : Page 232;
      CustEntryApplID@1004 : Code[50];
    BEGIN
      IF NOT ApplyingCustLedgEntry.Open THEN
        ERROR(CannotApplyClosedEntriesErr);

      CustEntryApplID := USERID;
      IF CustEntryApplID = '' THEN
        CustEntryApplID := '***';
      IF ApplyingCustLedgEntry."Remaining Amount" = 0 THEN
        ApplyingCustLedgEntry.CALCFIELDS("Remaining Amount");

      ApplyingCustLedgEntry."Applying Entry" := TRUE;
      ApplyingCustLedgEntry."Applies-to ID" := CustEntryApplID;
      ApplyingCustLedgEntry."Amount to Apply" := ApplyingCustLedgEntry."Remaining Amount";
      CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",ApplyingCustLedgEntry);
      COMMIT;

      CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
      CustLedgEntry.SETRANGE("Customer No.",ApplyingCustLedgEntry."Customer No.");
      CustLedgEntry.SETRANGE(Open,TRUE);
      IF CustLedgEntry.FINDFIRST THEN BEGIN
        ApplyCustEntries.SetCustLedgEntry(ApplyingCustLedgEntry);
        ApplyCustEntries.SETRECORD(CustLedgEntry);
        ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
        ApplyCustEntries.RUNMODAL;
        CLEAR(ApplyCustEntries);
        ApplyingCustLedgEntry."Applying Entry" := FALSE;
        ApplyingCustLedgEntry."Applies-to ID" := '';
        ApplyingCustLedgEntry."Amount to Apply" := 0;
      END;
    END;

    LOCAL PROCEDURE FindLastApplTransactionEntry@11(CustLedgEntryNo@1000 : Integer) : Integer;
    VAR
      DtldCustLedgEntry@1001 : Record 379;
      LastTransactionNo@1002 : Integer;
    BEGIN
      DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.","Entry Type");
      DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",CustLedgEntryNo);
      DtldCustLedgEntry.SETRANGE("Entry Type",DtldCustLedgEntry."Entry Type"::Application);
      LastTransactionNo := 0;
      IF DtldCustLedgEntry.FIND('-') THEN
        REPEAT
          IF (DtldCustLedgEntry."Transaction No." > LastTransactionNo) AND NOT DtldCustLedgEntry.Unapplied THEN
            LastTransactionNo := DtldCustLedgEntry."Transaction No.";
        UNTIL DtldCustLedgEntry.NEXT = 0;
      EXIT(LastTransactionNo);
    END;

    [External]
    PROCEDURE PreviewApply@13(CustLedgEntry@1003 : Record 21;DocumentNo@1002 : Code[20];ApplicationDate@1001 : Date);
    VAR
      GenJnlPostPreview@1004 : Codeunit 19;
      CustEntryApplyPostedEntries@1000 : Codeunit 226;
      PaymentToleranceMgt@1005 : Codeunit 426;
    BEGIN
      IF NOT PaymentToleranceMgt.PmtTolCust(CustLedgEntry) THEN
        EXIT;

      BINDSUBSCRIPTION(CustEntryApplyPostedEntries);
      CustEntryApplyPostedEntries.SetApplyContext(ApplicationDate,DocumentNo);
      GenJnlPostPreview.Preview(CustEntryApplyPostedEntries,CustLedgEntry);
    END;

    [External]
    PROCEDURE PreviewUnapply@15(DetailedCustLedgEntry@1002 : Record 379;DocumentNo@1001 : Code[20];ApplicationDate@1000 : Date);
    VAR
      CustLedgEntry@1005 : Record 21;
      GenJnlPostPreview@1003 : Codeunit 19;
      CustEntryApplyPostedEntries@1004 : Codeunit 226;
    BEGIN
      BINDSUBSCRIPTION(CustEntryApplyPostedEntries);
      CustEntryApplyPostedEntries.SetUnapplyContext(DetailedCustLedgEntry,ApplicationDate,DocumentNo);
      GenJnlPostPreview.Preview(CustEntryApplyPostedEntries,CustLedgEntry);
    END;

    [External]
    PROCEDURE SetApplyContext@16(ApplicationDate@1000 : Date;DocumentNo@1001 : Code[20]);
    BEGIN
      ApplicationDatePreviewContext := ApplicationDate;
      DocumentNoPreviewContext := DocumentNo;
      RunOptionPreviewContext := RunOptionPreview::Apply;
    END;

    [External]
    PROCEDURE SetUnapplyContext@28(VAR DetailedCustLedgEntry@1002 : Record 379;ApplicationDate@1000 : Date;DocumentNo@1001 : Code[20]);
    BEGIN
      ApplicationDatePreviewContext := ApplicationDate;
      DocumentNoPreviewContext := DocumentNo;
      DetailedCustLedgEntryPreviewContext := DetailedCustLedgEntry;
      RunOptionPreviewContext := RunOptionPreview::Unapply;
    END;

    [EventSubscriber(Codeunit,19,OnRunPreview)]
    LOCAL PROCEDURE OnPreviewRun@21(VAR Result@1000 : Boolean;Subscriber@1001 : Variant;RecVar@1003 : Variant);
    VAR
      CustEntryApplyPostedEntries@1002 : Codeunit 226;
    BEGIN
      CustEntryApplyPostedEntries := Subscriber;
      PreviewMode := TRUE;
      Result := CustEntryApplyPostedEntries.RUN(RecVar);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostApplyCustLedgEntry@23(GenJournalLine@1000 : Record 81;CustLedgerEntry@1001 : Record 21);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostUnapplyCustLedgEntry@24(GenJournalLine@1000 : Record 81;CustLedgerEntry@1001 : Record 21;DetailedCustLedgEntry@1002 : Record 379);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostApplyCustLedgEntry@18(VAR GenJournalLine@1000 : Record 81;CustLedgerEntry@1001 : Record 21);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostUnapplyCustLedgEntry@20(VAR GenJournalLine@1000 : Record 81;CustLedgerEntry@1001 : Record 21;DetailedCustLedgEntry@1002 : Record 379);
    BEGIN
    END;

    BEGIN
    END.
  }
}

