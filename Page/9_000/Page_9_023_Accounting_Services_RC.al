OBJECT Page 9023 Accounting Services RC
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@=Use same translation as 'Profile Description' (if applicable);
               DAN=Udliciteret regnskabschef;
               ENU=Outsourced Accounting Manager];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 7       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 6       ;1   ;ActionGroup;
                      CaptionML=[DAN=Ny;
                                 ENU=New] }
      { 5       ;2   ;Action    ;
                      CaptionML=[DAN=Salgstilbud;
                                 ENU=Sales Quote];
                      ToolTipML=[DAN=Tilbyd varer eller servicer til en debitor.;
                                 ENU=Offer items or services to a customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 41;
                      Image=NewSalesQuote;
                      RunPageMode=Create }
      { 4       ;2   ;Action    ;
                      CaptionML=[DAN=Salgsfaktura;
                                 ENU=Sales Invoice];
                      ToolTipML=[DAN=Opret en ny faktura for salget af varer eller servicer. Fakturamëngder kan ikke bogfõres delvist.;
                                 ENU=Create a new invoice for the sales of items or services. Invoice quantities cannot be posted partially.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 43;
                      Image=NewSalesInvoice;
                      RunPageMode=Create }
      { 14      ;0   ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 22 }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 31 }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Bogf. salgsfakturaer;
                                 ENU=Posted Sales Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgsfakturaer.;
                                 ENU=Open the list of posted sales invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 143 }
    }
  }
  CONTROLS
  {
    { 13  ;0   ;Container ;
                ContainerType=RoleCenterArea }

    { 1   ;1   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page9070;
                PartType=Page }

    { 2   ;1   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page9150;
                PartType=Page }

  }
  CODE
  {

    BEGIN
    END.
  }
}

