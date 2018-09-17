OBJECT Report 394 Suggest Employee Payments
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Foresl� medarbejderbetalinger;
               ENU=Suggest Employee Payments];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  CompanyInformation.GET;
                  TempEmployeeLedgerEntry.DELETEALL;
                  ShowPostingDateWarning := FALSE;
                END;

    OnPostReport=BEGIN
                   COMMIT;
                   IF NOT TempEmployeeLedgerEntry.ISEMPTY THEN
                     IF CONFIRM(UnprocessedEntriesQst) THEN
                       PAGE.RUNMODAL(0,TempEmployeeLedgerEntry);
                 END;

  }
  DATASET
  {
    { 3182;    ;DataItem;                    ;
               DataItemTable=Table5200;
               DataItemTableView=SORTING(No.)
                                 WHERE(Privacy Blocked=CONST(No));
               OnPreDataItem=BEGIN
                               IF PostingDate = 0D THEN
                                 ERROR(PostingDateRequiredErr);

                               BankPmtType := GenJnlLine2."Bank Payment Type";
                               BalAccType := GenJnlLine2."Bal. Account Type";
                               BalAccNo := GenJnlLine2."Bal. Account No.";
                               GenJnlLineInserted := FALSE;
                               MessageText := '';

                               IF ((BankPmtType = GenJnlLine2."Bank Payment Type"::" ") OR
                                   SummarizePerEmpl) AND
                                  (NextDocNo = '')
                               THEN
                                 ERROR(StartingDocNoErr);

                               IF ((BankPmtType = GenJnlLine2."Bank Payment Type"::"Manual Check") AND
                                   NOT SummarizePerEmpl AND
                                   NOT DocNoPerLine)
                               THEN
                                 ERROR(ManualCheckErr);

                               Empl2.COPYFILTERS(Employee);

                               OriginalAmtAvailable := AmountAvailable;

                               Window.OPEN(ProcessingEmployeesMsg);

                               SelectedDim.SETRANGE("User ID",USERID);
                               SelectedDim.SETRANGE("Object Type",3);
                               SelectedDim.SETRANGE("Object ID",REPORT::"Suggest Employee Payments");
                               SummarizePerDim := SelectedDim.FIND('-') AND SummarizePerEmpl;

                               NextEntryNo := 1;
                             END;

               OnAfterGetRecord=BEGIN
                                  CLEAR(EmployeeBalance);
                                  CALCFIELDS(Balance);
                                  EmployeeBalance := Balance;

                                  IF StopPayments THEN
                                    CurrReport.BREAK;
                                  Window.UPDATE(1,"No.");
                                  IF EmployeeBalance > 0 THEN BEGIN
                                    GetEmplLedgEntries(TRUE);
                                    GetEmplLedgEntries(FALSE);
                                    CheckAmounts;
                                    ClearNegative;
                                  END;
                                END;

               OnPostDataItem=BEGIN
                                IF FINDSET THEN
                                  REPEAT
                                    ClearNegative;
                                  UNTIL NEXT = 0;

                                DimSetEntry.LOCKTABLE;
                                GenJnlLine.LOCKTABLE;
                                GenJnlTemplate.GET(GenJnlLine."Journal Template Name");
                                GenJnlBatch.GET(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");
                                GenJnlLine.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
                                GenJnlLine.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
                                IF GenJnlLine.FINDLAST THEN BEGIN
                                  LastLineNo := GenJnlLine."Line No.";
                                  GenJnlLine.INIT;
                                END;

                                Window2.OPEN(InsertingJournalLinesMsg);

                                TempPayableEmployeeLedgerEntry.RESET;
                                MakeGenJnlLines;
                                TempPayableEmployeeLedgerEntry.RESET;
                                MakeGenJnlLines;
                                TempPayableEmployeeLedgerEntry.RESET;
                                TempPayableEmployeeLedgerEntry.DELETEALL;

                                Window2.CLOSE;
                                Window.CLOSE;
                                ShowMessage(MessageText);
                              END;

               ReqFilterFields=No. }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnInit=BEGIN
               SummarizePerDimTextEnable := TRUE;
               SkipExportedPayments := TRUE;
             END;

      OnOpenPage=BEGIN
                   PostingDate := WORKDATE;
                   ValidatePostingDate;
                   SetDefaults;
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options];
                  GroupType=Group }

      { 4   ;2   ;Group     ;
                  CaptionML=[DAN=Find betalinger;
                             ENU=Find Payments];
                  GroupType=Group }

      { 11  ;3   ;Field     ;
                  Name=Available Amount (LCY);
                  CaptionML=[DAN=Bel�b til r�dighed (RV);
                             ENU=Available Amount (LCY)];
                  ToolTipML=[DAN=Angiver et maksimalt bel�b (i RV), som er tilg�ngeligt for betalinger.;
                             ENU=Specifies a maximum amount (in LCY) that is available for payments.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=AmountAvailable;
                  Importance=Additional }

      { 13  ;3   ;Field     ;
                  Name=SkipExportedPayments;
                  CaptionML=[DAN=Spring over eksporterede betalinger;
                             ENU=Skip Exported Payments];
                  ToolTipML=[DAN=Angiver, om du ikke vil have batchjobbet til at inds�tte betalingskladdelinjer for bilag, hvor der allerede er eksporteret betalinger til en bankfil.;
                             ENU=Specifies if you do not want the batch job to insert payment journal lines for documents for which payments have already been exported to a bank file.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=SkipExportedPayments;
                  Importance=Additional }

      { 7   ;2   ;Group     ;
                  CaptionML=[DAN=Sammenfat resultater;
                             ENU=Summarize Results];
                  GroupType=Group }

      { 6   ;3   ;Field     ;
                  Name=SummarizePerEmployee;
                  CaptionML=[DAN=Sammenfat pr. medarbejder;
                             ENU=Summarize per Employee];
                  ToolTipML=[DAN=Angiver, om k�rslen skal oprette �n linje pr. medarbejder;
                             ENU=Specifies if you want the batch job to make one line per employee];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=SummarizePerEmpl }

      { 17  ;3   ;Field     ;
                  Name=SummarizePerDimText;
                  CaptionML=[DAN=Pr. dimension;
                             ENU=By Dimension];
                  ToolTipML=[DAN=Angiver de dimensioner, som k�rslen skal tage h�jde for.;
                             ENU=Specifies the dimensions that you want the batch job to consider.];
                  ApplicationArea=#Suite;
                  SourceExpr=SummarizePerDimText;
                  Importance=Additional;
                  Enabled=SummarizePerDimTextEnable;
                  Editable=FALSE;
                  OnAssistEdit=VAR
                                 DimSelectionBuf@1001 : Record 368;
                               BEGIN
                                 DimSelectionBuf.SetDimSelectionMultiple(3,REPORT::"Suggest Employee Payments",SummarizePerDimText);
                               END;
                                }

      { 8   ;2   ;Group     ;
                  CaptionML=[DAN=Udfyld kladdelinjer;
                             ENU=Fill in Journal Lines];
                  GroupType=Group }

      { 5   ;3   ;Field     ;
                  Name=PostingDate;
                  CaptionML=[DAN=Bogf�ringsdato;
                             ENU=Posting Date];
                  ToolTipML=[DAN=Angiver datoen for k�rslens bogf�ring. Arbejdsdatoen angives som standard, men du kan �ndre den.;
                             ENU=Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PostingDate;
                  Importance=Promoted;
                  OnValidate=BEGIN
                               ValidatePostingDate;
                             END;
                              }

      { 9   ;3   ;Field     ;
                  Name=StartingDocumentNo;
                  CaptionML=[DAN=Start bilagsnr.;
                             ENU=Starting Document No.];
                  ToolTipML=[DAN=Angiver det n�ste tilg�ngelige nummer i kladdek�rslens nummerserie. N�r du udf�rer k�rslen, vises dette bilagsnummer p� den f�rste betalingskladdelinje. Du kan ogs� udfylde feltet manuelt.;
                             ENU=Specifies the next available number in the number series for the journal batch that is linked to the payment journal. When you run the batch job, this is the document number that appears on the first payment journal line. You can also fill in this field manually.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=NextDocNo;
                  OnValidate=VAR
                               TextManagement@1000 : Codeunit 41;
                             BEGIN
                               IF NextDocNo <> '' THEN
                                 TextManagement.EvaluateIncStr(NextDocNo,StartingDocumentNoErr);
                             END;
                              }

      { 18  ;3   ;Field     ;
                  Name=NewDocNoPerLine;
                  CaptionML=[DAN=Nyt bilagsnr. pr. linje;
                             ENU=New Doc. No. per Line];
                  ToolTipML=[DAN=Angiver, om batchjobbet skal udfylde betalingskladdelinjerne automatisk med fortl�bende bilagsnumre med udgangspunkt i det bilagsnummer, der er angivet i feltet Start bilagsnr.;
                             ENU=Specifies if you want the batch job to fill in the payment journal lines with consecutive document numbers, starting with the document number specified in the Starting Document No. field.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=DocNoPerLine;
                  Importance=Additional }

      { 10  ;3   ;Field     ;
                  Name=BalAccountType;
                  CaptionML=[DAN=Modkontotype;
                             ENU=Bal. Account Type];
                  ToolTipML=[DAN=Angiver den modkontotype, som betalinger p� betalingskladden er bogf�rt til.;
                             ENU=Specifies the balancing account type that payments on the payment journal are posted to.];
                  OptionCaptionML=[DAN=Finanskonto,,,Bankkonto;
                                   ENU=G/L Account,,,Bank Account];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=GenJnlLine2."Bal. Account Type";
                  Importance=Additional;
                  OnValidate=BEGIN
                               GenJnlLine2."Bal. Account No." := '';
                             END;
                              }

      { 12  ;3   ;Field     ;
                  Name=BalAccountNo;
                  CaptionML=[DAN=Modkontonr.;
                             ENU=Bal. Account No.];
                  ToolTipML=[DAN=Angiver det modkontonummer, som betalinger p� betalingskladden er bogf�rt til.;
                             ENU=Specifies the balancing account number that payments on the payment journal are posted to.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=GenJnlLine2."Bal. Account No.";
                  Importance=Additional;
                  OnValidate=BEGIN
                               IF GenJnlLine2."Bal. Account No." <> '' THEN
                                 CASE GenJnlLine2."Bal. Account Type" OF
                                   GenJnlLine2."Bal. Account Type"::"G/L Account":
                                     GLAcc.GET(GenJnlLine2."Bal. Account No.");
                                   GenJnlLine2."Bal. Account Type"::Customer,
                                   GenJnlLine2."Bal. Account Type"::Vendor,
                                   GenJnlLine2."Bal. Account Type"::Employee:
                                     ERROR(AccountTypeErr,GenJnlLine2.FIELDCAPTION("Bal. Account Type"));
                                   GenJnlLine2."Bal. Account Type"::"Bank Account":
                                     BankAcc.GET(GenJnlLine2."Bal. Account No.");
                                 END;
                             END;

                  OnLookup=BEGIN
                             CASE GenJnlLine2."Bal. Account Type" OF
                               GenJnlLine2."Bal. Account Type"::"G/L Account":
                                 IF PAGE.RUNMODAL(0,GLAcc) = ACTION::LookupOK THEN
                                   GenJnlLine2."Bal. Account No." := GLAcc."No.";
                               GenJnlLine2."Bal. Account Type"::Customer,
                               GenJnlLine2."Bal. Account Type"::Vendor,
                               GenJnlLine2."Bal. Account Type"::Employee:
                                 ERROR(AccountTypeErr,GenJnlLine2.FIELDCAPTION("Bal. Account Type"));
                               GenJnlLine2."Bal. Account Type"::"Bank Account":
                                 IF PAGE.RUNMODAL(0,BankAcc) = ACTION::LookupOK THEN
                                   GenJnlLine2."Bal. Account No." := BankAcc."No.";
                             END;
                           END;
                            }

      { 14  ;3   ;Field     ;
                  Name=BankPaymentType;
                  CaptionML=[DAN=Bankbetalingstype;
                             ENU=Bank Payment Type];
                  ToolTipML=[DAN=Angiver den checktype, der skal anvendes, hvis du bruger Bankkonto som modkontotype.;
                             ENU=Specifies the check type to be used, if you use Bank Account as the balancing account type.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=GenJnlLine2."Bank Payment Type";
                  Importance=Additional;
                  OnValidate=BEGIN
                               IF (GenJnlLine2."Bal. Account Type" <> GenJnlLine2."Bal. Account Type"::"Bank Account") AND
                                  (GenJnlLine2."Bank Payment Type" > 0)
                               THEN
                                 ERROR(BankPaymentTypeErr);
                             END;
                              }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      PostingDateRequiredErr@1001 : TextConst 'DAN=I feltet Bogf�ringsdato skal du angive den dato, der bruges som bogf�ringsdato for kladdeposterne.;ENU=In the Posting Date field, specify the date that will be used as the posting date for the journal entries.';
      StartingDocNoErr@1002 : TextConst 'DAN=I feltet Startbilagsnr. skal du angive det f�rste bilagsnummer, der skal bruges.;ENU=In the Starting Document No. field, specify the first document number to be used.';
      ProcessingEmployeesMsg@1006 : TextConst '@@@=#1########## is for the progress dialog. Don''t translate that part of the string;DAN=Behandler medarbejdere          #1##########;ENU=Processing employees     #1##########';
      InsertingJournalLinesMsg@1008 : TextConst '@@@=#1########## is for the progress dialog. Don''t translate that part of the string;DAN=Inds�tter betalingskladdelinjer #1##########;ENU=Inserting payment journal lines #1##########';
      AccountTypeErr@1009 : TextConst '@@@=%1 - balancing account type;DAN=%1 skal v�re Finanskonto eller Bankkonto.;ENU=%1 must be G/L Account or Bank Account.';
      BankPaymentTypeErr@1010 : TextConst 'DAN=Bankbetalingstype skal udfyldes, n�r Modkontotype er angivet til bankkontoen.;ENU=Bank Payment Type field must be filled only when Bal. Account Type is set to Bank Account.';
      ManualCheckErr@1017 : TextConst 'DAN=N�r bankbetalingstypen er angivet til Manuel check, og du ikke har markeret feltet Sammenfat pr. medarbejder,\ skal du v�lge Nyt bilagsnr. pr. linje.;ENU=If bank payment type is set to Manual Check, and you have not selected the Summarize per Employee field,\ then you must select the New Doc. No. per Line.';
      EmployeePaymentLinesCreatedTxt@1022 : TextConst 'DAN=Du har oprettet foresl�ede medarbejderbetalingslinjer.;ENU=You have created suggested employee payment lines.';
      Empl2@1023 : Record 5200;
      GenJnlTemplate@1024 : Record 80;
      GenJnlBatch@1025 : Record 232;
      GenJnlLine@1026 : Record 81;
      DimSetEntry@1027 : Record 480;
      GenJnlLine2@1028 : Record 81;
      EmployeeLedgerEntry@1029 : Record 5222;
      GLAcc@1030 : Record 15;
      BankAcc@1031 : Record 270;
      TempPayableEmployeeLedgerEntry@1032 : TEMPORARY Record 5224;
      CompanyInformation@1062 : Record 79;
      TempEmplPaymentBuffer@1033 : TEMPORARY Record 5225;
      OldTempEmplPaymentBuffer@1034 : TEMPORARY Record 5225;
      SelectedDim@1035 : Record 369;
      TempEmployeeLedgerEntry@1102601000 : TEMPORARY Record 5222;
      NoSeriesMgt@1036 : Codeunit 396;
      DimMgt@1038 : Codeunit 408;
      DimBufMgt@1018 : Codeunit 411;
      Window@1039 : Dialog;
      Window2@1004 : Dialog;
      PostingDate@1041 : Date;
      NextDocNo@1043 : Code[20];
      AmountAvailable@1044 : Decimal;
      OriginalAmtAvailable@1045 : Decimal;
      SummarizePerEmpl@1047 : Boolean;
      SummarizePerDim@1048 : Boolean;
      SummarizePerDimText@1049 : Text[250];
      LastLineNo@1051 : Integer;
      NextEntryNo@1052 : Integer;
      StopPayments@1053 : Boolean;
      DocNoPerLine@1054 : Boolean;
      BankPmtType@1055 : Option;
      BalAccType@1056 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
      BalAccNo@1057 : Code[20];
      MessageText@1058 : Text;
      GenJnlLineInserted@1059 : Boolean;
      UnprocessedEntriesQst@1102601001 : TextConst 'DAN=Der findes en eller flere poster, hvortil der ikke er angivet betalingsforslag, fordi bogf�ringsdatoerne i for posterne er senere end den anmodede bogf�ringsdato. Vil du se posterne?;ENU=There are one or more entries for which no payment suggestions have been made because the posting dates of the entries are later than the requested posting date. Do you want to see the entries?';
      SummarizePerDimTextEnable@19039578 : Boolean INDATASET;
      ShowPostingDateWarning@1119 : Boolean;
      EmployeeBalance@1065 : Decimal;
      ReplacePostingDateMsg@1064 : TextConst 'DAN=Den anmodede bogf�ringsdato for en eller flere poster ligger f�r arbejdsdatoen.\\Disse bogf�ringsdatoer anvender arbejdsdatoen.;ENU=For one or more entries, the requested posting date is before the work date.\\These posting dates will use the work date.';
      SkipExportedPayments@1019 : Boolean;
      StartingDocumentNoErr@1012 : TextConst 'DAN=Start bilagsnr.;ENU=Starting Document No.';
      UnsupportedCurrencyErr@1007 : TextConst 'DAN=Modkontoen skal have lokale valuta.;ENU=The balancing bank account must have local currency.';

    PROCEDURE SetGenJnlLine@1(NewGenJnlLine@1000 : Record 81);
    BEGIN
      GenJnlLine := NewGenJnlLine;
    END;

    LOCAL PROCEDURE ValidatePostingDate@7();
    BEGIN
      GenJnlBatch.GET(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");
      IF GenJnlBatch."No. Series" = '' THEN
        NextDocNo := ''
      ELSE BEGIN
        NextDocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series",PostingDate,FALSE);
        CLEAR(NoSeriesMgt);
      END;
    END;

    PROCEDURE InitializeRequest@3(NewAvailableAmount@1002 : Decimal;NewSkipExportedPayments@1009 : Boolean;NewPostingDate@1003 : Date;NewStartDocNo@1004 : Code[20];NewSummarizePerEmpl@1005 : Boolean;BalAccType@1006 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';BalAccNo@1007 : Code[20];BankPmtType@1008 : Option);
    BEGIN
      AmountAvailable := NewAvailableAmount;
      SkipExportedPayments := NewSkipExportedPayments;
      PostingDate := NewPostingDate;
      NextDocNo := NewStartDocNo;
      SummarizePerEmpl := NewSummarizePerEmpl;
      GenJnlLine2."Bal. Account Type" := BalAccType;
      GenJnlLine2."Bal. Account No." := BalAccNo;
      GenJnlLine2."Bank Payment Type" := BankPmtType;
    END;

    LOCAL PROCEDURE GetEmplLedgEntries@13(Positive@1000 : Boolean);
    BEGIN
      EmployeeLedgerEntry.RESET;
      EmployeeLedgerEntry.SETCURRENTKEY("Employee No.",Open,Positive);
      EmployeeLedgerEntry.SETRANGE("Employee No.",Employee."No.");
      EmployeeLedgerEntry.SETRANGE(Open,TRUE);
      EmployeeLedgerEntry.SETRANGE(Positive,Positive);
      EmployeeLedgerEntry.SETRANGE("Applies-to ID",'');

      IF SkipExportedPayments THEN
        EmployeeLedgerEntry.SETRANGE("Exported to Payment File",FALSE);
      EmployeeLedgerEntry.SETFILTER("Global Dimension 1 Code",Employee.GETFILTER("Global Dimension 1 Filter"));
      EmployeeLedgerEntry.SETFILTER("Global Dimension 2 Code",Employee.GETFILTER("Global Dimension 2 Filter"));

      IF EmployeeLedgerEntry.FINDSET THEN
        REPEAT
          SaveAmount;
        UNTIL EmployeeLedgerEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE SaveAmount@6();
    BEGIN
      WITH GenJnlLine DO BEGIN
        INIT;
        VALIDATE("Posting Date",PostingDate);
        "Document Type" := "Document Type"::Payment;
        "Account Type" := "Account Type"::Employee;
        Empl2.GET(EmployeeLedgerEntry."Employee No.");
        Description := COPYSTR(Empl2.FullName,1,MAXSTRLEN(Description));
        "Posting Group" := Empl2."Employee Posting Group";
        "Salespers./Purch. Code" := Empl2."Salespers./Purch. Code";
        VALIDATE("Bill-to/Pay-to No.","Account No.");
        VALIDATE("Sell-to/Buy-from No.","Account No.");
        "Gen. Posting Type" := 0;
        "Gen. Prod. Posting Group" := '';
        "Gen. Bus. Posting Group" := '';
        "VAT Bus. Posting Group" := '';
        "VAT Prod. Posting Group" := '';
        VALIDATE("Currency Code",EmployeeLedgerEntry."Currency Code");
        EmployeeLedgerEntry.CALCFIELDS("Remaining Amount");
        Amount := -EmployeeLedgerEntry."Remaining Amount";
        VALIDATE(Amount);
      END;

      TempPayableEmployeeLedgerEntry."Employee No." := EmployeeLedgerEntry."Employee No.";
      TempPayableEmployeeLedgerEntry."Entry No." := NextEntryNo;
      TempPayableEmployeeLedgerEntry."Employee Ledg. Entry No." := EmployeeLedgerEntry."Entry No.";
      TempPayableEmployeeLedgerEntry.Amount := GenJnlLine.Amount;
      TempPayableEmployeeLedgerEntry.Positive := (TempPayableEmployeeLedgerEntry.Amount > 0);
      TempPayableEmployeeLedgerEntry."Currency Code" := EmployeeLedgerEntry."Currency Code";
      TempPayableEmployeeLedgerEntry.INSERT;
      NextEntryNo := NextEntryNo + 1;
    END;

    LOCAL PROCEDURE CheckAmounts@10();
    VAR
      CurrencyBalance@1001 : Decimal;
      PrevCurrency@1002 : Code[10];
    BEGIN
      TempPayableEmployeeLedgerEntry.SETRANGE("Employee No.",Employee."No.");

      IF TempPayableEmployeeLedgerEntry.FIND('-') THEN BEGIN
        REPEAT
          IF TempPayableEmployeeLedgerEntry."Currency Code" <> PrevCurrency THEN BEGIN
            IF CurrencyBalance > 0 THEN
              AmountAvailable := AmountAvailable - CurrencyBalance;
            CurrencyBalance := 0;
            PrevCurrency := TempPayableEmployeeLedgerEntry."Currency Code";
          END;
          IF (OriginalAmtAvailable = 0) OR
             (AmountAvailable >= CurrencyBalance + TempPayableEmployeeLedgerEntry.Amount)
          THEN
            CurrencyBalance := CurrencyBalance + TempPayableEmployeeLedgerEntry.Amount
          ELSE
            TempPayableEmployeeLedgerEntry.DELETE;
        UNTIL TempPayableEmployeeLedgerEntry.NEXT = 0;
        IF OriginalAmtAvailable > 0 THEN
          AmountAvailable := AmountAvailable - CurrencyBalance;
        IF (OriginalAmtAvailable > 0) AND (AmountAvailable <= 0) THEN
          StopPayments := TRUE;
      END;
      TempPayableEmployeeLedgerEntry.RESET;
    END;

    LOCAL PROCEDURE MakeGenJnlLines@2();
    VAR
      RemainingAmtAvailable@1008 : Decimal;
    BEGIN
      TempEmplPaymentBuffer.RESET;
      TempEmplPaymentBuffer.DELETEALL;

      IF BalAccType = BalAccType::"Bank Account" THEN
        CheckCurrencies(BalAccType,BalAccNo);

      IF OriginalAmtAvailable <> 0 THEN BEGIN
        RemainingAmtAvailable := OriginalAmtAvailable;
        RemovePaymentsAboveLimit(TempPayableEmployeeLedgerEntry,RemainingAmtAvailable);
      END;

      CopyEmployeeLedgerEntriesToTempEmplPaymentBuffer(RemainingAmtAvailable);
      CopyTempEmpPaymentBuffersToGenJnlLines;
    END;

    LOCAL PROCEDURE CopyEmployeeLedgerEntriesToTempEmplPaymentBuffer@21(RemainingAmtAvailable@1001 : Decimal);
    VAR
      DimBuf@1000 : Record 360;
    BEGIN
      IF TempPayableEmployeeLedgerEntry.FIND('-') THEN
        REPEAT
          TempPayableEmployeeLedgerEntry.SETRANGE("Employee No.",TempPayableEmployeeLedgerEntry."Employee No.");
          TempPayableEmployeeLedgerEntry.FIND('-');
          REPEAT
            EmployeeLedgerEntry.GET(TempPayableEmployeeLedgerEntry."Employee Ledg. Entry No.");

            TempEmplPaymentBuffer."Employee No." := EmployeeLedgerEntry."Employee No.";
            TempEmplPaymentBuffer."Currency Code" := EmployeeLedgerEntry."Currency Code";
            TempEmplPaymentBuffer."Payment Method Code" := EmployeeLedgerEntry."Payment Method Code";
            TempEmplPaymentBuffer."Creditor No." := EmployeeLedgerEntry."Creditor No.";
            TempEmplPaymentBuffer."Payment Reference" := EmployeeLedgerEntry."Payment Reference";
            TempEmplPaymentBuffer."Exported to Payment File" := EmployeeLedgerEntry."Exported to Payment File";

            SetTempEmplPaymentBufferDims(DimBuf);

            EmployeeLedgerEntry.CALCFIELDS("Remaining Amount");

            IF SummarizePerEmpl THEN BEGIN
              TempEmplPaymentBuffer."Employee Ledg. Entry No." := 0;
              IF TempEmplPaymentBuffer.FIND THEN BEGIN
                TempEmplPaymentBuffer.Amount := TempEmplPaymentBuffer.Amount + TempPayableEmployeeLedgerEntry.Amount;
                TempEmplPaymentBuffer.MODIFY;
              END ELSE BEGIN
                TempEmplPaymentBuffer."Document No." := NextDocNo;
                NextDocNo := INCSTR(NextDocNo);
                TempEmplPaymentBuffer.Amount := TempPayableEmployeeLedgerEntry.Amount;
                Window2.UPDATE(1,EmployeeLedgerEntry."Employee No.");
                TempEmplPaymentBuffer.INSERT;
              END;
              EmployeeLedgerEntry."Applies-to ID" := TempEmplPaymentBuffer."Document No.";
            END ELSE
              IF NOT IsEntryAlreadyApplied(GenJnlLine,EmployeeLedgerEntry) THEN BEGIN
                TempEmplPaymentBuffer."Employee Ledg. Entry Doc. Type" := EmployeeLedgerEntry."Document Type";
                TempEmplPaymentBuffer."Employee Ledg. Entry Doc. No." := EmployeeLedgerEntry."Document No.";
                TempEmplPaymentBuffer."Global Dimension 1 Code" := EmployeeLedgerEntry."Global Dimension 1 Code";
                TempEmplPaymentBuffer."Global Dimension 2 Code" := EmployeeLedgerEntry."Global Dimension 2 Code";
                TempEmplPaymentBuffer."Dimension Set ID" := EmployeeLedgerEntry."Dimension Set ID";
                TempEmplPaymentBuffer."Employee Ledg. Entry No." := EmployeeLedgerEntry."Entry No.";
                TempEmplPaymentBuffer.Amount := TempPayableEmployeeLedgerEntry.Amount;
                Window2.UPDATE(1,EmployeeLedgerEntry."Employee No.");
                TempEmplPaymentBuffer.INSERT;
              END;

            EmployeeLedgerEntry."Amount to Apply" := EmployeeLedgerEntry."Remaining Amount";
            CODEUNIT.RUN(CODEUNIT::"Empl. Entry-Edit",EmployeeLedgerEntry);

            TempPayableEmployeeLedgerEntry.DELETE;
            IF OriginalAmtAvailable <> 0 THEN BEGIN
              RemainingAmtAvailable := RemainingAmtAvailable - TempPayableEmployeeLedgerEntry.Amount;
              RemovePaymentsAboveLimit(TempPayableEmployeeLedgerEntry,RemainingAmtAvailable);
            END;

          UNTIL NOT TempPayableEmployeeLedgerEntry.FINDSET;
          TempPayableEmployeeLedgerEntry.DELETEALL;
          TempPayableEmployeeLedgerEntry.SETRANGE("Employee No.");
        UNTIL NOT TempPayableEmployeeLedgerEntry.FIND('-');
    END;

    LOCAL PROCEDURE CopyTempEmpPaymentBuffersToGenJnlLines@11();
    VAR
      Employee@1000 : Record 5200;
    BEGIN
      CLEAR(OldTempEmplPaymentBuffer);
      TempEmplPaymentBuffer.SETCURRENTKEY("Document No.");
      TempEmplPaymentBuffer.SETFILTER(
        "Employee Ledg. Entry Doc. Type",'<>%1&<>%2',TempEmplPaymentBuffer."Employee Ledg. Entry Doc. Type"::Refund,
        TempEmplPaymentBuffer."Employee Ledg. Entry Doc. Type"::Payment);
      IF TempEmplPaymentBuffer.FINDSET THEN
        REPEAT
          WITH GenJnlLine DO BEGIN
            INIT;
            Window2.UPDATE(1,TempEmplPaymentBuffer."Employee No.");
            LastLineNo := LastLineNo + 10000;
            "Line No." := LastLineNo;
            "Document Type" := "Document Type"::Payment;
            "Posting No. Series" := GenJnlBatch."Posting No. Series";
            IF SummarizePerEmpl THEN
              "Document No." := TempEmplPaymentBuffer."Document No."
            ELSE
              IF DocNoPerLine THEN BEGIN
                IF TempEmplPaymentBuffer.Amount < 0 THEN
                  "Document Type" := "Document Type"::Refund;

                "Document No." := NextDocNo;
                NextDocNo := INCSTR(NextDocNo);
              END ELSE
                IF (TempEmplPaymentBuffer."Employee No." = OldTempEmplPaymentBuffer."Employee No.") AND
                   (TempEmplPaymentBuffer."Currency Code" = OldTempEmplPaymentBuffer."Currency Code")
                THEN
                  "Document No." := OldTempEmplPaymentBuffer."Document No."
                ELSE BEGIN
                  "Document No." := NextDocNo;
                  NextDocNo := INCSTR(NextDocNo);
                  OldTempEmplPaymentBuffer := TempEmplPaymentBuffer;
                  OldTempEmplPaymentBuffer."Document No." := "Document No.";
                END;
            "Account Type" := "Account Type"::Employee;
            SetHideValidation(TRUE);
            VALIDATE("Posting Date",PostingDate);
            VALIDATE("Account No.",TempEmplPaymentBuffer."Employee No.");
            VALIDATE("Recipient Bank Account",TempEmplPaymentBuffer."Employee No.");
            Employee.GET(TempEmplPaymentBuffer."Employee No.");

            "Bal. Account Type" := BalAccType;
            VALIDATE("Bal. Account No.",BalAccNo);
            VALIDATE("Currency Code",TempEmplPaymentBuffer."Currency Code");
            "Message to Recipient" := CompanyInformation.Name;
            "Bank Payment Type" := BankPmtType;
            IF SummarizePerEmpl THEN
              "Applies-to ID" := "Document No.";
            Description := COPYSTR(Employee.FullName,1,MAXSTRLEN(Description));
            "Source Line No." := TempEmplPaymentBuffer."Employee Ledg. Entry No.";
            "Shortcut Dimension 1 Code" := TempEmplPaymentBuffer."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := TempEmplPaymentBuffer."Global Dimension 2 Code";
            "Dimension Set ID" := TempEmplPaymentBuffer."Dimension Set ID";
            "Source Code" := GenJnlTemplate."Source Code";
            "Reason Code" := GenJnlBatch."Reason Code";
            VALIDATE(Amount,TempEmplPaymentBuffer.Amount);
            "Applies-to Doc. Type" := TempEmplPaymentBuffer."Employee Ledg. Entry Doc. Type";
            "Applies-to Doc. No." := TempEmplPaymentBuffer."Employee Ledg. Entry Doc. No.";
            "Payment Method Code" := TempEmplPaymentBuffer."Payment Method Code";
            "Creditor No." := COPYSTR(TempEmplPaymentBuffer."Creditor No.",1,MAXSTRLEN("Creditor No."));
            "Payment Reference" := COPYSTR(TempEmplPaymentBuffer."Payment Reference",1,MAXSTRLEN("Payment Reference"));
            "Exported to Payment File" := TempEmplPaymentBuffer."Exported to Payment File";
            "Applies-to Ext. Doc. No." := TempEmplPaymentBuffer."Applies-to Ext. Doc. No.";

            UpdateDimensions(GenJnlLine);
            INSERT;
            GenJnlLineInserted := TRUE;
          END;
        UNTIL TempEmplPaymentBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE UpdateDimensions@17(VAR GenJnlLine@1005 : Record 81);
    VAR
      DimBuf@1002 : Record 360;
      TempDimSetEntry@1001 : TEMPORARY Record 480;
      TempDimSetEntry2@1000 : TEMPORARY Record 480;
      DimVal@1004 : Record 349;
      NewDimensionID@1003 : Integer;
      DimSetIDArr@1006 : ARRAY [10] OF Integer;
    BEGIN
      WITH GenJnlLine DO BEGIN
        NewDimensionID := "Dimension Set ID";
        IF SummarizePerEmpl THEN BEGIN
          DimBuf.RESET;
          DimBuf.DELETEALL;
          DimBufMgt.GetDimensions(TempEmplPaymentBuffer."Dimension Entry No.",DimBuf);
          IF DimBuf.FINDSET THEN
            REPEAT
              DimVal.GET(DimBuf."Dimension Code",DimBuf."Dimension Value Code");
              TempDimSetEntry."Dimension Code" := DimBuf."Dimension Code";
              TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
              TempDimSetEntry."Dimension Value Code" := DimBuf."Dimension Value Code";
              TempDimSetEntry.INSERT;
            UNTIL DimBuf.NEXT = 0;
          NewDimensionID := DimMgt.GetDimensionSetID(TempDimSetEntry);
          "Dimension Set ID" := NewDimensionID;
        END;
        CreateDim(
          DimMgt.TypeToTableID1("Account Type"),"Account No.",
          DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
          DATABASE::Job,"Job No.",
          DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
          DATABASE::Campaign,"Campaign No.");
        IF NewDimensionID <> "Dimension Set ID" THEN BEGIN
          DimSetIDArr[2] := NewDimensionID;
          DimSetIDArr[1] := "Dimension Set ID";
          "Dimension Set ID" :=
            DimMgt.GetCombinedDimensionSetID(DimSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        END;

        IF SummarizePerEmpl THEN BEGIN
          DimMgt.GetDimensionSet(TempDimSetEntry,"Dimension Set ID");
          IF AdjustAgainstSelectedDim(TempDimSetEntry,TempDimSetEntry2) THEN
            "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry2);
          DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code",
            "Shortcut Dimension 2 Code");
        END;
      END;
    END;

    LOCAL PROCEDURE ShowMessage@15(Text@1000 : Text);
    BEGIN
      IF GenJnlLineInserted THEN BEGIN
        IF ShowPostingDateWarning THEN
          Text += ReplacePostingDateMsg;
        IF Text <> '' THEN
          MESSAGE(Text);
      END;
    END;

    LOCAL PROCEDURE CheckCurrencies@4(BalAccType@1000 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';BalAccNo@1001 : Code[20]);
    VAR
      BankAcc@1003 : Record 270;
    BEGIN
      IF BalAccType = BalAccType::"Bank Account" THEN
        IF BalAccNo <> '' THEN BEGIN
          BankAcc.GET(BalAccNo);
          IF BankAcc."Currency Code" <> '' THEN
            ERROR(UnsupportedCurrencyErr);

          MessageText := EmployeePaymentLinesCreatedTxt;
        END;
    END;

    LOCAL PROCEDURE ClearNegative@8();
    VAR
      TempCurrency@1000 : TEMPORARY Record 4;
      TempPayableEmplLedgEntry2@1001 : TEMPORARY Record 5224;
      CurrencyBalance@1002 : Decimal;
    BEGIN
      CLEAR(TempPayableEmployeeLedgerEntry);
      TempPayableEmployeeLedgerEntry.SETRANGE("Employee No.",Employee."No.");

      WHILE TempPayableEmployeeLedgerEntry.NEXT <> 0 DO BEGIN
        TempCurrency.Code := TempPayableEmployeeLedgerEntry."Currency Code";
        CurrencyBalance := 0;
        IF TempCurrency.INSERT THEN BEGIN
          TempPayableEmplLedgEntry2 := TempPayableEmployeeLedgerEntry;
          TempPayableEmplLedgEntry2.SETRANGE("Currency Code",TempPayableEmployeeLedgerEntry."Currency Code");
          REPEAT
            CurrencyBalance := CurrencyBalance + TempPayableEmployeeLedgerEntry.Amount
          UNTIL TempPayableEmployeeLedgerEntry.NEXT = 0;
          IF CurrencyBalance < 0 THEN BEGIN
            TempPayableEmployeeLedgerEntry.DELETEALL;
            AmountAvailable += CurrencyBalance;
          END;
          TempPayableEmployeeLedgerEntry.SETRANGE("Currency Code");
          TempPayableEmployeeLedgerEntry := TempPayableEmplLedgEntry2;
        END;
      END;
      TempPayableEmployeeLedgerEntry.RESET;
    END;

    LOCAL PROCEDURE DimCodeIsInDimBuf@1101(DimCode@1111 : Code[20];DimBuf@1112 : Record 360) : Boolean;
    BEGIN
      DimBuf.RESET;
      DimBuf.SETRANGE("Dimension Code",DimCode);
      EXIT(NOT DimBuf.ISEMPTY);
    END;

    LOCAL PROCEDURE RemovePaymentsAboveLimit@5(VAR PayableEmplLedgEntry@1000 : Record 5224;RemainingAmtAvailable@1001 : Decimal);
    BEGIN
      PayableEmplLedgEntry.SETFILTER(Amount,'>%1',RemainingAmtAvailable);
      PayableEmplLedgEntry.DELETEALL;
      PayableEmplLedgEntry.SETRANGE(Amount);
    END;

    LOCAL PROCEDURE InsertDimBuf@9(VAR DimBuf@1004 : Record 360;TableID@1000 : Integer;EntryNo@1001 : Integer;DimCode@1002 : Code[20];DimValue@1003 : Code[20]);
    BEGIN
      DimBuf.INIT;
      DimBuf."Table ID" := TableID;
      DimBuf."Entry No." := EntryNo;
      DimBuf."Dimension Code" := DimCode;
      DimBuf."Dimension Value Code" := DimValue;
      DimBuf.INSERT;
    END;

    LOCAL PROCEDURE AdjustAgainstSelectedDim@16(VAR TempDimSetEntry@1000 : TEMPORARY Record 480;VAR TempDimSetEntry2@1003 : TEMPORARY Record 480) : Boolean;
    BEGIN
      IF SelectedDim.FINDSET THEN BEGIN
        REPEAT
          TempDimSetEntry.SETRANGE("Dimension Code",SelectedDim."Dimension Code");
          IF TempDimSetEntry.FINDFIRST THEN BEGIN
            TempDimSetEntry2.TRANSFERFIELDS(TempDimSetEntry,TRUE);
            TempDimSetEntry2.INSERT;
          END;
        UNTIL SelectedDim.NEXT = 0;
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE SetTempEmplPaymentBufferDims@12(VAR DimBuf@1000 : Record 360);
    VAR
      GLSetup@1003 : Record 98;
      EntryNo@1001 : Integer;
    BEGIN
      IF SummarizePerDim THEN BEGIN
        DimBuf.RESET;
        DimBuf.DELETEALL;
        IF SelectedDim.FIND('-') THEN
          REPEAT
            IF DimSetEntry.GET(
                 EmployeeLedgerEntry."Dimension Set ID",SelectedDim."Dimension Code")
            THEN
              InsertDimBuf(DimBuf,DATABASE::"Dimension Buffer",0,DimSetEntry."Dimension Code",
                DimSetEntry."Dimension Value Code");
          UNTIL SelectedDim.NEXT = 0;
        EntryNo := DimBufMgt.FindDimensions(DimBuf);
        IF EntryNo = 0 THEN
          EntryNo := DimBufMgt.InsertDimensions(DimBuf);
        TempEmplPaymentBuffer."Dimension Entry No." := EntryNo;
        IF TempEmplPaymentBuffer."Dimension Entry No." <> 0 THEN BEGIN
          GLSetup.GET;
          IF DimCodeIsInDimBuf(GLSetup."Global Dimension 1 Code",DimBuf) THEN
            TempEmplPaymentBuffer."Global Dimension 1 Code" := EmployeeLedgerEntry."Global Dimension 1 Code"
          ELSE
            TempEmplPaymentBuffer."Global Dimension 1 Code" := '';
          IF DimCodeIsInDimBuf(GLSetup."Global Dimension 2 Code",DimBuf) THEN
            TempEmplPaymentBuffer."Global Dimension 2 Code" := EmployeeLedgerEntry."Global Dimension 2 Code"
          ELSE
            TempEmplPaymentBuffer."Global Dimension 2 Code" := '';
        END ELSE BEGIN
          TempEmplPaymentBuffer."Global Dimension 1 Code" := '';
          TempEmplPaymentBuffer."Global Dimension 2 Code" := '';
        END;
        TempEmplPaymentBuffer."Dimension Set ID" := EmployeeLedgerEntry."Dimension Set ID";
      END ELSE BEGIN
        TempEmplPaymentBuffer."Dimension Entry No." := 0;
        TempEmplPaymentBuffer."Global Dimension 1 Code" := '';
        TempEmplPaymentBuffer."Global Dimension 2 Code" := '';
        TempEmplPaymentBuffer."Dimension Set ID" := 0;
      END;
    END;

    LOCAL PROCEDURE IsEntryAlreadyApplied@19(GenJnlLine3@1000 : Record 81;EmplLedgEntry2@1001 : Record 5222) : Boolean;
    VAR
      GenJnlLine4@1002 : Record 81;
    BEGIN
      GenJnlLine4.SETRANGE("Journal Template Name",GenJnlLine3."Journal Template Name");
      GenJnlLine4.SETRANGE("Journal Batch Name",GenJnlLine3."Journal Batch Name");
      GenJnlLine4.SETRANGE("Account Type",GenJnlLine4."Account Type"::Employee);
      GenJnlLine4.SETRANGE("Account No.",EmplLedgEntry2."Employee No.");
      GenJnlLine4.SETRANGE("Applies-to Doc. Type",EmplLedgEntry2."Document Type");
      GenJnlLine4.SETRANGE("Applies-to Doc. No.",EmplLedgEntry2."Document No.");
      EXIT(NOT GenJnlLine4.ISEMPTY);
    END;

    LOCAL PROCEDURE SetDefaults@14();
    BEGIN
      GenJnlBatch.GET(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");
      GenJnlLine2."Bal. Account Type" := GenJnlBatch."Bal. Account Type";
      GenJnlLine2."Bal. Account No." := GenJnlBatch."Bal. Account No.";
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

