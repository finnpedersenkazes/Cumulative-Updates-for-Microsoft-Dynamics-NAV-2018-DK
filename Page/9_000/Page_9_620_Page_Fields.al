OBJECT Page 9620 Page Fields
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=[DAN=F›j felt til side;
               ENU=Add Field to Page];
    Description=Place fields by dragging from the list to a position on the page.;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table2000000171;
    PageType=List;
    InstructionalTextML=[DAN=Anbring felter ved at tr‘kke fra listen til en position p† siden.;
                         ENU=Place fields by dragging from the list to a position on the page.];
    OnAfterGetRecord=VAR
                       DesignerPageId@1000 : Codeunit 9621;
                     BEGIN
                       FieldPlaced := Status = 1;
                       DesignerPageId.SetPageId("Page ID");
                     END;

    ActionList=ACTIONS
    {
      { 9       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 10      ;1   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Vis;
                                 ENU=View];
                      ToolTipML=;
                      ApplicationArea=#Basic,#Suite;
                      OnAction=BEGIN
                                 // Comment to indicate to the server that this action must be run
                                 // This action is here to override the default behavior of opening the card page with this record
                                 // which is not desired in this case.
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
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den side, der bruges til at vise den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the number of the page that is used to show the journal or worksheet that uses the template.];
                ApplicationArea=#All;
                SourceExpr="Page ID" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for feltet.;
                           ENU=Specifies the ID of the field.];
                ApplicationArea=#All;
                SourceExpr="Field ID" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver felttypen.;
                           ENU=Specifies the type of the field.];
                ApplicationArea=#All;
                SourceExpr=Type }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver feltets l‘ngde.;
                           ENU=Specifies the length of the field.];
                ApplicationArea=#All;
                SourceExpr=Length }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver feltets tekst.;
                           ENU=Specifies the caption of the field.];
                ApplicationArea=#All;
                SourceExpr=Caption }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver feltets status, eksempelvis hvis feltet allerede er placeret p† siden.;
                           ENU=Specifies the field's status, such as if the field is already placed on the page.];
                ApplicationArea=#All;
                SourceExpr=Status;
                Style=Favorable;
                StyleExpr=FieldPlaced }

  }
  CODE
  {
    VAR
      FieldPlaced@1000 : Boolean;

    BEGIN
    END.
  }
}

