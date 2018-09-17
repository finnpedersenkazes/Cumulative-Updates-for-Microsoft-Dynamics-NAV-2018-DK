OBJECT Page 1131 Cost Budget per Period Matrix
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Matrix for omkostningsbudget pr. periode;
               ENU=Cost Budget per Period Matrix];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table1103;
    PageType=ListPart;
    RefreshOnActivate=Yes;
    ShowFilter=No;
    OnAfterGetRecord=VAR
                       MATRIX_CurrentColumnOrdinal@1000 : Integer;
                     BEGIN
                       FOR MATRIX_CurrentColumnOrdinal := 1 TO MATRIX_CurrentNoOfMatrixColumn DO
                         MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
                       NameIndent := Indentation;
                       Emphasize := Type <> Type::"Cost Type";
                     END;

    ActionList=ACTIONS
    {
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Omkostningstype;
                                 ENU=&Cost Type];
                      Image=Costs }
      { 3       ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=&Kort;
                                 ENU=&Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger for omkostningstypen.;
                                 ENU=View or edit detailed information for the cost type.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1101;
                      RunPageOnRec=Yes;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Cost Center Filter=FIELD(Cost Center Filter),
                                  Cost Object Filter=FIELD(Cost Object Filter),
                                  Budget Filter=FIELD(Budget Filter);
                      Image=EditLines }
      { 4       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=P&oster;
                                 ENU=E&ntries];
                      ToolTipML=[DAN=F� vist posterne for omkostningsbudget pr. periode.;
                                 ENU=View the entries for the cost budget per period.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1103;
                      RunPageView=SORTING(Cost Type No.,Posting Date);
                      RunPageLink=Cost Type No.=FIELD(No.);
                      Image=Entries }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 6       ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Kopier omkostningsbudget til omkostningsbudget;
                                 ENU=&Copy Cost Budget to Cost Budget];
                      ToolTipML=[DAN=Kopi�r bel�bene i omkostningsbudgettet i �t budget eller fra budget til budget. Du kan kopiere et budget flere gange og angive en faktor til for�gelse eller reduktion af budgetbel�bene.;
                                 ENU=Copy cost budget amounts within a budget or from budget to budget. You can copy a budget several times and enter a factor to increase or reduce the budget amounts.];
                      ApplicationArea=#CostAccounting;
                      Image=CopyCostBudget;
                      OnAction=BEGIN
                                 COPYFILTER("Budget Filter",CostBudgetEntry."Budget Name");
                                 COPYFILTER("Cost Center Filter",CostBudgetEntry."Cost Center Code");
                                 COPYFILTER("Cost Object Filter",CostBudgetEntry."Cost Object Code");
                                 REPORT.RUNMODAL(REPORT::"Copy Cost Budget",TRUE,FALSE,CostBudgetEntry);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier &finansbudget til omkostningsbudget;
                                 ENU=Copy &G/L Budget to Cost Budget];
                      ToolTipML=[DAN=Kopi�r tallene i finansbudgettet til omkostningsregnskabsbudgettet. Du kan ogs� angive budgetter for omkostningssteder og omkostningsemner i finansregnskabet.;
                                 ENU=Copy general ledger budget figures to the cost accounting budget. You can also enter budgets for the cost centers and cost objects in the general ledger.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1135;
                      Image=CopyGLtoCostBudget }
      { 8       ;2   ;Action    ;
                      CaptionML=[DAN=Kopier omkostnings&budget til finansbudget;
                                 ENU=Copy Cost &Budget to G/L Budget];
                      ToolTipML=[DAN=Kopi�r valgte omkostningsbudgetposter til finansregnskabet. Der er ogs� mulighed for multiplikationsfaktorer med datoforskydninger.;
                                 ENU=Copy selected cost budget entries into the general ledger. Multiplication factors and multiple copies with date offsets are also possible.];
                      ApplicationArea=#CostAccounting;
                      RunPageOnRec=Yes;
                      Image=CopyCosttoGLBudget;
                      OnAction=BEGIN
                                 COPYFILTER("Budget Filter",CostBudgetEntry."Budget Name");
                                 COPYFILTER("Cost Center Filter",CostBudgetEntry."Cost Center Code");
                                 COPYFILTER("Cost Object Filter",CostBudgetEntry."Cost Object Code");
                                 REPORT.RUNMODAL(REPORT::"Copy Cost Acctg. Budget to G/L",TRUE,FALSE,CostBudgetEntry);
                               END;
                                }
      { 9       ;2   ;Separator  }
      { 10      ;2   ;Action    ;
                      CaptionML=[DAN=Komprimer budget&poster;
                                 ENU=Compress Budget &Entries];
                      ToolTipML=[DAN=Komprimer omkostningsbudgetposter, s� de ikke optager s� meget plads i databasen.;
                                 ENU=Compresses cost budget entries so that they take up less space in the database.];
                      ApplicationArea=#CostAccounting;
                      OnAction=BEGIN
                                 CostBudgetEntry.CompressBudgetEntries(GETFILTER("Budget Filter"));
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 11  ;0   ;Container ;
                ContainerType=ContentArea }

    { 12  ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#CostAccounting;
                SourceExpr="No.";
                Editable=FALSE;
                Style=Strong;
                StyleExpr=Emphasize }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� omkostningstypen.;
                           ENU=Specifies the name of the cost type.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Name;
                Editable=FALSE;
                Style=Strong;
                StyleExpr=Emphasize }

    { 15  ;2   ;Field     ;
                Name=Column1;
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[1];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_ColumnCaption[1];
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             UpdateAmount(1);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(1);
                            END;
                             }

    { 16  ;2   ;Field     ;
                Name=Column2;
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[2];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_ColumnCaption[2];
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             UpdateAmount(2);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(2);
                            END;
                             }

    { 17  ;2   ;Field     ;
                Name=Column3;
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[3];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_ColumnCaption[3];
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             UpdateAmount(3);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(3);
                            END;
                             }

    { 18  ;2   ;Field     ;
                Name=Column4;
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[4];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_ColumnCaption[4];
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             UpdateAmount(4);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(4);
                            END;
                             }

    { 19  ;2   ;Field     ;
                Name=Column5;
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[5];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_ColumnCaption[5];
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             UpdateAmount(5);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(5);
                            END;
                             }

    { 20  ;2   ;Field     ;
                Name=Column6;
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[6];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_ColumnCaption[6];
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             UpdateAmount(6);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(6);
                            END;
                             }

    { 21  ;2   ;Field     ;
                Name=Column7;
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[7];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_ColumnCaption[7];
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             UpdateAmount(7);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(7);
                            END;
                             }

    { 22  ;2   ;Field     ;
                Name=Column8;
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[8];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_ColumnCaption[8];
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             UpdateAmount(8);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(8);
                            END;
                             }

    { 23  ;2   ;Field     ;
                Name=Column9;
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[9];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_ColumnCaption[9];
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             UpdateAmount(9);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(9);
                            END;
                             }

    { 24  ;2   ;Field     ;
                Name=Column10;
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[10];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_ColumnCaption[10];
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             UpdateAmount(10);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(10);
                            END;
                             }

    { 25  ;2   ;Field     ;
                Name=Column11;
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[11];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_ColumnCaption[11];
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             UpdateAmount(11);
                           END;

                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(11);
                            END;
                             }

    { 26  ;2   ;Field     ;
                Name=Column12;
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[12];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_ColumnCaption[12];
                Style=Strong;
                StyleExpr=Emphasize;
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
      MatrixRecords@1000 : ARRAY [32] OF Record 2000000007;
      CostBudgetEntry@1001 : Record 1109;
      MatrixMgt@1009 : Codeunit 9200;
      CostCenterFilter@1012 : Code[20];
      CostObjectFilter@1013 : Code[20];
      BudgetFilter@1002 : Code[10];
      MATRIX_ColumnCaption@1003 : ARRAY [12] OF Text[80];
      RoundingFactorFormatString@1016 : Text;
      AmtType@1011 : 'Balance at Date,Net Change';
      RoundingFactor@1005 : 'None,1,1000,1000000';
      MATRIX_CurrentNoOfMatrixColumn@1006 : Integer;
      MATRIX_CellData@1007 : ARRAY [32] OF Decimal;
      Emphasize@1008 : Boolean INDATASET;
      NameIndent@1010 : Integer INDATASET;
      Text000@1014 : TextConst 'DAN=Angiv Vis som til Bev�gelse, inden posterne redigeres.;ENU=Set View As to Net Change before you edit entries.';
      Text001@1015 : TextConst 'DAN=%1 eller %2 m� ikke v�re tom.;ENU=%1 or %2 must not be blank.';
      CurrRegNo@1004 : Integer;

    LOCAL PROCEDURE SetDateFilter@1(MATRIX_ColumnOrdinal@1000 : Integer);
    BEGIN
      IF AmtType = AmtType::"Net Change" THEN
        IF MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" THEN
          SETRANGE("Date Filter",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        ELSE
          SETRANGE("Date Filter",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start",MatrixRecords[MATRIX_ColumnOrdinal]."Period End")
      ELSE
        SETRANGE("Date Filter",0D,MatrixRecords[MATRIX_ColumnOrdinal]."Period End");
    END;

    [Internal]
    PROCEDURE Load@2(MatrixColumns1@1000 : ARRAY [32] OF Text[80];VAR MatrixRecords1@1001 : ARRAY [32] OF Record 2000000007;CurrentNoOfMatrixColumns@1008 : Integer;CostCenterFilter1@1002 : Code[20];CostObjectFilter1@1003 : Code[20];BudgetFilter1@1004 : Code[10];RoundingFactor1@1005 : 'None,1,1000,1000000';AmtType1@1007 : 'Balance at Date,Net Change');
    VAR
      i@1006 : Integer;
    BEGIN
      FOR i := 1 TO 12 DO BEGIN
        IF MatrixColumns1[i] = '' THEN
          MATRIX_ColumnCaption[i] := ' '
        ELSE
          MATRIX_ColumnCaption[i] := MatrixColumns1[i];
        MatrixRecords[i] := MatrixRecords1[i];
      END;
      IF MATRIX_ColumnCaption[1] = '' THEN; // To make this form pass preCAL test

      IF CurrentNoOfMatrixColumns > ARRAYLEN(MATRIX_CellData) THEN
        MATRIX_CurrentNoOfMatrixColumn := ARRAYLEN(MATRIX_CellData)
      ELSE
        MATRIX_CurrentNoOfMatrixColumn := CurrentNoOfMatrixColumns;
      CostCenterFilter := CostCenterFilter1;
      CostObjectFilter := CostObjectFilter1;
      BudgetFilter := BudgetFilter1;
      RoundingFactor := RoundingFactor1;
      AmtType := AmtType1;
      RoundingFactorFormatString := MatrixMgt.GetFormatString(RoundingFactor,FALSE);

      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE MATRIX_OnDrillDown@3(ColumnID@1000 : Integer);
    VAR
      CostBudgetEntries@1001 : Page 1115;
    BEGIN
      SetDateFilter(ColumnID);
      CostBudgetEntry.SETCURRENTKEY("Budget Name","Cost Type No.","Cost Center Code","Cost Object Code",Date);
      IF Type IN [Type::Total,Type::"End-Total"] THEN
        CostBudgetEntry.SETFILTER("Cost Type No.",Totaling)
      ELSE
        CostBudgetEntry.SETRANGE("Cost Type No.","No.");
      CostBudgetEntry.SETFILTER("Cost Center Code",CostCenterFilter);
      CostBudgetEntry.SETFILTER("Cost Object Code",CostObjectFilter);
      CostBudgetEntry.SETFILTER("Budget Name",BudgetFilter);
      CostBudgetEntry.SETFILTER(Date,GETFILTER("Date Filter"));
      CostBudgetEntry.FILTERGROUP(26);
      CostBudgetEntry.SETFILTER(Date,'..%1|%1..',MatrixRecords[ColumnID]."Period Start");
      CostBudgetEntry.FILTERGROUP(0);

      CostBudgetEntries.SetCurrRegNo(CurrRegNo);
      CostBudgetEntries.SETTABLEVIEW(CostBudgetEntry);
      CostBudgetEntries.RUNMODAL;
      CurrRegNo := CostBudgetEntries.GetCurrRegNo;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@4(ColumnID@1000 : Integer);
    BEGIN
      SetFilters(ColumnID);
      CALCFIELDS("Budget Amount");
      MATRIX_CellData[ColumnID] := MatrixMgt.RoundValue("Budget Amount",RoundingFactor);
    END;

    LOCAL PROCEDURE UpdateAmount@5(ColumnID@1000 : Integer);
    BEGIN
      IF AmtType <> AmtType::"Net Change" THEN
        ERROR(Text000);

      IF (CostCenterFilter = '') AND (CostObjectFilter = '') THEN
        ERROR(Text001,FIELDCAPTION("Cost Center Filter"),FIELDCAPTION("Cost Object Filter"));

      SetFilters(ColumnID);
      CALCFIELDS("Budget Amount");
      InsertMatrixCostBudgetEntry(CurrRegNo,ColumnID);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE SetFilters@6(ColumnID@1000 : Integer);
    BEGIN
      SetDateFilter(ColumnID);
      SETFILTER("Cost Center Filter",CostCenterFilter);
      SETFILTER("Cost Object Filter",CostObjectFilter);
      SETFILTER("Budget Filter",BudgetFilter);
    END;

    LOCAL PROCEDURE InsertMatrixCostBudgetEntry@7(VAR RegNo@1000 : Integer;ColumnID@1002 : Integer);
    VAR
      MatrixCostBudgetEntry@1001 : Record 1109;
    BEGIN
      MatrixCostBudgetEntry.SetCostBudgetRegNo(RegNo);
      MatrixCostBudgetEntry.INIT;
      MatrixCostBudgetEntry."Budget Name" := BudgetFilter;
      MatrixCostBudgetEntry."Cost Type No." := "No.";
      MatrixCostBudgetEntry.Date := MatrixRecords[ColumnID]."Period Start";
      MatrixCostBudgetEntry."Cost Center Code" := CostCenterFilter;
      MatrixCostBudgetEntry."Cost Object Code" := CostObjectFilter;
      MatrixCostBudgetEntry.Amount := MATRIX_CellData[ColumnID] - "Budget Amount";
      MatrixCostBudgetEntry.INSERT(TRUE);
      RegNo := MatrixCostBudgetEntry.GetCostBudgetRegNo;
    END;

    LOCAL PROCEDURE FormatStr@8() : Text;
    BEGIN
      EXIT(RoundingFactorFormatString);
    END;

    BEGIN
    END.
  }
}

