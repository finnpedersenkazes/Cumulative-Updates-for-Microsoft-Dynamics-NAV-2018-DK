OBJECT Report 393 Suggest Vendor Payments
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lav kreditorbetalingsforslag;
               ENU=Suggest Vendor Payments];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  CompanyInformation.GET;
                  VendorLedgEntryTemp.DELETEALL;
                  ShowPostingDateWarning := FALSE;
                END;

    OnPostReport=BEGIN
                   COMMIT;
                   IF NOT VendorLedgEntryTemp.ISEMPTY THEN
                     IF CONFIRM(Text024) THEN
                       PAGE.RUNMODAL(0,VendorLedgEntryTemp);
                 END;

  }
  DATASET
  {
    { 3182;    ;DataItem;                    ;
               DataItemTable=Table23;
               DataItemTableView=SORTING(No.)
                                 WHERE(Blocked=FILTER(=' '));
               OnPreDataItem=BEGIN
                               IF LastDueDateToPayReq = 0D THEN
                                 ERROR(Text000);
                               IF (PostingDate = 0D) AND (NOT UseDueDateAsPostingDate) THEN
                                 ERROR(Text001);

                               BankPmtType := GenJnlLine2."Bank Payment Type";
                               BalAccType := GenJnlLine2."Bal. Account Type";
                               BalAccNo := GenJnlLine2."Bal. Account No.";
                               GenJnlLineInserted := FALSE;
                               SeveralCurrencies := FALSE;
                               MessageText := '';

                               IF ((BankPmtType = GenJnlLine2."Bank Payment Type"::" ") OR
                                   SummarizePerVend) AND
                                  (NextDocNo = '')
                               THEN
                                 ERROR(Text002);

                               IF ((BankPmtType = GenJnlLine2."Bank Payment Type"::"Manual Check") AND
                                   NOT SummarizePerVend AND
                                   NOT DocNoPerLine)
                               THEN
                                 ERROR(Text017,GenJnlLine2.FIELDCAPTION("Bank Payment Type"),FORMAT(GenJnlLine2."Bank Payment Type"::"Manual Check"));

                               IF UsePaymentDisc AND (LastDueDateToPayReq < WORKDATE) THEN
                                 IF NOT CONFIRM(Text003,FALSE,WORKDATE) THEN
                                   ERROR(Text005);

                               Vend2.COPYFILTERS(Vendor);

                               OriginalAmtAvailable := AmountAvailable;
                               IF UsePriority THEN BEGIN
                                 SETCURRENTKEY(Priority);
                                 SETRANGE(Priority,1,2147483647);
                                 UsePriority := TRUE;
                               END;
                               Window.OPEN(Text006);

                               SelectedDim.SETRANGE("User ID",USERID);
                               SelectedDim.SETRANGE("Object Type",3);
                               SelectedDim.SETRANGE("Object ID",REPORT::"Suggest Vendor Payments");
                               SummarizePerDim := SelectedDim.FIND('-') AND SummarizePerVend;

                               NextEntryNo := 1;
                             END;

               OnAfterGetRecord=BEGIN
                                  CLEAR(VendorBalance);
                                  CALCFIELDS("Balance (LCY)");
                                  VendorBalance := "Balance (LCY)";

                                  IF StopPayments THEN
                                    CurrReport.BREAK;
                                  Window.UPDATE(1,"No.");
                                  IF VendorBalance > 0 THEN BEGIN
                                    GetVendLedgEntries(TRUE,FALSE);
                                    GetVendLedgEntries(FALSE,FALSE);
                                    CheckAmounts(FALSE);
                                    ClearNegative;
                                  END;
                                END;

               OnPostDataItem=BEGIN
                                IF UsePriority AND NOT StopPayments THEN BEGIN
                                  RESET;
                                  COPYFILTERS(Vend2);
                                  SETCURRENTKEY(Priority);
                                  SETRANGE(Priority,0);
                                  IF FIND('-') THEN
                                    REPEAT
                                      CLEAR(VendorBalance);
                                      CALCFIELDS("Balance (LCY)");
                                      VendorBalance := "Balance (LCY)";
                                      IF VendorBalance > 0 THEN BEGIN
                                        Window.UPDATE(1,"No.");
                                        GetVendLedgEntries(TRUE,FALSE);
                                        GetVendLedgEntries(FALSE,FALSE);
                                        CheckAmounts(FALSE);
                                        ClearNegative;
                                      END;
                                    UNTIL (NEXT = 0) OR StopPayments;
                                END;

                                IF UsePaymentDisc AND NOT StopPayments THEN BEGIN
                                  RESET;
                                  COPYFILTERS(Vend2);
                                  Window2.OPEN(Text007);
                                  IF FIND('-') THEN
                                    REPEAT
                                      CLEAR(VendorBalance);
                                      CALCFIELDS("Balance (LCY)");
                                      VendorBalance := "Balance (LCY)";
                                      Window2.UPDATE(1,"No.");
                                      PayableVendLedgEntry.SETRANGE("Vendor No.","No.");
                                      IF VendorBalance > 0 THEN BEGIN
                                        GetVendLedgEntries(TRUE,TRUE);
                                        GetVendLedgEntries(FALSE,TRUE);
                                        CheckAmounts(TRUE);
                                        ClearNegative;
                                      END;
                                    UNTIL (NEXT = 0) OR StopPayments;
                                  Window2.CLOSE;
                                END ELSE
                                  IF FIND('-') THEN
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

                                Window2.OPEN(Text008);

                                PayableVendLedgEntry.RESET;
                                PayableVendLedgEntry.SETRANGE(Priority,1,2147483647);
                                MakeGenJnlLines;
                                PayableVendLedgEntry.RESET;
                                PayableVendLedgEntry.SETRANGE(Priority,0);
                                MakeGenJnlLines;
                                PayableVendLedgEntry.RESET;
                                PayableVendLedgEntry.DELETEALL;

                                Window2.CLOSE;
                                Window.CLOSE;
                                ShowMessage(MessageText);
                              END;

               ReqFilterFields=No.,Payment Method Code }

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
                   IF LastDueDateToPayReq = 0D THEN
                     LastDueDateToPayReq := WORKDATE;
                   IF PostingDate = 0D THEN
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

      { 1   ;3   ;Field     ;
                  Name=LastPaymentDate;
                  CaptionML=[DAN=Sidste betalingsdato;
                             ENU=Last Payment Date];
                  ToolTipML=[DAN=Angiver den sidste betalingsdato, som kan vises p� kreditorposterne, og som skal med i k�rslen. Kun kreditorposter, der forfalder f�r eller har en kontantrabatdato p� denne dato, medtages. Hvis betalingsdatoen ligger f�r systemdatoen, bliver der vist en advarsel.;
                             ENU=Specifies the latest payment date that can appear on the vendor ledger entries to be included in the batch job. Only entries that have a due date or a payment discount date before or on this date will be included. If the payment date is earlier than the system date, a warning will be displayed.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=LastDueDateToPayReq }

      { 2   ;3   ;Field     ;
                  Name=FindPaymentDiscounts;
                  CaptionML=[DAN=Find kontantrabatter;
                             ENU=Find Payment Discounts];
                  ToolTipML=[DAN=Angiver, om k�rslen skal medtage kreditorposter, hvortil der kan opn�s kontantrabat.;
                             ENU=Specifies if you want the batch job to include vendor ledger entries for which you can receive a payment discount.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=UsePaymentDisc;
                  Importance=Additional;
                  MultiLine=Yes;
                  OnValidate=BEGIN
                               IF UsePaymentDisc AND UseDueDateAsPostingDate THEN
                                 ERROR(PmtDiscUnavailableErr);
                             END;
                              }

      { 3   ;3   ;Field     ;
                  Name=UseVendorPriority;
                  CaptionML=[DAN=Anvend kreditorprioritet;
                             ENU=Use Vendor Priority];
                  ToolTipML=[DAN=Angiver, om feltet Prioritet p� kreditorkortene vil afg�re, i hvilken r�kkef�lge k�rslen foresl�r betaling af kreditorposterne. Kreditorer vil altid blive prioriteret til betaling, n�r du angiver et bel�b i feltet Bel�b til r�dighed (RV).;
                             ENU=Specifies if the Priority field on the vendor cards will determine in which order vendor entries are suggested for payment by the batch job. The batch job always prioritizes vendors for payment suggestions if you specify an available amount in the Available Amount (LCY) field.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=UsePriority;
                  Importance=Additional;
                  OnValidate=BEGIN
                               IF NOT UsePriority AND (AmountAvailable <> 0) THEN
                                 ERROR(Text011);
                             END;
                              }

      { 11  ;3   ;Field     ;
                  Name=Available Amount (LCY);
                  CaptionML=[DAN=Bel�b til r�dighed (RV);
                             ENU=Available Amount (LCY)];
                  ToolTipML=[DAN=Angiver et maksimalt bel�b (i RV), som er tilg�ngeligt til betalinger. K�rslen vil derefter oprette et betalingsforslag p� baggrund af bel�bet og i forhold til afkrydsningsfeltet Anvend kreditorprioritet. Det vil kun inkludere kreditorposter, der kan betales helt.;
                             ENU=Specifies a maximum amount (in LCY) that is available for payments. The batch job will then create a payment suggestion on the basis of this amount and the Use Vendor Priority check box. It will only include vendor entries that can be paid fully.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=AmountAvailable;
                  Importance=Additional;
                  OnValidate=BEGIN
                               IF AmountAvailable <> 0 THEN
                                 UsePriority := TRUE;
                             END;
                              }

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
                  CaptionML=[DAN=Opsummer resultater;
                             ENU=Summarize Results];
                  GroupType=Group }

      { 6   ;3   ;Field     ;
                  Name=SummarizePerVendor;
                  CaptionML=[DAN=Sammenfat pr. kreditor;
                             ENU=Summarize per Vendor];
                  ToolTipML=[DAN=Angiver, om k�rslen skal oprette �n linje pr. kreditor for hver valuta, som kreditoren f�rer poster i. Hvis en kreditor f.eks. benytter to valutaer, oprettes der to linjer i udbetalingskladden for denne kreditor. K�rslen bruger derefter feltet Udlignings-id til at f�je linjerne til kreditorposterne, n�r kladdelinjerne er bogf�rt, s� linjerne udlignes med kreditorposter. Hvis du ikke markerer afkrydsningsfeltet, oprettes der �n linje pr. faktura.;
                             ENU=Specifies if you want the batch job to make one line per vendor for each currency in which the vendor has ledger entries. If, for example, a vendor uses two currencies, the batch job will create two lines in the payment journal for this vendor. The batch job then uses the Applies-to ID field when the journal lines are posted to apply the lines to vendor ledger entries. If you do not select this check box, then the batch job will make one line per invoice.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=SummarizePerVend;
                  OnValidate=BEGIN
                               IF SummarizePerVend AND UseDueDateAsPostingDate THEN
                                 ERROR(PmtDiscUnavailableErr);
                             END;
                              }

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
                                 DimSelectionBuf.SetDimSelectionMultiple(3,REPORT::"Suggest Vendor Payments",SummarizePerDimText);
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
                  Editable=UseDueDateAsPostingDate = FALSE;
                  OnValidate=BEGIN
                               ValidatePostingDate;
                             END;
                              }

      { 16  ;3   ;Field     ;
                  Name=UseDueDateAsPostingDate;
                  CaptionML=[DAN=Beregn bogf�ringsdato fra forfaldsdato for udligningsbilag;
                             ENU=Calculate Posting Date from Applies-to-Doc. Due Date];
                  ToolTipML=[DAN=Angiver, om forfaldsdatoen p� k�bsfakturaen skal bruges som udgangspunkt til at beregne betalingens bogf�ringsdato.;
                             ENU=Specifies if the due date on the purchase invoice will be used as a basis to calculate the payment posting date.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=UseDueDateAsPostingDate;
                  Importance=Additional;
                  OnValidate=BEGIN
                               IF UseDueDateAsPostingDate AND (SummarizePerVend OR UsePaymentDisc) THEN
                                 ERROR(PmtDiscUnavailableErr);
                               IF NOT UseDueDateAsPostingDate THEN
                                 CLEAR(DueDateOffset);
                             END;
                              }

      { 15  ;3   ;Field     ;
                  Name=DueDateOffset;
                  CaptionML=[DAN=Forskydning af forfaldsdato for udligningsbilag;
                             ENU=Applies-to-Doc. Due Date Offset];
                  ToolTipML=[DAN=Angiver et tidsrum, som adskiller betalingens bogf�ringsdato fra forfaldsdatoen p� fakturaen. Eksempel 1: Hvis du vil betale fakturaen om fredagen i den uge, hvori den forfalder, skal du indtaste CW-2D (current week (aktuel uge) minus to dage). Eksempel 2: Hvis du vil betale fakturaen to dage f�r forfaldsdatoen, skal du indtaste -2D (minus to dage).;
                             ENU=Specifies a period of time that will separate the payment posting date from the due date on the invoice. Example 1: To pay the invoice on the Friday in the week of the due date, enter CW-2D (current week minus two days). Example 2: To pay the invoice two days before the due date, enter -2D (minus two days).];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=DueDateOffset;
                  Importance=Additional;
                  Enabled=UseDueDateAsPostingDate;
                  Editable=UseDueDateAsPostingDate }

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
                  Importance=Additional;
                  OnValidate=BEGIN
                               IF NOT UsePriority AND (AmountAvailable <> 0) THEN
                                 ERROR(Text013);
                             END;
                              }

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
                  CaptionML=[DAN=Modkonto;
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
                                   GenJnlLine2."Bal. Account Type"::Customer,GenJnlLine2."Bal. Account Type"::Vendor:
                                     ERROR(Text009,GenJnlLine2.FIELDCAPTION("Bal. Account Type"));
                                   GenJnlLine2."Bal. Account Type"::"Bank Account":
                                     BankAcc.GET(GenJnlLine2."Bal. Account No.");
                                 END;
                             END;

                  OnLookup=BEGIN
                             CASE GenJnlLine2."Bal. Account Type" OF
                               GenJnlLine2."Bal. Account Type"::"G/L Account":
                                 IF PAGE.RUNMODAL(0,GLAcc) = ACTION::LookupOK THEN
                                   GenJnlLine2."Bal. Account No." := GLAcc."No.";
                               GenJnlLine2."Bal. Account Type"::Customer,GenJnlLine2."Bal. Account Type"::Vendor:
                                 ERROR(Text009,GenJnlLine2.FIELDCAPTION("Bal. Account Type"));
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
                                 ERROR(
                                   Text010,
                                   GenJnlLine2.FIELDCAPTION("Bank Payment Type"),
                                   GenJnlLine2.FIELDCAPTION("Bal. Account Type"));
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
      Text000@1000 : TextConst 'DAN=I feltet Sidste betalingsdato skal du angive den sidste gyldige dato for foretagelse af betalingerne.;ENU=In the Last Payment Date field, specify the last possible date that payments must be made.';
      Text001@1001 : TextConst 'DAN=I feltet Bogf�ringsdato skal du angive den dato, der bruges som bogf�ringsdato for kladdeposterne.;ENU=In the Posting Date field, specify the date that will be used as the posting date for the journal entries.';
      Text002@1002 : TextConst 'DAN=I feltet Startbilagsnr. skal du angive det f�rste bilagsnummer, der skal bruges.;ENU=In the Starting Document No. field, specify the first document number to be used.';
      Text003@1003 : TextConst '@@@=%1 is a date;DAN=Betalingsdatoen er tidligere end %1.\\Vil du stadig udf�re k�rslen?;ENU=The payment date is earlier than %1.\\Do you still want to run the batch job?';
      Text005@1005 : TextConst 'DAN=K�rslen blev afbrudt.;ENU=The batch job was interrupted.';
      Text006@1006 : TextConst 'DAN=Kreditorerne gennemg�s                   #1##########;ENU=Processing vendors     #1##########';
      Text007@1007 : TextConst 'DAN=Genneml�ber kreditorer for kontantrab.   #1##########;ENU=Processing vendors for payment discounts #1##########';
      Text008@1008 : TextConst 'DAN=Inds�tter betalingskladdelinjer          #1##########;ENU=Inserting payment journal lines #1##########';
      Text009@1009 : TextConst 'DAN=%1 skal v�re Finanskonto eller Bankkonto.;ENU=%1 must be G/L Account or Bank Account.';
      Text010@1010 : TextConst 'DAN=%1 skal kun udfyldes, n�r %2 er en bankkonto.;ENU=%1 must be filled only when %2 is Bank Account.';
      Text011@1011 : TextConst 'DAN=Anvend kreditorprioritet skal v�re aktiv, n�r Bel�b til r�dighed ikke er 0.;ENU=Use Vendor Priority must be activated when the value in the Amount Available field is not 0.';
      Text013@1013 : TextConst 'DAN=Anvend kreditorprioritet skal v�re aktiv, n�r Bel�b til r�dighed ikke er 0.;ENU=Use Vendor Priority must be activated when the value in the Amount Available Amount (LCY) field is not 0.';
      Text017@1017 : TextConst '@@@="If Bank Payment Type = Computer Check and you have not selected the Summarize per Vendor field,\ then you must select the New Doc. No. per Line.";DAN="N�r %1 = %2, og du ikke har markeret feltet Sammenfat pr. kreditor, \ skal du v�lge Nyt bilagsnr. pr. linje.";ENU="If %1 = %2 and you have not selected the Summarize per Vendor field,\ then you must select the New Doc. No. per Line."';
      Text020@1020 : TextConst '@@@=You have only created suggested vendor payment lines for the Currency Code EUR.\ However, there are other open vendor ledger entries in currencies other than EUR.;DAN=Du har kun oprettet linjer til Lav kreditorbetalingsforslag for %1 %2.\ Der findes imidlertid ogs� �bne kreditorposter i andre valutaer end %2.\\;ENU=You have only created suggested vendor payment lines for the %1 %2.\ However, there are other open vendor ledger entries in currencies other than %2.\\';
      Text021@1021 : TextConst '@@@=You have only created suggested vendor payment lines for the Currency Code EUR\ There are no other open vendor ledger entries in other currencies.\\;DAN=Du har kun oprettet linjer til Lav kreditorbetalingsforslag for %1 %2.\ Der findes ingen �bne kreditorposter i andre valutaer.\\;ENU=You have only created suggested vendor payment lines for the %1 %2.\ There are no other open vendor ledger entries in other currencies.\\';
      Text022@1022 : TextConst 'DAN=Du har oprettet linjer til Lav kreditorbetalingsforslag for alle valutaer.\\;ENU=You have created suggested vendor payment lines for all currencies.\\';
      Vend2@1023 : Record 23;
      GenJnlTemplate@1024 : Record 80;
      GenJnlBatch@1025 : Record 232;
      GenJnlLine@1026 : Record 81;
      DimSetEntry@1027 : Record 480;
      GenJnlLine2@1028 : Record 81;
      VendLedgEntry@1029 : Record 25;
      GLAcc@1030 : Record 15;
      BankAcc@1031 : Record 270;
      PayableVendLedgEntry@1032 : TEMPORARY Record 317;
      CompanyInformation@1062 : Record 79;
      TempPaymentBuffer@1033 : TEMPORARY Record 372;
      OldTempPaymentBuffer@1034 : TEMPORARY Record 372;
      SelectedDim@1035 : Record 369;
      VendorLedgEntryTemp@1102601000 : TEMPORARY Record 25;
      NoSeriesMgt@1036 : Codeunit 396;
      DimMgt@1038 : Codeunit 408;
      DimBufMgt@1018 : Codeunit 411;
      Window@1039 : Dialog;
      Window2@1004 : Dialog;
      UsePaymentDisc@1040 : Boolean;
      PostingDate@1041 : Date;
      LastDueDateToPayReq@1042 : Date;
      NextDocNo@1043 : Code[20];
      AmountAvailable@1044 : Decimal;
      OriginalAmtAvailable@1045 : Decimal;
      UsePriority@1046 : Boolean;
      SummarizePerVend@1047 : Boolean;
      SummarizePerDim@1048 : Boolean;
      SummarizePerDimText@1049 : Text[250];
      LastLineNo@1051 : Integer;
      NextEntryNo@1052 : Integer;
      DueDateOffset@1118 : DateFormula;
      UseDueDateAsPostingDate@1066 : Boolean;
      StopPayments@1053 : Boolean;
      DocNoPerLine@1054 : Boolean;
      BankPmtType@1055 : Option;
      BalAccType@1056 : 'G/L Account,Customer,Vendor,Bank Account';
      BalAccNo@1057 : Code[20];
      MessageText@1058 : Text;
      GenJnlLineInserted@1059 : Boolean;
      SeveralCurrencies@1060 : Boolean;
      Text024@1102601001 : TextConst 'DAN=Der findes en eller flere poster, hvortil der ikke er angivet betalingsforslag, fordi bogf�ringsdatoerne i for posterne er senere end den anmodede bogf�ringsdato. Vil du se posterne?;ENU=There are one or more entries for which no payment suggestions have been made because the posting dates of the entries are later than the requested posting date. Do you want to see the entries?';
      SummarizePerDimTextEnable@19039578 : Boolean INDATASET;
      Text025@1063 : TextConst 'DAN=%1 med nummeret %2 har et %3 med nummeret %4.;ENU=The %1 with the number %2 has a %3 with the number %4.';
      ShowPostingDateWarning@1119 : Boolean;
      VendorBalance@1065 : Decimal;
      ReplacePostingDateMsg@1064 : TextConst 'DAN=Den anmodede bogf�ringsdato for en eller flere poster ligger f�r arbejdsdatoen.\\Disse bogf�ringsdatoer anvender arbejdsdatoen.;ENU=For one or more entries, the requested posting date is before the work date.\\These posting dates will use the work date.';
      PmtDiscUnavailableErr@1067 : TextConst 'DAN=Du kan ikke bruge Find kontantrabatter eller Sammenfat pr. kreditor sammen med Beregn bogf�ringsdato fra forfaldsdato for udligningsbilag, da den resulterende bogf�ringsdato muligvis ikke vil stemme overens med kontantrabatdatoen.;ENU=You cannot use Find Payment Discounts or Summarize per Vendor together with Calculate Posting Date from Applies-to-Doc. Due Date, because the resulting posting date might not match the payment discount date.';
      SkipExportedPayments@1019 : Boolean;
      MessageToRecipientMsg@1068 : TextConst '@@@=%1 document type, %2 Document No.;DAN=Betaling af %1 %2;ENU="Payment of %1 %2 "';
      StartingDocumentNoErr@1012 : TextConst 'DAN=Start bilagsnr.;ENU=Starting Document No.';

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

    PROCEDURE InitializeRequest@3(LastPmtDate@1000 : Date;FindPmtDisc@1001 : Boolean;NewAvailableAmount@1002 : Decimal;NewSkipExportedPayments@1009 : Boolean;NewPostingDate@1003 : Date;NewStartDocNo@1004 : Code[20];NewSummarizePerVend@1005 : Boolean;BalAccType@1006 : 'G/L Account,Customer,Vendor,Bank Account';BalAccNo@1007 : Code[20];BankPmtType@1008 : Option);
    BEGIN
      LastDueDateToPayReq := LastPmtDate;
      UsePaymentDisc := FindPmtDisc;
      AmountAvailable := NewAvailableAmount;
      SkipExportedPayments := NewSkipExportedPayments;
      PostingDate := NewPostingDate;
      NextDocNo := NewStartDocNo;
      SummarizePerVend := NewSummarizePerVend;
      GenJnlLine2."Bal. Account Type" := BalAccType;
      GenJnlLine2."Bal. Account No." := BalAccNo;
      GenJnlLine2."Bank Payment Type" := BankPmtType;
    END;

    LOCAL PROCEDURE GetVendLedgEntries@13(Positive@1000 : Boolean;Future@1001 : Boolean);
    BEGIN
      VendLedgEntry.RESET;
      VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
      VendLedgEntry.SETRANGE("Vendor No.",Vendor."No.");
      VendLedgEntry.SETRANGE(Open,TRUE);
      VendLedgEntry.SETRANGE(Positive,Positive);
      VendLedgEntry.SETRANGE("Applies-to ID",'');
      IF Future THEN BEGIN
        VendLedgEntry.SETRANGE("Due Date",LastDueDateToPayReq + 1,DMY2DATE(31,12,9999));
        VendLedgEntry.SETRANGE("Pmt. Discount Date",PostingDate,LastDueDateToPayReq);
        VendLedgEntry.SETFILTER("Remaining Pmt. Disc. Possible",'<>0');
      END ELSE
        VendLedgEntry.SETRANGE("Due Date",0D,LastDueDateToPayReq);
      IF SkipExportedPayments THEN
        VendLedgEntry.SETRANGE("Exported to Payment File",FALSE);
      VendLedgEntry.SETRANGE("On Hold",'');
      VendLedgEntry.SETFILTER("Currency Code",Vendor.GETFILTER("Currency Filter"));
      VendLedgEntry.SETFILTER("Global Dimension 1 Code",Vendor.GETFILTER("Global Dimension 1 Filter"));
      VendLedgEntry.SETFILTER("Global Dimension 2 Code",Vendor.GETFILTER("Global Dimension 2 Filter"));

      IF VendLedgEntry.FIND('-') THEN
        REPEAT
          SaveAmount;
          IF VendLedgEntry."Accepted Pmt. Disc. Tolerance" OR
             (VendLedgEntry."Accepted Payment Tolerance" <> 0)
          THEN BEGIN
            VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
            VendLedgEntry."Accepted Payment Tolerance" := 0;
            CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
          END;
        UNTIL VendLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE SaveAmount@6();
    VAR
      PaymentToleranceMgt@1000 : Codeunit 426;
    BEGIN
      WITH GenJnlLine DO BEGIN
        INIT;
        SetPostingDate(GenJnlLine,VendLedgEntry."Due Date",PostingDate);
        "Document Type" := "Document Type"::Payment;
        "Account Type" := "Account Type"::Vendor;
        Vend2.GET(VendLedgEntry."Vendor No.");
        Vend2.CheckBlockedVendOnJnls(Vend2,"Document Type",FALSE);
        Description := Vend2.Name;
        "Posting Group" := Vend2."Vendor Posting Group";
        "Salespers./Purch. Code" := Vend2."Purchaser Code";
        "Payment Terms Code" := Vend2."Payment Terms Code";
        VALIDATE("Bill-to/Pay-to No.","Account No.");
        VALIDATE("Sell-to/Buy-from No.","Account No.");
        "Gen. Posting Type" := 0;
        "Gen. Bus. Posting Group" := '';
        "Gen. Prod. Posting Group" := '';
        "VAT Bus. Posting Group" := '';
        "VAT Prod. Posting Group" := '';
        VALIDATE("Currency Code",VendLedgEntry."Currency Code");
        VALIDATE("Payment Terms Code");
        VendLedgEntry.CALCFIELDS("Remaining Amount");
        IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine,VendLedgEntry,0,FALSE) THEN
          Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
        ELSE
          Amount := -VendLedgEntry."Remaining Amount";
        VALIDATE(Amount);
      END;

      IF UsePriority THEN
        PayableVendLedgEntry.Priority := Vendor.Priority
      ELSE
        PayableVendLedgEntry.Priority := 0;
      PayableVendLedgEntry."Vendor No." := VendLedgEntry."Vendor No.";
      PayableVendLedgEntry."Entry No." := NextEntryNo;
      PayableVendLedgEntry."Vendor Ledg. Entry No." := VendLedgEntry."Entry No.";
      PayableVendLedgEntry.Amount := GenJnlLine.Amount;
      PayableVendLedgEntry."Amount (LCY)" := GenJnlLine."Amount (LCY)";
      PayableVendLedgEntry.Positive := (PayableVendLedgEntry.Amount > 0);
      PayableVendLedgEntry.Future := (VendLedgEntry."Due Date" > LastDueDateToPayReq);
      PayableVendLedgEntry."Currency Code" := VendLedgEntry."Currency Code";
      PayableVendLedgEntry.INSERT;
      NextEntryNo := NextEntryNo + 1;
    END;

    LOCAL PROCEDURE CheckAmounts@10(Future@1000 : Boolean);
    VAR
      CurrencyBalance@1001 : Decimal;
      PrevCurrency@1002 : Code[10];
    BEGIN
      PayableVendLedgEntry.SETRANGE("Vendor No.",Vendor."No.");
      PayableVendLedgEntry.SETRANGE(Future,Future);

      IF PayableVendLedgEntry.FIND('-') THEN BEGIN
        REPEAT
          IF PayableVendLedgEntry."Currency Code" <> PrevCurrency THEN BEGIN
            IF CurrencyBalance > 0 THEN
              AmountAvailable := AmountAvailable - CurrencyBalance;
            CurrencyBalance := 0;
            PrevCurrency := PayableVendLedgEntry."Currency Code";
          END;
          IF (OriginalAmtAvailable = 0) OR
             (AmountAvailable >= CurrencyBalance + PayableVendLedgEntry."Amount (LCY)")
          THEN
            CurrencyBalance := CurrencyBalance + PayableVendLedgEntry."Amount (LCY)"
          ELSE
            PayableVendLedgEntry.DELETE;
        UNTIL PayableVendLedgEntry.NEXT = 0;
        IF OriginalAmtAvailable > 0 THEN
          AmountAvailable := AmountAvailable - CurrencyBalance;
        IF (OriginalAmtAvailable > 0) AND (AmountAvailable <= 0) THEN
          StopPayments := TRUE;
      END;
      PayableVendLedgEntry.RESET;
    END;

    LOCAL PROCEDURE MakeGenJnlLines@2();
    VAR
      GenJnlLine1@1010 : Record 81;
      DimBuf@1002 : Record 360;
      Vendor@1001 : Record 23;
      RemainingAmtAvailable@1008 : Decimal;
    BEGIN
      TempPaymentBuffer.RESET;
      TempPaymentBuffer.DELETEALL;

      IF BalAccType = BalAccType::"Bank Account" THEN BEGIN
        CheckCurrencies(BalAccType,BalAccNo,PayableVendLedgEntry);
        SetBankAccCurrencyFilter(BalAccType,BalAccNo,PayableVendLedgEntry);
      END;

      IF OriginalAmtAvailable <> 0 THEN BEGIN
        RemainingAmtAvailable := OriginalAmtAvailable;
        RemovePaymentsAboveLimit(PayableVendLedgEntry,RemainingAmtAvailable);
      END;
      IF PayableVendLedgEntry.FIND('-') THEN
        REPEAT
          PayableVendLedgEntry.SETRANGE("Vendor No.",PayableVendLedgEntry."Vendor No.");
          PayableVendLedgEntry.FIND('-');
          REPEAT
            VendLedgEntry.GET(PayableVendLedgEntry."Vendor Ledg. Entry No.");
            SetPostingDate(GenJnlLine1,VendLedgEntry."Due Date",PostingDate);
            IF VendLedgEntry."Posting Date" <= GenJnlLine1."Posting Date" THEN BEGIN
              TempPaymentBuffer."Vendor No." := VendLedgEntry."Vendor No.";
              TempPaymentBuffer."Currency Code" := VendLedgEntry."Currency Code";
              TempPaymentBuffer."Payment Method Code" := VendLedgEntry."Payment Method Code";
              TempPaymentBuffer."Creditor No." := VendLedgEntry."Creditor No.";
              TempPaymentBuffer."Payment Reference" := VendLedgEntry."Payment Reference";
              TempPaymentBuffer."Exported to Payment File" := VendLedgEntry."Exported to Payment File";
              TempPaymentBuffer."Applies-to Ext. Doc. No." := VendLedgEntry."External Document No.";
              OnUpdateTempBufferFromVendorLedgerEntry(TempPaymentBuffer,VendLedgEntry);
              SetTempPaymentBufferDims(DimBuf);

              VendLedgEntry.CALCFIELDS("Remaining Amount");

              IF SummarizePerVend THEN BEGIN
                TempPaymentBuffer."Vendor Ledg. Entry No." := 0;
                IF TempPaymentBuffer.FIND THEN BEGIN
                  TempPaymentBuffer.Amount := TempPaymentBuffer.Amount + PayableVendLedgEntry.Amount;
                  TempPaymentBuffer.MODIFY;
                END ELSE BEGIN
                  TempPaymentBuffer."Document No." := NextDocNo;
                  NextDocNo := INCSTR(NextDocNo);
                  TempPaymentBuffer.Amount := PayableVendLedgEntry.Amount;
                  Window2.UPDATE(1,VendLedgEntry."Vendor No.");
                  TempPaymentBuffer.INSERT;
                END;
                VendLedgEntry."Applies-to ID" := TempPaymentBuffer."Document No.";
              END ELSE
                IF NOT IsEntryAlreadyApplied(GenJnlLine,VendLedgEntry) THEN BEGIN
                  TempPaymentBuffer."Vendor Ledg. Entry Doc. Type" := VendLedgEntry."Document Type";
                  TempPaymentBuffer."Vendor Ledg. Entry Doc. No." := VendLedgEntry."Document No.";
                  TempPaymentBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                  TempPaymentBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
                  TempPaymentBuffer."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
                  TempPaymentBuffer."Vendor Ledg. Entry No." := VendLedgEntry."Entry No.";
                  TempPaymentBuffer.Amount := PayableVendLedgEntry.Amount;
                  Window2.UPDATE(1,VendLedgEntry."Vendor No.");
                  TempPaymentBuffer.INSERT;
                END;

              VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
              CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
            END ELSE BEGIN
              VendorLedgEntryTemp := VendLedgEntry;
              VendorLedgEntryTemp.INSERT;
            END;

            PayableVendLedgEntry.DELETE;
            IF OriginalAmtAvailable <> 0 THEN BEGIN
              RemainingAmtAvailable := RemainingAmtAvailable - PayableVendLedgEntry."Amount (LCY)";
              RemovePaymentsAboveLimit(PayableVendLedgEntry,RemainingAmtAvailable);
            END;

          UNTIL NOT PayableVendLedgEntry.FINDSET;
          PayableVendLedgEntry.DELETEALL;
          PayableVendLedgEntry.SETRANGE("Vendor No.");
        UNTIL NOT PayableVendLedgEntry.FIND('-');

      CLEAR(OldTempPaymentBuffer);
      TempPaymentBuffer.SETCURRENTKEY("Document No.");
      TempPaymentBuffer.SETFILTER(
        "Vendor Ledg. Entry Doc. Type",'<>%1&<>%2',TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Refund,
        TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Payment);
      IF TempPaymentBuffer.FIND('-') THEN
        REPEAT
          WITH GenJnlLine DO BEGIN
            INIT;
            Window2.UPDATE(1,TempPaymentBuffer."Vendor No.");
            LastLineNo := LastLineNo + 10000;
            "Line No." := LastLineNo;
            "Document Type" := "Document Type"::Payment;
            "Posting No. Series" := GenJnlBatch."Posting No. Series";
            IF SummarizePerVend THEN
              "Document No." := TempPaymentBuffer."Document No."
            ELSE
              IF DocNoPerLine THEN BEGIN
                IF TempPaymentBuffer.Amount < 0 THEN
                  "Document Type" := "Document Type"::Refund;

                "Document No." := NextDocNo;
                NextDocNo := INCSTR(NextDocNo);
              END ELSE
                IF (TempPaymentBuffer."Vendor No." = OldTempPaymentBuffer."Vendor No.") AND
                   (TempPaymentBuffer."Currency Code" = OldTempPaymentBuffer."Currency Code")
                THEN
                  "Document No." := OldTempPaymentBuffer."Document No."
                ELSE BEGIN
                  "Document No." := NextDocNo;
                  NextDocNo := INCSTR(NextDocNo);
                  OldTempPaymentBuffer := TempPaymentBuffer;
                  OldTempPaymentBuffer."Document No." := "Document No.";
                END;
            "Account Type" := "Account Type"::Vendor;
            SetHideValidation(TRUE);
            ShowPostingDateWarning := ShowPostingDateWarning OR
              SetPostingDate(GenJnlLine,GetApplDueDate(TempPaymentBuffer."Vendor Ledg. Entry No."),PostingDate);
            VALIDATE("Account No.",TempPaymentBuffer."Vendor No.");
            Vendor.GET(TempPaymentBuffer."Vendor No.");
            IF (Vendor."Pay-to Vendor No." <> '') AND (Vendor."Pay-to Vendor No." <> "Account No.") THEN
              MESSAGE(Text025,Vendor.TABLECAPTION,Vendor."No.",Vendor.FIELDCAPTION("Pay-to Vendor No."),
                Vendor."Pay-to Vendor No.");
            "Bal. Account Type" := BalAccType;
            VALIDATE("Bal. Account No.",BalAccNo);
            VALIDATE("Currency Code",TempPaymentBuffer."Currency Code");
            "Message to Recipient" := GetMessageToRecipient(SummarizePerVend);
            "Bank Payment Type" := BankPmtType;
            IF SummarizePerVend THEN
              "Applies-to ID" := "Document No.";
            Description := Vendor.Name;
            "Source Line No." := TempPaymentBuffer."Vendor Ledg. Entry No.";
            "Shortcut Dimension 1 Code" := TempPaymentBuffer."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := TempPaymentBuffer."Global Dimension 2 Code";
            "Dimension Set ID" := TempPaymentBuffer."Dimension Set ID";
            "Source Code" := GenJnlTemplate."Source Code";
            "Reason Code" := GenJnlBatch."Reason Code";
            VALIDATE(Amount,TempPaymentBuffer.Amount);
            "Applies-to Doc. Type" := TempPaymentBuffer."Vendor Ledg. Entry Doc. Type";
            "Applies-to Doc. No." := TempPaymentBuffer."Vendor Ledg. Entry Doc. No.";
            "Payment Method Code" := TempPaymentBuffer."Payment Method Code";
            "Creditor No." := TempPaymentBuffer."Creditor No.";
            "Payment Reference" := TempPaymentBuffer."Payment Reference";
            "Exported to Payment File" := TempPaymentBuffer."Exported to Payment File";
            "Applies-to Ext. Doc. No." := TempPaymentBuffer."Applies-to Ext. Doc. No.";
            OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(GenJnlLine,TempPaymentBuffer);
            UpdateDimensions(GenJnlLine);
            INSERT;
            GenJnlLineInserted := TRUE;
          END;
        UNTIL TempPaymentBuffer.NEXT = 0;
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
        IF SummarizePerVend THEN BEGIN
          DimBuf.RESET;
          DimBuf.DELETEALL;
          DimBufMgt.GetDimensions(TempPaymentBuffer."Dimension Entry No.",DimBuf);
          IF DimBuf.FINDSET THEN
            REPEAT
              DimVal.GET(DimBuf."Dimension Code",DimBuf."Dimension Value Code");
              TempDimSetEntry."Dimension Code" := DimBuf."Dimension Code";
              TempDimSetEntry."Dimension Value Code" := DimBuf."Dimension Value Code";
              TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
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
          DimSetIDArr[1] := "Dimension Set ID";
          DimSetIDArr[2] := NewDimensionID;
          "Dimension Set ID" :=
            DimMgt.GetCombinedDimensionSetID(DimSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        END;

        IF SummarizePerVend THEN BEGIN
          DimMgt.GetDimensionSet(TempDimSetEntry,"Dimension Set ID");
          IF AdjustAgainstSelectedDim(TempDimSetEntry,TempDimSetEntry2) THEN
            "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry2);
          DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code",
            "Shortcut Dimension 2 Code");
        END;
      END;
    END;

    LOCAL PROCEDURE SetBankAccCurrencyFilter@11(BalAccType@1000 : 'G/L Account,Customer,Vendor,Bank Account';BalAccNo@1001 : Code[20];VAR TmpPayableVendLedgEntry@1002 : Record 317);
    VAR
      BankAcc@1003 : Record 270;
    BEGIN
      IF BalAccType = BalAccType::"Bank Account" THEN
        IF BalAccNo <> '' THEN BEGIN
          BankAcc.GET(BalAccNo);
          IF BankAcc."Currency Code" <> '' THEN
            TmpPayableVendLedgEntry.SETRANGE("Currency Code",BankAcc."Currency Code");
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

    LOCAL PROCEDURE CheckCurrencies@4(BalAccType@1000 : 'G/L Account,Customer,Vendor,Bank Account';BalAccNo@1001 : Code[20];VAR TmpPayableVendLedgEntry@1002 : Record 317);
    VAR
      BankAcc@1003 : Record 270;
      TmpPayableVendLedgEntry2@1004 : TEMPORARY Record 317;
    BEGIN
      IF BalAccType = BalAccType::"Bank Account" THEN
        IF BalAccNo <> '' THEN BEGIN
          BankAcc.GET(BalAccNo);
          IF BankAcc."Currency Code" <> '' THEN BEGIN
            TmpPayableVendLedgEntry2.RESET;
            TmpPayableVendLedgEntry2.DELETEALL;
            IF TmpPayableVendLedgEntry.FIND('-') THEN
              REPEAT
                TmpPayableVendLedgEntry2 := TmpPayableVendLedgEntry;
                TmpPayableVendLedgEntry2.INSERT;
              UNTIL TmpPayableVendLedgEntry.NEXT = 0;

            TmpPayableVendLedgEntry2.SETFILTER("Currency Code",'<>%1',BankAcc."Currency Code");
            SeveralCurrencies := SeveralCurrencies OR TmpPayableVendLedgEntry2.FINDFIRST;

            IF SeveralCurrencies THEN
              MessageText :=
                STRSUBSTNO(Text020,BankAcc.FIELDCAPTION("Currency Code"),BankAcc."Currency Code")
            ELSE
              MessageText :=
                STRSUBSTNO(Text021,BankAcc.FIELDCAPTION("Currency Code"),BankAcc."Currency Code");
          END ELSE
            MessageText := Text022;
        END;
    END;

    LOCAL PROCEDURE ClearNegative@8();
    VAR
      TempCurrency@1000 : TEMPORARY Record 4;
      PayableVendLedgEntry2@1001 : TEMPORARY Record 317;
      CurrencyBalance@1002 : Decimal;
    BEGIN
      CLEAR(PayableVendLedgEntry);
      PayableVendLedgEntry.SETRANGE("Vendor No.",Vendor."No.");

      WHILE PayableVendLedgEntry.NEXT <> 0 DO BEGIN
        TempCurrency.Code := PayableVendLedgEntry."Currency Code";
        CurrencyBalance := 0;
        IF TempCurrency.INSERT THEN BEGIN
          PayableVendLedgEntry2 := PayableVendLedgEntry;
          PayableVendLedgEntry.SETRANGE("Currency Code",PayableVendLedgEntry."Currency Code");
          REPEAT
            CurrencyBalance := CurrencyBalance + PayableVendLedgEntry."Amount (LCY)"
          UNTIL PayableVendLedgEntry.NEXT = 0;
          IF CurrencyBalance < 0 THEN BEGIN
            PayableVendLedgEntry.DELETEALL;
            AmountAvailable += CurrencyBalance;
          END;
          PayableVendLedgEntry.SETRANGE("Currency Code");
          PayableVendLedgEntry := PayableVendLedgEntry2;
        END;
      END;
      PayableVendLedgEntry.RESET;
    END;

    LOCAL PROCEDURE DimCodeIsInDimBuf@1101(DimCode@1111 : Code[20];DimBuf@1112 : Record 360) : Boolean;
    BEGIN
      DimBuf.RESET;
      DimBuf.SETRANGE("Dimension Code",DimCode);
      EXIT(NOT DimBuf.ISEMPTY);
    END;

    LOCAL PROCEDURE RemovePaymentsAboveLimit@5(VAR PayableVendLedgEntry@1000 : Record 317;RemainingAmtAvailable@1001 : Decimal);
    BEGIN
      PayableVendLedgEntry.SETFILTER("Amount (LCY)",'>%1',RemainingAmtAvailable);
      PayableVendLedgEntry.DELETEALL;
      PayableVendLedgEntry.SETRANGE("Amount (LCY)");
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

    LOCAL PROCEDURE GetMessageToRecipient@18(SummarizePerVend@1000 : Boolean) : Text[140];
    VAR
      VendorLedgerEntry@1001 : Record 25;
    BEGIN
      IF SummarizePerVend THEN
        EXIT(CompanyInformation.Name);

      VendorLedgerEntry.GET(TempPaymentBuffer."Vendor Ledg. Entry No.");
      IF VendorLedgerEntry."Message to Recipient" <> '' THEN
        EXIT(VendorLedgerEntry."Message to Recipient");

      EXIT(
        STRSUBSTNO(
          MessageToRecipientMsg,
          TempPaymentBuffer."Vendor Ledg. Entry Doc. Type",
          TempPaymentBuffer."Applies-to Ext. Doc. No."));
    END;

    LOCAL PROCEDURE SetPostingDate@92(VAR GenJnlLine@1002 : Record 81;DueDate@1001 : Date;PostingDate@1000 : Date) : Boolean;
    BEGIN
      IF NOT UseDueDateAsPostingDate THEN BEGIN
        GenJnlLine.VALIDATE("Posting Date",PostingDate);
        EXIT(FALSE);
      END;

      IF DueDate = 0D THEN
        DueDate := GenJnlLine.GetAppliesToDocDueDate;
      EXIT(GenJnlLine.SetPostingDateAsDueDate(DueDate,DueDateOffset));
    END;

    LOCAL PROCEDURE GetApplDueDate@94(VendLedgEntryNo@1001 : Integer) : Date;
    VAR
      AppliedVendLedgEntry@1000 : Record 25;
    BEGIN
      IF AppliedVendLedgEntry.GET(VendLedgEntryNo) THEN
        EXIT(AppliedVendLedgEntry."Due Date");

      EXIT(PostingDate);
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

    LOCAL PROCEDURE SetTempPaymentBufferDims@12(VAR DimBuf@1000 : Record 360);
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
                 VendLedgEntry."Dimension Set ID",SelectedDim."Dimension Code")
            THEN
              InsertDimBuf(DimBuf,DATABASE::"Dimension Buffer",0,DimSetEntry."Dimension Code",
                DimSetEntry."Dimension Value Code");
          UNTIL SelectedDim.NEXT = 0;
        EntryNo := DimBufMgt.FindDimensions(DimBuf);
        IF EntryNo = 0 THEN
          EntryNo := DimBufMgt.InsertDimensions(DimBuf);
        TempPaymentBuffer."Dimension Entry No." := EntryNo;
        IF TempPaymentBuffer."Dimension Entry No." <> 0 THEN BEGIN
          GLSetup.GET;
          IF DimCodeIsInDimBuf(GLSetup."Global Dimension 1 Code",DimBuf) THEN
            TempPaymentBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code"
          ELSE
            TempPaymentBuffer."Global Dimension 1 Code" := '';
          IF DimCodeIsInDimBuf(GLSetup."Global Dimension 2 Code",DimBuf) THEN
            TempPaymentBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code"
          ELSE
            TempPaymentBuffer."Global Dimension 2 Code" := '';
        END ELSE BEGIN
          TempPaymentBuffer."Global Dimension 1 Code" := '';
          TempPaymentBuffer."Global Dimension 2 Code" := '';
        END;
        TempPaymentBuffer."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
      END ELSE BEGIN
        TempPaymentBuffer."Dimension Entry No." := 0;
        TempPaymentBuffer."Global Dimension 1 Code" := '';
        TempPaymentBuffer."Global Dimension 2 Code" := '';
        TempPaymentBuffer."Dimension Set ID" := 0;
      END;
    END;

    LOCAL PROCEDURE IsEntryAlreadyApplied@19(GenJnlLine3@1000 : Record 81;VendLedgEntry2@1001 : Record 25) : Boolean;
    VAR
      GenJnlLine4@1002 : Record 81;
    BEGIN
      GenJnlLine4.SETRANGE("Journal Template Name",GenJnlLine3."Journal Template Name");
      GenJnlLine4.SETRANGE("Journal Batch Name",GenJnlLine3."Journal Batch Name");
      GenJnlLine4.SETRANGE("Account Type",GenJnlLine4."Account Type"::Vendor);
      GenJnlLine4.SETRANGE("Account No.",VendLedgEntry2."Vendor No.");
      GenJnlLine4.SETRANGE("Applies-to Doc. Type",VendLedgEntry2."Document Type");
      GenJnlLine4.SETRANGE("Applies-to Doc. No.",VendLedgEntry2."Document No.");
      EXIT(NOT GenJnlLine4.ISEMPTY);
    END;

    LOCAL PROCEDURE SetDefaults@14();
    BEGIN
      GenJnlBatch.GET(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");
      IF GenJnlBatch."Bal. Account No." <> '' THEN BEGIN
        GenJnlLine2."Bal. Account Type" := GenJnlBatch."Bal. Account Type";
        GenJnlLine2."Bal. Account No." := GenJnlBatch."Bal. Account No.";
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnUpdateTempBufferFromVendorLedgerEntry@1085(VAR TempPaymentBuffer@1086 : TEMPORARY Record 372;VendorLedgerEntry@1088 : Record 25);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer@1090(VAR GenJournalLine@1091 : Record 81;TempPaymentBuffer@1092 : TEMPORARY Record 372);
    BEGIN
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

