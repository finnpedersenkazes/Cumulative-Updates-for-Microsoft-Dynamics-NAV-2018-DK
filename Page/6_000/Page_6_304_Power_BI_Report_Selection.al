OBJECT Page 6304 Power BI Report Selection
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Power BI-rapportvalg;
               ENU=Power BI Reports Selection];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table6302;
    PageType=List;
    SourceTableTemporary=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapporter,Administrer,Hent rapporter;
                                ENU=New,Process,Report,Manage,Get Reports];
    OnOpenPage=BEGIN
                 LoadReportsList;
                 IsSaaS := AzureADMgt.IsSaaS;
               END;

    OnQueryClosePage=BEGIN
                       SaveAndClose;
                     END;

    ActionList=ACTIONS
    {
      { 5       ;    ;ActionContainer;
                      ActionContainerType=Reports }
      { 7       ;1   ;Action    ;
                      Name=EnableReport;
                      CaptionML=[DAN=Aktiver;
                                 ENU=Enable];
                      ToolTipML=[DAN=Aktiverer valg af rapport.;
                                 ENU=Enables the report selection.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=NOT Enabled;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 Enabled := TRUE;
                                 CurrPage.UPDATE;
                               END;

                      Gesture=LeftSwipe }
      { 8       ;1   ;Action    ;
                      Name=DisableReport;
                      CaptionML=[DAN=Deaktiver;
                                 ENU=Disable];
                      ToolTipML=[DAN=Deaktiverer valg af rapport.;
                                 ENU=Disables the report selection.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=Enabled;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 Enabled := FALSE;
                                 CurrPage.UPDATE;
                               END;

                      Gesture=RightSwipe }
      { 9       ;1   ;Action    ;
                      Name=Refresh;
                      CaptionML=[DAN=Opdater oversigt;
                                 ENU=Refresh List];
                      ToolTipML=[DAN=Opdater rapportlisten med netop tilf›jede rapporter.;
                                 ENU=Update the report list with any newly added reports.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Refresh;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 LoadReportsList;
                               END;
                                }
      { 10      ;1   ;Action    ;
                      Name=MyOrganization;
                      CaptionML=[DAN=Min organisation;
                                 ENU=My Organization];
                      ToolTipML=[DAN=Gennemse indholdspakker, der er udgivet af andre i virksomheden.;
                                 ENU=Browse content packs that other people in your organization have published.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Image=PowerBI;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 // Opens a new browser tab to Power BI's content pack list, set to the My Organization tab.
                                 HYPERLINK(PowerBIServiceMgt.GetContentPacksMyOrganizationUrl);
                               END;
                                }
      { 11      ;1   ;Action    ;
                      Name=Services;
                      CaptionML=[DAN=Tjenester;
                                 ENU=Services];
                      ToolTipML=[DAN=V‘lg indholdspakker fra onlinetjenester, du bruger.;
                                 ENU=Choose content packs from online services that you use.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Image=PowerBI;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 // Opens a new browser tab to AppSource's content pack list, filtered to NAV reports.
                                 HYPERLINK(PowerBIServiceMgt.GetContentPacksServicesUrl);
                               END;
                                }
      { 12      ;1   ;Action    ;
                      Name=ConnectionInfo;
                      CaptionML=[DAN=Oplysninger om forbindelse;
                                 ENU=Connection Information];
                      ToolTipML=[DAN=Vis oplysninger vedr›rende oprettelse af forbindelse til Power BI-indholdspakker.;
                                 ENU=Show information for connecting to Power BI content packs.];
                      ApplicationArea=#All;
                      RunObject=Page 6316;
                      Promoted=Yes;
                      Visible=NOT IsSaaS;
                      Image=Setup;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                Visible=HasReports;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                Name=ReportName;
                CaptionML=[DAN=Rapportnavn;
                           ENU=Report Name];
                ToolTipML=[DAN=Angiver navnet p† rapporten.;
                           ENU=Specifies the name of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ReportName;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              // Throw an error if the selected report is disabled
                              IF NOT Enabled THEN
                                ERROR(DisabledReportSelectedErr);

                              // OnDrillDown returns a LookupCancel Action when the page closes.
                              // IsPgclosedOkay is used to tell the caller of this page that inspite of the LookupCancel
                              // the action should be treated like a LookupOk
                              IsPgClosedOkay := TRUE;
                              SaveAndClose;
                            END;
                             }

    { 4   ;2   ;Field     ;
                Name=Enabled;
                ToolTipML=[DAN=Angiver, at rapportvalget er aktiveret.;
                           ENU=Specifies that the report selection is enabled.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Enabled }

    { 6   ;1   ;Group     ;
                Visible=NOT HasReports;
                GroupType=Group }

    { 13  ;2   ;Field     ;
                Name=NoReportsError;
                CaptionML=[DAN=Der er ingen rapporter fra Power BI.;
                           ENU=There are no reports available from Power BI.];
                ToolTipML=[DAN=Angiver, at brugeren har brug for at v‘lge Power BI-rapporter.;
                           ENU=Specifies that the user needs to select Power BI reports.];
                ApplicationArea=#Basic,#Suite }

  }
  CODE
  {
    VAR
      DisabledReportSelectedErr@1000 : TextConst 'DAN=Den rapport, som du har valgt, er deaktiveret og kan ikke †bnes i rollecenteret. Aktiv‚r den valgte rapport, eller v‘lg en anden rapport.;ENU=The report that you selected is disabled and cannot be opened on the role center. Enable the selected report or select another report.';
      AzureADMgt@1002 : Codeunit 6300;
      PowerBIServiceMgt@1005 : Codeunit 6301;
      Context@1001 : Text[30];
      NameFilter@1004 : Text;
      IsPgClosedOkay@1003 : Boolean;
      IsSaaS@1006 : Boolean;
      HasReports@1007 : Boolean;

    [External]
    PROCEDURE SetContext@2(ParentContext@1000 : Text[30]);
    BEGIN
      // Sets the ID of the parent page that reports are being selected for.
      Context := ParentContext;
    END;

    [External]
    PROCEDURE SetNameFilter@10(ParentFilter@1000 : Text);
    BEGIN
      // Sets the value to filter report names by.
      // This should be called by the parent page before opening this page.
      NameFilter := ParentFilter;
    END;

    LOCAL PROCEDURE FilterReports@21();
    BEGIN
      // Filters the report collection by name, if the parent page has provided a value to filter by.
      // This filter will display any report that has the value anywhere in the name, case insensitive.
      IF NameFilter <> '' THEN
        SETFILTER(ReportName,'%1','@*' + NameFilter + '*');
    END;

    LOCAL PROCEDURE LoadReportsList@6();
    VAR
      ExceptionMessage@1000 : Text;
      ExceptionDetails@1001 : Text;
    BEGIN
      // Clears and retrieves a list of all reports in the user's Power BI account.
      DELETEALL;
      PowerBIServiceMgt.GetReports(Rec,ExceptionMessage,ExceptionDetails,Context);

      HasReports := NOT ISEMPTY;
      IF ISEMPTY THEN
        INSERT; // Hack to prevent empty list error.

      // Set sort order, scrollbar position, and filters.
      SETCURRENTKEY(ReportName);
      FINDFIRST;
      FilterReports;
    END;

    LOCAL PROCEDURE SaveAndClose@5();
    VAR
      PowerBiReportConfiguration@1001 : Record 6301;
      TempPowerBiReportBuffer@1000 : TEMPORARY Record 6302;
    BEGIN
      // use a temp buffer record for saving to not disturb the position, filters, etc. of the source table
      // ShareTable = TRUE makes a shallow copy of the record, which is OK since no modifications are made to the records themselves
      TempPowerBiReportBuffer.COPY(Rec,TRUE);

      IF TempPowerBiReportBuffer.FIND('-') THEN
        REPEAT
          IF PowerBiReportConfiguration.GET(USERSECURITYID,TempPowerBiReportBuffer.ReportID,Context) THEN BEGIN
            IF NOT TempPowerBiReportBuffer.Enabled THEN
              PowerBiReportConfiguration.DELETE;
          END ELSE
            IF TempPowerBiReportBuffer.Enabled THEN BEGIN
              PowerBiReportConfiguration.INIT;
              PowerBiReportConfiguration."User Security ID" := USERSECURITYID;
              PowerBiReportConfiguration."Report ID" := TempPowerBiReportBuffer.ReportID;
              PowerBiReportConfiguration.Context := Context;
              PowerBiReportConfiguration.INSERT;
            END;
        UNTIL TempPowerBiReportBuffer.NEXT = 0;

      IsPgClosedOkay := TRUE;
      CurrPage.CLOSE;
    END;

    [External]
    PROCEDURE IsPageClosedOkay@3() : Boolean;
    BEGIN
      EXIT(IsPgClosedOkay);
    END;

    BEGIN
    END.
  }
}

