OBJECT Page 9170 Profile Card
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Profilkort;
               ENU=Profile Card];
    SourceTable=Table2000000178;
    DataCaptionExpr="Profile ID" + ' ' + Description;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Ressourceovers‘ttelse;
                                ENU=New,Process,Report,Resource Translation];
    OnOpenPage=VAR
                 FileManagement@1000 : Codeunit 419;
                 PermissionManager@1001 : Codeunit 9002;
               BEGIN
                 RoleCenterSubtype := RoleCenterTxt;
                 CanRunDotNetOnClient := FileManagement.CanRunDotNetOnClient;
                 IsSaaS := PermissionManager.SoftwareAsAService;
                 IF "Profile ID" = '' THEN
                   IsNewProfile := TRUE;
               END;

    OnNewRecord=BEGIN
                  IF IsSaaS THEN
                    Scope := Scope::Tenant;
                END;

    OnInsertRecord=BEGIN
                     IF "Default Role Center" THEN
                       ConfPersonalizationMgt.ChangeDefaultRoleCenter(Rec);
                   END;

    OnModifyRecord=BEGIN
                     IF "Default Role Center" THEN
                       ConfPersonalizationMgt.ChangeDefaultRoleCenter(Rec);
                   END;

    OnDeleteRecord=BEGIN
                     ConfPersonalizationMgt.ValidateDeleteProfile(Rec);
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Profil;
                                 ENU=&Profile];
                      Image=User }
      { 17      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=Vis en liste over alle profiler.;
                                 ENU=View a list of all profiles.];
                      ApplicationArea=#Basic,#Suite;
                      Image=OpportunitiesList;
                      OnAction=VAR
                                 ProfileList@1102601000 : Page 9171;
                               BEGIN
                                 ProfileList.LOOKUPMODE := TRUE;
                                 ProfileList.SETRECORD(Rec);
                                 IF ProfileList.RUNMODAL = ACTION::LookupOK THEN
                                   ProfileList.GETRECORD(Rec);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktioner;
                                 ENU=F&unctions];
                      Image=Action }
      { 33      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier profil;
                                 ENU=Copy Profile];
                      ToolTipML=[DAN=Kopi‚r en eksisterende profil for at oprette en ny profil baseret p† det samme indhold.;
                                 ENU=Copy an existing profile to create a new profile based on the same content.];
                      ApplicationArea=#Basic,#Suite;
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
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=Fjern &konfigurerede sider;
                                 ENU=C&lear Configured Pages];
                      ToolTipML=[DAN=Slet alle konfigurationer, der er lavet til profilen.;
                                 ENU=Delete all configurations that are made for the profile.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=NOT IsSaaS;
                      Enabled=Scope = Scope::System;
                      Image=Cancel;
                      OnAction=BEGIN
                                 ConfPersonalizationMgt.ClearProfileConfiguration(Rec);
                               END;
                                }
      { 50      ;2   ;Separator  }
      { 22      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udl‘s profiler;
                                 ENU=E&xport Profiles];
                      ToolTipML=[DAN=Eksporter en profil, for eksempel for at genbruge brugergr‘nsefladekonfigurationer i andre Dynamics NAV-databaser.;
                                 ENU=Export a profile, for example to reuse UI configurations in other Dynamics NAV databases.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=NOT IsSaaS;
                      Enabled=Scope = Scope::System;
                      Image=Export;
                      OnAction=VAR
                                 Profile@1001 : Record 2000000178;
                               BEGIN
                                 Profile.SETRANGE("Profile ID","Profile ID");
                                 REPORT.RUN(REPORT::"Export Profiles",TRUE,FALSE,Profile);
                               END;
                                }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ressourceovers‘ttelse;
                                 ENU=Resource Translation] }
      { 18      ;2   ;Action    ;
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
                                 Profile@1002 : Record 2000000178;
                                 ConfPersonalizationMgt@1001 : Codeunit 9170;
                               BEGIN
                                 Profile.SETRANGE("Profile ID","Profile ID");
                                 ConfPersonalizationMgt.ImportTranslatedResourcesWithFolderSelection(Profile);
                               END;
                                }
      { 16      ;2   ;Action    ;
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
                                 Profile@1000 : Record 2000000178;
                                 ConfPersonalizationMgt@1001 : Codeunit 9170;
                               BEGIN
                                 Profile.SETRANGE("Profile ID","Profile ID");
                                 ConfPersonalizationMgt.ImportTranslatedResources(Profile,'',TRUE);
                               END;
                                }
      { 15      ;2   ;Action    ;
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
                                 Profile@1002 : Record 2000000178;
                                 ConfPersonalizationMgt@1001 : Codeunit 9170;
                               BEGIN
                                 Profile.SETRANGE("Profile ID","Profile ID");
                                 Profile.SETRANGE(Scope,Profile.Scope::System);
                                 ConfPersonalizationMgt.ExportTranslatedResourcesWithFolderSelection(Profile);
                               END;
                                }
      { 6       ;2   ;Action    ;
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
                                 Profile@1002 : Record 2000000178;
                                 ConfPersonalizationMgt@1001 : Codeunit 9170;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Profile);
                                 Profile.SETRANGE(Scope,Profile.Scope::System);
                                 ConfPersonalizationMgt.RemoveTranslatedResourcesWithLanguageSelection(Profile);
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
                           ENU=General];
                Editable=(NOT IsSaaS) OR ((Scope = Scope::Tenant) AND IsSaaS) }

    { 24  ;2   ;Group     ;
                GroupType=Group }

    { 7   ;3   ;Field     ;
                Name=Scope;
                CaptionML=[DAN=Omr†de;
                           ENU=Scope];
                ToolTipML=[DAN=Angiver, om profilen er standard for systemet eller vedr›rer en lejerdatabase.;
                           ENU=Specifies if the profile is general for the system or applies to a tenant database.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Scope;
                Enabled=IsNewProfile AND NOT (IsSaaS) }

    { 21  ;3   ;Field     ;
                CaptionML=[DAN=Udvidelsesnavn;
                           ENU=Extension Name];
                ToolTipML=[DAN=Angiver navnet p† den udvidelse, der leverede profilen.;
                           ENU=Specifies the name of the extension that provided the profile.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="App Name";
                Enabled=False }

    { 2   ;3   ;Field     ;
                CaptionML=[DAN=Profil-id;
                           ENU=Profile ID];
                ToolTipML=[DAN=Angiver profilens id (navn).;
                           ENU=Specifies the ID (name) of the profile.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="Profile ID" }

    { 8   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af profilen.;
                           ENU=Specifies a description of the profile.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 11  ;3   ;Field     ;
                CaptionML=[DAN=Rollecenter-id;
                           ENU=Role Center ID];
                ToolTipML=[DAN=Angiver id'et p† det Rollecenter, som er knyttet til profilen.;
                           ENU=Specifies the ID of the Role Center associated with the profile.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Role Center ID";
                OnValidate=VAR
                             AllObjWithCaption@1102601001 : Record 2000000058;
                           BEGIN
                             IF "Default Role Center" THEN
                               TESTFIELD("Role Center ID");

                             AllObjWithCaption.GET(AllObjWithCaption."Object Type"::Page,"Role Center ID");
                             AllObjWithCaption.TESTFIELD("Object Subtype",RoleCenterSubtype);
                           END;

                OnLookup=VAR
                           AllObjWithCaption@1003 : Record 2000000058;
                           AllObjectsWithCaption@1002 : Page 9174;
                         BEGIN
                           AllObjWithCaption.SETRANGE("Object Type",AllObjWithCaption."Object Type"::Page);
                           AllObjWithCaption.SETRANGE("Object Subtype",RoleCenterSubtype);
                           AllObjectsWithCaption.SETTABLEVIEW(AllObjWithCaption);

                           IF AllObjWithCaption.GET(AllObjWithCaption."Object Type"::Page,"Role Center ID") THEN
                             AllObjectsWithCaption.SETRECORD(AllObjWithCaption);

                           AllObjectsWithCaption.LOOKUPMODE := TRUE;
                           IF AllObjectsWithCaption.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             AllObjectsWithCaption.GETRECORD(AllObjWithCaption);
                             VALIDATE("Role Center ID",AllObjWithCaption."Object ID");
                           END;
                         END;
                          }

    { 4   ;3   ;Field     ;
                CaptionML=[DAN=Standardrollecenter;
                           ENU=Default Role Center];
                ToolTipML=[DAN=Angiver, om det Rollecenter, der er tilknyttet denne profil, er standardrollecenteret.;
                           ENU=Specifies whether the Role Center associated with this profile is the default Role Center.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Default Role Center";
                Enabled=NOT IsSaaS;
                OnValidate=BEGIN
                             TESTFIELD("Profile ID");
                             TESTFIELD("Role Center ID");
                           END;
                            }

    { 5   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om tilpasning er deaktiveret for brugere af profilen.;
                           ENU=Specifies whether personalization is disabled for users of the profile.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Disable Personalization" }

    { 3   ;2   ;Group     ;
                CaptionML=[DAN=OneNote;
                           ENU=OneNote];
                Enabled=Scope = Scope::System;
                GroupType=Group }

    { 9   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger, der bruges af integrationsfunktionen i OneNote. Hvis du vil have flere oplysninger, kan du se S†dan konfigureres OneNote-integration for en gruppe brugere.;
                           ENU=Specifies information used by the OneNote integration feature. For more information, see How to: Set up OneNote Integration for a Group of Users.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Use Record Notes" }

    { 10  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger, der bruges af integrationsfunktionen i OneNote. Hvis du vil have flere oplysninger, kan du se S†dan konfigureres OneNote-integration for en gruppe brugere.;
                           ENU=Specifies information used by the OneNote integration feature. For more information, see How to: Set up OneNote Integration for a Group of Users.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Record Notebook" }

    { 12  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger, der bruges af integrationsfunktionen i OneNote. Hvis du vil have flere oplysninger, kan du se S†dan konfigureres OneNote-integration for en gruppe brugere.;
                           ENU=Specifies information used by the OneNote integration feature. For more information, see How to: Set up OneNote Integration for a Group of Users.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Use Page Notes" }

    { 14  ;3   ;Field     ;
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
      ConfPersonalizationMgt@1000 : Codeunit 9170;
      RoleCenterSubtype@1102601000 : Text[30];
      RoleCenterTxt@1001 : TextConst '@@@={Locked};DAN=RoleCenter;ENU=RoleCenter';
      CanRunDotNetOnClient@1002 : Boolean;
      IsNewProfile@1003 : Boolean;
      IsSaaS@1004 : Boolean;

    BEGIN
    END.
  }
}

