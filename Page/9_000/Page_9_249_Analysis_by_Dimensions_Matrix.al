OBJECT Page 9249 Analysis by Dimensions Matrix
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Matrix for dimensionsanalyse;
               ENU=Analysis by Dimensions Matrix];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table367;
    DataCaptionExpr=AnalysisViewCode;
    PageType=List;
    SourceTableTemporary=Yes;
    OnInit=BEGIN
             Field32Visible := TRUE;
             Field31Visible := TRUE;
             Field30Visible := TRUE;
             Field29Visible := TRUE;
             Field28Visible := TRUE;
             Field27Visible := TRUE;
             Field26Visible := TRUE;
             Field25Visible := TRUE;
             Field24Visible := TRUE;
             Field23Visible := TRUE;
             Field22Visible := TRUE;
             Field21Visible := TRUE;
             Field20Visible := TRUE;
             Field19Visible := TRUE;
             Field18Visible := TRUE;
             Field17Visible := TRUE;
             Field16Visible := TRUE;
             Field15Visible := TRUE;
             Field14Visible := TRUE;
             Field13Visible := TRUE;
             Field12Visible := TRUE;
             Field11Visible := TRUE;
             Field10Visible := TRUE;
             Field9Visible := TRUE;
             Field8Visible := TRUE;
             Field7Visible := TRUE;
             Field6Visible := TRUE;
             Field5Visible := TRUE;
             Field4Visible := TRUE;
             Field3Visible := TRUE;
             Field2Visible := TRUE;
             Field1Visible := TRUE;
           END;

    OnOpenPage=VAR
                 CashFlowForecast@1000 : Record 840;
                 GLAcc@1001 : Record 15;
                 FileManagement@1002 : Codeunit 419;
               BEGIN
                 CanRunDotNet := FileManagement.CanRunDotNetOnClient;
                 MATRIX_NoOfMatrixColumns := ARRAYLEN(MATRIX_CellData);

                 ValidateAnalysisViewCode;

                 InitRec(Rec,LineDimOption);
                 InitRec(MatrixRecord,ColumnDimOption);

                 IF (LineDimCode = '') AND (ColumnDimCode = '') THEN BEGIN
                   IF GLAccountSource THEN
                     LineDimCode := GLAcc.TABLECAPTION
                   ELSE
                     LineDimCode := CashFlowForecast.TABLECAPTION;
                   ColumnDimCode := Text000;
                 END;

                 CalculateClosingDateFilter;

                 SetVisible;
                 IF LineDimOption = LineDimOption::Period THEN
                   Code := '';
               END;

    OnFindRecord=BEGIN
                   EXIT(FindRec(LineDimOption,Rec,Which));
                 END;

    OnNextRecord=BEGIN
                   EXIT(NextRec(LineDimOption,Rec,Steps));
                 END;

    OnAfterGetRecord=VAR
                       MATRIX_CurrentColumnOrdinal@1043 : Integer;
                       MATRIX_Steps@1044 : Integer;
                     BEGIN
                       Amount := MatrixMgt.RoundValue(CalcAmount(FALSE),RoundingFactor);

                       MATRIX_CurrentColumnOrdinal := 0;
                       IF MATRIX_PrimKeyFirstCol <> '' THEN
                         MatrixRecord.SETPOSITION(MATRIX_PrimKeyFirstCol);
                       IF MATRIX_OnFindRecord('=><') THEN BEGIN
                         MATRIX_CurrentColumnOrdinal := 1;

                         REPEAT
                           MATRIX_ColumnOrdinal := MATRIX_CurrentColumnOrdinal;
                           MATRIX_OnAfterGetRecord;
                           MATRIX_Steps := MATRIX_OnNextRecord(1);
                           MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + MATRIX_Steps;
                         UNTIL (MATRIX_CurrentColumnOrdinal - MATRIX_Steps = MATRIX_NoOfMatrixColumns) OR (MATRIX_Steps = 0);
                         IF MATRIX_CurrentColumnOrdinal <> 1 THEN
                           MATRIX_OnNextRecord(1 - MATRIX_CurrentColumnOrdinal);
                       END;

                       SetVisible;
                       FormatLine;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=H&andlinger;
                                 ENU=&Actions];
                      Image=Action }
      { 5       ;2   ;Action    ;
                      Name=ExportToExcel;
                      CaptionML=[DAN=Udl�s til Excel;
                                 ENU=Export to Excel];
                      ToolTipML=[DAN=Eksport�r oplysningerne i analyserapporten til Excel.;
                                 ENU=Export the information in the analysis report to Excel.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Visible=CanRunDotNet;
                      Image=ExportToExcel;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 AnalysisViewEntry@1001 : Record 365;
                                 AnalysisViewToExcel@1000 : Codeunit 424;
                               BEGIN
                                 SetCommonFilters(AnalysisViewEntry);
                                 AnalysisViewEntry.FIND('-');
                                 AnalysisViewToExcel.ExportData(
                                   AnalysisViewEntry,LineDimCode,ColumnDimCode,ShowOppositeSign,
                                   ShowInAddCurr,AmountField,PeriodType,ShowColumnName,DateFilter,AccountFilter,BudgetFilter,
                                   Dim1Filter,Dim2Filter,Dim3Filter,Dim4Filter,AmountType,ClosingEntryFilter,ShowActualBudg,BusUnitFilter);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                IndentationColumnName=Indentation;
                IndentationControls=Name;
                GroupType=Repeater }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for recorden.;
                           ENU=Specifies the code of the record.];
                ApplicationArea=#Suite;
                SourceExpr=Code;
                Style=Strong;
                StyleExpr=Emphasize;
                OnLookup=BEGIN
                           LookUpCode(LineDimOption,LineDimCode,Code);
                         END;
                          }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� recorden.;
                           ENU=Specifies the name of the record.];
                ApplicationArea=#Suite;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=Emphasize }

    { 24  ;2   ;Field     ;
                Name=TotalAmount;
                CaptionML=[DAN=I alt;
                           ENU=Total Amount];
                ToolTipML=[DAN=Angiver det samlede bel�b for den bel�bstype, du har valgt i feltet Vis i oversigtspanelet Indstillinger.;
                           ENU=Specifies the total amount for the amount type that you select in the Show field in the Options FastTab.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=+Amount;
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              DrillDown(FALSE);
                            END;
                             }

    { 1011;2   ;Field     ;
                Name=Field1;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[1];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[1];
                Visible=Field1Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(1);
                              DrillDown(TRUE);
                            END;
                             }

    { 1012;2   ;Field     ;
                Name=Field2;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[2];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[2];
                Visible=Field2Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(2);
                              DrillDown(TRUE);
                            END;
                             }

    { 1013;2   ;Field     ;
                Name=Field3;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[3];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[3];
                Visible=Field3Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(3);
                              DrillDown(TRUE);
                            END;
                             }

    { 1014;2   ;Field     ;
                Name=Field4;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[4];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[4];
                Visible=Field4Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(4);
                              DrillDown(TRUE);
                            END;
                             }

    { 1015;2   ;Field     ;
                Name=Field5;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[5];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[5];
                Visible=Field5Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(5);
                              DrillDown(TRUE);
                            END;
                             }

    { 1016;2   ;Field     ;
                Name=Field6;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[6];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[6];
                Visible=Field6Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(6);
                              DrillDown(TRUE);
                            END;
                             }

    { 1017;2   ;Field     ;
                Name=Field7;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[7];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[7];
                Visible=Field7Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(7);
                              DrillDown(TRUE);
                            END;
                             }

    { 1018;2   ;Field     ;
                Name=Field8;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[8];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[8];
                Visible=Field8Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(8);
                              DrillDown(TRUE);
                            END;
                             }

    { 1019;2   ;Field     ;
                Name=Field9;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[9];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[9];
                Visible=Field9Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(9);
                              DrillDown(TRUE);
                            END;
                             }

    { 1020;2   ;Field     ;
                Name=Field10;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[10];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[10];
                Visible=Field10Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(10);
                              DrillDown(TRUE);
                            END;
                             }

    { 1021;2   ;Field     ;
                Name=Field11;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[11];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[11];
                Visible=Field11Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(11);
                              DrillDown(TRUE);
                            END;
                             }

    { 1022;2   ;Field     ;
                Name=Field12;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[12];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[12];
                Visible=Field12Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(12);
                              DrillDown(TRUE);
                            END;
                             }

    { 1023;2   ;Field     ;
                Name=Field13;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[13];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[13];
                Visible=Field13Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(13);
                              DrillDown(TRUE);
                            END;
                             }

    { 1024;2   ;Field     ;
                Name=Field14;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[14];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[14];
                Visible=Field14Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(14);
                              DrillDown(TRUE);
                            END;
                             }

    { 1025;2   ;Field     ;
                Name=Field15;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[15];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[15];
                Visible=Field15Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(15);
                              DrillDown(TRUE);
                            END;
                             }

    { 1026;2   ;Field     ;
                Name=Field16;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[16];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[16];
                Visible=Field16Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnAssistEdit=BEGIN
                               MATRIX_UpdateMatrixRecord(16);
                               DrillDown(TRUE);
                             END;
                              }

    { 1027;2   ;Field     ;
                Name=Field17;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[17];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[17];
                Visible=Field17Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(17);
                              DrillDown(TRUE);
                            END;
                             }

    { 1028;2   ;Field     ;
                Name=Field18;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[18];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[18];
                Visible=Field18Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(18);
                              DrillDown(TRUE);
                            END;
                             }

    { 1029;2   ;Field     ;
                Name=Field19;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[19];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[19];
                Visible=Field19Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(19);
                              DrillDown(TRUE);
                            END;
                             }

    { 1030;2   ;Field     ;
                Name=Field20;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[20];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[20];
                Visible=Field20Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(20);
                              DrillDown(TRUE);
                            END;
                             }

    { 1031;2   ;Field     ;
                Name=Field21;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[21];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[21];
                Visible=Field21Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(21);
                              DrillDown(TRUE);
                            END;
                             }

    { 1032;2   ;Field     ;
                Name=Field22;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[22];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[22];
                Visible=Field22Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(22);
                              DrillDown(TRUE);
                            END;
                             }

    { 1033;2   ;Field     ;
                Name=Field23;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[23];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[23];
                Visible=Field23Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(23);
                              DrillDown(TRUE);
                            END;
                             }

    { 1034;2   ;Field     ;
                Name=Field24;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[24];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[24];
                Visible=Field24Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(24);
                              DrillDown(TRUE);
                            END;
                             }

    { 1035;2   ;Field     ;
                Name=Field25;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[25];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[25];
                Visible=Field25Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(25);
                              DrillDown(TRUE);
                            END;
                             }

    { 1036;2   ;Field     ;
                Name=Field26;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[26];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[26];
                Visible=Field26Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(26);
                              DrillDown(TRUE);
                            END;
                             }

    { 1037;2   ;Field     ;
                Name=Field27;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[27];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[27];
                Visible=Field27Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(27);
                              DrillDown(TRUE);
                            END;
                             }

    { 1038;2   ;Field     ;
                Name=Field28;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[28];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[28];
                Visible=Field28Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(28);
                              DrillDown(TRUE);
                            END;
                             }

    { 1039;2   ;Field     ;
                Name=Field29;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[29];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[29];
                Visible=Field29Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(29);
                              DrillDown(TRUE);
                            END;
                             }

    { 1040;2   ;Field     ;
                Name=Field30;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[30];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[30];
                Visible=Field30Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(30);
                              DrillDown(TRUE);
                            END;
                             }

    { 1041;2   ;Field     ;
                Name=Field31;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[31];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[31];
                Visible=Field31Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(31);
                              DrillDown(TRUE);
                            END;
                             }

    { 1042;2   ;Field     ;
                Name=Field32;
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[32];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + ColumnCaptions[32];
                Visible=Field32Visible;
                Style=Strong;
                StyleExpr=Emphasize;
                OnDrillDown=BEGIN
                              MATRIX_UpdateMatrixRecord(32);
                              DrillDown(TRUE);
                            END;
                             }

  }
  CODE
  {
    VAR
      Text000@1080 : TextConst 'DAN=Periode;ENU=Period';
      Text002@1082 : TextConst 'DAN=Du har ikke angivet en analysevisning.;ENU=You have not yet defined an analysis view.';
      MatrixRecord@1003 : TEMPORARY Record 367;
      GLSetup@1089 : Record 98;
      AnalysisView@1091 : Record 363;
      AnalysisViewEntry@1092 : Record 365;
      AnalysisViewBudgetEntry@1093 : Record 366;
      AVBreakdownBuffer@1094 : TEMPORARY Record 375;
      Currency@1095 : Record 4;
      CurrExchRate@1096 : Record 330;
      PeriodOption@1006 : Record 2000000007;
      MatrixMgt@1005 : Codeunit 9200;
      AnalysisViewCode@1097 : Code[10];
      LineDimOption@1098 : 'G/L Account,Period,Business Unit,Dimension 1,Dimension 2,Dimension 3,Dimension 4,Cash Flow Account,Cash Flow Forecast';
      ColumnDimOption@1099 : 'G/L Account,Period,Business Unit,Dimension 1,Dimension 2,Dimension 3,Dimension 4,Cash Flow Account,Cash Flow Forecast';
      LineDimCode@1100 : Text[30];
      ColumnDimCode@1101 : Text[30];
      PeriodType@1102 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      AmountType@1103 : 'Net Change,Balance at Date';
      RoundingFactor@1104 : 'None,1,1000,1000000';
      AmountField@1105 : 'Amount,Debit Amount,Credit Amount';
      ShowActualBudg@1106 : 'Actual Amounts,Budgeted Amounts,Variance,Variance%,Index%,Amounts';
      ShowInAddCurr@1107 : Boolean;
      ShowOppositeSign@1108 : Boolean;
      ClosingEntryFilter@1109 : 'Include,Exclude';
      ShowColumnName@1110 : Boolean;
      DateFilter@1111 : Text;
      CashFlowFilter@1025 : Text;
      ExcludeClosingDateFilter@1113 : Text;
      MATRIX_CellData@1128 : ARRAY [32] OF Decimal;
      MATRIX_PrimKeyFirstCol@1004 : Text[1024];
      AccountFilter@1114 : Text;
      BudgetFilter@1115 : Text;
      Dim1Filter@1116 : Text;
      Dim2Filter@1117 : Text;
      Dim3Filter@1118 : Text;
      Dim4Filter@1119 : Text;
      MatrixAmount@1121 : Decimal;
      CurrExchDate@1123 : Date;
      BusUnitFilter@1124 : Text;
      MATRIX_ColumnOrdinal@1126 : Integer;
      MATRIX_NoOfMatrixColumns@1127 : Integer;
      ColumnCaptions@1000 : ARRAY [32] OF Text[250];
      RoundingFactorFormatString@1039 : Text;
      GLAccountSource@1014 : Boolean;
      Field1Visible@19069335 : Boolean INDATASET;
      Field2Visible@19014807 : Boolean INDATASET;
      Field3Visible@19062679 : Boolean INDATASET;
      Field4Visible@19074839 : Boolean INDATASET;
      Field5Visible@19043543 : Boolean INDATASET;
      Field6Visible@19067287 : Boolean INDATASET;
      Field7Visible@19067863 : Boolean INDATASET;
      Field8Visible@19039959 : Boolean INDATASET;
      Field9Visible@19008663 : Boolean INDATASET;
      Field10Visible@19006501 : Boolean INDATASET;
      Field11Visible@19052468 : Boolean INDATASET;
      Field12Visible@19013039 : Boolean INDATASET;
      Field13Visible@19079726 : Boolean INDATASET;
      Field14Visible@19077225 : Boolean INDATASET;
      Field15Visible@19035896 : Boolean INDATASET;
      Field16Visible@19003763 : Boolean INDATASET;
      Field17Visible@19049730 : Boolean INDATASET;
      Field18Visible@19007213 : Boolean INDATASET;
      Field19Visible@19053180 : Boolean INDATASET;
      Field20Visible@19014629 : Boolean INDATASET;
      Field21Visible@19060596 : Boolean INDATASET;
      Field22Visible@19021167 : Boolean INDATASET;
      Field23Visible@19047854 : Boolean INDATASET;
      Field24Visible@19045353 : Boolean INDATASET;
      Field25Visible@19004024 : Boolean INDATASET;
      Field26Visible@19011891 : Boolean INDATASET;
      Field27Visible@19057858 : Boolean INDATASET;
      Field28Visible@19015341 : Boolean INDATASET;
      Field29Visible@19061308 : Boolean INDATASET;
      Field30Visible@19010597 : Boolean INDATASET;
      Field31Visible@19056564 : Boolean INDATASET;
      Field32Visible@19017135 : Boolean INDATASET;
      Text003@1001 : TextConst 'DAN=Kontokilden %1 underst�ttes ikke.;ENU=Unsupported Account Source %1.';
      Emphasize@1002 : Boolean;
      CanRunDotNet@1007 : Boolean;

    LOCAL PROCEDURE InitRec@42(VAR DimCodeBuf@1006 : Record 367;DimOption@1005 : 'G/L Account,Period,Business Unit,Dimension 1,Dimension 2,Dimension 3,Dimension 4,Cash Flow Account,Cash Flow Forecast');
    VAR
      GLAccount@1003 : Record 15;
      CashFlowAccount@1000 : Record 841;
      BusinessUnit@1001 : Record 220;
      CashFlowForecast@1002 : Record 840;
    BEGIN
      CASE DimOption OF
        DimOption::"G/L Account":
          BEGIN
            IF AccountFilter <> '' THEN
              GLAccount.SETFILTER("No.",AccountFilter);
            IF GLAccount.FINDSET THEN
              REPEAT
                CopyGLAccToBuf(GLAccount,DimCodeBuf);
              UNTIL GLAccount.NEXT = 0;
          END;
        DimOption::"Cash Flow Account":
          BEGIN
            IF AccountFilter <> '' THEN
              CashFlowAccount.SETFILTER("No.",AccountFilter);
            IF CashFlowAccount.FINDSET THEN
              REPEAT
                CopyCFAccToBuf(CashFlowAccount,DimCodeBuf);
              UNTIL CashFlowAccount.NEXT = 0;
          END;
        DimOption::Period:
          BEGIN
            PeriodOption.SETRANGE("Period Type",PeriodType);
            IF DateFilter <> '' THEN BEGIN
              PeriodOption.FILTERGROUP(2);
              PeriodOption.SETFILTER("Period Start",DateFilter);
              PeriodOption.FILTERGROUP(0);
            END;
          END;
        DimOption::"Business Unit":
          BEGIN
            IF BusUnitFilter <> '' THEN
              BusinessUnit.SETFILTER(Code,BusUnitFilter);
            IF BusinessUnit.FINDSET THEN
              REPEAT
                CopyBusUnitToBuf(BusinessUnit,DimCodeBuf);
              UNTIL BusinessUnit.NEXT = 0;
          END;
        DimOption::"Cash Flow Forecast":
          BEGIN
            IF CashFlowFilter <> '' THEN
              CashFlowForecast.SETFILTER("No.",CashFlowFilter);
            IF CashFlowForecast.FINDSET THEN
              REPEAT
                CopyCashFlowToBuf(CashFlowForecast,DimCodeBuf);
              UNTIL CashFlowForecast.NEXT = 0;
          END;
        DimOption::"Dimension 1":
          InitDimValue(
            DimCodeBuf,AnalysisView."Dimension 1 Code",Dim1Filter);
        DimOption::"Dimension 2":
          InitDimValue(
            DimCodeBuf,AnalysisView."Dimension 2 Code",Dim2Filter);
        DimOption::"Dimension 3":
          InitDimValue(
            DimCodeBuf,AnalysisView."Dimension 3 Code",Dim3Filter);
        DimOption::"Dimension 4":
          InitDimValue(
            DimCodeBuf,AnalysisView."Dimension 4 Code",Dim4Filter);
      END;
      IF FINDFIRST THEN;
    END;

    LOCAL PROCEDURE FindRec@4(DimOption@1000 : 'G/L Account,Period,Business Unit,Dimension 1,Dimension 2,Dimension 3,Dimension 4,Cash Flow Account,Cash Flow Forecast';VAR DimCodeBuf@1001 : Record 367;Which@1002 : Text[250]) : Boolean;
    BEGIN
      CASE DimOption OF
        DimOption::"G/L Account",
        DimOption::"Cash Flow Account",
        DimOption::"Business Unit",
        DimOption::"Cash Flow Forecast",
        DimOption::"Dimension 1",
        DimOption::"Dimension 2",
        DimOption::"Dimension 3",
        DimOption::"Dimension 4":
          EXIT(DimCodeBuf.FIND(Which));
        DimOption::Period:
          // Make specifial length of Which parameter in order to find PeriodFormmgt.FindDate procedure
          EXIT(FindPeriod(DimCodeBuf,COPYSTR(Which,1,3)));
      END;
    END;

    LOCAL PROCEDURE NextRec@1138(DimOption@1000 : 'G/L Account,Period,Business Unit,Dimension 1,Dimension 2,Dimension 3,Dimension 4,Cash Flow Account,Cash Flow Forecast';VAR DimCodeBuf@1001 : Record 367;Steps@1002 : Integer) : Integer;
    BEGIN
      CASE DimOption OF
        DimOption::"G/L Account",
        DimOption::"Cash Flow Account",
        DimOption::"Business Unit",
        DimOption::"Cash Flow Forecast",
        DimOption::"Dimension 1",
        DimOption::"Dimension 2",
        DimOption::"Dimension 3",
        DimOption::"Dimension 4":
          EXIT(DimCodeBuf.NEXT(Steps));
        DimOption::Period:
          EXIT(NextPeriod(DimCodeBuf,Steps));
      END;
    END;

    LOCAL PROCEDURE CopyGLAccToBuf@1145(VAR TheGLAcc@1000 : Record 15;VAR TheDimCodeBuf@1001 : Record 367);
    BEGIN
      WITH TheDimCodeBuf DO BEGIN
        INIT;
        Code := TheGLAcc."No.";
        Name := TheGLAcc.Name;
        Totaling := TheGLAcc.Totaling;
        Indentation := TheGLAcc.Indentation;
        "Show in Bold" := TheGLAcc."Account Type" <> TheGLAcc."Account Type"::Posting;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE CopyCFAccToBuf@1372(VAR TheCFAcc@1000 : Record 841;VAR TheDimCodeBuf@1001 : Record 367);
    BEGIN
      WITH TheDimCodeBuf DO BEGIN
        INIT;
        Code := TheCFAcc."No.";
        Name := TheCFAcc.Name;
        Totaling := TheCFAcc.Totaling;
        Indentation := TheCFAcc.Indentation;
        "Show in Bold" := TheCFAcc."Account Type" <> TheCFAcc."Account Type"::Entry;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE CopyPeriodToBuf@1146(VAR ThePeriod@1000 : Record 2000000007;VAR TheDimCodeBuf@1001 : Record 367);
    VAR
      Period2@1147 : Record 2000000007;
    BEGIN
      WITH TheDimCodeBuf DO BEGIN
        INIT;
        Code := FORMAT(ThePeriod."Period Start");
        "Period Start" := ThePeriod."Period Start";
        IF ClosingEntryFilter = ClosingEntryFilter::Include THEN
          "Period End" := CLOSINGDATE(ThePeriod."Period End")
        ELSE
          "Period End" := ThePeriod."Period End";
        IF DateFilter <> '' THEN BEGIN
          Period2.SETFILTER("Period End",DateFilter);
          IF Period2.GETRANGEMAX("Period End") < "Period End" THEN
            "Period End" := Period2.GETRANGEMAX("Period End");
        END;
        Name := ThePeriod."Period Name";
        IF INSERT THEN;
      END;
    END;

    LOCAL PROCEDURE CopyBusUnitToBuf@1148(VAR TheBusUnit@1000 : Record 220;VAR TheDimCodeBuf@1001 : Record 367);
    BEGIN
      WITH TheDimCodeBuf DO BEGIN
        INIT;
        Code := TheBusUnit.Code;
        Name := TheBusUnit.Name;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE CopyCashFlowToBuf@1375(VAR TheCashFlowForecast@1000 : Record 840;VAR TheDimCodeBuf@1001 : Record 367);
    BEGIN
      WITH TheDimCodeBuf DO BEGIN
        INIT;
        Code := TheCashFlowForecast."No.";
        Name := TheCashFlowForecast.Description;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE CopyDimValueToBuf@1149(VAR TheDimVal@1000 : Record 349;VAR TheDimCodeBuf@1001 : Record 367);
    BEGIN
      WITH TheDimCodeBuf DO BEGIN
        INIT;
        Code := TheDimVal.Code;
        Name := TheDimVal.Name;
        Totaling := TheDimVal.Totaling;
        Indentation := TheDimVal.Indentation;
        "Show in Bold" :=
          TheDimVal."Dimension Value Type" <> TheDimVal."Dimension Value Type"::Standard;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE CalculateClosingDateFilter@1153();
    VAR
      AccountingPeriod@1154 : Record 50;
      FirstRec@1155 : Boolean;
    BEGIN
      IF ClosingEntryFilter = ClosingEntryFilter::Include THEN
        ExcludeClosingDateFilter := ''
      ELSE BEGIN
        AccountingPeriod.SETCURRENTKEY("New Fiscal Year");
        AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
        FirstRec := TRUE;
        IF AccountingPeriod.FIND('-') THEN
          REPEAT
            IF FirstRec THEN
              ExcludeClosingDateFilter :=
                STRSUBSTNO('<>%1',CLOSINGDATE(AccountingPeriod."Starting Date" - 1))
            ELSE
              ExcludeClosingDateFilter :=
                ExcludeClosingDateFilter + STRSUBSTNO('&<>%1',CLOSINGDATE(AccountingPeriod."Starting Date" - 1));
            FirstRec := FALSE;
          UNTIL AccountingPeriod.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE LookUpCode@1160(DimOption@1000 : 'G/L Account,Period,Business Unit,Dimension 1,Dimension 2,Dimension 3,Dimension 4,Cash Flow Account,Cash Flow Forecast';DimCode@1001 : Text[30];Code@1002 : Text[30]);
    VAR
      GLAcc@1161 : Record 15;
      BusUnit@1162 : Record 220;
      CFAccount@1385 : Record 841;
      CashFlowForecast@1386 : Record 840;
      DimVal@1163 : Record 349;
    BEGIN
      CASE DimOption OF
        DimOption::"G/L Account":
          BEGIN
            GLAcc.GET(Code);
            PAGE.RUNMODAL(PAGE::"G/L Account List",GLAcc);
          END;
        DimOption::Period:
          ;
        DimOption::"Business Unit":
          BEGIN
            BusUnit.GET(Code);
            PAGE.RUNMODAL(PAGE::"Business Unit List",BusUnit);
          END;
        DimOption::"Cash Flow Account":
          BEGIN
            CFAccount.GET(Code);
            PAGE.RUNMODAL(PAGE::"Cash Flow Account List",CFAccount);
          END;
        DimOption::"Cash Flow Forecast":
          BEGIN
            CashFlowForecast.GET(Code);
            PAGE.RUNMODAL(PAGE::"Cash Flow Forecast List",CashFlowForecast);
          END;
        DimOption::"Dimension 1",DimOption::"Dimension 2",
        DimOption::"Dimension 3",DimOption::"Dimension 4":
          BEGIN
            DimVal.SETRANGE("Dimension Code",DimCode);
            DimVal.GET(DimCode,Code);

            PAGE.RUNMODAL(PAGE::"Dimension Value List",DimVal);
          END;
      END;
    END;

    LOCAL PROCEDURE SetCommonFilters@1168(VAR TheAnalysisViewEntry@1000 : Record 365);
    VAR
      DateFilter2@1169 : Text;
    BEGIN
      WITH TheAnalysisViewEntry DO BEGIN
        IF DateFilter = '' THEN
          DateFilter2 := ExcludeClosingDateFilter
        ELSE BEGIN
          IF AmountType = AmountType::"Net Change" THEN BEGIN
            DateFilter2 := DateFilter;
          END ELSE BEGIN
            SETFILTER("Posting Date",DateFilter);
            DateFilter2 := STRSUBSTNO('..%1',GETRANGEMAX("Posting Date"));
          END;
          IF ExcludeClosingDateFilter <> '' THEN
            DateFilter2 := STRSUBSTNO('%1 & %2',DateFilter2,ExcludeClosingDateFilter);
        END;
        RESET;

        SETRANGE("Analysis View Code",AnalysisView.Code);
        IF BusUnitFilter <> '' THEN
          SETFILTER("Business Unit Code",BusUnitFilter);
        IF CashFlowFilter <> '' THEN
          SETFILTER("Cash Flow Forecast No.",CashFlowFilter);

        IF AccountFilter <> '' THEN
          SETFILTER("Account No.",AccountFilter);

        SETRANGE("Account Source",AnalysisView."Account Source");

        SETFILTER("Posting Date",DateFilter2);
        IF Dim1Filter <> '' THEN
          SETFILTER("Dimension 1 Value Code",GetDimValueTotaling(Dim1Filter,AnalysisView."Dimension 1 Code"));
        IF Dim2Filter <> '' THEN
          SETFILTER("Dimension 2 Value Code",GetDimValueTotaling(Dim2Filter,AnalysisView."Dimension 2 Code"));
        IF Dim3Filter <> '' THEN
          SETFILTER("Dimension 3 Value Code",GetDimValueTotaling(Dim3Filter,AnalysisView."Dimension 3 Code"));
        IF Dim4Filter <> '' THEN
          SETFILTER("Dimension 4 Value Code",GetDimValueTotaling(Dim4Filter,AnalysisView."Dimension 4 Code"));
      END;
    END;

    LOCAL PROCEDURE SetDimFilters@1170(VAR TheAnalysisViewEntry@1000 : Record 365;LineOrColumn@1001 : 'Line,Column');
    VAR
      DimCodeBuf@1002 : Record 367;
      DimOption@1171 : 'G/L Account,Period,Business Unit,Dimension 1,Dimension 2,Dimension 3,Dimension 4,Cash Flow Account,Cash Flow Forecast';
    BEGIN
      IF LineOrColumn = LineOrColumn::Line THEN BEGIN
        DimCodeBuf := Rec;
        DimOption := LineDimOption;
      END ELSE BEGIN
        DimCodeBuf := MatrixRecord;
        DimOption := ColumnDimOption;
      END;
      CASE DimOption OF
        DimOption::"G/L Account",
        DimOption::"Cash Flow Account":
          IF DimCodeBuf.Totaling = '' THEN
            TheAnalysisViewEntry.SETRANGE("Account No.",DimCodeBuf.Code)
          ELSE
            TheAnalysisViewEntry.SETFILTER("Account No.",DimCodeBuf.Totaling);
        DimOption::Period:
          BEGIN
            IF AmountType = AmountType::"Net Change" THEN
              TheAnalysisViewEntry.SETRANGE(
                "Posting Date",DimCodeBuf."Period Start",DimCodeBuf."Period End")
            ELSE
              TheAnalysisViewEntry.SETRANGE("Posting Date",0D,DimCodeBuf."Period End");
            IF (ClosingEntryFilter = ClosingEntryFilter::Exclude) AND (ExcludeClosingDateFilter <> '') THEN
              TheAnalysisViewEntry.SETFILTER(
                "Posting Date",TheAnalysisViewEntry.GETFILTER("Posting Date") +
                '&' + ExcludeClosingDateFilter);
          END;
        DimOption::"Business Unit":
          TheAnalysisViewEntry.SETRANGE("Business Unit Code",DimCodeBuf.Code);
        DimOption::"Cash Flow Forecast":
          TheAnalysisViewEntry.SETRANGE("Cash Flow Forecast No.",DimCodeBuf.Code);
        DimOption::"Dimension 1":
          IF DimCodeBuf.Totaling = '' THEN
            TheAnalysisViewEntry.SETRANGE("Dimension 1 Value Code",DimCodeBuf.Code)
          ELSE
            TheAnalysisViewEntry.SETFILTER("Dimension 1 Value Code",DimCodeBuf.Totaling);
        DimOption::"Dimension 2":
          IF DimCodeBuf.Totaling = '' THEN
            TheAnalysisViewEntry.SETRANGE("Dimension 2 Value Code",DimCodeBuf.Code)
          ELSE
            TheAnalysisViewEntry.SETFILTER("Dimension 2 Value Code",DimCodeBuf.Totaling);
        DimOption::"Dimension 3":
          IF DimCodeBuf.Totaling = '' THEN
            TheAnalysisViewEntry.SETRANGE("Dimension 3 Value Code",DimCodeBuf.Code)
          ELSE
            TheAnalysisViewEntry.SETFILTER("Dimension 3 Value Code",DimCodeBuf.Totaling);
        DimOption::"Dimension 4":
          IF DimCodeBuf.Totaling = '' THEN
            TheAnalysisViewEntry.SETRANGE("Dimension 4 Value Code",DimCodeBuf.Code)
          ELSE
            TheAnalysisViewEntry.SETFILTER("Dimension 4 Value Code",DimCodeBuf.Totaling);
      END;
    END;

    LOCAL PROCEDURE SetCommonBudgetFilters@1173(VAR TheAnalysisViewBudgetEntry@1000 : Record 366);
    BEGIN
      WITH TheAnalysisViewBudgetEntry DO BEGIN
        RESET;
        SETRANGE("Analysis View Code",AnalysisView.Code);
        IF BusUnitFilter <> '' THEN
          SETFILTER("Business Unit Code",BusUnitFilter);
        IF BudgetFilter <> '' THEN
          SETFILTER("Budget Name",BudgetFilter);
        IF AccountFilter <> '' THEN
          SETFILTER("G/L Account No.",AccountFilter);
        IF DateFilter <> '' THEN
          SETFILTER("Posting Date",DateFilter);
        IF Dim1Filter <> '' THEN
          SETFILTER("Dimension 1 Value Code",GetDimValueTotaling(Dim1Filter,AnalysisView."Dimension 1 Code"));
        IF Dim2Filter <> '' THEN
          SETFILTER("Dimension 2 Value Code",GetDimValueTotaling(Dim2Filter,AnalysisView."Dimension 2 Code"));
        IF Dim3Filter <> '' THEN
          SETFILTER("Dimension 3 Value Code",GetDimValueTotaling(Dim3Filter,AnalysisView."Dimension 3 Code"));
        IF Dim4Filter <> '' THEN
          SETFILTER("Dimension 4 Value Code",GetDimValueTotaling(Dim4Filter,AnalysisView."Dimension 4 Code"));
      END;
    END;

    LOCAL PROCEDURE SetDimBudgetFilters@1174(VAR TheAnalysisViewBudgetEntry@1000 : Record 366;LineOrColumn@1001 : 'Line,Column');
    VAR
      DimCodeBuf@1002 : Record 367;
      DimOption@1175 : 'G/L Account,Period,Business Unit,Dimension 1,Dimension 2,Dimension 3,Dimension 4,Cash Flow Account,CashFlow';
    BEGIN
      IF LineOrColumn = LineOrColumn::Line THEN BEGIN
        DimCodeBuf := Rec;
        DimOption := LineDimOption;
      END ELSE BEGIN
        DimCodeBuf := MatrixRecord;
        DimOption := ColumnDimOption;
      END;
      CASE DimOption OF
        DimOption::"G/L Account":
          IF DimCodeBuf.Totaling = '' THEN
            TheAnalysisViewBudgetEntry.SETRANGE("G/L Account No.",DimCodeBuf.Code)
          ELSE
            TheAnalysisViewBudgetEntry.SETFILTER("G/L Account No.",DimCodeBuf.Totaling);
        DimOption::Period:
          IF AmountType = AmountType::"Net Change" THEN
            TheAnalysisViewBudgetEntry.SETRANGE(
              "Posting Date",DimCodeBuf."Period Start",DimCodeBuf."Period End")
          ELSE
            TheAnalysisViewBudgetEntry.SETRANGE("Posting Date",0D,DimCodeBuf."Period End");
        DimOption::"Business Unit":
          TheAnalysisViewBudgetEntry.SETRANGE("Business Unit Code",DimCodeBuf.Code);
        DimOption::"Dimension 1":
          IF DimCodeBuf.Totaling = '' THEN
            TheAnalysisViewBudgetEntry.SETRANGE("Dimension 1 Value Code",DimCodeBuf.Code)
          ELSE
            TheAnalysisViewBudgetEntry.SETFILTER("Dimension 1 Value Code",DimCodeBuf.Totaling);
        DimOption::"Dimension 2":
          IF DimCodeBuf.Totaling = '' THEN
            TheAnalysisViewBudgetEntry.SETRANGE("Dimension 2 Value Code",DimCodeBuf.Code)
          ELSE
            TheAnalysisViewBudgetEntry.SETFILTER("Dimension 2 Value Code",DimCodeBuf.Totaling);
        DimOption::"Dimension 3":
          IF DimCodeBuf.Totaling = '' THEN
            TheAnalysisViewBudgetEntry.SETRANGE("Dimension 3 Value Code",DimCodeBuf.Code)
          ELSE
            TheAnalysisViewBudgetEntry.SETFILTER("Dimension 3 Value Code",DimCodeBuf.Totaling);
        DimOption::"Dimension 4":
          IF DimCodeBuf.Totaling = '' THEN
            TheAnalysisViewBudgetEntry.SETRANGE("Dimension 4 Value Code",DimCodeBuf.Code)
          ELSE
            TheAnalysisViewBudgetEntry.SETFILTER("Dimension 4 Value Code",DimCodeBuf.Totaling);
      END;
    END;

    LOCAL PROCEDURE DrillDown@1177(SetColFilter@1000 : Boolean);
    BEGIN
      IF ShowActualBudg = ShowActualBudg::"Actual Amounts" THEN BEGIN
        SetCommonFilters(AnalysisViewEntry);
        SetDimFilters(AnalysisViewEntry,0);
        IF SetColFilter THEN
          SetDimFilters(AnalysisViewEntry,1);
        PAGE.RUN(PAGE::"Analysis View Entries",AnalysisViewEntry);
      END;
      IF ShowActualBudg = ShowActualBudg::"Budgeted Amounts" THEN BEGIN
        SetCommonBudgetFilters(AnalysisViewBudgetEntry);
        SetDimBudgetFilters(AnalysisViewBudgetEntry,0);
        IF SetColFilter THEN
          SetDimBudgetFilters(AnalysisViewBudgetEntry,1);
        PAGE.RUN(PAGE::"Analysis View Budget Entries",AnalysisViewBudgetEntry);
      END;
      IF ShowActualBudg = ShowActualBudg::Amounts THEN BEGIN
        SetCommonFilters(AnalysisViewEntry);
        SetDimFilters(AnalysisViewEntry,0);
        IF SetColFilter THEN
          SetDimFilters(AnalysisViewEntry,1);
        PAGE.RUN(PAGE::"Analysis View Entries",AnalysisViewEntry);
      END;
    END;

    LOCAL PROCEDURE ValidateAnalysisViewCode@1178();
    BEGIN
      AnalysisView.Code := AnalysisViewCode;
      IF NOT AnalysisView.FIND('=<>') THEN
        ERROR(Text002);
      AnalysisViewCode := AnalysisView.Code;

      CASE AnalysisView."Account Source" OF
        AnalysisView."Account Source"::"G/L Account":
          GLAccountSource := TRUE;
        AnalysisView."Account Source"::"Cash Flow Account":
          GLAccountSource := FALSE;
        ELSE
          ERROR(Text003,AnalysisView."Account Source");
      END;
    END;

    LOCAL PROCEDURE CalcAmount@1184(SetColFilter@1000 : Boolean) : Decimal;
    VAR
      Amount@1185 : Decimal;
      ColumnCode@1186 : Code[20];
    BEGIN
      IF SetColFilter THEN
        ColumnCode := MatrixRecord.Code
      ELSE
        ColumnCode := '';
      IF AVBreakdownBuffer.GET(Code,ColumnCode) THEN
        EXIT(AVBreakdownBuffer.Amount);
      CASE ShowActualBudg OF
        ShowActualBudg::"Actual Amounts":
          Amount := CalcActualAmount(SetColFilter);
        ShowActualBudg::Amounts:
          Amount := CalcActualAmount(SetColFilter);
        ShowActualBudg::"Budgeted Amounts":
          Amount := CalcBudgAmount(SetColFilter);
        ShowActualBudg::Variance:
          Amount := CalcActualAmount(SetColFilter) - CalcBudgAmount(SetColFilter);
        ShowActualBudg::"Variance%":
          BEGIN
            Amount := CalcBudgAmount(SetColFilter);
            IF Amount <> 0 THEN
              Amount := ROUND(100 * (CalcActualAmount(SetColFilter) - Amount) / Amount);
          END;
        ShowActualBudg::"Index%":
          BEGIN
            Amount := CalcBudgAmount(SetColFilter);
            IF Amount <> 0 THEN
              Amount := ROUND(100 * CalcActualAmount(SetColFilter) / Amount);
          END;
      END;
      IF ShowOppositeSign THEN
        Amount := -Amount;
      AVBreakdownBuffer."Line Code" := Code;
      AVBreakdownBuffer."Column Code" := ColumnCode;
      AVBreakdownBuffer.Amount := Amount;
      AVBreakdownBuffer.INSERT;
      EXIT(Amount);
    END;

    LOCAL PROCEDURE CalcActualAmount@1187(SetColFilter@1000 : Boolean) : Decimal;
    VAR
      Amount@1188 : Decimal;
    BEGIN
      AnalysisViewEntry.RESET;
      SetCommonFilters(AnalysisViewEntry);
      SetDimFilters(AnalysisViewEntry,0);
      IF SetColFilter THEN
        SetDimFilters(AnalysisViewEntry,1);
      IF ShowInAddCurr THEN
        CASE AmountField OF
          AmountField::Amount:
            BEGIN
              AnalysisViewEntry.CALCSUMS("Add.-Curr. Amount");
              Amount := AnalysisViewEntry."Add.-Curr. Amount";
            END;
          AmountField::"Debit Amount":
            BEGIN
              AnalysisViewEntry.CALCSUMS("Add.-Curr. Debit Amount");
              Amount := AnalysisViewEntry."Add.-Curr. Debit Amount";
            END;
          AmountField::"Credit Amount":
            BEGIN
              AnalysisViewEntry.CALCSUMS("Add.-Curr. Credit Amount");
              Amount := AnalysisViewEntry."Add.-Curr. Credit Amount";
            END;
        END
      ELSE
        CASE AmountField OF
          AmountField::Amount:
            BEGIN
              AnalysisViewEntry.CALCSUMS(Amount);
              Amount := AnalysisViewEntry.Amount;
            END;
          AmountField::"Debit Amount":
            BEGIN
              AnalysisViewEntry.CALCSUMS("Debit Amount");
              Amount := AnalysisViewEntry."Debit Amount";
            END;
          AmountField::"Credit Amount":
            BEGIN
              AnalysisViewEntry.CALCSUMS("Credit Amount");
              Amount := AnalysisViewEntry."Credit Amount";
            END;
        END;
      EXIT(Amount);
    END;

    LOCAL PROCEDURE CalcBudgAmount@1189(SetColFilter@1000 : Boolean) : Decimal;
    VAR
      Amount@1190 : Decimal;
    BEGIN
      AnalysisViewBudgetEntry.RESET;
      SetCommonBudgetFilters(AnalysisViewBudgetEntry);
      SetDimBudgetFilters(AnalysisViewBudgetEntry,0);
      IF SetColFilter THEN
        SetDimBudgetFilters(AnalysisViewBudgetEntry,1);
      AnalysisViewBudgetEntry.CALCSUMS(Amount);
      Amount := AnalysisViewBudgetEntry.Amount;
      CASE AmountField OF
        AmountField::"Debit Amount":
          IF Amount < 0 THEN
            Amount := 0;
        AmountField::"Credit Amount":
          IF Amount > 0 THEN
            Amount := 0
          ELSE
            Amount := -Amount;
      END;
      IF (Amount <> 0) AND ShowInAddCurr THEN BEGIN
        IF AnalysisViewBudgetEntry.GETFILTER("Posting Date") = '' THEN
          CurrExchDate := WORKDATE
        ELSE
          CurrExchDate := AnalysisViewBudgetEntry.GETRANGEMIN("Posting Date");
        Amount :=
          ROUND(
            CurrExchRate.ExchangeAmtLCYToFCY(
              CurrExchDate,GLSetup."Additional Reporting Currency",Amount,
              CurrExchRate.ExchangeRate(CurrExchDate,GLSetup."Additional Reporting Currency")),
            Currency."Amount Rounding Precision");
      END;
      EXIT(Amount);
    END;

    LOCAL PROCEDURE MATRIX_UpdateMatrixRecord@1193(MATRIX_NewColumnOrdinal@1005 : Integer);
    BEGIN
      MATRIX_ColumnOrdinal := MATRIX_NewColumnOrdinal;
      MatrixRecord.SETPOSITION(MATRIX_PrimKeyFirstCol);
      MATRIX_OnFindRecord('=');
      IF MATRIX_ColumnOrdinal <> 1 THEN
        MATRIX_OnNextRecord(MATRIX_ColumnOrdinal - 1);
    END;

    LOCAL PROCEDURE MATRIX_OnFindRecord@1195(Which@1007 : Text[1024]) : Boolean;
    BEGIN
      EXIT(FindRec(ColumnDimOption,MatrixRecord,Which));
    END;

    LOCAL PROCEDURE MATRIX_OnNextRecord@1196(Steps@1008 : Integer) : Integer;
    BEGIN
      EXIT(NextRec(ColumnDimOption,MatrixRecord,Steps));
    END;

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@1197();
    BEGIN
      MatrixAmount := MatrixMgt.RoundValue(CalcAmount(TRUE),RoundingFactor);

      MATRIX_CellData[MATRIX_ColumnOrdinal] := MatrixAmount;
    END;

    [External]
    PROCEDURE SetVisible@8();
    BEGIN
      Field1Visible := ColumnCaptions[1] <> '';
      Field2Visible := ColumnCaptions[2] <> '';
      Field3Visible := ColumnCaptions[3] <> '';
      Field4Visible := ColumnCaptions[4] <> '';
      Field5Visible := ColumnCaptions[5] <> '';
      Field6Visible := ColumnCaptions[6] <> '';
      Field7Visible := ColumnCaptions[7] <> '';
      Field8Visible := ColumnCaptions[8] <> '';
      Field9Visible := ColumnCaptions[9] <> '';
      Field10Visible := ColumnCaptions[10] <> '';
      Field11Visible := ColumnCaptions[11] <> '';
      Field12Visible := ColumnCaptions[12] <> '';
      Field13Visible := ColumnCaptions[13] <> '';
      Field14Visible := ColumnCaptions[14] <> '';
      Field15Visible := ColumnCaptions[15] <> '';
      Field16Visible := ColumnCaptions[16] <> '';
      Field17Visible := ColumnCaptions[17] <> '';
      Field18Visible := ColumnCaptions[18] <> '';
      Field19Visible := ColumnCaptions[19] <> '';
      Field20Visible := ColumnCaptions[20] <> '';
      Field21Visible := ColumnCaptions[21] <> '';
      Field22Visible := ColumnCaptions[22] <> '';
      Field23Visible := ColumnCaptions[23] <> '';
      Field24Visible := ColumnCaptions[24] <> '';
      Field25Visible := ColumnCaptions[25] <> '';
      Field26Visible := ColumnCaptions[26] <> '';
      Field27Visible := ColumnCaptions[27] <> '';
      Field28Visible := ColumnCaptions[28] <> '';
      Field29Visible := ColumnCaptions[29] <> '';
      Field30Visible := ColumnCaptions[30] <> '';
      Field31Visible := ColumnCaptions[31] <> '';
      Field32Visible := ColumnCaptions[32] <> '';
    END;

    [External]
    PROCEDURE Load@3(LineDimOptionLocal@1015 : Option;ColumnDimOptionLocal@1000 : Option;LineDimCodeLocal@1020 : Text[30];ColumnDimCodeLocal@1019 : Text[30];NewPeriodType@1002 : Option;NewDateFilter@1003 : Text;NewAccountFilter@1004 : Text;NewBusUnitFilter@1001 : Text;NewBudgetFilter@1005 : Text;NewDim1Filter@1006 : Text;NewDim2Filter@1007 : Text;NewDim3Filter@1016 : Text;NewDim4Filter@1017 : Text;NewCashFlowFilter@1111 : Text);
    BEGIN
      LineDimOption := LineDimOptionLocal;
      ColumnDimOption := ColumnDimOptionLocal;
      LineDimCode := LineDimCodeLocal;
      ColumnDimCode := ColumnDimCodeLocal;
      PeriodType := NewPeriodType;
      DateFilter := NewDateFilter;
      AccountFilter := NewAccountFilter;
      BusUnitFilter := NewBusUnitFilter;
      BudgetFilter := NewBudgetFilter;
      CashFlowFilter := NewCashFlowFilter;
      Dim1Filter := NewDim1Filter;
      Dim2Filter := NewDim2Filter;
      Dim3Filter := NewDim3Filter;
      Dim4Filter := NewDim4Filter;
    END;

    [External]
    PROCEDURE Load2@1(NewAmountType@1000 : Option;ViewCode@1003 : Code[50];ShowOp@1002 : Boolean;ShowColumnNameLocal@1001 : Boolean;NewShowActualBudg@1010 : Option;NewAmountField@1009 : Option;NewClosingEntryFilter@1008 : Option;NewRoundingFactor@1007 : Option;NewShowInAddCurr@1006 : Boolean;NewMATRIX_ColumnCaptions@1005 : ARRAY [32] OF Text[250];NewPrimKeyFirstCol@1004 : Text[1024]);
    BEGIN
      AmountType := NewAmountType;
      ShowOppositeSign := ShowOp;
      AnalysisViewCode := ViewCode;
      ShowColumnName := ShowColumnNameLocal;
      ShowActualBudg := NewShowActualBudg;
      AmountField := NewAmountField;
      ClosingEntryFilter := NewClosingEntryFilter;
      RoundingFactor := NewRoundingFactor;
      ShowInAddCurr := NewShowInAddCurr;
      COPYARRAY(ColumnCaptions,NewMATRIX_ColumnCaptions,1);
      MATRIX_PrimKeyFirstCol := NewPrimKeyFirstCol;
      RoundingFactorFormatString := MatrixMgt.GetFormatString(RoundingFactor,FALSE);
    END;

    LOCAL PROCEDURE FormatLine@5();
    BEGIN
      Emphasize := "Show in Bold";
    END;

    LOCAL PROCEDURE FindPeriod@37(VAR DimCodeBuf@1001 : Record 367;Which@1000 : Text[3]) Found : Boolean;
    VAR
      PeriodFormMgt@1002 : Codeunit 359;
    BEGIN
      EVALUATE(PeriodOption."Period Start",DimCodeBuf.Code);
      FilterLinePeriod(DimCodeBuf);
      Found := PeriodFormMgt.FindDate(Which,PeriodOption,PeriodType);
      IF Found THEN
        CopyPeriodToBuf(PeriodOption,DimCodeBuf);
      EXIT(Found);
    END;

    LOCAL PROCEDURE NextPeriod@18(VAR DimCodeBuf@1002 : Record 367;Steps@1000 : Integer) ResultSteps : Integer;
    VAR
      PeriodFormMgt@1170000003 : Codeunit 359;
    BEGIN
      EVALUATE(PeriodOption."Period Start",DimCodeBuf.Code);
      FilterLinePeriod(DimCodeBuf);
      ResultSteps := PeriodFormMgt.NextDate(Steps,PeriodOption,PeriodType);
      IF ResultSteps <> 0 THEN
        CopyPeriodToBuf(PeriodOption,DimCodeBuf);
      EXIT(ResultSteps);
    END;

    LOCAL PROCEDURE FilterLinePeriod@13(VAR DimCodeBuf@1000 : Record 367);
    BEGIN
      IF LineDimOption = LineDimOption::Period THEN BEGIN
        PeriodOption.SETRANGE("Period Start");
        PeriodOption.SETRANGE("Period Name");
        PeriodOption.SETFILTER("Period Start",DimCodeBuf.GETFILTER(Code));
        PeriodOption.SETFILTER("Period Name",DimCodeBuf.GETFILTER(Name));
      END;
    END;

    LOCAL PROCEDURE InitDimValue@10(VAR DimensionCodeBuffer@1000 : Record 367;DimensionCode@1003 : Code[20];DimensionFilter@1002 : Text);
    VAR
      DimensionValue@1001 : Record 349;
    BEGIN
      IF DimensionCode <> '' THEN BEGIN
        DimensionValue.SETRANGE("Dimension Code",DimensionCode);
        IF DimensionFilter <> '' THEN
          DimensionValue.SETFILTER(Code,DimensionFilter);
        IF DimensionValue.FINDSET THEN
          REPEAT
            CopyDimValueToBuf(DimensionValue,DimensionCodeBuffer);
          UNTIL DimensionValue.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE FormatStr@9() : Text;
    BEGIN
      EXIT(RoundingFactorFormatString);
    END;

    LOCAL PROCEDURE GetDimValueTotaling@6(DimValueFilter@1002 : Text;DimensionCode@1000 : Code[20]) : Text;
    VAR
      DimensionValue@1001 : Record 349;
    BEGIN
      IF DimensionCode <> '' THEN BEGIN
        DimensionValue.SETRANGE("Dimension Code",DimensionCode);
        DimensionValue.SETFILTER(Code,DimValueFilter);
        IF DimensionValue.FINDFIRST THEN
          IF DimensionValue.Totaling <> '' THEN
            EXIT(DimensionValue.Totaling);
      END;
      EXIT(DimValueFilter);
    END;

    BEGIN
    END.
  }
}

