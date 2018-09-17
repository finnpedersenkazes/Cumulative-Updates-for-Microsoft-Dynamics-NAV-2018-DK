OBJECT Report 1401 Check
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836,NAVDK11.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 270=m;
    CaptionML=[DAN=Check;
               ENU=Check];
    OnPreReport=BEGIN
                  InitTextVariable;
                END;

  }
  DATASET
  {
    { 9788;    ;DataItem;VoidGenJnlLine      ;
               DataItemTable=Table81;
               DataItemTableView=SORTING(Journal Template Name,Journal Batch Name,Posting Date,Document No.);
               OnPreDataItem=BEGIN
                               IF CurrReport.PREVIEW THEN
                                 ERROR(Text000);

                               IF UseCheckNo = '' THEN
                                 ERROR(Text001);

                               IF TestPrint THEN
                                 CurrReport.BREAK;

                               IF NOT ReprintChecks THEN
                                 CurrReport.BREAK;

                               IF (GETFILTER("Line No.") <> '') OR (GETFILTER("Document No.") <> '') THEN
                                 ERROR(
                                   Text002,FIELDCAPTION("Line No."),FIELDCAPTION("Document No."));
                               SETRANGE("Bank Payment Type","Bank Payment Type"::"Computer Check");
                               SETRANGE("Check Printed",TRUE);
                             END;

               OnAfterGetRecord=BEGIN
                                  CheckManagement.VoidCheck(VoidGenJnlLine);
                                END;

               ReqFilterFields=Journal Template Name,Journal Batch Name,Posting Date }

    { 3808;    ;DataItem;GenJnlLine          ;
               DataItemTable=Table81;
               DataItemTableView=SORTING(Journal Template Name,Journal Batch Name,Posting Date,Document No.);
               OnPreDataItem=BEGIN
                               COPY(VoidGenJnlLine);
                               CompanyInfo.GET;
                               IF NOT TestPrint THEN BEGIN
                                 FormatAddr.Company(CompanyAddr,CompanyInfo);
                                 BankAcc2.GET(BankAcc2."No.");
                                 BankAcc2.TESTFIELD(Blocked,FALSE);
                                 COPY(VoidGenJnlLine);
                                 SETRANGE("Bank Payment Type","Bank Payment Type"::"Computer Check");
                                 SETRANGE("Check Printed",FALSE);
                               END ELSE BEGIN
                                 CLEAR(CompanyAddr);
                                 FOR i := 1 TO 5 DO
                                   CompanyAddr[i] := Text003;
                               END;
                               ChecksPrinted := 0;

                               SETRANGE("Account Type","Account Type"::"Fixed Asset");
                               IF FIND('-') THEN
                                 FIELDERROR("Account Type");
                               SETRANGE("Account Type");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF OneCheckPrVendor AND ("Currency Code" <> '') AND
                                     ("Currency Code" <> Currency.Code)
                                  THEN BEGIN
                                    Currency.GET("Currency Code");
                                    Currency.TESTFIELD("Conv. LCY Rndg. Debit Acc.");
                                    Currency.TESTFIELD("Conv. LCY Rndg. Credit Acc.");
                                  END;

                                  JournalPostingDate := "Posting Date";

                                  IF "Bank Payment Type" = "Bank Payment Type"::"Computer Check" THEN
                                    TESTFIELD("Exported to Payment File",FALSE);

                                  IF NOT TestPrint THEN BEGIN
                                    IF Amount = 0 THEN
                                      CurrReport.SKIP;

                                    TESTFIELD("Bal. Account Type","Bal. Account Type"::"Bank Account");
                                    IF "Bal. Account No." <> BankAcc2."No." THEN
                                      CurrReport.SKIP;

                                    IF ("Account No." <> '') AND ("Bal. Account No." <> '') THEN BEGIN
                                      BalancingType := "Account Type";
                                      BalancingNo := "Account No.";
                                      RemainingAmount := Amount;
                                      IF OneCheckPrVendor THEN BEGIN
                                        ApplyMethod := ApplyMethod::MoreLinesOneEntry;
                                        GenJnlLine2.RESET;
                                        GenJnlLine2.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
                                        GenJnlLine2.SETRANGE("Journal Template Name","Journal Template Name");
                                        GenJnlLine2.SETRANGE("Journal Batch Name","Journal Batch Name");
                                        GenJnlLine2.SETRANGE("Posting Date","Posting Date");
                                        GenJnlLine2.SETRANGE("Document No.","Document No.");
                                        GenJnlLine2.SETRANGE("Account Type","Account Type");
                                        GenJnlLine2.SETRANGE("Account No.","Account No.");
                                        GenJnlLine2.SETRANGE("Bal. Account Type","Bal. Account Type");
                                        GenJnlLine2.SETRANGE("Bal. Account No.","Bal. Account No.");
                                        GenJnlLine2.SETRANGE("Bank Payment Type","Bank Payment Type");
                                        GenJnlLine2.FIND('-');
                                        RemainingAmount := 0;
                                      END ELSE
                                        IF "Applies-to Doc. No." <> '' THEN
                                          ApplyMethod := ApplyMethod::OneLineOneEntry
                                        ELSE
                                          IF "Applies-to ID" <> '' THEN
                                            ApplyMethod := ApplyMethod::OneLineID
                                          ELSE
                                            ApplyMethod := ApplyMethod::Payment;
                                    END ELSE
                                      IF "Account No." = '' THEN
                                        FIELDERROR("Account No.",Text004)
                                      ELSE
                                        FIELDERROR("Bal. Account No.",Text004);

                                    CLEAR(CheckToAddr);
                                    CLEAR(SalesPurchPerson);
                                    CASE BalancingType OF
                                      BalancingType::"G/L Account":
                                        CheckToAddr[1] := Description;
                                      BalancingType::Customer:
                                        BEGIN
                                          Cust.GET(BalancingNo);
                                          IF Cust."Privacy Blocked" THEN
                                            ERROR(Cust.GetPrivacyBlockedGenericErrorText(Cust));

                                          IF Cust.Blocked = Cust.Blocked::All THEN
                                            ERROR(Text064,Cust.FIELDCAPTION(Blocked),Cust.Blocked,Cust.TABLECAPTION,Cust."No.");
                                          Cust.Contact := '';
                                          FormatAddr.Customer(CheckToAddr,Cust);
                                          IF BankAcc2."Currency Code" <> "Currency Code" THEN
                                            ERROR(Text005);
                                          IF Cust."Salesperson Code" <> '' THEN
                                            SalesPurchPerson.GET(Cust."Salesperson Code");
                                        END;
                                      BalancingType::Vendor:
                                        BEGIN
                                          Vend.GET(BalancingNo);
                                          IF Vend."Privacy Blocked" THEN
                                            ERROR(Vend.GetPrivacyBlockedGenericErrorText(Vend));

                                          IF Vend.Blocked IN [Vend.Blocked::All,Vend.Blocked::Payment] THEN
                                            ERROR(Text064,Vend.FIELDCAPTION(Blocked),Vend.Blocked,Vend.TABLECAPTION,Vend."No.");
                                          Vend.Contact := '';
                                          FormatAddr.Vendor(CheckToAddr,Vend);
                                          IF BankAcc2."Currency Code" <> "Currency Code" THEN
                                            ERROR(Text005);
                                          IF Vend."Purchaser Code" <> '' THEN
                                            SalesPurchPerson.GET(Vend."Purchaser Code");
                                        END;
                                      BalancingType::"Bank Account":
                                        BEGIN
                                          BankAcc.GET(BalancingNo);
                                          BankAcc.TESTFIELD(Blocked,FALSE);
                                          BankAcc.Contact := '';
                                          FormatAddr.BankAcc(CheckToAddr,BankAcc);
                                          IF BankAcc2."Currency Code" <> BankAcc."Currency Code" THEN
                                            ERROR(Text008);
                                          IF BankAcc."Our Contact Code" <> '' THEN
                                            SalesPurchPerson.GET(BankAcc."Our Contact Code");
                                        END;
                                    END;

                                    CheckDateText := FORMAT("Posting Date",0,4);
                                  END ELSE BEGIN
                                    IF ChecksPrinted > 0 THEN
                                      CurrReport.BREAK;
                                    BalancingType := BalancingType::Vendor;
                                    BalancingNo := Text010;
                                    CLEAR(CheckToAddr);
                                    FOR i := 1 TO 5 DO
                                      CheckToAddr[i] := Text003;
                                    CLEAR(SalesPurchPerson);
                                    CheckNoText := Text011;
                                    CheckDateText := Text012;
                                  END;
                                END;
                                 }

    { 43  ;1   ;Column  ;JournalTempName_GenJnlLine;
               SourceExpr="Journal Template Name" }

    { 44  ;1   ;Column  ;JournalBatchName_GenJnlLine;
               SourceExpr="Journal Batch Name" }

    { 45  ;1   ;Column  ;LineNo_GenJnlLine   ;
               SourceExpr="Line No." }

    { 1159;1   ;DataItem;CheckPages          ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               FirstPage := TRUE;
                               FoundLast := FALSE;
                               TotalLineAmount := 0;
                               TotalLineDiscount := 0;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF FoundLast THEN
                                    CurrReport.BREAK;

                                  UseCheckNo := INCSTR(UseCheckNo);
                                  IF NOT TestPrint THEN
                                    CheckNoText := UseCheckNo
                                  ELSE
                                    CheckNoText := Text011;
                                END;

               OnPostDataItem=VAR
                                RecordRestrictionMgt@1000 : Codeunit 1550;
                              BEGIN
                                IF NOT TestPrint THEN BEGIN
                                  IF UseCheckNo <> GenJnlLine."Document No." THEN BEGIN
                                    GenJnlLine3.RESET;
                                    GenJnlLine3.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
                                    GenJnlLine3.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
                                    GenJnlLine3.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
                                    GenJnlLine3.SETRANGE("Posting Date",GenJnlLine."Posting Date");
                                    GenJnlLine3.SETRANGE("Document No.",UseCheckNo);
                                    IF GenJnlLine3.FIND('-') THEN
                                      GenJnlLine3.FIELDERROR("Document No.",STRSUBSTNO(Text013,UseCheckNo));
                                  END;

                                  IF ApplyMethod <> ApplyMethod::MoreLinesOneEntry THEN BEGIN
                                    GenJnlLine3 := GenJnlLine;
                                    GenJnlLine3.TESTFIELD("Posting No. Series",'');
                                    GenJnlLine3."Document No." := UseCheckNo;
                                    GenJnlLine3."Check Printed" := TRUE;
                                    GenJnlLine3.MODIFY;
                                  END ELSE BEGIN
                                    IF GenJnlLine2.FIND('-') THEN BEGIN
                                      HighestLineNo := GenJnlLine2."Line No.";
                                      REPEAT
                                        RecordRestrictionMgt.CheckRecordHasUsageRestrictions(GenJnlLine2);
                                        IF GenJnlLine2."Line No." > HighestLineNo THEN
                                          HighestLineNo := GenJnlLine2."Line No.";
                                        GenJnlLine3 := GenJnlLine2;
                                        GenJnlLine3.TESTFIELD("Posting No. Series",'');
                                        GenJnlLine3."Bal. Account No." := '';
                                        GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::" ";
                                        GenJnlLine3."Document No." := UseCheckNo;
                                        GenJnlLine3."Check Printed" := TRUE;
                                        GenJnlLine3.VALIDATE(Amount);
                                        GenJnlLine3.MODIFY;
                                      UNTIL GenJnlLine2.NEXT = 0;
                                    END;

                                    GenJnlLine3.RESET;
                                    GenJnlLine3 := GenJnlLine;
                                    GenJnlLine3.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
                                    GenJnlLine3.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
                                    GenJnlLine3."Line No." := HighestLineNo;
                                    IF GenJnlLine3.NEXT = 0 THEN
                                      GenJnlLine3."Line No." := HighestLineNo + 10000
                                    ELSE BEGIN
                                      WHILE GenJnlLine3."Line No." = HighestLineNo + 1 DO BEGIN
                                        HighestLineNo := GenJnlLine3."Line No.";
                                        IF GenJnlLine3.NEXT = 0 THEN
                                          GenJnlLine3."Line No." := HighestLineNo + 20000;
                                      END;
                                      GenJnlLine3."Line No." := (GenJnlLine3."Line No." + HighestLineNo) DIV 2;
                                    END;
                                    GenJnlLine3.INIT;
                                    GenJnlLine3.VALIDATE("Posting Date",GenJnlLine."Posting Date");
                                    GenJnlLine3."Document Type" := GenJnlLine."Document Type";
                                    GenJnlLine3."Document No." := UseCheckNo;
                                    GenJnlLine3."Account Type" := GenJnlLine3."Account Type"::"Bank Account";
                                    GenJnlLine3.VALIDATE("Account No.",BankAcc2."No.");
                                    IF BalancingType <> BalancingType::"G/L Account" THEN
                                      GenJnlLine3.Description := STRSUBSTNO(Text014,SELECTSTR(BalancingType + 1,Text062),BalancingNo);
                                    GenJnlLine3.VALIDATE(Amount,-TotalLineAmount);
                                    GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::"Computer Check";
                                    GenJnlLine3."Check Printed" := TRUE;
                                    GenJnlLine3."Source Code" := GenJnlLine."Source Code";
                                    GenJnlLine3."Reason Code" := GenJnlLine."Reason Code";
                                    GenJnlLine3."Allow Zero-Amount Posting" := TRUE;
                                    GenJnlLine3.INSERT;
                                    IF CheckGenJournalBatchAndLineIsApproved(GenJnlLine) THEN
                                      RecordRestrictionMgt.AllowRecordUsage(GenJnlLine3);
                                  END;
                                END;

                                BankAcc2."Last Check No." := UseCheckNo;
                                BankAcc2.MODIFY;

                                CLEAR(CheckManagement);
                              END;
                               }

    { 24  ;2   ;Column  ;CheckToAddr1        ;
               SourceExpr=CheckToAddr[1] }

    { 52  ;2   ;Column  ;CheckDateText       ;
               SourceExpr=CheckDateText }

    { 96  ;2   ;Column  ;CheckNoText         ;
               SourceExpr=CheckNoText }

    { 37  ;2   ;Column  ;FirstPage           ;
               SourceExpr=FirstPage }

    { 36  ;2   ;Column  ;PreprintedStub      ;
               SourceExpr=PreprintedStub }

    { 89  ;2   ;Column  ;CheckNoTextCaption  ;
               SourceExpr=CheckNoTextCaptionLbl }

    { 4098;2   ;DataItem;PrintSettledLoop    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               MaxIteration=30;
               OnPreDataItem=BEGIN
                               IF NOT TestPrint THEN
                                 IF FirstPage THEN BEGIN
                                   FoundLast := TRUE;
                                   CASE ApplyMethod OF
                                     ApplyMethod::OneLineOneEntry:
                                       FoundLast := FALSE;
                                     ApplyMethod::OneLineID:
                                       CASE BalancingType OF
                                         BalancingType::Customer:
                                           BEGIN
                                             CustLedgEntry.RESET;
                                             CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
                                             CustLedgEntry.SETRANGE("Customer No.",BalancingNo);
                                             CustLedgEntry.SETRANGE(Open,TRUE);
                                             CustLedgEntry.SETRANGE(Positive,TRUE);
                                             CustLedgEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
                                             FoundLast := NOT CustLedgEntry.FIND('-');
                                             IF FoundLast THEN BEGIN
                                               CustLedgEntry.SETRANGE(Positive,FALSE);
                                               FoundLast := NOT CustLedgEntry.FIND('-');
                                               FoundNegative := TRUE;
                                             END ELSE
                                               FoundNegative := FALSE;
                                           END;
                                         BalancingType::Vendor:
                                           BEGIN
                                             VendLedgEntry.RESET;
                                             VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive);
                                             VendLedgEntry.SETRANGE("Vendor No.",BalancingNo);
                                             VendLedgEntry.SETRANGE(Open,TRUE);
                                             VendLedgEntry.SETRANGE(Positive,TRUE);
                                             VendLedgEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
                                             FoundLast := NOT VendLedgEntry.FIND('-');
                                             IF FoundLast THEN BEGIN
                                               VendLedgEntry.SETRANGE(Positive,FALSE);
                                               FoundLast := NOT VendLedgEntry.FIND('-');
                                               FoundNegative := TRUE;
                                             END ELSE
                                               FoundNegative := FALSE;
                                           END;
                                       END;
                                     ApplyMethod::MoreLinesOneEntry:
                                       FoundLast := FALSE;
                                   END;
                                 END
                                 ELSE
                                   FoundLast := FALSE;

                               IF DocNo = '' THEN
                                 CurrencyCode2 := GenJnlLine."Currency Code";

                               IF PreprintedStub THEN
                                 TotalText := ''
                               ELSE
                                 TotalText := Text019;

                               IF GenJnlLine."Currency Code" <> '' THEN
                                 NetAmount := STRSUBSTNO(Text063,GenJnlLine."Currency Code")
                               ELSE BEGIN
                                 GLSetup.GET;
                                 NetAmount := STRSUBSTNO(Text063,GLSetup."LCY Code");
                               END;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF NOT TestPrint THEN BEGIN
                                    IF FoundLast THEN BEGIN
                                      IF RemainingAmount <> 0 THEN BEGIN
                                        DocNo := '';
                                        ExtDocNo := '';
                                        DocDate := 0D;
                                        LineAmount := RemainingAmount;
                                        LineAmount2 := RemainingAmount;
                                        CurrentLineAmount := LineAmount2;
                                        LineDiscount := 0;
                                        RemainingAmount := 0;
                                      END ELSE
                                        CurrReport.BREAK;
                                    END ELSE
                                      CASE ApplyMethod OF
                                        ApplyMethod::OneLineOneEntry:
                                          BEGIN
                                            CASE BalancingType OF
                                              BalancingType::Customer:
                                                BEGIN
                                                  CustLedgEntry.RESET;
                                                  CustLedgEntry.SETCURRENTKEY("Document No.");
                                                  CustLedgEntry.SETRANGE("Document Type",GenJnlLine."Applies-to Doc. Type");
                                                  CustLedgEntry.SETRANGE("Document No.",GenJnlLine."Applies-to Doc. No.");
                                                  CustLedgEntry.SETRANGE("Customer No.",BalancingNo);
                                                  CustLedgEntry.FIND('-');
                                                  CustUpdateAmounts(CustLedgEntry,RemainingAmount);
                                                END;
                                              BalancingType::Vendor:
                                                BEGIN
                                                  VendLedgEntry.RESET;
                                                  VendLedgEntry.SETCURRENTKEY("Document No.");
                                                  VendLedgEntry.SETRANGE("Document Type",GenJnlLine."Applies-to Doc. Type");
                                                  VendLedgEntry.SETRANGE("Document No.",GenJnlLine."Applies-to Doc. No.");
                                                  VendLedgEntry.SETRANGE("Vendor No.",BalancingNo);
                                                  VendLedgEntry.FIND('-');
                                                  VendUpdateAmounts(VendLedgEntry,RemainingAmount);
                                                END;
                                            END;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            CurrentLineAmount := LineAmount2;
                                            FoundLast := TRUE;
                                          END;
                                        ApplyMethod::OneLineID:
                                          BEGIN
                                            CASE BalancingType OF
                                              BalancingType::Customer:
                                                BEGIN
                                                  CustUpdateAmounts(CustLedgEntry,RemainingAmount);
                                                  FoundLast := (CustLedgEntry.NEXT = 0) OR (RemainingAmount <= 0);
                                                  IF FoundLast AND NOT FoundNegative THEN BEGIN
                                                    CustLedgEntry.SETRANGE(Positive,FALSE);
                                                    FoundLast := NOT CustLedgEntry.FIND('-');
                                                    FoundNegative := TRUE;
                                                  END;
                                                END;
                                              BalancingType::Vendor:
                                                BEGIN
                                                  VendUpdateAmounts(VendLedgEntry,RemainingAmount);
                                                  FoundLast := (VendLedgEntry.NEXT = 0) OR (RemainingAmount <= 0);
                                                  IF FoundLast AND NOT FoundNegative THEN BEGIN
                                                    VendLedgEntry.SETRANGE(Positive,FALSE);
                                                    FoundLast := NOT VendLedgEntry.FIND('-');
                                                    FoundNegative := TRUE;
                                                  END;
                                                END;
                                            END;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            CurrentLineAmount := LineAmount2;
                                          END;
                                        ApplyMethod::MoreLinesOneEntry:
                                          BEGIN
                                            CurrentLineAmount := GenJnlLine2.Amount;
                                            LineAmount2 := CurrentLineAmount;

                                            IF GenJnlLine2."Applies-to ID" <> '' THEN
                                              ERROR(Text016);
                                            GenJnlLine2.TESTFIELD("Check Printed",FALSE);
                                            GenJnlLine2.TESTFIELD("Bank Payment Type",GenJnlLine2."Bank Payment Type"::"Computer Check");
                                            IF BankAcc2."Currency Code" <> GenJnlLine2."Currency Code" THEN
                                              ERROR(Text005);
                                            IF GenJnlLine2."Applies-to Doc. No." = '' THEN BEGIN
                                              DocNo := '';
                                              ExtDocNo := '';
                                              DocDate := 0D;
                                              LineAmount := CurrentLineAmount;
                                              LineDiscount := 0;
                                            END ELSE
                                              CASE BalancingType OF
                                                BalancingType::"G/L Account":
                                                  BEGIN
                                                    DocNo := GenJnlLine2."Document No.";
                                                    ExtDocNo := GenJnlLine2."External Document No.";
                                                    LineAmount := CurrentLineAmount;
                                                    LineDiscount := 0;
                                                  END;
                                                BalancingType::Customer:
                                                  BEGIN
                                                    CustLedgEntry.RESET;
                                                    CustLedgEntry.SETCURRENTKEY("Document No.");
                                                    CustLedgEntry.SETRANGE("Document Type",GenJnlLine2."Applies-to Doc. Type");
                                                    CustLedgEntry.SETRANGE("Document No.",GenJnlLine2."Applies-to Doc. No.");
                                                    CustLedgEntry.SETRANGE("Customer No.",BalancingNo);
                                                    CustLedgEntry.FIND('-');
                                                    CustUpdateAmounts(CustLedgEntry,CurrentLineAmount);
                                                    LineAmount := CurrentLineAmount;
                                                  END;
                                                BalancingType::Vendor:
                                                  BEGIN
                                                    VendLedgEntry.RESET;
                                                    IF GenJnlLine2."Source Line No." <> 0 THEN
                                                      VendLedgEntry.SETRANGE("Entry No.",GenJnlLine2."Source Line No.")
                                                    ELSE BEGIN
                                                      VendLedgEntry.SETCURRENTKEY("Document No.");
                                                      VendLedgEntry.SETRANGE("Document Type",GenJnlLine2."Applies-to Doc. Type");
                                                      VendLedgEntry.SETRANGE("Document No.",GenJnlLine2."Applies-to Doc. No.");
                                                      VendLedgEntry.SETRANGE("Vendor No.",BalancingNo);
                                                    END;
                                                    VendLedgEntry.FIND('-');
                                                    VendUpdateAmounts(VendLedgEntry,CurrentLineAmount);
                                                    LineAmount := CurrentLineAmount;
                                                  END;
                                                BalancingType::"Bank Account":
                                                  BEGIN
                                                    DocNo := GenJnlLine2."Document No.";
                                                    ExtDocNo := GenJnlLine2."External Document No.";
                                                    LineAmount := CurrentLineAmount;
                                                    LineDiscount := 0;
                                                  END;
                                              END;
                                            FoundLast := GenJnlLine2.NEXT = 0;
                                          END;
                                      END;

                                    TotalLineAmount := TotalLineAmount + LineAmount2;
                                    TotalLineDiscount := TotalLineDiscount + LineDiscount;
                                  END ELSE BEGIN
                                    IF FoundLast THEN
                                      CurrReport.BREAK;
                                    FoundLast := TRUE;
                                    DocNo := Text010;
                                    ExtDocNo := Text010;
                                    LineAmount := 0;
                                    LineDiscount := 0;
                                  END;
                                END;
                                 }

    { 31  ;3   ;Column  ;NetAmount           ;
               SourceExpr=NetAmount;
               AutoFormatType=1;
               AutoFormatExpr=GenJnlLine."Currency Code" }

    { 4   ;3   ;Column  ;TotalLineDiscountLineDiscount;
               SourceExpr=TotalLineDiscount - LineDiscount;
               AutoFormatType=1;
               AutoFormatExpr=GenJnlLine."Currency Code" }

    { 26  ;3   ;Column  ;TotalLineAmountLineAmount;
               SourceExpr=TotalLineAmount - LineAmount;
               AutoFormatType=1;
               AutoFormatExpr=GenJnlLine."Currency Code" }

    { 32  ;3   ;Column  ;TotalLineAmountLineAmount2;
               SourceExpr=TotalLineAmount - LineAmount2;
               AutoFormatType=1;
               AutoFormatExpr=GenJnlLine."Currency Code" }

    { 113 ;3   ;Column  ;LineAmount          ;
               SourceExpr=LineAmount;
               AutoFormatType=1;
               AutoFormatExpr=GenJnlLine."Currency Code" }

    { 114 ;3   ;Column  ;LineDiscount        ;
               SourceExpr=LineDiscount;
               AutoFormatType=1;
               AutoFormatExpr=GenJnlLine."Currency Code" }

    { 115 ;3   ;Column  ;LineAmountLineDiscount;
               SourceExpr=LineAmount + LineDiscount;
               AutoFormatType=1;
               AutoFormatExpr=GenJnlLine."Currency Code" }

    { 116 ;3   ;Column  ;DocNo               ;
               SourceExpr=DocNo }

    { 13  ;3   ;Column  ;DocDate             ;
               SourceExpr=DocDate }

    { 28  ;3   ;Column  ;CurrencyCode2       ;
               SourceExpr=CurrencyCode2;
               AutoFormatType=1;
               AutoFormatExpr=GenJnlLine."Currency Code" }

    { 29  ;3   ;Column  ;CurrentLineAmount   ;
               SourceExpr=CurrentLineAmount;
               AutoFormatType=1;
               AutoFormatExpr=GenJnlLine."Currency Code" }

    { 34  ;3   ;Column  ;ExtDocNo            ;
               SourceExpr=ExtDocNo }

    { 108 ;3   ;Column  ;LineAmountCaption   ;
               SourceExpr=LineAmountCaptionLbl }

    { 109 ;3   ;Column  ;LineDiscountCaption ;
               SourceExpr=LineDiscountCaptionLbl }

    { 110 ;3   ;Column  ;AmountCaption       ;
               SourceExpr=AmountCaptionLbl }

    { 111 ;3   ;Column  ;DocNoCaption        ;
               SourceExpr=DocNoCaptionLbl }

    { 14  ;3   ;Column  ;DocDateCaption      ;
               SourceExpr=DocDateCaptionLbl }

    { 25  ;3   ;Column  ;CurrencyCodeCaption ;
               SourceExpr=CurrencyCodeCaptionLbl }

    { 33  ;3   ;Column  ;YourDocNoCaption    ;
               SourceExpr=YourDocNoCaptionLbl }

    { 27  ;3   ;Column  ;TransportCaption    ;
               SourceExpr=TransportCaptionLbl }

    { 3931;2   ;DataItem;PrintCheck          ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               MaxIteration=1;
               OnAfterGetRecord=VAR
                                  Decimals@1000 : Decimal;
                                  CheckLedgEntryAmount@1001 : Decimal;
                                BEGIN
                                  IF NOT TestPrint THEN BEGIN
                                    WITH GenJnlLine DO BEGIN
                                      CheckLedgEntry.INIT;
                                      CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                                      CheckLedgEntry."Posting Date" := "Posting Date";
                                      CheckLedgEntry."Document Type" := "Document Type";
                                      CheckLedgEntry."Document No." := UseCheckNo;
                                      CheckLedgEntry.Description := Description;
                                      CheckLedgEntry."Bank Payment Type" := "Bank Payment Type";
                                      CheckLedgEntry."Bal. Account Type" := BalancingType;
                                      CheckLedgEntry."Bal. Account No." := BalancingNo;
                                      IF FoundLast THEN BEGIN
                                        IF TotalLineAmount <= 0 THEN
                                          ERROR(
                                            Text020,
                                            UseCheckNo,TotalLineAmount);
                                        CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Printed;
                                        CheckLedgEntry.Amount := TotalLineAmount;
                                      END ELSE BEGIN
                                        CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Voided;
                                        CheckLedgEntry.Amount := 0;
                                      END;
                                      CheckLedgEntry."Check Date" := "Posting Date";
                                      CheckLedgEntry."Check No." := UseCheckNo;
                                      CheckManagement.InsertCheck(CheckLedgEntry,RECORDID);

                                      IF FoundLast THEN BEGIN
                                        IF BankAcc2."Currency Code" <> '' THEN
                                          Currency.GET(BankAcc2."Currency Code")
                                        ELSE
                                          Currency.InitRoundingPrecision;
                                        CheckLedgEntryAmount := CheckLedgEntry.Amount;
                                        Decimals := CheckLedgEntry.Amount - ROUND(CheckLedgEntry.Amount,1,'<');
                                        IF STRLEN(FORMAT(Decimals)) < STRLEN(FORMAT(Currency."Amount Rounding Precision")) THEN
                                          IF Decimals = 0 THEN
                                            CheckAmountText := FORMAT(CheckLedgEntryAmount,0,0) +
                                              COPYSTR(FORMAT(0.01),2,1) +
                                              PADSTR('',STRLEN(FORMAT(Currency."Amount Rounding Precision")) - 2,'0')
                                          ELSE
                                            CheckAmountText := FORMAT(CheckLedgEntryAmount,0,0) +
                                              PADSTR('',STRLEN(FORMAT(Currency."Amount Rounding Precision")) - STRLEN(FORMAT(Decimals)),'0')
                                        ELSE
                                          CheckAmountText := FORMAT(CheckLedgEntryAmount,0,0);
                                        FormatNoText(DescriptionLine,CheckLedgEntry.Amount,BankAcc2."Currency Code");
                                        VoidText := '';
                                      END ELSE BEGIN
                                        CLEAR(CheckAmountText);
                                        CLEAR(DescriptionLine);
                                        TotalText := Text065;
                                        DescriptionLine[1] := Text021;
                                        DescriptionLine[2] := DescriptionLine[1];
                                        VoidText := Text022;
                                      END;
                                    END;
                                  END ELSE
                                    WITH GenJnlLine DO BEGIN
                                      CheckLedgEntry.INIT;
                                      CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                                      CheckLedgEntry."Posting Date" := "Posting Date";
                                      CheckLedgEntry."Document No." := UseCheckNo;
                                      CheckLedgEntry.Description := Text023;
                                      CheckLedgEntry."Bank Payment Type" := "Bank Payment Type"::"Computer Check";
                                      CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::"Test Print";
                                      CheckLedgEntry."Check Date" := "Posting Date";
                                      CheckLedgEntry."Check No." := UseCheckNo;
                                      CheckManagement.InsertCheck(CheckLedgEntry,RECORDID);

                                      CheckAmountText := Text024;
                                      DescriptionLine[1] := Text025;
                                      DescriptionLine[2] := DescriptionLine[1];
                                      VoidText := Text022;
                                    END;

                                  ChecksPrinted := ChecksPrinted + 1;
                                  FirstPage := FALSE;
                                END;
                                 }

    { 1   ;3   ;Column  ;CheckAmountText     ;
               SourceExpr=CheckAmountText }

    { 2   ;3   ;Column  ;CheckDateTextControl2;
               SourceExpr=CheckDateText }

    { 5   ;3   ;Column  ;DescriptionLine2    ;
               SourceExpr=DescriptionLine[2] }

    { 6   ;3   ;Column  ;DescriptionLine1    ;
               SourceExpr=DescriptionLine[1] }

    { 7   ;3   ;Column  ;CheckToAddr1Control7;
               SourceExpr=CheckToAddr[1] }

    { 8   ;3   ;Column  ;CheckToAddr2        ;
               SourceExpr=CheckToAddr[2] }

    { 9   ;3   ;Column  ;CheckToAddr4        ;
               SourceExpr=CheckToAddr[4] }

    { 10  ;3   ;Column  ;CheckToAddr3        ;
               SourceExpr=CheckToAddr[3] }

    { 12  ;3   ;Column  ;CheckToAddr5        ;
               SourceExpr=CheckToAddr[5] }

    { 15  ;3   ;Column  ;CompanyAddr4        ;
               SourceExpr=CompanyAddr[4] }

    { 16  ;3   ;Column  ;CompanyAddr8        ;
               SourceExpr=CompanyAddr[8] }

    { 17  ;3   ;Column  ;CompanyAddr7        ;
               SourceExpr=CompanyAddr[7] }

    { 18  ;3   ;Column  ;CompanyAddr6        ;
               SourceExpr=CompanyAddr[6] }

    { 19  ;3   ;Column  ;CompanyAddr5        ;
               SourceExpr=CompanyAddr[5] }

    { 20  ;3   ;Column  ;CompanyAddr3        ;
               SourceExpr=CompanyAddr[3] }

    { 21  ;3   ;Column  ;CheckNoTextControl21;
               SourceExpr=CheckNoText }

    { 22  ;3   ;Column  ;CompanyAddr2        ;
               SourceExpr=CompanyAddr[2] }

    { 23  ;3   ;Column  ;CompanyAddr1        ;
               SourceExpr=CompanyAddr[1] }

    { 30  ;3   ;Column  ;TotalLineAmount     ;
               SourceExpr=TotalLineAmount;
               AutoFormatType=1;
               AutoFormatExpr=GenJnlLine."Currency Code" }

    { 11  ;3   ;Column  ;TotalText           ;
               SourceExpr=TotalText }

    { 3   ;3   ;Column  ;VoidText            ;
               SourceExpr=VoidText }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnOpenPage=BEGIN
                   IF BankAcc2."No." <> '' THEN
                     IF BankAcc2.GET(BankAcc2."No.") THEN
                       UseCheckNo := BankAcc2."Last Check No."
                     ELSE BEGIN
                       BankAcc2."No." := '';
                       UseCheckNo := '';
                     END;
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  Name=BankAccount;
                  CaptionML=[DAN=Bankkonto;
                             ENU=Bank Account];
                  ToolTipML=[DAN=Angiver den bankkonto, som de udskrevne checks skal tr‘kkes p†.;
                             ENU=Specifies the bank account that the printed checks will be drawn from.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=BankAcc2."No.";
                  TableRelation="Bank Account";
                  OnValidate=BEGIN
                               InputBankAccount;
                             END;
                              }

      { 3   ;2   ;Field     ;
                  Name=LastCheckNo;
                  CaptionML=[DAN=Sidste checknr.;
                             ENU=Last Check No.];
                  ToolTipML=[DAN=Angiver v‘rdien i feltet Sidste checknr. p† bankkontokortet.;
                             ENU=Specifies the value of the Last Check No. field on the bank account card.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=UseCheckNo }

      { 11  ;2   ;Field     ;
                  Name=OneCheckPerVendorPerDocumentNo;
                  CaptionML=[DAN=En check pr. kreditor pr. bilagsnr.;
                             ENU=One Check per Vendor per Document No.];
                  ToolTipML=[DAN=Angiver, om der kun udskrives ‚n check pr. kreditor for hvert dokumentnr.;
                             ENU=Specifies if only one check is printed per vendor for each document number.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=OneCheckPrVendor;
                  MultiLine=Yes }

      { 5   ;2   ;Field     ;
                  Name=ReprintChecks;
                  CaptionML=[DAN=Genudskriv check;
                             ENU=Reprint Checks];
                  ToolTipML=[DAN=Angiver, om checks udskrives igen, hvis du har annulleret udskrivningen pga. et problem.;
                             ENU=Specifies if checks are printed again if you canceled the printing due to a problem.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ReprintChecks }

      { 9   ;2   ;Field     ;
                  Name=TestPrinting;
                  CaptionML=[DAN=Kontroludskrift;
                             ENU=Test Print];
                  ToolTipML=[DAN=Angiver, om du vil udskrive checks p† et blankt stykke papir, f›r du udskriver den p† checkblanketter.;
                             ENU=Specifies if you want to print the checks on blank paper before you print them on check forms.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=TestPrint }

      { 13  ;2   ;Field     ;
                  CaptionML=[DAN=Fortrykt f›lgebrev;
                             ENU=Preprinted Stub];
                  ToolTipML=[DAN=Angiver, om du vil bruge checkblanketter med fortrykt f›lgebrev.;
                             ENU=Specifies if you use check forms with preprinted stubs.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PreprintedStub }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Det er ikke muligt at se rapporten p† sk‘rmen.;ENU=Preview is not allowed.';
      Text001@1001 : TextConst 'DAN=Sidste checknr. skal udfyldes.;ENU=Last Check No. must be filled in.';
      Text002@1002 : TextConst 'DAN=Der m† ikke v‘re filtre p† %1 og %2.;ENU=Filters on %1 and %2 are not allowed.';
      Text003@1003 : TextConst 'DAN=XXXXXXXXXXXXXXXX;ENU=XXXXXXXXXXXXXXXX';
      Text004@1004 : TextConst 'DAN=skal indtastes.;ENU=must be entered.';
      Text005@1005 : TextConst 'DAN=Bankkontoen og finanslinjerne skal v‘re i den samme valuta.;ENU=The Bank Account and the General Journal Line must have the same currency.';
      Text008@1008 : TextConst 'DAN=Begge bankkonti skal have den samme valuta.;ENU=Both Bank Accounts must have the same currency.';
      Text010@1010 : TextConst 'DAN=XXXXXXXXXX;ENU=XXXXXXXXXX';
      Text011@1011 : TextConst 'DAN=XXXX;ENU=XXXX';
      Text012@1012 : TextConst 'DAN=XX.XXXXXXXXXX.XXXX;ENU=XX.XXXXXXXXXX.XXXX';
      Text013@1013 : TextConst 'DAN=%1 findes allerede.;ENU=%1 already exists.';
      Text014@1014 : TextConst 'DAN=Unders›g for %1 %2;ENU=Check for %1 %2';
      Text016@1016 : TextConst 'DAN=I kontrolrapporten m† en check pr. kreditor pr. bilagsnr.\ikke v‘re aktiveret, n†r Udlignings-id er angivet p† kladdelinjerne.;ENU=In the Check report, One Check per Vendor and Document No.\must not be activated when Applies-to ID is specified in the journal lines.';
      Text019@1019 : TextConst 'DAN=I alt;ENU=Total';
      Text020@1020 : TextConst 'DAN=Det totale bel›b p† check %1 er %2. Bel›bet skal v‘re positivt.;ENU=The total amount of check %1 is %2. The amount must be positive.';
      Text021@1021 : TextConst 'DAN=UGYLDIG UGYLDIG UGYLDIG UGYLDIG UGYLDIG UGYLDIG UGYLDIG UGYLDIG;ENU=VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
      Text022@1022 : TextConst 'DAN=IKKE OMS’TTELIG;ENU=NON-NEGOTIABLE';
      Text023@1023 : TextConst 'DAN=Kontroludskrift;ENU=Test print';
      Text024@1024 : TextConst 'DAN=XXXX.XX;ENU=XXXX.XX';
      Text025@1025 : TextConst 'DAN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;ENU=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
      Text026@1026 : TextConst 'DAN=NUL;ENU=ZERO';
      Text027@1027 : TextConst 'DAN=HUNDREDE;ENU=HUNDRED';
      Text028@1028 : TextConst 'DAN=OG;ENU=AND';
      Text029@1029 : TextConst 'DAN=%1 resulterer i et skrevet tal, der er for langt.;ENU=%1 results in a written number that is too long.';
      Text030@1030 : TextConst 'DAN=" er allerede udlignet med %1 %2 for debitor %3.";ENU=" is already applied to %1 %2 for customer %3."';
      Text031@1031 : TextConst 'DAN=" er allerede udlignet med %1 %2 for kreditor %3.";ENU=" is already applied to %1 %2 for vendor %3."';
      Text032@1032 : TextConst 'DAN=EN;ENU=ONE';
      Text033@1033 : TextConst 'DAN=TO;ENU=TWO';
      Text034@1034 : TextConst 'DAN=TRE;ENU=THREE';
      Text035@1035 : TextConst 'DAN=FIRE;ENU=FOUR';
      Text036@1036 : TextConst 'DAN=FEM;ENU=FIVE';
      Text037@1037 : TextConst 'DAN=SEKS;ENU=SIX';
      Text038@1038 : TextConst 'DAN=SYV;ENU=SEVEN';
      Text039@1039 : TextConst 'DAN=OTTE;ENU=EIGHT';
      Text040@1040 : TextConst 'DAN=NI;ENU=NINE';
      Text041@1041 : TextConst 'DAN=TI;ENU=TEN';
      Text042@1042 : TextConst 'DAN=ELLEVE;ENU=ELEVEN';
      Text043@1043 : TextConst 'DAN=TOLV;ENU=TWELVE';
      Text044@1044 : TextConst 'DAN=TRETTEN;ENU=THIRTEEN';
      Text045@1045 : TextConst 'DAN=FJORTEN;ENU=FOURTEEN';
      Text046@1046 : TextConst 'DAN=FEMTEN;ENU=FIFTEEN';
      Text047@1047 : TextConst 'DAN=SEKSTEN;ENU=SIXTEEN';
      Text048@1048 : TextConst 'DAN=SYTTEN;ENU=SEVENTEEN';
      Text049@1049 : TextConst 'DAN=ATTEN;ENU=EIGHTEEN';
      Text050@1050 : TextConst 'DAN=NITTEN;ENU=NINETEEN';
      Text051@1051 : TextConst 'DAN=TOTI;ENU=TWENTY';
      Text052@1052 : TextConst 'DAN=TRETI;ENU=THIRTY';
      Text053@1053 : TextConst 'DAN=FIRTI;ENU=FORTY';
      Text054@1054 : TextConst 'DAN=FEMTI;ENU=FIFTY';
      Text055@1055 : TextConst 'DAN=SEKSTI;ENU=SIXTY';
      Text056@1056 : TextConst 'DAN=SYVTI;ENU=SEVENTY';
      Text057@1057 : TextConst 'DAN=OTTI;ENU=EIGHTY';
      Text058@1058 : TextConst 'DAN=NITI;ENU=NINETY';
      Text059@1059 : TextConst 'DAN=TUSIND;ENU=THOUSAND';
      Text060@1060 : TextConst 'DAN=MILLION;ENU=MILLION';
      Text061@1061 : TextConst 'DAN=MILLIARD;ENU=BILLION';
      CompanyInfo@1062 : Record 79;
      CurrencyExchangeRate@1006 : Record 330;
      SalesPurchPerson@1063 : Record 13;
      GenJnlLine2@1064 : Record 81;
      GenJnlLine3@1065 : Record 81;
      Cust@1066 : Record 18;
      CustLedgEntry@1067 : Record 21;
      Vend@1068 : Record 23;
      VendLedgEntry@1069 : Record 25;
      BankAcc@1070 : Record 270;
      BankAcc2@1071 : Record 270;
      CheckLedgEntry@1072 : Record 272;
      Currency@1073 : Record 4;
      GLSetup@1007 : Record 98;
      FormatAddr@1074 : Codeunit 365;
      CheckManagement@1075 : Codeunit 367;
      CompanyAddr@1076 : ARRAY [8] OF Text[50];
      CheckToAddr@1077 : ARRAY [8] OF Text[50];
      OnesText@1078 : ARRAY [20] OF Text[30];
      TensText@1079 : ARRAY [10] OF Text[30];
      ExponentText@1080 : ARRAY [5] OF Text[30];
      BalancingType@1081 : 'G/L Account,Customer,Vendor,Bank Account';
      BalancingNo@1082 : Code[20];
      CheckNoText@1084 : Text[30];
      CheckDateText@1085 : Text[30];
      CheckAmountText@1086 : Text[30];
      DescriptionLine@1087 : ARRAY [2] OF Text[80];
      DocNo@1089 : Text[30];
      ExtDocNo@1119 : Text[35];
      VoidText@1090 : Text[30];
      LineAmount@1091 : Decimal;
      LineDiscount@1092 : Decimal;
      TotalLineAmount@1093 : Decimal;
      TotalLineDiscount@1094 : Decimal;
      RemainingAmount@1095 : Decimal;
      CurrentLineAmount@1096 : Decimal;
      UseCheckNo@1097 : Code[20];
      FoundLast@1098 : Boolean;
      ReprintChecks@1099 : Boolean;
      TestPrint@1100 : Boolean;
      FirstPage@1101 : Boolean;
      OneCheckPrVendor@1102 : Boolean;
      FoundNegative@1103 : Boolean;
      ApplyMethod@1104 : 'Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry';
      ChecksPrinted@1105 : Integer;
      HighestLineNo@1106 : Integer;
      PreprintedStub@1107 : Boolean;
      TotalText@1108 : Text[10];
      DocDate@1109 : Date;
      JournalPostingDate@1009 : Date;
      i@1110 : Integer;
      Text062@1111 : TextConst 'DAN=Finanskonto,Debitor,Kreditor,Bankkonto;ENU=G/L Account,Customer,Vendor,Bank Account';
      CurrencyCode2@1112 : Code[10];
      NetAmount@1114 : Text[30];
      LineAmount2@1116 : Decimal;
      Text063@1117 : TextConst 'DAN=Nettobel›b %1;ENU=Net Amount %1';
      Text064@1113 : TextConst 'DAN=%1 m† ikke v‘re %2 for %3 %4.;ENU=%1 must not be %2 for %3 %4.';
      Text065@1120 : TextConst 'DAN=Subtotal;ENU=Subtotal';
      OneHundredThousandText@1060000 : Text[30];
      Text10600@1060001 : TextConst 'DAN=ET;ENU=ONE-ET';
      Text10601@1060002 : TextConst 'DAN=OG;ENU=AND';
      Text10602@1060003 : TextConst 'DAN=ER;ENU=S';
      CheckNoTextCaptionLbl@6359 : TextConst 'DAN=Checknr.;ENU=Check No.';
      LineAmountCaptionLbl@5261 : TextConst 'DAN=Nettobel›b;ENU=Net Amount';
      LineDiscountCaptionLbl@3244 : TextConst 'DAN=Rabat;ENU=Discount';
      AmountCaptionLbl@7794 : TextConst 'DAN=Bel›b;ENU=Amount';
      DocNoCaptionLbl@2117 : TextConst 'DAN=Bilagsnr.;ENU=Document No.';
      DocDateCaptionLbl@6175 : TextConst 'DAN=Bilagsdato;ENU=Document Date';
      CurrencyCodeCaptionLbl@2455 : TextConst 'DAN=Valutakode;ENU=Currency Code';
      YourDocNoCaptionLbl@4226 : TextConst 'DAN=Dit bilagsnr.;ENU=Your Doc. No.';
      TransportCaptionLbl@2440 : TextConst 'DAN=Transport;ENU=Transport';

    [External]
    PROCEDURE FormatNoText@1(VAR NoText@1000 : ARRAY [2] OF Text[80];No@1001 : Decimal;CurrencyCode@1002 : Code[10]);
    VAR
      PrintExponent@1003 : Boolean;
      Ones@1004 : Integer;
      Tens@1005 : Integer;
      Hundreds@1006 : Integer;
      Exponent@1007 : Integer;
      NoTextIndex@1008 : Integer;
      DecimalPosition@1010 : Decimal;
      OriginalNumber@1060000 : Decimal;
    BEGIN
      CLEAR(NoText);
      NoTextIndex := 1;
      NoText[1] := '****';
      GLSetup.GET;

      OriginalNumber := No;

      IF No < 1 THEN
        AddToNoText(NoText,NoTextIndex,PrintExponent,Text026,FALSE)
      ELSE BEGIN
        FOR Exponent := 4 DOWNTO 1 DO BEGIN
          PrintExponent := FALSE;
          Ones := No DIV POWER(1000,Exponent - 1);
          Hundreds := Ones DIV 100;
          Tens := (Ones MOD 100) DIV 10;
          Ones := Ones MOD 10;
          IF Hundreds > 0 THEN BEGIN
            IF Hundreds = 1 THEN
              AddToNoText(NoText,NoTextIndex,PrintExponent,OneHundredThousandText,TRUE)
            ELSE
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Hundreds],TRUE);
            AddToNoText(NoText,NoTextIndex,PrintExponent,Text027,TRUE);
          END;
          IF ((Tens * 10 + Ones) > 0) AND (Exponent = 1) AND (OriginalNumber > 100) THEN
            AddToNoText(NoText,NoTextIndex,PrintExponent,Text10601,TRUE);
          IF Tens >= 2 THEN BEGIN
            AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[Tens],TRUE);
            IF Ones > 0 THEN
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Ones],FALSE);
          END ELSE
            IF (Tens * 10 + Ones) > 0 THEN
              IF (Exponent = 2) AND ((Tens * 10 + Ones) = 1) THEN
                AddToNoText(NoText,NoTextIndex,PrintExponent,OneHundredThousandText,TRUE)
              ELSE
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Tens * 10 + Ones],TRUE);
          IF PrintExponent AND (Exponent > 1) THEN
            AddToNoText(NoText,NoTextIndex,PrintExponent,ExponentText[Exponent],TRUE);
          IF PrintExponent AND (Exponent > 2) AND ((Hundreds * 100 + Tens * 10 + Ones) > 1) THEN
            AddToNoText(NoText,NoTextIndex,PrintExponent,Text10602,FALSE);
          No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000,Exponent - 1);
        END;
      END;

      AddToNoText(NoText,NoTextIndex,PrintExponent,Text028,TRUE);
      DecimalPosition := GetAmtDecimalPosition;
      AddToNoText(NoText,NoTextIndex,PrintExponent,(FORMAT(No * DecimalPosition) + '/' + FORMAT(DecimalPosition)),TRUE);


      IF CurrencyCode <> '' THEN
        AddToNoText(NoText,NoTextIndex,PrintExponent,CurrencyCode,TRUE);
    END;

    LOCAL PROCEDURE AddToNoText@2(VAR NoText@1000 : ARRAY [2] OF Text[80];VAR NoTextIndex@1001 : Integer;VAR PrintExponent@1002 : Boolean;AddText@1003 : Text[30];AddSpace@1060000 : Boolean);
    VAR
      SpaceText@1060001 : Text[2];
    BEGIN
      PrintExponent := TRUE;

      IF AddSpace THEN
        SpaceText := ' '
      ELSE
        SpaceText := '';
      WHILE STRLEN(NoText[NoTextIndex] + SpaceText + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
        NoTextIndex := NoTextIndex + 1;
        IF NoTextIndex > ARRAYLEN(NoText) THEN
          ERROR(Text029,AddText);
      END;

      NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + SpaceText + AddText,'<');
    END;

    [Internal]
    LOCAL PROCEDURE CustUpdateAmounts@3(VAR CustLedgEntry2@1000 : Record 21;RemainingAmount2@1001 : Decimal);
    VAR
      AmountToApply@1002 : Decimal;
    BEGIN
      IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
         (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
      THEN BEGIN
        GenJnlLine3.RESET;
        GenJnlLine3.SETCURRENTKEY(
          "Account Type","Account No.","Applies-to Doc. Type","Applies-to Doc. No.");
        GenJnlLine3.SETRANGE("Account Type",GenJnlLine3."Account Type"::Customer);
        GenJnlLine3.SETRANGE("Account No.",CustLedgEntry2."Customer No.");
        GenJnlLine3.SETRANGE("Applies-to Doc. Type",CustLedgEntry2."Document Type");
        GenJnlLine3.SETRANGE("Applies-to Doc. No.",CustLedgEntry2."Document No.");
        IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
          GenJnlLine3.SETFILTER("Line No.",'<>%1',GenJnlLine."Line No.")
        ELSE
          GenJnlLine3.SETFILTER("Line No.",'<>%1',GenJnlLine2."Line No.");
        IF CustLedgEntry2."Document Type" <> CustLedgEntry2."Document Type"::" " THEN
          IF GenJnlLine3.FIND('-') THEN
            GenJnlLine3.FIELDERROR(
              "Applies-to Doc. No.",
              STRSUBSTNO(
                Text030,
                CustLedgEntry2."Document Type",CustLedgEntry2."Document No.",
                CustLedgEntry2."Customer No."));
      END;

      DocNo := CustLedgEntry2."Document No.";
      ExtDocNo := CustLedgEntry2."External Document No.";
      DocDate := CustLedgEntry2."Posting Date";
      CurrencyCode2 := CustLedgEntry2."Currency Code";

      CustLedgEntry2.CALCFIELDS("Remaining Amount");

      LineAmount :=
        -ABSMin(
          CustLedgEntry2."Remaining Amount" -
          CustLedgEntry2."Remaining Pmt. Disc. Possible" -
          CustLedgEntry2."Accepted Payment Tolerance",
          CustLedgEntry2."Amount to Apply");
      LineAmount2 :=
        ROUND(ExchangeAmt(GenJnlLine."Currency Code",CurrencyCode2,LineAmount),Currency."Amount Rounding Precision");

      IF ((CustLedgEntry2."Document Type" IN [CustLedgEntry2."Document Type"::Invoice,
                                              CustLedgEntry2."Document Type"::"Credit Memo"]) AND
          (CustLedgEntry2."Remaining Pmt. Disc. Possible" <> 0) AND
          (CustLedgEntry2."Posting Date" <= CustLedgEntry2."Pmt. Discount Date")) OR
         CustLedgEntry2."Accepted Pmt. Disc. Tolerance"
      THEN BEGIN
        LineDiscount := -CustLedgEntry2."Remaining Pmt. Disc. Possible";
        IF CustLedgEntry2."Accepted Payment Tolerance" <> 0 THEN
          LineDiscount := LineDiscount - CustLedgEntry2."Accepted Payment Tolerance";
      END ELSE BEGIN
        AmountToApply :=
          ROUND(-ExchangeAmt(
              GenJnlLine."Currency Code",CurrencyCode2,CustLedgEntry2."Amount to Apply"),Currency."Amount Rounding Precision");
        IF RemainingAmount2 >= AmountToApply THEN
          LineAmount2 := AmountToApply
        ELSE BEGIN
          LineAmount2 := RemainingAmount2;
          LineAmount := ROUND(ExchangeAmt(CurrencyCode2,GenJnlLine."Currency Code",LineAmount2),Currency."Amount Rounding Precision");
        END;
        LineDiscount := 0;
      END;
    END;

    [Internal]
    LOCAL PROCEDURE VendUpdateAmounts@4(VAR VendLedgEntry2@1000 : Record 25;RemainingAmount2@1001 : Decimal);
    VAR
      AmountToApply@1002 : Decimal;
    BEGIN
      IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
         (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
      THEN BEGIN
        GenJnlLine3.RESET;
        GenJnlLine3.SETCURRENTKEY(
          "Account Type","Account No.","Applies-to Doc. Type","Applies-to Doc. No.");
        GenJnlLine3.SETRANGE("Account Type",GenJnlLine3."Account Type"::Vendor);
        GenJnlLine3.SETRANGE("Account No.",VendLedgEntry2."Vendor No.");
        GenJnlLine3.SETRANGE("Applies-to Doc. Type",VendLedgEntry2."Document Type");
        GenJnlLine3.SETRANGE("Applies-to Doc. No.",VendLedgEntry2."Document No.");
        IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
          GenJnlLine3.SETFILTER("Line No.",'<>%1',GenJnlLine."Line No.")
        ELSE
          GenJnlLine3.SETFILTER("Line No.",'<>%1',GenJnlLine2."Line No.");
        IF VendLedgEntry2."Document Type" <> VendLedgEntry2."Document Type"::" " THEN
          IF GenJnlLine3.FIND('-') THEN
            GenJnlLine3.FIELDERROR(
              "Applies-to Doc. No.",
              STRSUBSTNO(
                Text031,
                VendLedgEntry2."Document Type",VendLedgEntry2."Document No.",
                VendLedgEntry2."Vendor No."));
      END;

      DocNo := VendLedgEntry2."Document No.";
      ExtDocNo := VendLedgEntry2."External Document No.";
      DocDate := VendLedgEntry2."Posting Date";
      CurrencyCode2 := VendLedgEntry2."Currency Code";
      VendLedgEntry2.CALCFIELDS("Remaining Amount");

      LineAmount :=
        -ABSMin(
          VendLedgEntry2."Remaining Amount" -
          VendLedgEntry2."Remaining Pmt. Disc. Possible" -
          VendLedgEntry2."Accepted Payment Tolerance",
          VendLedgEntry2."Amount to Apply");

      LineAmount2 :=
        ROUND(ExchangeAmt(GenJnlLine."Currency Code",CurrencyCode2,LineAmount),Currency."Amount Rounding Precision");

      IF ((VendLedgEntry2."Document Type" IN [VendLedgEntry2."Document Type"::Invoice,
                                              VendLedgEntry2."Document Type"::"Credit Memo"]) AND
          (VendLedgEntry2."Remaining Pmt. Disc. Possible" <> 0) AND
          (GenJnlLine."Posting Date" <= VendLedgEntry2."Pmt. Discount Date")) OR
         VendLedgEntry2."Accepted Pmt. Disc. Tolerance"
      THEN BEGIN
        LineDiscount := -VendLedgEntry2."Remaining Pmt. Disc. Possible";
        IF VendLedgEntry2."Accepted Payment Tolerance" <> 0 THEN
          LineDiscount := LineDiscount - VendLedgEntry2."Accepted Payment Tolerance";
      END ELSE BEGIN
        AmountToApply := ROUND(-ExchangeAmt(
              GenJnlLine."Currency Code",CurrencyCode2,VendLedgEntry2."Amount to Apply"),Currency."Amount Rounding Precision");
        IF ABS(RemainingAmount2) >= ABS(AmountToApply) THEN BEGIN
          LineAmount2 := AmountToApply;
          LineAmount :=
            ROUND(ExchangeAmt(CurrencyCode2,GenJnlLine."Currency Code",LineAmount2),Currency."Amount Rounding Precision");
        END ELSE BEGIN
          LineAmount2 := RemainingAmount2;
          LineAmount :=
            ROUND(
              ExchangeAmt(CurrencyCode2,GenJnlLine."Currency Code",LineAmount2),Currency."Amount Rounding Precision");
        END;
        LineDiscount := 0;
      END;
    END;

    [External]
    PROCEDURE InitTextVariable@5();
    BEGIN
      OnesText[1] := Text032;
      OnesText[2] := Text033;
      OnesText[3] := Text034;
      OnesText[4] := Text035;
      OnesText[5] := Text036;
      OnesText[6] := Text037;
      OnesText[7] := Text038;
      OnesText[8] := Text039;
      OnesText[9] := Text040;
      OnesText[10] := Text041;
      OnesText[11] := Text042;
      OnesText[12] := Text043;
      OnesText[13] := Text044;
      OnesText[14] := Text045;
      OnesText[15] := Text046;
      OnesText[16] := Text047;
      OnesText[17] := Text048;
      OnesText[18] := Text049;
      OnesText[19] := Text050;

      TensText[1] := '';
      TensText[2] := Text051;
      TensText[3] := Text052;
      TensText[4] := Text053;
      TensText[5] := Text054;
      TensText[6] := Text055;
      TensText[7] := Text056;
      TensText[8] := Text057;
      TensText[9] := Text058;

      ExponentText[1] := '';
      ExponentText[2] := Text059;
      ExponentText[3] := Text060;
      ExponentText[4] := Text061;

      OneHundredThousandText := Text10600;
    END;

    [External]
    PROCEDURE InitializeRequest@6(BankAcc@1000 : Code[20];LastCheckNo@1001 : Code[20];NewOneCheckPrVend@1002 : Boolean;NewReprintChecks@1003 : Boolean;NewTestPrint@1004 : Boolean;NewPreprintedStub@1005 : Boolean);
    BEGIN
      IF BankAcc <> '' THEN
        IF BankAcc2.GET(BankAcc) THEN BEGIN
          UseCheckNo := LastCheckNo;
          OneCheckPrVendor := NewOneCheckPrVend;
          ReprintChecks := NewReprintChecks;
          TestPrint := NewTestPrint;
          PreprintedStub := NewPreprintedStub;
        END;
    END;

    [Internal]
    LOCAL PROCEDURE ExchangeAmt@7(CurrencyCode@1001 : Code[10];CurrencyCode2@1003 : Code[10];Amount@1002 : Decimal) Amount2 : Decimal;
    BEGIN
      IF (CurrencyCode <> '')  AND (CurrencyCode2 = '') THEN
        Amount2 :=
          CurrencyExchangeRate.ExchangeAmtLCYToFCY(
            JournalPostingDate,CurrencyCode,Amount,CurrencyExchangeRate.ExchangeRate(JournalPostingDate,CurrencyCode))
      ELSE
        IF (CurrencyCode = '') AND (CurrencyCode2 <> '') THEN
          Amount2 :=
            CurrencyExchangeRate.ExchangeAmtFCYToLCY(
              JournalPostingDate,CurrencyCode2,Amount,CurrencyExchangeRate.ExchangeRate(JournalPostingDate,CurrencyCode2))
        ELSE
          IF (CurrencyCode <> '') AND (CurrencyCode2 <> '') AND (CurrencyCode <> CurrencyCode2) THEN
            Amount2 := CurrencyExchangeRate.ExchangeAmtFCYToFCY(JournalPostingDate,CurrencyCode2,CurrencyCode,Amount)
          ELSE
            Amount2 := Amount;
    END;

    LOCAL PROCEDURE ABSMin@21(Decimal1@1000 : Decimal;Decimal2@1001 : Decimal) : Decimal;
    BEGIN
      IF ABS(Decimal1) < ABS(Decimal2) THEN
        EXIT(Decimal1);
      EXIT(Decimal2);
    END;

    [External]
    PROCEDURE InputBankAccount@8();
    BEGIN
      IF BankAcc2."No." <> '' THEN BEGIN
        BankAcc2.GET(BankAcc2."No.");
        BankAcc2.TESTFIELD("Last Check No.");
        UseCheckNo := BankAcc2."Last Check No.";
      END;
    END;

    LOCAL PROCEDURE GetAmtDecimalPosition@22() : Decimal;
    VAR
      Currency@1000 : Record 4;
    BEGIN
      IF GenJnlLine."Currency Code" = '' THEN
        Currency.InitRoundingPrecision
      ELSE BEGIN
        Currency.GET(GenJnlLine."Currency Code");
        Currency.TESTFIELD("Amount Rounding Precision");
      END;
      EXIT(1 / Currency."Amount Rounding Precision");
    END;

    LOCAL PROCEDURE CheckGenJournalBatchAndLineIsApproved@15(GenJournalLine@1000 : Record 81) : Boolean;
    VAR
      GenJournalBatch@1002 : Record 232;
    BEGIN
      GenJournalBatch.GET(GenJournalLine."Journal Template Name",GenJournalLine."Journal Batch Name");
      EXIT(
        VerifyRecordIdIsApproved(DATABASE::"Gen. Journal Batch",GenJournalBatch.RECORDID) OR
        VerifyRecordIdIsApproved(DATABASE::"Gen. Journal Line",GenJournalLine.RECORDID));
    END;

    LOCAL PROCEDURE VerifyRecordIdIsApproved@19(TableNo@1000 : Integer;RecordId@1001 : RecordID) : Boolean;
    VAR
      ApprovalEntry@1002 : Record 454;
      ApprovalsMgmt@1003 : Codeunit 1535;
    BEGIN
      ApprovalEntry.SETRANGE("Table ID",TableNo);
      ApprovalEntry.SETRANGE("Record ID to Approve",RecordId);
      ApprovalEntry.SETRANGE(Status,ApprovalEntry.Status::Approved);
      ApprovalEntry.SETRANGE("Related to Change",FALSE);
      IF ApprovalEntry.ISEMPTY THEN
        EXIT(FALSE);
      EXIT(NOT ApprovalsMgmt.HasOpenOrPendingApprovalEntries(RecordId));
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
    <?xml version="1.0" encoding="utf-8"?>
<Report xmlns="http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner">
  <AutoRefresh>0</AutoRefresh>
  <DataSources>
    <DataSource Name="DataSource">
      <ConnectionProperties>
        <DataProvider>SQL</DataProvider>
        <ConnectString />
      </ConnectionProperties>
      <rd:SecurityType>None</rd:SecurityType>
      <rd:DataSourceID>ac1bb36c-7b28-449e-aa5f-8da3f87729d0</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="JournalTempName_GenJnlLine">
          <DataField>JournalTempName_GenJnlLine</DataField>
        </Field>
        <Field Name="JournalBatchName_GenJnlLine">
          <DataField>JournalBatchName_GenJnlLine</DataField>
        </Field>
        <Field Name="LineNo_GenJnlLine">
          <DataField>LineNo_GenJnlLine</DataField>
        </Field>
        <Field Name="CheckToAddr1">
          <DataField>CheckToAddr1</DataField>
        </Field>
        <Field Name="CheckDateText">
          <DataField>CheckDateText</DataField>
        </Field>
        <Field Name="CheckNoText">
          <DataField>CheckNoText</DataField>
        </Field>
        <Field Name="FirstPage">
          <DataField>FirstPage</DataField>
        </Field>
        <Field Name="PreprintedStub">
          <DataField>PreprintedStub</DataField>
        </Field>
        <Field Name="CheckNoTextCaption">
          <DataField>CheckNoTextCaption</DataField>
        </Field>
        <Field Name="NetAmount">
          <DataField>NetAmount</DataField>
        </Field>
        <Field Name="TotalLineDiscountLineDiscount">
          <DataField>TotalLineDiscountLineDiscount</DataField>
        </Field>
        <Field Name="TotalLineDiscountLineDiscountFormat">
          <DataField>TotalLineDiscountLineDiscountFormat</DataField>
        </Field>
        <Field Name="TotalLineAmountLineAmount">
          <DataField>TotalLineAmountLineAmount</DataField>
        </Field>
        <Field Name="TotalLineAmountLineAmountFormat">
          <DataField>TotalLineAmountLineAmountFormat</DataField>
        </Field>
        <Field Name="TotalLineAmountLineAmount2">
          <DataField>TotalLineAmountLineAmount2</DataField>
        </Field>
        <Field Name="TotalLineAmountLineAmount2Format">
          <DataField>TotalLineAmountLineAmount2Format</DataField>
        </Field>
        <Field Name="LineAmount">
          <DataField>LineAmount</DataField>
        </Field>
        <Field Name="LineAmountFormat">
          <DataField>LineAmountFormat</DataField>
        </Field>
        <Field Name="LineDiscount">
          <DataField>LineDiscount</DataField>
        </Field>
        <Field Name="LineDiscountFormat">
          <DataField>LineDiscountFormat</DataField>
        </Field>
        <Field Name="LineAmountLineDiscount">
          <DataField>LineAmountLineDiscount</DataField>
        </Field>
        <Field Name="LineAmountLineDiscountFormat">
          <DataField>LineAmountLineDiscountFormat</DataField>
        </Field>
        <Field Name="DocNo">
          <DataField>DocNo</DataField>
        </Field>
        <Field Name="DocDate">
          <DataField>DocDate</DataField>
        </Field>
        <Field Name="CurrencyCode2">
          <DataField>CurrencyCode2</DataField>
        </Field>
        <Field Name="CurrentLineAmount">
          <DataField>CurrentLineAmount</DataField>
        </Field>
        <Field Name="CurrentLineAmountFormat">
          <DataField>CurrentLineAmountFormat</DataField>
        </Field>
        <Field Name="ExtDocNo">
          <DataField>ExtDocNo</DataField>
        </Field>
        <Field Name="LineAmountCaption">
          <DataField>LineAmountCaption</DataField>
        </Field>
        <Field Name="LineDiscountCaption">
          <DataField>LineDiscountCaption</DataField>
        </Field>
        <Field Name="AmountCaption">
          <DataField>AmountCaption</DataField>
        </Field>
        <Field Name="DocNoCaption">
          <DataField>DocNoCaption</DataField>
        </Field>
        <Field Name="DocDateCaption">
          <DataField>DocDateCaption</DataField>
        </Field>
        <Field Name="CurrencyCodeCaption">
          <DataField>CurrencyCodeCaption</DataField>
        </Field>
        <Field Name="YourDocNoCaption">
          <DataField>YourDocNoCaption</DataField>
        </Field>
        <Field Name="TransportCaption">
          <DataField>TransportCaption</DataField>
        </Field>
        <Field Name="CheckAmountText">
          <DataField>CheckAmountText</DataField>
        </Field>
        <Field Name="CheckDateTextControl2">
          <DataField>CheckDateTextControl2</DataField>
        </Field>
        <Field Name="DescriptionLine2">
          <DataField>DescriptionLine2</DataField>
        </Field>
        <Field Name="DescriptionLine1">
          <DataField>DescriptionLine1</DataField>
        </Field>
        <Field Name="CheckToAddr1Control7">
          <DataField>CheckToAddr1Control7</DataField>
        </Field>
        <Field Name="CheckToAddr2">
          <DataField>CheckToAddr2</DataField>
        </Field>
        <Field Name="CheckToAddr4">
          <DataField>CheckToAddr4</DataField>
        </Field>
        <Field Name="CheckToAddr3">
          <DataField>CheckToAddr3</DataField>
        </Field>
        <Field Name="CheckToAddr5">
          <DataField>CheckToAddr5</DataField>
        </Field>
        <Field Name="CompanyAddr4">
          <DataField>CompanyAddr4</DataField>
        </Field>
        <Field Name="CompanyAddr8">
          <DataField>CompanyAddr8</DataField>
        </Field>
        <Field Name="CompanyAddr7">
          <DataField>CompanyAddr7</DataField>
        </Field>
        <Field Name="CompanyAddr6">
          <DataField>CompanyAddr6</DataField>
        </Field>
        <Field Name="CompanyAddr5">
          <DataField>CompanyAddr5</DataField>
        </Field>
        <Field Name="CompanyAddr3">
          <DataField>CompanyAddr3</DataField>
        </Field>
        <Field Name="CheckNoTextControl21">
          <DataField>CheckNoTextControl21</DataField>
        </Field>
        <Field Name="CompanyAddr2">
          <DataField>CompanyAddr2</DataField>
        </Field>
        <Field Name="CompanyAddr1">
          <DataField>CompanyAddr1</DataField>
        </Field>
        <Field Name="TotalLineAmount">
          <DataField>TotalLineAmount</DataField>
        </Field>
        <Field Name="TotalLineAmountFormat">
          <DataField>TotalLineAmountFormat</DataField>
        </Field>
        <Field Name="TotalText">
          <DataField>TotalText</DataField>
        </Field>
        <Field Name="VoidText">
          <DataField>VoidText</DataField>
        </Field>
      </Fields>
      <rd:DataSetInfo>
        <rd:DataSetName>DataSet</rd:DataSetName>
        <rd:SchemaPath>Report.xsd</rd:SchemaPath>
        <rd:TableName>Result</rd:TableName>
      </rd:DataSetInfo>
    </DataSet>
  </DataSets>
  <ReportSections>
    <ReportSection>
      <Body>
        <ReportItems>
          <Tablix Name="list1">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>7.00787in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>1.6248in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1_Contents">
                          <ReportItems>
                            <Tablix Name="Table1">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.7874in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.7874in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.7874in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.70866in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.90551in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.98425in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.98425in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.98425in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.07874in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CheckToAddr1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CheckToAddr1.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>77</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CheckDateText">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CheckDateText.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>76</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CheckNoTextCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CheckNoTextCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>75</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CheckNoText">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CheckNoText.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>74</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox42">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>73</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox4">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox4</rd:DefaultName>
                                            <ZIndex>72</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox1</rd:DefaultName>
                                            <ZIndex>71</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox2">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox2</rd:DefaultName>
                                            <ZIndex>70</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox13">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox13</rd:DefaultName>
                                            <ZIndex>69</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox14">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox14</rd:DefaultName>
                                            <ZIndex>68</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox17">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox17</rd:DefaultName>
                                            <ZIndex>67</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox19">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox19</rd:DefaultName>
                                            <ZIndex>66</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox20">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox20</rd:DefaultName>
                                            <ZIndex>65</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox27">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox27</rd:DefaultName>
                                            <ZIndex>64</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox5">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox5</rd:DefaultName>
                                            <ZIndex>63</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="DocNoCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DocNoCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>62</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="YourDocNoCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!YourDocNoCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>61</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="DocDateCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DocDateCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>60</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CurrencyCodeCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CurrencyCodeCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>59</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="AmountCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AmountCaption.value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>58</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="LineDiscountCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineDiscountCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>57</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="LineAmountCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineAmountCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>56</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="NetAmount">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!NetAmount.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>55</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox6">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox6</rd:DefaultName>
                                            <ZIndex>54</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox160">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox160</rd:DefaultName>
                                            <ZIndex>53</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox161">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox161</rd:DefaultName>
                                            <ZIndex>52</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox162">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox162</rd:DefaultName>
                                            <ZIndex>51</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox163">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox163</rd:DefaultName>
                                            <ZIndex>50</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox164">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox164</rd:DefaultName>
                                            <ZIndex>49</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox165">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox165</rd:DefaultName>
                                            <ZIndex>48</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox166">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox166</rd:DefaultName>
                                            <ZIndex>47</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox167">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox167</rd:DefaultName>
                                            <ZIndex>46</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox7">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox7</rd:DefaultName>
                                            <ZIndex>45</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox58">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox58</rd:DefaultName>
                                            <ZIndex>44</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox59">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox59</rd:DefaultName>
                                            <ZIndex>43</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox60">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox60</rd:DefaultName>
                                            <ZIndex>42</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox62">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox62</rd:DefaultName>
                                            <ZIndex>41</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox67">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox67</rd:DefaultName>
                                            <ZIndex>40</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox68">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox68</rd:DefaultName>
                                            <ZIndex>39</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox93">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox93</rd:DefaultName>
                                            <ZIndex>38</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox106">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox106</rd:DefaultName>
                                            <ZIndex>37</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox8">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox8</rd:DefaultName>
                                            <ZIndex>36</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox29">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox29</rd:DefaultName>
                                            <ZIndex>35</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox30">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox30</rd:DefaultName>
                                            <ZIndex>34</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox43">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox43</rd:DefaultName>
                                            <ZIndex>33</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox45">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox45</rd:DefaultName>
                                            <ZIndex>32</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox46">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox46</rd:DefaultName>
                                            <ZIndex>31</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox50">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox50</rd:DefaultName>
                                            <ZIndex>30</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox52">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox52</rd:DefaultName>
                                            <ZIndex>29</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox53">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox53</rd:DefaultName>
                                            <ZIndex>28</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox10">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox10</rd:DefaultName>
                                            <ZIndex>27</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox22">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox22</rd:DefaultName>
                                            <ZIndex>26</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox23">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox23</rd:DefaultName>
                                            <ZIndex>25</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox24">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox24</rd:DefaultName>
                                            <ZIndex>24</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox25">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox25</rd:DefaultName>
                                            <ZIndex>23</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TransportCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TransportCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>22</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalLineDiscountLineDiscount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalLineDiscountLineDiscount.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!TotalLineDiscountLineDiscountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>21</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalLineAmtLineAmt">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalLineAmountLineAmount.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!TotalLineAmountLineAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalLineAmtLineAmt2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalLineAmountLineAmount2.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!TotalLineAmountLineAmount2Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>19</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox11">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!TotalLineAmountLineAmount2Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox11</rd:DefaultName>
                                            <ZIndex>18</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox70">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox70</rd:DefaultName>
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox75">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox75</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox77">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox77</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox78">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox78</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox83">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox83</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox84">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!TotalLineDiscountLineDiscountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox84</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox85">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!TotalLineAmountLineAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox85</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox86">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!TotalLineAmountLineAmount2Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox86</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox3">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox3</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="DocNo">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DocNo.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ExtDocNo">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ExtDocNo.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="DocDate">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DocDate.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CurrencyCode2">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CurrencyCode2.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="LineAmtLineDiscount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineAmountLineDiscount.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!LineAmountLineDiscountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="LineDiscount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineDiscount.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!LineDiscountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="LineAmount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineAmount.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!LineAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>0.105cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="LineAmount2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CurrentLineAmount.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!CurrentLineAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="IsLastRec">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=iif(CInt(CountRows("Table1_Group1")) = CInt(RowNumber("Table1_Group1")),True,False)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!LineAmountFormat.Value</Format>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.105cm</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <Group Name="Table1_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!JournalTempName_GenJnlLine.Value</GroupExpression>
                                        <GroupExpression>=Fields!JournalBatchName_GenJnlLine.Value</GroupExpression>
                                        <GroupExpression>=Fields!LineNo_GenJnlLine.Value</GroupExpression>
                                      </GroupExpressions>
                                      <Filters>
                                        <Filter>
                                          <FilterExpression>=Fields!CheckNoText.Value</FilterExpression>
                                          <Operator>GreaterThan</Operator>
                                          <FilterValues>
                                            <FilterValue>=""</FilterValue>
                                          </FilterValues>
                                        </Filter>
                                      </Filters>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=iif(Fields!PreprintedStub.Value=true,true,false)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=iif(Fields!PreprintedStub.Value=true,true,false)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=iif(Fields!PreprintedStub.Value=false,true,false)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=iif(Fields!FirstPage.Value=true,true,false)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=iif(Fields!FirstPage.Value=true,true,false)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Group Name="Table1_Details_Group">
                                          <DataElementName>Detail</DataElementName>
                                        </Group>
                                        <SortExpressions>
                                          <SortExpression>
                                            <Value>=Fields!DocNo.Value</Value>
                                          </SortExpression>
                                          <SortExpression>
                                            <Value>=Fields!ExtDocNo.Value</Value>
                                          </SortExpression>
                                        </SortExpressions>
                                        <TablixMembers>
                                          <TablixMember />
                                        </TablixMembers>
                                        <DataElementName>Detail_Collection</DataElementName>
                                        <DataElementOutput>Output</DataElementOutput>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <KeepTogether>true</KeepTogether>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!CheckNoText.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>0.31746cm</Top>
                              <Height>1.49886in</Height>
                              <Width>7.00786in</Width>
                              <Style />
                            </Tablix>
                            <Tablix Name="table2">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.11811in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.12498in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompAddr">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!CompanyAddr1.Value) + Chr(177) +
Last(Fields!CompanyAddr2.Value) + Chr(177) +
Last(Fields!CompanyAddr3.Value) + Chr(177) +
Last(Fields!CompanyAddr4.Value) + Chr(177) +
Last(Fields!CompanyAddr5.Value) + Chr(177) +
Last(Fields!CompanyAddr6.Value) + Chr(177) +
Last(Fields!CompanyAddr7.Value) + Chr(177) +
Last(Fields!CompanyAddr8.Value)+ Chr(177) +
Last(Fields!DescriptionLine1.Value) + Chr(177) +
Last(Fields!DescriptionLine2.Value) + Chr(177) +
Last(Fields!CheckToAddr1Control7.Value) + Chr(177) +
Last(Fields!CheckToAddr2.Value) + Chr(177) +
Last(Fields!CheckToAddr3.Value) + Chr(177) +
Last(Fields!CheckToAddr4.Value) + Chr(177) +
Last(Fields!CheckToAddr5.Value)+ Chr(177) +
CStr(last(Fields!TotalText.Value)) + Chr(177) +
CStr(Last(Fields!TotalLineAmount.Value)) + Chr(177) +
CStr(Last(Fields!CheckNoTextControl21.Value)) + Chr(177) +
CStr(Last(Fields!CheckDateTextControl2.Value)) + Chr(177) +
CStr(Last(Fields!CheckAmountText.Value)) + Chr(177) +
CStr(Last(Fields!VoidText.Value))</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>2</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Height>0.31745cm</Height>
                              <Width>0.3cm</Width>
                              <ZIndex>1</ZIndex>
                              <Style />
                            </Tablix>
                          </ReportItems>
                          <KeepTogether>true</KeepTogether>
                          <Style />
                        </Rectangle>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
              </TablixRows>
            </TablixBody>
            <TablixColumnHierarchy>
              <TablixMembers>
                <TablixMember />
              </TablixMembers>
            </TablixColumnHierarchy>
            <TablixRowHierarchy>
              <TablixMembers>
                <TablixMember>
                  <Group Name="list1_Details_Group">
                    <GroupExpressions>
                      <GroupExpression>=Fields!CheckNoText.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <SortExpressions>
                    <SortExpression>
                      <Value>=Fields!CheckNoText.Value</Value>
                    </SortExpression>
                  </SortExpressions>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <KeepTogether>true</KeepTogether>
            <PageBreak>
              <BreakLocation>End</BreakLocation>
            </PageBreak>
            <Filters>
              <Filter>
                <FilterExpression>=Fields!CheckNoText.Value</FilterExpression>
                <Operator>GreaterThan</Operator>
                <FilterValues>
                  <FilterValue>=""</FilterValue>
                </FilterValues>
              </Filter>
            </Filters>
            <Height>4.12699cm</Height>
            <Width>17.79999cm</Width>
            <Style />
          </Tablix>
        </ReportItems>
        <Height>4.12699cm</Height>
        <Style />
      </Body>
      <Width>17.8cm</Width>
      <Page>
        <PageFooter>
          <Height>3.34364in</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Rectangle Name="rectangle1">
              <ReportItems>
                <Textbox Name="TotalText">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(16,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                            <FontWeight>Bold</FontWeight>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Left>3.97917in</Left>
                  <Height>0.423cm</Height>
                  <Width>2.5cm</Width>
                  <Style>
                    <Border />
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="TotalLineAmount">
                  <CanGrow>true</CanGrow>
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(17,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                            <FontWeight>Bold</FontWeight>
                            <Format>N</Format>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Left>5.94792in</Left>
                  <Height>0.423cm</Height>
                  <Width>2.49812cm</Width>
                  <ZIndex>1</ZIndex>
                  <Style>
                    <Border />
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="VoidText">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(21,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>3.01042in</Top>
                  <Left>4.95833in</Left>
                  <Height>0.423cm</Height>
                  <Width>2.5cm</Width>
                  <ZIndex>2</ZIndex>
                  <Style>
                    <Border />
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CompanyAddr2">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(2,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>1.01042in</Top>
                  <Height>0.423cm</Height>
                  <Width>6.03175cm</Width>
                  <ZIndex>3</ZIndex>
                  <Style>
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CompanyAddr3">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(3,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>1.17709in</Top>
                  <Height>0.423cm</Height>
                  <Width>6.03175cm</Width>
                  <ZIndex>4</ZIndex>
                  <Style>
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CompanyAddr4">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(4,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>1.34375in</Top>
                  <Height>0.423cm</Height>
                  <Width>6.03175cm</Width>
                  <ZIndex>5</ZIndex>
                  <Style>
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CompanyAddr5">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(5,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>1.51042in</Top>
                  <Height>0.423cm</Height>
                  <Width>6.03175cm</Width>
                  <ZIndex>6</ZIndex>
                  <Style>
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CompanyAddr6">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(6,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>1.67709in</Top>
                  <Height>0.423cm</Height>
                  <Width>6.03175cm</Width>
                  <ZIndex>7</ZIndex>
                  <Style>
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CompanyAddr7">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(7,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>1.84375in</Top>
                  <Height>0.423cm</Height>
                  <Width>6.03175cm</Width>
                  <ZIndex>8</ZIndex>
                  <Style>
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CompanyAddr8">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(8,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>2.01042in</Top>
                  <Height>0.423cm</Height>
                  <Width>6.03175cm</Width>
                  <ZIndex>9</ZIndex>
                  <Style>
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CheckNoTextControl21">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(18,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                            <FontWeight>Bold</FontWeight>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>1.17709in</Top>
                  <Left>5.94792in</Left>
                  <Height>0.423cm</Height>
                  <Width>2.49812cm</Width>
                  <ZIndex>10</ZIndex>
                  <Style>
                    <Border />
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="DescriptionLine1">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(9,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>2.17709in</Top>
                  <Left>0.79167in</Left>
                  <Height>0.423cm</Height>
                  <Width>13.1cm</Width>
                  <ZIndex>11</ZIndex>
                  <Style>
                    <Border />
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="DescriptionLine2">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(10,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>2.34381in</Top>
                  <Left>0.79167in</Left>
                  <Height>0.423cm</Height>
                  <Width>13.1cm</Width>
                  <ZIndex>12</ZIndex>
                  <Style>
                    <Border />
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CheckToAddr">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(11,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>2.51042in</Top>
                  <Left>0.79167in</Left>
                  <Height>0.423cm</Height>
                  <Width>5.8cm</Width>
                  <ZIndex>13</ZIndex>
                  <Style>
                    <Border />
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CheckNoTextCtrl21">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(19,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>2.51042in</Top>
                  <Left>3.97917in</Left>
                  <Height>0.423cm</Height>
                  <Width>2.5cm</Width>
                  <ZIndex>14</ZIndex>
                  <Style>
                    <Border />
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CheckAmountText">
                  <CanGrow>true</CanGrow>
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>="********" +Code.GetData(20,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                            <Format>N</Format>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>2.51042in</Top>
                  <Left>5.94792in</Left>
                  <Height>0.423cm</Height>
                  <Width>2.49812cm</Width>
                  <ZIndex>15</ZIndex>
                  <Style>
                    <Border />
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CheckToAddr2">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(12,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>2.67709in</Top>
                  <Left>0.79167in</Left>
                  <Height>0.423cm</Height>
                  <Width>5.8cm</Width>
                  <ZIndex>16</ZIndex>
                  <Style>
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CheckToAddr3">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(13,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>2.84375in</Top>
                  <Left>0.79167in</Left>
                  <Height>0.423cm</Height>
                  <Width>5.8cm</Width>
                  <ZIndex>17</ZIndex>
                  <Style>
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CheckToAddr4">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(14,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>3.01042in</Top>
                  <Left>0.79167in</Left>
                  <Height>0.423cm</Height>
                  <Width>5.8cm</Width>
                  <ZIndex>18</ZIndex>
                  <Style>
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CheckToAddr5">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(15,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>3.17709in</Top>
                  <Left>0.79167in</Left>
                  <Height>0.16655in</Height>
                  <Width>5.8cm</Width>
                  <ZIndex>19</ZIndex>
                  <Style>
                    <Border />
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
                <Textbox Name="CompanyAddr1">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(1,1)</Value>
                          <Style>
                            <FontSize>7pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>0.84375in</Top>
                  <Height>0.423cm</Height>
                  <Width>6.03175cm</Width>
                  <ZIndex>20</ZIndex>
                  <Style>
                    <PaddingLeft>2pt</PaddingLeft>
                    <PaddingRight>2pt</PaddingRight>
                    <PaddingTop>2pt</PaddingTop>
                    <PaddingBottom>2pt</PaddingBottom>
                  </Style>
                </Textbox>
              </ReportItems>
              <DataElementOutput>ContentsOnly</DataElementOutput>
              <Height>3.34364in</Height>
              <Width>17.60584cm</Width>
              <Visibility>
                <Hidden>=iif(CBool(ReportItems!IsLastRec.Value),False,True)</Hidden>
              </Visibility>
              <Style />
            </Rectangle>
          </ReportItems>
          <Style />
        </PageFooter>
        <PageHeight>29.7cm</PageHeight>
        <PageWidth>21cm</PageWidth>
        <InteractiveHeight>11in</InteractiveHeight>
        <InteractiveWidth>8.5in</InteractiveWidth>
        <LeftMargin>1.5cm</LeftMargin>
        <RightMargin>0cm</RightMargin>
        <TopMargin>2cm</TopMargin>
        <BottomMargin>2cm</BottomMargin>
        <Style />
      </Page>
    </ReportSection>
  </ReportSections>
  <Code>Public Function BlankZero(ByVal Value As Decimal)
    if Value = 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankPos(ByVal Value As Decimal)
    if Value &gt; 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankZeroAndPos(ByVal Value As Decimal)
    if Value &gt;= 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankNeg(ByVal Value As Decimal)
    if Value &lt; 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankNegAndZero(ByVal Value As Decimal)
    if Value &lt;= 0 then
        Return ""
    end if
    Return Value
End Function

Shared Data1 as Object

Public Function GetData(Num as Integer, Group as integer) as Object
if Group = 1 then
   Return Cstr(Choose(Num, Split(Cstr(Data1),Chr(177))))
End If
End Function

Public Function SetData(NewData as Object,Group as integer)
  If Group = 1 and NewData &gt; "" Then
      Data1 = NewData
  End If  
  Return True
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>65fac6f4-eda5-4b03-9009-3a3cdbf9e25b</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

