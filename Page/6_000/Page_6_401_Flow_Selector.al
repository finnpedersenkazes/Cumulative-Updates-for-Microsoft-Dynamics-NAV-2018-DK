OBJECT Page 6401 Flow Selector
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=H�ndter flow;
               ENU=Manage Flows];
    LinksAllowed=No;
    SourceTable=Table467;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Konfiguration;
                                ENU=New,Process,Report,Configuration];
    OnOpenPage=BEGIN
                 IF FlowServiceManagement.IsPPE THEN BEGIN
                   ShowErrorMessage(FlowServiceManagement.GetFlowPPEError);
                   EXIT;
                 END;

                 IsErrorMessageVisible := FALSE;
                 IF NOT TryInitialize THEN
                   ShowErrorMessage(GETLASTERRORTEXT);
                 IF NOT FlowServiceManagement.IsUserReadyForFlow THEN
                   ERROR('');
                 IsUserReadyForFlow := TRUE;

                 IF NOT FlowServiceManagement.HasUserSelectedFlowEnvironment THEN
                   FlowServiceManagement.SetSelectedFlowEnvironmentIDToDefault;

                 IsSaaS := AzureAdMgt.IsSaaS;
               END;

    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 8       ;1   ;Action    ;
                      Name=FlowEntries;
                      CaptionML=[DAN=Flow-poster;
                                 ENU=Flow Entries];
                      ToolTipML=[DAN=F� vist og konfigurer Flow-poster.;
                                 ENU=View and configure Flow entries.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaaS;
                      PromotedIsBig=Yes;
                      Image=Flow;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 WorkflowWebhookEntry@1000 : Record 467;
                               BEGIN
                                 WorkflowWebhookEntry.SetDefaultFilter(WorkflowWebhookEntry);
                                 PAGE.RUN(PAGE::"Workflow Webhook Entries",WorkflowWebhookEntry);
                               END;
                                }
      { 7       ;1   ;Action    ;
                      Name=OpenMyFlows;
                      CaptionML=[DAN=�bn Flow;
                                 ENU=Open Flow];
                      ToolTipML=[DAN=F� vist og konfigurer flow p� Flow-webstedet.;
                                 ENU=View and configure Flows on the Flow website.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Flow;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 HYPERLINK(FlowServiceManagement.GetFlowManageUrl);
                               END;
                                }
      { 9       ;1   ;Action    ;
                      Name=SelectFlowUserEnvironment;
                      CaptionML=[DAN=V�lg milj�;
                                 ENU=Select Environment];
                      ToolTipML=[DAN=V�lg dit Flow-milj�.;
                                 ENU=Select your Flow environment.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CheckList;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 FlowUserEnvironmentConfig@1002 : Record 1545;
                                 TempFlowUserEnvironmentBuffer@1000 : TEMPORARY Record 1544;
                                 FlowUserEnvSelection@1001 : Page 6416;
                               BEGIN
                                 TempFlowUserEnvironmentBuffer.RESET;
                                 FlowServiceManagement.GetEnvironments(TempFlowUserEnvironmentBuffer);
                                 FlowUserEnvSelection.SetFlowEnvironmentBuffer(TempFlowUserEnvironmentBuffer);
                                 FlowUserEnvSelection.LOOKUPMODE(TRUE);

                                 IF FlowUserEnvSelection.RUNMODAL <> ACTION::LookupOK THEN
                                   EXIT;

                                 TempFlowUserEnvironmentBuffer.RESET;
                                 TempFlowUserEnvironmentBuffer.SETRANGE(Enabled,TRUE);

                                 // Remove any previous selection since user did not select anything
                                 IF NOT TempFlowUserEnvironmentBuffer.FINDFIRST THEN BEGIN
                                   IF FlowUserEnvironmentConfig.GET(USERSECURITYID) THEN
                                     FlowUserEnvironmentConfig.DELETE;
                                   EXIT;
                                 END;

                                 FlowServiceManagement.SaveFlowUserEnvironmentSelection(TempFlowUserEnvironmentBuffer);
                                 LoadFlows;
                               END;
                                }
      { 13      ;1   ;Action    ;
                      Name=ConnectionInfo;
                      CaptionML=[DAN=Oplysninger om forbindelse;
                                 ENU=Connection Information];
                      ToolTipML=[DAN=Vis oplysninger vedr�rende oprettelse af forbindelse til Power BI-indholdspakker.;
                                 ENU=Show information for connecting to Power BI content packs.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 6316;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Setup;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                Name=Flow Selector;
                ContainerType=ContentArea }

    { 10  ;1   ;Group     ;
                Visible=IsUserReadyForFlow AND NOT IsErrorMessageVisible;
                GroupType=GridLayout }

    { 11  ;2   ;Field     ;
                Name=EnvironmentNameText;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=EnvironmentNameText;
                ShowCaption=No }

    { 3   ;1   ;Group     ;
                Visible=IsUserReadyForFlow AND NOT IsErrorMessageVisible;
                GroupType=Group }

    { 2   ;2   ;Field     ;
                Name=FlowAddin;
                ApplicationArea=#Basic,#Suite;
                ControlAddIn=[Microsoft.Dynamics.Nav.Client.FlowIntegration;PublicKeyToken=31bf3856ad364e35] }

    { 4   ;1   ;Group     ;
                Visible=IsErrorMessageVisible;
                GroupType=Group }

    { 5   ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ErrorMessageText;
                Editable=False;
                ShowCaption=No }

  }
  CODE
  {
    VAR
      AzureAdMgt@1000 : Codeunit 6300;
      FlowServiceManagement@1001 : Codeunit 6400;
      IsErrorMessageVisible@1002 : Boolean;
      ErrorMessageText@1003 : Text;
      IsUserReadyForFlow@1004 : Boolean;
      AddInReady@1005 : Boolean;
      EnvironmentNameText@1006 : Text;
      IsSaaS@1007 : Boolean;

    LOCAL PROCEDURE Initialize@1();
    BEGIN
      IsUserReadyForFlow := FlowServiceManagement.IsUserReadyForFlow;

      IF NOT IsUserReadyForFlow THEN BEGIN
        IF AzureAdMgt.IsSaaS THEN
          ERROR(FlowServiceManagement.GetGenericError);
        IF NOT TryAzureAdMgtGetAccessToken THEN
          ShowErrorMessage(GETLASTERRORTEXT);
        CurrPage.UPDATE;
      END;
    END;

    LOCAL PROCEDURE LoadFlows@7();
    BEGIN
      EnvironmentNameText := FlowServiceManagement.GetSelectedFlowEnvironmentName;
      CurrPage.FlowAddin.LoadFlows(FlowServiceManagement.GetFlowEnvironmentID);
      CurrPage.UPDATE;
    END;

    [TryFunction]
    LOCAL PROCEDURE TryInitialize@2();
    BEGIN
      Initialize;
    END;

    [TryFunction]
    LOCAL PROCEDURE TryAzureAdMgtGetAccessToken@3();
    BEGIN
      AzureAdMgt.GetAccessToken(FlowServiceManagement.GetFlowARMResourceUrl,FlowServiceManagement.GetFlowResourceName,TRUE);
    END;

    LOCAL PROCEDURE ShowErrorMessage@6(TextToShow@1000 : Text);
    BEGIN
      IsErrorMessageVisible := TRUE;
      IsUserReadyForFlow := FALSE;
      IF TextToShow = '' THEN
        TextToShow := FlowServiceManagement.GetGenericError;
      ErrorMessageText := TextToShow;
      CurrPage.UPDATE;
    END;

    EVENT FlowAddin@-2::ControlAddInReady@3();
    BEGIN
      CurrPage.FlowAddin.Initialize(
        FlowServiceManagement.GetFlowUrl,FlowServiceManagement.GetLocale,
        AzureAdMgt.GetAccessToken(FlowServiceManagement.GetFlowARMResourceUrl,FlowServiceManagement.GetFlowResourceName,FALSE),
        AzureAdMgt.GetAccessToken(FlowServiceManagement.GetFlowGraphResourceUrl,FlowServiceManagement.GetFlowResourceName,FALSE));

      LoadFlows;

      AddInReady := TRUE;
    END;

    EVENT FlowAddin@-2::ErrorOccurred@4(error@1001 : Text;description@1000 : Text);
    VAR
      Company@1002 : Record 2000000006;
      ActivityLog@1003 : Record 710;
    BEGIN
      Company.GET(COMPANYNAME); // Dummy record to attach to activity log
      ActivityLog.LogActivityForUser(
        Company.RECORDID,ActivityLog.Status::Failed,'Microsoft Flow',description,error,USERID);
      ShowErrorMessage(FlowServiceManagement.GetGenericError);
    END;

    EVENT FlowAddin@-2::Refresh@5();
    BEGIN
      IF AddInReady THEN
        LoadFlows;
    END;

    BEGIN
    END.
  }
}

