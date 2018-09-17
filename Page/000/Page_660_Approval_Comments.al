OBJECT Page 660 Approval Comments
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Godkendelsesbem�rkninger;
               ENU=Approval Comments];
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table455;
    DelayedInsert=Yes;
    DataCaptionFields=Record ID to Approve;
    PageType=List;
    OnInsertRecord=BEGIN
                     "Workflow Step Instance ID" := WorkflowStepInstanceID;
                   END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kommentaren. Du kan bruge op til 250 tegn (b�de tal og bogstaver).;
                           ENU=Specifies the comment. You can enter a maximum of 250 characters, both numbers and letters.];
                ApplicationArea=#Suite;
                SourceExpr=Comment }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et p� den bruger, der oprettede denne godkendelsesbem�rkning.;
                           ENU=Specifies the ID of the user who created this approval comment.];
                ApplicationArea=#Suite;
                SourceExpr="User ID" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dato og klokkesl�t for oprettelsen af bem�rkningen.;
                           ENU=Specifies the date and time when the comment was made.];
                ApplicationArea=#Suite;
                SourceExpr="Date and Time" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No.";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      WorkflowStepInstanceID@1000 : GUID;

    PROCEDURE SetWorkflowStepInstanceID@1(NewWorkflowStepInstanceID@1000 : GUID);
    BEGIN
      WorkflowStepInstanceID := NewWorkflowStepInstanceID;
    END;

    BEGIN
    END.
  }
}

