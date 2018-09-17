OBJECT Page 5052 Contact List
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Kontaktoversigt;
               ENU=Contact List];
    SourceTable=Table5050;
    SourceTableView=SORTING(Company Name,Company No.,Type,Name);
    DataCaptionFields=Company No.;
    PageType=List;
    CardPageID=Contact Card;
    OnInit=BEGIN
             ActionVisible := ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Windows;
           END;

    OnOpenPage=VAR
                 CRMIntegrationManagement@1000 : Codeunit 5330;
               BEGIN
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
               END;

    OnAfterGetRecord=VAR
                       CRMCouplingManagement@1001 : Codeunit 5331;
                     BEGIN
                       EnableFields;
                       StyleIsStrong := Type = Type::Company;

                       IF CRMIntegrationEnabled THEN
                         CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&ontakt;
                                 ENU=C&ontact];
                      Image=ContactPerson }
      { 34      ;2   ;ActionGroup;
                      CaptionML=[DAN=Virksom&hed;
                                 ENU=Comp&any];
                      Enabled=CompanyGroupEnabled;
                      Image=Company }
      { 35      ;3   ;Action    ;
                      CaptionML=[DAN=Forretningsrelationer;
                                 ENU=Business Relations];
                      ToolTipML=[DAN=Vis eller rediger kontaktens forretningsrelationer, eksempelvis debitorer, kreditorer, banker, advokater, konsulenter, konkurrenter og s� videre.;
                                 ENU=View or edit the contact's business relations, such as customers, vendors, banks, lawyers, consultants, competitors, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5061;
                      RunPageLink=Contact No.=FIELD(Company No.);
                      Image=BusinessRelation }
      { 36      ;3   ;Action    ;
                      CaptionML=[DAN=Brancher;
                                 ENU=Industry Groups];
                      ToolTipML=[DAN=Vis eller rediger de brancher, f.eks. Detail eller Automobil, som kontakten tilh�rer.;
                                 ENU=View or edit the industry groups, such as Retail or Automobile, that the contact belongs to.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5067;
                      RunPageLink=Contact No.=FIELD(Company No.);
                      Image=IndustryGroups }
      { 37      ;3   ;Action    ;
                      CaptionML=[DAN=Webkilder;
                                 ENU=Web Sources];
                      ToolTipML=[DAN=Vis en liste med webstederne med oplysninger om kontakterne.;
                                 ENU=View a list of the web sites with information about the contacts.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5070;
                      RunPageLink=Contact No.=FIELD(Company No.);
                      Image=Web }
      { 38      ;2   ;ActionGroup;
                      CaptionML=[DAN=Kontak&t;
                                 ENU=P&erson];
                      Enabled=PersonGroupEnabled;
                      Image=User }
      { 39      ;3   ;Action    ;
                      CaptionML=[DAN=Ansvarsomr�der;
                                 ENU=Job Responsibilities];
                      ToolTipML=[DAN=Vis eller rediger kontaktens ansvarsomr�der.;
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
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=Pro&filer;
                                 ENU=Pro&files];
                      ToolTipML=[DAN=�bn vinduet Profilsp�rgeskema.;
                                 ENU=Open the Profile Questionnaires window.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Answers;
                      OnAction=VAR
                                 ProfileManagement@1001 : Codeunit 5059;
                               BEGIN
                                 ProfileManagement.ShowContactQuestionnaireCard(Rec,'',0);
                               END;
                                }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=&Billede;
                                 ENU=&Picture];
                      ToolTipML=[DAN=Vis eller tilf�j et billede af kontaktpersonen eller f.eks. virksomhedens logo.;
                                 ENU=View or add a picture of the contact person or, for example, the company's logo.];
                      ApplicationArea=#Suite,#RelationshipMgmt;
                      RunObject=Page 5104;
                      RunPageLink=No.=FIELD(No.);
                      Visible=ActionVisible;
                      Image=Picture }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5072;
                      RunPageLink=Table Name=CONST(Contact),
                                  No.=FIELD(No.),
                                  Sub No.=CONST(0);
                      Image=ViewComments }
      { 45      ;2   ;ActionGroup;
                      CaptionML=[DAN=Alternati&v adresse;
                                 ENU=Alternati&ve Address];
                      Image=Addresses }
      { 46      ;3   ;Action    ;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om kontakten.;
                                 ENU=View or change detailed information about the contact.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5057;
                      RunPageLink=Contact No.=FIELD(No.);
                      Image=EditLines }
      { 47      ;3   ;Action    ;
                      CaptionML=[DAN=Datointervaller;
                                 ENU=Date Ranges];
                      ToolTipML=[DAN=Angiver datointervallet, der g�lder for kontaktens alternative adresse.;
                                 ENU=Specify date ranges that apply to the contact's alternate address.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5059;
                      RunPageLink=Contact No.=FIELD(No.);
                      Image=DateRange }
      { 25      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 23      ;2   ;Action    ;
                      Name=CRMGotoContact;
                      CaptionML=[DAN=Kontakt;
                                 ENU=Contact];
                      ToolTipML=[DAN=�bn den sammenk�dede Dynamics 365 for Sales-kontakt.;
                                 ENU=Open the coupled Dynamics 365 for Sales contact.];
                      ApplicationArea=#Suite;
                      Enabled=(Type <> Type::Company) AND ("Company No." <> '');
                      Image=CoupledContactPerson;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowCRMEntityFromRecordID(RECORDID);
                               END;
                                }
      { 27      ;2   ;Action    ;
                      Name=CRMSynchronizeNow;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Synkroniser;
                                 ENU=Synchronize];
                      ToolTipML=[DAN=Send eller hent opdaterede data til eller fra Dynamics 365 for Sales.;
                                 ENU=Send or get updated data to or from Dynamics 365 for Sales.];
                      ApplicationArea=#Suite;
                      Enabled=(Type <> Type::Company) AND ("Company No." <> '');
                      Image=Refresh;
                      OnAction=VAR
                                 Contact@1000 : Record 5050;
                                 CRMIntegrationManagement@1001 : Codeunit 5330;
                                 ContactRecordRef@1002 : RecordRef;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Contact);
                                 Contact.NEXT;

                                 IF Contact.COUNT = 1 THEN
                                   CRMIntegrationManagement.UpdateOneNow(Contact.RECORDID)
                                 ELSE BEGIN
                                   ContactRecordRef.GETTABLE(Contact);
                                   CRMIntegrationManagement.UpdateMultipleNow(ContactRecordRef);
                                 END
                               END;
                                }
      { 26      ;2   ;ActionGroup;
                      Name=Coupling;
                      CaptionML=[@@@=Coupling is a noun;
                                 DAN=Sammenk�dning;
                                 ENU=Coupling];
                      ToolTipML=[DAN=Opret, rediger eller slet en sammenk�dning mellem Microsoft Dynamics NAV-recorden og en Dynamics 365 for Sales-record.;
                                 ENU=Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.];
                      Enabled=(Type <> Type::Company) AND ("Company No." <> '');
                      Image=LinkAccount }
      { 21      ;3   ;Action    ;
                      Name=ManageCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Konfigurer sammenk�dning;
                                 ENU=Set Up Coupling];
                      ToolTipML=[DAN=Opret eller rediger sammenk�dningen med en Dynamics 365 for Sales-kontakt.;
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
                      CaptionML=[DAN=Slet sammenk�dning;
                                 ENU=Delete Coupling];
                      ToolTipML=[DAN=Slet sammenk�dningen med en Dynamics 365 for Sales-kontakt.;
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
      { 17      ;2   ;ActionGroup;
                      Name=Create;
                      CaptionML=[DAN=Opret;
                                 ENU=Create];
                      Image=NewCustomer }
      { 15      ;3   ;Action    ;
                      Name=CreateInCRM;
                      CaptionML=[DAN=Opret kontakt i Dynamics 365 for Sales;
                                 ENU=Create Contact in Dynamics 365 for Sales];
                      ToolTipML=[DAN=Opret en kontakt i Dynamics 365 for Sales, som er sammenk�det med en kontakt i din virksomhed.;
                                 ENU=Create a contact in Dynamics 365 for Sales that is linked to a contact in your company.];
                      ApplicationArea=#Suite;
                      Enabled=(Type <> Type::Company) AND ("Company No." <> '');
                      Image=NewCustomer;
                      OnAction=VAR
                                 Contact@1001 : Record 5050;
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Contact);
                                 CRMIntegrationManagement.CreateNewRecordsInCRM(Contact);
                               END;
                                }
      { 13      ;3   ;Action    ;
                      Name=CreateFromCRM;
                      CaptionML=[DAN=Opret kontakt i Dynamics NAV;
                                 ENU=Create Contact in Dynamics NAV];
                      ToolTipML=[DAN=Opret en kontakt her i din virksomhed, som er sammenk�det med en kontakt i Dynamics 365 for Sales.;
                                 ENU=Create a contact here in your company that is linked to the Dynamics 365 for Sales contact.];
                      ApplicationArea=#Suite;
                      Image=NewCustomer;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.CreateNewContactFromCRM;
                               END;
                                }
      { 52      ;2   ;Action    ;
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
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Tilknytte&de kontakter;
                                 ENU=Relate&d Contacts];
                      ToolTipML=[DAN=Se en liste med alle kontakter.;
                                 ENU=View a list of all contacts.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5052;
                      RunPageLink=Company No.=FIELD(Company No.);
                      Image=Users }
      { 55      ;2   ;Action    ;
                      CaptionML=[DAN=M�lgr&upper;
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
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Mailg&rupper;
                                 ENU=Mailing &Groups];
                      ToolTipML=[DAN=Vis eller rediger mailgrupper, som kontakten er tildelt, eksempelvis til at sende prislister eller julekort.;
                                 ENU=View or edit the mailing groups that the contact is assigned to, for example, for sending price lists or Christmas cards.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5064;
                      RunPageLink=Contact No.=FIELD(No.);
                      Image=DistributionGroup }
      { 53      ;2   ;Action    ;
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
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      Image=Task }
      { 50      ;2   ;Action    ;
                      CaptionML=[DAN=Opg&aver;
                                 ENU=T&asks];
                      ToolTipML=[DAN=F� vist alle marketingopgaver, der vedr�rer kontaktpersonen.;
                                 ENU=View all marketing tasks that involve the contact person.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5096;
                      RunPageView=SORTING(Contact Company No.,Contact No.);
                      RunPageLink=Contact Company No.=FIELD(Company No.),
                                  Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                  System To-do Type=FILTER(Contact Attendee);
                      Image=TaskList }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=�bne &salgsmuligheder;
                                 ENU=Open Oppo&rtunities];
                      ToolTipML=[DAN=Vis de �bne salgsmuligheder, der h�ndteres af s�lgere for kontakten. Salgsmuligheder skal omfatte en kontakt og kan knyttes til kampagner.;
                                 ENU=View the open sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5123;
                      RunPageView=SORTING(Contact Company No.,Contact No.);
                      RunPageLink=Contact Company No.=FIELD(Company No.),
                                  Contact No.=FILTER(<>''),
                                  Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                  Status=FILTER(Not Started|In Progress);
                      Promoted=Yes;
                      Image=OpportunityList;
                      PromotedCategory=Process;
                      Scope=Repeater }
      { 76      ;2   ;Action    ;
                      CaptionML=[DAN=Udsatte i&nteraktioner;
                                 ENU=Postponed &Interactions];
                      ToolTipML=[DAN=F� vist periodiserede transaktioner for kontakten.;
                                 ENU=View postponed interactions for the contact.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5082;
                      RunPageView=SORTING(Contact Company No.,Contact No.);
                      RunPageLink=Contact Company No.=FIELD(Company No.),
                                  Contact No.=FILTER(<>''),
                                  Contact No.=FIELD(FILTER(Lookup Contact No.));
                      Image=PostponedInteractions }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 68      ;2   ;Action    ;
                      Name=ShowSalesQuotes;
                      CaptionML=[DAN=S&algstilbud;
                                 ENU=Sales &Quotes];
                      ToolTipML=[DAN=Vis eksisterende salgstilbud for kontakten.;
                                 ENU=View sales quotes that exist for the contact.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9300;
                      RunPageView=SORTING(Document Type,Sell-to Contact No.);
                      RunPageLink=Sell-to Contact No.=FIELD(No.);
                      Image=Quote }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 67      ;2   ;Action    ;
                      CaptionML=[DAN=Lukkede &salgsmuligheder;
                                 ENU=Closed Oppo&rtunities];
                      ToolTipML=[DAN=Vis de lukkede salgsmuligheder, der h�ndteres af s�lgere for kontakten. Salgsmuligheder skal omfatte en kontakt og kan knyttes til kampagner.;
                                 ENU=View the closed sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5123;
                      RunPageView=SORTING(Contact Company No.,Contact No.);
                      RunPageLink=Contact Company No.=FIELD(Company No.),
                                  Contact No.=FILTER(<>''),
                                  Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                  Status=FILTER(Won|Lost);
                      Image=OpportunityList }
      { 49      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Interaktionslogposter;
                                 ENU=Interaction Log E&ntries];
                      ToolTipML=[DAN=Vis en liste med de interaktioner, som du har gemt, f.eks. hvis du vil oprette en interaktion, udskrive en f�lgeseddel en salgsordre osv.;
                                 ENU=View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5076;
                      RunPageView=SORTING(Contact Company No.,Contact No.);
                      RunPageLink=Contact Company No.=FIELD(Company No.),
                                  Contact No.=FILTER(<>''),
                                  Contact No.=FIELD(FILTER(Lookup Contact No.));
                      Image=InteractionLog }
      { 42      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger s�som v�rdien for bogf�rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5053;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 30      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 54      ;2   ;Action    ;
                      Name=MakePhoneCall;
                      CaptionML=[DAN=Foretag &tlf.opkald;
                                 ENU=Make &Phone Call];
                      ToolTipML=[DAN=Ring til den valgte kontakt.;
                                 ENU=Call the selected contact.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=Calls;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=VAR
                                 TAPIManagement@1001 : Codeunit 5053;
                               BEGIN
                                 TAPIManagement.DialContCustVendBank(DATABASE::Contact,"No.",GetDefaultPhoneNo,'');
                               END;
                                }
      { 56      ;2   ;Action    ;
                      CaptionML=[DAN=Start &webkilde;
                                 ENU=Launch &Web Source];
                      ToolTipML=[DAN=S�g efter oplysninger om kontakten online.;
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
      { 58      ;2   ;ActionGroup;
                      CaptionML=[DAN=Opret som;
                                 ENU=Create as];
                      Visible=ActionVisible;
                      Image=CustomerContact }
      { 59      ;3   ;Action    ;
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
      { 60      ;3   ;Action    ;
                      Name=Vendor;
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
      { 61      ;3   ;Action    ;
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
      { 62      ;2   ;ActionGroup;
                      CaptionML=[DAN=Opret k�de til eksist.;
                                 ENU=Link with existing];
                      Image=Links }
      { 63      ;3   ;Action    ;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      ToolTipML=[DAN=K�d kontakten sammen med eksisterende debitor.;
                                 ENU=Link the contact to an existing customer.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Customer;
                      OnAction=BEGIN
                                 CreateCustomerLink;
                               END;
                                }
      { 64      ;3   ;Action    ;
                      CaptionML=[DAN=Kreditor;
                                 ENU=Vendor];
                      ToolTipML=[DAN=K�d kontakten sammen med eksisterende kreditor.;
                                 ENU=Link the contact to an existing vendor.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Vendor;
                      OnAction=BEGIN
                                 CreateVendorLink;
                               END;
                                }
      { 65      ;3   ;Action    ;
                      AccessByPermission=TableData 270=R;
                      CaptionML=[DAN=Bank;
                                 ENU=Bank];
                      ToolTipML=[DAN=K�d kontakten sammen med eksisterende bank.;
                                 ENU=Link the contact to an existing bank.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Bank;
                      OnAction=BEGIN
                                 CreateBankAccountLink;
                               END;
                                }
      { 31      ;1   ;Action    ;
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
      { 51      ;1   ;Action    ;
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
      { 28      ;1   ;Action    ;
                      Name=SyncWithExchange;
                      CaptionML=[DAN=Synkroniser med Office 365;
                                 ENU=Sync with Office 365];
                      ToolTipML=[DAN=Synkroniser med Office 365 siden sidste synkroniseringsdato og sidste �ndringsdato. Alle �ndringer i Office 365 siden sidste synkroniseringsdato synkroniseres tilbage.;
                                 ENU=Synchronize with Office 365 based on last sync date and last modified date. All changes in Office 365 since the last sync date will be synchronized back.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Refresh;
                      OnAction=BEGIN
                                 SyncExchangeContacts(FALSE);
                               END;
                                }
      { 32      ;1   ;Action    ;
                      Name=FullSyncWithExchange;
                      CaptionML=[DAN=Komplet synkronisering med Office 365;
                                 ENU=Full Sync with Office 365];
                      ToolTipML=[DAN=Synkroniser, men ignorer datoerne for seneste synkronisering og seneste �ndring. Alle �ndringer videresendes til Office 365 og tager alle kontakter fra din Exchange-mappe og synkroniserer dem tilbage.;
                                 ENU=Synchronize, but ignore the last synchronized and last modified dates. All changes will be pushed to Office 365 and take all contacts from your Exchange folder and sync back.];
                      ApplicationArea=#Basic,#Suite;
                      Image=RefreshLines;
                      OnAction=BEGIN
                                 SyncExchangeContacts(TRUE);
                               END;
                                }
      { 1900000005;0 ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 1900900305;1 ;Action    ;
                      Name=NewSalesQuote;
                      CaptionML=[DAN=Nyt salgstilbud;
                                 ENU=New Sales Quote];
                      ToolTipML=[DAN=Tilbyd varer eller servicer til en debitor.;
                                 ENU=Offer items or services to a customer.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=NewSalesQuote;
                      PromotedCategory=New;
                      OnAction=BEGIN
                                 CreateSalesQuoteFromContact;
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1904205506;1 ;Action    ;
                      CaptionML=[DAN=Kontakt - etiketter;
                                 ENU=Contact Labels];
                      ToolTipML=[DAN=Vis adresseetiketter med navne og adresser p� dine kontakter. Du kan f.eks. bruge rapporten, n�r du skal gennemse kontaktoplysninger, f�r du sender salgs- og marketingbreve.;
                                 ENU=View mailing labels with names and addresses of your contacts. For example, you can use the report to review contact information before you send sales and marketing campaign letters.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Report 5056;
                      Image=Report }
      { 1905922906;1 ;Action    ;
                      CaptionML=[DAN=Sp�rgeskema - kopi;
                                 ENU=Questionnaire Handout];
                      ToolTipML=[DAN=Vis dit profilsp�rgeskema for kontakten. Du kan udskrive denne rapport for at f� en kopi af sp�rgsm�lene i profilsp�rgeskemaet.;
                                 ENU=View your profile questionnaire for the contact. You can print this report to have a printed copy of the questions that are within the profile questionnaire.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Report 5066;
                      Image=Report }
      { 1900800206;1 ;Action    ;
                      CaptionML=[DAN=Salgsprocesanalyse;
                                 ENU=Sales Cycle Analysis];
                      ToolTipML=[DAN=Vis oplysninger om dine salgsprocesser. Rapporten indeholder detaljer om salgsprocessen, bl.a. det aktuelle antal salgsmuligheder p� dette tidspunkt og den ansl�ede og beregnede v�rdi af salgsmuligheder, der er oprettet vha. salgsprocessen.;
                                 ENU=View information about your sales cycles. The report includes details about the sales cycle, such as the number of opportunities currently at that stage, the estimated and calculated current values of opportunities created using the sales cycle, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Report 5062;
                      Image=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� kontakten. Hvis kontakten er en person, kan du klikke p� feltet og f� vist vinduet Navneoplysninger.;
                           ENU=Specifies the name of the contact. If the contact is a person, you can click the field to see the Name Details window.];
                ApplicationArea=#All;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� virksomheden. Hvis kontakten er en person, angives navnet p� den virksomhed, som kontakten arbejder for. Du kan ikke �ndre oplysningerne i feltet.;
                           ENU=Specifies the name of the company. If the contact is a person, Specifies the name of the company for which this contact works. This field is not editable.];
                ApplicationArea=#All;
                SourceExpr="Company Name";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr�de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens telefonnummer.;
                           ENU=Specifies the contact's phone number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens mobiltelefonnummer.;
                           ENU=Specifies the contact's mobile telephone number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Mobile Phone No.";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver kontaktens mail.;
                           ENU=Specifies the contact's email.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens faxnummer.;
                           ENU=Specifies the contact's fax number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fax No.";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s�lger, der normalt h�ndterer kontakten.;
                           ENU=Specifies the code of the salesperson who normally handles this contact.];
                ApplicationArea=#Suite;
                SourceExpr="Salesperson Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens distriktskode.;
                           ENU=Specifies the territory code for the contact.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Territory Code" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for kontakten.;
                           ENU=Specifies the currency code for the contact.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs�ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p� en ordrebekr�ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at s�ge efter den �nskede record, hvis du ikke kan huske v�rdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Search Name";
                Visible=FALSE }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om adgangen til data skal begr�nses for dataemnet i den daglige drift. Dette er eksempelvis nyttigt, n�r du vil beskytte data mod �ndringer, mens det kontrolleres, om de indeholder personlige oplysninger.;
                           ENU=Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Privacy Blocked";
                Importance=Additional;
                Visible=FALSE }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at personens alder er lavere end den myndighedsalder, som lovgivningen foreskriver. Data for mindre�rige blokeres, indtil en for�lder eller v�rge giver for�ldresamtykke. Du kan oph�ve blokeringen af data ved at markere afkrydsningsfeltet For�ldresamtykke modtaget.;
                           ENU=Specifies that the person's age is below the definition of adulthood as recognized by law. Data for minors is blocked until a parent or guardian of the minor provides parental consent. You unblock the data by selecting the Parental Consent Received check box.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Minor;
                Importance=Additional;
                Visible=FALSE }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den mindre�riges for�ldre eller v�rge har givet samtykke til, at den mindre�rige m� bruge denne tjeneste. N�r dette afkrydsningsfelt er markeret, kan data til den mindre�rige behandles.;
                           ENU=Specifies that a parent or guardian of the minor has provided their consent to allow the minor to use this service. When this check box is selected, data for the minor can be processed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Parental Consent Received";
                Importance=Additional;
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 128 ;1   ;Part      ;
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
      ClientTypeManagement@1000 : Codeunit 4;
      StyleIsStrong@1001 : Boolean INDATASET;
      CompanyGroupEnabled@1004 : Boolean;
      PersonGroupEnabled@1003 : Boolean;
      CRMIntegrationEnabled@1006 : Boolean;
      CRMIsCoupledToRecord@1005 : Boolean;
      ActionVisible@1007 : Boolean;

    LOCAL PROCEDURE EnableFields@1();
    BEGIN
      CompanyGroupEnabled := Type = Type::Company;
      PersonGroupEnabled := Type = Type::Person;
    END;

    [Internal]
    PROCEDURE SyncExchangeContacts@2(FullSync@1001 : Boolean);
    VAR
      ExchangeSync@1002 : Record 6700;
      O365SyncManagement@1000 : Codeunit 6700;
      ExchangeContactSync@1003 : Codeunit 6703;
    BEGIN
      IF O365SyncManagement.IsO365Setup(TRUE) THEN
        IF ExchangeSync.GET(USERID) THEN BEGIN
          ExchangeContactSync.GetRequestParameters(ExchangeSync);
          O365SyncManagement.SyncExchangeContacts(ExchangeSync,FullSync);
        END;
    END;

    BEGIN
    END.
  }
}

