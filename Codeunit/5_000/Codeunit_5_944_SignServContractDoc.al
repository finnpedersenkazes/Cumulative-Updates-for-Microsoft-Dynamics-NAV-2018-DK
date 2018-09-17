OBJECT Codeunit 5944 SignServContractDoc
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    TableNo=5965;
    Permissions=TableData 5970=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      GLAcc@1057 : Record 15;
      ServHeader@1043 : Record 5900;
      ServMgtSetup@1006 : Record 5911;
      FromServContractHeader@1050 : Record 5965;
      FromServContractLine@1034 : Record 5964;
      ToServContractLine@1033 : Record 5964;
      ServContractAccGr@1003 : Record 5973;
      FiledServContractHeader@1016 : Record 5970;
      ContractChangeLog@1029 : Record 5967;
      ContractGainLossEntry@1038 : Record 5969;
      ServContractMgt@1000 : Codeunit 5940;
      ServLogMgt@1035 : Codeunit 5906;
      Window@1001 : Dialog;
      ServHeaderNo@1039 : Code[20];
      InvoicingStartingPeriod@1019 : Boolean;
      InvoiceNow@1021 : Boolean;
      GoOut@1024 : Boolean;
      Text001@1005 : TextConst 'DAN=Du kan ikke �ndre servicekontrakttilbuddet %1 til en kontrakt,\fordi nogle servicekontraktlinjer mangler et %2.;ENU=You cannot convert the service contract quote %1 to a contract,\because some Service Contract Lines have a missing %2.';
      Text003@1007 : TextConst 'DAN=%1 skal v�re den f�rste dag i m�neden.;ENU=%1 must be the first day of the month.';
      Text004@1046 : TextConst 'DAN=Du kan ikke underskrive servicekontrakten %1,\fordi nogle servicekontraktlinjer mangler et %2.;ENU=You cannot sign service contract %1,\because some Service Contract Lines have a missing %2.';
      Text005@1008 : TextConst 'DAN=%1 er ikke den sidste dag i m�neden.\\Bekr�ft, at det er den rigtige dato.;ENU=%1 is not the last day of the month.\\Confirm that this is the correct date.';
      Text010@1048 : TextConst 'DAN=Vil du underskrive kontrakten %1?;ENU=Do you want to sign service contract %1?';
      Text011@1014 : TextConst 'DAN=Skal kontrakttilbuddet �ndres til en kontrakt?;ENU=Do you want to convert the contract quote into a contract?';
      Text012@1013 : TextConst 'DAN=Underskriver kontrakt     #1######\;ENU=Signing contract          #1######\';
      Text013@1012 : TextConst 'DAN=Behandler kontraktlinjer  #2######\;ENU=Processing contract lines #2######\';
      WPostLine@1018 : Integer;
      Text015@1020 : TextConst 'DAN=Vil du oprette en faktura for perioden %1 .. %2?;ENU=Do you want to create an invoice for the period %1 .. %2?';
      AppliedEntry@1044 : Integer;
      InvoiceFrom@1023 : Date;
      InvoiceTo@1022 : Date;
      FirstPrepaidPostingDate@1026 : Date;
      LastPrepaidPostingDate@1025 : Date;
      PostingDate@1027 : Date;
      Text016@1040 : TextConst 'DAN=Servicefakturaen %1 blev oprettet.;ENU=Service Invoice %1 was created.';
      Text018@1055 : TextConst 'DAN=Det er ikke muligt at tilf�je nye linjer i denne servicekontrakt med den aktuelle arbejdsdato,\fordi der vil opst� et hul i faktureringsperioden.;ENU=It is not possible to add new lines to this service contract with the current working date\because it will cause a gap in the invoice period.';
      HideDialog@1056 : Boolean;
      Text019@1058 : TextConst 'DAN=Du kan ikke underskrive en servicekontrakt med et negativt �rligt bel�b.;ENU=You cannot sign service contract with negative annual amount.';
      Text020@1059 : TextConst 'DAN=Du kan ikke underskrive en kontrakt med et �rligt bel�b, som er nul, n�r fakturaperioden er forskellig fra Ingen.;ENU=You cannot sign service contract with zero annual amount when invoice period is different from None.';
      Text021@1004 : TextConst 'DAN=En eller flere serviceartikler i kontrakttilbudet %1 h�rer ikke til debitoren %2.;ENU=One or more service items on contract quote %1 does not belong to customer %2.';
      Text022@1009 : TextConst 'DAN=Feltet %1 er tomt p� en eller flere servicekontraktlinjer, og der kan ikke automatisk oprettes serviceordrer. Vil du forts�tte?;ENU=The %1 field is empty on one or more service contract lines, and service orders cannot be created automatically. Do you want to continue?';
      Text023@1010 : TextConst 'DAN=Du kan ikke underskrive en servicekontrakt, hvis %1 for den ikke er lig med %2-v�rdien.;ENU=You cannot sign a service contract if its %1 is not equal to the %2 value.';
      Text024@1011 : TextConst 'DAN=Du kan ikke underskrive en annulleret servicekontrakt.;ENU=You cannot sign a canceled service contract.';

    [External]
    PROCEDURE SignContractQuote@2(FromServContractHeader@1000 : Record 5965);
    VAR
      FromServContractLine@1008 : Record 5964;
      ToServContractHeader@1007 : Record 5965;
      FiledServContractHeader2@1009 : Record 5970;
      RecordLinkManagement@1001 : Codeunit 447;
    BEGIN
      OnBeforeSignContractQuote(FromServContractHeader);

      IF NOT HideDialog THEN
        CLEARALL;
      CheckServContractQuote(FromServContractHeader);
      IF NOT HideDialog THEN
        IF NOT CONFIRM(Text011,TRUE) THEN
          EXIT;
      IF NOT HideDialog THEN
        IF NOT CheckServContractNextPlannedServiceDate(FromServContractHeader) THEN
          EXIT;

      Window.OPEN(
        Text012 +
        Text013);

      FiledServContractHeader.FileQuotationBeforeSigning(FromServContractHeader);

      Window.UPDATE(1,1);
      WPostLine := 0;
      InvoicingStartingPeriod := FALSE;
      SetInvoicing(FromServContractHeader);

      FirstPrepaidPostingDate := 0D;
      LastPrepaidPostingDate := 0D;

      ToServContractHeader.TRANSFERFIELDS(FromServContractHeader);

      IF InvoiceNow THEN
        PostingDate := InvoiceFrom;

      ToServContractHeader."Contract Type" := ToServContractHeader."Contract Type"::Contract;
      IF InvoiceNow THEN BEGIN
        ToServContractHeader."Last Invoice Date" := ToServContractHeader."Starting Date";
        ToServContractHeader.VALIDATE("Last Invoice Period End",InvoiceTo);
      END;
      ToServContractHeader.INSERT;
      IF ServMgtSetup."Register Contract Changes" THEN
        ContractChangeLog.LogContractChange(
          ToServContractHeader."Contract No.",0,ToServContractHeader.FIELDCAPTION(Status),0,
          '',FORMAT(ToServContractHeader.Status),'',0);

      FiledServContractHeader.RESET;
      FiledServContractHeader.SETCURRENTKEY("Contract Type Relation","Contract No. Relation");
      FiledServContractHeader.SETRANGE("Contract Type Relation",FromServContractHeader."Contract Type");
      FiledServContractHeader.SETRANGE("Contract No. Relation",FromServContractHeader."Contract No.");
      IF FiledServContractHeader.FINDSET THEN
        REPEAT
          FiledServContractHeader2 := FiledServContractHeader;
          FiledServContractHeader2."Contract Type Relation" := ToServContractHeader."Contract Type";
          FiledServContractHeader2."Contract No. Relation" := ToServContractHeader."Contract No.";
          FiledServContractHeader2.MODIFY;
        UNTIL FiledServContractHeader.NEXT = 0;

      FromServContractLine.RESET;
      FromServContractLine.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
      FromServContractLine.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
      IF FromServContractLine.FINDSET THEN
        REPEAT
          ToServContractLine := FromServContractLine;
          ToServContractLine."Contract Type" := ToServContractLine."Contract Type"::Contract;
          ToServContractLine."Contract No." := FromServContractLine."Contract No.";
          ToServContractLine."Contract Status" := FromServContractLine."Contract Status"::Signed;
          ToServContractLine.SuspendStatusCheck(TRUE);
          ToServContractLine.INSERT(TRUE);
          CLEAR(ServLogMgt);
          WPostLine := WPostLine + 1;
          Window.UPDATE(2,WPostLine);
        UNTIL FromServContractLine.NEXT = 0;

      CopyServComments(FromServContractHeader,ToServContractHeader);

      IF InvoicingStartingPeriod AND
         NOT ToServContractHeader.Prepaid AND
         InvoiceNow
      THEN BEGIN
        ToServContractHeader.VALIDATE("Last Invoice Date",InvoiceTo);
        ToServContractHeader.MODIFY;
      END;

      ToServContractHeader.Status := ToServContractHeader.Status::Signed;
      ToServContractHeader."Change Status" := ToServContractHeader."Change Status"::Locked;
      ToServContractHeader.MODIFY;
      RecordLinkManagement.CopyLinks(FromServContractHeader,ToServContractHeader);

      IF InvoiceNow THEN BEGIN
        ServMgtSetup.GET;
        CreateServiceLinesLedgerEntries(ToServContractHeader,FALSE);
      END;

      CopyContractServDiscounts(FromServContractHeader,ToServContractHeader);

      ContractGainLossEntry.AddEntry(
        2,ToServContractHeader."Contract Type",ToServContractHeader."Contract No.",FromServContractHeader."Annual Amount",'');

      ToServContractLine.RESET;
      ToServContractLine.SETRANGE("Contract Type",ToServContractHeader."Contract Type");
      ToServContractLine.SETRANGE("Contract No.",ToServContractHeader."Contract No.");
      IF ToServContractLine.FINDSET THEN
        REPEAT
          ToServContractLine."New Line" := FALSE;
          ToServContractLine.MODIFY;
        UNTIL ToServContractLine.NEXT = 0;

      FromServContractLine.RESET;
      FromServContractLine.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
      FromServContractLine.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
      FromServContractLine.DELETEALL;
      FromServContractHeader.DELETE;

      CopyServHours(ToServContractHeader);

      Window.CLOSE;

      IF NOT HideDialog THEN
        IF ServHeaderNo <> '' THEN
          MESSAGE(Text016,ServHeaderNo);
    END;

    [External]
    PROCEDURE SignContract@1(FromServContractHeader@1000 : Record 5965);
    VAR
      ServContractLine@1008 : Record 5964;
      ServContractHeader@1007 : Record 5965;
      LockOpenServContract@1001 : Codeunit 5943;
    BEGIN
      OnBeforeSignContract(FromServContractHeader);

      IF NOT HideDialog THEN
        CLEARALL;

      IF NOT HideDialog THEN
        IF NOT CONFIRM(Text010,TRUE,FromServContractHeader."Contract No.") THEN
          EXIT;

      ServContractHeader.GET(FromServContractHeader."Contract Type",FromServContractHeader."Contract No.");
      CheckServContract(ServContractHeader);

      IF ServContractHeader.Status = ServContractHeader.Status::Signed THEN BEGIN
        LockOpenServContract.LockServContract(ServContractHeader);
        EXIT;
      END;

      Window.OPEN(Text012 + Text013);

      FiledServContractHeader.FileQuotationBeforeSigning(ServContractHeader);

      Window.UPDATE(1,1);
      WPostLine := 0;
      InvoicingStartingPeriod := FALSE;
      SetInvoicing(ServContractHeader);

      IF InvoiceNow THEN
        PostingDate := InvoiceFrom;

      IF InvoiceNow THEN BEGIN
        ServContractHeader."Last Invoice Date" := ServContractHeader."Starting Date";
        ServContractHeader.VALIDATE("Last Invoice Period End",InvoiceTo);
      END;

      ServContractLine.RESET;
      ServContractLine.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
      ServContractLine.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
      IF ServContractLine.FINDSET THEN
        REPEAT
          ServContractLine."Contract Status" := ServContractLine."Contract Status"::Signed;
          ServContractLine.MODIFY;
          CLEAR(ServLogMgt);
          WPostLine := WPostLine + 1;
          Window.UPDATE(2,WPostLine);
        UNTIL ServContractLine.NEXT = 0;

      IF InvoicingStartingPeriod AND
         NOT ServContractHeader.Prepaid AND
         InvoiceNow
      THEN BEGIN
        ServContractHeader.VALIDATE("Last Invoice Date",InvoiceTo);
        ServContractHeader.MODIFY;
      END;

      IF InvoiceNow THEN BEGIN
        ServMgtSetup.GET;
        CreateServiceLinesLedgerEntries(ServContractHeader,FALSE);
      END;

      ContractGainLossEntry.AddEntry(
        2,ServContractHeader."Contract Type",
        ServContractHeader."Contract No.",
        ServContractHeader."Annual Amount",'');

      ServContractHeader.Status := ServContractHeader.Status::Signed;
      ServContractHeader."Change Status" := ServContractHeader."Change Status"::Locked;
      ServContractHeader.MODIFY;

      ServContractLine.RESET;
      ServContractLine.SETRANGE("Contract Type",ServContractHeader."Contract Type");
      ServContractLine.SETRANGE("Contract No.",ServContractHeader."Contract No.");
      IF ServContractLine.FINDSET THEN
        REPEAT
          ServContractLine."New Line" := FALSE;
          ServContractLine.MODIFY;
        UNTIL ServContractLine.NEXT = 0;

      IF ServMgtSetup."Register Contract Changes" THEN
        ContractChangeLog.LogContractChange(
          ServContractHeader."Contract No.",0,ServContractHeader.FIELDCAPTION(Status),0,
          '',FORMAT(ServContractHeader.Status),'',0);

      CLEAR(FromServContractHeader);

      Window.CLOSE;

      IF NOT HideDialog THEN
        IF ServHeaderNo <> '' THEN
          MESSAGE(Text016,ServHeaderNo);
    END;

    [Internal]
    PROCEDURE AddendumToContract@4(ServContractHeader@1000 : Record 5965);
    VAR
      Currency@1001 : Record 4;
      ServContractLine@1008 : Record 5964;
      TempDate@1005 : Date;
      StartingDate@1010 : Date;
      RemainingAmt@1011 : Decimal;
      InvoicePrepaid@1007 : Boolean;
      NonExpiredContractLineExists@1003 : Boolean;
      NoOfMonthsAndMParts@1004 : Decimal;
    BEGIN
      IF NOT HideDialog THEN
        CLEARALL;
      FromServContractHeader := ServContractHeader;
      IF (FromServContractHeader."Invoice Period" = FromServContractHeader."Invoice Period"::None) OR
         (FromServContractHeader."Next Invoice Date" = 0D)
      THEN
        EXIT;
      FromServContractHeader.TESTFIELD("Serv. Contract Acc. Gr. Code");
      ServContractAccGr.GET(FromServContractHeader."Serv. Contract Acc. Gr. Code");
      ServContractAccGr.TESTFIELD("Non-Prepaid Contract Acc.");
      GLAcc.GET(ServContractAccGr."Non-Prepaid Contract Acc.");
      GLAcc.TESTFIELD("Direct Posting");

      IF FromServContractHeader.Prepaid THEN BEGIN
        ServContractAccGr.TESTFIELD("Prepaid Contract Acc.");
        GLAcc.GET(ServContractAccGr."Prepaid Contract Acc.");
        GLAcc.TESTFIELD("Direct Posting");
      END;

      ServMgtSetup.GET;
      Currency.InitRoundingPrecision;

      ServContractLine.RESET;
      ServContractLine.SETCURRENTKEY("Contract Type","Contract No.",Credited,"New Line");
      ServContractLine.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
      ServContractLine.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
      ServContractLine.SETRANGE("New Line",TRUE);
      StartingDate := WORKDATE;
      IF ServContractLine.FINDSET THEN
        REPEAT
          IF ServMgtSetup."Contract Rsp. Time Mandatory" THEN
            ServContractLine.TESTFIELD("Response Time (Hours)");
          ServContractLine."Starting Date" := StartingDate;
          IF (ServContractLine."Next Planned Service Date" <> 0D) AND
             (ServContractLine."Next Planned Service Date" < StartingDate)
          THEN
            ServContractLine."Next Planned Service Date" := StartingDate;
          ServContractLine.MODIFY;
        UNTIL ServContractLine.NEXT = 0;

      IF NOT HideDialog THEN BEGIN
        ServContractLine.RESET;
        ServContractLine.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
        ServContractLine.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
        ServContractLine.SETRANGE("New Line",TRUE);
        ServContractLine.SETRANGE("Next Planned Service Date",0D);
        IF ServContractLine.FINDFIRST THEN
          IF NOT
             CONFIRM(
               Text022,
               TRUE,
               ServContractLine.FIELDCAPTION("Next Planned Service Date"))
          THEN
            ERROR('');
      END;

      Window.OPEN(Text012 + Text013);

      FiledServContractHeader.FileQuotationBeforeSigning(FromServContractHeader);

      Window.UPDATE(1,1);
      WPostLine := 0;

      InvoicePrepaid := FromServContractHeader.Prepaid;

      TempDate := FromServContractHeader."Next Invoice Period Start";
      IF StartingDate < TempDate THEN BEGIN
        TempDate := TempDate - 1;
      END ELSE BEGIN
        IF StartingDate > CALCDATE('<CM>',TempDate) THEN BEGIN
          Window.CLOSE;
          ERROR(Text018);
        END;
        TempDate := CALCDATE('<CM>',StartingDate);
        InvoicePrepaid := TRUE;
      END;

      IF StartingDate >= FromServContractHeader."Next Invoice Period Start" THEN BEGIN
        GoOut := TRUE;
        InvoicePrepaid := FALSE;
      END;

      IF NOT GoOut THEN BEGIN
        InvoiceFrom := StartingDate;
        InvoiceTo := TempDate;
        InvoicingStartingPeriod := TRUE;
      END;

      IF FromServContractHeader.Prepaid AND InvoicePrepaid THEN BEGIN
        FirstPrepaidPostingDate := ServContractMgt.FindFirstPrepaidTransaction(FromServContractHeader."Contract No.");
        IF FirstPrepaidPostingDate <> 0D THEN BEGIN
          IF StartingDate < FromServContractHeader."Next Invoice Date" THEN
            LastPrepaidPostingDate := FromServContractHeader."Next Invoice Date" - 1
          ELSE
            LastPrepaidPostingDate := FromServContractHeader."Next Invoice Period End";
          CASE TRUE OF
            InvoiceFrom < FirstPrepaidPostingDate:
              InvoiceTo := FirstPrepaidPostingDate - 1;
            InvoiceFrom > FirstPrepaidPostingDate:
              IF LastPrepaidPostingDate = CALCDATE('<CM>',InvoiceFrom) THEN
                InvoicePrepaid := FALSE
              ELSE BEGIN
                InvoiceTo := CALCDATE('<CM>',InvoiceFrom);
                FirstPrepaidPostingDate := InvoiceTo + 1;
                IF InvoiceFrom > LastPrepaidPostingDate
                THEN
                  LastPrepaidPostingDate := FromServContractHeader."Next Invoice Period End";
              END;
          END;
        END ELSE
          IF InvoiceFrom > FromServContractHeader."Next Invoice Period Start" THEN BEGIN
            FirstPrepaidPostingDate := CALCDATE('<CM>',InvoiceFrom) + 1;
            IF FirstPrepaidPostingDate < FromServContractHeader."Next Invoice Period End" THEN
              LastPrepaidPostingDate := FromServContractHeader."Next Invoice Period End"
            ELSE
              InvoicePrepaid := FALSE;
          END ELSE
            InvoicePrepaid := FALSE;
      END;

      IF NOT GoOut THEN
        IF HideDialog THEN
          InvoiceNow := TRUE
        ELSE BEGIN
          IF InvoicePrepaid AND (LastPrepaidPostingDate <> 0D)
          THEN
            TempDate := LastPrepaidPostingDate;
          IF CONFIRM(
               Text015,TRUE,
               StartingDate,TempDate)
          THEN
            InvoiceNow := TRUE
          ELSE
            InvoicePrepaid := FALSE;
        END;

      IF FromServContractHeader.Prepaid AND InvoicePrepaid THEN
        IF InvoiceFrom = ServContractMgt.FindFirstPrepaidTransaction(FromServContractHeader."Contract No.")
        THEN
          InvoiceNow := FALSE;

      IF InvoiceNow THEN BEGIN
        PostingDate := InvoiceFrom;
        ServContractLine.RESET;
        ServContractLine.SETCURRENTKEY("Contract Type","Contract No.",Credited,"New Line");
        ServContractLine.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
        ServContractLine.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
        ServContractLine.SETRANGE("New Line",TRUE);
        IF ServContractLine.FINDSET THEN
          REPEAT
            IF (ServContractLine."Contract Expiration Date" <> 0D) AND
               (ServContractLine."Contract Expiration Date" < InvoiceTo)
            THEN
              NoOfMonthsAndMParts := ServContractMgt.NoOfMonthsAndMPartsInPeriod(
                  InvoiceFrom,ServContractLine."Contract Expiration Date")
            ELSE
              IF (FromServContractHeader."Expiration Date" <> 0D) AND
                 (FromServContractHeader."Expiration Date" < InvoiceTo)
              THEN
                NoOfMonthsAndMParts := ServContractMgt.NoOfMonthsAndMPartsInPeriod(
                    InvoiceFrom,FromServContractHeader."Expiration Date")
              ELSE
                NoOfMonthsAndMParts :=
                  ServContractMgt.NoOfMonthsAndMPartsInPeriod(InvoiceFrom,InvoiceTo);
            RemainingAmt :=
              RemainingAmt +
              ROUND(
                ServContractLine."Line Amount" / 12 * NoOfMonthsAndMParts,Currency."Amount Rounding Precision");
          UNTIL ServContractLine.NEXT = 0;
      END;

      IF InvoiceNow THEN
        CreateServiceLinesLedgerEntries(FromServContractHeader,TRUE);

      IF InvoicePrepaid AND FromServContractHeader.Prepaid THEN BEGIN
        ServContractMgt.InitCodeUnit;
        IF ServHeaderNo = '' THEN
          ServHeaderNo :=
            ServContractMgt.CreateServHeader(FromServContractHeader,PostingDate,FALSE);

        RemainingAmt := 0;
        ServContractLine.RESET;
        ServContractLine.SETCURRENTKEY("Contract Type","Contract No.",Credited,"New Line");
        ServContractLine.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
        ServContractLine.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
        ServContractLine.SETRANGE("New Line",TRUE);

        IF ServContractLine.FINDSET THEN
          REPEAT
            InvoiceFrom := FirstPrepaidPostingDate;
            InvoiceTo := LastPrepaidPostingDate;
            IF (ServContractLine."Contract Expiration Date" <> 0D) AND
               (ServContractLine."Contract Expiration Date" < InvoiceTo)
            THEN
              InvoiceTo := ServContractLine."Contract Expiration Date";
            IF (FromServContractHeader."Expiration Date" <> 0D) AND
               (FromServContractHeader."Expiration Date" < InvoiceTo)
            THEN
              InvoiceTo := FromServContractHeader."Expiration Date";
            IF ServContractLine."Starting Date" > InvoiceFrom THEN
              InvoiceFrom := ServContractLine."Starting Date";
            NoOfMonthsAndMParts :=
              ServContractMgt.NoOfMonthsAndMPartsInPeriod(InvoiceFrom,InvoiceTo);
            RemainingAmt :=
              RemainingAmt +
              ROUND(
                ServContractLine."Line Amount" / 12 * NoOfMonthsAndMParts,Currency."Amount Rounding Precision");
          UNTIL ServContractLine.NEXT = 0;
        IF RemainingAmt <> 0 THEN BEGIN
          ServHeader.GET(ServHeader."Document Type"::Invoice,ServHeaderNo);
          IF FromServContractHeader."Contract Lines on Invoice" THEN BEGIN
            ServContractLine.RESET;
            ServContractLine.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
            ServContractLine.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
            ServContractLine.SETRANGE("New Line",TRUE);
            IF ServContractLine.FINDSET THEN
              REPEAT
                IF FromServContractHeader."Contract Lines on Invoice" THEN
                  ServContractMgt.CreateDetailedServLine(
                    ServHeader,
                    ServContractLine,
                    FromServContractHeader."Contract Type",
                    FromServContractHeader."Contract No.");

                AppliedEntry :=
                  ServContractMgt.CreateServiceLedgerEntry(
                    ServHeader,FromServContractHeader."Contract Type",
                    FromServContractHeader."Contract No.",FirstPrepaidPostingDate,
                    LastPrepaidPostingDate,FALSE,TRUE,
                    ServContractLine."Line No.");

                ServContractMgt.CreateServLine(
                  ServHeader,
                  FromServContractHeader."Contract Type",
                  FromServContractHeader."Contract No.",
                  FirstPrepaidPostingDate,LastPrepaidPostingDate,
                  AppliedEntry,FALSE);
              UNTIL ServContractLine.NEXT = 0;
          END ELSE BEGIN
            ServContractMgt.CreateHeadingServLine(
              ServHeader,
              FromServContractHeader."Contract Type",
              FromServContractHeader."Contract No.");

            AppliedEntry :=
              ServContractMgt.CreateServiceLedgerEntry(
                ServHeader,FromServContractHeader."Contract Type",
                FromServContractHeader."Contract No.",FirstPrepaidPostingDate,
                LastPrepaidPostingDate,FALSE,TRUE,0);

            ServContractMgt.CreateServLine(
              ServHeader,
              FromServContractHeader."Contract Type",
              FromServContractHeader."Contract No.",
              FirstPrepaidPostingDate,LastPrepaidPostingDate,
              AppliedEntry,FALSE);
          END;
        END;
        ServContractMgt.FinishCodeunit;
      END;

      ServContractLine.RESET;
      ServContractLine.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
      ServContractLine.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
      IF ServContractLine.FINDSET THEN
        REPEAT
          IF (ServContractLine."Contract Expiration Date" <> 0D) AND (ServContractHeader."Last Invoice Date" <> 0D) THEN
            IF ServContractLine."Contract Expiration Date" > ServContractHeader."Last Invoice Date" THEN
              NonExpiredContractLineExists := TRUE;
        UNTIL ServContractLine.NEXT = 0;
      IF InvoiceNow AND (NOT NonExpiredContractLineExists) THEN BEGIN
        IF NOT FromServContractHeader.Prepaid THEN
          FromServContractHeader."Last Invoice Date" := InvoiceTo
        ELSE
          FromServContractHeader."Last Invoice Date" := FromServContractHeader."Next Invoice Date";
        FromServContractHeader.MODIFY;
      END;

      FromServContractHeader.GET(ServContractHeader."Contract Type",ServContractHeader."Contract No.");
      FromServContractHeader."Change Status" := FromServContractHeader."Change Status"::Locked;
      FromServContractHeader.MODIFY;

      ServContractLine.RESET;
      ServContractLine.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
      ServContractLine.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
      ServContractLine.MODIFYALL("New Line",FALSE);
      Window.CLOSE;

      IF NOT HideDialog THEN
        IF ServHeaderNo <> '' THEN
          MESSAGE(Text016,ServHeaderNo);
    END;

    [External]
    PROCEDURE SetHideDialog@3(NewHideDialog@1000 : Boolean);
    BEGIN
      HideDialog := NewHideDialog;
    END;

    LOCAL PROCEDURE SetInvoicing@8(ServContractHeader@1000 : Record 5965);
    VAR
      TempDate@1001 : Date;
    BEGIN
      IF ServContractHeader."Invoice Period" = ServContractHeader."Invoice Period"::None THEN
        EXIT;

      IF ServContractHeader.Prepaid THEN BEGIN
        IF ServContractHeader."Starting Date" < ServContractHeader."Next Invoice Date" THEN BEGIN
          IF HideDialog THEN
            InvoiceNow := TRUE
          ELSE
            IF CONFIRM(Text015,TRUE,
                 ServContractHeader."Starting Date",ServContractHeader."Next Invoice Date" - 1)
            THEN
              InvoiceNow := TRUE;
          InvoiceFrom := ServContractHeader."Starting Date";
          InvoiceTo := ServContractHeader."Next Invoice Date" - 1;
        END
      END ELSE BEGIN
        GoOut := TRUE;
        TempDate := ServContractHeader."Next Invoice Period Start";
        IF ServContractHeader."Starting Date" < TempDate THEN BEGIN
          TempDate := TempDate - 1;
          GoOut := FALSE;
        END;
        IF NOT GoOut THEN BEGIN
          IF HideDialog THEN
            InvoiceNow := TRUE
          ELSE
            IF CONFIRM(
                 Text015,TRUE,
                 ServContractHeader."Starting Date",TempDate)
            THEN
              InvoiceNow := TRUE;
          InvoiceFrom := ServContractHeader."Starting Date";
          InvoiceTo := TempDate;
          InvoicingStartingPeriod := TRUE;
        END;
      END;
    END;

    LOCAL PROCEDURE CheckServContractQuote@5(FromServContractHeader@1000 : Record 5965);
    VAR
      ServItem@1001 : Record 5940;
    BEGIN
      FromServContractHeader.TESTFIELD("Serv. Contract Acc. Gr. Code");
      FromServContractHeader.TESTFIELD("Service Period");
      FromServContractHeader.CALCFIELDS("Calcd. Annual Amount");
      IF FromServContractHeader."Calcd. Annual Amount" < 0 THEN
        ERROR(Text019);
      FromServContractHeader.TESTFIELD("Annual Amount",FromServContractHeader."Calcd. Annual Amount");
      ServContractAccGr.GET(FromServContractHeader."Serv. Contract Acc. Gr. Code");
      ServContractAccGr.TESTFIELD("Non-Prepaid Contract Acc.");
      GLAcc.GET(ServContractAccGr."Non-Prepaid Contract Acc.");
      GLAcc.TESTFIELD("Direct Posting");

      IF FromServContractHeader.Prepaid THEN BEGIN
        ServContractAccGr.TESTFIELD("Prepaid Contract Acc.");
        GLAcc.GET(ServContractAccGr."Prepaid Contract Acc.");
        GLAcc.TESTFIELD("Direct Posting");
      END;

      FromServContractLine.RESET;
      FromServContractLine.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
      FromServContractLine.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
      FromServContractLine.SETRANGE("Line Amount",0);
      FromServContractLine.SETFILTER("Line Discount %",'<%1',100);
      IF FromServContractLine.FINDFIRST THEN
        ERROR(
          Text001,
          FromServContractHeader."Contract No.",
          FromServContractLine.FIELDCAPTION("Line Amount"));

      FromServContractHeader.TESTFIELD("Starting Date");
      CheckServContractNonZeroAmounts(FromServContractHeader);

      FromServContractLine.RESET;
      FromServContractLine.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
      FromServContractLine.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
      FromServContractLine.SETFILTER("Service Item No.",'<>%1','');
      IF FromServContractLine.FINDSET THEN
        REPEAT
          ServItem.GET(FromServContractLine."Service Item No.");
          IF ServItem."Customer No." <> FromServContractHeader."Customer No." THEN
            ERROR(
              Text021,
              FromServContractHeader."Contract No.",
              FromServContractHeader."Customer No.");
        UNTIL FromServContractLine.NEXT = 0;

      ServMgtSetup.GET;
      IF ServMgtSetup."Salesperson Mandatory" THEN
        FromServContractHeader.TESTFIELD("Salesperson Code");
      CheckServContractNextInvoiceDate(FromServContractHeader);

      FromServContractLine.RESET;
      FromServContractLine.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
      FromServContractLine.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
      IF FromServContractLine.FINDSET THEN
        REPEAT
          IF ServMgtSetup."Contract Rsp. Time Mandatory" THEN
            FromServContractLine.TESTFIELD("Response Time (Hours)");
        UNTIL FromServContractLine.NEXT = 0;

      ServContractMgt.CopyCheckSCDimToTempSCDim(FromServContractHeader);
    END;

    [External]
    PROCEDURE CheckServContract@14(VAR ServContractHeader@1002 : Record 5965);
    VAR
      ServContractLine@1001 : Record 5964;
    BEGIN
      IF ServContractHeader.Status = ServContractHeader.Status::Signed THEN
        EXIT;
      IF ServContractHeader.Status = ServContractHeader.Status::Canceled THEN
        ERROR(Text024);
      ServContractHeader.TESTFIELD("Serv. Contract Acc. Gr. Code");
      ServContractHeader.TESTFIELD("Service Period");
      ServContractHeader.CALCFIELDS("Calcd. Annual Amount");

      IF ServContractHeader."Annual Amount" <> ServContractHeader."Calcd. Annual Amount" THEN
        ERROR(Text023,ServContractHeader.FIELDCAPTION("Annual Amount"),
          ServContractHeader.FIELDCAPTION("Calcd. Annual Amount"));

      IF ServContractHeader."Annual Amount" < 0 THEN
        ERROR(Text019);
      ServContractAccGr.GET(ServContractHeader."Serv. Contract Acc. Gr. Code");
      ServContractAccGr.TESTFIELD("Non-Prepaid Contract Acc.");
      GLAcc.GET(ServContractAccGr."Non-Prepaid Contract Acc.");
      GLAcc.TESTFIELD("Direct Posting");

      IF ServContractHeader.Prepaid THEN BEGIN
        ServContractAccGr.TESTFIELD("Prepaid Contract Acc.");
        GLAcc.GET(ServContractAccGr."Prepaid Contract Acc.");
        GLAcc.TESTFIELD("Direct Posting");
      END;

      ServContractLine.RESET;
      ServContractLine.SETRANGE("Contract Type",ServContractHeader."Contract Type");
      ServContractLine.SETRANGE("Contract No.",ServContractHeader."Contract No.");
      ServContractLine.SETRANGE("Line Amount",0);
      ServContractLine.SETFILTER("Line Discount %",'<%1',100);
      IF NOT ServContractLine.ISEMPTY THEN
        ERROR(
          Text004,
          ServContractHeader."Contract No.",
          ServContractLine.FIELDCAPTION("Line Amount"));

      ServContractHeader.TESTFIELD("Starting Date");
      CheckServContractNonZeroAmounts(ServContractHeader);

      ServMgtSetup.GET;
      IF ServMgtSetup."Salesperson Mandatory" THEN
        ServContractHeader.TESTFIELD("Salesperson Code");

      CheckServContractNextInvoiceDate(ServContractHeader);

      IF ServMgtSetup."Contract Rsp. Time Mandatory" THEN BEGIN
        ServContractLine.RESET;
        ServContractLine.SETRANGE("Contract Type",ServContractHeader."Contract Type");
        ServContractLine.SETRANGE("Contract No.",ServContractHeader."Contract No.");
        ServContractLine.SETRANGE("Response Time (Hours)",0);
        IF ServContractLine.FINDFIRST THEN
          ServContractLine.FIELDERROR("Response Time (Hours)");
      END;
      ServContractMgt.CopyCheckSCDimToTempSCDim(ServContractHeader);

      IF NOT HideDialog THEN
        CheckServContractNextPlannedServiceDate(ServContractHeader);
    END;

    LOCAL PROCEDURE CheckServContractNextInvoiceDate@22(ServContractHeader@1000 : Record 5965);
    BEGIN
      IF ServContractHeader."Invoice Period" <> ServContractHeader."Invoice Period"::None THEN
        IF ServContractHeader.Prepaid THEN BEGIN
          IF CALCDATE('<-CM>',ServContractHeader."Next Invoice Date") <> ServContractHeader."Next Invoice Date"
          THEN
            ERROR(Text003,ServContractHeader.FIELDCAPTION("Next Invoice Date"));
        END ELSE BEGIN
          IF
             CALCDATE('<CM>',ServContractHeader."Next Invoice Date") <> ServContractHeader."Next Invoice Date"
          THEN
            IF NOT HideDialog THEN
              IF NOT CONFIRM(
                   STRSUBSTNO(
                     Text005,
                     ServContractHeader.FIELDCAPTION("Next Invoice Date")))
              THEN
                EXIT;
        END;
    END;

    LOCAL PROCEDURE CheckServContractNextPlannedServiceDate@28(ServContractHeader@1001 : Record 5965) : Boolean;
    VAR
      ServContractLine@1000 : Record 5964;
    BEGIN
      ServContractLine.RESET;
      ServContractLine.SETRANGE("Contract Type",ServContractHeader."Contract Type");
      ServContractLine.SETRANGE("Contract No.",ServContractHeader."Contract No.");
      ServContractLine.SETRANGE("Next Planned Service Date",0D);
      IF ServContractLine.FINDFIRST THEN
        IF NOT
           CONFIRM(
             Text022,
             TRUE,
             ServContractLine.FIELDCAPTION("Next Planned Service Date"))
        THEN
          EXIT(FALSE);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckServContractNonZeroAmounts@38(ServContractHeader@1000 : Record 5965);
    BEGIN
      IF ServContractHeader."Invoice Period" <> ServContractHeader."Invoice Period"::None THEN BEGIN
        IF ServContractHeader."Annual Amount" = 0 THEN
          ERROR(Text020);
        ServContractHeader.TESTFIELD("Amount per Period");
      END;
    END;

    LOCAL PROCEDURE CreateServiceLinesLedgerEntries@53(VAR ServContractHeader@1000 : Record 5965;NewLine@1004 : Boolean);
    VAR
      ServContractLine@1001 : Record 5964;
    BEGIN
      ServContractMgt.InitCodeUnit;
      ServHeaderNo :=
        ServContractMgt.CreateServHeader(ServContractHeader,PostingDate,FALSE);

      ServHeader.GET(ServHeader."Document Type"::Invoice,ServHeaderNo);
      IF ServContractHeader."Contract Lines on Invoice" THEN BEGIN
        ServContractLine.RESET;
        ServContractLine.SETRANGE("Contract Type",ServContractHeader."Contract Type");
        ServContractLine.SETRANGE("Contract No.",ServContractHeader."Contract No.");
        IF NewLine THEN
          ServContractLine.SETRANGE("New Line",TRUE);
        IF ServContractLine.FINDSET THEN
          REPEAT
            ServContractMgt.CreateDetailedServLine(
              ServHeader,ServContractLine,
              ServContractHeader."Contract Type",
              ServContractHeader."Contract No.");

            AppliedEntry :=
              ServContractMgt.CreateServiceLedgerEntry(
                ServHeader,ServContractHeader."Contract Type",
                ServContractHeader."Contract No.",InvoiceFrom,
                InvoiceTo,NOT NewLine,NewLine,
                ServContractLine."Line No.");

            ServContractMgt.CreateServLine(
              ServHeader,
              ServContractHeader."Contract Type",
              ServContractHeader."Contract No.",
              InvoiceFrom,InvoiceTo,AppliedEntry,NOT NewLine);
          UNTIL ServContractLine.NEXT = 0;
      END ELSE BEGIN
        ServContractMgt.CreateHeadingServLine(
          ServHeader,
          ServContractHeader."Contract Type",
          ServContractHeader."Contract No.");

        AppliedEntry :=
          ServContractMgt.CreateServiceLedgerEntry(
            ServHeader,ServContractHeader."Contract Type",
            ServContractHeader."Contract No.",InvoiceFrom,
            InvoiceTo,NOT NewLine,NewLine,0);

        ServContractMgt.CreateServLine(
          ServHeader,
          ServContractHeader."Contract Type",
          ServContractHeader."Contract No.",
          InvoiceFrom,InvoiceTo,AppliedEntry,NOT NewLine);
      END;

      ServContractHeader.MODIFY;
      ServContractMgt.FinishCodeunit;
    END;

    LOCAL PROCEDURE CopyServComments@6(FromServContractHeader@1000 : Record 5965;ToServContractHeader@1001 : Record 5965);
    VAR
      FromServCommentLine@1003 : Record 5906;
      ToServCommentLine@1002 : Record 5906;
    BEGIN
      FromServCommentLine.SETRANGE("Table Name",FromServCommentLine."Table Name"::"Service Contract");
      FromServCommentLine.SETRANGE("Table Subtype",FromServContractHeader."Contract Type");
      FromServCommentLine.SETRANGE("No.",FromServContractHeader."Contract No.");
      IF FromServCommentLine.FINDSET THEN
        REPEAT
          ToServCommentLine."Table Name" := ToServCommentLine."Table Name"::"Service Contract";
          ToServCommentLine."Table Subtype" := ToServContractHeader."Contract Type"::Contract;
          ToServCommentLine."Table Line No." := FromServCommentLine."Table Line No.";
          ToServCommentLine."No." := ToServContractHeader."Contract No.";
          ToServCommentLine."Line No." := FromServCommentLine."Line No.";
          ToServCommentLine.Comment := FromServCommentLine.Comment;
          ToServCommentLine.Date := FromServCommentLine.Date;
          ToServCommentLine.INSERT;
        UNTIL FromServCommentLine.NEXT = 0;
      FromServCommentLine.DELETEALL;
    END;

    LOCAL PROCEDURE CopyServHours@13(ToServContractHeader@1001 : Record 5965);
    VAR
      FromServHour@1000 : Record 5910;
      ToServHour@1002 : Record 5910;
    BEGIN
      FromServHour.RESET;
      FromServHour.SETRANGE("Service Contract Type",FromServHour."Service Contract Type"::Quote);
      FromServHour.SETRANGE("Service Contract No.",ToServContractHeader."Contract No.");
      IF FromServHour.FINDSET THEN
        REPEAT
          ToServHour := FromServHour;
          ToServHour."Service Contract Type" := FromServHour."Service Contract Type"::Contract;
          ToServHour."Service Contract No." := ToServContractHeader."Contract No.";
          ToServHour.INSERT;
        UNTIL FromServHour.NEXT = 0;

      FromServHour.DELETEALL;
    END;

    LOCAL PROCEDURE CopyContractServDiscounts@10(FromServContractHeader@1001 : Record 5965;ToServContractHeader@1000 : Record 5965);
    VAR
      FromContractServDisc@1003 : Record 5972;
      ToContractServDisc@1002 : Record 5972;
    BEGIN
      FromContractServDisc.RESET;
      FromContractServDisc.SETRANGE("Contract Type",FromServContractHeader."Contract Type");
      FromContractServDisc.SETRANGE("Contract No.",FromServContractHeader."Contract No.");
      IF FromContractServDisc.FINDSET THEN
        REPEAT
          ToContractServDisc.COPY(FromContractServDisc);
          ToContractServDisc."Contract Type" := FromContractServDisc."Contract Type"::Contract;
          ToContractServDisc."Contract No." := ToServContractHeader."Contract No.";
          IF ToContractServDisc.INSERT THEN;
          FromContractServDisc.DELETE;
        UNTIL FromContractServDisc.NEXT = 0;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeSignContract@9(VAR ServiceContractHeader@1000 : Record 5965);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeSignContractQuote@7(VAR ServiceContractHeader@1000 : Record 5965);
    BEGIN
    END;

    BEGIN
    END.
  }
}

