OBJECT Page 5123 Opportunity List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Salgsmulighedsoversigt;
               ENU=Opportunity List];
    SourceTable=Table5092;
    DataCaptionExpr=Caption;
    PageType=List;
    CardPageID=Opportunity Card;
    OnOpenPage=VAR
                 CRMIntegrationManagement@1000 : Codeunit 5330;
               BEGIN
                 CurrPage.EDITABLE := TRUE;
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
               END;

    OnFindRecord=VAR
                   RecordsFound@1001 : Boolean;
                 BEGIN
                   RecordsFound := FIND(Which);
                   EXIT(RecordsFound);
                 END;

    OnAfterGetRecord=VAR
                       SalesCycleStage@1000 : Record 5091;
                       CRMCouplingManagement@1001 : Codeunit 5331;
                     BEGIN
                       CALCFIELDS("Current Sales Cycle Stage");
                       CurrSalesCycleStage := '';
                       IF SalesCycleStage.GET("Sales Cycle Code","Current Sales Cycle Stage") THEN
                         CurrSalesCycleStage := SalesCycleStage.Description;

                       IF CRMIntegrationEnabled THEN
                         CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
                     END;

    OnAfterGetCurrRecord=BEGIN
                           CALCFIELDS("Contact Name","Contact Company Name");
                           OppNotStarted := Status = Status::"Not Started";
                           OppInProgress := Status = Status::"In Progress";
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 30      ;1   ;ActionGroup;
                      Name=Opportunity;
                      CaptionML=[DAN=&Salgsmulighed;
                                 ENU=Oppo&rtunity];
                      Image=Opportunity }
      { 36      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger sÜsom vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5127;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 55      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Interaktionslogposter;
                                 ENU=Interaction Log E&ntries];
                      ToolTipML=[DAN=Vis en liste med de interaktioner, som du har gemt, f.eks. hvis du vil oprette en interaktion, udskrive en fõlgeseddel en salgsordre osv.;
                                 ENU=View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5076;
                      RunPageView=SORTING(Opportunity No.,Date);
                      RunPageLink=Opportunity No.=FIELD(No.);
                      Image=InteractionLog }
      { 58      ;2   ;Action    ;
                      CaptionML=[DAN=&Udsatte interaktioner;
                                 ENU=Postponed &Interactions];
                      ToolTipML=[DAN=FÜ vist udskudte transaktioner for salgsmuligheder.;
                                 ENU=View postponed interactions for opportunities.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5082;
                      RunPageView=SORTING(Opportunity No.,Date);
                      RunPageLink=Opportunity No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostponedInteractions;
                      PromotedCategory=Process;
                      Scope=Repeater }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Opg&aver;
                                 ENU=T&asks];
                      ToolTipML=[DAN=FÜ vist alle marketingopgaver, der vedrõrer salgsmuligheden.;
                                 ENU="View all marketing tasks that involve the opportunity. "];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5096;
                      RunPageView=SORTING(Opportunity No.);
                      RunPageLink=Opportunity No.=FIELD(No.),
                                  System To-do Type=FILTER(Organizer);
                      Image=TaskList }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5072;
                      RunPageLink=Table Name=CONST(Opportunity),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 7       ;2   ;Action    ;
                      CaptionML=[DAN=Vis salgstilbud;
                                 ENU=Show Sales Quote];
                      ToolTipML=[DAN=Vis det tildelte salgstilbud.;
                                 ENU=Show the assigned sales quote.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=Quote;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ShowSalesQuoteWithCheck;
                               END;
                                }
      { 28      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 25      ;2   ;Action    ;
                      Name=CRMGotoOpportunity;
                      CaptionML=[DAN=Salgsmulighed;
                                 ENU=Opportunity];
                      ToolTipML=[DAN=èbn den sammenkëdede Dynamics 365 for Sales-salgsmulighed.;
                                 ENU=Open the coupled Dynamics 365 for Sales opportunity.];
                      ApplicationArea=#Suite;
                      Image=CoupledContactPerson;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowCRMEntityFromRecordID(RECORDID);
                               END;
                                }
      { 26      ;2   ;Action    ;
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
      { 23      ;2   ;ActionGroup;
                      Name=Coupling;
                      CaptionML=[@@@=Coupling is a noun;
                                 DAN=Sammenkëdning;
                                 ENU=Coupling];
                      ToolTipML=[DAN=Opret, rediger eller slet en sammenkëdning mellem Microsoft Dynamics NAV-recorden og en Dynamics 365 for Sales-record.;
                                 ENU=Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.];
                      Image=LinkAccount }
      { 20      ;3   ;Action    ;
                      Name=ManageCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Konfigurer sammenkëdning;
                                 ENU=Set Up Coupling];
                      ToolTipML=[DAN=Opret eller rediger sammenkëdningen med en Dynamics 365 for Sales-salgsmulighed.;
                                 ENU=Create or modify the coupling to a Dynamics 365 for Sales opportunity.];
                      ApplicationArea=#Suite;
                      Image=LinkAccount;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.DefineCoupling(RECORDID);
                               END;
                                }
      { 21      ;3   ;Action    ;
                      Name=DeleteCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Slet sammenkëdning;
                                 ENU=Delete Coupling];
                      ToolTipML=[DAN=Slet sammenkëdningen med en Dynamics 365 for Sales-salgsmulighed.;
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
      { 15      ;2   ;Action    ;
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
      { 29      ;1   ;ActionGroup;
                      Name=Functions;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Opdater;
                                 ENU=Update];
                      ToolTipML=[DAN=Opdater alle handlinger i forbindelse med dine salgsmuligheder.;
                                 ENU=Update all the actions that are related to your opportunities.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Enabled=OppInProgress;
                      Image=Refresh;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 UpdateOpportunity;
                               END;
                                }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Luk;
                                 ENU=Close];
                      ToolTipML=[DAN=Luk alle handlinger i forbindelse med dine salgsmuligheder.;
                                 ENU=Close all the actions that are related to your opportunities.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Enabled=OppNotStarted OR OppInProgress;
                      Image=Close;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 CloseOpportunity;
                               END;
                                }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=AktivÇr fõrste fase;
                                 ENU=Activate First Stage];
                      ToolTipML=[DAN=Angiv, om salgsmuligheden skal aktiveres. Statussen er indstillet til Igangvërende.;
                                 ENU=Specify if the opportunity is to be activated. The status is set to In Progress.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Enabled=OppNotStarted;
                      Image=Action;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 StartActivateFirstStage;
                               END;
                                }
      { 34      ;2   ;Action    ;
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
                      Scope=Repeater;
                      OnAction=BEGIN
                                 AssignQuote;
                               END;
                                }
      { 57      ;2   ;Action    ;
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
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=O&pret interaktion;
                                 ENU=Create &Interaction];
                      ToolTipML=[DAN=Opret en interaktion med en bestemt salgsmulighed.;
                                 ENU=Create an interaction with a specified opportunity.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=CreateInteraction;
                      PromotedCategory=Process;
                      Scope=Repeater;
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
                Editable=FALSE;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at salgsmuligheden er lukket.;
                           ENU=Specifies that the opportunity is closed.];
                ApplicationArea=#All;
                SourceExpr=Closed }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor salgsmuligheden blev oprettet.;
                           ENU=Specifies the date that the opportunity was created.];
                ApplicationArea=#All;
                SourceExpr="Creation Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af den Übne salgsmulighed.;
                           ENU=Specifies the description of the opportunity.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, som denne salgsmulighed er knyttet til.;
                           ENU=Specifies the number of the contact that this opportunity is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact No." }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den virksomhed, som er knyttet til denne salgsmulighed.;
                           ENU=Specifies the number of the company that is linked to this opportunity.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Company No.";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den sëlger, som er ansvarlig for salgsmuligheden.;
                           ENU=Specifies the code of the salesperson that is responsible for the opportunity.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for salgsmuligheden. Der er fire indstillinger:;
                           ENU=Specifies the status of the opportunity. There are four options:];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Status }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den salgsproces, som salgsmuligheden er knyttet til.;
                           ENU=Specifies the code of the sales cycle that the opportunity is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Sales Cycle Code";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                CaptionML=[DAN=Aktuel salgsprocesfase;
                           ENU=Current Sales Cycle Stage];
                ToolTipML=[DAN=Angiver den aktuelle salgsprocesfase for salgsmuligheden.;
                           ENU=Specifies the current sales cycle stage of the opportunity.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=CurrSalesCycleStage }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kampagne, som denne salgsmulighed er knyttet til.;
                           ENU=Specifies the number of the campaign to which this opportunity is linked.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No." }

    { 51  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver beskrivelsen af den kampagne, som salgsmuligheden er knyttet til. Feltet udfyldes automatisk, nÜr du angiver et nummer i feltet Kampagnenr.;
                           ENU=Specifies the description of the campaign to which the opportunity is linked. The program automatically fills in this field when you have entered a number in the Campaign No. field.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Description" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsdokumentets type (Tilbud, Ordre, Bogfõrt faktura). Kombinationen af Salgsdokumentsnr. og Salgsdokumenttype angiver, hvilket salgsdokument der er knyttet til salgsmuligheden.;
                           ENU=Specifies the type of the sales document (Quote, Order, Posted Invoice). The combination of Sales Document No. and Sales Document Type specifies which sales document is assigned to the opportunity.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Document Type" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det salgsdokument, der er blevet oprettet til denne salgsmulighed.;
                           ENU=Specifies the number of the sales document that has been created for this opportunity.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Document No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den anslÜede ultimodato for salgsmuligheden.;
                           ENU=Specifies the estimated closing date of the opportunity.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Estimated Closing Date" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den anslÜede vërdi af salgsmuligheden.;
                           ENU=Specifies the estimated value of the opportunity.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Estimated Value (LCY)" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den aktuelle beregnede vërdi af salgsmuligheden.;
                           ENU=Specifies the current calculated value of the opportunity.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Calcd. Current Value (LCY)" }

    { 45  ;1   ;Group      }

    { 46  ;2   ;Field     ;
                DrillDown=No;
                CaptionML=[DAN=Kontaktnavn;
                           ENU=Contact Name];
                ToolTipML=[DAN=Angiver navnet pÜ den kontakt, som denne salgsmulighed er knyttet til. Feltet udfyldes automatisk, nÜr du angiver et nummer i feltet Nummer.;
                           ENU=Specifies the name of the contact to which this opportunity is linked. The program automatically fills in this field when you have entered a number in the No. field.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Name" }

    { 50  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ virksomheden for den kontakt, som denne salgsmulighed er knyttet til. Feltet udfyldes automatisk, nÜr du angiver et nummer i feltet Virksomhedsnummer.;
                           ENU=Specifies the name of the company of the contact person to which this opportunity is linked. The program automatically fills in this field when you have entered a number in the Contact Company No. field.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Company Name" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 5   ;1   ;Part      ;
                ApplicationArea=#RelationshipMgmt;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page5174;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Text001@1004 : TextConst 'DAN=ikke navngivet;ENU=untitled';
      OppNotStarted@1001 : Boolean;
      OppInProgress@1002 : Boolean;
      CRMIntegrationEnabled@1003 : Boolean;
      CRMIsCoupledToRecord@1005 : Boolean;
      CurrSalesCycleStage@1000 : Text;

    LOCAL PROCEDURE Caption@1() : Text[260];
    VAR
      CaptionStr@1000 : Text[260];
    BEGIN
      CASE TRUE OF
        BuildCaptionContact(CaptionStr,GETFILTER("Contact Company No.")),
        BuildCaptionContact(CaptionStr,GETFILTER("Contact No.")),
        BuildCaptionSalespersonPurchaser(CaptionStr,GETFILTER("Salesperson Code")),
        BuildCaptionCampaign(CaptionStr,GETFILTER("Campaign No.")),
        BuildCaptionSegmentHeader(CaptionStr,GETFILTER("Segment No.")):
          EXIT(CaptionStr)
      END;

      EXIT(Text001);
    END;

    LOCAL PROCEDURE BuildCaptionContact@9(VAR CaptionText@1007 : Text[260];Filter@1000 : Text) : Boolean;
    VAR
      Contact@1001 : Record 5050;
    BEGIN
      WITH Contact DO
        EXIT(BuildCaption(CaptionText,Contact,Filter,FIELDNO("No."),FIELDNO(Name)));
    END;

    LOCAL PROCEDURE BuildCaptionSalespersonPurchaser@8(VAR CaptionText@1007 : Text[260];Filter@1000 : Text) : Boolean;
    VAR
      SalespersonPurchaser@1002 : Record 13;
    BEGIN
      WITH SalespersonPurchaser DO
        EXIT(BuildCaption(CaptionText,SalespersonPurchaser,Filter,FIELDNO(Code),FIELDNO(Name)));
    END;

    LOCAL PROCEDURE BuildCaptionCampaign@7(VAR CaptionText@1001 : Text[260];Filter@1000 : Text) : Boolean;
    VAR
      Campaign@1002 : Record 5071;
    BEGIN
      WITH Campaign DO
        EXIT(BuildCaption(CaptionText,Campaign,Filter,FIELDNO("No."),FIELDNO(Description)));
    END;

    LOCAL PROCEDURE BuildCaptionSegmentHeader@6(VAR CaptionText@1001 : Text[260];Filter@1000 : Text) : Boolean;
    VAR
      SegmentHeader@1002 : Record 5076;
    BEGIN
      WITH SegmentHeader DO
        EXIT(BuildCaption(CaptionText,SegmentHeader,Filter,FIELDNO("No."),FIELDNO(Description)));
    END;

    LOCAL PROCEDURE BuildCaption@2(VAR CaptionText@1007 : Text[260];RecVar@1001 : Variant;Filter@1000 : Text;IndexFieldNo@1005 : Integer;TextFieldNo@1006 : Integer) : Boolean;
    VAR
      RecRef@1002 : RecordRef;
      IndexFieldRef@1003 : FieldRef;
      TextFieldRef@1004 : FieldRef;
    BEGIN
      Filter := DELCHR(Filter,'<>','''');
      IF Filter <> '' THEN BEGIN
        RecRef.GETTABLE(RecVar);
        IndexFieldRef := RecRef.FIELD(IndexFieldNo);
        IndexFieldRef.SETRANGE(Filter);
        IF RecRef.FINDFIRST THEN BEGIN
          TextFieldRef := RecRef.FIELD(TextFieldNo);
          CaptionText := COPYSTR(FORMAT(IndexFieldRef.VALUE) + ' ' + FORMAT(TextFieldRef.VALUE),1,MAXSTRLEN(CaptionText));
        END;
      END;

      EXIT(Filter <> '');
    END;

    BEGIN
    END.
  }
}

