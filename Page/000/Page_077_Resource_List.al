OBJECT Page 77 Resource List
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Ressourceoversigt;
               ENU=Resource List];
    SourceTable=Table156;
    PageType=List;
    CardPageID=Resource Card;
    OnOpenPage=VAR
                 CRMIntegrationManagement@1000 : Codeunit 5330;
               BEGIN
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
               END;

    OnAfterGetCurrRecord=VAR
                           CRMCouplingManagement@1001 : Codeunit 5331;
                         BEGIN
                           CRMIsCoupledToRecord :=
                             CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID) AND CRMIntegrationEnabled;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=R&essource;
                                 ENU=&Resource];
                      Image=Resource }
      { 31      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 223;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Resource),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 19      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      Image=Dimensions }
      { 84      ;3   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - enkelt;
                                 ENU=Dimensions-Single];
                      ToolTipML=[DAN=FÜ vist eller rediger de enkelte sët af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(156),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 18      ;3   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Jobs;
                      Image=DimensionSets;
                      OnAction=VAR
                                 Res@1001 : Record 156;
                                 DefaultDimMultiple@1002 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Res);
                                 DefaultDimMultiple.SetMultiResource(Res);
                                 DefaultDimMultiple.RUNMODAL;
                               END;
                                }
      { 50      ;2   ;Action    ;
                      CaptionML=[DAN=&Billede;
                                 ENU=&Picture];
                      ToolTipML=[DAN=Vis eller tilfõj et billede af ressourcen eller f.eks. virksomhedens logo.;
                                 ENU=View or add a picture of the resource or, for example, the company's logo.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 407;
                      RunPageLink=No.=FIELD(No.);
                      Image=Picture }
      { 33      ;2   ;Action    ;
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
                      Promoted=No;
                      Image=ResourceLedger;
                      PromotedCategory=Process }
      { 25      ;2   ;Action    ;
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
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Enheder;
                                 ENU=Units of Measure];
                      ToolTipML=[DAN=Vis eller rediger de basisenheder, der er angivet for ressourcen.;
                                 ENU=View or edit the units of measure that are set up for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 210;
                      RunPageLink=Resource No.=FIELD(No.);
                      Image=UnitOfMeasure }
      { 23      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 22      ;2   ;Action    ;
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
      { 17      ;2   ;Action    ;
                      Name=CRMSynchronizeNow;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Synkroniser;
                                 ENU=Synchronize];
                      ToolTipML=[DAN=Send de opdaterede data til Dynamics 365 for Sales.;
                                 ENU=Send updated data to Dynamics 365 for Sales.];
                      ApplicationArea=#Suite;
                      Image=Refresh;
                      OnAction=VAR
                                 Resource@1000 : Record 156;
                                 CRMIntegrationManagement@1001 : Codeunit 5330;
                                 ResourceRecordRef@1003 : RecordRef;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Resource);
                                 Resource.NEXT;

                                 IF Resource.COUNT = 1 THEN
                                   CRMIntegrationManagement.UpdateOneNow(Resource.RECORDID)
                                 ELSE BEGIN
                                   ResourceRecordRef.GETTABLE(Resource);
                                   CRMIntegrationManagement.UpdateMultipleNow(ResourceRecordRef);
                                 END
                               END;
                                }
      { 15      ;2   ;ActionGroup;
                      Name=Coupling;
                      CaptionML=[@@@=Coupling is a noun;
                                 DAN=Sammenkëdning;
                                 ENU=Coupling];
                      ToolTipML=[DAN=Opret, rediger eller slet en sammenkëdning mellem Microsoft Dynamics NAV-recorden og en Dynamics 365 for Sales-record.;
                                 ENU=Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.];
                      Image=LinkAccount }
      { 13      ;3   ;Action    ;
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
      { 11      ;3   ;Action    ;
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
      { 24      ;2   ;Action    ;
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
      { 28      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Priser;
                                 ENU=&Prices];
                      Image=Price }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Kostpriser;
                                 ENU=Costs];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om omkostninger for ressourcen.;
                                 ENU=View or change detailed information about costs for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 203;
                      RunPageLink=Type=CONST(Resource),
                                  Code=FIELD(No.);
                      Image=ResourceCosts }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Salgspriser;
                                 ENU=Prices];
                      ToolTipML=[DAN=Vis eller rediger priser for ressourcen.;
                                 ENU=View or edit prices for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 204;
                      RunPageLink=Type=CONST(Resource),
                                  Code=FIELD(No.);
                      Image=Price }
      { 27      ;1   ;ActionGroup;
                      CaptionML=[DAN=Plan&lëgn.;
                                 ENU=Plan&ning];
                      Image=Planning }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=Ressource&kapacitet;
                                 ENU=Resource &Capacity];
                      ToolTipML=[DAN=Vis sagens ressourcekapacitet.;
                                 ENU=View this job's resource capacity.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 213;
                      RunPageOnRec=Yes;
                      Image=Capacity }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Ressource allokeret pÜ service&ordre;
                                 ENU=Resource Allocated per Service &Order];
                      ToolTipML=[DAN=Vis serviceordrens tildelinger for ressourcen.;
                                 ENU=View the service order allocations of the resource.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6008;
                      RunPageLink=Resource Filter=FIELD(No.);
                      Image=ViewServiceOrder }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=Ressource&disponering;
                                 ENU=Resource A&vailability];
                      ToolTipML=[DAN=Vis en oversigt over ressourcekapaciteter, antallet af ressourcetimer, der er allokeret til sager i ordre, det antal, der er allokeret til serviceordrer, den kapacitet, der er tildelt til sager i tilbud, og ressourcetilgëngelighed.;
                                 ENU=View a summary of resource capacities, the quantity of resource hours allocated to jobs on order, the quantity allocated to service orders, the capacity assigned to jobs on quote, and the resource availability.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 225;
                      RunPageLink=No.=FIELD(No.),
                                  Unit of Measure Filter=FIELD(Unit of Measure Filter),
                                  Chargeable Filter=FIELD(Chargeable Filter);
                      Image=Calendar }
      { 1900000005;0 ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 1907665105;1 ;Action    ;
                      CaptionML=[DAN=Ny ressourcegruppe;
                                 ENU=New Resource Group];
                      ToolTipML=[DAN=Opret en ny ressource.;
                                 ENU=Create a new resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 72;
                      Promoted=Yes;
                      Image=NewResourceGroup;
                      PromotedCategory=New;
                      RunPageMode=Create }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1902833306;1 ;Action    ;
                      CaptionML=[DAN=Ressource - stamoplysninger;
                                 ENU=Resource - List];
                      ToolTipML=[DAN=Vis listen over ressourcer.;
                                 ENU=View the list of resources.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1101;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
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
      { 1902197906;1 ;Action    ;
                      CaptionML=[DAN=Ressource - prisliste;
                                 ENU=Resource - Price List];
                      ToolTipML=[DAN=Angiver en liste over enhedspriser for de valgte ressourcer. Som standard baseres en enhedspris pÜ prisen i vinduet Ressourcesalgspriser. Hvis der ikke findes en alternativ gyldig pris, bruges enhedsprisen fra ressourcekortet. Rapporten kan bruges af virksomhedens sëlger eller sendes til debitorer.;
                                 ENU=Specifies a list of unit prices for the selected resources. By default, a unit price is based on the price in the Resource Prices window. If there is no valid alternative price, then the unit price from the resource card is used. The report can be used by the company's salespeople or sent to customers.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1115;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1900862106;1 ;Action    ;
                      CaptionML=[DAN=Ressourcejournal;
                                 ENU=Resource Register];
                      ToolTipML=[DAN=Vis en liste over alle ressourcejournaler. Hver gang en ressourcepost bliver bogfõrt, oprettes der en ressourcejournal. Hver journal viser det fõrste og sidste lõbenummer for posterne i den. Du kan bruge oplysningerne i en ressourcejournal til at dokumentere, hvornÜr posterne er bogfõrt.;
                                 ENU=View a list of all the resource registers. Every time a resource entry is posted, a register is created. Every register shows the first and last entry numbers of its entries. You can use the information in a resource register to document when entries were posted.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1103;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 3       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 7       ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret timesedler;
                                 ENU=Create Time Sheets];
                      ToolTipML=[DAN=Opret nye timesedler for den valgte ressource.;
                                 ENU=Create new time sheets for the selected resource.];
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
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Jobs;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af ressourcen.;
                           ENU=Specifies a description of the resource.];
                ApplicationArea=#Jobs;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om ressourcen er en person eller en maskine.;
                           ENU=Specifies whether the resource is a person or a machine.];
                ApplicationArea=#Jobs;
                SourceExpr=Type }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den basisenhed, der bruges til at mÜle ressourcen, f.eks. time, stik. eller kilometer.;
                           ENU=Specifies the base unit used to measure the resource, such as hour, piece, or kilometer.];
                ApplicationArea=#Jobs;
                SourceExpr="Base Unit of Measure" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ressourcegruppe, som denne ressource er tilknyttet.;
                           ENU=Specifies the resource group that this resource is assigned to.];
                ApplicationArea=#Jobs;
                SourceExpr="Resource Group No.";
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Jobs;
                SourceExpr="Direct Unit Cost";
                Visible=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste kõbspris, der omfatter indirekte omkostninger, sÜsom fragt, der er knyttet til kõbet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Jobs;
                SourceExpr="Indirect Cost %";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver relationen mellem felterne Kostpris, Enhedspris og Avancepct. for denne ressource.;
                           ENU=Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this resource.];
                ApplicationArea=#Jobs;
                SourceExpr="Price/Profit Calculation" }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dëkningsgrad, du vil sëlge ressourcen til. Du kan angive en avanceprocent manuelt eller fÜ den angivet i henhold til feltet Avancepct.beregning.;
                           ENU=Specifies the profit margin that you want to sell the resource at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field];
                ApplicationArea=#Jobs;
                SourceExpr="Profit %" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for Çn enhed af varen eller ressourcen. Du kan angive en pris manuelt eller fÜ den angivet i henhold til feltet Avancepct.beregning pÜ det dertilhõrende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Price" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="Gen. Prod. Posting Group" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.;
                           ENU=Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.];
                ApplicationArea=#Jobs;
                SourceExpr="Privacy Blocked";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at sõge efter den õnskede record, hvis du ikke kan huske vërdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Jobs;
                SourceExpr="Search Name" }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Standardperiodiseringsskabelon;
                           ENU=Default Deferral Template];
                ToolTipML=[DAN=Angiver den standardskabelon, der styrer, hvordan indtjening og udgifter periodiseres til de perioder, hvor de indtrëffer.;
                           ENU=Specifies the default template that governs how to defer revenues and expenses to the periods when they occurred.];
                ApplicationArea=#Jobs;
                SourceExpr="Default Deferral Template Code" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1906609707;1;Part   ;
                ApplicationArea=#Jobs;
                SubPageLink=No.=FIELD(No.),
                            Chargeable Filter=FIELD(Chargeable Filter),
                            Service Zone Filter=FIELD(Service Zone Filter),
                            Unit of Measure Filter=FIELD(Unit of Measure Filter);
                PagePartID=Page9107;
                Visible=TRUE;
                PartType=Page }

    { 1907012907;1;Part   ;
                ApplicationArea=#Jobs;
                SubPageLink=No.=FIELD(No.),
                            Chargeable Filter=FIELD(Chargeable Filter),
                            Service Zone Filter=FIELD(Service Zone Filter),
                            Unit of Measure Filter=FIELD(Unit of Measure Filter);
                PagePartID=Page9108;
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
      CRMIntegrationEnabled@1001 : Boolean;
      CRMIsCoupledToRecord@1000 : Boolean;

    BEGIN
    END.
  }
}

