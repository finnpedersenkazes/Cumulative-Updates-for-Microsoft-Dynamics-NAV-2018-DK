OBJECT Page 7139 Sales Budget Overview
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Oversigt over salgsbudget;
               ENU=Sales Budget Overview];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    PageType=ListPlus;
    OnInit=BEGIN
             BudgetDim3FilterEnable := TRUE;
             BudgetDim2FilterEnable := TRUE;
             BudgetDim1FilterEnable := TRUE;
           END;

    OnOpenPage=BEGIN
                 IF ValueType = 0 THEN
                   ValueType := ValueType::"Sales Amount";
                 CurrentAnalysisArea := CurrentAnalysisArea::Sales;
                 ItemBudgetManagement.BudgetNameSelection(
                   CurrentAnalysisArea,CurrentBudgetName,ItemBudgetName,ItemStatisticsBuffer,
                   BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter);

                 IF (NewBudgetName <> '') AND (CurrentBudgetName <> NewBudgetName) THEN BEGIN
                   CurrentBudgetName := NewBudgetName;
                   ItemBudgetManagement.CheckBudgetName(CurrentAnalysisArea,CurrentBudgetName,ItemBudgetName);
                   ItemBudgetManagement.SetItemBudgetName(
                     CurrentBudgetName,ItemBudgetName,ItemStatisticsBuffer,
                     BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter);
                 END;

                 ItemBudgetManagement.SetLineAndColDim(
                   ItemBudgetName,LineDimCode,LineDimOption,ColumnDimCode,ColumnDimOption);

                 GLSetup.GET;
                 SourceTypeFilter := SourceTypeFilter::Customer;

                 UpdateDimCtrls;

                 FindPeriod('');
                 MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
                 UpdateMatrixSubForm;
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 40      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=Byt om p� linjer og kolonner;
                                 ENU=Reverse Lines and Columns];
                      ToolTipML=[DAN=Rediger visningen af matrixen ved at invertere v�rdierne i felterne Vis som linjer og Vis som kolonner.;
                                 ENU=Change the display of the matrix by inverting the values in the Show as Lines and Show as Columns fields.];
                      ApplicationArea=#SalesBudget;
                      Image=Undo;
                      OnAction=VAR
                                 TempDimCode@1001 : Text[30];
                               BEGIN
                                 TempDimCode := ColumnDimCode;
                                 ColumnDimCode := LineDimCode;
                                 LineDimCode := TempDimCode;
                                 ItemBudgetManagement.ValidateLineDimCode(
                                   ItemBudgetName,LineDimCode,LineDimOption,ColumnDimOption,
                                   InternalDateFilter,DateFilter,ItemStatisticsBuffer,PeriodInitialized);
                                 ItemBudgetManagement.ValidateColumnDimCode(
                                   ItemBudgetName,ColumnDimCode,ColumnDimOption,LineDimOption,
                                   InternalDateFilter,DateFilter,ItemStatisticsBuffer,PeriodInitialized);
                                 MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
                                 UpdateMatrixSubForm;
                               END;
                                }
      { 53      ;2   ;Separator  }
      { 54      ;2   ;Action    ;
                      Name=DeleteBudget;
                      CaptionML=[DAN=Slet budget;
                                 ENU=Delete Budget];
                      ToolTipML=[DAN=Slet det aktuelle budget.;
                                 ENU=Delete the current budget.];
                      ApplicationArea=#SalesBudget;
                      Image=Delete;
                      OnAction=BEGIN
                                 ItemBudgetManagement.DeleteBudget(
                                   CurrentAnalysisArea,CurrentBudgetName,
                                   ItemFilter,DateFilter,
                                   SourceTypeFilter,SourceNoFilter,
                                   GlobalDim1Filter,GlobalDim2Filter,
                                   BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter);
                               END;
                                }
      { 55      ;2   ;Separator  }
      { 42      ;1   ;ActionGroup;
                      CaptionML=[DAN=Udl�s til Excel;
                                 ENU=Export to Excel];
                      Image=ExportToExcel }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Opret nyt dokument;
                                 ENU=Create New Document];
                      ToolTipML=[DAN=�bn analyserapporten i en ny Excel-projektmappe. Det opretter en Excel-projektmappe p� din enhed.;
                                 ENU=Open the analysis report in a new Excel workbook. This creates an Excel workbook on your device.];
                      ApplicationArea=#SalesBudget;
                      Image=ExportToExcel;
                      OnAction=VAR
                                 ExportItemBudgetToExcel@1000 : Report 7132;
                               BEGIN
                                 ExportItemBudgetToExcel.SetOptions(
                                   CurrentAnalysisArea,
                                   CurrentBudgetName,
                                   ValueType,
                                   GlobalDim1Filter,GlobalDim2Filter,
                                   BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter,
                                   DateFilter,
                                   SourceTypeFilter,SourceNoFilter,
                                   ItemFilter,
                                   InternalDateFilter,PeriodInitialized,PeriodType,
                                   LineDimOption,ColumnDimOption,LineDimCode,ColumnDimCode,RoundingFactor);
                                 ExportItemBudgetToExcel.RUN;
                               END;
                                }
      { 4       ;2   ;Action    ;
                      CaptionML=[DAN=Opdater eksisterende dokument;
                                 ENU=Update Existing Document];
                      ToolTipML=[DAN=Opdater data i en eksisterende Excel-projektmappe. Du skal angive den projektmappe, som du vil opdatere.;
                                 ENU=Refresh the data in an existing Excel workbook. You must specify the workbook that you want to update.];
                      ApplicationArea=#SalesBudget;
                      Image=ExportToExcel;
                      OnAction=VAR
                                 ExportItemBudgetToExcel@1000 : Report 7132;
                               BEGIN
                                 ExportItemBudgetToExcel.SetOptions(
                                   CurrentAnalysisArea,
                                   CurrentBudgetName,
                                   ValueType,
                                   GlobalDim1Filter,GlobalDim2Filter,
                                   BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter,
                                   DateFilter,
                                   SourceTypeFilter,SourceNoFilter,
                                   ItemFilter,
                                   InternalDateFilter,PeriodInitialized,PeriodType,
                                   LineDimOption,ColumnDimOption,LineDimCode,ColumnDimCode,RoundingFactor);
                                 ExportItemBudgetToExcel.SetUpdateExistingWorksheet(TRUE);
                                 ExportItemBudgetToExcel.RUN;
                               END;
                                }
      { 56      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indl�s fra Excel;
                                 ENU=Import from Excel];
                      ToolTipML=[DAN=Import�r et budget, du tidligere har eksporteret til Excel.;
                                 ENU=Import a budget that you exported to Excel earlier.];
                      ApplicationArea=#SalesBudget;
                      Image=ImportExcel;
                      OnAction=VAR
                                 ImportItemBudgetFromExcel@1000 : Report 7131;
                               BEGIN
                                 ImportItemBudgetFromExcel.SetParameters(CurrentBudgetName,CurrentAnalysisArea,ValueType);
                                 ImportItemBudgetFromExcel.RUNMODAL;
                                 CLEAR(ImportItemBudgetFromExcel);
                               END;
                                }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=N�ste periode;
                                 ENU=Next Period];
                      ToolTipML=[DAN=Vis oplysningerne baseret p� den n�ste periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen efter.;
                                 ENU=Show the information based on the next period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#SalesBudget;
                      Promoted=Yes;
                      Image=NextRecord;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF (LineDimOption = LineDimOption::Period) OR (ColumnDimOption = ColumnDimOption::Period) THEN
                                   EXIT;
                                 FindPeriod('>');
                                 CurrPage.UPDATE;
                                 UpdateMatrixSubForm;
                               END;
                                }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Forrige periode;
                                 ENU=Previous Period];
                      ToolTipML=[DAN=F� vist oplysningerne baseret p� den forrige periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen f�r.;
                                 ENU=Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#SalesBudget;
                      Promoted=Yes;
                      Image=PreviousRecord;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF (LineDimOption = LineDimOption::Period) OR (ColumnDimOption = ColumnDimOption::Period) THEN
                                   EXIT;
                                 FindPeriod('<');
                                 CurrPage.UPDATE;
                                 UpdateMatrixSubForm;
                               END;
                                }
      { 23      ;1   ;Action    ;
                      CaptionML=[DAN=Forrige s�t;
                                 ENU=Previous Set];
                      ToolTipML=[DAN=G� til det forrige datas�t.;
                                 ENU=Go to the previous set of data.];
                      ApplicationArea=#SalesBudget;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousSet;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MATRIX_Step@1001 : 'Initial,Previous,Same,Next';
                               BEGIN
                                 MATRIX_GenerateColumnCaptions(MATRIX_Step::Previous);
                                 UpdateMatrixSubForm;
                               END;
                                }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Forrige kolonne;
                                 ENU=Previous Column];
                      ToolTipML=[DAN=G� til den forrige kolonne.;
                                 ENU=Go to the previous column.];
                      ApplicationArea=#SalesBudget;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousRecord;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 MATRIX_GenerateColumnCaptions(MATRIX_Step::PreviousColumn);
                                 UpdateMatrixSubForm;
                               END;
                                }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=N�ste kolonne;
                                 ENU=Next Column];
                      ToolTipML=[DAN=G� til n�ste kolonne.;
                                 ENU=Go to the next column.];
                      ApplicationArea=#SalesBudget;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextRecord;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 MATRIX_GenerateColumnCaptions(MATRIX_Step::NextColumn);
                                 UpdateMatrixSubForm;
                               END;
                                }
      { 24      ;1   ;Action    ;
                      CaptionML=[DAN=N�ste s�t;
                                 ENU=Next Set];
                      ToolTipML=[DAN=G� til det n�ste datas�t.;
                                 ENU=Go to the next set of data.];
                      ApplicationArea=#SalesBudget;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextSet;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MATRIX_Step@1001 : 'Initial,Previous,Same,Next';
                               BEGIN
                                 MATRIX_GenerateColumnCaptions(MATRIX_Step::Next);
                                 UpdateMatrixSubForm;
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

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Varebudgetnavn;
                           ENU=Item Budget Name];
                ToolTipML=[DAN=Angiver navnet p� det budget, der skal vises i vinduet.;
                           ENU=Specifies the name of the budget to be shown in the window.];
                ApplicationArea=#SalesBudget;
                SourceExpr=CurrentBudgetName;
                OnValidate=BEGIN
                             ItemBudgetManagement.CheckBudgetName(CurrentAnalysisArea,CurrentBudgetName,ItemBudgetName);
                             UpdateMatrixSubForm;
                             CurrentBudgetNameOnAfterValida;
                           END;

                OnLookup=BEGIN
                           ItemBudgetManagement.LookupItemBudgetName(
                             CurrentBudgetName,ItemBudgetName,ItemStatisticsBuffer,
                             BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter);
                           ItemBudgetManagement.ValidateLineDimCode(
                             ItemBudgetName,LineDimCode,LineDimOption,ColumnDimOption,
                             InternalDateFilter,DateFilter,ItemStatisticsBuffer,PeriodInitialized);
                           ItemBudgetManagement.ValidateColumnDimCode(
                             ItemBudgetName,ColumnDimCode,ColumnDimOption,LineDimOption,
                             InternalDateFilter,DateFilter,ItemStatisticsBuffer,PeriodInitialized);
                           UpdateDimCtrls;
                           UpdateMatrixSubForm;
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Vis som linjer;
                           ENU=Show as Lines];
                ToolTipML=[DAN=Angiver, hvilke v�rdier du vil have vist som linjer i vinduet. P� denne m�de f�r du vist det samme matrixvindue fra forskellige synsvinkler, is�r n�r du bruger b�de feltet Vis som linjer og Vis som kolonner.;
                           ENU=Specifies which values you want to show as lines in the window. This allows you to see the same matrix window from various perspectives, especially when you use both the Show as Lines field and the Show as Columns field.];
                ApplicationArea=#SalesBudget;
                SourceExpr=LineDimCode;
                OnValidate=BEGIN
                             IF (UPPERCASE(LineDimCode) = UPPERCASE(ColumnDimCode)) AND (LineDimCode <> '') THEN BEGIN
                               ColumnDimCode := '';
                               ItemBudgetManagement.ValidateColumnDimCode(
                                 ItemBudgetName,ColumnDimCode,ColumnDimOption,LineDimOption,
                                 InternalDateFilter,DateFilter,ItemStatisticsBuffer,PeriodInitialized);
                             END;
                             ItemBudgetManagement.ValidateLineDimCode(
                               ItemBudgetName,LineDimCode,LineDimOption,ColumnDimOption,
                               InternalDateFilter,DateFilter,ItemStatisticsBuffer,PeriodInitialized);
                             LineDimCodeOnAfterValidate;
                           END;

                OnLookup=VAR
                           NewCode@1000 : Text[30];
                         BEGIN
                           NewCode := ItemBudgetManagement.GetDimSelection(LineDimCode,ItemBudgetName);
                           IF NewCode <> LineDimCode THEN BEGIN
                             Text := NewCode;
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Vis som kolonner;
                           ENU=Show as Columns];
                ToolTipML=[DAN=Angiver, hvilke v�rdier du vil have vist som kolonner i vinduet. P� denne m�de f�r du vist det samme matrixvindue fra forskellige synsvinkler, is�r n�r du bruger b�de feltet Vis som linjer og Vis som kolonner.;
                           ENU=Specifies which values you want to show as columns in the window. This allows you to see the same matrix window from various perspectives, especially when you use both the Show as Lines field and the Show as Columns field.];
                ApplicationArea=#SalesBudget;
                SourceExpr=ColumnDimCode;
                OnValidate=BEGIN
                             IF (UPPERCASE(LineDimCode) = UPPERCASE(ColumnDimCode)) AND (LineDimCode <> '') THEN BEGIN
                               LineDimCode := '';
                               ItemBudgetManagement.ValidateLineDimCode(
                                 ItemBudgetName,LineDimCode,LineDimOption,ColumnDimOption,
                                 InternalDateFilter,DateFilter,ItemStatisticsBuffer,PeriodInitialized);
                             END;
                             ItemBudgetManagement.ValidateColumnDimCode(
                               ItemBudgetName,ColumnDimCode,ColumnDimOption,LineDimOption,
                               InternalDateFilter,DateFilter,ItemStatisticsBuffer,PeriodInitialized);

                             MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
                             ColumnDimCodeOnAfterValidate;
                           END;

                OnLookup=VAR
                           NewCode@1000 : Text[30];
                         BEGIN
                           NewCode := ItemBudgetManagement.GetDimSelection(ColumnDimCode,ItemBudgetName);
                           IF NewCode <> ColumnDimCode THEN BEGIN
                             Text := NewCode;
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 14  ;2   ;Field     ;
                CaptionML=[DAN=Vis v�rdi som;
                           ENU=Show Value as];
                ToolTipML=[DAN=Angiver, om du vil have vist varev�rdier efter salgsbel�b, kostbel�b eller antal.;
                           ENU=Specifies if you want to view the item values by sales amount, cost amount, or quantity.];
                OptionCaptionML=[DAN=Salgsbel�b,Vareforbrugsbel�b,Antal;
                                 ENU=Sales Amount,COGS Amount,Quantity];
                ApplicationArea=#SalesBudget;
                SourceExpr=ValueType;
                OnValidate=BEGIN
                             ValueTypeOnAfterValidate;
                           END;
                            }

    { 21  ;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode bel�bene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,M�ned,Kvartal,�r,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                ApplicationArea=#SalesBudget;
                SourceExpr=PeriodType;
                OnValidate=BEGIN
                             FindPeriod('');
                             PeriodTypeOnAfterValidate;
                           END;
                            }

    { 27  ;2   ;Field     ;
                CaptionML=[DAN=Afrundingsfaktor;
                           ENU=Rounding Factor];
                ToolTipML=[DAN=Angiver afrundingsfaktoren for bel�bene i kolonnerne.;
                           ENU=Specifies the factor that is used to round the amounts in the columns.];
                OptionCaptionML=[DAN=Ingen,1,1000,1000000;
                                 ENU=None,1,1000,1000000];
                ApplicationArea=#SalesBudget;
                SourceExpr=RoundingFactor;
                OnValidate=BEGIN
                             RoundingFactorOnAfterValidate;
                           END;
                            }

    { 26  ;2   ;Field     ;
                CaptionML=[DAN=Vis kolonnenavn;
                           ENU=Show Column Name];
                ToolTipML=[DAN=Angiver, at navnene p� kolonner vises i matrixvinduet.;
                           ENU=Specifies that the names of columns are shown in the matrix window.];
                ApplicationArea=#SalesBudget;
                SourceExpr=ShowColumnName;
                OnValidate=BEGIN
                             ShowColumnNameOnAfterValidate;
                           END;
                            }

    { 17  ;1   ;Part      ;
                Name=MATRIX;
                ApplicationArea=#SalesBudget;
                PagePartID=Page9239 }

    { 1907524401;1;Group  ;
                CaptionML=[DAN=Filtre;
                           ENU=Filters] }

    { 33  ;2   ;Field     ;
                CaptionML=[DAN=Datofilter;
                           ENU=Date Filter];
                ToolTipML=[DAN=Angiver et datofilter, som budgetbel�b vises efter.;
                           ENU=Specifies a date filter by which budget amounts are displayed.];
                ApplicationArea=#SalesBudget;
                SourceExpr=DateFilter;
                OnValidate=VAR
                             ApplicationManagement@1001 : Codeunit 1;
                           BEGIN
                             IF ApplicationManagement.MakeDateFilter(DateFilter) = 0 THEN;
                             ItemStatisticsBuffer.SETFILTER("Date Filter",DateFilter);
                             DateFilter := ItemStatisticsBuffer.GETFILTER("Date Filter");
                             InternalDateFilter := DateFilter;
                             DateFilterOnAfterValidate;
                           END;
                            }

    { 31  ;2   ;Field     ;
                Name=SalesCodeFilterCtrl;
                CaptionML=[DAN=Debitorfilter;
                           ENU=Customer Filter];
                ToolTipML=[DAN=Angiver det filter, der g�lder for debitorer, som varerne er solgt til.;
                           ENU=Specifies the filter that applies to the customers to whom items are sold.];
                ApplicationArea=#SalesBudget;
                SourceExpr=SourceNoFilter;
                OnValidate=BEGIN
                             SourceNoFilterOnAfterValidate;
                           END;

                OnLookup=VAR
                           CustList@1005 : Page 22;
                           VendList@1004 : Page 27;
                         BEGIN
                           CASE SourceTypeFilter OF
                             SourceTypeFilter::Customer:
                               BEGIN
                                 CustList.LOOKUPMODE := TRUE;
                                 IF CustList.RUNMODAL = ACTION::LookupOK THEN
                                   Text := CustList.GetSelectionFilter
                                 ELSE
                                   EXIT(FALSE);
                               END;
                             SourceTypeFilter::Vendor:
                               BEGIN
                                 VendList.LOOKUPMODE := TRUE;
                                 IF VendList.RUNMODAL = ACTION::LookupOK THEN
                                   Text := VendList.GetSelectionFilter
                                 ELSE
                                   EXIT(FALSE);
                               END;
                           END;

                           EXIT(TRUE);
                         END;
                          }

    { 32  ;2   ;Field     ;
                CaptionML=[DAN=Varefilter;
                           ENU=Item Filter];
                ToolTipML=[DAN=Angiver, hvilke varer der skal medtages i budgetoversigten.;
                           ENU=Specifies which items to include in the budget overview.];
                ApplicationArea=#SalesBudget;
                SourceExpr=ItemFilter;
                OnValidate=BEGIN
                             ItemFilterOnAfterValidate;
                           END;

                OnLookup=VAR
                           ItemList@1002 : Page 31;
                         BEGIN
                           ItemList.LOOKUPMODE(TRUE);
                           IF ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             Text := ItemList.GetSelectionFilter;
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 47  ;2   ;Field     ;
                Name=BudgetDim1Filter;
                CaptionML=[DAN=Budgetdimension 1-filter;
                           ENU=Budget Dimension 1 Filter];
                ToolTipML=[DAN="Angiver et filter efter en budgetdimension. ";
                           ENU="Specifies a filter by a budget dimension. "];
                ApplicationArea=#Dimensions;
                SourceExpr=BudgetDim1Filter;
                CaptionClass=GetCaptionClass(1);
                Enabled=BudgetDim1FilterEnable;
                OnValidate=BEGIN
                             BudgetDim1FilterOnAfterValidat;
                           END;

                OnLookup=BEGIN
                           EXIT(LookUpDimFilter(ItemBudgetName."Budget Dimension 1 Code",Text));
                         END;
                          }

    { 44  ;2   ;Field     ;
                Name=BudgetDim2Filter;
                CaptionML=[DAN=Budgetdimension 2-filter;
                           ENU=Budget Dimension 2 Filter];
                ToolTipML=[DAN="Angiver endnu et filter efter en budgetdimension. ";
                           ENU="Specifies a second filter by a budget dimension. "];
                ApplicationArea=#Dimensions;
                SourceExpr=BudgetDim2Filter;
                CaptionClass=GetCaptionClass(2);
                Enabled=BudgetDim2FilterEnable;
                OnValidate=BEGIN
                             BudgetDim2FilterOnAfterValidat;
                           END;

                OnLookup=BEGIN
                           EXIT(LookUpDimFilter(ItemBudgetName."Budget Dimension 2 Code",Text));
                         END;
                          }

    { 43  ;2   ;Field     ;
                Name=BudgetDim3Filter;
                CaptionML=[DAN=Budgetdimension 3-filter;
                           ENU=Budget Dimension 3 Filter];
                ToolTipML=[DAN="Angiver et tredje filter efter en budgetdimension. ";
                           ENU="Specifies a third filter by a budget dimension. "];
                ApplicationArea=#Dimensions;
                SourceExpr=BudgetDim3Filter;
                CaptionClass=GetCaptionClass(3);
                Enabled=BudgetDim3FilterEnable;
                OnValidate=BEGIN
                             BudgetDim3FilterOnAfterValidat;
                           END;

                OnLookup=BEGIN
                           EXIT(LookUpDimFilter(ItemBudgetName."Budget Dimension 3 Code",Text));
                         END;
                          }

    { 50  ;2   ;Field     ;
                Name=GlobalDim1Filter;
                CaptionML=[DAN=Global dimension 1-filter;
                           ENU=Global Dimension 1 Filter];
                ToolTipML=[DAN=Angiver den globale dimension, som dataene vises efter. Globale dimensioner de dimensioner, som du analyserer oftest. To globale dimensioner, der typisk er for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies by which global dimension data is shown. Global dimensions are the dimensions that you analyze most frequently. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr=GlobalDim1Filter;
                CaptionClass='1,3,1';
                OnValidate=BEGIN
                             GlobalDim1FilterOnAfterValidat;
                           END;

                OnLookup=BEGIN
                           EXIT(LookUpDimFilter(GLSetup."Global Dimension 1 Code",Text));
                         END;
                          }

    { 49  ;2   ;Field     ;
                Name=GlobalDim2Filter;
                CaptionML=[DAN=Global dimension 2-filter;
                           ENU=Global Dimension 2 Filter];
                ToolTipML=[DAN=Angiver den globale dimension, som dataene vises efter. Globale dimensioner de dimensioner, som du analyserer oftest. To globale dimensioner, der typisk er for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies by which global dimension data is shown. Global dimensions are the dimensions that you analyze most frequently. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr=GlobalDim2Filter;
                CaptionClass='1,3,2';
                OnValidate=BEGIN
                             GlobalDim2FilterOnAfterValidat;
                           END;

                OnLookup=BEGIN
                           EXIT(LookUpDimFilter(GLSetup."Global Dimension 2 Code",Text));
                         END;
                          }

  }
  CODE
  {
    VAR
      GLSetup@1026 : Record 98;
      ItemBudgetName@1010 : Record 7132;
      ItemStatisticsBuffer@1006 : Record 5821;
      MATRIX_MatrixRecords@1137 : ARRAY [32] OF Record 367;
      ItemBudgetManagement@1003 : Codeunit 7130;
      MATRIX_CaptionSet@1138 : ARRAY [32] OF Text[80];
      MATRIX_CaptionRange@1139 : Text;
      FirstColumn@1020 : Text;
      LastColumn@1021 : Text;
      MATRIX_PrimKeyFirstCaptionInCu@1143 : Text;
      MATRIX_CurrentNoOfColumns@1144 : Integer;
      CurrentAnalysisArea@1005 : 'Sales,Purchase,Inventory';
      CurrentBudgetName@1002 : Code[10];
      SourceTypeFilter@1017 : ' ,Customer,Vendor,Item';
      SourceNoFilter@1016 : Text;
      ItemFilter@1019 : Text;
      ValueType@1018 : 'Sales Amount,COGS Amount,Quantity';
      RoundingFactor@1028 : 'None,1,1000,1000000';
      LineDimOption@1001 : 'Item,Customer,Vendor,Period,Location,Global Dimension 1,Global Dimension 2,Budget Dimension 1,Budget Dimension 2,Budget Dimension 3';
      ColumnDimOption@1000 : 'Item,Customer,Vendor,Period,Location,Global Dimension 1,Global Dimension 2,Budget Dimension 1,Budget Dimension 2,Budget Dimension 3';
      PeriodType@1022 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      GlobalDim1Filter@1024 : Text;
      GlobalDim2Filter@1023 : Text;
      BudgetDim1Filter@1009 : Text;
      BudgetDim2Filter@1008 : Text;
      BudgetDim3Filter@1007 : Text;
      LineDimCode@1012 : Text[30];
      ColumnDimCode@1011 : Text[30];
      DateFilter@1014 : Text;
      InternalDateFilter@1013 : Text;
      PeriodInitialized@1015 : Boolean;
      ShowColumnName@1025 : Boolean;
      Text003@1034 : TextConst 'DAN=1,6,,Budgetdimension 1-filter;ENU=1,6,,Budget Dimension 1 Filter';
      Text004@1033 : TextConst 'DAN=1,6,,Budgetdimension 2-filter;ENU=1,6,,Budget Dimension 2 Filter';
      Text005@1004 : TextConst 'DAN=1,6,,Budgetdimension 3-filter;ENU=1,6,,Budget Dimension 3 Filter';
      Text100@1036 : TextConst 'DAN=Periode;ENU=Period';
      NewBudgetName@1037 : Code[10];
      MATRIX_Step@1029 : 'Initial,Previous,Same,Next,PreviousColumn,NextColumn';
      BudgetDim1FilterEnable@19060021 : Boolean INDATASET;
      BudgetDim2FilterEnable@19020249 : Boolean INDATASET;
      BudgetDim3FilterEnable@19077914 : Boolean INDATASET;

    LOCAL PROCEDURE MATRIX_GenerateColumnCaptions@1152(MATRIX_SetWanted@1000 : 'Initial,Previous,Same,Next,PreviousColumn,NextColumn');
    VAR
      MATRIX_PeriodRecords@1001 : ARRAY [32] OF Record 2000000007;
      Location@1005 : Record 14;
      Item@1007 : Record 27;
      Customer@1008 : Record 18;
      Vendor@1009 : Record 23;
      MatrixMgt@1003 : Codeunit 9200;
      RecRef@1004 : RecordRef;
      FieldRef@1011 : FieldRef;
      i@1002 : Integer;
    BEGIN
      CLEAR(MATRIX_CaptionSet);
      CLEAR(MATRIX_MatrixRecords);
      FirstColumn := '';
      LastColumn := '';
      MATRIX_CurrentNoOfColumns := 12;

      IF ColumnDimCode = '' THEN
        EXIT;

      CASE ColumnDimCode OF
        Text100:  // Period
          BEGIN
            MatrixMgt.GeneratePeriodMatrixData(
              MATRIX_SetWanted,12,ShowColumnName,
              PeriodType,DateFilter,MATRIX_PrimKeyFirstCaptionInCu,
              MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns,MATRIX_PeriodRecords);
            FOR i := 1 TO 12 DO BEGIN
              MATRIX_MatrixRecords[i]."Period Start" := MATRIX_PeriodRecords[i]."Period Start";
              MATRIX_MatrixRecords[i]."Period End" := MATRIX_PeriodRecords[i]."Period End";
            END;
            FirstColumn := FORMAT(MATRIX_PeriodRecords[1]."Period Start");
            LastColumn := FORMAT(MATRIX_PeriodRecords[MATRIX_CurrentNoOfColumns]."Period End");
          END;
        Location.TABLECAPTION:
          BEGIN
            CLEAR(MATRIX_CaptionSet);
            RecRef.GETTABLE(Location);
            RecRef.SETTABLE(Location);
            MatrixMgt.GenerateMatrixData(
              RecRef,MATRIX_SetWanted,12,1,
              MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
            FOR i := 1 TO MATRIX_CurrentNoOfColumns DO
              MATRIX_MatrixRecords[i].Code := MATRIX_CaptionSet[i];
            IF ShowColumnName THEN
              MatrixMgt.GenerateMatrixData(
                RecRef,MATRIX_SetWanted::Same,12,2,
                MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
          END;
        Item.TABLECAPTION:
          BEGIN
            CLEAR(MATRIX_CaptionSet);
            RecRef.GETTABLE(Item);
            RecRef.SETTABLE(Item);
            IF ItemFilter <> '' THEN BEGIN
              FieldRef := RecRef.FIELD(Item.FIELDNO("No."));
              FieldRef.SETFILTER(ItemFilter);
            END;
            MatrixMgt.GenerateMatrixData(
              RecRef,MATRIX_SetWanted,12,1,
              MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
            FOR i := 1 TO MATRIX_CurrentNoOfColumns DO
              MATRIX_MatrixRecords[i].Code := MATRIX_CaptionSet[i];
            IF ShowColumnName THEN
              MatrixMgt.GenerateMatrixData(
                RecRef,MATRIX_SetWanted::Same,12,3,
                MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
          END;
        Customer.TABLECAPTION:
          BEGIN
            CLEAR(MATRIX_CaptionSet);
            RecRef.GETTABLE(Customer);
            RecRef.SETTABLE(Customer);
            IF SourceNoFilter <> '' THEN BEGIN
              FieldRef := RecRef.FIELD(Customer.FIELDNO("No."));
              FieldRef.SETFILTER(SourceNoFilter);
            END;
            MatrixMgt.GenerateMatrixData(
              RecRef,MATRIX_SetWanted,12,1,
              MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
            FOR i := 1 TO MATRIX_CurrentNoOfColumns DO
              MATRIX_MatrixRecords[i].Code := MATRIX_CaptionSet[i];
            IF ShowColumnName THEN
              MatrixMgt.GenerateMatrixData(
                RecRef,MATRIX_SetWanted::Same,12,2,
                MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
          END;
        Vendor.TABLECAPTION:
          BEGIN
            CLEAR(MATRIX_CaptionSet);
            RecRef.GETTABLE(Vendor);
            RecRef.SETTABLE(Vendor);
            MatrixMgt.GenerateMatrixData(
              RecRef,MATRIX_SetWanted,12,1,
              MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
            FOR i := 1 TO MATRIX_CurrentNoOfColumns DO
              MATRIX_MatrixRecords[i].Code := MATRIX_CaptionSet[i];
            IF ShowColumnName THEN
              MatrixMgt.GenerateMatrixData(
                RecRef,MATRIX_SetWanted::Same,12,2,
                MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
          END;
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
        ItemBudgetName."Budget Dimension 1 Code":
          MatrixMgt.GenerateDimColumnCaption(
            ItemBudgetName."Budget Dimension 1 Code",
            BudgetDim1Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
            MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
        ItemBudgetName."Budget Dimension 2 Code":
          MatrixMgt.GenerateDimColumnCaption(
            ItemBudgetName."Budget Dimension 2 Code",
            BudgetDim2Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
            MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
        ItemBudgetName."Budget Dimension 3 Code":
          MatrixMgt.GenerateDimColumnCaption(
            ItemBudgetName."Budget Dimension 3 Code",
            BudgetDim3Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
            MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
      END;
    END;

    LOCAL PROCEDURE FindPeriod@2(SearchText@1000 : Code[3]);
    VAR
      PeriodFormMgt@1003 : Codeunit 359;
    BEGIN
      PeriodFormMgt.FindPeriodOnMatrixPage(
        DateFilter,InternalDateFilter,SearchText,PeriodType,
        (LineDimOption <> LineDimOption::Period) AND (ColumnDimOption <> ColumnDimOption::Period));
    END;

    LOCAL PROCEDURE GetCaptionClass@13(BudgetDimType@1000 : Integer) : Text[250];
    BEGIN
      IF ItemBudgetName.Name <> CurrentBudgetName THEN
        ItemBudgetName.GET(CurrentAnalysisArea,CurrentBudgetName);
      CASE BudgetDimType OF
        1:
          BEGIN
            IF ItemBudgetName."Budget Dimension 1 Code" <> '' THEN
              EXIT('1,6,' + ItemBudgetName."Budget Dimension 1 Code");
            EXIT(Text003);
          END;
        2:
          BEGIN
            IF ItemBudgetName."Budget Dimension 2 Code" <> '' THEN
              EXIT('1,6,' + ItemBudgetName."Budget Dimension 2 Code");
            EXIT(Text004);
          END;
        3:
          BEGIN
            IF ItemBudgetName."Budget Dimension 3 Code" <> '' THEN
              EXIT('1,6,' + ItemBudgetName."Budget Dimension 3 Code");
            EXIT(Text005);
          END;
      END;
    END;

    LOCAL PROCEDURE LookUpDimFilter@57(Dim@1000 : Code[20];VAR Text@1001 : Text[250]) : Boolean;
    VAR
      DimVal@1002 : Record 349;
      DimValList@1003 : Page 560;
    BEGIN
      IF Dim = '' THEN
        EXIT(FALSE);
      DimVal.SETRANGE("Dimension Code",Dim);
      DimValList.SETTABLEVIEW(DimVal);
      DimValList.LOOKUPMODE(TRUE);
      IF DimValList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        DimValList.GETRECORD(DimVal);
        Text := DimValList.GetSelectionFilter;
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE UpdateDimCtrls@1();
    BEGIN
      BudgetDim1FilterEnable := ItemBudgetName."Budget Dimension 1 Code" <> '';
      BudgetDim2FilterEnable := ItemBudgetName."Budget Dimension 2 Code" <> '';
      BudgetDim3FilterEnable := ItemBudgetName."Budget Dimension 3 Code" <> '';
    END;

    [External]
    PROCEDURE SetNewBudgetName@5(NewPurchBudgetName@1000 : Code[10]);
    BEGIN
      NewBudgetName := NewPurchBudgetName;
    END;

    LOCAL PROCEDURE UpdateMatrixSubForm@7();
    BEGIN
      CurrPage.MATRIX.PAGE.SetFilters(
        DateFilter,ItemFilter,SourceNoFilter,
        GlobalDim1Filter,GlobalDim2Filter,
        BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter);
      CurrPage.MATRIX.PAGE.Load(
        MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,
        CurrentBudgetName,LineDimOption,ColumnDimOption,RoundingFactor,ValueType,PeriodType);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE CurrentBudgetNameOnAfterValida@19022925();
    BEGIN
      ItemBudgetManagement.SetItemBudgetName(
        CurrentBudgetName,ItemBudgetName,ItemStatisticsBuffer,
        BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter);
      ItemBudgetManagement.ValidateLineDimCode(
        ItemBudgetName,LineDimCode,LineDimOption,ColumnDimOption,
        InternalDateFilter,DateFilter,ItemStatisticsBuffer,PeriodInitialized);
      ItemBudgetManagement.ValidateColumnDimCode(
        ItemBudgetName,ColumnDimCode,ColumnDimOption,LineDimOption,
        InternalDateFilter,DateFilter,ItemStatisticsBuffer,PeriodInitialized);
      UpdateDimCtrls;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ColumnDimCodeOnAfterValidate@19023109();
    BEGIN
      FindPeriod('');
      MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubForm;
    END;

    LOCAL PROCEDURE LineDimCodeOnAfterValidate@19031201();
    BEGIN
      FindPeriod('');
      MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubForm;
    END;

    LOCAL PROCEDURE ValueTypeOnAfterValidate@19028630();
    BEGIN
      FindPeriod('');
      MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubForm;
    END;

    LOCAL PROCEDURE PeriodTypeOnAfterValidate@19015506();
    VAR
      MATRIX_Step@1001 : 'First,Previous,Next';
    BEGIN
      IF ColumnDimOption = ColumnDimOption::Period THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::First);
      UpdateMatrixSubForm;
    END;

    LOCAL PROCEDURE ShowColumnNameOnAfterValidate@19074585();
    VAR
      MATRIX_SetWanted@1000 : 'First,Previous,Same,Next';
    BEGIN
      MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::Same);
      UpdateMatrixSubForm;
    END;

    LOCAL PROCEDURE RoundingFactorOnAfterValidate@19029817();
    BEGIN
      UpdateMatrixSubForm;
    END;

    LOCAL PROCEDURE BudgetDim3FilterOnAfterValidat@19015715();
    BEGIN
      IF ColumnDimOption = ColumnDimOption::"Budget Dimension 3" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubForm;
    END;

    LOCAL PROCEDURE BudgetDim2FilterOnAfterValidat@19061952();
    BEGIN
      IF ColumnDimOption = ColumnDimOption::"Budget Dimension 2" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubForm;
    END;

    LOCAL PROCEDURE BudgetDim1FilterOnAfterValidat@19002351();
    BEGIN
      IF ColumnDimOption = ColumnDimOption::"Budget Dimension 1" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubForm;
    END;

    LOCAL PROCEDURE GlobalDim2FilterOnAfterValidat@19025957();
    BEGIN
      IF ColumnDimOption = ColumnDimOption::"Global Dimension 2" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubForm;
    END;

    LOCAL PROCEDURE GlobalDim1FilterOnAfterValidat@19037628();
    BEGIN
      IF ColumnDimOption = ColumnDimOption::"Global Dimension 1" THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubForm;
    END;

    LOCAL PROCEDURE SourceNoFilterOnAfterValidate@19003103();
    BEGIN
      IF ColumnDimOption = ColumnDimOption::Customer THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubForm;
    END;

    LOCAL PROCEDURE ItemFilterOnAfterValidate@19051257();
    BEGIN
      IF ColumnDimOption = ColumnDimOption::Item THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubForm;
    END;

    LOCAL PROCEDURE DateFilterOnAfterValidate@19006009();
    BEGIN
      IF ColumnDimOption = ColumnDimOption::Period THEN
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
      UpdateMatrixSubForm;
    END;

    BEGIN
    END.
  }
}

