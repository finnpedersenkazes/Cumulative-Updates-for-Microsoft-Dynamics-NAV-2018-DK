OBJECT Page 5116 Salesperson/Purchaser Card
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sëlger-/indkõberkort;
               ENU=Salesperson/Purchaser Card];
    SourceTable=Table13;
    PageType=Card;
    OnOpenPage=BEGIN
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
               END;

    OnInsertRecord=BEGIN
                     IF xRec.Code = '' THEN
                       RESET;
                   END;

    OnAfterGetCurrRecord=VAR
                           CRMCouplingManagement@1001 : Codeunit 5331;
                         BEGIN
                           IF CRMIntegrationEnabled THEN BEGIN
                             CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
                             IF Code <> xRec.Code THEN
                               CRMIntegrationManagement.SendResultNotification(Rec);
                           END;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Sëlger;
                                 ENU=&Salesperson];
                      Image=SalesPerson }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Tea&m;
                                 ENU=Tea&ms];
                      ToolTipML=[DAN=Vis eller rediger grupper, som sëlgeren/indkõberen er medlem af.;
                                 ENU=View or edit any teams that the salesperson/purchaser is a member of.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5107;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=TeamSales }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Kon&takter;
                                 ENU=Con&tacts];
                      ToolTipML=[DAN=FÜ vist en liste over kontakter, der er tilknyttet sëlgeren/indkõberen.;
                                 ENU=View a list of contacts that are associated with the salesperson/purchaser.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5052;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=CustomerContact }
      { 23      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(13),
                                  No.=FIELD(Code);
                      Image=Dimensions }
      { 21      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger sÜsom vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5117;
                      RunPageLink=Code=FIELD(Code);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=K&ampagner;
                                 ENU=C&ampaigns];
                      ToolTipML=[DAN=Vis eller rediger kampagner, som sëlgeren/indkõberen har fÜet tildelt.;
                                 ENU=View or edit any campaigns that the salesperson/purchaser is assigned to.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5087;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=Campaign }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=M&Ülgrupper;
                                 ENU=S&egments];
                      ToolTipML=[DAN=FÜ vist en liste over alle mÜlgrupperne.;
                                 ENU=View a list of all segments.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5093;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=Segment }
      { 33      ;2   ;Separator ;
                      CaptionML=[DAN="";
                                 ENU=""] }
      { 32      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Interaktionslogposter;
                                 ENU=Interaction Log E&ntries];
                      ToolTipML=[DAN=FÜ vist interaktionslogposter for sëlgeren/indkõberen.;
                                 ENU=View interaction log entries for the salesperson/purchaser.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5076;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=InteractionLog }
      { 76      ;2   ;Action    ;
                      CaptionML=[DAN=&Udsatte interaktioner;
                                 ENU=Postponed &Interactions];
                      ToolTipML=[DAN=FÜ vist udskudte interaktioner for sëlgeren/indkõberen.;
                                 ENU=View postponed interactions for the salesperson/purchaser.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5082;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=PostponedInteractions }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Opg&aver;
                                 ENU=T&asks];
                      ToolTipML=[DAN=FÜ vist opgaver for sëlgeren/indkõberen.;
                                 ENU=View tasks for the salesperson/purchaser.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5096;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code),
                                  System To-do Type=FILTER(Organizer|Salesperson Attendee);
                      Image=TaskList }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=&Salgsmuligheder;
                                 ENU=Oppo&rtunities];
                      ToolTipML=[DAN=FÜ vist salgsmuligheder for sëlgeren/indkõberen.;
                                 ENU=View opportunities for the salesperson/purchaser.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5123;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=OpportunitiesList }
      { 13      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 11      ;2   ;Action    ;
                      Name=CRMGotoSystemUser;
                      CaptionML=[DAN=Bruger;
                                 ENU=User];
                      ToolTipML=[DAN=èbn den sammenkëdede Dynamics 365 for Sales-systembruger.;
                                 ENU=Open the coupled Dynamics 365 for Sales system user.];
                      ApplicationArea=#Suite;
                      Image=CoupledUser;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowCRMEntityFromRecordID(RECORDID);
                               END;
                                }
      { 20      ;2   ;Action    ;
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
      { 18      ;2   ;ActionGroup;
                      Name=Coupling;
                      CaptionML=[@@@=Coupling is a noun;
                                 DAN=Sammenkëdning;
                                 ENU=Coupling];
                      ToolTipML=[DAN=Opret, rediger eller slet en sammenkëdning mellem Microsoft Dynamics NAV-recorden og en Dynamics 365 for Sales-record.;
                                 ENU=Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.];
                      Image=LinkAccount }
      { 9       ;3   ;Action    ;
                      Name=ManageCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Konfigurer sammenkëdning;
                                 ENU=Set Up Coupling];
                      ToolTipML=[DAN=Opret eller rediger sammenkëdningen med en Dynamics 365 for Sales-bruger.;
                                 ENU=Create or modify the coupling to a Dynamics 365 for Sales user.];
                      ApplicationArea=#Suite;
                      Image=LinkAccount;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.DefineCoupling(RECORDID);
                               END;
                                }
      { 7       ;3   ;Action    ;
                      Name=DeleteCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Slet sammenkëdning;
                                 ENU=Delete Coupling];
                      ToolTipML=[DAN=Slet sammenkëdningen med en Dynamics 365 for Sales-bruger.;
                                 ENU=Delete the coupling to a Dynamics 365 for Sales user.];
                      ApplicationArea=#Suite;
                      Enabled=CRMIsCoupledToRecord;
                      Image=UnLinkAccount;
                      OnAction=VAR
                                 CRMCouplingManagement@1000 : Codeunit 5331;
                               BEGIN
                                 CRMCouplingManagement.RemoveCoupling(RECORDID);
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=ShowLog;
                      CaptionML=[DAN=Synkroniseringslog;
                                 ENU=Synchronization Log];
                      ToolTipML=[DAN=Vis integrationssynkroniseringsjobs for sëlger/indkõber-tabellen.;
                                 ENU=View integration synchronization jobs for the salesperson/purchaser table.];
                      ApplicationArea=#Suite;
                      Image=Log;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowLog(RECORDID);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 36      ;1   ;Action    ;
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
                ToolTipML=[DAN=Angiver en kode for sëlgeren eller indkõberen.;
                           ENU=Specifies a code for the salesperson or purchaser.];
                ApplicationArea=#All;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ sëlgeren eller indkõberen.;
                           ENU=Specifies the name of the salesperson or purchaser.];
                ApplicationArea=#All;
                SourceExpr=Name }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sëlgerens stilling.;
                           ENU=Specifies the salesperson's job title.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Job Title" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen, der skal bruges til beregning af sëlgerens provision.;
                           ENU=Specifies the percentage to use to calculate the salesperson's commission.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Commission %" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sëlgerens telefonnummer.;
                           ENU=Specifies the salesperson's telephone number.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Phone No." }

    { 8   ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver sëlgerens mailadresse.;
                           ENU=Specifies the salesperson's email address.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="E-Mail" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for den nëste opgave, der er tildelt sëlgeren.;
                           ENU=Specifies the date of the next task assigned to the salesperson.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Next Task Date" }

    { 195 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om adgangen til data skal begrënses for dataemnet i den daglige drift. Dette er eksempelvis nyttigt, nÜr du vil beskytte data mod ëndringer, mens det kontrolleres, om de indeholder personlige oplysninger.;
                           ENU=Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Privacy Blocked";
                Importance=Additional }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik pÜ analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilgëngelige pÜ alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik pÜ analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilgëngelige pÜ alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 3   ;1   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Code=FIELD(Code);
                PagePartID=Page5108;
                PartType=Page }

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
      CRMIntegrationManagement@1002 : Codeunit 5330;
      CRMIntegrationEnabled@1001 : Boolean;
      CRMIsCoupledToRecord@1000 : Boolean;

    BEGIN
    END.
  }
}

