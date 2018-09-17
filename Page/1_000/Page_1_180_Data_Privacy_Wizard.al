OBJECT Page 1180 Data Privacy Wizard
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=V‘rkt›j til databeskyttelse;
               ENU=Data Privacy Utility];
    SourceTable=Table1180;
    PageType=NavigatePage;
    SourceTableTemporary=Yes;
    OnInit=BEGIN
             LoadTopBanners;
             CurrentPage := 1;
           END;

    OnOpenPage=BEGIN
                 EnableControls;
                 DataPrivacyMgmt.CreateEntities;
               END;

    ActionList=ACTIONS
    {
      { 5       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 8       ;1   ;Action    ;
                      Name=PreviewData;
                      CaptionML=[DAN=&Gener‚r og f† vist data;
                                 ENU=&Generate and Preview Data];
                      ApplicationArea=#Basic,#Suite;
                      Visible=CurrentPage = 3;
                      Enabled=PreviewActionEnabled;
                      InFooterBar=Yes;
                      OnAction=BEGIN
                                 CurrPage.UPDATE;
                                 DataPrivacyMgmt.InitRecords(EntityTypeTableNo,EntityNo,PackageCode,ActionType,FALSE,DataSensitivity);
                                 CurrPage.DataPrivacySubPage.PAGE.GeneratePreviewData(PackageCode);
                                 CurrentPage := CurrentPage + 1;
                               END;
                                }
      { 47      ;1   ;Action    ;
                      Name=BackAction;
                      CaptionML=[DAN=&Tilbage;
                                 ENU=&Back];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=(CurrentPage > 1) AND (CurrentPage < 5);
                      InFooterBar=Yes;
                      Image=PreviousRecord;
                      OnAction=VAR
                                 PreviousPage@1000 : Integer;
                               BEGIN
                                 PreviousPage := CurrentPage;
                                 CurrentPage := CurrentPage - 1;

                                 NextActionEnabled := TRUE;
                                 PreviewActionEnabled := TRUE;
                                 IF CurrentPage = 3 THEN BEGIN
                                   IF PreviousPage = 4 THEN // Don't clear the entity number if coming back from the preview page
                                     EXIT;
                                   IF PackageCode <> '' THEN
                                     IF STRPOS(PackageCode,'*') > 0 THEN
                                       DataPrivacyMgmt.DeletePackage(PackageCode);
                                   NextActionEnabled := FALSE;
                                   PreviewActionEnabled := FALSE;
                                 END;

                                 CurrPage.UPDATE;
                               END;
                                }
      { 9       ;1   ;Action    ;
                      Name=NextAction;
                      CaptionML=[DAN=&N‘ste;
                                 ENU=&Next];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NextActionEnabled;
                      InFooterBar=Yes;
                      Image=NextRecord;
                      OnAction=VAR
                                 ActivityLog@1000 : Record 710;
                                 Company@1001 : Record 2000000006;
                                 ConfigPackageTable@1003 : Record 8613;
                                 ConfigPackage@1002 : Record 8623;
                                 SessionId@1004 : Integer;
                               BEGIN
                                 NextActionEnabled := TRUE;
                                 PreviewActionEnabled := TRUE;

                                 CurrentPage := CurrentPage + 1;

                                 IF CurrentPage = 3 THEN BEGIN
                                   EntityNo := '';
                                   NextActionEnabled := FALSE;
                                   PreviewActionEnabled := FALSE;
                                 END;

                                 IF CurrentPage = 4 THEN BEGIN
                                   DataPrivacyMgmt.InitRecords(EntityTypeTableNo,EntityNo,PackageCode,ActionType,FALSE,DataSensitivity);
                                   IF ActionType = ActionType::"Create a data privacy configuration package" THEN
                                     IF ConfigPackage.GET(PackageCode) THEN BEGIN
                                       Company.GET(COMPANYNAME);
                                       NextActionEnabled := FALSE;
                                       PreviewActionEnabled := FALSE;
                                       EditConfigPackage := TRUE;
                                       CurrentPage := 5; // Move to the end
                                       ActivityLog.LogActivity(
                                         Company.RECORDID,ActivityLog.Status::Success,ActivityContextTxt,ActivityDescriptionConfigTxt,
                                         STRSUBSTNO(ActivityMessageConfigTxt,EntityType,EntityNo));
                                     END ELSE BEGIN // No data generated, so no config package created.
                                       CurrentPage := 6; // Move to the end
                                       ActivityLog.LogActivity(
                                         Company.RECORDID,ActivityLog.Status::Failed,ActivityContextTxt,ActivityDescriptionConfigTxt,
                                         STRSUBSTNO(ActivityMessageConfigTxt,EntityType,EntityNo));
                                       NextActionEnabled := FALSE;
                                       PreviewActionEnabled := FALSE;
                                       EditConfigPackage := FALSE;
                                       EXIT;
                                     END;
                                   CurrentPage := 5;
                                 END;

                                 IF CurrentPage = 5 THEN BEGIN
                                   NextActionEnabled := FALSE;
                                   PreviewActionEnabled := FALSE;

                                   Company.GET(COMPANYNAME);
                                   IF ActionType = ActionType::"Export a data subject's data" THEN
                                     IF ConfigPackage.GET(PackageCode) THEN BEGIN
                                       DataPrivacyMgmt.SetPrivacyBlocked(EntityTypeTableNo,EntityNo);
                                       ConfigPackageTable.SETRANGE("Package Code",PackageCode);
                                       IF STARTSESSION(SessionId,CODEUNIT::"Prvacy Data Mgmt Excel",COMPANYNAME,ConfigPackageTable) THEN
                                         ActivityLog.LogActivity(
                                           Company.RECORDID,ActivityLog.Status::Success,ActivityContextTxt,ActivityDescriptionExportTxt,
                                           STRSUBSTNO(ActivityMessageExportTxt,LOWERCASE(FORMAT(DataSensitivity)),EntityType,EntityNo))
                                       ELSE
                                         ActivityLog.LogActivity(
                                           Company.RECORDID,ActivityLog.Status::Failed,ActivityContextTxt,ActivityDescriptionExportTxt,
                                           STRSUBSTNO(ActivityMessageExportTxt,LOWERCASE(FORMAT(DataSensitivity)),EntityType,EntityNo));
                                     END ELSE BEGIN // No data generated, so no config package created.
                                       CurrentPage := 6; // Move to the end
                                       ActivityLog.LogActivity(
                                         Company.RECORDID,ActivityLog.Status::Failed,ActivityContextTxt,ActivityDescriptionExportTxt,
                                         STRSUBSTNO(ActivityMessageExportTxt,LOWERCASE(FORMAT(DataSensitivity)),EntityType,EntityNo));
                                     END;
                                   NextActionEnabled := FALSE;
                                   PreviewActionEnabled := FALSE;
                                 END;

                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 10      ;1   ;Action    ;
                      Name=FinishAction;
                      CaptionML=[DAN=&Udf›r;
                                 ENU=&Finish];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=CurrentPage >= 5;
                      InFooterBar=Yes;
                      Image=Approve;
                      OnAction=VAR
                                 ConfigPackage@1001 : Record 8623;
                                 ConfigPackages@1000 : Page 8615;
                               BEGIN
                                 IF EditConfigPackage AND (ActionType = ActionType::"Create a data privacy configuration package") THEN BEGIN
                                   ConfigPackage.FILTERGROUP(2);
                                   ConfigPackage.SETFILTER(Code,PackageCode);
                                   ConfigPackage.FILTERGROUP(0);

                                   ConfigPackages.SETTABLEVIEW(ConfigPackage);
                                   ConfigPackages.EDITABLE := TRUE;
                                   ConfigPackages.RUN;
                                 END;
                                 CurrPage.CLOSE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                Name=Privacy Data Wizard;
                CaptionML=[DAN=Ops‘tning af beskyttelsesdata;
                           ENU=Privacy Data Setup];
                ContainerType=ContentArea }

    { 17  ;1   ;Group     ;
                Visible=TopBannerVisible AND NOT (CurrentPage = 5);
                Editable=False;
                GroupType=Group }

    { 18  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=MediaResourcesStandard."Media Reference";
                Editable=FALSE;
                ShowCaption=No }

    { 19  ;1   ;Group     ;
                Visible=TopBannerVisible AND (CurrentPage = 5);
                Editable=False;
                GroupType=Group }

    { 20  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=MediaResourcesDone."Media Reference";
                Editable=FALSE;
                ShowCaption=No }

    { 12  ;1   ;Group     ;
                Name=Step1;
                Visible=CurrentPage = 1;
                GroupType=Group;
                InstructionalTextML= }

    { 6   ;2   ;Group     ;
                Name=Para1.1;
                CaptionML=[DAN=Velkommen til v‘rk›jet til databeskyttelse;
                           ENU=Welcome to Data Privacy Utility];
                GroupType=Group;
                InstructionalTextML= }

    { 7   ;3   ;Group     ;
                Name=Para1.1.1;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Group;
                InstructionalTextML=[DAN=Du kan eksportere en persons data til Excel eller en RapidStart-konfigurationspakke.;
                                     ENU=You can export data for a person to Excel or to a RapidStart configuration package.] }

    { 29  ;2   ;Group     ;
                Name=Para1.2;
                CaptionML=[DAN=Lad os komme i gang!;
                           ENU=Let's go!];
                GroupType=Group }

    { 30  ;3   ;Group     ;
                Name=Para1.2.1;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Group;
                InstructionalTextML=[DAN=V‘lg N‘ste for at starte processen.;
                                     ENU=Choose Next to start the process.] }

    { 26  ;1   ;Group     ;
                Name=Step2;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=CurrentPage = 2;
                GroupType=Group }

    { 4   ;2   ;Group     ;
                Name=Para2.1;
                CaptionML=[DAN=Jeg vil...;
                           ENU=I want to...];
                GroupType=Group }

    { 27  ;3   ;Field     ;
                OptionCaptionML=[@@@=Note to translators.  These options must be translated based on being prefixed with "I want to" text.;
                                 DAN=Eksportere et dataemnes data,Oprette en konfigurationspakke til databeskyttelse;
                                 ENU=Export a data subject's data,Create a data privacy configuration package];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ActionType;
                ShowCaption=No }

    { 41  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AvailableOptionsDescription;
                Editable=FALSE;
                MultiLine=Yes;
                ShowCaption=No }

    { 14  ;1   ;Group     ;
                Name=Step3;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=CurrentPage = 3;
                GroupType=Group }

    { 13  ;2   ;Group     ;
                Name=Para3.1;
                CaptionML=[DAN=Angiv de data, du vil eksportere.;
                           ENU=Specify the data that you want to export.];
                GroupType=Group }

    { 16  ;3   ;Field     ;
                Name=EntityType;
                CaptionML=[DAN=Dataemne;
                           ENU=Data Subject];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=EntityType;
                TableRelation="Data Privacy Entities"."Table Caption";
                OnLookup=BEGIN
                           RESET;
                           DELETEALL;
                           IF PAGE.RUNMODAL(PAGE::"Data Subject",Rec) = ACTION::LookupOK THEN BEGIN
                             EntityType := "Table Caption";
                             EntityTypeTableNo := "Table No.";
                             IF EntityType <> EntityTypeGlobal THEN
                               EntityNo := '';
                             EntityTypeGlobal := EntityType;
                           END;
                         END;
                          }

    { 25  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=EntityTypeTableNo;
                Visible=FALSE }

    { 21  ;3   ;Field     ;
                Name=EntityNo;
                CaptionML=[DAN=Identifikator for dataemne;
                           ENU=Data Subject Identifier];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=EntityNo;
                OnValidate=VAR
                             Customer@1006 : Record 18;
                             Vendor@1005 : Record 23;
                             Contact@1004 : Record 5050;
                             Resource@1003 : Record 156;
                             Employee@1002 : Record 5200;
                             SalespersonPurchaser@1001 : Record 13;
                             User@1012 : Record 2000000120;
                             FilterAsText@1010 : Text;
                           BEGIN
                             IF EntityNo <> '' THEN BEGIN
                               IF EntityTypeTableNo = DATABASE::Customer THEN BEGIN
                                 IF NOT Customer.GET(FORMAT(EntityNo,20)) THEN
                                   ERROR(RecordNotFoundErr);
                                 SetEntityFilter(DATABASE::Customer,FilterAsText);
                                 Customer.SETVIEW(FilterAsText);
                                 Customer.SETRANGE("No.",FORMAT(EntityNo,20));
                                 IF NOT Customer.FINDFIRST THEN
                                   ERROR(NoPartnerPeopleErr);
                                 IF Customer."Privacy Blocked" THEN
                                   MESSAGE(DataSubjectBlockedMsg);
                               END;

                               IF EntityTypeTableNo = DATABASE::Vendor THEN BEGIN
                                 IF NOT Vendor.GET(FORMAT(EntityNo,20)) THEN
                                   ERROR(RecordNotFoundErr);
                                 SetEntityFilter(DATABASE::Vendor,FilterAsText);
                                 Vendor.SETVIEW(FilterAsText);
                                 Vendor.SETRANGE("No.",FORMAT(EntityNo,20));
                                 IF NOT Vendor.FINDFIRST THEN
                                   ERROR(NoPartnerPeopleErr);
                                 IF Vendor."Privacy Blocked" THEN
                                   MESSAGE(DataSubjectBlockedMsg);
                               END;

                               IF EntityTypeTableNo = DATABASE::Contact THEN BEGIN
                                 IF NOT Contact.GET(FORMAT(EntityNo,20)) THEN
                                   ERROR(RecordNotFoundErr);
                                 SetEntityFilter(DATABASE::Contact,FilterAsText);
                                 Contact.SETVIEW(FilterAsText);
                                 Contact.SETRANGE("No.",FORMAT(EntityNo,20));
                                 IF NOT Contact.FINDFIRST THEN
                                   ERROR(NoPersonErr);
                                 IF Contact."Privacy Blocked" THEN
                                   MESSAGE(DataSubjectBlockedMsg);
                               END;

                               IF EntityTypeTableNo = DATABASE::Resource THEN BEGIN
                                 IF NOT Resource.GET(FORMAT(EntityNo,20)) THEN
                                   ERROR(RecordNotFoundErr);
                                 SetEntityFilter(DATABASE::Resource,FilterAsText);
                                 Resource.SETVIEW(FilterAsText);
                                 Resource.SETRANGE("No.",FORMAT(EntityNo,20));
                                 IF NOT Resource.FINDFIRST THEN
                                   ERROR(NoPersonErr);
                                 IF Resource."Privacy Blocked" THEN
                                   MESSAGE(DataSubjectBlockedMsg);
                               END;

                               IF EntityTypeTableNo = DATABASE::Employee THEN BEGIN
                                 Employee.SETRANGE("No.",FORMAT(EntityNo,20));
                                 IF NOT Employee.FINDFIRST THEN
                                   ERROR(RecordNotFoundErr);
                                 IF Employee."Privacy Blocked" THEN
                                   MESSAGE(DataSubjectBlockedMsg);
                               END;

                               IF EntityTypeTableNo = DATABASE::"Salesperson/Purchaser" THEN BEGIN
                                 SalespersonPurchaser.SETRANGE(Code,FORMAT(EntityNo,20));
                                 IF NOT SalespersonPurchaser.FINDFIRST THEN
                                   ERROR(RecordNotFoundErr);
                                 IF SalespersonPurchaser."Privacy Blocked" THEN
                                   MESSAGE(DataSubjectBlockedMsg);
                               END;

                               IF EntityTypeTableNo = DATABASE::User THEN BEGIN
                                 User.SETRANGE("User Name",EntityNo);
                                 IF NOT User.FINDFIRST THEN
                                   ERROR(RecordNotFoundErr);
                               END;
                             END;

                             NextActionEnabled := EntityNo <> '';
                             PreviewActionEnabled := EntityNo <> '';

                             OnEntityNoValidate;
                           END;

                OnDrillDown=VAR
                              Customer@1013 : Record 18;
                              Vendor@1011 : Record 23;
                              Contact@1009 : Record 5050;
                              Resource@1007 : Record 156;
                              Employee@1003 : Record 5200;
                              SalespersonPurchaser@1001 : Record 13;
                              DataPrivacyEntities@1004 : Record 1180;
                              User@1016 : Record 2000000120;
                              CustomerList@1012 : Page 22;
                              VendorList@1010 : Page 27;
                              ContactList@1008 : Page 5052;
                              ResourceList@1006 : Page 77;
                              EmployeeList@1002 : Page 5201;
                              SalespersonsPurchasers@1000 : Page 14;
                              Users@1015 : Page 9800;
                              Instream@1005 : InStream;
                              FilterAsText@1014 : Text;
                            BEGIN
                              IF EntityTypeTableNo = DATABASE::Customer THEN BEGIN
                                IF DataPrivacyEntities.GET(DATABASE::Customer) THEN BEGIN
                                  DataPrivacyEntities.CALCFIELDS("Entity Filter");
                                  DataPrivacyEntities."Entity Filter".CREATEINSTREAM(Instream);
                                  Instream.READTEXT(FilterAsText);
                                END;
                                CustomerList.LOOKUPMODE := TRUE;
                                Customer.SETVIEW(FilterAsText);
                                CustomerList.SETTABLEVIEW(Customer);
                                IF CustomerList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                  CustomerList.GETRECORD(Customer);
                                  IF Customer."Privacy Blocked" THEN
                                    MESSAGE(DataSubjectBlockedMsg);
                                  EntityNo := Customer."No.";
                                END;
                              END;

                              IF EntityTypeTableNo = DATABASE::Vendor THEN BEGIN
                                IF DataPrivacyEntities.GET(DATABASE::Vendor) THEN BEGIN
                                  DataPrivacyEntities.CALCFIELDS("Entity Filter");
                                  DataPrivacyEntities."Entity Filter".CREATEINSTREAM(Instream);
                                  Instream.READTEXT(FilterAsText);
                                END;
                                VendorList.LOOKUPMODE := TRUE;
                                Vendor.SETVIEW(FilterAsText);
                                VendorList.SETTABLEVIEW(Vendor);
                                IF VendorList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                  VendorList.GETRECORD(Vendor);
                                  IF Vendor."Privacy Blocked" THEN
                                    MESSAGE(DataSubjectBlockedMsg);
                                  EntityNo := Vendor."No.";
                                END;
                              END;

                              IF EntityTypeTableNo = DATABASE::Contact THEN BEGIN
                                IF DataPrivacyEntities.GET(DATABASE::Contact) THEN BEGIN
                                  DataPrivacyEntities.CALCFIELDS("Entity Filter");
                                  DataPrivacyEntities."Entity Filter".CREATEINSTREAM(Instream);
                                  Instream.READTEXT(FilterAsText);
                                END;
                                ContactList.LOOKUPMODE := TRUE;
                                Contact.SETVIEW(FilterAsText);
                                ContactList.SETTABLEVIEW(Contact);
                                IF ContactList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                  ContactList.GETRECORD(Contact);
                                  IF Contact."Privacy Blocked" THEN
                                    MESSAGE(DataSubjectBlockedMsg);
                                  EntityNo := Contact."No.";
                                END;
                              END;

                              IF EntityTypeTableNo = DATABASE::Resource THEN BEGIN
                                IF DataPrivacyEntities.GET(DATABASE::Resource) THEN BEGIN
                                  DataPrivacyEntities.CALCFIELDS("Entity Filter");
                                  DataPrivacyEntities."Entity Filter".CREATEINSTREAM(Instream);
                                  Instream.READTEXT(FilterAsText);
                                END;
                                ResourceList.LOOKUPMODE := TRUE;
                                Resource.SETVIEW(FilterAsText);
                                ResourceList.SETTABLEVIEW(Resource);
                                IF ResourceList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                  ResourceList.GETRECORD(Resource);
                                  IF Resource."Privacy Blocked" THEN
                                    MESSAGE(DataSubjectBlockedMsg);
                                  EntityNo := Resource."No.";
                                END;
                              END;

                              IF EntityTypeTableNo = DATABASE::Employee THEN BEGIN
                                EmployeeList.LOOKUPMODE := TRUE;
                                IF EmployeeList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                  EmployeeList.GETRECORD(Employee);
                                  IF Employee."Privacy Blocked" THEN
                                    MESSAGE(DataSubjectBlockedMsg);
                                  EntityNo := Employee."No.";
                                END;
                              END;

                              IF EntityTypeTableNo = DATABASE::"Salesperson/Purchaser" THEN BEGIN
                                SalespersonsPurchasers.LOOKUPMODE := TRUE;
                                IF SalespersonsPurchasers.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                  SalespersonsPurchasers.GETRECORD(SalespersonPurchaser);
                                  IF SalespersonPurchaser."Privacy Blocked" THEN
                                    MESSAGE(DataSubjectBlockedMsg);
                                  EntityNo := SalespersonPurchaser.Code;
                                END;
                              END;

                              IF EntityTypeTableNo = DATABASE::User THEN BEGIN
                                Users.LOOKUPMODE := TRUE;
                                IF Users.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                  Users.GETRECORD(User);
                                  EntityNo := User."User Name";
                                END;
                              END;

                              OnDrillDownForEntityNumber(EntityTypeTableNo); // Integration point to external devs

                              NextActionEnabled := EntityNo <> '';
                              PreviewActionEnabled := EntityNo <> '';
                            END;
                             }

    { 24  ;3   ;Field     ;
                Name=DataSensitivity;
                CaptionML=[DAN=Dataf›lsomhed;
                           ENU=Data Sensitivity];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=DataSensitivity }

    { 11  ;2   ;Group     ;
                Name=Para3.05;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=(CurrentPage = 3) AND (ActionType < 1);
                GroupType=Group;
                InstructionalTextML=[DAN=V‘lg at generere og f† vist de data, der skal eksporteres. Bem‘rk, at det kan tage et stykke tid, afh‘ngigt af st›rrelsen p† datas‘ttet.;
                                     ENU=Choose to generate and preview the data that will be exported. Note that this can take a while, depending on the size of the dataset.] }

    { 45  ;2   ;Group     ;
                Name=Para3.2;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=(CurrentPage = 3) AND (ActionType = 0);
                GroupType=Group;
                InstructionalTextML=[DAN=V‘lg N‘ste for at eksportere dataene.;
                                     ENU=Choose Next to export the data.] }

    { 37  ;2   ;Group     ;
                Name=Para3.4;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=ActionType = 1;
                GroupType=Group;
                InstructionalTextML=[DAN=V‘lg N‘ste for at oprette konfigurationspakken;
                                     ENU=Choose Next to create the configuration package] }

    { 2   ;1   ;Group     ;
                Name=Step4;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=CurrentPage = 4;
                GroupType=Group }

    { 35  ;2   ;Group     ;
                Name=Para4.1;
                CaptionML=[DAN=Vis de data, der skal eksporteres;
                           ENU=Preview the data that will be exported];
                GroupType=Group }

    { 3   ;3   ;Part      ;
                Name=DataPrivacySubPage;
                CaptionML=[DAN=" ";
                           ENU=" "];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page1181;
                PartType=Page }

    { 22  ;2   ;Group     ;
                Name=Para4.2;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=(CurrentPage = 4) AND (ActionType = 0);
                GroupType=Group;
                InstructionalTextML=[DAN=V‘lg N‘ste for at eksportere dataene.;
                                     ENU=Choose Next to export the data.] }

    { 31  ;1   ;Group     ;
                Name=Step5;
                CaptionML=[DAN=<Trin5>;
                           ENU=<Step5>];
                Visible=CurrentPage = 5;
                GroupType=Group;
                InstructionalTextML= }

    { 15  ;2   ;Group     ;
                Name=Para5.1;
                CaptionML=[DAN=Handlingen lykkedes!;
                           ENU=Success!];
                GroupType=Group;
                InstructionalTextML= }

    { 23  ;3   ;Group     ;
                Name=Para5.1.1;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=(CurrentPage = 5) AND (ActionType = 0);
                GroupType=Group;
                InstructionalTextML=[DAN=Dataene eksporteres. Excel-projektmappen vises i Rapportindbakke p† startsiden.;
                                     ENU=The data is being exported. The Excel workbook will show up in the Report Inbox on your home page.] }

    { 40  ;4   ;Group     ;
                Name=Para5.1.1.1;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=(CurrentPage = 5) AND (ActionType = 0);
                GroupType=Group;
                InstructionalTextML=[DAN=Vi anbefaler, at du kontrollerer de data, der er eksporteret til Excel. Kontroller filtrene i konfigurationspakken at sikre, at du har f†et de data, du ›nsker.;
                                     ENU=We recommend that you verify the data that is exported to Excel. Please also verify the filters in the configuration package to make sure that you are getting the data that you want.] }

    { 38  ;3   ;Group     ;
                Name=Para5.1.3;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=(CurrentPage = 5) AND (ActionType = 1);
                GroupType=Group;
                InstructionalTextML=[DAN=Konfigurationspakken blev oprettet.;
                                     ENU=Your configuration package has been successfully created.] }

    { 39  ;4   ;Field     ;
                CaptionML=[DAN=Rediger konfigurationspakke;
                           ENU=Edit Configuration Package];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=EditConfigPackage }

    { 43  ;4   ;Group     ;
                Name=Para5.1.4.1;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=(CurrentPage = 5) AND (ActionType = 1);
                GroupType=Group;
                InstructionalTextML=[DAN=Kontroll‚r filtrene i konfigurationspakken at sikre, at du f†r de data, du ›nsker.;
                                     ENU=Please verify the filters in the configuration package to make sure that you will get the data that you want.] }

    { 36  ;1   ;Group     ;
                Name=Step6;
                CaptionML=[DAN=<Trin5>;
                           ENU=<Step5>];
                Visible=CurrentPage = 6;
                GroupType=Group;
                InstructionalTextML= }

    { 34  ;2   ;Group     ;
                Name=Para6.1;
                CaptionML=[DAN=Processen er afsluttet.;
                           ENU=Process finished.];
                GroupType=Group;
                InstructionalTextML= }

    { 33  ;3   ;Group     ;
                Name=Para6.1.1;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=(CurrentPage = 6) AND (ActionType = 0);
                GroupType=Group;
                InstructionalTextML=[DAN=Der blev ikke fundet nogen data, der kunne genereres, s† der blev ikke oprettet nogen eksportfil.;
                                     ENU=No data was found that could be generated, so no export file was created.] }

    { 28  ;3   ;Group     ;
                Name=Para6.1.2;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=(CurrentPage = 6) AND (ActionType = 1);
                GroupType=Group;
                InstructionalTextML=[DAN=Der blev ikke fundet nogen data, der kunne genereres, s† der blev ikke oprettet nogen konfigurationspakke.;
                                     ENU=No data was found that could be generated, so no configuration package was created.] }

  }
  CODE
  {
    VAR
      MediaRepositoryStandard@1005 : Record 9400;
      MediaRepositoryDone@1004 : Record 9400;
      MediaResourcesStandard@1026 : Record 2000000182;
      MediaResourcesDone@1025 : Record 2000000182;
      ClientTypeManagement@1077 : Codeunit 4;
      DataPrivacyMgmt@1009 : Codeunit 1180;
      CurrentPage@1000 : Integer;
      TopBannerVisible@1006 : Boolean;
      ActionType@1011 : 'Export a data subject''s data,Create a data privacy configuration package';
      EntityType@1007 : Text[80];
      EntityTypeTableNo@1017 : Integer;
      EntityNo@1003 : Code[50];
      DataSensitivity@1001 : 'Sensitive,Personal,Company Confidential,Normal,Unclassified';
      EntityTypeGlobal@1008 : Text[80];
      NextActionEnabled@1012 : Boolean;
      ActivityContextTxt@1010 : TextConst 'DAN=Databeskyttelselsesaktivitet;ENU=Privacy Activity';
      ActivityMessageExportTxt@1018 : TextConst '@@@="%1=The type of information being exported. %2=The type of entity. %3=The entity''s control number.";DAN=Eksporterer %1 oplysninger om %2 %3;ENU=Exporting %1 information for %2 %3';
      ActivityDescriptionExportTxt@1019 : TextConst 'DAN=Eksporterer data om dataemne;ENU=Exporting data subject data';
      PreviewActionEnabled@1030 : Boolean;
      PackageCode@1021 : Code[20];
      ActivityMessageConfigTxt@1033 : TextConst '@@@="%1=The type of entity. %2=The entity''s control number.";DAN=Opretter konfigurationspakke til databeskyttelse for %1 %2;ENU=Creating data privacy configuration package for %1 %2';
      ActivityDescriptionConfigTxt@1032 : TextConst 'DAN=Opretter konfigurationspakken til databeskyttelse;ENU=Creating the data privacy configuration package';
      RecordNotFoundErr@1022 : TextConst 'DAN=Recorden blev ikke fundet.;ENU=Record not found.';
      EditConfigPackage@1034 : Boolean;
      OptionsDescriptionTxt@1035 : TextConst 'DAN=\V‘lg, hvad du vil g›re med de personlige oplysninger.\\Du kan eksportere data om et bestemt dataemne, f.eks. en debitor.\Du kan ogs† oprette en konfigurationspakke, s† du kan f† vist og redigere de felter og tabeller, som dataene eksporteres fra.;ENU=\Choose what you want to do with the privacy data.\\You can export data for a specific data subject, such as a customer.\You can also create a configuration package so that you can view and edit the fields and tables that the data will be exported from.';
      AvailableOptionsDescription@1036 : Text;
      DataSubjectBlockedMsg@1015 : TextConst 'DAN=Dette dataemne er allerede markeret som sp‘rret p† grund af beskyttelse af personlige oplysninger. Du kan eksportere de relaterede data.;ENU=This data subject is already marked as blocked due to privacy. You can export the related data.';
      NoPartnerPeopleErr@1002 : TextConst 'DAN=Det blev ikke fundet nogen records med partnertypen ''Person''.;ENU=No records of Partner Type of ''Person'' were found.';
      NoPersonErr@1013 : TextConst 'DAN=Det blev ikke fundet nogen records af typen ''Person''.;ENU=No records of type ''Person'' were found.';

    LOCAL PROCEDURE LoadTopBanners@1();
    BEGIN
      IF MediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png',FORMAT(ClientTypeManagement.GetCurrentClientType)) AND
         MediaRepositoryDone.GET('AssistedSetupDone-NoText-400px.png',FORMAT(ClientTypeManagement.GetCurrentClientType))
      THEN
        IF MediaResourcesStandard.GET(MediaRepositoryStandard."Media Resources Ref") AND
           MediaResourcesDone.GET(MediaRepositoryDone."Media Resources Ref")
        THEN
          TopBannerVisible := MediaResourcesDone."Media Reference".HASVALUE;
    END;

    LOCAL PROCEDURE ResetControls@2();
    BEGIN
      NextActionEnabled := TRUE;
      PreviewActionEnabled := TRUE;
      EditConfigPackage := TRUE;
    END;

    LOCAL PROCEDURE EnableControls@3();
    BEGIN
      ResetControls;
      AvailableOptionsDescription := OptionsDescriptionTxt;
    END;

    LOCAL PROCEDURE SetEntityFilter@5(TableId@1000 : Integer;VAR FilterAsText@1001 : Text);
    VAR
      DataPrivacyEntities@1002 : Record 1180;
      Instream@1003 : InStream;
    BEGIN
      IF DataPrivacyEntities.GET(TableId) THEN BEGIN
        DataPrivacyEntities.CALCFIELDS("Entity Filter");
        DataPrivacyEntities."Entity Filter".CREATEINSTREAM(Instream);
        Instream.READTEXT(FilterAsText);
      END;
    END;

    PROCEDURE SetEntitityType@6(VAR DataPrivacyEntities2@1002 : Record 1180;EntityTypeText@1000 : Text[80]);
    BEGIN
      EntityType := EntityTypeText;

      DataPrivacyEntities2.SETRANGE("Table Caption",EntityType);
      IF DataPrivacyEntities2.FINDFIRST THEN
        EntityTypeTableNo := DataPrivacyEntities2."Table No.";
      CLEAR(DataPrivacyEntities2);
    END;

    [Integration]
    LOCAL PROCEDURE OnDrillDownForEntityNumber@10(EntityTypeTableNo@1000 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnEntityNoValidate@4();
    BEGIN
    END;

    BEGIN
    END.
  }
}

