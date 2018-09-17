OBJECT Page 9013 Machine Operator Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_MACHINEOPERATOR""}";
               DAN=Maskinoperatõr - omfattende produktion;
               ENU=Machine Operator - Manufacturing Comprehensive];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 52      ;1   ;Action    ;
                      CaptionML=[DAN=&Kapacitet - operationsliste;
                                 ENU=&Capacity Task List];
                      ToolTipML=[DAN=Viser de produktionsordrer, der venter pÜ at blive behandlet i arbejdscentre og produktionsressourcer. Der udskrives oversigter vedrõrende kapaciteten i arbejdscenteret eller produktionsressourcen. Rapporten indeholder bl.a. oplysninger om start-/slutdato og forfaldsdato samt tilgangsantal.;
                                 ENU=View the production orders that are waiting to be processed at the work centers and machine centers. Printouts are made for the capacity of the work center or machine center). The report includes information such as starting and ending time, date per production order and input quantity.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000780;
                      Image=Report }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=Prod.ordre - &jobkort;
                                 ENU=Prod. Order - &Job Card];
                      ToolTipML=[DAN=Vis en oversigt over igangvërende arbejde i forbindelse med en produktionsordre. Afgang, spildantal og gennemlõbstid vises eller udskrives afhëngigt af operationen.;
                                 ENU=View a list of the work in progress of a production order. Output, Scrapped Quantity and Production Lead Time are shown or printed depending on the operation.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000762;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
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
      { 12      ;1   ;Action    ;
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
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Kapacitetsposter;
                                 ENU=Capacity Ledger Entries];
                      ToolTipML=[DAN=Vis kapacitetsposterne for den involverede produktionsordre. Kapaciteten registreres enten som tid (operationstid, stoptid eller opstillingstid) eller som antal (spildantal eller afgangsantal).;
                                 ENU=View the capacity ledger entries of the involved production order. Capacity is recorded either as time (run time, stop time, or setup time) or as quantity (scrap quantity or output quantity).];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5832;
                      Image=CapacityLedger }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Lëg-pÜ-lager-akt. (lager);
                                 ENU=Inventory Put-aways];
                      ToolTipML=[DAN="Vis igangvërende lëg-pÜ-lager-vareaktiviteter til placeringer i henhold til en grundlëggende lagerkonfiguration. ";
                                 ENU="View ongoing put-aways of items to bins according to a basic warehouse configuration. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9315 }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Pluk (lager);
                                 ENU=Inventory Picks];
                      ToolTipML=[DAN="Vis igangvërende varepluk fra placeringer i henhold til en grundlëggende lagerkonfiguration. ";
                                 ENU="View ongoing picks of items from bins according to a basic warehouse configuration. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9316 }
      { 14      ;1   ;Action    ;
                      Name=ConsumptionJournals;
                      CaptionML=[DAN=Forbrugskladder;
                                 ENU=Consumption Journals];
                      ToolTipML=[DAN=Bogfõr forbrug af materiale i takt med, at operationer udfõres.;
                                 ENU=Post the consumption of material as operations are performed.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Consumption),
                                        Recurring=CONST(No)) }
      { 15      ;1   ;Action    ;
                      Name=OutputJournals;
                      CaptionML=[DAN=Afgangskladder;
                                 ENU=Output Journals];
                      ToolTipML=[DAN="Bogfõr fërdigvarer og tidsforbrug i produktionen. ";
                                 ENU="Post finished end items and time spent in production. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Output),
                                        Recurring=CONST(No)) }
      { 19      ;1   ;Action    ;
                      Name=CapacityJournals;
                      CaptionML=[DAN=Kapacitetskladder;
                                 ENU=Capacity Journals];
                      ToolTipML=[DAN=Bogfõr forbrugt kapacitet, der ikke er knyttet til produktionsordren. Vedligeholdelsesarbejde skal f.eks. knyttes til kapaciteten, men ikke til en produktionsordre.;
                                 ENU=Post consumed capacities that are not assigned to the production order. For example, maintenance work must be assigned to capacity, but not to a production order.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Capacity),
                                        Recurring=CONST(No)) }
      { 20      ;1   ;Action    ;
                      Name=RecurringCapacityJournals;
                      CaptionML=[DAN=Kapacitetsgentagelseskladder;
                                 ENU=Recurring Capacity Journals];
                      ToolTipML=[DAN=Bogfõr forbrugt kapacitet, der ikke er bogfõrt som en del af produktionsordreafgangen, f.eks. vedligeholdelsesarbejde.;
                                 ENU=Post consumed capacities that are not posted as part of production order output, such as maintenance work.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Capacity),
                                        Recurring=CONST(Yes)) }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 4       ;1   ;Action    ;
                      CaptionML=[DAN=&Pluk (lager);
                                 ENU=Inventory P&ick];
                      ToolTipML=[DAN="Opret et pluk i henhold til en grundlëggende lagerkonfiguration, eksempelvis for at plukke komponenter til en produktionsordre. ";
                                 ENU="Create a pick according to a basic warehouse configuration, for example to pick components for a production order. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7377;
                      Promoted=No;
                      Image=CreateInventoryPickup;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=&Lëg-pÜ-lager (lager);
                                 ENU=Inventory Put-&away];
                      ToolTipML=[DAN="Vis igangvërende lëg-pÜ-lager-vareaktiviteter til placeringer i henhold til en grundlëggende lagerkonfiguration. ";
                                 ENU="View ongoing put-aways of items to bins according to a basic warehouse configuration. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7375;
                      Promoted=No;
                      Image=CreatePutAway;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 67      ;1   ;Separator ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      IsHeader=Yes }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Forbrug&skladde;
                                 ENU=Consumptio&n Journal];
                      ToolTipML=[DAN=Bogfõr forbrug af materiale i takt med, at operationer udfõres.;
                                 ENU=Post the consumption of material as operations are performed.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000846;
                      Image=ConsumptionJournal }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=Afga&ngskladde;
                                 ENU=Output &Journal];
                      ToolTipML=[DAN="Bogfõr fërdigvarer og tidsforbrug i produktionen. ";
                                 ENU="Post finished end items and time spent in production. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000823;
                      Image=OutputJournal }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Kapa&citetskladde;
                                 ENU=&Capacity Journal];
                      ToolTipML=[DAN=Bogfõr forbrugt kapacitet, der ikke er bogfõrt som en del af produktionsordreafgangen, f.eks. vedligeholdelsesarbejde.;
                                 ENU=Post consumed capacities that are not posted as part of production order output, such as maintenance work.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000773;
                      Image=CapacityJournal }
      { 6       ;1   ;Separator  }
      { 25      ;1   ;Action    ;
                      CaptionML=[DAN=Registrer fravër - &produktionsressource;
                                 ENU=Register Absence - &Machine Center];
                      ToolTipML=[DAN=RegistrÇr planlagt fravër i en produktionsressource. Det planlagte fravër kan registreres for bÜde personale og maskiner. Du kan registrere ëndringer i tilgëngelige ressourcer i tabellen Registreret fravër. NÜr kõrslen er afsluttet, kan du se resultatet i vinduet Reg. fravër.;
                                 ENU=Register planned absences at a machine center. The planned absence can be registered for both human and machine resources. You can register changes in the available resources in the Registered Absence table. When the batch job has been completed, you can see the result in the Registered Absences window.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99003800;
                      Image=CalendarMachine }
      { 26      ;1   ;Action    ;
                      CaptionML=[DAN=Registrer fra&vër - arbejdscenter;
                                 ENU=Register Absence - &Work Center];
                      ToolTipML=[DAN=RegistrÇr planlagt fravër i en produktionsressource. Det planlagte fravër kan registreres for bÜde personale og maskiner. Du kan registrere ëndringer i tilgëngelige ressourcer i tabellen Registreret fravër. NÜr kõrslen er afsluttet, kan du se resultatet i vinduet Reg. fravër.;
                                 ENU=Register planned absences at a machine center. The planned absence can be registered for both human and machine resources. You can register changes in the available resources in the Registered Absence table. When the batch job has been completed, you can see the result in the Registered Absences window.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99003805;
                      Image=CalendarWorkcenter }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 1900316508;2;Part   ;
                ApplicationArea=#Manufacturing;
                PagePartID=Page9047;
                PartType=Page }

    { 1900724708;1;Group   }

    { 3   ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 1905989608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9152;
                PartType=Page }

    { 5   ;2   ;Part      ;
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

