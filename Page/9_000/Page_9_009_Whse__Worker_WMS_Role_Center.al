OBJECT Page 9009 Whse. Worker WMS Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_WAREHOUSEWORKER-WMS""}";
               DAN=Lagermedarbejder - logistik;
               ENU=Warehouse Worker - Warehouse Management System];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Lager&placeringsoversigt;
                                 ENU=Warehouse &Bin List];
                      ToolTipML=[DAN=FÜ et overblik over lagerplaceringerne, opsëtningen og antallet af varer pÜ placeringerne.;
                                 ENU=Get an overview of warehouse bins, their setup, and the quantity of items within the bins.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 7319;
                      Image=Report }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Regul.pla&cering (logistik);
                                 ENU=Warehouse A&djustment Bin];
                      ToolTipML=[DAN=FÜ et overblik over lagerplaceringerne, opsëtningen og antallet af varer pÜ placeringerne.;
                                 ENU=Get an overview of warehouse bins, their setup, and the quantity of items within the bins.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 7320;
                      Image=Report }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=La&gerplaceringsopg.oversigt;
                                 ENU=Whse. P&hys. Inventory List];
                      ToolTipML=[DAN=Vis eller udskriv listen over de linjer, du har beregnet i vinduet Lagersted - fysisk lagerkladde. Du kan bruge denne rapport under den fysiske lageroptëlling til at notere det faktiske antal pÜ lager og sammenligne antallet med det antal, der er registreret i programmet.;
                                 ENU=View or print the list of the lines that you have calculated in the Whse. Phys. Invt. Journal window. You can use this report during the physical inventory count to mark down actual quantities on hand in the warehouse and compare them to what is recorded in the program.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 7307;
                      Image=Report }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=Prod.&ordre - plukliste;
                                 ENU=Prod. &Order Picking List];
                      ToolTipML=[DAN=Vis en detaljeret oversigt over, hvilke varer der skal plukkes til en bestemt produktionsordre, fra hvilken lokation (og placering, hvis lokationen anvender placeringer) de skal plukkes, og hvornÜr varerne skal vëre klar til produktion.;
                                 ENU=View a detailed list of items that must be picked for a particular production order, from which location (and bin, if the location uses bins) they must be picked, and when the items are due for production.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 99000766;
                      Image=Report }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=Debitor - &etiketter;
                                 ENU=Customer &Labels];
                      ToolTipML=[DAN=Vis, gem eller udskriv etiketter med debitornavn og -adresse. Rapporten kan f.eks. bruges, nÜr du udsender salgsbreve.;
                                 ENU=View, save, or print mailing labels with the customers' names and addresses. The report can be used to send sales letters, for example.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 110;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 26      ;1   ;Action    ;
                      CaptionML=[DAN=Pluk;
                                 ENU=Picks];
                      ToolTipML=[DAN="Vis listen over igangvërende lagerpluk. ";
                                 ENU="View the list of ongoing warehouse picks. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9313 }
      { 36      ;1   ;Action    ;
                      CaptionML=[DAN=Lëg-pÜ-lager-aktiviteter;
                                 ENU=Put-aways];
                      ToolTipML=[DAN=Vis oversigten over igangvërende lëg-pÜ-lager-aktiviteter.;
                                 ENU=View the list of ongoing put-aways.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9312 }
      { 41      ;1   ;Action    ;
                      CaptionML=[DAN=Bevëgelser;
                                 ENU=Movements];
                      ToolTipML=[DAN=Vis oversigten over igangvërende bevëgelser mellem placeringer i henhold til en avanceret lagerkonfiguration.;
                                 ENU=View the list of ongoing movements between bins according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9314 }
      { 9       ;1   ;Action    ;
                      Name=WhseShpt;
                      CaptionML=[DAN=Lagerleverancer;
                                 ENU=Warehouse Shipments];
                      ToolTipML=[DAN=Vis listen over igangvërende lagerleverancer.;
                                 ENU=View the list of ongoing warehouse shipments.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7339 }
      { 22      ;1   ;Action    ;
                      Name=WhseShptReleased;
                      CaptionML=[DAN=Frigivet;
                                 ENU=Released];
                      ToolTipML=[DAN=Vis listen over frigivne kildebilag, som er klar til lageraktiviteter.;
                                 ENU=View the list of released source documents that are ready for warehouse activities.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7339;
                      RunPageView=SORTING(No.)
                                  WHERE(Status=FILTER(Released)) }
      { 23      ;1   ;Action    ;
                      Name=WhseShptPartPicked;
                      CaptionML=[DAN=Delvist plukket;
                                 ENU=Partially Picked];
                      ToolTipML=[DAN=Vis listen over igangvërende lagerpluk, der er delvist fuldfõrt.;
                                 ENU=View the list of ongoing warehouse picks that are partially completed.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7339;
                      RunPageView=WHERE(Document Status=FILTER(Partially Picked)) }
      { 24      ;1   ;Action    ;
                      Name=WhseShptComplPicked;
                      CaptionML=[DAN=Fuldt plukket;
                                 ENU=Completely Picked];
                      ToolTipML=[DAN=Vis listen over afsluttede lagerpluk.;
                                 ENU=View the list of completed warehouse picks.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7339;
                      RunPageView=WHERE(Document Status=FILTER(Completely Picked)) }
      { 25      ;1   ;Action    ;
                      Name=WhseShptPartShipped;
                      CaptionML=[DAN=Delvist leveret;
                                 ENU=Partially Shipped];
                      ToolTipML=[DAN=Vis listen over igangvërende lagerleverancer, der er delvist fuldfõrt.;
                                 ENU=View the list of ongoing warehouse shipments that are partially completed.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7339;
                      RunPageView=WHERE(Document Status=FILTER(Partially Shipped)) }
      { 11      ;1   ;Action    ;
                      Name=WhseReceipts;
                      CaptionML=[DAN=Lagermodtagelser;
                                 ENU=Warehouse Receipts];
                      ToolTipML=[DAN=Vis listen over igangvërende lagermodtagelser.;
                                 ENU=View the list of ongoing warehouse receipts.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7332 }
      { 77      ;1   ;Action    ;
                      Name=WhseReceiptsPartReceived;
                      CaptionML=[DAN=Delvist modtaget;
                                 ENU=Partially Received];
                      ToolTipML=[DAN=Vis listen over igangvërende lagermodtagelser, der er delvist fuldfõrt.;
                                 ENU=View the list of ongoing warehouse receipts that are partially completed.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7332;
                      RunPageView=WHERE(Document Status=FILTER(Partially Received)) }
      { 83      ;1   ;Action    ;
                      CaptionML=[DAN=Overflytningsordrer;
                                 ENU=Transfer Orders];
                      ToolTipML=[DAN=Flyt lagervarer mellem lokationer for virksomheden. Med overflytningsordrer kan du sende udgÜende overflytninger fra Çn lokation og modtage den indgÜende overfõrsel pÜ den anden lokation. Derved kan du administrere de involverede lageraktiviteter, og det õger sikkerheden for, at vareantallet opdateres korrekt.;
                                 ENU=Move inventory items between company locations. With transfer orders, you ship the outbound transfer from one location and receive the inbound transfer at the other location. This allows you to manage the involved warehouse activities and provides more certainty that inventory quantities are updated correctly.];
                      ApplicationArea=#Location;
                      RunObject=Page 5742;
                      Image=Document }
      { 1       ;1   ;Action    ;
                      CaptionML=[DAN=Montageordrer;
                                 ENU=Assembly Orders];
                      ToolTipML=[DAN=Vis igangvërende montageordrer.;
                                 ENU=View ongoing assembly orders.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 902 }
      { 46      ;1   ;Action    ;
                      CaptionML=[DAN=Placeringsindhold;
                                 ENU=Bin Contents];
                      ToolTipML=[DAN=Vis varer i placeringen, hvis den valgte linje indeholder en placeringskode.;
                                 ENU=View items in the bin if the selected line contains a bin code.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7305;
                      Image=BinContent }
      { 47      ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 31;
                      Image=Item }
      { 49      ;1   ;Action    ;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 22;
                      Image=Customer }
      { 52      ;1   ;Action    ;
                      CaptionML=[DAN=Kreditorer;
                                 ENU=Vendors];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de kreditorer, som du handler med. Fra det enkelte kreditorkort kan du fÜ adgang til relaterede oplysninger som f.eks. kõbsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som kreditoren giver dig, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 27;
                      Image=Vendor }
      { 53      ;1   ;Action    ;
                      CaptionML=[DAN=Speditõrer;
                                 ENU=Shipping Agents];
                      ToolTipML=[DAN=Vis listen over speditõrer, som du bruger til at transportere varer.;
                                 ENU=View the list of shipping companies that you use to transport goods.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 428 }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=Lagermedarbejdere;
                                 ENU=Warehouse Employees];
                      ToolTipML=[DAN=FÜ vist de lagermedarbejdere, der findes i systemet.;
                                 ENU=View the warehouse employees that exist in the system.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7348 }
      { 55      ;1   ;Action    ;
                      Name=WhsePhysInvtJournals;
                      CaptionML=[DAN=Lagerplacering - opg.kladder;
                                 ENU=Whse. Phys. Invt. Journals];
                      ToolTipML=[DAN=Forbered optëlling af lagerbeholdningen ved at klargõre de dokumenter, som lagermedarbejderne skal bruge, nÜr de foretager en lageropgõrelse af bestemte varer eller af hele lagerstedet. NÜr optëllingen er fërdig, skal du indtaste det antal varer, der findes pÜ placeringerne, i dette vindue, hvorefter du registrerer lageropgõrelsen.;
                                 ENU=Prepare to count inventories by preparing the documents that warehouse employees use when they perform a physical inventory of selected items or of all the inventory. When the physical count has been made, you enter the number of items that are in the bins in this window, and then you register the physical inventory.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7329;
                      RunPageView=WHERE(Template Type=CONST(Physical Inventory)) }
      { 3       ;1   ;Action    ;
                      Name=WhseItem Journals;
                      CaptionML=[DAN=Lagerkladder;
                                 ENU=Whse. Item Journals];
                      ToolTipML=[DAN=Reguler antallet af en vare pÜ Çn eller flere placeringer. Det kan f.eks. vëre, at du finder nogle varer pÜ en placering, der ikke er registreret i systemet, eller at du ikke kan plukke det nõdvendige antal, fordi der er fërre varer pÜ en placering, som programmet har beregnet. Placeringen opdateres derefter, sÜ den svarer til det faktiske antal pÜ placeringen. Desuden oprettes et udlignende antal pÜ reguleringsplaceringen til synkronisering med vareposter, som du derefter kan bogfõre med en varekladde.;
                                 ENU=Adjust the quantity of an item in a particular bin or bins. For instance, you might find some items in a bin that are not registered in the system, or you might not be able to pick the quantity needed because there are fewer items in a bin than was calculated by the program. The bin is then updated to correspond to the actual quantity in the bin. In addition, it creates a balancing quantity in the adjustment bin, for synchronization with item ledger entries, which you can then post with an item journal.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7329;
                      RunPageView=WHERE(Template Type=CONST(Item)) }
      { 56      ;1   ;Action    ;
                      Name=PickWorksheets;
                      CaptionML=[DAN=Plukkladder;
                                 ENU=Pick Worksheets];
                      ToolTipML=[DAN="Planlëg og start pluk af varer. ";
                                 ENU="Plan and initialize picks of items. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7346;
                      RunPageView=WHERE(Template Type=CONST(Pick)) }
      { 58      ;1   ;Action    ;
                      Name=PutawayWorksheets;
                      CaptionML=[DAN=Lëg-pÜ-lager-kladder;
                                 ENU=Put-away Worksheets];
                      ToolTipML=[DAN=Planlëg og start lëg-pÜ-lager-vareaktiviteter.;
                                 ENU=Plan and initialize item put-aways.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7346;
                      RunPageView=WHERE(Template Type=CONST(Put-away)) }
      { 60      ;1   ;Action    ;
                      Name=MovementWorksheets;
                      CaptionML=[DAN=Bevëgelseskladder;
                                 ENU=Movement Worksheets];
                      ToolTipML=[DAN=Planlëg og start varebevëgelser mellem placeringer i henhold til en avanceret lagerkonfiguration.;
                                 ENU=Plan and initiate movements of items between bins according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7346;
                      RunPageView=WHERE(Template Type=CONST(Movement)) }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=Registrerede dokumenter;
                                 ENU=Registered Documents];
                      Image=RegisteredDocs }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=Registrerede pluk;
                                 ENU=Registered Picks];
                      ToolTipML=[DAN=Vis lagerpluk, der er foretaget.;
                                 ENU=View warehouse picks that have been performed.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9344;
                      Image=RegisteredDocs }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=Registrerede lëg-pÜ-lager-akt.;
                                 ENU=Registered Put-aways];
                      ToolTipML=[DAN=Vis listen over afsluttede lëg-pÜ-lager-aktiviteter.;
                                 ENU=View the list of completed put-away activities.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9343;
                      Image=RegisteredDocs }
      { 45      ;2   ;Action    ;
                      CaptionML=[DAN=Registrerede bevëgelser;
                                 ENU=Registered Movements];
                      ToolTipML=[DAN=Vis listen over afsluttede lagerbevëgelser.;
                                 ENU=View the list of completed warehouse movements.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9345;
                      Image=RegisteredDocs }
      { 59      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte lagermodtagelser;
                                 ENU=Posted Whse. Receipts];
                      ToolTipML=[DAN=èbn listen over bogfõrte lagermodtagelser.;
                                 ENU=Open the list of posted warehouse receipts.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7333;
                      Image=PostedReceipts }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 37      ;1   ;Action    ;
                      CaptionML=[DAN=Lageropgõr&elseskladde;
                                 ENU=Whse. P&hysical Invt. Journal];
                      ToolTipML=[DAN=Forbered optëlling af lagerbeholdningen ved at klargõre de dokumenter, som lagermedarbejderne skal bruge, nÜr de foretager en lageropgõrelse af bestemte varer eller af hele lagerstedet. NÜr optëllingen er fërdig, skal du indtaste det antal varer, der findes pÜ placeringerne, i dette vindue, hvorefter du registrerer lageropgõrelsen.;
                                 ENU=Prepare to count inventories by preparing the documents that warehouse employees use when they perform a physical inventory of selected items or of all the inventory. When the physical count has been made, you enter the number of items that are in the bins in this window, and then you register the physical inventory.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7326;
                      Image=InventoryJournal }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Lagerkla&dde;
                                 ENU=Whse. Item &Journal];
                      ToolTipML=[DAN=Reguler antallet af en vare pÜ Çn eller flere placeringer. Det kan f.eks. vëre, at du finder nogle varer pÜ en placering, der ikke er registreret i systemet, eller at du ikke kan plukke det nõdvendige antal, fordi der er fërre varer pÜ en placering, som programmet har beregnet. Placeringen opdateres derefter, sÜ den svarer til det faktiske antal pÜ placeringen. Desuden oprettes et udlignende antal pÜ reguleringsplaceringen til synkronisering med vareposter, som du derefter kan bogfõre med en varekladde.;
                                 ENU=Adjust the quantity of an item in a particular bin or bins. For instance, you might find some items in a bin that are not registered in the system, or you might not be able to pick the quantity needed because there are fewer items in a bin than was calculated by the program. The bin is then updated to correspond to the actual quantity in the bin. In addition, it creates a balancing quantity in the adjustment bin, for synchronization with item ledger entries, which you can then post with an item journal.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7324;
                      Image=BinJournal }
      { 17      ;1   ;Action    ;
                      CaptionML=[DAN=Pl&ukkladde;
                                 ENU=Pick &Worksheet];
                      ToolTipML=[DAN="Planlëg og start pluk af varer. ";
                                 ENU="Plan and initialize picks of items. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7345;
                      Image=PickWorksheet }
      { 28      ;1   ;Action    ;
                      CaptionML=[DAN=Lëg-&pÜ-lager-kladde;
                                 ENU=Put-&away Worksheet];
                      ToolTipML=[DAN=Planlëg og start lëg-pÜ-lager-vareaktiviteter.;
                                 ENU=Plan and initialize item put-aways.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7352;
                      Image=PutAwayWorksheet }
      { 30      ;1   ;Action    ;
                      CaptionML=[DAN=&Bevëgelseskladde;
                                 ENU=M&ovement Worksheet];
                      ToolTipML=[DAN=Gõr klar til at flytte varer mellem placeringer pÜ lageret.;
                                 ENU=Prepare to move items between bins within the warehouse.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7351;
                      Image=MovementWorksheet }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 1901138408;2;Part   ;
                ApplicationArea=#Warehouse;
                PagePartID=Page9056;
                PartType=Page }

    { 1905989608;2;Part   ;
                ApplicationArea=#Suite;
                PagePartID=Page9152;
                PartType=Page }

    { 1900724708;1;Group   }

    { 1006;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 4   ;2   ;Part      ;
                ApplicationArea=#Warehouse;
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

