OBJECT Page 113 Budget
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Budget;
               ENU=Budget];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    DataCaptionExpr=BudgetName;
    PageType=ListPlus;
    OnInit=BEGIN
             BudgetDim4FilterEnable := TRUE;
             BudgetDim3FilterEnable := TRUE;
             BudgetDim2FilterEnable := TRUE;
             BudgetDim1FilterEnable := TRUE;
             PeriodTypeEnable := TRUE;
             GlobalDim2FilterEnable := TRUE;
             GlobalDim1FilterEnable := TRUE;
           END;

    OnOpenPage=VAR
                 GLAcc@1000 : Record 15;
                 MATRIX_Step@1001 : 'Initial,Previous,Same,Next,PreviousColumn,NextColumn';
               BEGIN
                 IF GLAccBudgetBuf.GETFILTER("Global Dimension 1 Filter") <> '' THEN
                   GlobalDim1Filter := GLAccBudgetBuf.GETFILTER("Global Dimension 1 Filter");
                 IF GLAccBudgetBuf.GETFILTER("Global Dimension 2 Filter") <> '' THEN
                   GlobalDim2Filter := GLAccBudgetBuf.GETFILTER("Global Dimension 2 Filter");

                 GLSetup.GET;

                 GlobalDim1FilterEnable :=
                   (GLSetup."Global Dimension 1 Code" <> '') AND
                   (GLAccBudgetBuf.GETFILTER("Global Dimension 1 Filter") = '');
                 GlobalDim2FilterEnable :=
                   (GLSetup."Global Dimension 2 Code" <> '') AND
                   (GLAccBudgetBuf.GETFILTER("Global Dimension 2 Filter") = '');

                 IF GLAccBudgetBuf.GETFILTER("G/L Account Filter") <> '' THEN
                   GLAccFilter := GLAccBudgetBuf.GETFILTER("G/L Account Filter");

                 ValidateBudgetName;

                 IF LineDimCode = '' THEN
                   LineDimCode := GLAcc.TABLECAPTION;
                 IF ColumnDimCode = '' THEN
                   ColumnDimCode := Text001;

                 LineDimOption := DimCodeToOption(LineDimCode);
                 ColumnDimOption := DimCodeToOption(ColumnDimCode);

                 IF (NewBudgetName <> '') AND (NewBudgetName <> BudgetName) THEN BEGIN
                   BudgetName := NewBudgetName;
                   ValidateBudgetName;
                   ValidateLineDimCode;
                   ValidateColumnDimCode;
                 END;

                 PeriodType := PeriodType::Month;
                 IncomeBalanceGLAccFilter := IncomeBalanceGLAccFilter::"Income Statement";
                 IF DateFilter = '' THEN
                   ValidateDateFilter(FORMAT(CALCDATE('<-CY>',TODAY)) + '..' + FORMAT(CALCDATE('<CY>',TODAY)));

                 FindPeriod('');
                 MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);

                 UpdateMatrixSubform;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601009;1 ;ActionGroup;
                      CaptionML=[DAN=&Saldo;
                                 ENU=&Balance];
                      Image=Balance }
      { 1102601011;2 ;Action    ;
                      Name=GLBalanceBudget;
                      CaptionML=[DAN=Finanskontos saldo/b&udget efter periode;
                                 ENU=G/L Account Balance B&udget by period];
                      ToolTipML=[DAN=�bn en oversigt over debet- og kreditsaldi for det aktuelle budget.;
                                 ENU=Open a summary of the debit and credit balances for the current budget.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=ChartOfAccounts;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 GLAccount@1000 : Record 15;
                               BEGIN
                                 GLAccount.SETFILTER("Budget Filter",BudgetName);
                                 IF BusUnitFilter <> '' THEN
                                   GLAccount.SETFILTER("Business Unit Filter",BusUnitFilter);
                                 IF GLAccFilter <> '' THEN
                                   GLAccount.SETFILTER("No.",GLAccFilter);
                                 IF DateFilter <> '' THEN
                                   GLAccount.SETFILTER("Date Filter",DateFilter);
                                 CASE IncomeBalanceGLAccFilter OF
                                   IncomeBalanceGLAccFilter::"Balance Sheet":
                                     GLAccount.SETRANGE("Income/Balance",GLAccount."Income/Balance"::"Balance Sheet");
                                   IncomeBalanceGLAccFilter::"Income Statement":
                                     GLAccount.SETRANGE("Income/Balance",GLAccount."Income/Balance"::"Income Statement");
                                 END;
                                 IF GLAccCategoryFilter <> GLAccCategoryFilter::" " THEN
                                   GLAccount.SETRANGE("Account Category",GLAccCategoryFilter);
                                 IF GlobalDim1Filter <> '' THEN
                                   GLAccount.SETFILTER("Global Dimension 1 Filter",GlobalDim1Filter);
                                 IF GlobalDim2Filter <> '' THEN
                                   GLAccount.SETFILTER("Global Dimension 2 Filter",GlobalDim2Filter);
                                 PAGE.RUN(PAGE::"G/L Balance/Budget",GLAccount);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102601001;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1102601002;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier budget;
                                 ENU=Copy Budget];
                      ToolTipML=[DAN=Opret en kopi af det aktuelle budget baseret p� en finanspost eller en finansbudgetpost.;
                                 ENU=Create a copy of the current budget based on a general ledger entry or a general ledger budget entry.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=CopyBudget;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Copy G/L Budget",TRUE,FALSE);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 1102601003;2 ;Action    ;
                      CaptionML=[DAN=Slet budget;
                                 ENU=Delete Budget];
                      ToolTipML=[DAN=Slet det aktuelle budget.;
                                 ENU=Delete the current budget.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Delete;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 DeleteBudget;
                               END;
                                }
      { 1102601004;2 ;Separator ;
                      CaptionML=[DAN="";
                                 ENU=""] }
      { 1102601005;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udl�s til Excel;
                                 ENU=Export to Excel];
                      ToolTipML=[DAN=Eksport�r alle dele af budgettet til Excel til yderligere analyse. Hvis du foretager �ndringer i Excel, kan du importere budgettet bagefter.;
                                 ENU=Export all or part of the budget to Excel for further analysis. If you make changes in Excel, you can import the budget afterwards.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=ExportToExcel;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 GLBudgetEntry@1001 : Record 96;
                               BEGIN
                                 GLBudgetEntry.SETFILTER("Budget Name",BudgetName);
                                 GLBudgetEntry.SETFILTER("Business Unit Code",BusUnitFilter);
                                 GLBudgetEntry.SETFILTER("G/L Account No.",GLAccFilter);
                                 GLBudgetEntry.SETFILTER("Global Dimension 1 Code",GlobalDim1Filter);
                                 GLBudgetEntry.SETFILTER("Global Dimension 2 Code",GlobalDim2Filter);
                                 GLBudgetEntry.SETFILTER("Budget Dimension 1 Code",BudgetDim1Filter);
                                 GLBudgetEntry.SETFILTER("Budget Dimension 2 Code",BudgetDim2Filter);
                                 GLBudgetEntry.SETFILTER("Budget Dimension 3 Code",BudgetDim3Filter);
                                 GLBudgetEntry.SETFILTER("Budget Dimension 4 Code",BudgetDim4Filter);
                                 REPORT.RUN(REPORT::"Export Budget to Excel",TRUE,FALSE,GLBudgetEntry);
                               END;
                                }
      { 1102601006;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indl�s fra Excel;
                                 ENU=Import from Excel];
                      ToolTipML=[DAN=Import�r et budget, du tidligere har eksporteret til Excel.;
                                 ENU=Import a budget that you exported to Excel earlier.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=ImportExcel;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ImportBudgetfromExcel@1001 : Report 81;
                               BEGIN
                                 ImportBudgetfromExcel.SetParameters(BudgetName,0);
                                 ImportBudgetfromExcel.RUNMODAL;
                                 UpdateMatrixSubform;
                               END;
                                }
      { 1102601007;2 ;Separator  }
      { 1102601008;2 ;Action    ;
                      CaptionML=[DAN=Byt om p� linjer og kolonner;
                                 ENU=Reverse Lines and Columns];
                      ToolTipML=[DAN=Rediger visningen af matrix ved at invertere v�rdierne i felterne Vis som linjer og Vis som kolonner.;
                                 ENU=Change the display of the matrix by inverting the values in the Show as Lines and Show as Columns fields.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Undo;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 TempDimCode@1102601000 : Text[30];
                               BEGIN
                                 TempDimCode := ColumnDimCode;
                                 ColumnDimCode := LineDimCode;
                                 LineDimCode := TempDimCode;
                                 ValidateLineDimCode;
                                 ValidateColumnDimCode;

                                 MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
                                 UpdateMatrixSubform;
                               END;
                                }
      { 4       ;1   ;ActionGroup;
                      Name=ReportGroup;
                      CaptionML=[DAN=Rapport;
                                 ENU=Report];
                      Image=Report }
      { 3       ;2   ;Action    ;
                      Name=ReportTrialBalance;
                      CaptionML=[DAN=Pr�veversions saldo/budget;
                                 ENU=Trial Balance/Budget];
                      ToolTipML=[DAN=Vis budgetoplysninger for den angivne periode.;
                                 ENU=View budget details for the specified period.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 REPORT.RUN(REPORT::"Trial Balance/Budget");
                               END;
                                }
      { 2       ;2   ;Action    ;
                      Name=ReportBudget;
                      CaptionML=[DAN=Budget;
                                 ENU=Budget];
                      ToolTipML=[DAN=Vis budgetoplysninger for den angivne periode.;
                                 ENU=View budget details for the specified period.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 REPORT.RUN(REPORT::Budget);
                               END;
                                }
      { 22      ;1   ;Action    ;
                      CaptionML=[DAN=N�ste periode;
                                 ENU=Next Period];
                      ToolTipML=[DAN=Vis oplysningerne baseret p� den n�ste periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen efter.;
                                 ENU=Show the information based on the next period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=NextRecord;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 IF (LineDimOption = LineDimOption::Period) OR (ColumnDimOption = ColumnDimOption::Period) THEN
                                   EXIT;
                                 FindPeriod('>');
                                 CurrPage.UPDATE;
                                 UpdateMatrixSubform;
                               END;
                                }
      { 21      ;1   ;Action    ;
                      CaptionML=[DAN=Forrige periode;
                                 ENU=Previous Period];
                      ToolTipML=[DAN=Vis oplysningerne baseret p� den forrige periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen f�r.;
                                 ENU=Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=PreviousRecord;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 IF (LineDimOption = LineDimOption::Period) OR (ColumnDimOption = ColumnDimOption::Period) THEN
                                   EXIT;
                                 FindPeriod('<');
                                 CurrPage.UPDATE;
                                 UpdateMatrixSubform;
                               END;
                                }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=Forrige s�t;
                                 ENU=Previous Set];
                      ToolTipML=[DAN=G� til det forrige datas�t.;
                                 ENU=Go to the previous set of data.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousSet;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 MATRIX_GenerateColumnCaptions(MATRIX_Step::Previous);
                                 UpdateMatrixSubform;
                               END;
                                }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=Forrige kolonne;
                                 ENU=Previous Column];
                      ToolTipML=[DAN=G� til forrige kolonne.;
                                 ENU=Go to the previous column.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousRecord;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 MATRIX_GenerateColumnCaptions(MATRIX_Step::PreviousColumn);
                                 UpdateMatrixSubform;
                               END;
                                }
      { 52      ;1   ;Action    ;
                      CaptionML=[DAN=N�ste kolonne;
                                 ENU=Next Column];
                      ToolTipML=[DAN=G� til n�ste kolonne.;
                                 ENU=Go to the next column.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextRecord;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 MATRIX_GenerateColumnCaptions(MATRIX_Step::NextColumn);
                                 UpdateMatrixSubform;
                               END;
                                }
      { 111     ;1   ;Action    ;
                      CaptionML=[DAN=N�ste s�t;
                                 ENU=Next Set];
                      ToolTipML=[DAN=G� til det n�ste datas�t.;
                                 ENU=Go to the next set of data.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextSet;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 MATRIX_GenerateColumnCaptions(MATRIX_Step::Next);
                                 UpdateMatrixSubform;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Budgetnavn;
                           ENU=Budget Name];
                ToolTipML=[DAN=Angiver navnet p� budgettet.;
                           ENU=Specifies the name of the budget.];
                ApplicationArea=#Suite;
                SourceExpr=BudgetName;
                TableRelation="G/L Budget Name";
                OnValidate=BEGIN
                             ValidateBudgetName;
                             ValidateLineDimCode;
                             ValidateColumnDimCode;

                             UpdateMatrixSubform;
                           END;

                OnLookup=VAR
                           GLBudgetNames@1002 : Page 121;
                         BEGIN
                           GLBudgetNames.LOOKUPMODE := TRUE;
                           GLBudgetNames.SETRECORD(GLBudgetName);
                           IF GLBudgetNames.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             GLBudgetNames.GETRECORD(GLBudgetName);
                             BudgetName := GLBudgetName.Name;
                             Text := GLBudgetName.Name;
                             ValidateBudgetName;
                             ValidateLineDimCode;
                             ValidateColumnDimCode;
                             UpdateMatrixSubform;
                             EXIT(TRUE);
                           END;
                           ValidateBudgetName;
                           ValidateLineDimCode;
                           ValidateColumnDimCode;
                           CurrPage.UPDATE;
                           EXIT(FALSE);
                         END;
                          }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Vis som linjer;
                           ENU=Show as Lines];
                ToolTipML=[DAN=Angiver, hvilke v�rdier du vil have vist som linjer i vinduet. P� denne m�de f�r du vist det samme matrixvindue fra forskellige synsvinkler, is�r n�r du bruger b�de feltet Vis som linjer og Vis som kolonner.;
                           ENU=Specifies which values you want to show as lines in the window. This allows you to see the same matrix window from various perspectives, especially when you use both the Show as Lines field and the Show as Columns field.];
                ApplicationArea=#Suite;
                SourceExpr=LineDimCode;
                OnValidate=VAR
                             MATRIX_SetWanted@1001 : 'Initial,Previous,Same,Next,PreviousColumn,NextColumn';
                           BEGIN
                             IF (UPPERCASE(LineDimCode) = UPPERCASE(ColumnDimCode)) AND (LineDimCode <> '') THEN BEGIN
                               ColumnDimCode := '';
                               ValidateColumnDimCode;
                             END;
                             ValidateLineDimCode;
                             MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::Initial);
                             LineDimCodeOnAfterValidate;
                           END;

                OnLookup=VAR
                           NewCode@1002 : Text[30];
                         BEGIN
                           NewCode := GetDimSelection(LineDimCode);
                           IF NewCode = LineDimCode THEN
                             EXIT(FALSE);

                           Text := NewCode;
                           LineDimCode := NewCode;
                           ValidateLineDimCode;
                           LineDimCodeOnAfterValidate;
                           EXIT(TRUE);
                         END;
                          }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Vis som kolonner;
                           ENU=Show as Columns];
                ToolTipML=[DAN=Angiver, hvilke v�rdier du vil have vist som kolonner i vinduet. P� denne m�de f�r du vist det samme matrixvindue fra forskellige synsvinkler, is�r n�r du bruger b�de feltet Vis som linjer og Vis som kolonner.;
                           ENU=Specifies which values you want to show as columns in the window. This allows you to see the same matrix window from various perspectives, especially when you use both the Show as Lines field and the Show as Columns field.];
                ApplicationArea=#Suite;
                SourceExpr=ColumnDimCode;
                OnValidate=VAR
                             MATRIX_Step@1001 : 'Initial,Previous,Same,Next,PreviousColumn,NextColumn';
                           BEGIN
                             IF (UPPERCASE(LineDimCode) = UPPERCASE(ColumnDimCode)) AND (LineDimCode <> '') THEN BEGIN
                               LineDimCode := '';
                               ValidateLineDimCode;
                             END;
                             ValidateColumnDimCode;
                             MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
                             ColumnDimCodeOnAfterValidate;
                           END;

                OnLookup=VAR
                           NewCode@1002 : Text[30];
                           MATRIX_Step@1003 : 'Initial,Previous,Same,Next,PreviousColumn,NextColumn';
                         BEGIN
                           NewCode := GetDimSelection(ColumnDimCode);
                           IF NewCode = ColumnDimCode THEN
                             EXIT(FALSE);

                           Text := NewCode;
                           ColumnDimCode := NewCode;
                           ValidateColumnDimCode;
                           MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
                           ColumnDimCodeOnAfterValidate;
                           EXIT(TRUE);
                         END;
                          }

    { 15  ;2   ;Field     ;
                Name=PeriodType;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode bel�bene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,M�ned,Kvartal,�r,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                ApplicationArea=#Suite;
                SourceExpr=PeriodType;
                Enabled=PeriodTypeEnable;
                OnValidate=BEGIN
                             FindPeriod('');
                             PeriodTypeOnAfterValidate;
                           END;
                            }

    { 19  ;2   ;Field     ;
                CaptionML=[DAN=Afrundingsfaktor;
                           ENU=Rounding Factor];
                ToolTipML=[DAN=Angiver afrundingsfaktoren for bel�b.;
                           ENU=Specifies the factor that is used to round the amounts.];
                OptionCaptionML=[DAN=Ingen,1,1000,1000000;
                                 ENU=None,1,1000,1000000];
                ApplicationArea=#Suite;
                SourceExpr=RoundingFactor;
                OnValidate=BEGIN
                             UpdateMatrixSubform;
                           END;
                            }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Vis kolonnenavn;
                           ENU=Show Column Name];
                ToolTipML=[DAN=Angiver, at navnene p� kolonner vises i matrixvinduet.;
                           ENU=Specifies that the names of columns are shown in the matrix window.];
                ApplicationArea=#Suite;
                SourceExpr=ShowColumnName;
                OnValidate=BEGIN
                             ShowColumnNameOnPush;
                           END;
                            }

    { 1102601000;1;Part   ;
                Name=MatrixForm;
                ApplicationArea=#Suite;
                PagePartID=Page9203 }

    { 1907524401;1;Group  ;
                CaptionML=[DAN=Filtre;
                           ENU=Filters] }

    { 36  ;2   ;Field     ;
                Name=DateFilter;
                CaptionML=[DAN=Datofilter;
                           ENU=Date Filter];
                ToolTipML=[DAN=Angiver de datoer, der bruges til at filtrere bel�bene i vinduet.;
                           ENU=Specifies the dates that will be used to filter the amounts in the window.];
                ApplicationArea=#Suite;
                SourceExpr=DateFilter;
                OnValidate=BEGIN
                             ValidateDateFilter(DateFilter);
                           END;
                            }

    { 38  ;2   ;Field     ;
                CaptionML=[DAN=Finanskontofilter;
                           ENU=G/L Account Filter];
                ToolTipML=[DAN=Angiver de finanskonti, du vil have vist oplysninger om i vinduet.;
                           ENU=Specifies the G/L accounts for which you will see information in the window.];
                ApplicationArea=#Suite;
                SourceExpr=GLAccFilter;
                OnValidate=BEGIN
                             GLAccFilterOnAfterValidate;
                           END;

                OnLookup=VAR
                           GLAccList@1002 : Page 18;
                         BEGIN
                           GLAccList.LOOKUPMODE(TRUE);
                           IF NOT (GLAccList.RUNMODAL = ACTION::LookupOK) THEN
                             EXIT(FALSE);

                           Text := GLAccList.GetSelectionFilter;
                           EXIT(TRUE);
                         END;
                          }

    { 8   ;2   ;Field     ;
                Name=GLAccCategory;
                CaptionML=[DAN=Filter for finanskontokategori;
                           ENU=G/L Account Category Filter];
                ToolTipML=[DAN=Angiver kategorien for den finanskonto, du vil have vist oplysninger om i vinduet.;
                           ENU=Specifies the category of the G/L account for which you will see information in the window.];
                OptionCaptionML=[DAN=" ,Aktiver,G�ld,Egenkapital,Indt�gter,Vareforbrug,Udgifter";
                                 ENU=" ,Assets,Liabilities,Equity,Income,Cost of Goods Sold,Expense"];
                ApplicationArea=#Suite;
                SourceExpr=GLAccCategoryFilter;
                OnValidate=BEGIN
                             ValidateGLAccCategoryFilter;
                           END;
                            }

    { 7   ;2   ;Field     ;
                Name=IncomeBalGLAccFilter;
                CaptionML=[DAN=Filter for indt�gter/finanskontosaldo;
                           ENU=Income/Balance G/L Account Filter];
                ToolTipML=[DAN=Angiver typen af finanskonto, du vil have vist oplysninger om i vinduet.;
                           ENU=Specifies the type of the G/L account for which you will see information in the window.];
                OptionCaptionML=[DAN=" ,Resultatopg�relse,Balance";
                                 ENU=" ,Income Statement,Balance Sheet"];
                ApplicationArea=#Suite;
                SourceExpr=IncomeBalanceGLAccFilter;
                OnValidate=BEGIN
                             ValidateIncomeBalanceGLAccFilter;
                           END;
                            }

    { 49  ;2   ;Field     ;
                Name=GlobalDim1Filter;
                CaptionML=[DAN=Global dimension 1-filter;
                           ENU=Global Dimension 1 Filter];
                ToolTipML=[DAN=Angiver den globale dimension, som dataene vises efter. Globale dimensioner de dimensioner, som du analyserer oftest. To globale dimensioner, der typisk er for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies by which global dimension data is shown. Global dimensions are the dimensions that you analyze most frequently. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr=GlobalDim1Filter;
                CaptionClass='1,3,1';
                Enabled=GlobalDim1FilterEnable;
                OnValidate=BEGIN
                             GlobalDim1FilterOnAfterValidat;
                           END;

                OnLookup=VAR
                           DimensionValue@1001 : Record 349;
                         BEGIN
                           EXIT(DimensionValue.LookUpDimFilter(GLSetup."Global Dimension 1 Code",Text));
                         END;
                          }

    { 48  ;2   ;Field     ;
                Name=GlobalDim2Filter;
                CaptionML=[DAN=Global dimension 2-filter;
                           ENU=Global Dimension 2 Filter];
                ToolTipML=[DAN=Angiver den globale dimension, som dataene vises efter. Globale dimensioner de dimensioner, som du analyserer oftest. To globale dimensioner, der typisk er for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies by which global dimension data is shown. Global dimensions are the dimensions that you analyze most frequently. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr=GlobalDim2Filter;
                CaptionClass='1,3,2';
                Enabled=GlobalDim2FilterEnable;
                OnValidate=BEGIN
                             GlobalDim2FilterOnAfterValidat;
                           END;

                OnLookup=VAR
                           DimensionValue@1001 : Record 349;
                         BEGIN
                           EXIT(DimensionValue.LookUpDimFilter(GLSetup."Global Dimension 2 Code",Text));
                         END;
                          }

    { 34  ;2   ;Field     ;
                Name=BudgetDim1Filter;
                CaptionML=[DAN=Budgetdimension 1-filter;
                           ENU=Budget Dimension 1 Filter];
                ToolTipML=[DAN=Angiver et filter efter en budgetdimension. Du kan angive fire yderligere dimensioner p� hvert budget, du opretter.;
                           ENU=Specifies a filter by a budget dimension. You can specify four additional dimensions on each budget that you create.];
                ApplicationArea=#Suite;
                SourceExpr=BudgetDim1Filter;
                CaptionClass=GetCaptionClass(1);
                Enabled=BudgetDim1FilterEnable;
                OnValidate=BEGIN
                             BudgetDim1FilterOnAfterValidat;
                           END;

                OnLookup=VAR
                           DimensionValue@1001 : Record 349;
                         BEGIN
                           EXIT(DimensionValue.LookUpDimFilter(GLBudgetName."Budget Dimension 1 Code",Text));
                         END;
                          }

    { 30  ;2   ;Field     ;
                Name=BudgetDim2Filter;
                CaptionML=[DAN=Budgetdimension 2-filter;
                           ENU=Budget Dimension 2 Filter];
                ToolTipML=[DAN=Angiver et filter efter en budgetdimension. Du kan angive fire yderligere dimensioner p� hvert budget, du opretter.;
                           ENU=Specifies a filter by a budget dimension. You can specify four additional dimensions on each budget that you create.];
                ApplicationArea=#Suite;
                SourceExpr=BudgetDim2Filter;
                CaptionClass=GetCaptionClass(2);
                Enabled=BudgetDim2FilterEnable;
                OnValidate=BEGIN
                             BudgetDim2FilterOnAfterValidat;
                           END;

                OnLookup=VAR
                           DimensionValue@1001 : Record 349;
                         BEGIN
                           EXIT(DimensionValue.LookUpDimFilter(GLBudgetName."Budget Dimension 2 Code",Text));
                         END;
                          }

    { 46  ;2   ;Field     ;
                Name=BudgetDim3Filter;
                CaptionML=[DAN=Budgetdimension 3-filter;
                           ENU=Budget Dimension 3 Filter];
                ToolTipML=[DAN=Angiver et filter efter en budgetdimension. Du kan angive fire yderligere dimensioner p� hvert budget, du opretter.;
                           ENU=Specifies a filter by a budget dimension. You can specify four additional dimensions on each budget that you create.];
                ApplicationArea=#Suite;
                SourceExpr=BudgetDim3Filter;
                CaptionClass=GetCaptionClass(3);
                Enabled=BudgetDim3FilterEnable;
                OnValidate=BEGIN
                             BudgetDim3FilterOnAfterValidat;
                           END;

                OnLookup=VAR
                           DimensionValue@1001 : Record 349;
                         BEGIN
                           EXIT(DimensionValue.LookUpDimFilter(GLBudgetName."Budget Dimension 3 Code",Text));
                         END;
                          }

    { 35  ;2   ;Field     ;
                Name=BudgetDim4Filter;
                CaptionML=[DAN=Budgetdimension 4-filter;
                           ENU=Budget Dimension 4 Filter];
                ToolTipML=[DAN=Angiver et filter efter en budgetdimension. Du kan angive fire yderligere dimensioner p� hvert budget, du opretter.;
                           ENU=Specifies a filter by a budget dimension. You can specify four additional dimensions on each budget that you create.];
                ApplicationArea=#Suite;
                SourceExpr=BudgetDim4Filter;
                CaptionClass=GetCaptionClass(4);
                Enabled=BudgetDim4FilterEnable;
                OnValidate=BEGIN
                             BudgetDim4FilterOnAfterValidat;
                           END;

                OnLookup=VAR
                           DimensionValue@1001 : Record 349;
                         BEGIN
                           EXIT(DimensionValue.LookUpDimFilter(GLBudgetName."Budget Dimension 4 Code",Text));
                         END;
                          }

  }
  CODE
  {
    VAR
      GLSetup@1014 : Record 98;
      GLAccBudgetBuf@1013 : Record 374;
      GLBudgetName@1012 : Record 95;
      PrevGLBudgetName@1002 : Record 95;
      MATRIX_MatrixRecords@1191 : ARRAY [32] OF Record 367;
      MATRIX_CaptionSet@1192 : ARRAY [32] OF Text[80];
      MATRIX_CaptionRange@1193 : Text[80];
      FirstColumn@1000 : Text;
      LastColumn@1024 : Text;
      MATRIX_PrimKeyFirstCaptionInCu@1197 : Text[80];
      MATRIX_CurrentNoOfColumns@1198 : Integer;
      Text001@1001 : TextConst 'DAN=Periode;ENU=Period';
      Text003@1003 : TextConst 'DAN=Skal de viste budgetposter slettes?;ENU=Do you want to delete the budget entries shown?';
      Text004@1004 : TextConst 'DAN=STANDARD;ENU=DEFAULT';
      Text005@1005 : TextConst 'DAN=Standardbudget;ENU=Default budget';
      Text006@1006 : TextConst 'DAN=%1 er ikke en gyldig linjedefinition.;ENU=%1 is not a valid line definition.';
      Text007@1007 : TextConst 'DAN=%1 er ikke en gyldig kolonnedefinition.;ENU=%1 is not a valid column definition.';
      Text008@1008 : TextConst 'DAN=1,6,,Budgetdimension 1-filter;ENU=1,6,,Budget Dimension 1 Filter';
      Text009@1009 : TextConst 'DAN=1,6,,Budgetdimension 2-filter;ENU=1,6,,Budget Dimension 2 Filter';
      Text010@1010 : TextConst 'DAN=1,6,,Budgetdimension 3-filter;ENU=1,6,,Budget Dimension 3 Filter';
      Text011@1011 : TextConst 'DAN=1,6,,Budgetdimension 4-filter;ENU=1,6,,Budget Dimension 4 Filter';
      MATRIX_Step@1015 : 'Initial,Previous,Same,Next,PreviousColumn,NextColumn';
      BudgetName@1016 : Code[10];
      NewBudgetName@1042 : Code[10];
      LineDimOption@1017 : 'G/L Account,Period,Business Unit,Global Dimension 1,Global Dimension 2,Budget Dimension 1,Budget Dimension 2,Budget Dimension 3,Budget Dimension 4';
      ColumnDimOption@1018 : 'G/L Account,Period,Business Unit,Global Dimension 1,Global Dimension 2,Budget Dimension 1,Budget Dimension 2,Budget Dimension 3,Budget Dimension 4';
      LineDimCode@1019 : Text[30];
      ColumnDimCode@1020 : Text[30];
      PeriodType@1021 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      RoundingFactor@1022 : 'None,1,1000,1000000';
      GLAccCategoryFilter@1037 : ' ,Assets,Liabilities,Equity,Income,Cost of Goods Sold,Expense';
      IncomeBalanceGLAccFilter@1035 : ' ,Income Statement,Balance Sheet';
      ShowColumnName@1023 : Boolean;
      DateFilter@1025 : Text[30];
      InternalDateFilter@1026 : Text[30];
      BusUnitFilter@1027 : Text;
      GLAccFilter@1028 : Text;
      GlobalDim1Filter@1029 : Text;
      GlobalDim2Filter@1030 : Text;
      BudgetDim1Filter@1031 : Text;
      BudgetDim2Filter@1032 : Text;
      BudgetDim3Filter@1033 : Text;
      BudgetDim4Filter@1034 : Text;
      GlobalDim1FilterEnable@19070261 : Boolean INDATASET;
      GlobalDim2FilterEnable@19027189 : Boolean INDATASET;
      PeriodTypeEnable@19066505 : Boolean INDATASET;
      BudgetDim1FilterEnable@19060021 : Boolean INDATASET;
      BudgetDim2FilterEnable@19020249 : Boolean INDATASET;
      BudgetDim3FilterEnable@19077914 : Boolean INDATASET;
      BudgetDim4FilterEnable@19015030 : Boolean INDATASET;

    LOCAL PROCEDURE MATRIX_GenerateColumnCaptions@1206(MATRIX_SetWanted@1000 : 'Initial,Previous,Same,Next,PreviousColumn,NextColumn');
    VAR
      MATRIX_PeriodRecords@1006 : ARRAY [32] OF Record 2000000007;
      BusUnit@1002 : Record 220;
      GLAccount@1008 : Record 15;
      MatrixMgt@1003 : Codeunit 9200;
      RecRef@1004 : RecordRef;
      FieldRef@1005 : FieldRef;
      IncomeBalFieldRef@1001 : FieldRef;
      GLAccCategoryFieldRef@1009 : FieldRef;
      i@1007 : Integer;
    BEGIN
      CLEAR(MATRIX_CaptionSet);
      CLEAR(MATRIX_MatrixRecords);
      FirstColumn := '';
      LastColumn := '';
      MATRIX_CurrentNoOfColumns := 12;

      IF ColumnDimCode = '' THEN
        EXIT;

      CASE ColumnDimCode OF
        Text001:  // Period
          BEGIN
            MatrixMgt.GeneratePeriodMatrixData(
              MATRIX_SetWanted,MATRIX_CurrentNoOfColumns,ShowColumnName,
              PeriodType,DateFilter,MATRIX_PrimKeyFirstCaptionInCu,
              MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns,MATRIX_PeriodRecords);
            FOR i := 1 TO MATRIX_CurrentNoOfColumns DO BEGIN
              MATRIX_MatrixRecords[i]."Period Start" := MATRIX_PeriodRecords[i]."Period Start";
              MATRIX_MatrixRecords[i]."Period End" := MATRIX_PeriodRecords[i]."Period End";
            END;
            FirstColumn := FORMAT(MATRIX_PeriodRecords[1]."Period Start");
            LastColumn := FORMAT(MATRIX_PeriodRecords[MATRIX_CurrentNoOfColumns]."Period End");
            PeriodTypeEnable := TRUE;
          END;
        GLAccount.TABLECAPTION:
          BEGIN
            CLEAR(MATRIX_CaptionSet);
            RecRef.GETTABLE(GLAccount);
            RecRef.SETTABLE(GLAccount);
            IF GLAccFilter <> '' THEN BEGIN
              FieldRef := RecRef.FIELDINDEX(1);
              FieldRef.SETFILTER(GLAccFilter);
            END;
            IF IncomeBalanceGLAccFilter <> IncomeBalanceGLAccFilter::" " THEN BEGIN
              IncomeBalFieldRef := RecRef.FIELDINDEX(GLAccount.FIELDNO("Income/Balance"));
              CASE IncomeBalanceGLAccFilter OF
                IncomeBalanceGLAccFilter::"Balance Sheet":
                  IncomeBalFieldRef.SETRANGE(GLAccount."Income/Balance"::"Balance Sheet");
                IncomeBalanceGLAccFilter::"Income Statement":
                  IncomeBalFieldRef.SETRANGE(GLAccount."Income/Balance"::"Income Statement");
              END;
            END;
            IF GLAccCategoryFilter <> GLAccCategoryFilter::" " THEN BEGIN
              GLAccCategoryFieldRef := RecRef.FIELDINDEX(GLAccount.FIELDNO("Account Category"));
              GLAccCategoryFieldRef.SETRANGE(GLAccCategoryFilter);
            END;
            MatrixMgt.GenerateMatrixData(
              RecRef,MATRIX_SetWanted,12,1,
              MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
            FOR i := 1 TO MATRIX_CurrentNoOfColumns DO
              MATRIX_MatrixRecords[i].Code := COPYSTR(MATRIX_CaptionSet[i],1,MAXSTRLEN(MATRIX_MatrixRecords[i].Code));
            IF ShowColumnName THEN
              MatrixMgt.GenerateMatrixData(
                RecRef,MATRIX_SetWanted::Same,12,GLAccount.FIELDNO(Name),
                MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
          END;
        BusUnit.TABLECAPTION:
          BEGIN
            CLEAR(MATRIX_CaptionSet);
            RecRef.GETTABLE(BusUnit);
            RecRef.SETTABLE(BusUnit);
            IF BusUnitFilter <> '' THEN BEGIN
              FieldRef := RecRef.FIELDINDEX(1);
              FieldRef.SETFILTER(BusUnitFilter);
            END;
            MatrixMgt.GenerateMatrixData(
              RecRef,MATRIX_SetWanted,12,1,
              MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
            FOR i := 1 TO MATRIX_CurrentNoOfColumns DO
              MATRIX_MatrixRecords[i].Code := COPYSTR(MATRIX_CaptionSet[i],1,MAXSTRLEN(MATRIX_MatrixRecords[i].Code));
            IF ShowColumnName THEN
              MatrixMgt.GenerateMatrixData(
                RecRef,MATRIX_SetWanted::Same,12,BusUnit.FIELDNO(Name),
                MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
          END;
        // Apply dimension filter
        GLSetup."Global Dimension 1 Code":
          MatrixMgt.GenerateDimColumnCaption(
            GLSetup."Global Dimension 1 Code",
            GlobalDim1Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
            MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
        GLSetup."Global Dimension 2 Code":
          MatrixMgt.GenerateDimColumnCaption(
            GLSetup."Global Dimension 2 Code",
            GlobalDim2Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
            MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
        GLBudgetName."Budget Dimension 1 Code":
          MatrixMgt.GenerateDimColumnCaption(
            GLBudgetName."Budget Dimension 1 Code",
            BudgetDim1Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
            MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
        GLBudgetName."Budget Dimension 2 Code":
          MatrixMgt.GenerateDimColumnCaption(
            GLBudgetName."Budget Dimension 2 Code",
            BudgetDim2Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
            MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
        GLBudgetName."Budget Dimension 3 Code":
          MatrixMgt.GenerateDimColumnCaption(
            GLBudgetName."Budget Dimension 3 Code",
            BudgetDim3Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
            MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
        GLBudgetName."Budget Dimension 4 Code":
          MatrixMgt.GenerateDimColumnCaption(
            GLBudgetName."Budget Dimension 4 Code",
            BudgetDim4Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
            MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
      END;
    END;

    LOCAL PROCEDURE DimCodeToOption@21(DimCode@1000 : Text[30]) : Integer;
    VAR
      BusUnit@1001 : Record 220;
      GLAcc@1002 : Record 15;
    BEGIN
      CASE DimCode OF
        '':
          EXIT(-1);
        GLAcc.TABLECAPTION:
          EXIT(0);
        Text001:
          EXIT(1);
        BusUnit.TABLECAPTION:
          EXIT(2);
        GLSetup."Global Dimension 1 Code":
          EXIT(3);
        GLSetup."Global Dimension 2 Code":
          EXIT(4);
        GLBudgetName."Budget Dimension 1 Code":
          EXIT(5);
        GLBudgetName."Budget Dimension 2 Code":
          EXIT(6);
        GLBudgetName."Budget Dimension 3 Code":
          EXIT(7);
        GLBudgetName."Budget Dimension 4 Code":
          EXIT(8);
        ELSE
          EXIT(-1);
      END;
    END;

    LOCAL PROCEDURE FindPeriod@2(SearchText@1000 : Code[10]);
    VAR
      GLAcc@1001 : Record 15;
      Calendar@1002 : Record 2000000007;
      PeriodFormMgt@1003 : Codeunit 359;
    BEGIN
      IF DateFilter <> '' THEN BEGIN
        Calendar.SETFILTER("Period Start",DateFilter);
        IF NOT PeriodFormMgt.FindDate('+',Calendar,PeriodType) THEN
          PeriodFormMgt.FindDate('+',Calendar,PeriodType::Day);
        Calendar.SETRANGE("Period Start");
      END;
      PeriodFormMgt.FindDate(SearchText,Calendar,PeriodType);
      GLAcc.SETRANGE("Date Filter",Calendar."Period Start",Calendar."Period End");
      IF GLAcc.GETRANGEMIN("Date Filter") = GLAcc.GETRANGEMAX("Date Filter") THEN
        GLAcc.SETRANGE("Date Filter",GLAcc.GETRANGEMIN("Date Filter"));
      InternalDateFilter := GLAcc.GETFILTER("Date Filter");
      IF (LineDimOption <> LineDimOption::Period) AND (ColumnDimOption <> ColumnDimOption::Period) THEN
        DateFilter := InternalDateFilter;
    END;

    LOCAL PROCEDURE GetDimSelection@3(OldDimSelCode@1000 : Text[30]) : Text[30];
    VAR
      GLAcc@1001 : Record 15;
      BusUnit@1003 : Record 220;
      DimSelection@1002 : Page 568;
    BEGIN
      DimSelection.InsertDimSelBuf(FALSE,GLAcc.TABLECAPTION,GLAcc.TABLECAPTION);
      DimSelection.InsertDimSelBuf(FALSE,BusUnit.TABLECAPTION,BusUnit.TABLECAPTION);
      DimSelection.InsertDimSelBuf(FALSE,Text001,Text001);
      IF GLSetup."Global Dimension 1 Code" <> '' THEN
        DimSelection.InsertDimSelBuf(FALSE,GLSetup."Global Dimension 1 Code",'');
      IF GLSetup."Global Dimension 2 Code" <> '' THEN
        DimSelection.InsertDimSelBuf(FALSE,GLSetup."Global Dimension 2 Code",'');
      IF GLBudgetName."Budget Dimension 1 Code" <> '' THEN
        DimSelection.InsertDimSelBuf(FALSE,GLBudgetName."Budget Dimension 1 Code",'');
      IF GLBudgetName."Budget Dimension 2 Code" <> '' THEN
        DimSelection.InsertDimSelBuf(FALSE,GLBudgetName."Budget Dimension 2 Code",'');
      IF GLBudgetName."Budget Dimension 3 Code" <> '' THEN
        DimSelection.InsertDimSelBuf(FALSE,GLBudgetName."Budget Dimension 3 Code",'');
      IF GLBudgetName."Budget Dimension 4 Code" <> '' THEN
        DimSelection.InsertDimSelBuf(FALSE,GLBudgetName."Budget Dimension 4 Code",'');

      DimSelection.LOOKUPMODE := TRUE;
      IF DimSelection.RUNMODAL = ACTION::LookupOK THEN
        EXIT(DimSelection.GetDimSelCode);

      EXIT(OldDimSelCode);
    END;

    LOCAL PROCEDURE DeleteBudget@10();
    VAR
      GLBudgetEntry@1000 : Record 96;
      UpdateAnalysisView@1001 : Codeunit 410;
    BEGIN
      IF CONFIRM(Text003) THEN
        WITH GLBudgetEntry DO BEGIN
          SETRANGE("Budget Name",BudgetName);
          IF BusUnitFilter <> '' THEN
            SETFILTER("Business Unit Code",BusUnitFilter);
          IF GLAccFilter <> '' THEN
            SETFILTER("G/L Account No.",GLAccFilter);
          IF DateFilter <> '' THEN
            SETFILTER(Date,DateFilter);
          IF GlobalDim1Filter <> '' THEN
            SETFILTER("Global Dimension 1 Code",GlobalDim1Filter);
          IF GlobalDim2Filter <> '' THEN
            SETFILTER("Global Dimension 2 Code",GlobalDim2Filter);
          IF BudgetDim1Filter <> '' THEN
            SETFILTER("Budget Dimension 1 Code",BudgetDim1Filter);
          IF BudgetDim2Filter <> '' THEN
            SETFILTER("Budget Dimension 2 Code",BudgetDim2Filter);
          IF BudgetDim3Filter <> '' THEN
            SETFILTER("Budget Dimension 3 Code",BudgetDim3Filter);
          IF BudgetDim4Filter <> '' THEN
            SETFILTER("Budget Dimension 4 Code",BudgetDim4Filter);
          SETCURRENTKEY("Entry No.");
          IF FINDFIRST THEN
            UpdateAnalysisView.SetLastBudgetEntryNo("Entry No." - 1);
          SETCURRENTKEY("Budget Name");
          DELETEALL(TRUE);
        END;
    END;

    LOCAL PROCEDURE ValidateBudgetName@11();
    BEGIN
      GLBudgetName.Name := BudgetName;
      IF NOT GLBudgetName.FIND('=<>') THEN BEGIN
        GLBudgetName.INIT;
        GLBudgetName.Name := Text004;
        GLBudgetName.Description := Text005;
        GLBudgetName.INSERT;
      END;
      BudgetName := GLBudgetName.Name;
      GLAccBudgetBuf.SETRANGE("Budget Filter",BudgetName);
      IF PrevGLBudgetName.Name <> '' THEN BEGIN
        IF GLBudgetName."Budget Dimension 1 Code" <> PrevGLBudgetName."Budget Dimension 1 Code" THEN
          BudgetDim1Filter := '';
        IF GLBudgetName."Budget Dimension 2 Code" <> PrevGLBudgetName."Budget Dimension 2 Code" THEN
          BudgetDim2Filter := '';
        IF GLBudgetName."Budget Dimension 3 Code" <> PrevGLBudgetName."Budget Dimension 3 Code" THEN
          BudgetDim3Filter := '';
        IF GLBudgetName."Budget Dimension 4 Code" <> PrevGLBudgetName."Budget Dimension 4 Code" THEN
          BudgetDim4Filter := '';
      END;
      GLAccBudgetBuf.SETFILTER("Budget Dimension 1 Filter",BudgetDim1Filter);
      GLAccBudgetBuf.SETFILTER("Budget Dimension 2 Filter",BudgetDim2Filter);
      GLAccBudgetBuf.SETFILTER("Budget Dimension 3 Filter",BudgetDim3Filter);
      GLAccBudgetBuf.SETFILTER("Budget Dimension 4 Filter",BudgetDim4Filter);
      BudgetDim1FilterEnable := (GLBudgetName."Budget Dimension 1 Code" <> '');
      BudgetDim2FilterEnable := (GLBudgetName."Budget Dimension 2 Code" <> '');
      BudgetDim3FilterEnable := (GLBudgetName."Budget Dimension 3 Code" <> '');
      BudgetDim4FilterEnable := (GLBudgetName."Budget Dimension 4 Code" <> '');

      PrevGLBudgetName := GLBudgetName;
    END;

    LOCAL PROCEDURE ValidateLineDimCode@19();
    VAR
      BusUnit@1000 : Record 220;
      GLAcc@1001 : Record 15;
    BEGIN
      IF (UPPERCASE(LineDimCode) <> UPPERCASE(GLAcc.TABLECAPTION)) AND
         (UPPERCASE(LineDimCode) <> UPPERCASE(BusUnit.TABLECAPTION)) AND
         (UPPERCASE(LineDimCode) <> UPPERCASE(Text001)) AND
         (UPPERCASE(LineDimCode) <> GLBudgetName."Budget Dimension 1 Code") AND
         (UPPERCASE(LineDimCode) <> GLBudgetName."Budget Dimension 2 Code") AND
         (UPPERCASE(LineDimCode) <> GLBudgetName."Budget Dimension 3 Code") AND
         (UPPERCASE(LineDimCode) <> GLBudgetName."Budget Dimension 4 Code") AND
         (UPPERCASE(LineDimCode) <> GLSetup."Global Dimension 1 Code") AND
         (UPPERCASE(LineDimCode) <> GLSetup."Global Dimension 2 Code") AND
         (LineDimCode <> '')
      THEN BEGIN
        MESSAGE(Text006,LineDimCode);
        LineDimCode := '';
      END;
      LineDimOption := DimCodeToOption(LineDimCode);
      DateFilter := InternalDateFilter;
      IF (LineDimOption <> LineDimOption::Period) AND (ColumnDimOption <> ColumnDimOption::Period) THEN BEGIN
        DateFilter := InternalDateFilter;
        IF STRPOS(DateFilter,'&') > 1 THEN
          DateFilter := COPYSTR(DateFilter,1,STRPOS(DateFilter,'&') - 1);
      END ELSE
        DateFilter := '';
    END;

    LOCAL PROCEDURE ValidateColumnDimCode@20();
    VAR
      BusUnit@1000 : Record 220;
      GLAcc@1001 : Record 15;
    BEGIN
      IF (UPPERCASE(ColumnDimCode) <> UPPERCASE(GLAcc.TABLECAPTION)) AND
         (UPPERCASE(ColumnDimCode) <> UPPERCASE(BusUnit.TABLECAPTION)) AND
         (UPPERCASE(ColumnDimCode) <> UPPERCASE(Text001)) AND
         (UPPERCASE(ColumnDimCode) <> GLBudgetName."Budget Dimension 1 Code") AND
         (UPPERCASE(ColumnDimCode) <> GLBudgetName."Budget Dimension 2 Code") AND
         (UPPERCASE(ColumnDimCode) <> GLBudgetName."Budget Dimension 3 Code") AND
         (UPPERCASE(ColumnDimCode) <> GLBudgetName."Budget Dimension 4 Code") AND
         (UPPERCASE(ColumnDimCode) <> GLSetup."Global Dimension 1 Code") AND
         (UPPERCASE(ColumnDimCode) <> GLSetup."Global Dimension 2 Code") AND
         (ColumnDimCode <> '')
      THEN BEGIN
        MESSAGE(Text007,ColumnDimCode);
        ColumnDimCode := '';
      END;
      ColumnDimOption := DimCodeToOption(ColumnDimCode);
      DateFilter := InternalDateFilter;
      IF (LineDimOption <> LineDimOption::Period) AND (ColumnDimOption <> ColumnDimOption::Period) THEN BEGIN
        DateFilter := InternalDateFilter;
        IF STRPOS(DateFilter,'&') > 1 THEN
          DateFilter := COPYSTR(DateFilter,1,STRPOS(DateFilter,'&') - 1);
      END ELSE
        DateFilter := '';
    END;

    LOCAL PROCEDURE GetCaptionClass@13(BudgetDimType@1000 : Integer) : Text[250];
    BEGIN
      IF GLBudgetName.Name <> BudgetName THEN
        GLBudgetName.GET(BudgetName);
      CASE BudgetDimType OF
        1:
          BEGIN
            IF GLBudgetName."Budget Dimension 1 Code" <> '' THEN
              EXIT('1,6,' + GLBudgetName."Budget Dimension 1 Code");

            EXIT(Text008);
          END;
        2:
          BEGIN
            IF GLBudgetName."Budget Dimension 2 Code" <> '' THEN
              EXIT('1,6,' + GLBudgetName."Budget Dimension 2 Code");

            EXIT(Text009);
          END;
        3:
          BEGIN
            IF GLBudgetName."Budget Dimension 3 Code" <> '' THEN
              EXIT('1,6,' + GLBudgetName."Budget Dimension 3 Code");

            EXIT(Text010);
          END;
        4:
          BEGIN
            IF GLBudgetName."Budget Dimension 4 Code" <> '' THEN
              EXIT('1,6,' + GLBudgetName."Budget Dimension 4 Code");

            EXIT(Text011);
          END;
      END;
    END;

    [External]
    PROCEDURE SetBudgetName@14(NextBudgetName@1000 : Code[10]);
    BEGIN
      NewBudgetName := NextBudgetName;
    END;

    [Internal]
    PROCEDURE SetGLAccountFilter@1(NewGLAccFilter@1000 : Code[250]);
    BEGIN
      GLAccFilter := NewGLAccFilter;
      GLAccFilterOnAfterValidate;
    END;

    LOCAL PROCEDURE UpdateMatrixSubform@1102601003();
    BEGIN
      CurrPage.MatrixForm.PAGE.Load(
        MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,LineDimCode,
        LineDimOption,ColumnDimOption,GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,
        BudgetDim2Filter,BudgetDim3Filter,BudgetDim4Filter,GLBudgetName,DateFilter,
        GLAccFilter,IncomeBalanceGLAccFilter,GLAccCategoryFilter,RoundingFactor,PeriodType);

      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE LineDimCodeOnAfterValidate@19031201();
    BEGIN
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE ColumnDimCodeOnAfterValidate@19023109();
    BEGIN
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE PeriodTypeOnAfterValidate@19015506();
    VAR
      MATRIX_Step@1001 : 'Initial,Previous,Same,Next,PreviousColumn,NextColumn';
    BEGIN
      IF ColumnDimOption = ColumnDimOption::Period THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE GLAccFilterOnAfterValidate@19040142();
    BEGIN
      GLAccBudgetBuf.SETFILTER("G/L Account Filter",GLAccFilter);
      IF ColumnDimOption = ColumnDimOption::"G/L Account" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE ValidateIncomeBalanceGLAccFilter@4();
    BEGIN
      GLAccBudgetBuf.SETRANGE("Income/Balance",IncomeBalanceGLAccFilter);
      IF ColumnDimOption = ColumnDimOption::"G/L Account" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE ValidateGLAccCategoryFilter@9();
    BEGIN
      GLAccBudgetBuf.SETRANGE("Account Category",GLAccCategoryFilter);
      IF ColumnDimOption = ColumnDimOption::"G/L Account" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE GlobalDim2FilterOnAfterValidat@19025957();
    BEGIN
      GLAccBudgetBuf.SETFILTER("Global Dimension 2 Filter",GlobalDim2Filter);
      IF ColumnDimOption = ColumnDimOption::"Global Dimension 2" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE GlobalDim1FilterOnAfterValidat@19037628();
    BEGIN
      GLAccBudgetBuf.SETFILTER("Global Dimension 1 Filter",GlobalDim1Filter);
      IF ColumnDimOption = ColumnDimOption::"Global Dimension 1" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE BudgetDim2FilterOnAfterValidat@19061952();
    BEGIN
      GLAccBudgetBuf.SETFILTER("Budget Dimension 2 Filter",BudgetDim2Filter);
      IF ColumnDimOption = ColumnDimOption::"Budget Dimension 2" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE BudgetDim1FilterOnAfterValidat@19002351();
    BEGIN
      GLAccBudgetBuf.SETFILTER("Budget Dimension 1 Filter",BudgetDim1Filter);
      IF ColumnDimOption = ColumnDimOption::"Budget Dimension 1" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE BudgetDim4FilterOnAfterValidat@19068654();
    BEGIN
      GLAccBudgetBuf.SETFILTER("Budget Dimension 4 Filter",BudgetDim4Filter);
      IF ColumnDimOption = ColumnDimOption::"Budget Dimension 4" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE BudgetDim3FilterOnAfterValidat@19015715();
    BEGIN
      GLAccBudgetBuf.SETFILTER("Budget Dimension 3 Filter",BudgetDim3Filter);
      IF ColumnDimOption = ColumnDimOption::"Budget Dimension 3" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE DateFilterOnAfterValidate@19006009();
    BEGIN
      IF ColumnDimOption = ColumnDimOption::Period THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE ShowColumnNameOnPush@19040364();
    VAR
      MATRIX_Step@1000 : 'Initial,Previous,Same,Next,PreviousColumn,NextColumn';
    BEGIN
      MATRIX_GenerateColumnCaptions(MATRIX_Step::Same);
      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE ValidateDateFilter@5(NewDateFilter@1000 : Text[30]);
    VAR
      ApplicationManagement@1001 : Codeunit 1;
    BEGIN
      IF ApplicationManagement.MakeDateFilter(NewDateFilter) = 0 THEN;
      GLAccBudgetBuf.SETFILTER("Date Filter",NewDateFilter);
      DateFilter := COPYSTR(GLAccBudgetBuf.GETFILTER("Date Filter"),1,MAXSTRLEN(DateFilter));
      InternalDateFilter := NewDateFilter;
      DateFilterOnAfterValidate;
    END;

    BEGIN
    END.
  }
}

