OBJECT Page 1 Company Information
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Virksomhedsoplysninger;
               ENU=Company Information];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table79;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Proces,Rapport,Programindstillinger,Systemindstillinger,Valutaer,Koder,Regionale indstillinger;
                                ENU=New,Process,Report,Application Settings,System Settings,Currencies,Codes,Regional Settings];
    OnInit=VAR
             ApplicationAreaSetup@1001 : Record 9178;
             WebhookManagement@1000 : Codeunit 5377;
           BEGIN
             SetShowMandatoryConditions;
             IsSaaS := PermissionManager.SoftwareAsAService AND NOT ApplicationAreaSetup.IsInvoicingOnlyEnabled;
             SyncAllowed := WebhookManagement.IsSyncAllowed;
             IsAdvancedSaaS := ApplicationAreaSetup.IsAdvancedSaaSEnabled;
           END;

    OnOpenPage=VAR
                 ApplicationAreaSetup@1000 : Record 9178;
               BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;
                 ApplicationAreaSetup.GetExperienceTierCurrentCompany(SavedExperience);
               END;

    OnClosePage=VAR
                  ApplicationAreaSetup@1000 : Record 9178;
                  BankAccount@1001 : Record 270;
                BEGIN
                  IF ApplicationAreaSetup.IsFoundationEnabled THEN
                    CompanyInformationMgt.UpdateCompanyBankAccount(Rec,BankAcctPostingGroup,BankAccount);

                  IF SavedExperience <> Experience THEN
                    RestartSession;
                END;

    OnAfterGetRecord=VAR
                       ApplicationAreaSetup@1000 : Record 9178;
                     BEGIN
                       ApplicationAreaSetup.GetExperienceTierCurrentCompany(Experience);
                     END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateSystemIndicator;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 70      ;1   ;Action    ;
                      CaptionML=[DAN=Ansvarscentre;
                                 ENU=Responsibility Centers];
                      ToolTipML=[DAN=Opret ansvarscentre til administration af forretningsaktiviteter, der dëkker forskellige lokationer, f.eks. et salgskontorer eller indkõbsafdelinger.;
                                 ENU=Set up responsibility centers to administer business operations that cover multiple locations, such as a sales offices or a purchasing departments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5715;
                      Image=Position }
      { 25      ;1   ;Action    ;
                      CaptionML=[DAN=Rapportlayout;
                                 ENU=Report Layouts];
                      ToolTipML=[DAN=Angiv det layout, der skal bruges ved visning, udskrivning og lagring af rapporter. Layoutet definerer f.eks. skrifttype, feltplacering eller baggrund.;
                                 ENU=Specify the layout to use on reports when viewing, printing, and saving them. The layout defines things like text font, field placement, or background.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9652;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes }
      { 53      ;1   ;ActionGroup;
                      CaptionML=[DAN=Programindstillinger;
                                 ENU=Application Settings] }
      { 55      ;2   ;ActionGroup;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Setup];
                      Image=Setup }
      { 52      ;3   ;Action    ;
                      CaptionML=[DAN=Opsëtning af Finans;
                                 ENU=General Ledger Setup];
                      ToolTipML=[DAN=Definer dine generelle regnskabspolitikker, f.eks. den tilladte bogfõringsperiode, og hvordan betalinger behandles. Konfigurer dine standarddimensioner for finansielle analyser.;
                                 ENU=Define your general accounting policies, such as the allowed posting period and how payments are processed. Set up your default dimensions for financial analysis.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 118;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=JournalSetup;
                      PromotedCategory=Category4 }
      { 46      ;3   ;Action    ;
                      CaptionML=[DAN=Opsëtning af Salg;
                                 ENU=Sales & Receivables Setup];
                      ToolTipML=[DAN=Definer dine gennerelle politikker for fakturering af salg og for returneringer, som f.eks. hvornÜr krediterings- og beholdningsadvarsler skal vises, og hvordan salgsrabatter skal bogfõres. Konfigurer dine nummerserier for oprettelse af debitorer og forskellige salgsdokumenter.;
                                 ENU=Define your general policies for sales invoicing and returns, such as when to show credit and stockout warnings and how to post sales discounts. Set up your number series for creating customers and different sales documents.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 459;
                      Image=ReceivablesPayablesSetup }
      { 48      ;3   ;Action    ;
                      CaptionML=[DAN=Opsëtning af Kõb;
                                 ENU=Purchases & Payables Setup];
                      ToolTipML=[DAN=Definer dine gennerelle politikker for fakturering af kõb og for returneringer, som f.eks. om kreditorfakturanumre skal angives, og hvordan kõbsrabatter skal bogfõres. Konfigurer dine nummerserier for oprettelse af kreditorer og forskellige kõbsdokumenter.;
                                 ENU=Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 460;
                      Image=Purchase }
      { 45      ;3   ;Action    ;
                      CaptionML=[DAN=Opsëtning af Lager;
                                 ENU=Inventory Setup];
                      ToolTipML=[DAN=Definer dine gennerelle lagerpolitikker, som f.eks. om negativ beholdning er tilladt, og hvordan varepriser skal bogfõres og reguleres. Konfigurer dine nummerserier for oprettelse af nye lagervarer eller -tjenester.;
                                 ENU=Define your general inventory policies, such as whether to allow negative inventory and how to post and adjust item costs. Set up your number series for creating new inventory items or services.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 461;
                      Image=InventorySetup }
      { 44      ;3   ;Action    ;
                      CaptionML=[DAN=Opsëtning af Anlëg;
                                 ENU=Fixed Assets Setup];
                      ToolTipML=[DAN=Definer regnskabspolitikkerne for anlëgsaktiver, som f.eks. den tilladte bogfõringsperiode, og om bogfõring pÜ hovedanlëg er tilladt. Konfigurer nummerserien for oprettelse af nye anlëgsaktiver.;
                                 ENU=Define your accounting policies for fixed assets, such as the allowed posting period and whether to allow posting to main assets. Set up your number series for creating new fixed assets.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5607;
                      Image=FixedAssets }
      { 41      ;3   ;Action    ;
                      CaptionML=[DAN=Opsëtning af Personale;
                                 ENU=Human Resources Setup];
                      ToolTipML=[DAN=Konfigurer nummerserie for oprettelse af nye medarbejderkort, og definer, om ansëttelsestid mÜles i dage eller timer.;
                                 ENU=Set up number series for creating new employee cards and define if employment time is measured by days or hours.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5233;
                      Image=HRSetup }
      { 40      ;3   ;Action    ;
                      CaptionML=[DAN=Opsëtning af Sag;
                                 ENU=Jobs Setup];
                      ToolTipML=[DAN=Definer dine regnskabspolitikker for sager, f.eks. hvilken metode for igangvërende arbejde der skal bruges, og om varekostpriser skal opdateres automatisk.;
                                 ENU=Define your accounting policies for jobs, such as which WIP method to use and whether to update job item costs automatically.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 463;
                      Image=Job }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Nummerserie;
                                 ENU=No. Series];
                      ToolTipML=[DAN=Konfigurer den nummerserie, som et nyt nummer automatisk tildeles til nye kort og dokumenter fra, som f.eks. varekort og salgsfakturaer.;
                                 ENU=Set up the number series from which a new number is automatically assigned to new cards and documents, such as item cards and sales invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 456;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NumberSetup;
                      PromotedCategory=Category4 }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=Systemindstillinger;
                                 ENU=System Settings] }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Brugere;
                                 ENU=Users];
                      ToolTipML=[DAN=Konfigurer de medarbejdere, der skal arbejde i denne virksomhed.;
                                 ENU=Set up the employees who will work in this company.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9800;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Users;
                      PromotedCategory=Category5 }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Rettighedssët;
                                 ENU=Permission Sets];
                      ToolTipML=[DAN=Vis eller rediger, hvilke funktionsobjekter brugerne skal bruge til at fÜ adgang til og konfigurere de relaterede tilladelser i rettighedssët, som du kan tildele til databasens brugere.;
                                 ENU=View or edit which feature objects that users need to access and set up the related permissions in permission sets that you can assign to the users of the database.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9802;
                      Image=Permission }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=Opsëtning af SMTP-mail;
                                 ENU=SMTP Mail Setup];
                      ToolTipML=[DAN=Konfigurer integrationen og sikkerheden for den mailserver pÜ dit websted, der hÜndterer mail.;
                                 ENU=Set up the integration and security of the mail server at your site that handles email.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 409;
                      Image=MailSetup }
      { 59      ;1   ;ActionGroup;
                      CaptionML=[DAN=Valutaer;
                                 ENU=Currencies] }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Valutaer;
                                 ENU=Currencies];
                      ToolTipML=[DAN=Konfigurer de forskellige valutaer, du handler i, ved at definere, hvilke finanskonti de involverede transaktioner bogfõres pÜ, og hvordan belõbene i fremmed valuta afrundes.;
                                 ENU=Set up the different currencies that you trade in by defining which general ledger accounts the involved transactions are posted to and how the foreign currency amounts are rounded.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Currencies;
                      PromotedCategory=Category6 }
      { 21      ;1   ;ActionGroup;
                      CaptionML=[DAN=Regionale indstillinger;
                                 ENU=Regional Settings] }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Lande/omrÜder;
                                 ENU=Countries/Regions];
                      ToolTipML=[DAN=Konfigurer de lande/omrÜder, hvor dine forskellige forretningspartnere er placeret, sÜ du kan tildele lande- og omrÜdekoder til forretningspartnere, hvor der krëves specielle lokale procedurer.;
                                 ENU=Set up the country/regions where your different business partners are located, so that you can assign Country/Region codes to business partners where special local procedures are required.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 10;
                      Image=CountryRegion }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=Postnumre;
                                 ENU=Post Codes];
                      ToolTipML=[DAN=Konfigurer postnumre for de byer, hvor dine forretningspartnere er placeret.;
                                 ENU=Set up the post codes of cities where your business partners are located.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 367;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=MailSetup;
                      PromotedCategory=Category8 }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=Opsëtning af Online Map;
                                 ENU=Online Map Setup];
                      ToolTipML=[DAN=Definer, hvilke kortudbydere der skal bruges, og hvordan ruter og afstande vises, nÜr du vëlger feltet Online Map i forretningsdokumenter.;
                                 ENU=Define which map provider to use and how routes and distances are displayed when you choose the Online Map field on business documents.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 800;
                      Image=MapSetup }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=Sprog;
                                 ENU=Languages];
                      ToolTipML=[DAN=Konfigurer de sprog, der tales af de forskellige forretningspartnere, sÜ du kan udskrive varenavne eller -beskrivelser pÜ det relevante sprog.;
                                 ENU=Set up the languages that are spoken by your different business partners, so that you can print item names or descriptions in the relevant language.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Language;
                      PromotedCategory=Category7 }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Koder;
                                 ENU=Codes];
                      ActionContainerType=NewDocumentItems }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Kildekoder;
                                 ENU=Source Codes];
                      ToolTipML=[DAN=Konfigurer koder for de forskellige forretningstransaktionstyper, sÜ du kan spore transaktionskilden i forbindelse med revision.;
                                 ENU=Set up codes for your different types of business transactions, so that you can track the source of the transactions in an audit.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 257;
                      Image=CodesList }
      { 5       ;2   ;Action    ;
                      CaptionML=[DAN=èrsagskoder;
                                 ENU=Reason Codes];
                      ToolTipML=[DAN=Vis eller konfigurer koder, der angiver Ürsager til oprettelse af poster (f.eks. Returvare), for at angive, hvorfor en kõbskreditnota er bogfõrt.;
                                 ENU=View or set up codes that specify reasons why entries were created, such as Return, to specify why a purchase credit memo was posted.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 259;
                      Image=CodesList }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedens navn og selskabsform, f.eks. A/S eller ApS.;
                           ENU=Specifies the company's name and corporate form. For example, Inc. or Ltd.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                ShowMandatory=TRUE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedens adresse.;
                           ENU=Specifies the company's address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address;
                ShowMandatory=TRUE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code";
                ShowMandatory=TRUE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedens by.;
                           ENU=Specifies the company's city.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City;
                ShowMandatory=TRUE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omrÜde.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code";
                ShowMandatory=TRUE }

    { 63  ;2   ;Field     ;
                CaptionML=[DAN=Kontaktnavn;
                           ENU=Contact Name];
                ToolTipML=[DAN=Angiver navnet pÜ kontakten i din virksomhed.;
                           ENU=Specifies the name of the contact person in your company.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Person" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedens telefonnummer.;
                           ENU=Specifies the company's telephone number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedens CVR-nummer.;
                           ENU=Specifies the company's VAT registration number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Registration No.";
                ShowMandatory=TRUE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver din virksomhed i forbindelse med udveksling af elektronisk dokument.;
                           ENU=Specifies your company in connection with electronic document exchange.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GLN }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedens SIC-kode.;
                           ENU=Specifies the company's industrial classification code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Industrial Classification";
                Importance=Additional }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det billede, der er oprettet for virksomheden, f.eks. et firmalogo.;
                           ENU=Specifies the picture that has been set up for the company, such as a company logo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Picture;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 61  ;2   ;Field     ;
                CaptionML=[DAN=Synkroniser med Office 365 Business-profil;
                           ENU=Synchronize with Office 365 Business Profile];
                ToolTipML=[DAN=Angiver, at profilen skal synkroniseres med den i Office 365.;
                           ENU=Specifies that the profile will be synchronized with the one in Office 365.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sync with O365 Bus. profile";
                Importance=Additional;
                Visible=SyncAllowed }

    { 1902768601;1;Group  ;
                CaptionML=[DAN=Kommunikation;
                           ENU=Communication] }

    { 50  ;2   ;Field     ;
                Name=Phone No.2;
                ToolTipML=[DAN=Angiver virksomhedens telefonnummer.;
                           ENU=Specifies the company's telephone number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No.";
                Importance=Additional }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedens faxnummer.;
                           ENU=Specifies the company's fax number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fax No.";
                Importance=Additional }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedens mailadresse.;
                           ENU=Specifies the company's email address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail" }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver din virksomheds websted.;
                           ENU=Specifies your company's web site.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Home Page" }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedens koncerninterne partnerkode.;
                           ENU=Specifies your company's intercompany partner code.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code";
                Importance=Additional }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type IC-indbakke, du har, enten Filplacering eller Database.;
                           ENU=Specifies what type of intercompany inbox you have, either File Location or Database.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Inbox Type";
                Importance=Additional }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om placeringen af din IC-indbakke, som kan overfõre IC-transaktioner til virksomheden.;
                           ENU=Specifies details about the location of your intercompany inbox, which can transfer intercompany transactions into your company.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Inbox Details";
                Importance=Additional }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at nÜr der modtages transaktioner i den koncerninterne udbakke, sendes de til den koncerninterne partner.;
                           ENU=Specifies that as soon as transactions arrive in the intercompany outbox, they will be sent to the intercompany partner.];
                ApplicationArea=#Intercompany;
                SourceExpr="Auto. Send Transactions";
                Importance=Additional }

    { 1901677601;1;Group  ;
                CaptionML=[DAN=Betalinger;
                           ENU=Payments] }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du har tilladelse til at oprette en salgsfaktura uden at udfylde opsëtningsfelterne i dette oversigtspanel.;
                           ENU=Specifies if you are allowed to create a sales invoice without filling the setup fields on this FastTab.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow Blank Payment Info." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den bank, virksomheden bruger.;
                           ENU=Specifies the name of the bank the company uses.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Name";
                ShowMandatory=TRUE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankens registreringsnummer.;
                           ENU=Specifies the bank's branch number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Branch No.";
                OnValidate=BEGIN
                             SetShowMandatoryConditions
                           END;

                ShowMandatory=IBANMissing }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedens bankkontonummer.;
                           ENU=Specifies the company's bank account number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account No.";
                OnValidate=BEGIN
                             SetShowMandatoryConditions
                           END;

                ShowMandatory=IBANMissing }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedens PBS-nummer.;
                           ENU=Specifies the company's payment routing number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Routing No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedens gironummer.;
                           ENU=Specifies the company's giro number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Giro No." }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver SWIFT-koden (internationalt bank-id) for din primëre bank.;
                           ENU=Specifies the SWIFT code (international bank identifier code) of your primary bank.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="SWIFT Code";
                OnValidate=BEGIN
                             SetShowMandatoryConditions
                           END;
                            }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den primëre bankkontos internationale bankkontonummer.;
                           ENU=Specifies the international bank account number of your primary bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=IBAN;
                OnValidate=BEGIN
                             SetShowMandatoryConditions
                           END;

                ShowMandatory=BankBranchNoOrAccountNoMissing }

    { 30  ;2   ;Field     ;
                Name=BankAccountPostingGroup;
                Lookup=Yes;
                CaptionML=[DAN=" Bankkontobogfõringsgruppe";
                           ENU=" Bank Account Posting Group"];
                ToolTipML=[DAN=Angiver en kode for bankkontobogfõringsgruppe for virksomhedens bankkonto.;
                           ENU=Specifies a code for the bank account posting group for the company's bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BankAcctPostingGroup;
                TableRelation="Bank Account Posting Group".Code }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den lokation, som virksomhedens varer skal leveres til.;
                           ENU=Specifies the name of the location to which items for the company should be shipped.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name" }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen pÜ den lokation, som virksomhedens varer skal leveres til.;
                           ENU=Specifies the address of the location to which items for the company should be shipped.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address 2" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code" }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i virksomhedens leveringsadresse.;
                           ENU=Specifies the city of the company's ship-to address.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to City" }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omrÜdekoden pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Country/Region Code" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokationskode, der svarer til virksomhedens leveringsadresse.;
                           ENU=Specifies the location code that corresponds to the company's ship-to address.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for standardansvarscentret.;
                           ENU=Specifies the code for the default responsibility center.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en datoformel, som definerer det tidsrum efter planlagt afsendelsesdato pÜ behovslinjer, hvor systemet kontrollerer tilgëngelighed for den pÜgëldende behovslinje.;
                           ENU=Specifies a date formula that defines the length of the period after the planned shipment date on demand lines in which the system checks availability for the demand line in question.];
                ApplicationArea=#Planning;
                SourceExpr="Check-Avail. Period Calc." }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor ofte systemet kontrollerer forsyningsbehovshëndelser for at registrere, om varen pÜ behovslinjen er tilgëngelig pÜ afsendelsesdatoen.;
                           ENU=Specifies how frequently the system checks supply-demand events to discover if the item on the demand line is available on its shipment date.];
                ApplicationArea=#Planning;
                SourceExpr="Check-Avail. Time Bucket" }

    { 67  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver koden for den basiskalender, som du vil tildele din virksomhed.;
                           ENU=Specifies the code for the base calendar that you want to assign to your company.];
                ApplicationArea=#Advanced;
                SourceExpr="Base Calendar Code" }

    { 69  ;2   ;Field     ;
                Name=Customized Calendar;
                DrillDown=Yes;
                CaptionML=[DAN=Tilpasset kalender;
                           ENU=Customized Calendar];
                ToolTipML=[DAN=Angiver, om virksomheden har oprettet en tilpasset kalender.;
                           ENU=Specifies whether or not your company has set up a customized calendar.];
                ApplicationArea=#Advanced;
                SourceExpr=CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."Source Type"::Company,'','',"Base Calendar Code");
                Editable=FALSE;
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              TESTFIELD("Base Calendar Code");
                              CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."Source Type"::Company,'','',"Base Calendar Code");
                            END;
                             }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan datoer baseret pÜ kalender- og kalenderrelaterede dokumenter beregnes.;
                           ENU=Specifies how dates based on calendar and calendar-related documents are calculated.];
                ApplicationArea=#Advanced;
                SourceExpr="Cal. Convergence Time Frame" }

    { 1904604101;1;Group  ;
                CaptionML=[DAN=Systemindikator;
                           ENU=System Indicator] }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan du vil bruge systemindikatoren, nÜr du arbejder med forskellige versioner af Dynamics NAV.;
                           ENU=Specifies how you want to use the system indicator when you are working with different versions of Dynamics NAV.];
                ApplicationArea=#Advanced;
                SourceExpr="System Indicator";
                OnValidate=BEGIN
                             SystemIndicatorOnAfterValidate;
                           END;
                            }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil anvende en bestemt typografi i systemindikatoren.;
                           ENU=Specifies if you want to apply a certain style to the system indicator.];
                ApplicationArea=#Advanced;
                SourceExpr="System Indicator Style" }

    { 102 ;2   ;Field     ;
                Name=System Indicator Text;
                CaptionML=[DAN=Tekst til systemindikator;
                           ENU=System Indicator Text];
                ToolTipML=[DAN=Angiver tekst, som du angiver i feltet Navn.;
                           ENU=Specifies text that you enter in the Name field.];
                ApplicationArea=#Advanced;
                SourceExpr=SystemIndicatorText;
                Editable=SystemIndicatorTextEditable;
                OnValidate=BEGIN
                             "Custom System Indicator Text" := SystemIndicatorText;
                             SystemIndicatorTextOnAfterVali;
                           END;
                            }

    { 31  ;1   ;Group     ;
                CaptionML=[DAN=Brugeroplevelse;
                           ENU=User Experience];
                Visible=(Experience = Experience::Custom) AND IsSaaS;
                GroupType=Group }

    { 32  ;2   ;Field     ;
                Name=ExperienceCustom;
                AccessByPermission=TableData 9178=IM;
                CaptionML=[DAN=Oplevelse;
                           ENU=Experience];
                ToolTipML=[DAN=Angiver, hvilke funktionalitetsomrÜder der vises felter og handlinger for i brugergrënsefladen. PÜ denne mÜde forenkles produktet ved at skjule brugergrënsefladeelementer for funktioner, virksomheden ikke bruger.;
                           ENU=Specifies for which application areas fields and actions are shown in the user interface. This is a way to simplify the product by hiding UI elements for features that the company does not use.];
                OptionCaptionML=[DAN=,,,,,Grundlëggende,,,,,,,,,,Suite,,,,,Brugerdefineret;
                                 ENU=,,,,,Basic,,,,,,,,,,Suite,,,,,Custom];
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=Experience;
                OnValidate=VAR
                             ApplicationAreaSetup@1000 : Record 9178;
                           BEGIN
                             ApplicationAreaSetup.SetExperienceTierCurrentCompany(Experience);
                           END;
                            }

    { 38  ;1   ;Group     ;
                CaptionML=[DAN=Brugeroplevelse;
                           ENU=User Experience];
                Visible=(Experience <> Experience::Custom) AND IsSaaS;
                GroupType=Group }

    { 36  ;2   ;Field     ;
                Name=Experience;
                AccessByPermission=TableData 9178=IM;
                CaptionML=[DAN=Oplevelse;
                           ENU=Experience];
                ToolTipML=[DAN=Angiver, hvilke funktionalitetsomrÜder der vises felter og handlinger for i brugergrënsefladen. PÜ denne mÜde forenkles produktet ved at skjule brugergrënsefladeelementer for funktioner, virksomheden ikke bruger.;
                           ENU=Specifies for which application areas fields and actions are shown in the user interface. This is a way to simplify the product by hiding UI elements for features that the company does not use.];
                OptionCaptionML=[DAN=,,,,,Grundlëggende,,,,,,,,,,Suite;
                                 ENU=,,,,,Basic,,,,,,,,,,Suite];
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=Experience;
                Visible=NOT IsAdvancedSaaS;
                OnValidate=VAR
                             ApplicationAreaSetup@1000 : Record 9178;
                           BEGIN
                             ApplicationAreaSetup.SetExperienceTierCurrentCompany(Experience);
                           END;
                            }

    { 65  ;2   ;Field     ;
                Name=ExperienceFull;
                AccessByPermission=TableData 9178=IM;
                CaptionML=[DAN=Oplevelse;
                           ENU=Experience];
                ToolTipML=[DAN=Angiver, hvilke funktionalitetsomrÜder der vises felter og handlinger for i brugergrënsefladen. PÜ denne mÜde forenkles produktet ved at skjule brugergrënsefladeelementer for funktioner, virksomheden ikke bruger.;
                           ENU=Specifies for which application areas fields and actions are shown in the user interface. This is a way to simplify the product by hiding UI elements for features that the company does not use.];
                OptionCaptionML=[DAN=,,,,,Grundlëggende,,,,,,,,,,Suite,,,,,,,,,,Avanceret;
                                 ENU=,,,,,Basic,,,,,,,,,,Suite,,,,,,,,,,Advanced];
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=Experience;
                Visible=IsAdvancedSaaS;
                OnValidate=VAR
                             ApplicationAreaSetup@1000 : Record 9178;
                           BEGIN
                             ApplicationAreaSetup.SetExperienceTierCurrentCompany(Experience);
                           END;
                            }

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
      CustomizedCalEntry@1007 : Record 7603;
      CustomizedCalendar@1005 : Record 7602;
      CalendarMgmt@1004 : Codeunit 7600;
      CompanyInformationMgt@1003 : Codeunit 1306;
      PermissionManager@1011 : Codeunit 9002;
      Experience@1008 : ',,,,,Basic,,,,,,,,,,Suite,,,,,Custom,,,,,Advanced';
      SavedExperience@1009 : ',,,,,Basic,,,,,,,,,,Suite,,,,,Custom,,,,,Advanced';
      SystemIndicatorText@1006 : Text[250];
      SystemIndicatorTextEditable@19043996 : Boolean INDATASET;
      IBANMissing@1000 : Boolean;
      BankBranchNoOrAccountNoMissing@1001 : Boolean;
      IsSaaS@1010 : Boolean;
      SyncAllowed@1012 : Boolean;
      IsAdvancedSaaS@1013 : Boolean;
      BankAcctPostingGroup@1002 : Code[20];

    LOCAL PROCEDURE UpdateSystemIndicator@1008();
    VAR
      IndicatorStyle@1000 : Option;
    BEGIN
      GetSystemIndicator(SystemIndicatorText,IndicatorStyle); // IndicatorStyle is not used
      SystemIndicatorTextEditable := CurrPage.EDITABLE AND ("System Indicator" = "System Indicator"::"Custom Text");
    END;

    LOCAL PROCEDURE SystemIndicatorTextOnAfterVali@19070270();
    BEGIN
      UpdateSystemIndicator
    END;

    LOCAL PROCEDURE SystemIndicatorOnAfterValidate@19079461();
    BEGIN
      UpdateSystemIndicator
    END;

    LOCAL PROCEDURE SetShowMandatoryConditions@2();
    BEGIN
      BankBranchNoOrAccountNoMissing := ("Bank Branch No." = '') OR ("Bank Account No." = '');
      IBANMissing := IBAN = ''
    END;

    LOCAL PROCEDURE RestartSession@1();
    VAR
      SessionSetting@1000 : SessionSettings;
    BEGIN
      SessionSetting.INIT;
      SessionSetting.REQUESTSESSIONUPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

