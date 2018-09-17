OBJECT Page 9239 Sales Budget Overview Matrix
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Matrix for oversigt over salgsbudget;
               ENU=Sales Budget Overview Matrix];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table367;
    PageType=ListPart;
    RefreshOnActivate=Yes;
    OnInit=BEGIN
             QuantityVisible := TRUE;
             AmountVisible := TRUE;
           END;

    OnOpenPage=BEGIN
                 ItemBudgetManagement.BudgetNameSelection(
                   CurrentAnalysisArea,CurrentBudgetName,ItemBudgetName,ItemStatisticsBuffer,
                   BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter);

                 GLSetup.GET;
                 SourceTypeFilter := SourceTypeFilter::Customer;
               END;

    OnFindRecord=BEGIN
                   EXIT(
                     ItemBudgetManagement.FindRec(
                       ItemBudgetName,LineDimOption,Rec,Which,
                       ItemFilter,SourceNoFilter,PeriodType,DateFilter,PeriodInitialized,InternalDateFilter,
                       GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter));
                 END;

    OnNextRecord=BEGIN
                   EXIT(
                     ItemBudgetManagement.NextRec(
                       ItemBudgetName,LineDimOption,Rec,Steps,
                       ItemFilter,SourceNoFilter,PeriodType,DateFilter,
                       GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter));
                 END;

    OnAfterGetRecord=VAR
                       MATRIX_CurrentColumnOrdinal@1044 : Integer;
                     BEGIN
                       NameIndent := 0;
                       IF AmountVisible THEN
                         Amount := MatrixMgt.RoundValue(CalcAmt(ValueType::"Sales Amount",FALSE),RoundingFactor);
                       IF QuantityVisible THEN
                         Quantity := MatrixMgt.RoundValue(CalcAmt(ValueType::Quantity,FALSE),RoundingFactor);

                       MATRIX_CurrentColumnOrdinal := 0;
                       WHILE MATRIX_CurrentColumnOrdinal < MATRIX_CurrentNoOfMatrixColumn DO BEGIN
                         MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
                         MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
                       END;

                       FormatLine;
                       AmountOnFormat(FORMAT(+Amount));
                     END;

    OnAfterGetCurrRecord=BEGIN
                           IF AmountVisible THEN
                             Amount := CalcAmt(0,FALSE);
                           IF QuantityVisible THEN
                             Quantity := CalcAmt(2,FALSE);
                         END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dimensionsv�rdikoden for de dimensioner, der er valgt i feltet Vis som linjer.;
                           ENU=Specifies the dimension value code for the dimension selected in the Show as Lines field.];
                ApplicationArea=#SalesBudget;
                SourceExpr=Code;
                Editable=FALSE;
                StyleExpr='Strong' }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� dimensionsv�rdikoden p� linjen.;
                           ENU=Specifies the name of the dimension value on the line.];
                ApplicationArea=#SalesBudget;
                SourceExpr=Name;
                Editable=FALSE;
                StyleExpr='Strong' }

    { 26  ;2   ;Field     ;
                Name=Quantity;
                CaptionML=[DAN=Budgetteret antal;
                           ENU=Budgeted Quantity];
                ToolTipML=[DAN=Angiver det samlede antal for salgsbudgetposterne.;
                           ENU=Specifies the total quantity of the sales budget entries.];
                ApplicationArea=#SalesBudget;
                SourceExpr=+Quantity;
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                Visible=QuantityVisible;
                Editable=FALSE;
                StyleExpr='Strong';
                OnDrillDown=BEGIN
                              DrillDown(TRUE,ValueType::Quantity);
                            END;
                             }

    { 24  ;2   ;Field     ;
                Name=Amount;
                CaptionML=[DAN=Budgetteret salgsbel�b;
                           ENU=Budgeted Sales Amount];
                ToolTipML=[DAN=Angiver det samlede salgsbel�b for salgsbudgetposterne.;
                           ENU=Specifies the total sales amount of the sales budget entries.];
                ApplicationArea=#SalesBudget;
                SourceExpr=+Amount;
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                Visible=AmountVisible;
                StyleExpr='Strong';
                OnDrillDown=BEGIN
                              DrillDown(TRUE,ValueType::"Sales Amount");
                            END;
                             }

    { 1012;2   ;Field     ;
                Name=Field1;
                ApplicationArea=#SalesBudget;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[1];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[1];
                StyleExpr='Strong';
                OnValidate=BEGIN
                             UpdateAmount(1);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(1);
                            END;
                             }

    { 1013;2   ;Field     ;
                Name=Field2;
                ApplicationArea=#SalesBudget;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[2];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[2];
                StyleExpr='Strong';
                OnValidate=BEGIN
                             UpdateAmount(2);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(2);
                            END;
                             }

    { 1014;2   ;Field     ;
                Name=Field3;
                ApplicationArea=#SalesBudget;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[3];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[3];
                StyleExpr='Strong';
                OnValidate=BEGIN
                             UpdateAmount(3);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(3);
                            END;
                             }

    { 1015;2   ;Field     ;
                Name=Field4;
                ApplicationArea=#SalesBudget;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[4];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[4];
                StyleExpr='Strong';
                OnValidate=BEGIN
                             UpdateAmount(4);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(4);
                            END;
                             }

    { 1016;2   ;Field     ;
                Name=Field5;
                ApplicationArea=#SalesBudget;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[5];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[5];
                StyleExpr='Strong';
                OnValidate=BEGIN
                             UpdateAmount(5);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(5);
                            END;
                             }

    { 1017;2   ;Field     ;
                Name=Field6;
                ApplicationArea=#SalesBudget;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[6];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[6];
                StyleExpr='Strong';
                OnValidate=BEGIN
                             UpdateAmount(6);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(6);
                            END;
                             }

    { 1018;2   ;Field     ;
                Name=Field7;
                ApplicationArea=#SalesBudget;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[7];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[7];
                StyleExpr='Strong';
                OnValidate=BEGIN
                             UpdateAmount(7);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(7);
                            END;
                             }

    { 1019;2   ;Field     ;
                Name=Field8;
                ApplicationArea=#SalesBudget;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[8];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[8];
                StyleExpr='Strong';
                OnValidate=BEGIN
                             UpdateAmount(8);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(8);
                            END;
                             }

    { 1020;2   ;Field     ;
                Name=Field9;
                ApplicationArea=#SalesBudget;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[9];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[9];
                StyleExpr='Strong';
                OnValidate=BEGIN
                             UpdateAmount(9);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(9);
                            END;
                             }

    { 1021;2   ;Field     ;
                Name=Field10;
                ApplicationArea=#SalesBudget;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[10];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[10];
                StyleExpr='Strong';
                OnValidate=BEGIN
                             UpdateAmount(10);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(10);
                            END;
                             }

    { 1022;2   ;Field     ;
                Name=Field11;
                ApplicationArea=#SalesBudget;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[11];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[11];
                StyleExpr='Strong';
                OnValidate=BEGIN
                             UpdateAmount(11);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(11);
                            END;
                             }

    { 1023;2   ;Field     ;
                Name=Field12;
                ApplicationArea=#SalesBudget;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[12];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[12];
                StyleExpr='Strong';
                OnValidate=BEGIN
                             UpdateAmount(12);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(12);
                            END;
                             }

  }
  CODE
  {
    VAR
      GLSetup@1081 : Record 98;
      ItemBudgetName@1082 : Record 7132;
      ItemStatisticsBuffer@1083 : Record 5821;
      MatrixRecords@1004 : ARRAY [12] OF Record 367;
      MATRIX_ColumnTempRec@1001 : Record 367;
      ItemBudgetManagement@1084 : Codeunit 7130;
      MatrixMgt@1000 : Codeunit 9200;
      CurrentAnalysisArea@1085 : 'Sales,Purchase,Inventory';
      CurrentBudgetName@1086 : Code[10];
      SourceTypeFilter@1087 : ' ,Customer,Vendor,Item';
      SourceNoFilter@1088 : Text;
      ItemFilter@1089 : Text;
      ValueType@1090 : 'Sales Amount,COGS Amount,Quantity';
      RoundingFactor@1091 : 'None,1,1000,1000000';
      LineDimOption@1092 : 'Item,Customer,Vendor,Period,Location,Global Dimension 1,Global Dimension 2,Budget Dimension 1,Budget Dimension 2,Budget Dimension 3';
      ColumnDimOption@1093 : 'Item,Customer,Vendor,Period,Location,Global Dimension 1,Global Dimension 2,Budget Dimension 1,Budget Dimension 2,Budget Dimension 3';
      PeriodType@1094 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      GlobalDim1Filter@1095 : Text;
      GlobalDim2Filter@1096 : Text;
      BudgetDim1Filter@1097 : Text;
      BudgetDim2Filter@1098 : Text;
      BudgetDim3Filter@1099 : Text;
      DateFilter@1102 : Text;
      InternalDateFilter@1103 : Text;
      PeriodInitialized@1104 : Boolean;
      Text002@1003 : TextConst 'DAN=Du m� kun redigere kolonne 1 til %1.;ENU=You may only edit column 1 to %1.';
      MATRIX_CurrentNoOfMatrixColumn@1118 : Integer;
      MATRIX_CellData@1119 : ARRAY [12] OF Decimal;
      MATRIX_CaptionSet@1120 : ARRAY [32] OF Text[80];
      RoundingFactorFormatString@1002 : Text;
      AmountVisible@19071318 : Boolean INDATASET;
      QuantityVisible@19058433 : Boolean INDATASET;
      NameIndent@19079073 : Integer INDATASET;

    LOCAL PROCEDURE CalcAmt@1125(ValueType@1001 : Integer;SetColFilter@1000 : Boolean) : Decimal;
    BEGIN
      EXIT(
        ItemBudgetManagement.CalcAmount(
          ValueType,SetColFilter,
          ItemStatisticsBuffer,ItemBudgetName,
          ItemFilter,SourceTypeFilter,SourceNoFilter,DateFilter,
          GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter,
          LineDimOption,Rec,ColumnDimOption,MATRIX_ColumnTempRec));
    END;

    LOCAL PROCEDURE SetAmt@1(ValueType@1001 : Integer;SetColFilter@1000 : Boolean;NewAmount@1002 : Decimal);
    BEGIN
      ItemBudgetManagement.UpdateAmount(
        ValueType,SetColFilter,
        ItemStatisticsBuffer,ItemBudgetName,
        ItemFilter,SourceTypeFilter,SourceNoFilter,DateFilter,
        GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter,
        LineDimOption,Rec,ColumnDimOption,MATRIX_ColumnTempRec,NewAmount);
    END;

    LOCAL PROCEDURE DrillDown@1131(OnlyLines@1000 : Boolean;ValueType@1001 : 'Sales Amount,Cost Amount,Quantity');
    BEGIN
      ItemBudgetManagement.BudgetDrillDown(
        ItemBudgetName,
        ItemFilter,SourceTypeFilter,SourceNoFilter,DateFilter,
        GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter,
        LineDimOption,Rec,
        ColumnDimOption,MATRIX_ColumnTempRec,
        ValueType,
        OnlyLines);
    END;

    [External]
    PROCEDURE Load@1132(MatrixColumns1@1005 : ARRAY [32] OF Text[80];VAR MatrixRecords1@1006 : ARRAY [12] OF Record 367;CurrentNoOfMatrixColumns@1007 : Integer;_CurrentBudgetName@1000 : Code[10];_LineDimOption@1001 : Integer;_ColumnDimOption@1002 : Integer;_RoundingFactor@1003 : Integer;_ValueType@1004 : Integer;_PeriodType@1100 : 'Day,Week,Month,Quarter,Year,Accounting Period');
    VAR
      i@1008 : Integer;
    BEGIN
      CLEAR(MATRIX_CellData);

      FOR i := 1 TO 12 DO BEGIN
        MATRIX_CaptionSet[i] := MatrixColumns1[i];
        MatrixRecords[i] := MatrixRecords1[i];
      END;
      MATRIX_CurrentNoOfMatrixColumn := CurrentNoOfMatrixColumns;
      CurrentAnalysisArea := CurrentAnalysisArea::Sales;
      CurrentBudgetName := _CurrentBudgetName;
      LineDimOption := _LineDimOption;
      ColumnDimOption := _ColumnDimOption;
      RoundingFactor := _RoundingFactor;
      ValueType := _ValueType;
      PeriodType := _PeriodType;
      ItemBudgetManagement.BudgetNameSelection(
        CurrentAnalysisArea,CurrentBudgetName,ItemBudgetName,ItemStatisticsBuffer,
        BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter);
      RoundingFactorFormatString := MatrixMgt.GetFormatString(RoundingFactor,FALSE);
    END;

    [External]
    PROCEDURE SetFilters@1102601000(_DateFilter@1102601001 : Text;_ItemFilter@1102601000 : Text;_SourceNoFilter@1102601007 : Text;_GlobalDim1Filter@1102601002 : Text;_GlobalDim2Filter@1102601003 : Text;_BudgetDim1Filter@1102601004 : Text;_BudgetDim2Filter@1102601005 : Text;_BudgetDim3Filter@1102601006 : Text);
    BEGIN
      DateFilter := _DateFilter;
      ItemFilter := _ItemFilter;
      SourceNoFilter := _SourceNoFilter;
      GlobalDim1Filter := _GlobalDim1Filter;
      GlobalDim2Filter := _GlobalDim2Filter;
      BudgetDim1Filter := _BudgetDim1Filter;
      BudgetDim2Filter := _BudgetDim2Filter;
      BudgetDim3Filter := _BudgetDim3Filter;
    END;

    LOCAL PROCEDURE MATRIX_OnDrillDown@1133(MATRIX_ColumnOrdinal@1008 : Integer);
    BEGIN
      MATRIX_ColumnTempRec := MatrixRecords[MATRIX_ColumnOrdinal];
      DrillDown(FALSE,ValueType);
    END;

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@1135(MATRIX_ColumnOrdinal@1010 : Integer);
    BEGIN
      MATRIX_ColumnTempRec := MatrixRecords[MATRIX_ColumnOrdinal];
      MATRIX_CellData[MATRIX_ColumnOrdinal] := MatrixMgt.RoundValue(CalcAmt(ValueType,TRUE),RoundingFactor);
    END;

    LOCAL PROCEDURE UpdateAmount@1001(MATRIX_ColumnOrdinal@1102601000 : Integer);
    VAR
      NewAmount@1000 : Decimal;
    BEGIN
      ItemBudgetName.TESTFIELD(Blocked,FALSE);
      IF MATRIX_ColumnOrdinal > MATRIX_CurrentNoOfMatrixColumn THEN
        ERROR(Text002,MATRIX_CurrentNoOfMatrixColumn);
      MATRIX_ColumnTempRec := MatrixRecords[MATRIX_ColumnOrdinal];

      NewAmount := FromRoundedValue(MATRIX_CellData[MATRIX_ColumnOrdinal]);
      SetAmt(ValueType,TRUE,NewAmount);
      Amount := MatrixMgt.RoundValue(CalcAmt(ValueType::"Sales Amount",FALSE),RoundingFactor);
      Quantity := MatrixMgt.RoundValue(CalcAmt(ValueType::Quantity,FALSE),RoundingFactor);
    END;

    LOCAL PROCEDURE FromRoundedValue@3(OrgAmount@1000 : Decimal) : Decimal;
    VAR
      NewAmount@1001 : Decimal;
    BEGIN
      NewAmount := OrgAmount;
      CASE RoundingFactor OF
        RoundingFactor::"1000":
          NewAmount := OrgAmount * 1000;
        RoundingFactor::"1000000":
          NewAmount := OrgAmount * 1000000;
      END;
      EXIT(NewAmount);
    END;

    LOCAL PROCEDURE FormatLine@19037745();
    BEGIN
      NameIndent := Indentation;
    END;

    LOCAL PROCEDURE AmountOnFormat@19014598(Text@19024947 : Text[1024]);
    BEGIN
      ItemBudgetManagement.FormatAmount(Text,RoundingFactor);
    END;

    LOCAL PROCEDURE FormatStr@8() : Text;
    BEGIN
      EXIT(RoundingFactorFormatString);
    END;

    BEGIN
    END.
  }
}

