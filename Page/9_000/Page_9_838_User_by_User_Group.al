OBJECT Page 9838 User by User Group
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bruger efter brugergruppe;
               ENU=User by User Group];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table2000000120;
    PageType=Worksheet;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,S›g;
                                ENU=New,Process,Report,Browse];
    OnOpenPage=VAR
                 UserGroup@1000 : Record 9000;
               BEGIN
                 NoOfRecords := UserGroup.COUNT;
                 PermissionPagesMgt.Init(NoOfRecords,ARRAYLEN(UserGroupCodeArr));
                 SelectedCompany := COMPANYNAME;
                 HideExternalUsers;
               END;

    OnAfterGetRecord=BEGIN
                       FindUserGroups;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           FindUserGroups;
                         END;

    ActionList=ACTIONS
    {
      { 9       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Action    ;
                      Name=AllColumnsLeft;
                      CaptionML=[DAN=Alle kolonner venstre;
                                 ENU=All Columns Left];
                      ToolTipML=[DAN=Spring til den yderste kolonne til venstre.;
                                 ENU=Jump to the left-most column.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousSet;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 PermissionPagesMgt.AllColumnsLeft;
                               END;
                                }
      { 15      ;1   ;Action    ;
                      Name=ColumnLeft;
                      CaptionML=[DAN=Kolonne venstre;
                                 ENU=Column Left];
                      ToolTipML=[DAN=Spring ‚n kolonne til venstre.;
                                 ENU=Jump one column to the left.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousRecord;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 PermissionPagesMgt.ColumnLeft;
                               END;
                                }
      { 16      ;1   ;Action    ;
                      Name=ColumnRight;
                      CaptionML=[DAN=Kolonne h›jre;
                                 ENU=Column Right];
                      ToolTipML=[DAN=Spring ‚n kolonne til h›jre.;
                                 ENU=Jump one column to the right.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextRecord;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 PermissionPagesMgt.ColumnRight;
                               END;
                                }
      { 25      ;1   ;Action    ;
                      Name=AllColumnsRight;
                      CaptionML=[DAN=Alle kolonner h›jre;
                                 ENU=All Columns Right];
                      ToolTipML=[DAN=Spring til den yderste kolonne til h›jre.;
                                 ENU=Jump to the right-most column.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextSet;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 PermissionPagesMgt.AllColumnsRight;
                               END;
                                }
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
                ToolTipML=[DAN=Angiver den virksomhed, som du vil se brugere til.;
                           ENU=Specifies the company that you want to see users for.];
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
                ToolTipML=[DAN=Angiver brugerens navn. Hvis brugeren skal angive legitimationsoplysninger ved start af klienten, skal brugeren angive dette navn.;
                           ENU=Specifies the user's name. If the user is required to present credentials when starting the client, this is the name that the user must present.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User Name" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver brugerens fulde navn.;
                           ENU=Specifies the full name of the user.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Full Name" }

    { 22  ;2   ;Field     ;
                Name=MemberOfAllGroups;
                CaptionML=[DAN=Alle brugergrupper;
                           ENU=All User Groups];
                ToolTipML=[DAN=Angiver, om brugeren er medlem af alle brugergrupper.;
                           ENU=Specifies if the user is a member of all user groups.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=MemberOfAllGroups;
                OnValidate=BEGIN
                             SetColumnPermission(0,MemberOfAllGroups);
                             CurrPage.UPDATE(FALSE);
                           END;
                            }

    { 11  ;2   ;Field     ;
                Name=Column1;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne brugergruppe.;
                           ENU=Specifies if the user is a member of this user group.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfUserGroup[1];
                CaptionClass='3,' + UserGroupCodeArr[1];
                Visible=NoOfRecords >= 1;
                OnValidate=BEGIN
                             SetColumnPermission(1,IsMemberOfUserGroup[1]);
                           END;
                            }

    { 12  ;2   ;Field     ;
                Name=Column2;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne brugergruppe.;
                           ENU=Specifies if the user is a member of this user group.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfUserGroup[2];
                CaptionClass='3,' + UserGroupCodeArr[2];
                Visible=NoOfRecords >= 2;
                OnValidate=BEGIN
                             SetColumnPermission(2,IsMemberOfUserGroup[2]);
                           END;
                            }

    { 13  ;2   ;Field     ;
                Name=Column3;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne brugergruppe.;
                           ENU=Specifies if the user is a member of this user group.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfUserGroup[3];
                CaptionClass='3,' + UserGroupCodeArr[3];
                Visible=NoOfRecords >= 3;
                OnValidate=BEGIN
                             SetColumnPermission(3,IsMemberOfUserGroup[3]);
                           END;
                            }

    { 14  ;2   ;Field     ;
                Name=Column4;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne brugergruppe.;
                           ENU=Specifies if the user is a member of this user group.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfUserGroup[4];
                CaptionClass='3,' + UserGroupCodeArr[4];
                Visible=NoOfRecords >= 4;
                OnValidate=BEGIN
                             SetColumnPermission(4,IsMemberOfUserGroup[4]);
                           END;
                            }

    { 5   ;2   ;Field     ;
                Name=Column5;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne brugergruppe.;
                           ENU=Specifies if the user is a member of this user group.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfUserGroup[5];
                CaptionClass='3,' + UserGroupCodeArr[5];
                Visible=NoOfRecords >= 5;
                OnValidate=BEGIN
                             SetColumnPermission(5,IsMemberOfUserGroup[5]);
                           END;
                            }

    { 17  ;2   ;Field     ;
                Name=Column6;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne brugergruppe.;
                           ENU=Specifies if the user is a member of this user group.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfUserGroup[6];
                CaptionClass='3,' + UserGroupCodeArr[6];
                Visible=NoOfRecords >= 6;
                OnValidate=BEGIN
                             SetColumnPermission(6,IsMemberOfUserGroup[6]);
                           END;
                            }

    { 18  ;2   ;Field     ;
                Name=Column7;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne brugergruppe.;
                           ENU=Specifies if the user is a member of this user group.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfUserGroup[7];
                CaptionClass='3,' + UserGroupCodeArr[7];
                Visible=NoOfRecords >= 7;
                OnValidate=BEGIN
                             SetColumnPermission(7,IsMemberOfUserGroup[7]);
                           END;
                            }

    { 19  ;2   ;Field     ;
                Name=Column8;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne brugergruppe.;
                           ENU=Specifies if the user is a member of this user group.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfUserGroup[8];
                CaptionClass='3,' + UserGroupCodeArr[8];
                Visible=NoOfRecords >= 8;
                OnValidate=BEGIN
                             SetColumnPermission(8,IsMemberOfUserGroup[8]);
                           END;
                            }

    { 20  ;2   ;Field     ;
                Name=Column9;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne brugergruppe.;
                           ENU=Specifies if the user is a member of this user group.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfUserGroup[9];
                CaptionClass='3,' + UserGroupCodeArr[9];
                Visible=NoOfRecords >= 9;
                OnValidate=BEGIN
                             SetColumnPermission(9,IsMemberOfUserGroup[9]);
                           END;
                            }

    { 21  ;2   ;Field     ;
                Name=Column10;
                ToolTipML=[DAN=Angiver, om brugeren er medlem af denne brugergruppe.;
                           ENU=Specifies if the user is a member of this user group.];
                ApplicationArea=#All;
                SourceExpr=IsMemberOfUserGroup[10];
                CaptionClass='3,' + UserGroupCodeArr[10];
                Visible=NoOfRecords >= 10;
                OnValidate=BEGIN
                             SetColumnPermission(10,IsMemberOfUserGroup[10]);
                           END;
                            }

    { 8   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 6   ;1   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=User Security ID=FIELD(User Security ID);
                PagePartID=Page9817;
                PartType=Page }

  }
  CODE
  {
    VAR
      Company@1007 : Record 2000000006;
      PermissionPagesMgt@1008 : Codeunit 9001;
      SelectedCompany@1006 : Text[30];
      UserGroupCodeArr@1000 : ARRAY [10] OF Code[20];
      IsMemberOfUserGroup@1001 : ARRAY [10] OF Boolean;
      MemberOfAllGroups@1004 : Boolean;
      NoOfRecords@1003 : Integer;

    LOCAL PROCEDURE FindUserGroups@5();
    VAR
      UserGroup@1000 : Record 9000;
      i@1001 : Integer;
    BEGIN
      CLEAR(UserGroupCodeArr);
      CLEAR(IsMemberOfUserGroup);
      MemberOfAllGroups := TRUE;
      IF UserGroup.FINDSET THEN
        REPEAT
          i += 1;
          IF PermissionPagesMgt.IsInColumnsRange(i) THEN BEGIN
            UserGroupCodeArr[i - PermissionPagesMgt.GetOffset] := UserGroup.Code;
            IsMemberOfUserGroup[i - PermissionPagesMgt.GetOffset] := UserGroup.IsUserMember(Rec,SelectedCompany);
            MemberOfAllGroups := MemberOfAllGroups AND IsMemberOfUserGroup[i - PermissionPagesMgt.GetOffset];
          END ELSE
            IF MemberOfAllGroups THEN
              MemberOfAllGroups := UserGroup.IsUserMember(Rec,SelectedCompany);
        UNTIL (UserGroup.NEXT = 0) OR (PermissionPagesMgt.IsPastColumnRange(i) AND NOT MemberOfAllGroups);
    END;

    LOCAL PROCEDURE SetColumnPermission@1(ColumnNo@1001 : Integer;NewUserGroupMembership@1003 : Boolean);
    VAR
      UserGroup@1000 : Record 9000;
    BEGIN
      IF ColumnNo > 0 THEN BEGIN
        UserGroup.GET(UserGroupCodeArr[ColumnNo]);
        UserGroup.SetUserGroupMembership(Rec,NewUserGroupMembership,SelectedCompany);
        MemberOfAllGroups := MemberOfAllGroups AND NewUserGroupMembership;
      END ELSE
        IF UserGroup.FINDSET THEN
          REPEAT
            UserGroup.SetUserGroupMembership(Rec,NewUserGroupMembership,SelectedCompany);
          UNTIL UserGroup.NEXT = 0;
    END;

    LOCAL PROCEDURE HideExternalUsers@2();
    VAR
      PermissionManager@1001 : Codeunit 9002;
      OriginalFilterGroup@1000 : Integer;
    BEGIN
      IF NOT PermissionManager.SoftwareAsAService THEN
        EXIT;

      OriginalFilterGroup := FILTERGROUP;
      FILTERGROUP := 2;
      SETFILTER("License Type",'<>%1',"License Type"::"External User");
      FILTERGROUP := OriginalFilterGroup;
    END;

    BEGIN
    END.
  }
}

