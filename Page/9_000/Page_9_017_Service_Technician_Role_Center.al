OBJECT Page 9017 Service Technician Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_OUTBOUNDTECHNICIAN""}";
               DAN=Ekstern tekniker - kundeservice;
               ENU=Outbound Technician - Customer Service];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=Service&ordre;
                                 ENU=Service &Order];
                      ToolTipML=[DAN=Opret en ny serviceordre for at udfõre service pÜ varen for en debitor.;
                                 ENU=Create a new service order to perform service on a customer's item.];
                      ApplicationArea=#Service;
                      RunObject=Report 5900;
                      Image=Document }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Serviceart. - garanti &udlõbet;
                                 ENU=Service Items Out of &Warranty];
                      ToolTipML=[DAN=Vis oplysninger om garantiudlõbsdatoer, serienumre, antal aktive kontrakter, varebeskrivelse og navne pÜ debitorer. Du kan udskrive en oversigt over serviceartikler, hvis garanti er udlõbet.;
                                 ENU=View information about warranty end dates, serial numbers, number of active contracts, items description, and names of customers. You can print a list of service items that are out of warranty.];
                      ApplicationArea=#Service;
                      RunObject=Report 5937;
                      Image=Report }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Serviceart.&linje - tekster;
                                 ENU=Service Item &Line Labels];
                      ToolTipML=[DAN=Vis oversigten over serviceartikler i serviceordrer. Rapporten viser ordrenummer, serviceartikelnummer, serienummer og navnet pÜ varen.;
                                 ENU=View the list of service items on service orders. The report shows the order number, service item number, serial number, and the name of the item.];
                      ApplicationArea=#Service;
                      RunObject=Report 5901;
                      Image=Report }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=Servicearti&kelkladde;
                                 ENU=Service &Item Worksheet];
                      ToolTipML=[DAN=FÜ vist eller rediger oplysninger om serviceartiklerne, f.eks. reparationsstatus, bemërkninger til fejl, fejlkoder samt omkostninger. I dette vindue kan du opdatere oplysninger om artiklerne, f.eks. reparationsstatus samt fejl- og lõsningskoder. Du kan desuden angive nye servicelinjer for ressourcetidsforbrug, for brug af reservedele og for bestemte serviceomkostninger.;
                                 ENU=View or edit information about service items, such as repair status, fault comments and codes, and cost. In this window, you can update information on the items such as repair status and fault and resolution codes. You can also enter new service lines for resource hours, for the use of spare parts and for specific service costs.];
                      ApplicationArea=#Service;
                      RunObject=Report 5936;
                      Image=ServiceItemWorksheet }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 5       ;1   ;Action    ;
                      Name=ServiceOrders;
                      CaptionML=[DAN=Serviceordrer;
                                 ENU=Service Orders];
                      ToolTipML=[DAN=èbn oversigten over igangvërende serviceordrer.;
                                 ENU=Open the list of ongoing service orders.];
                      ApplicationArea=#Service;
                      RunObject=Page 9318;
                      Image=Document }
      { 17      ;1   ;Action    ;
                      Name=ServiceOrdersInProcess;
                      CaptionML=[DAN=Igangsat;
                                 ENU=In Process];
                      ToolTipML=[DAN="Vis igangvërende serviceordrer. ";
                                 ENU="View ongoing service orders. "];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9318;
                      RunPageView=WHERE(Status=FILTER(In Process)) }
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=Serviceartikellinjer;
                                 ENU=Service Item Lines];
                      ToolTipML=[DAN=Vis listen over igangvërende serviceartikellinjer.;
                                 ENU=View the list of ongoing service item lines.];
                      ApplicationArea=#Service;
                      RunObject=Page 5903 }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 22;
                      Image=Customer }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=UdlÜnsvarer;
                                 ENU=Loaners];
                      ToolTipML=[DAN=FÜ vist eller vëlg blandt de artikler, du udlÜner midlertidigt til debitorer som erstatning for de artikler, de har til service.;
                                 ENU=View or select from items that you lend out temporarily to customers to replace items that they have in service.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5923;
                      Image=Loaners }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Serviceartikler;
                                 ENU=Service Items];
                      ToolTipML=[DAN=Vis listen over serviceelementer.;
                                 ENU=View the list of service items.];
                      ApplicationArea=#Service;
                      RunObject=Page 5981;
                      Image=ServiceItem }
      { 22      ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 31;
                      Image=Item }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Service&ordre;
                                 ENU=Service &Order];
                      ToolTipML=[DAN=Opret en ny serviceordre for at udfõre service pÜ varen for en debitor.;
                                 ENU=Create a new service order to perform service on a customer's item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5900;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=&UdlÜnsvare;
                                 ENU=&Loaner];
                      ToolTipML=[DAN=FÜ vist eller vëlg blandt de artikler, du udlÜner midlertidigt til debitorer som erstatning for de artikler, de har til service.;
                                 ENU=View or select from items that you lend out temporarily to customers to replace items that they have in service.];
                      ApplicationArea=#Service;
                      RunObject=Page 5922;
                      Promoted=No;
                      Image=Loaner;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Separator ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      IsHeader=Yes }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Serviceartikel&kladde;
                                 ENU=Service Item &Worksheet];
                      ToolTipML=[DAN=Forbered registrering af serviceÜbningstiderne og de anvendte reservedele, reparationsstatus, bemërkninger til fejl og kostpris.;
                                 ENU=Prepare to record service hours and spare parts used, repair status, fault comments, and cost.];
                      ApplicationArea=#Service;
                      RunObject=Page 5906;
                      Image=ServiceItemWorksheet }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 1900744308;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9066;
                PartType=Page }

    { 1900724708;1;Group   }

    { 8   ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 1907692008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9150;
                PartType=Page }

    { 4   ;2   ;Part      ;
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

