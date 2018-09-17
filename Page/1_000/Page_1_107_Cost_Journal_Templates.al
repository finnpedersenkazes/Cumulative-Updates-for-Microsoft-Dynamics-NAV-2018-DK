OBJECT Page 1107 Cost Journal Templates
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningskladdetyper;
               ENU=Cost Journal Templates];
    SourceTable=Table1100;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1       ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=Ska&beloner;
                                 ENU=Te&mplates];
                      ActionContainerType=NewDocumentItems;
                      Image=Template }
      { 7       ;2   ;Action    ;
                      CaptionML=[DAN=Navne;
                                 ENU=Batches];
                      ToolTipML=[DAN="èbn listen over kladdenavne for kladdetypen. ";
                                 ENU="Open the list of journal batches for the journal template. "];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1135;
                      RunPageLink=Journal Template Name=FIELD(Name);
                      Promoted=No;
                      Image=Description }
    }
  }
  CONTROLS
  {
    { 3   ;0   ;Container ;
                ContainerType=ContentArea }

    { 4   ;1   ;Group     ;
                GroupType=Repeater }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ omkostningskladdeposten.;
                           ENU=Specifies the name of the cost journal entry.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af omkostningskladdeposten.;
                           ENU=Specifies a description of the cost journal entry.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Ürsagskoden som et supplerende kildespor, der hjëlper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Reason Code" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Source Code" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

