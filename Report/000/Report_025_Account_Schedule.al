OBJECT Report 25 Account Schedule
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontoskema;
               ENU=Account Schedule];
    OnPreReport=BEGIN
                  TransferValues;
                  UpdateFilters;
                  InitAccSched;
                END;

    PreviewMode=PrintLayout;
  }
  DATASET
  {
    { 2151;    ;DataItem;AccScheduleName     ;
               DataItemTable=Table84;
               DataItemTableView=SORTING(Name);
               OnPreDataItem=BEGIN
                               SETRANGE(Name,AccSchedName);

                               PageGroupNo := 1;
                               NextPageGroupNo := 1;
                             END;

               OnAfterGetRecord=BEGIN
                                  CurrReport.PAGENO := 1;
                                  GLSetup.GET;
                                  IF "Analysis View Name" <> '' THEN BEGIN
                                    AnalysisView.GET("Analysis View Name");
                                  END ELSE BEGIN
                                    AnalysisView.INIT;
                                    AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
                                    AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
                                  END;

                                  IF UseAmtsInAddCurr THEN
                                    HeaderText := STRSUBSTNO(Text003,GLSetup."Additional Reporting Currency")
                                  ELSE
                                    IF GLSetup."LCY Code" <> '' THEN
                                      HeaderText := STRSUBSTNO(Text003,GLSetup."LCY Code")
                                    ELSE
                                      HeaderText := '';
                                END;
                                 }

    { 93  ;1   ;Column  ;AccScheduleName_Name;
               SourceExpr=Name }

    { 6714;1   ;DataItem;Heading             ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=VAR
                               ColumnLayout@1001 : Record 334;
                               i@1000 : Integer;
                             BEGIN
                               ColumnLayout.SETRANGE("Column Layout Name",ColumnLayoutName);
                               IF ColumnLayout.FINDSET THEN
                                 REPEAT
                                   i += 1;
                                   ColumnHeaderArrayText[i] := ColumnLayout."Column Header";
                                 UNTIL (ColumnLayout.NEXT = 0) OR (i = ARRAYLEN(ColumnHeaderArrayText));
                             END;
                              }

    { 70  ;2   ;Column  ;ColumnLayoutName    ;
               SourceExpr=ColumnLayoutName }

    { 69  ;2   ;Column  ;FiscalStartDate     ;
               SourceExpr=FORMAT(FiscalStartDate) }

    { 66  ;2   ;Column  ;PeriodText          ;
               SourceExpr=PeriodText }

    { 67  ;2   ;Column  ;COMPANYNAME         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 1   ;2   ;Column  ;AccScheduleName_Description;
               SourceExpr=AccScheduleName.Description }

    { 110 ;2   ;Column  ;AnalysisView_Code   ;
               SourceExpr=AnalysisView.Code }

    { 112 ;2   ;Column  ;AnalysisView_Name   ;
               SourceExpr=AnalysisView.Name }

    { 2   ;2   ;Column  ;HeaderText          ;
               SourceExpr=HeaderText }

    { 10  ;2   ;Column  ;AccScheduleLineTABLECAPTION_AccSchedLineFilter;
               SourceExpr="Acc. Schedule Line".TABLECAPTION + ': ' + AccSchedLineFilter }

    { 7   ;2   ;Column  ;AccSchedLineFilter  ;
               SourceExpr=AccSchedLineFilter }

    { 73  ;2   ;Column  ;ColumnLayoutNameCaption;
               SourceExpr=ColumnLayoutNameCaptionLbl }

    { 71  ;2   ;Column  ;AccScheduleName_Name_Caption;
               SourceExpr=AccScheduleName_Name_CaptionLbl }

    { 72  ;2   ;Column  ;FiscalStartDateCaption;
               SourceExpr=FiscalStartDateCaptionLbl }

    { 74  ;2   ;Column  ;PeriodTextCaption   ;
               SourceExpr=PeriodTextCaptionLbl }

    { 64  ;2   ;Column  ;CurrReport_PAGENOCaption;
               SourceExpr=CurrReport_PAGENOCaptionLbl }

    { 65  ;2   ;Column  ;Account_ScheduleCaption;
               SourceExpr=Account_ScheduleCaptionLbl }

    { 111 ;2   ;Column  ;AnalysisView_CodeCaption;
               SourceExpr=AnalysisView_CodeCaptionLbl }

    { 3   ;2   ;Column  ;RowNoCaption        ;
               SourceExpr=RowNoCaption }

    { 23  ;2   ;Column  ;ShowRowNo           ;
               SourceExpr=ShowRowNo }

    { 16  ;2   ;Column  ;ShowRoundingHeader  ;
               SourceExpr=ShowRoundingHeader }

    { 14  ;2   ;Column  ;ColumnHeader1       ;
               SourceExpr=ColumnHeaderArrayText[1] }

    { 9   ;2   ;Column  ;ColumnHeader2       ;
               SourceExpr=ColumnHeaderArrayText[2] }

    { 6   ;2   ;Column  ;ColumnHeader3       ;
               SourceExpr=ColumnHeaderArrayText[3] }

    { 5   ;2   ;Column  ;ColumnHeader4       ;
               SourceExpr=ColumnHeaderArrayText[4] }

    { 4   ;2   ;Column  ;ColumnHeader5       ;
               SourceExpr=ColumnHeaderArrayText[5] }

    { 7769;2   ;DataItem;                    ;
               DataItemTable=Table85;
               DataItemTableView=SORTING(Schedule Name,Line No.);
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               PageGroupNo := NextPageGroupNo;

                               SETFILTER("Date Filter",DateFilter);
                               SETFILTER("G/L Budget Filter",GLBudgetFilter);
                               SETFILTER("Cost Budget Filter",CostBudgetFilter);
                               SETFILTER("Business Unit Filter",BusinessUnitFilter);
                               SETFILTER("Dimension 1 Filter",Dim1Filter);
                               SETFILTER("Dimension 2 Filter",Dim2Filter);
                               SETFILTER("Dimension 3 Filter",Dim3Filter);
                               SETFILTER("Dimension 4 Filter",Dim4Filter);
                               SETFILTER("Cost Center Filter",CostCenterFilter);
                               SETFILTER("Cost Object Filter",CostObjectFilter);
                               SETFILTER("Cash Flow Forecast Filter",CashFlowFilter);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF (Show = Show::No) OR NOT ShowLine(Bold,Italic) THEN
                                    CurrReport.SKIP;

                                  PadChar := 160; // whitespace
                                  PadString[1] := PadChar;
                                  Bold_control := Bold;
                                  Italic_control := Italic;
                                  Underline_control := Underline;
                                  DoubleUnderline_control := "Double Underline";
                                  PageGroupNo := NextPageGroupNo;
                                  IF "New Page" THEN
                                    NextPageGroupNo := PageGroupNo + 1;

                                  LineShadowed := ShowAlternatingShading AND NOT LineShadowed;

                                  IF NOT ShowRowNo THEN
                                    "Row No." := '';
                                END;

               DataItemLinkReference=AccScheduleName;
               DataItemLink=Schedule Name=FIELD(Name) }

    { 18  ;3   ;Column  ;NextPageGroupNo     ;
               OptionCaptionML=[DAN=Ingen,Division med nul,Periodefejl,Begge;
                                ENU=None,Division by Zero,Period Error,Both];
               SourceExpr=NextPageGroupNo }

    { 30  ;3   ;Column  ;Acc__Schedule_Line_Description;
               SourceExpr=PADSTR('',Indentation * 2,PadString) + Description }

    { 29  ;3   ;Column  ;Acc__Schedule_Line__Row_No;
               SourceExpr="Row No." }

    { 12  ;3   ;Column  ;Acc__Schedule_Line_Line_No;
               SourceExpr="Line No." }

    { 28  ;3   ;Column  ;Bold_control        ;
               SourceExpr=Bold_control }

    { 27  ;3   ;Column  ;Italic_control      ;
               SourceExpr=Italic_control }

    { 20  ;3   ;Column  ;Underline_control   ;
               SourceExpr=Underline_control }

    { 22  ;3   ;Column  ;DoubleUnderline_control;
               SourceExpr=DoubleUnderline_control }

    { 13  ;3   ;Column  ;LineShadowed        ;
               SourceExpr=LineShadowed }

    { 19  ;3   ;Column  ;LineSkipped         ;
               SourceExpr=LineSkipped }

    { 5937;3   ;DataItem;                    ;
               DataItemTable=Table334;
               DataItemTableView=SORTING(Column Layout Name,Line No.);
               OnPreDataItem=BEGIN
                               SETRANGE("Column Layout Name",ColumnLayoutName);
                               LineSkipped := TRUE;
                               ColumnValuesArrayIndex := 0;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Show = Show::Never THEN
                                    CurrReport.SKIP;

                                  Header := "Column Header";
                                  RoundingHeader := '';

                                  IF "Rounding Factor" IN ["Rounding Factor"::"1000","Rounding Factor"::"1000000"] THEN
                                    CASE "Rounding Factor" OF
                                      "Rounding Factor"::"1000":
                                        RoundingHeader := Text000;
                                      "Rounding Factor"::"1000000":
                                        RoundingHeader := Text001;
                                    END;

                                  ColumnValuesAsText := CalcColumnValueAsText("Acc. Schedule Line","Column Layout");

                                  ColumnValuesArrayIndex += 1;
                                  IF ColumnValuesArrayIndex <= ARRAYLEN(ColumnValuesArrayText) THEN
                                    ColumnValuesArrayText[ColumnValuesArrayIndex] := ColumnValuesAsText;

                                  IF (ColumnValuesAsText <> '') OR ("Acc. Schedule Line".Show = "Acc. Schedule Line".Show::Yes) THEN
                                    LineSkipped := FALSE;
                                END;
                                 }

    { 15  ;4   ;Column  ;ColumnNo            ;
               SourceExpr="Column No." }

    { 11  ;4   ;Column  ;Header              ;
               SourceExpr=Header }

    { 17  ;4   ;Column  ;RoundingHeader      ;
               SourceExpr=RoundingHeader;
               AutoCalcField=No }

    { 43  ;4   ;Column  ;ColumnValuesAsText  ;
               SourceExpr=ColumnValuesAsText;
               AutoCalcField=No }

    { 21  ;4   ;Column  ;LineNo_ColumnLayout ;
               SourceExpr="Line No." }

    { 34  ;3   ;DataItem;FixedColumns        ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 33  ;4   ;Column  ;ColumnValue1        ;
               SourceExpr=ColumnValuesArrayText[1] }

    { 32  ;4   ;Column  ;ColumnValue2        ;
               SourceExpr=ColumnValuesArrayText[2] }

    { 31  ;4   ;Column  ;ColumnValue3        ;
               SourceExpr=ColumnValuesArrayText[3] }

    { 26  ;4   ;Column  ;ColumnValue4        ;
               SourceExpr=ColumnValuesArrayText[4] }

    { 25  ;4   ;Column  ;ColumnValue5        ;
               SourceExpr=ColumnValuesArrayText[5] }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnInit=BEGIN
               Dim4FilterEnable := TRUE;
               Dim3FilterEnable := TRUE;
               Dim2FilterEnable := TRUE;
               Dim1FilterEnable := TRUE;
               AccSchedNameEditable := TRUE;
             END;

      OnOpenPage=BEGIN
                   GLSetup.GET;
                   TransferValues;
                   IF AccSchedName <> '' THEN
                     IF (ColumnLayoutName = '') OR NOT AccSchedNameEditable THEN
                       ValidateAccSchedName;
                   SetBudgetFilterEnable;
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 28  ;2   ;Group     ;
                  CaptionML=[DAN=Layout;
                             ENU=Layout];
                  Visible=AccSchedNameEditable;
                  GroupType=Group }

      { 3   ;3   ;Field     ;
                  Name=AccSchedNam;
                  Lookup=Yes;
                  CaptionML=[DAN=Kontoskemanavn;
                             ENU=Acc. Schedule Name];
                  ToolTipML=[DAN=Angiver navnet p† kontoskemaet.;
                             ENU=Specifies the name of the account schedule.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=AccSchedName;
                  TableRelation="Acc. Schedule Name";
                  Importance=Promoted;
                  Editable=AccSchedNameEditable;
                  OnValidate=BEGIN
                               ValidateAccSchedName;
                               AccSchedNameHidden := '';
                               SetBudgetFilterEnable;
                               RequestOptionsPage.UPDATE(FALSE);
                             END;

                  OnLookup=BEGIN
                             EXIT(AccSchedManagement.LookupName(AccSchedName,Text));
                           END;

                  ShowMandatory=TRUE }

      { 2   ;3   ;Field     ;
                  Name=ColumnLayoutNames;
                  Lookup=Yes;
                  CaptionML=[DAN=Kolonneformatnavn;
                             ENU=Column Layout Name];
                  ToolTipML=[DAN=Angiver navnet p† det kolonneformat der bruges til rapporten.;
                             ENU=Specifies the name of the column layout that is used for the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ColumnLayoutName;
                  TableRelation="Column Layout Name".Name;
                  Importance=Promoted;
                  Editable=AccSchedNameEditable;
                  OnValidate=BEGIN
                               IF ColumnLayoutName = '' THEN
                                 ERROR(Text006);
                               AccSchedManagement.CheckColumnName(ColumnLayoutName);
                               SetBudgetFilterEnable;
                               ColumnLayoutNameHidden := '';
                               RequestOptionsPage.UPDATE;
                             END;

                  OnLookup=BEGIN
                             IF NOT AccSchedManagement.LookupColumnName(ColumnLayoutName,Text) THEN
                               EXIT(FALSE);
                             SetBudgetFilterEnable;
                             RequestOptionsPage.UPDATE;
                             EXIT(TRUE);
                           END;

                  ShowMandatory=TRUE }

      { 27  ;2   ;Group     ;
                  CaptionML=[DAN=Filtre;
                             ENU=Filters] }

      { 7   ;3   ;Field     ;
                  Name=StartDate;
                  CaptionML=[DAN=Startdato;
                             ENU=Starting Date];
                  ToolTipML=[DAN=Angiver den dato, som rapporten eller k›rslen behandler oplysninger fra.;
                             ENU=Specifies the date from which the report or batch job processes information.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=StartDate;
                  Enabled=StartDateEnabled;
                  OnValidate=BEGIN
                               ValidateStartEndDate;
                             END;

                  ShowMandatory=TRUE }

      { 12  ;3   ;Field     ;
                  Name=EndDate;
                  CaptionML=[DAN=Slutdato;
                             ENU=Ending Date];
                  ToolTipML=[DAN=Angiver den dato, som rapporten eller k›rslen behandler oplysninger frem til.;
                             ENU=Specifies the date to which the report or batch job processes information.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=EndDate;
                  OnValidate=BEGIN
                               ValidateStartEndDate;
                             END;

                  ShowMandatory=TRUE }

      { 13  ;3   ;Field     ;
                  Name=GLBudgetFilter;
                  Width=10;
                  CaptionML=[DAN=Fin.budget;
                             ENU=G/L Budget];
                  ToolTipML=[DAN=Angiver et finanskontobudgetfilter til rapporten.;
                             ENU=Specifies a general ledger budget filter for the report.];
                  ApplicationArea=#Suite;
                  SourceExpr=GLBudgetName;
                  TableRelation="G/L Budget Name".Name;
                  Enabled=BudgetFilterEnable;
                  OnValidate=BEGIN
                               GLBudgetFilter := GLBudgetName;
                               "Acc. Schedule Line".SETRANGE("G/L Budget Filter",GLBudgetFilter);
                               GLBudgetFilter := "Acc. Schedule Line".GETFILTER("G/L Budget Filter");
                             END;

                  ShowMandatory=BudgetFilterEnable }

      { 9   ;3   ;Field     ;
                  Name=CostBudgetFilter;
                  CaptionML=[DAN=Omkostningsbudgetfilter;
                             ENU=Cost Budget Filter];
                  ToolTipML=[DAN=Angiver en kode for et omkostningsbudget, som denne kontoskemalinje filtreres efter.;
                             ENU=Specifies a code for a cost budget that the account schedule line will be filtered on.];
                  ApplicationArea=#CostAccounting;
                  SourceExpr=CostBudgetFilter;
                  TableRelation="Cost Budget Name".Name;
                  Importance=Additional;
                  Enabled=BudgetFilterEnable;
                  OnValidate=BEGIN
                               "Acc. Schedule Line".SETFILTER("Cost Budget Filter",CostBudgetFilter);
                               CostBudgetFilter := "Acc. Schedule Line".GETFILTER("Cost Budget Filter");
                             END;
                              }

      { 23  ;3   ;Field     ;
                  Name=BusinessUnitFilter;
                  CaptionML=[DAN=Koncernvirk.filter;
                             ENU=Business Unit Filter];
                  ToolTipML=[DAN=Angiver koncernvirksomhedsfilteret for kontoskemaet.;
                             ENU=Specifies the business unit filter for the account schedule.];
                  ApplicationArea=#Advanced;
                  SourceExpr=BusinessUnitFilter;
                  TableRelation="Business Unit";
                  Importance=Additional;
                  Visible=BusinessUnitFilterVisible;
                  LookupPageID=Business Unit List;
                  OnValidate=BEGIN
                               "Acc. Schedule Line".SETFILTER("Business Unit Filter",BusinessUnitFilter);
                               BusinessUnitFilter := "Acc. Schedule Line".GETFILTER("Business Unit Filter");
                             END;
                              }

      { 26  ;2   ;Group     ;
                  CaptionML=[DAN=Dimensionsfiltre;
                             ENU=Dimension Filters] }

      { 15  ;3   ;Field     ;
                  Name=Dim1Filter;
                  CaptionML=[DAN=Dimension 1-filter;
                             ENU=Dimension 1 Filter];
                  ToolTipML=[DAN=Angiver et filter til dimensionsv‘rdier i en dimension. Filteret bruger den dimension, du har defineret som Dimension 1 til at vise den analysevisning, der er valgt i feltet Analysevisningskode.;
                             ENU=Specifies a filter for dimension values within a dimension. The filter uses the dimension you have defined as dimension 1 for the analysis view selected in the Analysis View Code field.];
                  ApplicationArea=#Suite;
                  SourceExpr=Dim1Filter;
                  CaptionClass=FormGetCaptionClass(1);
                  Importance=Additional;
                  Visible=Dim1FilterEnable;
                  OnLookup=BEGIN
                             EXIT(FormLookUpDimFilter(AnalysisView."Dimension 1 Code",Text));
                           END;
                            }

      { 17  ;3   ;Field     ;
                  Name=Dim2Filter;
                  CaptionML=[DAN=Dimension 2-filter;
                             ENU=Dimension 2 Filter];
                  ToolTipML=[DAN=Angiver et filter til dimensionsv‘rdier i en dimension. Filteret bruger den dimension, du har defineret som Dimension 2 til at vise den analysevisning, der er valgt i feltet Analysevisningskode.;
                             ENU=Specifies a filter for dimension values within a dimension. The filter uses the dimension you have defined as dimension 2 for the analysis view selected in the Analysis View Code field.];
                  ApplicationArea=#Suite;
                  SourceExpr=Dim2Filter;
                  CaptionClass=FormGetCaptionClass(2);
                  Importance=Additional;
                  Visible=Dim2FilterEnable;
                  OnLookup=BEGIN
                             EXIT(FormLookUpDimFilter(AnalysisView."Dimension 2 Code",Text));
                           END;
                            }

      { 21  ;3   ;Field     ;
                  Name=Dim3Filter;
                  CaptionML=[DAN=Dimension 3-filter;
                             ENU=Dimension 3 Filter];
                  ToolTipML=[DAN=Angiver et filter til dimensionsv‘rdier i en dimension. Filteret bruger den dimension, du har defineret som Dimension 3 til at vise den analysevisning, der er valgt i feltet Analysevisningskode.;
                             ENU=Specifies a filter for dimension values within a dimension. The filter uses the dimension you have defined as dimension 3 for the analysis view selected in the Analysis View Code field.];
                  ApplicationArea=#Suite;
                  SourceExpr=Dim3Filter;
                  CaptionClass=FormGetCaptionClass(3);
                  Importance=Additional;
                  Visible=Dim3FilterEnable;
                  OnLookup=BEGIN
                             EXIT(FormLookUpDimFilter(AnalysisView."Dimension 3 Code",Text));
                           END;
                            }

      { 19  ;3   ;Field     ;
                  Name=Dim4Filter;
                  CaptionML=[DAN=Dimension 4-filter;
                             ENU=Dimension 4 Filter];
                  ToolTipML=[DAN=Angiver et filter til dimensionsv‘rdier i en dimension. Filteret bruger den dimension, du har defineret som Dimension 4 til at vise den analysevisning, der er valgt i feltet Analysevisningskode.;
                             ENU=Specifies a filter for dimension values within a dimension. The filter uses the dimension you have defined as dimension 4 for the analysis view selected in the Analysis View Code field.];
                  ApplicationArea=#Suite;
                  SourceExpr=Dim4Filter;
                  CaptionClass=FormGetCaptionClass(4);
                  Importance=Additional;
                  Visible=Dim4FilterEnable;
                  OnLookup=BEGIN
                             EXIT(FormLookUpDimFilter(AnalysisView."Dimension 4 Code",Text));
                           END;
                            }

      { 1   ;3   ;Field     ;
                  CaptionML=[DAN=Omkostningsstedsfilter;
                             ENU=Cost Center Filter];
                  ToolTipML=[DAN="Angiver et omkostningsstedsfilter for dimensionsv‘rdierne inden for en dimension. Filteret bruger den dimension, du har defineret som Dimension 1 for den analysevisning, der er valgt i feltet Analysevisningskode. Hvis du ikke har defineret en Dimension 1 for en analysevisning, er dette felt deaktiveret. ";
                             ENU="Specifies a cost center filter for dimension values within a dimension. The filter uses the dimension you have defined as Dimension 1 for the Analysis View selected in the Analysis View Code field. If you have not defined a Dimension 1 for an analysis view, this field will be disabled. "];
                  ApplicationArea=#CostAccounting;
                  SourceExpr=CostCenterFilter;
                  Importance=Additional;
                  OnLookup=VAR
                             CostCenter@1002 : Record 1112;
                           BEGIN
                             EXIT(CostCenter.LookupCostCenterFilter(Text));
                           END;
                            }

      { 6   ;3   ;Field     ;
                  CaptionML=[DAN=Omkostningsemnefilter;
                             ENU=Cost Object Filter];
                  ToolTipML=[DAN=Angiver det g‘ldende omkostningsemnefilter.;
                             ENU=Specifies the cost object filter that applies.];
                  ApplicationArea=#CostAccounting;
                  SourceExpr=CostObjectFilter;
                  Importance=Additional;
                  OnLookup=VAR
                             CostObject@1002 : Record 1113;
                           BEGIN
                             EXIT(CostObject.LookupCostObjectFilter(Text));
                           END;
                            }

      { 8   ;3   ;Field     ;
                  CaptionML=[DAN=Pengestr›msfilter;
                             ENU=Cash Flow Filter];
                  ToolTipML=[DAN=Angiver et pengestr›msfilter for planen.;
                             ENU=Specifies a cash flow filter for the schedule.];
                  ApplicationArea=#Advanced;
                  SourceExpr=CashFlowFilter;
                  Importance=Additional;
                  OnLookup=VAR
                             CashFlowForecast@1000 : Record 840;
                           BEGIN
                             EXIT(CashFlowForecast.LookupCashFlowFilter(Text));
                           END;
                            }

      { 25  ;2   ;Group     ;
                  CaptionML=[DAN=Vis;
                             ENU=Show] }

      { 4   ;3   ;Field     ;
                  CaptionML=[DAN=Vis fejl;
                             ENU=Show Error];
                  ToolTipML=[DAN=Angiver, om rapporten viser fejloplysninger.;
                             ENU=Specifies if the report shows error information.];
                  OptionCaptionML=[DAN=Ingen,Division med nul,Periodefejl,Begge;
                                   ENU=None,Division by Zero,Period Error,Both];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ShowError;
                  Importance=Additional }

      { 5   ;3   ;Field     ;
                  CaptionML=[DAN=Vis bel›b i ekstra rapporteringsvaluta;
                             ENU=Show Amounts in Add. Reporting Currency];
                  ToolTipML=[DAN=Angiver, om de rapporterede bel›b vises i den ekstra rapporteringsvaluta.;
                             ENU=Specifies if the reported amounts are shown in the additional reporting currency.];
                  ApplicationArea=#Suite;
                  SourceExpr=UseAmtsInAddCurr;
                  Importance=Additional;
                  Visible=UseAmtsInAddCurrVisible;
                  MultiLine=Yes }

      { 10  ;3   ;Field     ;
                  CaptionML=[DAN=Vis r‘kkenummer;
                             ENU=Show Row No.];
                  ToolTipML=[DAN=Angiver, om rapporten viser r‘kkenumre.;
                             ENU=Specifies if the report shows row numbers.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ShowRowNo;
                  Importance=Additional }

      { 11  ;3   ;Field     ;
                  CaptionML=[DAN=Udskriv skiftende farvning;
                             ENU=Print Alternating Shading];
                  ToolTipML=[DAN=Angiver, om hver anden r‘kke i rapporten skal v‘re skyggelagt.;
                             ENU=Specifies if you want every second row in the report to be shaded.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ShowAlternatingShading;
                  Importance=Additional }

    }
  }
  LABELS
  {
    { 8   ;AccSchedLineSpec_DescriptionCaptionLbl;
                                CaptionML=[DAN=Beskrivelse;
                                           ENU=Description] }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=(Tusinde);ENU=(Thousands)';
      Text001@1001 : TextConst 'DAN=(Millioner);ENU=(Millions)';
      Text002@1002 : TextConst 'DAN=* FEJL *;ENU=* ERROR *';
      Text003@1003 : TextConst 'DAN=Alle bel›b er i %1.;ENU=All amounts are in %1.';
      AnalysisView@1005 : Record 363;
      GLSetup@1006 : Record 98;
      AccSchedManagement@1007 : Codeunit 8;
      AccSchedName@1028 : Code[10];
      AccSchedNameHidden@1038 : Code[10];
      ColumnLayoutName@1008 : Code[10];
      ColumnLayoutNameHidden@1009 : Code[10];
      GLBudgetName@1020 : Code[10];
      StartDateEnabled@1066 : Boolean INDATASET;
      StartDate@1062 : Date;
      EndDate@1011 : Date;
      ShowError@1027 : 'None,Division by Zero,Period Error,Both';
      ShowAlternatingShading@1063 : Boolean;
      ShowRoundingHeader@1068 : Boolean;
      DateFilter@1030 : Text;
      UseHiddenFilters@1045 : Boolean;
      DateFilterHidden@1029 : Text;
      GLBudgetFilter@1031 : Text;
      GLBudgetFilterHidden@1039 : Text;
      CostBudgetFilter@1060 : Text;
      CostBudgetFilterHidden@1053 : Text;
      BusinessUnitFilter@1040 : Text;
      BusinessUnitFilterHidden@1033 : Text;
      Dim1Filter@1034 : Text;
      Dim1FilterHidden@1041 : Text;
      Dim2Filter@1035 : Text;
      Dim2FilterHidden@1042 : Text;
      Dim3Filter@1037 : Text;
      Dim3FilterHidden@1043 : Text;
      Dim4Filter@1036 : Text;
      Dim4FilterHidden@1044 : Text;
      CostCenterFilter@1058 : Text;
      CostObjectFilter@1059 : Text;
      CashFlowFilter@1052 : Text;
      FiscalStartDate@1013 : Date;
      ColumnHeaderArrayText@1025 : ARRAY [5] OF Text[30];
      ColumnValuesArrayText@1023 : ARRAY [5] OF Text[30];
      ColumnValuesArrayIndex@1048 : Integer;
      ColumnValuesDisplayed@1014 : Decimal;
      ColumnValuesAsText@1015 : Text[30];
      PeriodText@1016 : Text;
      AccSchedLineFilter@1017 : Text;
      Header@1018 : Text[50];
      RoundingHeader@1019 : Text[30];
      BusinessUnitFilterVisible@1065 : Boolean INDATASET;
      BudgetFilterEnable@1064 : Boolean INDATASET;
      UseAmtsInAddCurrVisible@1061 : Boolean INDATASET;
      UseAmtsInAddCurr@1024 : Boolean;
      ShowRowNo@1022 : Boolean;
      RowNoCaption@1067 : Text;
      HeaderText@1026 : Text[100];
      Text004@1012 : TextConst 'DAN=Ikke tilg‘ngelig;ENU=Not Available';
      Text005@1032 : TextConst 'DAN=1,6,,Dimension %1-filter;ENU=1,6,,Dimension %1 Filter';
      Bold_control@1046 : Boolean;
      Italic_control@1047 : Boolean;
      Underline_control@1049 : Boolean;
      DoubleUnderline_control@1021 : Boolean;
      PageGroupNo@1054 : Integer;
      NextPageGroupNo@1055 : Integer;
      Text006@1057 : TextConst 'DAN=Angiv kolonneformatnavnet.;ENU=Enter the Column Layout Name.';
      Dim1FilterEnable@19054192 : Boolean INDATASET;
      Dim2FilterEnable@19062512 : Boolean INDATASET;
      Dim3FilterEnable@19011605 : Boolean INDATASET;
      Dim4FilterEnable@19064250 : Boolean INDATASET;
      AccSchedNameEditable@1056 : Boolean INDATASET;
      LineShadowed@1010 : Boolean;
      LineSkipped@1004 : Boolean;
      ColumnLayoutNameCaptionLbl@8461 : TextConst 'DAN=Kolonneformat;ENU=Column Layout';
      AccScheduleName_Name_CaptionLbl@3916 : TextConst 'DAN=Kontoskema;ENU=Account Schedule';
      FiscalStartDateCaptionLbl@9008 : TextConst 'DAN=Regnskabs†rsstartdato;ENU=Fiscal Start Date';
      PeriodTextCaptionLbl@1984 : TextConst 'DAN=Periode;ENU=Period';
      PeriodEndingTextCaptionLbl@1069 : TextConst 'DAN=Periodeslut;ENU=Period Ending';
      CurrReport_PAGENOCaptionLbl@8565 : TextConst 'DAN=Side;ENU=Page';
      Account_ScheduleCaptionLbl@2350 : TextConst 'DAN=Kontoskema;ENU=Account Schedule';
      AnalysisView_CodeCaptionLbl@1996 : TextConst 'DAN=Analysevisning;ENU=Analysis View';
      PadChar@1050 : Char;
      PadString@1051 : Text;

    LOCAL PROCEDURE CalcColumnValueAsText@8(VAR AccScheduleLine@1000 : Record 85;VAR ColumnLayout@1001 : Record 334) : Text[30];
    VAR
      ColumnValuesAsText@1002 : Text[30];
    BEGIN
      ColumnValuesAsText := '';

      ColumnValuesDisplayed := AccSchedManagement.CalcCell(AccScheduleLine,ColumnLayout,UseAmtsInAddCurr);
      IF AccSchedManagement.GetDivisionError THEN BEGIN
        IF ShowError IN [ShowError::"Division by Zero",ShowError::Both] THEN
          ColumnValuesAsText := Text002;
      END ELSE
        IF AccSchedManagement.GetPeriodError THEN BEGIN
          IF ShowError IN [ShowError::"Period Error",ShowError::Both] THEN
            ColumnValuesAsText := Text004;
        END ELSE BEGIN
          ColumnValuesAsText :=
            AccSchedManagement.FormatCellAsText(ColumnLayout,ColumnValuesDisplayed,UseAmtsInAddCurr);

          IF AccScheduleLine."Totaling Type" = AccScheduleLine."Totaling Type"::Formula THEN
            CASE AccScheduleLine.Show OF
              AccScheduleLine.Show::"When Positive Balance":
                IF ColumnValuesDisplayed < 0 THEN
                  ColumnValuesAsText := '';
              AccScheduleLine.Show::"When Negative Balance":
                IF ColumnValuesDisplayed > 0 THEN
                  ColumnValuesAsText := '';
              AccScheduleLine.Show::"If Any Column Not Zero":
                IF ColumnValuesDisplayed = 0 THEN
                  ColumnValuesAsText := '';
            END;
        END;
      EXIT(ColumnValuesAsText);
    END;

    PROCEDURE InitAccSched@10();
    VAR
      ColumnLayout@1000 : Record 334;
      AccScheduleLine@1001 : Record 85;
    BEGIN
      AccScheduleName.SETRANGE(Name,AccSchedName);
      "Acc. Schedule Line".SETFILTER("Date Filter",DateFilter);
      "Acc. Schedule Line".SETFILTER("G/L Budget Filter",GLBudgetFilter);
      "Acc. Schedule Line".SETFILTER("Cost Budget Filter",CostBudgetFilter);
      "Acc. Schedule Line".SETFILTER("Business Unit Filter",BusinessUnitFilter);
      "Acc. Schedule Line".SETFILTER("Dimension 1 Filter",Dim1Filter);
      "Acc. Schedule Line".SETFILTER("Dimension 2 Filter",Dim2Filter);
      "Acc. Schedule Line".SETFILTER("Dimension 3 Filter",Dim3Filter);
      "Acc. Schedule Line".SETFILTER("Dimension 4 Filter",Dim4Filter);
      "Acc. Schedule Line".SETFILTER("Cost Center Filter",CostCenterFilter);
      "Acc. Schedule Line".SETFILTER("Cost Object Filter",CostObjectFilter);
      "Acc. Schedule Line".SETFILTER("Cash Flow Forecast Filter",CashFlowFilter);

      IF "Acc. Schedule Line".GETFILTER("Date Filter") <> '' THEN
        EndDate := "Acc. Schedule Line".GETRANGEMAX("Date Filter");
      FiscalStartDate := AccSchedManagement.FindFiscalYear(EndDate);

      AccScheduleLine.COPYFILTERS("Acc. Schedule Line");
      AccScheduleLine.SETRANGE("Date Filter");
      AccSchedLineFilter := AccScheduleLine.GETFILTERS;

      IF StartDateEnabled THEN
        PeriodText := PeriodTextCaptionLbl + ': ' + "Acc. Schedule Line".GETFILTER("Date Filter")
      ELSE
        PeriodText := PeriodEndingTextCaptionLbl + ' ' + FORMAT(EndDate);

      IF ShowRowNo THEN
        RowNoCaption := "Acc. Schedule Line".FIELDCAPTION("Row No.");

      ColumnLayout.SETRANGE("Column Layout Name",ColumnLayoutName);
      ColumnLayout.SETFILTER("Rounding Factor",'<>%1&<>%2',ColumnLayout."Rounding Factor"::None,ColumnLayout."Rounding Factor"::"1");
      ShowRoundingHeader := NOT ColumnLayout.ISEMPTY;
    END;

    PROCEDURE SetAccSchedName@6(NewAccSchedName@1000 : Code[10]);
    BEGIN
      AccSchedNameHidden := NewAccSchedName;
      AccSchedNameEditable := TRUE;
    END;

    PROCEDURE SetAccSchedNameNonEditable@16(NewAccSchedName@1000 : Code[10]);
    BEGIN
      SetAccSchedName(NewAccSchedName);
      AccSchedNameEditable := FALSE;
    END;

    PROCEDURE SetColumnLayoutName@1(ColLayoutName@1000 : Code[10]);
    BEGIN
      ColumnLayoutNameHidden := ColLayoutName;
    END;

    PROCEDURE SetFilters@4(NewDateFilter@1000 : Text;NewBudgetFilter@1001 : Text;NewCostBudgetFilter@1007 : Text;NewBusUnitFilter@1002 : Text;NewDim1Filter@1003 : Text;NewDim2Filter@1004 : Text;NewDim3Filter@1005 : Text;NewDim4Filter@1006 : Text);
    BEGIN
      DateFilterHidden := NewDateFilter;
      GLBudgetFilterHidden := NewBudgetFilter;
      CostBudgetFilterHidden := NewCostBudgetFilter;
      BusinessUnitFilterHidden := NewBusUnitFilter;
      Dim1FilterHidden := NewDim1Filter;
      Dim2FilterHidden := NewDim2Filter;
      Dim3FilterHidden := NewDim3Filter;
      Dim4FilterHidden := NewDim4Filter;
      UseHiddenFilters := TRUE;
    END;

    PROCEDURE ShowLine@3(Bold@1000 : Boolean;Italic@1001 : Boolean) : Boolean;
    BEGIN
      IF "Acc. Schedule Line"."Totaling Type" = "Acc. Schedule Line"."Totaling Type"::"Set Base For Percent" THEN
        EXIT(FALSE);
      IF "Acc. Schedule Line".Show = "Acc. Schedule Line".Show::No THEN
        EXIT(FALSE);
      IF "Acc. Schedule Line".Bold <> Bold THEN
        EXIT(FALSE);
      IF "Acc. Schedule Line".Italic <> Italic THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE FormLookUpDimFilter@57(Dim@1000 : Code[20];VAR Text@1001 : Text[1024]) : Boolean;
    VAR
      DimVal@1002 : Record 349;
      DimValList@1003 : Page 560;
    BEGIN
      IF Dim = '' THEN
        EXIT(FALSE);
      DimValList.LOOKUPMODE(TRUE);
      DimVal.SETRANGE("Dimension Code",Dim);
      DimValList.SETTABLEVIEW(DimVal);
      IF DimValList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        DimValList.GETRECORD(DimVal);
        Text := DimValList.GetSelectionFilter;
        EXIT(TRUE);
      END;
      EXIT(FALSE)
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
      END;
    END;

    LOCAL PROCEDURE TransferValues@5();
    VAR
      ColumnLayoutName2@1000 : Record 333;
      BusinessUnit@1001 : Record 220;
    BEGIN
      IF GLBudgetName <> '' THEN
        GLBudgetFilter := GLBudgetName;
      GLSetup.GET;
      UseAmtsInAddCurrVisible := GLSetup."Additional Reporting Currency" <> '';
      BusinessUnitFilterVisible := NOT BusinessUnit.ISEMPTY;
      IF NOT UseAmtsInAddCurrVisible THEN
        UseAmtsInAddCurr := FALSE;
      IF AccSchedNameHidden <> '' THEN
        AccSchedName := AccSchedNameHidden;
      IF ColumnLayoutNameHidden <> '' THEN
        ColumnLayoutName := ColumnLayoutNameHidden;
      IF DateFilterHidden <> '' THEN
        DateFilter := DateFilterHidden;
      IF GLBudgetFilterHidden <> '' THEN
        GLBudgetFilter := GLBudgetFilterHidden;
      IF CostBudgetFilterHidden <> '' THEN
        CostBudgetFilter := CostBudgetFilterHidden;
      IF BusinessUnitFilterHidden <> '' THEN
        BusinessUnitFilter := BusinessUnitFilterHidden;
      IF Dim1FilterHidden <> '' THEN
        Dim1Filter := Dim1FilterHidden;
      IF Dim2FilterHidden <> '' THEN
        Dim2Filter := Dim2FilterHidden;
      IF Dim3FilterHidden <> '' THEN
        Dim3Filter := Dim3FilterHidden;
      IF Dim4FilterHidden <> '' THEN
        Dim4Filter := Dim4FilterHidden;

      IF AccSchedName <> '' THEN
        IF NOT AccScheduleName.GET(AccSchedName) THEN
          AccSchedName := '';
      IF AccSchedName = '' THEN
        IF AccScheduleName.FINDFIRST THEN
          AccSchedName := AccScheduleName.Name;

      IF NOT ColumnLayoutName2.GET(ColumnLayoutName) THEN
        ColumnLayoutName := AccScheduleName."Default Column Layout";

      IF AccScheduleName."Analysis View Name" <> '' THEN
        AnalysisView.GET(AccScheduleName."Analysis View Name")
      ELSE BEGIN
        AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
        AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
      END;
    END;

    LOCAL PROCEDURE UpdateFilters@7();
    BEGIN
      IF UseHiddenFilters THEN BEGIN
        DateFilter := DateFilterHidden;
        GLBudgetFilter := GLBudgetFilterHidden;
        CostBudgetFilter := CostBudgetFilterHidden;
        BusinessUnitFilter := BusinessUnitFilterHidden;
        Dim1Filter := Dim1FilterHidden;
        Dim2Filter := Dim2FilterHidden;
        Dim3Filter := Dim3FilterHidden;
        Dim4Filter := Dim4FilterHidden;
      END ELSE BEGIN
        IF EndDate = 0D THEN
          EndDate := WORKDATE;
        IF StartDate = 0D THEN
          StartDate := CALCDATE('<CM-1M+1D>',EndDate);
        ValidateStartEndDate;
      END;

      IF ColumnLayoutName = '' THEN
        IF AccScheduleName.GET(AccSchedName) THEN
          ColumnLayoutName := AccScheduleName."Default Column Layout";
    END;

    LOCAL PROCEDURE SetBudgetFilterEnable@14();
    VAR
      ColumnLayout@1000 : Record 334;
    BEGIN
      BudgetFilterEnable := TRUE;
      StartDateEnabled := TRUE;
      IF ColumnLayoutName = '' THEN
        EXIT;
      ColumnLayout.SETRANGE("Column Layout Name",AccScheduleName."Default Column Layout");
      ColumnLayout.SETRANGE("Ledger Entry Type",ColumnLayout."Ledger Entry Type"::"Budget Entries");
      BudgetFilterEnable := NOT ColumnLayout.ISEMPTY;
      IF NOT BudgetFilterEnable THEN
        GLBudgetFilter := '';
      GLBudgetName := COPYSTR(GLBudgetFilter,1,MAXSTRLEN(GLBudgetName));
      ColumnLayout.SETRANGE("Ledger Entry Type");
      ColumnLayout.SETFILTER("Column Type",'<>%1',ColumnLayout."Column Type"::"Balance at Date");
      StartDateEnabled := NOT ColumnLayout.ISEMPTY;
      IF NOT StartDateEnabled THEN
        StartDate := 0D;
    END;

    LOCAL PROCEDURE ValidateStartEndDate@25();
    BEGIN
      IF (StartDate = 0D) AND (EndDate = 0D) THEN
        ValidateDateFilter('')
      ELSE
        ValidateDateFilter(STRSUBSTNO('%1..%2',StartDate,EndDate));
    END;

    LOCAL PROCEDURE ValidateDateFilter@17(NewDateFilter@1000 : Text[30]);
    VAR
      ApplicationManagement@1001 : Codeunit 1;
    BEGIN
      IF ApplicationManagement.MakeDateFilter(NewDateFilter) = 0 THEN;
      "Acc. Schedule Line".SETFILTER("Date Filter",NewDateFilter);
      DateFilter := COPYSTR("Acc. Schedule Line".GETFILTER("Date Filter"),1,MAXSTRLEN(DateFilter));
    END;

    LOCAL PROCEDURE ValidateAccSchedName@2();
    BEGIN
      AccSchedManagement.CheckName(AccSchedName);
      AccScheduleName.GET(AccSchedName);
      IF AccScheduleName."Default Column Layout" <> '' THEN
        ColumnLayoutName := AccScheduleName."Default Column Layout";
      IF AccScheduleName."Analysis View Name" <> '' THEN
        AnalysisView.GET(AccScheduleName."Analysis View Name")
      ELSE BEGIN
        CLEAR(AnalysisView);
        AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
        AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
      END;
      Dim1FilterEnable := AnalysisView."Dimension 1 Code" <> '';
      Dim2FilterEnable := AnalysisView."Dimension 2 Code" <> '';
      Dim3FilterEnable := AnalysisView."Dimension 3 Code" <> '';
      Dim4FilterEnable := AnalysisView."Dimension 4 Code" <> '';
      RequestOptionsPage.CAPTION := AccScheduleName.Description;
      RequestOptionsPage.UPDATE(FALSE);
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
      <rd:DataSourceID>aa735c03-5860-44b4-bb96-53a55f9ca503</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="AccScheduleName_Name">
          <DataField>AccScheduleName_Name</DataField>
        </Field>
        <Field Name="ColumnLayoutName">
          <DataField>ColumnLayoutName</DataField>
        </Field>
        <Field Name="FiscalStartDate">
          <DataField>FiscalStartDate</DataField>
        </Field>
        <Field Name="PeriodText">
          <DataField>PeriodText</DataField>
        </Field>
        <Field Name="COMPANYNAME">
          <DataField>COMPANYNAME</DataField>
        </Field>
        <Field Name="AccScheduleName_Description">
          <DataField>AccScheduleName_Description</DataField>
        </Field>
        <Field Name="AnalysisView_Code">
          <DataField>AnalysisView_Code</DataField>
        </Field>
        <Field Name="AnalysisView_Name">
          <DataField>AnalysisView_Name</DataField>
        </Field>
        <Field Name="HeaderText">
          <DataField>HeaderText</DataField>
        </Field>
        <Field Name="AccScheduleLineTABLECAPTION_AccSchedLineFilter">
          <DataField>AccScheduleLineTABLECAPTION_AccSchedLineFilter</DataField>
        </Field>
        <Field Name="AccSchedLineFilter">
          <DataField>AccSchedLineFilter</DataField>
        </Field>
        <Field Name="ColumnLayoutNameCaption">
          <DataField>ColumnLayoutNameCaption</DataField>
        </Field>
        <Field Name="AccScheduleName_Name_Caption">
          <DataField>AccScheduleName_Name_Caption</DataField>
        </Field>
        <Field Name="FiscalStartDateCaption">
          <DataField>FiscalStartDateCaption</DataField>
        </Field>
        <Field Name="PeriodTextCaption">
          <DataField>PeriodTextCaption</DataField>
        </Field>
        <Field Name="CurrReport_PAGENOCaption">
          <DataField>CurrReport_PAGENOCaption</DataField>
        </Field>
        <Field Name="Account_ScheduleCaption">
          <DataField>Account_ScheduleCaption</DataField>
        </Field>
        <Field Name="AnalysisView_CodeCaption">
          <DataField>AnalysisView_CodeCaption</DataField>
        </Field>
        <Field Name="RowNoCaption">
          <DataField>RowNoCaption</DataField>
        </Field>
        <Field Name="ShowRowNo">
          <DataField>ShowRowNo</DataField>
        </Field>
        <Field Name="ShowRoundingHeader">
          <DataField>ShowRoundingHeader</DataField>
        </Field>
        <Field Name="ColumnHeader1">
          <DataField>ColumnHeader1</DataField>
        </Field>
        <Field Name="ColumnHeader2">
          <DataField>ColumnHeader2</DataField>
        </Field>
        <Field Name="ColumnHeader3">
          <DataField>ColumnHeader3</DataField>
        </Field>
        <Field Name="ColumnHeader4">
          <DataField>ColumnHeader4</DataField>
        </Field>
        <Field Name="ColumnHeader5">
          <DataField>ColumnHeader5</DataField>
        </Field>
        <Field Name="NextPageGroupNo">
          <DataField>NextPageGroupNo</DataField>
        </Field>
        <Field Name="Acc__Schedule_Line_Description">
          <DataField>Acc__Schedule_Line_Description</DataField>
        </Field>
        <Field Name="Acc__Schedule_Line__Row_No">
          <DataField>Acc__Schedule_Line__Row_No</DataField>
        </Field>
        <Field Name="Acc__Schedule_Line_Line_No">
          <DataField>Acc__Schedule_Line_Line_No</DataField>
        </Field>
        <Field Name="Bold_control">
          <DataField>Bold_control</DataField>
        </Field>
        <Field Name="Italic_control">
          <DataField>Italic_control</DataField>
        </Field>
        <Field Name="Underline_control">
          <DataField>Underline_control</DataField>
        </Field>
        <Field Name="DoubleUnderline_control">
          <DataField>DoubleUnderline_control</DataField>
        </Field>
        <Field Name="LineShadowed">
          <DataField>LineShadowed</DataField>
        </Field>
        <Field Name="ColumnNo">
          <DataField>ColumnNo</DataField>
        </Field>
        <Field Name="Header">
          <DataField>Header</DataField>
        </Field>
        <Field Name="RoundingHeader">
          <DataField>RoundingHeader</DataField>
        </Field>
        <Field Name="ColumnValuesAsText">
          <DataField>ColumnValuesAsText</DataField>
        </Field>
        <Field Name="LineSkipped">
          <DataField>LineSkipped</DataField>
        </Field>
        <Field Name="LineNo_ColumnLayout">
          <DataField>LineNo_ColumnLayout</DataField>
        </Field>
        <Field Name="ColumnValue1">
          <DataField>ColumnValue1</DataField>
        </Field>
        <Field Name="ColumnValue2">
          <DataField>ColumnValue2</DataField>
        </Field>
        <Field Name="ColumnValue3">
          <DataField>ColumnValue3</DataField>
        </Field>
        <Field Name="ColumnValue4">
          <DataField>ColumnValue4</DataField>
        </Field>
        <Field Name="ColumnValue5">
          <DataField>ColumnValue5</DataField>
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
          <Rectangle Name="list1_Contents">
            <ReportItems>
              <Tablix Name="Table1">
                <TablixBody>
                  <TablixColumns>
                    <TablixColumn>
                      <Width>1.30741cm</Width>
                    </TablixColumn>
                    <TablixColumn>
                      <Width>6.81441cm</Width>
                    </TablixColumn>
                    <TablixColumn>
                      <Width>0.15cm</Width>
                    </TablixColumn>
                    <TablixColumn>
                      <Width>2.61967cm</Width>
                    </TablixColumn>
                  </TablixColumns>
                  <TablixRows>
                    <TablixRow>
                      <Height>0.42301cm</Height>
                      <TablixCells>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="textbox52">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!RowNoCaption.Value</Value>
                                      <Style>
                                        <FontSize>7pt</FontSize>
                                        <FontWeight>Bold</FontWeight>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>textbox45</rd:DefaultName>
                              <ZIndex>90</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
                          </CellContents>
                        </TablixCell>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="textbox51">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Parameters!AccSchedLineSpec_DescriptionCaptionLbl.Value</Value>
                                      <Style>
                                        <FontSize>7pt</FontSize>
                                        <FontWeight>Bold</FontWeight>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>textbox46</rd:DefaultName>
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
                              <rd:DefaultName>Textbox1</rd:DefaultName>
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
                            <Textbox Name="Header_1_">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Header.Value</Value>
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
                              <ZIndex>296</ZIndex>
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
                      <Height>0.42301cm</Height>
                      <TablixCells>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="Textbox17">
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
                                    <TextAlign>Right</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox17</rd:DefaultName>
                              <Visibility>
                                <Hidden>true</Hidden>
                              </Visibility>
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
                            <Textbox Name="Textbox18">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value />
                                      <Style>
                                        <FontStyle>=IIF(Fields!Italic_control.Value=TRUE,"Italic","Normal")</FontStyle>
                                        <FontSize>7pt</FontSize>
                                        <FontWeight>=IIF(Fields!Bold_control.Value=TRUE,"Bold","Normal")</FontWeight>
                                        <TextDecoration>=IIF(Fields!Underline_control.Value=TRUE,"Underline","None")</TextDecoration>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox18</rd:DefaultName>
                              <Visibility>
                                <Hidden>true</Hidden>
                              </Visibility>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>0.125cm</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
                          </CellContents>
                        </TablixCell>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="Textbox2">
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
                                    <TextAlign>Right</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox2</rd:DefaultName>
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
                            <Textbox Name="textbox6">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!RoundingHeader.Value</Value>
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
                              <rd:DefaultName>textbox6</rd:DefaultName>
                              <ZIndex>282</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!RoundingHeader.Value = nothing, true, false)</Hidden>
                              </Visibility>
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
                      <Height>0.08819cm</Height>
                      <TablixCells>
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
                                        <FontSize>7pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Right</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox15</rd:DefaultName>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <BottomBorder>
                                  <Style>Solid</Style>
                                </BottomBorder>
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
                            <Textbox Name="Textbox16">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value />
                                      <Style>
                                        <FontStyle>=IIF(Fields!Italic_control.Value=TRUE,"Italic","Normal")</FontStyle>
                                        <FontSize>7pt</FontSize>
                                        <FontWeight>=IIF(Fields!Bold_control.Value=TRUE,"Bold","Normal")</FontWeight>
                                        <TextDecoration>=IIF(Fields!Underline_control.Value=TRUE,"Underline","None")</TextDecoration>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox16</rd:DefaultName>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <BottomBorder>
                                  <Style>Solid</Style>
                                </BottomBorder>
                                <VerticalAlign>Middle</VerticalAlign>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>0.125cm</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
                          </CellContents>
                        </TablixCell>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="Textbox3">
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
                                    <TextAlign>Center</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox3</rd:DefaultName>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <BottomBorder>
                                  <Style>Solid</Style>
                                </BottomBorder>
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
                                        <FontSize>7pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Center</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox19</rd:DefaultName>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <BottomBorder>
                                  <Style>Solid</Style>
                                </BottomBorder>
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
                      <Height>0.08819cm</Height>
                      <TablixCells>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="Textbox20">
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
                                    <TextAlign>Right</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox20</rd:DefaultName>
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
                            <Textbox Name="Textbox21">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value />
                                      <Style>
                                        <FontStyle>=IIF(Fields!Italic_control.Value=TRUE,"Italic","Normal")</FontStyle>
                                        <FontSize>7pt</FontSize>
                                        <FontWeight>=IIF(Fields!Bold_control.Value=TRUE,"Bold","Normal")</FontWeight>
                                        <TextDecoration>=IIF(Fields!Underline_control.Value=TRUE,"Underline","None")</TextDecoration>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox21</rd:DefaultName>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>0.125cm</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
                          </CellContents>
                        </TablixCell>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="Textbox4">
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
                                    <TextAlign>Center</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox4</rd:DefaultName>
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
                            <Textbox Name="Textbox22">
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
                                    <TextAlign>Center</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox22</rd:DefaultName>
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
                      <Height>0.18489cm</Height>
                      <TablixCells>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="Textbox177">
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
                                    <TextAlign>Right</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox177</rd:DefaultName>
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
                            <Textbox Name="Textbox178">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value />
                                      <Style>
                                        <FontStyle>=IIF(Fields!Italic_control.Value=TRUE,"Italic","Normal")</FontStyle>
                                        <FontSize>7pt</FontSize>
                                        <FontWeight>=IIF(Fields!Bold_control.Value=TRUE,"Bold","Normal")</FontWeight>
                                        <TextDecoration>=IIF(Fields!Underline_control.Value=TRUE,"Underline","None")</TextDecoration>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox178</rd:DefaultName>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>0.125cm</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
                          </CellContents>
                        </TablixCell>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="Textbox5">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value />
                                      <Style>
                                        <FontStyle>=IIF(Fields!Italic_control.Value=TRUE,"Italic","Normal")</FontStyle>
                                        <FontSize>7pt</FontSize>
                                        <FontWeight>=IIF(Fields!Bold_control.Value=TRUE,"Bold","Normal")</FontWeight>
                                        <TextDecoration>=IIF(Fields!Underline_control.Value=TRUE,"Underline","None")</TextDecoration>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Right</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox5</rd:DefaultName>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                                <PaddingLeft>0.125cm</PaddingLeft>
                                <PaddingRight>0.125cm</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
                          </CellContents>
                        </TablixCell>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="Textbox179">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value />
                                      <Style>
                                        <FontStyle>=IIF(Fields!Italic_control.Value=TRUE,"Italic","Normal")</FontStyle>
                                        <FontSize>7pt</FontSize>
                                        <FontWeight>=IIF(Fields!Bold_control.Value=TRUE,"Bold","Normal")</FontWeight>
                                        <TextDecoration>=IIF(Fields!Underline_control.Value=TRUE,"Underline","None")</TextDecoration>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Right</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox179</rd:DefaultName>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                                <PaddingLeft>0.125cm</PaddingLeft>
                                <PaddingRight>0.125cm</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
                          </CellContents>
                        </TablixCell>
                      </TablixCells>
                    </TablixRow>
                    <TablixRow>
                      <Height>0.42301cm</Height>
                      <TablixCells>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="Acc__Schedule_Line__Row_No___Control22">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Acc__Schedule_Line__Row_No.Value</Value>
                                      <Style>
                                        <FontStyle>=IIF(Fields!Italic_control.Value=TRUE,"Italic","Normal")</FontStyle>
                                        <FontSize>7pt</FontSize>
                                        <FontWeight>=IIF(Fields!Bold_control.Value=TRUE,"Bold","Normal")</FontWeight>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Right</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <ZIndex>209</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                  <Width>2pt</Width>
                                </Border>
                                <BackgroundColor>=IIF(Fields!LineShadowed.Value = true,"#EFEFEF" , "#FFFFFF")</BackgroundColor>
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
                            <Textbox Name="Acc__Schedule_Line_Description_Control23">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Acc__Schedule_Line_Description.Value</Value>
                                      <Style>
                                        <FontStyle>=IIF(Fields!Italic_control.Value=TRUE,"Italic","Normal")</FontStyle>
                                        <FontSize>7pt</FontSize>
                                        <FontWeight>=IIF(Fields!Bold_control.Value=TRUE,"Bold","Normal")</FontWeight>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <ZIndex>208</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <BackgroundColor>=IIF(Fields!LineShadowed.Value = true,"#EFEFEF" , "#FFFFFF")</BackgroundColor>
                                <VerticalAlign>Middle</VerticalAlign>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>0.125cm</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
                          </CellContents>
                        </TablixCell>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="Textbox7">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value />
                                      <Style>
                                        <FontStyle>=IIF(Fields!Italic_control.Value=TRUE,"Italic","Normal")</FontStyle>
                                        <FontSize>7pt</FontSize>
                                        <FontWeight>=IIF(Fields!Bold_control.Value=TRUE,"Bold","Normal")</FontWeight>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Right</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox7</rd:DefaultName>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <BackgroundColor>=IIF(Fields!LineShadowed.Value = true,"#EFEFEF" , "#FFFFFF")</BackgroundColor>
                                <VerticalAlign>Middle</VerticalAlign>
                                <PaddingLeft>0.125cm</PaddingLeft>
                                <PaddingRight>0.125cm</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <rd:Selected>true</rd:Selected>
                          </CellContents>
                        </TablixCell>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="ColumnValuesAsText_1__Control24">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!ColumnValuesAsText.Value</Value>
                                      <Style>
                                        <FontStyle>=IIF(Fields!Italic_control.Value=TRUE,"Italic","Normal")</FontStyle>
                                        <FontSize>7pt</FontSize>
                                        <FontWeight>=IIF(Fields!Bold_control.Value=TRUE,"Bold","Normal")</FontWeight>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Right</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <ZIndex>207</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <BottomBorder>
                                  <Style>=IIF(Fields!Underline_control.Value=TRUE,"Solid",IIF(Fields!DoubleUnderline_control.Value=TRUE,"Double","None"))</Style>
                                  <Width>=IIF(Fields!DoubleUnderline_control.Value=TRUE,"3pt","1pt")</Width>
                                </BottomBorder>
                                <BackgroundColor>=IIF(Fields!LineShadowed.Value = true,"#EFEFEF" , "#FFFFFF")</BackgroundColor>
                                <VerticalAlign>Middle</VerticalAlign>
                                <PaddingLeft>0.125cm</PaddingLeft>
                                <PaddingRight>0.125cm</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
                          </CellContents>
                        </TablixCell>
                      </TablixCells>
                    </TablixRow>
                    <TablixRow>
                      <Height>0.08252cm</Height>
                      <TablixCells>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="DummyTextBox1">
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
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <BackgroundColor>=IIF(Fields!LineShadowed.Value = true,"#EFEFEF" , "#FFFFFF")</BackgroundColor>
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
                            <Textbox Name="DummyTextBox2">
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
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <BackgroundColor>=IIF(Fields!LineShadowed.Value = true,"#EFEFEF" , "#FFFFFF")</BackgroundColor>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>0.125cm</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
                          </CellContents>
                        </TablixCell>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="Textbox8">
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
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>Textbox8</rd:DefaultName>
                              <Style>
                                <Border />
                                <BackgroundColor>=IIF(Fields!LineShadowed.Value = true,"#EFEFEF" , "#FFFFFF")</BackgroundColor>
                                <PaddingLeft>0.125cm</PaddingLeft>
                                <PaddingRight>0.125cm</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
                          </CellContents>
                        </TablixCell>
                        <TablixCell>
                          <CellContents>
                            <Textbox Name="DummyTextBox3">
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
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Style>
                                <Border />
                                <BackgroundColor>=IIF(Fields!LineShadowed.Value = true,"#EFEFEF" , "#FFFFFF")</BackgroundColor>
                                <PaddingLeft>0.125cm</PaddingLeft>
                                <PaddingRight>0.125cm</PaddingRight>
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
                    <TablixMember>
                      <Visibility>
                        <Hidden>=Fields!ShowRowNo.Value=false</Hidden>
                      </Visibility>
                    </TablixMember>
                    <TablixMember />
                    <TablixMember>
                      <Group Name="Columns">
                        <GroupExpressions>
                          <GroupExpression>=Fields!LineNo_ColumnLayout.Value</GroupExpression>
                        </GroupExpressions>
                        <PageBreak>
                          <BreakLocation>Between</BreakLocation>
                        </PageBreak>
                      </Group>
                      <SortExpressions>
                        <SortExpression>
                          <Value>=Fields!LineNo_ColumnLayout.Value</Value>
                        </SortExpression>
                      </SortExpressions>
                      <TablixMembers>
                        <TablixMember />
                        <TablixMember />
                      </TablixMembers>
                      <Visibility>
                        <Hidden>=iif(ISNOTHING(Fields!ColumnNo.Value),true,false)</Hidden>
                      </Visibility>
                    </TablixMember>
                  </TablixMembers>
                </TablixColumnHierarchy>
                <TablixRowHierarchy>
                  <TablixMembers>
                    <TablixMember>
                      <Group Name="Header">
                        <GroupExpressions>
                          <GroupExpression>0</GroupExpression>
                        </GroupExpressions>
                      </Group>
                      <SortExpressions>
                        <SortExpression>
                          <Value>Header</Value>
                        </SortExpression>
                      </SortExpressions>
                      <TablixMembers>
                        <TablixMember>
                          <KeepWithGroup>After</KeepWithGroup>
                          <RepeatOnNewPage>true</RepeatOnNewPage>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=Fields!ShowRoundingHeader.Value=false</Hidden>
                          </Visibility>
                          <KeepWithGroup>After</KeepWithGroup>
                          <RepeatOnNewPage>true</RepeatOnNewPage>
                        </TablixMember>
                        <TablixMember>
                          <KeepWithGroup>After</KeepWithGroup>
                          <RepeatOnNewPage>true</RepeatOnNewPage>
                        </TablixMember>
                        <TablixMember>
                          <KeepWithGroup>After</KeepWithGroup>
                          <RepeatOnNewPage>true</RepeatOnNewPage>
                        </TablixMember>
                        <TablixMember>
                          <Group Name="ScheduleNameGroup">
                            <GroupExpressions>
                              <GroupExpression>=Fields!AccScheduleName_Name.Value</GroupExpression>
                            </GroupExpressions>
                          </Group>
                          <SortExpressions>
                            <SortExpression>
                              <Value>=Fields!AccScheduleName_Name.Value</Value>
                            </SortExpression>
                          </SortExpressions>
                          <TablixMembers>
                            <TablixMember>
                              <Group Name="PageGroup">
                                <GroupExpressions>
                                  <GroupExpression>=Fields!NextPageGroupNo.Value</GroupExpression>
                                </GroupExpressions>
                                <PageBreak>
                                  <BreakLocation>Between</BreakLocation>
                                </PageBreak>
                                <Filters>
                                  <Filter>
                                    <FilterExpression>=Fields!NextPageGroupNo.Value</FilterExpression>
                                    <Operator>NotEqual</Operator>
                                    <FilterValues>
                                      <FilterValue>=nothing</FilterValue>
                                    </FilterValues>
                                  </Filter>
                                </Filters>
                              </Group>
                              <SortExpressions>
                                <SortExpression>
                                  <Value>=Fields!AccScheduleName_Name.Value</Value>
                                </SortExpression>
                              </SortExpressions>
                              <TablixMembers>
                                <TablixMember>
                                  <KeepWithGroup>After</KeepWithGroup>
                                  <RepeatOnNewPage>true</RepeatOnNewPage>
                                  <KeepTogether>true</KeepTogether>
                                </TablixMember>
                                <TablixMember>
                                  <Group Name="Lines">
                                    <GroupExpressions>
                                      <GroupExpression>=Fields!Acc__Schedule_Line_Line_No.Value</GroupExpression>
                                    </GroupExpressions>
                                  </Group>
                                  <SortExpressions>
                                    <SortExpression>
                                      <Value>=Fields!Acc__Schedule_Line_Line_No.Value</Value>
                                    </SortExpression>
                                  </SortExpressions>
                                  <TablixMembers>
                                    <TablixMember />
                                    <TablixMember />
                                  </TablixMembers>
                                  <Visibility>
                                    <Hidden>=IIF(Last(Fields!LineSkipped.Value, "Lines") = True, True, False)</Hidden>
                                  </Visibility>
                                  <KeepTogether>true</KeepTogether>
                                </TablixMember>
                              </TablixMembers>
                            </TablixMember>
                          </TablixMembers>
                        </TablixMember>
                      </TablixMembers>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                  </TablixMembers>
                </TablixRowHierarchy>
                <RepeatColumnHeaders>true</RepeatColumnHeaders>
                <RepeatRowHeaders>true</RepeatRowHeaders>
                <KeepTogether>true</KeepTogether>
                <DataSetName>DataSet_Result</DataSetName>
                <Top>0.17062cm</Top>
                <Left>0.03757cm</Left>
                <Height>1.71282cm</Height>
                <Width>10.89149cm</Width>
                <DataElementOutput>NoOutput</DataElementOutput>
                <Style />
              </Tablix>
            </ReportItems>
            <KeepTogether>true</KeepTogether>
            <Top>0.03528cm</Top>
            <Height>0.80139in</Height>
            <Width>18.71005cm</Width>
            <Style />
          </Rectangle>
        </ReportItems>
        <Height>2.2472cm</Height>
        <Style />
      </Body>
      <Width>18.81896cm</Width>
      <Page>
        <PageHeader>
          <Height>4.04732cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="FiscalStartDateCaption1">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!FiscalStartDateCaption.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>2.02571cm</Top>
              <Left>0.0683cm</Left>
              <Height>0.423cm</Height>
              <Width>2.25cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="COMPANYNAME1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!COMPANYNAME.Value</Value>
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
              <Top>0.79871cm</Top>
              <Left>0.03757cm</Left>
              <Height>0.423cm</Height>
              <Width>10.4cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PeriodText1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!PeriodText.Value</Value>
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
              <Top>1.22171cm</Top>
              <Left>0.03757cm</Left>
              <Height>0.423cm</Height>
              <Width>10.4cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="FiscalStartDate1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!FiscalStartDate.Value</Value>
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
              <Top>2.02571cm</Top>
              <Left>2.43757cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="HeaderText1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!HeaderText.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>3.20106cm</Top>
              <Left>0.0683cm</Left>
              <Height>0.423cm</Height>
              <Width>7.93651cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="AccSchedLineFilter1">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!AccSchedLineFilter.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>2.62948cm</Top>
              <Left>0.0683cm</Left>
              <Height>0.423cm</Height>
              <Width>18.64175cm</Width>
              <ZIndex>5</ZIndex>
              <Visibility>
                <Hidden>=IIF(First(Fields!AccSchedLineFilter.Value, "DataSet_Result")="",TRUE,FALSE)</Hidden>
              </Visibility>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="Account_ScheduleCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!AccScheduleName_Description.Value</Value>
                      <Style>
                        <FontSize>16pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.0125in</Top>
              <Left>0.03757cm</Left>
              <Height>20pt</Height>
              <Width>10.4cm</Width>
              <ZIndex>6</ZIndex>
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
              <Top>0.80896cm</Top>
              <Left>12.34324cm</Left>
              <Height>0.423cm</Height>
              <Width>6.36681cm</Width>
              <ZIndex>7</ZIndex>
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
                        <Format>d</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.03175cm</Top>
              <Left>14.90971cm</Left>
              <Height>0.423cm</Height>
              <Width>3.80034cm</Width>
              <ZIndex>8</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CurrReport_PAGENOCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!CurrReport_PAGENOCaption.Value,"DataSet_Result") &amp; " " &amp; Globals!PageNumber</Value>
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
              <Top>0.43006cm</Top>
              <Left>14.9097cm</Left>
              <Height>0.423cm</Height>
              <Width>3.80035cm</Width>
              <ZIndex>9</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
          </ReportItems>
          <Style />
        </PageHeader>
        <PageHeight>21cm</PageHeight>
        <PageWidth>29.7cm</PageWidth>
        <InteractiveHeight>21cm</InteractiveHeight>
        <InteractiveWidth>28cm</InteractiveWidth>
        <LeftMargin>1cm</LeftMargin>
        <RightMargin>2cm</RightMargin>
        <TopMargin>1.058cm</TopMargin>
        <BottomMargin>0cm</BottomMargin>
        <Style />
      </Page>
    </ReportSection>
  </ReportSections>
  <ReportParameters>
    <ReportParameter Name="AccSchedLineSpec_DescriptionCaptionLbl">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>AccSchedLineSpec_DescriptionCaptionLbl</Value>
        </Values>
      </DefaultValue>
      <Prompt>AccSchedLineSpec_DescriptionCaptionLbl</Prompt>
    </ReportParameter>
  </ReportParameters>
  <ReportParametersLayout>
    <GridLayoutDefinition>
      <NumberOfColumns>1</NumberOfColumns>
      <NumberOfRows>1</NumberOfRows>
      <CellDefinitions>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>0</RowIndex>
          <ParameterName>AccSchedLineSpec_DescriptionCaptionLbl</ParameterName>
        </CellDefinition>
      </CellDefinitions>
    </GridLayoutDefinition>
  </ReportParametersLayout>
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
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>181ac405-3e59-4785-8bff-f5239ed34435</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

