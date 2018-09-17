OBJECT Page 8638 Configuration Completion
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Afslutning af konfiguration;
               ENU=Configuration Completion];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table8627;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Ops‘tning;
                                ENU=New,Process,Report,Setup];
    ShowFilter=No;
    OnInit=BEGIN
             YourProfileCode := "Your Profile Code";
           END;

    OnClosePage=BEGIN
                  SelectDefaultRoleCenter("Your Profile Code","Your Profile App ID","Your Profile Scope");
                END;

    ActionList=ACTIONS
    {
      { 4       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Ops‘tning;
                                 ENU=Setup] }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Brugere;
                                 ENU=Users];
                      ToolTipML=[DAN=Vis eller rediger brugere, der skal konfigureres i databasen.;
                                 ENU=View or edit users that will be configured in the database.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9800;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=User;
                      PromotedCategory=Category4 }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=Brugertilpasning;
                                 ENU=Users Personalization];
                      ToolTipML=[DAN=Vis eller rediger gr‘nseflade‘ndringer, der skal konfigureres i databasen.;
                                 ENU=View or edit UI changes that will be configured in the database.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9173;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=UserSetup;
                      PromotedCategory=Category4 }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=F‘rdigg›re ops‘tning;
                           ENU=Complete Setup];
                GroupType=Group }

    { 6   ;2   ;Group     ;
                GroupType=Group }

    { 5   ;3   ;Field     ;
                Name=BeforeSetupCloseMessage;
                CaptionML=[DAN=Hvis du er f‘rdig med at ops‘tte din virksomhed, skal du v‘lge, hvilken profil du ›nsker at bruge som standard, og derefter klikke p† OK for at lukke siden. Derefter skal du genstarte Microsoft Dynamics NAV-klienten for at anvende ‘ndringerne.;
                           ENU=If you have finished setting up the company, select the profile that you want to use as your default, and then choose the OK button to close the page. Then restart the Microsoft Dynamics NAV client to apply the changes.];
                ToolTipML=[DAN=Angiver, hvordan du fuldf›rer ops‘tning af din virksomhed.;
                           ENU=Specifies how to finish setting up your company.];
                ApplicationArea=#Basic,#Suite }

    { 3   ;3   ;Field     ;
                Name=Your Profile Code;
                DrillDown=No;
                ToolTipML=[DAN=Angiver profilkoden for konfigurationsl›sningen og -pakken.;
                           ENU=Specifies the profile code for your configuration solution and package.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=YourProfileCode;
                Editable=False;
                OnAssistEdit=VAR
                               AllProfileTable@1000 : Record 2000000178;
                             BEGIN
                               IF PAGE.RUNMODAL(PAGE::"Available Profiles",AllProfileTable) = ACTION::LookupOK THEN BEGIN
                                 YourProfileCode := AllProfileTable."Profile ID";
                                 "Your Profile Code" := AllProfileTable."Profile ID";
                                 "Your Profile App ID" := AllProfileTable."App ID";
                                 "Your Profile Scope" := AllProfileTable.Scope;
                               END;
                             END;
                              }

  }
  CODE
  {
    VAR
      YourProfileCode@1000 : Code[30];

    BEGIN
    END.
  }
}

