OBJECT Report 2 General Journal - Test
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finanskladde - kontrol;
               ENU=General Journal - Test];
  }
  DATASET
  {
    { 3502;    ;DataItem;                    ;
               DataItemTable=Table232;
               DataItemTableView=SORTING(Journal Template Name,Name);
               OnPreDataItem=BEGIN
                               GLSetup.GET;
                               SalesSetup.GET;
                               PurchSetup.GET;
                               AmountLCY := 0;
                               BalanceLCY := 0;
                             END;
                              }

    { 68  ;1   ;Column  ;JnlTmplName_GenJnlBatch;
               SourceExpr="Journal Template Name" }

    { 69  ;1   ;Column  ;Name_GenJnlBatch    ;
               SourceExpr=Name }

    { 3   ;1   ;Column  ;CompanyName         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 1   ;1   ;Column  ;GeneralJnlTestCaption;
               SourceExpr=GeneralJnlTestCap }

    { 5444;1   ;DataItem;                    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               PrintOnlyIfDetail=Yes }

    { 8   ;2   ;Column  ;JnlTemplateName_GenJnlBatch;
               SourceExpr="Gen. Journal Batch"."Journal Template Name" }

    { 10  ;2   ;Column  ;JnlName_GenJnlBatch ;
               SourceExpr="Gen. Journal Batch".Name }

    { 60  ;2   ;Column  ;GenJnlLineFilter    ;
               SourceExpr=GenJnlLineFilter }

    { 53  ;2   ;Column  ;GenJnlLineFilterTableCaption;
               SourceExpr="Gen. Journal Line".TABLECAPTION + ': ' + GenJnlLineFilter }

    { 70  ;2   ;Column  ;Number_Integer      ;
               SourceExpr=Number }

    { 4   ;2   ;Column  ;PageNoCaption       ;
               SourceExpr=PageNoCap }

    { 7   ;2   ;Column  ;JnlTmplNameCaption_GenJnlBatch;
               SourceExpr="Gen. Journal Batch".FIELDCAPTION("Journal Template Name") }

    { 9   ;2   ;Column  ;JournalBatchCaption ;
               SourceExpr=JnlBatchNameCap }

    { 11  ;2   ;Column  ;PostingDateCaption  ;
               SourceExpr=PostingDateCap }

    { 12  ;2   ;Column  ;DocumentTypeCaption ;
               SourceExpr=DocumentTypeCap }

    { 13  ;2   ;Column  ;DocNoCaption_GenJnlLine;
               SourceExpr="Gen. Journal Line".FIELDCAPTION("Document No.") }

    { 14  ;2   ;Column  ;AccountTypeCaption  ;
               SourceExpr=AccountTypeCap }

    { 15  ;2   ;Column  ;AccNoCaption_GenJnlLine;
               SourceExpr="Gen. Journal Line".FIELDCAPTION("Account No.") }

    { 16  ;2   ;Column  ;AccNameCaption      ;
               SourceExpr=AccNameCap }

    { 17  ;2   ;Column  ;DescCaption_GenJnlLine;
               SourceExpr="Gen. Journal Line".FIELDCAPTION(Description) }

    { 18  ;2   ;Column  ;PostingTypeCaption  ;
               SourceExpr=GenPostingTypeCap }

    { 19  ;2   ;Column  ;GenBusPostGroupCaption;
               SourceExpr=GenBusPostingGroupCap }

    { 20  ;2   ;Column  ;GenProdPostGroupCaption;
               SourceExpr=GenProdPostingGroupCap }

    { 21  ;2   ;Column  ;AmountCaption_GenJnlLine;
               SourceExpr="Gen. Journal Line".FIELDCAPTION(Amount) }

    { 22  ;2   ;Column  ;BalAccNoCaption_GenJnlLine;
               SourceExpr="Gen. Journal Line".FIELDCAPTION("Bal. Account No.") }

    { 23  ;2   ;Column  ;BalLCYCaption_GenJnlLine;
               SourceExpr="Gen. Journal Line".FIELDCAPTION("Balance (LCY)") }

    { 7024;2   ;DataItem;                    ;
               DataItemTable=Table81;
               DataItemTableView=SORTING(Journal Template Name,Journal Batch Name,Line No.);
               OnPreDataItem=BEGIN
                               COPYFILTER("Journal Batch Name","Gen. Journal Batch".Name);
                               GenJnlLineFilter := GETFILTERS;

                               GenJnlTemplate.GET("Gen. Journal Batch"."Journal Template Name");
                               IF GenJnlTemplate.Recurring THEN BEGIN
                                 IF GETFILTER("Posting Date") <> '' THEN
                                   AddError(
                                     STRSUBSTNO(
                                       Text000,
                                       FIELDCAPTION("Posting Date")));
                                 SETRANGE("Posting Date",0D,WORKDATE);
                                 IF GETFILTER("Expiration Date") <> '' THEN
                                   AddError(
                                     STRSUBSTNO(
                                       Text000,
                                       FIELDCAPTION("Expiration Date")));
                                 SETFILTER("Expiration Date",'%1 | %2..',0D,WORKDATE);
                               END;

                               IF "Gen. Journal Batch"."No. Series" <> '' THEN BEGIN
                                 NoSeries.GET("Gen. Journal Batch"."No. Series");
                                 LastEntrdDocNo := '';
                                 LastEntrdDate := 0D;
                               END;

                               CurrentCustomerVendors := 0;
                               VATEntryCreated := FALSE;

                               GenJnlLine2.RESET;
                               GenJnlLine2.COPYFILTERS("Gen. Journal Line");

                               GLAccNetChange.DELETEALL;
                               CurrReport.CREATETOTALS("Amount (LCY)","Balance (LCY)");
                             END;

               OnAfterGetRecord=VAR
                                  PaymentTerms@1004 : Record 3;
                                  DimMgt@1001 : Codeunit 408;
                                  TableID@1002 : ARRAY [10] OF Integer;
                                  No@1003 : ARRAY [10] OF Code[20];
                                BEGIN
                                  IF "Currency Code" = '' THEN
                                    "Amount (LCY)" := Amount;

                                  UpdateLineBalance;

                                  AccName := '';
                                  BalAccName := '';

                                  IF NOT EmptyLine THEN BEGIN
                                    MakeRecurringTexts("Gen. Journal Line");

                                    AmountError := FALSE;

                                    IF ("Account No." = '') AND ("Bal. Account No." = '') THEN
                                      AddError(STRSUBSTNO(Text001,FIELDCAPTION("Account No."),FIELDCAPTION("Bal. Account No.")))
                                    ELSE
                                      IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
                                         ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
                                      THEN
                                        TestFixedAssetFields("Gen. Journal Line");
                                    CheckICDocument;
                                    IF "Account No." <> '' THEN
                                      CASE "Account Type" OF
                                        "Account Type"::"G/L Account":
                                          BEGIN
                                            IF ("Gen. Bus. Posting Group" <> '') OR ("Gen. Prod. Posting Group" <> '') OR
                                               ("VAT Bus. Posting Group" <> '') OR ("VAT Prod. Posting Group" <> '')
                                            THEN BEGIN
                                              IF "Gen. Posting Type" = 0 THEN
                                                AddError(STRSUBSTNO(Text002,FIELDCAPTION("Gen. Posting Type")));
                                            END;
                                            IF ("Gen. Posting Type" <> "Gen. Posting Type"::" ") AND
                                               ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
                                            THEN BEGIN
                                              IF "VAT Amount" + "VAT Base Amount" <> Amount THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text003,FIELDCAPTION("VAT Amount"),FIELDCAPTION("VAT Base Amount"),
                                                    FIELDCAPTION(Amount)));
                                              IF "Currency Code" <> '' THEN
                                                IF "VAT Amount (LCY)" + "VAT Base Amount (LCY)" <> "Amount (LCY)" THEN
                                                  AddError(
                                                    STRSUBSTNO(
                                                      Text003,FIELDCAPTION("VAT Amount (LCY)"),
                                                      FIELDCAPTION("VAT Base Amount (LCY)"),FIELDCAPTION("Amount (LCY)")));
                                            END;
                                            TestJobFields("Gen. Journal Line");
                                          END;
                                        "Account Type"::Customer,"Account Type"::Vendor:
                                          BEGIN
                                            IF "Gen. Posting Type" <> 0 THEN
                                              AddError(
                                                STRSUBSTNO(
                                                  Text004,
                                                  FIELDCAPTION("Gen. Posting Type"),FIELDCAPTION("Account Type"),"Account Type"));
                                            IF ("Gen. Bus. Posting Group" <> '') OR ("Gen. Prod. Posting Group" <> '') OR
                                               ("VAT Bus. Posting Group" <> '') OR ("VAT Prod. Posting Group" <> '')
                                            THEN
                                              AddError(
                                                STRSUBSTNO(
                                                  Text005,
                                                  FIELDCAPTION("Gen. Bus. Posting Group"),FIELDCAPTION("Gen. Prod. Posting Group"),
                                                  FIELDCAPTION("VAT Bus. Posting Group"),FIELDCAPTION("VAT Prod. Posting Group"),
                                                  FIELDCAPTION("Account Type"),"Account Type"));

                                            IF "Document Type" <> 0 THEN BEGIN
                                              IF "Account Type" = "Account Type"::Customer THEN
                                                CASE "Document Type" OF
                                                  "Document Type"::"Credit Memo":
                                                    WarningIfPositiveAmt("Gen. Journal Line");
                                                  "Document Type"::Payment:
                                                    IF ("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") AND
                                                       ("Applies-to Doc. No." <> '')
                                                    THEN
                                                      WarningIfNegativeAmt("Gen. Journal Line")
                                                    ELSE
                                                      WarningIfPositiveAmt("Gen. Journal Line");
                                                  "Document Type"::Refund:
                                                    WarningIfNegativeAmt("Gen. Journal Line");
                                                  ELSE
                                                    WarningIfNegativeAmt("Gen. Journal Line");
                                                END
                                              ELSE
                                                CASE "Document Type" OF
                                                  "Document Type"::"Credit Memo":
                                                    WarningIfNegativeAmt("Gen. Journal Line");
                                                  "Document Type"::Payment:
                                                    IF ("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") AND
                                                       ("Applies-to Doc. No." <> '')
                                                    THEN
                                                      WarningIfPositiveAmt("Gen. Journal Line")
                                                    ELSE
                                                      WarningIfNegativeAmt("Gen. Journal Line");
                                                  "Document Type"::Refund:
                                                    WarningIfPositiveAmt("Gen. Journal Line");
                                                  ELSE
                                                    WarningIfPositiveAmt("Gen. Journal Line");
                                                END
                                            END;

                                            IF Amount * "Sales/Purch. (LCY)" < 0 THEN
                                              AddError(
                                                STRSUBSTNO(
                                                  Text008,
                                                  FIELDCAPTION("Sales/Purch. (LCY)"),FIELDCAPTION(Amount)));
                                            IF "Job No." <> '' THEN
                                              AddError(STRSUBSTNO(Text009,FIELDCAPTION("Job No.")));
                                          END;
                                        "Account Type"::"Bank Account":
                                          BEGIN
                                            IF "Gen. Posting Type" <> 0 THEN
                                              AddError(
                                                STRSUBSTNO(
                                                  Text004,
                                                  FIELDCAPTION("Gen. Posting Type"),FIELDCAPTION("Account Type"),"Account Type"));
                                            IF ("Gen. Bus. Posting Group" <> '') OR ("Gen. Prod. Posting Group" <> '') OR
                                               ("VAT Bus. Posting Group" <> '') OR ("VAT Prod. Posting Group" <> '')
                                            THEN
                                              AddError(
                                                STRSUBSTNO(
                                                  Text005,
                                                  FIELDCAPTION("Gen. Bus. Posting Group"),FIELDCAPTION("Gen. Prod. Posting Group"),
                                                  FIELDCAPTION("VAT Bus. Posting Group"),FIELDCAPTION("VAT Prod. Posting Group"),
                                                  FIELDCAPTION("Account Type"),"Account Type"));

                                            IF "Job No." <> '' THEN
                                              AddError(STRSUBSTNO(Text009,FIELDCAPTION("Job No.")));
                                            IF (Amount < 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") THEN
                                              IF NOT "Check Printed" THEN
                                                AddError(STRSUBSTNO(Text010,FIELDCAPTION("Check Printed")));
                                          END;
                                        "Account Type"::"Fixed Asset":
                                          TestFixedAsset("Gen. Journal Line");
                                      END;

                                    IF "Bal. Account No." <> '' THEN
                                      CASE "Bal. Account Type" OF
                                        "Bal. Account Type"::"G/L Account":
                                          BEGIN
                                            IF ("Bal. Gen. Bus. Posting Group" <> '') OR ("Bal. Gen. Prod. Posting Group" <> '') OR
                                               ("Bal. VAT Bus. Posting Group" <> '') OR ("Bal. VAT Prod. Posting Group" <> '')
                                            THEN BEGIN
                                              IF "Bal. Gen. Posting Type" = 0 THEN
                                                AddError(STRSUBSTNO(Text002,FIELDCAPTION("Bal. Gen. Posting Type")));
                                            END;
                                            IF ("Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" ") AND
                                               ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
                                            THEN BEGIN
                                              IF "Bal. VAT Amount" + "Bal. VAT Base Amount" <> -Amount THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text011,FIELDCAPTION("Bal. VAT Amount"),FIELDCAPTION("Bal. VAT Base Amount"),
                                                    FIELDCAPTION(Amount)));
                                              IF "Currency Code" <> '' THEN
                                                IF "Bal. VAT Amount (LCY)" + "Bal. VAT Base Amount (LCY)" <> -"Amount (LCY)" THEN
                                                  AddError(
                                                    STRSUBSTNO(
                                                      Text011,FIELDCAPTION("Bal. VAT Amount (LCY)"),
                                                      FIELDCAPTION("Bal. VAT Base Amount (LCY)"),FIELDCAPTION("Amount (LCY)")));
                                            END;
                                          END;
                                        "Bal. Account Type"::Customer,"Bal. Account Type"::Vendor:
                                          BEGIN
                                            IF "Bal. Gen. Posting Type" <> 0 THEN
                                              AddError(
                                                STRSUBSTNO(
                                                  Text004,
                                                  FIELDCAPTION("Bal. Gen. Posting Type"),FIELDCAPTION("Bal. Account Type"),"Bal. Account Type"));
                                            IF ("Bal. Gen. Bus. Posting Group" <> '') OR ("Bal. Gen. Prod. Posting Group" <> '') OR
                                               ("Bal. VAT Bus. Posting Group" <> '') OR ("Bal. VAT Prod. Posting Group" <> '')
                                            THEN
                                              AddError(
                                                STRSUBSTNO(
                                                  Text005,
                                                  FIELDCAPTION("Bal. Gen. Bus. Posting Group"),FIELDCAPTION("Bal. Gen. Prod. Posting Group"),
                                                  FIELDCAPTION("Bal. VAT Bus. Posting Group"),FIELDCAPTION("Bal. VAT Prod. Posting Group"),
                                                  FIELDCAPTION("Bal. Account Type"),"Bal. Account Type"));

                                            IF "Document Type" <> 0 THEN BEGIN
                                              IF ("Bal. Account Type" = "Bal. Account Type"::Customer) =
                                                 ("Document Type" IN ["Document Type"::Payment,"Document Type"::"Credit Memo"])
                                              THEN
                                                WarningIfNegativeAmt("Gen. Journal Line")
                                              ELSE
                                                WarningIfPositiveAmt("Gen. Journal Line")
                                            END;
                                            IF Amount * "Sales/Purch. (LCY)" > 0 THEN
                                              AddError(
                                                STRSUBSTNO(
                                                  Text012,
                                                  FIELDCAPTION("Sales/Purch. (LCY)"),FIELDCAPTION(Amount)));
                                            IF "Job No." <> '' THEN
                                              AddError(STRSUBSTNO(Text009,FIELDCAPTION("Job No.")));
                                          END;
                                        "Bal. Account Type"::"Bank Account":
                                          BEGIN
                                            IF "Bal. Gen. Posting Type" <> 0 THEN
                                              AddError(
                                                STRSUBSTNO(
                                                  Text004,
                                                  FIELDCAPTION("Bal. Gen. Posting Type"),FIELDCAPTION("Bal. Account Type"),"Bal. Account Type"));
                                            IF ("Bal. Gen. Bus. Posting Group" <> '') OR ("Bal. Gen. Prod. Posting Group" <> '') OR
                                               ("Bal. VAT Bus. Posting Group" <> '') OR ("Bal. VAT Prod. Posting Group" <> '')
                                            THEN
                                              AddError(
                                                STRSUBSTNO(
                                                  Text005,
                                                  FIELDCAPTION("Bal. Gen. Bus. Posting Group"),FIELDCAPTION("Bal. Gen. Prod. Posting Group"),
                                                  FIELDCAPTION("Bal. VAT Bus. Posting Group"),FIELDCAPTION("Bal. VAT Prod. Posting Group"),
                                                  FIELDCAPTION("Bal. Account Type"),"Bal. Account Type"));

                                            IF "Job No." <> '' THEN
                                              AddError(STRSUBSTNO(Text009,FIELDCAPTION("Job No.")));
                                            IF (Amount > 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") THEN
                                              IF NOT "Check Printed" THEN
                                                AddError(STRSUBSTNO(Text010,FIELDCAPTION("Check Printed")));
                                          END;
                                        "Bal. Account Type"::"Fixed Asset":
                                          TestFixedAsset("Gen. Journal Line");
                                      END;

                                    IF ("Account No." <> '') AND
                                       NOT "System-Created Entry" AND
                                       (Amount = 0) AND
                                       NOT GenJnlTemplate.Recurring AND
                                       NOT "Allow Zero-Amount Posting" AND
                                       ("Account Type" <> "Account Type"::"Fixed Asset")
                                    THEN
                                      WarningIfZeroAmt("Gen. Journal Line");

                                    CheckRecurringLine("Gen. Journal Line");
                                    CheckAllocations("Gen. Journal Line");

                                    IF "Posting Date" = 0D THEN
                                      AddError(STRSUBSTNO(Text002,FIELDCAPTION("Posting Date")))
                                    ELSE BEGIN
                                      IF "Posting Date" <> NORMALDATE("Posting Date") THEN
                                        IF ("Account Type" <> "Account Type"::"G/L Account") OR
                                           ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account")
                                        THEN
                                          AddError(
                                            STRSUBSTNO(
                                              Text013,FIELDCAPTION("Posting Date")));

                                      IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
                                        IF USERID <> '' THEN
                                          IF UserSetup.GET(USERID) THEN BEGIN
                                            AllowPostingFrom := UserSetup."Allow Posting From";
                                            AllowPostingTo := UserSetup."Allow Posting To";
                                          END;
                                        IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
                                          AllowPostingFrom := GLSetup."Allow Posting From";
                                          AllowPostingTo := GLSetup."Allow Posting To";
                                        END;
                                        IF AllowPostingTo = 0D THEN
                                          AllowPostingTo := DMY2DATE(31,12,9999);
                                      END;
                                      IF ("Posting Date" < AllowPostingFrom) OR ("Posting Date" > AllowPostingTo) THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text014,FORMAT("Posting Date")));

                                      IF "Gen. Journal Batch"."No. Series" <> '' THEN BEGIN
                                        IF NoSeries."Date Order" AND ("Posting Date" < LastEntrdDate) THEN
                                          AddError(Text015);
                                        LastEntrdDate := "Posting Date";
                                      END;
                                    END;

                                    IF "Document Date" <> 0D THEN
                                      IF ("Document Date" <> NORMALDATE("Document Date")) AND
                                         (("Account Type" <> "Account Type"::"G/L Account") OR
                                          ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account"))
                                      THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text013,FIELDCAPTION("Document Date")));

                                    IF "Document No." = '' THEN
                                      AddError(STRSUBSTNO(Text002,FIELDCAPTION("Document No.")))
                                    ELSE
                                      IF "Gen. Journal Batch"."No. Series" <> '' THEN BEGIN
                                        IF (LastEntrdDocNo <> '') AND
                                           ("Document No." <> LastEntrdDocNo) AND
                                           ("Document No." <> INCSTR(LastEntrdDocNo))
                                        THEN
                                          AddError(Text016);
                                        LastEntrdDocNo := "Document No.";
                                      END;

                                    IF ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Fixed Asset"]) AND
                                       ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Fixed Asset"])
                                    THEN
                                      AddError(
                                        STRSUBSTNO(
                                          Text017,
                                          FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type")));

                                    IF Amount * "Amount (LCY)" < 0 THEN
                                      AddError(
                                        STRSUBSTNO(
                                          Text008,FIELDCAPTION("Amount (LCY)"),FIELDCAPTION(Amount)));

                                    IF ("Account Type" = "Account Type"::"G/L Account") AND
                                       ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")
                                    THEN
                                      IF "Applies-to Doc. No." <> '' THEN
                                        AddError(STRSUBSTNO(Text009,FIELDCAPTION("Applies-to Doc. No.")));

                                    IF (("Account Type" = "Account Type"::"G/L Account") AND
                                        ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) OR
                                       ("Document Type" <> "Document Type"::Invoice)
                                    THEN
                                      IF PaymentTerms.GET("Payment Terms Code") THEN BEGIN
                                        IF ("Document Type" = "Document Type"::"Credit Memo") AND
                                           (NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                                        THEN BEGIN
                                          IF "Pmt. Discount Date" <> 0D THEN
                                            AddError(STRSUBSTNO(Text009,FIELDCAPTION("Pmt. Discount Date")));
                                          IF "Payment Discount %" <> 0 THEN
                                            AddError(STRSUBSTNO(Text018,FIELDCAPTION("Payment Discount %")));
                                        END;
                                      END ELSE BEGIN
                                        IF "Pmt. Discount Date" <> 0D THEN
                                          AddError(STRSUBSTNO(Text009,FIELDCAPTION("Pmt. Discount Date")));
                                        IF "Payment Discount %" <> 0 THEN
                                          AddError(STRSUBSTNO(Text018,FIELDCAPTION("Payment Discount %")));
                                      END;

                                    IF (("Account Type" = "Account Type"::"G/L Account") AND
                                        ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) OR
                                       ("Applies-to Doc. No." <> '')
                                    THEN
                                      IF "Applies-to ID" <> '' THEN
                                        AddError(STRSUBSTNO(Text009,FIELDCAPTION("Applies-to ID")));

                                    IF ("Account Type" <> "Account Type"::"Bank Account") AND
                                       ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account")
                                    THEN
                                      IF GenJnlLine2."Bank Payment Type" > 0 THEN
                                        AddError(STRSUBSTNO(Text009,FIELDCAPTION("Bank Payment Type")));

                                    IF ("Account No." <> '') AND ("Bal. Account No." <> '') THEN BEGIN
                                      PurchPostingType := FALSE;
                                      SalesPostingType := FALSE;
                                    END;
                                    IF "Account No." <> '' THEN
                                      CheckAccountTypes("Account Type",AccName);
                                    IF "Bal. Account No." <> '' THEN BEGIN
                                      CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line","Gen. Journal Line");
                                      CheckAccountTypes("Account Type",BalAccName);
                                      CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line","Gen. Journal Line");
                                    END;

                                    IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
                                      AddError(DimMgt.GetDimCombErr);

                                    TableID[1] := DimMgt.TypeToTableID1("Account Type");
                                    No[1] := "Account No.";
                                    TableID[2] := DimMgt.TypeToTableID1("Bal. Account Type");
                                    No[2] := "Bal. Account No.";
                                    TableID[3] := DATABASE::Job;
                                    No[3] := "Job No.";
                                    TableID[4] := DATABASE::"Salesperson/Purchaser";
                                    No[4] := "Salespers./Purch. Code";
                                    TableID[5] := DATABASE::Campaign;
                                    No[5] := "Campaign No.";
                                    IF NOT DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") THEN
                                      AddError(DimMgt.GetDimValuePostingErr);
                                  END;

                                  CheckBalance;
                                  AmountLCY += "Amount (LCY)";
                                  BalanceLCY += "Balance (LCY)";
                                END;

               ReqFilterFields=Posting Date;
               DataItemLinkReference=Gen. Journal Batch;
               DataItemLink=Journal Template Name=FIELD(Journal Template Name),
                            Journal Batch Name=FIELD(Name) }

    { 24  ;3   ;Column  ;PostingDate_GenJnlLine;
               SourceExpr=FORMAT("Posting Date") }

    { 25  ;3   ;Column  ;DocType_GenJnlLine  ;
               SourceExpr="Document Type" }

    { 26  ;3   ;Column  ;DocNo_GenJnlLine    ;
               SourceExpr="Document No." }

    { 5   ;3   ;Column  ;ExtDocNo_GenJnlLine ;
               SourceExpr="External Document No." }

    { 27  ;3   ;Column  ;AccountType_GenJnlLine;
               SourceExpr="Account Type" }

    { 28  ;3   ;Column  ;AccountNo_GenJnlLine;
               SourceExpr="Account No." }

    { 29  ;3   ;Column  ;AccName             ;
               SourceExpr=AccName }

    { 30  ;3   ;Column  ;Description_GenJnlLine;
               SourceExpr=Description }

    { 31  ;3   ;Column  ;GenPostType_GenJnlLine;
               SourceExpr="Gen. Posting Type" }

    { 32  ;3   ;Column  ;GenBusPosGroup_GenJnlLine;
               SourceExpr="Gen. Bus. Posting Group" }

    { 33  ;3   ;Column  ;GenProdPostGroup_GenJnlLine;
               SourceExpr="Gen. Prod. Posting Group" }

    { 34  ;3   ;Column  ;Amount_GenJnlLine   ;
               SourceExpr=Amount }

    { 35  ;3   ;Column  ;CurrencyCode_GenJnlLine;
               SourceExpr="Currency Code" }

    { 36  ;3   ;Column  ;BalAccNo_GenJnlLine ;
               SourceExpr="Bal. Account No." }

    { 37  ;3   ;Column  ;BalanceLCY_GenJnlLine;
               SourceExpr="Balance (LCY)" }

    { 58  ;3   ;Column  ;AmountLCY           ;
               SourceExpr=AmountLCY }

    { 61  ;3   ;Column  ;BalanceLCY          ;
               SourceExpr=BalanceLCY }

    { 39  ;3   ;Column  ;AmountLCY_GenJnlLine;
               SourceExpr="Amount (LCY)" }

    { 2766;3   ;Column  ;JnlTmplName_GenJnlLine;
               SourceExpr="Journal Template Name" }

    { 4759;3   ;Column  ;JnlBatchName_GenJnlLine;
               SourceExpr="Journal Batch Name" }

    { 8309;3   ;Column  ;LineNo_GenJnlLine   ;
               SourceExpr="Line No." }

    { 38  ;3   ;Column  ;TotalLCYCaption     ;
               SourceExpr=AmountLCYCap }

    { 9775;3   ;DataItem;DimensionLoop       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowDim THEN
                                 CurrReport.BREAK;
                               DimSetEntry.RESET;
                               DimSetEntry.SETRANGE("Dimension Set ID","Gen. Journal Line"."Dimension Set ID")
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry.FINDSET THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF NOT Continue THEN
                                      CurrReport.BREAK;

                                  DimText := GetDimensionText(DimSetEntry);
                                END;
                                 }

    { 59  ;4   ;Column  ;DimText             ;
               SourceExpr=DimText }

    { 56  ;4   ;Column  ;Number_DimensionLoop;
               SourceExpr=Number }

    { 57  ;4   ;Column  ;DimensionsCaption   ;
               SourceExpr=DimensionsCap }

    { 100 ;3   ;DataItem;                    ;
               DataItemTable=Table221;
               DataItemTableView=SORTING(Journal Template Name,Journal Batch Name,Journal Line No.,Line No.);
               DataItemLink=Journal Template Name=FIELD(Journal Template Name),
                            Journal Batch Name=FIELD(Journal Batch Name),
                            Journal Line No.=FIELD(Line No.) }

    { 101 ;4   ;Column  ;AccountNo_GenJnlAllocation;
               SourceExpr="Account No." }

    { 102 ;4   ;Column  ;AccountName_GenJnlAllocation;
               SourceExpr="Account Name" }

    { 103 ;4   ;Column  ;AllocationQuantity_GenJnlAllocation;
               SourceExpr="Allocation Quantity" }

    { 104 ;4   ;Column  ;AllocationPct_GenJnlAllocation;
               SourceExpr="Allocation %" }

    { 105 ;4   ;Column  ;Amount_GenJnlAllocation;
               SourceExpr=Amount }

    { 106 ;4   ;Column  ;JournalLineNo_GenJnlAllocation;
               SourceExpr="Journal Line No." }

    { 107 ;4   ;Column  ;LineNo_GenJnlAllocation;
               SourceExpr="Line No." }

    { 108 ;4   ;Column  ;JournalBatchName_GenJnlAllocation;
               SourceExpr="Journal Batch Name" }

    { 109 ;4   ;Column  ;AccountNoCaption_GenJnlAllocation;
               SourceExpr=FIELDCAPTION("Account No.") }

    { 110 ;4   ;Column  ;AccountNameCaption_GenJnlAllocation;
               SourceExpr=FIELDCAPTION("Account Name") }

    { 111 ;4   ;Column  ;AllocationQuantityCaption_GenJnlAllocation;
               SourceExpr=FIELDCAPTION("Allocation Quantity") }

    { 112 ;4   ;Column  ;AllocationPctCaption_GenJnlAllocation;
               SourceExpr=FIELDCAPTION("Allocation %") }

    { 113 ;4   ;Column  ;AmountCaption_GenJnlAllocation;
               SourceExpr=FIELDCAPTION(Amount) }

    { 2   ;4   ;Column  ;Recurring_GenJnlTemplate;
               SourceExpr=GenJnlTemplate.Recurring }

    { 114 ;4   ;DataItem;DimensionLoopAllocations;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowDim THEN
                                 CurrReport.BREAK;
                               DimSetEntry.RESET;
                               DimSetEntry.SETRANGE("Dimension Set ID","Gen. Jnl. Allocation"."Dimension Set ID")
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry.FINDFIRST THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF NOT Continue THEN
                                      CurrReport.BREAK;

                                  AllocationDimText := GetDimensionText(DimSetEntry);
                                END;
                                 }

    { 115 ;5   ;Column  ;AllocationDimText   ;
               SourceExpr=AllocationDimText }

    { 116 ;5   ;Column  ;Number_DimensionLoopAllocations;
               SourceExpr=Number }

    { 117 ;5   ;Column  ;DimensionAllocationsCaption;
               SourceExpr=DimensionAllocationsCap }

    { 1162;3   ;DataItem;ErrorLoop           ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SETRANGE(Number,1,ErrorCounter);
                             END;

               OnPostDataItem=BEGIN
                                ErrorCounter := 0;
                              END;
                               }

    { 43  ;4   ;Column  ;ErrorTextNumber     ;
               SourceExpr=ErrorText[Number] }

    { 42  ;4   ;Column  ;WarningCaption      ;
               SourceExpr=WarningCap }

    { 5127;2   ;DataItem;ReconcileLoop       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SETRANGE(Number,1,GLAccNetChange.COUNT);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN
                                    GLAccNetChange.FIND('-')
                                  ELSE
                                    GLAccNetChange.NEXT;
                                END;

               OnPostDataItem=BEGIN
                                GLAccNetChange.DELETEALL;
                              END;
                               }

    { 49  ;3   ;Column  ;GLAccNetChangeNo    ;
               SourceExpr=GLAccNetChange."No." }

    { 50  ;3   ;Column  ;GLAccNetChangeName  ;
               SourceExpr=GLAccNetChange.Name }

    { 51  ;3   ;Column  ;GLAccNetChangeNetChangeJnl;
               SourceExpr=GLAccNetChange."Net Change in Jnl." }

    { 52  ;3   ;Column  ;GLAccNetChangeBalafterPost;
               SourceExpr=GLAccNetChange."Balance after Posting" }

    { 44  ;3   ;Column  ;ReconciliationCaption;
               SourceExpr=ReconciliationCap }

    { 45  ;3   ;Column  ;NoCaption           ;
               SourceExpr=NoCap }

    { 46  ;3   ;Column  ;NameCaption         ;
               SourceExpr=NameCap }

    { 47  ;3   ;Column  ;NetChangeinJnlCaption;
               SourceExpr=NetChangeinJnlCap }

    { 48  ;3   ;Column  ;BalafterPostingCaption;
               SourceExpr=BalafterPostingCap }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  Name=ShowDim;
                  CaptionML=[DAN=Vis dimensioner;
                             ENU=Show Dimensions];
                  ToolTipML=[DAN=Angiver, om dimensionsoplysninger for kladdelinjerne skal medtages i rapporten.;
                             ENU=Specifies if you want dimensions information for the journal lines to be included in the report.];
                  ApplicationArea=#Dimensions;
                  SourceExpr=ShowDim }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Der kan ikke s�ttes filter p� %1, n�r man bogf�rer gentagelseskladder.;ENU=%1 cannot be filtered when you post recurring journals.';
      Text001@1001 : TextConst 'DAN=%1 og %2 skal indtastes.;ENU=%1 or %2 must be specified.';
      Text002@1002 : TextConst 'DAN=%1 skal indtastes.;ENU=%1 must be specified.';
      Text003@1003 : TextConst 'DAN=%1 + %2 skal v�re %3.;ENU=%1 + %2 must be %3.';
      Text004@1004 : TextConst 'DAN=%1 skal v�re " " n�r %2 er %3.;ENU=%1 must be " " when %2 is %3.';
      Text005@1005 : TextConst 'DAN=%1, %2, %3 eller %4 m� ikke v�ret angivet, n�r %5 er %6.;ENU=%1, %2, %3 or %4 must not be completed when %5 is %6.';
      Text006@1006 : TextConst 'DAN=%1 skal v�re negativ.;ENU=%1 must be negative.';
      Text007@1007 : TextConst 'DAN=%1 skal v�re positiv.;ENU=%1 must be positive.';
      Text008@1008 : TextConst 'DAN=%1 skal have samme fortegn som %2.;ENU=%1 must have the same sign as %2.';
      Text009@1009 : TextConst 'DAN=%1 kan ikke indtastes.;ENU=%1 cannot be specified.';
      Text010@1010 : TextConst 'DAN=%1 skal v�re Ja.;ENU=%1 must be Yes.';
      Text011@1011 : TextConst 'DAN=%1 + %2 skal v�re -%3.;ENU=%1 + %2 must be -%3.';
      Text012@1012 : TextConst 'DAN=%1 skal have et andet fortegn end %2.;ENU=%1 must have a different sign than %2.';
      Text013@1013 : TextConst 'DAN=%1 m� kun v�re en ultimodato for finansposter.;ENU=%1 must only be a closing date for G/L entries.';
      Text014@1014 : TextConst 'DAN=%1 er ikke inden for den tilladte bogf�ringsperiode.;ENU=%1 is not within your allowed range of posting dates.';
      Text015@1015 : TextConst 'DAN=Linjerne er ikke sorteret efter bogf�ringsdato, fordi de ikke blev indtastet i den r�kkef�lge.;ENU=The lines are not listed according to Posting Date because they were not entered in that order.';
      Text016@1016 : TextConst 'DAN=Der er et hul i nummerserien.;ENU=There is a gap in the number series.';
      Text017@1017 : TextConst 'DAN=%1 eller %2 skal v�re Finanskonto eller Bankkonto.;ENU=%1 or %2 must be G/L Account or Bank Account.';
      Text018@1018 : TextConst 'DAN=%1 skal v�re 0.;ENU=%1 must be 0.';
      Text019@1019 : TextConst 'DAN=%1 m� ikke indtastes, n�r man bruger gentagelseskladder.;ENU=%1 cannot be specified when using recurring journals.';
      Text020@1020 : TextConst 'DAN="%1 m� ikke v�re %2, n�r %3 = %4.";ENU="%1 must not be %2 when %3 = %4."';
      Text021@1021 : TextConst 'DAN=Fordelinger kan kun bruges i forbindelse med gentagelseskladder.;ENU=Allocations can only be used with recurring journals.';
      Text022@1022 : TextConst 'DAN=Angiv %1 i fordelingslinjerne %2.;ENU=Specify %1 in the %2 allocation lines.';
      Text023@1023 : TextConst 'DAN=<Month Text>;ENU=<Month Text>';
      Text024@1024 : TextConst '@@@=%1 - document type, %2 - document number, %3 - posting date;DAN=%1 %2 med bogf�ringsdatoen %3 skal v�re adskilt med en tom linje.;ENU=%1 %2 posted on %3, must be separated by an empty line.';
      Text025@1025 : TextConst 'DAN=%1 %2 stemmer ikke med %3.;ENU=%1 %2 is out of balance by %3.';
      Text026@1026 : TextConst 'DAN=Tilbagef�rselslinjerne i %1 %2 stemmer ikke med %3.;ENU=The reversing entries for %1 %2 are out of balance by %3.';
      Text027@1027 : TextConst 'DAN=Linjerne stemmer ikke med %2 pr. %1.;ENU=As of %1, the lines are out of balance by %2.';
      Text028@1028 : TextConst 'DAN=Tilbagef�ringsposterne stemmer ikke med %2 pr. %1.;ENU=As of %1, the reversing entries are out of balance by %2.';
      Text029@1029 : TextConst 'DAN=Saldoen p� linjerne stemmer ikke med %1.;ENU=The total of the lines is out of balance by %1.';
      Text030@1030 : TextConst 'DAN=I alt stemmer tilbagef�rselslinjerne ikke med %1.;ENU=The total of the reversing entries is out of balance by %1.';
      Text031@1031 : TextConst 'DAN=%1 %2 findes ikke.;ENU=%1 %2 does not exist.';
      Text032@1032 : TextConst 'DAN=%1 skal v�re %2 for %3 %4.;ENU=%1 must be %2 for %3 %4.';
      Text036@1033 : TextConst 'DAN=%1 %2 %3 findes ikke.;ENU=%1 %2 %3 does not exist.';
      Text037@1034 : TextConst 'DAN=%1 skal v�re %2.;ENU=%1 must be %2.';
      Text038@1035 : TextConst 'DAN=Valutaen %1 blev ikke fundet. Kontroll�r valutatabellen.;ENU=The currency %1 cannot be found. Check the currency table.';
      Text039@1036 : TextConst 'DAN=Salg %1 %2 findes allerede.;ENU=Sales %1 %2 already exists.';
      Text040@1037 : TextConst 'DAN=K�b %1 %2 findes allerede.;ENU=Purchase %1 %2 already exists.';
      Text041@1038 : TextConst 'DAN=%1 skal indtastes.;ENU=%1 must be entered.';
      Text042@1039 : TextConst 'DAN=%1 m� ikke udfyldes, n�r %2 er forskellig fra %3 og %4.;ENU=%1 must not be filled when %2 is different in %3 and %4.';
      Text043@1040 : TextConst 'DAN="%1 %2 m� ikke have %3 = %4.";ENU="%1 %2 must not have %3 = %4."';
      Text044@1041 : TextConst 'DAN=%1 m� ikke indtastes p� kladdelinjer i anl�gsaktiver.;ENU=%1 must not be specified in fixed asset journal lines.';
      Text045@1042 : TextConst 'DAN=%1 skal indtastes p� kladdelinjer i anl�gsaktiver.;ENU=%1 must be specified in fixed asset journal lines.';
      Text046@1043 : TextConst 'DAN=%1 skal v�re forskellig fra %2.;ENU=%1 must be different than %2.';
      Text047@1044 : TextConst 'DAN=%1 og %2 m� ikke begge v�re %3.;ENU=%1 and %2 must not both be %3.';
      Text049@1046 : TextConst 'DAN="%1 m� ikke indtastes n�r %2 = %3.";ENU="%1 must not be specified when %2 = %3."';
      Text050@1047 : TextConst 'DAN="m� ikke indtastes, n�r %1 = %2.";ENU="must not be specified together with %1 = %2."';
      Text051@1048 : TextConst 'DAN=%1 skal v�re lig med %2.;ENU=%1 must be identical to %2.';
      Text052@1049 : TextConst 'DAN=%1 m� ikke v�re en ultimodato.;ENU=%1 cannot be a closing date.';
      Text053@1050 : TextConst 'DAN=%1 er ikke inden for den tilladte bogf�ringsperiode.;ENU=%1 is not within your range of allowed posting dates.';
      Text054@1051 : TextConst 'DAN=Forsikringsintegration er ikke aktiveret for %1 %2.;ENU=Insurance integration is not activated for %1 %2.';
      Text055@1052 : TextConst 'DAN=m� ikke indtastes, n�r %1 er udfyldt.;ENU=must not be specified when %1 is specified.';
      Text056@1053 : TextConst 'DAN=N�r finansintegration ikke er aktiv, m� %1 ikke bogf�res i finanskladden.;ENU=When G/L integration is not activated, %1 must not be posted in the general journal.';
      Text057@1054 : TextConst 'DAN=N�r finansintegration ikke er aktiv, m� %1 ikke indtastes i finanskladden.;ENU=When G/L integration is not activated, %1 must not be specified in the general journal.';
      Text058@1055 : TextConst 'DAN=%1 m� ikke indtastes.;ENU=%1 must not be specified.';
      Text059@1056 : TextConst 'DAN=Kombinationen Kontotype Debitor og Bogf�ringstype K�b er ikke tilladt.;ENU=The combination of Customer and Gen. Posting Type Purchase is not allowed.';
      Text060@1057 : TextConst 'DAN=Kombinationen Kontotype Kreditor og Bogf�ringstype Salg er ikke tilladt.;ENU=The combination of Vendor and Gen. Posting Type Sales is not allowed.';
      Text061@1058 : TextConst 'DAN=Gentagelsesmetoderne Balance og Omvendt balance kan kun anvendes i forbindelse med fordelinger.;ENU=The Balance and Reversing Balance recurring methods can be used only with Allocations.';
      Text062@1059 : TextConst 'DAN=%1 m� ikke v�re 0.;ENU=%1 must not be 0.';
      GLSetup@1060 : Record 98;
      SalesSetup@1061 : Record 311;
      PurchSetup@1062 : Record 312;
      UserSetup@1063 : Record 91;
      AccountingPeriod@1064 : Record 50;
      GLAcc@1065 : Record 15;
      Currency@1066 : Record 4;
      Cust@1067 : Record 18;
      Vend@1068 : Record 23;
      BankAccPostingGr@1069 : Record 277;
      BankAcc@1070 : Record 270;
      GenJnlTemplate@1071 : Record 80;
      GenJnlLine2@1072 : Record 81;
      TempGenJnlLine@1125 : TEMPORARY Record 81;
      GenJnlAlloc@1073 : Record 221;
      OldCustLedgEntry@1074 : Record 21;
      OldVendLedgEntry@1075 : Record 25;
      VATPostingSetup@1076 : Record 325;
      NoSeries@1077 : Record 308;
      FA@1078 : Record 5600;
      ICPartner@1132 : Record 413;
      DeprBook@1079 : Record 5611;
      FADeprBook@1080 : Record 5612;
      FASetup@1081 : Record 5603;
      GLAccNetChange@1082 : TEMPORARY Record 269;
      DimSetEntry@1083 : Record 480;
      Employee@1945 : Record 5200;
      GenJnlLineFilter@1085 : Text;
      AllowPostingFrom@1086 : Date;
      AllowPostingTo@1087 : Date;
      AllowFAPostingFrom@1088 : Date;
      AllowFAPostingTo@1089 : Date;
      LastDate@1090 : Date;
      LastDocType@1091 : 'Document,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder';
      LastDocNo@1092 : Code[20];
      LastEntrdDocNo@1093 : Code[20];
      LastEntrdDate@1094 : Date;
      BalanceLCY@1138 : Decimal;
      AmountLCY@1131 : Decimal;
      DocBalance@1095 : Decimal;
      DocBalanceReverse@1096 : Decimal;
      DateBalance@1097 : Decimal;
      DateBalanceReverse@1098 : Decimal;
      TotalBalance@1099 : Decimal;
      TotalBalanceReverse@1100 : Decimal;
      AccName@1101 : Text[50];
      LastLineNo@1102 : Integer;
      Day@1104 : Integer;
      Week@1105 : Integer;
      Month@1106 : Integer;
      MonthText@1107 : Text[30];
      AmountError@1108 : Boolean;
      ErrorCounter@1109 : Integer;
      ErrorText@1110 : ARRAY [50] OF Text[250];
      TempErrorText@1111 : Text[250];
      BalAccName@1112 : Text[50];
      CurrentCustomerVendors@1113 : Integer;
      VATEntryCreated@1114 : Boolean;
      CustPosting@1115 : Boolean;
      VendPosting@1116 : Boolean;
      SalesPostingType@1117 : Boolean;
      PurchPostingType@1118 : Boolean;
      DimText@1119 : Text[75];
      AllocationDimText@1140 : Text[75];
      ShowDim@1121 : Boolean;
      Continue@1122 : Boolean;
      Text063@1123 : TextConst 'DAN=Dokument,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion;ENU=Document,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
      Text064@1124 : TextConst 'DAN=%1 %2 bruges allerede i linje %3 (%4 %5).;ENU=%1 %2 is already used in line %3 (%4 %5).';
      Text065@1126 : TextConst 'DAN=%1 m� ikke v�re sp�rret med typen %2, n�r %3 er %4.;ENU=%1 must not be blocked with type %2 when %3 is %4.';
      CurrentICPartner@1128 : Code[20];
      Text066@1129 : TextConst 'DAN=Du kan ikke angive finanskonto eller bankkonto i b�de %1 og %2.;ENU=You cannot enter G/L Account or Bank Account in both %1 and %2.';
      Text067@1130 : TextConst 'DAN=%1 %2 er knyttet til %3 %4.;ENU=%1 %2 is linked to %3 %4.';
      Text069@1134 : TextConst 'DAN=%1 m� ikke angives, n�r %2 er %3.;ENU=%1 must not be specified when %2 is %3.';
      Text070@1135 : TextConst 'DAN=%1 m� ikke angives, n�r dokumentet ikke er en intercompany-transaktion.;ENU=%1 must not be specified when the document is not an intercompany transaction.';
      Text071@1137 : TextConst 'DAN=%1 %2 findes ikke.;ENU=%1 %2 does not exist.';
      Text072@1136 : TextConst 'DAN=%1 m� ikke v�re %2 for %3 %4.;ENU=%1 must not be %2 for %3 %4.';
      Text073@1102601000 : TextConst 'DAN=%1 %2 findes allerede.;ENU=%1 %2 already exists.';
      GeneralJnlTestCap@4487 : TextConst 'DAN=Finanskladde - kontrol;ENU=General Journal - Test';
      PageNoCap@8565 : TextConst 'DAN=Side;ENU=Page';
      JnlBatchNameCap@3422 : TextConst 'DAN=Kladdenavn;ENU=Journal Batch';
      PostingDateCap@7627 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      DocumentTypeCap@7853 : TextConst 'DAN=Bilagstype;ENU=Document Type';
      AccountTypeCap@5964 : TextConst 'DAN=Kontotype;ENU=Account Type';
      AccNameCap@8342 : TextConst 'DAN=Navn;ENU=Name';
      GenPostingTypeCap@6614 : TextConst 'DAN=Bogf�ringstype;ENU=Gen. Posting Type';
      GenBusPostingGroupCap@9852 : TextConst 'DAN=Virksomhedsbogf�ringsgruppe;ENU=Gen. Bus. Posting Group';
      GenProdPostingGroupCap@8547 : TextConst 'DAN=Produktbogf�ringsgruppe;ENU=Gen. Prod. Posting Group';
      AmountLCYCap@7335 : TextConst 'DAN=I alt (RV);ENU=Total (LCY)';
      DimensionsCap@2995 : TextConst 'DAN=Dimensioner;ENU=Dimensions';
      WarningCap@5070 : TextConst 'DAN=Advarsel!;ENU=Warning!';
      ReconciliationCap@4137 : TextConst 'DAN=Afstemning;ENU=Reconciliation';
      NoCap@4841 : TextConst 'DAN=Nummer;ENU=No.';
      NameCap@3866 : TextConst 'DAN=Navn;ENU=Name';
      NetChangeinJnlCap@9374 : TextConst 'DAN=Bev�gelse i kladde;ENU=Net Change in Jnl.';
      BalafterPostingCap@5926 : TextConst 'DAN=Saldo efter bogf�ring;ENU=Balance after Posting';
      DimensionAllocationsCap@4488 : TextConst 'DAN=Tildeling af dimensioner;ENU=Allocation Dimensions';

    LOCAL PROCEDURE CheckRecurringLine@5(GenJnlLine2@1000 : Record 81);
    BEGIN
      WITH GenJnlLine2 DO
        IF GenJnlTemplate.Recurring THEN BEGIN
          IF "Recurring Method" = 0 THEN
            AddError(STRSUBSTNO(Text002,FIELDCAPTION("Recurring Method")));
          IF FORMAT("Recurring Frequency") = '' THEN
            AddError(STRSUBSTNO(Text002,FIELDCAPTION("Recurring Frequency")));
          IF "Bal. Account No." <> '' THEN
            AddError(
              STRSUBSTNO(
                Text019,
                FIELDCAPTION("Bal. Account No.")));
          CASE "Recurring Method" OF
            "Recurring Method"::"V  Variable","Recurring Method"::"RV Reversing Variable",
            "Recurring Method"::"F  Fixed","Recurring Method"::"RF Reversing Fixed":
              WarningIfZeroAmt("Gen. Journal Line");
            "Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance":
              WarningIfNonZeroAmt("Gen. Journal Line");
          END;
          IF "Recurring Method" > "Recurring Method"::"V  Variable" THEN BEGIN
            IF "Account Type" = "Account Type"::"Fixed Asset" THEN
              AddError(
                STRSUBSTNO(
                  Text020,
                  FIELDCAPTION("Recurring Method"),"Recurring Method",
                  FIELDCAPTION("Account Type"),"Account Type"));
            IF "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" THEN
              AddError(
                STRSUBSTNO(
                  Text020,
                  FIELDCAPTION("Recurring Method"),"Recurring Method",
                  FIELDCAPTION("Bal. Account Type"),"Bal. Account Type"));
          END;
        END ELSE BEGIN
          IF "Recurring Method" <> 0 THEN
            AddError(STRSUBSTNO(Text009,FIELDCAPTION("Recurring Method")));
          IF FORMAT("Recurring Frequency") <> '' THEN
            AddError(STRSUBSTNO(Text009,FIELDCAPTION("Recurring Frequency")));
        END;
    END;

    LOCAL PROCEDURE CheckAllocations@6(GenJnlLine2@1000 : Record 81);
    BEGIN
      WITH GenJnlLine2 DO BEGIN
        IF "Recurring Method" IN
           ["Recurring Method"::"B  Balance",
            "Recurring Method"::"RB Reversing Balance"]
        THEN BEGIN
          GenJnlAlloc.RESET;
          GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
          GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
          GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
          IF NOT GenJnlAlloc.FINDFIRST THEN
            AddError(Text061);
        END;

        GenJnlAlloc.RESET;
        GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
        GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
        GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
        GenJnlAlloc.SETFILTER(Amount,'<>0');
        IF GenJnlAlloc.FINDFIRST THEN
          IF NOT GenJnlTemplate.Recurring THEN
            AddError(Text021)
          ELSE BEGIN
            GenJnlAlloc.SETRANGE("Account No.",'');
            IF GenJnlAlloc.FINDFIRST THEN
              AddError(
                STRSUBSTNO(
                  Text022,
                  GenJnlAlloc.FIELDCAPTION("Account No."),GenJnlAlloc.COUNT));
          END;
      END;
    END;

    LOCAL PROCEDURE MakeRecurringTexts@1(VAR GenJnlLine2@1000 : Record 81);
    BEGIN
      WITH GenJnlLine2 DO
        IF ("Posting Date" <> 0D) AND ("Account No." <> '') AND ("Recurring Method" <> 0) THEN BEGIN
          Day := DATE2DMY("Posting Date",1);
          Week := DATE2DWY("Posting Date",2);
          Month := DATE2DMY("Posting Date",2);
          MonthText := FORMAT("Posting Date",0,Text023);
          AccountingPeriod.SETRANGE("Starting Date",0D,"Posting Date");
          IF NOT AccountingPeriod.FINDLAST THEN
            AccountingPeriod.Name := '';
          "Document No." :=
            DELCHR(
              PADSTR(
                STRSUBSTNO("Document No.",Day,Week,Month,MonthText,AccountingPeriod.Name),
                MAXSTRLEN("Document No.")),
              '>');
          Description :=
            DELCHR(
              PADSTR(
                STRSUBSTNO(Description,Day,Week,Month,MonthText,AccountingPeriod.Name),
                MAXSTRLEN(Description)),
              '>');
        END;
    END;

    LOCAL PROCEDURE CheckBalance@7();
    VAR
      GenJnlLine@1000 : Record 81;
      NextGenJnlLine@1001 : Record 81;
    BEGIN
      GenJnlLine := "Gen. Journal Line";
      LastLineNo := "Gen. Journal Line"."Line No.";
      NextGenJnlLine := "Gen. Journal Line";
      IF NextGenJnlLine.NEXT = 0 THEN;
      MakeRecurringTexts(NextGenJnlLine);
      WITH GenJnlLine DO
        IF NOT EmptyLine THEN BEGIN
          DocBalance := DocBalance + "Balance (LCY)";
          DateBalance := DateBalance + "Balance (LCY)";
          TotalBalance := TotalBalance + "Balance (LCY)";
          IF "Recurring Method" >= "Recurring Method"::"RF Reversing Fixed" THEN BEGIN
            DocBalanceReverse := DocBalanceReverse + "Balance (LCY)";
            DateBalanceReverse := DateBalanceReverse + "Balance (LCY)";
            TotalBalanceReverse := TotalBalanceReverse + "Balance (LCY)";
          END;
          LastDocType := "Document Type";
          LastDocNo := "Document No.";
          LastDate := "Posting Date";
          IF TotalBalance = 0 THEN BEGIN
            CurrentCustomerVendors := 0;
            VATEntryCreated := FALSE;
          END;
          IF GenJnlTemplate."Force Doc. Balance" THEN BEGIN
            VATEntryCreated :=
              VATEntryCreated OR
              (("Account Type" = "Account Type"::"G/L Account") AND ("Account No." <> '') AND
               ("Gen. Posting Type" IN ["Gen. Posting Type"::Purchase,"Gen. Posting Type"::Sale])) OR
              (("Bal. Account Type" = "Bal. Account Type"::"G/L Account") AND ("Bal. Account No." <> '') AND
               ("Bal. Gen. Posting Type" IN ["Bal. Gen. Posting Type"::Purchase,"Bal. Gen. Posting Type"::Sale]));
            IF (("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) AND
                ("Account No." <> '')) OR
               (("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]) AND
                ("Bal. Account No." <> ''))
            THEN
              CurrentCustomerVendors := CurrentCustomerVendors + 1;
            IF (CurrentCustomerVendors > 1) AND VATEntryCreated THEN
              AddError(
                STRSUBSTNO(
                  Text024,
                  "Document Type","Document No.","Posting Date"));
          END;
        END;

      WITH NextGenJnlLine DO BEGIN
        IF (LastDate <> 0D) AND (LastDocNo <> '') AND
           (("Posting Date" <> LastDate) OR
            ("Document Type" <> LastDocType) OR
            ("Document No." <> LastDocNo) OR
            ("Line No." = LastLineNo))
        THEN BEGIN
          IF GenJnlTemplate."Force Doc. Balance" THEN BEGIN
            CASE TRUE OF
              DocBalance <> 0:
                AddError(
                  STRSUBSTNO(
                    Text025,
                    SELECTSTR(LastDocType + 1,Text063),LastDocNo,DocBalance));
              DocBalanceReverse <> 0:
                AddError(
                  STRSUBSTNO(
                    Text026,
                    SELECTSTR(LastDocType + 1,Text063),LastDocNo,DocBalanceReverse));
            END;
            DocBalance := 0;
            DocBalanceReverse := 0;
          END;
          IF ("Posting Date" <> LastDate) OR
             ("Document Type" <> LastDocType) OR ("Document No." <> LastDocNo)
          THEN BEGIN
            CurrentCustomerVendors := 0;
            VATEntryCreated := FALSE;
            CustPosting := FALSE;
            VendPosting := FALSE;
            SalesPostingType := FALSE;
            PurchPostingType := FALSE;
          END;
        END;

        IF (LastDate <> 0D) AND (("Posting Date" <> LastDate) OR ("Line No." = LastLineNo)) THEN BEGIN
          CASE TRUE OF
            DateBalance <> 0:
              AddError(
                STRSUBSTNO(
                  Text027,
                  LastDate,DateBalance));
            DateBalanceReverse <> 0:
              AddError(
                STRSUBSTNO(
                  Text028,
                  LastDate,DateBalanceReverse));
          END;
          DocBalance := 0;
          DocBalanceReverse := 0;
          DateBalance := 0;
          DateBalanceReverse := 0;
        END;

        IF "Line No." = LastLineNo THEN BEGIN
          CASE TRUE OF
            TotalBalance <> 0:
              AddError(
                STRSUBSTNO(
                  Text029,
                  TotalBalance));
            TotalBalanceReverse <> 0:
              AddError(
                STRSUBSTNO(
                  Text030,
                  TotalBalanceReverse));
          END;
          DocBalance := 0;
          DocBalanceReverse := 0;
          DateBalance := 0;
          DateBalanceReverse := 0;
          TotalBalance := 0;
          TotalBalanceReverse := 0;
          LastDate := 0D;
          LastDocType := 0;
          LastDocNo := '';
        END;
      END;
    END;

    LOCAL PROCEDURE AddError@2(Text@1000 : Text[250]);
    BEGIN
      ErrorCounter := ErrorCounter + 1;
      ErrorText[ErrorCounter] := Text;
    END;

    LOCAL PROCEDURE ReconcileGLAccNo@8(GLAccNo@1000 : Code[20];ReconcileAmount@1001 : Decimal);
    BEGIN
      IF NOT GLAccNetChange.GET(GLAccNo) THEN BEGIN
        GLAcc.GET(GLAccNo);
        GLAcc.CALCFIELDS("Balance at Date");
        GLAccNetChange.INIT;
        GLAccNetChange."No." := GLAcc."No.";
        GLAccNetChange.Name := GLAcc.Name;
        GLAccNetChange."Balance after Posting" := GLAcc."Balance at Date";
        GLAccNetChange.INSERT;
      END;
      GLAccNetChange."Net Change in Jnl." := GLAccNetChange."Net Change in Jnl." + ReconcileAmount;
      GLAccNetChange."Balance after Posting" := GLAccNetChange."Balance after Posting" + ReconcileAmount;
      GLAccNetChange.MODIFY;
    END;

    LOCAL PROCEDURE CheckGLAcc@4(VAR GenJnlLine@1000 : Record 81;VAR AccName@1001 : Text[50]);
    BEGIN
      WITH GenJnlLine DO
        IF NOT GLAcc.GET("Account No.") THEN
          AddError(
            STRSUBSTNO(
              Text031,
              GLAcc.TABLECAPTION,"Account No."))
        ELSE BEGIN
          AccName := GLAcc.Name;

          IF GLAcc.Blocked THEN
            AddError(
              STRSUBSTNO(
                Text032,
                GLAcc.FIELDCAPTION(Blocked),FALSE,GLAcc.TABLECAPTION,"Account No."));
          IF GLAcc."Account Type" <> GLAcc."Account Type"::Posting THEN BEGIN
            GLAcc."Account Type" := GLAcc."Account Type"::Posting;
            AddError(
              STRSUBSTNO(
                Text032,
                GLAcc.FIELDCAPTION("Account Type"),GLAcc."Account Type",GLAcc.TABLECAPTION,"Account No."));
          END;
          IF NOT "System-Created Entry" THEN
            IF "Posting Date" = NORMALDATE("Posting Date") THEN
              IF NOT GLAcc."Direct Posting" THEN
                AddError(
                  STRSUBSTNO(
                    Text032,
                    GLAcc.FIELDCAPTION("Direct Posting"),TRUE,GLAcc.TABLECAPTION,"Account No."));

          IF "Gen. Posting Type" > 0 THEN BEGIN
            CASE "Gen. Posting Type" OF
              "Gen. Posting Type"::Sale:
                SalesPostingType := TRUE;
              "Gen. Posting Type"::Purchase:
                PurchPostingType := TRUE;
            END;
            TestPostingType;

            IF NOT VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group") THEN
              AddError(
                STRSUBSTNO(
                  Text036,
                  VATPostingSetup.TABLECAPTION,"VAT Bus. Posting Group","VAT Prod. Posting Group"))
            ELSE
              IF "VAT Calculation Type" <> VATPostingSetup."VAT Calculation Type" THEN
                AddError(
                  STRSUBSTNO(
                    Text037,
                    FIELDCAPTION("VAT Calculation Type"),VATPostingSetup."VAT Calculation Type"))
          END;

          IF GLAcc."Reconciliation Account" THEN
            ReconcileGLAccNo("Account No.",ROUND("Amount (LCY)" / (1 + "VAT %" / 100)));
        END;
    END;

    LOCAL PROCEDURE CheckCust@9(VAR GenJnlLine@1000 : Record 81;VAR AccName@1001 : Text[50]);
    BEGIN
      WITH GenJnlLine DO
        IF NOT Cust.GET("Account No.") THEN
          AddError(
            STRSUBSTNO(
              Text031,
              Cust.TABLECAPTION,"Account No."))
        ELSE BEGIN
          AccName := Cust.Name;
          IF Cust."Privacy Blocked" THEN
            AddError(Cust.GetPrivacyBlockedGenericErrorText(Cust));
          IF ((Cust.Blocked = Cust.Blocked::All) OR
              ((Cust.Blocked = Cust.Blocked::Invoice) AND
               ("Document Type" IN ["Document Type"::Invoice,"Document Type"::" "]))
              )
          THEN
            AddError(
              STRSUBSTNO(
                Text065,
                "Account Type",Cust.Blocked,FIELDCAPTION("Document Type"),"Document Type"));
          IF "Currency Code" <> '' THEN
            IF NOT Currency.GET("Currency Code") THEN
              AddError(
                STRSUBSTNO(
                  Text038,
                  "Currency Code"));
          IF (Cust."IC Partner Code" <> '') AND (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) THEN
            IF ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
              IF ICPartner.Blocked THEN
                AddError(
                  STRSUBSTNO(
                    '%1 %2',
                    STRSUBSTNO(
                      Text067,
                      Cust.TABLECAPTION,"Account No.",ICPartner.TABLECAPTION,"IC Partner Code"),
                    STRSUBSTNO(
                      Text032,
                      ICPartner.FIELDCAPTION(Blocked),FALSE,ICPartner.TABLECAPTION,Cust."IC Partner Code")));
            END ELSE
              AddError(
                STRSUBSTNO(
                  '%1 %2',
                  STRSUBSTNO(
                    Text067,
                    Cust.TABLECAPTION,"Account No.",ICPartner.TABLECAPTION,Cust."IC Partner Code"),
                  STRSUBSTNO(
                    Text031,
                    ICPartner.TABLECAPTION,Cust."IC Partner Code")));
          CustPosting := TRUE;
          TestPostingType;

          IF "Recurring Method" = 0 THEN
            IF "Document Type" IN
               ["Document Type"::Invoice,"Document Type"::"Credit Memo",
                "Document Type"::"Finance Charge Memo","Document Type"::Reminder]
            THEN BEGIN
              OldCustLedgEntry.RESET;
              OldCustLedgEntry.SETCURRENTKEY("Document No.");
              OldCustLedgEntry.SETRANGE("Document Type","Document Type");
              OldCustLedgEntry.SETRANGE("Document No.","Document No.");
              IF OldCustLedgEntry.FINDFIRST THEN
                AddError(
                  STRSUBSTNO(
                    Text039,"Document Type","Document No."));

              IF SalesSetup."Ext. Doc. No. Mandatory" OR
                 ("External Document No." <> '')
              THEN BEGIN
                IF "External Document No." = '' THEN
                  AddError(
                    STRSUBSTNO(
                      Text041,FIELDCAPTION("External Document No.")));

                OldCustLedgEntry.RESET;
                OldCustLedgEntry.SETCURRENTKEY("External Document No.");
                OldCustLedgEntry.SETRANGE("Document Type","Document Type");
                OldCustLedgEntry.SETRANGE("Customer No.","Account No.");
                OldCustLedgEntry.SETRANGE("External Document No.","External Document No.");
                IF OldCustLedgEntry.FINDFIRST THEN
                  AddError(
                    STRSUBSTNO(
                      Text039,
                      "Document Type","External Document No."));
                CheckAgainstPrevLines("Gen. Journal Line");
              END;
            END;
        END;
    END;

    LOCAL PROCEDURE CheckVend@10(VAR GenJnlLine@1000 : Record 81;VAR AccName@1001 : Text[50]);
    BEGIN
      WITH GenJnlLine DO
        IF NOT Vend.GET("Account No.") THEN
          AddError(
            STRSUBSTNO(
              Text031,
              Vend.TABLECAPTION,"Account No."))
        ELSE BEGIN
          AccName := Vend.Name;
          IF Vend."Privacy Blocked" THEN
            AddError(Vend.GetPrivacyBlockedGenericErrorText(Vend));
          IF ((Vend.Blocked = Vend.Blocked::All) OR
              ((Vend.Blocked = Vend.Blocked::Payment) AND ("Document Type" = "Document Type"::Payment))
              )
          THEN
            AddError(
              STRSUBSTNO(
                Text065,
                "Account Type",Vend.Blocked,FIELDCAPTION("Document Type"),"Document Type"));
          IF "Currency Code" <> '' THEN
            IF NOT Currency.GET("Currency Code") THEN
              AddError(
                STRSUBSTNO(
                  Text038,
                  "Currency Code"));

          IF (Vend."IC Partner Code" <> '') AND (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) THEN
            IF ICPartner.GET(Vend."IC Partner Code") THEN BEGIN
              IF ICPartner.Blocked THEN
                AddError(
                  STRSUBSTNO(
                    '%1 %2',
                    STRSUBSTNO(
                      Text067,
                      Vend.TABLECAPTION,"Account No.",ICPartner.TABLECAPTION,Vend."IC Partner Code"),
                    STRSUBSTNO(
                      Text032,
                      ICPartner.FIELDCAPTION(Blocked),FALSE,ICPartner.TABLECAPTION,Vend."IC Partner Code")));
            END ELSE
              AddError(
                STRSUBSTNO(
                  '%1 %2',
                  STRSUBSTNO(
                    Text067,
                    Vend.TABLECAPTION,"Account No.",ICPartner.TABLECAPTION,"IC Partner Code"),
                  STRSUBSTNO(
                    Text031,
                    ICPartner.TABLECAPTION,Vend."IC Partner Code")));
          VendPosting := TRUE;
          TestPostingType;

          IF "Recurring Method" = 0 THEN
            IF "Document Type" IN
               ["Document Type"::Invoice,"Document Type"::"Credit Memo",
                "Document Type"::"Finance Charge Memo","Document Type"::Reminder]
            THEN BEGIN
              OldVendLedgEntry.RESET;
              OldVendLedgEntry.SETCURRENTKEY("Document No.");
              OldVendLedgEntry.SETRANGE("Document Type","Document Type");
              OldVendLedgEntry.SETRANGE("Document No.","Document No.");
              IF OldVendLedgEntry.FINDFIRST THEN
                AddError(
                  STRSUBSTNO(
                    Text040,
                    "Document Type","Document No."));

              IF PurchSetup."Ext. Doc. No. Mandatory" OR
                 ("External Document No." <> '')
              THEN BEGIN
                IF "External Document No." = '' THEN
                  AddError(
                    STRSUBSTNO(
                      Text041,FIELDCAPTION("External Document No.")));

                OldVendLedgEntry.RESET;
                OldVendLedgEntry.SETCURRENTKEY("External Document No.");
                OldVendLedgEntry.SETRANGE("Document Type","Document Type");
                OldVendLedgEntry.SETRANGE("Vendor No.","Account No.");
                OldVendLedgEntry.SETRANGE("External Document No.","External Document No.");
                IF OldVendLedgEntry.FINDFIRST THEN
                  AddError(
                    STRSUBSTNO(
                      Text040,
                      "Document Type","External Document No."));
                CheckAgainstPrevLines("Gen. Journal Line");
              END;
            END;
        END;
    END;

    LOCAL PROCEDURE CheckEmployee@297(VAR GenJnlLine@1001 : Record 81;VAR AccName@1000 : Text[50]);
    BEGIN
      WITH GenJnlLine DO
        IF NOT Employee.GET("Account No.") THEN
          AddError(STRSUBSTNO(Text031,Employee.TABLECAPTION,"Account No."))
        ELSE BEGIN
          AccName := Employee."No.";
          IF Employee."Privacy Blocked" THEN
            AddError(STRSUBSTNO(Text032,Employee.FIELDCAPTION("Privacy Blocked"),FALSE,Employee.TABLECAPTION,AccName))
        END;
    END;

    LOCAL PROCEDURE CheckBankAcc@11(VAR GenJnlLine@1000 : Record 81;VAR AccName@1001 : Text[50]);
    BEGIN
      WITH GenJnlLine DO
        IF NOT BankAcc.GET("Account No.") THEN
          AddError(
            STRSUBSTNO(
              Text031,
              BankAcc.TABLECAPTION,"Account No."))
        ELSE BEGIN
          AccName := BankAcc.Name;

          IF BankAcc.Blocked THEN
            AddError(
              STRSUBSTNO(
                Text032,
                BankAcc.FIELDCAPTION(Blocked),FALSE,BankAcc.TABLECAPTION,"Account No."));
          IF ("Currency Code" <> BankAcc."Currency Code") AND (BankAcc."Currency Code" <> '') THEN
            AddError(
              STRSUBSTNO(
                Text037,
                FIELDCAPTION("Currency Code"),BankAcc."Currency Code"));

          IF "Currency Code" <> '' THEN
            IF NOT Currency.GET("Currency Code") THEN
              AddError(
                STRSUBSTNO(
                  Text038,
                  "Currency Code"));

          IF "Bank Payment Type" <> 0 THEN
            IF ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") AND (Amount < 0) THEN
              IF BankAcc."Currency Code" <> "Currency Code" THEN
                AddError(
                  STRSUBSTNO(
                    Text042,
                    FIELDCAPTION("Bank Payment Type"),FIELDCAPTION("Currency Code"),
                    TABLECAPTION,BankAcc.TABLECAPTION));

          IF BankAccPostingGr.GET(BankAcc."Bank Acc. Posting Group") THEN
            IF BankAccPostingGr."G/L Bank Account No." <> '' THEN
              ReconcileGLAccNo(
                BankAccPostingGr."G/L Bank Account No.",
                ROUND("Amount (LCY)" / (1 + "VAT %" / 100)));
        END;
    END;

    LOCAL PROCEDURE CheckFixedAsset@23(VAR GenJnlLine@1000 : Record 81;VAR AccName@1001 : Text[50]);
    BEGIN
      WITH GenJnlLine DO
        IF NOT FA.GET("Account No.") THEN
          AddError(
            STRSUBSTNO(
              Text031,
              FA.TABLECAPTION,"Account No."))
        ELSE BEGIN
          AccName := FA.Description;
          IF FA.Blocked THEN
            AddError(
              STRSUBSTNO(
                Text032,
                FA.FIELDCAPTION(Blocked),FALSE,FA.TABLECAPTION,"Account No."));
          IF FA.Inactive THEN
            AddError(
              STRSUBSTNO(
                Text032,
                FA.FIELDCAPTION(Inactive),FALSE,FA.TABLECAPTION,"Account No."));
          IF FA."Budgeted Asset" THEN
            AddError(
              STRSUBSTNO(
                Text043,
                FA.TABLECAPTION,"Account No.",FA.FIELDCAPTION("Budgeted Asset"),TRUE));
          IF DeprBook.GET("Depreciation Book Code") THEN
            CheckFAIntegration(GenJnlLine)
          ELSE
            AddError(
              STRSUBSTNO(
                Text031,
                DeprBook.TABLECAPTION,"Depreciation Book Code"));
          IF NOT FADeprBook.GET(FA."No.","Depreciation Book Code") THEN
            AddError(
              STRSUBSTNO(
                Text036,
                FADeprBook.TABLECAPTION,FA."No.","Depreciation Book Code"));
        END;
    END;

    LOCAL PROCEDURE CheckICPartner@26(VAR GenJnlLine@1000 : Record 81;VAR AccName@1001 : Text[50]);
    BEGIN
      WITH GenJnlLine DO
        IF NOT ICPartner.GET("Account No.") THEN
          AddError(
            STRSUBSTNO(
              Text031,
              ICPartner.TABLECAPTION,"Account No."))
        ELSE BEGIN
          AccName := ICPartner.Name;
          IF ICPartner.Blocked THEN
            AddError(
              STRSUBSTNO(
                Text032,
                ICPartner.FIELDCAPTION(Blocked),FALSE,ICPartner.TABLECAPTION,"Account No."));
        END;
    END;

    LOCAL PROCEDURE TestFixedAsset@13(VAR GenJnlLine@1000 : Record 81);
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF "Job No." <> '' THEN
          AddError(
            STRSUBSTNO(
              Text044,FIELDCAPTION("Job No.")));
        IF "FA Posting Type" = "FA Posting Type"::" " THEN
          AddError(
            STRSUBSTNO(
              Text045,FIELDCAPTION("FA Posting Type")));
        IF "Depreciation Book Code" = '' THEN
          AddError(
            STRSUBSTNO(
              Text045,FIELDCAPTION("Depreciation Book Code")));
        IF "Depreciation Book Code" = "Duplicate in Depreciation Book" THEN
          AddError(
            STRSUBSTNO(
              Text046,
              FIELDCAPTION("Depreciation Book Code"),FIELDCAPTION("Duplicate in Depreciation Book")));
        CheckFADocNo(GenJnlLine);
        IF "Account Type" = "Bal. Account Type" THEN
          AddError(
            STRSUBSTNO(
              Text047,
              FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type"),"Account Type"));
        IF "Account Type" = "Account Type"::"Fixed Asset" THEN
          IF "FA Posting Type" IN
             ["FA Posting Type"::"Acquisition Cost","FA Posting Type"::Disposal,"FA Posting Type"::Maintenance]
          THEN BEGIN
            IF ("Gen. Bus. Posting Group" <> '') OR ("Gen. Prod. Posting Group" <> '') THEN
              IF "Gen. Posting Type" = "Gen. Posting Type"::" " THEN
                AddError(STRSUBSTNO(Text002,FIELDCAPTION("Gen. Posting Type")));
          END ELSE BEGIN
            IF "Gen. Posting Type" <> "Gen. Posting Type"::" " THEN
              AddError(
                STRSUBSTNO(
                  Text049,
                  FIELDCAPTION("Gen. Posting Type"),FIELDCAPTION("FA Posting Type"),"FA Posting Type"));
            IF "Gen. Bus. Posting Group" <> '' THEN
              AddError(
                STRSUBSTNO(
                  Text049,
                  FIELDCAPTION("Gen. Bus. Posting Group"),FIELDCAPTION("FA Posting Type"),"FA Posting Type"));
            IF "Gen. Prod. Posting Group" <> '' THEN
              AddError(
                STRSUBSTNO(
                  Text049,
                  FIELDCAPTION("Gen. Prod. Posting Group"),FIELDCAPTION("FA Posting Type"),"FA Posting Type"));
          END;
        IF "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" THEN
          IF "FA Posting Type" IN
             ["FA Posting Type"::"Acquisition Cost","FA Posting Type"::Disposal,"FA Posting Type"::Maintenance]
          THEN BEGIN
            IF ("Bal. Gen. Bus. Posting Group" <> '') OR ("Bal. Gen. Prod. Posting Group" <> '') THEN
              IF "Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::" " THEN
                AddError(STRSUBSTNO(Text002,FIELDCAPTION("Bal. Gen. Posting Type")));
          END ELSE BEGIN
            IF "Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" " THEN
              AddError(
                STRSUBSTNO(
                  Text049,
                  FIELDCAPTION("Bal. Gen. Posting Type"),FIELDCAPTION("FA Posting Type"),"FA Posting Type"));
            IF "Bal. Gen. Bus. Posting Group" <> '' THEN
              AddError(
                STRSUBSTNO(
                  Text049,
                  FIELDCAPTION("Bal. Gen. Bus. Posting Group"),FIELDCAPTION("FA Posting Type"),"FA Posting Type"));
            IF "Bal. Gen. Prod. Posting Group" <> '' THEN
              AddError(
                STRSUBSTNO(
                  Text049,
                  FIELDCAPTION("Bal. Gen. Prod. Posting Group"),FIELDCAPTION("FA Posting Type"),"FA Posting Type"));
          END;
        TempErrorText :=
          '%1 ' +
          STRSUBSTNO(
            Text050,
            FIELDCAPTION("FA Posting Type"),"FA Posting Type");
        IF "FA Posting Type" <> "FA Posting Type"::"Acquisition Cost" THEN BEGIN
          IF "Depr. Acquisition Cost" THEN
            AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Depr. Acquisition Cost")));
          IF "Salvage Value" <> 0 THEN
            AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Salvage Value")));
          IF "FA Posting Type" <> "FA Posting Type"::Maintenance THEN
            IF Quantity <> 0 THEN
              AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION(Quantity)));
          IF "Insurance No." <> '' THEN
            AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Insurance No.")));
        END;
        IF ("FA Posting Type" = "FA Posting Type"::Maintenance) AND "Depr. until FA Posting Date" THEN
          AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Depr. until FA Posting Date")));
        IF ("FA Posting Type" <> "FA Posting Type"::Maintenance) AND ("Maintenance Code" <> '') THEN
          AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Maintenance Code")));

        IF ("FA Posting Type" <> "FA Posting Type"::Depreciation) AND
           ("FA Posting Type" <> "FA Posting Type"::"Custom 1") AND
           ("No. of Depreciation Days" <> 0)
        THEN
          AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("No. of Depreciation Days")));

        IF ("FA Posting Type" = "FA Posting Type"::Disposal) AND "FA Reclassification Entry" THEN
          AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("FA Reclassification Entry")));

        IF ("FA Posting Type" = "FA Posting Type"::Disposal) AND ("Budgeted FA No." <> '') THEN
          AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Budgeted FA No.")));

        IF "FA Posting Date" = 0D THEN
          "FA Posting Date" := "Posting Date";
        IF DeprBook.GET("Depreciation Book Code") THEN
          IF DeprBook."Use Same FA+G/L Posting Dates" AND ("Posting Date" <> "FA Posting Date") THEN
            AddError(
              STRSUBSTNO(
                Text051,
                FIELDCAPTION("Posting Date"),FIELDCAPTION("FA Posting Date")));
        IF "FA Posting Date" <> 0D THEN BEGIN
          IF "FA Posting Date" <> NORMALDATE("FA Posting Date") THEN
            AddError(
              STRSUBSTNO(
                Text052,
                FIELDCAPTION("FA Posting Date")));
          IF NOT ("FA Posting Date" IN [DMY2DATE(1,1,2)..DMY2DATE(31,12,9998)]) THEN
            AddError(
              STRSUBSTNO(
                Text053,
                FIELDCAPTION("FA Posting Date")));
          IF (AllowFAPostingFrom = 0D) AND (AllowFAPostingTo = 0D) THEN BEGIN
            IF USERID <> '' THEN
              IF UserSetup.GET(USERID) THEN BEGIN
                AllowFAPostingFrom := UserSetup."Allow FA Posting From";
                AllowFAPostingTo := UserSetup."Allow FA Posting To";
              END;
            IF (AllowFAPostingFrom = 0D) AND (AllowFAPostingTo = 0D) THEN BEGIN
              FASetup.GET;
              AllowFAPostingFrom := FASetup."Allow FA Posting From";
              AllowFAPostingTo := FASetup."Allow FA Posting To";
            END;
            IF AllowFAPostingTo = 0D THEN
              AllowFAPostingTo := DMY2DATE(31,12,9998);
          END;
          IF ("FA Posting Date" < AllowFAPostingFrom) OR
             ("FA Posting Date" > AllowFAPostingTo)
          THEN
            AddError(
              STRSUBSTNO(
                Text053,
                FIELDCAPTION("FA Posting Date")));
        END;
        FASetup.GET;
        IF ("FA Posting Type" = "FA Posting Type"::"Acquisition Cost") AND
           ("Insurance No." <> '') AND ("Depreciation Book Code" <> FASetup."Insurance Depr. Book")
        THEN
          AddError(
            STRSUBSTNO(
              Text054,
              FIELDCAPTION("Depreciation Book Code"),"Depreciation Book Code"));

        IF "FA Error Entry No." > 0 THEN BEGIN
          TempErrorText :=
            '%1 ' +
            STRSUBSTNO(
              Text055,
              FIELDCAPTION("FA Error Entry No."));
          IF "Depr. until FA Posting Date" THEN
            AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Depr. until FA Posting Date")));
          IF "Depr. Acquisition Cost" THEN
            AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Depr. Acquisition Cost")));
          IF "Duplicate in Depreciation Book" <> '' THEN
            AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Duplicate in Depreciation Book")));
          IF "Use Duplication List" THEN
            AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Use Duplication List")));
          IF "Salvage Value" <> 0 THEN
            AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Salvage Value")));
          IF "Insurance No." <> '' THEN
            AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Insurance No.")));
          IF "Budgeted FA No." <> '' THEN
            AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Budgeted FA No.")));
          IF "Recurring Method" > 0 THEN
            AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Recurring Method")));
          IF "FA Posting Type" = "FA Posting Type"::Maintenance THEN
            AddError(STRSUBSTNO(TempErrorText,"FA Posting Type"));
        END;
      END;
    END;

    LOCAL PROCEDURE CheckFAIntegration@12(VAR GenJnlLine@1000 : Record 81);
    VAR
      GLIntegration@1001 : Boolean;
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF "FA Posting Type" = "FA Posting Type"::" " THEN
          EXIT;
        CASE "FA Posting Type" OF
          "FA Posting Type"::"Acquisition Cost":
            GLIntegration := DeprBook."G/L Integration - Acq. Cost";
          "FA Posting Type"::Depreciation:
            GLIntegration := DeprBook."G/L Integration - Depreciation";
          "FA Posting Type"::"Write-Down":
            GLIntegration := DeprBook."G/L Integration - Write-Down";
          "FA Posting Type"::Appreciation:
            GLIntegration := DeprBook."G/L Integration - Appreciation";
          "FA Posting Type"::"Custom 1":
            GLIntegration := DeprBook."G/L Integration - Custom 1";
          "FA Posting Type"::"Custom 2":
            GLIntegration := DeprBook."G/L Integration - Custom 2";
          "FA Posting Type"::Disposal:
            GLIntegration := DeprBook."G/L Integration - Disposal";
          "FA Posting Type"::Maintenance:
            GLIntegration := DeprBook."G/L Integration - Maintenance";
        END;
        IF NOT GLIntegration THEN
          AddError(
            STRSUBSTNO(
              Text056,
              "FA Posting Type"));

        IF NOT DeprBook."G/L Integration - Depreciation" THEN BEGIN
          IF "Depr. until FA Posting Date" THEN
            AddError(
              STRSUBSTNO(
                Text057,
                FIELDCAPTION("Depr. until FA Posting Date")));
          IF "Depr. Acquisition Cost" THEN
            AddError(
              STRSUBSTNO(
                Text057,
                FIELDCAPTION("Depr. Acquisition Cost")));
        END;
      END;
    END;

    LOCAL PROCEDURE TestFixedAssetFields@14(VAR GenJnlLine@1000 : Record 81);
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF "FA Posting Type" <> "FA Posting Type"::" " THEN
          AddError(STRSUBSTNO(Text058,FIELDCAPTION("FA Posting Type")));
        IF "Depreciation Book Code" <> '' THEN
          AddError(STRSUBSTNO(Text058,FIELDCAPTION("Depreciation Book Code")));
      END;
    END;

    PROCEDURE TestPostingType@15();
    BEGIN
      CASE TRUE OF
        CustPosting AND PurchPostingType:
          AddError(Text059);
        VendPosting AND SalesPostingType:
          AddError(Text060);
      END;
    END;

    LOCAL PROCEDURE WarningIfNegativeAmt@3(GenJnlLine@1000 : Record 81);
    BEGIN
      IF (GenJnlLine.Amount < 0) AND NOT AmountError THEN BEGIN
        AmountError := TRUE;
        AddError(STRSUBSTNO(Text007,GenJnlLine.FIELDCAPTION(Amount)));
      END;
    END;

    LOCAL PROCEDURE WarningIfPositiveAmt@16(GenJnlLine@1000 : Record 81);
    BEGIN
      IF (GenJnlLine.Amount > 0) AND NOT AmountError THEN BEGIN
        AmountError := TRUE;
        AddError(STRSUBSTNO(Text006,GenJnlLine.FIELDCAPTION(Amount)));
      END;
    END;

    LOCAL PROCEDURE WarningIfZeroAmt@22(GenJnlLine@1000 : Record 81);
    BEGIN
      IF (GenJnlLine.Amount = 0) AND NOT AmountError THEN BEGIN
        AmountError := TRUE;
        AddError(STRSUBSTNO(Text002,GenJnlLine.FIELDCAPTION(Amount)));
      END;
    END;

    LOCAL PROCEDURE WarningIfNonZeroAmt@24(GenJnlLine@1000 : Record 81);
    BEGIN
      IF (GenJnlLine.Amount <> 0) AND NOT AmountError THEN BEGIN
        AmountError := TRUE;
        AddError(STRSUBSTNO(Text062,GenJnlLine.FIELDCAPTION(Amount)));
      END;
    END;

    LOCAL PROCEDURE CheckAgainstPrevLines@20(GenJnlLine@1000 : Record 81);
    VAR
      i@1001 : Integer;
      AccType@1002 : Integer;
      AccNo@1003 : Code[20];
      ErrorFound@1004 : Boolean;
    BEGIN
      IF (GenJnlLine."External Document No." = '') OR
         NOT (GenJnlLine."Account Type" IN
              [GenJnlLine."Account Type"::Customer,GenJnlLine."Account Type"::Vendor]) AND
         NOT (GenJnlLine."Bal. Account Type" IN
              [GenJnlLine."Bal. Account Type"::Customer,GenJnlLine."Bal. Account Type"::Vendor])
      THEN
        EXIT;

      IF GenJnlLine."Account Type" IN [GenJnlLine."Account Type"::Customer,GenJnlLine."Account Type"::Vendor] THEN BEGIN
        AccType := GenJnlLine."Account Type";
        AccNo := GenJnlLine."Account No.";
      END ELSE BEGIN
        AccType := GenJnlLine."Bal. Account Type";
        AccNo := GenJnlLine."Bal. Account No.";
      END;

      TempGenJnlLine.RESET;
      TempGenJnlLine.SETRANGE("External Document No.",GenJnlLine."External Document No.");

      WHILE (i < 2) AND NOT ErrorFound DO BEGIN
        i := i + 1;
        IF i = 1 THEN BEGIN
          TempGenJnlLine.SETRANGE("Account Type",AccType);
          TempGenJnlLine.SETRANGE("Account No.",AccNo);
          TempGenJnlLine.SETRANGE("Bal. Account Type");
          TempGenJnlLine.SETRANGE("Bal. Account No.");
        END ELSE BEGIN
          TempGenJnlLine.SETRANGE("Account Type");
          TempGenJnlLine.SETRANGE("Account No.");
          TempGenJnlLine.SETRANGE("Bal. Account Type",AccType);
          TempGenJnlLine.SETRANGE("Bal. Account No.",AccNo);
        END;
        IF TempGenJnlLine.FINDFIRST THEN BEGIN
          ErrorFound := TRUE;
          AddError(
            STRSUBSTNO(
              Text064,GenJnlLine.FIELDCAPTION("External Document No."),GenJnlLine."External Document No.",
              TempGenJnlLine."Line No.",GenJnlLine.FIELDCAPTION("Document No."),TempGenJnlLine."Document No."));
        END;
      END;

      TempGenJnlLine.RESET;
      TempGenJnlLine := GenJnlLine;
      TempGenJnlLine.INSERT;
    END;

    LOCAL PROCEDURE CheckICDocument@17();
    VAR
      GenJnlLine4@1000 : Record 81;
      ICGLAccount@1001 : Record 410;
    BEGIN
      WITH "Gen. Journal Line" DO
        IF GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany THEN BEGIN
          IF ("Posting Date" <> LastDate) OR ("Document Type" <> LastDocType) OR ("Document No." <> LastDocNo) THEN BEGIN
            GenJnlLine4.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
            GenJnlLine4.SETRANGE("Journal Template Name","Journal Template Name");
            GenJnlLine4.SETRANGE("Journal Batch Name","Journal Batch Name");
            GenJnlLine4.SETRANGE("Posting Date","Posting Date");
            GenJnlLine4.SETRANGE("Document No.","Document No.");
            GenJnlLine4.SETFILTER("IC Partner Code",'<>%1','');
            IF GenJnlLine4.FINDFIRST THEN
              CurrentICPartner := GenJnlLine4."IC Partner Code"
            ELSE
              CurrentICPartner := '';
          END;
          IF (CurrentICPartner <> '') AND ("IC Direction" = "IC Direction"::Outgoing) THEN BEGIN
            IF ("Account Type" IN ["Account Type"::"G/L Account","Account Type"::"Bank Account"]) AND
               ("Bal. Account Type" IN ["Bal. Account Type"::"G/L Account","Account Type"::"Bank Account"]) AND
               ("Account No." <> '') AND
               ("Bal. Account No." <> '')
            THEN BEGIN
              AddError(
                STRSUBSTNO(
                  Text066,FIELDCAPTION("Account No."),FIELDCAPTION("Bal. Account No.")));
            END ELSE BEGIN
              IF (("Account Type" IN ["Account Type"::"G/L Account","Account Type"::"Bank Account"]) AND ("Account No." <> '')) XOR
                 (("Bal. Account Type" IN ["Bal. Account Type"::"G/L Account","Account Type"::"Bank Account"]) AND
                  ("Bal. Account No." <> ''))
              THEN BEGIN
                IF "IC Partner G/L Acc. No." = '' THEN
                  AddError(
                    STRSUBSTNO(
                      Text002,FIELDCAPTION("IC Partner G/L Acc. No.")))
                ELSE BEGIN
                  IF ICGLAccount.GET("IC Partner G/L Acc. No.") THEN
                    IF ICGLAccount.Blocked THEN
                      AddError(
                        STRSUBSTNO(
                          Text032,
                          ICGLAccount.FIELDCAPTION(Blocked),FALSE,FIELDCAPTION("IC Partner G/L Acc. No."),
                          "IC Partner G/L Acc. No."
                          ));
                END;
              END ELSE
                IF "IC Partner G/L Acc. No." <> '' THEN
                  AddError(
                    STRSUBSTNO(
                      Text009,FIELDCAPTION("IC Partner G/L Acc. No.")));
            END;
          END ELSE
            IF "IC Partner G/L Acc. No." <> '' THEN BEGIN
              IF "IC Direction" = "IC Direction"::Incoming THEN
                AddError(
                  STRSUBSTNO(
                    Text069,FIELDCAPTION("IC Partner G/L Acc. No."),FIELDCAPTION("IC Direction"),FORMAT("IC Direction")));
              IF CurrentICPartner = '' THEN
                AddError(
                  STRSUBSTNO(
                    Text070,FIELDCAPTION("IC Partner G/L Acc. No.")));
            END;
        END;
    END;

    LOCAL PROCEDURE TestJobFields@18(VAR GenJnlLine@1000 : Record 81);
    VAR
      Job@1001 : Record 167;
      JT@1002 : Record 1001;
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF ("Job No." = '') OR ("Account Type" <> "Account Type"::"G/L Account") THEN
          EXIT;
        IF NOT Job.GET("Job No.") THEN
          AddError(STRSUBSTNO(Text071,Job.TABLECAPTION,"Job No."))
        ELSE
          IF Job.Blocked > Job.Blocked::" " THEN
            AddError(
              STRSUBSTNO(
                Text072,Job.FIELDCAPTION(Blocked),Job.Blocked,Job.TABLECAPTION,"Job No."));

        IF "Job Task No." = '' THEN
          AddError(STRSUBSTNO(Text002,FIELDCAPTION("Job Task No.")))
        ELSE
          IF NOT JT.GET("Job No.","Job Task No.") THEN
            AddError(STRSUBSTNO(Text071,JT.TABLECAPTION,"Job Task No."))
      END;
    END;

    LOCAL PROCEDURE CheckFADocNo@19(GenJnlLine@1002 : Record 81);
    VAR
      DeprBook@1005 : Record 5611;
      FAJnlLine@1003 : Record 5621;
      OldFALedgEntry@1001 : Record 5601;
      OldMaintenanceLedgEntry@1000 : Record 5625;
      FANo@1004 : Code[20];
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF "Account Type" = "Account Type"::"Fixed Asset" THEN
          FANo := "Account No.";
        IF "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" THEN
          FANo := "Bal. Account No.";
        IF (FANo = '') OR
           ("FA Posting Type" = "FA Posting Type"::" ") OR
           ("Depreciation Book Code" = '') OR
           ("Document No." = '')
        THEN
          EXIT;
        IF NOT DeprBook.GET("Depreciation Book Code") THEN
          EXIT;
        IF DeprBook."Allow Identical Document No." THEN
          EXIT;

        FAJnlLine."FA Posting Type" := "FA Posting Type" - 1;
        IF "FA Posting Type" <> "FA Posting Type"::Maintenance THEN BEGIN
          OldFALedgEntry.SETCURRENTKEY(
            "FA No.","Depreciation Book Code","FA Posting Category","FA Posting Type","Document No.");
          OldFALedgEntry.SETRANGE("FA No.",FANo);
          OldFALedgEntry.SETRANGE("Depreciation Book Code","Depreciation Book Code");
          OldFALedgEntry.SETRANGE("FA Posting Category",OldFALedgEntry."FA Posting Category"::" ");
          OldFALedgEntry.SETRANGE("FA Posting Type",FAJnlLine.ConvertToLedgEntry(FAJnlLine));
          OldFALedgEntry.SETRANGE("Document No.","Document No.");
          IF OldFALedgEntry.FINDFIRST THEN
            AddError(
              STRSUBSTNO(
                Text073,
                FIELDCAPTION("Document No."),"Document No."));
        END ELSE BEGIN
          OldMaintenanceLedgEntry.SETCURRENTKEY(
            "FA No.","Depreciation Book Code","Document No.");
          OldMaintenanceLedgEntry.SETRANGE("FA No.",FANo);
          OldMaintenanceLedgEntry.SETRANGE("Depreciation Book Code","Depreciation Book Code");
          OldMaintenanceLedgEntry.SETRANGE("Document No.","Document No.");
          IF OldMaintenanceLedgEntry.FINDFIRST THEN
            AddError(
              STRSUBSTNO(
                Text073,
                FIELDCAPTION("Document No."),"Document No."));
        END;
      END;
    END;

    PROCEDURE InitializeRequest@21(NewShowDim@1000 : Boolean);
    BEGIN
      ShowDim := NewShowDim;
    END;

    LOCAL PROCEDURE GetDimensionText@25(VAR DimensionSetEntry@1005 : Record 480) : Text[75];
    VAR
      DimensionText@1001 : Text[75];
      Separator@1003 : Code[10];
      DimValue@1002 : Text[45];
    BEGIN
      Separator := '';
      DimValue := '';
      Continue := FALSE;

      REPEAT
        DimValue := STRSUBSTNO('%1 - %2',DimensionSetEntry."Dimension Code",DimensionSetEntry."Dimension Value Code");
        IF MAXSTRLEN(DimensionText) < STRLEN(DimensionText + Separator + DimValue) THEN BEGIN
          Continue := TRUE;
          EXIT(DimensionText);
        END;
        DimensionText := DimensionText + Separator + DimValue;
        Separator := '; ';
      UNTIL DimSetEntry.NEXT = 0;
      EXIT(DimensionText);
    END;

    LOCAL PROCEDURE CheckAccountTypes@299(AccountType@1000 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';VAR Name@1001 : Text[50]);
    BEGIN
      CASE AccountType OF
        AccountType::"G/L Account":
          CheckGLAcc("Gen. Journal Line",Name);
        AccountType::Customer:
          CheckCust("Gen. Journal Line",Name);
        AccountType::Vendor:
          CheckVend("Gen. Journal Line",Name);
        AccountType::"Bank Account":
          CheckBankAcc("Gen. Journal Line",Name);
        AccountType::"Fixed Asset":
          CheckFixedAsset("Gen. Journal Line",Name);
        AccountType::"IC Partner":
          CheckICPartner("Gen. Journal Line",Name);
        AccountType::Employee:
          CheckEmployee("Gen. Journal Line",Name);
      END;
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
      <rd:DataSourceID>7ee18a32-d991-40f8-a570-b43fad5d7248</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="JnlTmplName_GenJnlBatch">
          <DataField>JnlTmplName_GenJnlBatch</DataField>
        </Field>
        <Field Name="Name_GenJnlBatch">
          <DataField>Name_GenJnlBatch</DataField>
        </Field>
        <Field Name="CompanyName">
          <DataField>CompanyName</DataField>
        </Field>
        <Field Name="GeneralJnlTestCaption">
          <DataField>GeneralJnlTestCaption</DataField>
        </Field>
        <Field Name="JnlTemplateName_GenJnlBatch">
          <DataField>JnlTemplateName_GenJnlBatch</DataField>
        </Field>
        <Field Name="JnlName_GenJnlBatch">
          <DataField>JnlName_GenJnlBatch</DataField>
        </Field>
        <Field Name="GenJnlLineFilter">
          <DataField>GenJnlLineFilter</DataField>
        </Field>
        <Field Name="GenJnlLineFilterTableCaption">
          <DataField>GenJnlLineFilterTableCaption</DataField>
        </Field>
        <Field Name="Number_Integer">
          <DataField>Number_Integer</DataField>
        </Field>
        <Field Name="PageNoCaption">
          <DataField>PageNoCaption</DataField>
        </Field>
        <Field Name="JnlTmplNameCaption_GenJnlBatch">
          <DataField>JnlTmplNameCaption_GenJnlBatch</DataField>
        </Field>
        <Field Name="JournalBatchCaption">
          <DataField>JournalBatchCaption</DataField>
        </Field>
        <Field Name="PostingDateCaption">
          <DataField>PostingDateCaption</DataField>
        </Field>
        <Field Name="DocumentTypeCaption">
          <DataField>DocumentTypeCaption</DataField>
        </Field>
        <Field Name="DocNoCaption_GenJnlLine">
          <DataField>DocNoCaption_GenJnlLine</DataField>
        </Field>
        <Field Name="AccountTypeCaption">
          <DataField>AccountTypeCaption</DataField>
        </Field>
        <Field Name="AccNoCaption_GenJnlLine">
          <DataField>AccNoCaption_GenJnlLine</DataField>
        </Field>
        <Field Name="AccNameCaption">
          <DataField>AccNameCaption</DataField>
        </Field>
        <Field Name="DescCaption_GenJnlLine">
          <DataField>DescCaption_GenJnlLine</DataField>
        </Field>
        <Field Name="PostingTypeCaption">
          <DataField>PostingTypeCaption</DataField>
        </Field>
        <Field Name="GenBusPostGroupCaption">
          <DataField>GenBusPostGroupCaption</DataField>
        </Field>
        <Field Name="GenProdPostGroupCaption">
          <DataField>GenProdPostGroupCaption</DataField>
        </Field>
        <Field Name="AmountCaption_GenJnlLine">
          <DataField>AmountCaption_GenJnlLine</DataField>
        </Field>
        <Field Name="BalAccNoCaption_GenJnlLine">
          <DataField>BalAccNoCaption_GenJnlLine</DataField>
        </Field>
        <Field Name="BalLCYCaption_GenJnlLine">
          <DataField>BalLCYCaption_GenJnlLine</DataField>
        </Field>
        <Field Name="PostingDate_GenJnlLine">
          <DataField>PostingDate_GenJnlLine</DataField>
        </Field>
        <Field Name="DocType_GenJnlLine">
          <DataField>DocType_GenJnlLine</DataField>
        </Field>
        <Field Name="DocNo_GenJnlLine">
          <DataField>DocNo_GenJnlLine</DataField>
        </Field>
        <Field Name="AccountType_GenJnlLine">
          <DataField>AccountType_GenJnlLine</DataField>
        </Field>
        <Field Name="AccountNo_GenJnlLine">
          <DataField>AccountNo_GenJnlLine</DataField>
        </Field>
        <Field Name="AccName">
          <DataField>AccName</DataField>
        </Field>
        <Field Name="Description_GenJnlLine">
          <DataField>Description_GenJnlLine</DataField>
        </Field>
        <Field Name="GenPostType_GenJnlLine">
          <DataField>GenPostType_GenJnlLine</DataField>
        </Field>
        <Field Name="GenBusPosGroup_GenJnlLine">
          <DataField>GenBusPosGroup_GenJnlLine</DataField>
        </Field>
        <Field Name="GenProdPostGroup_GenJnlLine">
          <DataField>GenProdPostGroup_GenJnlLine</DataField>
        </Field>
        <Field Name="Amount_GenJnlLine">
          <DataField>Amount_GenJnlLine</DataField>
        </Field>
        <Field Name="Amount_GenJnlLineFormat">
          <DataField>Amount_GenJnlLineFormat</DataField>
        </Field>
        <Field Name="CurrencyCode_GenJnlLine">
          <DataField>CurrencyCode_GenJnlLine</DataField>
        </Field>
        <Field Name="BalAccNo_GenJnlLine">
          <DataField>BalAccNo_GenJnlLine</DataField>
        </Field>
        <Field Name="BalanceLCY_GenJnlLine">
          <DataField>BalanceLCY_GenJnlLine</DataField>
        </Field>
        <Field Name="BalanceLCY_GenJnlLineFormat">
          <DataField>BalanceLCY_GenJnlLineFormat</DataField>
        </Field>
        <Field Name="AmountLCY">
          <DataField>AmountLCY</DataField>
        </Field>
        <Field Name="AmountLCYFormat">
          <DataField>AmountLCYFormat</DataField>
        </Field>
        <Field Name="BalanceLCY">
          <DataField>BalanceLCY</DataField>
        </Field>
        <Field Name="BalanceLCYFormat">
          <DataField>BalanceLCYFormat</DataField>
        </Field>
        <Field Name="AmountLCY_GenJnlLine">
          <DataField>AmountLCY_GenJnlLine</DataField>
        </Field>
        <Field Name="AmountLCY_GenJnlLineFormat">
          <DataField>AmountLCY_GenJnlLineFormat</DataField>
        </Field>
        <Field Name="JnlTmplName_GenJnlLine">
          <DataField>JnlTmplName_GenJnlLine</DataField>
        </Field>
        <Field Name="JnlBatchName_GenJnlLine">
          <DataField>JnlBatchName_GenJnlLine</DataField>
        </Field>
        <Field Name="LineNo_GenJnlLine">
          <DataField>LineNo_GenJnlLine</DataField>
        </Field>
        <Field Name="TotalLCYCaption">
          <DataField>TotalLCYCaption</DataField>
        </Field>
        <Field Name="DimText">
          <DataField>DimText</DataField>
        </Field>
        <Field Name="Number_DimensionLoop">
          <DataField>Number_DimensionLoop</DataField>
        </Field>
        <Field Name="DimensionsCaption">
          <DataField>DimensionsCaption</DataField>
        </Field>
        <Field Name="AccountNo_GenJnlAllocation">
          <DataField>AccountNo_GenJnlAllocation</DataField>
        </Field>
        <Field Name="AccountName_GenJnlAllocation">
          <DataField>AccountName_GenJnlAllocation</DataField>
        </Field>
        <Field Name="AllocationQuantity_GenJnlAllocation">
          <DataField>AllocationQuantity_GenJnlAllocation</DataField>
        </Field>
        <Field Name="AllocationQuantity_GenJnlAllocationFormat">
          <DataField>AllocationQuantity_GenJnlAllocationFormat</DataField>
        </Field>
        <Field Name="AllocationPct_GenJnlAllocation">
          <DataField>AllocationPct_GenJnlAllocation</DataField>
        </Field>
        <Field Name="AllocationPct_GenJnlAllocationFormat">
          <DataField>AllocationPct_GenJnlAllocationFormat</DataField>
        </Field>
        <Field Name="Amount_GenJnlAllocation">
          <DataField>Amount_GenJnlAllocation</DataField>
        </Field>
        <Field Name="Amount_GenJnlAllocationFormat">
          <DataField>Amount_GenJnlAllocationFormat</DataField>
        </Field>
        <Field Name="JournalLineNo_GenJnlAllocation">
          <DataField>JournalLineNo_GenJnlAllocation</DataField>
        </Field>
        <Field Name="LineNo_GenJnlAllocation">
          <DataField>LineNo_GenJnlAllocation</DataField>
        </Field>
        <Field Name="JournalBatchName_GenJnlAllocation">
          <DataField>JournalBatchName_GenJnlAllocation</DataField>
        </Field>
        <Field Name="AccountNoCaption_GenJnlAllocation">
          <DataField>AccountNoCaption_GenJnlAllocation</DataField>
        </Field>
        <Field Name="AccountNameCaption_GenJnlAllocation">
          <DataField>AccountNameCaption_GenJnlAllocation</DataField>
        </Field>
        <Field Name="AllocationQuantityCaption_GenJnlAllocation">
          <DataField>AllocationQuantityCaption_GenJnlAllocation</DataField>
        </Field>
        <Field Name="AllocationPctCaption_GenJnlAllocation">
          <DataField>AllocationPctCaption_GenJnlAllocation</DataField>
        </Field>
        <Field Name="AmountCaption_GenJnlAllocation">
          <DataField>AmountCaption_GenJnlAllocation</DataField>
        </Field>
        <Field Name="Recurring_GenJnlTemplate">
          <DataField>Recurring_GenJnlTemplate</DataField>
        </Field>
        <Field Name="AllocationDimText">
          <DataField>AllocationDimText</DataField>
        </Field>
        <Field Name="Number_DimensionLoopAllocations">
          <DataField>Number_DimensionLoopAllocations</DataField>
        </Field>
        <Field Name="DimensionAllocationsCaption">
          <DataField>DimensionAllocationsCaption</DataField>
        </Field>
        <Field Name="ErrorTextNumber">
          <DataField>ErrorTextNumber</DataField>
        </Field>
        <Field Name="WarningCaption">
          <DataField>WarningCaption</DataField>
        </Field>
        <Field Name="GLAccNetChangeNo">
          <DataField>GLAccNetChangeNo</DataField>
        </Field>
        <Field Name="GLAccNetChangeName">
          <DataField>GLAccNetChangeName</DataField>
        </Field>
        <Field Name="GLAccNetChangeNetChangeJnl">
          <DataField>GLAccNetChangeNetChangeJnl</DataField>
        </Field>
        <Field Name="GLAccNetChangeNetChangeJnlFormat">
          <DataField>GLAccNetChangeNetChangeJnlFormat</DataField>
        </Field>
        <Field Name="GLAccNetChangeBalafterPost">
          <DataField>GLAccNetChangeBalafterPost</DataField>
        </Field>
        <Field Name="GLAccNetChangeBalafterPostFormat">
          <DataField>GLAccNetChangeBalafterPostFormat</DataField>
        </Field>
        <Field Name="ReconciliationCaption">
          <DataField>ReconciliationCaption</DataField>
        </Field>
        <Field Name="NoCaption">
          <DataField>NoCaption</DataField>
        </Field>
        <Field Name="NameCaption">
          <DataField>NameCaption</DataField>
        </Field>
        <Field Name="NetChangeinJnlCaption">
          <DataField>NetChangeinJnlCaption</DataField>
        </Field>
        <Field Name="BalafterPostingCaption">
          <DataField>BalafterPostingCaption</DataField>
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
                  <Width>7.21536in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>4.74888in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1_Contents">
                          <ReportItems>
                            <Tablix Name="table2">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.74991in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.87476in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.76677in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.74991in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox77">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ReconciliationCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>22</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                            <ZIndex>21</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox79">
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
                                            <ZIndex>20</ZIndex>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox80">
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
                                            <ZIndex>19</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox811">
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
                                            <ZIndex>18</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox82">
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
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>16</ZIndex>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox84">
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
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox85">
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
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox86">
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
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox87">
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
                                            <ZIndex>12</ZIndex>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox88">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!NoCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox89">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!NameCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox90">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!NetChangeinJnlCaption.Value</Value>
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
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox912">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BalafterPostingCaption.Value</Value>
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
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox92">
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
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox94">
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
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox95">
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
                                            <ZIndex>4</ZIndex>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox73">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GLAccNetChangeNo.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox74">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GLAccNetChangeName.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox75">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GLAccNetChangeNetChangeJnl.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!GLAccNetChangeNetChangeJnlFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox76">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GLAccNetChangeBalafterPost.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!GLAccNetChangeBalafterPostFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
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
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF(Fields!ReconciliationCaption.Value&lt;&gt;"",False,True)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF(Fields!ReconciliationCaption.Value&lt;&gt;"",False,True)</Hidden>
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
                                    <Group Name="table2_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!JnlTmplName_GenJnlBatch.Value</GroupExpression>
                                        <GroupExpression>=Fields!Name_GenJnlBatch.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="table2_Details_Group">
                                          <DataElementName>Detail</DataElementName>
                                        </Group>
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
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!GLAccNetChangeNo.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>9.52409cm</Top>
                              <Height>2.53807cm</Height>
                              <Width>10.51903cm</Width>
                              <Visibility>
                                <Hidden>=IIF(Fields!GLAccNetChangeNo.Value&lt;&gt;"",False,True)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Tablix>
                            <Tablix Name="Table1">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.5315in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.62992in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.7874in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.3937in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.64961in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.62992in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.82677in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.27559in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.27559in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.27559in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.62492in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.31496in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.49994in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.49994in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox55">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!JnlTmplNameCaption_GenJnlBatch.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>124</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="textbox69">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!JnlTmplName_GenJnlBatch.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>123</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="textbox303">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>122</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox304">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>121</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox305">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>120</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox306">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>119</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox307">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>118</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox308">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>117</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox309">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>116</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox310">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>115</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox311">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>114</ZIndex>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox70">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!JournalBatchCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>113</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="textbox71">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Name_GenJnlBatch.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>112</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="textbox282">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>111</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox283">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>110</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox284">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>109</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox285">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>108</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox286">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>107</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox287">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>106</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox288">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>105</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox289">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>104</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox290">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>103</ZIndex>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox256">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>102</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox257">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>101</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox258">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>100</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox259">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>99</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox260">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>98</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox261">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>97</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox262">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>96</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox263">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>95</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox264">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>94</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox265">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>93</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox266">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>92</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox267">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>91</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox268">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>90</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox269">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>89</ZIndex>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox111">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GenJnlLineFilterTableCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>88</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>14</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox1</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox30">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox30</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox29">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox29</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox19">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox19</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox15">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox15</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox14">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox14</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox13">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox13</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox221">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>80</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox222">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>79</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox223">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>78</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox224">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>77</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox225">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>76</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox226">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>75</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox227">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>74</ZIndex>
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
                                  <TablixRow>
                                    <Height>0.38428in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox319">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!PostingDateCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>73</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox36">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!DocumentTypeCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>72</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox37">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!DocNoCaption_GenJnlLine.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>71</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox129">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AccountTypeCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>70</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox320">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AccNoCaption_GenJnlLine.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>69</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox321">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AccNameCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>68</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox322">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!DescCaption_GenJnlLine.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>67</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox323">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!PostingTypeCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>66</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox324">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!GenBusPostGroupCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>65</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox325">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!GenProdPostGroupCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>64</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox326">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AmountCaption_GenJnlLine.Value)</Value>
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
                                            <ZIndex>63</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox327">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>62</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox328">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!BalAccNoCaption_GenJnlLine.Value)</Value>
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
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox329">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!BalLCYCaption_GenJnlLine.Value)</Value>
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
                                            <ZIndex>60</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
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
                                          <Textbox Name="textbox9">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox9</rd:DefaultName>
                                            <ZIndex>59</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
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
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox10</rd:DefaultName>
                                            <ZIndex>58</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox16">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox16</rd:DefaultName>
                                            <ZIndex>57</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox17</rd:DefaultName>
                                            <ZIndex>56</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox18">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox18</rd:DefaultName>
                                            <ZIndex>55</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox20</rd:DefaultName>
                                            <ZIndex>54</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox21">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox21</rd:DefaultName>
                                            <ZIndex>53</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox22">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox22</rd:DefaultName>
                                            <ZIndex>52</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox23</rd:DefaultName>
                                            <ZIndex>51</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox24</rd:DefaultName>
                                            <ZIndex>50</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox25</rd:DefaultName>
                                            <ZIndex>49</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox26">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox26</rd:DefaultName>
                                            <ZIndex>48</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox27</rd:DefaultName>
                                            <ZIndex>47</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox28">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox28</rd:DefaultName>
                                            <ZIndex>46</ZIndex>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GenJournalLinePostingDate">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PostingDate_GenJnlLine.Value</Value>
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
                                            <ZIndex>45</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GenJournalLineDocumentType">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DocType_GenJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>44</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GenJournalLineDocumentNo">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DocNo_GenJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>43</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GenJournalLineAccountType">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AccountType_GenJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>42</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GenJournalLineAccountNo">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AccountNo_GenJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>41</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="AccName">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AccName.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>40</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GenJournalLineDescription">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description_GenJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>39</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GenJournalLineGenPostingType">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GenPostType_GenJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>38</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GenJournalLineGenBusPostingGroup">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GenBusPosGroup_GenJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>37</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GenJournalLineGenProdPostingGroup">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GenProdPostGroup_GenJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>36</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GenJournalLineAmount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Amount_GenJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Amount_GenJnlLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>35</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GenJournalLineCurrencyCode">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CurrencyCode_GenJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>34</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GenJournalLineBalAccountNo">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BalAccNo_GenJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>33</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GenJournalLineBalanceLCY">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BalanceLCY_GenJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!BalanceLCY_GenJnlLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>32</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
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
                                          <Textbox Name="textbox56">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimensionsCaption.Value</Value>
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
                                            <rd:DefaultName>textbox56</rd:DefaultName>
                                            <ZIndex>31</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="DimText">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText.Value</Value>
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
                                            <rd:DefaultName>DimText</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>12</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox172">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <ZIndex>29</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="DimText1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Normal</FontWeight>
                                                      <TextDecoration>None</TextDecoration>
                                                      <Color>#000000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>DimText1</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>12</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.33428in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox11">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox11</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="AccountNoCaption_GenJnlAllocation">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AccountNoCaption_GenJnlAllocation.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AccountNoCaption_GenJnlAllocation</rd:DefaultName>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="AccountName_GenJnlAllocation">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AccountNameCaption_GenJnlAllocation.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AccountName_GenJnlAllocation</rd:DefaultName>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="AllocationQuantity_GenJnlAllocation">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AllocationQuantityCaption_GenJnlAllocation.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AllocationQuantity_GenJnlAllocation</rd:DefaultName>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="Textbox43">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AllocationPctCaption_GenJnlAllocation.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox43</rd:DefaultName>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="Textbox46">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AmountCaption_GenJnlAllocation.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox46</rd:DefaultName>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                          <rd:Selected>true</rd:Selected>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox50">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>Textbox50</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="AccountNo_GenJnlAllocation">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AccountNo_GenJnlAllocation.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AccountNo_GenJnlAllocation</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="AccountName_GenJnlAllocation1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AccountName_GenJnlAllocation.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AccountName_GenJnlAllocation1</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="AllocationQuantity_GenJnlAllocation1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AllocationQuantity_GenJnlAllocation.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AllocationQuantity_GenJnlAllocation1</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="AllocationPct_GenJnlAllocation">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AllocationPct_GenJnlAllocation.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AllocationPct_GenJnlAllocation</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="Amount_GenJnlAllocation">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Amount_GenJnlAllocation.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Amount_GenJnlAllocation</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox31">
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
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox31</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="DimensionAllocationsCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimensionAllocationsCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>DimensionAllocationsCaption</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="AllocationDimText">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AllocationDimText.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AllocationDimText</rd:DefaultName>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>10</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox32">
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
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox32</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="AllocationDimText1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AllocationDimText.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AllocationDimText1</rd:DefaultName>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>10</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox151">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!WarningCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
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
                                          <Textbox Name="textbox153">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ErrorTextNumber.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.075cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>12</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox38">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox38</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox39">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox39</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox40">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox40</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox57">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox57</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox59</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox60</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox61">
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
                                            <rd:DefaultName>textbox61</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox63">
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
                                            <rd:DefaultName>textbox63</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox64">
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
                                            <rd:DefaultName>textbox64</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox65">
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
                                            <rd:DefaultName>textbox65</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox66">
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
                                            <rd:DefaultName>textbox66</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox67</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox68</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox3">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox3</rd:DefaultName>
                                            <ZIndex>27</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
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
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox4</rd:DefaultName>
                                            <ZIndex>26</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
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
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox5</rd:DefaultName>
                                            <ZIndex>25</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
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
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox6</rd:DefaultName>
                                            <ZIndex>24</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
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
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox7</rd:DefaultName>
                                            <ZIndex>23</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
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
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox8</rd:DefaultName>
                                            <ZIndex>22</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox152">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!TotalLCYCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!AmountLCY_GenJnlLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox152</rd:DefaultName>
                                            <ZIndex>21</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                          <Textbox Name="textbox156">
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
                                            <rd:DefaultName>textbox156</rd:DefaultName>
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox157">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=last(Fields!AmountLCY.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!AmountLCY_GenJnlLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox157</rd:DefaultName>
                                            <ZIndex>19</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox158">
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
                                            <rd:DefaultName>textbox158</rd:DefaultName>
                                            <ZIndex>18</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox159">
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
                                            <rd:DefaultName>textbox159</rd:DefaultName>
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox160">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!BalanceLCY.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!BalanceLCY_GenJnlLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox160</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
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
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
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
                                        <GroupExpression>=Fields!JnlTmplName_GenJnlLine.Value</GroupExpression>
                                        <GroupExpression>=Fields!JnlBatchName_GenJnlLine.Value</GroupExpression>
                                        <GroupExpression>=Fields!Name_GenJnlBatch.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!JnlTmplName_GenJnlLine.Value&lt;&gt;"",False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <RepeatOnNewPage>true</RepeatOnNewPage>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!Name_GenJnlBatch.Value&lt;&gt;"",False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <RepeatOnNewPage>true</RepeatOnNewPage>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <RepeatOnNewPage>true</RepeatOnNewPage>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!GenJnlLineFilter.Value&lt;&gt;"",False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <RepeatOnNewPage>true</RepeatOnNewPage>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <RepeatOnNewPage>true</RepeatOnNewPage>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <RepeatOnNewPage>true</RepeatOnNewPage>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <RepeatOnNewPage>true</RepeatOnNewPage>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Group Name="Table1_Details_Group">
                                          <DataElementName>Detail</DataElementName>
                                        </Group>
                                        <TablixMembers>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF((Previous(Last(Fields!LineNo_GenJnlLine.Value))=Fields!LineNo_GenJnlLine.Value)and(previous(Last(Fields!JnlBatchName_GenJnlLine.Value))=Fields!JnlBatchName_GenJnlLine.Value)and(previous(Last(Fields!JnlTmplName_GenJnlLine.Value))=Fields!JnlTmplName_GenJnlLine.Value),TRUE,FALSE)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!DimText.Value&lt;&gt;"" AND Fields!Number_DimensionLoop.Value = "1",False,True)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!DimText.Value&lt;&gt;"" AND Fields!Number_DimensionLoop.Value &gt; 1,False,True)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(Previous(Fields!AccountNoCaption_GenJnlAllocation.Value) = Fields!AccountNoCaption_GenJnlAllocation.Value OR NOT Fields!Recurring_GenJnlTemplate.Value,TRUE,FALSE)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(((Previous(Fields!JournalLineNo_GenJnlAllocation.Value) = Fields!JournalLineNo_GenJnlAllocation.Value) AND (Previous(Fields!LineNo_GenJnlAllocation.Value) = Fields!LineNo_GenJnlAllocation.Value) AND ((Previous(Fields!JournalBatchName_GenJnlAllocation.Value) = Fields!JournalBatchName_GenJnlAllocation.Value)) OR (NOT Fields!Recurring_GenJnlTemplate.Value)),True,False)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!AllocationDimText.Value&lt;&gt;"" AND Fields!Number_DimensionLoopAllocations.Value = "1",False,True)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!AllocationDimText.Value&lt;&gt;"" AND Fields!Number_DimensionLoopAllocations.Value &gt; 1,False,True)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!ErrorTextNumber.Value&lt;&gt;"",False,True)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                        </TablixMembers>
                                        <DataElementName>Detail_Collection</DataElementName>
                                        <DataElementOutput>Output</DataElementOutput>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!JnlTmplName_GenJnlLine.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                                <Filter>
                                  <FilterExpression>=Fields!Name_GenJnlBatch.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>0.31746cm</Top>
                              <Height>8.17032cm</Height>
                              <Width>18.32699cm</Width>
                              <ZIndex>1</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!LineNo_GenJnlLine.Value&lt;&gt;0,False,True)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Tablix>
                            <Textbox Name="NewPage">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=IIF(Code.IsNewPage(Fields!JnlTmplName_GenJnlBatch.Value,Fields!Name_GenJnlBatch.Value),TRUE,FALSE)</Value>
                                      <Style />
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Height>0.07937cm</Height>
                              <Width>17.46032cm</Width>
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
                      <GroupExpression>=Fields!JnlTemplateName_GenJnlBatch.Value</GroupExpression>
                      <GroupExpression>=Fields!JnlName_GenJnlBatch.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <PageBreak>
              <BreakLocation>End</BreakLocation>
            </PageBreak>
            <Filters>
              <Filter>
                <FilterExpression>=Fields!JnlTemplateName_GenJnlBatch.Value</FilterExpression>
                <Operator>GreaterThan</Operator>
                <FilterValues>
                  <FilterValue>=""</FilterValue>
                </FilterValues>
              </Filter>
              <Filter>
                <FilterExpression>=Fields!JnlName_GenJnlBatch.Value</FilterExpression>
                <Operator>GreaterThan</Operator>
                <FilterValues>
                  <FilterValue>=""</FilterValue>
                </FilterValues>
              </Filter>
            </Filters>
            <Height>12.06215cm</Height>
            <Width>18.32701cm</Width>
            <Style />
          </Tablix>
        </ReportItems>
        <Height>12.06216cm</Height>
        <Style />
      </Body>
      <Width>18.32752cm</Width>
      <Page>
        <PageHeader>
          <Height>1.26984cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="GeneralJournalTestCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!GeneralJnlTestCaption.Value</Value>
                      <Style>
                        <FontSize>8pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="COMPANYNAME13">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!CompanyName.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ExecutionTimeTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Globals!ExecutionTime</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Format>g</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>14.19022cm</Left>
              <Height>0.423cm</Height>
              <Width>4.1373cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="UserIdTextBox">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=User!UserID</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.846cm</Top>
              <Left>13.07752cm</Left>
              <Height>0.42384cm</Height>
              <Width>5.25cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox2">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>="Page "&amp;Code.GetGroupPageNumber(ReportItems!NewPage.Value,Globals!PageNumber)</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Left>15.77753cm</Left>
              <Height>0.423cm</Height>
              <Width>2.54999cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
          </ReportItems>
          <Style />
        </PageHeader>
        <PageHeight>29.7cm</PageHeight>
        <PageWidth>21cm</PageWidth>
        <InteractiveHeight>11in</InteractiveHeight>
        <InteractiveWidth>8.5in</InteractiveWidth>
        <LeftMargin>1.5cm</LeftMargin>
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

Shared offset as Integer
Shared newPage as Object 
Shared currentgroup1 as Object
Shared currentgroup2 as Object
Public Function GetGroupPageNumber(NewPage as Boolean, pagenumber as Integer) as Object
If NewPage
      offset = pagenumber  - 1
End If
  Return  pagenumber - offset
End Function

Public Function IsNewPage(group1 as Object, group2 as Object) As Boolean
newPage = FALSE
If Not (group1 = currentgroup1)
   NewPage = TRUE
   currentgroup2 = group2
   currentgroup1 = group1
ELSE
   If Not (group2 = currentgroup2)
      NewPage = TRUE
      currentgroup2 = group2
   End If
End If
Return NewPage
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>b1bc7310-cbfb-4276-96c7-f8e77bae4fba</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

