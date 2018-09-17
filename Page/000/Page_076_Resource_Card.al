OBJECT Page 76 Resource Card
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ressourcekort;
               ENU=Resource Card];
    SourceTable=Table156;
    PageType=Card;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
                 SetNoFieldVisible;
               END;

    OnAfterGetCurrRecord=VAR
                           CRMCouplingManagement@1001 : Codeunit 5331;
                         BEGIN
                           IF CRMIntegrationEnabled THEN BEGIN
                             CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
                             IF "No." <> xRec."No." THEN
                               CRMIntegrationManagement.SendResultNotification(Rec);
                           END;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 56      ;1   ;ActionGroup;
                      CaptionML=[DAN=R&essource;
                                 ENU=&Resource];
                      Image=Resource }
      { 58      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 223;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Unit of Measure Filter=FIELD(Unit of Measure Filter),
                                  Chargeable Filter=FIELD(Chargeable Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 84      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(156),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 73      ;2   ;Action    ;
                      CaptionML=[DAN=&Billede;
                                 ENU=&Picture];
                      ToolTipML=[DAN=Vis eller tilfõj et billede af ressourcen eller f.eks. virksomhedens logo.;
                                 ENU=View or add a picture of the resource or, for example, the company's logo.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 407;
                      RunPageLink=No.=FIELD(No.);
                      Image=Picture }
      { 70      ;2   ;Action    ;
                      CaptionML=[DAN=&Udvidede tekster;
                                 ENU=E&xtended Texts];
                      ToolTipML=[DAN=Vis den forlëngede varebeskrivelse, der er oprettet.;
                                 ENU=View the extended description that is set up.];
                      ApplicationArea=#Suite;
                      RunObject=Page 391;
                      RunPageView=SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                      RunPageLink=Table Name=CONST(Resource),
                                  No.=FIELD(No.);
                      Image=Text }
      { 77      ;2   ;Action    ;
                      CaptionML=[DAN=Enheder;
                                 ENU=Units of Measure];
                      ToolTipML=[DAN=Vis eller rediger de basisenheder, der er angivet for ressourcen.;
                                 ENU=View or edit the units of measure that are set up for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 210;
                      RunPageLink=Resource No.=FIELD(No.);
                      Image=UnitOfMeasure }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=K&valifikationer;
                                 ENU=S&kills];
                      ToolTipML=[DAN=Vis tildelingen af kvalifikationer til ressourcen. Du kan bruge kvalifikationskoderne til at allokere kvalificerede ressourcer til serviceartikler eller varer, som krëver specialviden ved reparation.;
                                 ENU=View the assignment of skills to the resource. You can use skill codes to allocate skilled resources to service items or items that need special skills for servicing.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6019;
                      RunPageLink=Type=CONST(Resource),
                                  No.=FIELD(No.);
                      Image=Skills }
      { 34      ;2   ;Separator ;
                      CaptionML=[DAN="";
                                 ENU=""] }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Ressourcelo&kationer;
                                 ENU=Resource L&ocations];
                      ToolTipML=[DAN=Vis, hvor ressourcer er placeret, eller tildel ressourcer til lokationer.;
                                 ENU=View where resources are located or assign resources to locations.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6015;
                      RunPageView=SORTING(Resource No.);
                      RunPageLink=Resource No.=FIELD(No.);
                      Image=Resource }
      { 59      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Resource),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 80      ;2   ;Action    ;
                      CaptionML=[DAN=Online Map;
                                 ENU=Online Map];
                      ToolTipML=[DAN=Vis adressen pÜ et onlinekort.;
                                 ENU=View the address on an online map.];
                      ApplicationArea=#Jobs;
                      Image=Map;
                      OnAction=BEGIN
                                 DisplayMap;
                               END;
                                }
      { 69      ;2   ;Separator  }
      { 33      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 31      ;2   ;Action    ;
                      Name=CRMGoToProduct;
                      CaptionML=[DAN=Produkt;
                                 ENU=Product];
                      ToolTipML=[DAN=èbn det sammenkëdede Dynamics 365 for Sales-produkt.;
                                 ENU=Open the coupled Dynamics 365 for Sales product.];
                      ApplicationArea=#Suite;
                      Image=CoupledItem;
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
                      ToolTipML=[DAN=Send de opdaterede data til Dynamics 365 for Sales.;
                                 ENU=Send updated data to Dynamics 365 for Sales.];
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
                      ToolTipML=[DAN=Opret eller rediger sammenkëdningen med et Dynamics 365 for Sales-produkt.;
                                 ENU=Create or modify the coupling to a Dynamics 365 for Sales product.];
                      ApplicationArea=#Suite;
                      Image=LinkAccount;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.DefineCoupling(RECORDID);
                               END;
                                }
      { 22      ;3   ;Action    ;
                      Name=DeleteCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Slet sammenkëdning;
                                 ENU=Delete Coupling];
                      ToolTipML=[DAN=Slet sammenkëdningen med et Dynamics 365 for Sales-produkt.;
                                 ENU=Delete the coupling to a Dynamics 365 for Sales product.];
                      ApplicationArea=#Suite;
                      Enabled=CRMIsCoupledToRecord;
                      Image=UnLinkAccount;
                      OnAction=VAR
                                 CRMCouplingManagement@1000 : Codeunit 5331;
                               BEGIN
                                 CRMCouplingManagement.RemoveCoupling(RECORDID);
                               END;
                                }
      { 41      ;2   ;Action    ;
                      Name=ShowLog;
                      CaptionML=[DAN=Synkroniseringslog;
                                 ENU=Synchronization Log];
                      ToolTipML=[DAN=Vis integrationssynkroniseringsjobs for ressourcetabellen.;
                                 ENU=View integration synchronization jobs for the resource table.];
                      ApplicationArea=#Suite;
                      Image=Log;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowLog(RECORDID);
                               END;
                                }
      { 51      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Priser;
                                 ENU=&Prices];
                      Image=Price }
      { 61      ;2   ;Action    ;
                      CaptionML=[DAN=Kostpriser;
                                 ENU=Costs];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om omkostninger for ressourcen.;
                                 ENU=View or change detailed information about costs for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 203;
                      RunPageLink=Type=CONST(Resource),
                                  Code=FIELD(No.);
                      Promoted=Yes;
                      Image=ResourceCosts;
                      PromotedCategory=Process }
      { 62      ;2   ;Action    ;
                      CaptionML=[DAN=Salgspriser;
                                 ENU=Prices];
                      ToolTipML=[DAN=Vis eller rediger priser for ressourcen.;
                                 ENU=View or edit prices for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 204;
                      RunPageLink=Type=CONST(Resource),
                                  Code=FIELD(No.);
                      Promoted=Yes;
                      Image=Price;
                      PromotedCategory=Process }
      { 50      ;1   ;ActionGroup;
                      CaptionML=[DAN=Plan&lëgn.;
                                 ENU=Plan&ning];
                      Image=Planning }
      { 63      ;2   ;Action    ;
                      CaptionML=[DAN=Ressource&kapacitet;
                                 ENU=Resource &Capacity];
                      ToolTipML=[DAN=Vis sagens ressourcekapacitet.;
                                 ENU=View this job's resource capacity.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 213;
                      RunPageOnRec=Yes;
                      Image=Capacity }
      { 64      ;2   ;Action    ;
                      CaptionML=[DAN=Ressource allo&keret pÜ sager;
                                 ENU=Resource &Allocated per Job];
                      ToolTipML=[DAN=Vis sagens ressourcetildeling.;
                                 ENU=View this job's resource allocation.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 221;
                      RunPageLink=Resource Filter=FIELD(No.);
                      Image=ViewJob }
      { 76      ;2   ;Action    ;
                      CaptionML=[DAN=Ressource allokeret pÜ service&ordre;
                                 ENU=Resource Allocated per Service &Order];
                      ToolTipML=[DAN=Vis serviceordrens tildelinger for ressourcen.;
                                 ENU=View the service order allocations of the resource.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6008;
                      RunPageLink=Resource Filter=FIELD(No.);
                      Image=ViewServiceOrder }
      { 66      ;2   ;Action    ;
                      CaptionML=[DAN=Ressource&disponering;
                                 ENU=Resource A&vailability];
                      ToolTipML=[DAN=Vis en oversigt over ressourcekapaciteter, antallet af ressourcetimer, der er allokeret til sager i ordre, det antal, der er allokeret til serviceordrer, den kapacitet, der er tildelt til sager i tilbud, og ressourcetilgëngelighed.;
                                 ENU=View a summary of resource capacities, the quantity of resource hours allocated to jobs on order, the quantity allocated to service orders, the capacity assigned to jobs on quote, and the resource availability.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 225;
                      RunPageLink=No.=FIELD(No.),
                                  Base Unit of Measure=FIELD(Base Unit of Measure),
                                  Chargeable Filter=FIELD(Chargeable Filter);
                      Image=Calendar }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Service;
                                 ENU=Service];
                      Image=ServiceZone }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Service&zoner;
                                 ENU=Service &Zones];
                      ToolTipML=[DAN=Vis de forskellige servicezoner, som du kan tildele debitorer og ressourcer. NÜr du allokerer en ressource til en serviceopgave, der skal udfõres pÜ debitorens adresse, kan du vëlge en ressource, som er placeret i samme servicezone som debitoren.;
                                 ENU=View the different service zones that you can assign to customers and resources. When you allocate a resource to a service task that is to be performed at the customer site, you can select a resource that is located in the same service zone as the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 6021;
                      RunPageLink=Resource No.=FIELD(No.);
                      Image=ServiceZone }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 60      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 202;
                      RunPageView=SORTING(Resource No.)
                                  ORDER(Descending);
                      RunPageLink=Resource No.=FIELD(No.);
                      Promoted=Yes;
                      Image=ResourceLedger;
                      PromotedCategory=Process }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1901205806;1 ;Action    ;
                      CaptionML=[DAN=Ressourcestatistik;
                                 ENU=Resource Statistics];
                      ToolTipML=[DAN=Vis detaljerede, historiske oplysninger for ressourcen.;
                                 ENU=View detailed, historical information for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1105;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1907688806;1 ;Action    ;
                      CaptionML=[DAN=Ressourceforbrug;
                                 ENU=Resource Usage];
                      ToolTipML=[DAN=Vis, hvordan ressourcen er blevet brugt. Rapporten omfatter ressourcekapacitet, antal forbrugt og den resterende saldo.;
                                 ENU=View the resource utilization that has taken place. The report includes the resource capacity, quantity of usage, and the remaining balance.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1106;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1907042906;1 ;Action    ;
                      CaptionML=[DAN=Ressource - lõngrundlag;
                                 ENU=Resource - Cost Breakdown];
                      ToolTipML=[DAN=Vis kõbsprisen pr. enhed og de samlede direkte omkostninger for den enkelte ressource. Der medtages kun bogfõring af forbrug i denne rapport. Ressourceforbrug kan vëre bogfõrt i ressourcekladden eller i sagskladden.;
                                 ENU=View the direct unit costs and the total direct costs for each resource. Only usage postings are considered in this report. Resource usage can be posted in the resource journal or the job journal.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1107;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 15      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 9       ;2   ;Action    ;
                      Name=CreateTimeSheets;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret timesedler;
                                 ENU=Create Time Sheets];
                      ToolTipML=[DAN=Opret nye timesedler for ressourcen.;
                                 ENU=Create new time sheets for the resource.];
                      ApplicationArea=#Jobs;
                      Image=NewTimesheet;
                      OnAction=BEGIN
                                 CreateTimeSheets;
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

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af ressourcen.;
                           ENU=Specifies a description of the resource.];
                ApplicationArea=#Jobs;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om ressourcen er en person eller en maskine.;
                           ENU=Specifies whether the resource is a person or a machine.];
                ApplicationArea=#Jobs;
                SourceExpr=Type;
                Importance=Promoted }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den basisenhed, der bruges til at mÜle ressourcen, f.eks. time, stik. eller kilometer.;
                           ENU=Specifies the base unit used to measure the resource, such as hour, piece, or kilometer.];
                ApplicationArea=#Jobs;
                SourceExpr="Base Unit of Measure";
                Importance=Promoted }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at sõge efter den õnskede record, hvis du ikke kan huske vërdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Jobs;
                SourceExpr="Search Name" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ressourcegruppe, som denne ressource er tilknyttet.;
                           ENU=Specifies the resource group that this resource is assigned to.];
                ApplicationArea=#Jobs;
                SourceExpr="Resource Group No.";
                Importance=Promoted }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogfõres under transaktioner - eksempelvis en debitor, som er erklëret insolvent, eller en vare, som er sat i karantëne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Jobs;
                SourceExpr=Blocked }

    { 120 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om adgangen til data skal begrënses for dataemnet i den daglige drift. Dette er eksempelvis nyttigt, nÜr du vil beskytte data mod ëndringer, mens det kontrolleres, om de indeholder personlige oplysninger.;
                           ENU=Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.];
                ApplicationArea=#Jobs;
                SourceExpr="Privacy Blocked";
                Importance=Additional }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for, hvornÜr oplysningerne i vinduet Ressourcekort sidst blev ëndret.;
                           ENU=Specifies the date of the most recent change of information in the Resource Card window.];
                ApplicationArea=#Jobs;
                SourceExpr="Last Date Modified" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en ressource bruger en timeseddel til at registrere den tid, der er allokeret til forskellige opgaver.;
                           ENU=Specifies if a resource uses a time sheet to record time allocated to various tasks.];
                ApplicationArea=#Jobs;
                SourceExpr="Use Time Sheet" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ ejeren af timesedlen.;
                           ENU=Specifies the name of the owner of the time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Time Sheet Owner User ID" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for godkenderen af timesedlen.;
                           ENU=Specifies the ID of the approver of the time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Time Sheet Approver User ID" }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Jobs;
                SourceExpr="Direct Unit Cost" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste kõbspris, der omfatter indirekte omkostninger, sÜsom fragt, der er knyttet til kõbet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Jobs;
                SourceExpr="Indirect Cost %" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver relationen mellem felterne Kostpris, Enhedspris og Avancepct. for denne ressource.;
                           ENU=Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this resource.];
                ApplicationArea=#Jobs;
                SourceExpr="Price/Profit Calculation" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dëkningsgrad, du vil sëlge ressourcen til. Du kan angive en avanceprocent manuelt eller fÜ den angivet i henhold til feltet Avancepct.beregning.;
                           ENU=Specifies the profit margin that you want to sell the resource at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field];
                ApplicationArea=#Jobs;
                SourceExpr="Profit %" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for Çn enhed af varen eller ressourcen. Du kan angive en pris manuelt eller fÜ den angivet i henhold til feltet Avancepct.beregning pÜ det dertilhõrende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Price" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="Gen. Prod. Posting Group";
                Importance=Promoted }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="VAT Prod. Posting Group";
                Importance=Promoted }

    { 21  ;2   ;Field     ;
                CaptionML=[DAN=Standardperiodiseringsskabelon;
                           ENU=Default Deferral Template];
                ToolTipML=[DAN=Angiver den standardskabelon, der styrer, hvordan indtjening og udgifter periodiseres til de perioder, hvor de indtrëffer.;
                           ENU=Specifies the default template that governs how to defer revenues and expenses to the periods when they occurred.];
                ApplicationArea=#Jobs;
                SourceExpr="Default Deferral Template Code" }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der tilfõjes et udvidet teksthoved pÜ salgs- eller kõbsbilag for denne ressource.;
                           ENU=Specifies that an Extended Text Header will be added on sales or purchase documents for this resource.];
                ApplicationArea=#Jobs;
                SourceExpr="Automatic Ext. Texts" }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den IC-finanskonto i din partners firma, som belõbet for denne ressource bogfõres pÜ.;
                           ENU=Specifies the intercompany g/l account number in your partner's company that the amount for this resource is posted to.];
                ApplicationArea=#Jobs;
                SourceExpr="IC Partner Purch. G/L Acc. No." }

    { 1904603601;1;Group  ;
                CaptionML=[DAN=Personoplysninger;
                           ENU=Personal Data] }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver personens stilling.;
                           ENU=Specifies the person's job title.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Title" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ressourcens adresse eller lokation, hvis det er relevant.;
                           ENU=Specifies the address or location of the resource, if applicable.];
                ApplicationArea=#Jobs;
                SourceExpr=Address }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Jobs;
                SourceExpr="Address 2" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Jobs;
                SourceExpr="Post Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for ressourcens adresse.;
                           ENU=Specifies the city of the resource's address.];
                ApplicationArea=#Jobs;
                SourceExpr=City }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver personens CPR-nummer eller maskinens serienummer.;
                           ENU=Specifies the person's social security number or the machine's serial number.];
                ApplicationArea=#Jobs;
                SourceExpr="Social Security No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver uddannelses- eller certificeringsniveauet for personen.;
                           ENU=Specifies the training, education, or certification level of the person.];
                ApplicationArea=#Jobs;
                SourceExpr=Education }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver overenskomsten for personen.;
                           ENU=Specifies the contract class for the person.];
                ApplicationArea=#Jobs;
                SourceExpr="Contract Class" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor personen begyndte at arbejde for dig, og den dato, hvor maskinen blev sat i drift.;
                           ENU=Specifies the date when the person began working for you or the date when the machine was placed in service.];
                ApplicationArea=#Jobs;
                SourceExpr="Employment Date" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 39  ;1   ;Part      ;
                ApplicationArea=#Jobs;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page407;
                PartType=Page }

    { 1906609707;1;Part   ;
                ApplicationArea=#Jobs;
                SubPageLink=No.=FIELD(No.),
                            Unit of Measure Filter=FIELD(Unit of Measure Filter),
                            Chargeable Filter=FIELD(Chargeable Filter),
                            Service Zone Filter=FIELD(Service Zone Filter);
                PagePartID=Page9107;
                Visible=TRUE;
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
      CRMIntegrationManagement@1002 : Codeunit 5330;
      CRMIntegrationEnabled@1001 : Boolean;
      CRMIsCoupledToRecord@1000 : Boolean;
      NoFieldVisible@1003 : Boolean;

    LOCAL PROCEDURE SetNoFieldVisible@13();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
    BEGIN
      NoFieldVisible := DocumentNoVisibility.ResourceNoIsVisible;
    END;

    BEGIN
    END.
  }
}

