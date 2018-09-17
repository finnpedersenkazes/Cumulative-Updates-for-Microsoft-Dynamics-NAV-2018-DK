OBJECT Page 5124 Opportunity Card
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Salgsmulighedkort;
               ENU=Opportunity Card];
    SourceTable=Table5092;
    PageType=Card;
    RefreshOnActivate=Yes;
    OnInit=BEGIN
             ContactNoEditable := TRUE;
             PriorityEditable := TRUE;
             CampaignNoEditable := TRUE;
             SalespersonCodeEditable := TRUE;
             SalesDocumentTypeEditable := TRUE;
             SalesDocumentNoEditable := TRUE;
             SalesCycleCodeEditable := TRUE;
             Started := TRUE;
           END;

    OnOpenPage=VAR
                 CRMIntegrationManagement@1000 : Codeunit 5330;
               BEGIN
                 OppNo := "No.";
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
               END;

    OnAfterGetRecord=VAR
                       CRMCouplingManagement@1000 : Codeunit 5331;
                     BEGIN
                       IF CRMIntegrationEnabled THEN
                         CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
                     END;

    OnNewRecord=BEGIN
                  "Creation Date" := WORKDATE;
                  IF "Segment No." = '' THEN
                    SetSegmentFromFilter;
                  IF "Contact No." = '' THEN
                    SetContactFromFilter;
                  IF "Campaign No." = '' THEN
                    SetCampaignFromFilter;
                  SetDefaultSalesCycle;
                END;

    OnQueryClosePage=BEGIN
                       IF GET("No.") THEN
                         IF ("No." <> OppNo) AND (Status = Status::"Not Started") THEN
                           StartActivateFirstStage;
                     END;

    OnAfterGetCurrRecord=VAR
                           Contact@1000 : Record 5050;
                         BEGIN
                           IF "Contact No." <> '' THEN
                             IF Contact.GET("Contact No.") THEN
                               Contact.CheckIfPrivacyBlockedGeneric;
                           IF "Contact Company No." <> '' THEN
                             IF Contact.GET("Contact Company No.") THEN
                               Contact.CheckIfPrivacyBlockedGeneric;
                           UpdateEditable;
                           OppInProgress := Status = Status::"In Progress";
                           OppNo := "No.";
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 27      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Salgsmulighed;
                                 ENU=Oppo&rtunity];
                      Image=Opportunity }
      { 29      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger s�som v�rdien for bogf�rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5127;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 49      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Interaktionslogposter;
                                 ENU=Interaction Log E&ntries];
                      ToolTipML=[DAN=Vis en liste med de interaktioner, som du har gemt, f.eks. hvis du vil oprette en interaktion, udskrive en f�lgeseddel en salgsordre osv.;
                                 ENU=View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5076;
                      RunPageView=SORTING(Opportunity No.,Date);
                      RunPageLink=Opportunity No.=FIELD(No.);
                      Image=InteractionLog }
      { 50      ;2   ;Action    ;
                      CaptionML=[DAN=&Udsatte interaktioner;
                                 ENU=Postponed &Interactions];
                      ToolTipML=[DAN=F� vist udskudte transaktioner for salgsmuligheder.;
                                 ENU=View postponed interactions for opportunities.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5082;
                      RunPageView=SORTING(Opportunity No.,Date);
                      RunPageLink=Opportunity No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostponedInteractions;
                      PromotedCategory=Process }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Opg&aver;
                                 ENU=T&asks];
                      ToolTipML=[DAN=F� vist alle marketingopgaver, der vedr�rer salgsmuligheden.;
                                 ENU=View all marketing tasks that involve the opportunity.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5096;
                      RunPageView=SORTING(Opportunity No.);
                      RunPageLink=Opportunity No.=FIELD(No.),
                                  System To-do Type=FILTER(Organizer);
                      Image=TaskList }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5072;
                      RunPageLink=Table Name=CONST(Opportunity),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 5       ;2   ;Action    ;
                      CaptionML=[DAN=Vis salgstilbud;
                                 ENU=Show Sales Quote];
                      ToolTipML=[DAN=Vis det tildelte salgstilbud.;
                                 ENU=Show the assigned sales quote.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Quote;
                      OnAction=VAR
                                 SalesHeader@1001 : Record 36;
                               BEGIN
                                 IF ("Sales Document Type" <> "Sales Document Type"::Quote) OR
                                    ("Sales Document No." = '')
                                 THEN
                                   ERROR(Text001);

                                 IF SalesHeader.GET(SalesHeader."Document Type"::Quote,"Sales Document No.") THEN
                                   PAGE.RUN(PAGE::"Sales Quote",SalesHeader)
                                 ELSE
                                   ERROR(Text002,"Sales Document No.");
                               END;
                                }
      { 24      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 23      ;2   ;Action    ;
                      Name=CRMGotoOpportunity;
                      CaptionML=[DAN=Salgsmulighed;
                                 ENU=Opportunity];
                      ToolTipML=[DAN=�bn den sammenk�dede Dynamics 365 for Sales-salgsmulighed.;
                                 ENU=Open the coupled Dynamics 365 for Sales opportunity.];
                      ApplicationArea=#Suite;
                      Image=CoupledContactPerson;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowCRMEntityFromRecordID(RECORDID);
                               END;
                                }
      { 21      ;2   ;Action    ;
                      Name=CRMSynchronizeNow;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Synkroniser;
                                 ENU=Synchronize];
                      ToolTipML=[DAN=Send eller hent opdaterede data til eller fra Dynamics 365 for Sales.;
                                 ENU=Send or get updated data to or from Dynamics 365 for Sales.];
                      ApplicationArea=#Suite;
                      Image=Refresh;
                      OnAction=VAR
                                 Opportunity@1000 : Record 5092;
                                 CRMIntegrationManagement@1001 : Codeunit 5330;
                                 OpportunityRecordRef@1002 : RecordRef;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Opportunity);
                                 Opportunity.NEXT;

                                 IF Opportunity.COUNT = 1 THEN
                                   CRMIntegrationManagement.UpdateOneNow(Opportunity.RECORDID)
                                 ELSE BEGIN
                                   OpportunityRecordRef.GETTABLE(Opportunity);
                                   CRMIntegrationManagement.UpdateMultipleNow(OpportunityRecordRef);
                                 END
                               END;
                                }
      { 19      ;2   ;ActionGroup;
                      Name=Coupling;
                      CaptionML=[@@@=Coupling is a noun;
                                 DAN=Sammenk�dning;
                                 ENU=Coupling];
                      ToolTipML=[DAN=Opret, rediger eller slet en sammenk�dning mellem Microsoft Dynamics NAV-recorden og en Dynamics 365 for Sales-record.;
                                 ENU=Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.];
                      Image=LinkAccount }
      { 17      ;3   ;Action    ;
                      Name=ManageCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Konfigurer sammenk�dning;
                                 ENU=Set Up Coupling];
                      ToolTipML=[DAN=Opret eller rediger sammenk�dningen med en Dynamics 365 for Sales-salgsmulighed.;
                                 ENU=Create or modify the coupling to a Dynamics 365 for Sales opportunity.];
                      ApplicationArea=#Suite;
                      Image=LinkAccount;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.DefineCoupling(RECORDID);
                               END;
                                }
      { 15      ;3   ;Action    ;
                      Name=DeleteCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Slet sammenk�dning;
                                 ENU=Delete Coupling];
                      ToolTipML=[DAN=Slet sammenk�dningen med en Dynamics 365 for Sales-salgsmulighed.;
                                 ENU=Delete the coupling to a Dynamics 365 for Sales opportunity.];
                      ApplicationArea=#Suite;
                      Enabled=CRMIsCoupledToRecord;
                      Image=UnLinkAccount;
                      OnAction=VAR
                                 CRMCouplingManagement@1000 : Codeunit 5331;
                               BEGIN
                                 CRMCouplingManagement.RemoveCoupling(RECORDID);
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=ShowLog;
                      CaptionML=[DAN=Synkroniseringslog;
                                 ENU=Synchronization Log];
                      ToolTipML=[DAN=Vis integrationssynkroniseringsjobs for salgsmulighedstabellen.;
                                 ENU=View integration synchronization jobs for the opportunity table.];
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
      { 26      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 9       ;2   ;Action    ;
                      Name=Activate the First Stage;
                      CaptionML=[DAN=Aktiv�r f�rste fase;
                                 ENU=Activate First Stage];
                      ToolTipML=[DAN=Angiv, om salgsmuligheden skal aktiveres. Statussen er indstillet til Igangv�rende.;
                                 ENU=Specify if the opportunity is to be activated. The status is set to In Progress.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Visible=NOT Started;
                      Image=Action;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 StartActivateFirstStage;
                               END;
                                }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Opdater;
                                 ENU=Update];
                      ToolTipML=[DAN=Opdater alle handlinger i forbindelse med din salgsmulighed.;
                                 ENU=Update all the actions that are related to your opportunity.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Visible=Started;
                      Image=Refresh;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 UpdateOpportunity;
                               END;
                                }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Luk;
                                 ENU=Close];
                      ToolTipML=[DAN=Luk alle handlinger i forbindelse med din salgsmulighed.;
                                 ENU=Close all the actions that are related to your opportunity.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Visible=Started;
                      Image=Close;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CloseOpportunity;
                               END;
                                }
      { 33      ;2   ;Action    ;
                      Name=AssignSalesQuote;
                      CaptionML=[DAN=Tildel salgs&tilbud;
                                 ENU=Assign Sales &Quote];
                      ToolTipML=[DAN=Tildel et salgstilbud til en salgsmulighed.;
                                 ENU=Assign a sales quote to an opportunity.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Enabled=OppInProgress;
                      PromotedIsBig=Yes;
                      Image=Allocate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 AssignQuote;
                               END;
                                }
      { 48      ;2   ;Action    ;
                      CaptionML=[DAN=Udskriv detaljer;
                                 ENU=Print Details];
                      ToolTipML=[DAN=Vis oplysninger om salgsfaser, aktiviteter og planlagte opgaver for en salgsmulighed.;
                                 ENU=View information about your sales stages, activities and planned tasks for an opportunity.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Print;
                      OnAction=VAR
                                 Opp@1000 : Record 5092;
                               BEGIN
                                 Opp := Rec;
                                 Opp.SETRECFILTER;
                                 REPORT.RUN(REPORT::"Opportunity - Details",TRUE,FALSE,Opp);
                               END;
                                }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=O&pret interaktion;
                                 ENU=Create &Interaction];
                      ToolTipML=[DAN=Opret en interaktion med en bestemt salgsmulighed.;
                                 ENU=Create an interaction with a specified opportunity.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=CreateInteraction;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 TempSegmentLine@1000 : TEMPORARY Record 5077;
                               BEGIN
                                 TempSegmentLine.CreateInteractionFromOpp(Rec);
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
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Importance=Additional }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af den �bne salgsmulighed.;
                           ENU=Specifies the description of the opportunity.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den kontakt, som denne salgsmulighed er knyttet til.;
                           ENU=Specifies the number of the contact that this opportunity is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact No.";
                Editable=ContactNoEditable;
                OnValidate=VAR
                             Contact@1000 : Record 5050;
                           BEGIN
                             IF "Contact No." <> '' THEN
                               IF Contact.GET("Contact No.") THEN
                                 Contact.CheckIfPrivacyBlockedGeneric;
                             ContactNoOnAfterValidate;
                           END;
                            }

    { 42  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p� den kontakt, som denne salgsmulighed er knyttet til. Feltet udfyldes automatisk, n�r du angiver et nummer i feltet Nummer.;
                           ENU=Specifies the name of the contact to which this opportunity is linked. The program automatically fills in this field when you have entered a number in the No. field.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Name";
                Editable=FALSE }

    { 44  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p� virksomheden for den kontakt, som denne salgsmulighed er knyttet til. Feltet udfyldes automatisk, n�r du angiver et nummer i feltet Virksomhedsnummer.;
                           ENU=Specifies the name of the company of the contact person to which this opportunity is linked. The program automatically fills in this field when you have entered a number in the Contact Company No. field.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Company Name";
                Importance=Additional;
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s�lger, som er ansvarlig for salgsmuligheden.;
                           ENU=Specifies the code of the salesperson that is responsible for the opportunity.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code";
                Editable=SalespersonCodeEditable }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsdokumentets type (Tilbud, Ordre, Bogf�rt faktura). Kombinationen af Salgsdokumentsnr. og Salgsdokumenttype angiver, hvilket salgsdokument der er knyttet til salgsmuligheden.;
                           ENU=Specifies the type of the sales document (Quote, Order, Posted Invoice). The combination of Sales Document No. and Sales Document Type specifies which sales document is assigned to the opportunity.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Document Type";
                ValuesAllowed=[" ";Quote;Order];
                Importance=Additional;
                Editable=SalesDocumentTypeEditable }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det salgsdokument, der er blevet oprettet til denne salgsmulighed.;
                           ENU=Specifies the number of the sales document that has been created for this opportunity.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Document No.";
                Importance=Additional;
                Editable=SalesDocumentNoEditable }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den kampagne, som denne salgsmulighed er knyttet til.;
                           ENU=Specifies the number of the campaign to which this opportunity is linked.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Importance=Additional;
                Editable=CampaignNoEditable }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den prioritering, salgsmuligheden har. Der er tre indstillinger:;
                           ENU=Specifies the priority of the opportunity. There are three options:];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Priority;
                Importance=Additional;
                Editable=PriorityEditable }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den salgsproces, som salgsmuligheden er knyttet til.;
                           ENU=Specifies the code of the sales cycle that the opportunity is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Sales Cycle Code";
                Editable=SalesCycleCodeEditable }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for salgsmuligheden. Der er fire indstillinger:;
                           ENU=Specifies the status of the opportunity. There are four options:];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Status }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at salgsmuligheden er lukket.;
                           ENU=Specifies that the opportunity is closed.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Closed;
                Importance=Additional }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor salgsmuligheden blev oprettet.;
                           ENU=Specifies the date that the opportunity was created.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Creation Date";
                Importance=Additional;
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor salgsmuligheden blev lukket.;
                           ENU=Specifies the date the opportunity was closed.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Date Closed";
                Importance=Additional }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den m�lgruppe, der eventuelt er knyttet til salgsmuligheden.;
                           ENU=Specifies the number of the segment (if any) that is linked to the opportunity.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Segment No.";
                Importance=Additional }

    { 25  ;1   ;Part      ;
                ApplicationArea=#RelationshipMgmt;
                SubPageLink=Opportunity No.=FIELD(No.);
                PagePartID=Page5125;
                PartType=Page }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 7   ;1   ;Part      ;
                CaptionML=[DAN=Statistik;
                           ENU=Statistics];
                ApplicationArea=#RelationshipMgmt;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page5174;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Text001@1000 : TextConst 'DAN=Der er ikke tildelt et salgstilbud til denne salgsmulighed.;ENU=There is no sales quote assigned to this opportunity.';
      Text002@1001 : TextConst 'DAN=Salgstilbuddet %1 findes ikke.;ENU=Sales quote %1 doesn''t exist.';
      OppNo@1003 : Code[20];
      SalesCycleCodeEditable@19025168 : Boolean INDATASET;
      SalesDocumentNoEditable@19055963 : Boolean INDATASET;
      SalesDocumentTypeEditable@19069947 : Boolean INDATASET;
      SalespersonCodeEditable@19071610 : Boolean INDATASET;
      CampaignNoEditable@19055339 : Boolean INDATASET;
      PriorityEditable@19032936 : Boolean INDATASET;
      ContactNoEditable@19030566 : Boolean INDATASET;
      Started@1002 : Boolean;
      OppInProgress@1004 : Boolean;
      CRMIntegrationEnabled@1005 : Boolean;
      CRMIsCoupledToRecord@1006 : Boolean;

    LOCAL PROCEDURE UpdateEditable@1();
    BEGIN
      Started := (Status <> Status::"Not Started");
      SalesCycleCodeEditable := Status = Status::"Not Started";
      SalespersonCodeEditable := Status < Status::Won;
      CampaignNoEditable := Status < Status::Won;
      PriorityEditable := Status < Status::Won;
      ContactNoEditable := Status < Status::Won;
      SalesDocumentNoEditable := Status = Status::"In Progress";
      SalesDocumentTypeEditable := Status = Status::"In Progress";
    END;

    LOCAL PROCEDURE ContactNoOnAfterValidate@19009577();
    BEGIN
      CALCFIELDS("Contact Name","Contact Company Name");
    END;

    BEGIN
    END.
  }
}

