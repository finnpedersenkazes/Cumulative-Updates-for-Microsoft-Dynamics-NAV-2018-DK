OBJECT Page 9837 Permission Set by User Group
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rettighedss‘t efter brugergruppe;
               ENU=Permission Set by User Group];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table2000000167;
    PageType=Worksheet;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,S›g;
                                ENU=New,Process,Report,Browse];
    OnOpenPage=VAR
                 UserGroup@1000 : Record 9000;
               BEGIN
                 NoOfRecords := UserGroup.COUNT;
                 PermissionPagesMgt.Init(NoOfRecords,ARRAYLEN(UserGroupCodeArr));
               END;

    OnAfterGetRecord=BEGIN
                       FindUserGroups;
                       PermissionEditable := ISNULLGUID("App ID");
                     END;

    OnAfterGetCurrRecord=BEGIN
                           FindUserGroups;
                         END;

    ActionList=ACTIONS
    {
      { 10      ;    ;ActionContainer;
                      Name=PermissionActions;
                      CaptionML=[DAN=Rettigheder;
                                 ENU=Permissions];
                      ActionContainerType=RelatedInformation }
      { 6       ;1   ;Action    ;
                      Name=Permissions;
                      ShortCutKey=Shift+Ctrl+p;
                      CaptionML=[DAN=Rettigheder;
                                 ENU=Permissions];
                      ToolTipML=[DAN=Vis eller rediger, hvilke funktionsobjekter brugerne skal bruge til at f† adgang til og konfigurere de relaterede tilladelser i rettighedss‘t, som du kan tildele til databasens brugere.;
                                 ENU=View or edit which feature objects that users need to access and set up the related permissions in permission sets that you can assign to the users of the database.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9803;
                      RunPageLink=Role ID=FIELD(Role ID);
                      Promoted=Yes;
                      Enabled=PermissionEditable;
                      PromotedIsBig=Yes;
                      Image=Permission;
                      PromotedCategory=Process }
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

    { 2   ;1   ;Group     ;
                Name=Group;
                CaptionML=[DAN=Rettighedss‘t;
                           ENU=Permission Set];
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en profil. Profilen bestemmer hjemmesidens layout.;
                           ENU=Specifies a profile. The profile determines the layout of the home page.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Role ID";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† recorden.;
                           ENU=Specifies the name of the record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Editable=FALSE }

    { 27  ;2   ;Field     ;
                CaptionML=[DAN=Udvidelses-id;
                           ENU=Extension ID];
                ToolTipML=[DAN=Angiver det entydige id for udvidelsen. Et entydigt id genereres, hvis du ikke har angivet en v‘rdi.;
                           ENU=Specifies the unique identifier for the extension. A unique identifier will be generated if a value is not provided.];
                ApplicationArea=#Advanced;
                SourceExpr="App ID";
                Visible=False }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Udvidelsesnavn;
                           ENU=Extension Name];
                ToolTipML=[DAN=Angiver navnet p† en udvidelse.;
                           ENU=Specifies the name of an extension.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="App Name" }

    { 22  ;2   ;Field     ;
                Name=AllUsersHavePermission;
                CaptionML=[DAN=Alle brugergrupper;
                           ENU=All User Groups];
                ToolTipML=[DAN=Angiver, om brugeren er medlem af alle brugergrupper.;
                           ENU=Specifies if the user is a member of all user groups.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AllGroupsHavePermission;
                OnValidate=BEGIN
                             IF AllGroupsHavePermission THEN
                               IF NOT CONFIRM(AllUserGrpGetsPermissionQst) THEN
                                 ERROR('');

                             SetColumnPermission(0,AllGroupsHavePermission);
                             CurrPage.UPDATE(FALSE);
                           END;
                            }

    { 11  ;2   ;Field     ;
                Name=Column1;
                ToolTipML=[DAN=Angiver, om brugeren har dette rettighedss‘t.;
                           ENU=Specifies if the user has this permission set.];
                ApplicationArea=#All;
                SourceExpr=UserGroupHasPermissionSet[1];
                CaptionClass='3,' + UserGroupCodeArr[1];
                Visible=NoOfRecords >= 1;
                OnValidate=BEGIN
                             SetColumnPermission(1,UserGroupHasPermissionSet[1]);
                           END;
                            }

    { 12  ;2   ;Field     ;
                Name=Column2;
                ToolTipML=[DAN=Angiver, om brugeren har dette rettighedss‘t.;
                           ENU=Specifies if the user has this permission set.];
                ApplicationArea=#All;
                SourceExpr=UserGroupHasPermissionSet[2];
                CaptionClass='3,' + UserGroupCodeArr[2];
                Visible=NoOfRecords >= 2;
                OnValidate=BEGIN
                             SetColumnPermission(2,UserGroupHasPermissionSet[2]);
                           END;
                            }

    { 13  ;2   ;Field     ;
                Name=Column3;
                ToolTipML=[DAN=Angiver, om brugeren har dette rettighedss‘t.;
                           ENU=Specifies if the user has this permission set.];
                ApplicationArea=#All;
                SourceExpr=UserGroupHasPermissionSet[3];
                CaptionClass='3,' + UserGroupCodeArr[3];
                Visible=NoOfRecords >= 3;
                OnValidate=BEGIN
                             SetColumnPermission(3,UserGroupHasPermissionSet[3]);
                           END;
                            }

    { 14  ;2   ;Field     ;
                Name=Column4;
                ToolTipML=[DAN=Angiver, om brugeren har dette rettighedss‘t.;
                           ENU=Specifies if the user has this permission set.];
                ApplicationArea=#All;
                SourceExpr=UserGroupHasPermissionSet[4];
                CaptionClass='3,' + UserGroupCodeArr[4];
                Visible=NoOfRecords >= 4;
                OnValidate=BEGIN
                             SetColumnPermission(4,UserGroupHasPermissionSet[4]);
                           END;
                            }

    { 5   ;2   ;Field     ;
                Name=Column5;
                ToolTipML=[DAN=Angiver, om brugeren har dette rettighedss‘t.;
                           ENU=Specifies if the user has this permission set.];
                ApplicationArea=#All;
                SourceExpr=UserGroupHasPermissionSet[5];
                CaptionClass='3,' + UserGroupCodeArr[5];
                Visible=NoOfRecords >= 5;
                OnValidate=BEGIN
                             SetColumnPermission(5,UserGroupHasPermissionSet[5]);
                           END;
                            }

    { 17  ;2   ;Field     ;
                Name=Column6;
                ToolTipML=[DAN=Angiver, om brugeren har dette rettighedss‘t.;
                           ENU=Specifies if the user has this permission set.];
                ApplicationArea=#All;
                SourceExpr=UserGroupHasPermissionSet[6];
                CaptionClass='3,' + UserGroupCodeArr[6];
                Visible=NoOfRecords >= 6;
                OnValidate=BEGIN
                             SetColumnPermission(6,UserGroupHasPermissionSet[6]);
                           END;
                            }

    { 18  ;2   ;Field     ;
                Name=Column7;
                ToolTipML=[DAN=Angiver, om brugeren har dette rettighedss‘t.;
                           ENU=Specifies if the user has this permission set.];
                ApplicationArea=#All;
                SourceExpr=UserGroupHasPermissionSet[7];
                CaptionClass='3,' + UserGroupCodeArr[7];
                Visible=NoOfRecords >= 7;
                OnValidate=BEGIN
                             SetColumnPermission(7,UserGroupHasPermissionSet[7]);
                           END;
                            }

    { 19  ;2   ;Field     ;
                Name=Column8;
                ToolTipML=[DAN=Angiver, om brugeren har dette rettighedss‘t.;
                           ENU=Specifies if the user has this permission set.];
                ApplicationArea=#All;
                SourceExpr=UserGroupHasPermissionSet[8];
                CaptionClass='3,' + UserGroupCodeArr[8];
                Visible=NoOfRecords >= 8;
                OnValidate=BEGIN
                             SetColumnPermission(8,UserGroupHasPermissionSet[8]);
                           END;
                            }

    { 20  ;2   ;Field     ;
                Name=Column9;
                ToolTipML=[DAN=Angiver, om brugeren har dette rettighedss‘t.;
                           ENU=Specifies if the user has this permission set.];
                ApplicationArea=#All;
                SourceExpr=UserGroupHasPermissionSet[9];
                CaptionClass='3,' + UserGroupCodeArr[9];
                Visible=NoOfRecords >= 9;
                OnValidate=BEGIN
                             SetColumnPermission(9,UserGroupHasPermissionSet[9]);
                           END;
                            }

    { 21  ;2   ;Field     ;
                Name=Column10;
                ToolTipML=[DAN=Angiver, om brugeren har dette rettighedss‘t.;
                           ENU=Specifies if the user has this permission set.];
                ApplicationArea=#All;
                SourceExpr=UserGroupHasPermissionSet[10];
                CaptionClass='3,' + UserGroupCodeArr[10];
                Visible=NoOfRecords >= 10;
                OnValidate=BEGIN
                             SetColumnPermission(10,UserGroupHasPermissionSet[10]);
                           END;
                            }

    { 24  ;    ;Container ;
                ContainerType=FactBoxArea }

    { 23  ;1   ;Part      ;
                CaptionML=[DAN=Rettigheder;
                           ENU=Permissions];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Role ID=FIELD(Role ID);
                PagePartID=Page9804;
                PartType=Page }

    { 26  ;1   ;Part      ;
                CaptionML=[DAN=Lejerrettigheder;
                           ENU=Tenant Permissions];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Role ID=FIELD(Role ID),
                            App ID=FIELD(App ID);
                PagePartID=Page9840;
                Editable=FALSE;
                PartType=Page }

  }
  CODE
  {
    VAR
      PermissionPagesMgt@1006 : Codeunit 9001;
      UserGroupCodeArr@1000 : ARRAY [10] OF Code[20];
      UserGroupHasPermissionSet@1001 : ARRAY [10] OF Boolean;
      AllGroupsHavePermission@1004 : Boolean;
      NoOfRecords@1003 : Integer;
      PermissionEditable@1002 : Boolean;
      AllUserGrpGetsPermissionQst@1005 : TextConst 'DAN=Er du sikker p†, at du vil f›je dette rettighedss‘t til alle brugergrupper?;ENU=Are you sure you want to add this permission set to all user groups?';

    LOCAL PROCEDURE FindUserGroups@5();
    VAR
      UserGroup@1000 : Record 9000;
      i@1001 : Integer;
    BEGIN
      CLEAR(UserGroupCodeArr);
      CLEAR(UserGroupHasPermissionSet);
      AllGroupsHavePermission := TRUE;
      IF UserGroup.FINDSET THEN
        REPEAT
          i += 1;
          IF PermissionPagesMgt.IsInColumnsRange(i) THEN BEGIN
            UserGroupCodeArr[i - PermissionPagesMgt.GetOffset] := UserGroup.Code;
            UserGroupHasPermissionSet[i - PermissionPagesMgt.GetOffset] := UserGroupHasPermission(Rec,UserGroup);
            AllGroupsHavePermission := AllGroupsHavePermission AND UserGroupHasPermissionSet[i - PermissionPagesMgt.GetOffset];
          END ELSE
            IF AllGroupsHavePermission THEN
              AllGroupsHavePermission := UserGroupHasPermission(Rec,UserGroup);
        UNTIL (UserGroup.NEXT = 0) OR (PermissionPagesMgt.IsPastColumnRange(i) AND NOT AllGroupsHavePermission);
    END;

    LOCAL PROCEDURE UserGroupHasPermission@14(VAR AggregatePermissionSet@1001 : Record 2000000167;VAR UserGroup@1000 : Record 9000) : Boolean;
    VAR
      UserGroupPermissionSet@1002 : Record 9003;
    BEGIN
      UserGroupPermissionSet.SETRANGE("User Group Code",UserGroup.Code);
      UserGroupPermissionSet.SETRANGE("Role ID",AggregatePermissionSet."Role ID");
      UserGroupPermissionSet.SETRANGE("App ID",AggregatePermissionSet."App ID");
      EXIT(NOT UserGroupPermissionSet.ISEMPTY);
    END;

    LOCAL PROCEDURE SetColumnPermission@1(ColumnNo@1001 : Integer;UserHasPermission@1003 : Boolean);
    VAR
      UserGroup@1000 : Record 9000;
    BEGIN
      IF ColumnNo > 0 THEN BEGIN
        SetUserGroupPermission(UserGroupCodeArr[ColumnNo],UserHasPermission);
        AllGroupsHavePermission := AllGroupsHavePermission AND UserHasPermission;
      END ELSE
        IF UserGroup.FINDSET THEN
          REPEAT
            SetUserGroupPermission(UserGroup.Code,UserHasPermission);
          UNTIL UserGroup.NEXT = 0;
    END;

    LOCAL PROCEDURE SetUserGroupPermission@7(UserGroupCode@1001 : Code[20];UserGroupHasPermission@1003 : Boolean);
    VAR
      UserGroupPermissionSet@1002 : Record 9003;
    BEGIN
      IF UserGroupPermissionSet.GET(UserGroupCode,"Role ID",Scope,"App ID") THEN BEGIN
        IF NOT UserGroupHasPermission THEN
          UserGroupPermissionSet.DELETE(TRUE);
        EXIT;
      END;
      IF NOT UserGroupHasPermission THEN
        EXIT;
      UserGroupPermissionSet.INIT;
      UserGroupPermissionSet."User Group Code" := UserGroupCode;
      UserGroupPermissionSet."Role ID" := "Role ID";
      UserGroupPermissionSet."App ID" := "App ID";
      UserGroupPermissionSet.Scope := Scope;
      UserGroupPermissionSet.INSERT(TRUE);
    END;

    BEGIN
    END.
  }
}

