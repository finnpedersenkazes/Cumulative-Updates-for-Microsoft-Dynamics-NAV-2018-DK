OBJECT Table 9002 User Group Access Control
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    Permissions=TableData 2000000053=rimd;
    CaptionML=[DAN=Adgangskontrol for brugergruppe;
               ENU=User Group Access Control];
  }
  FIELDS
  {
    { 1   ;   ;User Group Code     ;Code20        ;TableRelation="User Group";
                                                   CaptionML=[DAN=Brugergruppekode;
                                                              ENU=User Group Code] }
    { 2   ;   ;User Security ID    ;GUID          ;TableRelation=User;
                                                   DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Brugersikkerheds-id;
                                                              ENU=User Security ID] }
    { 3   ;   ;Role ID             ;Code20        ;TableRelation="Permission Set";
                                                   CaptionML=[DAN=Rolle-id;
                                                              ENU=Role ID];
                                                   Editable=No }
    { 4   ;   ;Company Name        ;Text30        ;TableRelation=Company;
                                                   CaptionML=[DAN=Firmanavn;
                                                              ENU=Company Name] }
    { 5   ;   ;User Name           ;Code50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."User Name" WHERE (User Security ID=FIELD(User Security ID)));
                                                   CaptionML=[DAN=Brugernavn;
                                                              ENU=User Name];
                                                   Editable=No }
    { 6   ;   ;Scope               ;Option        ;CaptionML=[DAN=Omr†de;
                                                              ENU=Scope];
                                                   OptionCaptionML=[DAN=System,Lejer;
                                                                    ENU=System,Tenant];
                                                   OptionString=System,Tenant }
    { 7   ;   ;App ID              ;GUID          ;CaptionML=[DAN=App-id;
                                                              ENU=App ID] }
  }
  KEYS
  {
    {    ;User Group Code,User Security ID,Role ID,Company Name,Scope,App ID;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE AddUserGroupMember@1(UserGroupCode@1000 : Code[20];UserSecurityID@1001 : GUID;SelectedCompany@1002 : Text[30]);
    VAR
      UserGroupPermissionSet@1003 : Record 9003;
    BEGIN
      UserGroupPermissionSet.SETRANGE("User Group Code",UserGroupCode);
      IF UserGroupPermissionSet.FINDSET THEN
        REPEAT
          AddPermissionSetToUser(
            UserGroupCode,UserSecurityID,SelectedCompany,UserGroupPermissionSet."Role ID",UserGroupPermissionSet."App ID",
            UserGroupPermissionSet.Scope);
        UNTIL UserGroupPermissionSet.NEXT = 0;
    END;

    [External]
    PROCEDURE RemoveUserGroupMember@2(UserGroupCode@1000 : Code[20];UserSecurityID@1001 : GUID;SelectedCompany@1002 : Text[30]);
    VAR
      UserGroupPermissionSet@1003 : Record 9003;
    BEGIN
      UserGroupPermissionSet.SETRANGE("User Group Code",UserGroupCode);
      IF UserGroupPermissionSet.FINDSET THEN
        REPEAT
          RemovePermissionSetFromUser(
            UserGroupCode,UserSecurityID,SelectedCompany,UserGroupPermissionSet."Role ID",UserGroupPermissionSet."App ID",
            UserGroupPermissionSet.Scope);
        UNTIL UserGroupPermissionSet.NEXT = 0;
    END;

    [External]
    PROCEDURE AddUserGroupPermissionSet@3(UserGroupCode@1000 : Code[20];RoleID@1001 : Code[20];AppID@1002 : GUID;ItemScope@1004 : Integer);
    VAR
      UserGroupMember@1003 : Record 9001;
    BEGIN
      UserGroupMember.SETRANGE("User Group Code",UserGroupCode);
      IF UserGroupMember.FINDSET THEN
        REPEAT
          AddPermissionSetToUser(
            UserGroupCode,UserGroupMember."User Security ID",UserGroupMember."Company Name",RoleID,AppID,ItemScope);
        UNTIL UserGroupMember.NEXT = 0;
    END;

    [External]
    PROCEDURE RemoveUserGroupPermissionSet@5(UserGroupCode@1000 : Code[20];RoleID@1001 : Code[20];AppID@1003 : GUID;ItemScope@1004 : Integer);
    VAR
      UserGroupMember@1002 : Record 9001;
    BEGIN
      UserGroupMember.SETRANGE("User Group Code",UserGroupCode);
      IF UserGroupMember.FINDSET THEN
        REPEAT
          RemovePermissionSetFromUser(
            UserGroupCode,UserGroupMember."User Security ID",UserGroupMember."Company Name",RoleID,AppID,ItemScope);
        UNTIL UserGroupMember.NEXT = 0;
    END;

    [External]
    PROCEDURE AddPermissionSetToUser@4(UserGroupCode@1000 : Code[20];UserSecurityID@1001 : GUID;SelectedCompany@1002 : Text[30];RoleID@1004 : Code[20];AppID@1006 : GUID;ItemScope@1009 : Integer);
    VAR
      AccessControl@1003 : Record 2000000053;
      AccessControlExists@1005 : Boolean;
    BEGIN
      // If this is the first assignment via a user group and the user already had a manually defined access control,
      // we add a 'null' record for it.
      IF GET(UserGroupCode,UserSecurityID,RoleID,SelectedCompany,ItemScope,AppID) THEN
        EXIT;
      AccessControlExists := AccessControl.GET(UserSecurityID,RoleID,SelectedCompany,ItemScope,AppID);
      RESET;
      INIT;
      "User Group Code" := '';
      "User Security ID" := UserSecurityID;
      "Role ID" := RoleID;
      "Company Name" := SelectedCompany;
      "App ID" := AppID;
      Scope := ItemScope;
      IF AccessControlExists THEN BEGIN
        SETRANGE("User Security ID",UserSecurityID);
        SETRANGE("Role ID",RoleID);
        SETRANGE("Company Name",SelectedCompany);
        SETRANGE(Scope,ItemScope);
        SETRANGE("App ID",AppID);
        IF ISEMPTY THEN
          INSERT;
      END;
      "User Group Code" := UserGroupCode;
      INSERT;
      IF NOT AccessControlExists THEN BEGIN
        AccessControl.INIT;
        AccessControl."User Security ID" := UserSecurityID;
        AccessControl."Role ID" := RoleID;
        AccessControl."Company Name" := SelectedCompany;
        AccessControl.Scope := ItemScope;
        AccessControl."App ID" := AppID;
        AccessControl.INSERT;
      END;
    END;

    [External]
    PROCEDURE RemovePermissionSetFromUser@8(UserGroupCode@1000 : Code[20];UserSecurityID@1001 : GUID;SelectedCompany@1002 : Text[30];RoleID@1004 : Code[20];AppID@1007 : GUID;ItemScope@1009 : Integer);
    VAR
      AccessControl@1003 : Record 2000000053;
      AccessControlExists@1005 : Boolean;
      ReferenceExists@1006 : Boolean;
    BEGIN
      // If this is the last assignment via a user group and the user does not have a manually defined access control,
      // we remove the 'null' record for it if it exists.
      IF NOT GET(UserGroupCode,UserSecurityID,RoleID,SelectedCompany,ItemScope,AppID) THEN
        EXIT;
      DELETE;
      AccessControlExists := AccessControl.GET(UserSecurityID,RoleID,SelectedCompany,ItemScope,AppID);
      IF AccessControlExists THEN BEGIN
        RESET;
        SETRANGE("User Security ID",UserSecurityID);
        SETRANGE("Role ID",RoleID);
        SETRANGE("Company Name",SelectedCompany);
        SETRANGE(Scope,ItemScope);
        SETRANGE("App ID",AppID);
        ReferenceExists := FINDLAST;
        IF NOT ReferenceExists THEN
          AccessControl.DELETE;
        IF ReferenceExists AND ("User Group Code" = '') THEN
          DELETE;
      END;
    END;

    BEGIN
    END.
  }
}

