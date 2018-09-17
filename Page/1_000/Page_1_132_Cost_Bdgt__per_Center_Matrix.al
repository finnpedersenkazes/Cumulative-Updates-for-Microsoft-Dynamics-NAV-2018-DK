OBJECT Page 1132 Cost Bdgt. per Center Matrix
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Matrix for omkostningsbudget pr. sted;
               ENU=Cost Bdgt. per Center Matrix];
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
                      ToolTipML=[DAN=F� vist posterne for omkostningsbudget pr. sted.;
                                 ENU=View the entries for the cost budget per center.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1103;
                      RunPageView=SORTING(Cost Type No.,Posting Date);
                      RunPageLink=Cost Type No.=FIELD(No.);
                      Image=Entries }
    }
  }
  CONTROLS
  {
    { 5   ;0   ;Container ;
                ContainerType=ContentArea }

    { 6   ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#CostAccounting;
                SourceExpr="No.";
                Editable=FALSE;
                Style=Strong;
                StyleExpr=Emphasize }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� omkostningstypen.;
                           ENU=Specifies the name of the cost type.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Name;
                Editable=FALSE;
                Style=Strong;
                StyleExpr=Emphasize }

    { 9   ;2   ;Field     ;
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

    { 10  ;2   ;Field     ;
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

    { 11  ;2   ;Field     ;
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

    { 12  ;2   ;Field     ;
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

    { 13  ;2   ;Field     ;
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

    { 14  ;2   ;Field     ;
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

    { 15  ;2   ;Field     ;
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

    { 16  ;2   ;Field     ;
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

    { 17  ;2   ;Field     ;
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

    { 18  ;2   ;Field     ;
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

    { 19  ;2   ;Field     ;
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

    { 20  ;2   ;Field     ;
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
      CostBudgetEntry@1001 : Record 1109;
      CostCenterMatrixRecords@1012 : ARRAY [12] OF Record 1112;
      MatrixMgt@1000 : Codeunit 9200;
      BudgetFilter@1002 : Text;
      MATRIX_ColumnCaption@1003 : ARRAY [12] OF Text[80];
      DateFilter@1004 : Text;
      RoundingFactorFormatString@1009 : Text;
      RoundingFactor@1005 : 'None,1,1000,1000000';
      MATRIX_CurrentNoOfMatrixColumn@1006 : Integer;
      MATRIX_CellData@1007 : ARRAY [12] OF Decimal;
      Emphasize@1008 : Boolean INDATASET;
      NameIndent@1010 : Integer INDATASET;
      Text000@1014 : TextConst 'DAN=Angiv Vis som til Bev�gelse, inden posterne redigeres.;ENU=Set View As to Net Change before you edit entries.';

    [External]
    PROCEDURE Load@2(MatrixColumns1@1000 : ARRAY [12] OF Text[80];VAR CostCenterMatrixRecords1@1001 : ARRAY [12] OF Record 1112;CurrentNoOfMatrixColumns@1002 : Integer;DateFilter1@1003 : Text;BudgetFilter1@1004 : Text;RoundingFactor1@1005 : Option);
    VAR
      i@1006 : Integer;
    BEGIN
      FOR i := 1 TO 12 DO BEGIN
        IF MatrixColumns1[i] = '' THEN
          MATRIX_ColumnCaption[i] := ' '
        ELSE
          MATRIX_ColumnCaption[i] := MatrixColumns1[i];
        CostCenterMatrixRecords[i] := CostCenterMatrixRecords1[i];
      END;
      IF MATRIX_ColumnCaption[1] = '' THEN; // To make this form pass preCAL test

      IF CurrentNoOfMatrixColumns > ARRAYLEN(MATRIX_CellData) THEN
        MATRIX_CurrentNoOfMatrixColumn := ARRAYLEN(MATRIX_CellData)
      ELSE
        MATRIX_CurrentNoOfMatrixColumn := CurrentNoOfMatrixColumns;
      DateFilter := DateFilter1;
      BudgetFilter := BudgetFilter1;
      RoundingFactor := RoundingFactor1;
      RoundingFactorFormatString := MatrixMgt.GetFormatString(RoundingFactor,FALSE);

      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE MATRIX_OnDrillDown@3(ColumnID@1000 : Integer);
    BEGIN
      CostBudgetEntry.SETCURRENTKEY("Budget Name","Cost Type No.","Cost Center Code","Cost Object Code",Date);
      IF Type IN [Type::Total,Type::"End-Total"] THEN
        CostBudgetEntry.SETFILTER("Cost Type No.",Totaling)
      ELSE
        CostBudgetEntry.SETRANGE("Cost Type No.","No.");
      CostBudgetEntry.SETFILTER("Cost Center Code",CostCenterMatrixRecords[ColumnID].Code);
      CostBudgetEntry.SETFILTER("Budget Name",BudgetFilter);
      CostBudgetEntry.SETFILTER(Date,GETFILTER("Date Filter"));
      PAGE.RUN(0,CostBudgetEntry);
    END;

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@4(ColumnID@1000 : Integer);
    BEGIN
      SetFilters(ColumnID);
      CALCFIELDS("Budget Amount");
      MATRIX_CellData[ColumnID] := MatrixMgt.RoundValue("Budget Amount",RoundingFactor);
    END;

    LOCAL PROCEDURE UpdateAmount@5(ColumnID@1000 : Integer);
    BEGIN
      SetFilters(ColumnID);
      IF GETRANGEMIN("Date Filter") = 0D THEN
        ERROR(Text000);

      CALCFIELDS("Budget Amount");
      VALIDATE("Budget Amount",MATRIX_CellData[ColumnID]);
    END;

    LOCAL PROCEDURE SetFilters@6(ColumnID@1000 : Integer);
    BEGIN
      SETFILTER("Date Filter",DateFilter);
      SETFILTER("Cost Center Filter",CostCenterMatrixRecords[ColumnID].Code);
      SETFILTER("Budget Filter",BudgetFilter);
    END;

    LOCAL PROCEDURE FormatStr@8() : Text;
    BEGIN
      EXIT(RoundingFactorFormatString);
    END;

    BEGIN
    END.
  }
}

