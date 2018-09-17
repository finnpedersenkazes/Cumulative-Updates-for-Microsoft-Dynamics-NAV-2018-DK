OBJECT Page 1523 Workflow Response Options
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Indstillinger for workflowrespons;
               ENU=Workflow Response Options];
    SourceTable=Table1523;
    PageType=CardPart;
    ShowFilter=No;
    OnOpenPage=VAR
                 ApprovalUserSetup@1000 : Page 663;
               BEGIN
                 NoArguments := NoArgumentsTxt;
                 ApprovalUserSetupLabel := STRSUBSTNO(OpenPageTxt,ApprovalUserSetup.CAPTION);
                 HideExternalUsers;
               END;

    OnFindRecord=BEGIN
                   EXIT(FIND(Which));
                 END;

    OnAfterGetRecord=BEGIN
                       SetVisibilityOptions;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           SetVisibilityOptions;
                           GetEventTable;
                           CALCFIELDS("Field Caption");
                           TableFieldCaption := "Field Caption";
                           ApplyAllValues := ("Field No." = 0);
                         END;

  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                Name=Set Up Arguments;
                ContainerType=ContentArea }

    { 5   ;1   ;Group     ;
                GroupType=Group }

    { 14  ;2   ;Group     ;
                Visible="Response Option Group" = 'GROUP 0';
                GroupType=Group }

    { 16  ;3   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=NoArguments;
                Editable=FALSE;
                ShowCaption=No }

    { 7   ;2   ;Group     ;
                Visible="Response Option Group" = 'GROUP 1';
                GroupType=Group }

    { 2   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den finanskladdetype, der anvendes til dette argument i workflowtrin.;
                           ENU=Specifies the name of the general journal template that is used for this workflow step argument.];
                ApplicationArea=#Suite;
                SourceExpr="General Journal Template Name";
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE)
                           END;

                ShowMandatory=True }

    { 3   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den finanskladdekõrsel, der anvendes til dette argument i workflowtrin.;
                           ENU=Specifies the name of the general journal batch that is used for this workflow step argument.];
                ApplicationArea=#Suite;
                SourceExpr="General Journal Batch Name";
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE)
                           END;

                ShowMandatory=True }

    { 8   ;2   ;Group     ;
                Visible="Response Option Group" = 'GROUP 2';
                GroupType=Group }

    { 9   ;3   ;Field     ;
                Name=Link Target Page Approvals;
                CaptionML=[DAN=Side, der linkes til;
                           ENU=Link Target Page];
                ToolTipML=[DAN=Angiver en specifik side, der Übnes, nÜr en bruger vëlger linket i en notifikation. Hvis feltet ikke udfyldes, Übner siden, der viser den tilknyttede record.;
                           ENU=Specifies a specific page that opens when a user chooses the link in a notification. If you do not fill this field, the page showing the involved record will open.];
                ApplicationArea=#Suite;
                SourceExpr="Link Target Page" }

    { 15  ;3   ;Field     ;
                Name=Custom Link Approvals;
                CaptionML=[DAN=Brugerdefineret link;
                           ENU=Custom Link];
                ToolTipML=[DAN=Angiver et link, der indsëttes i notifikationen for at oprette et link til en brugerdefineret placering.;
                           ENU=Specifies a link that is inserted in the notification to link to a custom location.];
                ApplicationArea=#Suite;
                SourceExpr="Custom Link" }

    { 23  ;2   ;Group     ;
                Visible="Response Option Group" = 'GROUP 3';
                GroupType=Group }

    { 22  ;3   ;Field     ;
                CaptionML=[DAN=Modtagers bruger-id;
                           ENU=Recipient User ID];
                ToolTipML=[DAN=Angiver id'et pÜ den bruger, der notificeres i forbindelse med dette argument i workflowtrin.;
                           ENU=Specifies the ID of the user that will be notified in connection with this workflow step argument.];
                ApplicationArea=#Suite;
                SourceExpr="Notification User ID";
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE)
                           END;

                ShowMandatory=True }

    { 20  ;3   ;Field     ;
                CaptionML=[DAN=Side, der linkes til;
                           ENU=Link Target Page];
                ToolTipML=[DAN=Angiver en specifik side, der Übnes, nÜr en bruger vëlger linket i en notifikation. Hvis feltet ikke udfyldes, Übner siden, der viser den tilknyttede record.;
                           ENU=Specifies a specific page that opens when a user chooses the link in a notification. If you do not fill this field, the page showing the involved record will open.];
                ApplicationArea=#Suite;
                SourceExpr="Link Target Page" }

    { 19  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver et link, der indsëttes i notifikationen for at oprette et link til en brugerdefineret placering.;
                           ENU=Specifies a link that is inserted in the notification to link to a custom location.];
                ApplicationArea=#Suite;
                SourceExpr="Custom Link" }

    { 6   ;2   ;Group     ;
                Visible="Response Option Group" = 'GROUP 4';
                GroupType=Group }

    { 17  ;3   ;Field     ;
                Name=MessageField;
                CaptionML=[DAN=Meddelelse;
                           ENU=Message];
                ToolTipML=[DAN=Angiver den meddelelse, der vises som et svar.;
                           ENU=Specifies the message that will be shown as a response.];
                ApplicationArea=#Suite;
                SourceExpr=Message;
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE)
                           END;
                            }

    { 10  ;2   ;Group     ;
                Visible="Response Option Group" = 'GROUP 5';
                GroupType=Group }

    { 25  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, at bekrëftelsesmeddelelsen vises for brugerne, efter at de anmoder om en godkendelse.;
                           ENU=Specifies that a confirmation message is shown to users after they request an approval.];
                ApplicationArea=#Suite;
                SourceExpr="Show Confirmation Message" }

    { 24  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver. hvor mange dage, der skal gÜ, fõr godkendelsesanmodningen er lõst fra den dato, den blev afsendt.;
                           ENU=Specifies in how many days the approval request must be resolved from the date when it was sent.];
                ApplicationArea=#Suite;
                SourceExpr="Due Date Formula" }

    { 21  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om og hvornÜr en godkendelsesanmodning automatisk bliver uddelegeret til den relevante stedfortrëder. Du kan vëlge at uddelegere automatisk Çn, to eller fem dage, efter den dato, hvor der blev anmodet om godkendelsen.;
                           ENU=Specifies if and when an approval request will automatically be delegated to the relevant substitute. You can select to automatically delegate one, two, or five days after the date when the approval was requested.];
                ApplicationArea=#Suite;
                SourceExpr="Delegate After" }

    { 11  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvem der fõrst blev notificeret om godkendelsesanmodningen.;
                           ENU=Specifies who is notified first about approval requests.];
                ApplicationArea=#Suite;
                SourceExpr="Approver Type";
                OnValidate=BEGIN
                             SetVisibilityOptions;
                             CurrPage.UPDATE(TRUE)
                           END;
                            }

    { 4   ;3   ;Group     ;
                Visible=ShowApprovalLimitType;
                GroupType=Group }

    { 12  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan godkenderes godkendelsesgrënse pÜvirkes, nÜr godkendelsesanmodningsposterne oprettes for dem. En kvalificeret godkender er en godkender, hvor godkendelsesgrënsen overstiger vërdien i godkendelsesanmodningen.;
                           ENU=Specifies how approvers' approval limits affect when approval request entries are created for them. A qualified approver is an approver whose approval limit is above the value on the approval request.];
                ApplicationArea=#Suite;
                SourceExpr="Approver Limit Type";
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE)
                           END;
                            }

    { 18  ;3   ;Group     ;
                Visible=NOT ShowApprovalLimitType;
                GroupType=Group }

    { 13  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den workflowbrugergruppe, der anvendes i forbindelse med dette argument i workflowtrinnet.;
                           ENU=Specifies the workflow user group that is used in connection with this workflow step argument.];
                ApplicationArea=#Suite;
                SourceExpr="Workflow User Group Code";
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE)
                           END;

                ShowMandatory=True }

    { 34  ;3   ;Group     ;
                Visible=ShowApproverUserId;
                GroupType=Group }

    { 33  ;4   ;Field     ;
                Name=ApproverId;
                CaptionML=[DAN=Godkender-id;
                           ENU=Approver ID];
                ToolTipML=[DAN=Angiver godkenderen.;
                           ENU=Specifies the approver.];
                ApplicationArea=#Suite;
                SourceExpr="Approver User ID";
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE)
                           END;

                ShowMandatory=True }

    { 26  ;3   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ApprovalUserSetupLabel;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              PAGE.RUNMODAL(PAGE::"Approval User Setup");
                            END;

                ShowCaption=No }

    { 27  ;2   ;Group     ;
                Visible="Response Option Group" = 'GROUP 6';
                GroupType=Group }

    { 28  ;3   ;Field     ;
                Name=TableFieldRevert;
                CaptionML=[DAN=Felt;
                           ENU=Field];
                ToolTipML=[DAN=Angiver det felt, hvori der kan forekomme en ëndring, som workflowet overvÜger.;
                           ENU=Specifies the field in which a change can occur that the workflow monitors.];
                ApplicationArea=#Suite;
                SourceExpr=TableFieldCaption;
                OnValidate=BEGIN
                             ValidateFieldCaption;
                           END;

                OnLookup=BEGIN
                           GetEventTable;
                           Text := LookupFieldCaption(FORMAT("Table No."),'');
                           EXIT(Text <> '')
                         END;

                ShowMandatory=True }

    { 29  ;2   ;Group     ;
                Visible="Response Option Group" = 'GROUP 7';
                GroupType=Group }

    { 31  ;3   ;Field     ;
                Name=ApplyAllValues;
                CaptionML=[DAN=Anvend alle nye vërdier;
                           ENU=Apply All New Values];
                ToolTipML=[DAN=Angiver, at alle de nye, godkendte vërdier udlignes med recorden.;
                           ENU=Specifies that all the new, approved values will be applied to the record.];
                ApplicationArea=#Suite;
                SourceExpr=ApplyAllValues;
                OnValidate=BEGIN
                             IF ApplyAllValues THEN BEGIN
                               "Table No." := 0;
                               "Field No." := 0;
                               CurrPage.UPDATE(TRUE);
                             END;
                           END;
                            }

    { 32  ;3   ;Group     ;
                Visible=NOT ApplyAllValues;
                GroupType=Group }

    { 30  ;4   ;Field     ;
                Name=TableFieldApply;
                CaptionML=[DAN=Felt;
                           ENU=Field];
                ToolTipML=[DAN=Angiver det felt, hvori der kan forekomme en ëndring, som workflowet overvÜger.;
                           ENU=Specifies the field in which a change can occur that the workflow monitors.];
                ApplicationArea=#Suite;
                SourceExpr=TableFieldCaption;
                OnValidate=BEGIN
                             ValidateFieldCaption;
                           END;

                OnLookup=BEGIN
                           Text := LookupFieldCaptionForApplyNewValues;
                           EXIT(Text <> '')
                         END;

                ShowMandatory=TRUE }

    { 35  ;2   ;Group     ;
                Visible="Response Option Group" = 'GROUP 8';
                GroupType=Group }

    { 36  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver svartypen for workflowresponsen. Du kan ikke angive indstillinger for denne.;
                           ENU=Specifies the response type for the workflow response. You cannot set options for this.];
                ApplicationArea=#Suite;
                SourceExpr="Response Type";
                OnValidate=BEGIN
                             SetVisibilityOptions;
                             CurrPage.UPDATE(TRUE)
                           END;
                            }

    { 37  ;3   ;Group     ;
                Visible=ShowResponseUserID;
                GroupType=Group }

    { 38  ;4   ;Field     ;
                Name=ResponseUserId;
                CaptionML=[DAN=Id for svarbruger;
                           ENU=Response User ID];
                ToolTipML=[DAN=Angiver den bruger, der er nõdvendig for et acceptabelt svar.;
                           ENU=Specifies the user necessary for an acceptable response.];
                ApplicationArea=#Suite;
                SourceExpr="Response User ID";
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE);
                           END;

                ShowMandatory=True }

  }
  CODE
  {
    VAR
      NoArguments@1003 : Text;
      NoArgumentsTxt@1000 : TextConst 'DAN=Du kan ikke angive indstillinger for denne workflowrespons.;ENU=You cannot set options for this workflow response.';
      ShowApprovalLimitType@1001 : Boolean;
      ShowApproverUserId@1004 : Boolean;
      ApprovalUserSetupLabel@1005 : Text;
      OpenPageTxt@1007 : TextConst '@@@=%1 is the page that will be opened when clicking the control;DAN=èbn %1;ENU=Open %1';
      TableFieldCaption@1009 : Text;
      ApplyAllValues@1002 : Boolean;
      ShowResponseUserID@1006 : Boolean;

    LOCAL PROCEDURE GetEventTable@1();
    VAR
      WorkflowStep@1001 : Record 1502;
      WorkflowStepEvent@1002 : Record 1502;
      WorkflowEvent@1000 : Record 1520;
    BEGIN
      WorkflowStep.SETRANGE(Argument,ID);
      IF WorkflowStep.FINDFIRST THEN
        IF WorkflowStep.HasParentEvent(WorkflowStepEvent) THEN BEGIN
          WorkflowEvent.GET(WorkflowStepEvent."Function Name");
          "Table No." := WorkflowEvent."Table ID";
        END;
    END;

    LOCAL PROCEDURE SetVisibilityOptions@2();
    BEGIN
      CALCFIELDS("Response Option Group");
      ShowApprovalLimitType := "Approver Type" <> "Approver Type"::"Workflow User Group";
      ShowApproverUserId := ShowApprovalLimitType AND ("Approver Limit Type" = "Approver Limit Type"::"Specific Approver");
      ShowResponseUserID := "Response Type" = "Response Type"::"User ID";
    END;

    LOCAL PROCEDURE LookupFieldCaption@4(TableNoFilter@1001 : Text;FieldNoFilter@1002 : Text) : Text;
    VAR
      Field@1000 : Record 2000000041;
    BEGIN
      Field.FILTERGROUP(2);
      Field.SETFILTER(Type,STRSUBSTNO('%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11|%12',
          Field.Type::Boolean,
          Field.Type::Text,
          Field.Type::Code,
          Field.Type::Decimal,
          Field.Type::Integer,
          Field.Type::BigInteger,
          Field.Type::Date,
          Field.Type::Time,
          Field.Type::DateTime,
          Field.Type::DateFormula,
          Field.Type::Option,
          Field.Type::Duration));
      Field.SETRANGE(Class,Field.Class::Normal);

      Field.SETFILTER(TableNo,TableNoFilter);
      Field.SETFILTER("No.",FieldNoFilter);
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      Field.TableNo := "Table No.";
      Field."No." := "Field No.";
      IF PAGE.RUNMODAL(PAGE::"Field List",Field) = ACTION::LookupOK THEN BEGIN
        "Table No." := Field.TableNo;
        EXIT(Field."Field Caption");
      END;
      EXIT('');
    END;

    LOCAL PROCEDURE LookupFieldCaptionForApplyNewValues@17() : Text;
    VAR
      WorkflowStepApply@1001 : Record 1502;
      WorkflowStepRevert@1000 : Record 1502;
      WorkflowStepArgument@1004 : Record 1523;
      WorkflowResponseHandling@1002 : Codeunit 1521;
      FilterForField@1003 : Text;
      FilterForTable@1005 : Text;
      Separator@1007 : Text[1];
      AddSeparator@1006 : Boolean;
    BEGIN
      WorkflowStepApply.SETRANGE(Argument,ID);
      IF WorkflowStepApply.FINDFIRST THEN BEGIN
        WorkflowStepRevert.SETRANGE("Workflow Code",WorkflowStepApply."Workflow Code");
        WorkflowStepRevert.SETRANGE("Function Name",WorkflowResponseHandling.RevertValueForFieldCode);

        IF WorkflowStepRevert.FINDSET THEN
          REPEAT
            WorkflowStepArgument.GET(WorkflowStepRevert.Argument);
            IF WorkflowStepArgument."Field No." <> 0 THEN BEGIN
              IF AddSeparator THEN
                Separator := '|';
              AddSeparator := TRUE;
              FilterForTable += Separator + FORMAT(WorkflowStepArgument."Table No.");
              FilterForField += Separator + FORMAT(WorkflowStepArgument."Field No.");
            END;
          UNTIL WorkflowStepRevert.NEXT = 0;

        EXIT(LookupFieldCaption(FilterForTable,FilterForField));
      END;
      EXIT('');
    END;

    LOCAL PROCEDURE ValidateFieldCaption@5();
    VAR
      Field@1000 : Record 2000000041;
    BEGIN
      IF TableFieldCaption <> '' THEN BEGIN
        Field.SETRANGE(TableNo,"Table No.");
        Field.SETRANGE("Field Caption",TableFieldCaption);
        Field.FINDFIRST;
        "Field No." := Field."No."
      END ELSE
        "Field No." := 0;

      CurrPage.UPDATE(TRUE);
    END;

    BEGIN
    END.
  }
}

