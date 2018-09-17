OBJECT Page 14 Salespersons/Purchasers
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sëlgere/indkõbere;
               ENU=Salespersons/Purchasers];
    SourceTable=Table13;
    PageType=List;
    CardPageID=Salesperson/Purchaser Card;
    OnInit=VAR
             SegmentLine@1000 : Record 5077;
           BEGIN
             CreateInteractionVisible := SegmentLine.READPERMISSION;
           END;

    OnOpenPage=VAR
                 CRMIntegrationManagement@1000 : Codeunit 5330;
               BEGIN
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
               END;

    OnAfterGetCurrRecord=VAR
                           CRMCouplingManagement@1001 : Codeunit 5331;
                         BEGIN
                           IF CRMIntegrationEnabled THEN
                             CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Sëlger;
                                 ENU=&Salesperson];
                      Image=SalesPerson }
      { 14      ;2   ;Action    ;
                      CaptionML=[DAN=Tea&m;
                                 ENU=Tea&ms];
                      ToolTipML=[DAN=Vis eller rediger grupper, som sëlgeren/indkõberen er medlem af.;
                                 ENU=View or edit any teams that the salesperson/purchaser is a member of.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5107;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=TeamSales }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=Kon&takter;
                                 ENU=Con&tacts];
                      ToolTipML=[DAN=FÜ vist en liste over kontakter, der er tilknyttet sëlgeren/indkõberen.;
                                 ENU=View a list of contacts that are associated with the salesperson/purchaser.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5052;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=CustomerContact }
      { 26      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      Image=Dimensions }
      { 18      ;3   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - enkelt;
                                 ENU=Dimensions-Single];
                      ToolTipML=[DAN=FÜ vist eller rediger de enkelte sët af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(13),
                                  No.=FIELD(Code);
                      Image=Dimensions }
      { 27      ;3   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Dimensions;
                      Image=DimensionSets;
                      OnAction=VAR
                                 SalespersonPurchaser@1001 : Record 13;
                                 DefaultDimMultiple@1002 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(SalespersonPurchaser);
                                 DefaultDimMultiple.SetMultiSalesperson(SalespersonPurchaser);
                                 DefaultDimMultiple.RUNMODAL;
                               END;
                                }
      { 19      ;2   ;Action    ;
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
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=K&ampagner;
                                 ENU=C&ampaigns];
                      ToolTipML=[DAN=Vis eller rediger kampagner, som sëlgeren/indkõberen har fÜet tildelt.;
                                 ENU=View or edit any campaigns that the salesperson/purchaser is assigned to.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5087;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=Campaign }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=M&Ülgrupper;
                                 ENU=S&egments];
                      ToolTipML=[DAN=FÜ vist en liste over alle mÜlgrupperne.;
                                 ENU=View a list of all segments.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5093;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=Segment }
      { 22      ;2   ;Separator ;
                      CaptionML=[DAN="";
                                 ENU=""] }
      { 23      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Interaktionslo&gposter;
                                 ENU=Interaction Log E&ntries];
                      ToolTipML=[DAN=Vis en liste med de interaktioner, som du har gemt, f.eks. hvis du vil oprette en interaktion, udskrive en fõlgeseddel en salgsordre osv.;
                                 ENU=View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5076;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=InteractionLog }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Udsatte &interaktioner;
                                 ENU=Postponed &Interactions];
                      ToolTipML=[DAN=FÜ vist udskudte interaktioner for sëlgeren/indkõberen.;
                                 ENU=View postponed interactions for the salesperson/purchaser.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5082;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=PostponedInteractions }
      { 24      ;2   ;Action    ;
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
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=&Salgsmuligheder;
                                 ENU=Oppo&rtunities];
                      ToolTipML=[DAN=FÜ vist salgsmuligheder for sëlgeren/indkõberen.;
                                 ENU=View opportunities for the salesperson/purchaser.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5123;
                      RunPageView=SORTING(Salesperson Code);
                      RunPageLink=Salesperson Code=FIELD(Code);
                      Image=OpportunitiesList }
      { 5       ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 9       ;2   ;Action    ;
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
      { 16      ;2   ;Action    ;
                      Name=CRMSynchronizeNow;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Synkroniser;
                                 ENU=Synchronize];
                      ToolTipML=[DAN=Send eller hent opdaterede data til eller fra Dynamics 365 for Sales.;
                                 ENU=Send or get updated data to or from Dynamics 365 for Sales.];
                      ApplicationArea=#Suite;
                      Image=Refresh;
                      OnAction=VAR
                                 SalespersonPurchaser@1000 : Record 13;
                                 CRMIntegrationManagement@1001 : Codeunit 5330;
                                 SalespersonPurchaserRecordRef@1002 : RecordRef;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(SalespersonPurchaser);
                                 SalespersonPurchaser.NEXT;

                                 IF SalespersonPurchaser.COUNT = 1 THEN
                                   CRMIntegrationManagement.UpdateOneNow(SalespersonPurchaser.RECORDID)
                                 ELSE BEGIN
                                   SalespersonPurchaserRecordRef.GETTABLE(SalespersonPurchaser);
                                   CRMIntegrationManagement.UpdateMultipleNow(SalespersonPurchaserRecordRef);
                                 END
                               END;
                                }
      { 13      ;2   ;ActionGroup;
                      Name=Coupling;
                      CaptionML=[@@@=Coupling is a noun;
                                 DAN=Sammenkëdning;
                                 ENU=Coupling];
                      ToolTipML=[DAN=Opret, rediger eller slet en sammenkëdning mellem Microsoft Dynamics NAV-recorden og en Dynamics 365 for Sales-record.;
                                 ENU=Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.];
                      Image=LinkAccount }
      { 10      ;3   ;Action    ;
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
      { 3       ;3   ;Action    ;
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
      { 7       ;2   ;Action    ;
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
      { 17      ;1   ;Action    ;
                      Name=CreateInteraction;
                      AccessByPermission=TableData 5062=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=O&pret interaktion;
                                 ENU=Create &Interaction];
                      ToolTipML=[DAN=Brug en kõrsel til at oprette interaktioner for de involverede sëlgere eller indkõbere.;
                                 ENU=Use a batch job to help you create interactions for the involved salespeople or purchasers.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=CreateInteractionVisible;
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
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for recorden.;
                           ENU=Specifies the code of the record.];
                ApplicationArea=#All;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ recorden.;
                           ENU=Specifies the name of the record.];
                ApplicationArea=#Suite,#RelationshipMgmt;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen, der skal bruges til beregning af sëlgerens provision.;
                           ENU=Specifies the percentage to use to calculate the salesperson's commission.];
                ApplicationArea=#Suite,#RelationshipMgmt;
                SourceExpr="Commission %" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sëlgerens eller kõberens telefonnummer.;
                           ENU=Specifies the salesperson's or purchaser's telephone number.];
                ApplicationArea=#Suite,#RelationshipMgmt;
                SourceExpr="Phone No." }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om adgangen til data skal begrënses for dataemnet i den daglige drift. Dette er eksempelvis nyttigt, nÜr du vil beskytte data mod ëndringer, mens det kontrolleres, om de indeholder personlige oplysninger.;
                           ENU=Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.];
                ApplicationArea=#Suite,#RelationshipMgmt;
                SourceExpr="Privacy Blocked";
                Importance=Additional;
                Visible=FALSE }

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
      CreateInteractionVisible@1000 : Boolean INDATASET;
      CRMIntegrationEnabled@1002 : Boolean;
      CRMIsCoupledToRecord@1001 : Boolean;

    BEGIN
    END.
  }
}

