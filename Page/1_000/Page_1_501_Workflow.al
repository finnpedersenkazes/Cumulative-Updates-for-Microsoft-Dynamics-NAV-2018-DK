OBJECT Page 1501 Workflow
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Workflow;
               ENU=Workflow];
    SourceTable=Table1501;
    PageType=Document;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Flow;
                                ENU=New,Process,Report,Flow];
    OnOpenPage=VAR
                 ApplicationAreaSetup@1000 : Record 9178;
               BEGIN
                 IsNotTemplate := NOT Template;
                 InstancesExist := FALSE;
                 ArchiveExists := FALSE;

                 IF OpenView OR ApplicationAreaSetup.IsBasicOnlyEnabled THEN
                   CurrPage.EDITABLE := FALSE;

                 // Load webhook subscription link when page opens
                 WorkflowWebhookSubscription.SETRANGE(Enabled,TRUE);
                 WorkflowWebhookSubscription.SETRANGE("WF Definition Id",Code);
                 HasWebhookClientLink := WorkflowWebhookSubscription.FINDFIRST;
               END;

    OnClosePage=VAR
                  Workflow@1000 : Record 1501;
                BEGIN
                  IF Workflow.GET THEN
                    Workflow.DELETE;
                END;

    OnAfterGetRecord=VAR
                       WorkflowStepInstance@1000 : Record 1504;
                       WorkflowStepInstanceArchive@1001 : Record 1530;
                     BEGIN
                       IsNotTemplate := NOT Template;
                       WorkflowStepInstance.SETRANGE("Workflow Code",Code);
                       InstancesExist := NOT WorkflowStepInstance.ISEMPTY;

                       WorkflowStepInstanceArchive.SETRANGE("Workflow Code",Code);
                       ArchiveExists := NOT WorkflowStepInstanceArchive.ISEMPTY;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           IF OpenNew THEN
                             CLEAR(Rec);

                           CurrPage.WorkflowResponses.PAGE.UpdateData;
                         END;

    ActionList=ACTIONS
    {
      { 8       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 18      ;1   ;Action    ;
                      Name=ImportWorkflow;
                      CaptionML=[DAN=Indl�s fra fil;
                                 ENU=Import from File];
                      ToolTipML=[DAN=Import�r eksisterende workflow fra en XML-fil.;
                                 ENU=Import an existing workflow from an XML file.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Visible=IsNotTemplate;
                      Enabled=Code <> '';
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 TempBlob@1000 : Record 99008535;
                                 WorkflowImpExpMgt@1007 : Codeunit 1560;
                                 FileManagement@1001 : Codeunit 419;
                               BEGIN
                                 IF FileManagement.BLOBImport(TempBlob,'') = '' THEN
                                   EXIT;

                                 WorkflowImpExpMgt.ReplaceWorkflow(Rec,TempBlob);
                                 CurrPage.WorkflowSubpage.PAGE.RefreshBuffer;
                               END;
                                }
      { 17      ;1   ;Action    ;
                      Name=ExportWorkflow;
                      CaptionML=[DAN=Udl�s til fil;
                                 ENU=Export to File];
                      ToolTipML=[DAN=Eksport�r workflowet til en fil, der kan importeres i en anden Dynamics NAV-database.;
                                 ENU=Export the workflow to a file that can be imported in another Dynamics NAV database.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Visible=IsNotTemplate;
                      Enabled=Code <> '';
                      PromotedIsBig=Yes;
                      Image=Export;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Workflow@1003 : Record 1501;
                                 TempBlob@1001 : Record 99008535;
                                 FileManagement@1002 : Codeunit 419;
                               BEGIN
                                 Workflow.GET(Code);
                                 Workflow.SETRANGE(Code,Code);
                                 Workflow.ExportToBlob(TempBlob);
                                 FileManagement.BLOBExport(TempBlob,'*.xml',TRUE);
                               END;
                                }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Flow;
                                 ENU=Flow] }
      { 14      ;2   ;Action    ;
                      Name=WebhookClientLink;
                      CaptionML=[DAN=Vis;
                                 ENU=View];
                      ToolTipML=[DAN=Vis flowdefinition;
                                 ENU=View Flow Definition];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=HasWebhookClientLink;
                      PromotedIsBig=Yes;
                      Image=Flow;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 WorkflowMgt@1000 : Codeunit 1501;
                               BEGIN
                                 IF NOT WorkflowWebhookSubscription.ISEMPTY THEN
                                   HYPERLINK(WorkflowMgt.GetWebhookClientLink(WorkflowWebhookSubscription."Client Id",WorkflowWebhookSubscription."Client Type"));
                               END;
                                }
      { 12      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 13      ;1   ;Action    ;
                      Name=WorkflowStepInstances;
                      CaptionML=[DAN=Workflowtrininstanser;
                                 ENU=Workflow Step Instances];
                      ToolTipML=[DAN=Vis alle instanser af workflowtrin i aktuelle workflows.;
                                 ENU=Show all instances of workflow steps in current workflows.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Visible=IsNotTemplate;
                      Enabled=InstancesExist;
                      PromotedIsBig=Yes;
                      Image=List;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 WorkflowStepInstances@1000 : Page 1504;
                               BEGIN
                                 WorkflowStepInstances.SetWorkflow(Rec);
                                 WorkflowStepInstances.RUNMODAL;
                               END;
                                }
      { 15      ;1   ;Action    ;
                      Name=ArchivedWorkflowStepInstances;
                      CaptionML=[DAN=Arkiverede workflowtrininstanser;
                                 ENU=Archived Workflow Step Instances];
                      ToolTipML=[DAN=Vis alle instanser af workflowtrin, som ikke l�ngere anvendes, enten fordi de er afsluttet eller arkiveret manuelt.;
                                 ENU=View all instances of workflow steps that are no longer used, either because they are completed or because they were manually archived.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Visible=IsNotTemplate;
                      Enabled=ArchiveExists;
                      PromotedIsBig=Yes;
                      Image=ListPage;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ArchivedWFStepInstances@1000 : Page 1530;
                               BEGIN
                                 ArchivedWFStepInstances.SetWorkflowCode(Code);
                                 ArchivedWFStepInstances.RUNMODAL;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 4   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver workflowet.;
                           ENU=Specifies the workflow.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code;
                Editable=IsNotTemplate;
                OnValidate=BEGIN
                             IF OpenNew THEN BEGIN
                               IF INSERT THEN;
                               CurrPage.UPDATE(FALSE);
                               GET(Code);
                               OpenNew := FALSE;
                             END;
                           END;
                            }

    { 5   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver workflowet.;
                           ENU=Specifies the workflow.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Editable=IsNotTemplate }

    { 16  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken kategori workflowet tilh�rer.;
                           ENU=Specifies the category that the workflow belongs to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Category;
                Editable=IsNotTemplate }

    { 2   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver, at workflowet starter, n�r h�ndelsen i det f�rste startpunkt til workflowtrinnet forekommer.;
                           ENU=Specifies that the workflow will start when the event in the first entry-point workflow step occurs.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Enabled;
                Enabled=IsNotTemplate;
                Editable=IsNotTemplate;
                OnValidate=BEGIN
                             CurrPage.UPDATE;
                           END;
                            }

    { 7   ;1   ;Part      ;
                Name=WorkflowSubpage;
                CaptionML=[DAN=Workflowtrin;
                           ENU=Workflow Steps];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Workflow Code=FIELD(Code);
                PagePartID=Page1502;
                PartType=Page;
                UpdatePropagation=Both }

    { 3   ;    ;Container ;
                ContainerType=FactBoxArea }

    { 6   ;1   ;Part      ;
                Name=WorkflowResponses;
                CaptionML=[DAN=Workflowrespons;
                           ENU=Workflow Responses];
                ApplicationArea=#Suite;
                SubPageLink=Parent Event Step ID=FIELD(Event Step ID),
                            Workflow Code=FIELD(Workflow Code);
                PagePartID=Page1525;
                ProviderID=7;
                PartType=Page }

    { 11  ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

    { 10  ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {
    VAR
      WorkflowWebhookSubscription@1007 : Record 469;
      IsNotTemplate@1000 : Boolean;
      InstancesExist@1001 : Boolean;
      ArchiveExists@1002 : Boolean;
      OpenNew@1003 : Boolean;
      OpenView@1004 : Boolean;
      HasWebhookClientLink@1006 : Boolean;

    [External]
    PROCEDURE SetOpenNew@1(NewOpenNew@1000 : Boolean);
    BEGIN
      OpenNew := NewOpenNew
    END;

    [External]
    PROCEDURE SetOpenView@2(NewOpenView@1000 : Boolean);
    BEGIN
      OpenView := NewOpenView
    END;

    BEGIN
    END.
  }
}

