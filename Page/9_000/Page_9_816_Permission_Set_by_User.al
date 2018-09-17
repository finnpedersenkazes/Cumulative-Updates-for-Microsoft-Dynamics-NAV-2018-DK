OBJECT Page 9816 Permission Set by User
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Permissions=TableData 2000000053=rimd;
    CaptionML=[DAN=Rettighedss�t efter bruger;
               ENU=Permission Set by User];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table2000000167;
    DataCaptionExpr=SelectedCompany;
    PageType=Worksheet;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,S�g;
                                ENU=New,Process,Report,Browse];
    OnOpenPage=VAR
                 User@1000 : Record 2000000120;
               BEGIN
                 SelectedCompany := COMPANYNAME;
                 UpdateCompany;
                 HideExternalUsers(User);
                 NoOfRecords := User.COUNT;
                 PermissionPagesMgt.Init(NoOfRecords,ARRAYLEN(UserNameCode));
               END;

    OnAfterGetRecord=BEGIN
                       FindUsers;
                       PermissionEditable := ISNULLGUID("App ID");
                     END;

    OnAfterGetCurrRecord=BEGIN
                           FindUsers;
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
                      ToolTipML=[DAN=Vis eller rediger, hvilke funktionsobjekter brugerne skal bruge til at f� adgang til og konfigurere de relaterede tilladelser i rettighedss�t, som du kan tildele til databasens brugere.;
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
      { 8       ;1   ;Action    ;
                      Name=CopyPermissionSet;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopi�r rettighedss�t;
                                 ENU=Copy Permission Set];
                      ToolTipML=[DAN=Opret en kopi af det aktuelle rettighedss�t med et navn, som du angiver.;
                                 ENU=Create a copy of the current permission set with a name that you specify.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=PermissionEditable;
                      Image=Copy;
                      OnAction=VAR
                                 PermissionSet@1035 : Record 2000000004;
                                 CopyPermissionSet@1034 : Report 9802;
                               BEGIN
                                 PermissionSet.SETRANGE("Role ID","Role ID");
                                 CopyPermissionSet.SETTABLEVIEW(PermissionSet);
                                 CopyPermissionSet.RUNMODAL;

                                 IF GET(Scope::System,"App ID",CopyPermissionSet.GetRoleId) THEN;
                               END;
                                }
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
                      ToolTipML=[DAN=Spring �n kolonne til venstre.;
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
                      CaptionML=[DAN=Kolonne h�jre;
                                 ENU=Column Right];
                      ToolTipML=[DAN=Spring �n kolonne til h�jre.;
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
                      CaptionML=[DAN=Alle kolonner h�jre;
                                 ENU=All Columns Right];
                      ToolTipML=[DAN=Spring til den yderste kolonne til h�jre.;
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

    { 23  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 24  ;2   ;Field     ;
                CaptionML=[DAN=Firmanavn;
                           ENU=Company Name];
                ToolTipML=[DAN=Angiver navnet p� virksomheden.;
                           ENU=Specifies the name of the company.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SelectedCompany;
                TableRelation=Company;
                OnValidate=BEGIN
                             UpdateCompany;
                           END;
                            }

    { 26  ;2   ;Field     ;
                CaptionML=[DAN=Vis dom�nenavn;
                           ENU=Show Domain Name];
                ToolTipML=[DAN=Angiver dom�nenavnet sammen med brugernavnet for Windows-brugerkonti, f.eks. DOMAIN\UserName.;
                           ENU=Specifies the domain name together with the user name for Windows user accounts, for example, DOMAIN\UserName.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShowDomainName;
                OnValidate=BEGIN
                             CurrPage.UPDATE(FALSE);
                           END;
                            }

    { 2   ;1   ;Group     ;
                Name=Group;
                CaptionML=[DAN=Rettighedss�t;
                           ENU=Permission Set];
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en profil. Profilen bestemmer hjemmesidens layout.;
                           ENU=Specifies a profile. The profile determines the layout of the home page.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Role ID" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� recorden.;
                           ENU=Specifies the name of the record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 31  ;2   ;Field     ;
                CaptionML=[DAN=Udvidelses-id;
                           ENU=Extension ID];
                ToolTipML=[DAN=Angiver det entydige id for udvidelsen. Et entydigt id genereres, hvis du ikke har angivet en v�rdi.;
                           ENU=Specifies the unique identifier for the extension. A unique identifier will be generated if a value is not provided.];
                ApplicationArea=#Advanced;
                SourceExpr="App ID";
                Visible=False }

    { 29  ;2   ;Field     ;
                CaptionML=[DAN=Udvidelsesnavn;
                           ENU=Extension Name];
                ToolTipML=[DAN=Angiver navnet p� udvidelsen.;
                           ENU=Specifies the name of the extension.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="App Name" }

    { 22  ;2   ;Field     ;
                Name=AllUsersHavePermission;
                CaptionML=[DAN=Alle brugere;
                           ENU=All Users];
                ToolTipML=[DAN=Angiver, at rettighedss�ttet tildeles alle brugere.;
                           ENU=Specifies that the permission set will be assigned to all users.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AllUsersHavePermission;
                OnValidate=BEGIN
                             SetColumnPermission(0,AllUsersHavePermission);
                             CurrPage.UPDATE(FALSE);
                           END;
                            }

    { 11  ;2   ;Field     ;
                Name=Column1;
                ApplicationArea=#All;
                SourceExpr=UserHasPermissionSet[1];
                CaptionClass='3,' + UserNameCode[1];
                Visible=NoOfRecords >= 1;
                OnValidate=BEGIN
                             SetColumnPermission(1,UserHasPermissionSet[1]);
                           END;
                            }

    { 12  ;2   ;Field     ;
                Name=Column2;
                ApplicationArea=#All;
                SourceExpr=UserHasPermissionSet[2];
                CaptionClass='3,' + UserNameCode[2];
                Visible=NoOfRecords >= 2;
                OnValidate=BEGIN
                             SetColumnPermission(2,UserHasPermissionSet[2]);
                           END;
                            }

    { 13  ;2   ;Field     ;
                Name=Column3;
                ApplicationArea=#All;
                SourceExpr=UserHasPermissionSet[3];
                CaptionClass='3,' + UserNameCode[3];
                Visible=NoOfRecords >= 3;
                OnValidate=BEGIN
                             SetColumnPermission(3,UserHasPermissionSet[3]);
                           END;
                            }

    { 14  ;2   ;Field     ;
                Name=Column4;
                ApplicationArea=#All;
                SourceExpr=UserHasPermissionSet[4];
                CaptionClass='3,' + UserNameCode[4];
                Visible=NoOfRecords >= 4;
                OnValidate=BEGIN
                             SetColumnPermission(4,UserHasPermissionSet[4]);
                           END;
                            }

    { 5   ;2   ;Field     ;
                Name=Column5;
                ApplicationArea=#All;
                SourceExpr=UserHasPermissionSet[5];
                CaptionClass='3,' + UserNameCode[5];
                Visible=NoOfRecords >= 5;
                OnValidate=BEGIN
                             SetColumnPermission(5,UserHasPermissionSet[5]);
                           END;
                            }

    { 17  ;2   ;Field     ;
                Name=Column6;
                ApplicationArea=#All;
                SourceExpr=UserHasPermissionSet[6];
                CaptionClass='3,' + UserNameCode[6];
                Visible=NoOfRecords >= 6;
                OnValidate=BEGIN
                             SetColumnPermission(6,UserHasPermissionSet[6]);
                           END;
                            }

    { 18  ;2   ;Field     ;
                Name=Column7;
                ApplicationArea=#All;
                SourceExpr=UserHasPermissionSet[7];
                CaptionClass='3,' + UserNameCode[7];
                Visible=NoOfRecords >= 7;
                OnValidate=BEGIN
                             SetColumnPermission(7,UserHasPermissionSet[7]);
                           END;
                            }

    { 19  ;2   ;Field     ;
                Name=Column8;
                ApplicationArea=#All;
                SourceExpr=UserHasPermissionSet[8];
                CaptionClass='3,' + UserNameCode[8];
                Visible=NoOfRecords >= 8;
                OnValidate=BEGIN
                             SetColumnPermission(8,UserHasPermissionSet[8]);
                           END;
                            }

    { 20  ;2   ;Field     ;
                Name=Column9;
                ApplicationArea=#All;
                SourceExpr=UserHasPermissionSet[9];
                CaptionClass='3,' + UserNameCode[9];
                Visible=NoOfRecords >= 9;
                OnValidate=BEGIN
                             SetColumnPermission(9,UserHasPermissionSet[9]);
                           END;
                            }

    { 21  ;2   ;Field     ;
                Name=Column10;
                ApplicationArea=#All;
                SourceExpr=UserHasPermissionSet[10];
                CaptionClass='3,' + UserNameCode[10];
                Visible=NoOfRecords >= 10;
                OnValidate=BEGIN
                             SetColumnPermission(10,UserHasPermissionSet[10]);
                           END;
                            }

    { 28  ;    ;Container ;
                ContainerType=FactBoxArea }

    { 27  ;1   ;Part      ;
                CaptionML=[DAN=Rettigheder;
                           ENU=Permissions];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Role ID=FIELD(Role ID);
                PagePartID=Page9804;
                PartType=Page }

    { 30  ;1   ;Part      ;
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
      Company@1006 : Record 2000000006;
      PermissionPagesMgt@1009 : Codeunit 9001;
      UserSecurityIDArr@1005 : ARRAY [10] OF GUID;
      SelectedCompany@1007 : Text[30];
      ShowDomainName@1008 : Boolean;
      UserNameCode@1000 : ARRAY [10] OF Code[50];
      UserHasPermissionSet@1001 : ARRAY [10] OF Boolean;
      AllUsersHavePermission@1004 : Boolean;
      NoOfRecords@1002 : Integer;
      PermissionEditable@1003 : Boolean;

    LOCAL PROCEDURE FindUsers@5();
    VAR
      User@1000 : Record 2000000120;
      i@1001 : Integer;
      j@1002 : Integer;
    BEGIN
      CLEAR(UserNameCode);
      CLEAR(UserHasPermissionSet);
      User.SETCURRENTKEY("User Name");
      AllUsersHavePermission := TRUE;
      HideExternalUsers(User);
      IF User.FINDSET THEN
        REPEAT
          i += 1;
          IF PermissionPagesMgt.IsInColumnsRange(i) THEN BEGIN
            UserSecurityIDArr[i - PermissionPagesMgt.GetOffset] := User."User Security ID";
            j := 0;
            IF NOT ShowDomainName THEN BEGIN
              j := STRPOS(User."User Name",'\');
              IF j < 0 THEN
                j := 0;
            END;
            UserNameCode[i - PermissionPagesMgt.GetOffset] := COPYSTR(User."User Name",j + 1,MAXSTRLEN(UserNameCode[1]));
            UserHasPermissionSet[i - PermissionPagesMgt.GetOffset] := UserHasPermission(Rec,User);
            AllUsersHavePermission := AllUsersHavePermission AND UserHasPermissionSet[i - PermissionPagesMgt.GetOffset];
          END ELSE
            IF AllUsersHavePermission THEN
              AllUsersHavePermission := UserHasPermission(Rec,User);
        UNTIL (User.NEXT = 0) OR (PermissionPagesMgt.IsPastColumnRange(i) AND NOT AllUsersHavePermission);
    END;

    LOCAL PROCEDURE UserHasPermission@14(VAR AggregatePermissionSet@1001 : Record 2000000167;VAR User@1000 : Record 2000000120) : Boolean;
    VAR
      AccessControl@1002 : Record 2000000053;
    BEGIN
      AccessControl.SETRANGE("User Security ID",User."User Security ID");
      AccessControl.SETRANGE("Role ID",AggregatePermissionSet."Role ID");
      AccessControl.SETFILTER("Company Name",'%1|%2','',Company.Name);
      AccessControl.SETRANGE(Scope,AggregatePermissionSet.Scope);
      AccessControl.SETRANGE("App ID",AggregatePermissionSet."App ID");
      EXIT(NOT AccessControl.ISEMPTY);
    END;

    LOCAL PROCEDURE SetColumnPermission@1(ColumnNo@1001 : Integer;UserHasPermission@1003 : Boolean);
    VAR
      User@1000 : Record 2000000120;
    BEGIN
      IF ColumnNo > 0 THEN BEGIN
        SetUserPermission(UserSecurityIDArr[ColumnNo],UserHasPermission);
        AllUsersHavePermission := AllUsersHavePermission AND UserHasPermission;
      END ELSE BEGIN
        HideExternalUsers(User);
        IF User.FINDSET THEN
          REPEAT
            SetUserPermission(User."User Security ID",UserHasPermission);
          UNTIL User.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE SetUserPermission@7(UserSecurityID@1001 : GUID;UserHasPermission@1003 : Boolean);
    VAR
      AccessControl@1002 : Record 2000000053;
    BEGIN
      IF AccessControl.GET(UserSecurityID,"Role ID",'',Scope,"App ID") OR
         AccessControl.GET(UserSecurityID,"Role ID",Company.Name,Scope,"App ID")
      THEN BEGIN
        IF NOT UserHasPermission THEN
          AccessControl.DELETE;
        EXIT;
      END;
      IF NOT UserHasPermission THEN
        EXIT;
      AccessControl.INIT;
      AccessControl."User Security ID" := UserSecurityID;
      AccessControl."Role ID" := "Role ID";
      AccessControl."Company Name" := Company.Name;
      AccessControl.Scope := Scope;
      AccessControl."App ID" := "App ID";
      AccessControl.INSERT;
    END;

    LOCAL PROCEDURE UpdateCompany@2();
    BEGIN
      Company.Name := SelectedCompany;
      IF SelectedCompany <> '' THEN BEGIN
        Company.FIND('=<>');
        SelectedCompany := Company.Name;
      END;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE HideExternalUsers@6(VAR User@1000 : Record 2000000120);
    VAR
      PermissionManager@1001 : Codeunit 9002;
    BEGIN
      IF PermissionManager.SoftwareAsAService THEN
        User.SETFILTER("License Type",'<>%1',User."License Type"::"External User");
    END;

    BEGIN
    END.
  }
}

