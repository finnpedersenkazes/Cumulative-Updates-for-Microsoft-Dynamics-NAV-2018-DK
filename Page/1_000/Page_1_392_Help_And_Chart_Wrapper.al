OBJECT Page 1392 Help And Chart Wrapper
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Virksomhedshjëlp;
               ENU=Business Assistance];
    DeleteAllowed=No;
    SourceTable=Table1803;
    SourceTableView=SORTING(Order,Visible)
                    WHERE(Visible=CONST(Yes),
                          Featured=CONST(Yes));
    PageType=CardPart;
    OnOpenPage=VAR
                 CompanyInformation@1000 : Record 79;
                 LastUsedChart@1002 : Record 1311;
                 PermissionManager@1001 : Codeunit 9002;
               BEGIN
                 CompanyInformation.GET;
                 ShowChart := CompanyInformation."Show Chart On RoleCenter";

                 IsSaaS := PermissionManager.SoftwareAsAService;
                 IF ShowChart THEN BEGIN
                   IF LastUsedChart.GET(USERID) THEN
                     IF SelectedChartDefinition.GET(LastUsedChart."Code Unit ID",LastUsedChart."Chart Name") THEN;

                   InitializeSelectedChart;
                 END;

                 Initialize;
               END;

    ActionList=ACTIONS
    {
      { 6000    ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 6001    ;1   ;Action    ;
                      Name=Select Chart;
                      CaptionML=[DAN=Vëlg diagram;
                                 ENU=Select Chart];
                      ToolTipML=[DAN=Skift det diagram, der vises. Du kan vëlge mellem forskellige diagrammer, som viser data for forskellige nõgletal.;
                                 ENU=Change the chart that is displayed. You can choose from several charts that show data for different performance indicators.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=ShowChart;
                      Image=SelectChart;
                      OnAction=BEGIN
                                 ChartManagement.SelectChart(BusinessChartBuffer,SelectedChartDefinition);
                                 InitializeSelectedChart;
                               END;
                                }
      { 7002    ;1   ;Action    ;
                      Name=Previous Chart;
                      CaptionML=[DAN=Forrige diagram;
                                 ENU=Previous Chart];
                      ToolTipML=[DAN=FÜ vist det forrige diagram.;
                                 ENU=View the previous chart.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=ShowChart;
                      Image=PreviousSet;
                      OnAction=BEGIN
                                 SelectedChartDefinition.SETRANGE(Enabled,TRUE);
                                 IF SelectedChartDefinition.NEXT(-1) = 0 THEN
                                   IF NOT SelectedChartDefinition.FINDLAST THEN
                                     EXIT;
                                 InitializeSelectedChart;
                               END;
                                }
      { 7000    ;1   ;Action    ;
                      Name=Next Chart;
                      CaptionML=[DAN=Nëste diagram;
                                 ENU=Next Chart];
                      ToolTipML=[DAN=FÜ vist det nëste diagram.;
                                 ENU=View the next chart.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=ShowChart;
                      Image=NextSet;
                      OnAction=BEGIN
                                 SelectedChartDefinition.SETRANGE(Enabled,TRUE);
                                 IF SelectedChartDefinition.NEXT = 0 THEN
                                   IF NOT SelectedChartDefinition.FINDFIRST THEN
                                     EXIT;
                                 InitializeSelectedChart;
                               END;
                                }
      { 7007    ;1   ;ActionGroup;
                      Name=PeriodLength;
                      CaptionML=[DAN=Periodelëngde;
                                 ENU=Period Length];
                      Visible=ShowChart;
                      Image=Period }
      { 7006    ;2   ;Action    ;
                      Name=Day;
                      CaptionML=[DAN=Dag;
                                 ENU=Day];
                      ToolTipML=[DAN=Hver stak dëkker en dag.;
                                 ENU=Each stack covers one day.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=ShowChart;
                      Image=DueDate;
                      OnAction=BEGIN
                                 SetPeriodAndUpdateChart(BusinessChartBuffer."Period Length"::Day);
                               END;
                                }
      { 7005    ;2   ;Action    ;
                      Name=Week;
                      CaptionML=[DAN=Uge;
                                 ENU=Week];
                      ToolTipML=[DAN=Hver stak pÜ nër den sidste dëkker en uge. Den sidste stak indeholder data fra starten af ugen frem til den dato, der er defineret af indstillingen Vis.;
                                 ENU=Each stack except for the last stack covers one week. The last stack contains data from the start of the week until the date that is defined by the Show option.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=ShowChart;
                      Image=DateRange;
                      OnAction=BEGIN
                                 SetPeriodAndUpdateChart(BusinessChartBuffer."Period Length"::Week);
                               END;
                                }
      { 7004    ;2   ;Action    ;
                      Name=Month;
                      CaptionML=[DAN=MÜned;
                                 ENU=Month];
                      ToolTipML=[DAN=Hver stak pÜ nër den sidste dëkker en mÜned. Den sidste stak indeholder data fra starten af mÜneden frem til den dato, der er defineret af indstillingen Vis.;
                                 ENU=Each stack except for the last stack covers one month. The last stack contains data from the start of the month until the date that is defined by the Show option.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=ShowChart;
                      Image=DateRange;
                      OnAction=BEGIN
                                 SetPeriodAndUpdateChart(BusinessChartBuffer."Period Length"::Month);
                               END;
                                }
      { 7003    ;2   ;Action    ;
                      Name=Quarter;
                      CaptionML=[DAN=Kvartal;
                                 ENU=Quarter];
                      ToolTipML=[DAN=Hver stak pÜ nër den sidste dëkker et kvartal. Den sidste stak indeholder data fra starten af kvartalet frem til den dato, der er defineret af indstillingen Vis.;
                                 ENU=Each stack except for the last stack covers one quarter. The last stack contains data from the start of the quarter until the date that is defined by the Show option.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=ShowChart;
                      Image=DateRange;
                      OnAction=BEGIN
                                 SetPeriodAndUpdateChart(BusinessChartBuffer."Period Length"::Quarter);
                               END;
                                }
      { 7001    ;2   ;Action    ;
                      Name=Year;
                      CaptionML=[DAN=èr;
                                 ENU=Year];
                      ToolTipML=[DAN=Hver stak pÜ nër den sidste dëkker et Ür. Den sidste stak indeholder data fra starten af Üret frem til den dato, der er defineret af indstillingen Vis.;
                                 ENU=Each stack except for the last stack covers one year. The last stack contains data from the start of the year until the date that is defined by the Show option.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=ShowChart;
                      Image=DateRange;
                      OnAction=BEGIN
                                 SetPeriodAndUpdateChart(BusinessChartBuffer."Period Length"::Year);
                               END;
                                }
      { 6003    ;1   ;Action    ;
                      Name=PreviousPeriod;
                      CaptionML=[DAN=Forrige periode;
                                 ENU=Previous Period];
                      ToolTipML=[DAN=Vis oplysningerne baseret pÜ den forrige periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen fõr.;
                                 ENU=Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=ShowChart;
                      Enabled=PreviousNextActionEnabled;
                      Image=PreviousRecord;
                      OnAction=BEGIN
                                 ChartManagement.UpdateChart(SelectedChartDefinition,BusinessChartBuffer,Period::Previous);
                                 BusinessChartBuffer.Update(CurrPage.BusinessChart);
                               END;
                                }
      { 6002    ;1   ;Action    ;
                      Name=NextPeriod;
                      CaptionML=[DAN=Nëste periode;
                                 ENU=Next Period];
                      ToolTipML=[DAN=Vis oplysningerne baseret pÜ den nëste periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen efter.;
                                 ENU=Show the information based on the next period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=ShowChart;
                      Enabled=PreviousNextActionEnabled;
                      Image=NextRecord;
                      OnAction=BEGIN
                                 ChartManagement.UpdateChart(SelectedChartDefinition,BusinessChartBuffer,Period::Next);
                                 BusinessChartBuffer.Update(CurrPage.BusinessChart);
                               END;
                                }
      { 4       ;1   ;Action    ;
                      Name=ChartInformation;
                      CaptionML=[DAN=Diagramoplysninger;
                                 ENU=Chart Information];
                      ToolTipML=[DAN=FÜ vist en beskrivelse af diagrammet.;
                                 ENU=View a description of the chart.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=ShowChart;
                      Image=AboutNav;
                      OnAction=VAR
                                 Description@1000 : Text;
                               BEGIN
                                 IF StatusText = '' THEN
                                   EXIT;
                                 Description := ChartManagement.ChartDescription(SelectedChartDefinition);
                                 IF Description = '' THEN
                                   MESSAGE(NoDescriptionMsg)
                                 ELSE
                                   MESSAGE(Description);
                               END;
                                }
      { 13      ;1   ;Action    ;
                      Name=Show Setup and Help Resources;
                      CaptionML=[DAN=Vis konfigurations- og hjëlperessourcer;
                                 ENU=Show Setup and Help Resources];
                      ToolTipML=[DAN=FÜ hjëlp til konfiguration og visning af hjëlpeemner, videoer og andre ressourcer.;
                                 ENU=Get assistance for setup and view help topics, videos, and other resources.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=ShowChart AND IsSaaS;
                      OnAction=BEGIN
                                 PersistChartVisibility(FALSE);
                                 MESSAGE(RefreshPageMsg)
                               END;
                                }
      { 10      ;1   ;Action    ;
                      Name=View;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Vis;
                                 ENU=View];
                      ToolTipML=[DAN=FÜ vist ressourcen.;
                                 ENU=View the resource.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      Visible=NOT ShowChart;
                      Image=View;
                      PromotedCategory=Category4;
                      RunPageMode=View;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
      { 9       ;1   ;Action    ;
                      Name=Show Chart;
                      CaptionML=[DAN=Vis diagram;
                                 ENU=Show Chart];
                      ToolTipML=[DAN=FÜ vist diagrammet.;
                                 ENU=View the chart.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=NOT ShowChart;
                      Image=AnalysisView;
                      OnAction=BEGIN
                                 SETRANGE(Featured,TRUE);
                                 PersistChartVisibility(TRUE);
                                 IF ClientTypeManagement.GetCurrentClientType IN [CLIENTTYPE::Phone,CLIENTTYPE::Tablet] THEN
                                   MESSAGE(SignInAgainMsg)
                                 ELSE
                                   MESSAGE(RefreshPageMsg);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 8   ;1   ;Group     ;
                Name=Group;
                CaptionML=[DAN=FremgangsmÜde:;
                           ENU=How To:];
                Visible=NOT ShowChart;
                GroupType=Repeater }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen pÜ ressourcen.;
                           ENU=Specifies the type of resource.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Item Type";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ ressourcen.;
                           ENU=Specifies the name of the resource.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ikonet for den knap, der Übner ressourcen.;
                           ENU=Specifies the icon for the button that opens the resource.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Icon }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for ressource, f.eks. Fuldfõrt.;
                           ENU=Specifies the status of the resource, such as Completed.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Status;
                Visible=IsSaaS }

    { 2   ;1   ;Field     ;
                Name=Status Text;
                CaptionML=[DAN=Statustekst;
                           ENU=Status Text];
                ToolTipML=[DAN=Angiver status for ressource, f.eks. Fuldfõrt.;
                           ENU=Specifies the status of the resource, such as Completed.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=StatusText;
                Visible=ShowChart;
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                ShowCaption=No }

    { 3   ;1   ;Field     ;
                Name=BusinessChart;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                Visible=ShowChart;
                ControlAddIn=[Microsoft.Dynamics.Nav.Client.BusinessChart;PublicKeyToken=31bf3856ad364e35] }

  }
  CODE
  {
    VAR
      SelectedChartDefinition@1004 : Record 1310;
      BusinessChartBuffer@1008 : Record 485;
      ChartManagement@1002 : Codeunit 1315;
      ClientTypeManagement@1011 : Codeunit 4;
      StatusText@1001 : Text;
      Period@1005 : ' ,Next,Previous';
      PreviousNextActionEnabled@6000 : Boolean INDATASET;
      NoDescriptionMsg@1006 : TextConst 'DAN=Der er ikke angivet en beskrivelse til dette diagram.;ENU=A description was not specified for this chart.';
      IsChartAddInReady@1000 : Boolean;
      ShowChart@1010 : Boolean;
      RefreshPageMsg@1003 : TextConst 'DAN=Opdater siden, for at fÜ ëndringen til at trëde i kraft.;ENU=Refresh the page for the change to take effect.';
      IsSaaS@1007 : Boolean;
      SignInAgainMsg@1009 : TextConst 'DAN=Log af og derefter pÜ igen, sÜ ëndringen kan trëde i kraft.;ENU=Sign out and sign in for the change to take effect.';

    LOCAL PROCEDURE InitializeSelectedChart@7000();
    BEGIN
      ChartManagement.SetDefaultPeriodLength(SelectedChartDefinition,BusinessChartBuffer);
      ChartManagement.UpdateChart(SelectedChartDefinition,BusinessChartBuffer,Period::" ");
      PreviousNextActionEnabled := ChartManagement.UpdateNextPrevious(SelectedChartDefinition);
      ChartManagement.UpdateStatusText(SelectedChartDefinition,BusinessChartBuffer,StatusText);
      UpdateChart;
    END;

    LOCAL PROCEDURE SetPeriodAndUpdateChart@1(PeriodLength@1000 : Option);
    BEGIN
      ChartManagement.SetPeriodLength(SelectedChartDefinition,BusinessChartBuffer,PeriodLength,FALSE);
      ChartManagement.UpdateChart(SelectedChartDefinition,BusinessChartBuffer,Period::" ");
      ChartManagement.UpdateStatusText(SelectedChartDefinition,BusinessChartBuffer,StatusText);
      UpdateChart;
    END;

    LOCAL PROCEDURE UpdateChart@2();
    BEGIN
      IF NOT IsChartAddInReady THEN
        EXIT;
      BusinessChartBuffer.Update(CurrPage.BusinessChart);
    END;

    LOCAL PROCEDURE PersistChartVisibility@14(VisibilityStatus@1000 : Boolean);
    VAR
      CompanyInformation@1001 : Record 79;
    BEGIN
      IF NOT CompanyInformation.GET THEN BEGIN
        CompanyInformation.INIT;
        CompanyInformation.INSERT;
      END;

      CompanyInformation.VALIDATE("Show Chart On RoleCenter",VisibilityStatus);
      CompanyInformation.MODIFY;
    END;

    EVENT BusinessChart@-5::DataPointClicked@12(point@1000 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
    BEGIN
      BusinessChartBuffer.SetDrillDownIndexes(point);
      ChartManagement.DataPointClicked(BusinessChartBuffer,SelectedChartDefinition);
    END;

    EVENT BusinessChart@-5::DataPointDoubleClicked@13(point@1000 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
    BEGIN
    END;

    EVENT BusinessChart@-3::AddInReady@14();
    BEGIN
      IsChartAddInReady := TRUE;
      ChartManagement.AddinReady(SelectedChartDefinition,BusinessChartBuffer);
      InitializeSelectedChart;
    END;

    EVENT BusinessChart@-15::Refresh@4();
    BEGIN
      UpdateChart
    END;

    BEGIN
    END.
  }
}

