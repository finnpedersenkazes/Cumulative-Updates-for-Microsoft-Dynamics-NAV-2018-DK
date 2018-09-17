OBJECT Page 1505 Workflow Templates
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
    CaptionML=[DAN=Workflowskabeloner;
               ENU=Workflow Templates];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table1500;
    PageType=List;
    SourceTableTemporary=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Administrer;
                                ENU=New,Process,Report,Manage];
    OnOpenPage=BEGIN
                 WorkflowSetup.InitWorkflow;
                 InitBufferForTemplates(Rec);
                 IsLookupMode := CurrPage.LOOKUPMODE;
                 IF FINDFIRST THEN;
               END;

    OnAfterGetRecord=BEGIN
                       IF "Workflow Code" = '' THEN
                         DescriptionStyle := 'Strong'
                       ELSE
                         DescriptionStyle := 'Standard';
                     END;

    OnQueryClosePage=BEGIN
                       IF CurrPage.LOOKUPMODE AND (CloseAction = ACTION::LookupOK) AND ("Workflow Code" = '') THEN
                         ERROR(QueryClosePageLookupErr);
                     END;

    ActionList=ACTIONS
    {
      { 5       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;Action    ;
                      Name=ViewAction;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Vis;
                                 ENU=View];
                      ToolTipML=[DAN=Se en eksisterende workflowskabelon.;
                                 ENU=View an existing workflow template.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=View;
                      PromotedCategory=Category4;
                      RunPageMode=View;
                      OnAction=VAR
                                 Workflow@1000 : Record 1501;
                               BEGIN
                                 Workflow.GET("Workflow Code");
                                 PAGE.RUN(PAGE::Workflow,Workflow);
                               END;
                                }
      { 10      ;1   ;Action    ;
                      Name=New Workflow from Template;
                      CaptionML=[DAN=Ny workflow fra skabelon;
                                 ENU=New Workflow from Template];
                      ToolTipML=[DAN=Opret hurtigt en ny workflowskabelon med en eksisterende workflowskabelon.;
                                 ENU=Create a new workflow template using an existing workflow template.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=NOT IsLookupMode;
                      PromotedIsBig=Yes;
                      Image=NewDocument;
                      PromotedCategory=New;
                      OnAction=BEGIN
                                 CopyWorkflow(Rec)
                               END;
                                }
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

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af workflowskabelonen.;
                           ENU=Specifies a description of the workflow template.];
                ApplicationArea=#Suite;
                SourceExpr=Description;
                StyleExpr=DescriptionStyle }

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
      QueryClosePageLookupErr@1001 : TextConst 'DAN=V‘lg en workflowskabelon for at forts‘tte, eller v‘lg Annuller for at lukke siden.;ENU=Select a workflow template to continue, or choose Cancel to close the page.';
      DescriptionStyle@1003 : Text;
      IsLookupMode@1002 : Boolean;

    BEGIN
    END.
  }
}

