OBJECT Page 9011 Shop Supervisor Mfg Foundation
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_SHOPSUPERVISOR-FOUNDATION""}";
               DAN=Tilsynsfõrende - produktionsfond;
               ENU=Shop Supervisor - Manufacturing Foundation];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 43      ;1   ;Action    ;
                      CaptionML=[DAN=Produktionsordre - &mankoliste;
                                 ENU=Production Order - &Shortage List];
                      ToolTipML=[DAN=Vis en liste med antallet af manglende varer pr. produktionsordre. Rapporten giver et overblik over lagerdisponeringen fra dags dato indtil en bestemt dato - f.eks. hvilke ordrer der endnu er Übne.;
                                 ENU=View a list of the missing quantity per production order. The report shows how the inventory development is planned from today until the set day - for example whether orders are still open.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000788;
                      Image=Report }
      { 45      ;1   ;Action    ;
                      CaptionML=[DAN=U.leverandõr - ordreover&sigt;
                                 ENU=Subcontractor - Dis&patch List];
                      ToolTipML=[DAN=Vis oversigten over materiale, der skal sendes til produktionsunderleverandõrer.;
                                 ENU=View the list of material to be sent to manufacturing subcontractors.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000789;
                      Image=Report }
      { 42      ;1   ;Separator  }
      { 47      ;1   ;Action    ;
                      CaptionML=[DAN=Produktions&ordre - beregning;
                                 ENU=Production &Order Calculation];
                      ToolTipML=[DAN=Vis en oversigt over produktionsordrerne og deres kostpriser De forventede driftsomkostninger, forventede komponentomkostninger og de samlede kostpriser udskrives.;
                                 ENU=View a list of the production orders and their costs. Expected Operation Costs, Expected Component Costs and Total Costs are printed.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000767;
                      Image=Report }
      { 48      ;1   ;Action    ;
                      CaptionML=[DAN=S&tatus;
                                 ENU=S&tatus];
                      ToolTipML=[DAN=Vis produktionsordrer efter status.;
                                 ENU=View production orders by status.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 706;
                      Image=Report }
      { 49      ;1   ;Action    ;
                      CaptionML=[DAN=Vare&journaler - antal;
                                 ENU=&Item Registers - Quantity];
                      ToolTipML=[DAN=Vis alle vareposter.;
                                 ENU=View all item ledger entries.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 703;
                      Image=Report }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=Lagervërdi - igangvërende &arb.;
                                 ENU=Inventory Valuation &WIP];
                      ToolTipML=[DAN=FÜ vist lagervërdien pÜ udvalgte produktionsordrer i VIA-lagerbeholdningen. Rapporten indeholder ogsÜ oplysninger om forbrugsvërdi, kapacitetsudnyttelse og afgang i VIA-vërdien. Den udskrevne rapport viser kun fakturerede belõb, det vil sige kõbsprisen for poster, der er bogfõrt som fakturerede.;
                                 ENU=View inventory valuation for selected production orders in your WIP inventory. The report also shows information about the value of consumption, capacity usage and output in WIP. The printed report only shows invoiced amounts, that is, the cost of entries that have been posted as invoiced.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 5802;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 31      ;1   ;Action    ;
                      CaptionML=[DAN=Simulerede produktionsordrer;
                                 ENU=Simulated Production Orders];
                      ToolTipML=[DAN=Vis listen med igangvërende simulerede produktionsordrer.;
                                 ENU=View the list of ongoing simulated production orders.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9323 }
      { 32      ;1   ;Action    ;
                      CaptionML=[DAN=Planlagte produktionsordrer;
                                 ENU=Planned Production Orders];
                      ToolTipML=[DAN=Vis oversigten over produktionsordrer med statussen Planlagt.;
                                 ENU=View the list of production orders with status Planned.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9324 }
      { 33      ;1   ;Action    ;
                      CaptionML=[DAN=Fastlagte produktionsordrer;
                                 ENU=Firm Planned Production Orders];
                      ToolTipML=[DAN="Vis fuldfõrte produktionsordrer. ";
                                 ENU="View completed production orders. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9325 }
      { 34      ;1   ;Action    ;
                      CaptionML=[DAN=Frigivne produktionsordrer;
                                 ENU=Released Production Orders];
                      ToolTipML=[DAN=Vis listen over frigivne produktionsordrer, som er klar til lageraktiviteter.;
                                 ENU=View the list of released production order that are ready for warehouse activities.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9326 }
      { 35      ;1   ;Action    ;
                      CaptionML=[DAN=Fërdige produktionsordrer;
                                 ENU=Finished Production Orders];
                      ToolTipML=[DAN="Vis fuldfõrte produktionsordrer. ";
                                 ENU="View completed production orders. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9327 }
      { 2       ;1   ;Action    ;
                      Name=Items;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 31;
                      Image=Item }
      { 37      ;1   ;Action    ;
                      Name=ItemsProduced;
                      CaptionML=[DAN=Produceret;
                                 ENU=Produced];
                      ToolTipML=[DAN=Vis oversigten over produktionsvarer.;
                                 ENU=View the list of production items.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 31;
                      RunPageView=WHERE(Replenishment System=CONST(Prod. Order)) }
      { 94      ;1   ;Action    ;
                      Name=ItemsRawMaterials;
                      CaptionML=[DAN=RÜvarer;
                                 ENU=Raw Materials];
                      ToolTipML=[DAN=Vis oversigten over varer, der ikke er styklister.;
                                 ENU=View the list of items that are not bills of material.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 31;
                      RunPageView=WHERE(Low-Level Code=FILTER(>0),
                                        Replenishment System=CONST(Purchase),
                                        Production BOM No.=FILTER(='')) }
      { 95      ;1   ;Action    ;
                      CaptionML=[DAN=Lagervarer;
                                 ENU=Stockkeeping Units];
                      ToolTipML=[DAN="èbn oversigten over lagervarer for varen for at vise eller redigere forekomster af varen pÜ forskellige lokationer eller med forskellige varianter. ";
                                 ENU="Open the list of item SKUs to view or edit instances of item at different locations or with different variants. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5701;
                      Image=SKU }
      { 3       ;1   ;Action    ;
                      Name=ProductionBOM;
                      CaptionML=[DAN=Produktionsstykliste;
                                 ENU=Production BOM];
                      ToolTipML=[DAN=èbn varens produktionsstykliste for at vise eller redigere dens komponenter.;
                                 ENU=Open the item's production bill of material to view or edit its components.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000787;
                      Image=BOM }
      { 15      ;1   ;Action    ;
                      Name=ProductionBOMUnderDevelopment;
                      CaptionML=[DAN=Under udvikling;
                                 ENU=Under Development];
                      ToolTipML=[DAN=Vis oversigten over produktionsstyklister, der ikke er endnu er godkendt.;
                                 ENU=View the list of production BOMs that are not yet certified.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000787;
                      RunPageView=WHERE(Status=CONST(Under Development)) }
      { 63      ;1   ;Action    ;
                      Name=ProductionBOMCertified;
                      CaptionML=[DAN=Certificeret;
                                 ENU=Certified];
                      ToolTipML=[DAN=Vis listen over godkendte produktionsstyklister.;
                                 ENU=View the list of certified production BOMs.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000787;
                      RunPageView=WHERE(Status=CONST(Certified)) }
      { 97      ;1   ;Action    ;
                      CaptionML=[DAN=Arbejdscentre;
                                 ENU=Work Centers];
                      ToolTipML=[DAN=Vis eller rediger listen over arbejdscentre.;
                                 ENU=View or edit the list of work centers.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000755 }
      { 83      ;1   ;Action    ;
                      CaptionML=[DAN=Ruter;
                                 ENU=Routings];
                      ToolTipML=[DAN=FÜ vist eller rediger driftsprocesser og behandlingstider for producerede varer.;
                                 ENU=View or edit operation sequences and process times for produced items.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000764 }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. Salgsordrer gõr det i modsëtning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
                                 ENU=Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9305;
                      Image=Order }
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=Kõbsordrer;
                                 ENU=Purchase Orders];
                      ToolTipML=[DAN=Opret kõbsordrer for at afspejle de salgsbilag, som leverandõrer sender til dig. PÜ denne mÜde kan du registrere kõbsomkostninger og spore kreditorer. Bogfõringen af kõbsordrer opdaterer lagerniveauerne dynamisk, sÜ du kan minimere lageromkostningerne og levere bedre kundeservice. Kõbsordrer tillader delleverancer, modsat kõbsfakturaer, og muliggõr direkte levering fra kreditoren til debitoren. Kõbsordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag.;
                                 ENU=Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9307 }
      { 106     ;1   ;Action    ;
                      CaptionML=[DAN=Overflytningsordrer;
                                 ENU=Transfer Orders];
                      ToolTipML=[DAN=Flyt lagervarer mellem lokationer for virksomheden. Med overflytningsordrer kan du sende udgÜende overflytninger fra Çn lokation og modtage den indgÜende overfõrsel pÜ den anden lokation. Derved kan du administrere de involverede lageraktiviteter, og det õger sikkerheden for, at vareantallet opdateres korrekt.;
                                 ENU=Move inventory items between company locations. With transfer orders, you ship the outbound transfer from one location and receive the inbound transfer at the other location. This allows you to manage the involved warehouse activities and provides more certainty that inventory quantities are updated correctly.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5742;
                      Image=Document }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=Lëg-pÜ-lager-akt. (lager);
                                 ENU=Inventory Put-aways];
                      ToolTipML=[DAN="Vis igangvërende lëg-pÜ-lager-vareaktiviteter til placeringer i henhold til en grundlëggende lagerkonfiguration. ";
                                 ENU="View ongoing put-aways of items to bins according to a basic warehouse configuration. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9315 }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=Pluk (lager);
                                 ENU=Inventory Picks];
                      ToolTipML=[DAN="Vis igangvërende varepluk fra placeringer i henhold til en grundlëggende lagerkonfiguration. ";
                                 ENU="View ongoing picks of items from bins according to a basic warehouse configuration. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9316 }
      { 29      ;1   ;Action    ;
                      CaptionML=[DAN=Standardkostpriskladder;
                                 ENU=Standard Cost Worksheets];
                      ToolTipML=[DAN=Gennemse eller opdater standardomkostninger. Indkõbere, produktions- eller montageadministratorer kan bruge kladden til at simulere indflydelsen pÜ kostprisen pÜ den producerede eller samlede vare, hvis standardkostprisen for forbrug, produktionskapacitetsforbruget eller montageressourceforbruget ëndres. Du kan angive, at en kostprisëndring fõrst trëder i kraft pÜ en bestemt dato.;
                                 ENU=Review or update standard costs. Purchasers, production or assembly managers can use the worksheet to simulate the effect on the cost of the manufactured or assembled item if the standard cost for consumption, production capacity usage, or assembly resource usage is changed. You can set a cost change to take effect on a specified date.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5840 }
      { 22      ;1   ;Action    ;
                      Name=SubcontractingWorksheets;
                      CaptionML=[DAN=Underleverandõrkladder;
                                 ENU=Subcontracting Worksheets];
                      ToolTipML=[DAN=Beregn den nõdvendige produktionsforsyning, find de produktionsordrer med materiale, der allerede er parat til afsendelse til en underleverandõr, og opret automatisk kõbsordrer pÜ operationer fra produktionsordreruter, der skal udfõres hos en underleverandõr.;
                                 ENU=Calculate the needed production supply, find the production orders that have material ready to send to a subcontractor, and automatically create purchase orders for subcontracted operations from production order routings.];
                      ApplicationArea=#Planning;
                      RunObject=Page 295;
                      RunPageView=WHERE(Template Type=CONST(For. Labor),
                                        Recurring=CONST(No)) }
      { 20      ;1   ;Action    ;
                      Name=RequisitionWorksheets;
                      CaptionML=[DAN=Indkõbskladder;
                                 ENU=Requisition Worksheets];
                      ToolTipML=[DAN=Beregn en forsyningsplan for at opfylde varebehov via indkõb eller overfõrsler.;
                                 ENU=Calculate a supply plan to fulfill item demand with purchases or transfers.];
                      ApplicationArea=#Planning;
                      RunObject=Page 295;
                      RunPageView=WHERE(Template Type=CONST(Req.),
                                        Recurring=CONST(No)) }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kladder;
                                 ENU=Journals];
                      Image=Journals }
      { 38      ;2   ;Action    ;
                      Name=RevaluationJournals;
                      CaptionML=[DAN=Vërdireguleringskladder;
                                 ENU=Revaluation Journals];
                      ToolTipML=[DAN=Ret lagervërdien af varer, f.eks. nÜr du har foretaget en fysisk lageropgõrelse.;
                                 ENU=Change the inventory value of items, for example after doing a physical inventory.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Revaluation),
                                        Recurring=CONST(No)) }
      { 46      ;2   ;Action    ;
                      Name=ConsumptionJournals;
                      CaptionML=[DAN=Forbrugskladder;
                                 ENU=Consumption Journals];
                      ToolTipML=[DAN=Bogfõr forbrug af materiale i takt med, at operationer udfõres.;
                                 ENU=Post the consumption of material as operations are performed.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Consumption),
                                        Recurring=CONST(No)) }
      { 51      ;2   ;Action    ;
                      Name=OutputJournals;
                      CaptionML=[DAN=Afgangskladder;
                                 ENU=Output Journals];
                      ToolTipML=[DAN="Bogfõr fërdigvarer og tidsforbrug i produktionen. ";
                                 ENU="Post finished end items and time spent in production. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Output),
                                        Recurring=CONST(No)) }
      { 52      ;2   ;Action    ;
                      Name=RecurringConsumptionJournals;
                      CaptionML=[DAN=Forbrugsgentagelseskladder;
                                 ENU=Recurring Consumption Journals];
                      ToolTipML=[DAN=Bogfõr forbrug af materiale i takt med, at operationer udfõres.;
                                 ENU=Post the consumption of material as operations are performed.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Consumption),
                                        Recurring=CONST(Yes)) }
      { 53      ;2   ;Action    ;
                      Name=RecurringOutputJournals;
                      CaptionML=[DAN=Afgangsgentagelseskladder;
                                 ENU=Recurring Output Journals];
                      ToolTipML=[DAN=Vis alle afgangsgentagelseskladder.;
                                 ENU=View all recurring output journals.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Output),
                                        Recurring=CONST(Yes)) }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Administration];
                      Image=Administration }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=Arbejdsskift;
                                 ENU=Work Shifts];
                      ToolTipML=[DAN=Vis eller rediger de arbejdsskift, der kan tildeles til produktionskalendere.;
                                 ENU=View or edit the work shifts that can be assigned to shop calendars.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000750 }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=Produktionskalendere;
                                 ENU=Shop Calendars];
                      ToolTipML=[DAN=Vis eller rediger listen over produktionsressource- eller arbejdscenterkalendere.;
                                 ENU=View or edit the list of machine or work center calendars.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000751 }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Arbejdscentergrupper;
                                 ENU=Work Center Groups];
                      ToolTipML=[DAN=Vis eller rediger listen over arbejdscentergrupper.;
                                 ENU=View or edit the list of work center groups.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000758 }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=Stopkoder;
                                 ENU=Stop Codes];
                      ToolTipML=[DAN=Vis eller rediger koder til identifikation af de forskellige produktionsressource eller produktionsfejlÜrsager, som du kan bogfõre pÜ afgangskladde- og kapacitetskladdelinjer.;
                                 ENU=View or edit codes to identify different machine or shop center failure reasons, which you can post with output journal and capacity journal lines.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000779 }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=Spildkoder;
                                 ENU=Scrap Codes];
                      ToolTipML=[DAN=Definer spildkoder for at identificere forskellige Ürsager til, hvorfor der forekommer spild. NÜr du har konfigureret spildkoderne, kan du angive dem pÜ bogfõringslinjerne i afgangskladden og kapacitetskladden.;
                                 ENU=Define scrap codes to identify different reasons for why scrap has been produced. After you have set up the scrap codes, you can enter them in the posting lines of the output journal and the capacity journal.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000780 }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=Standardoperationer;
                                 ENU=Standard Tasks];
                      ToolTipML=[DAN=Vis eller rediger standardproduktionsoperationer.;
                                 ENU=View or edit standard production operations.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000799 }
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=&Produktionsordre;
                                 ENU=Production &Order];
                      ToolTipML=[DAN=Opret en ny produktionsordre for at sikre forsyning af en produceret vare.;
                                 ENU=Create a new production order to supply a produced item.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000813;
                      Promoted=No;
                      Image=Order;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 4       ;1   ;Action    ;
                      CaptionML=[DAN=Kõbs&ordre;
                                 ENU=P&urchase Order];
                      ToolTipML=[DAN=Opret en ny kõbsordre.;
                                 ENU=Create a new purchase order.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 50;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 67      ;1   ;Separator ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      IsHeader=Yes }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Forbr&ugskladde;
                                 ENU=Co&nsumption Journal];
                      ToolTipML=[DAN=Bogfõr forbrug af materiale i takt med, at operationer udfõres.;
                                 ENU=Post the consumption of material as operations are performed.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000846;
                      Image=ConsumptionJournal }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=&Afgangskladde;
                                 ENU=Output &Journal];
                      ToolTipML=[DAN="Bogfõr fërdigvarer og tidsforbrug i produktionen. ";
                                 ENU="Post finished end items and time spent in production. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000823;
                      Image=OutputJournal }
      { 9       ;1   ;Separator  }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Indkõbsklad&de;
                                 ENU=Requisition &Worksheet];
                      ToolTipML=[DAN=Beregn en forsyningsplan for at opfylde varebehov via indkõb eller overfõrsler.;
                                 ENU=Calculate a supply plan to fulfill item demand with purchases or transfers.];
                      ApplicationArea=#Planning;
                      RunObject=Page 291;
                      Image=Worksheet }
      { 123     ;1   ;Action    ;
                      CaptionML=[DAN=Ordre&planlëgning;
                                 ENU=Order &Planning];
                      ToolTipML=[DAN=Planlëg forsyningsordrer ordre for ordre for at opfylde nye behov.;
                                 ENU=Plan supply orders order by order to fulfill new demand.];
                      ApplicationArea=#Planning;
                      RunObject=Page 5522;
                      Image=Planning }
      { 28      ;1   ;Separator  }
      { 26      ;1   ;Action    ;
                      CaptionML=[DAN=Skift prod.o&rdrestatus;
                                 ENU=&Change Production Order Status];
                      ToolTipML=[DAN=Skift status for flere produktionsordrer, f.eks. fra planlagt til frigivet.;
                                 ENU=Change the status of multiple production orders, for example from Planned to Released.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000914;
                      Image=ChangeStatus }
      { 110     ;1   ;Separator ;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Administration];
                      IsHeader=Yes }
      { 111     ;1   ;Action    ;
                      CaptionML=[DAN=Produk&tionsopsëtning;
                                 ENU=Manu&facturing Setup];
                      ToolTipML=[DAN=Definer virksomhedens politikker for produktion, f.eks. standardsikkerhedstiden og om advarsler vises i planlëgningskladden.;
                                 ENU=Define company policies for manufacturing, such as the default safety lead time and whether warnings are displayed in the planning worksheet.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000768;
                      Image=ProductionSetup }
      { 89      ;1   ;Separator ;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      IsHeader=Yes }
      { 126     ;1   ;Action    ;
                      CaptionML=[DAN=&Varesporing;
                                 ENU=Item &Tracing];
                      ToolTipML=[DAN=Spor, hvor en lot- eller et serienummer, som varen er blevet tildelt, blev anvendt, eksempelvis for at finde ud af, hvilket lot en defekt komponent stammer fra, eller for at finde alle de debitorer, som har modtaget varer, der indeholder den defekte komponent.;
                                 ENU=Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 6520;
                      Image=ItemTracing }
      { 90      ;1   ;Action    ;
                      CaptionML=[DAN=Navi&ger;
                                 ENU=Navi&gate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 344;
                      Image=Navigate }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 1907234908;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9044;
                PartType=Page }

    { 1905989608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9152;
                PartType=Page }

    { 1900724708;1;Group   }

    { 21  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 27  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page681;
                Visible=FALSE;
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

