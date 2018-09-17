OBJECT Page 5050 Contact Card
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontaktkort;
               ENU=Contact Card];
    SourceTable=Table5050;
    PageType=ListPlus;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Relaterede oplysninger;
                                ENU=New,Process,Report,Related Information];
    OnInit=BEGIN
             OrganizationalLevelCodeEnable := TRUE;
             CompanyNameEnable := TRUE;
             VATRegistrationNoEnable := TRUE;
             CurrencyCodeEnable := TRUE;
             ActionVisible := CURRENTCLIENTTYPE = CLIENTTYPE::Windows;
           END;

    OnOpenPage=VAR
                 OfficeManagement@1002 : Codeunit 1630;
               BEGIN
                 IsOfficeAddin := OfficeManagement.IsAvailable;
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
                 SetNoFieldVisible;
                 SetParentalConsentReceivedEnable;
               END;

    OnNewRecord=VAR
                  Contact@1001 : Record 5050;
                BEGIN
                  IF GETFILTER("Company No.") <> '' THEN BEGIN
                    "Company No." := GETRANGEMAX("Company No.");
                    Type := Type::Person;
                    Contact.GET("Company No.");
                    InheritCompanyToPersonData(Contact);
                  END;
                END;

    OnAfterGetCurrRecord=VAR
                           CRMCouplingManagement@1001 : Codeunit 5331;
                         BEGIN
                           IF CRMIntegrationEnabled THEN BEGIN
                             CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
                             IF "No." <> xRec."No." THEN
                               CRMIntegrationManagement.SendResultNotification(Rec);
                           END;

                           xRec := Rec;
                           EnableFields;

                           IF Type = Type::Person THEN
                             IntegrationFindCustomerNo
                           ELSE
                             IntegrationCustomerNo := '';
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 76      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&ontakt;
                                 ENU=C&ontact];
                      Image=ContactPerson }
      { 82      ;2   ;ActionGroup;
                      CaptionML=[DAN=Virksom&hed;
                                 ENU=Comp&any];
                      Enabled=CompanyGroupEnabled;
                      Image=Company }
      { 85      ;3   ;Action    ;
                      CaptionML=[DAN=Forretningsrelationer;
                                 ENU=Business Relations];
                      ToolTipML=[DAN=Vis eller rediger kontaktens forretningsrelationer, eksempelvis debitorer, kreditorer, banker, advokater, konsulenter, konkurrenter og sÜ videre.;
                                 ENU=View or edit the contact's business relations, such as customers, vendors, banks, lawyers, consultants, competitors, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=BusinessRelation;
                      OnAction=VAR
                                 ContactBusinessRelationRec@1000 : Record 5054;
                               BEGIN
                                 TESTFIELD(Type,Type::Company);
                                 ContactBusinessRelationRec.SETRANGE("Contact No.","Company No.");
                                 PAGE.RUN(PAGE::"Contact Business Relations",ContactBusinessRelationRec);
                               END;
                                }
      { 83      ;3   ;Action    ;
                      CaptionML=[DAN=Brancher;
                                 ENU=Industry Groups];
                      ToolTipML=[DAN=Vis eller rediger de brancher, f.eks. Detail eller Automobil, som kontakten tilhõrer.;
                                 ENU=View or edit the industry groups, such as Retail or Automobile, that the contact belongs to.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=IndustryGroups;
                      OnAction=VAR
                                 ContactIndustryGroupRec@1001 : Record 5058;
                               BEGIN
                                 TESTFIELD(Type,Type::Company);
                                 ContactIndustryGroupRec.SETRANGE("Contact No.","Company No.");
                                 PAGE.RUN(PAGE::"Contact Industry Groups",ContactIndustryGroupRec);
                               END;
                                }
      { 84      ;3   ;Action    ;
                      CaptionML=[DAN=Webkilder;
                                 ENU=Web Sources];
                      ToolTipML=[DAN=Vis en liste med webstederne med oplysninger om kontakten.;
                                 ENU=View a list of the web sites with information about the contact.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Web;
                      OnAction=VAR
                                 ContactWebSourceRec@1001 : Record 5060;
                               BEGIN
                                 TESTFIELD(Type,Type::Company);
                                 ContactWebSourceRec.SETRANGE("Contact No.","Company No.");
                                 PAGE.RUN(PAGE::"Contact Web Sources",ContactWebSourceRec);
                               END;
                                }
      { 80      ;2   ;ActionGroup;
                      CaptionML=[DAN=Kontak&t;
                                 ENU=P&erson];
                      Enabled=PersonGroupEnabled;
                      Image=User }
      { 81      ;3   ;Action    ;
                      CaptionML=[DAN=AnsvarsomrÜder;
                                 ENU=Job Responsibilities];
                      ToolTipML=[DAN=Vis eller rediger kontaktens ansvarsomrÜder.;
                                 ENU=View or edit the contact's job responsibilities.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Job;
                      OnAction=VAR
                                 ContJobResp@1001 : Record 5067;
                               BEGIN
                                 TESTFIELD(Type,Type::Person);
                                 ContJobResp.SETRANGE("Contact No.","No.");
                                 PAGE.RUNMODAL(PAGE::"Contact Job Responsibilities",ContJobResp);
                               END;
                                }
      { 87      ;2   ;Action    ;
                      CaptionML=[DAN=Pro&filer;
                                 ENU=Pro&files];
                      ToolTipML=[DAN=èbn vinduet Profilspõrgeskema.;
                                 ENU=Open the Profile Questionnaires window.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Answers;
                      OnAction=VAR
                                 ProfileManagement@1001 : Codeunit 5059;
                               BEGIN
                                 ProfileManagement.ShowContactQuestionnaireCard(Rec,'',0);
                               END;
                                }
      { 89      ;2   ;Action    ;
                      CaptionML=[DAN=&Billede;
                                 ENU=&Picture];
                      ToolTipML=[DAN=Vis eller tilfõj et billede af kontaktpersonen eller f.eks. virksomhedens logo.;
                                 ENU=View or add a picture of the contact person or, for example, the company's logo.];
                      ApplicationArea=#Suite,#RelationshipMgmt;
                      RunObject=Page 5104;
                      RunPageLink=No.=FIELD(No.);
                      Visible=ActionVisible;
                      Image=Picture }
      { 90      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5072;
                      RunPageLink=Table Name=CONST(Contact),
                                  No.=FIELD(No.),
                                  Sub No.=CONST(0);
                      Image=ViewComments }
      { 91      ;2   ;ActionGroup;
                      CaptionML=[DAN=Alternati&v adresse;
                                 ENU=Alternati&ve Address];
                      Image=Addresses }
      { 92      ;3   ;Action    ;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om kontakten.;
                                 ENU=View or change detailed information about the contact.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5057;
                      RunPageLink=Contact No.=FIELD(No.);
                      Image=EditLines }
      { 93      ;3   ;Action    ;
                      CaptionML=[DAN=Datointervaller;
                                 ENU=Date Ranges];
                      ToolTipML=[DAN=Angiver datointervallet, der gëlder for kontaktens alternative adresse.;
                                 ENU=Specify date ranges that apply to the contact's alternate address.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5059;
                      RunPageLink=Contact No.=FIELD(No.);
                      Image=DateRange }
      { 23      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled;
                      Enabled=(Type <> Type::Company) AND ("Company No." <> '') }
      { 21      ;2   ;Action    ;
                      Name=CRMGotoContact;
                      CaptionML=[DAN=Kontakt;
                                 ENU=Contact];
                      ToolTipML=[DAN=èbn den sammenkëdede Dynamics 365 for Sales-kontakt.;
                                 ENU=Open the coupled Dynamics 365 for Sales contact.];
                      ApplicationArea=#Suite;
                      Image=CoupledContactPerson;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowCRMEntityFromRecordID(RECORDID);
                               END;
                                }
      { 29      ;2   ;Action    ;
                      Name=CRMSynchronizeNow;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Synkroniser;
                                 ENU=Synchronize];
                      ToolTipML=[DAN=Send eller hent opdaterede data til eller fra Dynamics 365 for Sales.;
                                 ENU=Send or get updated data to or from Dynamics 365 for Sales.];
                      ApplicationArea=#Suite;
                      Image=Refresh;
                      OnAction=VAR
                                 CRMIntegrationManagement@1001 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.UpdateOneNow(RECORDID);
                               END;
                                }
      { 27      ;2   ;ActionGroup;
                      Name=Coupling;
                      CaptionML=[@@@=Coupling is a noun;
                                 DAN=Sammenkëdning;
                                 ENU=Coupling];
                      ToolTipML=[DAN=Opret, rediger eller slet en sammenkëdning mellem Microsoft Dynamics NAV-recorden og en Dynamics 365 for Sales-record.;
                                 ENU=Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.];
                      Image=LinkAccount }
      { 25      ;3   ;Action    ;
                      Name=ManageCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Konfigurer sammenkëdning;
                                 ENU=Set Up Coupling];
                      ToolTipML=[DAN=Opret eller rediger sammenkëdningen med en Dynamics 365 for Sales-kontakt.;
                                 ENU=Create or modify the coupling to a Dynamics 365 for Sales contact.];
                      ApplicationArea=#Suite;
                      Image=LinkAccount;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.DefineCoupling(RECORDID);
                               END;
                                }
      { 19      ;3   ;Action    ;
                      Name=DeleteCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Slet sammenkëdning;
                                 ENU=Delete Coupling];
                      ToolTipML=[DAN=Slet sammenkëdningen med en Dynamics 365 for Sales-kontakt.;
                                 ENU=Delete the coupling to a Dynamics 365 for Sales contact.];
                      ApplicationArea=#Suite;
                      Enabled=CRMIsCoupledToRecord;
                      Image=UnLinkAccount;
                      OnAction=VAR
                                 CRMCouplingManagement@1000 : Codeunit 5331;
                               BEGIN
                                 CRMCouplingManagement.RemoveCoupling(RECORDID);
                               END;
                                }
      { 45      ;2   ;Action    ;
                      Name=ShowLog;
                      CaptionML=[DAN=Synkroniseringslog;
                                 ENU=Synchronization Log];
                      ToolTipML=[DAN=Vis integrationssynkroniseringsjobs for kontakttabellen.;
                                 ENU=View integration synchronization jobs for the contact table.];
                      ApplicationArea=#Suite;
                      Image=Log;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowLog(RECORDID);
                               END;
                                }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Relaterede oplysninger;
                                 ENU=Related Information];
                      Image=Users }
      { 79      ;2   ;Action    ;
                      CaptionML=[DAN=Tilknytte&de kontakter;
                                 ENU=Relate&d Contacts];
                      ToolTipML=[DAN=Se en liste med alle kontakter.;
                                 ENU=View a list of all contacts.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5052;
                      RunPageLink=Company No.=FIELD(Company No.);
                      Image=Users }
      { 100     ;2   ;Action    ;
                      CaptionML=[DAN=MÜlgr&upper;
                                 ENU=Segmen&ts];
                      ToolTipML=[DAN=Vis segmenter, der er relateret til kontakten.;
                                 ENU=View the segments that are related to the contact.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5150;
                      RunPageView=SORTING(Contact No.,Segment No.);
                      RunPageLink=Contact Company No.=FIELD(Company No.),
                                  Contact No.=FILTER(<>''),
                                  Contact No.=FIELD(FILTER(Lookup Contact No.));
                      Image=Segment }
      { 86      ;2   ;Action    ;
                      CaptionML=[DAN=Mailg&rupper;
                                 ENU=Mailing &Groups];
                      ToolTipML=[DAN=Vis eller rediger mailgrupper, som kontakten er tildelt, eksempelvis til at sende prislister eller julekort.;
                                 ENU=View or edit the mailing groups that the contact is assigned to, for example, for sending price lists or Christmas cards.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5064;
                      RunPageLink=Contact No.=FIELD(No.);
                      Image=DistributionGroup }
      { 99      ;2   ;Action    ;
                      CaptionML=[DAN=D&ebitor/Kreditor/Bankkto.;
                                 ENU=C&ustomer/Vendor/Bank Acc.];
                      ToolTipML=[DAN=Se den relaterede debitor, kreditor eller bankkonto, der er knyttet til den aktuelle record.;
                                 ENU=View the related customer, vendor, or bank account that is associated with the current record.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ContactReference;
                      OnAction=BEGIN
                                 ShowCustVendBank;
                               END;
                                }
      { 63      ;2   ;Action    ;
                      CaptionML=[DAN=Online Map;
                                 ENU=Online Map];
                      ToolTipML=[DAN=Vis adressen pÜ et onlinekort.;
                                 ENU=View the address on an online map.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Map;
                      OnAction=BEGIN
                                 DisplayMap;
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=Office Customer/Vendor;
                      CaptionML=[DAN=Debitor/kreditor;
                                 ENU=Customer/Vendor];
                      ToolTipML=[DAN=Vis den relaterede debitor, kreditor eller bankkonto.;
                                 ENU=View the related customer, vendor, or bank account.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=IsOfficeAddin;
                      Image=ContactReference;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 ShowCustVendBank;
                               END;
                                }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      Image=Task }
      { 96      ;2   ;Action    ;
                      CaptionML=[DAN=Opg&aver;
                                 ENU=T&asks];
                      ToolTipML=[DAN=FÜ vist alle marketingopgaver, der vedrõrer kontaktpersonen.;
                                 ENU=View all marketing tasks that involve the contact person.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5096;
                      RunPageView=SORTING(Contact Company No.,Date,Contact No.,Closed);
                      RunPageLink=Contact Company No.=FIELD(Company No.),
                                  Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                  System To-do Type=FILTER(Contact Attendee);
                      Image=TaskList }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=&Salgsmuligheder;
                                 ENU=Oppo&rtunities];
                      ToolTipML=[DAN=Vis de salgsmuligheder, der hÜndteres af sëlgere for kontakten. Salgsmuligheder skal omfatte en kontakt og kan knyttes til kampagner.;
                                 ENU=View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5123;
                      RunPageView=SORTING(Contact Company No.,Contact No.);
                      RunPageLink=Contact Company No.=FIELD(Company No.),
                                  Contact No.=FILTER(<>''),
                                  Contact No.=FIELD(FILTER(Lookup Contact No.));
                      Image=OpportunityList }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Udskudte &interaktioner;
                                 ENU=Postponed &Interactions];
                      ToolTipML=[DAN=Vis udskudte interaktioner for kontakten.;
                                 ENU=View postponed interactions for the contact.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5082;
                      RunPageView=SORTING(Contact Company No.,Date,Contact No.,Canceled,Initiated By,Attempt Failed);
                      RunPageLink=Contact Company No.=FIELD(Company No.),
                                  Contact No.=FILTER(<>''),
                                  Contact No.=FIELD(FILTER(Lookup Contact No.));
                      Visible=ActionVisible;
                      Image=PostponedInteractions }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 116     ;2   ;Action    ;
                      Name=SalesQuotes;
                      CaptionML=[DAN=S&algstilbud;
                                 ENU=Sales &Quotes];
                      ToolTipML=[DAN=Vis eksisterende salgstilbud for kontakten.;
                                 ENU=View sales quotes that exist for the contact.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9300;
                      RunPageView=SORTING(Document Type,Sell-to Contact No.);
                      RunPageLink=Sell-to Contact No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Quote;
                      PromotedCategory=Process }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 95      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Interaktionslogposter;
                                 ENU=Interaction Log E&ntries];
                      ToolTipML=[DAN=Vis en liste med de interaktioner, som du har gemt, f.eks. hvis du vil oprette en interaktion, udskrive en fõlgeseddel en salgsordre osv.;
                                 ENU=View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5076;
                      RunPageView=SORTING(Contact Company No.,Date,Contact No.,Canceled,Initiated By,Attempt Failed);
                      RunPageLink=Contact Company No.=FIELD(Company No.),
                                  Contact No.=FILTER(<>''),
                                  Contact No.=FIELD(FILTER(Lookup Contact No.));
                      Image=InteractionLog }
      { 88      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger sÜsom vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5053;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 75      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 102     ;2   ;Action    ;
                      CaptionML=[DAN=Start &webkilde;
                                 ENU=Launch &Web Source];
                      ToolTipML=[DAN=Sõg efter oplysninger om kontakten online.;
                                 ENU=Search for information about the contact online.];
                      ApplicationArea=#RelationshipMgmt;
                      Visible=ActionVisible;
                      Image=LaunchWeb;
                      OnAction=VAR
                                 ContactWebSource@1001 : Record 5060;
                               BEGIN
                                 ContactWebSource.SETRANGE("Contact No.","Company No.");
                                 IF PAGE.RUNMODAL(PAGE::"Web Source Launch",ContactWebSource) = ACTION::LookupOK THEN
                                   ContactWebSource.Launch;
                               END;
                                }
      { 103     ;2   ;Action    ;
                      CaptionML=[DAN=&Udskriv fõlgebrev;
                                 ENU=Print Cover &Sheet];
                      ToolTipML=[DAN=Vis fõlgebreve, der skal sendes til din kontakt.;
                                 ENU=View cover sheets to send to your contact.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=PrintCover;
                      OnAction=VAR
                                 Cont@1001 : Record 5050;
                               BEGIN
                                 Cont := Rec;
                                 Cont.SETRECFILTER;
                                 REPORT.RUN(REPORT::"Contact - Cover Sheet",TRUE,FALSE,Cont);
                               END;
                                }
      { 105     ;2   ;ActionGroup;
                      CaptionML=[DAN=Opret som;
                                 ENU=Create as];
                      Image=CustomerContact }
      { 106     ;3   ;Action    ;
                      Name=CreateCustomer;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      ToolTipML=[DAN=Opret et kontakten som debitor.;
                                 ENU=Create the contact as a customer.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Customer;
                      OnAction=BEGIN
                                 CreateCustomer(ChooseCustomerTemplate);
                               END;
                                }
      { 107     ;3   ;Action    ;
                      Name=CreateVendor;
                      CaptionML=[DAN=Kreditor;
                                 ENU=Vendor];
                      ToolTipML=[DAN=Opret kontakten som kreditor.;
                                 ENU=Create the contact as a vendor.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Vendor;
                      OnAction=BEGIN
                                 CreateVendor;
                               END;
                                }
      { 108     ;3   ;Action    ;
                      Name=CreateBank;
                      AccessByPermission=TableData 270=R;
                      CaptionML=[DAN=Bank;
                                 ENU=Bank];
                      ToolTipML=[DAN=Opret kontakten som bank.;
                                 ENU=Create the contact as a bank.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Bank;
                      OnAction=BEGIN
                                 CreateBankAccount;
                               END;
                                }
      { 109     ;2   ;ActionGroup;
                      CaptionML=[DAN=Opret këde til eksist.;
                                 ENU=Link with existing];
                      Visible=ActionVisible;
                      Image=Links }
      { 110     ;3   ;Action    ;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      ToolTipML=[DAN=Këd kontakten sammen med eksisterende debitor.;
                                 ENU=Link the contact to an existing customer.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Customer;
                      OnAction=BEGIN
                                 CreateCustomerLink;
                               END;
                                }
      { 111     ;3   ;Action    ;
                      CaptionML=[DAN=Kreditor;
                                 ENU=Vendor];
                      ToolTipML=[DAN=Këd kontakten sammen med eksisterende kreditor.;
                                 ENU=Link the contact to an existing vendor.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Vendor;
                      OnAction=BEGIN
                                 CreateVendorLink;
                               END;
                                }
      { 112     ;3   ;Action    ;
                      AccessByPermission=TableData 270=R;
                      CaptionML=[DAN=Bank;
                                 ENU=Bank];
                      ToolTipML=[DAN=Këd kontakten sammen med eksisterende bank.;
                                 ENU=Link the contact to an existing bank.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Bank;
                      OnAction=BEGIN
                                 CreateBankAccountLink;
                               END;
                                }
      { 153     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Anvend skabelon;
                                 ENU=Apply Template];
                      ToolTipML=[DAN=Vëlg en defineret skabelon for hurtigt at oprette en ny record.;
                                 ENU=Select a defined template to quickly create a new record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ApplyTemplate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ConfigTemplateMgt@1000 : Codeunit 8612;
                                 RecRef@1001 : RecordRef;
                               BEGIN
                                 RecRef.GETTABLE(Rec);
                                 ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
                               END;
                                }
      { 17      ;2   ;Action    ;
                      Name=CreateAsCustomer;
                      CaptionML=[DAN=Opret som debitor;
                                 ENU=Create as Customer];
                      ToolTipML=[DAN=Opret en ny debitor baseret pÜ denne kontakt.;
                                 ENU=Create a new customer based on this contact.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=IsOfficeAddin;
                      Image=Customer;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CreateCustomer(ChooseCustomerTemplate);
                               END;
                                }
      { 15      ;2   ;Action    ;
                      Name=CreateAsVendor;
                      CaptionML=[DAN=Opret som kreditor;
                                 ENU=Create as Vendor];
                      ToolTipML=[DAN=Opret en ny kreditor baseret pÜ denne kontakt.;
                                 ENU=Create a new vendor based on this contact.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=IsOfficeAddin;
                      Image=Vendor;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CreateVendor;
                               END;
                                }
      { 77      ;1   ;Action    ;
                      AccessByPermission=TableData 5062=R;
                      CaptionML=[DAN=O&pret interaktion;
                                 ENU=Create &Interaction];
                      ToolTipML=[DAN=Opret en interaktion med en bestemt kontakt.;
                                 ENU=Create an interaction with a specified contact.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=CreateInteraction;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CreateInteraction;
                               END;
                                }
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=Opret salgsmulighed;
                                 ENU=Create Opportunity];
                      ToolTipML=[DAN=Registrer en salgsmulighed for kontakten.;
                                 ENU=Register a sales opportunity for the contact.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5124;
                      RunPageLink=Contact No.=FIELD(No.),
                                  Contact Company No.=FIELD(Company No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NewOpportunity;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1907415106;1 ;Action    ;
                      Name=ContactCoverSheet;
                      CaptionML=[DAN=Kontakt - fõlgebrev;
                                 ENU=Contact Cover Sheet];
                      ToolTipML=[DAN=Udskriv eller gem fõlgebreve, der skal sendes til en eller flere af dine kontakter.;
                                 ENU=Print or save cover sheets to send to one or more of your contacts.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cont := Rec;
                                 Cont.SETRECFILTER;
                                 REPORT.RUN(REPORT::"Contact Cover Sheet",TRUE,FALSE,Cont);
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Importance=Additional;
                Visible=NoFieldVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 10  ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver navnet pÜ kontakten. Hvis kontakten er en person, kan du klikke pÜ feltet og fÜ vist vinduet Navneoplysninger.;
                           ENU=Specifies the name of the contact. If the contact is a person, you can click the field to see the Name Details window.];
                ApplicationArea=#All;
                SourceExpr=Name;
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               MODIFY;
                               COMMIT;
                               Cont.SETRANGE("No.","No.");
                               IF Type = Type::Person THEN BEGIN
                                 CLEAR(NameDetails);
                                 NameDetails.SETTABLEVIEW(Cont);
                                 NameDetails.SETRECORD(Cont);
                                 NameDetails.RUNMODAL;
                               END ELSE BEGIN
                                 CLEAR(CompanyDetails);
                                 CompanyDetails.SETTABLEVIEW(Cont);
                                 CompanyDetails.SETRECORD(Cont);
                                 CompanyDetails.RUNMODAL;
                               END;
                               GET("No.");
                               CurrPage.UPDATE;
                             END;

                ShowMandatory=TRUE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontakttypen, dvs. virksomhed eller person.;
                           ENU=Specifies the type of contact, either company or person.];
                ApplicationArea=#All;
                SourceExpr=Type;
                OnValidate=BEGIN
                             TypeOnAfterValidate;
                           END;
                            }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonens virksomhed.;
                           ENU=Specifies the number for the contact's company.];
                ApplicationArea=#All;
                SourceExpr="Company No.";
                Importance=Additional }

    { 8   ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver navnet pÜ virksomheden. Hvis kontakten er en person, angives navnet pÜ den virksomhed, som kontakten arbejder for. Du kan ikke ëndre oplysningerne i feltet.;
                           ENU=Specifies the name of the company. If the contact is a person, Specifies the name of the company for which this contact works. This field is not editable.];
                ApplicationArea=#All;
                SourceExpr="Company Name";
                Importance=Promoted;
                Enabled=CompanyNameEnable;
                OnAssistEdit=BEGIN
                               LookupCompany;
                             END;
                              }

    { 125 ;2   ;Field     ;
                CaptionML=[DAN=Integration af debitornr.;
                           ENU=Integration Customer No.];
                ToolTipML=[DAN=Angiver nummeret pÜ en debitor, som er integreret gennem Dynamics 365 for Sales.;
                           ENU=Specifies the number of a customer that is integrated through Dynamics 365 for Sales.];
                ApplicationArea=#All;
                SourceExpr=IntegrationCustomerNo;
                Visible=FALSE;
                OnValidate=VAR
                             Customer@1000 : Record 18;
                             ContactBusinessRelation@1001 : Record 5054;
                           BEGIN
                             IF NOT (IntegrationCustomerNo = '') THEN BEGIN
                               Customer.GET(IntegrationCustomerNo);
                               ContactBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                               ContactBusinessRelation.SETRANGE("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
                               ContactBusinessRelation.SETRANGE("No.",Customer."No.");
                               IF ContactBusinessRelation.FINDFIRST THEN
                                 VALIDATE("Company No.",ContactBusinessRelation."Contact No.");
                             END ELSE
                               VALIDATE("Company No.",'');
                           END;
                            }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at sõge efter den õnskede record, hvis du ikke kan huske vërdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Search Name";
                Importance=Additional }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den sëlger, der normalt hÜndterer kontakten.;
                           ENU=Specifies the code of the salesperson who normally handles this contact.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Salesperson Code";
                Importance=Additional }

    { 117 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den starthilsenkode, som skal bruges, nÜr du kommunikerer med kontakten. Starthilsenkoden bruges kun i Word-dokumenter. Klik pÜ feltet, hvis du vil se en oversigt over de starthilsenkoder, der er oprettet.;
                           ENU=Specifies the salutation code that will be used when you interact with the contact. The salutation code is only used in Word documents. To see a list of the salutation codes already defined, click the field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Salutation Code";
                Importance=Additional }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver organisationskoden for kontakten, f.eks. topledelse. Feltet er kun relevant for personer.;
                           ENU=Specifies the organizational code for the contact, for example, top management. This field is valid for persons only.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Organizational Level Code";
                Importance=Additional;
                Enabled=OrganizationalLevelCodeEnable }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kontaktkortet sidst blev rettet. Du kan ikke ëndre oplysningerne i feltet.;
                           ENU=Specifies the date when the contact card was last modified. This field is not editable.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Date Modified";
                Importance=Additional }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for den sidste interaktion med kontakten, f.eks. modtagelse eller afsendelse af en mail eller et telefonopkald. Oplysningerne i feltet kan ikke ëndres.;
                           ENU=Specifies the date of the last interaction involving the contact, for example, a received or sent mail, e-mail, or phone call. This field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Date of Last Interaction";
                Importance=Additional;
                OnDrillDown=VAR
                              InteractionLogEntry@1000 : Record 5065;
                            BEGIN
                              InteractionLogEntry.SETCURRENTKEY("Contact Company No.",Date,"Contact No.",Canceled,"Initiated By","Attempt Failed");
                              InteractionLogEntry.SETRANGE("Contact Company No.","Company No.");
                              InteractionLogEntry.SETFILTER("Contact No.","Lookup Contact No.");
                              InteractionLogEntry.SETRANGE("Attempt Failed",FALSE);
                              IF InteractionLogEntry.FINDLAST THEN
                                PAGE.RUN(0,InteractionLogEntry);
                            END;
                             }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kontakten sidst blev kontaktet, f.eks. hvor du prõvede at ringe kontakten op, med eller uden held.ˇOplysningerne i feltet kan ikke ëndres.;
                           ENU=Specifies the date when the contact was last contacted, for example, when you tried to call the contact, with or without success. This field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Last Date Attempted";
                Importance=Additional;
                OnDrillDown=VAR
                              InteractionLogEntry@1000 : Record 5065;
                            BEGIN
                              InteractionLogEntry.SETCURRENTKEY("Contact Company No.",Date,"Contact No.",Canceled,"Initiated By","Attempt Failed");
                              InteractionLogEntry.SETRANGE("Contact Company No.","Company No.");
                              InteractionLogEntry.SETFILTER("Contact No.","Lookup Contact No.");
                              InteractionLogEntry.SETRANGE("Initiated By",InteractionLogEntry."Initiated By"::Us);
                              IF InteractionLogEntry.FINDLAST THEN
                                PAGE.RUN(0,InteractionLogEntry);
                            END;
                             }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for den nëste opgave vedrõrende kontakten.;
                           ENU=Specifies the date of the next task involving the contact.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Next Task Date";
                Importance=Additional }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kontakten skal udelukkes fra mÜlgrupper:;
                           ENU=Specifies if the contact should be excluded from segments:];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Exclude from Segment";
                Importance=Additional }

    { 195 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om adgangen til data skal begrënses for dataemnet i den daglige drift. Dette er eksempelvis nyttigt, nÜr du vil beskytte data mod ëndringer, mens det kontrolleres, om de indeholder personlige oplysninger.;
                           ENU=Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Privacy Blocked";
                Importance=Additional }

    { 196 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at personens alder er lavere end den myndighedsalder, som lovgivningen foreskriver. Data for mindreÜrige blokeres, indtil en forëlder eller vërge giver forëldresamtykke. Du kan ophëve blokeringen af data ved at markere afkrydsningsfeltet Forëldresamtykke modtaget.;
                           ENU=Specifies that the person's age is below the definition of adulthood as recognized by law. Data for minors is blocked until a parent or guardian of the minor provides parental consent. You unblock the data by choosing the Parental Consent Received check box.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Minor;
                Importance=Additional;
                OnValidate=BEGIN
                             SetParentalConsentReceivedEnable;
                           END;
                            }

    { 197 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den mindreÜriges forëldre eller vërge har givet samtykke til, at den mindreÜrige mÜ bruge denne tjeneste. NÜr dette afkrydsningsfelt er markeret, kan data til den mindreÜrige behandles.;
                           ENU=Specifies that a parent or guardian of the minor has provided their consent to allow the minor to use this service. When this check box is selected, data for the minor can be processed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Parental Consent Received";
                Importance=Additional;
                Enabled=ParentalConsentReceivedEnable }

    { 1902768601;1;Group  ;
                CaptionML=[DAN=Kommunikation;
                           ENU=Communication] }

    { 37  ;2   ;Group     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                GroupType=Group }

    { 34  ;3   ;Field     ;
                Name=Address;
                ToolTipML=[DAN=Angiver kontaktens adresse.;
                           ENU=Specifies the contact's address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 16  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2" }

    { 18  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code";
                Importance=Promoted }

    { 14  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver byen, hvor kontakten har adresse.;
                           ENU=Specifies the city where the contact is located.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 12  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omrÜde.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 43  ;3   ;Field     ;
                Name=ShowMap;
                ToolTipML=[DAN=Angiver kontaktens adresse pÜ dit foretrukne kortwebsted.;
                           ENU=Specifies the contact's address on your preferred map website.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShowMapLbl;
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              CurrPage.UPDATE(TRUE);
                              DisplayMap;
                            END;

                ShowCaption=No }

    { 39  ;2   ;Group     ;
                Name=ContactDetails;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                GroupType=Group }

    { 35  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens telefonnummer.;
                           ENU=Specifies the contact's phone number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 36  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens mobiltelefonnummer.;
                           ENU=Specifies the contact's mobile telephone number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Mobile Phone No." }

    { 46  ;3   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver mailadressen for kontakten.;
                           ENU=Specifies the email address of the contact.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail";
                Importance=Promoted }

    { 38  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens faxnummer.;
                           ENU=Specifies the contact's fax number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fax No.";
                Importance=Additional }

    { 48  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens websted.;
                           ENU=Specifies the contact's web site.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Home Page" }

    { 126 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den foretrukne type korrespondance for interaktionen. BEMíRK: Hvis du bruger webklient, mÜ du ikke vëlge indstillingen Papirformat, fordi det ikke er muligt at udskrive fra webklienten.;
                           ENU=Specifies the preferred type of correspondence for the interaction. NOTE: If you use the Web client, you must not select the Hard Copy option because printing is not possible from the web client.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Correspondence Type";
                Importance=Additional }

    { 33  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved oversëttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen pÜ en ordrebekrëftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code";
                Importance=Promoted }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for kontakten.;
                           ENU=Specifies the currency code for the contact.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Promoted;
                Enabled=CurrencyCodeEnable }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens distriktskode.;
                           ENU=Specifies the territory code for the contact.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Territory Code";
                Importance=Additional }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens SE-/CVR-nummer. Feltet er kun relevant for virksomheder.;
                           ENU=Specifies the contact's VAT registration number. This field is valid for companies only.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Registration No.";
                Importance=Additional;
                Enabled=VATRegistrationNoEnable;
                OnDrillDown=VAR
                              VATRegistrationLogMgt@1000 : Codeunit 249;
                            BEGIN
                              VATRegistrationLogMgt.AssistEditContactVATReg(Rec);
                            END;
                             }

    { 72  ;1   ;Part      ;
                CaptionML=[DAN=Profilspõrgeskema;
                           ENU=Profile Questionnaire];
                ApplicationArea=#RelationshipMgmt;
                SubPageLink=Contact No.=FIELD(No.);
                PagePartID=Page5051;
                PartType=Page }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 41  ;1   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page5104;
                Visible=NOT IsOfficeAddin;
                PartType=Page }

    { 31  ;1   ;Part      ;
                ApplicationArea=#RelationshipMgmt;
                SubPageLink=No.=FIELD(No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9130;
                PartType=Page }

    { 1900383207;1;Part   ;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Cont@1000 : Record 5050;
      CRMIntegrationManagement@1011 : Codeunit 5330;
      CompanyDetails@1001 : Page 5054;
      NameDetails@1002 : Page 5055;
      IntegrationCustomerNo@1003 : Code[20];
      CurrencyCodeEnable@19025310 : Boolean INDATASET;
      VATRegistrationNoEnable@19054634 : Boolean INDATASET;
      CompanyNameEnable@19044404 : Boolean INDATASET;
      OrganizationalLevelCodeEnable@19070485 : Boolean INDATASET;
      CompanyGroupEnabled@1004 : Boolean;
      PersonGroupEnabled@1005 : Boolean;
      CRMIntegrationEnabled@1006 : Boolean;
      CRMIsCoupledToRecord@1007 : Boolean;
      IsOfficeAddin@1008 : Boolean;
      ActionVisible@1009 : Boolean;
      ShowMapLbl@1010 : TextConst 'DAN=Vis kort;ENU=Show Map';
      NoFieldVisible@1012 : Boolean;
      ParentalConsentReceivedEnable@1013 : Boolean;

    LOCAL PROCEDURE EnableFields@1();
    BEGIN
      CompanyGroupEnabled := Type = Type::Company;
      PersonGroupEnabled := Type = Type::Person;
      CurrencyCodeEnable := Type = Type::Company;
      VATRegistrationNoEnable := Type = Type::Company;
      CompanyNameEnable := Type = Type::Person;
      OrganizationalLevelCodeEnable := Type = Type::Person;
    END;

    LOCAL PROCEDURE IntegrationFindCustomerNo@2();
    VAR
      ContactBusinessRelation@1000 : Record 5054;
    BEGIN
      ContactBusinessRelation.SETCURRENTKEY("Link to Table","Contact No.");
      ContactBusinessRelation.SETRANGE("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
      ContactBusinessRelation.SETRANGE("Contact No.","Company No.");
      IF ContactBusinessRelation.FINDFIRST THEN BEGIN
        IntegrationCustomerNo := ContactBusinessRelation."No.";
      END ELSE
        IntegrationCustomerNo := '';
    END;

    LOCAL PROCEDURE TypeOnAfterValidate@19069045();
    BEGIN
      EnableFields;
    END;

    LOCAL PROCEDURE SetNoFieldVisible@13();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
    BEGIN
      NoFieldVisible := DocumentNoVisibility.ContactNoIsVisible;
    END;

    LOCAL PROCEDURE SetParentalConsentReceivedEnable@20();
    BEGIN
      IF Minor THEN
        ParentalConsentReceivedEnable := TRUE
      ELSE BEGIN
        "Parental Consent Received" := FALSE;
        ParentalConsentReceivedEnable := FALSE;
      END;
    END;

    BEGIN
    END.
  }
}

