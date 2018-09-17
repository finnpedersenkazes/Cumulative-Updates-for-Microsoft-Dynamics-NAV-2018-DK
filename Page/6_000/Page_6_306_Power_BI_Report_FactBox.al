OBJECT Page 6306 Power BI Report FactBox
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Faktaboks til Power BI-rapport;
               ENU=Power BI Report FactBox];
    PageType=CardPart;
    OnOpenPage=BEGIN
                 IsErrorMessageVisible := FALSE;
                 IsUrlFieldVisible := FALSE;
                 UpdateContext;

                 // create a new Power BI User Configuration table entry or read one if it exist
                 SetPowerBIUserConfig.CreateOrReadUserConfigEntry(PowerBIUserConfiguration,LastOpenedReportID,Context);

                 IF NOT TryLoadPart THEN
                   ShowErrorMessage(GETLASTERRORTEXT);

                 PowerBiServiceMgt.LogException(ExceptionMessage,ExceptionDetails);
                 CurrPage.UPDATE;
               END;

    ActionList=ACTIONS
    {
      { 17      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 16      ;1   ;Action    ;
                      Name=Select Report;
                      CaptionML=[DAN=V�lg rapport;
                                 ENU=Select Report];
                      ToolTipML=[DAN=V�lg rapporten.;
                                 ENU=Select the report.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NOT IsGettingStartedVisible AND NOT IsErrorMessageVisible;
                      Image=SelectChart;
                      OnAction=BEGIN
                                 SelectReports;
                               END;
                                }
      { 15      ;1   ;Action    ;
                      Name=Expand Report;
                      CaptionML=[DAN=Udvid rapport;
                                 ENU=Expand Report];
                      ToolTipML=[DAN=Vis alle oplysninger i rapporten.;
                                 ENU=View all information in the report.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=HasReports AND NOT IsErrorMessageVisible;
                      Image=View;
                      OnAction=VAR
                                 PowerBiReportDialog@1000 : Page 6305;
                               BEGIN
                                 PowerBiReportDialog.SetUrl(GetEmbedUrlWithNavigationWithFilters,GetMessage);
                                 PowerBiReportDialog.CAPTION(TempPowerBiReportBuffer.ReportName);
                                 PowerBiReportDialog.SetFilter(messagefilter,reportfirstpage);
                                 PowerBiReportDialog.RUN;
                               END;
                                }
      { 14      ;1   ;Action    ;
                      Name=Previous Report;
                      CaptionML=[DAN=Forrige rapport;
                                 ENU=Previous Report];
                      ToolTipML=[DAN=G� til den forrige rapport.;
                                 ENU=Go to the previous report.];
                      ApplicationArea=#Basic,#Suite;
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
      { 13      ;1   ;Action    ;
                      Name=Next Report;
                      CaptionML=[DAN=N�ste rapport;
                                 ENU=Next Report];
                      ToolTipML=[DAN=G� til n�ste rapport.;
                                 ENU=Go to the next report.];
                      ApplicationArea=#Basic,#Suite;
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
      { 18      ;1   ;Action    ;
                      Name=Refresh;
                      CaptionML=[DAN=Opdater side;
                                 ENU=Refresh Page];
                      ToolTipML=[DAN=Opdater synligt indhold.;
                                 ENU=Refresh the visible content.];
                      ApplicationArea=#Basic,#Suite;
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
                Name=Control1;
                ContainerType=ContentArea }

    { 3   ;1   ;Group     ;
                Visible=NOT IsGettingStartedVisible AND NOT IsErrorMessageVisible AND HasReports;
                GroupType=Group }

    { 4   ;2   ;Field     ;
                Name=WebReportViewer;
                ApplicationArea=#Basic,#Suite;
                ControlAddIn=[Microsoft.Dynamics.Nav.Client.WebPageViewer;PublicKeyToken=31bf3856ad364e35] }

    { 12  ;1   ;Group     ;
                GroupType=GridLayout;
                Layout=Columns }

    { 11  ;2   ;Group     ;
                GroupType=Group }

    { 10  ;3   ;Group     ;
                Visible=IsGettingStartedVisible;
                GroupType=Group }

    { 9   ;4   ;Field     ;
                Name=GettingStarted;
                ToolTipML=[DAN=Angiver processen til oprettelse af forbindelse til Power BI.;
                           ENU=Specifies the process of connecting to Power BI.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr='Get started with Power BI';
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              IF NOT TryAzureAdMgtGetAccessToken THEN
                                ShowErrorMessage(GETLASTERRORTEXT);
                              IF NOT TryLoadPart THEN
                                ShowErrorMessage(GETLASTERRORTEXT);

                              PowerBiServiceMgt.LogException(ExceptionMessage,ExceptionDetails);
                              CurrPage.UPDATE;
                            END;

                ShowCaption=No }

    { 8   ;3   ;Group     ;
                Visible=IsErrorMessageVisible;
                GroupType=Group }

    { 7   ;4   ;Field     ;
                ToolTipML=[DAN=Angiver fejlmeddelelsen fra Power BI.;
                           ENU=Specifies the error message from Power BI.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ErrorMessageText;
                MultiLine=Yes;
                ShowCaption=No }

    { 19  ;4   ;Field     ;
                Name=ErrorUrlTextField;
                ExtendedDatatype=URL;
                ToolTipML=[DAN=Angiver det link, som for�rsagede fejlen.;
                           ENU=Specifies the link that generated the error.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ErrorUrlText;
                Visible=IsUrlFieldVisible;
                ShowCaption=No }

    { 2   ;4   ;Field     ;
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

    { 6   ;3   ;Group     ;
                Visible=NOT IsGettingStartedVisible AND NOT IsErrorMessageVisible AND NOT HasReports;
                GroupType=Group }

    { 5   ;4   ;Field     ;
                Name=EmptyMessage;
                CaptionML=[DAN=Der er ingen aktiverede rapporter. V�lg V�lg rapport for at f� vist en oversigt over de rapporter, du kan f� vist.;
                           ENU=There are no enabled reports. Choose Select Report to see a list of reports that you can display.];
                ToolTipML=[DAN=Angiver, at brugeren har brug for at v�lge Power BI-rapporter.;
                           ENU=Specifies that the user needs to select Power BI reports.];
                ApplicationArea=#Basic,#Suite;
                Editable=FALSE;
                ShowCaption=No }

  }
  CODE
  {
    VAR
      NoReportsAvailableErr@1011 : TextConst 'DAN=Der er ingen rapporter fra Power BI.;ENU=There are no reports available from Power BI.';
      PowerBIUserConfiguration@1018 : Record 6304;
      TempPowerBiReportBuffer@1015 : TEMPORARY Record 6302;
      PowerBiServiceMgt@1013 : Codeunit 6301;
      AzureAdMgt@1012 : Codeunit 6300;
      ConfPersonalizationMgt@1014 : Codeunit 9170;
      SetPowerBIUserConfig@1017 : Codeunit 6305;
      ClientTypeManagement@1077 : Codeunit 4;
      JObject@1019 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      JObjecttemp@1020 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      LastOpenedReportID@1016 : GUID;
      Context@1010 : Text[30];
      NameFilter@1009 : Text;
      IsGettingStartedVisible@1008 : Boolean;
      HasReports@1007 : Boolean;
      AddInReady@1006 : Boolean;
      IsErrorMessageVisible@1005 : Boolean;
      ErrorMessageText@1004 : Text;
      IsUrlFieldVisible@1002 : Boolean;
      IsGetReportsVisible@1026 : Boolean;
      ErrorUrlText@1001 : Text;
      CurrentListSelection@1000 : Text;
      reportLoadData@1022 : Text;
      IsValueInt@1021 : Boolean;
      ExceptionMessage@1003 : Text;
      ExceptionDetails@1023 : Text;
      messagefilter@1024 : Text;
      reportfirstpage@1025 : Text;

    PROCEDURE SetCurrentListSelection@1(CurrentSelection@1000 : Text;IsValueIntInput@1001 : Boolean);
    BEGIN
      // get the name of the selected element from the corresponding list of the parent page and filter the report
      CurrentListSelection := CurrentSelection;
      IsValueInt := IsValueIntInput;
      GetAndSetReportFilter(reportLoadData);
    END;

    LOCAL PROCEDURE GetMessage@12() : Text;
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
        CurrPage.WebReportViewer.InitializeIFrame('4:3');
      // subscribe to events
      CurrPage.WebReportViewer.SubscribeToEvent('message',GetEmbedUrl);
      CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
    END;

    PROCEDURE SetLastOpenedReportID@14(LastOpenedReportIDInput@1000 : GUID);
    BEGIN
      // update the last loaded report field (the record at this point should already exist bacause it was created OnOpenPage)
      LastOpenedReportID := LastOpenedReportIDInput;
      PowerBIUserConfiguration.RESET;
      PowerBIUserConfiguration.SETFILTER("Page ID",'%1',Context);
      PowerBIUserConfiguration.SETFILTER("User Security ID",'%1',USERSECURITYID);
      PowerBIUserConfiguration.SETFILTER("Profile ID",'%1',ConfPersonalizationMgt.GetCurrentProfileIDNoError);
      IF NOT PowerBIUserConfiguration.ISEMPTY THEN BEGIN
        PowerBIUserConfiguration."Selected Report ID" := LastOpenedReportID;
        PowerBIUserConfiguration.MODIFY;
        COMMIT;
      END;
    END;

    PROCEDURE SetFactBoxVisibility@13(VisibilityInput@1000 : Boolean);
    BEGIN
      PowerBIUserConfiguration.RESET;
      PowerBIUserConfiguration.SETFILTER("Page ID",'%1',Context);
      PowerBIUserConfiguration.SETFILTER("User Security ID",'%1',USERSECURITYID);
      PowerBIUserConfiguration.SETFILTER("Profile ID",'%1',ConfPersonalizationMgt.GetCurrentProfileIDNoError);
      IF NOT PowerBIUserConfiguration.ISEMPTY THEN BEGIN
        PowerBIUserConfiguration."Report Visibility" := VisibilityInput;
        PowerBIUserConfiguration.MODIFY;
      END;
    END;

    PROCEDURE GetAndSetReportFilter@64(VAR data@1000 : Text);
    VAR
      firstpage@1002 : Text;
    BEGIN
      // get all pages of the report
      IF STRPOS(data,'reportPageLoaded') > 0 THEN BEGIN
        CurrPage.WebReportViewer.PostMessage('{"method":"GET","url":"/report/pages","headers":{"id":"getpagesfromreport"}}','*',TRUE);
        EXIT;
      END;

      // navigate to the first page of the report
      IF STRPOS(data,'getpagesfromreport') > 0 THEN BEGIN
        JObject := JObject.Parse(data);
        JObject := JObject.GetValue('body');
        JObject := JObject.First; // get the first (by index) page of the report
        firstpage := FORMAT(JObject.GetValue('name'));
        messagefilter := '{"method":"PUT","url":"/report/pages/active","headers":{"id":"setpage,' + firstpage +
          '"},"body": {"name":"' + firstpage + '","displayName": null}}';
        reportfirstpage := messagefilter;
        CurrPage.WebReportViewer.PostMessage(messagefilter,'*',TRUE);
        EXIT;
      END;

      // find all filters on this page of the report
      IF STRPOS(data,'setpage') > 0 THEN BEGIN
        JObject := JObject.Parse(data);
        JObject := JObject.GetValue('headers');
        firstpage := SELECTSTR(2,FORMAT(JObject.GetValue('id')));
        // messagefilter := '{"method":"GET","url":"/report/pages/' + firstpage + '/filters","headers": {"id":"getfilters,' + firstpage + '"}}'; // page filters
        messagefilter := '{"method":"GET","url":"/report/filters","headers": {"id":"getfilters,' + firstpage + '"}}'; // report filters
        CurrPage.WebReportViewer.PostMessage(messagefilter,'*',TRUE);
        EXIT;
      END;

      // change the filter value to the one received from the corresponding list (only for basic filters)
      IF (STRPOS(data,'getfilters') > 0) AND (STRPOS(data,'schema#basic') > 0) THEN BEGIN
        reportLoadData := data; // save data for filter update on change of selected list element

        JObject := JObject.Parse(data);
        JObjecttemp := JObject.GetValue('headers');
        firstpage := SELECTSTR(2,FORMAT(JObjecttemp.GetValue('id')));
        JObject := JObject.GetValue('body');
        // filter only if there is a filter in the report
        IF JObject.Count > 0 THEN BEGIN
          JObject := JObject.First;
          JObjecttemp := JObject.GetValue('target');

          messagefilter := '{"$schema":"' + FORMAT(JObject.GetValue('$schema')) +
            '","target":{"table":"' + FORMAT(JObjecttemp.GetValue('table')) + '","column":"' +
            FORMAT(JObjecttemp.GetValue('column')) + '"},';
          // filter parameter can be string, then value should be in ""; or it can be an integer, then no "" are required
          IF IsValueInt THEN
            messagefilter := messagefilter + '"operator":"In","values":[' + CurrentListSelection + ']}'
          ELSE
            messagefilter := messagefilter + '"operator":"In","values":["' + CurrentListSelection + '"]}';

          messagefilter := '{"method": "PUT", "url": "/report/filters", "headers": {}, "body": [' +
            messagefilter + '] }';
          CurrPage.WebReportViewer.PostMessage(messagefilter,'*',TRUE);
        END;

        EXIT;
      END;
    END;

    LOCAL PROCEDURE GetEmbedUrlWithNavigationWithFilters@15() : Text;
    BEGIN
      // update last loaded report
      SetLastOpenedReportID(TempPowerBiReportBuffer.ReportID);
      // Shows filters and shows navigation tabs.
      EXIT(TempPowerBiReportBuffer.EmbedUrl);
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

    EVENT WebReportViewer@-4::ControlAddInReady@9(callbackUrl@1000 : Text);
    BEGIN
      AddInReady := TRUE;
      IF NOT TempPowerBiReportBuffer.ISEMPTY THEN
        SetReport;
    END;

    EVENT WebReportViewer@-4::DocumentReady@10();
    BEGIN
      IF NOT TempPowerBiReportBuffer.ISEMPTY THEN
        CurrPage.WebReportViewer.PostMessage(GetMessage,'*',FALSE);
    END;

    EVENT WebReportViewer@-4::Callback@11(data@1000 : Text);
    BEGIN
      GetAndSetReportFilter(data);
    END;

    EVENT WebReportViewer@-4::Refresh@12(callbackUrl@1000 : Text);
    BEGIN
      IF AddInReady AND NOT TempPowerBiReportBuffer.ISEMPTY THEN
        SetReport;
    END;

    EVENT JObject@1019::PropertyChanged@117(sender@1001 : Variant;e@1000 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.ComponentModel.PropertyChangedEventArgs");
    BEGIN
    END;

    EVENT JObject@1019::PropertyChanging@118(sender@1001 : Variant;e@1000 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.ComponentModel.PropertyChangingEventArgs");
    BEGIN
    END;

    EVENT JObject@1019::ListChanged@119(sender@1001 : Variant;e@1000 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.ComponentModel.ListChangedEventArgs");
    BEGIN
    END;

    EVENT JObject@1019::AddingNew@120(sender@1001 : Variant;e@1000 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.ComponentModel.AddingNewEventArgs");
    BEGIN
    END;

    EVENT JObject@1019::CollectionChanged@121(sender@1001 : Variant;e@1000 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Specialized.NotifyCollectionChangedEventArgs");
    BEGIN
    END;

    EVENT JObjecttemp@1020::PropertyChanged@117(sender@1001 : Variant;e@1000 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.ComponentModel.PropertyChangedEventArgs");
    BEGIN
    END;

    EVENT JObjecttemp@1020::PropertyChanging@118(sender@1001 : Variant;e@1000 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.ComponentModel.PropertyChangingEventArgs");
    BEGIN
    END;

    EVENT JObjecttemp@1020::ListChanged@119(sender@1001 : Variant;e@1000 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.ComponentModel.ListChangedEventArgs");
    BEGIN
    END;

    EVENT JObjecttemp@1020::AddingNew@120(sender@1001 : Variant;e@1000 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.ComponentModel.AddingNewEventArgs");
    BEGIN
    END;

    EVENT JObjecttemp@1020::CollectionChanged@121(sender@1001 : Variant;e@1000 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Specialized.NotifyCollectionChangedEventArgs");
    BEGIN
    END;

    BEGIN
    END.
  }
}

