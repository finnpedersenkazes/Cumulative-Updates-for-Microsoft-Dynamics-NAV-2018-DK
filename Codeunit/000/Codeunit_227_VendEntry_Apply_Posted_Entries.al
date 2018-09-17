OBJECT Codeunit 227 VendEntry-Apply Posted Entries
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=25;
    Permissions=TableData 25=rimd;
    EventSubscriberInstance=Manual;
    OnRun=BEGIN
            IF PreviewMode THEN
              CASE RunOptionPreviewContext OF
                RunOptionPreview::Apply:
                  Apply(Rec,DocumentNoPreviewContext,ApplicationDatePreviewContext);
                RunOptionPreview::Unapply:
                  PostUnApplyVendor(DetailedVendorLedgEntryPreviewContext,DocumentNoPreviewContext,ApplicationDatePreviewContext);
              END
            ELSE
              Apply(Rec,"Document No.",0D);
          END;

  }
  CODE
  {
    VAR
      PostingApplicationMsg@1000 : TextConst 'DAN=Udligningen bogf�res...;ENU=Posting application...';
      MustNotBeBeforeErr@1002 : TextConst 'DAN=Den angivne bogf�ringsdato m� ikke ligge f�r bogf�ringsdatoen for kreditorposten.;ENU=The posting date entered must not be before the posting date on the vendor ledger entry.';
      NoEntriesAppliedErr@1003 : TextConst '@@@=%1 - Caption of "Applies to ID" field of Gen. Journal Line;DAN=Der kan ikke bogf�res, fordi du ikke har angivet, hvilken post der skal udlignes. Du skal angive en post i feltet %1 for en eller flere �bne poster.;ENU=Cannot post because you did not specify which entry to apply. You must specify an entry in the %1 field for one or more open entries.';
      UnapplyPostedAfterThisEntryErr@1018 : TextConst 'DAN=F�r du kan annullere udligningen af denne post, skal du f�rst annullere udligningen af alle udligningsposter, der er bogf�rt efter denne post.;ENU=Before you can unapply this entry, you must first unapply all application entries that were posted after this entry.';
      NoApplicationEntryErr@1017 : TextConst 'DAN=Kreditorl�benr. %1 har ikke en udligningspost.;ENU=Vendor Ledger Entry No. %1 does not have an application entry.';
      UnapplyingMsg@1015 : TextConst 'DAN=Annullerer udligning og bogf�rer...;ENU=Unapplying and posting...';
      UnapplyAllPostedAfterThisEntryErr@1021 : TextConst 'DAN=F�r du kan annullere udligningen af denne post, skal du f�rst annullere udligningen af alle udligningsposter i kreditorl�benr. %1, der er bogf�rt efter denne post.;ENU=Before you can unapply this entry, you must first unapply all application entries in Vendor Ledger Entry No. %1 that were posted after this entry.';
      NotAllowedPostingDatesErr@1019 : TextConst 'DAN=Bogf�ringsdatoen er ikke inden for intervallet af tilladte bogf�ringsdatoer.;ENU=Posting date is not within the range of allowed posting dates.';
      LatestEntryMustBeApplicationErr@1023 : TextConst 'DAN=Det seneste transaktionsnr. skal v�re en udligning i kreditorl�benr. %1.;ENU=The latest Transaction No. must be an application in Vendor Ledger Entry No. %1.';
      CannotUnapplyExchRateErr@1025 : TextConst 'DAN=Du kan ikke annullere udligningen af posten med bogf�ringsdato %1, fordi valutakursen for den ekstra rapporteringsvaluta er �ndret.;ENU=You cannot unapply the entry with the posting date %1, because the exchange rate for the additional reporting currency has been changed.';
      CannotUnapplyInReversalErr@1026 : TextConst 'DAN=Du kan ikke annullere udligning af kreditorpostl�benr. %1, fordi posten indg�r i en tilbagef�rsel.;ENU=You cannot unapply Vendor Ledger Entry No. %1 because the entry is part of a reversal.';
      CannotApplyClosedEntriesErr@1102601000 : TextConst 'DAN=En eller flere af de valgte poster er lukket. Du kan ikke bruge en lukket post.;ENU=One or more of the entries that you selected is closed. You cannot apply closed entries.';
      DetailedVendorLedgEntryPreviewContext@1010 : Record 380;
      ApplicationDatePreviewContext@1009 : Date;
      DocumentNoPreviewContext@1008 : Code[20];
      RunOptionPreview@1007 : 'Apply,Unapply';
      RunOptionPreviewContext@1006 : 'Apply,Unapply';
      PreviewMode@1005 : Boolean;

    [External]
    PROCEDURE Apply@17(VendLedgEntry@1000 : Record 25;DocumentNo@1001 : Code[20];ApplicationDate@1002 : Date) : Boolean;
    VAR
      PaymentToleranceMgt@1011 : Codeunit 426;
    BEGIN
      WITH VendLedgEntry DO BEGIN
        IF NOT PreviewMode THEN
          IF NOT PaymentToleranceMgt.PmtTolVend(VendLedgEntry) THEN
            EXIT(FALSE);
        GET("Entry No.");

        IF ApplicationDate = 0D THEN
          ApplicationDate := GetApplicationDate(VendLedgEntry)
        ELSE
          IF ApplicationDate < GetApplicationDate(VendLedgEntry) THEN
            ERROR(MustNotBeBeforeErr);

        IF DocumentNo = '' THEN
          DocumentNo := "Document No.";

        VendPostApplyVendLedgEntry(VendLedgEntry,DocumentNo,ApplicationDate);
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE GetApplicationDate@14(VendLedgEntry@1000 : Record 25) ApplicationDate : Date;
    VAR
      ApplyToVendLedgEntry@1001 : Record 25;
    BEGIN
      WITH VendLedgEntry DO BEGIN
        ApplicationDate := 0D;
        ApplyToVendLedgEntry.SETCURRENTKEY("Vendor No.","Applies-to ID");
        ApplyToVendLedgEntry.SETRANGE("Vendor No.","Vendor No.");
        ApplyToVendLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
        ApplyToVendLedgEntry.FIND('-');
        REPEAT
          IF ApplyToVendLedgEntry."Posting Date" > ApplicationDate THEN
            ApplicationDate := ApplyToVendLedgEntry."Posting Date";
        UNTIL ApplyToVendLedgEntry.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE VendPostApplyVendLedgEntry@12(VendLedgEntry@1000 : Record 25;DocumentNo@1002 : Code[20];ApplicationDate@1003 : Date);
    VAR
      SourceCodeSetup@1004 : Record 242;
      GenJnlLine@1005 : Record 81;
      UpdateAnalysisView@1001 : Codeunit 410;
      GenJnlPostLine@1006 : Codeunit 12;
      GenJnlPostPreview@1008 : Codeunit 19;
      Window@1007 : Dialog;
      EntryNoBeforeApplication@1010 : Integer;
      EntryNoAfterApplication@1009 : Integer;
    BEGIN
      WITH VendLedgEntry DO BEGIN
        Window.OPEN(PostingApplicationMsg);

        SourceCodeSetup.GET;

        GenJnlLine.INIT;
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine."Posting Date" := ApplicationDate;
        GenJnlLine."Document Date" := GenJnlLine."Posting Date";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine."Account No." := "Vendor No.";
        CALCFIELDS("Debit Amount","Credit Amount","Debit Amount (LCY)","Credit Amount (LCY)");
        GenJnlLine.Correction :=
          ("Debit Amount" < 0) OR ("Credit Amount" < 0) OR
          ("Debit Amount (LCY)" < 0) OR ("Credit Amount (LCY)" < 0);
        GenJnlLine."Document Type" := "Document Type";
        GenJnlLine.Description := Description;
        GenJnlLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := "Dimension Set ID";
        GenJnlLine."Posting Group" := "Vendor Posting Group";
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source No." := "Vendor No.";
        GenJnlLine."Source Code" := SourceCodeSetup."Purchase Entry Application";
        GenJnlLine."System-Created Entry" := TRUE;

        EntryNoBeforeApplication := FindLastApplDtldVendLedgEntry;

        OnBeforePostApplyVendLedgEntry(GenJnlLine,VendLedgEntry);
        GenJnlPostLine.VendPostApplyVendLedgEntry(GenJnlLine,VendLedgEntry);

        EntryNoAfterApplication := FindLastApplDtldVendLedgEntry;
        IF EntryNoAfterApplication = EntryNoBeforeApplication THEN
          ERROR(STRSUBSTNO(NoEntriesAppliedErr,GenJnlLine.FIELDCAPTION("Applies-to ID")));

        IF PreviewMode THEN
          GenJnlPostPreview.ThrowError;

        COMMIT;
        Window.CLOSE;
        UpdateAnalysisView.UpdateAll(0,TRUE);
      END;
    END;

    LOCAL PROCEDURE FindLastApplDtldVendLedgEntry@1() : Integer;
    VAR
      DtldVendLedgEntry@1000 : Record 380;
    BEGIN
      DtldVendLedgEntry.LOCKTABLE;
      IF DtldVendLedgEntry.FINDLAST THEN
        EXIT(DtldVendLedgEntry."Entry No.");

      EXIT(0);
    END;

    LOCAL PROCEDURE FindLastApplEntry@2(VendLedgEntryNo@1002 : Integer) : Integer;
    VAR
      DtldVendLedgEntry@1001 : Record 380;
      ApplicationEntryNo@1000 : Integer;
    BEGIN
      WITH DtldVendLedgEntry DO BEGIN
        SETCURRENTKEY("Vendor Ledger Entry No.","Entry Type");
        SETRANGE("Vendor Ledger Entry No.",VendLedgEntryNo);
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

    LOCAL PROCEDURE FindLastTransactionNo@6(VendLedgEntryNo@1002 : Integer) : Integer;
    VAR
      DtldVendLedgEntry@1001 : Record 380;
      LastTransactionNo@1000 : Integer;
    BEGIN
      WITH DtldVendLedgEntry DO BEGIN
        SETCURRENTKEY("Vendor Ledger Entry No.","Entry Type");
        SETRANGE("Vendor Ledger Entry No.",VendLedgEntryNo);
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
    PROCEDURE UnApplyDtldVendLedgEntry@3(DtldVendLedgEntry@1000 : Record 380);
    VAR
      ApplicationEntryNo@1001 : Integer;
    BEGIN
      DtldVendLedgEntry.TESTFIELD("Entry Type",DtldVendLedgEntry."Entry Type"::Application);
      DtldVendLedgEntry.TESTFIELD(Unapplied,FALSE);
      ApplicationEntryNo := FindLastApplEntry(DtldVendLedgEntry."Vendor Ledger Entry No.");

      IF DtldVendLedgEntry."Entry No." <> ApplicationEntryNo THEN
        ERROR(UnapplyPostedAfterThisEntryErr);
      CheckReversal(DtldVendLedgEntry."Vendor Ledger Entry No.");
      UnApplyVendor(DtldVendLedgEntry);
    END;

    [External]
    PROCEDURE UnApplyVendLedgEntry@7(VendLedgEntryNo@1000 : Integer);
    VAR
      DtldVendLedgEntry@1002 : Record 380;
      ApplicationEntryNo@1001 : Integer;
    BEGIN
      CheckReversal(VendLedgEntryNo);
      ApplicationEntryNo := FindLastApplEntry(VendLedgEntryNo);
      IF ApplicationEntryNo = 0 THEN
        ERROR(NoApplicationEntryErr,VendLedgEntryNo);
      DtldVendLedgEntry.GET(ApplicationEntryNo);
      UnApplyVendor(DtldVendLedgEntry);
    END;

    LOCAL PROCEDURE UnApplyVendor@19(DtldVendLedgEntry@1000000000 : Record 380);
    VAR
      UnapplyVendEntries@1000 : Page 624;
    BEGIN
      WITH DtldVendLedgEntry DO BEGIN
        TESTFIELD("Entry Type","Entry Type"::Application);
        TESTFIELD(Unapplied,FALSE);
        UnapplyVendEntries.SetDtldVendLedgEntry("Entry No.");
        UnapplyVendEntries.LOOKUPMODE(TRUE);
        UnapplyVendEntries.RUNMODAL;
      END;
    END;

    [External]
    PROCEDURE PostUnApplyVendor@4(DtldVendLedgEntry2@1007 : Record 380;DocNo@1000 : Code[20];PostingDate@1001 : Date);
    VAR
      GLEntry@1013 : Record 17;
      VendLedgEntry@1004 : Record 25;
      DtldVendLedgEntry@1010 : Record 380;
      SourceCodeSetup@1006 : Record 242;
      GenJnlLine@1005 : Record 81;
      DateComprReg@1014 : Record 87;
      GenJnlPostLine@1003 : Codeunit 12;
      GenJnlPostPreview@1011 : Codeunit 19;
      Window@1002 : Dialog;
      LastTransactionNo@1009 : Integer;
      AddCurrChecked@1012 : Boolean;
      MaxPostingDate@1008 : Date;
    BEGIN
      MaxPostingDate := 0D;
      GLEntry.LOCKTABLE;
      DtldVendLedgEntry.LOCKTABLE;
      VendLedgEntry.LOCKTABLE;
      VendLedgEntry.GET(DtldVendLedgEntry2."Vendor Ledger Entry No.");
      CheckPostingDate(PostingDate,MaxPostingDate);
      IF PostingDate < DtldVendLedgEntry2."Posting Date" THEN
        ERROR(MustNotBeBeforeErr);
      IF DtldVendLedgEntry2."Transaction No." = 0 THEN BEGIN
        DtldVendLedgEntry.SETCURRENTKEY("Application No.","Vendor No.","Entry Type");
        DtldVendLedgEntry.SETRANGE("Application No.",DtldVendLedgEntry2."Application No.");
      END ELSE BEGIN
        DtldVendLedgEntry.SETCURRENTKEY("Transaction No.","Vendor No.","Entry Type");
        DtldVendLedgEntry.SETRANGE("Transaction No.",DtldVendLedgEntry2."Transaction No.");
      END;
      DtldVendLedgEntry.SETRANGE("Vendor No.",DtldVendLedgEntry2."Vendor No.");
      DtldVendLedgEntry.SETFILTER("Entry Type",'<>%1',DtldVendLedgEntry."Entry Type"::"Initial Entry");
      DtldVendLedgEntry.SETRANGE(Unapplied,FALSE);
      IF DtldVendLedgEntry.FIND('-') THEN
        REPEAT
          IF NOT AddCurrChecked THEN BEGIN
            CheckAdditionalCurrency(PostingDate,DtldVendLedgEntry."Posting Date");
            AddCurrChecked := TRUE;
          END;
          CheckReversal(DtldVendLedgEntry."Vendor Ledger Entry No.");
          IF DtldVendLedgEntry."Transaction No." <> 0 THEN BEGIN
            IF DtldVendLedgEntry."Entry Type" = DtldVendLedgEntry."Entry Type"::Application THEN BEGIN
              LastTransactionNo :=
                FindLastApplTransactionEntry(DtldVendLedgEntry."Vendor Ledger Entry No.");
              IF (LastTransactionNo <> 0) AND (LastTransactionNo <> DtldVendLedgEntry."Transaction No.") THEN
                ERROR(UnapplyAllPostedAfterThisEntryErr,DtldVendLedgEntry."Vendor Ledger Entry No.");
            END;
            LastTransactionNo := FindLastTransactionNo(DtldVendLedgEntry."Vendor Ledger Entry No.");
            IF (LastTransactionNo <> 0) AND (LastTransactionNo <> DtldVendLedgEntry."Transaction No.") THEN
              ERROR(LatestEntryMustBeApplicationErr,DtldVendLedgEntry."Vendor Ledger Entry No.");
          END;
        UNTIL DtldVendLedgEntry.NEXT = 0;

      DateComprReg.CheckMaxDateCompressed(MaxPostingDate,0);

      WITH DtldVendLedgEntry2 DO BEGIN
        SourceCodeSetup.GET;
        VendLedgEntry.GET("Vendor Ledger Entry No.");
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine."Account No." := "Vendor No.";
        GenJnlLine.Correction := TRUE;
        GenJnlLine."Document Type" := "Document Type";
        GenJnlLine.Description := VendLedgEntry.Description;
        GenJnlLine."Shortcut Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
        GenJnlLine."Posting Group" := VendLedgEntry."Vendor Posting Group";
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source No." := "Vendor No.";
        GenJnlLine."Source Code" := SourceCodeSetup."Unapplied Purch. Entry Appln.";
        GenJnlLine."Source Currency Code" := "Currency Code";
        GenJnlLine."System-Created Entry" := TRUE;
        Window.OPEN(UnapplyingMsg);
        OnBeforePostUnapplyVendLedgEntry(GenJnlLine,VendLedgEntry,DtldVendLedgEntry2);
        GenJnlPostLine.UnapplyVendLedgEntry(GenJnlLine,DtldVendLedgEntry2);

        IF PreviewMode THEN
          GenJnlPostPreview.ThrowError;

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

    LOCAL PROCEDURE CheckReversal@9(VendLedgEntryNo@1000 : Integer);
    VAR
      VendLedgEntry@1001 : Record 25;
    BEGIN
      VendLedgEntry.GET(VendLedgEntryNo);
      IF VendLedgEntry.Reversed THEN
        ERROR(CannotUnapplyInReversalErr,VendLedgEntryNo);
    END;

    [External]
    PROCEDURE ApplyVendEntryFormEntry@10(VAR ApplyingVendLedgEntry@1000 : Record 25);
    VAR
      VendLedgEntry@1002 : Record 25;
      ApplyVendEntries@1001 : Page 233;
      VendEntryApplID@1004 : Code[50];
    BEGIN
      IF NOT ApplyingVendLedgEntry.Open THEN
        ERROR(CannotApplyClosedEntriesErr);

      VendEntryApplID := USERID;
      IF VendEntryApplID = '' THEN
        VendEntryApplID := '***';
      IF ApplyingVendLedgEntry."Remaining Amount" = 0 THEN
        ApplyingVendLedgEntry.CALCFIELDS("Remaining Amount");

      ApplyingVendLedgEntry."Applying Entry" := TRUE;
      IF ApplyingVendLedgEntry."Applies-to ID" = '' THEN
        ApplyingVendLedgEntry."Applies-to ID" := VendEntryApplID;
      ApplyingVendLedgEntry."Amount to Apply" := ApplyingVendLedgEntry."Remaining Amount";
      CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",ApplyingVendLedgEntry);
      COMMIT;

      VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive);
      VendLedgEntry.SETRANGE("Vendor No.",ApplyingVendLedgEntry."Vendor No.");
      VendLedgEntry.SETRANGE(Open,TRUE);
      IF VendLedgEntry.FINDFIRST THEN BEGIN
        ApplyVendEntries.SetVendLedgEntry(ApplyingVendLedgEntry);
        ApplyVendEntries.SETRECORD(VendLedgEntry);
        ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
        IF ApplyingVendLedgEntry."Applies-to ID" <> VendEntryApplID THEN
          ApplyVendEntries.SetAppliesToID(ApplyingVendLedgEntry."Applies-to ID");
        ApplyVendEntries.RUNMODAL;
        CLEAR(ApplyVendEntries);
        ApplyingVendLedgEntry."Applying Entry" := FALSE;
        ApplyingVendLedgEntry."Applies-to ID" := '';
        ApplyingVendLedgEntry."Amount to Apply" := 0;
      END;
    END;

    LOCAL PROCEDURE FindLastApplTransactionEntry@11(VendLedgEntryNo@1000 : Integer) : Integer;
    VAR
      DtldVendLedgEntry@1001 : Record 380;
      LastTransactionNo@1002 : Integer;
    BEGIN
      DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.","Entry Type");
      DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.",VendLedgEntryNo);
      DtldVendLedgEntry.SETRANGE("Entry Type",DtldVendLedgEntry."Entry Type"::Application);
      LastTransactionNo := 0;
      IF DtldVendLedgEntry.FIND('-') THEN
        REPEAT
          IF (DtldVendLedgEntry."Transaction No." > LastTransactionNo) AND NOT DtldVendLedgEntry.Unapplied THEN
            LastTransactionNo := DtldVendLedgEntry."Transaction No.";
        UNTIL DtldVendLedgEntry.NEXT = 0;
      EXIT(LastTransactionNo);
    END;

    [External]
    PROCEDURE PreviewApply@16(VendorLedgerEntry@1003 : Record 25;DocumentNo@1002 : Code[20];ApplicationDate@1001 : Date);
    VAR
      GenJnlPostPreview@1004 : Codeunit 19;
      VendEntryApplyPostedEntries@1000 : Codeunit 227;
      PaymentToleranceMgt@1005 : Codeunit 426;
    BEGIN
      IF NOT PaymentToleranceMgt.PmtTolVend(VendorLedgerEntry) THEN
        EXIT;

      BINDSUBSCRIPTION(VendEntryApplyPostedEntries);
      VendEntryApplyPostedEntries.SetApplyContext(ApplicationDate,DocumentNo);
      GenJnlPostPreview.Preview(VendEntryApplyPostedEntries,VendorLedgerEntry);
    END;

    [External]
    PROCEDURE PreviewUnapply@15(DetailedVendorLedgEntry@1002 : Record 380;DocumentNo@1001 : Code[20];ApplicationDate@1000 : Date);
    VAR
      VendorLedgerEntry@1004 : Record 25;
      GenJnlPostPreview@1003 : Codeunit 19;
      VendEntryApplyPostedEntries@1005 : Codeunit 227;
    BEGIN
      BINDSUBSCRIPTION(VendEntryApplyPostedEntries);
      VendEntryApplyPostedEntries.SetUnapplyContext(DetailedVendorLedgEntry,ApplicationDate,DocumentNo);
      GenJnlPostPreview.Preview(VendEntryApplyPostedEntries,VendorLedgerEntry);
    END;

    [External]
    PROCEDURE SetApplyContext@13(ApplicationDate@1000 : Date;DocumentNo@1001 : Code[20]);
    BEGIN
      ApplicationDatePreviewContext := ApplicationDate;
      DocumentNoPreviewContext := DocumentNo;
      RunOptionPreviewContext := RunOptionPreview::Apply;
    END;

    [External]
    PROCEDURE SetUnapplyContext@28(VAR DetailedVendorLedgEntry@1002 : Record 380;ApplicationDate@1000 : Date;DocumentNo@1001 : Code[20]);
    BEGIN
      ApplicationDatePreviewContext := ApplicationDate;
      DocumentNoPreviewContext := DocumentNo;
      DetailedVendorLedgEntryPreviewContext := DetailedVendorLedgEntry;
      RunOptionPreviewContext := RunOptionPreview::Unapply;
    END;

    [EventSubscriber(Codeunit,19,OnRunPreview)]
    LOCAL PROCEDURE OnRunPreview@18(VAR Result@1000 : Boolean;Subscriber@1001 : Variant;RecVar@1002 : Variant);
    VAR
      VendEntryApplyPostedEntries@1003 : Codeunit 227;
    BEGIN
      VendEntryApplyPostedEntries := Subscriber;
      PreviewMode := TRUE;
      Result := VendEntryApplyPostedEntries.RUN(RecVar);
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostApplyVendLedgEntry@20(VAR GenJournalLine@1000 : Record 81;VendorLedgerEntry@1001 : Record 25);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostUnapplyVendLedgEntry@22(VAR GenJournalLine@1000 : Record 81;VendorLedgerEntry@1001 : Record 25;DetailedVendorLedgEntry@1002 : Record 380);
    BEGIN
    END;

    BEGIN
    END.
  }
}

