OBJECT Page 1526 Workflow Event Conditions
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=H�ndelsesbetingelser;
               ENU=Event Conditions];
    SourceTable=Table1524;
    DataCaptionExpr=EventDescription;
    PageType=StandardDialog;
    SourceTableTemporary=Yes;
    OnInit=BEGIN
             CurrPage.LOOKUPMODE := TRUE;
           END;

    OnOpenPage=VAR
                 WorkflowStep@1000 : Record 1502;
                 WorkflowEvent@1001 : Record 1520;
               BEGIN
                 WorkflowStep.GET("Workflow Code","Workflow Step ID");
                 WorkflowEvent.GET(WorkflowStep."Function Name");
                 EventDescription := WorkflowEvent.Description;
                 FilterConditionText := WorkflowStep.GetConditionAsDisplayText;
               END;

    OnAfterGetRecord=BEGIN
                       SetField("Field No.");

                       ShowFilter := TRUE;

                       ShowAdvancedCondition := "Field No." <> 0;
                       UpdateLabels;
                     END;

  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 13  ;1   ;Group     ;
                GroupType=Group }

    { 12  ;2   ;Group     ;
                Visible=ShowFilter;
                GroupType=Group;
                InstructionalTextML=[DAN=Angiv h�ndelsesbetingelser:;
                                     ENU=Set conditions for the event:] }

    { 15  ;3   ;Group     ;
                GroupType=GridLayout;
                Layout=Rows }

    { 14  ;4   ;Group     ;
                GroupType=Group }

    { 16  ;5   ;Field     ;
                CaptionML=[DAN=Betingelse;
                           ENU=Condition];
                ToolTipML=[DAN=Angiver workflowh�ndelsesbetingelsen.;
                           ENU=Specifies the workflow event condition.];
                ApplicationArea=#Suite;
                ShowCaption=No }

    { 2   ;5   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=FilterConditionText;
                Editable=FALSE;
                OnAssistEdit=VAR
                               WorkflowStep@1000 : Record 1502;
                             BEGIN
                               WorkflowStep.GET("Workflow Code","Workflow Step ID");

                               WorkflowStep.OpenEventConditions;

                               FilterConditionText := WorkflowStep.GetConditionAsDisplayText;
                             END;

                ShowCaption=No }

    { 11  ;2   ;Group     ;
                GroupType=Group;
                InstructionalTextML=[DAN="";
                                     ENU=""] }

    { 10  ;3   ;Group     ;
                Visible=ShowAdvancedCondition;
                GroupType=Group;
                InstructionalTextML=[DAN=Angiv en betingelse for, n�r en feltv�rdi �ndres:;
                                     ENU=Set a condition for when a field value changes:] }

    { 9   ;4   ;Group     ;
                GroupType=GridLayout;
                Layout=Rows }

    { 7   ;5   ;Group     ;
                GroupType=Group }

    { 8   ;6   ;Field     ;
                CaptionML=[DAN=Felt;
                           ENU=Field];
                ToolTipML=[DAN=Angiver det felt, hvori der kan forekomme en �ndring, som workflowet overv�ger.;
                           ENU=Specifies the field in which a change can occur that the workflow monitors.];
                ApplicationArea=#Suite;
                ShowCaption=No }

    { 6   ;6   ;Field     ;
                DrillDown=No;
                ApplicationArea=#Suite;
                SourceExpr=FieldCaption2;
                OnValidate=VAR
                             Field@1000 : Record 2000000041;
                           BEGIN
                             IF FieldCaption2 = '' THEN BEGIN
                               SetField(0);
                               EXIT;
                             END;

                             IF NOT FindAndFilterToField(Field,FieldCaption2) THEN
                               ERROR(FeildNotExistErr,FieldCaption2);

                             IF Field.COUNT = 1 THEN BEGIN
                               SetField(Field."No.");
                               EXIT;
                             END;

                             IF PAGE.RUNMODAL(PAGE::"Field List",Field) = ACTION::LookupOK THEN
                               SetField(Field."No.")
                             ELSE
                               ERROR(FeildNotExistErr,FieldCaption2);
                           END;

                OnLookup=VAR
                           Field@1002 : Record 2000000041;
                         BEGIN
                           FindAndFilterToField(Field,Text);
                           Field.SETRANGE("Field Caption");
                           Field.SETRANGE("No.");

                           IF PAGE.RUNMODAL(PAGE::"Field List",Field) = ACTION::LookupOK THEN
                             SetField(Field."No.");
                         END;

                ShowCaption=No }

    { 5   ;6   ;Field     ;
                CaptionML=[DAN=er;
                           ENU=is];
                ApplicationArea=#Suite;
                ShowCaption=No }

    { 4   ;6   ;Field     ;
                ToolTipML=[DAN=Angiver den �ndringstype, der kan forekomme i feltet i denne record. I workflowskabelonen Godkendelsesworkflow for �ndring af kreditmaksimum er operatorerne for h�ndelsesbetingelsen For�get, Reduceret, �ndret.;
                           ENU=Specifies the type of change that can occur to the field on the record. In the Change Customer Credit Limit Approval Workflow workflow template, the event condition operators are Increased, Decreased, Changed.];
                ApplicationArea=#Suite;
                SourceExpr=Operator;
                ShowCaption=No }

    { 3   ;3   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=AddChangeValueConditionLbl;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              ShowAdvancedCondition := NOT ShowAdvancedCondition;

                              IF NOT ShowAdvancedCondition THEN
                                ClearRule;

                              UpdateLabels;
                            END;

                ShowCaption=No }

  }
  CODE
  {
    VAR
      FilterConditionText@1000 : Text;
      AddChangeValueConditionLabelTxt@1001 : TextConst 'DAN=Tilf�j en betingelse for, n�r en feltv�rdi �ndres.;ENU=Add a condition for when a field value changes.';
      ShowAdvancedCondition@1002 : Boolean;
      AddChangeValueConditionLbl@1003 : Text;
      FieldCaption2@1004 : Text[250];
      RemoveChangeValueConditionLabelTxt@1005 : TextConst 'DAN=Fjern betingelsen.;ENU=Remove the condition.';
      FeildNotExistErr@1007 : TextConst '@@@="%1 = Field Caption";DAN=Feltet %1 findes ikke.;ENU=Field %1 does not exist.';
      EventDescription@1008 : Text;
      ShowFilter@1009 : Boolean;

    [External]
    PROCEDURE SetRule@10(TempWorkflowRule@1000 : TEMPORARY Record 1524);
    BEGIN
      Rec := TempWorkflowRule;
      INSERT(TRUE);
    END;

    LOCAL PROCEDURE ClearRule@5();
    BEGIN
      SetField(0);
      Operator := Operator::Changed;
    END;

    LOCAL PROCEDURE SetField@54(FieldNo@1000 : Integer);
    BEGIN
      "Field No." := FieldNo;
      CALCFIELDS("Field Caption");
      FieldCaption2 := "Field Caption";
    END;

    LOCAL PROCEDURE FindAndFilterToField@57(VAR Field@1000 : Record 2000000041;CaptionToFind@1001 : Text) : Boolean;
    BEGIN
      Field.FILTERGROUP(2);
      Field.SETRANGE(TableNo,"Table ID");
      Field.SETFILTER(Type,STRSUBSTNO('%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11|%12|%13',
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
          Field.Type::Duration,
          Field.Type::RecordID));
      Field.SETRANGE(Class,Field.Class::Normal);
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);

      IF CaptionToFind = "Field Caption" THEN
        Field.SETRANGE("No.","Field No.")
      ELSE
        Field.SETFILTER("Field Caption",'%1','@' + CaptionToFind + '*');

      EXIT(Field.FINDFIRST);
    END;

    LOCAL PROCEDURE UpdateLabels@6();
    BEGIN
      IF ShowAdvancedCondition THEN
        AddChangeValueConditionLbl := RemoveChangeValueConditionLabelTxt
      ELSE
        AddChangeValueConditionLbl := AddChangeValueConditionLabelTxt;
    END;

    BEGIN
    END.
  }
}

