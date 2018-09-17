OBJECT Page 9172 User Personalization Card
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Brugertilpasningskort;
               ENU=User Personalization Card];
    SourceTable=Table2000000073;
    DataCaptionExpr="User ID";
    DelayedInsert=Yes;
    PageType=Card;
    OnOpenPage=BEGIN
                 HideExternalUsers;
               END;

    OnInsertRecord=BEGIN
                     TESTFIELD("User SID");
                   END;

    OnModifyRecord=BEGIN
                     TESTFIELD("User SID");
                   END;

    OnAfterGetCurrRecord=BEGIN
                           ProfileID := "Profile ID";
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Brugertil&pasning;
                                 ENU=User &Personalization];
                      Image=Grid }
      { 14      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=Vis eller rediger en liste over alle brugere, der har tilpasset deres brugergr‘nseflade ved at tilpasse en eller flere sider.;
                                 ENU=View or edit a list of all users who have personalized their user interface by customizing one or more pages.];
                      ApplicationArea=#Basic,#Suite;
                      Image=OpportunitiesList;
                      OnAction=VAR
                                 UserPersList@1102601000 : Page 9173;
                               BEGIN
                                 UserPersList.LOOKUPMODE := TRUE;
                                 UserPersList.SETRECORD(Rec);
                                 IF UserPersList.RUNMODAL = ACTION::LookupOK THEN
                                   UserPersList.GETRECORD(Rec);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktioner;
                                 ENU=F&unctions];
                      Image=Action }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Fjern &tilpassede sider;
                                 ENU=C&lear Personalized Pages];
                      ToolTipML=[DAN=Slet alle tilpasninger, som den angivne bruger har foretaget, p† tv‘rs af visningsm†l.;
                                 ENU=Delete all personalizations made by the specified user across display targets.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Cancel;
                      OnAction=BEGIN
                                 ConfPersMgt.ClearUserPersonalization(Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 4   ;2   ;Field     ;
                DrillDown=No;
                CaptionML=[DAN=Bruger-id;
                           ENU=User ID];
                ToolTipML=[DAN=Angiver bruger-id'et for en bruger, der benytter Database Server Authentication til at logge p† Dynamics NAV.;
                           ENU=Specifies the user ID of a user who is using Database Server Authentication to log on to Dynamics NAV.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID";
                Editable=FALSE;
                OnAssistEdit=VAR
                               UserPersonalization@1005 : Record 2000000073;
                               UserMgt@1002 : Codeunit 418;
                               SID@1006 : GUID;
                               UserID@1001 : Code[50];
                             BEGIN
                               UserMgt.LookupUser(UserID,SID);

                               IF (SID <> "User SID") AND NOT ISNULLGUID(SID) THEN BEGIN
                                 IF UserPersonalization.GET(SID) THEN BEGIN
                                   UserPersonalization.CALCFIELDS("User ID");
                                   ERROR(Text000,TABLECAPTION,UserPersonalization."User ID");
                                 END;

                                 VALIDATE("User SID",SID);
                                 CALCFIELDS("User ID");

                                 CurrPage.UPDATE;
                               END;
                             END;
                              }

    { 6   ;2   ;Field     ;
                DrillDown=No;
                CaptionML=[DAN=Profil-id;
                           ENU=Profile ID];
                ToolTipML=[DAN=Angiver id'et p† den profil, som er knyttet til den aktuelle bruger.;
                           ENU=Specifies the ID of the profile that is associated with the current user.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ProfileID;
                Editable=False;
                LookupPageID=Profile List;
                OnValidate=BEGIN
                             SetExperienceToSuite("Profile ID");
                           END;

                OnAssistEdit=VAR
                               AllProfileTable@1000 : Record 2000000178;
                             BEGIN
                               IF PAGE.RUNMODAL(PAGE::"Available Profiles",AllProfileTable) = ACTION::LookupOK THEN BEGIN
                                 "Profile ID" := AllProfileTable."Profile ID";
                                 "App ID" := AllProfileTable."App ID";
                                 Scope := AllProfileTable.Scope;
                                 ProfileID := "Profile ID";
                               END
                             END;
                              }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Sprog-id;
                           ENU=Language ID];
                ToolTipML=[DAN=Angiver et id for det sprog, som Microsoft Windows er konfigureret til at k›re for den valgte bruger.;
                           ENU=Specifies the ID of the language that Microsoft Windows is set up to run for the selected user.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Language ID";
                OnValidate=VAR
                             ApplicationManagement@1001 : Codeunit 1;
                           BEGIN
                             ApplicationManagement.ValidateApplicationlLanguage("Language ID");
                           END;

                OnLookup=VAR
                           ApplicationManagement@1002 : Codeunit 1;
                         BEGIN
                           ApplicationManagement.LookupApplicationlLanguage("Language ID");

                           IF "Language ID" <> xRec."Language ID" THEN
                             VALIDATE("Language ID","Language ID");
                         END;
                          }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Landestandard-id;
                           ENU=Locale ID];
                ToolTipML=[DAN=Angiver et id for den landestandard, som Microsoft Windows er konfigureret til at k›re for den valgte bruger.;
                           ENU=Specifies the ID of the locale that Microsoft Windows is set up to run for the selected user.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Locale ID";
                TableRelation="Windows Language"."Language ID";
                Importance=Additional }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Tidszone;
                           ENU=Time Zone];
                ToolTipML=[DAN=Angiver den tidszone, som Microsoft Windows er konfigureret til at k›re for den valgte bruger.;
                           ENU=Specifies the time zone that Microsoft Windows is set up to run for the selected user.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Time Zone";
                Importance=Additional;
                OnValidate=BEGIN
                             ConfPersMgt.ValidateTimeZone("Time Zone")
                           END;

                OnLookup=BEGIN
                           EXIT(ConfPersMgt.LookupTimeZone(Text))
                         END;
                          }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Virksomhed;
                           ENU=Company];
                ToolTipML=[DAN=Angiver den virksomhed, som er knyttet til brugeren.;
                           ENU=Specifies the company that is associated with the user.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Company }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ConfPersMgt@1000 : Codeunit 9170;
      Text000@1008 : TextConst '@@@=User Personalization User1 already exists.;DAN=%1 %2 findes allerede.;ENU=%1 %2 already exists.';
      AccountantTxt@1002 : TextConst '@@@=Please translate all caps;DAN=REGNSKABSMEDARBEJDER;ENU=ACCOUNTANT';
      ProjectManagerTxt@1003 : TextConst '@@@=Please translate all caps;DAN=PROJEKTLEDER;ENU=PROJECT MANAGER';
      TeamMemberTxt@1001 : TextConst '@@@=Please translate all caps;DAN=TEAMMEDLEM;ENU=TEAM MEMBER';
      ExperienceMsg@1004 : TextConst 'DAN=Du er ved at skifte til et rollecenter, som har flere funktioner. Hvis du vil se alle funktioner for denne rolle, skal du angive indstillingen Oplevelse til Suite.;ENU=You are changing to a Role Center that has more functionality. To display the full functionality for this role, your Experience setting will be set to Suite.';
      ProfileID@1005 : Code[30];

    LOCAL PROCEDURE HideExternalUsers@5();
    VAR
      PermissionManager@1001 : Codeunit 9002;
      OriginalFilterGroup@1000 : Integer;
    BEGIN
      IF NOT PermissionManager.SoftwareAsAService THEN
        EXIT;

      OriginalFilterGroup := FILTERGROUP;
      FILTERGROUP := 2;
      CALCFIELDS("License Type");
      SETFILTER("License Type",'<>%1',"License Type"::"External User");
      FILTERGROUP := OriginalFilterGroup;
    END;

    PROCEDURE SetExperienceToSuite@8(SelectedProfileID@1003 : Text[30]);
    VAR
      ApplicationAreaSetup@1002 : Record 9178;
      CompanyInformationMgt@1001 : Codeunit 1306;
      ExperienceTier@1000 : ',,,,,Basic,,,,,,,,,,Suite,,,,,Custom,,,,,Advanced';
    BEGIN
      IF CompanyInformationMgt.IsDemoCompany THEN BEGIN
        ApplicationAreaSetup.GetExperienceTierCurrentCompany(ExperienceTier);
        IF ExperienceTier = ExperienceTier::Basic THEN
          IF (SelectedProfileID = TeamMemberTxt) OR
             (SelectedProfileID = AccountantTxt) OR
             (SelectedProfileID = ProjectManagerTxt)
          THEN BEGIN
            MESSAGE(ExperienceMsg);
            ExperienceTier := ExperienceTier::Suite;
            ApplicationAreaSetup.SetExperienceTierCurrentCompany(ExperienceTier);
          END;
      END;
    END;

    BEGIN
    END.
  }
}

