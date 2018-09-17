OBJECT Table 9001 User Group Member
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
    OnInsert=VAR
               UserGroupAccessControl@1000 : Record 9002;
             BEGIN
               UserGroupAccessControl.AddUserGroupMember("User Group Code","User Security ID","Company Name");
               CopyDefaultProfileFromUserGroupToUser("User Group Code",FALSE);
             END;

    OnModify=BEGIN
               IF ("User Group Code" <> xRec."User Group Code") OR
                  ("User Security ID" <> xRec."User Security ID") OR
                  ("Company Name" <> xRec."Company Name")
               THEN
                 ModifyUserGroupMembership;
             END;

    OnDelete=VAR
               UserGroupAccessControl@1000 : Record 9002;
               PermissionManager@1001 : Codeunit 9002;
             BEGIN
               UserGroupAccessControl.RemoveUserGroupMember("User Group Code","User Security ID","Company Name");

               // In SaaS the default profile comes from the plan and not from the user group
               IF NOT PermissionManager.SoftwareAsAService THEN
                 UpdateDefaultProfileOfUser("User Group Code");
             END;

    OnRename=BEGIN
               ModifyUserGroupMembership;
             END;

    CaptionML=[DAN=Medlem af brugergruppe;
               ENU=User Group Member];
  }
  FIELDS
  {
    { 1   ;   ;User Group Code     ;Code20        ;TableRelation="User Group";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Brugergruppekode;
                                                              ENU=User Group Code];
                                                   NotBlank=Yes }
    { 2   ;   ;User Security ID    ;GUID          ;TableRelation=User;
                                                   DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Brugersikkerheds-id;
                                                              ENU=User Security ID];
                                                   NotBlank=Yes }
    { 3   ;   ;Company Name        ;Text30        ;TableRelation=Company;
                                                   CaptionML=[DAN=Firmanavn;
                                                              ENU=Company Name] }
    { 4   ;   ;User Name           ;Code50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."User Name" WHERE (User Security ID=FIELD(User Security ID)));
                                                   CaptionML=[DAN=Brugernavn;
                                                              ENU=User Name];
                                                   Editable=No }
    { 5   ;   ;User Full Name      ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."Full Name" WHERE (User Security ID=FIELD(User Security ID)));
                                                   CaptionML=[DAN=Brugers fulde navn;
                                                              ENU=User Full Name];
                                                   Editable=No }
    { 6   ;   ;User Group Name     ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("User Group".Name WHERE (Code=FIELD(User Group Code)));
                                                   CaptionML=[DAN=Brugergruppenavn;
                                                              ENU=User Group Name];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;User Group Code,User Security ID,Company Name;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [Internal]
    PROCEDURE AddUsers@1(SelectedCompany@1002 : Text[30]);
    VAR
      User@1001 : Record 2000000120;
      UserLookup@1003 : Page 9843;
    BEGIN
      IF GETFILTER("User Group Code") = '' THEN
        EXIT;

      UserLookup.LOOKUPMODE := TRUE;
      IF UserLookup.RUNMODAL = ACTION::LookupOK THEN BEGIN
        UserLookup.GetSelectionFilter(User);
        IF User.FINDSET THEN
          REPEAT
            "User Group Code" := GETRANGEMIN("User Group Code");
            "User Security ID" := User."User Security ID";
            "Company Name" := SelectedCompany;
            IF INSERT(TRUE) THEN;
          UNTIL User.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE ModifyUserGroupMembership@5();
    VAR
      UserGroupAccessControl@1001 : Record 9002;
      UserGroupMember@1003 : Record 9001;
      DefaultProfile@1004 : Record 2000000178;
      ConfPersonalizationMgt@1002 : Codeunit 9170;
    BEGIN
      IF ISNULLGUID("User Security ID") OR ("User Group Code" = '') THEN
        EXIT;
      UserGroupAccessControl.RemoveUserGroupMember(xRec."User Group Code",xRec."User Security ID",xRec."Company Name");
      UserGroupAccessControl.AddUserGroupMember("User Group Code","User Security ID","Company Name");

      // If there is more than one User group assigned to a user, then use the company default profile
      UserGroupMember.SETRANGE("User Security ID","User Security ID");
      UserGroupMember.SETFILTER("User Group Code",'<>%1',xRec."User Group Code");
      IF NOT UserGroupMember.ISEMPTY THEN BEGIN
        // When there are more than two user groups assigned to this user, assign to him the default profile
        ConfPersonalizationMgt.GetDefaultProfile(DefaultProfile);
        CopyDefaultProfileToUser(DefaultProfile,TRUE);
        EXIT;
      END;

      // Else assign the profile of the current user group
      UpdateDefaultProfileOfUser(xRec."User Group Code");
      CopyDefaultProfileFromUserGroupToUser("User Group Code",FALSE);
    END;

    LOCAL PROCEDURE UpdateDefaultProfileOfUser@12(UserGroupCode@1003 : Code[20]);
    VAR
      UserGroupMember@1002 : Record 9001;
      UserPersonalization@1001 : Record 2000000073;
    BEGIN
      UserGroupMember.SETRANGE("User Security ID","User Security ID");
      UserGroupMember.SETFILTER("User Group Code",'<>%1',UserGroupCode);
      IF NOT UserGroupMember.FINDFIRST THEN BEGIN
        IF NOT UserPersonalization.GET("User Security ID") THEN
          EXIT;
        UserPersonalization."Profile ID" := '';
        UserPersonalization.MODIFY(TRUE);
      END ELSE
        CopyDefaultProfileFromUserGroupToUser(UserGroupMember."User Group Code",TRUE);
    END;

    LOCAL PROCEDURE CopyDefaultProfileFromUserGroupToUser@16(UserGroupCode@1003 : Code[20];Force@1000 : Boolean);
    VAR
      UserGroup@1001 : Record 9000;
      DefaultProfile@1002 : Record 2000000178;
    BEGIN
      // Updates the user's personalization, if empty, with the current default profile
      IF NOT UserGroup.GET(UserGroupCode) THEN
        EXIT; // there is no default profile to add
      IF DefaultProfile.GET(UserGroup."Default Profile Scope",UserGroup."Default Profile App ID",UserGroup."Default Profile ID") THEN
        CopyDefaultProfileToUser(DefaultProfile,Force);
    END;

    LOCAL PROCEDURE CopyDefaultProfileToUser@9(DefaultProfile@1003 : Record 2000000178;Force@1000 : Boolean);
    VAR
      UserPersonalization@1002 : Record 2000000073;
    BEGIN
      IF DefaultProfile."Profile ID" = '' THEN
        EXIT;
      // Force = TRUE overwrites the current default profile
      IF NOT UserPersonalization.GET("User Security ID") THEN BEGIN
        UserPersonalization.INIT;
        UserPersonalization."User SID" := "User Security ID";
        UserPersonalization."Profile ID" := DefaultProfile."Profile ID";
        UserPersonalization."App ID" := DefaultProfile."App ID";
        UserPersonalization.Scope := DefaultProfile.Scope;
        UserPersonalization.INSERT(TRUE);
      END ELSE
        IF (UserPersonalization."Profile ID" = '') OR Force THEN BEGIN
          UserPersonalization."Profile ID" := DefaultProfile."Profile ID";
          UserPersonalization."App ID" := DefaultProfile."App ID";
          UserPersonalization.Scope := DefaultProfile.Scope;
          UserPersonalization.MODIFY(TRUE);
        END;
    END;

    BEGIN
    END.
  }
}

