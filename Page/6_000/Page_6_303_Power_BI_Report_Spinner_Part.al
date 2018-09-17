OBJECT Page 6303 Power BI Report Spinner Part
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Power BI-rapporter;
               ENU=Power BI Reports];
    PageType=CardPart;
    SourceTableTemporary=Yes;
    OnOpenPage=BEGIN
                 IsErrorMessageVisible := FALSE;
                 UpdateContext;

                 // Contextual Power BI FactBox: loading Power BI related user settings
                 SetPowerBIUserConfig.CreateOrReadUserConfigEntry(PowerBIUserConfiguration,LastOpenedReportID,Context);

                 IF NOT TryLoadPart THEN
                   ShowErrorMessage(GETLASTERRORTEXT);

                 // Always call this function after calling TryLoadPart to log exceptions to ActivityLog table
                 PowerBiServiceMgt.LogException(ExceptionMessage,ExceptionDetails);
                 CurrPage.UPDATE;
               END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 8       ;1   ;Action    ;
                      Name=Select Report;
                      CaptionML=[DAN=V‘lg rapport;
                                 ENU=Select Report];
                      ToolTipML=[DAN=V‘lg rapporten.;
                                 ENU=Select the report.];
                      ApplicationArea=#All;
                      Enabled=NOT IsGettingStartedVisible AND NOT IsErrorMessageVisible;
                      Image=SelectChart;
                      OnAction=BEGIN
                                 SelectReports;
                               END;
                                }
      { 4       ;1   ;Action    ;
                      Name=Expand Report;
                      CaptionML=[DAN=Udvid rapport;
                                 ENU=Expand Report];
                      ToolTipML=[DAN=Vis alle oplysninger i rapporten.;
                                 ENU=View all information in the report.];
                      ApplicationArea=#All;
                      Enabled=HasReports AND NOT IsErrorMessageVisible;
                      Image=View;
                      OnAction=VAR
                                 PowerBiReportDialog@1000 : Page 6305;
                               BEGIN
                                 PowerBiReportDialog.SetUrl(GetEmbedUrlWithNavigation,GetMessage);
                                 PowerBiReportDialog.CAPTION(TempPowerBiReportBuffer.ReportName);
                                 PowerBiReportDialog.RUN;
                               END;
                                }
      { 5       ;1   ;Action    ;
                      Name=Previous Report;
                      CaptionML=[DAN=Forrige rapport;
                                 ENU=Previous Report];
                      ToolTipML=[DAN=G† til den forrige rapport.;
                                 ENU=Go to the previous report.];
                      ApplicationArea=#All;
                      Enabled=HasReports AND NOT IsErrorMessageVisible;
                      Image=PreviousSet;
                      OnAction=BEGIN
                                 // need to reset filters or it would load the LastLoadedReport otherwise
                                 TempPowerBiReportBuffer.RESET;
                                 TempPowerBiReportBuffer.SETFILTER(Enabled,'%1',TRUE);
                                 IF TempPowerBiReportBuffer.NEXT(-1) = 0 THEN
                                   TempPowerBiReportBuffer.FINDLAST;

                                 CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
                               END;
                                }
      { 6       ;1   ;Action    ;
                      Name=Next Report;
                      CaptionML=[DAN=N‘ste rapport;
                                 ENU=Next Report];
                      ToolTipML=[DAN=G† til n‘ste rapport.;
                                 ENU=Go to the next report.];
                      ApplicationArea=#All;
                      Enabled=HasReports AND NOT IsErrorMessageVisible;
                      Image=NextSet;
                      OnAction=BEGIN
                                 // need to reset filters or it would load the LastLoadedReport otherwise
                                 TempPowerBiReportBuffer.RESET;
                                 TempPowerBiReportBuffer.SETFILTER(Enabled,'%1',TRUE);
                                 IF TempPowerBiReportBuffer.NEXT = 0 THEN
                                   TempPowerBiReportBuffer.FINDFIRST;

                                 CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
                               END;
                                }
      { 21      ;1   ;Action    ;
                      Name=Refresh;
                      CaptionML=[DAN=Opdater side;
                                 ENU=Refresh Page];
                      ToolTipML=[DAN=Opdater synligt indhold.;
                                 ENU=Refresh the visible content.];
                      ApplicationArea=#All;
                      Enabled=NOT IsGettingStartedVisible;
                      Image=Refresh;
                      OnAction=BEGIN
                                 RefreshPart;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 11  ;1   ;Group     ;
                Visible=NOT IsGettingStartedVisible AND NOT IsErrorMessageVisible AND HasReports;
                GroupType=Group }

    { 2   ;2   ;Field     ;
                Name=WebReportViewer;
                ApplicationArea=#All;
                ControlAddIn=[Microsoft.Dynamics.Nav.Client.WebPageViewer;PublicKeyToken=31bf3856ad364e35] }

    { 15  ;1   ;Group     ;
                GroupType=GridLayout;
                Layout=Columns }

    { 13  ;2   ;Group     ;
                GroupType=Group }

    { 7   ;3   ;Group     ;
                Visible=IsGettingStartedVisible;
                GroupType=Group }

    { 19  ;4   ;Field     ;
                Name=GettingStarted;
                ToolTipML=[DAN=Angiver, at Azure AD-ops‘tningsvinduet †bnes.;
                           ENU="Specifies that the Azure AD setup window opens. "];
                ApplicationArea=#All;
                SourceExpr='Get started with Power BI';
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              IF NOT TryAzureAdMgtGetAccessToken THEN
                                ShowErrorMessage(GETLASTERRORTEXT);
                              IF NOT TryLoadPart THEN
                                ShowErrorMessage(GETLASTERRORTEXT);

                              // Always call this function after calling TryLoadPart to log exceptions to ActivityLog table
                              PowerBiServiceMgt.LogException(ExceptionMessage,ExceptionDetails);
                              CurrPage.UPDATE;
                            END;

                ShowCaption=No }

    { 10  ;3   ;Group     ;
                Visible=IsErrorMessageVisible;
                GroupType=Group }

    { 16  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver fejlmeddelelsen fra Power BI.;
                           ENU=Specifies the error message from Power BI.];
                ApplicationArea=#All;
                SourceExpr=ErrorMessageText;
                Editable=FALSE;
                ShowCaption=No }

    { 14  ;4   ;Field     ;
                ExtendedDatatype=URL;
                ToolTipML=[DAN=Angiver det link, som for†rsagede fejlen.;
                           ENU=Specifies the link that generated the error.];
                ApplicationArea=#All;
                SourceExpr=ErrorUrlText;
                Visible=IsUrlFieldVisible;
                Editable=FALSE;
                ShowCaption=No }

    { 17  ;4   ;Field     ;
                Name=GetReportsLink;
                ToolTipML=[DAN=Angiver rapporterne.;
                           ENU=Specifies the reports.];
                ApplicationArea=#All;
                SourceExpr='Get reports';
                Visible=IsGetReportsVisible;
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              SelectReports;
                            END;

                ShowCaption=No }

    { 12  ;3   ;Group     ;
                Visible=NOT IsGettingStartedVisible AND NOT IsErrorMessageVisible AND NOT HasReports;
                GroupType=Group }

    { 9   ;4   ;Field     ;
                Name=EmptyMessage;
                CaptionML=[DAN=Der er ingen aktiverede rapporter. V‘lg V‘lg rapport for at f† vist en oversigt over de rapporter, du kan f† vist.;
                           ENU=There are no enabled reports. Choose Select Report to see a list of reports that you can display.];
                ToolTipML=[DAN=Angiver, at brugeren har brug for at v‘lge Power BI-rapporter.;
                           ENU=Specifies that the user needs to select Power BI reports.];
                ApplicationArea=#All;
                Editable=FALSE;
                ShowCaption=No }

  }
  CODE
  {
    VAR
      TempPowerBiReportBuffer@1009 : TEMPORARY Record 6302;
      NoReportsAvailableErr@1004 : TextConst 'DAN=Der er ingen rapporter fra Power BI.;ENU=There are no reports available from Power BI.';
      PowerBIUserConfiguration@1013 : Record 6304;
      SetPowerBIUserConfig@1014 : Codeunit 6305;
      ConfPersonalizationMgt@1016 : Codeunit 9170;
      PowerBiServiceMgt@1012 : Codeunit 6301;
      AzureAdMgt@1011 : Codeunit 6300;
      ClientTypeManagement@1077 : Codeunit 4;
      LastOpenedReportID@1015 : GUID;
      Context@1010 : Text[30];
      NameFilter@1008 : Text;
      IsGettingStartedVisible@1007 : Boolean;
      HasReports@1006 : Boolean;
      AddInReady@1005 : Boolean;
      IsErrorMessageVisible@1003 : Boolean;
      ErrorMessageText@1002 : Text;
      IsUrlFieldVisible@1001 : Boolean;
      IsGetReportsVisible@1019 : Boolean;
      ErrorUrlText@1000 : Text;
      ExceptionMessage@1018 : Text;
      ExceptionDetails@1017 : Text;

    LOCAL PROCEDURE GetMessage@1() : Text;
    VAR
      HttpUtility@1000 : DotNet "'System.Web, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Web.HttpUtility";
    BEGIN
      EXIT(
        '{"action":"loadReport","accessToken":"' +
        HttpUtility.JavaScriptStringEncode(AzureAdMgt.GetAccessToken(
            PowerBiServiceMgt.GetPowerBiResourceUrl,PowerBiServiceMgt.GetPowerBiResourceName,FALSE)) + '"}');
    END;

    LOCAL PROCEDURE GetEmbedUrl@2() : Text;
    BEGIN
      IF TempPowerBiReportBuffer.ISEMPTY THEN BEGIN
        // Clear out last opened report if there are no reports to display.
        CLEAR(LastOpenedReportID);
        SetLastOpenedReportID(LastOpenedReportID);
      END ELSE BEGIN
        // update last loaded report
        SetLastOpenedReportID(TempPowerBiReportBuffer.ReportID);
        // Hides both filters and tabs for embedding in small spaces where navigation is unnecessary.
        EXIT(TempPowerBiReportBuffer.EmbedUrl + '&filterPaneEnabled=false&navContentPaneEnabled=false');
      END;
    END;

    LOCAL PROCEDURE GetEmbedUrlWithNavigation@3() : Text;
    BEGIN
      // update last loaded report
      SetLastOpenedReportID(TempPowerBiReportBuffer.ReportID);
      // Hides filters and shows tabs for embedding in large spaces where navigation is necessary.
      EXIT(TempPowerBiReportBuffer.EmbedUrl + '&filterPaneEnabled=false');
    END;

    LOCAL PROCEDURE LoadPart@5();
    BEGIN
      IsGettingStartedVisible := NOT PowerBiServiceMgt.IsUserReadyForPowerBI;

      TempPowerBiReportBuffer.RESET;
      TempPowerBiReportBuffer.DELETEALL;
      IF IsGettingStartedVisible THEN BEGIN
        IF AzureAdMgt.IsSaaS THEN
          ERROR(PowerBiServiceMgt.GetGenericError);

        TempPowerBiReportBuffer.INSERT // Hack to display Get Started link.
      END ELSE BEGIN
        PowerBiServiceMgt.GetReports(TempPowerBiReportBuffer,ExceptionMessage,ExceptionDetails,Context);

        IF TempPowerBiReportBuffer.ISEMPTY THEN
          ERROR(NoReportsAvailableErr);

        RefreshAvailableReports;
      END;
    END;

    LOCAL PROCEDURE RefreshAvailableReports@7();
    BEGIN
      // Filters the report buffer to show the user's selected report onscreen if possible, otherwise defaulting
      // to other enabled reports.
      // (The updated selection will automatically get saved on render - can't save to database here without
      // triggering errors about calling MODIFY during a TryFunction.)
      TempPowerBiReportBuffer.RESET;
      TempPowerBiReportBuffer.SETFILTER(Enabled,'%1',TRUE);
      IF NOT ISNULLGUID(LastOpenedReportID) THEN BEGIN
        TempPowerBiReportBuffer.SETFILTER(ReportID,'%1',LastOpenedReportID);

        IF TempPowerBiReportBuffer.ISEMPTY THEN BEGIN
          // If last selection is invalid, clear it and default to showing the first enabled report.
          CLEAR(LastOpenedReportID);
          RefreshAvailableReports;
        END;
      END;

      HasReports := TempPowerBiReportBuffer.FINDFIRST;
    END;

    LOCAL PROCEDURE RefreshPart@22();
    BEGIN
      // Refreshes content by re-rendering the whole page part - removes any current error message text, and tries to
      // reload the user's list of reports, as if the page just loaded. Used by the Refresh button or when closing the
      // Select Reports page, to make sure we have the most up to date list of reports and aren't stuck in an error state.
      IsErrorMessageVisible := FALSE;
      IsUrlFieldVisible := FALSE;
      IsGetReportsVisible := FALSE;

      IF NOT TryLoadPart THEN
        ShowErrorMessage(GETLASTERRORTEXT);

      // Always call this function after calling TryLoadPart to log exceptions to ActivityLog table
      PowerBiServiceMgt.LogException(ExceptionMessage,ExceptionDetails);
      CurrPage.UPDATE;
    END;

    [External]
    PROCEDURE SetContext@6(ParentContext@1000 : Text[30]);
    BEGIN
      // Sets an ID that tracks which page to show reports for - called by the parent page hosting the part,
      // if possible (see UpdateContext).
      Context := ParentContext;
    END;

    LOCAL PROCEDURE UpdateContext@8();
    VAR
      ConfPersonalizationMgt@1000 : Codeunit 9170;
    BEGIN
      // Automatically sets the parent page ID based on the user's selected role center (role centers can't
      // have codebehind, so they have no other way to set the context for their reports).
      IF Context = '' THEN
        SetContext(ConfPersonalizationMgt.GetCurrentProfileIDNoError);
    END;

    [External]
    PROCEDURE SetNameFilter@9(ParentFilter@1000 : Text);
    BEGIN
      // Sets a text value that tells the selection page how to filter the reports list. This should be called
      // by the parent page hosting this page part, if possible.
      NameFilter := ParentFilter;
    END;

    LOCAL PROCEDURE ShowErrorMessage@4(TextToShow@1000 : Text);
    BEGIN
      // this condition checks if we caught the authorization error that contains a link to Power BI
      // the function divide the error message into simple text and url part
      IF TextToShow = PowerBiServiceMgt.GetUnauthorizedErrorText THEN BEGIN
        IsUrlFieldVisible := TRUE;
        // this message is required to have ':' at the end, but it has '.' instead due to C/AL Localizability requirement
        TextToShow := DELSTR(PowerBiServiceMgt.GetUnauthorizedErrorText,STRLEN(PowerBiServiceMgt.GetUnauthorizedErrorText),1) + ':';
        ErrorUrlText := PowerBiServiceMgt.GetPowerBIUrl;
      END;

      IsGetReportsVisible := (TextToShow = NoReportsAvailableErr);

      IsErrorMessageVisible := TRUE;
      IsGettingStartedVisible := FALSE;
      TempPowerBiReportBuffer.DELETEALL; // Required to avoid one INSERT after another (that will lead to an error)
      IF TextToShow = '' THEN
        TextToShow := PowerBiServiceMgt.GetGenericError;
      ErrorMessageText := TextToShow;
      TempPowerBiReportBuffer.INSERT; // Hack to show the field with the text
      CurrPage.UPDATE;
    END;

    [TryFunction]
    LOCAL PROCEDURE TryLoadPart@11();
    BEGIN
      // Need the try function here to catch any possible internal errors
      LoadPart;
    END;

    [TryFunction]
    LOCAL PROCEDURE TryAzureAdMgtGetAccessToken@33();
    BEGIN
      AzureAdMgt.GetAccessToken(PowerBiServiceMgt.GetPowerBiResourceUrl,PowerBiServiceMgt.GetPowerBiResourceName,TRUE);
    END;

    LOCAL PROCEDURE SetReport@10();
    BEGIN
      IF (ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Phone) AND
         (ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Windows)
      THEN
        CurrPage.WebReportViewer.InitializeIFrame(PowerBiServiceMgt.GetReportPageSize);

      CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
    END;

    PROCEDURE SetLastOpenedReportID@14(LastOpenedReportIDInputValue@1000 : GUID);
    BEGIN
      LastOpenedReportID := LastOpenedReportIDInputValue;
      // filter to find the proper record
      PowerBIUserConfiguration.RESET;
      PowerBIUserConfiguration.SETFILTER("Page ID",'%1',Context);
      PowerBIUserConfiguration.SETFILTER("Profile ID",'%1',ConfPersonalizationMgt.GetCurrentProfileIDNoError);
      PowerBIUserConfiguration.SETFILTER("User Security ID",'%1',USERSECURITYID);

      // update the last loaded report field (the record at this point should already exist bacause it was created OnOpenPage)
      IF NOT PowerBIUserConfiguration.ISEMPTY THEN BEGIN
        PowerBIUserConfiguration."Selected Report ID" := LastOpenedReportID;
        PowerBIUserConfiguration.MODIFY;
        COMMIT;
      END;
    END;

    LOCAL PROCEDURE SelectReports@16();
    VAR
      PowerBIReportSelection@1000 : Page 6304;
    BEGIN
      // Opens the report selection page, then updates the onscreen report depending on the user's
      // subsequent selection and enabled/disabled settings.
      PowerBIReportSelection.SetContext(Context);
      PowerBIReportSelection.SetNameFilter(NameFilter);
      PowerBIReportSelection.LOOKUPMODE(TRUE);

      PowerBIReportSelection.RUNMODAL;
      IF PowerBIReportSelection.IsPageClosedOkay THEN BEGIN
        PowerBIReportSelection.GETRECORD(TempPowerBiReportBuffer);

        IF TempPowerBiReportBuffer.Enabled THEN
          LastOpenedReportID := TempPowerBiReportBuffer.ReportID; // RefreshAvailableReports handles fallback logic on invalid selection.

        RefreshPart;

        IF AddInReady THEN
          CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
        // at this point, NAV will load the web page viewer since HasReports should be true. WebReportViewer::ControlAddInReady will then fire, calling Navigate()
      END;
    END;

    EVENT WebReportViewer@-2::ControlAddInReady@7(callbackUrl@1000 : Text);
    BEGIN
      AddInReady := TRUE;
      IF NOT TempPowerBiReportBuffer.ISEMPTY THEN
        SetReport;
    END;

    EVENT WebReportViewer@-2::DocumentReady@8();
    BEGIN
      IF NOT TempPowerBiReportBuffer.ISEMPTY THEN
        CurrPage.WebReportViewer.PostMessage(GetMessage,'*',FALSE);
    END;

    EVENT WebReportViewer@-2::Callback@9(data@1000 : Text);
    BEGIN
    END;

    EVENT WebReportViewer@-2::Refresh@10(callbackUrl@1000 : Text);
    BEGIN
      IF AddInReady AND NOT TempPowerBiReportBuffer.ISEMPTY THEN
        SetReport;
    END;

    BEGIN
    END.
  }
}

