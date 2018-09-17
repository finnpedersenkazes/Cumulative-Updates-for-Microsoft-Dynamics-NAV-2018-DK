OBJECT Page 1812 Item Approval WF Setup Wizard
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfiguration af godkendelsesworkflow for vare;
               ENU=Item Approval Workflow Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table1804;
    PageType=NavigatePage;
    SourceTableTemporary=Yes;
    ShowFilter=No;
    OnInit=BEGIN
             IF NOT GET THEN BEGIN
               INIT;
               SetDefaultValues;
               INSERT;
             END;
             LoadTopBanners;
           END;

    OnOpenPage=BEGIN
                 ShowIntroStep;
               END;

    OnQueryClosePage=VAR
                       AssistedSetup@1001 : Record 1803;
                     BEGIN
                       IF CloseAction = ACTION::OK THEN
                         IF AssistedSetup.GetStatus(PAGE::"Item Approval WF Setup Wizard") = AssistedSetup.Status::"Not Completed" THEN
                           IF NOT CONFIRM(NAVNotSetUpQst,FALSE) THEN
                             ERROR('');
                     END;

    ActionList=ACTIONS
    {
      { 8       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 15      ;1   ;Action    ;
                      Name=PreviousPage;
                      CaptionML=[DAN=Tilbage;
                                 ENU=Back];
                      ApplicationArea=#Suite;
                      Enabled=BackEnabled;
                      InFooterBar=Yes;
                      Image=PreviousRecord;
                      OnAction=BEGIN
                                 NextStep(TRUE);
                               END;
                                }
      { 14      ;1   ;Action    ;
                      Name=NextPage;
                      CaptionML=[DAN=N�ste;
                                 ENU=Next];
                      ApplicationArea=#Suite;
                      Enabled=NextEnabled;
                      InFooterBar=Yes;
                      Image=NextRecord;
                      OnAction=BEGIN
                                 NextStep(FALSE);
                               END;
                                }
      { 9       ;1   ;Action    ;
                      Name=Finish;
                      CaptionML=[DAN=Udf�r;
                                 ENU=Finish];
                      ApplicationArea=#Suite;
                      Enabled=FinishEnabled;
                      InFooterBar=Yes;
                      Image=Approve;
                      OnAction=VAR
                                 AssistedSetup@1004 : Record 1803;
                                 ApprovalWorkflowSetupMgt@1001 : Codeunit 1804;
                               BEGIN
                                 ApprovalWorkflowSetupMgt.ApplyItemWizardUserInput(Rec);
                                 AssistedSetup.SetStatus(PAGE::"Item Approval WF Setup Wizard",AssistedSetup.Status::Completed);

                                 CurrPage.CLOSE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 96  ;1   ;Group     ;
                Visible=TopBannerVisible AND NOT DoneVisible;
                Editable=FALSE;
                GroupType=Group }

    { 97  ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=MediaResourcesStandard."Media Reference";
                Editable=FALSE;
                ShowCaption=No }

    { 98  ;1   ;Group     ;
                Visible=TopBannerVisible AND DoneVisible;
                Editable=FALSE;
                GroupType=Group }

    { 99  ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=MediaResourcesDone."Media Reference";
                Editable=FALSE;
                ShowCaption=No }

    { 11  ;1   ;Group     ;
                Name=Step1;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=IntroVisible;
                GroupType=Group }

    { 18  ;2   ;Group     ;
                Name=Para1.1;
                CaptionML=[DAN=Velkommen til Konfiguration af godkendelsesworkflow for vare;
                           ENU=Welcome to Item Approval Workflow Setup];
                GroupType=Group }

    { 19  ;3   ;Group     ;
                Name=Para1.1.1;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Group;
                InstructionalTextML=[DAN=Du kan oprette godkendelsesworkflows, som automatisk underretter en godkender, n�r en bruger fors�ger at oprette eller �ndre et varekort.;
                                     ENU=You can create approval workflows that automatically notify an approver when a user tries to create or change an item card.] }

    { 21  ;2   ;Group     ;
                Name=Para1.2;
                CaptionML=[DAN=Lad os komme i gang!;
                           ENU=Let's go!];
                GroupType=Group;
                InstructionalTextML=[DAN=V�lg N�ste for at angive grundl�ggende indstillinger for godkendelsesworkflows for �ndring af et varekort.;
                                     ENU=Choose Next to specify basic approval workflow settings for changing an item card.] }

    { 67  ;1   ;Group     ;
                Name=Step2;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=ItemApproverSetupVisible;
                GroupType=Group }

    { 5   ;2   ;Group     ;
                Name=Para2.1;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Group }

    { 4   ;3   ;Group     ;
                Name=Para2.1.1;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Group;
                InstructionalTextML=[DAN=V�lg, hvem der er autoriseret til at godkende eller afvise nye eller �ndrede varekort.;
                                     ENU=Choose who is authorized to approve or reject new or changed item cards.] }

    { 2   ;4   ;Field     ;
                CaptionML=[DAN=Godkender;
                           ENU=Approver];
                ApplicationArea=#Suite;
                SourceExpr="Approver ID";
                LookupPageID=Approval User Setup;
                OnValidate=BEGIN
                             CanEnableNext;
                           END;
                            }

    { 66  ;2   ;Group     ;
                Name=Para2.2;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Group }

    { 13  ;3   ;Group     ;
                Name=Para2.2.1;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Group;
                InstructionalTextML=[DAN=V�lg, om godkendelsesprocessen starter automatisk, eller om brugeren skal starte processen.;
                                     ENU=Choose if the approval process starts automatically or if the user must start the process.] }

    { 65  ;3   ;Field     ;
                CaptionML=[DAN=Workflowet starter, n�r;
                           ENU=The workflow starts when];
                ApplicationArea=#Suite;
                SourceExpr="App. Trigger";
                OnValidate=BEGIN
                             CanEnableNext;
                           END;
                            }

    { 12  ;1   ;Group     ;
                Name=Step3;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=ItemAutoAppDetailsVisible;
                GroupType=Group }

    { 62  ;2   ;Group     ;
                Name=Para3.1;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Group;
                InstructionalTextML=[DAN=V�lg kriterier for, hvorn�r godkendelsesprocessen starter automatisk.;
                                     ENU=Choose criteria for when the approval process starts automatically.] }

    { 61  ;3   ;Group     ;
                Name=Para3.1.1;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=GridLayout;
                Layout=Rows }

    { 60  ;4   ;Group     ;
                Name=Para3.1.1.1;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Group;
                InstructionalTextML=[DAN=Workflowet starter, n�r:;
                                     ENU=The workflow starts when:] }

    { 59  ;5   ;Field     ;
                Name=ItemFieldCap;
                CaptionML=[DAN=Felt;
                           ENU=Field];
                ApplicationArea=#Suite;
                SourceExpr=ItemFieldCaption;
                OnValidate=VAR
                             FieldRec@1000 : Record 2000000041;
                           BEGIN
                             IF ItemFieldCaption = '' THEN BEGIN
                               SetItemField(0);
                               EXIT;
                             END;

                             IF NOT FindAndFilterToField(FieldRec,ItemFieldCaption) THEN
                               ERROR(FieldNotExistErr,ItemFieldCaption);

                             IF FieldRec.COUNT = 1 THEN BEGIN
                               SetItemField(FieldRec."No.");
                               EXIT;
                             END;

                             IF PAGE.RUNMODAL(PAGE::"Field List",FieldRec) = ACTION::LookupOK THEN
                               SetItemField(FieldRec."No.")
                             ELSE
                               ERROR(FieldNotExistErr,ItemFieldCaption);
                           END;

                OnLookup=VAR
                           FieldRec@1000 : Record 2000000041;
                         BEGIN
                           FindAndFilterToField(FieldRec,Text);
                           FieldRec.SETRANGE("Field Caption");
                           FieldRec.SETRANGE("No.");

                           IF PAGE.RUNMODAL(PAGE::"Field List",FieldRec) = ACTION::LookupOK THEN
                             SetItemField(FieldRec."No.");
                         END;

                ShowCaption=No }

    { 58  ;5   ;Field     ;
                CaptionML=[DAN=er;
                           ENU=is];
                ApplicationArea=#Suite;
                ShowCaption=No }

    { 57  ;5   ;Field     ;
                CaptionML=[DAN=Operator;
                           ENU=Operator];
                ApplicationArea=#Suite;
                SourceExpr="Field Operator";
                ShowCaption=No }

    { 56  ;3   ;Group     ;
                Name=Para3.1.2;
                CaptionML=[DAN=Angiv den meddelelse, der skal vises, n�r workflowet starter.;
                           ENU=Specify the message to display when the workflow starts.];
                GroupType=Group }

    { 54  ;4   ;Field     ;
                CaptionML=[DAN=Meddelelse;
                           ENU=Message];
                ApplicationArea=#Suite;
                SourceExpr="Custom Message";
                ShowCaption=No }

    { 10  ;1   ;Group     ;
                Name=Step10;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=DoneVisible;
                GroupType=Group }

    { 7   ;2   ;Group     ;
                Name=Para10.1;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Group;
                InstructionalTextML=[DAN=Oversigt over godkendelsesworkflow for vare;
                                     ENU=Item Approval Workflow Overview] }

    { 6   ;3   ;Field     ;
                Name=Overview;
                ApplicationArea=#Suite;
                SourceExpr=SummaryText;
                Editable=FALSE;
                MultiLine=Yes;
                Style=StrongAccent;
                StyleExpr=TRUE;
                ShowCaption=No }

    { 25  ;2   ;Group     ;
                Name=Para10.2;
                CaptionML=[DAN=Det var det hele!;
                           ENU=That's it!];
                GroupType=Group;
                InstructionalTextML=[DAN=V�lg Udf�r for at aktivere workflowet med de angivne indstillinger.;
                                     ENU=Choose Finish to enable the workflow with the specified settings.] }

  }
  CODE
  {
    VAR
      MediaRepositoryStandard@1040 : Record 9400;
      MediaRepositoryDone@1041 : Record 9400;
      MediaResourcesStandard@1005 : Record 2000000182;
      MediaResourcesDone@1003 : Record 2000000182;
      ClientTypeManagement@1009 : Codeunit 4;
      Step@1015 : 'Intro,Item Approver Setup,Automatic Approval Setup,Done';
      BackEnabled@1014 : Boolean;
      NextEnabled@1013 : Boolean;
      FinishEnabled@1010 : Boolean;
      TopBannerVisible@1042 : Boolean;
      IntroVisible@1001 : Boolean;
      ItemApproverSetupVisible@1011 : Boolean;
      ItemAutoAppDetailsVisible@1027 : Boolean;
      DoneVisible@1004 : Boolean;
      NAVNotSetUpQst@1000 : TextConst 'DAN=Varegodkendelse er ikke konfigureret.\\Er du sikker p�, at du vil afslutte?;ENU=Item Approval has not been set up.\\Are you sure that you want to exit?';
      MandatoryApproverErr@1002 : TextConst '@@@="%1 = User Name";DAN=Du skal v�lge en godkender, f�r du kan forts�tte.;ENU=You must select an approver before continuing.';
      ItemFieldCaption@1021 : Text[250];
      FieldNotExistErr@1028 : TextConst '@@@="%1 = Field Caption";DAN=Feltet %1 findes ikke.;ENU=Field %1 does not exist.';
      SummaryText@1006 : Text;
      ManualTriggerTxt@1008 : TextConst '@@@="%1 = User Name (eg. An approval request will be sent to the user Domain/Username when the user sends the request manually.)";DAN=En godkendelsesanmodning vil blive sendt til brugeren %1, n�r brugeren sender anmodningen manuelt.;ENU=An approval request will be sent to the user %1 when the user sends the request manually.';
      AutoTriggerTxt@1007 : TextConst '@@@="%1 = User Name, %2 = Field caption, %3 = Of of this 3 values: Increased, Decreased, Changed (eg. An approval request will be sent to the user Domain/Username when the value in the Credit Limit (LCY) field is Increased.)";DAN=En godkendelsesanmodning vil blive sendt til brugeren %1, n�r v�rdien i feltet for %2 er %3.;ENU=An approval request will be sent to the user %1 when the value in the %2 field is %3.';

    LOCAL PROCEDURE NextStep@3(Backwards@1000 : Boolean);
    BEGIN
      IF Backwards THEN
        Step := Step - 1
      ELSE BEGIN
        IF ItemApproverSetupVisible THEN
          ValidateApprover;
        IF ItemAutoAppDetailsVisible THEN
          ValidateFieldSelection;
        Step := Step + 1;
      END;

      CASE Step OF
        Step::Intro:
          ShowIntroStep;
        Step::"Item Approver Setup":
          ShowApprovalUserSetupDetailsStep;
        Step::"Automatic Approval Setup":
          IF "App. Trigger" = "App. Trigger"::"The user changes a specific field"
          THEN
            ShowItemApprovalDetailsStep
          ELSE
            NextStep(Backwards);
        Step::Done:
          ShowDoneStep;
      END;
      CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE ShowIntroStep@1();
    BEGIN
      ResetWizardControls;
      IntroVisible := TRUE;
      BackEnabled := FALSE;
    END;

    LOCAL PROCEDURE ShowApprovalUserSetupDetailsStep@9();
    BEGIN
      ResetWizardControls;
      ItemApproverSetupVisible := TRUE;
    END;

    LOCAL PROCEDURE ShowItemApprovalDetailsStep@25();
    BEGIN
      ResetWizardControls;
      ItemAutoAppDetailsVisible := TRUE;
      SetItemField(Field);
    END;

    LOCAL PROCEDURE ShowDoneStep@6();
    BEGIN
      ResetWizardControls;
      DoneVisible := TRUE;
      NextEnabled := FALSE;
      FinishEnabled := TRUE;

      IF "App. Trigger" = "App. Trigger"::"The user sends an approval requests manually" THEN
        SummaryText := STRSUBSTNO(ManualTriggerTxt,"Approver ID");
      IF "App. Trigger" = "App. Trigger"::"The user changes a specific field"
      THEN BEGIN
        CALCFIELDS("Field Caption");
        SummaryText := STRSUBSTNO(AutoTriggerTxt,"Approver ID","Field Caption","Field Operator");
      END;

      SummaryText := CONVERTSTR(SummaryText,'\','/');
    END;

    LOCAL PROCEDURE ResetWizardControls@10();
    BEGIN
      // Buttons
      BackEnabled := TRUE;
      NextEnabled := TRUE;
      FinishEnabled := FALSE;

      // Tabs
      IntroVisible := FALSE;
      ItemApproverSetupVisible := FALSE;
      ItemAutoAppDetailsVisible := FALSE;
      DoneVisible := FALSE;
    END;

    LOCAL PROCEDURE SetDefaultValues@8();
    VAR
      Workflow@1000 : Record 1501;
      WorkflowRule@1007 : Record 1524;
      WorkflowStep@1003 : Record 1502;
      WorkflowStepArgument@1006 : Record 1523;
      WorkflowSetup@1002 : Codeunit 1502;
      WorkflowResponseHandling@1005 : Codeunit 1521;
      WorkflowCode@1001 : Code[20];
    BEGIN
      TableNo := DATABASE::Item;
      WorkflowCode := WorkflowSetup.GetWorkflowTemplateCode(WorkflowSetup.ItemUnitPriceChangeApprovalWorkflowCode);
      IF Workflow.GET(WorkflowCode) THEN BEGIN
        WorkflowRule.SETRANGE("Workflow Code",WorkflowCode);
        IF WorkflowRule.FINDFIRST THEN BEGIN
          Field := WorkflowRule."Field No.";
          "Field Operator" := WorkflowRule.Operator;
        END;
        WorkflowStep.SETRANGE("Workflow Code",WorkflowCode);
        WorkflowStep.SETRANGE("Function Name",WorkflowResponseHandling.ShowMessageCode);
        IF WorkflowStep.FINDFIRST THEN BEGIN
          WorkflowStepArgument.GET(WorkflowStep.Argument);
          "Custom Message" := WorkflowStepArgument.Message;
        END;
      END;
    END;

    LOCAL PROCEDURE ValidateApprover@11();
    BEGIN
      IF "Approver ID" = '' THEN
        ERROR(MandatoryApproverErr);
    END;

    LOCAL PROCEDURE ValidateFieldSelection@7();
    BEGIN
    END;

    LOCAL PROCEDURE CanEnableNext@32();
    BEGIN
      NextEnabled := TRUE;
    END;

    LOCAL PROCEDURE SetItemField@54(FieldNo@1000 : Integer);
    BEGIN
      Field := FieldNo;
      CALCFIELDS("Field Caption");
      ItemFieldCaption := "Field Caption";
    END;

    LOCAL PROCEDURE FindAndFilterToField@57(VAR FieldRec@1000 : Record 2000000041;CaptionToFind@1001 : Text) : Boolean;
    BEGIN
      FieldRec.FILTERGROUP(2);
      FieldRec.SETRANGE(TableNo,DATABASE::Item);
      FieldRec.SETFILTER(Type,STRSUBSTNO('%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11|%12|%13',
          FieldRec.Type::Boolean,
          FieldRec.Type::Text,
          FieldRec.Type::Code,
          FieldRec.Type::Decimal,
          FieldRec.Type::Integer,
          FieldRec.Type::BigInteger,
          FieldRec.Type::Date,
          FieldRec.Type::Time,
          FieldRec.Type::DateTime,
          FieldRec.Type::DateFormula,
          FieldRec.Type::Option,
          FieldRec.Type::Duration,
          FieldRec.Type::RecordID));
      FieldRec.SETRANGE(Class,FieldRec.Class::Normal);
      FieldRec.SETFILTER(ObsoleteState,'<>%1',FieldRec.ObsoleteState::Removed);

      IF CaptionToFind = "Field Caption" THEN
        FieldRec.SETRANGE("No.",Field)
      ELSE
        FieldRec.SETFILTER("Field Caption",'%1','@' + CaptionToFind + '*');

      EXIT(FieldRec.FINDFIRST);
    END;

    LOCAL PROCEDURE LoadTopBanners@40();
    BEGIN
      IF MediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png',FORMAT(ClientTypeManagement.GetCurrentClientType)) AND
         MediaRepositoryDone.GET('AssistedSetupDone-NoText-400px.png',FORMAT(ClientTypeManagement.GetCurrentClientType))
      THEN
        IF MediaResourcesStandard.GET(MediaRepositoryStandard."Media Resources Ref") AND
           MediaResourcesDone.GET(MediaRepositoryDone."Media Resources Ref")
        THEN
          TopBannerVisible := MediaResourcesDone."Media Reference".HASVALUE;
    END;

    BEGIN
    END.
  }
}

