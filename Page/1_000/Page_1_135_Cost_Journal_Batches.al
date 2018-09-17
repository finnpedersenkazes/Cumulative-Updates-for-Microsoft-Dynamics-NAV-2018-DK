OBJECT Page 1135 Cost Journal Batches
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningskladdenavne;
               ENU=Cost Journal Batches];
    SourceTable=Table1102;
    PageType=List;
    OnInit=BEGIN
             SETRANGE("Journal Template Name");
           END;

    OnOpenPage=BEGIN
                 CostJnlMgt.OpenJnlBatch(Rec);
               END;

    ActionList=ACTIONS
    {
      { 14      ;    ;ActionContainer;
                      Name=<Action1>;
                      ActionContainerType=ActionItems }
      { 3       ;1   ;Action    ;
                      Name=Edit Journal;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Rediger kladde;
                                 ENU=Edit Journal];
                      ToolTipML=[DAN=Aktiv‚r redigering af omkostningskladden.;
                                 ENU=Enable editing of the cost journal.];
                      ApplicationArea=#CostAccounting;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=OpenJournal;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CostJnlMgt.TemplateSelectionFromBatch(Rec);
                               END;
                                }
      { 15      ;1   ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&ost];
                      ToolTipML=[DAN=Bogf›r oplysningerne i kladden til det relaterede omkostningsregister, eksempelvis rene omkostningsposter, interne afgifter mellem omkostningssteder, manuelle fordelinger og korrigerende poster mellem omkostningstyper, omkostningssteder og omkostningsemner.;
                                 ENU=Post information in the journal to the related cost register, such as pure cost entries, internal charges between cost centers, manual allocations, and corrective entries between cost types, cost centers, and cost objects.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Codeunit 1107;
                      Image=PostOrder }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† omkostningskladdek›rslen.;
                           ENU=Specifies the name of the cost journal batch.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Name }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af omkostningskladdek›rslen.;
                           ENU=Specifies a description of the cost journal batch.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Reason Code" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den type, som en udlignende post for kladdelinjen bogf›res til.;
                           ENU=Specifies the number of the type that a balancing entry for the journal line is posted to.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Bal. Cost Type No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det omkostningssted, som en udlignende post for kladdelinjen bogf›res til.;
                           ENU=Specifies the number of the cost center that a balancing entry for the journal line is posted to.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Bal. Cost Center Code" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det omkostningssted, som en udlignende post for kladdelinjen bogf›res til.;
                           ENU=Specifies the number of the cost center that a balancing entry for the journal line is posted to.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Bal. Cost Object Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om de bogf›rte kladdelinjer slettes. Hvis afkrydsningsfeltet ikke er valgt, kan du bruge de bogf›rte kladdelinjer igen. N†r der er bogf›rt, slettes kun bogf›ringsdataene, Du kan bruge indstillingen til m†nedligt tilbagevendende omkostningsposter.;
                           ENU=Specifies if the posted journal lines are deleted. If the check box is not selected, you can use the posted journal lines again. After the posting, only the posting date is deleted. You can use the option for monthly recurring cost entries.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Delete after Posting" }

  }
  CODE
  {
    VAR
      CostJnlMgt@1000 : Codeunit 1106;

    BEGIN
    END.
  }
}

