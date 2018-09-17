OBJECT Page 8629 Config. Wizard
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Velkommen til RapidStart-tjenester til Microsoft Dynamics NAV;
               ENU=Welcome to RapidStart Services for Microsoft Dynamics NAV];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table8627;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Trin 4,Trin 5;
                                ENU=New,Process,Report,Step 4,Step 5];
    ShowFilter=No;
    OnInit=VAR
             FileManagement@1000 : Codeunit 419;
           BEGIN
             CanRunDotNet := FileManagement.CanRunDotNetOnClient;
           END;

    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END ELSE BEGIN
                   "Package File Name" := '';
                   "Package Name" := '';
                   "Package Code" := '';
                   MODIFY;
                 END;
                 YourProfileCode := "Your Profile Code";
               END;

    OnClosePage=BEGIN
                  SelectDefaultRoleCenter("Your Profile Code","Your Profile App ID","Your Profile Scope");
                END;

    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=Handlinger;
                                 ENU=Actions] }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=Anvend pakke;
                                 ENU=Apply Package];
                      ToolTipML=[DAN=Importer konfigurationspakken, og anvend alle pakkedatabasedata pÜ samme tid.;
                                 ENU=Import the configuration package and apply the package database data at the same time.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=ApplyVisible;
                      PromotedIsBig=Yes;
                      Image=Apply;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IF CompleteWizard THEN
                                   ConfigVisible := TRUE
                                 ELSE
                                   ERROR(Text003);
                               END;
                                }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=Konfigurationskladde;
                                 ENU=Configuration Worksheet];
                      ToolTipML=[DAN=Planlëg og konfigurer initialiseringen af en ny lõsning, der er baseret pÜ ëldre data og debitorernes krav.;
                                 ENU=Plan and configure how to initialize a new solution based on legacy data and the customers requirements.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 8632;
                      Promoted=Yes;
                      Enabled=ConfigVisible;
                      PromotedIsBig=Yes;
                      Image=SetupLines;
                      PromotedCategory=Category4 }
      { 14      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Setup] }
      { 16      ;2   ;Action    ;
                      CaptionML=[DAN=Brugere;
                                 ENU=Users];
                      ToolTipML=[DAN=èbn listen over brugere, der er registrerede i systemet.;
                                 ENU=Open the list of users that are registered in the system.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9800;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=User;
                      PromotedCategory=Category5 }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=Brugertilpasning;
                                 ENU=Users Personalization];
                      ToolTipML=[DAN=èbn listen over tilpassede brugergrënseflader, der er registrerede i systemet.;
                                 ENU=Open the list of personalized UIs that are registered in the system.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9173;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=UserSetup;
                      PromotedCategory=Category5 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 56  ;1   ;Group     ;
                CaptionML=[DAN=Trin 1. Indtast dine virksomhedsoplysninger.;
                           ENU=Step 1. Enter your company details.] }

    { 5   ;2   ;Group     ;
                GroupType=Group }

    { 55  ;3   ;Field     ;
                CaptionML=[DAN=Navn (pÜkrëvet);
                           ENU=Name (Required)];
                ToolTipML=[DAN=Angiver navnet pÜ den virksomhed, du er ved at konfigurere.;
                           ENU=Specifies the name of your company that you are configuring.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 54  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver adressen pÜ den virksomhed, du er ved at konfigurere.;
                           ENU=Specifies an address for the company that you are configuring.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 53  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2" }

    { 52  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code" }

    { 51  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den by, hvor den virksomhed, du konfigurerer, er beliggende.;
                           ENU=Specifies the city where the company that you are configuring is located.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 50  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omrÜde.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 48  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens CVR-nummer.;
                           ENU=Specifies the customer's VAT registration number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Registration No." }

    { 47  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver branchen for den virksomhed, du konfigurerer.;
                           ENU=Specifies the type of industry that the company that you are configuring is.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Industrial Classification" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det billede, der er oprettet til virksomheden, f.eks. et firmalogo.;
                           ENU=Specifies the picture that has been set up for the company, for example, a company logo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Picture }

    { 45  ;1   ;Group     ;
                CaptionML=[DAN=Trin 2. Indtast dine kommunikationsoplysninger.;
                           ENU=Step 2. Enter communication details.] }

    { 44  ;2   ;Field     ;
                Name=Phone No.2;
                ToolTipML=[DAN=Angiver telefonnummeret til den virksomhed, du konfigurerer.;
                           ENU=Specifies the telephone number of the company that you are configuring.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver faxnummeret til den virksomhed, du konfigurerer.;
                           ENU=Specifies fax number of the company that you are configuring.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fax No." }

    { 42  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver mailadressen til den virksomhed, du konfigurerer.;
                           ENU=Specifies the email address of the company that you are configuring.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver din virksomheds websted.;
                           ENU=Specifies your company's web site.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Home Page" }

    { 37  ;1   ;Group     ;
                CaptionML=[DAN=Trin 3. Indtast betalingsoplysninger.;
                           ENU=Step 3. Enter payment details.] }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den bank, virksomheden bruger.;
                           ENU=Specifies the name of the bank the company uses.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Name" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankens afdelingsnummeret til den virksomhed, du konfigurerer.;
                           ENU=Specifies the branch number of the bank that the company that you are configuring uses.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Branch No." }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankkontonummeret til den virksomhed, du konfigurerer.;
                           ENU=Specifies the bank account number of the company that you are configuring.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account No." }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver PBS-nummeret til den virksomhed, du konfigurerer.;
                           ENU=Specifies the payment routing number of the company that you are configuring.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Routing No." }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver gironummeret til den virksomhed, du konfigurerer.;
                           ENU=Specifies the giro number of the company that you are configuring.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Giro No." }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver SWIFT-koden (internationalt bank-id) fra den primëre bank til den virksomhed, du konfigurerer.;
                           ENU=Specifies the SWIFT code (international bank identifier code) of the primary bank of the company that you are configuring.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="SWIFT Code" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det internationale bankkontonummer fra den primëre bankkonto til den virksomhed, du konfigurerer.;
                           ENU=Specifies the international bank account number of the primary bank account of the company that you are configuring.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=IBAN }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Trin 4. Vëlg pakke.;
                           ENU=Step 4. Select package.];
                GroupType=Group }

    { 2   ;2   ;Group     ;
                GroupType=Group }

    { 4   ;3   ;Field     ;
                Name=PackageFileNameRtc;
                CaptionML=[DAN=Vëlg den konfigurationspakke, du õnsker at indlëse:;
                           ENU=Select the configuration package you want to load:];
                ToolTipML=[DAN=Angiver navnet pÜ den konfigurationspakke, som du har oprettet.;
                           ENU=Specifies the name of the configuration package that you have created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Package File Name";
                Visible=CanRunDotNet;
                Editable=FALSE;
                OnValidate=BEGIN
                             IF "Package File Name" = '' THEN
                               ApplyVisible := FALSE;

                             CurrPage.UPDATE;
                           END;

                OnAssistEdit=VAR
                               FileManagement@1000 : Codeunit 419;
                               ConfigXMLExchange@1001 : Codeunit 8614;
                             BEGIN
                               IF ConfigVisible THEN
                                 ERROR(PackageIsAlreadyAppliedErr);

                               "Package File Name" :=
                                 COPYSTR(
                                   FileManagement.OpenFileDialog(
                                     Text004,'',ConfigXMLExchange.GetFileDialogFilter),1,MAXSTRLEN("Package File Name"));

                               IF "Package File Name" <> '' THEN BEGIN
                                 VALIDATE("Package File Name");
                                 ApplyVisible := TRUE;
                               END ELSE
                                 ApplyVisible := FALSE;
                             END;
                              }

    { 23  ;3   ;Field     ;
                Name=PackageFileNameWeb;
                CaptionML=[DAN=Vëlg den konfigurationspakke, du õnsker at indlëse:;
                           ENU=Select the configuration package you want to load:];
                ToolTipML=[DAN=Angiver navnet pÜ den konfigurationspakke, som du har oprettet.;
                           ENU=Specifies the name of the configuration package that you have created.];
                ApplicationArea=#Basic,#Suite,#Advanced;
                SourceExpr=PackageFileName;
                Visible=NOT CanRunDotNet;
                Editable=FALSE;
                OnValidate=BEGIN
                             IF "Package File Name" = '' THEN
                               ApplyVisible := FALSE;

                             CurrPage.UPDATE;
                           END;

                OnAssistEdit=VAR
                               FileManagement@1000 : Codeunit 419;
                               ServerFileName@1001 : Text;
                             BEGIN
                               IF ConfigVisible THEN
                                 ERROR(PackageIsAlreadyAppliedErr);

                               ServerFileName := FileManagement.UploadFile(UpdateDialogTitleTxt,'');

                               IF ServerFileName <> '' THEN
                                 VALIDATE("Package File Name",COPYSTR(ServerFileName,1,MAXSTRLEN("Package File Name")))
                               ELSE
                                 PackageFileName := '';

                               ApplyVisible := "Package File Name" <> '';

                               IF "Package File Name" <> '' THEN
                                 PackageFileName := FileManagement.GetFileName("Package File Name");
                             END;
                              }

    { 21  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver koden for konfigurationspakken.;
                           ENU=Specifies the code of the configuration package.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Package Code" }

    { 22  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den pakke, der indeholder konfigurationsoplysningerne.;
                           ENU=Specifies the name of the package that contains the configuration information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Package Name";
                Editable=FALSE }

    { 19  ;3   ;Field     ;
                CaptionML=[DAN=Vëlg handlingen Anvend pakke for at indlëse dataene fra konfigurationen til Microsoft Dynamics NAV-tabeller.;
                           ENU=Choose Apply Package action to load the data from the configuration to Microsoft Dynamics NAV tables.];
                ToolTipML=[DAN=Angiver den handling, der indlëser konfigurationsdataene.;
                           ENU=Specifies the action that loads the configuration data.];
                ApplicationArea=#Basic,#Suite }

    { 20  ;3   ;Field     ;
                CaptionML=[DAN=Klik pÜ Konfigurationskladde, hvis du õnsker at redigere de anvendte data.;
                           ENU=Choose Configuration Worksheet if you want to edit and modify applied data.];
                ToolTipML=[DAN=Angiver den handling, der indlëser konfigurationsdataene.;
                           ENU=Specifies the action that loads the configuration data.];
                ApplicationArea=#Basic,#Suite }

    { 15  ;1   ;Group     ;
                CaptionML=[DAN=Trin 5. Vëlg profil.;
                           ENU=Step 5. Select profile.];
                GroupType=Group }

    { 11  ;2   ;Group     ;
                GroupType=Group }

    { 9   ;3   ;Group     ;
                GroupType=Group }

    { 7   ;4   ;Field     ;
                Name=ProfileText;
                CaptionML=[DAN=Hvis du er fërdig med at konfigurere din virksomhed, skal du vëlge den profil, som du õnsker at anvende som standard og derefter klikke pÜ OK for at lukke guiden.;
                           ENU=If you are finished setting up your company, select the profile that you want to use as your default, and then choose the OK button to close the Wizard.];
                ToolTipML=[DAN=Angiver den handling, der indlëser konfigurationsdataene.;
                           ENU=Specifies the action that loads the configuration data.];
                ApplicationArea=#Basic,#Suite }

    { 17  ;4   ;Field     ;
                Name=Your Profile Code;
                DrillDown=No;
                CaptionML=[DAN=Vëlg den profil, du õnsker at bruge, nÜr du er fërdig med opsëtningen.;
                           ENU=Select the profile that you want to use after the setup has completed.];
                ToolTipML=[DAN=Angiver profilkoden for konfigurationslõsningen og -pakken.;
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

    { 3   ;3   ;Field     ;
                Name=BeforeSetupCloseMessage;
                CaptionML=[DAN=Hvis du stadig har brug for at ëndre opsëtningsdata, skal du ikke ëndre profilen. Klik pÜ OK for at lukke guiden, og brug derefter konfigurationsarket til at fortsëtte opsëtningen af Microsoft Dynamics NAV.;
                           ENU=If you still need to change setup data, do not change the profile. Choose the OK button to close the wizard, and then use the configuration worksheet to continue setting up Microsoft Dynamics NAV.];
                ToolTipML=[DAN=Angiver, hvordan Microsoft Dynamics NAV skal konfigureres;
                           ENU=Specifies how to set up Microsoft Dynamics NAV];
                ApplicationArea=#Basic,#Suite;
                Style=Attention;
                StyleExpr=TRUE }

  }
  CODE
  {
    VAR
      Text003@1001 : TextConst 'DAN=Du skal vëlge en pakke for at kunne kõre funktionen Anvend pakke.;ENU=Select a package to run the Apply Package function.';
      Text004@1000 : TextConst 'DAN=Vëlg en pakkefil.;ENU=Select a package file.';
      YourProfileCode@1004 : Code[30];
      ApplyVisible@1002 : Boolean;
      ConfigVisible@1003 : Boolean;
      PackageIsAlreadyAppliedErr@1005 : TextConst 'DAN=En pakke er allerede valgt og anvendt.;ENU=A package has already been selected and applied.';
      CanRunDotNet@1006 : Boolean;
      UpdateDialogTitleTxt@1009 : TextConst 'DAN=Overfõr pakkefil;ENU=Upload package file';
      PackageFileName@1008 : Text;

    BEGIN
    END.
  }
}

