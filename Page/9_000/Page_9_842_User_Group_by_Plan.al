OBJECT Page 9842 User Group by Plan
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
    CaptionML=[DAN=Brugergruppe efter plan;
               ENU=User Group by Plan];
    LinksAllowed=No;
    SourceTable=Table9000;
    PageType=Worksheet;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,S›g;
                                ENU=New,Process,Report,Browse];
    ShowFilter=No;
    OnOpenPage=VAR
                 Plan@1000 : Record 9004;
               BEGIN
                 SelectedCompany := COMPANYNAME;
                 NoOfPlans := Plan.COUNT;
                 PermissionPagesMgt.Init(NoOfPlans,ARRAYLEN(PlanNameArray));
               END;

    OnAfterGetRecord=BEGIN
                       GetUserGroupPlanParameters;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           GetUserGroupPlanParameters;
                         END;

    ActionList=ACTIONS
    {
      { 9       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 24  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 23  ;2   ;Field     ;
                Name=SelectedCompany;
                CaptionML=[DAN=Firmanavn;
                           ENU=Company Name];
                ToolTipML=[DAN=Angiver virksomheden.;
                           ENU=Specifies the company.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SelectedCompany;
                TableRelation=Company;
                OnValidate=BEGIN
                             Company.Name := SelectedCompany;
                             IF SelectedCompany <> '' THEN BEGIN
                               Company.FIND('=<>');
                               SelectedCompany := Company.Name;
                             END;
                             CurrPage.UPDATE(FALSE);
                           END;
                            }

    { 2   ;1   ;Group     ;
                Name=Group;
                CaptionML=[DAN=Rettighedss‘t;
                           ENU=Permission Set];
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Brugergruppekode;
                           ENU=User Group Code];
                ToolTipML=[DAN=Angiver en brugergruppe.;
                           ENU=Specifies a user group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Brugergruppenavn;
                           ENU=User Group Name];
                ToolTipML=[DAN=Angiver brugergruppens navn.;
                           ENU=Specifies the name of a user group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 11  ;2   ;Field     ;
                Name=Column1;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne abonnementsplan.;
                           ENU=Specifies if the user is a member of this subscription plan.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfPlan[1];
                CaptionClass='3,' + PlanNameArray[1];
                Visible=NoOfPlans >= 1 }

    { 12  ;2   ;Field     ;
                Name=Column2;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne abonnementsplan.;
                           ENU=Specifies if the user is a member of this subscription plan.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfPlan[2];
                CaptionClass='3,' + PlanNameArray[2];
                Visible=NoOfPlans >= 2 }

    { 13  ;2   ;Field     ;
                Name=Column3;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne abonnementsplan.;
                           ENU=Specifies if the user is a member of this subscription plan.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfPlan[3];
                CaptionClass='3,' + PlanNameArray[3];
                Visible=NoOfPlans >= 3 }

    { 14  ;2   ;Field     ;
                Name=Column4;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne abonnementsplan.;
                           ENU=Specifies if the user is a member of this subscription plan.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfPlan[4];
                CaptionClass='3,' + PlanNameArray[4];
                Visible=NoOfPlans >= 4 }

    { 5   ;2   ;Field     ;
                Name=Column5;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne abonnementsplan.;
                           ENU=Specifies if the user is a member of this subscription plan.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfPlan[5];
                CaptionClass='3,' + PlanNameArray[5];
                Visible=NoOfPlans >= 5 }

    { 17  ;2   ;Field     ;
                Name=Column6;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne abonnementsplan.;
                           ENU=Specifies if the user is a member of this subscription plan.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfPlan[6];
                CaptionClass='3,' + PlanNameArray[6];
                Visible=NoOfPlans >= 6 }

    { 18  ;2   ;Field     ;
                Name=Column7;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne abonnementsplan.;
                           ENU=Specifies if the user is a member of this subscription plan.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfPlan[7];
                CaptionClass='3,' + PlanNameArray[7];
                Visible=NoOfPlans >= 7 }

    { 19  ;2   ;Field     ;
                Name=Column8;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne abonnementsplan.;
                           ENU=Specifies if the user is a member of this subscription plan.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfPlan[8];
                CaptionClass='3,' + PlanNameArray[8];
                Visible=NoOfPlans >= 8 }

    { 20  ;2   ;Field     ;
                Name=Column9;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne abonnementsplan.;
                           ENU=Specifies if the user is a member of this subscription plan.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfPlan[9];
                CaptionClass='3,' + PlanNameArray[9];
                Visible=NoOfPlans >= 9 }

    { 21  ;2   ;Field     ;
                Name=Column10;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne abonnementsplan.;
                           ENU=Specifies if the user is a member of this subscription plan.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfPlan[10];
                CaptionClass='3,' + PlanNameArray[10];
                Visible=NoOfPlans >= 10 }

  }
  CODE
  {
    VAR
      Company@1007 : Record 2000000006;
      PermissionPagesMgt@1008 : Codeunit 9001;
      SelectedCompany@1006 : Text[30];
      PlanNameArray@1000 : ARRAY [10] OF Text[55];
      PlanIDArray@1002 : ARRAY [10] OF GUID;
      IsMemberOfPlan@1001 : ARRAY [10] OF Boolean;
      NoOfPlans@1003 : Integer;

    LOCAL PROCEDURE GetUserGroupPlanParameters@5();
    VAR
      Plan@1000 : Record 9004;
      columnNumber@1001 : Integer;
    BEGIN
      CLEAR(PlanIDArray);
      CLEAR(PlanNameArray);
      CLEAR(IsMemberOfPlan);
      IF Plan.FINDSET THEN
        REPEAT
          columnNumber += 1;
          IF PermissionPagesMgt.IsInColumnsRange(columnNumber) THEN BEGIN
            PlanIDArray[columnNumber - PermissionPagesMgt.GetOffset] := Plan."Plan ID";
            PlanNameArray[columnNumber - PermissionPagesMgt.GetOffset] := STRSUBSTNO('%1 %2','Plan ',Plan.Name);
            IsMemberOfPlan[columnNumber - PermissionPagesMgt.GetOffset] := IsUserGroupInPlan(Code,Plan."Plan ID");
          END;
        UNTIL Plan.NEXT = 0;
    END;

    LOCAL PROCEDURE IsUserGroupInPlan@7(UserGroupCode@1000 : Code[20];PlanID@1001 : GUID) : Boolean;
    VAR
      UserGroupPlan@1002 : Record 9007;
    BEGIN
      EXIT(UserGroupPlan.GET(PlanID,UserGroupCode));
    END;

    BEGIN
    END.
  }
}

