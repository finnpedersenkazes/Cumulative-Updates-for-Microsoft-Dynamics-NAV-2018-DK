OBJECT Report 20 Calc. and Post VAT Settlement
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Permissions=TableData 254=imd;
    CaptionML=[DAN=Afregn moms;
               ENU=Calc. and Post VAT Settlement];
    OnPreReport=BEGIN
                  IF PostingDate = 0D THEN
                    ERROR(Text000);
                  IF DocNo = '' THEN
                    ERROR(Text001);
                  IF GLAccSettle."No." = '' THEN
                    ERROR(Text002);
                  GLAccSettle.FIND;

                  IF PostSettlement AND NOT Initialized THEN
                    IF NOT CONFIRM(Text003,FALSE) THEN
                      CurrReport.QUIT;

                  VATPostingSetupFilter := "VAT Posting Setup".GETFILTERS;
                  IF EndDateReq = 0D THEN
                    VATEntry.SETFILTER("Posting Date",'%1..',EntrdStartDate)
                  ELSE
                    VATEntry.SETRANGE("Posting Date",EntrdStartDate,EndDateReq);
                  VATDateFilter := VATEntry.GETFILTER("Posting Date");
                  CLEAR(GenJnlPostLine);
                END;

  }
  DATASET
  {
    { 1756;    ;DataItem;                    ;
               DataItemTable=Table325;
               DataItemTableView=SORTING(VAT Bus. Posting Group,VAT Prod. Posting Group);
               OnPreDataItem=BEGIN
                               GLEntry.LOCKTABLE; // Avoid deadlock with function 12
                               IF GLEntry.FINDLAST THEN;
                               VATEntry.LOCKTABLE;
                               VATEntry.RESET;
                               IF VATEntry.FIND('+') THEN
                                 NextVATEntryNo := VATEntry."Entry No.";

                               SourceCodeSetup.GET;
                               GLSetup.GET;
                               VATAmount := 0;
                               VATAmountAddCurr := 0;

                               IF UseAmtsInAddCurr THEN
                                 HeaderText := STRSUBSTNO(AllAmountsAreInTxt,GLSetup."Additional Reporting Currency")
                               ELSE BEGIN
                                 GLSetup.TESTFIELD("LCY Code");
                                 HeaderText := STRSUBSTNO(AllAmountsAreInTxt,GLSetup."LCY Code");
                               END;
                             END;

               OnPostDataItem=BEGIN
                                // Post to settlement account
                                IF VATAmount <> 0 THEN BEGIN
                                  GenJnlLine.INIT;
                                  GenJnlLine."System-Created Entry" := TRUE;
                                  GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";

                                  GLAccSettle.TESTFIELD("Gen. Posting Type",GenJnlLine."Gen. Posting Type"::" ");
                                  GLAccSettle.TESTFIELD("VAT Bus. Posting Group",'');
                                  GLAccSettle.TESTFIELD("VAT Prod. Posting Group",'');
                                  IF VATPostingSetup.GET(GLAccSettle."VAT Bus. Posting Group",GLAccSettle."VAT Prod. Posting Group") THEN
                                    VATPostingSetup.TESTFIELD("VAT %",0);
                                  GLAccSettle.TESTFIELD("Gen. Bus. Posting Group",'');
                                  GLAccSettle.TESTFIELD("Gen. Prod. Posting Group",'');

                                  GenJnlLine.VALIDATE("Account No.",GLAccSettle."No.");
                                  GenJnlLine."Posting Date" := PostingDate;
                                  GenJnlLine."Document Type" := 0;
                                  GenJnlLine."Document No." := DocNo;
                                  GenJnlLine.Description := Text004;
                                  GenJnlLine.Amount := VATAmount;
                                  GenJnlLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
                                  GenJnlLine."Source Currency Amount" := VATAmountAddCurr;
                                  GenJnlLine."Source Code" := SourceCodeSetup."VAT Settlement";
                                  GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
                                  IF PostSettlement THEN
                                    PostGenJnlLine(GenJnlLine);
                                END;
                              END;

               ReqFilterFields=VAT Bus. Posting Group,VAT Prod. Posting Group }

    { 2   ;1   ;Column  ;TodayFormatted      ;
               SourceExpr=FORMAT(TODAY,0,4) }

    { 3   ;1   ;Column  ;PeriodVATDateFilter ;
               SourceExpr=STRSUBSTNO(Text005,VATDateFilter) }

    { 6   ;1   ;Column  ;CompanyName         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 77  ;1   ;Column  ;PostSettlement      ;
               SourceExpr=PostSettlement }

    { 10  ;1   ;Column  ;PostingDate         ;
               SourceExpr=FORMAT(PostingDate) }

    { 12  ;1   ;Column  ;DocNo               ;
               SourceExpr=DocNo }

    { 14  ;1   ;Column  ;GLAccSettleNo       ;
               SourceExpr=GLAccSettle."No." }

    { 78  ;1   ;Column  ;UseAmtsInAddCurr    ;
               SourceExpr=UseAmtsInAddCurr }

    { 79  ;1   ;Column  ;PrintVATEntries     ;
               SourceExpr=PrintVATEntries }

    { 15  ;1   ;Column  ;VATPostingSetupCaption;
               SourceExpr=TABLECAPTION + ': ' + VATPostingSetupFilter }

    { 76  ;1   ;Column  ;VATPostingSetupFilter;
               SourceExpr=VATPostingSetupFilter }

    { 75  ;1   ;Column  ;HeaderText          ;
               SourceExpr=HeaderText }

    { 37  ;1   ;Column  ;VATAmount           ;
               SourceExpr=VATAmount;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 66  ;1   ;Column  ;VATAmountAddCurr    ;
               SourceExpr=VATAmountAddCurr;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 1   ;1   ;Column  ;CalcandPostVATSettlementCaption;
               SourceExpr=CalcandPostVATSettlementCaptionLbl }

    { 4   ;1   ;Column  ;PageCaption         ;
               SourceExpr=PageCaptionLbl }

    { 8   ;1   ;Column  ;TestReportnotpostedCaption;
               SourceExpr=TestReportnotpostedCaptionLbl }

    { 11  ;1   ;Column  ;DocNoCaption        ;
               SourceExpr=DocNoCaptionLbl }

    { 13  ;1   ;Column  ;SettlementAccCaption;
               SourceExpr=SettlementAccCaptionLbl }

    { 18  ;1   ;Column  ;DocumentTypeCaption ;
               SourceExpr=DocumentTypeCaptionLbl }

    { 25  ;1   ;Column  ;UserIDCaption       ;
               SourceExpr=UserIDCaptionLbl }

    { 36  ;1   ;Column  ;TotalCaption        ;
               SourceExpr=TotalCaptionLbl }

    { 23  ;1   ;Column  ;DocumentNoCaption   ;
               SourceExpr="VAT Entry".FIELDCAPTION("Document No.") }

    { 22  ;1   ;Column  ;TypeCaption         ;
               SourceExpr="VAT Entry".FIELDCAPTION(Type) }

    { 21  ;1   ;Column  ;BaseCaption         ;
               SourceExpr="VAT Entry".FIELDCAPTION(Base) }

    { 20  ;1   ;Column  ;AmountCaption       ;
               SourceExpr="VAT Entry".FIELDCAPTION(Amount) }

    { 19  ;1   ;Column  ;UnrealizedBaseCaption;
               SourceExpr="VAT Entry".FIELDCAPTION("Unrealized Base") }

    { 17  ;1   ;Column  ;UnrealizedAmountCaption;
               SourceExpr="VAT Entry".FIELDCAPTION("Unrealized Amount") }

    { 16  ;1   ;Column  ;VATCalculationCaption;
               SourceExpr="VAT Entry".FIELDCAPTION("VAT Calculation Type") }

    { 7   ;1   ;Column  ;BilltoPaytoNoCaption;
               SourceExpr="VAT Entry".FIELDCAPTION("Bill-to/Pay-to No.") }

    { 5   ;1   ;Column  ;EntryNoCaption      ;
               SourceExpr="VAT Entry".FIELDCAPTION("Entry No.") }

    { 9   ;1   ;Column  ;PostingDateCaption  ;
               SourceExpr=PostingDateCaptionLbl }

    { 8188;1   ;DataItem;Closing G/L and VAT Entry;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               VATType := VATEntry.Type::Purchase;
                               FindFirstEntry := TRUE;
                             END;

               OnAfterGetRecord=BEGIN
                                  VATEntry.RESET;
                                  IF NOT
                                     VATEntry.SETCURRENTKEY(
                                       Type,Closed,"VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date")
                                  THEN
                                    VATEntry.SETCURRENTKEY(
                                      Type,Closed,"Tax Jurisdiction Code","Use Tax","Posting Date");
                                  VATEntry.SETRANGE(Type,VATType);
                                  VATEntry.SETRANGE(Closed,FALSE);
                                  VATEntry.SETFILTER("Posting Date",VATDateFilter);
                                  VATEntry.SETRANGE("VAT Bus. Posting Group","VAT Posting Setup"."VAT Bus. Posting Group");
                                  VATEntry.SETRANGE("VAT Prod. Posting Group","VAT Posting Setup"."VAT Prod. Posting Group");

                                  CASE "VAT Posting Setup"."VAT Calculation Type" OF
                                    "VAT Posting Setup"."VAT Calculation Type"::"Normal VAT",
                                    "VAT Posting Setup"."VAT Calculation Type"::"Reverse Charge VAT",
                                    "VAT Posting Setup"."VAT Calculation Type"::"Full VAT":
                                      BEGIN
                                        IF FindFirstEntry THEN BEGIN
                                          IF NOT VATEntry.FIND('-') THEN
                                            REPEAT
                                              VATType := VATType + 1;
                                              VATEntry.SETRANGE(Type,VATType);
                                            UNTIL (VATType = VATEntry.Type::Settlement) OR VATEntry.FIND('-');
                                          FindFirstEntry := FALSE;
                                        END ELSE BEGIN
                                          IF VATEntry.NEXT = 0 THEN
                                            REPEAT
                                              VATType := VATType + 1;
                                              VATEntry.SETRANGE(Type,VATType);
                                            UNTIL (VATType = VATEntry.Type::Settlement) OR VATEntry.FIND('-');
                                        END;
                                        IF VATType < VATEntry.Type::Settlement THEN
                                          VATEntry.FIND('+');
                                      END;
                                    "VAT Posting Setup"."VAT Calculation Type"::"Sales Tax":
                                      BEGIN
                                        IF FindFirstEntry THEN BEGIN
                                          IF NOT VATEntry.FIND('-') THEN
                                            REPEAT
                                              VATType := VATType + 1;
                                              VATEntry.SETRANGE(Type,VATType);
                                            UNTIL (VATType = VATEntry.Type::Settlement) OR VATEntry.FIND('-');
                                          FindFirstEntry := FALSE;
                                        END ELSE BEGIN
                                          VATEntry.SETRANGE("Tax Jurisdiction Code");
                                          VATEntry.SETRANGE("Use Tax");
                                          IF VATEntry.NEXT = 0 THEN
                                            REPEAT
                                              VATType := VATType + 1;
                                              VATEntry.SETRANGE(Type,VATType);
                                            UNTIL (VATType = VATEntry.Type::Settlement) OR VATEntry.FIND('-');
                                        END;
                                        IF VATType < VATEntry.Type::Settlement THEN BEGIN
                                          VATEntry.SETRANGE("Tax Jurisdiction Code",VATEntry."Tax Jurisdiction Code");
                                          VATEntry.SETRANGE("Use Tax",VATEntry."Use Tax");
                                          VATEntry.FIND('+');
                                        END;
                                      END;
                                  END;

                                  IF VATType = VATEntry.Type::Settlement THEN
                                    CurrReport.BREAK;
                                END;
                                 }

    { 26  ;2   ;Column  ;VATBusPstGr_VATPostSetup;
               SourceExpr="VAT Posting Setup"."VAT Bus. Posting Group" }

    { 27  ;2   ;Column  ;VATPrdPstGr_VATPostSetup;
               SourceExpr="VAT Posting Setup"."VAT Prod. Posting Group" }

    { 35  ;2   ;Column  ;VATEntryGetFilterType;
               SourceExpr=VATEntry.GETFILTER(Type) }

    { 52  ;2   ;Column  ;VATEntryGetFiltTaxJurisCd;
               SourceExpr=VATEntry.GETFILTER("Tax Jurisdiction Code") }

    { 53  ;2   ;Column  ;VATEntryGetFilterUseTax;
               SourceExpr=VATEntry.GETFILTER("Use Tax") }

    { 7612;2   ;DataItem;                    ;
               DataItemTable=Table254;
               DataItemTableView=SORTING(Type,Closed)
                                 WHERE(Closed=CONST(No),
                                       Type=FILTER(Purchase|Sale));
               OnPreDataItem=BEGIN
                               COPYFILTERS(VATEntry);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF NOT PrintVATEntries THEN
                                    CurrReport.SKIP;
                                END;
                                 }

    { 38  ;3   ;Column  ;PostingDate_VATEntry;
               SourceExpr=FORMAT("Posting Date") }

    { 39  ;3   ;Column  ;DocumentNo_VATEntry ;
               IncludeCaption=No;
               SourceExpr="Document No." }

    { 40  ;3   ;Column  ;DocumentType_VATEntry;
               SourceExpr="Document Type" }

    { 41  ;3   ;Column  ;Type_VATEntry       ;
               IncludeCaption=No;
               SourceExpr=Type }

    { 42  ;3   ;Column  ;Base_VATEntry       ;
               SourceExpr=Base;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 43  ;3   ;Column  ;Amount_VATEntry     ;
               SourceExpr=Amount;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 44  ;3   ;Column  ;VATCalcType_VATEntry;
               SourceExpr="VAT Calculation Type" }

    { 45  ;3   ;Column  ;BilltoPaytoNo_VATEntry;
               SourceExpr="Bill-to/Pay-to No." }

    { 46  ;3   ;Column  ;EntryNo_VATEntry    ;
               SourceExpr="Entry No." }

    { 47  ;3   ;Column  ;UserID_VATEntry     ;
               SourceExpr="User ID" }

    { 48  ;3   ;Column  ;UnrealizedAmount_VATEntry;
               SourceExpr="Unrealized Amount";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 50  ;3   ;Column  ;UnrealizedBase_VATEntry;
               SourceExpr="Unrealized Base";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 58  ;3   ;Column  ;AddCurrUnrlzdAmt_VATEntry;
               SourceExpr="Add.-Currency Unrealized Amt.";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 59  ;3   ;Column  ;AddCurrUnrlzdBas_VATEntry;
               SourceExpr="Add.-Currency Unrealized Base";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 60  ;3   ;Column  ;AdditionlCurrAmt_VATEntry;
               SourceExpr="Additional-Currency Amount";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 61  ;3   ;Column  ;AdditinlCurrBase_VATEntry;
               SourceExpr="Additional-Currency Base";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 3370;2   ;DataItem;Close VAT Entries   ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               MaxIteration=1;
               OnAfterGetRecord=BEGIN
                                  // Calculate amount and base
                                  VATEntry.CALCSUMS(
                                    Base,Amount,
                                    "Additional-Currency Base","Additional-Currency Amount");

                                  ReversingEntry := FALSE;
                                  // Balancing entries to VAT accounts
                                  CLEAR(GenJnlLine);
                                  GenJnlLine."System-Created Entry" := TRUE;
                                  GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                                  CASE VATType OF
                                    VATEntry.Type::Purchase:
                                      GenJnlLine.Description :=
                                        DELCHR(
                                          STRSUBSTNO(
                                            Text007,
                                            "VAT Posting Setup"."VAT Bus. Posting Group",
                                            "VAT Posting Setup"."VAT Prod. Posting Group"),
                                          '>');
                                    VATEntry.Type::Sale:
                                      GenJnlLine.Description :=
                                        DELCHR(
                                          STRSUBSTNO(
                                            Text008,
                                            "VAT Posting Setup"."VAT Bus. Posting Group",
                                            "VAT Posting Setup"."VAT Prod. Posting Group"),
                                          '>');
                                  END;
                                  GenJnlLine."VAT Bus. Posting Group" := "VAT Posting Setup"."VAT Bus. Posting Group";
                                  GenJnlLine."VAT Prod. Posting Group" := "VAT Posting Setup"."VAT Prod. Posting Group";
                                  GenJnlLine."VAT Calculation Type" := "VAT Posting Setup"."VAT Calculation Type";
                                  GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Settlement;
                                  GenJnlLine."Posting Date" := PostingDate;
                                  GenJnlLine."Document Type" := 0;
                                  GenJnlLine."Document No." := DocNo;
                                  GenJnlLine."Source Code" := SourceCodeSetup."VAT Settlement";
                                  GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
                                  CASE "VAT Posting Setup"."VAT Calculation Type" OF
                                    "VAT Posting Setup"."VAT Calculation Type"::"Normal VAT",
                                    "VAT Posting Setup"."VAT Calculation Type"::"Full VAT":
                                      BEGIN
                                        CASE VATType OF
                                          VATEntry.Type::Purchase:
                                            GenJnlLine."Account No." := "VAT Posting Setup".GetPurchAccount(FALSE);
                                          VATEntry.Type::Sale:
                                            GenJnlLine."Account No." := "VAT Posting Setup".GetSalesAccount(FALSE);
                                        END;
                                        CopyAmounts(GenJnlLine,VATEntry);
                                        IF PostSettlement THEN
                                          PostGenJnlLine(GenJnlLine);
                                        VATAmount := VATAmount + VATEntry.Amount;
                                        VATAmountAddCurr := VATAmountAddCurr + VATEntry."Additional-Currency Amount";
                                      END;
                                    "VAT Posting Setup"."VAT Calculation Type"::"Reverse Charge VAT":
                                      CASE VATType OF
                                        VATEntry.Type::Purchase:
                                          BEGIN
                                            GenJnlLine."Account No." := "VAT Posting Setup".GetRevChargeAccount(FALSE);
                                            CopyAmounts(GenJnlLine,VATEntry);
                                            IF PostSettlement THEN
                                              PostGenJnlLine(GenJnlLine);

                                            CreateGenJnlLine(GenJnlLine2,"VAT Posting Setup".GetRevChargeAccount(FALSE));
                                            IF PostSettlement THEN
                                              PostGenJnlLine(GenJnlLine2);
                                            ReversingEntry := TRUE;
                                          END;
                                        VATEntry.Type::Sale:
                                          BEGIN
                                            GenJnlLine."Account No." := "VAT Posting Setup".GetSalesAccount(FALSE);
                                            CopyAmounts(GenJnlLine,VATEntry);
                                            IF PostSettlement THEN
                                              PostGenJnlLine(GenJnlLine);
                                          END;
                                      END;
                                    "VAT Posting Setup"."VAT Calculation Type"::"Sales Tax":
                                      BEGIN
                                        TaxJurisdiction.GET(VATEntry."Tax Jurisdiction Code");
                                        GenJnlLine."Tax Area Code" := TaxJurisdiction.Code;
                                        GenJnlLine."Use Tax" := VATEntry."Use Tax";
                                        CASE VATType OF
                                          VATEntry.Type::Purchase:
                                            IF VATEntry."Use Tax" THEN BEGIN
                                              TaxJurisdiction.TESTFIELD("Tax Account (Purchases)");
                                              GenJnlLine."Account No." := TaxJurisdiction."Tax Account (Purchases)";
                                              CopyAmounts(GenJnlLine,VATEntry);
                                              IF PostSettlement THEN
                                                PostGenJnlLine(GenJnlLine);

                                              TaxJurisdiction.TESTFIELD("Reverse Charge (Purchases)");
                                              CreateGenJnlLine(GenJnlLine2,TaxJurisdiction."Reverse Charge (Purchases)");
                                              GenJnlLine2."Tax Area Code" := TaxJurisdiction.Code;
                                              GenJnlLine2."Use Tax" := VATEntry."Use Tax";
                                              IF PostSettlement THEN
                                                PostGenJnlLine(GenJnlLine2);
                                              ReversingEntry := TRUE;
                                            END ELSE BEGIN
                                              TaxJurisdiction.TESTFIELD("Tax Account (Purchases)");
                                              GenJnlLine."Account No." := TaxJurisdiction."Tax Account (Purchases)";
                                              CopyAmounts(GenJnlLine,VATEntry);
                                              IF PostSettlement THEN
                                                PostGenJnlLine(GenJnlLine);
                                              VATAmount := VATAmount + VATEntry.Amount;
                                              VATAmountAddCurr := VATAmountAddCurr + VATEntry."Additional-Currency Amount";
                                            END;
                                          VATEntry.Type::Sale:
                                            BEGIN
                                              TaxJurisdiction.TESTFIELD("Tax Account (Sales)");
                                              GenJnlLine."Account No." := TaxJurisdiction."Tax Account (Sales)";
                                              CopyAmounts(GenJnlLine,VATEntry);
                                              IF PostSettlement THEN
                                                PostGenJnlLine(GenJnlLine);
                                              VATAmount := VATAmount + VATEntry.Amount;
                                              VATAmountAddCurr := VATAmountAddCurr + VATEntry."Additional-Currency Amount";
                                            END;
                                        END;
                                      END;
                                  END;
                                  NextVATEntryNo := NextVATEntryNo + 1;

                                  // Close current VAT entries
                                  IF PostSettlement THEN BEGIN
                                    VATEntry.MODIFYALL("Closed by Entry No.",NextVATEntryNo);
                                    VATEntry.MODIFYALL(Closed,TRUE);
                                  END;
                                END;
                                 }

    { 28  ;3   ;Column  ;PostingDate1        ;
               SourceExpr=FORMAT(PostingDate) }

    { 29  ;3   ;Column  ;GenJnlLineDocumentNo;
               SourceExpr=GenJnlLine."Document No." }

    { 31  ;3   ;Column  ;GenJnlLineVATBaseAmount;
               SourceExpr=GenJnlLine."VAT Base Amount";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 32  ;3   ;Column  ;GenJnlLineVATAmount ;
               SourceExpr=GenJnlLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 33  ;3   ;Column  ;GenJnlLnVATCalcType ;
               SourceExpr=FORMAT(GenJnlLine."VAT Calculation Type") }

    { 34  ;3   ;Column  ;NextVATEntryNo      ;
               SourceExpr=NextVATEntryNo }

    { 70  ;3   ;Column  ;GenJnlLnSrcCurrVATAmount;
               SourceExpr=GenJnlLine."Source Curr. VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 71  ;3   ;Column  ;GenJnlLnSrcCurrVATBaseAmt;
               SourceExpr=GenJnlLine."Source Curr. VAT Base Amount";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 92  ;3   ;Column  ;GenJnlLine2Amount   ;
               SourceExpr=GenJnlLine2.Amount;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 95  ;3   ;Column  ;GenJnlLine2DocumentNo;
               SourceExpr=GenJnlLine2."Document No." }

    { 80  ;3   ;Column  ;ReversingEntry      ;
               SourceExpr=ReversingEntry }

    { 85  ;3   ;Column  ;GenJnlLn2SrcCurrencyAmt;
               SourceExpr=GenJnlLine2."Source Currency Amount";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrency }

    { 30  ;3   ;Column  ;SettlementCaption   ;
               SourceExpr=SettlementCaptionLbl }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      ShowFilter=No;
    }
    CONTROLS
    {
      { 10  ;0   ;Container ;
                  ContainerType=ContentArea }

      { 9   ;1   ;Group     ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  Name=StartingDate;
                  CaptionML=[DAN=Startdato;
                             ENU=Starting Date];
                  ToolTipML=[DAN=Angiver den f�rste dato i perioden, hvor der skal medtages momsposter i k�rslen.;
                             ENU=Specifies the first date in the period from which VAT entries are processed in the batch job.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=EntrdStartDate }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Slutdato;
                             ENU=Ending Date];
                  ToolTipML=[DAN=Angiver den sidste dato i perioden, hvor der skal medtages momsposter i k�rslen.;
                             ENU=Specifies the last date in the period from which VAT entries are processed in the batch job.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=EndDateReq }

      { 3   ;2   ;Field     ;
                  Name=PostingDt;
                  CaptionML=[DAN=Bogf�ringsdato;
                             ENU=Posting Date];
                  ToolTipML=[DAN=Angiver datoen for, hvorn�r overf�rslen til momskontoen skal bogf�res. Feltet skal udfyldes.;
                             ENU=Specifies the date on which the transfer to the VAT account is posted. This field must be filled in.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PostingDate }

      { 4   ;2   ;Field     ;
                  Name=DocumentNo;
                  CaptionML=[DAN=Bilagsnr.;
                             ENU=Document No.];
                  ToolTipML=[DAN=Angiver et bilagsnummer. Feltet skal udfyldes.;
                             ENU=Specifies a document number. This field must be filled in.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=DocNo }

      { 5   ;2   ;Field     ;
                  Name=SettlementAcc;
                  CaptionML=[DAN=Afregningskonto;
                             ENU=Settlement Account];
                  ToolTipML=[DAN=Angiver nummeret p� afregningskontomomsen. V�lg feltet for at se kontoplanen. Dette felt skal udfyldes.;
                             ENU=Specifies the number of the VAT settlement account. Select the field to see the chart of account. This field must be filled in.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=GLAccSettle."No.";
                  TableRelation="G/L Account";
                  OnValidate=BEGIN
                               IF GLAccSettle."No." <> '' THEN BEGIN
                                 GLAccSettle.FIND;
                                 GLAccSettle.CheckGLAcc;
                               END;
                             END;
                              }

      { 6   ;2   ;Field     ;
                  Name=ShowVATEntries;
                  CaptionML=[DAN=Vis momsposter;
                             ENU=Show VAT Entries];
                  ToolTipML=[DAN=Angiver, om den rapport, der udskrives efter k�rslen, skal indeholde de enkelte momsposter. Hvis du v�lger ikke at udskrive momsposterne, vises kun afregningsbel�bet for hver momsbogf�ringsgruppe.;
                             ENU=Specifies if you want the report that is printed during the batch job to contain the individual VAT entries. If you do not choose to print the VAT entries, the settlement amount is shown only for each VAT posting group.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintVATEntries }

      { 7   ;2   ;Field     ;
                  Name=Post;
                  CaptionML=[DAN=Bogf�r;
                             ENU=Post];
                  ToolTipML=[DAN=Angiver, om overf�rslen automatisk skal bogf�res p� momsafregningskontoen. Hvis du v�lger ikke at bogf�re overf�rslen, udskrives der kun en kontrolrapport med teksten: Kontroludskrift (er ikke bogf�rt).;
                             ENU=Specifies if you want the program to post the transfer to the VAT settlement account automatically. If you do not choose to post the transfer, the batch job only prints a test report, and Test Report (not Posted) appears on the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PostSettlement }

      { 8   ;2   ;Field     ;
                  Name=AmtsinAddReportingCurr;
                  CaptionML=[DAN=Vis bel�b i ekstra rapporteringsvaluta;
                             ENU=Show Amounts in Add. Reporting Currency];
                  ToolTipML=[DAN=Angiver, om de rapporterede bel�b vises i den ekstra rapporteringsvaluta.;
                             ENU=Specifies if the reported amounts are shown in the additional reporting currency.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=UseAmtsInAddCurr;
                  MultiLine=Yes }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Angiv bogf�ringsdatoen.;ENU=Enter the posting date.';
      Text001@1001 : TextConst 'DAN=Indtast bilagsnr.;ENU=Enter the document no.';
      Text002@1002 : TextConst 'DAN=Indtast afregningskonto.;ENU=Enter the settlement account.';
      Text003@1003 : TextConst 'DAN=Vil du afregne moms?;ENU=Do you want to calculate and post the VAT Settlement?';
      Text004@1004 : TextConst 'DAN=Momsafregning;ENU=VAT Settlement';
      Text005@1005 : TextConst 'DAN=Periode: %1;ENU=Period: %1';
      AllAmountsAreInTxt@1006 : TextConst '@@@="%1 = Currency Code";DAN=Alle bel�b er i %1.;ENU=All amounts are in %1.';
      Text007@1007 : TextConst 'DAN=Afregning af k�bsmoms:   #1######## #2########;ENU=Purchase VAT settlement: #1######## #2########';
      Text008@1008 : TextConst 'DAN=Afregning af salgsmoms:  #1######## #2########;ENU=Sales VAT settlement  : #1######## #2########';
      GLAccSettle@1009 : Record 15;
      SourceCodeSetup@1010 : Record 242;
      GenJnlLine@1011 : Record 81;
      GenJnlLine2@1012 : Record 81;
      GLEntry@1013 : Record 17;
      VATEntry@1014 : Record 254;
      TaxJurisdiction@1016 : Record 320;
      GLSetup@1017 : Record 98;
      VATPostingSetup@1018 : Record 325;
      GenJnlPostLine@1019 : Codeunit 12;
      EntrdStartDate@1020 : Date;
      EndDateReq@1021 : Date;
      PrintVATEntries@1022 : Boolean;
      NextVATEntryNo@1023 : Integer;
      PostingDate@1024 : Date;
      DocNo@1025 : Code[20];
      VATType@1026 : Integer;
      VATAmount@1027 : Decimal;
      VATAmountAddCurr@1028 : Decimal;
      PostSettlement@1029 : Boolean;
      FindFirstEntry@1030 : Boolean;
      ReversingEntry@1031 : Boolean;
      Initialized@1032 : Boolean;
      VATPostingSetupFilter@1033 : Text;
      VATDateFilter@1034 : Text;
      UseAmtsInAddCurr@1035 : Boolean;
      HeaderText@1036 : Text[30];
      CalcandPostVATSettlementCaptionLbl@1384 : TextConst 'DAN=Afregn moms;ENU=Calc. and Post VAT Settlement';
      PageCaptionLbl@6215 : TextConst 'DAN=Side;ENU=Page';
      TestReportnotpostedCaptionLbl@4405 : TextConst 'DAN=Testrapport (ikke bogf�rt);ENU=Test Report (Not Posted)';
      DocNoCaptionLbl@2117 : TextConst 'DAN=Bilagsnr.;ENU=Document No.';
      SettlementAccCaptionLbl@4332 : TextConst 'DAN=Afregningskonto;ENU=Settlement Account';
      DocumentTypeCaptionLbl@5905 : TextConst 'DAN=Bilagstype;ENU=Document Type';
      UserIDCaptionLbl@6950 : TextConst 'DAN=Bruger-id;ENU=User ID';
      TotalCaptionLbl@1909 : TextConst 'DAN=I alt;ENU=Total';
      PostingDateCaptionLbl@4591 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      SettlementCaptionLbl@6937 : TextConst 'DAN=Afregning;ENU=Settlement';

    PROCEDURE InitializeRequest@1(NewStartDate@1000 : Date;NewEndDate@1001 : Date;NewPostingDate@1002 : Date;NewDocNo@1003 : Code[20];NewSettlementAcc@1004 : Code[20];ShowVATEntries@1005 : Boolean;Post@1006 : Boolean);
    BEGIN
      EntrdStartDate := NewStartDate;
      EndDateReq := NewEndDate;
      PostingDate := NewPostingDate;
      DocNo := NewDocNo;
      GLAccSettle."No." := NewSettlementAcc;
      PrintVATEntries := ShowVATEntries;
      PostSettlement := Post;
      Initialized := TRUE;
    END;

    PROCEDURE InitializeRequest2@5(NewUseAmtsInAddCurr@1007 : Boolean);
    BEGIN
      UseAmtsInAddCurr := NewUseAmtsInAddCurr;
    END;

    LOCAL PROCEDURE GetCurrency@2() : Code[10];
    BEGIN
      IF UseAmtsInAddCurr THEN
        EXIT(GLSetup."Additional Reporting Currency");

      EXIT('');
    END;

    LOCAL PROCEDURE PostGenJnlLine@3(VAR GenJnlLine@1000 : Record 81);
    VAR
      DimMgt@1001 : Codeunit 408;
      TableID@1004 : ARRAY [10] OF Integer;
      No@1003 : ARRAY [10] OF Code[20];
    BEGIN
      TableID[1] := DATABASE::"G/L Account";
      TableID[2] := DATABASE::"G/L Account";
      No[1] := GenJnlLine."Account No.";
      No[2] := GenJnlLine."Bal. Account No.";
      GenJnlLine."Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          GenJnlLine,0,TableID,No,GenJnlLine."Source Code",
          GenJnlLine."Shortcut Dimension 1 Code",GenJnlLine."Shortcut Dimension 2 Code",0,0);
      GenJnlPostLine.RUN(GenJnlLine);
    END;

    PROCEDURE SetInitialized@4(Initialize@1000 : Boolean);
    BEGIN
      Initialized := Initialize;
    END;

    LOCAL PROCEDURE CopyAmounts@6(VAR GenJournalLine@1000 : Record 81;VATEntry@1001 : Record 254);
    BEGIN
      WITH GenJournalLine DO BEGIN
        Amount := -VATEntry.Amount;
        "VAT Amount" := -VATEntry.Amount;
        "VAT Base Amount" := -VATEntry.Base;
        "Source Currency Code" := GLSetup."Additional Reporting Currency";
        "Source Currency Amount" := -VATEntry."Additional-Currency Amount";
        "Source Curr. VAT Amount" := -VATEntry."Additional-Currency Amount";
        "Source Curr. VAT Base Amount" := -VATEntry."Additional-Currency Base";
      END;
    END;

    LOCAL PROCEDURE CreateGenJnlLine@7(VAR GenJnlLine2@1000 : Record 81;AccountNo@1002 : Code[20]);
    BEGIN
      CLEAR(GenJnlLine2);
      GenJnlLine2."System-Created Entry" := TRUE;
      GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
      GenJnlLine2.Description := GenJnlLine.Description;
      GenJnlLine2."Posting Date" := PostingDate;
      GenJnlLine2."Document Type" := 0;
      GenJnlLine2."Document No." := DocNo;
      GenJnlLine2."Source Code" := SourceCodeSetup."VAT Settlement";
      GenJnlLine2."VAT Posting" := GenJnlLine2."VAT Posting"::"Manual VAT Entry";
      GenJnlLine2."Account No." := AccountNo;
      GenJnlLine2.Amount := VATEntry.Amount;
      GenJnlLine2."Source Currency Code" := GLSetup."Additional Reporting Currency";
      GenJnlLine2."Source Currency Amount" := VATEntry."Additional-Currency Amount";
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
      <rd:DataSourceID>c10159d7-2406-45f3-96c3-f67e08bab49f</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="TodayFormatted">
          <DataField>TodayFormatted</DataField>
        </Field>
        <Field Name="PeriodVATDateFilter">
          <DataField>PeriodVATDateFilter</DataField>
        </Field>
        <Field Name="CompanyName">
          <DataField>CompanyName</DataField>
        </Field>
        <Field Name="PostSettlement">
          <DataField>PostSettlement</DataField>
        </Field>
        <Field Name="PostingDate">
          <DataField>PostingDate</DataField>
        </Field>
        <Field Name="DocNo">
          <DataField>DocNo</DataField>
        </Field>
        <Field Name="GLAccSettleNo">
          <DataField>GLAccSettleNo</DataField>
        </Field>
        <Field Name="UseAmtsInAddCurr">
          <DataField>UseAmtsInAddCurr</DataField>
        </Field>
        <Field Name="PrintVATEntries">
          <DataField>PrintVATEntries</DataField>
        </Field>
        <Field Name="VATPostingSetupCaption">
          <DataField>VATPostingSetupCaption</DataField>
        </Field>
        <Field Name="VATPostingSetupFilter">
          <DataField>VATPostingSetupFilter</DataField>
        </Field>
        <Field Name="HeaderText">
          <DataField>HeaderText</DataField>
        </Field>
        <Field Name="VATAmount">
          <DataField>VATAmount</DataField>
        </Field>
        <Field Name="VATAmountFormat">
          <DataField>VATAmountFormat</DataField>
        </Field>
        <Field Name="VATAmountAddCurr">
          <DataField>VATAmountAddCurr</DataField>
        </Field>
        <Field Name="VATAmountAddCurrFormat">
          <DataField>VATAmountAddCurrFormat</DataField>
        </Field>
        <Field Name="CalcandPostVATSettlementCaption">
          <DataField>CalcandPostVATSettlementCaption</DataField>
        </Field>
        <Field Name="PageCaption">
          <DataField>PageCaption</DataField>
        </Field>
        <Field Name="TestReportnotpostedCaption">
          <DataField>TestReportnotpostedCaption</DataField>
        </Field>
        <Field Name="DocNoCaption">
          <DataField>DocNoCaption</DataField>
        </Field>
        <Field Name="SettlementAccCaption">
          <DataField>SettlementAccCaption</DataField>
        </Field>
        <Field Name="DocumentTypeCaption">
          <DataField>DocumentTypeCaption</DataField>
        </Field>
        <Field Name="UserIDCaption">
          <DataField>UserIDCaption</DataField>
        </Field>
        <Field Name="TotalCaption">
          <DataField>TotalCaption</DataField>
        </Field>
        <Field Name="DocumentNoCaption">
          <DataField>DocumentNoCaption</DataField>
        </Field>
        <Field Name="TypeCaption">
          <DataField>TypeCaption</DataField>
        </Field>
        <Field Name="BaseCaption">
          <DataField>BaseCaption</DataField>
        </Field>
        <Field Name="AmountCaption">
          <DataField>AmountCaption</DataField>
        </Field>
        <Field Name="UnrealizedBaseCaption">
          <DataField>UnrealizedBaseCaption</DataField>
        </Field>
        <Field Name="UnrealizedAmountCaption">
          <DataField>UnrealizedAmountCaption</DataField>
        </Field>
        <Field Name="VATCalculationCaption">
          <DataField>VATCalculationCaption</DataField>
        </Field>
        <Field Name="BilltoPaytoNoCaption">
          <DataField>BilltoPaytoNoCaption</DataField>
        </Field>
        <Field Name="EntryNoCaption">
          <DataField>EntryNoCaption</DataField>
        </Field>
        <Field Name="PostingDateCaption">
          <DataField>PostingDateCaption</DataField>
        </Field>
        <Field Name="VATBusPstGr_VATPostSetup">
          <DataField>VATBusPstGr_VATPostSetup</DataField>
        </Field>
        <Field Name="VATPrdPstGr_VATPostSetup">
          <DataField>VATPrdPstGr_VATPostSetup</DataField>
        </Field>
        <Field Name="VATEntryGetFilterType">
          <DataField>VATEntryGetFilterType</DataField>
        </Field>
        <Field Name="VATEntryGetFiltTaxJurisCd">
          <DataField>VATEntryGetFiltTaxJurisCd</DataField>
        </Field>
        <Field Name="VATEntryGetFilterUseTax">
          <DataField>VATEntryGetFilterUseTax</DataField>
        </Field>
        <Field Name="PostingDate_VATEntry">
          <DataField>PostingDate_VATEntry</DataField>
        </Field>
        <Field Name="DocumentNo_VATEntry">
          <DataField>DocumentNo_VATEntry</DataField>
        </Field>
        <Field Name="DocumentType_VATEntry">
          <DataField>DocumentType_VATEntry</DataField>
        </Field>
        <Field Name="Type_VATEntry">
          <DataField>Type_VATEntry</DataField>
        </Field>
        <Field Name="Base_VATEntry">
          <DataField>Base_VATEntry</DataField>
        </Field>
        <Field Name="Base_VATEntryFormat">
          <DataField>Base_VATEntryFormat</DataField>
        </Field>
        <Field Name="Amount_VATEntry">
          <DataField>Amount_VATEntry</DataField>
        </Field>
        <Field Name="Amount_VATEntryFormat">
          <DataField>Amount_VATEntryFormat</DataField>
        </Field>
        <Field Name="VATCalcType_VATEntry">
          <DataField>VATCalcType_VATEntry</DataField>
        </Field>
        <Field Name="BilltoPaytoNo_VATEntry">
          <DataField>BilltoPaytoNo_VATEntry</DataField>
        </Field>
        <Field Name="EntryNo_VATEntry">
          <DataField>EntryNo_VATEntry</DataField>
        </Field>
        <Field Name="UserID_VATEntry">
          <DataField>UserID_VATEntry</DataField>
        </Field>
        <Field Name="UnrealizedAmount_VATEntry">
          <DataField>UnrealizedAmount_VATEntry</DataField>
        </Field>
        <Field Name="UnrealizedAmount_VATEntryFormat">
          <DataField>UnrealizedAmount_VATEntryFormat</DataField>
        </Field>
        <Field Name="UnrealizedBase_VATEntry">
          <DataField>UnrealizedBase_VATEntry</DataField>
        </Field>
        <Field Name="UnrealizedBase_VATEntryFormat">
          <DataField>UnrealizedBase_VATEntryFormat</DataField>
        </Field>
        <Field Name="AddCurrUnrlzdAmt_VATEntry">
          <DataField>AddCurrUnrlzdAmt_VATEntry</DataField>
        </Field>
        <Field Name="AddCurrUnrlzdAmt_VATEntryFormat">
          <DataField>AddCurrUnrlzdAmt_VATEntryFormat</DataField>
        </Field>
        <Field Name="AddCurrUnrlzdBas_VATEntry">
          <DataField>AddCurrUnrlzdBas_VATEntry</DataField>
        </Field>
        <Field Name="AddCurrUnrlzdBas_VATEntryFormat">
          <DataField>AddCurrUnrlzdBas_VATEntryFormat</DataField>
        </Field>
        <Field Name="AdditionlCurrAmt_VATEntry">
          <DataField>AdditionlCurrAmt_VATEntry</DataField>
        </Field>
        <Field Name="AdditionlCurrAmt_VATEntryFormat">
          <DataField>AdditionlCurrAmt_VATEntryFormat</DataField>
        </Field>
        <Field Name="AdditinlCurrBase_VATEntry">
          <DataField>AdditinlCurrBase_VATEntry</DataField>
        </Field>
        <Field Name="AdditinlCurrBase_VATEntryFormat">
          <DataField>AdditinlCurrBase_VATEntryFormat</DataField>
        </Field>
        <Field Name="PostingDate1">
          <DataField>PostingDate1</DataField>
        </Field>
        <Field Name="GenJnlLineDocumentNo">
          <DataField>GenJnlLineDocumentNo</DataField>
        </Field>
        <Field Name="GenJnlLineVATBaseAmount">
          <DataField>GenJnlLineVATBaseAmount</DataField>
        </Field>
        <Field Name="GenJnlLineVATBaseAmountFormat">
          <DataField>GenJnlLineVATBaseAmountFormat</DataField>
        </Field>
        <Field Name="GenJnlLineVATAmount">
          <DataField>GenJnlLineVATAmount</DataField>
        </Field>
        <Field Name="GenJnlLineVATAmountFormat">
          <DataField>GenJnlLineVATAmountFormat</DataField>
        </Field>
        <Field Name="GenJnlLnVATCalcType">
          <DataField>GenJnlLnVATCalcType</DataField>
        </Field>
        <Field Name="NextVATEntryNo">
          <DataField>NextVATEntryNo</DataField>
        </Field>
        <Field Name="GenJnlLnSrcCurrVATAmount">
          <DataField>GenJnlLnSrcCurrVATAmount</DataField>
        </Field>
        <Field Name="GenJnlLnSrcCurrVATAmountFormat">
          <DataField>GenJnlLnSrcCurrVATAmountFormat</DataField>
        </Field>
        <Field Name="GenJnlLnSrcCurrVATBaseAmt">
          <DataField>GenJnlLnSrcCurrVATBaseAmt</DataField>
        </Field>
        <Field Name="GenJnlLnSrcCurrVATBaseAmtFormat">
          <DataField>GenJnlLnSrcCurrVATBaseAmtFormat</DataField>
        </Field>
        <Field Name="GenJnlLine2Amount">
          <DataField>GenJnlLine2Amount</DataField>
        </Field>
        <Field Name="GenJnlLine2AmountFormat">
          <DataField>GenJnlLine2AmountFormat</DataField>
        </Field>
        <Field Name="GenJnlLine2DocumentNo">
          <DataField>GenJnlLine2DocumentNo</DataField>
        </Field>
        <Field Name="ReversingEntry">
          <DataField>ReversingEntry</DataField>
        </Field>
        <Field Name="GenJnlLn2SrcCurrencyAmt">
          <DataField>GenJnlLn2SrcCurrencyAmt</DataField>
        </Field>
        <Field Name="GenJnlLn2SrcCurrencyAmtFormat">
          <DataField>GenJnlLn2SrcCurrencyAmtFormat</DataField>
        </Field>
        <Field Name="SettlementCaption">
          <DataField>SettlementCaption</DataField>
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
          <Textbox Name="TestReportnotpostedCaption">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!TestReportnotpostedCaption.Value)</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                      <FontWeight>Bold</FontWeight>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Height>0.423cm</Height>
            <Width>7.5cm</Width>
            <Visibility>
              <Hidden>=IIF(Fields!PostSettlement.Value=TRUE,TRUE,FALSE)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Tablix Name="Table1">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>0.72878in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.61982in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.18567in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.18567in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.70866in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.70866in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.70866in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.70866in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.5in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.16604in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.557in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.34039in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.37495in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VATEntryPostingDateCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDateCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>125</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VATEntryDocumentNoCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!DocumentNoCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>124</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VATEntryDocumentTypeCaption">
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
                          <ZIndex>123</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VATEntryTypeCaption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!TypeCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>122</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VATEntryBaseCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!BaseCaption.Value)</Value>
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
                          <ZIndex>121</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VATEntryAmountCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!AmountCaption.Value)</Value>
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
                          <ZIndex>120</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VATEntryUnrealizedBaseCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!UnrealizedBaseCaption.Value)</Value>
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
                          <ZIndex>119</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VATEntryUnrealizedAmountCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!UnrealizedAmountCaption.Value)</Value>
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
                          <ZIndex>118</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VATEntryVATCalculationTypeCaption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!VATCalculationCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>117</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VATEntryBilltoPaytoNoCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!BilltoPaytoNoCaption.Value)</Value>
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
                          <ZIndex>116</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VATEntryEntryNoCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!EntryNoCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>115</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VATEntryUserIDCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!UserIDCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>114</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
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
                        <Textbox Name="VATPostingSetupVATBusPostingGroup">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VATBusPstGr_VATPostSetup.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>VATPostingSetupVATBusPostingGroup1</rd:DefaultName>
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
                        <Textbox Name="VATPostingSetupVATProdPostingGroup">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VATPrdPstGr_VATPostSetup.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>VATPostingSetupVATProdPostingGroup1</rd:DefaultName>
                          <ZIndex>100</ZIndex>
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
                        <Textbox Name="VATEntryGETFILTERType">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!VATEntryGetFilterType.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>VATEntryGETFILTERType</rd:DefaultName>
                          <ZIndex>99</ZIndex>
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
                        <Textbox Name="VATEntryGETFILTERTaxJurisdictionCode">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!VATEntryGetFiltTaxJurisCd.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>VATEntryGETFILTERTaxJurisdictionCode</rd:DefaultName>
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
                        <Textbox Name="VATEntryGETFILTERUseTax">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!VATEntryGetFilterUseTax.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>VATEntryGETFILTERUseTax</rd:DefaultName>
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
                        <Textbox Name="textbox9">
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox9</rd:DefaultName>
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
                        <Textbox Name="textbox10">
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox10</rd:DefaultName>
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
                        <Textbox Name="textbox20">
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox20</rd:DefaultName>
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
                        <Textbox Name="textbox211">
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox21</rd:DefaultName>
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
                        <Textbox Name="textbox22">
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox22</rd:DefaultName>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VATEntryPostingDate">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDate_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>91</ZIndex>
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
                        <Textbox Name="VATEntryDocumentNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocumentNo_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>90</ZIndex>
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
                        <Textbox Name="VATEntryDocumentType">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocumentType_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>89</ZIndex>
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
                        <Textbox Name="VATEntryType">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Type_VATEntry.Value</Value>
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
                        <Textbox Name="VATEntryBase">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Base_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!Base_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>87</ZIndex>
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
                        <Textbox Name="VATEntryAmount">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Amount_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!Amount_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>86</ZIndex>
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
                        <Textbox Name="VATEntryUnrealizedBase">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!UnrealizedBase_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!UnrealizedBase_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>85</ZIndex>
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
                        <Textbox Name="VATEntryUnrealizedAmount">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!UnrealizedAmount_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!UnrealizedAmount_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>84</ZIndex>
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
                        <Textbox Name="VATEntryVATCalculationType">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VATCalcType_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>83</ZIndex>
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
                        <Textbox Name="VATEntryBilltoPaytoNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BilltoPaytoNo_VATEntry.Value</Value>
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
                          <ZIndex>82</ZIndex>
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
                        <Textbox Name="VATEntryEntryNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EntryNo_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>81</ZIndex>
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
                        <Textbox Name="VATEntryUserID">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!UserID_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>80</ZIndex>
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
                        <Textbox Name="VATEntryPostingDateControl65">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDate_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>79</ZIndex>
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
                        <Textbox Name="VATEntryDocumentNoControl64">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocumentNo_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>78</ZIndex>
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
                        <Textbox Name="VATEntryDocumentTypeControl63">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocumentType_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>77</ZIndex>
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
                        <Textbox Name="VATEntryTypeControl62">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Type_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>76</ZIndex>
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
                        <Textbox Name="VATEntryAdditionalCurrencyBase">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AdditinlCurrBase_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AdditinlCurrBase_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>75</ZIndex>
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
                        <Textbox Name="VATEntryAdditionalCurrencyAmount">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AdditionlCurrAmt_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AdditionlCurrAmt_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>74</ZIndex>
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
                        <Textbox Name="VATEntryAddCurrencyUnrealizedBase">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AddCurrUnrlzdBas_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AddCurrUnrlzdBas_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>73</ZIndex>
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
                        <Textbox Name="VATEntryAddCurrencyUnrealizedAmt">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AddCurrUnrlzdAmt_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AddCurrUnrlzdAmt_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>72</ZIndex>
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
                        <Textbox Name="VATEntryVATCalculationTypeControl57">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VATCalcType_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>71</ZIndex>
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
                        <Textbox Name="VATEntryBilltoPaytoNoControl56">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BilltoPaytoNo_VATEntry.Value</Value>
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
                          <ZIndex>70</ZIndex>
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
                        <Textbox Name="VATEntryEntryNoControl55">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EntryNo_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>69</ZIndex>
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
                        <Textbox Name="VATEntryUserIDControl54">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!UserID_VATEntry.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>68</ZIndex>
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
                        <Textbox Name="PostingDate1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDate.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>PostingDate_1</rd:DefaultName>
                          <ZIndex>67</ZIndex>
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
                        <Textbox Name="GenJnlLineDocumentNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!GenJnlLineDocumentNo.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>GenJnlLineDocumentNo</rd:DefaultName>
                          <ZIndex>66</ZIndex>
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
                        <Textbox Name="textbox23">
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
                          <rd:DefaultName>textbox23</rd:DefaultName>
                          <ZIndex>65</ZIndex>
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
                                  <Value>=Fields!SettlementCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox27</rd:DefaultName>
                          <ZIndex>64</ZIndex>
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
                        <Textbox Name="GenJnlLineVATBaseAmount">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!GenJnlLineVATBaseAmount.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!GenJnlLineVATBaseAmountFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>GenJnlLineVATBaseAmount</rd:DefaultName>
                          <ZIndex>63</ZIndex>
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
                        <Textbox Name="GenJnlLineVATAmount">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!GenJnlLineVATAmount.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!GenJnlLineVATAmountFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>GenJnlLineVATAmount</rd:DefaultName>
                          <ZIndex>62</ZIndex>
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
                        <Textbox Name="textbox60">
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
                                    <Format>=Fields!AddCurrUnrlzdBas_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox60</rd:DefaultName>
                          <ZIndex>61</ZIndex>
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
                        <Textbox Name="textbox61">
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
                                    <Format>=Fields!AddCurrUnrlzdAmt_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox61</rd:DefaultName>
                          <ZIndex>60</ZIndex>
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
                        <Textbox Name="FORMATGenJnlLineVATCalculationType">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!GenJnlLnVATCalcType.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>FORMATGenJnlLineVATCalculationType</rd:DefaultName>
                          <ZIndex>59</ZIndex>
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox63</rd:DefaultName>
                          <ZIndex>58</ZIndex>
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
                        <Textbox Name="NextVATEntryNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!NextVATEntryNo.Value</Value>
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
                          <rd:DefaultName>NextVATEntryNo</rd:DefaultName>
                          <ZIndex>57</ZIndex>
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
                          <ZIndex>56</ZIndex>
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
                        <Textbox Name="textbox80">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDate.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>55</ZIndex>
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
                        <Textbox Name="textbox54">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!GenJnlLineDocumentNo.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>54</ZIndex>
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
                        <Textbox Name="textbox35">
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
                          <rd:DefaultName>textbox35</rd:DefaultName>
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
                        <Textbox Name="textbox26">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!SettlementCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox26</rd:DefaultName>
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
                        <Textbox Name="GenJnlLineSourceCurrVATBaseAmount">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!GenJnlLnSrcCurrVATBaseAmt.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!GenJnlLnSrcCurrVATBaseAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>GenJnlLineSourceCurrVATBaseAmount</rd:DefaultName>
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
                        <Textbox Name="GenJnlLineSourceCurrVATAmount">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!GenJnlLnSrcCurrVATAmount.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!GenJnlLnSrcCurrVATAmountFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>GenJnlLineSourceCurrVATAmount</rd:DefaultName>
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
                        <Textbox Name="textbox70">
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
                                    <Format>=Fields!AddCurrUnrlzdBas_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox70</rd:DefaultName>
                          <ZIndex>49</ZIndex>
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
                        <Textbox Name="textbox712">
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
                                    <Format>=Fields!AddCurrUnrlzdAmt_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox71</rd:DefaultName>
                          <ZIndex>48</ZIndex>
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
                        <Textbox Name="textbox57">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!GenJnlLnVATCalcType.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>47</ZIndex>
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
                        <Textbox Name="textbox73">
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
                          <rd:DefaultName>textbox73</rd:DefaultName>
                          <ZIndex>46</ZIndex>
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
                        <Textbox Name="NextVATEntryNo1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!NextVATEntryNo.Value</Value>
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
                          <rd:DefaultName>NextVATEntryNo_1</rd:DefaultName>
                          <ZIndex>45</ZIndex>
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
                          <ZIndex>44</ZIndex>
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
                        <Textbox Name="PostingDateControl28">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDate1.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>PostingDateControl28</rd:DefaultName>
                          <ZIndex>43</ZIndex>
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
                        <Textbox Name="GenJnlLine2DocumentNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!GenJnlLine2DocumentNo.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>GenJnlLine2DocumentNo</rd:DefaultName>
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
                        <Textbox Name="textbox36">
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
                          <rd:DefaultName>textbox36</rd:DefaultName>
                          <ZIndex>41</ZIndex>
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
                        <Textbox Name="textbox30">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!SettlementCaption.Value</Value>
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
                          <ZIndex>40</ZIndex>
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox58</rd:DefaultName>
                          <ZIndex>39</ZIndex>
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
                        <Textbox Name="GenJnlLine2Amount">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!GenJnlLine2Amount.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!GenJnlLine2AmountFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>GenJnlLine2Amount</rd:DefaultName>
                          <ZIndex>38</ZIndex>
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
                                    <Format>=Fields!AddCurrUnrlzdBas_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox83</rd:DefaultName>
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
                                    <Format>=Fields!AddCurrUnrlzdAmt_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox84</rd:DefaultName>
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
                          <rd:DefaultName>textbox85</rd:DefaultName>
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox86</rd:DefaultName>
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
                          <rd:DefaultName>textbox87</rd:DefaultName>
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
                        <Textbox Name="textbox88">
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
                          <rd:DefaultName>textbox88</rd:DefaultName>
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
                        <Textbox Name="textbox55">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDate1.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>11</ZIndex>
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
                        <Textbox Name="textbox56">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!GenJnlLine2DocumentNo.Value</Value>
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
                          <rd:DefaultName>textbox95</rd:DefaultName>
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
                        <Textbox Name="textbox313">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!SettlementCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox31</rd:DefaultName>
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
                        <Textbox Name="textbox97">
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
                          <rd:DefaultName>textbox97</rd:DefaultName>
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
                        <Textbox Name="textbox98">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!GenJnlLn2SrcCurrencyAmt.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!GenJnlLn2SrcCurrencyAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox98</rd:DefaultName>
                          <ZIndex>6</ZIndex>
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
                        <Textbox Name="textbox99">
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
                                    <Format>=Fields!AddCurrUnrlzdBas_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox99</rd:DefaultName>
                          <ZIndex>5</ZIndex>
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
                        <Textbox Name="textbox100">
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
                                    <Format>=Fields!AddCurrUnrlzdAmt_VATEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox100</rd:DefaultName>
                          <ZIndex>4</ZIndex>
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
                        <Textbox Name="textbox1014">
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
                          <rd:DefaultName>textbox101</rd:DefaultName>
                          <ZIndex>3</ZIndex>
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
                        <Textbox Name="textbox102">
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
                          <rd:DefaultName>textbox102</rd:DefaultName>
                          <ZIndex>2</ZIndex>
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
                        <Textbox Name="textbox103">
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
                          <rd:DefaultName>textbox103</rd:DefaultName>
                          <ZIndex>1</ZIndex>
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
                        <Textbox Name="textbox104">
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
                          <rd:DefaultName>textbox104</rd:DefaultName>
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
                  <Height>0.182in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox1">
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
                          <ZIndex>21</ZIndex>
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
                        <Textbox Name="TextBox11">
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
                          <ZIndex>20</ZIndex>
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
                        <Textbox Name="VATAmountCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!TotalCaption.Value)</Value>
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
                        <Textbox Name="VATAmountAddCurr">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!VATAmountAddCurr.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!VATAmountAddCurrFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>18</ZIndex>
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
                                    <Format>=First(Fields!VATAmountAddCurrFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox6</rd:DefaultName>
                          <ZIndex>17</ZIndex>
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox16">
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
                          <ZIndex>15</ZIndex>
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
                        <Textbox Name="TextBox17">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>14</ZIndex>
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
                        <Textbox Name="TextBox18">
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
                          <ZIndex>13</ZIndex>
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
                        <Textbox Name="TextBox19">
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
                          <ZIndex>12</ZIndex>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.182in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox110">
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
                          <ZIndex>31</ZIndex>
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
                        <Textbox Name="TextBox111">
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
                          <ZIndex>30</ZIndex>
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
                        <Textbox Name="VATAmountAddCurrCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!TotalCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>29</ZIndex>
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
                        <Textbox Name="VATAmount">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!VATAmount.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!VATAmountFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>28</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <rd:Selected>true</rd:Selected>
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
                                    <Format>=First(Fields!VATAmountFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox8</rd:DefaultName>
                          <ZIndex>27</ZIndex>
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
                        <Textbox Name="TextBox1155">
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
                          <ZIndex>26</ZIndex>
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
                        <Textbox Name="TextBox116">
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
                          <ZIndex>25</ZIndex>
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
                        <Textbox Name="TextBox117">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>24</ZIndex>
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
                        <Textbox Name="TextBox118">
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
                          <ZIndex>23</ZIndex>
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
                        <Textbox Name="TextBox119">
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
                          <ZIndex>22</ZIndex>
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
              </TablixMembers>
            </TablixColumnHierarchy>
            <TablixRowHierarchy>
              <TablixMembers>
                <TablixMember>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Group Name="Table1_Group2">
                    <GroupExpressions>
                      <GroupExpression>=Fields!VATBusPstGr_VATPostSetup.Value</GroupExpression>
                      <GroupExpression>=Fields!VATPrdPstGr_VATPostSetup.Value</GroupExpression>
                      <GroupExpression>=Fields!VATEntryGetFilterType.Value</GroupExpression>
                    </GroupExpressions>
                  </Group>
                  <TablixMembers>
                    <TablixMember>
                      <KeepWithGroup>After</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Group Name="Table1_Details_Group">
                        <DataElementName>Detail</DataElementName>
                      </Group>
                      <TablixMembers>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(Fields!PrintVATEntries.Value=TRUE AND Fields!UseAmtsInAddCurr.Value=FALSE AND Fields!EntryNo_VATEntry.Value&lt;&gt;0,FALSE,TRUE)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(Fields!PrintVATEntries.Value=TRUE AND Fields!UseAmtsInAddCurr.Value=TRUE AND Fields!EntryNo_VATEntry.Value&lt;&gt;0,FALSE,TRUE)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(Fields!GenJnlLineDocumentNo.Value&lt;&gt;"" AND Fields!UseAmtsInAddCurr.Value=FALSE,FALSE,TRUE)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(Fields!GenJnlLineDocumentNo.Value&lt;&gt;"" AND Fields!UseAmtsInAddCurr.Value=TRUE,FALSE,TRUE)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(Fields!GenJnlLineDocumentNo.Value&lt;&gt;"" AND Fields!ReversingEntry.Value=TRUE,FALSE,TRUE)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(Fields!GenJnlLine2DocumentNo.Value&lt;&gt;"" AND Fields!ReversingEntry.Value=TRUE AND Fields!UseAmtsInAddCurr.Value=TRUE,FALSE,TRUE)</Hidden>
                          </Visibility>
                        </TablixMember>
                      </TablixMembers>
                      <DataElementName>Detail_Collection</DataElementName>
                      <DataElementOutput>Output</DataElementOutput>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                  </TablixMembers>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIF(Fields!UseAmtsInAddCurr.Value=FALSE,TRUE,FALSE)</Hidden>
                  </Visibility>
                  <KeepWithGroup>Before</KeepWithGroup>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIF(Fields!UseAmtsInAddCurr.Value=TRUE,TRUE,FALSE)</Hidden>
                  </Visibility>
                  <KeepWithGroup>Before</KeepWithGroup>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <Top>3.49206cm</Top>
            <Height>4.83801cm</Height>
            <Width>18.07974cm</Width>
            <ZIndex>1</ZIndex>
            <Style />
          </Tablix>
          <Textbox Name="HeaderText">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!HeaderText.Value)</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Top>2.85714cm</Top>
            <Height>0.423cm</Height>
            <Width>3.75cm</Width>
            <ZIndex>2</ZIndex>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="VATPostingSetupTABLECAPTIONVATPostingSetupFilter">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!VATPostingSetupCaption.Value)</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Top>2.22222cm</Top>
            <Height>0.423cm</Height>
            <Width>17.77778cm</Width>
            <ZIndex>3</ZIndex>
            <Visibility>
              <Hidden>=IIF(Fields!VATPostingSetupFilter.Value="",TRUE,FALSE)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="GLAccSettleNo">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!GLAccSettleNo.Value)</Value>
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
            <Top>1.48092cm</Top>
            <Left>3.15cm</Left>
            <Height>0.423cm</Height>
            <Width>3cm</Width>
            <ZIndex>4</ZIndex>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="GLAccSettleNoCaption">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!SettlementAccCaption.Value)</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Top>1.48092cm</Top>
            <Height>0.423cm</Height>
            <Width>3cm</Width>
            <ZIndex>5</ZIndex>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="DocNo">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!DocNo.Value)</Value>
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
            <Top>1.05792cm</Top>
            <Left>3.15cm</Left>
            <Height>0.423cm</Height>
            <Width>5cm</Width>
            <ZIndex>6</ZIndex>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="DocNoCaption">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!DocNoCaption.Value)</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Top>1.05792cm</Top>
            <Height>0.423cm</Height>
            <Width>3cm</Width>
            <ZIndex>7</ZIndex>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="PostingDate">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!PostingDate.Value)</Value>
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
            <Top>0.63492cm</Top>
            <Left>3.15cm</Left>
            <Height>0.423cm</Height>
            <Width>1.6119cm</Width>
            <ZIndex>8</ZIndex>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="PostingDateCaption">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Fields!PostingDateCaption.Value</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Top>0.63492cm</Top>
            <Height>0.423cm</Height>
            <Width>3cm</Width>
            <ZIndex>9</ZIndex>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
        </ReportItems>
        <Height>8.33008cm</Height>
        <Style />
      </Body>
      <Width>18.15cm</Width>
      <Page>
        <PageHeader>
          <Height>1.5873cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="CurrReportPAGENOCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!PageCaption.Value,"DataSet_Result") &amp; " " &amp; Globals!PageNumber</Value>
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
              <Left>14.9cm</Left>
              <Height>0.423cm</Height>
              <Width>3.25cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CalcandPostVATSettlementCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!CalcandPostVATSettlementCaption.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="COMPANYNAME16">
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
              <Top>0.846cm</Top>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="STRSUBSTNOText005VATDateFilter1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!PeriodVATDateFilter.Value</Value>
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
              <ZIndex>3</ZIndex>
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
                      <Value>=Fields!TodayFormatted.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Format>D</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>14.9cm</Left>
              <Height>0.423cm</Height>
              <Width>3.25cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <Border />
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
              <Left>14.9cm</Left>
              <Height>0.423cm</Height>
              <Width>3.25cm</Width>
              <ZIndex>5</ZIndex>
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
</Code>
  <rd:ReportUnitType>Invalid</rd:ReportUnitType>
  <rd:ReportID>aaf30a90-5292-48be-a30c-751c34e29d31</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

