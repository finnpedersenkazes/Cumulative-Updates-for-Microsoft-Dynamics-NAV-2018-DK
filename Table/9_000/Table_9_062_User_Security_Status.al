OBJECT Table 9062 User Security Status
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
    CaptionML=[DAN=Status for brugersikkerhed;
               ENU=User Security Status];
    LookupPageID=Page9818;
  }
  FIELDS
  {
    { 1   ;   ;User Security ID    ;GUID          ;TableRelation=User."User Security ID";
                                                   DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Brugersikkerheds-id;
                                                              ENU=User Security ID] }
    { 2   ;   ;User Name           ;Code50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."User Name" WHERE (User Security ID=FIELD(User Security ID)));
                                                   CaptionML=[DAN=Brugernavn;
                                                              ENU=User Name] }
    { 3   ;   ;Full Name           ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."Full Name" WHERE (User Security ID=FIELD(User Security ID)));
                                                   CaptionML=[DAN=Fulde navn;
                                                              ENU=Full Name] }
    { 13  ;   ;Reviewed            ;Boolean       ;CaptionML=[DAN=Gennemset;
                                                              ENU=Reviewed] }
    { 14  ;   ;Belongs To Subscription Plan;Boolean;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Exist("User Plan" WHERE (User Security ID=FIELD(User Security ID)));
                                                   CaptionML=[DAN=Tilh�rer abonnementsplan;
                                                              ENU=Belongs To Subscription Plan] }
    { 15  ;   ;Belongs to User Group;Boolean      ;FieldClass=FlowField;
                                                   CalcFormula=Exist("User Group Member" WHERE (User Security ID=FIELD(User Security ID)));
                                                   CaptionML=[DAN=Tilh�rer brugergruppe;
                                                              ENU=Belongs to User Group] }
    { 20  ;   ;Users - To review   ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=[Count("User Security Status" WHERE (Reviewed=CONST(No),
                                                                                                    User Security ID=FILTER(<>{00000000-0000-0000-0000-000000000000})))];
                                                   CaptionML=[DAN=Brugere - til gennemsyn;
                                                              ENU=Users - To review] }
    { 21  ;   ;Users - Without Subscriptions;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=[Count("User Security Status" WHERE (Belongs To Subscription Plan=CONST(No),
                                                                                                    User Security ID=FILTER(<>{00000000-0000-0000-0000-000000000000})))];
                                                   CaptionML=[DAN=Brugere - uden abonnementer;
                                                              ENU=Users - Without Subscriptions] }
    { 22  ;   ;Users - Not Group Members;Integer  ;FieldClass=FlowField;
                                                   CalcFormula=[Count("User Security Status" WHERE (Belongs to User Group=CONST(No),
                                                                                                    User Security ID=FILTER(<>{00000000-0000-0000-0000-000000000000})))];
                                                   CaptionML=[DAN=Brugere - ikke gruppemedlemmer;
                                                              ENU=Users - Not Group Members] }
  }
  KEYS
  {
    {    ;User Security ID                        ;Clustered=Yes }
    {    ;Reviewed                                 }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      UserNotReviewedTxt@1001 : TextConst '@@@="%1 = user name";DAN=Bruger %1: ikke gennemset.;ENU=User %1: not reviewed.';
      UserReviewedTxt@1000 : TextConst '@@@=%1: User name;DAN=Bruger %1: gennemset.;ENU=User %1: reviewed.';
      SecurityActivityTok@1003 : TextConst 'DAN=Brugers gennemsyn;ENU=User review';
      SecurityContextTok@1002 : TextConst 'DAN=Sikkerhedsadministration;ENU=Security administration';

    [External]
    PROCEDURE KeepOnlyEnabledUsers@1();
    VAR
      User@1000 : Record 2000000120;
      UserSecurityStatus@1001 : Record 9062;
    BEGIN
      User.SETRANGE(State,User.State::Disabled);
      IF NOT User.FINDSET THEN
        EXIT;
      REPEAT
        IF UserSecurityStatus.GET(User."User Security ID") THEN
          UserSecurityStatus.DELETE;
      UNTIL User.NEXT = 0;
    END;

    [Internal]
    PROCEDURE LoadUsers@2();
    VAR
      User@1000 : Record 2000000120;
      UserSecurityStatus@1001 : Record 9062;
      UserPlan@1002 : Record 9005;
      PermissionManager@1003 : Codeunit 9002;
      IsSaaS@1004 : Boolean;
    BEGIN
      User.SETRANGE(State,User.State::Enabled);
      HideExternalUsers(User);
      IF NOT User.FINDSET THEN
        EXIT;

      IsSaaS := PermissionManager.SoftwareAsAService;
      REPEAT
        IF UserSecurityStatus.GET(User."User Security ID") THEN BEGIN
          UserPlan.SETRANGE("User Security ID","User Security ID");
          IF UserPlan.ISEMPTY AND IsSaaS THEN BEGIN
            UserSecurityStatus.Reviewed := FALSE;
            UserSecurityStatus.MODIFY(TRUE);
          END;
        END ELSE BEGIN
          UserSecurityStatus.INIT;
          UserSecurityStatus."User Security ID" := User."User Security ID";
          UserSecurityStatus.Reviewed := FALSE;
          UserSecurityStatus.INSERT;
        END;
      UNTIL User.NEXT = 0;
    END;

    [External]
    PROCEDURE LogUserReviewActivity@3();
    VAR
      ActivityLog@1001 : Record 710;
      ActivityMessage@1000 : Text[250];
    BEGIN
      CALCFIELDS("User Name");
      IF Reviewed THEN
        ActivityMessage := STRSUBSTNO(UserReviewedTxt,"User Name")
      ELSE
        ActivityMessage := STRSUBSTNO(UserNotReviewedTxt,"User Name");
      ActivityLog.LogActivity(RECORDID,ActivityLog.Status::Success,SecurityContextTok,SecurityActivityTok,ActivityMessage);
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

