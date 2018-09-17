OBJECT Page 1803 Assisted Company Setup Wizard
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Virksomhedsops‘tning;
               ENU=Company Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table8627;
    PageType=NavigatePage;
    SourceTableTemporary=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Trin 4,Trin 5;
                                ENU=New,Process,Report,Step 4,Step 5];
    ShowFilter=No;
    OnInit=BEGIN
             InitializeRecord;
             LoadTopBanners;
           END;

    OnOpenPage=BEGIN
                 ResetWizardControls;
                 ShowIntroStep;
                 TypeSelectionEnabled := LoadConfigTypes AND NOT PackageImported;
               END;

    OnAfterGetRecord=BEGIN
                       LogoPositionOnDocumentsShown := Picture.HASVALUE;
                     END;

    OnQueryClosePage=VAR
                       AssistedSetup@1000 : Record 1803;
                     BEGIN
                       IF CloseAction = ACTION::OK THEN
                         IF AssistedSetup.GetStatus(PAGE::"Assisted Company Setup Wizard") = AssistedSetup.Status::"Not Completed" THEN
                           IF NOT CONFIRM(NotSetUpQst,FALSE) THEN
                             ERROR('');
                     END;

    ActionList=ACTIONS
    {
      { 4       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 3       ;1   ;Action    ;
                      Name=ActionBack;
                      CaptionML=[DAN=Tilbage;
                                 ENU=Back];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=BackEnabled;
                      InFooterBar=Yes;
                      Image=PreviousRecord;
                      OnAction=BEGIN
                                 NextStep(TRUE);
                               END;
                                }
      { 2       ;1   ;Action    ;
                      Name=ActionNext;
                      CaptionML=[DAN=N‘ste;
                                 ENU=Next];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NextEnabled;
                      InFooterBar=Yes;
                      Image=NextRecord;
                      OnAction=BEGIN
                                 IF (Step = Step::"Select Type") AND NOT (TypeStandard OR TypeEvaluation) THEN
                                   IF NOT CONFIRM(NoSetupTypeSelectedQst,FALSE) THEN
                                     ERROR('');
                                 NextStep(FALSE);
                               END;
                                }
      { 1       ;1   ;Action    ;
                      Name=ActionFinish;
                      CaptionML=[DAN=Udf›r;
                                 ENU=Finish];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=FinishEnabled;
                      InFooterBar=Yes;
                      Image=Approve;
                      OnAction=VAR
                                 AssistedSetup@1001 : Record 1803;
                                 AssistedCompanySetup@1000 : Codeunit 1800;
                               BEGIN
                                 AssistedCompanySetup.WaitForPackageImportToComplete;
                                 BankAccount.TRANSFERFIELDS(TempBankAccount,TRUE);
                                 AssistedCompanySetup.ApplyUserInput(Rec,BankAccount,AccountingPeriodStartDate,TypeEvaluation);
                                 AssistedSetup.SetStatus(PAGE::"Assisted Company Setup Wizard",AssistedSetup.Status::Completed);
                                 IF (BankAccount."No." <> '') AND (NOT TempOnlineBankAccLink.ISEMPTY) THEN
                                   BankAccount.OnMarkAccountLinkedEvent(TempOnlineBankAccLink,BankAccount);
                                 CurrPage.CLOSE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 96  ;1   ;Group     ;
                Visible=TopBannerVisible AND NOT DoneVisible;
                Editable=FALSE;
                GroupType=Group }

    { 97  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=MediaResourcesStandard."Media Reference";
                Editable=FALSE;
                ShowCaption=No }

    { 98  ;1   ;Group     ;
                Visible=TopBannerVisible AND DoneVisible;
                Editable=FALSE;
                GroupType=Group }

    { 99  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=MediaResourcesDone."Media Reference";
                Editable=FALSE;
                ShowCaption=No }

    { 8   ;1   ;Group     ;
                Visible=IntroVisible;
                GroupType=Group }

    { 5   ;2   ;Group     ;
                CaptionML=[DAN=Velkommen til Virksomhedsops‘tning.;
                           ENU=Welcome to Company Setup.];
                GroupType=Group;
                InstructionalTextML=[DAN=N†r du skal forberede Dynamics NAV til brug f›rste gang, skal du angive nogle grundl‘ggende oplysninger om virksomheden. Oplysningerne bruges p† dine eksterne dokumenter, f.eks. salgsfakturaer, og de omfatter dit virksomhedslogo og dine bankoplysninger. Du skal ogs† angive regnskabs†r.;
                                     ENU=To prepare Dynamics NAV for first use, you must specify some basic information about your company. This information is used on your external documents, such as sales invoices, and includes your company logo and bank information. You must also set up the fiscal year.] }

    { 11  ;2   ;Group     ;
                CaptionML=[DAN=Lad os komme i gang!;
                           ENU=Let's go!];
                GroupType=Group;
                InstructionalTextML=[DAN=V‘lg N‘ste for at angive de grundl‘ggende virksomhedsoplysninger.;
                                     ENU=Choose Next so you can specify basic company information.] }

    { 39  ;1   ;Group     ;
                Visible=SyncVisible;
                GroupType=Group }

    { 40  ;2   ;Group     ;
                GroupType=Group;
                InstructionalTextML=[DAN=Synkroniser virksomhedsoplysninger med Office 365 Business-profil.;
                                     ENU=Synchronize Company Information with Office 365 Business Profile.] }

    { 43  ;2   ;Group     ;
                GroupType=Group;
                InstructionalTextML=[DAN=Hvis du bruger Office 365 Business-center, kan vi s›rge for, at dine Dynamics 365 for Finance and Operations, Business edition-virksomhedsoplysninger, s†som dit firmalogo og dine kontaktoplysninger, synkroniseres med den Business-profil, der vises i dit Business-center.;
                                     ENU=If you are using the Office 365 Business center, we can keep your Dynamics 365 for Finance and Operations, Business edition company information, like your company logo and contact information, synchronized with the Business profile displayed in your Business center.] }

    { 49  ;2   ;Group     ;
                GroupType=Group;
                InstructionalTextML=[DAN=Hvis du allerede har konfigureret din Office 365 Business-profil, kan vi udfylde dine virksomhedsoplysninger her ved hj‘lp af det, du allerede har indtastet. Hvis du endnu ikke har konfigureret din O365 Business-profil, kan vi oprette din Business-profil og holde dig synkroniseret med O365 ud fra, hvad du indtaster her.;
                                     ENU=If you've already set up your Office 365 Business profile, we can fill in your company information here with what you've already entered. If you haven't yet set up your O365 Business profile, we can create your Business profile and keep you you in sync with O365 based on what you enter here.] }

    { 38  ;3   ;Field     ;
                Name=Sync with O365 Business profile;
                CaptionML=[DAN=Synkroniser med Office 365 Business-profil;
                           ENU=Synchronize with Office 365 Business profile];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SyncEnabled;
                OnValidate=VAR
                             CompanyInformation@1000 : Record 79;
                           BEGIN
                             CompanyInformation.VALIDATE("Sync with O365 Bus. profile",SyncEnabled);
                             CompanyInformation.MODIFY(TRUE);
                           END;
                            }

    { 18  ;1   ;Group     ;
                Visible=SelectTypeVisible AND TypeSelectionEnabled;
                GroupType=Group }

    { 22  ;2   ;Group     ;
                CaptionML=[DAN=Standardops‘tning;
                           ENU=Standard Setup];
                Visible=StandardVisible;
                GroupType=Group;
                InstructionalTextML=[DAN=Virksomheden er klar til brug, n†r ops‘tningen er fuldf›rt.;
                                     ENU=The company will be ready to use when Setup has completed.] }

    { 19  ;3   ;Field     ;
                Name=Standard;
                CaptionML=[DAN=Konfigurer som standard;
                           ENU=Set up as Standard];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TypeStandard;
                OnValidate=BEGIN
                             IF TypeStandard THEN
                               TypeEvaluation := FALSE;
                             CalcCompanyData;
                           END;
                            }

    { 23  ;2   ;Group     ;
                CaptionML=[DAN=Ops‘tning af evaluering;
                           ENU=Evaluation Setup];
                Visible=EvaluationVisible;
                GroupType=Group;
                InstructionalTextML=[DAN=Virksomheden konfigureres i demonstrationstilstand, s† du kan unders›ge og teste den.;
                                     ENU=The company will be set up in demonstration mode for exploring and testing.] }

    { 20  ;3   ;Field     ;
                Name=Evaluation;
                CaptionML=[DAN=Konfigurer til evaluering;
                           ENU=Set up as Evaluation];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TypeEvaluation;
                OnValidate=BEGIN
                             IF TypeEvaluation THEN
                               TypeStandard := FALSE;
                             CalcCompanyData;
                           END;
                            }

    { 17  ;2   ;Group     ;
                CaptionML=[DAN=Vigtigt;
                           ENU=Important];
                Visible=TypeStandard OR TypeEvaluation;
                GroupType=Group;
                InstructionalTextML=[DAN=Du kan ikke ‘ndre den valgte ops‘tning, n†r du har klikket p† N‘ste.;
                                     ENU=You cannot change your choice of setup after you choose Next.] }

    { 56  ;1   ;Group     ;
                Visible=CompanyDetailsVisible;
                GroupType=Group }

    { 12  ;2   ;Group     ;
                CaptionML=[DAN=Angiv din virksomheds adresseoplysninger og logo.;
                           ENU=Specify your company's address information and logo.];
                GroupType=Group;
                InstructionalTextML=[DAN=De bruges p† fakturaer og andre dokumenter, hvor der udskrives generelle oplysninger om din virksomhed.;
                                     ENU=This is used in invoices and other documents where general information about your company is printed.] }

    { 55  ;3   ;Field     ;
                CaptionML=[DAN=Virksomhedsnavn;
                           ENU=Company Name];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr=Name;
                ShowMandatory=TRUE }

    { 54  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 53  ;3   ;Field     ;
                ApplicationArea=#Advanced;
                SourceExpr="Address 2";
                Visible=FALSE }

    { 52  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code" }

    { 51  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 50  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code";
                TableRelation=Country/Region.Code }

    { 48  ;3   ;Field     ;
                ApplicationArea=#Advanced;
                SourceExpr="VAT Registration No.";
                Visible=FALSE }

    { 47  ;3   ;Field     ;
                ApplicationArea=#Advanced;
                NotBlank=Yes;
                SourceExpr="Industrial Classification";
                Visible=FALSE;
                ShowMandatory=TRUE }

    { 10  ;3   ;Field     ;
                CaptionML=[DAN=Firmalogo;
                           ENU=Company Logo];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Picture;
                OnValidate=BEGIN
                             LogoPositionOnDocumentsShown := Picture.HASVALUE;
                             IF LogoPositionOnDocumentsShown THEN BEGIN
                               IF "Logo Position on Documents" = "Logo Position on Documents"::"No Logo" THEN
                                 "Logo Position on Documents" := "Logo Position on Documents"::Right;
                             END ELSE
                               "Logo Position on Documents" := "Logo Position on Documents"::"No Logo";
                             CurrPage.UPDATE(TRUE);
                           END;
                            }

    { 30  ;3   ;Field     ;
                ApplicationArea=#Advanced;
                SourceExpr="Logo Position on Documents";
                Editable=LogoPositionOnDocumentsShown }

    { 45  ;1   ;Group     ;
                Visible=CommunicationDetailsVisible;
                GroupType=Group }

    { 13  ;2   ;Group     ;
                CaptionML=[DAN=Angiv din virksomheds kontaktoplysninger.;
                           ENU=Specify the contact details for your company.];
                GroupType=Group;
                InstructionalTextML=[DAN=De bruges p† fakturaer og andre dokumenter, hvor der udskrives generelle oplysninger om din virksomhed.;
                                     ENU=This is used in invoices and other documents where general information about your company is printed.] }

    { 44  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No.";
                OnValidate=VAR
                             TypeHelper@1000 : Codeunit 10;
                           BEGIN
                             IF "Phone No." = '' THEN
                               EXIT;

                             IF NOT TypeHelper.IsPhoneNumber("Phone No.") THEN
                               ERROR(InvalidPhoneNumberErr)
                           END;
                            }

    { 42  ;3   ;Field     ;
                ExtendedDatatype=E-Mail;
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail";
                OnValidate=VAR
                             MailManagement@1000 : Codeunit 9520;
                           BEGIN
                             IF "E-Mail" = '' THEN
                               EXIT;

                             MailManagement.CheckValidEmailAddress("E-Mail");
                           END;
                            }

    { 41  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Home Page";
                OnValidate=VAR
                             WebRequestHelper@1000 : Codeunit 1299;
                           BEGIN
                             IF "Home Page" = '' THEN
                               EXIT;

                             WebRequestHelper.IsValidUriWithoutProtocol("Home Page");
                           END;
                            }

    { 29  ;1   ;Group     ;
                Visible=BankStatementConfirmationVisible;
                GroupType=Group }

    { 25  ;2   ;Group     ;
                CaptionML=[DAN=Bankfeedtjeneste;
                           ENU=Bank Feed Service];
                GroupType=Group;
                InstructionalTextML=[DAN=Du kan bruge en bankfeedtjeneste til at importere elektroniske bankudtog fra banken for at behandle betalinger hurtigt.;
                                     ENU=You can use a bank feeds service to import electronic bank statements from your bank to quickly process payments.] }

    { 46  ;3   ;Field     ;
                CaptionML=[DAN=Brug en bankfeedtjeneste;
                           ENU=Use a bank feed service];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=UseBankStatementFeed }

    { 26  ;2   ;Group     ;
                CaptionML=[DAN=BEM’RK:;
                           ENU=NOTE:];
                Visible=UseBankStatementFeed;
                GroupType=Group;
                InstructionalTextML=[DAN=N†r du v‘lger N‘ste, accepterer du vilk†rene for anvendelse af bankfeedtjenesten.;
                                     ENU=When you choose Next, you accept the terms of use for the bank feed service.] }

    { 28  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TermsOfUseLbl;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              HYPERLINK(TermsOfUseUrlTxt);
                            END;

                ShowCaption=No }

    { 32  ;1   ;Group     ;
                CaptionML=[DAN=V‘lg bankkonto.;
                           ENU=Select bank account.];
                Visible=SelectBankAccountVisible;
                GroupType=Group }

    { 24  ;2   ;Part      ;
                Name=OnlineBanckAccountLinkPagePart;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page270;
                PartType=Page }

    { 37  ;1   ;Group     ;
                Visible=PaymentDetailsVisible;
                GroupType=Group }

    { 14  ;2   ;Group     ;
                CaptionML=[DAN=Angiv din virksomheds bankoplysninger.;
                           ENU=Specify your company's bank information.];
                GroupType=Group;
                InstructionalTextML=[DAN=Disse oplysninger medtages p† dokumenter, som du sender til debitorer og kreditorer, som information om indbetaling p† din bankkonto.;
                                     ENU=This information is included on documents that you send to customer and vendors to inform about payments to your bank account.] }

    { 36  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Name" }

    { 35  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Branch No." }

    { 34  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account No.";
                OnValidate=BEGIN
                             ShowBankAccountCreationWarning := NOT ValidateBankAccountNotEmpty;
                           END;
                            }

    { 31  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr="SWIFT Code" }

    { 27  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=IBAN }

    { 33  ;2   ;Group     ;
                CaptionML=[DAN=" ";
                           ENU=" "];
                Visible=ShowBankAccountCreationWarning;
                GroupType=Group;
                InstructionalTextML=[DAN=Hvis du vil oprette en bankkonto, der er knyttet til den relaterede onlinebankkonto, skal du angive ovenst†ende bankkontooplysninger.;
                                     ENU=To create a bank account that is linked to the related online bank account, you must specify the bank account information above.] }

    { 6   ;1   ;Group     ;
                Visible=AccountingPeriodVisible;
                GroupType=Group }

    { 15  ;2   ;Group     ;
                CaptionML=[DAN=Angiv startdatoen for virksomhedens regnskabs†r.;
                           ENU=Specify the start date of the company's fiscal year.];
                GroupType=Group }

    { 7   ;3   ;Field     ;
                CaptionML=[DAN=Regnskabs†rets startdato;
                           ENU=Fiscal Year Start Date];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr=AccountingPeriodStartDate;
                ShowMandatory=TRUE }

    { 57  ;1   ;Group     ;
                Visible=CostingMethodVisible;
                GroupType=Group }

    { 58  ;2   ;Group     ;
                CaptionML=[DAN=Angiv kostmetoden for din lagerv‘rdi.;
                           ENU=Specify the costing method for your inventory valuation.];
                GroupType=Group }

    { 122 ;3   ;Group     ;
                Name=CostingMethodLbl;
                CaptionML=[DAN=Metoden for kostprisberegning anvender bogf›ringsdatoen og r‘kkef›lgen til fastsl†, hvordan kostprisforl›bet skal registreres.;
                           ENU=The costing method works together with the posting date and sequence to determine how to record the cost flow.];
                GroupType=Group }

    { 123 ;4   ;Field     ;
                Name=Cost Method;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CostMethodeLbl;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              HYPERLINK(CostMethodUrlTxt);
                            END;

                ShowCaption=No }

    { 59  ;4   ;Field     ;
                Name=Costing Method;
                CaptionML=[DAN=Kostmetode;
                           ENU=Costing Method];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=InventorySetup."Default Costing Method";
                OnValidate=VAR
                             ExistingInventorySetup@1000 : Record 313;
                           BEGIN
                             IF NOT ExistingInventorySetup.GET THEN BEGIN
                               InventorySetup."Automatic Cost Adjustment" := InventorySetup."Automatic Cost Adjustment"::Always;
                               InventorySetup."Automatic Cost Posting" := TRUE;
                             END;

                             IF InventorySetup."Default Costing Method" = InventorySetup."Default Costing Method"::Average THEN BEGIN
                               InventorySetup."Average Cost Period" := InventorySetup."Average Cost Period"::Day;
                               InventorySetup."Average Cost Calc. Type" := InventorySetup."Average Cost Calc. Type"::Item;
                             END;

                             IF NOT InventorySetup.MODIFY THEN
                               InventorySetup.INSERT;
                           END;

                ShowMandatory=TRUE }

    { 9   ;1   ;Group     ;
                Visible=DoneVisible;
                GroupType=Group }

    { 16  ;2   ;Group     ;
                CaptionML=[DAN=Det var det hele!;
                           ENU=That's it!];
                GroupType=Group;
                InstructionalTextML=[DAN=V‘lg Udf›r for at forberede programmet til brug f›rste gang. Det tager et lille ›jeblik.;
                                     ENU=Choose Finish to prepare the application for first use. This will take a few moments.] }

    { 21  ;3   ;Field     ;
                ExtendedDatatype=URL;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=HelpLbl;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              HYPERLINK(HelpLinkTxt);
                            END;
                             }

  }
  CODE
  {
    VAR
      MediaRepositoryStandard@1040 : Record 9400;
      TempSavedBankAccount@1044 : TEMPORARY Record 270;
      TempBankAccount@1029 : TEMPORARY Record 270;
      BankAccount@1039 : Record 270;
      TempOnlineBankAccLink@1033 : TEMPORARY Record 777;
      MediaRepositoryDone@1041 : Record 9400;
      MediaResourcesStandard@1055 : Record 2000000182;
      MediaResourcesDone@1057 : Record 2000000182;
      InventorySetup@1060 : Record 313;
      AssistedCompanySetup@1045 : Codeunit 1800;
      ClientTypeManagement@1014 : Codeunit 4;
      AccountingPeriodStartDate@1000 : Date;
      CompanyData@1046 : 'Evaluation Data,Standard Data,None,Extended Data,Full No Data';
      TypeStandard@1018 : Boolean;
      TypeEvaluation@1019 : Boolean;
      Step@1012 : 'Intro,Sync,Select Type,Company Details,Communication Details,BankStatementFeed,SelectBankAccont,Payment Details,Accounting Period,Costing Method,Done';
      BackEnabled@1003 : Boolean;
      NextEnabled@1004 : Boolean;
      FinishEnabled@1005 : Boolean;
      TopBannerVisible@1042 : Boolean;
      IntroVisible@1006 : Boolean;
      SyncVisible@1035 : Boolean;
      SelectTypeVisible@1015 : Boolean;
      CompanyDetailsVisible@1007 : Boolean;
      CommunicationDetailsVisible@1008 : Boolean;
      PaymentDetailsVisible@1010 : Boolean;
      AccountingPeriodVisible@1009 : Boolean;
      CostingMethodVisible@1049 : Boolean;
      DoneVisible@1011 : Boolean;
      TypeSelectionEnabled@1026 : Boolean;
      StandardVisible@1023 : Boolean;
      EvaluationVisible@1024 : Boolean;
      SkipAccountingPeriod@1013 : Boolean;
      NotSetUpQst@1001 : TextConst 'DAN=Programmet er ikke konfigureret. Ops‘tningen forts‘tter, n‘ste gang du starter programmet.\\Er du sikker p†, at du vil afslutte?;ENU=The application has not been set up. Setup will continue the next time you start the program.\\Are you sure that you want to exit?';
      HideBankStatementProvider@1028 : Boolean;
      NoSetupTypeSelectedQst@1020 : TextConst 'DAN=Du har ikke valgt en ops‘tningstype. Hvis du forts‘tter, vil programmet ikke v‘re fuldt funktionelt, f›r du har konfigureret det manuelt.\\Vil du forts‘tte?;ENU=You have not selected any setup type. If you proceed, the application will not be fully functional, until you set it up manually.\\Do you want to continue?';
      HelpLbl@1027 : TextConst 'DAN=F† mere at vide om ops‘tning af din virksomhed;ENU=Learn more about setting up your company';
      HelpLinkTxt@1022 : TextConst '@@@={Locked};DAN="http://go.microsoft.com/fwlink/?LinkId=746160";ENU="http://go.microsoft.com/fwlink/?LinkId=746160"';
      BankStatementConfirmationVisible@1030 : Boolean;
      UseBankStatementFeed@1032 : Boolean;
      UseBankStatementFeedInitialized@1017 : Boolean;
      BankAccountInformationUpdated@1037 : Boolean;
      SelectBankAccountVisible@1038 : Boolean;
      TermsOfUseLbl@1031 : TextConst 'DAN=Vilk†r for anvendelse af Envestnet Yodlee;ENU=Envestnet Yodlee Terms of Use';
      TermsOfUseUrlTxt@1025 : TextConst '@@@={Locked};DAN="https://go.microsoft.com/fwlink/?LinkId=746179";ENU="https://go.microsoft.com/fwlink/?LinkId=746179"';
      LogoPositionOnDocumentsShown@1034 : Boolean;
      ShowBankAccountCreationWarning@1036 : Boolean;
      InvalidPhoneNumberErr@1002 : TextConst 'DAN=Telefonnummeret er ugyldigt.;ENU=The phone number is invalid.';
      SyncEnabled@1043 : Boolean;
      CostMethodeLbl@1143 : TextConst 'DAN=F† mere at vide;ENU=Learn more';
      CostMethodUrlTxt@1145 : TextConst '@@@={Locked};DAN="https://go.microsoft.com/fwlink/?linkid=858295";ENU="https://go.microsoft.com/fwlink/?linkid=858295"';

    LOCAL PROCEDURE NextStep@3(Backwards@1000 : Boolean);
    BEGIN
      ResetWizardControls;

      IF Backwards THEN
        Step := Step - 1
      ELSE
        Step := Step + 1;

      CASE Step OF
        Step::Intro:
          ShowIntroStep;
        Step::Sync:
          ShowSyncStep(Backwards);
        Step::"Select Type":
          IF NOT TypeSelectionEnabled THEN
            NextStep(Backwards)
          ELSE
            ShowSelectTypeStep;
        Step::"Company Details":
          IF TypeEvaluation THEN BEGIN
            Step := Step::Done;
            ShowDoneStep;
          END ELSE
            ShowCompanyDetailsStep;
        Step::"Communication Details":
          ShowCommunicationDetailsStep;
        Step::BankStatementFeed:
          IF NOT ShowBankStatementFeedStep THEN
            NextStep(Backwards)
          ELSE
            ShowBankStatementFeedConfirmation;
        Step::SelectBankAccont:
          BEGIN
            IF NOT Backwards THEN
              ShowOnlineBankStatement;
            IF NOT ShowSelectBankAccountStep THEN
              NextStep(Backwards)
            ELSE
              ShowSelectBankAccount;
          END;
        Step::"Payment Details":
          BEGIN
            IF NOT Backwards THEN
              PopulateBankAccountInformation;
            ShowPaymentDetailsStep;
            ShowBankAccountCreationWarning := NOT ValidateBankAccountNotEmpty;
          END;
        Step::"Accounting Period":
          IF SkipAccountingPeriod THEN
            NextStep(Backwards)
          ELSE
            ShowAccountingPeriodStep;
        Step::"Costing Method":
          ShowCostingMethodStep;
        Step::Done:
          ShowDoneStep;
      END;
      CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE ShowIntroStep@1();
    BEGIN
      IntroVisible := TRUE;
      BackEnabled := FALSE;
    END;

    LOCAL PROCEDURE ShowSyncStep@22(Backwards@1000 : Boolean);
    BEGIN
      NextStep(Backwards);
    END;

    LOCAL PROCEDURE ShowSelectTypeStep@12();
    BEGIN
      SelectTypeVisible := TRUE;
    END;

    LOCAL PROCEDURE ShowCompanyDetailsStep@2();
    BEGIN
      CompanyDetailsVisible := TRUE;
      IF TypeSelectionEnabled THEN BEGIN
        StartConfigPackageImport;
        BackEnabled := FALSE;
      END;
    END;

    LOCAL PROCEDURE ShowCommunicationDetailsStep@4();
    BEGIN
      CommunicationDetailsVisible := TRUE;
    END;

    LOCAL PROCEDURE ShowPaymentDetailsStep@5();
    BEGIN
      PaymentDetailsVisible := TRUE;
    END;

    LOCAL PROCEDURE ShowOnlineBankStatement@19();
    VAR
      CompanyInformationMgt@1001 : Codeunit 1306;
    BEGIN
      IF CompanyInformationMgt.IsDemoCompany THEN
        EXIT;

      IF HideBankStatementProvider THEN
        EXIT;

      TempOnlineBankAccLink.RESET;
      TempOnlineBankAccLink.DELETEALL;

      IF NOT TempBankAccount.StatementProvidersExist THEN
        EXIT;

      IF UseBankStatementFeed THEN BEGIN
        TempBankAccount.SimpleLinkStatementProvider(TempOnlineBankAccLink);
        IF TempOnlineBankAccLink.FINDFIRST THEN
          IF NOT TempOnlineBankAccLink.ISEMPTY THEN BEGIN
            CurrPage.OnlineBanckAccountLinkPagePart.PAGE.SetRecs(TempOnlineBankAccLink);
            HideBankStatementProvider := TRUE;
          END;
      END;
    END;

    LOCAL PROCEDURE ShowAccountingPeriodStep@7();
    BEGIN
      AccountingPeriodVisible := TRUE;
    END;

    LOCAL PROCEDURE ShowCostingMethodStep@23();
    BEGIN
      IF InventorySetup.GET THEN;
      CostingMethodVisible := TRUE;
    END;

    LOCAL PROCEDURE ShowDoneStep@6();
    BEGIN
      DoneVisible := TRUE;
      NextEnabled := FALSE;
      FinishEnabled := TRUE;
      IF TypeEvaluation THEN BEGIN
        StartConfigPackageImport;
        BackEnabled := FALSE;
      END;
    END;

    LOCAL PROCEDURE ResetWizardControls@10();
    BEGIN
      CompanyData := CompanyData::None;

      // Buttons
      BackEnabled := TRUE;
      NextEnabled := TRUE;
      FinishEnabled := FALSE;

      // Tabs
      IntroVisible := FALSE;
      SyncVisible := FALSE;
      SelectTypeVisible := FALSE;
      CompanyDetailsVisible := FALSE;
      CommunicationDetailsVisible := FALSE;
      BankStatementConfirmationVisible := FALSE;
      SelectBankAccountVisible := FALSE;
      PaymentDetailsVisible := FALSE;
      AccountingPeriodVisible := FALSE;
      CostingMethodVisible := FALSE;
      DoneVisible := FALSE;
    END;

    LOCAL PROCEDURE InitializeRecord@8();
    VAR
      CompanyInformation@1001 : Record 79;
      AccountingPeriod@1000 : Record 50;
    BEGIN
      INIT;

      IF CompanyInformation.GET THEN BEGIN
        TRANSFERFIELDS(CompanyInformation);
        IF Name = '' THEN
          Name := COMPANYNAME;
      END ELSE
        Name := COMPANYNAME;

      SkipAccountingPeriod := NOT AccountingPeriod.ISEMPTY;
      IF NOT SkipAccountingPeriod THEN
        AccountingPeriodStartDate := CALCDATE('<-CY>',TODAY);

      INSERT;
    END;

    LOCAL PROCEDURE CalcCompanyData@21();
    BEGIN
      CompanyData := CompanyData::None;
      IF TypeStandard THEN
        CompanyData := CompanyData::"Standard Data";
      IF TypeEvaluation THEN
        CompanyData := CompanyData::"Evaluation Data";
    END;

    LOCAL PROCEDURE StartConfigPackageImport@9();
    BEGIN
      IF NOT TypeSelectionEnabled THEN
        EXIT;
      IF CompanyData = CompanyData::None THEN
        EXIT;
      IF AssistedCompanySetup.IsCompanySetupInProgress(COMPANYNAME) THEN
        EXIT;
      AssistedCompanySetup.FillCompanyData(COMPANYNAME,CompanyData);
    END;

    LOCAL PROCEDURE LoadConfigTypes@42() : Boolean;
    BEGIN
      StandardVisible :=
        AssistedCompanySetup.ExistsConfigurationPackageFile(CompanyData::"Standard Data");
      EvaluationVisible :=
        AssistedCompanySetup.ExistsConfigurationPackageFile(CompanyData::"Evaluation Data");
      EXIT(StandardVisible OR EvaluationVisible);
    END;

    LOCAL PROCEDURE PackageImported@11() : Boolean;
    VAR
      AssistedCompanySetupStatus@1000 : Record 1802;
    BEGIN
      AssistedCompanySetupStatus.GET(COMPANYNAME);
      EXIT(AssistedCompanySetupStatus."Package Imported" OR AssistedCompanySetupStatus."Import Failed");
    END;

    LOCAL PROCEDURE LoadTopBanners@40();
    BEGIN
      IF MediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png',FORMAT(ClientTypeManagement.GetCurrentClientType)) AND
         MediaRepositoryDone.GET('AssistedSetupDone-NoText-400px.png',FORMAT(ClientTypeManagement.GetCurrentClientType))
      THEN
        IF MediaResourcesStandard.GET(MediaRepositoryStandard."Media Resources Ref") AND
           MediaResourcesDone.GET(MediaRepositoryDone."Media Resources Ref")
        THEN
          TopBannerVisible := MediaResourcesDone."Media Reference".HASVALUE;
    END;

    LOCAL PROCEDURE PopulateBankAccountInformation@14();
    BEGIN
      IF BankAccountInformationUpdated THEN
        IF TempOnlineBankAccLink.COUNT = 0 THEN BEGIN
          RestoreBankAccountInformation(TempSavedBankAccount);
          EXIT;
        END;

      IF TempOnlineBankAccLink.COUNT = 1 THEN
        TempOnlineBankAccLink.FINDFIRST
      ELSE
        CurrPage.OnlineBanckAccountLinkPagePart.PAGE.GETRECORD(TempOnlineBankAccLink);

      IF (TempBankAccount."Bank Account No." = TempOnlineBankAccLink."Bank Account No.") AND
         (TempBankAccount.Name = TempOnlineBankAccLink.Name)
      THEN
        EXIT;

      IF NOT IsBankAccountFormatValid(TempOnlineBankAccLink."Bank Account No.") THEN
        CLEAR(TempOnlineBankAccLink."Bank Account No.");

      IF NOT BankAccountInformationUpdated THEN
        StoreBankAccountInformation(TempSavedBankAccount);

      TempBankAccount.INIT;
      TempBankAccount.CreateNewAccount(TempOnlineBankAccLink);
      RestoreBankAccountInformation(TempBankAccount);
      BankAccountInformationUpdated := TRUE;
    END;

    LOCAL PROCEDURE StoreBankAccountInformation@25(VAR BufferBankAccount@1000 : Record 270);
    BEGIN
      IF NOT BufferBankAccount.ISEMPTY THEN
        EXIT;
      BufferBankAccount.INIT;
      BufferBankAccount."Bank Account No." := "Bank Account No.";
      BufferBankAccount.Name := "Bank Name";
      BufferBankAccount."Bank Branch No." := "Bank Branch No.";
      BufferBankAccount."SWIFT Code" := "SWIFT Code";
      BufferBankAccount.IBAN := IBAN;
      BufferBankAccount.INSERT;
    END;

    LOCAL PROCEDURE RestoreBankAccountInformation@26(VAR BufferBankAccount@1000 : Record 270);
    BEGIN
      IF BufferBankAccount.ISEMPTY THEN
        EXIT;
      "Bank Account No." := BufferBankAccount."Bank Account No.";
      "Bank Name" := BufferBankAccount.Name;
      "Bank Branch No." := BufferBankAccount."Bank Branch No.";
      "SWIFT Code" := BufferBankAccount."SWIFT Code";
      IBAN := BufferBankAccount.IBAN;
    END;

    LOCAL PROCEDURE ShowBankStatementFeedConfirmation@18();
    BEGIN
      BankStatementConfirmationVisible := TRUE;
    END;

    LOCAL PROCEDURE ShowBankStatementFeedStep@37() : Boolean;
    VAR
      GeneralLedgerSetup@1000 : Record 98;
      BankStatementProviderExists@1001 : Boolean;
    BEGIN
      IF NOT GeneralLedgerSetup.GET THEN
        EXIT(FALSE);

      IF GeneralLedgerSetup."LCY Code" = '' THEN
        EXIT(FALSE);

      BankStatementProviderExists := BankAccount.StatementProvidersExist;

      IF NOT UseBankStatementFeedInitialized THEN BEGIN
        UseBankStatementFeed := BankStatementProviderExists;
        UseBankStatementFeedInitialized := TRUE;
      END;

      EXIT(BankStatementProviderExists);
    END;

    LOCAL PROCEDURE ShowSelectBankAccountStep@13() : Boolean;
    BEGIN
      EXIT(TempOnlineBankAccLink.COUNT > 1);
    END;

    LOCAL PROCEDURE ShowSelectBankAccount@16();
    BEGIN
      SelectBankAccountVisible := TRUE;
    END;

    LOCAL PROCEDURE IsBankAccountFormatValid@15(BankAccount@1000 : Text) : Boolean;
    VAR
      VarInt@1001 : Integer;
      Which@1002 : Text;
    BEGIN
      Which := ' -';
      EXIT(EVALUATE(VarInt,DELCHR(BankAccount,'=',Which)));
    END;

    LOCAL PROCEDURE ValidateBankAccountNotEmpty@17() : Boolean;
    BEGIN
      EXIT(("Bank Account No." <> '') OR TempOnlineBankAccLink.ISEMPTY);
    END;

    BEGIN
    END.
  }
}

