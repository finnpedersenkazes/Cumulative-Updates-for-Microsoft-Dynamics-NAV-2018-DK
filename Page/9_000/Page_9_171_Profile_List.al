OBJECT Page 9171 Profile List
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
    CaptionML=[DAN=Profilliste;
               ENU=Profile List];
    SourceTable=Table2000000178;
    PageType=List;
    CardPageID=Profile Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Ressourceovers‘ttelse;
                                ENU=New,Process,Report,Resource Translation];
    OnOpenPage=VAR
                 FileManagement@1000 : Codeunit 419;
                 PermissionManager@1001 : Codeunit 9002;
                 ConfPersonalizationMgt@1002 : Codeunit 9170;
               BEGIN
                 CanRunDotNetOnClient := FileManagement.CanRunDotNetOnClient;
                 RoleCenterSubtype := RoleCenterTxt;
                 IsSaaS := PermissionManager.SoftwareAsAService;
                 ConfPersonalizationMgt.HideSandboxProfiles(Rec);
               END;

    OnFindRecord=BEGIN
                   EXIT(FindFirstAllowedRec(Which));
                 END;

    OnNextRecord=BEGIN
                   EXIT(FindNextAllowedRec(Steps));
                 END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102601007;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 17      ;2   ;Action    ;
                      Name=SetDefaultRoleCenter;
                      CaptionML=[DAN=Angiv standardrollecenter;
                                 ENU=Set Default Role Center];
                      ToolTipML=[DAN=Angiv, at dette Rollecenter †bnes som standard, n†r brugeren starter klienten.;
                                 ENU=Specify that this Role Center will open by default when the user starts the client.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsSaaS;
                      Image=Default;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ConfPersonalizationMgt@1000 : Codeunit 9170;
                               BEGIN
                                 TESTFIELD("Profile ID");
                                 TESTFIELD("Role Center ID");
                                 VALIDATE("Default Role Center",TRUE);
                                 MODIFY;
                                 ConfPersonalizationMgt.ChangeDefaultRoleCenter(Rec);
                               END;
                                }
      { 1102601008;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier profil;
                                 ENU=Copy Profile];
                      ToolTipML=[DAN=Kopi‚r en eksisterende profil for at oprette en ny profil baseret p† det samme indhold.;
                                 ENU=Copy an existing profile to create a new profile based on the same content.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Copy;
                      OnAction=VAR
                                 Profile@1035 : Record 2000000178;
                                 CopyProfile@1034 : Report 9170;
                               BEGIN
                                 Profile.SETRANGE("Profile ID","Profile ID");
                                 CopyProfile.SETTABLEVIEW(Profile);
                                 CopyProfile.RUNMODAL;

                                 IF GET(Profile.Scope,Profile."App ID",CopyProfile.GetProfileID) THEN;
                               END;
                                }
      { 4       ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indl‘s profil;
                                 ENU=Import Profile];
                      ToolTipML=[DAN=Implementer brugergr‘nsefladekonfigurationer for en profil ved at importere en XML-fil, der indeholder den konfigurerede profil.;
                                 ENU=Implement UI configurations for a profile by importing an XML file that holds the configured profile.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsSaaS;
                      Enabled=Scope = Scope::System;
                      Image=Import;
                      OnAction=BEGIN
                                 COMMIT;
                                 REPORT.RUNMODAL(REPORT::"Import Profiles",FALSE);
                                 COMMIT;
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Name=ExportProfiles;
                      CaptionML=[DAN=Udl‘s profiler;
                                 ENU=Export Profiles];
                      ToolTipML=[DAN=Eksporter en profil, for eksempel for at genbruge brugergr‘nsefladekonfigurationer i andre Dynamics NAV-databaser.;
                                 ENU=Export a profile, for example to reuse UI configurations in other Dynamics NAV databases.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsSaaS;
                      Enabled=Scope = Scope::System;
                      Image=Export;
                      OnAction=VAR
                                 Profile@1000 : Record 2000000178;
                                 ConfPersonalizationMgt@1001 : Codeunit 9170;
                               BEGIN
                                 AlertIfTenantProfileSelected;
                                 CurrPage.SETSELECTIONFILTER(Profile);
                                 Profile.SETRANGE(Scope,Profile.Scope::System);
                                 ConfPersonalizationMgt.ExportProfilesInZipFile(Profile);
                               END;
                                }
      { 14      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ressourceovers‘ttelse;
                                 ENU=Resource Translation] }
      { 6       ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Import‚r oversatte profilressourcer fra mappe;
                                 ENU=Import Translated Profile Resources From Folder];
                      ToolTipML=[DAN=Importer de oversatte profildata til profilen fra en mappe.;
                                 ENU=Import the translated profile data into the profile from a folder.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=CanRunDotNetOnClient AND (NOT IsSaaS);
                      Enabled=Scope = Scope::System;
                      Image=Language;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ProfileRec@1002 : Record 2000000178;
                                 ConfPersonalizationMgt@1001 : Codeunit 9170;
                               BEGIN
                                 AlertIfTenantProfileSelected;
                                 CurrPage.SETSELECTIONFILTER(ProfileRec);
                                 ConfPersonalizationMgt.ImportTranslatedResourcesWithFolderSelection(ProfileRec);
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Import‚r oversatte profilressourcer fra zipfil;
                                 ENU=Import Translated Profile Resources From Zip File];
                      ToolTipML=[DAN=Importer de oversatte profildata til profilen fra en zipfil.;
                                 ENU=Import the translated profile data into the profile from a Zip file.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsSaaS;
                      Enabled=Scope = Scope::System;
                      Image=Language;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ProfileRec@1002 : Record 2000000178;
                                 ConfPersonalizationMgt@1001 : Codeunit 9170;
                               BEGIN
                                 AlertIfTenantProfileSelected;
                                 CurrPage.SETSELECTIONFILTER(ProfileRec);
                                 ConfPersonalizationMgt.ImportTranslatedResources(ProfileRec,'',TRUE);
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Eksport‚r oversatte profilressourcer;
                                 ENU=Export Translated Profile Resources];
                      ToolTipML=[DAN=G›r klar til at udf›re brugerdefineret overs‘ttelse af profiler ved at eksportere og importere ressourcefiler (.resx).;
                                 ENU=Prepare to perform customized translation of profiles by exporting and importing resource (.resx) files.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsSaaS;
                      Enabled=Scope = Scope::System;
                      Image=ExportAttachment;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ProfileRec@1002 : Record 2000000178;
                                 ConfPersonalizationMgt@1001 : Codeunit 9170;
                               BEGIN
                                 AlertIfTenantProfileSelected;
                                 CurrPage.SETSELECTIONFILTER(ProfileRec);
                                 ProfileRec.SETRANGE(Scope,ProfileRec.Scope::System);
                                 ConfPersonalizationMgt.ExportTranslatedResourcesWithFolderSelection(ProfileRec);
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Fjern oversatte profilressourcer;
                                 ENU=Remove Translated Profile Resources];
                      ToolTipML=[DAN=Fjern den oversatte ressource fra profilen.;
                                 ENU=Remove the translated resource from the profile.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsSaaS;
                      Enabled=Scope = Scope::System;
                      Image=RemoveLine;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ProfileRec@1002 : Record 2000000178;
                                 ConfPersonalizationMgt@1001 : Codeunit 9170;
                               BEGIN
                                 AlertIfTenantProfileSelected;
                                 CurrPage.SETSELECTIONFILTER(ProfileRec);
                                 ProfileRec.SETRANGE(Scope,ProfileRec.Scope::System);
                                 ConfPersonalizationMgt.RemoveTranslatedResourcesWithLanguageSelection(ProfileRec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Profil-id;
                           ENU=Profile ID];
                ToolTipML=[DAN=Angiver profilens id (navn).;
                           ENU=Specifies the ID (name) of the profile.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="Profile ID" }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description];
                ToolTipML=[DAN=Angiver en beskrivelse af profilen.;
                           ENU=Specifies a description of the profile.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 20  ;2   ;Field     ;
                CaptionML=[DAN=Omr†de;
                           ENU=Scope];
                ToolTipML=[DAN=Angiver, om profilen er standard for systemet eller vedr›rer en lejerdatabase.;
                           ENU=Specifies if the profile is general for the system or applies to a tenant database.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Scope }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Udvidelsesnavn;
                           ENU=Extension Name];
                ToolTipML=[DAN=Angiver navnet p† den udvidelse, der leverede profilen.;
                           ENU=Specifies the name of the extension that provided the profile.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="App Name" }

    { 15  ;2   ;Field     ;
                Lookup=No;
                CaptionML=[DAN=Rollecenter-id;
                           ENU=Role Center ID];
                ToolTipML=[DAN=Angiver id'et p† det Rollecenter, som er knyttet til profilen.;
                           ENU=Specifies the ID of the Role Center associated with the profile.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Role Center ID" }

    { 1102601000;2;Field  ;
                CaptionML=[DAN=Standardrollecenter;
                           ENU=Default Role Center];
                ToolTipML=[DAN=Angiver, om det Rollecenter, der er tilknyttet denne profil, er standardrollecenteret.;
                           ENU=Specifies whether the Role Center associated with this profile is the default Role Center.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Default Role Center" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om tilpasning er deaktiveret for brugere af profilen.;
                           ENU=Specifies whether personalization is disabled for users of the profile.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Disable Personalization" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger, der bruges af integrationsfunktionen i OneNote. Hvis du vil have flere oplysninger, kan du se S†dan konfigureres OneNote-integration for en gruppe brugere.;
                           ENU=Specifies information used by the OneNote integration feature. For more information, see How to: Set up OneNote Integration for a Group of Users.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Use Record Notes" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger, der bruges af integrationsfunktionen i OneNote. Hvis du vil have flere oplysninger, kan du se S†dan konfigureres OneNote-integration for en gruppe brugere.;
                           ENU=Specifies information used by the OneNote integration feature. For more information, see How to: Set up OneNote Integration for a Group of Users.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Record Notebook" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger, der bruges af integrationsfunktionen i OneNote. Hvis du vil have flere oplysninger, kan du se S†dan konfigureres OneNote-integration for en gruppe brugere.;
                           ENU=Specifies information used by the OneNote integration feature. For more information, see How to: Set up OneNote Integration for a Group of Users.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Use Page Notes" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger, der bruges af integrationsfunktionen i OneNote. Hvis du vil have flere oplysninger, kan du se S†dan konfigureres OneNote-integration for en gruppe brugere.;
                           ENU=Specifies information used by the OneNote integration feature. For more information, see How to: Set up OneNote Integration for a Group of Users.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Page Notebook" }

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
      CanRunDotNetOnClient@1001 : Boolean;
      RoleCenterSubtype@1000 : Text;
      RoleCenterTxt@1002 : TextConst '@@@={Locked};DAN=RoleCenter;ENU=RoleCenter';
      ListContainsTenantProfilesErr@1004 : TextConst 'DAN=Lejerprofiler underst›tter ikke denne handling. Fjern eventuelle lejerprofiler fra markeringen, og pr›v igen.;ENU=Tenant Profiles does not support this action. Please remove any Tenant Profiles from selection and try again.';
      IsSaaS@1003 : Boolean;

    [External]
    PROCEDURE FindFirstAllowedRec@13(Which@1000 : Text[1024]) : Boolean;
    BEGIN
      IF FIND(Which) THEN
        REPEAT
          IF RoleCenterExist("Role Center ID") THEN
            EXIT(TRUE);
        UNTIL NEXT = 0;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE FindNextAllowedRec@14(Steps@1000 : Integer) : Integer;
    VAR
      ProfileBrowser@1001 : Record 2000000178;
      RealSteps@1003 : Integer;
      NextSteps@1002 : Integer;
    BEGIN
      RealSteps := 0;
      IF Steps <> 0 THEN BEGIN
        ProfileBrowser := Rec;
        REPEAT
          NextSteps := NEXT(Steps / ABS(Steps));
          IF RoleCenterExist("Role Center ID") THEN BEGIN
            RealSteps := RealSteps + NextSteps;
            ProfileBrowser := Rec;
          END;
        UNTIL (NextSteps = 0) OR (RealSteps = Steps);
        Rec := ProfileBrowser;
        IF NOT FIND THEN ;
      END;
      EXIT(RealSteps);
    END;

    LOCAL PROCEDURE RoleCenterExist@1(PageID@1000 : Integer) : Boolean;
    VAR
      AllObjWithCaption@1002 : Record 2000000058;
    BEGIN
      IF (PageID = PAGE::"O365 Sales Activities RC") OR (PageID = PAGE::"O365 Invoicing RC") THEN
        EXIT(FALSE);
      AllObjWithCaption.SETRANGE("Object Type",AllObjWithCaption."Object Type"::Page);
      AllObjWithCaption.SETRANGE("Object Subtype",RoleCenterSubtype);
      AllObjWithCaption.SETRANGE("Object ID",PageID);
      EXIT(NOT AllObjWithCaption.ISEMPTY);
    END;

    LOCAL PROCEDURE IsTenantProfileSelected@3() : Boolean;
    VAR
      Profile@1000 : Record 2000000178;
    BEGIN
      CurrPage.SETSELECTIONFILTER(Profile);
      Profile.SETRANGE(Scope,Profile.Scope::Tenant);
      IF Profile.FINDFIRST THEN
        EXIT(TRUE);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE AlertIfTenantProfileSelected@4();
    BEGIN
      IF IsTenantProfileSelected THEN
        ERROR(ListContainsTenantProfilesErr);
    END;

    BEGIN
    END.
  }
}

