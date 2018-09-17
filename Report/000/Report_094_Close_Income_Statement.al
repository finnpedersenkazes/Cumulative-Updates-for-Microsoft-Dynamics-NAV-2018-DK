OBJECT Report 94 Close Income Statement
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Nulstil resultatopg�relse;
               ENU=Close Income Statement];
    ProcessingOnly=Yes;
    OnPreReport=VAR
                  s@1000 : Text[1024];
                BEGIN
                  IF EndDateReq = 0D THEN
                    ERROR(Text000);
                  ValidateEndDate(TRUE);
                  IF DocNo = '' THEN
                    ERROR(Text001);

                  SelectedDim.GetSelectedDim(USERID,3,REPORT::"Close Income Statement",'',TempSelectedDim);
                  s := CheckDimPostingRules(TempSelectedDim);
                  IF s <> '' THEN
                    IF NOT CONFIRM(s + Text007,FALSE) THEN
                      ERROR('');

                  GenJnlBatch.GET(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");
                  SourceCodeSetup.GET;
                  GLSetup.GET;
                  IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
                    IF RetainedEarningsGLAcc."No." = '' THEN
                      ERROR(Text002);
                    IF NOT CONFIRM(
                         Text003 +
                         Text005 +
                         Text007,FALSE)
                    THEN
                      ERROR('');
                  END;

                  Window.OPEN(Text008 + Text009 + Text019 + Text010 + Text011);

                  ClosePerGlobalDim1 := FALSE;
                  ClosePerGlobalDim2 := FALSE;
                  ClosePerGlobalDimOnly := TRUE;

                  IF TempSelectedDim.FIND('-') THEN
                    REPEAT
                      IF TempSelectedDim."Dimension Code" = GLSetup."Global Dimension 1 Code" THEN
                        ClosePerGlobalDim1 := TRUE;
                      IF TempSelectedDim."Dimension Code" = GLSetup."Global Dimension 2 Code" THEN
                        ClosePerGlobalDim2 := TRUE;
                      IF (TempSelectedDim."Dimension Code" <> GLSetup."Global Dimension 1 Code") AND
                         (TempSelectedDim."Dimension Code" <> GLSetup."Global Dimension 2 Code")
                      THEN
                        ClosePerGlobalDimOnly := FALSE;
                    UNTIL TempSelectedDim.NEXT = 0;

                  GenJnlLine.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
                  GenJnlLine.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
                  IF NOT GenJnlLine.FINDLAST THEN;
                  GenJnlLine.INIT;
                  GenJnlLine."Posting Date" := FiscYearClosingDate;
                  GenJnlLine."Document No." := DocNo;
                  GenJnlLine.Description := PostingDescription;
                  GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
                  CLEAR(GenJnlPostLine);
                END;

    OnPostReport=VAR
                   UpdateAnalysisView@1000 : Codeunit 410;
                 BEGIN
                   Window.CLOSE;
                   COMMIT;
                   IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
                     MESSAGE(Text016);
                     UpdateAnalysisView.UpdateAll(0,TRUE);
                   END ELSE
                     MESSAGE(Text017);
                 END;

  }
  DATASET
  {
    { 6710;    ;DataItem;                    ;
               DataItemTable=Table15;
               DataItemTableView=SORTING(No.)
                                 WHERE(Account Type=CONST(Posting),
                                       Income/Balance=CONST(Income Statement));
               OnPreDataItem=BEGIN
                               NoOfAccounts := COUNT;
                             END;

               OnAfterGetRecord=BEGIN
                                  ThisAccountNo := ThisAccountNo + 1;
                                  Window.UPDATE(1,"No.");
                                  Window.UPDATE(4,ROUND(ThisAccountNo / NoOfAccounts * 10000,1));
                                  Window.UPDATE(2,'');
                                  Window.UPDATE(3,0);
                                END;

               OnPostDataItem=BEGIN
                                IF (TotalAmount <> 0) OR ((TotalAmountAddCurr <> 0) AND (GLSetup."Additional Reporting Currency" <> '')) THEN BEGIN
                                  GenJnlLine."Business Unit Code" := '';
                                  GenJnlLine."Shortcut Dimension 1 Code" := '';
                                  GenJnlLine."Shortcut Dimension 2 Code" := '';
                                  GenJnlLine."Dimension Set ID" := 0;
                                  GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                                  GenJnlLine."Account No." := RetainedEarningsGLAcc."No.";
                                  GenJnlLine."Source Code" := SourceCodeSetup."Close Income Statement";
                                  GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                                  GenJnlLine."Currency Code" := '';
                                  GenJnlLine."Additional-Currency Posting" :=
                                    GenJnlLine."Additional-Currency Posting"::None;
                                  GenJnlLine.VALIDATE(Amount,TotalAmount);
                                  GenJnlLine."Source Currency Amount" := TotalAmountAddCurr;
                                  HandleGenJnlLine;
                                  Window.UPDATE(1,GenJnlLine."Account No.");
                                END;
                              END;
                               }

    { 7069;1   ;DataItem;                    ;
               DataItemTable=Table17;
               DataItemTableView=SORTING(G/L Account No.,Posting Date);
               OnPreDataItem=BEGIN
                               Window.UPDATE(2,Text013);
                               Window.UPDATE(3,0);

                               IF ClosePerGlobalDimOnly OR ClosePerBusUnit THEN
                                 CASE TRUE OF
                                   ClosePerBusUnit AND (ClosePerGlobalDim1 OR ClosePerGlobalDim2):
                                     SETCURRENTKEY(
                                       "G/L Account No.","Business Unit Code",
                                       "Global Dimension 1 Code","Global Dimension 2 Code","Posting Date");
                                   ClosePerBusUnit AND NOT (ClosePerGlobalDim1 OR ClosePerGlobalDim2):
                                     SETCURRENTKEY(
                                       "G/L Account No.","Business Unit Code","Posting Date");
                                   NOT ClosePerBusUnit AND (ClosePerGlobalDim1 OR ClosePerGlobalDim2):
                                     SETCURRENTKEY(
                                       "G/L Account No.","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date");
                                 END;

                               SETRANGE("Posting Date",FiscalYearStartDate,FiscYearClosingDate);

                               MaxEntry := COUNT;

                               EntryNoAmountBuf.DELETEALL;
                               EntryCount := 0;

                               LastWindowUpdateDateTime := CURRENTDATETIME;
                             END;

               OnAfterGetRecord=VAR
                                  TempDimBuf@1000 : TEMPORARY Record 360;
                                  TempDimBuf2@1001 : TEMPORARY Record 360;
                                  DimensionBufferID@1002 : Integer;
                                  RowOffset@1003 : Integer;
                                BEGIN
                                  EntryCount := EntryCount + 1;
                                  IF CURRENTDATETIME - LastWindowUpdateDateTime > 1000 THEN BEGIN
                                    LastWindowUpdateDateTime := CURRENTDATETIME;
                                    Window.UPDATE(3,ROUND(EntryCount / MaxEntry * 10000,1));
                                  END;

                                  IF GroupSum THEN BEGIN
                                    CalcSumsInFilter("G/L Entry",RowOffset);
                                    GetGLEntryDimensions("Entry No.",TempDimBuf,"Dimension Set ID");
                                  END;

                                  IF (Amount <> 0) OR ("Additional-Currency Amount" <> 0) THEN BEGIN
                                    IF NOT GroupSum THEN BEGIN
                                      TotalAmount += Amount;
                                      IF GLSetup."Additional Reporting Currency" <> '' THEN
                                        TotalAmountAddCurr += "Additional-Currency Amount";

                                      GetGLEntryDimensions("Entry No.",TempDimBuf,"Dimension Set ID");
                                    END;

                                    IF TempSelectedDim.FIND('-') THEN
                                      REPEAT
                                        IF TempDimBuf.GET(DATABASE::"G/L Entry","Entry No.",TempSelectedDim."Dimension Code")
                                        THEN BEGIN
                                          TempDimBuf2."Table ID" := TempDimBuf."Table ID";
                                          TempDimBuf2."Dimension Code" := TempDimBuf."Dimension Code";
                                          TempDimBuf2."Dimension Value Code" := TempDimBuf."Dimension Value Code";
                                          TempDimBuf2.INSERT;
                                        END;
                                      UNTIL TempSelectedDim.NEXT = 0;

                                    DimensionBufferID := DimBufMgt.GetDimensionId(TempDimBuf2);

                                    EntryNoAmountBuf.RESET;
                                    IF ClosePerBusUnit AND FIELDACTIVE("Business Unit Code") THEN
                                      EntryNoAmountBuf."Business Unit Code" := "Business Unit Code"
                                    ELSE
                                      EntryNoAmountBuf."Business Unit Code" := '';
                                    EntryNoAmountBuf."Entry No." := DimensionBufferID;
                                    IF EntryNoAmountBuf.FIND THEN BEGIN
                                      EntryNoAmountBuf.Amount := EntryNoAmountBuf.Amount + Amount;
                                      EntryNoAmountBuf.Amount2 := EntryNoAmountBuf.Amount2 + "Additional-Currency Amount";
                                      EntryNoAmountBuf.MODIFY;
                                    END ELSE BEGIN
                                      EntryNoAmountBuf.Amount := Amount;
                                      EntryNoAmountBuf.Amount2 := "Additional-Currency Amount";
                                      EntryNoAmountBuf.INSERT;
                                    END;
                                  END;

                                  IF GroupSum THEN
                                    NEXT(RowOffset);
                                END;

               OnPostDataItem=VAR
                                TempDimBuf2@1000 : TEMPORARY Record 360;
                                GlobalDimVal1@1004 : Code[20];
                                GlobalDimVal2@1005 : Code[20];
                                NewDimensionID@1002 : Integer;
                              BEGIN
                                EntryNoAmountBuf.RESET;
                                MaxEntry := EntryNoAmountBuf.COUNT;
                                EntryCount := 0;
                                Window.UPDATE(2,Text012);
                                Window.UPDATE(3,0);

                                IF EntryNoAmountBuf.FIND('-') THEN
                                  REPEAT
                                    EntryCount := EntryCount + 1;
                                    IF CURRENTDATETIME - LastWindowUpdateDateTime > 1000 THEN BEGIN
                                      LastWindowUpdateDateTime := CURRENTDATETIME;
                                      Window.UPDATE(3,ROUND(EntryCount / MaxEntry * 10000,1));
                                    END;

                                    IF (EntryNoAmountBuf.Amount <> 0) OR (EntryNoAmountBuf.Amount2 <> 0) THEN BEGIN
                                      GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                                      GenJnlLine."Account No." := "G/L Account No.";
                                      GenJnlLine."Source Code" := SourceCodeSetup."Close Income Statement";
                                      GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                                      GenJnlLine.VALIDATE(Amount,-EntryNoAmountBuf.Amount);
                                      GenJnlLine."Source Currency Amount" := -EntryNoAmountBuf.Amount2;
                                      GenJnlLine."Business Unit Code" := EntryNoAmountBuf."Business Unit Code";

                                      TempDimBuf2.DELETEALL;
                                      DimBufMgt.RetrieveDimensions(EntryNoAmountBuf."Entry No.",TempDimBuf2);
                                      NewDimensionID := DimMgt.CreateDimSetIDFromDimBuf(TempDimBuf2);
                                      GenJnlLine."Dimension Set ID" := NewDimensionID;
                                      DimMgt.UpdateGlobalDimFromDimSetID(NewDimensionID,GlobalDimVal1,GlobalDimVal2);
                                      GenJnlLine."Shortcut Dimension 1 Code" := '';
                                      IF ClosePerGlobalDim1 THEN
                                        GenJnlLine."Shortcut Dimension 1 Code" := GlobalDimVal1;
                                      GenJnlLine."Shortcut Dimension 2 Code" := '';
                                      IF ClosePerGlobalDim2 THEN
                                        GenJnlLine."Shortcut Dimension 2 Code" := GlobalDimVal2;

                                      HandleGenJnlLine;
                                    END;
                                  UNTIL EntryNoAmountBuf.NEXT = 0;

                                EntryNoAmountBuf.DELETEALL;
                              END;

               DataItemLink=G/L Account No.=FIELD(No.) }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnOpenPage=VAR
                   GLAccount@1001 : Record 15;
                   GLAccountCategory@1000 : Record 570;
                 BEGIN
                   IF PostingDescription = '' THEN
                     PostingDescription :=
                       COPYSTR(ObjTransl.TranslateObject(ObjTransl."Object Type"::Report,REPORT::"Close Income Statement"),1,30);
                   EndDateReq := 0D;
                   AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
                   AccountingPeriod.SETRANGE("Date Locked",TRUE);
                   IF AccountingPeriod.FINDLAST THEN BEGIN
                     EndDateReq := AccountingPeriod."Starting Date" - 1;
                     IF NOT ValidateEndDate(FALSE) THEN
                       EndDateReq := 0D;
                   END ELSE
                     IF EndDateReq = 0D THEN
                       ERROR(NoFiscalYearsErr);
                   ValidateJnl;
                   ColumnDim := DimSelectionBuf.GetDimSelectionText(3,REPORT::"Close Income Statement",'');
                   IF RetainedEarningsGLAcc."No." = '' THEN BEGIN
                     GLAccountCategory.SETRANGE("Account Category",GLAccountCategory."Account Category"::Equity);
                     GLAccountCategory.SETRANGE(
                       "Additional Report Definition",GLAccountCategory."Additional Report Definition"::"Retained Earnings");
                     IF GLAccountCategory.FINDFIRST THEN BEGIN
                       GLAccount.SETRANGE("Account Subcategory Entry No.",GLAccountCategory."Entry No.");
                       IF GLAccount.FINDFIRST THEN
                         RetainedEarningsGLAcc."No." := GLAccount."No.";
                     END;
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
                  Name=FiscalYearEndingDate;
                  CaptionML=[DAN=Regnskabs�rets slutdato;
                             ENU=Fiscal Year Ending Date];
                  ToolTipML=[DAN=Angiver den sidste dato i det lukkede regnskabs�r. Denne dato bruges til at fastsl� ultimodatoen.;
                             ENU=Specifies the last date in the closed fiscal year. This date is used to determine the closing date.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=EndDateReq;
                  OnValidate=BEGIN
                               ValidateEndDate(TRUE);
                             END;
                              }

      { 2   ;2   ;Field     ;
                  Name=GenJournalTemplate;
                  CaptionML=[DAN=Finanskladdetype;
                             ENU=Gen. Journal Template];
                  ToolTipML=[DAN=Angiver den finanskladdetype, der bruges af k�rslen.;
                             ENU=Specifies the general journal template that is used by the batch job.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=GenJnlLine."Journal Template Name";
                  TableRelation="Gen. Journal Template";
                  OnValidate=BEGIN
                               GenJnlLine."Journal Batch Name" := '';
                               DocNo := '';
                             END;
                              }

      { 3   ;2   ;Field     ;
                  Name=GenJournalBatch;
                  Lookup=Yes;
                  CaptionML=[DAN=Finanskladdenavn;
                             ENU=Gen. Journal Batch];
                  ToolTipML=[DAN=Angiver den finanskladdek�rsel, der bruges af k�rslen.;
                             ENU=Specifies the general journal batch that is used by the batch job.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=GenJnlLine."Journal Batch Name";
                  OnValidate=BEGIN
                               IF GenJnlLine."Journal Batch Name" <> '' THEN BEGIN
                                 GenJnlLine.TESTFIELD("Journal Template Name");
                                 GenJnlBatch.GET(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");
                               END;
                               ValidateJnl;
                             END;

                  OnLookup=BEGIN
                             GenJnlLine.TESTFIELD("Journal Template Name");
                             GenJnlTemplate.GET(GenJnlLine."Journal Template Name");
                             GenJnlBatch.FILTERGROUP(2);
                             GenJnlBatch.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
                             GenJnlBatch.FILTERGROUP(0);
                             GenJnlBatch."Journal Template Name" := GenJnlLine."Journal Template Name";
                             GenJnlBatch.Name := GenJnlLine."Journal Batch Name";
                             IF PAGE.RUNMODAL(0,GenJnlBatch) = ACTION::LookupOK THEN BEGIN
                               Text := GenJnlBatch.Name;
                               EXIT(TRUE);
                             END;
                           END;
                            }

      { 8   ;2   ;Field     ;
                  Name=DocumentNo;
                  CaptionML=[DAN=Bilagsnr.;
                             ENU=Document No.];
                  ToolTipML=[DAN=Angiver nummeret p� det salgsdokument, der behandles af rapporten eller k�rslen.;
                             ENU=Specifies the number of the document that is processed by the report or batch job.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=DocNo }

      { 11  ;2   ;Field     ;
                  Name=RetainedEarningsAcc;
                  CaptionML=[DAN=Resultatkonto;
                             ENU=Retained Earnings Acc.];
                  ToolTipML=[DAN=Angiver den resultatkonto, som k�rslen bogf�res til. Kontoen skal v�re den samme som den konto, der bruges af k�rslen Nulstil resultatopg�relse.;
                             ENU=Specifies the retained earnings account that the batch job posts to. This account should be the same as the account that is used by the Close Income Statement batch job.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=RetainedEarningsGLAcc."No.";
                  TableRelation="G/L Account" WHERE (Account Type=CONST(Posting),
                                                     Account Category=FILTER(' '|Equity),
                                                     Income/Balance=CONST(Balance Sheet));
                  OnValidate=BEGIN
                               IF RetainedEarningsGLAcc."No." <> '' THEN BEGIN
                                 RetainedEarningsGLAcc.FIND;
                                 RetainedEarningsGLAcc.CheckGLAcc;
                               END;
                             END;
                              }

      { 4   ;2   ;Field     ;
                  Name=PostingDescription;
                  CaptionML=[DAN=Bogf�ringsbeskrivelse;
                             ENU=Posting Description];
                  ToolTipML=[DAN=Angiver den beskrivelse, der h�rer med til bogf�ringen.;
                             ENU=Specifies the description that accompanies the posting.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PostingDescription }

      { 14  ;2   ;Group     ;
                  CaptionML=[DAN=Nulstil pr.;
                             ENU=Close by] }

      { 5   ;3   ;Field     ;
                  CaptionML=[DAN=Konc.virksomhedskode;
                             ENU=Business Unit Code];
                  ToolTipML=[DAN=Angiver koden for koncernvirksomheden i en virksomhedsstruktur.;
                             ENU=Specifies the code for the business unit, in a company group structure.];
                  ApplicationArea=#Advanced;
                  SourceExpr=ClosePerBusUnit }

      { 13  ;3   ;Field     ;
                  Name=Dimensions;
                  CaptionML=[DAN=Dimensioner;
                             ENU=Dimensions];
                  ToolTipML=[DAN=Angiver dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                             ENU=Specifies dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                  ApplicationArea=#Suite;
                  SourceExpr=ColumnDim;
                  Editable=FALSE;
                  OnAssistEdit=VAR
                                 TempSelectedDim2@1002 : TEMPORARY Record 369;
                                 s@1001 : Text[1024];
                               BEGIN
                                 DimSelectionBuf.SetDimSelectionMultiple(3,REPORT::"Close Income Statement",ColumnDim);

                                 SelectedDim.GetSelectedDim(USERID,3,REPORT::"Close Income Statement",'',TempSelectedDim2);
                                 s := CheckDimPostingRules(TempSelectedDim2);
                                 IF s <> '' THEN
                                   MESSAGE(s);
                               END;
                                }

      { 15  ;2   ;Field     ;
                  Name=InventoryPeriodClosed;
                  CaptionML=[DAN=Lagerperioden er lukket;
                             ENU=Inventory Period Closed];
                  ToolTipML=[DAN=Angiver, at lagerperioden er blevet lukket.;
                             ENU=Specifies that the inventory period has been closed.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=IsInvtPeriodClosed }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      AccountingPeriod@1012 : Record 50;
      SourceCodeSetup@1013 : Record 242;
      GenJnlTemplate@1014 : Record 80;
      GenJnlBatch@1015 : Record 232;
      GenJnlLine@1016 : Record 81;
      RetainedEarningsGLAcc@1020 : Record 15;
      GLSetup@1021 : Record 98;
      DimSelectionBuf@1022 : Record 368;
      ObjTransl@1004 : Record 377;
      SelectedDim@1023 : Record 369;
      TempSelectedDim@1024 : TEMPORARY Record 369;
      EntryNoAmountBuf@1025 : TEMPORARY Record 386;
      NoSeriesMgt@1026 : Codeunit 396;
      GenJnlPostLine@1027 : Codeunit 12;
      DimMgt@1028 : Codeunit 408;
      DimBufMgt@1029 : Codeunit 411;
      Window@1031 : Dialog;
      FiscalYearStartDate@1032 : Date;
      FiscYearClosingDate@1033 : Date;
      EndDateReq@1034 : Date;
      DocNo@1035 : Code[20];
      PostingDescription@1036 : Text[50];
      ClosePerBusUnit@1037 : Boolean;
      ClosePerGlobalDim1@1038 : Boolean;
      ClosePerGlobalDim2@1039 : Boolean;
      ClosePerGlobalDimOnly@1040 : Boolean;
      TotalAmount@1041 : Decimal;
      TotalAmountAddCurr@1042 : Decimal;
      ColumnDim@1043 : Text[250];
      NoOfAccounts@1050 : Integer;
      ThisAccountNo@1049 : Integer;
      Text000@1053 : TextConst 'DAN=Indtast slutdatoen for regnskabs�ret.;ENU=Enter the ending date for the fiscal year.';
      Text001@1052 : TextConst 'DAN=Indtast et bilagsnr.;ENU=Enter a Document No.';
      Text002@1051 : TextConst 'DAN=Indtast resultatkontoen.;ENU=Enter Retained Earnings Account No.';
      Text003@1048 : TextConst 'DAN="Ved brug af en ekstra rapporteringsvaluta vil denne k�rsel bogf�re ultimoposter direkte til finansmodulet.  ";ENU="By using an additional reporting currency, this batch job will post closing entries directly to the general ledger.  "';
      Text005@1047 : TextConst 'DAN="Ultimoposterne bliver ikke overf�rt til en finanskladde f�rst, men bogf�rt direkte.\\ ";ENU="These closing entries will not be transferred to a general journal before the program posts them to the general ledger.\\ "';
      Text007@1046 : TextConst 'DAN=\Vil du forts�tte?;ENU=\Do you want to continue?';
      Text008@1045 : TextConst 'DAN=Finanskladdelinjer oprettes...\\;ENU=Creating general journal lines...\\';
      Text009@1030 : TextConst 'DAN=Kontonr.            #1##################\;ENU=Account No.         #1##################\';
      Text010@1019 : TextConst 'DAN=Udf�rer nu          #2##################\;ENU=Now performing      #2##################\';
      Text011@1011 : TextConst 'DAN="                    @3@@@@@@@@@@@@@@@@@@\";ENU="                    @3@@@@@@@@@@@@@@@@@@\"';
      Text019@1010 : TextConst 'DAN="                    @4@@@@@@@@@@@@@@@@@@\";ENU="                    @4@@@@@@@@@@@@@@@@@@\"';
      Text012@1058 : TextConst 'DAN=Opretter finanskladdelinjer;ENU=Creating Gen. Journal lines';
      Text013@1008 : TextConst 'DAN=Beregner bel�b;ENU=Calculating Amounts';
      Text014@1007 : TextConst 'DAN=Regnskabs�ret skal afsluttes, f�r resultatopg�relsen kan lukkes.;ENU=The fiscal year must be closed before the income statement can be closed.';
      Text015@1006 : TextConst 'DAN=Regnskabs�ret findes ikke.;ENU=The fiscal year does not exist.';
      Text017@1005 : TextConst 'DAN=Kladdelinjerne er blevet oprettet.;ENU=The journal lines have successfully been created.';
      Text016@1003 : TextConst 'DAN=Ultimoposterne er blevet bogf�rt.;ENU=The closing entries have successfully been posted.';
      Text020@1001 : TextConst 'DAN=F�lgende finanskonti har obligatoriske dimensionskoder, der ikke er valgt:;ENU=The following G/L Accounts have mandatory dimension codes that have not been selected:';
      Text021@1000 : TextConst 'DAN=\\Hvis du vil bogf�re til disse konti, skal du ogs� v�lge disse dimensioner:;ENU=\\In order to post to these accounts you must also select these dimensions:';
      MaxEntry@1002 : Integer;
      EntryCount@1057 : Integer;
      LastWindowUpdateDateTime@1044 : DateTime;
      NoFiscalYearsErr@1009 : TextConst 'DAN=Der findes intet lukket regnskabs�r.;ENU=No closed fiscal year exists.';

    LOCAL PROCEDURE ValidateEndDate@1(RealMode@1000 : Boolean) : Boolean;
    VAR
      OK@1001 : Boolean;
    BEGIN
      IF EndDateReq = 0D THEN
        EXIT;

      OK := AccountingPeriod.GET(EndDateReq + 1);
      IF OK THEN
        OK := AccountingPeriod."New Fiscal Year";
      IF OK THEN BEGIN
        IF NOT AccountingPeriod."Date Locked" THEN BEGIN
          IF NOT RealMode THEN
            EXIT;
          ERROR(Text014);
        END;
        FiscYearClosingDate := CLOSINGDATE(EndDateReq);
        AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
        OK := AccountingPeriod.FIND('<');
        FiscalYearStartDate := AccountingPeriod."Starting Date";
      END;
      IF NOT OK THEN BEGIN
        IF NOT RealMode THEN
          EXIT;
        ERROR(Text015);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ValidateJnl@2();
    BEGIN
      DocNo := '';
      IF GenJnlBatch.GET(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name") THEN
        IF GenJnlBatch."No. Series" <> '' THEN
          DocNo := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series",EndDateReq);
    END;

    LOCAL PROCEDURE HandleGenJnlLine@4();
    BEGIN
      GenJnlLine."Additional-Currency Posting" :=
        GenJnlLine."Additional-Currency Posting"::None;
      IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
        GenJnlLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
        IF ZeroGenJnlAmount THEN BEGIN
          GenJnlLine."Additional-Currency Posting" :=
            GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
          GenJnlLine.VALIDATE(Amount,GenJnlLine."Source Currency Amount");
          GenJnlLine."Source Currency Amount" := 0;
        END;
        IF GenJnlLine.Amount <> 0 THEN BEGIN
          GenJnlPostLine.RUN(GenJnlLine);
          IF DocNo = NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series",EndDateReq,FALSE) THEN
            NoSeriesMgt.SaveNoSeries;
        END;
      END ELSE
        IF NOT ZeroGenJnlAmount THEN
          GenJnlLine.INSERT;
    END;

    LOCAL PROCEDURE CalcSumsInFilter@18(VAR GLEntrySource@1000 : Record 17;VAR Offset@1001 : Integer);
    VAR
      GLEntry@1002 : Record 17;
    BEGIN
      GLEntry.COPYFILTERS(GLEntrySource);
      IF ClosePerBusUnit THEN BEGIN
        GLEntry.SETRANGE("Business Unit Code",GLEntrySource."Business Unit Code");
        GenJnlLine."Business Unit Code" := GLEntrySource."Business Unit Code";
      END;
      IF ClosePerGlobalDim1 THEN BEGIN
        GLEntry.SETRANGE("Global Dimension 1 Code",GLEntrySource."Global Dimension 1 Code");
        IF ClosePerGlobalDim2 THEN
          GLEntry.SETRANGE("Global Dimension 2 Code",GLEntrySource."Global Dimension 2 Code");
      END;

      GLEntry.CALCSUMS(Amount);
      GLEntrySource.Amount := GLEntry.Amount;
      TotalAmount += GLEntrySource.Amount;
      IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
        GLEntry.CALCSUMS("Additional-Currency Amount");
        GLEntrySource."Additional-Currency Amount" := GLEntry."Additional-Currency Amount";
        TotalAmountAddCurr += GLEntrySource."Additional-Currency Amount";
      END;
      Offset := GLEntry.COUNT - 1;
    END;

    LOCAL PROCEDURE GetGLEntryDimensions@7(EntryNo@1000 : Integer;VAR DimBuf@1001 : Record 360;DimensionSetID@1002 : Integer);
    VAR
      DimSetEntry@1004 : Record 480;
    BEGIN
      DimSetEntry.SETRANGE("Dimension Set ID",DimensionSetID);
      IF DimSetEntry.FINDSET THEN
        REPEAT
          DimBuf."Table ID" := DATABASE::"G/L Entry";
          DimBuf."Entry No." := EntryNo;
          DimBuf."Dimension Code" := DimSetEntry."Dimension Code";
          DimBuf."Dimension Value Code" := DimSetEntry."Dimension Value Code";
          DimBuf.INSERT;
        UNTIL DimSetEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDimPostingRules@6(VAR SelectedDim@1002 : Record 369) : Text[1024];
    VAR
      DefaultDim@1000 : Record 352;
      ErrorText@1001 : Text[1024];
      DimText@1004 : Text[1024];
      PrevAcc@1003 : Code[20];
      Handled@1005 : Boolean;
    BEGIN
      OnBeforeCheckDimPostingRules(SelectedDim,ErrorText,Handled);
      IF Handled THEN
        EXIT(ErrorText);

      DefaultDim.SETRANGE("Table ID",DATABASE::"G/L Account");
      DefaultDim.SETFILTER(
        "Value Posting",'%1|%2',
        DefaultDim."Value Posting"::"Same Code",DefaultDim."Value Posting"::"Code Mandatory");

      IF DefaultDim.FIND('-') THEN
        REPEAT
          SelectedDim.SETRANGE("Dimension Code",DefaultDim."Dimension Code");
          IF NOT SelectedDim.FIND('-') THEN BEGIN
            IF STRPOS(DimText,DefaultDim."Dimension Code") < 1 THEN
              DimText := DimText + ' ' + FORMAT(DefaultDim."Dimension Code");
            IF PrevAcc <> DefaultDim."No." THEN BEGIN
              PrevAcc := DefaultDim."No.";
              IF ErrorText = '' THEN
                ErrorText := Text020;
              ErrorText := ErrorText + ' ' + FORMAT(DefaultDim."No.");
            END;
          END;
          SelectedDim.SETRANGE("Dimension Code");
        UNTIL (DefaultDim.NEXT = 0) OR (STRLEN(ErrorText) > MAXSTRLEN(ErrorText) - MAXSTRLEN(DefaultDim."No.") - STRLEN(Text021) - 1);
      IF ErrorText <> '' THEN
        ErrorText := COPYSTR(ErrorText + Text021 + DimText,1,MAXSTRLEN(ErrorText));
      EXIT(ErrorText);
    END;

    LOCAL PROCEDURE IsInvtPeriodClosed@3() : Boolean;
    VAR
      AccPeriod@1001 : Record 50;
      InvtPeriod@1000 : Record 5814;
    BEGIN
      IF EndDateReq = 0D THEN
        EXIT;
      AccPeriod.GET(EndDateReq + 1);
      AccPeriod.NEXT(-1);
      EXIT(InvtPeriod.IsInvtPeriodClosed(AccPeriod."Starting Date"));
    END;

    [External]
    PROCEDURE InitializeRequestTest@5(EndDate@1000 : Date;GenJournalLine@1001 : Record 81;GLAccount@1002 : Record 15;CloseByBU@1003 : Boolean);
    BEGIN
      EndDateReq := EndDate;
      GenJnlLine := GenJournalLine;
      ValidateJnl;
      RetainedEarningsGLAcc := GLAccount;
      ClosePerBusUnit := CloseByBU;
    END;

    LOCAL PROCEDURE ZeroGenJnlAmount@8() : Boolean;
    BEGIN
      EXIT((GenJnlLine.Amount = 0) AND (GenJnlLine."Source Currency Amount" <> 0))
    END;

    LOCAL PROCEDURE GroupSum@10() : Boolean;
    BEGIN
      EXIT(ClosePerGlobalDimOnly AND (ClosePerBusUnit OR ClosePerGlobalDim1));
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCheckDimPostingRules@9(SelectedDimension@1002 : Record 369;ErrorText@1000 : Text[1024];VAR Handled@1001 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

