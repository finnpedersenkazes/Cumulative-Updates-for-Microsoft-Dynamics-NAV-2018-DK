OBJECT Codeunit 5940 ServContractManagement
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    TableNo=5965;
    Permissions=TableData 5907=rimd,
                TableData 5908=rimd,
                TableData 5934=rimd,
                TableData 5967=rimd,
                TableData 5969=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1015 : TextConst 'DAN=%1 kan ikke oprettes for servicekontrakten  %2, fordi %3 og %4 ikke er identiske.;ENU=%1 cannot be created for service contract  %2, because %3 and %4 are not equal.';
      Text002@1016 : TextConst 'DAN=Servicekontrakt: %1;ENU=Service Contract: %1';
      Text003@1018 : TextConst 'DAN=Der findes servicekontraktlinjer i:;ENU=Service contract line(s) included in:';
      Text004@1019 : TextConst 'DAN=Der kan ikke oprettes en kreditnota, fordi %1 %2 er efter arbejdsdatoen.;ENU=A credit memo cannot be created, because the %1 %2 is after the work date.';
      Text005@1020 : TextConst 'DAN=%1 %2 blev fjernet;ENU=%1 %2 removed';
      Text006@1021 : TextConst 'DAN=Vil du oprette en servicefaktura for perioden %1 .. %2?;ENU=Do you want to create a service invoice for the period %1 .. %2 ?';
      GlAcc@1003 : Record 15;
      ServMgtSetup@1022 : Record 5911;
      ServLedgEntry@1029 : Record 5907;
      ServLedgEntry2@1030 : Record 5907;
      TempServLedgEntry@1017 : TEMPORARY Record 5907;
      ServLine@1031 : Record 5902;
      ServHeader@1032 : Record 5900;
      ServiceRegister@1060 : Record 5934;
      ServContractAccGr@1000 : Record 5973;
      Salesperson@1924 : Record 13;
      NoSeriesMgt@1038 : Codeunit 396;
      DimMgt@1059 : Codeunit 408;
      NextLine@1041 : Integer;
      PostingDate@1053 : Date;
      WDate@1004 : Date;
      ServLineNo@1055 : Integer;
      NextEntry@1056 : Integer;
      AppliedEntry@1062 : Integer;
      Text007@1064 : TextConst 'DAN=Der kan ikke oprettes en faktura, fordi det fakturabel�b, der skal faktureres for denne periode, er nul.;ENU=Invoice cannot be created because amount to invoice for this invoice period is zero.';
      Text008@1068 : TextConst 'DAN=Kombinationen af de dimensioner, der bliver brugt i %1 %2, er sp�rret. %3;ENU=The combination of dimensions used in %1 %2 is blocked. %3';
      Text009@1066 : TextConst 'DAN=De dimensioner, der bliver brugt i %1 %2, er ugyldige. %3;ENU=The dimensions used in %1 %2 are invalid. %3';
      InvoicingStartingPeriod@1002 : Boolean;
      Text010@1006 : TextConst 'DAN=Du kan ikke oprette en faktura for kontrakt %1, f�r servicen i denne kontrakt er fuldf�rt, fordi afkrydsningsfeltet %2 er markeret.;ENU=You cannot create an invoice for contract %1 before the service under this contract is completed because the %2 check box is selected.';
      Text012@1070 : TextConst 'DAN=Feltet Nyt debitornr. skal udfyldes.;ENU=You must fill in the New Customer No. field.';
      Text013@1007 : TextConst 'DAN=%1 kan ikke oprettes, fordi %2 er for lang. Forkort %3 %4 %5 ved at fjerne %6 tegn.;ENU=%1 cannot be created because the %2 is too long. Please shorten the %3 %4 %5 by removing %6 character(s).';
      TempServLineDescription@1008 : Text[250];
      Text014@1009 : TextConst 'DAN=Der kan ikke oprettes en %1, fordi %2 %3 har tilknyttet mindst �n ikke-bogf�rt %4.;ENU=A %1 cannot be created because %2 %3 has at least one unposted %4 linked to it.';
      Text015@1005 : TextConst '@@@=Location Code SILVER for the existing Service Credit Memo 1001 for Service Contract 1002 differs from the newly calculated Location Code BLUE. Do you want to use the existing Location Code?;DAN=%1 %2 for de eksisterende %3 %4 for %5 %6 er forskellige fra de senest beregnede %1 %7. Vil du bruge den eksisterende %1?;ENU=%1 %2 for the existing %3 %4 for %5 %6 differs from the newly calculated %1 %7. Do you want to use the existing %1?';
      AppliedGLAccount@1001 : Code[20];
      CheckMParts@1050 : Boolean;
      CombinedCurrenciesErr1@1010 : TextConst 'DAN=Kunden %1 har servicekontrakter med forskellige valutakoder %2 og %3, som ikke kan kombineres p� �n faktura.;ENU=Customer %1 has service contracts with different currency codes %2 and %3, which cannot be combined on one invoice.';
      CombinedCurrenciesErr2@1011 : TextConst 'DAN=Begr�ns batchk�rslen af Opret kontraktfakturaer til visse valutakoder, eller fjern markeringen i feltet Kombiner fakturaer p� de p�g�ldende servicekontrakter.;ENU=Limit the Create Contract Invoices batch job to certain currency codes or clear the Combine Invoices field on the involved service contracts.';
      BlankTxt@1012 : TextConst 'DAN=<tom>;ENU=<blank>';
      ErrorSplitErr@1013 : TextConst 'DAN=%1\\%2.;ENU=%1\\%2.';
      AmountType@1014 : ',Amount,DiscAmount,UnitPrice,UnitCost';
      TempServLedgEntriesIsSet@1023 : Boolean;

    [Internal]
    PROCEDURE CreateInvoice@3(ServContractToInvoice@1001 : Record 5965) InvNo@1000 : Code[20];
    VAR
      InvoicedAmount@1002 : Decimal;
      InvoiceFrom@1004 : Date;
      InvoiceTo@1005 : Date;
    BEGIN
      ServContractToInvoice.TESTFIELD("Change Status",ServContractToInvoice."Change Status"::Locked);
      GetNextInvoicePeriod(ServContractToInvoice,InvoiceFrom,InvoiceTo);
      IF ServContractToInvoice.Prepaid THEN
        PostingDate := InvoiceFrom
      ELSE
        PostingDate := InvoiceTo;
      InvoicedAmount := CalcContractAmount(ServContractToInvoice,InvoiceFrom,InvoiceTo);

      IF InvoicedAmount = 0 THEN
        ERROR(Text007);

      InvNo := CreateRemainingPeriodInvoice(ServContractToInvoice);

      IF InvNo = '' THEN
        InvNo := CreateServHeader(ServContractToInvoice,PostingDate,FALSE);

      IF InvoicingStartingPeriod THEN BEGIN
        GetNextInvoicePeriod(ServContractToInvoice,InvoiceFrom,InvoiceTo);
        PostingDate := InvoiceFrom;
        InvoicedAmount := CalcContractAmount(ServContractToInvoice,InvoiceFrom,InvoiceTo);
      END;

      IF NOT CheckIfServiceExist(ServContractToInvoice) THEN
        ERROR(
          Text010,
          ServContractToInvoice."Contract No.",
          ServContractToInvoice.FIELDCAPTION("Invoice after Service"));

      CreateAllServLines(InvNo,ServContractToInvoice);
    END;

    [Internal]
    PROCEDURE CreateServiceLedgerEntry@4(ServHeader2@1001 : Record 5900;ContractType@1020 : Integer;ContractNo@1002 : Code[20];InvFrom@1003 : Date;InvTo@1004 : Date;SigningContract@1023 : Boolean;AddingNewLines@1012 : Boolean;LineNo@1018 : Integer) ReturnLedgerEntry@1000 : Integer;
    VAR
      ServContractLine@1022 : Record 5964;
      ServContractHeader@1021 : Record 5965;
      Currency@1026 : Record 4;
      LastEntry@1007 : Integer;
      FirstLineEntry@1008 : Integer;
      NoOfPayments@1015 : Integer;
      DueDate@1017 : Date;
      Days@1019 : Integer;
      InvTo2@1025 : Date;
      LineInvFrom@1102601000 : Date;
      PartInvFrom@1033 : Date;
      PartInvTo@1034 : Date;
      NewInvFrom@1024 : Date;
      NextInvDate@1027 : Date;
      ProcessSigningSLECreation@1006 : Boolean;
      NonDistrAmount@1011 : ARRAY [4] OF Decimal;
      InvAmount@1016 : ARRAY [4] OF Decimal;
      InvRoundedAmount@1028 : ARRAY [4] OF Decimal;
      CountOfEntryLoop@1010 : Integer;
      YearContractCorrection@1074 : Boolean;
      ServiceContractHeaderFound@1009 : Boolean;
    BEGIN
      ServiceContractHeaderFound := ServContractHeader.GET(ContractType,ContractNo);
      IF NOT ServiceContractHeaderFound OR (ServContractHeader."Invoice Period" = ServContractHeader."Invoice Period"::None) THEN
        EXIT;

      ServContractHeader.CALCFIELDS("Calcd. Annual Amount");
      CheckServiceContractHeaderAmts(ServContractHeader);
      Currency.InitRoundingPrecision;
      ReturnLedgerEntry := NextEntry;
      CLEAR(ServLedgEntry);
      InitServLedgEntry(ServLedgEntry,ServContractHeader,ServHeader2."No.");
      CLEAR(NonDistrAmount);
      CLEAR(InvAmount);
      CLEAR(InvRoundedAmount);

      IF ServContractHeader.Prepaid AND NOT SigningContract THEN BEGIN
        ServLedgEntry."Moved from Prepaid Acc." := FALSE;
        FirstLineEntry := NextEntry;
        FilterServContractLine(
          ServContractLine,ServContractHeader."Contract No.",ServContractHeader."Contract Type",LineNo);
        IF AddingNewLines THEN
          ServContractLine.SETRANGE("New Line",TRUE)
        ELSE
          ServContractLine.SETFILTER("Starting Date",'<=%1|%2..%3',ServContractHeader."Next Invoice Date",
            ServContractHeader."Next Invoice Period Start",ServContractHeader."Next Invoice Period End");
        IF ServContractLine.FIND('-') THEN BEGIN
          REPEAT
            YearContractCorrection := FALSE;
            Days := 0;
            WDate := CALCDATE('<-CM>',InvFrom);
            IF (InvFrom <= ServContractLine."Contract Expiration Date") OR
               (ServContractLine."Contract Expiration Date" = 0D)
            THEN BEGIN
              NoOfPayments := 0;
              REPEAT
                NoOfPayments := NoOfPayments + 1;
                WDate := CALCDATE('<1M>',WDate);
              UNTIL (WDate >= InvTo) OR
                    ((WDate > ServContractLine."Contract Expiration Date") AND
                     (ServContractLine."Contract Expiration Date" <> 0D));
              CountOfEntryLoop := NoOfPayments;

              // Partial period ranged by "Starting Date" and end of month. Full period is shifted by one month
              IF ServContractLine."Starting Date" > InvFrom THEN BEGIN
                Days := CALCDATE('<CM>',InvFrom) - ServContractLine."Starting Date";
                PartInvFrom := ServContractLine."Starting Date";
                PartInvTo := CALCDATE('<CM>',InvFrom);
                InvFrom := PartInvFrom;
                NewInvFrom := CALCDATE('<CM+1D>',InvFrom);
                CountOfEntryLoop := CountOfEntryLoop - 1;
                NoOfPayments := NoOfPayments - 1;
              END;

              IF ServContractLine."Contract Expiration Date" <> 0D THEN
                IF CALCDATE('<1D>',ServContractLine."Contract Expiration Date") < WDate THEN
                  IF Days = 0 THEN BEGIN
                    Days := DATE2DMY(ServContractLine."Contract Expiration Date",1);
                    CountOfEntryLoop := CountOfEntryLoop - 1;
                    PartInvFrom := CALCDATE('<-CM>',ServContractLine."Contract Expiration Date");
                    PartInvTo := ServContractLine."Contract Expiration Date";
                  END ELSE
                    IF ServContractLine."Contract Expiration Date" < PartInvTo THEN BEGIN
                      // partial period ranged by "Starting Date" from the beginning and "Contract Expiration Date" from the end
                      PartInvTo := ServContractLine."Contract Expiration Date";
                      Days := PartInvTo - PartInvFrom;
                      CountOfEntryLoop := 0;
                    END ELSE BEGIN
                      // Post previous partial period before new one with Contract Expiration Date
                      PostPartialServLedgEntry(
                        InvRoundedAmount,ServContractLine,ServHeader2,PartInvFrom,PartInvTo,
                        ServContractHeader."Next Invoice Date",Currency."Amount Rounding Precision");
                      Days := DATE2DMY(ServContractLine."Contract Expiration Date",1);
                      CountOfEntryLoop := CountOfEntryLoop - 1;
                      NoOfPayments := NoOfPayments - 1;
                      PartInvFrom := CALCDATE('<-CM>',ServContractLine."Contract Expiration Date");
                      PartInvTo := ServContractLine."Contract Expiration Date";
                    END;

              WDate := InvTo;
              IF (WDate > ServContractLine."Contract Expiration Date") AND
                 (ServContractLine."Contract Expiration Date" <> 0D)
              THEN
                WDate := ServContractLine."Contract Expiration Date";

              DueDate := WDate;
              // Calculate invoice amount for initial period and go ahead with shifted InvFrom
              CalcInvAmounts(InvAmount,ServContractLine,InvFrom,WDate);
              IF NewInvFrom = 0D THEN
                NextInvDate := ServContractHeader."Next Invoice Date"
              ELSE BEGIN
                InvFrom := NewInvFrom;
                NextInvDate := CALCDATE('<1M>',ServContractHeader."Next Invoice Date");
              END;

              InsertMultipleServLedgEntries(
                NoOfPayments,DueDate,NonDistrAmount,InvRoundedAmount,ServHeader2,InvFrom,NextInvDate,
                AddingNewLines,CountOfEntryLoop,ServContractLine,Currency."Amount Rounding Precision");
              IF Days = 0 THEN
                YearContractCorrection := FALSE
              ELSE
                YearContractCorrection :=
                  PostPartialServLedgEntry(
                    InvRoundedAmount,ServContractLine,ServHeader2,
                    PartInvFrom,PartInvTo,PartInvFrom,Currency."Amount Rounding Precision");
              LastEntry := ServLedgEntry."Entry No.";
              CalcInvoicedToDate(ServContractLine,InvFrom,InvTo);
              ServContractLine.MODIFY;
            END ELSE BEGIN
              YearContractCorrection := FALSE;
              ReturnLedgerEntry := 0;
            END;
          UNTIL ServContractLine.NEXT = 0;
          UpdateApplyUntilEntryNoInServLedgEntry(ReturnLedgerEntry,FirstLineEntry,LastEntry);
        END;
      END ELSE BEGIN
        YearContractCorrection := FALSE;
        ServLedgEntry."Moved from Prepaid Acc." := TRUE;
        ServLedgEntry."Posting Date" := ServHeader2."Posting Date";
        FilterServContractLine(
          ServContractLine,ServContractHeader."Contract No.",ServContractHeader."Contract Type",LineNo);
        IF AddingNewLines THEN
          ServContractLine.SETRANGE("New Line",TRUE)
        ELSE
          IF NOT SigningContract THEN BEGIN
            IF ServContractHeader."Last Invoice Date" <> 0D THEN
              ServContractLine.SETFILTER("Invoiced to Date",'%1|%2',ServContractHeader."Last Invoice Date",0D)
            ELSE
              ServContractLine.SETRANGE("Invoiced to Date",0D);
            ServContractLine.SETFILTER("Starting Date",'<=%1|%2..%3',InvFrom,
              ServContractHeader."Next Invoice Period Start",ServContractHeader."Next Invoice Period End");
          END ELSE
            ServContractLine.SETFILTER("Starting Date",'<=%1',InvTo);
        FirstLineEntry := NextEntry;
        InvTo2 := InvTo;
        IF ServContractLine.FIND('-') THEN BEGIN
          REPEAT
            IF SigningContract THEN BEGIN
              IF ServContractLine."Invoiced to Date" = 0D THEN
                ProcessSigningSLECreation := TRUE
              ELSE
                IF (ServContractLine."Invoiced to Date" <> 0D) AND
                   (ServContractLine."Invoiced to Date" <> CALCDATE('<CM>',ServContractLine."Invoiced to Date"))
                THEN
                  ProcessSigningSLECreation := TRUE
            END ELSE
              ProcessSigningSLECreation := TRUE;
            IF ((InvFrom <= ServContractLine."Contract Expiration Date") OR
                (ServContractLine."Contract Expiration Date" = 0D)) AND ProcessSigningSLECreation
            THEN BEGIN
              IF (ServContractLine."Contract Expiration Date" >= InvFrom) AND
                 (ServContractLine."Contract Expiration Date" < InvTo)
              THEN
                InvTo := ServContractLine."Contract Expiration Date";
              ServLedgEntry."Service Item No. (Serviced)" := ServContractLine."Service Item No.";
              ServLedgEntry."Item No. (Serviced)" := ServContractLine."Item No.";
              ServLedgEntry."Serial No. (Serviced)" := ServContractLine."Serial No.";
              LineInvFrom := CountLineInvFrom(SigningContract,ServContractLine,InvFrom);
              IF (LineInvFrom <> 0D) AND (LineInvFrom <= InvTo) THEN BEGIN
                SetServLedgEntryAmounts(
                  ServLedgEntry,InvRoundedAmount,
                  -CalcContractLineAmount(ServContractLine."Line Amount",LineInvFrom,InvTo),
                  -CalcContractLineAmount(ServContractLine."Line Value",LineInvFrom,InvTo),
                  CalcContractLineAmount(ServContractLine."Line Cost",LineInvFrom,InvTo),
                  CalcContractLineAmount(ServContractLine."Line Discount Amount",LineInvFrom,InvTo),
                  Currency."Amount Rounding Precision");
                ServLedgEntry."Cost Amount" := ServLedgEntry."Unit Cost" * ServLedgEntry."Charged Qty.";
                UpdateServLedgEntryAmount(ServLedgEntry,ServHeader2);
                ServLedgEntry."Entry No." := NextEntry;
                CalcInvAmounts(InvAmount,ServContractLine,LineInvFrom,InvTo);
                ServLedgEntry.INSERT;

                LastEntry := ServLedgEntry."Entry No.";
                NextEntry := NextEntry + 1;
                InvTo := InvTo2;
              END ELSE
                ReturnLedgerEntry := 0;
              CalcInvoicedToDate(ServContractLine,InvFrom,InvTo);
              ServContractLine.MODIFY;
            END ELSE
              ReturnLedgerEntry := 0;
          UNTIL ServContractLine.NEXT = 0;
          UpdateApplyUntilEntryNoInServLedgEntry(ReturnLedgerEntry,FirstLineEntry,LastEntry);
        END;
      END;
      IF ServLedgEntry.GET(LastEntry) AND (NOT YearContractCorrection)
      THEN BEGIN
        ServLedgEntry."Amount (LCY)" := ServLedgEntry."Amount (LCY)" + InvRoundedAmount[AmountType::Amount] -
          ROUND(InvAmount[AmountType::Amount],Currency."Amount Rounding Precision");
        ServLedgEntry."Unit Price" := ServLedgEntry."Unit Price" + InvRoundedAmount[AmountType::UnitPrice] -
          ROUND(InvAmount[AmountType::UnitPrice],Currency."Unit-Amount Rounding Precision");
        ServLedgEntry."Cost Amount" := ServLedgEntry."Cost Amount" + InvRoundedAmount[AmountType::UnitCost] -
          ROUND(InvAmount[AmountType::UnitCost],Currency."Amount Rounding Precision");
        SetServiceLedgerEntryUnitCost(ServLedgEntry);
        ServLedgEntry."Contract Disc. Amount" :=
          ServLedgEntry."Contract Disc. Amount" - InvRoundedAmount[AmountType::DiscAmount] +
          ROUND(InvAmount[AmountType::DiscAmount],Currency."Amount Rounding Precision");
        ServLedgEntry."Discount Amount" := ServLedgEntry."Contract Disc. Amount";
        CalcServLedgEntryDiscountPct(ServLedgEntry);
        UpdateServLedgEntryAmount(ServLedgEntry,ServHeader2);
        ServLedgEntry.MODIFY;
      END;
    END;

    LOCAL PROCEDURE CalcServLedgEntryDiscountPct@33(VAR ServiceLedgerEntry@1000 : Record 5907);
    BEGIN
      ServiceLedgerEntry."Discount %" := 0;
      IF ServiceLedgerEntry."Unit Price" <> 0 THEN
        ServiceLedgerEntry."Discount %" :=
          -ROUND(ServiceLedgerEntry."Discount Amount" / ServiceLedgerEntry."Unit Price" * 100,0.00001);
    END;

    [Internal]
    PROCEDURE CreateServHeader@5(ServContract2@1001 : Record 5965;PostDate@1003 : Date;ContractExists@1009 : Boolean) ServInvNo@1000 : Code[20];
    VAR
      ServHeader2@1005 : Record 5900;
      Cust@1006 : Record 18;
      ServDocReg@1007 : Record 5936;
      CurrExchRate@1008 : Record 330;
      GLSetup@1102601001 : Record 98;
      Cust2@1102601002 : Record 18;
      UserMgt@1102601000 : Codeunit 5700;
      RecordLinkManagement@1002 : Codeunit 447;
    BEGIN
      IF ServContract2."Invoice Period" = ServContract2."Invoice Period"::None THEN
        EXIT;

      IF PostDate = 0D THEN
        PostDate := WORKDATE;

      CLEAR(ServHeader2);
      ServHeader2.INIT;
      ServHeader2.SetHideValidationDialog(TRUE);
      ServHeader2."Document Type" := ServHeader2."Document Type"::Invoice;
      ServMgtSetup.GET ;
      ServMgtSetup.TESTFIELD("Contract Invoice Nos.");
      NoSeriesMgt.InitSeries(
        ServMgtSetup."Contract Invoice Nos.",'',
        PostDate,ServHeader2."No.",ServHeader2."No. Series");
      ServHeader2.INSERT(TRUE);
      ServInvNo := ServHeader2."No.";

      ServHeader2."Order Date" := WORKDATE;
      ServHeader2."Posting Description" :=
        FORMAT(ServHeader2."Document Type") + ' ' + ServHeader2."No.";
      ServHeader2.VALIDATE("Bill-to Customer No.",ServContract2."Bill-to Customer No.");
      ServHeader2."Prices Including VAT" := FALSE;
      ServHeader2."Customer No." := ServContract2."Customer No.";
      ServHeader2.VALIDATE("Ship-to Code",ServContract2."Ship-to Code");
      Cust.GET(ServHeader2."Customer No.");
      ServHeader2."Responsibility Center" := ServContract2."Responsibility Center";

      Cust.CheckBlockedCustOnDocs(Cust,ServHeader2."Document Type",FALSE,FALSE);

      Cust.TESTFIELD("Gen. Bus. Posting Group");
      ServHeader2.Name := Cust.Name;
      ServHeader2."Name 2" := Cust."Name 2";
      ServHeader2.Address := Cust.Address;
      ServHeader2."Address 2" := Cust."Address 2";
      ServHeader2.City := Cust.City;
      ServHeader2."Post Code" := Cust."Post Code";
      ServHeader2.County := Cust.County;
      ServHeader2."Country/Region Code" := Cust."Country/Region Code";
      ServHeader2."Contact Name" := ServContract2."Contact Name";
      ServHeader2."Contact No." := ServContract2."Contact No.";
      ServHeader2."Bill-to Contact No." := ServContract2."Bill-to Contact No.";
      ServHeader2."Bill-to Contact" := ServContract2."Bill-to Contact";

      IF NOT ContractExists THEN
        IF ServHeader2."Customer No." = ServContract2."Customer No." THEN
          ServHeader2.VALIDATE("Ship-to Code",ServContract2."Ship-to Code");
      ServHeader2.VALIDATE("Posting Date",PostDate);
      ServHeader2.VALIDATE("Document Date",PostDate);
      ServHeader2."Contract No." := ServContract2."Contract No.";
      ServHeader2."Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
      GLSetup.GET;
      IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." THEN BEGIN
        Cust2.GET(ServContract2."Bill-to Customer No.");
        ServHeader2."VAT Bus. Posting Group" := Cust2."VAT Bus. Posting Group";
      END ELSE
        ServHeader2."VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
      ServHeader2."Currency Code" := ServContract2."Currency Code";
      ServHeader2."Currency Factor" :=
        CurrExchRate.ExchangeRate(
          ServHeader2."Posting Date",ServHeader2."Currency Code");
      ServHeader2.VALIDATE("Payment Terms Code",ServContract2."Payment Terms Code");
      ServHeader2."Your Reference" := ServContract2."Your Reference";
      SetSalespersonCode(ServContract2."Salesperson Code",ServHeader2."Salesperson Code");
      ServHeader2."Shortcut Dimension 1 Code" := ServContract2."Shortcut Dimension 1 Code";
      ServHeader2."Shortcut Dimension 2 Code" := ServContract2."Shortcut Dimension 2 Code";
      ServHeader2."Dimension Set ID" := ServContract2."Dimension Set ID";
      ServHeader2.VALIDATE("Location Code",
        UserMgt.GetLocation(2,Cust."Location Code",ServContract2."Responsibility Center"));
      ServHeader2.MODIFY;
      RecordLinkManagement.CopyLinks(ServContract2,ServHeader2);

      CLEAR(ServDocReg);
      ServDocReg.InsertServSalesDocument(
        ServDocReg."Source Document Type"::Contract,
        ServContract2."Contract No.",
        ServDocReg."Destination Document Type"::Invoice,
        ServHeader2."No.");
    END;

    [Internal]
    PROCEDURE CreateServLine@9(ServHeader@1000 : Record 5900;ContractType@1010 : Integer;ContractNo@1001 : Code[20];InvFrom@1002 : Date;InvTo@1003 : Date;ServiceApplyEntry@1005 : Integer;SignningContract@1011 : Boolean);
    VAR
      ServContractHeader@1009 : Record 5965;
      ServDocReg@1008 : Record 5936;
      ServiceLedgerEntry@1012 : Record 5907;
      TotalServLine@1004 : Record 5902;
      TotalServLineLCY@1006 : Record 5902;
    BEGIN
      ServContractHeader.GET(ContractType,ContractNo);
      IF ServContractHeader."Invoice Period" = ServContractHeader."Invoice Period"::None THEN
        EXIT;
      ServLineNo := 0;
      ServLine.RESET;
      ServLine.SETRANGE("Document Type",ServLine."Document Type"::Invoice);
      ServLine.SETRANGE("Document No.",ServHeader."No.");
      IF ServLine.FINDLAST THEN
        ServLineNo := ServLine."Line No.";

      IF ServContractHeader.Prepaid AND NOT SignningContract THEN BEGIN
        ServContractHeader.TESTFIELD("Serv. Contract Acc. Gr. Code");
        ServContractAccGr.GET(ServContractHeader."Serv. Contract Acc. Gr. Code");
        ServContractAccGr.TESTFIELD("Prepaid Contract Acc.");
        GlAcc.GET(ServContractAccGr."Prepaid Contract Acc.");
        GlAcc.TESTFIELD("Direct Posting");
      END ELSE BEGIN
        ServContractHeader.TESTFIELD("Serv. Contract Acc. Gr. Code");
        ServContractAccGr.GET(ServContractHeader."Serv. Contract Acc. Gr. Code");
        ServContractAccGr.TESTFIELD("Non-Prepaid Contract Acc.");
        GlAcc.GET(ServContractAccGr."Non-Prepaid Contract Acc.");
        GlAcc.TESTFIELD("Direct Posting");
      END;
      AppliedGLAccount := GlAcc."No.";

      IF ServiceLedgerEntry.GET(ServiceApplyEntry) THEN BEGIN
        ServiceLedgerEntry.SETRANGE("Entry No.",ServiceApplyEntry,ServiceLedgerEntry."Apply Until Entry No.");
        IF ServiceLedgerEntry.FINDSET THEN
          REPEAT
            IF ServiceLedgerEntry.Prepaid THEN BEGIN
              InvFrom := ServiceLedgerEntry."Posting Date";
              InvTo := CALCDATE('<CM>',InvFrom);
            END;
            ServLedgEntryToServiceLine(
              TotalServLine,
              TotalServLineLCY,
              ServHeader,
              ServiceLedgerEntry,
              ContractNo,
              InvFrom,
              InvTo);
          UNTIL ServiceLedgerEntry.NEXT = 0
      END ELSE BEGIN
        CLEAR(ServiceLedgerEntry);
        ServLedgEntryToServiceLine(
          TotalServLine,
          TotalServLineLCY,
          ServHeader,
          ServiceLedgerEntry,
          ContractNo,
          InvFrom,
          InvTo);
      END;

      CLEAR(ServDocReg);
      ServDocReg.InsertServSalesDocument(
        ServDocReg."Source Document Type"::Contract,
        ContractNo,
        ServDocReg."Destination Document Type"::Invoice,
        ServLine."Document No.");
    END;

    [External]
    PROCEDURE CreateDetailedServLine@11(ServHeader@1000 : Record 5900;ServContractLine@1002 : Record 5964;ContractType@1008 : Integer;ContractNo@1001 : Code[20]);
    VAR
      ServContractHeader@1006 : Record 5965;
      Cust@1003 : Record 18;
      StdText@1004 : Record 7;
      FirstLine@1009 : Boolean;
      NewContract@1010 : Boolean;
    BEGIN
      ServContractHeader.GET(ContractType,ContractNo);
      IF ServContractHeader."Invoice Period" = ServContractHeader."Invoice Period"::None THEN
        EXIT;

      ServLineNo := 0;
      ServLine.SETRANGE("Document Type",ServLine."Document Type"::Invoice);
      ServLine.SETRANGE("Document No.",ServHeader."No.");
      IF ServLine.FINDLAST THEN BEGIN
        ServLineNo := ServLine."Line No.";
        NewContract := ServLine."Contract No." <> ServContractHeader."Contract No.";
        ServLine.INIT;
      END ELSE BEGIN
        FirstLine := TRUE;
        NewContract := TRUE;
      END;

      Cust.GET(ServContractHeader."Bill-to Customer No.");
      ServLine.RESET;

      IF FirstLine OR NewContract THEN
        ServMgtSetup.GET;

      IF FirstLine THEN BEGIN
        ServLine.INIT;
        ServLineNo := ServLineNo + 10000;
        ServLine."Document Type" := ServHeader."Document Type";
        ServLine."Document No." := ServHeader."No.";
        ServLine."Line No." := ServLineNo;
        ServLine.Type := ServLine.Type::" ";
        IF ServMgtSetup."Contract Line Inv. Text Code" <> '' THEN BEGIN
          StdText.GET(ServMgtSetup."Contract Line Inv. Text Code");
          ServLine.Description := StdText.Description;
        END ELSE
          ServLine.Description := Text003;
        ServLine.INSERT;
      END;

      IF NewContract THEN BEGIN
        ServLine.INIT;
        ServLineNo := ServLineNo + 10000;
        ServLine."Document Type" := ServHeader."Document Type";
        ServLine."Document No." := ServHeader."No.";
        ServLine."Line No." := ServLineNo;
        ServLine.Type := ServLine.Type::" ";
        IF ServMgtSetup."Contract Inv. Line Text Code" <> '' THEN BEGIN
          StdText.GET(ServMgtSetup."Contract Inv. Line Text Code");
          TempServLineDescription := STRSUBSTNO('%1 %2',StdText.Description,ServContractHeader."Contract No.");
          IF STRLEN(TempServLineDescription) > MAXSTRLEN(ServLine.Description) THEN
            ERROR(
              Text013,
              ServLine.TABLECAPTION,ServLine.FIELDCAPTION(Description),
              StdText.TABLECAPTION,StdText.Code,StdText.FIELDCAPTION(Description),
              FORMAT(STRLEN(TempServLineDescription) - MAXSTRLEN(ServLine.Description)));
          ServLine.Description := COPYSTR(TempServLineDescription,1,MAXSTRLEN(ServLine.Description));
        END ELSE
          ServLine.Description := STRSUBSTNO(Text002,ServContractHeader."Contract No.");
        ServLine.INSERT;
      END;

      CreateDescriptionServiceLines(ServContractLine."Service Item No.",ServContractLine.Description);
    END;

    LOCAL PROCEDURE CreateLastServLines@14(ServHeader@1000 : Record 5900;ContractType@1005 : Integer;ContractNo@1001 : Code[20]);
    VAR
      ServContractHeader@1006 : Record 5965;
      StdText@1002 : Record 7;
      Cust@1003 : Record 18;
      TransferExtendedText@1004 : Codeunit 378;
    BEGIN
      ServContractHeader.GET(ContractType,ContractNo);
      IF ServContractHeader."Invoice Period" = ServContractHeader."Invoice Period"::None THEN
        EXIT;

      Cust.GET(ServContractHeader."Bill-to Customer No.");
      IF ServContractHeader."Print Increase Text" THEN
        IF ServContractHeader."Price Inv. Increase Code" <> '' THEN
          IF StdText.GET(ServContractHeader."Price Inv. Increase Code") THEN BEGIN
            ServLine.INIT;
            ServLine."Document Type" := ServHeader."Document Type";
            ServLine."Document No." := ServHeader."No.";
            ServLine.Type := ServLine.Type::" ";
            ServLine."No." := ServContractHeader."Price Inv. Increase Code";
            ServLine."Contract No." := ContractNo;
            ServLine.Description := StdText.Description;
            IF ServLine.Description <> '' THEN BEGIN
              ServLineNo := ServLineNo + 10000;
              ServLine."Line No." := ServLineNo;
              ServLine.INSERT;
              IF TransferExtendedText.ServCheckIfAnyExtText(ServLine,TRUE) THEN
                TransferExtendedText.InsertServExtText(ServLine);
              IF TransferExtendedText.MakeUpdate THEN;
              ServLine."No." := '';
              ServLine.MODIFY;
            END;
          END;
    END;

    LOCAL PROCEDURE CreateOrGetCreditHeader@15(ServContract@1001 : Record 5965;CrMemoDate@1007 : Date) ServInvoiceNo@1000 : Code[20];
    VAR
      GLSetup@1002 : Record 98;
      ServHeader2@1003 : Record 5900;
      Cust@1004 : Record 18;
      ServDocReg@1005 : Record 5936;
      CurrExchRate@1006 : Record 330;
      UserMgt@1008 : Codeunit 5700;
      CreditMemoForm@1102601000 : Page 5935;
      ServContractForm@1102601001 : Page 6050;
      LocationCode@1102601003 : Code[10];
    BEGIN
      CLEAR(ServHeader2);
      ServDocReg.RESET;
      ServDocReg.SETRANGE("Source Document Type",ServDocReg."Source Document Type"::Contract);
      ServDocReg.SETRANGE("Source Document No.",ServContract."Contract No.");
      ServDocReg.SETRANGE("Destination Document Type",ServDocReg."Destination Document Type"::"Credit Memo");
      ServInvoiceNo := '';
      IF ServDocReg.FIND('-') THEN
        REPEAT
          ServInvoiceNo := ServDocReg."Destination Document No.";
        UNTIL (ServDocReg.NEXT = 0) OR (ServDocReg."Destination Document No." <> '');

      IF ServInvoiceNo <> '' THEN BEGIN
        ServHeader2.GET(ServHeader2."Document Type"::"Credit Memo",ServInvoiceNo);
        Cust.GET(ServHeader2."Bill-to Customer No.");
        LocationCode := UserMgt.GetLocation(2,Cust."Location Code",ServContract."Responsibility Center");
        IF ServHeader2."Location Code" <> LocationCode THEN
          IF NOT CONFIRM(
               STRSUBSTNO(
                 Text015,
                 ServHeader2.FIELDCAPTION("Location Code"),
                 ServHeader2."Location Code",
                 CreditMemoForm.CAPTION,
                 ServInvoiceNo,
                 ServContractForm.CAPTION,
                 ServContract."Contract No.",
                 LocationCode))
          THEN
            ERROR('');
        EXIT;
      END;

      CLEAR(ServHeader2);
      ServHeader2.INIT;
      ServHeader2.SetHideValidationDialog(TRUE);
      ServHeader2."Document Type" := ServHeader2."Document Type"::"Credit Memo";
      ServMgtSetup.GET ;
      ServMgtSetup.TESTFIELD("Contract Credit Memo Nos.");
      NoSeriesMgt.InitSeries(
        ServMgtSetup."Contract Credit Memo Nos.",ServHeader2."No. Series",0D,
        ServHeader2."No.",ServHeader2."No. Series");
      ServHeader2.INSERT(TRUE);
      ServInvoiceNo := ServHeader2."No.";

      GLSetup.GET;
      ServHeader2.Correction := GLSetup."Mark Cr. Memos as Corrections";
      ServHeader2."Posting Description" := FORMAT(ServHeader2."Document Type") + ' ' + ServHeader2."No.";
      ServHeader2.VALIDATE("Bill-to Customer No.",ServContract."Bill-to Customer No.");
      ServHeader2."Prices Including VAT" := FALSE;
      ServHeader2."Customer No." := ServContract."Customer No.";
      ServHeader2."Responsibility Center" := ServContract."Responsibility Center";
      Cust.GET(ServHeader2."Customer No.");
      Cust.CheckBlockedCustOnDocs(Cust,ServHeader2."Document Type",FALSE,FALSE);
      Cust.TESTFIELD("Gen. Bus. Posting Group");
      ServHeader2.Name := Cust.Name;
      ServHeader2."Name 2" := Cust."Name 2";
      ServHeader2.Address := Cust.Address;
      ServHeader2."Address 2" := Cust."Address 2";
      ServHeader2.City := Cust.City;
      ServHeader2."Post Code" := Cust."Post Code";
      ServHeader2.County := Cust.County;
      ServHeader2."Country/Region Code" := Cust."Country/Region Code";
      ServHeader2."Contact Name" := ServContract."Contact Name";
      ServHeader2."Contact No." := ServContract."Contact No.";
      ServHeader2."Bill-to Contact No." := ServContract."Bill-to Contact No.";
      ServHeader2."Bill-to Contact" := ServContract."Bill-to Contact";
      ServHeader2."Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
      IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Sell-to/Buy-from No." THEN
        ServHeader2."VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
      ServHeader2.VALIDATE("Ship-to Code",ServContract."Ship-to Code");
      IF CrMemoDate <> 0D THEN
        ServHeader2.VALIDATE("Posting Date",CrMemoDate)
      ELSE
        ServHeader2.VALIDATE("Posting Date",WORKDATE);
      ServHeader2."Contract No." := ServContract."Contract No.";
      ServHeader2."Currency Code" := ServContract."Currency Code";
      ServHeader2."Currency Factor" :=
        CurrExchRate.ExchangeRate(
          ServHeader2."Posting Date",ServHeader2."Currency Code");
      ServHeader2."Payment Terms Code" := ServContract."Payment Terms Code";
      ServHeader2."Your Reference" := ServContract."Your Reference";
      ServHeader2."Salesperson Code" := ServContract."Salesperson Code";
      ServHeader2."Shortcut Dimension 1 Code" := ServContract."Shortcut Dimension 1 Code";
      ServHeader2."Shortcut Dimension 2 Code" := ServContract."Shortcut Dimension 2 Code";
      ServHeader2."Dimension Set ID" := ServContract."Dimension Set ID";
      ServHeader2.VALIDATE("Location Code",
        UserMgt.GetLocation(2,Cust."Location Code",ServContract."Responsibility Center"));
      ServHeader2.MODIFY;

      CLEAR(ServDocReg);
      ServDocReg.InsertServSalesDocument(
        ServDocReg."Source Document Type"::Contract,
        ServContract."Contract No.",
        ServDocReg."Destination Document Type"::"Credit Memo",
        ServHeader2."No.");
    END;

    LOCAL PROCEDURE CreateCreditLine@16(CreditNo@1000 : Code[20];AccountNo@1001 : Code[20];CreditAmount@1002 : Decimal;PeriodStarts@1003 : Date;PeriodEnds@1004 : Date;LineDescription@1005 : Text[50];ServItemNo@1010 : Code[20];ServContract@1009 : Record 5965;CreditCost@1011 : Decimal;CreditUnitPrice@1012 : Decimal;DiscAmount@1013 : Decimal;ApplyDiscAmt@1014 : Boolean;ServLedgEntryNo@1015 : Integer);
    VAR
      ServHeader2@1006 : Record 5900;
      ServLine2@1007 : Record 5902;
      Cust@1008 : Record 18;
    BEGIN
      ServHeader2.GET(ServHeader2."Document Type"::"Credit Memo",CreditNo);
      Cust.GET(ServHeader2."Bill-to Customer No.");

      CLEAR(ServLine2);
      ServLine2.SETRANGE("Document Type",ServHeader2."Document Type");
      ServLine2.SETRANGE("Document No.",CreditNo);
      IF ServLine2.FINDLAST THEN
        NextLine := ServLine2."Line No." + 10000
      ELSE
        NextLine := 10000;
      CLEAR(ServLine2);
      ServLine2.INIT;
      ServLine2."Document Type" := ServHeader2."Document Type";
      ServLine2."Document No." := ServHeader2."No.";
      ServLine2.Type := ServLine2.Type::" ";
      ServLine2.Description := STRSUBSTNO('%1 - %2',FORMAT(PeriodStarts),FORMAT(PeriodEnds));
      ServLine2."Line No." := NextLine;
      ServLine2."Posting Date" := PeriodStarts;
      ServLine2.INSERT;

      NextLine := NextLine + 10000;
      ServLine2."Customer No." := ServHeader2."Customer No.";
      ServLine2."Location Code" := ServHeader2."Location Code";
      ServLine2."Shortcut Dimension 1 Code" := ServHeader2."Shortcut Dimension 1 Code";
      ServLine2."Shortcut Dimension 2 Code" := ServHeader2."Shortcut Dimension 2 Code";
      ServLine2."Dimension Set ID" := ServHeader2."Dimension Set ID";
      ServLine2."Gen. Bus. Posting Group" := ServHeader2."Gen. Bus. Posting Group";
      ServLine2."Transaction Specification" := ServHeader2."Transaction Specification";
      ServLine2."Transport Method" := ServHeader2."Transport Method";
      ServLine2."Exit Point" := ServHeader2."Exit Point";
      ServLine2.Area := ServHeader2.Area;
      ServLine2."Transaction Specification" := ServHeader2."Transaction Specification";
      ServLine2."Line No." := NextLine;
      ServLine2.Type := ServLine.Type::"G/L Account";
      ServLine2.VALIDATE("No.",AccountNo);
      ServLine2.VALIDATE(Quantity,1);
      IF ServHeader2."Currency Code" <> '' THEN BEGIN
        ServLine2.VALIDATE("Unit Price",AmountToFCY(CreditUnitPrice,ServHeader2));
        ServLine2.VALIDATE("Line Amount",AmountToFCY(CreditAmount,ServHeader2));
      END ELSE BEGIN
        ServLine2.VALIDATE("Unit Price",CreditUnitPrice);
        ServLine2.VALIDATE("Line Amount",CreditAmount);
      END;
      ServLine2.Description := LineDescription;
      ServLine2."Contract No." := ServContract."Contract No.";
      ServLine2."Service Item No." := ServItemNo;
      ServLine2."Appl.-to Service Entry" := ServLedgEntryNo;
      ServLine2."Unit Cost (LCY)" := CreditCost;
      ServLine2."Posting Date" := PeriodStarts;
      IF ApplyDiscAmt THEN
        ServLine2.VALIDATE("Line Discount Amount",DiscAmount);
      ServLine2.INSERT;

      WITH ServLine2 DO
        CreateDim(
          DimMgt.TypeToTableID5(Type),"No.",
          DATABASE::Job,"Job No.",
          DATABASE::"Responsibility Center","Responsibility Center");
    END;

    [Internal]
    PROCEDURE CreateContractLineCreditMemo@17(VAR FromContractLine@1001 : Record 5964;Deleting@1010 : Boolean) CreditMemoNo@1000 : Code[20];
    VAR
      ServItem@1009 : Record 5940;
      ServContractHeader@1002 : Record 5965;
      StdText@1003 : Record 7;
      Currency@1012 : Record 4;
      ServiceContract@1014 : Page 6050;
      ServiceCreditMemo@1013 : Page 5935;
      ServiceInvoice@1015 : Page 5933;
      CreditAmount@1004 : Decimal;
      FirstPrepaidPostingDate@1005 : Date;
      LastIncomePostingDate@1006 : Date;
      WDate@1016 : Date;
      LineDescription@1007 : Text[50];
    BEGIN
      CreditMemoNo := '';
      WITH FromContractLine DO BEGIN
        ServContractHeader.GET("Contract Type","Contract No.");
        TESTFIELD("Contract Expiration Date");
        TESTFIELD("Credit Memo Date");
        IF "Credit Memo Date" > WORKDATE THEN
          ERROR(
            Text004,
            FIELDCAPTION("Credit Memo Date"),"Credit Memo Date");
        ServContractHeader.CALCFIELDS("No. of Unposted Invoices");
        IF ServContractHeader."No. of Unposted Invoices" <> 0 THEN
          ERROR(
            Text014,
            ServiceCreditMemo.CAPTION,
            ServiceContract.CAPTION,
            ServContractHeader."Contract No.",
            ServiceInvoice.CAPTION);
        ServContractHeader.TESTFIELD("Serv. Contract Acc. Gr. Code");
        ServContractAccGr.GET(ServContractHeader."Serv. Contract Acc. Gr. Code");
        ServContractAccGr.TESTFIELD("Non-Prepaid Contract Acc.");
        GlAcc.GET(ServContractAccGr."Non-Prepaid Contract Acc.");
        GlAcc.TESTFIELD("Direct Posting");
        IF ServContractHeader.Prepaid THEN BEGIN
          ServContractAccGr.TESTFIELD("Prepaid Contract Acc.");
          GlAcc.GET(ServContractAccGr."Prepaid Contract Acc.");
          GlAcc.TESTFIELD("Direct Posting");
        END;

        FillTempServiceLedgerEntries(ServContractHeader);
        Currency.InitRoundingPrecision;

        IF "Line Amount" > 0 THEN BEGIN
          ServMgtSetup.GET;
          IF ServMgtSetup."Contract Credit Line Text Code" <> '' THEN BEGIN
            StdText.GET(ServMgtSetup."Contract Credit Line Text Code");
            LineDescription := COPYSTR(STRSUBSTNO('%1 %2',StdText.Description,"Service Item No."),1,50);
          END ELSE
            IF "Service Item No." <> '' THEN
              LineDescription := COPYSTR(STRSUBSTNO(Text005,ServItem.TABLECAPTION,"Service Item No."),1,50)
            ELSE
              LineDescription := COPYSTR(STRSUBSTNO(Text005,TABLECAPTION,"Line No."),1,50);
          IF "Invoiced to Date" >= "Contract Expiration Date" THEN BEGIN
            IF ServContractHeader.Prepaid THEN BEGIN
              FirstPrepaidPostingDate := FindFirstPrepaidTransaction("Contract No.");
            END ELSE
              FirstPrepaidPostingDate := 0D;

            LastIncomePostingDate := "Invoiced to Date";
            IF FirstPrepaidPostingDate <> 0D THEN
              LastIncomePostingDate := FirstPrepaidPostingDate - 1;
            WDate := "Contract Expiration Date";
            CreditAmount :=
              ROUND(
                CalcContractLineAmount("Line Amount",
                  WDate,"Invoiced to Date"),
                Currency."Amount Rounding Precision");
            IF CreditAmount > 0 THEN BEGIN
              CreditMemoNo := CreateOrGetCreditHeader(ServContractHeader,"Credit Memo Date");
              CreateAllCreditLines(
                CreditMemoNo,
                "Line Amount",
                WDate,
                "Invoiced to Date",
                LineDescription,
                "Service Item No.",
                "Item No.",
                ServContractHeader,
                "Line Cost",
                "Line Value",
                LastIncomePostingDate,
                "Starting Date")
            END;
          END;
        END;
        IF (CreditMemoNo <> '') AND NOT Deleting THEN BEGIN
          Credited := TRUE;
          MODIFY;
        END;
      END;
    END;

    [External]
    PROCEDURE FindFirstPrepaidTransaction@21(ContractNo@1000 : Code[20]) : Date;
    VAR
      ServLedgEntry@1001 : Record 5907;
    BEGIN
      CLEAR(ServLedgEntry);
      ServLedgEntry.SETCURRENTKEY(Type,"No.","Entry Type","Moved from Prepaid Acc.","Posting Date",Open);
      ServLedgEntry.SETRANGE(Type,ServLedgEntry.Type::"Service Contract");
      ServLedgEntry.SETRANGE("No.",ContractNo);
      ServLedgEntry.SETRANGE("Moved from Prepaid Acc.",FALSE);
      ServLedgEntry.SETRANGE(Prepaid,TRUE);
      IF ServLedgEntry.FINDFIRST THEN
        EXIT(ServLedgEntry."Posting Date");

      EXIT(0D);
    END;

    LOCAL PROCEDURE CreateAllCreditLines@36(CreditNo@1000 : Code[20];ContractLineAmount@1001 : Decimal;PeriodStarts@1002 : Date;PeriodEnds@1003 : Date;LineDescription@1004 : Text[50];ServItemNo@1005 : Code[20];ItemNo@1022 : Code[20];ServContract@1006 : Record 5965;ContractLineCost@1007 : Decimal;ContractLineUnitPrice@1008 : Decimal;LastIncomePostingDate@1009 : Date;ContractLineStartingDate@1010 : Date);
    VAR
      Currency@1011 : Record 4;
      ServContractAccGr@1012 : Record 5973;
      AccountNo@1013 : Code[20];
      WDate@1014 : Date;
      OldWDate@1015 : Date;
      i@1016 : Integer;
      Days@1017 : Integer;
      InvPeriod@1018 : Integer;
      AppliedCreditLineAmount@1024 : Decimal;
      AppliedCreditLineCost@1025 : Decimal;
      AppliedCreditLineUnitCost@1026 : Decimal;
      AppliedCreditLineDiscAmount@1019 : Decimal;
      ApplyServiceLedgerEntryAmounts@1020 : Boolean;
      ServLedgEntryNo@1021 : Integer;
    BEGIN
      Days := DATE2DMY(ContractLineStartingDate,1);
      Currency.InitRoundingPrecision;
      IF ServContract.Prepaid THEN
        InvPeriod := 1
      ELSE
        CASE ServContract."Invoice Period" OF
          ServContract."Invoice Period"::Month:
            InvPeriod := 1;
          ServContract."Invoice Period"::"Two Months":
            InvPeriod := 2;
          ServContract."Invoice Period"::Quarter:
            InvPeriod := 3;
          ServContract."Invoice Period"::"Half Year":
            InvPeriod := 6;
          ServContract."Invoice Period"::Year:
            InvPeriod := 12;
          ServContract."Invoice Period"::None:
            InvPeriod := 0;
        END;
      ServContract.TESTFIELD("Serv. Contract Acc. Gr. Code");
      ServContractAccGr.GET(ServContract."Serv. Contract Acc. Gr. Code");
      ServContractAccGr.TESTFIELD("Prepaid Contract Acc.");
      WDate := ContractLineStartingDate;
      REPEAT
        OldWDate := CALCDATE('<CM>',WDate);
        IF Days <> 1 THEN
          Days := 1
        ELSE BEGIN
          FOR i := 1 TO InvPeriod DO
            OldWDate := CALCDATE('<CM>',OldWDate) + 1;
          OldWDate := OldWDate - 1;
        END;
        IF OldWDate >= PeriodStarts THEN BEGIN
          IF WDate < PeriodStarts THEN
            WDate := PeriodStarts;
          IF OldWDate > PeriodEnds THEN
            OldWDate := PeriodEnds;
          IF OldWDate > LastIncomePostingDate THEN
            AccountNo := ServContractAccGr."Prepaid Contract Acc."
          ELSE
            AccountNo := ServContractAccGr."Non-Prepaid Contract Acc.";
          ApplyServiceLedgerEntryAmounts :=
            LookUpAmountToCredit(
              ServItemNo,
              ItemNo,
              WDate,
              AppliedCreditLineAmount,
              AppliedCreditLineCost,
              AppliedCreditLineUnitCost,
              AppliedCreditLineDiscAmount,
              ServLedgEntryNo);
          IF NOT ApplyServiceLedgerEntryAmounts THEN BEGIN
            AppliedCreditLineAmount :=
              ROUND(CalcContractLineAmount(ContractLineAmount,WDate,OldWDate),Currency."Amount Rounding Precision");
            AppliedCreditLineCost :=
              ROUND(CalcContractLineAmount(ContractLineCost,WDate,OldWDate),Currency."Amount Rounding Precision");
            AppliedCreditLineUnitCost :=
              ROUND(CalcContractLineAmount(ContractLineUnitPrice,WDate,OldWDate),Currency."Amount Rounding Precision");
          END;
          CreateCreditLine(
            CreditNo,
            AccountNo,
            AppliedCreditLineAmount,
            WDate,
            OldWDate,
            LineDescription,
            ServItemNo,
            ServContract,
            AppliedCreditLineCost,
            AppliedCreditLineUnitCost,
            AppliedCreditLineDiscAmount,
            ApplyServiceLedgerEntryAmounts,
            ServLedgEntryNo);
        END;
        WDate := CALCDATE('<CM>',OldWDate) + 1;
      UNTIL (OldWDate >= PeriodEnds);
    END;

    [External]
    PROCEDURE GetNextInvoicePeriod@6(InvoicedServContractHeader@1000 : Record 5965;VAR InvFrom@1001 : Date;VAR InvTo@1002 : Date);
    BEGIN
      InvFrom := InvoicedServContractHeader."Next Invoice Period Start";
      InvTo := InvoicedServContractHeader."Next Invoice Period End";
    END;

    [External]
    PROCEDURE NoOfDayInYear@1(InputDate@1000 : Date) : Integer;
    VAR
      W1@1001 : Date;
      W2@1002 : Date;
      YY@1003 : Integer;
    BEGIN
      YY := DATE2DMY(InputDate,3);
      W1 := DMY2DATE(1,1,YY);
      W2 := DMY2DATE(31,12,YY);
      EXIT(W2 - W1 + 1);
    END;

    [External]
    PROCEDURE NoOfMonthsAndDaysInPeriod@18(Day1@1000 : Date;Day2@1001 : Date;VAR NoOfMonthsInPeriod@1002 : Integer;VAR NoOfDaysInPeriod@1003 : Integer);
    VAR
      Wdate@1004 : Date;
      FirstDayinCrntMonth@1005 : Date;
      LastDayinCrntMonth@1006 : Date;
    BEGIN
      NoOfMonthsInPeriod := 0;
      NoOfDaysInPeriod := 0;

      IF Day1 > Day2 THEN
        EXIT;
      IF Day1 = 0D THEN
        EXIT;
      IF Day2 = 0D THEN
        EXIT;

      Wdate := Day1;
      REPEAT
        FirstDayinCrntMonth := CALCDATE('<-CM>',Wdate);
        LastDayinCrntMonth := CALCDATE('<CM>',Wdate);
        IF (Wdate = FirstDayinCrntMonth) AND (LastDayinCrntMonth <= Day2) THEN BEGIN
          NoOfMonthsInPeriod := NoOfMonthsInPeriod + 1;
          Wdate := LastDayinCrntMonth + 1;
        END ELSE BEGIN
          NoOfDaysInPeriod := NoOfDaysInPeriod + 1;
          Wdate := Wdate + 1;
        END;
      UNTIL Wdate > Day2;
    END;

    [External]
    PROCEDURE NoOfMonthsAndMPartsInPeriod@32(Day1@1000 : Date;Day2@1001 : Date) MonthsAndMParts : Decimal;
    VAR
      WDate@1002 : Date;
      OldWDate@1003 : Date;
    BEGIN
      IF Day1 > Day2 THEN
        EXIT;
      IF (Day1 = 0D) OR (Day2 = 0D) THEN
        EXIT;
      MonthsAndMParts := 0;

      WDate := CALCDATE('<-CM>',Day1);
      REPEAT
        OldWDate := CALCDATE('<CM>',WDate);
        IF WDate < Day1 THEN
          WDate := Day1;
        IF OldWDate > Day2 THEN
          OldWDate := Day2;
        IF (WDate <> CALCDATE('<-CM>',WDate)) OR (OldWDate <> CALCDATE('<CM>',OldWDate)) THEN
          MonthsAndMParts := MonthsAndMParts +
            (OldWDate - WDate + 1) / (CALCDATE('<CM>',OldWDate) - CALCDATE('<-CM>',WDate) + 1)
        ELSE
          MonthsAndMParts := MonthsAndMParts + 1;
        WDate := CALCDATE('<CM>',OldWDate) + 1;
        IF MonthsAndMParts <> ROUND(MonthsAndMParts,1) THEN
          CheckMParts := TRUE;
      UNTIL WDate > Day2;
    END;

    [External]
    PROCEDURE CalcContractAmount@19(ServContractHeader@1001 : Record 5965;PeriodStarts@1002 : Date;PeriodEnds@1003 : Date) AmountCalculated@1000 : Decimal;
    VAR
      ServContractLine@1004 : Record 5964;
      Currency@1008 : Record 4;
      LinePeriodStarts@1005 : Date;
      LinePeriodEnds@1006 : Date;
      ContractLineIncluded@1007 : Boolean;
    BEGIN
      Currency.InitRoundingPrecision;
      AmountCalculated := 0;

      IF ServContractHeader."Expiration Date" <> 0D THEN BEGIN
        IF ServContractHeader."Expiration Date" < PeriodStarts THEN
          EXIT;
        IF (ServContractHeader."Expiration Date" >= PeriodStarts) AND
           (ServContractHeader."Expiration Date" <= PeriodEnds)
        THEN
          PeriodEnds := ServContractHeader."Expiration Date";
      END;

      ServContractLine.RESET;
      ServContractLine.SETRANGE("Contract Type",ServContractHeader."Contract Type");
      ServContractLine.SETRANGE("Contract No.",ServContractHeader."Contract No.");
      IF ServContractHeader.Prepaid THEN
        ServContractLine.SETFILTER("Starting Date",'<=%1',ServContractHeader."Next Invoice Date")
      ELSE
        IF ServContractHeader."Last Invoice Date" <> 0D
        THEN
          ServContractLine.SETFILTER("Invoiced to Date",'%1|%2',ServContractHeader."Last Invoice Date",0D);
      IF ServContractLine.FIND('-') THEN BEGIN
        REPEAT
          ContractLineIncluded := TRUE;
          IF ServContractLine."Invoiced to Date" = 0D THEN
            LinePeriodStarts := ServContractLine."Starting Date"
          ELSE
            LinePeriodStarts := PeriodStarts;
          LinePeriodEnds := PeriodEnds;
          IF ServContractLine."Contract Expiration Date" <> 0D THEN BEGIN
            IF ServContractLine."Contract Expiration Date" < PeriodStarts THEN
              ContractLineIncluded := FALSE
            ELSE
              IF (ServContractLine."Contract Expiration Date" >= PeriodStarts) AND
                 (ServContractLine."Contract Expiration Date" <= PeriodEnds)
              THEN
                LinePeriodStarts := PeriodStarts;
          END;
          IF ContractLineIncluded THEN
            AmountCalculated := AmountCalculated +
              CalcContractLineAmount(ServContractLine."Line Amount",LinePeriodStarts,LinePeriodEnds);

        UNTIL ServContractLine.NEXT = 0;
        AmountCalculated := ROUND(AmountCalculated,Currency."Amount Rounding Precision");
      END ELSE BEGIN
        ServContractLine.SETRANGE("Starting Date");
        ServContractLine.SETRANGE("Invoiced to Date");
        IF ServContractLine.ISEMPTY THEN
          AmountCalculated :=
            ROUND(
              ServContractHeader."Annual Amount" / 12 * NoOfMonthsAndMPartsInPeriod(PeriodStarts,PeriodEnds),
              Currency."Amount Rounding Precision");
      END;
    END;

    [External]
    PROCEDURE CalcContractLineAmount@24(AnnualAmount@1001 : Decimal;PeriodStarts@1002 : Date;PeriodEnds@1003 : Date) AmountCalculated@1000 : Decimal;
    BEGIN
      AmountCalculated := 0;
      AmountCalculated :=
        AnnualAmount / 12 * NoOfMonthsAndMPartsInPeriod(PeriodStarts,PeriodEnds);
    END;

    [Internal]
    PROCEDURE CreateRemainingPeriodInvoice@20(VAR CurrServContract@1001 : Record 5965) InvoiceNo@1000 : Code[20];
    VAR
      ServContractLine@1006 : Record 5964;
      InvFrom@1002 : Date;
      InvTo@1003 : Date;
    BEGIN
      CurrServContract.TESTFIELD("Change Status",CurrServContract."Change Status"::Locked);
      IF CurrServContract.Prepaid THEN
        InvTo := CurrServContract."Next Invoice Date" - 1
      ELSE
        InvTo := CurrServContract."Next Invoice Period Start" - 1;
      IF (CurrServContract."Last Invoice Date" = 0D) AND
         (CurrServContract."Starting Date" < CurrServContract."Next Invoice Period Start")
      THEN BEGIN
        InvFrom := CurrServContract."Starting Date";
        IF (InvFrom = CALCDATE('<-CM>',InvFrom)) AND CurrServContract.Prepaid THEN
          EXIT;
      END ELSE
        IF CurrServContract."Last Invoice Period End" <> 0D THEN BEGIN
          IF CurrServContract."Last Invoice Period End" <> CALCDATE('<CM>',CurrServContract."Last Invoice Period End") THEN
            InvFrom := CALCDATE('<+1D>',CurrServContract."Last Invoice Period End");
          ServContractLine.RESET;
          ServContractLine.SETRANGE("Contract Type",CurrServContract."Contract Type");
          ServContractLine.SETRANGE("Contract No.",CurrServContract."Contract No.");
          ServContractLine.SETRANGE("Invoiced to Date",0D);
          ServContractLine.SETFILTER("Starting Date",'<=%1',InvTo);
          IF ServContractLine.FIND('-') THEN
            REPEAT
              IF InvFrom <> 0D THEN BEGIN
                IF ServContractLine."Starting Date" < InvFrom THEN
                  InvFrom := ServContractLine."Starting Date"
              END ELSE
                InvFrom := ServContractLine."Starting Date";
            UNTIL ServContractLine.NEXT = 0;
        END;

      IF (InvFrom = 0D) OR (InvFrom > InvTo) THEN
        EXIT;
      IF CONFIRM(Text006,TRUE,InvFrom,InvTo) THEN BEGIN
        InvoiceNo := CreateServHeader(CurrServContract,PostingDate,FALSE);
        ServHeader.GET(ServHeader."Document Type"::Invoice,InvoiceNo);
        ServMgtSetup.GET;
        IF NOT CurrServContract.Prepaid THEN
          CurrServContract.VALIDATE("Last Invoice Date",InvTo)
        ELSE BEGIN
          CurrServContract."Last Invoice Date" := CurrServContract."Starting Date";
          CurrServContract.VALIDATE("Last Invoice Period End",InvTo);
        END;
        IF CurrServContract."Contract Lines on Invoice" THEN BEGIN
          ServContractLine.RESET;
          ServContractLine.SETRANGE("Contract Type",CurrServContract."Contract Type");
          ServContractLine.SETRANGE("Contract No.",CurrServContract."Contract No.");
          ServContractLine.SETFILTER("Starting Date",'<=%1',InvTo);
          IF ServContractLine.FIND('-') THEN
            REPEAT
              IF ServContractLine."Invoiced to Date" = 0D THEN
                CreateDetailedServLine(
                  ServHeader,
                  ServContractLine,
                  CurrServContract."Contract Type",
                  CurrServContract."Contract No.");
              IF ServContractLine."Invoiced to Date" <> 0D THEN
                IF ServContractLine."Invoiced to Date" <> CALCDATE('<CM>',ServContractLine."Invoiced to Date") THEN
                  CreateDetailedServLine(
                    ServHeader,
                    ServContractLine,
                    CurrServContract."Contract Type",
                    CurrServContract."Contract No.");

              AppliedEntry :=
                CreateServiceLedgerEntry(
                  ServHeader,CurrServContract."Contract Type",
                  CurrServContract."Contract No.",InvFrom,InvTo,TRUE,FALSE,ServContractLine."Line No.");

              CreateServLine(
                ServHeader,CurrServContract."Contract Type",
                CurrServContract."Contract No.",InvFrom,InvTo,AppliedEntry,TRUE);
            UNTIL ServContractLine.NEXT = 0;
        END ELSE BEGIN
          CreateHeadingServLine(
            ServHeader,
            CurrServContract."Contract Type",
            CurrServContract."Contract No.");

          AppliedEntry :=
            CreateServiceLedgerEntry(
              ServHeader,CurrServContract."Contract Type",
              CurrServContract."Contract No.",InvFrom,InvTo,TRUE,FALSE,0);

          CreateServLine(
            ServHeader,CurrServContract."Contract Type",
            CurrServContract."Contract No.",InvFrom,InvTo,AppliedEntry,TRUE);
        END;

        CurrServContract.MODIFY;
        InvoicingStartingPeriod := TRUE;
      END;
    END;

    [External]
    PROCEDURE InitCodeUnit@8();
    VAR
      ServLedgEntry@1000 : Record 5907;
      SourceCodeSetup@1001 : Record 242;
      KeepFromWarrEntryNo@1002 : Integer;
      KeepToWarrEntryNo@1003 : Integer;
    BEGIN
      WITH ServLedgEntry DO BEGIN
        RESET;
        LOCKTABLE;
        IF FINDLAST THEN BEGIN
          NextEntry := "Entry No." + 1;
        END ELSE
          NextEntry := 1;

        ServiceRegister.RESET;
        ServiceRegister.LOCKTABLE;
        IF ServiceRegister.FINDLAST THEN BEGIN
          ServiceRegister."No." := ServiceRegister."No." + 1;
          KeepFromWarrEntryNo := ServiceRegister."From Warranty Entry No.";
          KeepToWarrEntryNo := ServiceRegister."To Warranty Entry No.";
        END ELSE
          ServiceRegister."No." := 1;

        ServiceRegister.INIT;
        ServiceRegister."From Entry No." := NextEntry;
        ServiceRegister."From Warranty Entry No." := KeepFromWarrEntryNo;
        ServiceRegister."To Warranty Entry No." := KeepToWarrEntryNo;
        ServiceRegister."Creation Date" := TODAY;
        SourceCodeSetup.GET;
        ServiceRegister."Source Code" := SourceCodeSetup."Service Management";
        ServiceRegister."User ID" := USERID;
      END;
    END;

    [External]
    PROCEDURE FinishCodeunit@25();
    BEGIN
      ServiceRegister."To Entry No." := NextEntry - 1;
      ServiceRegister.INSERT;
    END;

    [External]
    PROCEDURE CopyCheckSCDimToTempSCDim@34(ServContract@1001 : Record 5965);
    BEGIN
      CheckDimComb(ServContract,0);
      CheckDimValuePosting(ServContract,0);
    END;

    LOCAL PROCEDURE CheckDimComb@30(ServContract@1001 : Record 5965;LineNo@1000 : Integer);
    BEGIN
      IF NOT DimMgt.CheckDimIDComb(ServContract."Dimension Set ID") THEN
        IF LineNo = 0 THEN
          ERROR(
            Text008,
            ServContract."Contract Type",ServContract."Contract No.",DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimValuePosting@28(ServContract@1001 : Record 5965;LineNo@1000 : Integer);
    VAR
      TableIDArr@1002 : ARRAY [10] OF Integer;
      NumberArr@1003 : ARRAY [10] OF Code[20];
    BEGIN
      IF LineNo = 0 THEN BEGIN
        TableIDArr[1] := DATABASE::Customer;
        NumberArr[1] := ServContract."Bill-to Customer No.";
        TableIDArr[2] := DATABASE::"Salesperson/Purchaser";
        NumberArr[2] := ServContract."Salesperson Code";
        TableIDArr[3] := DATABASE::"Responsibility Center";
        NumberArr[3] := ServContract."Responsibility Center";
        TableIDArr[4] := DATABASE::"Service Contract Template";
        NumberArr[4] := ServContract."Template No.";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,ServContract."Dimension Set ID") THEN
          ERROR(
            Text009,
            ServContract."Contract Type",ServContract."Contract No.",DimMgt.GetDimValuePostingErr);
      END;
    END;

    [Internal]
    PROCEDURE CreateAllServLines@2(InvNo@1001 : Code[20];ServContractToInvoice@1000 : Record 5965);
    VAR
      ServContractLine@1007 : Record 5964;
      ServHeader@1006 : Record 5900;
      InvoiceFrom@1004 : Date;
      InvoiceTo@1003 : Date;
      ServiceApplyEntry@1005 : Integer;
    BEGIN
      GetNextInvoicePeriod(ServContractToInvoice,InvoiceFrom,InvoiceTo);
      WITH ServContractToInvoice DO BEGIN
        IF ServHeader.GET(ServHeader."Document Type"::Invoice,InvNo) THEN BEGIN
          ServContractLine.RESET;
          ServContractLine.SETRANGE("Contract Type","Contract Type");
          ServContractLine.SETRANGE("Contract No.","Contract No.");
          IF NOT "Contract Lines on Invoice" THEN
            CreateHeadingServLine(ServHeader,"Contract Type","Contract No.");
          IF ServContractLine.FIND('-') THEN
            REPEAT
              IF "Contract Lines on Invoice" AND (ServContractLine."Starting Date" <= InvoiceTo) THEN
                IF Prepaid AND (ServContractLine."Starting Date" <= "Next Invoice Date") OR
                   ((NOT Prepaid) AND
                    ((ServContractLine."Invoiced to Date" = "Last Invoice Date") OR
                     (ServContractLine."Invoiced to Date" = 0D)))
                THEN
                  IF (ServContractLine."Contract Expiration Date" = 0D) OR
                     (ServContractLine."Contract Expiration Date" >= InvoiceFrom)
                  THEN
                    CreateDetailedServLine(ServHeader,ServContractLine,"Contract Type","Contract No.");

              ServiceApplyEntry :=
                CreateServiceLedgerEntry(
                  ServHeader,"Contract Type","Contract No.",InvoiceFrom,InvoiceTo,
                  FALSE,FALSE,ServContractLine."Line No.");

              IF ServiceApplyEntry <> 0 THEN
                CreateServLine(
                  ServHeader,"Contract Type","Contract No.",
                  GetMaxDate(ServContractLine."Starting Date",InvoiceFrom),InvoiceTo,ServiceApplyEntry,FALSE);
            UNTIL ServContractLine.NEXT = 0;
        END;
        CreateLastServLines(ServHeader,"Contract Type","Contract No.");

        VALIDATE("Last Invoice Date","Next Invoice Date");
        "Print Increase Text" := FALSE;
        MODIFY;
      END;
    END;

    [External]
    PROCEDURE CheckIfServiceExist@10(ServContractHeader@1000 : Record 5965) : Boolean;
    VAR
      ServContractLine@1001 : Record 5964;
    BEGIN
      WITH ServContractHeader DO
        IF "Invoice after Service" THEN BEGIN
          ServContractLine.RESET;
          ServContractLine.SETRANGE("Contract Type","Contract Type");
          ServContractLine.SETRANGE("Contract No.","Contract No.");
          ServContractLine.SETFILTER("Last Service Date",'<%1 | >%2',"Next Invoice Period Start","Next Invoice Period End");
          EXIT(ServContractLine.ISEMPTY);
        END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE GetAffectedItemsOnCustChange@13(ContractNoToBeChanged@1002 : Code[20];VAR TempServContract@1001 : Record 5965;VAR TempServItem@1000 : Record 5940;Recursive@1003 : Boolean;ContractTypeToBeChanged@1008 : Integer);
    VAR
      ServContract@1004 : Record 5965;
      ServItem@1005 : Record 5940;
      ServContractLine@1006 : Record 5964;
      ServContractLine2@1007 : Record 5964;
    BEGIN
      IF NOT Recursive THEN BEGIN
        TempServContract.DELETEALL;
        TempServItem.DELETEALL;
      END;
      IF TempServContract.GET(ContractTypeToBeChanged,ContractNoToBeChanged) THEN
        EXIT;
      ServContract.GET(ContractTypeToBeChanged,ContractNoToBeChanged);
      IF (ServContract.Status = ServContract.Status::Canceled) AND
         (ServContract."Contract Type" = ServContract."Contract Type"::Contract)
      THEN
        EXIT;
      TempServContract := ServContract;
      TempServContract.INSERT;

      ServContractLine.SETRANGE("Contract Type",ContractTypeToBeChanged);
      ServContractLine.SETRANGE("Contract No.",ServContract."Contract No.");
      ServContractLine.SETFILTER("Contract Status",'<>%1',ServContractLine."Contract Status"::Cancelled);
      ServContractLine.SETFILTER("Service Item No.",'<>%1','');
      IF ServContractLine.FIND('-') THEN
        REPEAT
          IF NOT TempServItem.GET(ServContractLine."Service Item No.") THEN BEGIN
            ServItem.GET(ServContractLine."Service Item No.");
            TempServItem := ServItem;
            TempServItem.INSERT;
          END;

          ServContractLine2.RESET;
          ServContractLine2.SETCURRENTKEY("Service Item No.","Contract Status");
          ServContractLine2.SETRANGE("Service Item No.",ServContractLine."Service Item No.");
          ServContractLine2.SETFILTER("Contract Status",'<>%1',ServContractLine."Contract Status"::Cancelled);
          ServContractLine2.SETRANGE("Contract Type",ServContractLine."Contract Type"::Contract);
          ServContractLine2.SETFILTER("Contract No.",'<>%1',ServContractLine."Contract No.");
          IF ServContractLine2.FIND('-') THEN
            REPEAT
              GetAffectedItemsOnCustChange(
                ServContractLine2."Contract No.",
                TempServContract,
                TempServItem,
                TRUE,
                ServContractLine."Contract Type"::Contract)
            UNTIL ServContractLine2.NEXT = 0;

          ServContractLine2.RESET;
          ServContractLine2.SETCURRENTKEY("Service Item No.");
          ServContractLine2.SETRANGE("Service Item No.",ServContractLine."Service Item No.");
          ServContractLine2.SETRANGE("Contract Type",ServContractLine."Contract Type"::Quote);
          IF ServContractLine2.FIND('-') THEN
            REPEAT
              GetAffectedItemsOnCustChange(
                ServContractLine2."Contract No.",
                TempServContract,
                TempServItem,
                TRUE,
                ServContractLine."Contract Type"::Quote)
            UNTIL ServContractLine2.NEXT = 0;

        UNTIL ServContractLine.NEXT = 0;
    END;

    [Internal]
    PROCEDURE ChangeCustNoOnServContract@23(NewCustomertNo@1000 : Code[20];NewShipToCode@1001 : Code[10];ServContractHeader@1002 : Record 5965);
    VAR
      ServContractLine@1018 : Record 5964;
      Cust@1014 : Record 18;
      ContractChangeLog@1011 : Record 5967;
      CustCheckCrLimit@1006 : Codeunit 312;
      UserMgt@1003 : Codeunit 5700;
      OldSalespersonCode@1004 : Code[20];
      OldCurrencyCode@1005 : Code[10];
    BEGIN
      IF NewCustomertNo = '' THEN
        ERROR(Text012);

      ServMgtSetup.GET;

      WITH ServContractHeader DO BEGIN
        OldSalespersonCode := "Salesperson Code";
        OldCurrencyCode := "Currency Code";

        IF "Customer No." <> NewCustomertNo THEN BEGIN
          IF ServMgtSetup."Register Contract Changes" THEN
            ContractChangeLog.LogContractChange(
              "Contract No.",0,FIELDCAPTION("Customer No."),0,"Customer No.",NewCustomertNo,'',0);
          "Customer No." := NewCustomertNo;
          CustCheckCrLimit.OnNewCheckRemoveCustomerNotifications(RECORDID,TRUE);

          Cust.GET(NewCustomertNo);
          SetHideValidationDialog(TRUE);
          IF Cust."Bill-to Customer No." <> '' THEN
            VALIDATE("Bill-to Customer No.",Cust."Bill-to Customer No.")
          ELSE
            VALIDATE("Bill-to Customer No.",Cust."No.");
          "Responsibility Center" := UserMgt.GetRespCenter(2,Cust."Responsibility Center");
          UpdateShiptoCode;
          CALCFIELDS(
            Name,"Name 2",Address,"Address 2",
            "Post Code",City,County,"Country/Region Code");
          CustCheckCrLimit.ServiceContractHeaderCheck(ServContractHeader);
        END;

        IF "Ship-to Code" <> NewShipToCode THEN BEGIN
          IF ServMgtSetup."Register Contract Changes" THEN
            ContractChangeLog.LogContractChange(
              "Contract No.",0,FIELDCAPTION("Ship-to Code"),0,"Ship-to Code",NewShipToCode,'',0);
          "Ship-to Code" := NewShipToCode;
          IF NewShipToCode = '' THEN
            UpdateShiptoCode
          ELSE
            CALCFIELDS(
              "Ship-to Name","Ship-to Name 2","Ship-to Address","Ship-to Address 2",
              "Ship-to Post Code","Ship-to City","Ship-to County","Ship-to Country/Region Code");
        END;

        UpdateServZone;
        UpdateCont("Customer No.");
        UpdateCust("Contact No.");
        "Salesperson Code" := OldSalespersonCode;
        "Currency Code" := OldCurrencyCode;

        CreateDim(
          DATABASE::Customer,"Bill-to Customer No.",
          DATABASE::"Salesperson/Purchaser","Salesperson Code",
          DATABASE::"Responsibility Center","Responsibility Center",
          DATABASE::"Service Contract Template","Template No.",
          DATABASE::"Service Order Type","Service Order Type");

        ServContractLine.RESET;
        ServContractLine.SETRANGE("Contract Type","Contract Type");
        ServContractLine.SETRANGE("Contract No.","Contract No.");
        IF ServContractLine.FIND('-') THEN
          REPEAT
            ServContractLine."Customer No." := NewCustomertNo;
            ServContractLine."Ship-to Code" := NewShipToCode;
            ServContractLine.MODIFY;
          UNTIL ServContractLine.NEXT = 0;
      END;
      ServContractHeader.MODIFY;
    END;

    [External]
    PROCEDURE ChangeCustNoOnServItem@26(NewCustomertNo@1001 : Code[20];NewShipToCode@1000 : Code[10];ServItem@1002 : Record 5940);
    VAR
      OldServItem@1005 : Record 5940;
      ServLogMgt@1003 : Codeunit 5906;
    BEGIN
      OldServItem := ServItem;
      ServItem."Customer No." := NewCustomertNo;
      ServItem."Ship-to Code" := NewShipToCode;
      IF OldServItem."Customer No." <> NewCustomertNo THEN BEGIN
        ServLogMgt.ServItemCustChange(ServItem,OldServItem);
        ServLogMgt.ServItemShipToCodeChange(ServItem,OldServItem);
      END ELSE
        IF OldServItem."Ship-to Code" <> NewShipToCode THEN
          ServLogMgt.ServItemShipToCodeChange(ServItem,OldServItem);
      ServItem.MODIFY;
    END;

    [External]
    PROCEDURE CreateHeadingServLine@27(ServHeader@1000 : Record 5900;ContractType@1008 : Integer;ContractNo@1001 : Code[20]);
    VAR
      ServContractHeader@1006 : Record 5965;
      Cust@1003 : Record 18;
      StdText@1004 : Record 7;
    BEGIN
      ServContractHeader.GET(ContractType,ContractNo);
      IF ServContractHeader."Invoice Period" = ServContractHeader."Invoice Period"::None THEN
        EXIT;

      ServLineNo := 0;
      ServLine.SETRANGE("Document Type",ServLine."Document Type"::Invoice);
      ServLine.SETRANGE("Document No.",ServHeader."No.");
      IF ServLine.FINDLAST THEN
        ServLineNo := ServLine."Line No.";
      Cust.GET(ServContractHeader."Bill-to Customer No.");
      ServMgtSetup.GET;
      ServLine.RESET;
      ServLine.INIT;
      ServLineNo := ServLineNo + 10000;
      ServLine."Document Type" := ServHeader."Document Type";
      ServLine."Document No." := ServHeader."No.";
      ServLine."Line No." := ServLineNo;
      ServLine.Type := ServLine.Type::" ";
      IF ServMgtSetup."Contract Inv. Line Text Code" <> '' THEN BEGIN
        StdText.GET(ServMgtSetup."Contract Inv. Line Text Code");
        TempServLineDescription := STRSUBSTNO('%1 %2',StdText.Description,ServContractHeader."Contract No.");
        IF STRLEN(TempServLineDescription) > MAXSTRLEN(ServLine.Description) THEN
          ERROR(Text013,ServLine.TABLECAPTION,ServLine.FIELDCAPTION(Description),
            StdText.TABLECAPTION,StdText.Code,StdText.FIELDCAPTION(Description),
            FORMAT(STRLEN(TempServLineDescription) - MAXSTRLEN(ServLine.Description)));
        ServLine.Description := COPYSTR(TempServLineDescription,1,MAXSTRLEN(ServLine.Description));
      END ELSE
        ServLine.Description := STRSUBSTNO(Text002,ServContractHeader."Contract No.");
      ServLine.INSERT;
    END;

    [External]
    PROCEDURE LookupServItemNo@31(VAR ServiceContractLine@1002 : Record 5964);
    VAR
      ServContractHeader@1003 : Record 5965;
      ServItem@1001 : Record 5940;
      ServItemList@1000 : Page 5981;
    BEGIN
      CLEAR(ServItemList);
      IF ServItem.GET(ServiceContractLine."Service Item No.") THEN
        ServItemList.SETRECORD(ServItem);
      ServItem.RESET;
      ServItem.SETCURRENTKEY("Customer No.","Ship-to Code");
      ServItem.FILTERGROUP(2);
      IF ServiceContractLine."Customer No." <> '' THEN
        ServItem.SETRANGE("Customer No.",ServiceContractLine."Customer No.");
      ServItem.FILTERGROUP(0);
      IF ServContractHeader.GET(ServiceContractLine."Contract Type",ServiceContractLine."Contract No.") AND
         (ServiceContractLine."Ship-to Code" = ServContractHeader."Ship-to Code")
      THEN
        ServItem.SETRANGE("Ship-to Code",ServiceContractLine."Ship-to Code");
      ServItemList.SETTABLEVIEW(ServItem);
      ServItemList.LOOKUPMODE(TRUE);
      IF ServItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        ServItemList.GETRECORD(ServItem);
        ServiceContractLine.VALIDATE("Service Item No.",ServItem."No.");
      END;
    END;

    LOCAL PROCEDURE AmountToFCY@35(AmountLCY@1000 : Decimal;VAR ServHeader3@1001 : Record 5900) : Decimal;
    VAR
      CurrExchRate@1002 : Record 330;
      Currency@1003 : Record 4;
    BEGIN
      Currency.GET(ServHeader3."Currency Code");
      Currency.TESTFIELD("Unit-Amount Rounding Precision");
      EXIT(
        ROUND(
          CurrExchRate.ExchangeAmtLCYToFCY(
            ServHeader3."Posting Date",ServHeader3."Currency Code",
            AmountLCY,ServHeader3."Currency Factor"),
          Currency."Unit-Amount Rounding Precision"));
    END;

    [External]
    PROCEDURE YearContract@37(ContrType@1000 : Integer;ContrNo@1001 : Code[20]) : Boolean;
    VAR
      ServContrHeader@1002 : Record 5965;
    BEGIN
      IF NOT ServContrHeader.GET(ContrType,ContrNo) THEN
        EXIT(FALSE);
      EXIT(ServContrHeader."Expiration Date" = CALCDATE('<1Y-1D>',ServContrHeader."Starting Date"));
    END;

    LOCAL PROCEDURE FillTempServiceLedgerEntries@58(ServiceContractHeader@1001 : Record 5965);
    VAR
      ServiceLedgerEntry@1000 : Record 5907;
    BEGIN
      IF TempServLedgEntriesIsSet THEN
        EXIT;
      TempServLedgEntry.DELETEALL;
      WITH ServiceLedgerEntry DO BEGIN
        SETRANGE("Service Contract No.",ServiceContractHeader."Contract No.");
        SETRANGE("Entry Type","Entry Type"::Sale);
        IF NOT FINDSET THEN
          EXIT;
        REPEAT
          TempServLedgEntry := ServiceLedgerEntry;
          TempServLedgEntry.INSERT;
        UNTIL NEXT = 0;
        TempServLedgEntriesIsSet := TRUE;
      END;
    END;

    LOCAL PROCEDURE LookUpAmountToCredit@22(ServItemNo@1001 : Code[20];ItemNo@1009 : Code[20];PostingDate@1002 : Date;VAR LineAmount@1003 : Decimal;VAR CostAmount@1004 : Decimal;VAR UnitPrice@1005 : Decimal;VAR DiscountAmt@1007 : Decimal;VAR ServLedgEntryNo@1008 : Integer) : Boolean;
    BEGIN
      LineAmount := 0;
      CostAmount := 0;
      UnitPrice := 0;
      DiscountAmt := 0;
      ServLedgEntryNo := 0;

      TempServLedgEntry.RESET;
      IF ServItemNo <> '' THEN
        TempServLedgEntry.SETRANGE("Service Item No. (Serviced)",ServItemNo);
      IF ItemNo <> '' THEN
        TempServLedgEntry.SETRANGE("Item No. (Serviced)",ItemNo);
      TempServLedgEntry.SETRANGE("Posting Date",PostingDate);

      IF NOT TempServLedgEntry.FINDFIRST THEN
        EXIT(FALSE);

      LineAmount := -TempServLedgEntry."Amount (LCY)";
      CostAmount := TempServLedgEntry."Cost Amount";
      UnitPrice := -TempServLedgEntry."Unit Price";
      DiscountAmt := TempServLedgEntry."Discount Amount";
      ServLedgEntryNo := TempServLedgEntry."Entry No.";
      TempServLedgEntry.DELETE;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckServiceContractHeaderAmts@12(ServiceContractHeader@1000 : Record 5965);
    BEGIN
      IF ServiceContractHeader."Calcd. Annual Amount" <> ServiceContractHeader."Annual Amount" THEN
        ERROR(
          Text000,
          ServLedgEntry2.TABLECAPTION,
          ServiceContractHeader."Contract No.",
          ServiceContractHeader.FIELDCAPTION("Calcd. Annual Amount"),
          ServiceContractHeader.FIELDCAPTION("Annual Amount"));
    END;

    LOCAL PROCEDURE SetServiceLedgerEntryUnitCost@29(VAR ServiceLedgerEntry@1000 : Record 5907);
    BEGIN
      WITH ServiceLedgerEntry DO
        IF "Charged Qty." = 0 THEN
          "Unit Cost" := -"Cost Amount"
        ELSE
          "Unit Cost" := "Cost Amount" / "Charged Qty.";
    END;

    LOCAL PROCEDURE ServLedgEntryToServiceLine@38(VAR TotalServLine@1002 : Record 5902;VAR TotalServLineLCY@1001 : Record 5902;ServHeader@1011 : Record 5900;ServiceLedgerEntry@1006 : Record 5907;ContractNo@1009 : Code[20];InvFrom@1008 : Date;InvTo@1007 : Date);
    VAR
      StdText@1000 : Record 7;
    BEGIN
      ServLineNo := ServLineNo + 10000;
      WITH ServLine DO BEGIN
        RESET;
        INIT;
        "Document Type" := ServHeader."Document Type";
        "Document No." := ServHeader."No.";
        "Line No." := ServLineNo;
        "Customer No." := ServHeader."Customer No.";
        "Location Code" := ServHeader."Location Code";
        "Gen. Bus. Posting Group" := ServHeader."Gen. Bus. Posting Group";
        "Transaction Specification" := ServHeader."Transaction Specification";
        "Transport Method" := ServHeader."Transport Method";
        "Exit Point" := ServHeader."Exit Point";
        Area := ServHeader.Area;
        "Transaction Specification" := ServHeader."Transaction Specification";
        Type := Type::"G/L Account";
        VALIDATE("No.",AppliedGLAccount);
        VALIDATE(Quantity,1);
        IF ServMgtSetup."Contract Inv. Period Text Code" <> '' THEN BEGIN
          StdText.GET(ServMgtSetup."Contract Inv. Period Text Code");
          TempServLineDescription := STRSUBSTNO('%1 %2 - %3',StdText.Description,FORMAT(InvFrom),FORMAT(InvTo));
          IF STRLEN(TempServLineDescription) > MAXSTRLEN(Description) THEN
            ERROR(
              Text013,
              TABLECAPTION,FIELDCAPTION(Description),
              StdText.TABLECAPTION,StdText.Code,StdText.FIELDCAPTION(Description),
              FORMAT(STRLEN(TempServLineDescription) - MAXSTRLEN(Description)));
          Description := COPYSTR(TempServLineDescription,1,MAXSTRLEN(Description));
        END ELSE
          Description :=
            STRSUBSTNO('%1 - %2',FORMAT(InvFrom),FORMAT(InvTo));
        "Contract No." := ContractNo;
        "Appl.-to Service Entry" := ServiceLedgerEntry."Entry No.";
        "Service Item No." := ServiceLedgerEntry."Service Item No. (Serviced)";
        "Unit Cost (LCY)" := ServiceLedgerEntry."Unit Cost";
        "Unit Price" := -ServiceLedgerEntry."Unit Price";

        TotalServLine."Unit Price" += "Unit Price";
        TotalServLine."Line Amount" += -ServiceLedgerEntry."Amount (LCY)";
        IF (ServiceLedgerEntry."Amount (LCY)" <> 0) OR (ServiceLedgerEntry."Discount %" > 0) THEN
          IF ServHeader."Currency Code" <> '' THEN BEGIN
            VALIDATE("Unit Price",
              AmountToFCY(TotalServLine."Unit Price",ServHeader) - TotalServLineLCY."Unit Price");
            VALIDATE("Line Amount",
              AmountToFCY(TotalServLine."Line Amount",ServHeader) - TotalServLineLCY."Line Amount");
          END ELSE BEGIN
            VALIDATE("Unit Price");
            VALIDATE("Line Amount",-ServiceLedgerEntry."Amount (LCY)");
          END;
        TotalServLineLCY."Unit Price" += "Unit Price";
        TotalServLineLCY."Line Amount" += "Line Amount";

        "Shortcut Dimension 1 Code" := ServiceLedgerEntry."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := ServiceLedgerEntry."Global Dimension 2 Code";
        "Dimension Set ID" := ServiceLedgerEntry."Dimension Set ID";

        INSERT;
        CreateDim(
          DimMgt.TypeToTableID5(Type),"No.",
          DATABASE::Job,"Job No.",
          DATABASE::"Responsibility Center","Responsibility Center");
      END;
    END;

    [External]
    PROCEDURE CheckMultipleCurrenciesForCustomers@40(VAR ServiceContractHeader@1000 : Record 5965);
    VAR
      ServiceContractHeader2@1001 : Record 5965;
      PrevCustNo@1002 : Code[20];
    BEGIN
      WITH ServiceContractHeader2 DO BEGIN
        COPY(ServiceContractHeader);
        SETCURRENTKEY("Bill-to Customer No.","Contract Type","Combine Invoices","Next Invoice Date");
        SETRANGE("Combine Invoices",TRUE);
        IF FINDSET THEN
          REPEAT
            IF PrevCustNo <> "Bill-to Customer No." THEN BEGIN
              CheckCustomerCurrencyCombination(ServiceContractHeader2);
              PrevCustNo := "Bill-to Customer No.";
            END;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckCustomerCurrencyCombination@43(VAR ServiceContractHeader@1000 : Record 5965);
    VAR
      ServiceContractHeader2@1002 : Record 5965;
    BEGIN
      WITH ServiceContractHeader2 DO BEGIN
        COPY(ServiceContractHeader);
        SETRANGE("Bill-to Customer No.",ServiceContractHeader."Bill-to Customer No.");
        SETFILTER("Currency Code",'<>%1',ServiceContractHeader."Currency Code");
        IF FINDFIRST THEN
          ERROR(ErrorSplitErr,
            STRSUBSTNO(CombinedCurrenciesErr1,
              "Bill-to Customer No.",
              ShownCurrencyText("Currency Code"),
              ShownCurrencyText(ServiceContractHeader."Currency Code")),
            CombinedCurrenciesErr2);
      END;
    END;

    LOCAL PROCEDURE ShownCurrencyText@41(CurrCode@1000 : Code[10]) : Text;
    BEGIN
      IF CurrCode = '' THEN
        EXIT(BlankTxt);
      EXIT(CurrCode);
    END;

    LOCAL PROCEDURE InitServLedgEntry@52(VAR ServLedgEntry@1000 : Record 5907;ServContractHeader@1001 : Record 5965;DocNo@1002 : Code[20]);
    BEGIN
      WITH ServLedgEntry DO BEGIN
        INIT;
        Type := Type::"Service Contract";
        "No." := ServContractHeader."Contract No.";
        "Service Contract No." := ServContractHeader."Contract No.";
        "Document Type" := "Document Type"::" ";
        "Document No." := DocNo;
        "Serv. Contract Acc. Gr. Code" := ServContractHeader."Serv. Contract Acc. Gr. Code";
        "Bill-to Customer No." := ServContractHeader."Bill-to Customer No.";
        "Customer No." := ServContractHeader."Customer No.";
        "Ship-to Code" := ServContractHeader."Ship-to Code";
        "Global Dimension 1 Code" := ServContractHeader."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := ServContractHeader."Shortcut Dimension 2 Code";
        "Dimension Set ID" := ServContractHeader."Dimension Set ID";
        "Entry Type" := "Entry Type"::Sale;
        "User ID" := USERID;
        "Contract Invoice Period" := FORMAT(ServContractHeader."Invoice Period");
        "Contract Group Code" := ServContractHeader."Contract Group Code";
        "Responsibility Center" := ServContractHeader."Responsibility Center";
        Open := TRUE;
        Quantity := -1;
        "Charged Qty." := -1;
      END;
    END;

    [External]
    PROCEDURE GetInvoicePeriodText@60(InvoicePeriod@1000 : Option) : Text[4];
    VAR
      ServiceContractHeader@1001 : Record 5965;
    BEGIN
      CASE InvoicePeriod OF
        ServiceContractHeader."Invoice Period"::Month:
          EXIT('<1M>');
        ServiceContractHeader."Invoice Period"::"Two Months":
          EXIT('<2M>');
        ServiceContractHeader."Invoice Period"::Quarter:
          EXIT('<3M>');
        ServiceContractHeader."Invoice Period"::"Half Year":
          EXIT('<6M>');
        ServiceContractHeader."Invoice Period"::Year:
          EXIT('<1Y>');
      END;
    END;

    LOCAL PROCEDURE FilterServContractLine@42(VAR ServContractLine@1000 : Record 5964;ContractNo@1001 : Code[20];ContractType@1002 : Option;LineNo@1003 : Integer);
    BEGIN
      ServContractLine.RESET;
      ServContractLine.SETRANGE("Contract No.",ContractNo);
      ServContractLine.SETRANGE("Contract Type",ContractType);
      IF LineNo <> 0 THEN
        ServContractLine.SETRANGE("Line No.",LineNo);
    END;

    LOCAL PROCEDURE CountLineInvFrom@54(SigningContract@1000 : Boolean;VAR ServContractLine@1001 : Record 5964;InvFrom@1002 : Date) LineInvFrom : Date;
    BEGIN
      IF SigningContract THEN BEGIN
        IF ServContractLine."Invoiced to Date" = 0D THEN
          LineInvFrom := ServContractLine."Starting Date"
        ELSE
          IF ServContractLine."Invoiced to Date" <> CALCDATE('<CM>',ServContractLine."Invoiced to Date") THEN
            LineInvFrom := ServContractLine."Invoiced to Date" + 1
      END ELSE
        IF ServContractLine."Invoiced to Date" = 0D THEN BEGIN
          IF ServContractLine."Starting Date" >= CALCDATE('<-CM>',ServContractLine."Starting Date") THEN
            LineInvFrom := ServContractLine."Starting Date"
          ELSE
            IF ServContractLine."Starting Date" <= InvFrom THEN
              LineInvFrom := CALCDATE('<CM+1D>',ServContractLine."Starting Date")
            ELSE
              LineInvFrom := 0D;
        END ELSE
          LineInvFrom := InvFrom;
    END;

    LOCAL PROCEDURE CalcServLedgEntryAmounts@49(VAR ServContractLine@1001 : Record 5964;VAR InvAmountRounded@1004 : ARRAY [4] OF Decimal);
    VAR
      ServLedgEntry2@1000 : Record 5907;
      AccumulatedAmts@1003 : ARRAY [4] OF Decimal;
      i@1002 : Integer;
    BEGIN
      ServLedgEntry2.SETCURRENTKEY("Service Contract No.");
      ServLedgEntry2.SETRANGE("Service Contract No.",ServContractLine."Contract No.");
      ServLedgEntry2.SETRANGE("Service Item No. (Serviced)",ServContractLine."Service Item No.");
      ServLedgEntry2.SETRANGE("Entry Type",ServLedgEntry2."Entry Type"::Sale);
      FOR i := 1 TO 4 DO
        AccumulatedAmts[i] := 0;
      IF ServLedgEntry2.FINDSET THEN
        REPEAT
          AccumulatedAmts[AmountType::UnitCost] :=
            AccumulatedAmts[AmountType::UnitCost] + ServLedgEntry2."Cost Amount";
          AccumulatedAmts[AmountType::Amount] :=
            AccumulatedAmts[AmountType::Amount] - ServLedgEntry2."Amount (LCY)";
          AccumulatedAmts[AmountType::DiscAmount] :=
            AccumulatedAmts[AmountType::DiscAmount] + ServLedgEntry2."Discount Amount";
          AccumulatedAmts[AmountType::UnitPrice] :=
            AccumulatedAmts[AmountType::UnitPrice] - ServLedgEntry2."Unit Price";
        UNTIL ServLedgEntry2.NEXT = 0;
      ServLedgEntry."Cost Amount" := -ROUND(ServContractLine."Line Cost" + AccumulatedAmts[AmountType::UnitCost]);
      SetServiceLedgerEntryUnitCost(ServLedgEntry);
      ServLedgEntry."Amount (LCY)" := AccumulatedAmts[AmountType::Amount] - ServContractLine."Line Amount";
      ServLedgEntry."Discount Amount" := ServContractLine."Line Discount Amount" - AccumulatedAmts[AmountType::DiscAmount];
      ServLedgEntry."Contract Disc. Amount" := ServLedgEntry."Discount Amount";
      ServLedgEntry."Unit Price" := AccumulatedAmts[AmountType::UnitPrice] - ServContractLine."Line Value";
      CalcServLedgEntryDiscountPct(ServLedgEntry);
      InvAmountRounded[AmountType::Amount] -= ServLedgEntry."Amount (LCY)";
      InvAmountRounded[AmountType::UnitPrice] -= ServLedgEntry."Unit Price";
      InvAmountRounded[AmountType::UnitCost] += ServLedgEntry."Unit Cost";
      InvAmountRounded[AmountType::DiscAmount] += ServLedgEntry."Contract Disc. Amount";
    END;

    LOCAL PROCEDURE UpdateServLedgEntryAmount@51(VAR ServLedgEntry@1000 : Record 5907;VAR ServHeader@1001 : Record 5900);
    BEGIN
      IF ServHeader."Currency Code" <> '' THEN
        ServLedgEntry.Amount := AmountToFCY(ServLedgEntry."Amount (LCY)",ServHeader)
      ELSE
        ServLedgEntry.Amount := ServLedgEntry."Amount (LCY)";
    END;

    LOCAL PROCEDURE CalcInvoicedToDate@61(VAR ServContractLine@1000 : Record 5964;InvFrom@1001 : Date;InvTo@1002 : Date);
    BEGIN
      IF ServContractLine."Contract Expiration Date" <> 0D THEN BEGIN
        IF (ServContractLine."Contract Expiration Date" >= InvFrom) AND
           (ServContractLine."Contract Expiration Date" <= InvTo)
        THEN
          ServContractLine."Invoiced to Date" := ServContractLine."Contract Expiration Date"
        ELSE
          IF ServContractLine."Contract Expiration Date" > InvTo THEN
            ServContractLine."Invoiced to Date" := InvTo;
      END ELSE
        ServContractLine."Invoiced to Date" := InvTo;
    END;

    LOCAL PROCEDURE CreateDescriptionServiceLines@46(ServContractLineItemNo@1002 : Code[20];ServContractLineDesc@1001 : Text[50]);
    VAR
      ServLineDescription@1003 : Text;
      RequiredLength@1004 : Integer;
    BEGIN
      IF ServContractLineItemNo <> '' THEN BEGIN
        ServLineDescription := STRSUBSTNO('%1 %2',ServContractLineItemNo,ServContractLineDesc);
        RequiredLength := MAXSTRLEN(ServLine.Description);
        InsertDescriptionServiceLine(COPYSTR(ServLineDescription,1,RequiredLength));
        IF STRLEN(ServLineDescription) > RequiredLength THEN
          InsertDescriptionServiceLine(COPYSTR(ServLineDescription,RequiredLength + 1,RequiredLength))
      END ELSE
        InsertDescriptionServiceLine(ServContractLineDesc);
    END;

    LOCAL PROCEDURE InsertDescriptionServiceLine@48(Description@1002 : Text[50]);
    BEGIN
      ServLine.INIT;
      ServLine."Line No." := ServLine.GetNextLineNo(ServLine,TRUE);
      ServLine.Description := Description;
      ServLine.INSERT;
    END;

    LOCAL PROCEDURE UpdateApplyUntilEntryNoInServLedgEntry@45(ReturnLedgerEntry@1001 : Integer;FirstLineEntry@1002 : Integer;LastEntry@1003 : Integer);
    VAR
      ServLedgEntry@1000 : Record 5907;
    BEGIN
      IF ReturnLedgerEntry <> 0 THEN BEGIN
        ServLedgEntry.GET(FirstLineEntry);
        ServLedgEntry."Apply Until Entry No." := LastEntry;
        ServLedgEntry.MODIFY;
      END;
    END;

    LOCAL PROCEDURE PostPartialServLedgEntry@59(VAR InvAmountRounded@1004 : ARRAY [4] OF Decimal;ServContractLine@1000 : Record 5964;ServHeader@1001 : Record 5900;InvFrom@1002 : Date;InvTo@1005 : Date;DueDate@1007 : Date;AmtRoundingPrecision@1006 : Decimal) YearContractCorrection : Boolean;
    BEGIN
      ServLedgEntry."Service Item No. (Serviced)" := ServContractLine."Service Item No.";
      ServLedgEntry."Item No. (Serviced)" := ServContractLine."Item No.";
      ServLedgEntry."Serial No. (Serviced)" := ServContractLine."Serial No.";
      IF YearContract(ServContractLine."Contract Type",ServContractLine."Contract No.") THEN BEGIN
        YearContractCorrection := TRUE;
        CalcServLedgEntryAmounts(ServContractLine,InvAmountRounded);
        ServLedgEntry."Entry No." := NextEntry;
        UpdateServLedgEntryAmount(ServLedgEntry,ServHeader);
      END ELSE BEGIN
        YearContractCorrection := FALSE;
        SetServLedgEntryAmounts(
          ServLedgEntry,InvAmountRounded,
          -CalcContractLineAmount(ServContractLine."Line Amount",InvFrom,InvTo),
          -CalcContractLineAmount(ServContractLine."Line Value",InvFrom,InvTo),
          -CalcContractLineAmount(ServContractLine."Line Cost",InvFrom,InvTo),
          -CalcContractLineAmount(ServContractLine."Line Discount Amount",InvFrom,InvTo),
          AmtRoundingPrecision);
        ServLedgEntry."Entry No." := NextEntry;
        UpdateServLedgEntryAmount(ServLedgEntry,ServHeader);
      END;
      ServLedgEntry."Posting Date" := DueDate;
      ServLedgEntry.Prepaid := TRUE;
      ServLedgEntry.INSERT;
      NextEntry := NextEntry + 1;
      EXIT(YearContractCorrection);
    END;

    LOCAL PROCEDURE SetServLedgEntryAmounts@65(VAR ServLedgEntry@1000 : Record 5907;VAR EntryAmount@1006 : ARRAY [4] OF Decimal;Amount@1001 : Decimal;UnitPrice@1002 : Decimal;CostAmount@1003 : Decimal;DiscAmount@1004 : Decimal;AmtRoundingPrecision@1005 : Decimal);
    BEGIN
      ServLedgEntry."Amount (LCY)" := ROUND(Amount,AmtRoundingPrecision);
      ServLedgEntry."Unit Price" := ROUND(UnitPrice,AmtRoundingPrecision);
      ServLedgEntry."Unit Cost" := ROUND(CostAmount,AmtRoundingPrecision);
      ServLedgEntry."Contract Disc. Amount" := ROUND(DiscAmount,AmtRoundingPrecision);
      ServLedgEntry."Discount Amount" := ServLedgEntry."Contract Disc. Amount";
      CalcServLedgEntryDiscountPct(ServLedgEntry);
      EntryAmount[AmountType::Amount] -= ServLedgEntry."Amount (LCY)";
      EntryAmount[AmountType::UnitPrice] -= ServLedgEntry."Unit Price";
      EntryAmount[AmountType::UnitCost] += ServLedgEntry."Unit Cost";
      EntryAmount[AmountType::DiscAmount] += ServLedgEntry."Contract Disc. Amount";
    END;

    LOCAL PROCEDURE CalcInvAmounts@73(VAR InvAmount@1000 : ARRAY [4] OF Decimal;ServContractLine@1001 : Record 5964;InvFrom@1002 : Date;InvTo@1003 : Date);
    BEGIN
      InvAmount[AmountType::Amount] +=
        CalcContractLineAmount(ServContractLine."Line Amount",InvFrom,InvTo);
      InvAmount[AmountType::UnitPrice] +=
        CalcContractLineAmount(ServContractLine."Line Value",InvFrom,InvTo);
      InvAmount[AmountType::UnitCost] +=
        CalcContractLineAmount(ServContractLine."Line Cost",InvFrom,InvTo);
      InvAmount[AmountType::DiscAmount] +=
        CalcContractLineAmount(ServContractLine."Line Discount Amount",InvFrom,InvTo);
    END;

    LOCAL PROCEDURE InsertMultipleServLedgEntries@63(VAR NoOfPayments@1001 : Integer;VAR DueDate@1002 : Date;VAR NonDistrAmount@1005 : ARRAY [4] OF Decimal;VAR InvRoundedAmount@1011 : ARRAY [4] OF Decimal;VAR ServHeader@1004 : Record 5900;InvFrom@1006 : Date;NextInvDate@1007 : Date;AddingNewLines@1008 : Boolean;CountOfEntryLoop@1000 : Integer;ServContractLine@1003 : Record 5964;AmountRoundingPrecision@1010 : Decimal);
    VAR
      ServContractHeader@1012 : Record 5965;
      Index@1009 : Integer;
    BEGIN
      IF CountOfEntryLoop = 0 THEN
        EXIT;

      CheckMParts := FALSE;
      IF DueDate <> CALCDATE('<CM>',DueDate) THEN BEGIN
        DueDate := CALCDATE('<-CM-1D>',DueDate);
        ServContractHeader.GET(ServContractLine."Contract Type",ServContractLine."Contract No.");
        IF ServContractHeader."Contract Lines on Invoice" THEN
          CheckMParts := TRUE;
      END;
      NonDistrAmount[AmountType::Amount] :=
        -CalcContractLineAmount(ServContractLine."Line Amount",InvFrom,DueDate);
      NonDistrAmount[AmountType::UnitPrice] :=
        -CalcContractLineAmount(ServContractLine."Line Value",InvFrom,DueDate);
      NonDistrAmount[AmountType::UnitCost] :=
        CalcContractLineAmount(ServContractLine."Line Cost",InvFrom,DueDate);
      NonDistrAmount[AmountType::DiscAmount] :=
        CalcContractLineAmount(ServContractLine."Line Discount Amount",InvFrom,DueDate);
      ServLedgEntry."Service Item No. (Serviced)" := ServContractLine."Service Item No.";
      ServLedgEntry."Item No. (Serviced)" := ServContractLine."Item No.";
      ServLedgEntry."Serial No. (Serviced)" := ServContractLine."Serial No.";
      DueDate := NextInvDate;
      IF CheckMParts AND (NoOfPayments > 1) THEN
        NoOfPayments := NoOfPayments - 1;

      IF AddingNewLines THEN
        DueDate := InvFrom;
      FOR Index := 1 TO CountOfEntryLoop DO BEGIN
        SetServLedgEntryAmounts(
          ServLedgEntry,InvRoundedAmount,
          NonDistrAmount[AmountType::Amount] / (NoOfPayments + 1 - Index),
          NonDistrAmount[AmountType::UnitPrice] / (NoOfPayments + 1 - Index),
          NonDistrAmount[AmountType::UnitCost] / (NoOfPayments + 1 - Index),
          NonDistrAmount[AmountType::DiscAmount] / (NoOfPayments + 1 - Index),
          AmountRoundingPrecision);
        ServLedgEntry."Cost Amount" := ServLedgEntry."Charged Qty." * ServLedgEntry."Unit Cost";

        NonDistrAmount[AmountType::Amount] -= ServLedgEntry."Amount (LCY)";
        NonDistrAmount[AmountType::UnitPrice] -= ServLedgEntry."Unit Price";
        NonDistrAmount[AmountType::UnitCost] -= ServLedgEntry."Unit Cost";
        NonDistrAmount[AmountType::DiscAmount] -= ServLedgEntry."Contract Disc. Amount";

        ServLedgEntry."Entry No." := NextEntry;
        UpdateServLedgEntryAmount(ServLedgEntry,ServHeader);
        ServLedgEntry."Posting Date" := DueDate;
        ServLedgEntry.Prepaid := TRUE;
        ServLedgEntry.INSERT;
        NextEntry += 1;
        DueDate := CALCDATE('<1M>',DueDate);
      END;
    END;

    LOCAL PROCEDURE GetMaxDate@47(FirstDate@1000 : Date;SecondDate@1001 : Date) : Date;
    BEGIN
      IF FirstDate > SecondDate THEN
        EXIT(FirstDate);
      EXIT(SecondDate);
    END;

    LOCAL PROCEDURE SetSalespersonCode@218(SalesPersonCodeToCheck@1000 : Code[20];VAR SalesPersonCodeToAssign@1001 : Code[20]);
    BEGIN
      IF SalesPersonCodeToCheck <> '' THEN
        IF Salesperson.GET(SalesPersonCodeToCheck) THEN
          IF Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) THEN
            SalesPersonCodeToAssign := ''
          ELSE
            SalesPersonCodeToAssign := SalesPersonCodeToCheck;
    END;

    BEGIN
    END.
  }
}

