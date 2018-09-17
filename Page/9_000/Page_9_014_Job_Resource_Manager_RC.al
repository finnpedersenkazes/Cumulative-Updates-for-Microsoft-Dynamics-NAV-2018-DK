OBJECT Page 9014 Job Resource Manager RC
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_RESOURCEMANAGER""}";
               DAN=Personalechef;
               ENU=Resource Manager];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Ressource&statistik;
                                 ENU=Resource &Statistics];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om forbrug og salg af hver ressource. Vinduet Ressourcestatistik viser bÜde antal enheder og de tilsvarende belõb.;
                                 ENU=View detailed information about usage and sales of each resource. The Resource Statistics window shows both the units of measure and the corresponding amounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1105;
                      Image=Report }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=Ressource&forbrug;
                                 ENU=Resource &Utilization];
                      ToolTipML=[DAN="Vis statistiske oplysninger om forbruget af hver ressource. Ressourcens forbrugsantal sammenlignes med dens kapacitet og disponible kapacitet (i feltet Saldo) i overensstemmelse med denne formel: saldo = kapacitet - forbrug (antal)";
                                 ENU="View statistical information about the usage of each resource. The resource's usage quantity is compared with its capacity and the remaining capacity (in the Balance field), according to this formula: Balance = Capacity - Usage (Qty.)"];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1106;
                      Image=Report }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Ressource - &prisliste;
                                 ENU=Resource - &Price List];
                      ToolTipML=[DAN=Vis en liste over enhedspriser for ressourcerne. Som standard baseres en enhedspris pÜ prisen i vinduet Ressourcesalgspriser. Hvis der ikke findes en alternativ gyldig pris, bruges enhedsprisen fra ressourcekortet. Rapporten kan bruges af virksomhedens sëlger eller sendes til debitorer.;
                                 ENU=View a list of unit prices for the resources. By default, a unit price is based on the price in the Resource Prices window. If there is no valid alternative price, then the unit price from the resource card is used. The report can be used by the company's salespeople or sent to customers.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1101;
                      Image=Report }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Ressource - lõn&grundlag;
                                 ENU=Resource - Cost &Breakdown];
                      ToolTipML=[DAN=Vis kõbsprisen pr. enhed og de samlede direkte omkostninger for den enkelte ressource. Der medtages kun bogfõring af forbrug i denne rapport. Ressourceforbrug kan vëre bogfõrt i ressourcekladden eller i sagskladden.;
                                 ENU=View the direct unit costs and the total direct costs for each resource. Only usage postings are considered in this report. Resource usage can be posted in the resource journal or the job journal.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1107;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 13      ;1   ;Action    ;
                      Name=Resources;
                      CaptionML=[DAN=Ressourcer;
                                 ENU=Resources];
                      ToolTipML=[DAN=Administrer dine ressourcers sagsaktiviteter ved at angive deres omkostninger og priser. Reglerne for sagsrelaterede pris-, rabat- og kostfaktorer konfigureres for de respektive jobkort. Du kan angive omkostninger og priser for individuelle ressourcer, ressourcegrupper eller alle tilgëngelige ressourcer i virksomheden. NÜr ressourcerne anvendes eller sëlges i en sag, registreres de angivne priser og omkostninger for projektet.;
                                 ENU=Manage your resources' job activities by setting up their costs and prices. The job-related prices, discounts, and cost factor rules are set up on the respective job card. You can specify the costs and prices for individual resources, resource groups, or all available resources of the company. When resources are used or sold in a job, the specified prices and costs are recorded for the project.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 77 }
      { 14      ;1   ;Action    ;
                      Name=ResourcesPeople;
                      CaptionML=[DAN=Personer;
                                 ENU=People];
                      ToolTipML=[DAN=Vis listen over personer, der kan tildeles til sager.;
                                 ENU=View the list of people that can be assigned to jobs.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 77;
                      RunPageView=WHERE(Type=FILTER(Person)) }
      { 15      ;1   ;Action    ;
                      Name=ResourcesMachines;
                      CaptionML=[DAN=Maskiner;
                                 ENU=Machines];
                      ToolTipML=[DAN=Vis listen over maskiner, der kan tildeles til sager.;
                                 ENU=View the list of machines that can be assigned to jobs.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 77;
                      RunPageView=WHERE(Type=FILTER(Machine)) }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Ressourcegrupper;
                                 ENU=Resource Groups];
                      ToolTipML=[DAN=Vis alle ressourcegrupper.;
                                 ENU=View all resource groups.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 72 }
      { 35      ;1   ;Action    ;
                      Name=ResourceJournals;
                      CaptionML=[DAN=Ressourcekladder;
                                 ENU=Resource Journals];
                      ToolTipML=[DAN=Vis alle ressourcekladder.;
                                 ENU=View all resource journals.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 272;
                      RunPageView=WHERE(Recurring=CONST(No)) }
      { 36      ;1   ;Action    ;
                      Name=RecurringResourceJournals;
                      CaptionML=[DAN=Ressourcegentagelseskladder;
                                 ENU=Recurring Resource Journals];
                      ToolTipML=[DAN=Vis alle ressourcegentagelseskladder.;
                                 ENU=View all recurring resource journals.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 272;
                      RunPageView=WHERE(Recurring=CONST(Yes)) }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Sager;
                                 ENU=Jobs];
                      ToolTipML=[DAN=Definer en projektaktivitet ved at oprette et sagskort med integrerede sagsopgaver og sagsplanlëgningslinjer, opdelt i to lag. Sagsopgaven giver dig mulighed for at konfigurere sagsplanlëgningslinjer og bogfõre forbrug for sagen. Sagsplanlëgningslinjer angiver brugen af ressourcer, varer og forskellige finansudgifter i detaljer.;
                                 ENU=Define a project activity by creating a job card with integrated job tasks and job planning lines, structured in two layers. The job task enables you to set up job planning lines and to post consumption to the job. The job planning lines specify the detailed use of resources, items, and various general ledger expenses.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 89;
                      Image=Job }
      { 1       ;1   ;Action    ;
                      CaptionML=[DAN=Timesedler;
                                 ENU=Time Sheets];
                      ToolTipML=[DAN=Giv ressourcer mulighed for at tidsregistere. Efter godkendelsen, hvis en sÜdan krëves, kan timeseddelposterne bogfõres for den relevante sagskladde eller ressourcekladde som en del af registreringen af projektforlõbet. Hvis du vil spare konfigurationstid og sikre, at dataene er korrekte, kan du kopiere sagsplanlëgningslinjerne til timesedlerne.;
                                 ENU=Enable resources to register time. When approved, if approval is required, time sheet entries can be posted to the relevant job journal or resource journal as part of project progress reporting. To save setup time and to ensure data correctness, you can copy job planning lines into time sheets.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 951 }
      { 25      ;1   ;Action    ;
                      Name=Page Time Sheet List Open;
                      CaptionML=[DAN=èbn;
                                 ENU=Open];
                      ToolTipML=[DAN=èbn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Open Exists=CONST(Yes)) }
      { 24      ;1   ;Action    ;
                      Name=Page Time Sheet List Submitted;
                      CaptionML=[DAN=Sendt;
                                 ENU=Submitted];
                      ToolTipML=[DAN=FÜ vist sendte timesedler.;
                                 ENU=View submitted time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Submitted Exists=CONST(Yes)) }
      { 23      ;1   ;Action    ;
                      Name=Page Time Sheet List Rejected;
                      CaptionML=[DAN=Afvist;
                                 ENU=Rejected];
                      ToolTipML=[DAN=FÜ vist afviste timesedler.;
                                 ENU=View rejected time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Rejected Exists=CONST(Yes)) }
      { 21      ;1   ;Action    ;
                      Name=Page Time Sheet List Approved;
                      CaptionML=[DAN=Godkendt;
                                 ENU=Approved];
                      ToolTipML=[DAN=FÜ vist godkendte timesedler.;
                                 ENU=View approved time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Approved Exists=CONST(Yes)) }
      { 4       ;1   ;Action    ;
                      CaptionML=[DAN=Leders timesedler;
                                 ENU=Manager Time Sheets];
                      ToolTipML=[DAN=èbn listen med dine timesedler.;
                                 ENU=Open the list of your time sheets.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 953 }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 61      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Administration];
                      Image=Administration }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Ressourcekostpriser;
                                 ENU=Resource Costs];
                      ToolTipML=[DAN=Vis eller rediger alternative kostpriser for ressourcer. Ressourcekostpriser kan gëlde for alle ressourcer, for ressourcegrupper eller for en bestemt ressource. Du kan ogsÜ filtrere dem, sÜ de kun gëlder for bestemte arbejdstypekoder. Hvis en medarbejder f.eks. har en anden timesats for overarbejde, kan du i dette vindue oprette en ressourcekostpris for den pÜgëldende arbejdstype.;
                                 ENU=View or edit alternate costs for resources. Resource costs can apply to all resources, to resource groups or to individual resources. They can also be filtered so that they apply only to a specific work type code. For example, if an employee has a different hourly rate for overtime work, you can set up a resource cost for this work type.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 203 }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Ressourcesalgspriser;
                                 ENU=Resource Prices];
                      ToolTipML=[DAN=Vis ressourcepriserne.;
                                 ENU=View the prices of resources.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 204 }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Ressourceservicezoner;
                                 ENU=Resource Service Zones];
                      ToolTipML=[DAN=Vis tildelingen af ressourcer til servicezoner. NÜr du allokerer en ressource til en serviceopgave, der skal udfõres pÜ debitorens adresse, kan du vëlge en ressource, der er placeret i samme servicezone som debitoren.;
                                 ENU=View the assignment of resources to service zones. When you allocate a resource to a service task that is to be performed at the customer site, you can select a resource that is located in the same service zone as the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6021;
                      Image=Resource }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Ressourcelokationer;
                                 ENU=Resource Locations];
                      ToolTipML=[DAN=Vis, hvor ressourcer er placeret, eller tildel ressourcer til lokationer.;
                                 ENU=View where resources are located or assign resources to locations.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6015;
                      Image=Resource }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Arbejdstyper;
                                 ENU=Work Types];
                      ToolTipML=[DAN=Vis eller rediger listen over arbejdstyper, der bruges i forbindelse med registrering af forbrug og salg af ressourcer i sagskladder, ressourcekladder, pÜ salgsfakturaer osv. Arbejdstyperne beskriver de forskellige typer arbejde, som en ressource kan udfõre, f.eks. overarbejde eller kõrsel.;
                                 ENU=View or edit the list of work types that are used with the registration of both the usage and sales of resources in job journals, resource journals, sales invoices, and so on. Work types indicate the various kinds of work that a resource is capable of carrying out, such as overtime or transportation.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 208 }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 17      ;1   ;Separator ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      IsHeader=Yes }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=Reguler r&essourcepriser;
                                 ENU=Adjust R&esource Costs/Prices];
                      ToolTipML=[DAN=JustÇr indholdet af Çt eller flere felter pÜ ressourcekortet. Du kan f.eks. ëndre kõbsprisen pÜ alle ressourcer fra en bestemt ressourcegruppe med 10 procent. índringerne gennemfõres med det samme, nÜr kõrslen startes. De felter pÜ ressourcekortet, som er afhëngige af det justerede felt, ëndres ogsÜ.;
                                 ENU=Adjust one or more fields on the resource card. For example, you can change the direct unit cost by 10 percent on all resources from a specific resource group. The changes are processed immediately after the batch job is started. The fields on the resource card that are dependent on the adjusted field are also changed.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1195;
                      Image=Report }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=Ressourcep&risforslag;
                                 ENU=Resource P&rice Changes];
                      ToolTipML=[DAN=Rediger eller opdater alternative ressourcepriser ved at kõre kõrslen ForeslÜ ress.salgspris (ress.) eller kõrslen ForeslÜ ress.salgspris (pris).;
                                 ENU=Edit or update alternate resource prices, by running either the Suggest Res. Price Chg. (Res.) batch job or the Suggest Res. Price Chg. (Price) batch job.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 493;
                      Image=ResourcePrice }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=ForeslÜ ress.salgspr&is (ress.);
                                 ENU=Resource Pr&ice Chg from Resource];
                      ToolTipML=[DAN=Opdater de alternative priser i vinduet Ressourcesalgspriser med dem i vinduet Ressourceprisforslag.;
                                 ENU=Update the alternate prices in the Resource Prices window with the ones in the Resource Price Change s window.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1191;
                      Image=Report }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=F&oreslÜ ress.salgspris (pris);
                                 ENU=Resource Pri&ce Chg from Prices];
                      ToolTipML=[DAN=Opdater de alternative priser i vinduet Ressourcesalgspriser med dem i vinduet Ressourceprisforslag.;
                                 ENU=Update the alternate prices in the Resource Prices window with the ones in the Resource Price Change s window.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1192;
                      Image=Report }
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=O&pdater ressourcesalgspriser;
                                 ENU=I&mplement Resource Price Changes];
                      ToolTipML=[DAN=Opdater de alternative priser i vinduet Ressourcepriser med dem i vinduet Ressourceprisforslag. Prisëndringsforslag kan oprettes i kõrslen ForeslÜ ress.salgspris (ress.) eller ForeslÜ ress.salgspris (ress.). Du kan ogsÜ ëndre prisëndringsforslag i vinduet Ressourceprisforslag, fõr du indfõrer dem.;
                                 ENU=Update the alternate prices in the Resource Prices window with the ones in the Resource Price Changes window. Price change suggestions can be created with the Suggest Res. Price Chg.(Price) or the Suggest Res. Price Chg. (Res.) batch job. You can also modify the price change suggestions in the Resource Price Changes window before you implement them.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1193;
                      Image=ImplementPriceChange }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=Opret timesedler;
                                 ENU=Create Time Sheets];
                      ToolTipML=[DAN=Opret nye timesedler for ressourcer.;
                                 ENU=Create new time sheets for resources.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 950;
                      Image=NewTimesheet }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 1904257908;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9067;
                PartType=Page }

    { 1907692008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9150;
                PartType=Page }

    { 1900724708;1;Group   }

    { 19  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 18  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page972;
                PartType=Page }

    { 22  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page681;
                PartType=Page }

    { 1901377608;2;Part   ;
                ApplicationArea=#Advanced;
                PartType=System;
                SystemPartID=MyNotes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

