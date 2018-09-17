OBJECT Page 9010 Production Planner Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_PRODUCTIONPLANNER""}";
               DAN=Produktionsplanlëgger;
               ENU=Production Planner];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 107     ;1   ;Action    ;
                      CaptionML=[DAN=R&utediagram;
                                 ENU=Ro&uting Sheet];
                      ToolTipML=[DAN=Vis grundlëggende oplysninger om ruter, f.eks. send-ahead-antal, opstillingstid, operationstid og tidsenhed. Rapporten viser de operationer, der skal udfõres i denne rute, de produktionsressourcer eller arbejdscentre, der skal anvendes, personale, vërktõjer og beskrivelsen af hver operation.;
                                 ENU=View basic information for routings, such as send-ahead quantity, setup time, run time and time unit. This report shows you the operations to be performed in this routing, the work or machine centers to be used, the personnel, the tools, and the description of each operation.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000787;
                      Image=Report }
      { 109     ;1   ;Separator  }
      { 108     ;1   ;Action    ;
                      CaptionML=[DAN=Vare - &disponeringsoversigt;
                                 ENU=Inventory - &Availability Plan];
                      ToolTipML=[DAN=Vis en liste over antallet af de enkelte varer fordelt pÜ henholdsvis debitor-, kõbs- og overflytningsordrer, samt det antal der er disponibelt pÜ lageret. Oversigten er inddelt i kolonner, der dëkker seks perioder med angivne start- og slutdatoer, samt perioderne fõr og efter de pÜgëldende seks perioder. Listen er praktisk ved planlëgning af vareindkõb.;
                                 ENU=View a list of the quantity of each item in customer, purchase, and transfer orders and the quantity available in inventory. The list is divided into columns that cover six periods with starting and ending dates as well as the periods before and after those periods. The list is useful when you are planning your inventory purchases.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 707;
                      Image=ItemAvailability }
      { 110     ;1   ;Action    ;
                      CaptionML=[DAN=&Planlëgning - disponering;
                                 ENU=&Planning Availability];
                      ToolTipML=[DAN=Vis alle kendte krav og kõbsleverancer for den vare, du vëlger pÜ en bestemt dato. Du kan bruge rapporten til at fÜ et hurtigt billede af det aktuelle leveringsbehov for en vare. Rapporten viser varenummeret og beskrivelsen plus den aktuelle mëngde pÜ lageret.;
                                 ENU=View all known existing requirements and receipts for the items that you select on a specific date. You can use the report to get a quick picture of the current demand-supply situation for an item. The report displays the item number and description plus the actual quantity in inventory.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99001048;
                      Image=Report }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=&Kapacitet - operationsliste;
                                 ENU=&Capacity Task List];
                      ToolTipML=[DAN=Viser de produktionsordrer, der venter pÜ at blive behandlet i arbejdscentre og produktionsressourcer. Der udskrives oversigter vedrõrende kapaciteten i arbejdscenteret eller produktionsressourcen. Rapporten indeholder bl.a. oplysninger om start-/slutdato og forfaldsdato samt tilgangsantal.;
                                 ENU=View the production orders that are waiting to be processed at the work centers and machine centers. Printouts are made for the capacity of the work center or machine center). The report includes information such as starting and ending time, date per production order and input quantity.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000780;
                      Image=Report }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=U.leverandõr - &ordreoversigt;
                                 ENU=Subcontractor - &Dispatch List];
                      ToolTipML=[DAN=Vis oversigten over materiale, der skal sendes til produktionsunderleverandõrer.;
                                 ENU=View the list of material to be sent to manufacturing subcontractors.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000789;
                      Image=Report }
      { 111     ;1   ;Separator  }
      { 112     ;1   ;Action    ;
                      CaptionML=[DAN=Produktionsordre - &mankoliste;
                                 ENU=Production Order - &Shortage List];
                      ToolTipML=[DAN=Vis en liste med antallet af manglende varer pr. produktionsordre. Rapporten giver et overblik over lagerdisponeringen fra dags dato indtil en bestemt dato - f.eks. hvilke ordrer der endnu er Übne.;
                                 ENU=View a list of the missing quantity per production order. The report shows how the inventory development is planned from today until the set day - for example whether orders are still open.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000788;
                      Image=Report }
      { 49      ;1   ;Action    ;
                      CaptionML=[DAN=D&etaljeret beregning;
                                 ENU=D&etailed Calculation];
                      ToolTipML=[DAN=Vis en kostprisoversigt pr. vare under hensyntagen til spild.;
                                 ENU=View a cost list per item taking into account the scrap.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000756;
                      Image=Report }
      { 113     ;1   ;Separator  }
      { 114     ;1   ;Action    ;
                      CaptionML=[DAN=P&roduktionsordre - beregning;
                                 ENU=P&roduction Order - Calculation];
                      ToolTipML=[DAN=Vis en oversigt over produktionsordrerne og deres kostpriser, sÜsom de forventede driftsomkostninger, forventede komponentomkostninger og de samlede kostpriser.;
                                 ENU=View a list of the production orders and their costs, such as expected operation costs, expected component costs, and total costs.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000767;
                      Image=Report }
      { 115     ;1   ;Action    ;
                      CaptionML=[DAN=Sta&tus;
                                 ENU=Sta&tus];
                      ToolTipML=[DAN=Vis produktionsordrer efter status.;
                                 ENU=View production orders by status.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 706;
                      Image=Report }
      { 116     ;1   ;Action    ;
                      CaptionML=[DAN=Lager&vërdi - igangvërende arb.;
                                 ENU=Inventory &Valuation WIP];
                      ToolTipML=[DAN=Vis lagervërdien pÜ udvalgte produktionsordrer i lagerbeholdningen for igangvërende arbejde. Rapporten indeholder ogsÜ oplysninger om forbrugsvërdi, kapacitetsudnyttelse og afgang i vërdien for igangvërende arbejde.;
                                 ENU=View inventory valuation for selected production orders in your WIP inventory. The report also shows information about the value of consumption, capacity usage and output in WIP.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 5802;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Simulerede produktionsordrer;
                                 ENU=Simulated Production Orders];
                      ToolTipML=[DAN=Vis listen med igangvërende simulerede produktionsordrer.;
                                 ENU=View the list of ongoing simulated production orders.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9323 }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Planlagte produktionsordrer;
                                 ENU=Planned Production Orders];
                      ToolTipML=[DAN=Vis oversigten over produktionsordrer med statussen Planlagt.;
                                 ENU=View the list of production orders with status Planned.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9324 }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Fastlagte produktionsordrer;
                                 ENU=Firm Planned Production Orders];
                      ToolTipML=[DAN="Vis fuldfõrte produktionsordrer. ";
                                 ENU="View completed production orders. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9325 }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=Frigivne produktionsordrer;
                                 ENU=Released Production Orders];
                      ToolTipML=[DAN=Vis listen over frigivne produktionsordrer, som er klar til lageraktiviteter.;
                                 ENU=View the list of released production order that are ready for warehouse activities.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9326 }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Fërdige produktionsordrer;
                                 ENU=Finished Production Orders];
                      ToolTipML=[DAN="Vis fuldfõrte produktionsordrer. ";
                                 ENU="View completed production orders. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9327 }
      { 101     ;1   ;Action    ;
                      CaptionML=[DAN=Produktionsforecast;
                                 ENU=Production Forecast];
                      ToolTipML=[DAN=Vis eller rediger et produktionsforecast for dine salgsvarer, komponenter eller begge dele.;
                                 ENU=View or edit a production forecast for your sales items, components, or both.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000921 }
      { 102     ;1   ;Action    ;
                      CaptionML=[DAN=Rammesalgsordrer;
                                 ENU=Blanket Sales Orders];
                      ToolTipML=[DAN=Brug rammesalgsordrer som en ramme for en langsigtet aftale mellem dig og dine debitorer for at sëlge et stort antal varer, der skal leveres i flere mindre portioner i lõbet af en bestemt periode. En rammeordre omfatter ofte kun en enkelt vare med leveringsdatoer, der er fastsat pÜ forhÜnd. Den vësentligste Ürsag til at bruge en rammeordre i stedet for en salgsordre er, at de antal, der angives i en rammeordre, ikke pÜvirker varedisponeringen, og at oplysningerne dermed kan bruges til overvÜgnings-, prognose- og planlëgningsformÜl.;
                                 ENU=Use blanket sales orders as a framework for a long-term agreement between you and your customers to sell large quantities that are to be delivered in several smaller shipments over a certain period of time. Blanket orders often cover only one item with predetermined delivery dates. The main reason for using a blanket order rather than a sales order is that quantities entered on a blanket order do not affect item availability and thus can be used as a worksheet for monitoring, forecasting, and planning purposes..];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9303 }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. Salgsordrer gõr det i modsëtning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
                                 ENU=Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9305;
                      Image=Order }
      { 103     ;1   ;Action    ;
                      CaptionML=[DAN=Rammekõbsordrer;
                                 ENU=Blanket Purchase Orders];
                      ToolTipML=[DAN=Brug rammekõbsordrer som en ramme for en langsigtet aftale mellem dig og dine kreditorer for at kõbe et stort antal varer, der skal leveres i flere mindre portioner i lõbet af en bestemt periode. En rammeordre omfatter ofte kun en enkelt vare med leveringsdatoer, der er fastsat pÜ forhÜnd. Den vësentligste Ürsag til at bruge en rammeordre i stedet for en kõbsordre er, at de antal, der angives i en rammeordre, ikke pÜvirker varedisponeringen, og at oplysningerne dermed kan bruges til overvÜgnings-, prognose- og planlëgningsformÜl.;
                                 ENU=Use blanket purchase orders as a framework for a long-term agreement between you and your vendors to buy large quantities that are to be delivered in several smaller shipments over a certain period of time. Blanket orders often cover only one item with predetermined delivery dates. The main reason for using a blanket order rather than a purchase order is that quantities entered on a blanket order do not affect item availability and thus can be used as a worksheet for monitoring, forecasting, and planning purposes..];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9310 }
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
                      ApplicationArea=#Location;
                      RunObject=Page 5742;
                      Image=Document }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Kreditorer;
                                 ENU=Vendors];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de kreditorer, som du handler med. Fra det enkelte kreditorkort kan du fÜ adgang til relaterede oplysninger som f.eks. kõbsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som kreditoren giver dig, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 27;
                      Image=Vendor }
      { 17      ;1   ;Action    ;
                      Name=Items;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 31;
                      Image=Item }
      { 11      ;1   ;Action    ;
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
      { 16      ;1   ;Action    ;
                      Name=ProductionBOMs;
                      CaptionML=[DAN=Produktionsstyklister;
                                 ENU=Production BOMs];
                      ToolTipML=[DAN=Vis oversigten over produktionsstyklister.;
                                 ENU=View the list of production bills of material.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000787 }
      { 63      ;1   ;Action    ;
                      Name=ProductionBOMsCertified;
                      CaptionML=[DAN=Certificeret;
                                 ENU=Certified];
                      ToolTipML=[DAN=Vis listen over godkendte produktionsstyklister.;
                                 ENU=View the list of certified production BOMs.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000787;
                      RunPageView=WHERE(Status=CONST(Certified)) }
      { 83      ;1   ;Action    ;
                      CaptionML=[DAN=Ruter;
                                 ENU=Routings];
                      ToolTipML=[DAN=FÜ vist eller rediger driftsprocesser og behandlingstider for producerede varer.;
                                 ENU=View or edit operation sequences and process times for produced items.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000764 }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kladder;
                                 ENU=Journals];
                      Image=Journals }
      { 22      ;2   ;Action    ;
                      Name=ItemJournals;
                      CaptionML=[DAN=Varekladder;
                                 ENU=Item Journals];
                      ToolTipML=[DAN=Bogfõr varetransaktioner direkte pÜ varekladden for at regulere lagerbeholdningen i forbindelse med kõb, salg, opreguleringer eller nedreguleringer uden brug af bilag. Du kan gemme hele sët med varekladdelinjer som standardkladder, sÜ du hurtigt kan udfõre tilbagevendende bogfõringer. Der findes en komprimeret version af varekladdefunktionen pÜ varekort, som gõr det muligt at foretage en hurtig regulering af et varelagerantal.;
                                 ENU=Post item transactions directly to the item ledger to adjust inventory in connection with purchases, sales, and positive or negative adjustments without using documents. You can save sets of item journal lines as standard journals so that you can perform recurring postings quickly. A condensed version of the item journal function exists on item cards for quick adjustment of an items inventory quantity.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Item),
                                        Recurring=CONST(No)) }
      { 23      ;2   ;Action    ;
                      Name=ItemReclassificationJournals;
                      CaptionML=[DAN=Vareomposteringskladder;
                                 ENU=Item Reclassification Journals];
                      ToolTipML=[DAN=Rediger oplysninger, der er registreret i vareposter. Typiske lageroplysninger, der skal omposteres, omfatter dimensioner og salgskampagnekoder, men du kan ogsÜ udfõre grundlëggende lageroverfõrsler ved at ompostere lokations- og placeringskoder. Serie- eller lotnumre og deres udlõbsdatoer skal omposteres vha. omposteringskladden til varesporing.;
                                 ENU=Change information recorded on item ledger entries. Typical inventory information to reclassify includes dimensions and sales campaign codes, but you can also perform basic inventory transfers by reclassifying location and bin codes. Serial or lot numbers and their expiration dates must be reclassified with the Item Tracking Reclassification journal.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Transfer),
                                        Recurring=CONST(No)) }
      { 24      ;2   ;Action    ;
                      Name=RevaluationJournals;
                      CaptionML=[DAN=Vërdireguleringskladder;
                                 ENU=Revaluation Journals];
                      ToolTipML=[DAN=Ret lagervërdien af varer, f.eks. nÜr du har foretaget en fysisk lageropgõrelse.;
                                 ENU=Change the inventory value of items, for example after doing a physical inventory.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Revaluation),
                                        Recurring=CONST(No)) }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kladder;
                                 ENU=Worksheets];
                      Image=Worksheets }
      { 33      ;2   ;Action    ;
                      Name=PlanningWorksheets;
                      CaptionML=[DAN=Planlëgningskladder;
                                 ENU=Planning Worksheets];
                      ToolTipML=[DAN=Planlëg forsyningsordrer automatisk for at opfylde nye behov.;
                                 ENU=Plan supply orders automatically to fulfill new demand.];
                      ApplicationArea=#Planning;
                      RunObject=Page 295;
                      RunPageView=WHERE(Template Type=CONST(Planning),
                                        Recurring=CONST(No)) }
      { 32      ;2   ;Action    ;
                      Name=RequisitionWorksheets;
                      CaptionML=[DAN=Indkõbskladder;
                                 ENU=Requisition Worksheets];
                      ToolTipML=[DAN=Beregn en forsyningsplan for at opfylde varebehov via indkõb eller overfõrsler.;
                                 ENU=Calculate a supply plan to fulfill item demand with purchases or transfers.];
                      ApplicationArea=#Planning;
                      RunObject=Page 295;
                      RunPageView=WHERE(Template Type=CONST(Req.),
                                        Recurring=CONST(No)) }
      { 34      ;2   ;Action    ;
                      Name=SubcontractingWorksheets;
                      CaptionML=[DAN=Underleverandõrkladder;
                                 ENU=Subcontracting Worksheets];
                      ToolTipML=[DAN=Beregn den nõdvendige produktionsforsyning, find de produktionsordrer med materiale, der allerede er parat til afsendelse til en underleverandõr, og opret automatisk kõbsordrer pÜ operationer fra produktionsordreruter, der skal udfõres hos en underleverandõr.;
                                 ENU=Calculate the needed production supply, find the production orders that have material ready to send to a subcontractor, and automatically create purchase orders for subcontracted operations from production order routings.];
                      ApplicationArea=#Planning;
                      RunObject=Page 295;
                      RunPageView=WHERE(Template Type=CONST(For. Labor),
                                        Recurring=CONST(No)) }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Standardkostpriskladde;
                                 ENU=Standard Cost Worksheet];
                      ToolTipML=[DAN=Gennemse eller opdater standardomkostninger. Indkõbere, produktions- eller montageadministratorer kan bruge kladden til at simulere indflydelsen pÜ kostprisen pÜ den producerede eller samlede vare, hvis standardkostprisen for forbrug, produktionskapacitetsforbruget eller montageressourceforbruget ëndres. Du kan angive, at en kostprisëndring fõrst trëder i kraft pÜ en bestemt dato.;
                                 ENU=Review or update standard costs. Purchasers, production or assembly managers can use the worksheet to simulate the effect on the cost of the manufactured or assembled item if the standard cost for consumption, production capacity usage, or assembly resource usage is changed. You can set a cost change to take effect on a specified date.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5840 }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=Produktdesign;
                                 ENU=Product Design];
                      Image=ProductDesign }
      { 15      ;2   ;Action    ;
                      Name=ProductionBOM;
                      CaptionML=[DAN=Produktionsstykliste;
                                 ENU=Production BOM];
                      ToolTipML=[DAN=èbn varens produktionsstykliste for at vise eller redigere dens komponenter.;
                                 ENU=Open the item's production bill of material to view or edit its components.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000787;
                      Image=BOM }
      { 25      ;2   ;Action    ;
                      Name=ProductionBOMCertified;
                      CaptionML=[DAN=Certificeret;
                                 ENU=Certified];
                      ToolTipML=[DAN=Vis listen over godkendte produktionsstyklister.;
                                 ENU=View the list of certified production BOMs.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000787;
                      RunPageView=WHERE(Status=CONST(Certified)) }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Ruter;
                                 ENU=Routings];
                      ToolTipML=[DAN=FÜ vist eller rediger driftsprocesser og behandlingstider for producerede varer.;
                                 ENU=View or edit operation sequences and process times for produced items.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000764 }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Rutebindinger;
                                 ENU=Routing Links];
                      ToolTipML=[DAN=Vis eller rediger links mellem produktionsstyklistelinjerne og rutelinjer, der er konfigureret for at sikre just in time-trëk af komponenter.;
                                 ENU=View or edit links that are set up between production BOM lines and routing lines to ensure just-in-time flushing of components.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000798 }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Standardoperationer;
                                 ENU=Standard Tasks];
                      ToolTipML=[DAN=Vis eller rediger standardproduktionsoperationer.;
                                 ENU=View or edit standard production operations.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000799 }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Familier;
                                 ENU=Families];
                      ToolTipML=[DAN=Vis eller rediger en gruppe af producerede varer, hvis relation er baseret pÜ lighedspunkter i produktionsprocessen. Ved at oprette produktionsfamilier kan visse varer fremstilles to gange eller mere i Çn produktion, hvilket optimerer materialeforbruget.;
                                 ENU=View or edit a grouping of production items whose relationship is based on the similarity of their manufacturing processes. By forming production families, some items can be manufactured twice or more in one production, which will optimize material consumption.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000791 }
      { 30      ;2   ;Action    ;
                      Name=ProdDesign_Items;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 31;
                      Image=Item }
      { 31      ;2   ;Action    ;
                      Name=ProdDesign_ItemsProduced;
                      CaptionML=[DAN=Produceret;
                                 ENU=Produced];
                      ToolTipML=[DAN=Vis oversigten over produktionsvarer.;
                                 ENU=View the list of production items.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 31;
                      RunPageView=WHERE(Replenishment System=CONST(Prod. Order)) }
      { 36      ;2   ;Action    ;
                      Name=ProdDesign_ItemsRawMaterials;
                      CaptionML=[DAN=RÜvarer;
                                 ENU=Raw Materials];
                      ToolTipML=[DAN=Vis oversigten over varer, der ikke er styklister.;
                                 ENU=View the list of items that are not bills of material.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 31;
                      RunPageView=WHERE(Low-Level Code=FILTER(>0),
                                        Replenishment System=CONST(Purchase)) }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Lagervarer;
                                 ENU=Stockkeeping Units];
                      ToolTipML=[DAN="èbn oversigten over lagervarer for varen for at vise eller redigere forekomster af varen pÜ forskellige lokationer eller med forskellige varianter. ";
                                 ENU="Open the list of item SKUs to view or edit instances of item at different locations or with different variants. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5701;
                      Image=SKU }
      { 38      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kapaciteter;
                                 ENU=Capacities];
                      Image=Capacities }
      { 39      ;2   ;Action    ;
                      Name=WorkCenters;
                      CaptionML=[DAN=Arbejdscentre;
                                 ENU=Work Centers];
                      ToolTipML=[DAN=Vis eller rediger listen over arbejdscentre.;
                                 ENU=View or edit the list of work centers.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000755 }
      { 40      ;2   ;Action    ;
                      Name=WorkCentersInternal;
                      CaptionML=[DAN=Intern;
                                 ENU=Internal];
                      ToolTipML=[DAN=FÜ vist eller registrer interne bemërkninger til serviceartiklen. Interne bemërkninger er kun til intern brug og udskrives ikke i rapporter.;
                                 ENU=View or register internal comments for the service item. Internal comments are for internal use only and are not printed on reports.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000755;
                      RunPageView=WHERE(Subcontractor No.=FILTER(=''));
                      Image=Comment }
      { 41      ;2   ;Action    ;
                      Name=WorkCentersSubcontracted;
                      CaptionML=[DAN=Fra underleverandõrer;
                                 ENU=Subcontracted];
                      ToolTipML=[DAN=Vis listen over igangvërende kõbsordrer for produktionsordrer, der udfõres af underleverandõrer.;
                                 ENU=View the list of ongoing purchase orders for subcontracted production orders.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000755;
                      RunPageView=WHERE(Subcontractor No.=FILTER(<>'')) }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Produktionsressourcer;
                                 ENU=Machine Centers];
                      ToolTipML=[DAN=Vis oversigten over produktionsressourcer.;
                                 ENU=View the list of machine centers.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000761 }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=Registreret fravër;
                                 ENU=Registered Absence];
                      ToolTipML=[DAN=FÜ vist fravërstimer for arbejdscentre eller produktionsressourcer.;
                                 ENU=View absence hours for work or machine centers.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000920 }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=Kreditorer;
                                 ENU=Vendors];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de kreditorer, som du handler med. Fra det enkelte kreditorkort kan du fÜ adgang til relaterede oplysninger som f.eks. kõbsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som kreditoren giver dig, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 27;
                      Image=Vendor }
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 53      ;1   ;Action    ;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      ToolTipML=[DAN=Vis listen over varer, som du handler med.;
                                 ENU=View the list of items that you trade in.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 30;
                      Promoted=No;
                      Image=Item;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 52      ;1   ;Action    ;
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
      { 51      ;1   ;Action    ;
                      CaptionML=[DAN=&Produktionsstykliste;
                                 ENU=Production &BOM];
                      ToolTipML=[DAN=Opret en ny stykliste for en produceret vare.;
                                 ENU=Create a new bill of material for a produced item.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000786;
                      Promoted=No;
                      Image=BOM;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=Ru&te;
                                 ENU=&Routing];
                      ToolTipML=[DAN=Opret en rute, der definerer de handlinger, der krëves for at producere en vare.;
                                 ENU=Create a routing defining the operations that are required to produce an end item.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000766;
                      Promoted=No;
                      Image=Route;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 21      ;1   ;Action    ;
                      CaptionML=[DAN=&Kõbsordre;
                                 ENU=&Purchase Order];
                      ToolTipML=[DAN=Kõb varer eller servicer fra en kreditor.;
                                 ENU=Purchase goods or services from a vendor.];
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
      { 46      ;1   ;Action    ;
                      CaptionML=[DAN=&Varekladde;
                                 ENU=Item &Journal];
                      ToolTipML=[DAN=Juster det fysiske antal varer pÜ lager.;
                                 ENU=Adjust the physical quantity of items on inventory.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 40;
                      Image=Journals }
      { 47      ;1   ;Action    ;
                      CaptionML=[DAN=Indkõ&bskladde;
                                 ENU=Re&quisition Worksheet];
                      ToolTipML=[DAN=Planlëg forsyningsordrer automatisk for at opfylde nye behov. Kladden kan kun bruges til planlëgning af kõbs- og overflytningsordrer.;
                                 ENU=Plan supply orders automatically to fulfill new demand. This worksheet can plan purchase and transfer orders only.];
                      ApplicationArea=#Planning;
                      RunObject=Page 291;
                      Image=Worksheet }
      { 48      ;1   ;Action    ;
                      CaptionML=[DAN=Planl&ëgningskladde;
                                 ENU=Planning Works&heet];
                      ToolTipML=[DAN=Planlëg forsyningsordrer automatisk for at opfylde nye behov.;
                                 ENU=Plan supply orders automatically to fulfill new demand.];
                      ApplicationArea=#Planning;
                      RunObject=Page 99000852;
                      Image=PlanningWorksheet }
      { 4       ;1   ;Action    ;
                      CaptionML=[DAN=Varedisponering pr. tidslinje;
                                 ENU=Item Availability by Timeline];
                      ToolTipML=[DAN=FÜ en grafisk visning af en vares planlagte lager baseret pÜ fremtidige udbuds- og efterspõrgselshëndelser med eller uden planlëgningsforslag. Resultatet er en grafisk gengivelse af lagerprofilen.;
                                 ENU=Get a graphical view of an item's projected inventory based on future supply and demand events, with or without planning suggestions. The result is a graphical representation of the inventory profile.];
                      ApplicationArea=#Planning;
                      RunObject=Page 5540;
                      Image=Timeline }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=&Underleverandõrkladde;
                                 ENU=Subcontracting &Worksheet];
                      ToolTipML=[DAN=Beregn den nõdvendige produktionsforsyning, find de produktionsordrer med materiale, der allerede er parat til afsendelse til en underleverandõr, og opret automatisk kõbsordrer pÜ operationer fra produktionsordreruter, der skal udfõres hos en underleverandõr.;
                                 ENU=Calculate the needed production supply, find the production orders that have material ready to send to a subcontractor, and automatically create purchase orders for subcontracted operations from production order routings.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000886;
                      Image=SubcontractingWorksheet }
      { 45      ;1   ;Separator  }
      { 122     ;1   ;Action    ;
                      CaptionML=[DAN=Skift pro&d.ordrestatus;
                                 ENU=Change Pro&duction Order Status];
                      ToolTipML=[DAN=Skift produktionsordren til en anden status, f.eks. frigivet.;
                                 ENU=Change the production order to another status, such as Released.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000914;
                      Image=ChangeStatus }
      { 123     ;1   ;Action    ;
                      CaptionML=[DAN=Ordrep&lanlëgning;
                                 ENU=Order Pla&nning];
                      ToolTipML=[DAN=Planlëg forsyningsordrer ordre for ordre for at opfylde nye behov.;
                                 ENU=Plan supply orders order by order to fulfill new demand.];
                      ApplicationArea=#Planning;
                      RunObject=Page 5522;
                      Image=Planning }
      { 84      ;1   ;Separator ;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Administration];
                      IsHeader=Yes }
      { 124     ;1   ;Action    ;
                      CaptionML=[DAN=Opsëtn. af beregn. af lev.t&id;
                                 ENU=Order Promising S&etup];
                      ToolTipML=[DAN=Konfigurer virksomhedens politikker for beregning af leveringsdatoer.;
                                 ENU=Configure your company's policies for calculating delivery dates.];
                      ApplicationArea=#Planning;
                      RunObject=Page 99000958;
                      Image=OrderPromisingSetup }
      { 125     ;1   ;Action    ;
                      CaptionML=[DAN=&Produktionsopsëtning;
                                 ENU=&Manufacturing Setup];
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
                      CaptionML=[DAN=Vare&sporing;
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

    { 1905113808;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9038;
                PartType=Page }

    { 1900724708;1;Group   }

    { 54  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 1905989608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9152;
                PartType=Page }

    { 55  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page681;
                PartType=Page }

    { 1903012608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9175;
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

