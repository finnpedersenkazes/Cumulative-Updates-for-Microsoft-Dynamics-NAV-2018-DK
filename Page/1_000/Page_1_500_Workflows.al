OBJECT Page 1500 Workflows
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
    CaptionML=[DAN=Workflows;
               ENU=Workflows];
    SourceTable=Table1500;
    SourceTableView=WHERE(Template=CONST(No));
    PageType=List;
    SourceTableTemporary=Yes;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Administrer,Flow;
                                ENU=New,Process,Report,Manage,Flow];
    OnOpenPage=VAR
                 PermissionManager@1000 : Codeunit 9002;
               BEGIN
                 WorkflowSetup.InitWorkflow;
                 IF NOT WorkflowBufferInitialized THEN
                   InitBufferForWorkflows(Rec);

                 IsSaaS := PermissionManager.SoftwareAsAService;
               END;

    OnAfterGetRecord=VAR
                       WorkflowStep@1000 : Record 1502;
                       WorkflowMgt@1001 : Codeunit 1501;
                     BEGIN
                       RefreshTempWorkflowBuffer;
                       ExportEnabled := NOT ISEMPTY;
                       OnCondition := '';

                       IF "Workflow Code" = '' THEN BEGIN
                         DescriptionStyle := 'Strong';
                         ExternalLinkEnabled := FALSE;
                       END ELSE BEGIN
                         DescriptionStyle := 'Standard';

                         // Enable/disable external links
                         CALCFIELDS("External Client ID");
                         ExternalLinkEnabled := NOT ISNULLGUID("External Client ID");

                         // Create the on condition display
                         WorkflowStep.SETRANGE("Workflow Code","Workflow Code");
                         WorkflowStep.SETRANGE("Entry Point",TRUE);
                         IF WorkflowStep.FINDFIRST THEN
                           OnCondition := WorkflowMgt.BuildConditionDisplay(WorkflowStep);
                       END
                     END;

    OnAfterGetCurrRecord=BEGIN
                           RefreshTempWorkflowBufferRow;
                         END;

    ActionList=ACTIONS
    {
      { 4       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ny;
                                 ENU=New] }
      { 17      ;2   ;Action    ;
                      Name=NewAction;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ToolTipML=[DAN=Opret et nyt workflow.;
                                 ENU=Create a new workflow.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NewDocument;
                      PromotedCategory=New;
                      OnAction=VAR
                                 Workflow@1000 : Record 1501;
                                 WorkflowPage@1001 : Page 1501;
                               BEGIN
                                 IF ISEMPTY THEN BEGIN
                                   CLEAR(Rec);
                                   INSERT;
                                 END;
                                 Workflow.SETRANGE(Template,FALSE);
                                 IF Workflow.ISEMPTY THEN
                                   Workflow.INSERT;
                                 Workflow.FILTERGROUP := 2;
                                 WorkflowPage.SetOpenNew(TRUE);
                                 WorkflowPage.SETTABLEVIEW(Workflow);
                                 WorkflowPage.SETRECORD(Workflow);
                                 WorkflowPage.RUN;
                               END;
                                }
      { 18      ;2   ;Action    ;
                      Name=CopyFromTemplate;
                      CaptionML=[DAN=Ny workflow fra skabelon;
                                 ENU=New Workflow from Template];
                      ToolTipML=[DAN=Opret hurtigt et nyt workflow med en skabelon.;
                                 ENU=Create a new workflow quickly using a template.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Copy;
                      PromotedCategory=New;
                      OnAction=VAR
                                 TempWorkflowBuffer@1000 : TEMPORARY Record 1500;
                               BEGIN
                                 IF ISEMPTY THEN BEGIN
                                   CLEAR(Rec);
                                   INSERT;
                                 END;
                                 IF PAGE.RUNMODAL(PAGE::"Workflow Templates",TempWorkflowBuffer) = ACTION::LookupOK THEN BEGIN
                                   CopyWorkflow(TempWorkflowBuffer);

                                   // If first workflow on an empty page
                                   IF COUNT = 1 THEN
                                     Rec := TempWorkflowBuffer;

                                   RefreshTempWorkflowBuffer;
                                 END;
                               END;
                                }
      { 14      ;2   ;Action    ;
                      Name=CopyWorkflow;
                      CaptionML=[DAN=Kopi�r workflow;
                                 ENU=Copy Workflow];
                      ToolTipML=[DAN=Kopier et eksisterende workflow.;
                                 ENU=Copy an existing workflow.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled="Workflow Code" <> '';
                      PromotedIsBig=Yes;
                      Image=Copy;
                      PromotedCategory=New;
                      OnAction=BEGIN
                                 CopyWorkflow(Rec);
                               END;
                                }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=Administrer;
                                 ENU=Manage] }
      { 10      ;2   ;Action    ;
                      Name=EditAction;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Rediger;
                                 ENU=Edit];
                      ToolTipML=[DAN=Rediger et eksisterende workflow.;
                                 ENU=Edit an existing workflow.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled="Workflow Code" <> '';
                      PromotedIsBig=Yes;
                      Image=Edit;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Workflow@1000 : Record 1501;
                               BEGIN
                                 IF Workflow.GET("Workflow Code") THEN
                                   PAGE.RUN(PAGE::Workflow,Workflow);
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Name=ViewAction;
                      CaptionML=[DAN=Vis;
                                 ENU=View];
                      ToolTipML=[DAN=Se et eksisterende workflow.;
                                 ENU=View an existing workflow.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled="Workflow Code" <> '';
                      PromotedIsBig=Yes;
                      Image=View;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Workflow@1000 : Record 1501;
                                 WorkflowPage@1001 : Page 1501;
                               BEGIN
                                 Workflow.GET("Workflow Code");
                                 WorkflowPage.SETRECORD(Workflow);
                                 WorkflowPage.SetOpenView(TRUE);
                                 WorkflowPage.RUN;
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=DeleteAction;
                      CaptionML=[DAN=Slet;
                                 ENU=Delete];
                      ToolTipML=[DAN=Slet recorden.;
                                 ENU=Delete the record.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled="Workflow Code" <> '';
                      PromotedIsBig=Yes;
                      Image=Delete;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 DELETE(TRUE);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=Proces;
                                 ENU=Process] }
      { 20      ;2   ;Action    ;
                      Name=ImportWorkflow;
                      CaptionML=[DAN=Indl�s fra fil;
                                 ENU=Import from File];
                      ToolTipML=[DAN=Import�r workflow fra en fil.;
                                 ENU=Import workflow from a file.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Workflow@1003 : Record 1501;
                                 TempBlob@1000 : Record 99008535;
                                 FileManagement@1001 : Codeunit 419;
                               BEGIN
                                 IF FileManagement.BLOBImport(TempBlob,'') <> '' THEN BEGIN
                                   Workflow.ImportFromBlob(TempBlob);
                                   RefreshTempWorkflowBuffer;
                                 END;
                               END;
                                }
      { 21      ;2   ;Action    ;
                      Name=ExportWorkflow;
                      CaptionML=[DAN=Udl�s til fil;
                                 ENU=Export to File];
                      ToolTipML=[DAN=Eksport�r workflowet til en fil, der kan importeres i en anden Dynamics NAV-database.;
                                 ENU=Export the workflow to a file that can be imported in another Dynamics NAV database.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=ExportEnabled;
                      PromotedIsBig=Yes;
                      Image=Export;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Workflow@1003 : Record 1501;
                                 TempBlob@1005 : Record 99008535;
                                 FileManagement@1006 : Codeunit 419;
                                 Filter@1004 : Text;
                               BEGIN
                                 Filter := GetFilterFromSelection;
                                 IF Filter = '' THEN
                                   EXIT;
                                 Workflow.SETFILTER(Code,Filter);
                                 Workflow.ExportToBlob(TempBlob);
                                 FileManagement.BLOBExport(TempBlob,'*.xml',TRUE);
                               END;
                                }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=Flow;
                                 ENU=Flow] }
      { 26      ;2   ;Action    ;
                      Name=WebhookClientLink;
                      CaptionML=[DAN=Vis;
                                 ENU=View];
                      ToolTipML=[DAN=Vis flowdefinition;
                                 ENU=View Flow Definition];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaaS;
                      Enabled=ExternalLinkEnabled;
                      PromotedIsBig=Yes;
                      Image=Flow;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=VAR
                                 WorkflowMgt@1001 : Codeunit 1501;
                               BEGIN
                                 CALCFIELDS("External Client Type");
                                 HYPERLINK(WorkflowMgt.GetWebhookClientLink("External Client ID","External Client Type"));
                               END;
                                }
      { 9       ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 16      ;1   ;Action    ;
                      Name=ViewTemplates;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Vis skabeloner;
                                 ENU=View Templates];
                      ToolTipML=[DAN=Se de eksisterende workflowskabeloner.;
                                 ENU=View the existing workflow templates.];
                      ApplicationArea=#Suite;
                      RunObject=Page 1505;
                      Image=ViewPage }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                IndentationColumnName=Indentation;
                IndentationControls=Description;
                ShowAsTree=Yes;
                GroupType=Repeater }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af workflowet.;
                           ENU=Specifies a description of the workflow.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                StyleExpr=DescriptionStyle }

    { 3   ;2   ;Field     ;
                Name=On Condition;
                CaptionML=[DAN=P� betingelse;
                           ENU=On Condition];
                ToolTipML=[DAN=Angiver den betingelse, der modererer workflowh�ndelsen, du har angivet i feltet H�ndelsesbeskrivelse.;
                           ENU=Specifies the condition that moderates the workflow event that you specified in the Event Description field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=OnCondition }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver workflowtypen, f.eks. Administration eller Finans.;
                           ENU=Specifies the workflow type, such as Administration or Finance.];
                ApplicationArea=#Advanced;
                SourceExpr="Category Code";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det workflow, som workflowtrinnet tilh�rer.;
                           ENU=Specifies the workflow that the workflow step belongs to.];
                ApplicationArea=#Advanced;
                SourceExpr="Workflow Code";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om workflowet er aktiveret.;
                           ENU=Specifies if the workflow is enabled.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=Enabled }

    { 6   ;    ;Container ;
                ContainerType=FactBoxArea }

    { 7   ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

    { 8   ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {
    VAR
      WorkflowSetup@1000 : Codeunit 1502;
      DescriptionStyle@1002 : Text;
      ExportEnabled@1001 : Boolean;
      Refresh@1003 : Boolean;
      WorkflowBufferInitialized@1004 : Boolean;
      ExternalLinkEnabled@1005 : Boolean;
      IsSaaS@1008 : Boolean;
      OnCondition@1006 : Text;

    LOCAL PROCEDURE RefreshTempWorkflowBuffer@1();
    VAR
      Workflow@1001 : Record 1501;
      TempWorkflowBuffer@1000 : TEMPORARY Record 1500;
      WorkflowCode@1004 : Code[20];
      CurrentWorkflowChanged@1002 : Boolean;
      WorkflowCountChanged@1003 : Boolean;
    BEGIN
      WorkflowCode := "Workflow Code";
      IF Workflow.GET(WorkflowCode) THEN
        CurrentWorkflowChanged := ("Category Code" <> Workflow.Category) OR (Description <> Workflow.Description)
      ELSE
        CurrentWorkflowChanged := WorkflowCode <> '';

      Workflow.SETRANGE(Template,FALSE);

      TempWorkflowBuffer.COPY(Rec,TRUE);
      TempWorkflowBuffer.RESET;
      TempWorkflowBuffer.SETFILTER("Workflow Code",'<>%1','');
      TempWorkflowBuffer.SETRANGE(Template,FALSE);

      WorkflowCountChanged := Workflow.COUNT <> TempWorkflowBuffer.COUNT;

      IF CurrentWorkflowChanged OR WorkflowCountChanged THEN BEGIN
        InitBufferForWorkflows(Rec);
        Refresh := TRUE;
      END;
    END;

    LOCAL PROCEDURE RefreshTempWorkflowBufferRow@9();
    VAR
      Workflow@1001 : Record 1501;
    BEGIN
      IF Refresh THEN BEGIN
        CurrPage.UPDATE(FALSE);
        Refresh := FALSE;
        EXIT;
      END;

      IF "Workflow Code" = '' THEN
        EXIT;

      Workflow.GET("Workflow Code");
      "Category Code" := Workflow.Category;
      Description := Workflow.Description;
      MODIFY;
    END;

    LOCAL PROCEDURE GetFilterFromSelection@3() Filter : Text;
    VAR
      TempWorkflowBuffer@1000 : TEMPORARY Record 1500;
    BEGIN
      TempWorkflowBuffer.COPY(Rec,TRUE);
      CurrPage.SETSELECTIONFILTER(TempWorkflowBuffer);

      IF TempWorkflowBuffer.FINDSET THEN
        REPEAT
          IF TempWorkflowBuffer."Workflow Code" <> '' THEN
            IF Filter = '' THEN
              Filter := TempWorkflowBuffer."Workflow Code"
            ELSE
              Filter := STRSUBSTNO('%1|%2',Filter,TempWorkflowBuffer."Workflow Code");
        UNTIL TempWorkflowBuffer.NEXT = 0;
    END;

    [External]
    PROCEDURE SetWorkflowBufferRec@2(VAR TempWorkflowBuffer@1000 : TEMPORARY Record 1500);
    BEGIN
      WorkflowBufferInitialized := TRUE;
      InitBufferForWorkflows(Rec);
      COPYFILTERS(TempWorkflowBuffer);
      IF STRLEN(GETFILTER("Workflow Code")) > 0 THEN
        SETFILTER("Workflow Code",TempWorkflowBuffer.GETFILTER("Workflow Code") + '|''''');
      IF FINDLAST THEN;
    END;

    BEGIN
    END.
  }
}

