OBJECT Page 490 Acc. Schedule Overview
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontoskemaoversigt;
               ENU=Acc. Schedule Overview];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table85;
    DataCaptionExpr=CurrentSchedName + ' - ' + CurrentColumnName;
    PageType=List;
    ShowFilter=No;
    OnInit=BEGIN
             Dim4FilterEnable := TRUE;
             Dim3FilterEnable := TRUE;
             Dim2FilterEnable := TRUE;
             Dim1FilterEnable := TRUE;
           END;

    OnOpenPage=BEGIN
                 UseAmtsInAddCurr := FALSE;
                 GLSetup.GET;
                 UseAmtsInAddCurrVisible := GLSetup."Additional Reporting Currency" <> '';
                 IF NewCurrentSchedName <> '' THEN
                   CurrentSchedName := NewCurrentSchedName;
                 IF CurrentSchedName = '' THEN
                   CurrentSchedName := Text000;
                 IF NewCurrentColumnName <> '' THEN
                   CurrentColumnName := NewCurrentColumnName;
                 IF CurrentColumnName = '' THEN
                   CurrentColumnName := Text000;
                 IF NewPeriodTypeSet THEN
                   PeriodType := ModifiedPeriodType;

                 AccSchedManagement.CopyColumnsToTemp(CurrentColumnName,TempColumnLayout);
                 AccSchedManagement.OpenSchedule(CurrentSchedName,Rec);
                 AccSchedManagement.OpenColumns(CurrentColumnName,TempColumnLayout);
                 AccSchedManagement.CheckAnalysisView(CurrentSchedName,CurrentColumnName,TRUE);
                 UpdateColumnCaptions;
                 IF AccSchedName.GET(CurrentSchedName) THEN
                   IF AccSchedName."Analysis View Name" <> '' THEN
                     AnalysisView.GET(AccSchedName."Analysis View Name")
                   ELSE BEGIN
                     CLEAR(AnalysisView);
                     AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
                     AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
                   END;

                 AccSchedManagement.FindPeriod(Rec,'',PeriodType);
                 SETFILTER(Show,'<>%1',Show::No);
                 SETRANGE("Dimension 1 Filter");
                 SETRANGE("Dimension 2 Filter");
                 SETRANGE("Dimension 3 Filter");
                 SETRANGE("Dimension 4 Filter");
                 SETRANGE("Cost Center Filter");
                 SETRANGE("Cost Object Filter");
                 SETRANGE("Cash Flow Forecast Filter");
                 SETRANGE("Cost Budget Filter");
                 SETRANGE("G/L Budget Filter");
                 UpdateDimFilterControls;
                 DateFilter := GETFILTER("Date Filter");
               END;

    OnAfterGetRecord=VAR
                       ColumnNo@1000 : Integer;
                     BEGIN
                       CLEAR(ColumnValues);

                       IF (Totaling = '') OR (NOT TempColumnLayout.FINDSET) THEN
                         EXIT;

                       REPEAT
                         ColumnNo := ColumnNo + 1;
                         IF (ColumnNo > ColumnOffset) AND (ColumnNo - ColumnOffset <= ARRAYLEN(ColumnValues)) THEN BEGIN
                           ColumnValues[ColumnNo - ColumnOffset] :=
                             RoundNone(
                               MatrixMgt.RoundValue(
                                 AccSchedManagement.CalcCell(Rec,TempColumnLayout,UseAmtsInAddCurr),
                                 TempColumnLayout."Rounding Factor"),
                               TempColumnLayout."Rounding Factor");
                           ColumnLayoutArr[ColumnNo - ColumnOffset] := TempColumnLayout;
                           GetStyle(ColumnNo - ColumnOffset,"Line No.",TempColumnLayout."Line No.");
                         END;
                       UNTIL TempColumnLayout.NEXT = 0;
                       AccSchedManagement.ForceRecalculate(FALSE);
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 28      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 40      ;1   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udskriv;
                                 ENU=Print];
                      ToolTipML=[DAN=Udskriv oplysningerne i vinduet. Du f†r vist et anmodningsvindue for udskrivningen, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Print the information in the window. A print request window opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Print;
                      OnAction=VAR
                                 AccSched@1000 : Report 25;
                                 DateFilter2@1002 : Text;
                                 GLBudgetFilter2@1003 : Text;
                                 BusUnitFilter@1004 : Text;
                                 CostBudgetFilter2@1005 : Text;
                               BEGIN
                                 AccSched.SetAccSchedName(CurrentSchedName);
                                 AccSched.SetColumnLayoutName(CurrentColumnName);
                                 DateFilter2 := GETFILTER("Date Filter");
                                 GLBudgetFilter2 := GETFILTER("G/L Budget Filter");
                                 CostBudgetFilter2 := GETFILTER("Cost Budget Filter");
                                 BusUnitFilter := GETFILTER("Business Unit Filter");
                                 AccSched.SetFilters(DateFilter2,GLBudgetFilter2,CostBudgetFilter2,BusUnitFilter,Dim1Filter,Dim2Filter,Dim3Filter,Dim4Filter);
                                 AccSched.RUN;
                               END;
                                }
      { 2       ;1   ;Action    ;
                      Name=PreviousColumn;
                      CaptionML=[DAN=Forrige kolonne;
                                 ENU=Previous Column];
                      ToolTipML=[DAN=G† til forrige kolonne.;
                                 ENU=Go to the previous column.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousRecord;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 AdjustColumnOffset(-1);
                               END;
                                }
      { 27      ;1   ;Action    ;
                      Name=NextPeriod;
                      CaptionML=[DAN=N‘ste periode;
                                 ENU=Next Period];
                      ToolTipML=[DAN=Vis oplysningerne baseret p† den n‘ste periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen efter.;
                                 ENU=Show the information based on the next period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=NextRecord;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 AccSchedManagement.FindPeriod(Rec,'>=',PeriodType);
                                 DateFilter := GETFILTER("Date Filter");
                               END;
                                }
      { 26      ;1   ;Action    ;
                      Name=PreviousPeriod;
                      CaptionML=[DAN=Forrige periode;
                                 ENU=Previous Period];
                      ToolTipML=[DAN=Vis oplysningerne baseret p† den forrige periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen f›r.;
                                 ENU=Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=PreviousRecord;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 AccSchedManagement.FindPeriod(Rec,'<=',PeriodType);
                                 DateFilter := GETFILTER("Date Filter");
                               END;
                                }
      { 1       ;1   ;Action    ;
                      Name=NextColumn;
                      CaptionML=[DAN=N‘ste kolonne;
                                 ENU=Next Column];
                      ToolTipML=[DAN=G† til n‘ste kolonne.;
                                 ENU=Go to the next column.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextRecord;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 AdjustColumnOffset(1);
                               END;
                                }
      { 14      ;1   ;Action    ;
                      Name=Recalculate;
                      CaptionML=[DAN=Genberegn;
                                 ENU=Recalculate];
                      ToolTipML=[DAN=Opdater oversigten over kontoskemaer, der er baseret p† de seneste ‘ndringer.;
                                 ENU=Update the account schedule overview based on recent changes.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Refresh;
                      OnAction=BEGIN
                                 AccSchedManagement.ForceRecalculate(TRUE);
                               END;
                                }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Excel;
                                 ENU=Excel] }
      { 41      ;2   ;ActionGroup;
                      CaptionML=[DAN=Udl‘s til Excel;
                                 ENU=Export to Excel];
                      Image=ExportToExcel }
      { 292     ;3   ;Action    ;
                      CaptionML=[DAN=Opret nyt dokument;
                                 ENU=Create New Document];
                      ToolTipML=[DAN=bn oversigten over kontoskemaer i en ny Excel-projektmappe. Det opretter en Excel-projektmappe p† din enhed.;
                                 ENU=Open the account schedule overview in a new Excel workbook. This creates an Excel workbook on your device.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ExportToExcel;
                      OnAction=VAR
                                 ExportAccSchedToExcel@1001 : Report 29;
                               BEGIN
                                 ExportAccSchedToExcel.SetOptions(Rec,CurrentColumnName,UseAmtsInAddCurr);
                                 ExportAccSchedToExcel.RUN;
                               END;
                                }
      { 13      ;3   ;Action    ;
                      CaptionML=[DAN=Opdater eksisterende dokument;
                                 ENU=Update Existing Document];
                      ToolTipML=[DAN=Opdater data i en eksisterende Excel-projektmappe. Du skal angive den projektmappe, som du vil opdatere.;
                                 ENU=Refresh the data in an existing Excel workbook. You must specify the workbook that you want to update.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ExportToExcel;
                      OnAction=VAR
                                 ExportAccSchedToExcel@1000 : Report 29;
                               BEGIN
                                 ExportAccSchedToExcel.SetOptions(Rec,CurrentColumnName,UseAmtsInAddCurr);
                                 ExportAccSchedToExcel.SetUpdateExistingWorksheet(TRUE);
                                 ExportAccSchedToExcel.RUN;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 8   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 10  ;2   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kontoskemanavn;
                           ENU=Account Schedule Name];
                ToolTipML=[DAN=Angiver navnet p† det kontoskema, der skal vises i vinduet.;
                           ENU=Specifies the name of the account schedule to be shown in the window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CurrentSchedName;
                Importance=Promoted;
                LookupPageID=Account Schedule Names;
                OnValidate=BEGIN
                             AccSchedManagement.CheckName(CurrentSchedName);
                             CurrentSchedNameOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           EXIT(AccSchedManagement.LookupName(CurrentSchedName,Text));
                         END;
                          }

    { 12  ;2   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kolonneformatnavn;
                           ENU=Column Layout Name];
                ToolTipML=[DAN=Angiver navnet p† det kolonneformat, som skal bruges i vinduet.;
                           ENU=Specifies the name of the column layout that you want to use in the window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CurrentColumnName;
                TableRelation="Column Layout Name".Name;
                OnValidate=BEGIN
                             AccSchedManagement.CheckColumnName(CurrentColumnName);
                             CurrentColumnNameOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           EXIT(AccSchedManagement.LookupColumnName(CurrentColumnName,Text));
                         END;
                          }

    { 44  ;2   ;Field     ;
                Name=UseAmtsInAddCurr;
                CaptionML=[DAN=Vis bel›b i ekstra rapporteringsvaluta;
                           ENU=Show Amounts in Add. Reporting Currency];
                ToolTipML=[DAN=Angiver, om de rapporterede bel›b vises i den ekstra rapporteringsvaluta.;
                           ENU=Specifies if the reported amounts are shown in the additional reporting currency.];
                ApplicationArea=#Suite;
                SourceExpr=UseAmtsInAddCurr;
                Visible=UseAmtsInAddCurrVisible;
                MultiLine=Yes;
                OnValidate=BEGIN
                             CurrPage.UPDATE;
                           END;
                            }

    { 42  ;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode bel›bene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,M†ned,Kvartal,r,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=PeriodType;
                Importance=Promoted;
                OnValidate=BEGIN
                             AccSchedManagement.FindPeriod(Rec,'',PeriodType);
                             DateFilter := GETFILTER("Date Filter");
                             CurrPage.UPDATE;
                           END;
                            }

    { 7   ;2   ;Field     ;
                Name=DateFilter;
                CaptionML=[DAN=Datofilter;
                           ENU=Date Filter];
                ToolTipML=[DAN=Angiver de datoer, der bruges til at filtrere bel›bene i vinduet.;
                           ENU=Specifies the dates that will be used to filter the amounts in the window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=DateFilter;
                Importance=Promoted;
                OnValidate=VAR
                             ApplicationManagement@1002 : Codeunit 1;
                           BEGIN
                             IF ApplicationManagement.MakeDateFilter(DateFilter) = 0 THEN;
                             SETFILTER("Date Filter",DateFilter);
                             DateFilter := GETFILTER("Date Filter");
                             CurrPage.UPDATE;
                           END;
                            }

    { 1900242701;1;Group  ;
                CaptionML=[DAN=Dimensionsfiltre;
                           ENU=Dimension Filters] }

    { 37  ;2   ;Field     ;
                Name=Dim1Filter;
                CaptionML=[DAN=Dimension 1-filter;
                           ENU=Dimension 1 Filter];
                ToolTipML=[DAN=Angiver et filter for Dimension 1, hvor posteringerne vil blive vist i matrixvinduet.;
                           ENU=Specifies a filter for the Dimension 1 for which entries will be shown in the matrix window.];
                ApplicationArea=#Suite;
                SourceExpr=Dim1Filter;
                CaptionClass=FormGetCaptionClass(1);
                Importance=Promoted;
                Visible=Dim1FilterEnable;
                Enabled=Dim1FilterEnable;
                OnValidate=BEGIN
                             SetDimFilters(1,Dim1Filter);
                           END;

                OnLookup=VAR
                           DimValue@1000 : Record 349;
                         BEGIN
                           EXIT(DimValue.LookUpDimFilter(AnalysisView."Dimension 1 Code",Text));
                         END;
                          }

    { 36  ;2   ;Field     ;
                Name=Dim2Filter;
                CaptionML=[DAN=Dimension 2-filter;
                           ENU=Dimension 2 Filter];
                ToolTipML=[DAN=Angiver et filter for Dimension 2, hvor posteringerne vil blive vist i matrixvinduet.;
                           ENU=Specifies a filter for the Dimension 2 for which entries will be shown in the matrix window.];
                ApplicationArea=#Suite;
                SourceExpr=Dim2Filter;
                CaptionClass=FormGetCaptionClass(2);
                Importance=Promoted;
                Visible=Dim2FilterEnable;
                Enabled=Dim2FilterEnable;
                OnValidate=BEGIN
                             SetDimFilters(2,Dim2Filter);
                           END;

                OnLookup=VAR
                           DimValue@1000 : Record 349;
                         BEGIN
                           EXIT(DimValue.LookUpDimFilter(AnalysisView."Dimension 2 Code",Text));
                         END;
                          }

    { 39  ;2   ;Field     ;
                Name=Dim3Filter;
                CaptionML=[DAN=Dimension 3-filter;
                           ENU=Dimension 3 Filter];
                ToolTipML=[DAN=Angiver et filter for Dimension 3, hvor posteringerne vil blive vist i matrixvinduet.;
                           ENU=Specifies a filter for the Dimension 3 for which entries will be shown in the matrix window.];
                ApplicationArea=#Suite;
                SourceExpr=Dim3Filter;
                CaptionClass=FormGetCaptionClass(3);
                Importance=Promoted;
                Visible=Dim3FilterEnable;
                Enabled=Dim3FilterEnable;
                OnValidate=BEGIN
                             SetDimFilters(3,Dim3Filter);
                           END;

                OnLookup=VAR
                           DimValue@1000 : Record 349;
                         BEGIN
                           EXIT(DimValue.LookUpDimFilter(AnalysisView."Dimension 3 Code",Text));
                         END;
                          }

    { 38  ;2   ;Field     ;
                Name=Dim4Filter;
                CaptionML=[DAN=Dimension 4-filter;
                           ENU=Dimension 4 Filter];
                ToolTipML=[DAN=Angiver et filter for Dimension 4, hvor posteringerne vil blive vist i matrixvinduet.;
                           ENU=Specifies a filter for the Dimension 4 for which entries will be shown in the matrix window.];
                ApplicationArea=#Suite;
                SourceExpr=Dim4Filter;
                CaptionClass=FormGetCaptionClass(4);
                Importance=Promoted;
                Visible=Dim4FilterEnable;
                Enabled=Dim4FilterEnable;
                OnValidate=BEGIN
                             SetDimFilters(4,Dim4Filter);
                           END;

                OnLookup=VAR
                           DimValue@1000 : Record 349;
                         BEGIN
                           EXIT(DimValue.LookUpDimFilter(AnalysisView."Dimension 4 Code",Text));
                         END;
                          }

    { 3   ;2   ;Field     ;
                Name=CostCenterFilter;
                CaptionML=[DAN=Omkostningsstedsfilter;
                           ENU=Cost Center Filter];
                ToolTipML=[DAN=Angiver et omkostningssted, som du vil have vist kontobel›b for.;
                           ENU=Specifies a cost center for which you want to view account amounts.];
                ApplicationArea=#CostAccounting;
                SourceExpr=CostCenterFilter;
                Importance=Additional;
                OnValidate=BEGIN
                             IF CostCenterFilter = '' THEN
                               SETRANGE("Cost Center Filter")
                             ELSE
                               SETFILTER("Cost Center Filter",CostCenterFilter);
                             CurrPage.UPDATE;
                           END;

                OnLookup=VAR
                           CostCenter@1000 : Record 1112;
                         BEGIN
                           EXIT(CostCenter.LookupCostCenterFilter(Text));
                         END;
                          }

    { 4   ;2   ;Field     ;
                Name=CostObjectFilter;
                CaptionML=[DAN=Omkostningsemnefilter;
                           ENU=Cost Object Filter];
                ToolTipML=[DAN=Angiver et omkostningsemne, som du vil have vist kontobel›b for.;
                           ENU=Specifies a cost object for which you want to view account amounts.];
                ApplicationArea=#CostAccounting;
                SourceExpr=CostObjectFilter;
                Importance=Additional;
                OnValidate=BEGIN
                             IF CostObjectFilter = '' THEN
                               SETRANGE("Cost Object Filter")
                             ELSE
                               SETFILTER("Cost Object Filter",CostObjectFilter);
                             CurrPage.UPDATE;
                           END;

                OnLookup=VAR
                           CostObject@1000 : Record 1113;
                         BEGIN
                           EXIT(CostObject.LookupCostObjectFilter(Text));
                         END;
                          }

    { 5   ;2   ;Field     ;
                Name=CashFlowFilter;
                CaptionML=[DAN=Pengestr›msfilter;
                           ENU=Cash Flow Filter];
                ToolTipML=[DAN=Angiver et dimensionsfilter til den pengestr›m, som du vil have vist kontobel›b for.;
                           ENU=Specifies a dimension filter for the cash flow, for which you want to view account amounts.];
                ApplicationArea=#Advanced;
                SourceExpr=CashFlowFilter;
                Importance=Additional;
                OnValidate=BEGIN
                             IF CashFlowFilter = '' THEN
                               SETRANGE("Cash Flow Forecast Filter")
                             ELSE
                               SETFILTER("Cash Flow Forecast Filter",CashFlowFilter);
                             CurrPage.UPDATE;
                           END;

                OnLookup=VAR
                           CashFlowForecast@1000 : Record 840;
                         BEGIN
                           EXIT(CashFlowForecast.LookupCashFlowFilter(Text));
                         END;
                          }

    { 6   ;2   ;Field     ;
                Name=G/LBudgetFilter;
                CaptionML=[DAN=Finansbudgetfilter;
                           ENU=G/L Budget Filter];
                ToolTipML=[DAN=Angiver en kode for et finansbudget, som denne kontoskemalinje filtreres efter.;
                           ENU=Specifies a code for a general ledger budget that the account schedule line will be filtered on.];
                ApplicationArea=#Suite;
                SourceExpr=GLBudgetFilter;
                Importance=Promoted;
                OnValidate=BEGIN
                             IF GLBudgetFilter = '' THEN
                               SETRANGE("G/L Budget Filter")
                             ELSE
                               SETFILTER("G/L Budget Filter",GLBudgetFilter);
                             CurrPage.UPDATE;
                           END;

                OnLookup=VAR
                           Result@1001 : Boolean;
                         BEGIN
                           Result := LookupGLBudgetFilter(Text);
                           IF Result THEN BEGIN
                             SETFILTER("G/L Budget Filter",Text);
                             Text := GETFILTER("G/L Budget Filter");
                           END;
                           EXIT(Result);
                         END;
                          }

    { 9   ;2   ;Field     ;
                Name=CostBudgetFilter;
                CaptionML=[DAN=Omkostningsbudgetfilter;
                           ENU=Cost Budget Filter];
                ToolTipML=[DAN=Angiver en kode for et omkostningsbudget, som denne kontoskemalinje filtreres efter.;
                           ENU=Specifies a code for a cost budget that the account schedule line will be filtered on.];
                ApplicationArea=#CostAccounting;
                SourceExpr=CostBudgetFilter;
                Importance=Additional;
                OnValidate=BEGIN
                             IF CostBudgetFilter = '' THEN
                               SETRANGE("Cost Budget Filter")
                             ELSE
                               SETFILTER("Cost Budget Filter",CostBudgetFilter);
                             CurrPage.UPDATE;
                           END;

                OnLookup=VAR
                           Result@1001 : Boolean;
                         BEGIN
                           Result := LookupCostBudgetFilter(Text);
                           IF Result THEN BEGIN
                             SETFILTER("Cost Budget Filter",Text);
                             Text := GETFILTER("Cost Budget Filter");
                           END;
                           EXIT(Result);
                         END;
                          }

    { 48  ;1   ;Group     ;
                Editable=FALSE;
                IndentationColumnName=Indentation;
                IndentationControls=Description;
                GroupType=Repeater }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et nummer, som identificerer linjen.;
                           ENU=Specifies a number that identifies the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Row No." }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tekst, der vises p† kontoskemalinjen.;
                           ENU=Specifies text that will appear on the account schedule line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Style=Strong;
                StyleExpr=Bold }

    { 53  ;2   ;Field     ;
                Name=ColumnValues1;
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=ColumnValues[1];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr(1);
                CaptionClass='3,' + ColumnCaptions[1];
                StyleExpr=ColumnStyle1;
                OnDrillDown=BEGIN
                              DrillDown(1);
                            END;
                             }

    { 59  ;2   ;Field     ;
                Name=ColumnValues2;
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=ColumnValues[2];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr(2);
                CaptionClass='3,' + ColumnCaptions[2];
                Visible=NoOfColumns >= 2;
                StyleExpr=ColumnStyle2;
                OnDrillDown=BEGIN
                              DrillDown(2);
                            END;
                             }

    { 61  ;2   ;Field     ;
                Name=ColumnValues3;
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=ColumnValues[3];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr(3);
                CaptionClass='3,' + ColumnCaptions[3];
                Visible=NoOfColumns >= 3;
                StyleExpr=ColumnStyle3;
                OnDrillDown=BEGIN
                              DrillDown(3);
                            END;
                             }

    { 63  ;2   ;Field     ;
                Name=ColumnValues4;
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=ColumnValues[4];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr(4);
                CaptionClass='3,' + ColumnCaptions[4];
                Visible=NoOfColumns >= 4;
                StyleExpr=ColumnStyle4;
                OnDrillDown=BEGIN
                              DrillDown(4);
                            END;
                             }

    { 65  ;2   ;Field     ;
                Name=ColumnValues5;
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=ColumnValues[5];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr(5);
                CaptionClass='3,' + ColumnCaptions[5];
                Visible=NoOfColumns >= 5;
                StyleExpr=ColumnStyle5;
                OnDrillDown=BEGIN
                              DrillDown(5);
                            END;
                             }

    { 81  ;2   ;Field     ;
                Name=ColumnValues6;
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=ColumnValues[6];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr(6);
                CaptionClass='3,' + ColumnCaptions[6];
                Visible=NoOfColumns >= 6;
                StyleExpr=ColumnStyle6;
                OnDrillDown=BEGIN
                              DrillDown(6);
                            END;
                             }

    { 79  ;2   ;Field     ;
                Name=ColumnValues7;
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=ColumnValues[7];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr(7);
                CaptionClass='3,' + ColumnCaptions[7];
                Visible=NoOfColumns >= 7;
                StyleExpr=ColumnStyle7;
                OnDrillDown=BEGIN
                              DrillDown(7);
                            END;
                             }

    { 77  ;2   ;Field     ;
                Name=ColumnValues8;
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=ColumnValues[8];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr(8);
                CaptionClass='3,' + ColumnCaptions[8];
                Visible=NoOfColumns >= 8;
                StyleExpr=ColumnStyle8;
                OnDrillDown=BEGIN
                              DrillDown(8);
                            END;
                             }

    { 75  ;2   ;Field     ;
                Name=ColumnValues9;
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=ColumnValues[9];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr(9);
                CaptionClass='3,' + ColumnCaptions[9];
                Visible=NoOfColumns >= 9;
                StyleExpr=ColumnStyle9;
                OnDrillDown=BEGIN
                              DrillDown(9);
                            END;
                             }

    { 73  ;2   ;Field     ;
                Name=ColumnValues10;
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=ColumnValues[10];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr(10);
                CaptionClass='3,' + ColumnCaptions[10];
                Visible=NoOfColumns >= 10;
                StyleExpr=ColumnStyle10;
                OnDrillDown=BEGIN
                              DrillDown(10);
                            END;
                             }

    { 71  ;2   ;Field     ;
                Name=ColumnValues11;
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=ColumnValues[11];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr(11);
                CaptionClass='3,' + ColumnCaptions[11];
                Visible=NoOfColumns >= 11;
                StyleExpr=ColumnStyle11;
                OnDrillDown=BEGIN
                              DrillDown(11);
                            END;
                             }

    { 69  ;2   ;Field     ;
                Name=ColumnValues12;
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=ColumnValues[12];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr(12);
                CaptionClass='3,' + ColumnCaptions[12];
                Visible=NoOfColumns >= 12;
                StyleExpr=ColumnStyle12;
                OnDrillDown=BEGIN
                              DrillDown(12);
                            END;
                             }

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=STANDARD;ENU=DEFAULT';
      Text005@1021 : TextConst 'DAN=1,6,,Dimension %1-filter;ENU=1,6,,Dimension %1 Filter';
      TempColumnLayout@1004 : TEMPORARY Record 334;
      ColumnLayoutArr@1018 : ARRAY [12] OF Record 334;
      AccSchedName@1005 : Record 84;
      AnalysisView@1020 : Record 363;
      GLSetup@1016 : Record 98;
      AccSchedManagement@1006 : Codeunit 8;
      MatrixMgt@1029 : Codeunit 9200;
      DimensionManagement@1044 : Codeunit 408;
      CurrentSchedName@1007 : Code[10];
      CurrentColumnName@1008 : Code[10];
      NewCurrentSchedName@1009 : Code[10];
      NewCurrentColumnName@1010 : Code[10];
      ColumnValues@1012 : ARRAY [12] OF Decimal;
      ColumnCaptions@1017 : ARRAY [12] OF Text[80];
      PeriodType@1013 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      UseAmtsInAddCurrVisible@1032 : Boolean;
      UseAmtsInAddCurr@1014 : Boolean;
      Dim1Filter@1019 : Text;
      Dim2Filter@1022 : Text;
      Dim3Filter@1023 : Text;
      Dim4Filter@1024 : Text;
      CostCenterFilter@1011 : Text;
      CostObjectFilter@1001 : Text;
      CashFlowFilter@1015 : Text;
      NoOfColumns@1030 : Integer;
      ColumnOffset@1025 : Integer;
      Dim1FilterEnable@19054192 : Boolean INDATASET;
      Dim2FilterEnable@19062512 : Boolean INDATASET;
      Dim3FilterEnable@19011605 : Boolean INDATASET;
      Dim4FilterEnable@19064250 : Boolean INDATASET;
      GLBudgetFilter@1026 : Text;
      CostBudgetFilter@1027 : Text;
      DateFilter@1028 : Text;
      ModifiedPeriodType@1002 : Option;
      NewPeriodTypeSet@1003 : Boolean;
      ColumnStyle1@1031 : Text INDATASET;
      ColumnStyle2@1043 : Text INDATASET;
      ColumnStyle3@1042 : Text INDATASET;
      ColumnStyle4@1041 : Text INDATASET;
      ColumnStyle5@1040 : Text INDATASET;
      ColumnStyle6@1039 : Text INDATASET;
      ColumnStyle7@1038 : Text INDATASET;
      ColumnStyle8@1037 : Text INDATASET;
      ColumnStyle9@1036 : Text INDATASET;
      ColumnStyle10@1035 : Text INDATASET;
      ColumnStyle11@1034 : Text INDATASET;
      ColumnStyle12@1033 : Text INDATASET;

    [External]
    PROCEDURE SetAccSchedName@6(NewAccSchedName@1000 : Code[10]);
    VAR
      AccSchedName@1001 : Record 84;
    BEGIN
      NewCurrentSchedName := NewAccSchedName;
      IF AccSchedName.GET(NewCurrentSchedName) THEN
        IF AccSchedName."Default Column Layout" <> '' THEN
          NewCurrentColumnName := AccSchedName."Default Column Layout";
    END;

    [External]
    PROCEDURE SetPeriodType@1(NewPeriodType@1000 : Option);
    BEGIN
      ModifiedPeriodType := NewPeriodType;
      NewPeriodTypeSet := TRUE;
    END;

    LOCAL PROCEDURE SetDimFilters@2(DimNo@1000 : Integer;DimValueFilter@1001 : Text);
    BEGIN
      CASE DimNo OF
        1:
          IF DimValueFilter = '' THEN
            SETRANGE("Dimension 1 Filter")
          ELSE BEGIN
            DimensionManagement.ResolveDimValueFilter(DimValueFilter,AnalysisView."Dimension 1 Code");
            SETFILTER("Dimension 1 Filter",DimValueFilter);
          END;
        2:
          IF DimValueFilter = '' THEN
            SETRANGE("Dimension 2 Filter")
          ELSE BEGIN
            DimensionManagement.ResolveDimValueFilter(DimValueFilter,AnalysisView."Dimension 2 Code");
            SETFILTER("Dimension 2 Filter",DimValueFilter);
          END;
        3:
          IF DimValueFilter = '' THEN
            SETRANGE("Dimension 3 Filter")
          ELSE BEGIN
            DimensionManagement.ResolveDimValueFilter(DimValueFilter,AnalysisView."Dimension 3 Code");
            SETFILTER("Dimension 3 Filter",DimValueFilter);
          END;
        4:
          IF DimValueFilter = '' THEN
            SETRANGE("Dimension 4 Filter")
          ELSE BEGIN
            DimensionManagement.ResolveDimValueFilter(DimValueFilter,AnalysisView."Dimension 4 Code");
            SETFILTER("Dimension 4 Filter",DimValueFilter);
          END;
      END;
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE FormGetCaptionClass@12(DimNo@1000 : Integer) : Text[250];
    BEGIN
      CASE DimNo OF
        1:
          BEGIN
            IF AnalysisView."Dimension 1 Code" <> '' THEN
              EXIT('1,6,' + AnalysisView."Dimension 1 Code");

            EXIT(STRSUBSTNO(Text005,DimNo));
          END;
        2:
          BEGIN
            IF AnalysisView."Dimension 2 Code" <> '' THEN
              EXIT('1,6,' + AnalysisView."Dimension 2 Code");

            EXIT(STRSUBSTNO(Text005,DimNo));
          END;
        3:
          BEGIN
            IF AnalysisView."Dimension 3 Code" <> '' THEN
              EXIT('1,6,' + AnalysisView."Dimension 3 Code");

            EXIT(STRSUBSTNO(Text005,DimNo));
          END;
        4:
          BEGIN
            IF AnalysisView."Dimension 4 Code" <> '' THEN
              EXIT('1,6,' + AnalysisView."Dimension 4 Code");

            EXIT(STRSUBSTNO(Text005,DimNo));
          END;
        5:
          EXIT(FIELDCAPTION("Date Filter"));
        6:
          EXIT(FIELDCAPTION("Cash Flow Forecast Filter"));
      END;
    END;

    LOCAL PROCEDURE DrillDown@5(ColumnNo@1003 : Integer);
    BEGIN
      TempColumnLayout := ColumnLayoutArr[ColumnNo];
      AccSchedManagement.DrillDownFromOverviewPage(TempColumnLayout,Rec,PeriodType);
    END;

    LOCAL PROCEDURE UpdateColumnCaptions@19();
    VAR
      ColumnNo@1000 : Integer;
      i@1001 : Integer;
    BEGIN
      CLEAR(ColumnCaptions);
      IF TempColumnLayout.FINDSET THEN
        REPEAT
          ColumnNo := ColumnNo + 1;
          IF (ColumnNo > ColumnOffset) AND (ColumnNo - ColumnOffset <= ARRAYLEN(ColumnCaptions)) THEN
            ColumnCaptions[ColumnNo - ColumnOffset] := TempColumnLayout."Column Header";
        UNTIL (ColumnNo - ColumnOffset = ARRAYLEN(ColumnCaptions)) OR (TempColumnLayout.NEXT = 0);
      // Set unused columns to blank to prevent RTC to display control ID as caption
      FOR i := ColumnNo - ColumnOffset + 1 TO ARRAYLEN(ColumnCaptions) DO
        ColumnCaptions[i] := ' ';
      NoOfColumns := ColumnNo;
    END;

    LOCAL PROCEDURE AdjustColumnOffset@18(Delta@1000 : Integer);
    VAR
      OldColumnOffset@1001 : Integer;
    BEGIN
      OldColumnOffset := ColumnOffset;
      ColumnOffset := ColumnOffset + Delta;
      IF ColumnOffset + 12 > TempColumnLayout.COUNT THEN
        ColumnOffset := TempColumnLayout.COUNT - 12;
      IF ColumnOffset < 0 THEN
        ColumnOffset := 0;
      IF ColumnOffset <> OldColumnOffset THEN BEGIN
        UpdateColumnCaptions;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE UpdateDimFilterControls@4();
    BEGIN
      Dim1Filter := GETFILTER("Dimension 1 Filter");
      Dim2Filter := GETFILTER("Dimension 2 Filter");
      Dim3Filter := GETFILTER("Dimension 3 Filter");
      Dim4Filter := GETFILTER("Dimension 4 Filter");
      CostCenterFilter := '';
      CostObjectFilter := '';
      CashFlowFilter := '';
      Dim1FilterEnable := AnalysisView."Dimension 1 Code" <> '';
      Dim2FilterEnable := AnalysisView."Dimension 2 Code" <> '';
      Dim3FilterEnable := AnalysisView."Dimension 3 Code" <> '';
      Dim4FilterEnable := AnalysisView."Dimension 4 Code" <> '';
      GLBudgetFilter := '';
      CostBudgetFilter := '';
    END;

    LOCAL PROCEDURE CurrentSchedNameOnAfterValidate@19053875();
    VAR
      AccSchedName@1001 : Record 84;
      PrevAnalysisView@1002 : Record 363;
    BEGIN
      CurrPage.SAVERECORD;
      AccSchedManagement.SetName(CurrentSchedName,Rec);
      IF AccSchedName.GET(CurrentSchedName) THEN
        IF (AccSchedName."Default Column Layout" <> '') AND
           (CurrentColumnName <> AccSchedName."Default Column Layout")
        THEN BEGIN
          CurrentColumnName := AccSchedName."Default Column Layout";
          AccSchedManagement.CopyColumnsToTemp(CurrentColumnName,TempColumnLayout);
          AccSchedManagement.SetColumnName(CurrentColumnName,TempColumnLayout);
        END;
      AccSchedManagement.CheckAnalysisView(CurrentSchedName,CurrentColumnName,TRUE);

      IF AccSchedName."Analysis View Name" <> AnalysisView.Code THEN BEGIN
        PrevAnalysisView := AnalysisView;
        IF AccSchedName."Analysis View Name" <> '' THEN
          AnalysisView.GET(AccSchedName."Analysis View Name")
        ELSE BEGIN
          CLEAR(AnalysisView);
          AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
          AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
        END;
        IF PrevAnalysisView."Dimension 1 Code" <> AnalysisView."Dimension 1 Code" THEN
          SETRANGE("Dimension 1 Filter");
        IF PrevAnalysisView."Dimension 2 Code" <> AnalysisView."Dimension 2 Code" THEN
          SETRANGE("Dimension 2 Filter");
        IF PrevAnalysisView."Dimension 3 Code" <> AnalysisView."Dimension 3 Code" THEN
          SETRANGE("Dimension 3 Filter");
        IF PrevAnalysisView."Dimension 4 Code" <> AnalysisView."Dimension 4 Code" THEN
          SETRANGE("Dimension 4 Filter");
      END;
      UpdateDimFilterControls;

      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE CurrentColumnNameOnAfterValidate@19064415();
    BEGIN
      AccSchedManagement.CopyColumnsToTemp(CurrentColumnName,TempColumnLayout);
      AccSchedManagement.SetColumnName(CurrentColumnName,TempColumnLayout);
      AccSchedManagement.CheckAnalysisView(CurrentSchedName,CurrentColumnName,TRUE);
      ColumnOffset := 0;
      UpdateColumnCaptions;
      CurrPage.UPDATE(FALSE);
    END;

    [Internal]
    PROCEDURE FormatStr@8(ColumnNo@1000 : Integer) : Text;
    BEGIN
      EXIT(MatrixMgt.GetFormatString(ColumnLayoutArr[ColumnNo]."Rounding Factor",UseAmtsInAddCurr));
    END;

    [External]
    PROCEDURE RoundNone@9(Value@1000 : Decimal;RoundingFactor@1002 : 'None,1,1000,1000000') : Decimal;
    BEGIN
      IF RoundingFactor <> RoundingFactor::None THEN
        EXIT(Value);

      EXIT(ROUND(Value));
    END;

    LOCAL PROCEDURE GetStyle@7(ColumnNo@1000 : Integer;RowLineNo@1001 : Integer;ColumnLineNo@1003 : Integer);
    VAR
      ColumnStyle@1005 : Text;
      ErrorType@1004 : 'None,Division by Zero,Period Error,Both';
    BEGIN
      AccSchedManagement.CalcFieldError(ErrorType,RowLineNo,ColumnLineNo);
      IF ErrorType > ErrorType::None THEN
        ColumnStyle := 'Unfavorable'
      ELSE
        IF Bold THEN
          ColumnStyle := 'Strong'
        ELSE
          ColumnStyle := 'Standard';

      CASE ColumnNo OF
        1:
          ColumnStyle1 := ColumnStyle;
        2:
          ColumnStyle2 := ColumnStyle;
        3:
          ColumnStyle3 := ColumnStyle;
        4:
          ColumnStyle4 := ColumnStyle;
        5:
          ColumnStyle5 := ColumnStyle;
        6:
          ColumnStyle6 := ColumnStyle;
        7:
          ColumnStyle7 := ColumnStyle;
        8:
          ColumnStyle8 := ColumnStyle;
        9:
          ColumnStyle9 := ColumnStyle;
        10:
          ColumnStyle10 := ColumnStyle;
        11:
          ColumnStyle11 := ColumnStyle;
        12:
          ColumnStyle12 := ColumnStyle;
      END;
    END;

    BEGIN
    END.
  }
}

