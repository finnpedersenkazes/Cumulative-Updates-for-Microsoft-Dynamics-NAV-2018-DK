OBJECT Page 461 Inventory Setup
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ops‘tning af Lager;
               ENU=Inventory Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table313;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Generelt,Bogf›ring,Kladdetyper;
                                ENU=New,Process,Report,General,Posting,Journal Templates];
    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;
               END;

    ActionList=ACTIONS
    {
      { 21      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=Lagerperioder;
                                 ENU=Inventory Periods];
                      ToolTipML=[DAN=Ops‘t perioder i kombinationer med dine regnskabsperioder, der definerer, hvorn†r du kan bogf›re transaktioner, der p†virker v‘rdien af din varebeholdning. N†r du lukker lagerperioden, kan du ikke bogf›re ‘ndringer af lagerv‘rdien, hverken den forventede eller faktiske v‘rdi, f›r lagerperiodens slutdato.;
                                 ENU=Set up periods in combinations with your accounting periods that define when you can post transactions that affect the value of your item inventory. When you close an inventory period, you cannot post any changes to the inventory value, either expected or actual value, before the ending date of the inventory period.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5828;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Period;
                      PromotedCategory=Category4 }
      { 17      ;1   ;Action    ;
                      CaptionML=[DAN=Enheder;
                                 ENU=Units of Measure];
                      ToolTipML=[DAN=Ops‘t de enheder, f.eks. PSC eller TIME, som du kan v‘lge mellem, i vinduet Enheder, som du har adgang til fra varekortet.;
                                 ENU=Set up the units of measure, such as PSC or HOUR, that you can select from in the Item Units of Measure window that you access from the item card.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 209;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=UnitOfMeasure;
                      PromotedCategory=Category4 }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Varerabatgrupper;
                                 ENU=Item Discount Groups];
                      ToolTipML=[DAN=Ops‘t rabatgruppekoder, som du kan bruge som kriterier, n†r du definerer s‘rlige rabatter p† et debitor-, kreditor- eller varekort.;
                                 ENU=Set up discount group codes that you can use as criteria when you define special discounts on a customer, vendor, or item card.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 513;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Discount;
                      PromotedCategory=Category4 }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogf›ring;
                                 ENU=Posting] }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Ops‘tning af varebogf›ring;
                                 ENU=Inventory Posting Setup];
                      ToolTipML=[DAN=Ops‘t links mellem varebogf›ringsgrupper, lagerlokationer og finanskonti for at definere, hvor transaktioner for lagervarer registreres i finansbogholderiet.;
                                 ENU=Set up links between inventory posting groups, inventory locations, and general ledger accounts to define where transactions for inventory items are recorded in the general ledger.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5826;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostedInventoryPick;
                      PromotedCategory=Category5 }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Varebogf›ringsgrupper;
                                 ENU=Inventory Posting Groups];
                      ToolTipML=[DAN=Ops‘t de bogf›ringsgrupper, du tildeler til varekort, for at knytte forretningstransaktioner for varen til en lagerkonto i finansbogholderiet for at gruppere bel›b for den p†g‘ldende varetype.;
                                 ENU=Set up the posting groups that you assign to item cards to link business transactions made for the item with an inventory account in the general ledger to group amounts for that item type.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 112;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ItemGroup;
                      PromotedCategory=Category5 }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Kladdetyper;
                                 ENU=Journal Templates] }
      { 5       ;2   ;Action    ;
                      CaptionML=[DAN=Varekladdetyper;
                                 ENU=Item Journal Templates];
                      ToolTipML=[DAN=Ops‘t nummerserier og †rsagskoder i de kladder, du bruger til lagerregulering. Ved at bruge de forskellige kladder kan du udforme vinduer med forskelligt layout, og du kan tildele sporingskoder, nummerserier og rapporter til hver kladde.;
                                 ENU=Set up number series and reason codes in the journals that you use for inventory adjustment. By using different templates you can design windows with different layouts and you can assign trace codes, number series, and reports to each template.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 102;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=JournalSetup;
                      PromotedCategory=Category6 }
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
                ToolTipML=[DAN=Angiver, at funktionen Aut. lagerv‘rdibogf›ring anvendes.;
                           ENU=Specifies that the Automatic Cost Posting function is used.];
                ApplicationArea=#Advanced;
                SourceExpr="Automatic Cost Posting" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver muligheden af at bogf›re forventede omkostninger p† mellemregningskonti i finansregnskabet.;
                           ENU=Specifies the ability to post expected costs to interim accounts in the general ledger.];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Cost Posting to G/L";
                Importance=Additional }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der reguleres for eventuelle kostpris‘ndringer, n†r du bogf›rer lagertransaktioner.;
                           ENU=Specifies whether to adjust for any cost changes when you post inventory transactions.];
                ApplicationArea=#Advanced;
                SourceExpr="Automatic Cost Adjustment" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardmetoden for kostprisberegning.;
                           ENU=Specifies default costing method.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Default Costing Method" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om, hvilken metode der anvendes til beregning af den gennemsnitlige kostpris.;
                           ENU=Specifies information about the method that the program uses to calculate average cost.];
                OptionCaptionML=[DAN=,Vare,Vare & Lokation & Variant;
                                 ENU=,Item,Item & Location & Variant];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Average Cost Calc. Type";
                Importance=Additional }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tidsperiode, der er brugt til at beregne den v‘gtede gennemsnitsomkostning for varer, der anvender metoden til beregning af gennemsnitlig omkostning.;
                           ENU=Specifies the period of time used to calculate the weighted average cost of items that apply the average costing method.];
                OptionCaptionML=[DAN=,Dag,Uge,M†ned,,,Regnskabsperiode;
                                 ENU=,Day,Week,Month,,,Accounting Period];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Average Cost Period";
                Importance=Additional }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at de bem‘rkninger, der angives p† overflytningsordren, kopieres til overflytningsleverancen.;
                           ENU=Specifies that you want the program to copy the comments entered on the transfer order to the transfer shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Copy Comments Order to Shpt.";
                Importance=Additional }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at de bem‘rkninger, der angives p† overflytningsordren, kopieres til overflytningsmodtagelsen.;
                           ENU=Specifies that you want the program to copy the comments entered on the transfer order to the transfer receipt.];
                ApplicationArea=#Advanced;
                SourceExpr="Copy Comments Order to Rcpt.";
                Importance=Additional }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver en datoformel for den tid, det tager at g›re varerne klar til forsendelse fra denne lokation. Tidselementet anvendes ved beregning af leveringsdatoen p† f›lgende m†de: Afsendelsesdato + Udg†ende lagerekspeditionstid = Planlagt afsendelsesdato + Transporttid = Planlagt leveringsdato.";
                           ENU="Specifies a date formula for the time it takes to get items ready to ship from this location. The time element is used in the calculation of the delivery date as follows: Shipment Date + Outbound Warehouse Handling Time = Planned Shipment Date + Shipping Time = Planned Delivery Date."];
                ApplicationArea=#Warehouse;
                SourceExpr="Outbound Whse. Handling Time";
                Importance=Additional }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tid, det tager at g›re varer tilg‘ngelige fra lageret, efter varerne er bogf›rt som modtaget.;
                           ENU=Specifies the time it takes to make items part of available inventory, after the items have been posted as received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Inbound Whse. Handling Time";
                Importance=Additional }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du kan bogf›re transaktioner, der vil bringe lagerniveauet under nul.;
                           ENU=Specifies if you can post transactions that will bring inventory levels below zero.];
                ApplicationArea=#Advanced;
                SourceExpr="Prevent Negative Inventory" }

    { 1904339001;1;Group  ;
                CaptionML=[DAN=Lokation;
                           ENU=Location] }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varer skal have en lokationskode, for at de kan bogf›res.;
                           ENU=Specifies whether items must have a location code in order to be posted.];
                ApplicationArea=#Location;
                SourceExpr="Location Mandatory" }

    { 1900309501;1;Group  ;
                CaptionML=[DAN=Dimensioner;
                           ENU=Dimensions] }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionskode, der skal bruges for produktgrupper i analyserapporter.;
                           ENU=Specifies the dimension code that you want to use for product groups in analysis reports.];
                ApplicationArea=#Suite;
                SourceExpr="Item Group Dimension Code" }

    { 1904569201;1;Group  ;
                CaptionML=[DAN=Nummerering;
                           ENU=Numbering] }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til varer.;
                           ENU=Specifies the number series code that will be used to assign numbers to items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Nos." }

    { 16  ;2   ;Field     ;
                CaptionML=[DAN=Varekatalognumre;
                           ENU=Non-stock Item Nos.];
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til katalogvarer.;
                           ENU=Specifies the number series that is used for nonstock items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Nonstock Item Nos.";
                Importance=Additional }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der automatisk bruges til at tildele numre til overflytningsordrer.;
                           ENU=Specifies the number series code that the program uses to assign numbers to transfer orders.];
                ApplicationArea=#Location;
                SourceExpr="Transfer Order Nos.";
                Importance=Additional }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der automatisk bruges til at tildele numre til bogf›rte overflytningsleverancer.;
                           ENU=Specifies the number series code that the program uses to assign numbers to posted transfer shipments.];
                ApplicationArea=#Location;
                SourceExpr="Posted Transfer Shpt. Nos.";
                Importance=Additional }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til bogf›rte overflytningsmodtagelsesbilag.;
                           ENU=Specifies the number series code that will be used to assign numbers to posted transfer receipt documents.];
                ApplicationArea=#Location;
                SourceExpr="Posted Transfer Rcpt. Nos.";
                Importance=Additional }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til l‘g-p†-lager-aktiviteter.;
                           ENU=Specifies the number series code to assign numbers to inventory put-always.];
                ApplicationArea=#Warehouse;
                SourceExpr="Inventory Put-away Nos.";
                Importance=Additional }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til bogf›rte l‘g-p†-lager-aktiviteter.;
                           ENU=Specifies the number series code to assign numbers to posted inventory put-always.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posted Invt. Put-away Nos.";
                Importance=Additional }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til pluk fra lageret.;
                           ENU=Specifies the number series code to assign numbers to inventory picks.];
                ApplicationArea=#Warehouse;
                SourceExpr="Inventory Pick Nos.";
                Importance=Additional }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til bogf›rte pluk fra lageret.;
                           ENU=Specifies the number series code to assign numbers to posted inventory picks.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posted Invt. Pick Nos.";
                Importance=Additional }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til flytninger p† lageret.;
                           ENU=Specifies the number series code used to assign numbers to inventory movements.];
                ApplicationArea=#Warehouse;
                SourceExpr="Inventory Movement Nos.";
                Importance=Additional }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til registrerede flytninger p† lageret.;
                           ENU=Specifies the number series code to assign numbers to registered inventory movements.];
                ApplicationArea=#Warehouse;
                SourceExpr="Registered Invt. Movement Nos.";
                Importance=Additional }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til interne flytninger.;
                           ENU=Specifies the number series code used to assign numbers to internal movements.];
                ApplicationArea=#Warehouse;
                SourceExpr="Internal Movement Nos.";
                Importance=Additional }

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

    BEGIN
    END.
  }
}

