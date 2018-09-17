OBJECT Page 5949 Posted Serv. Shpt. Line List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Bogf. serviceleverancelinjeoversigt;
               ENU=Posted Serv. Shpt. Line List];
    SourceTable=Table5991;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 85      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 86      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vi&s bilag;
                                 ENU=&Show Document];
                      ToolTipML=[DAN=èbn det bilag, som oplysningerne pÜ linjen stammer fra.;
                                 ENU=Open the document that the information on the line comes from.];
                      ApplicationArea=#Service;
                      RunObject=Page 5975;
                      RunPageLink=No.=FIELD(Document No.);
                      Image=View }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicelinjen blev bogfõrt.;
                           ENU=Specifies the date when the service line was posted.];
                ApplicationArea=#Service;
                SourceExpr="Posting Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ leverancelinjen.;
                           ENU=Specifies the number of the shipment line.];
                ApplicationArea=#Service;
                SourceExpr="Line No." }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den serviceartikellinje, som servicelinjen er tilknyttet.;
                           ENU=Specifies the number of the service item line to which this service line is linked.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Line No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ leverancen.;
                           ENU=Specifies the number of this shipment.];
                ApplicationArea=#Service;
                SourceExpr="Document No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for leverancelinjen.;
                           ENU=Specifies the type of this shipment line.];
                ApplicationArea=#Service;
                SourceExpr=Type }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret pÜ den serviceartikel, som leverancelinjen er tilknyttet.;
                           ENU=Specifies the serial number of the service item to which this shipment line is linked.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Service Item Serial No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, eksempelvis lagersted eller distributionscenter, som varerne pÜ linjen skal tages fra, og hvor de skal registreres.;
                           ENU=Specifies the location, such as warehouse or distribution center, from which the items should be taken and where they should be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede ordre blev oprettet.;
                           ENU=Specifies the date when the related order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Date" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som ejer varerne pÜ serviceordren.;
                           ENU=Specifies the number of the customer who owns the items on the service order.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogsÜ i tilfëlde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af en vare, ressource, omkostning eller standardtekst pÜ servicelinjen.;
                           ENU=Specifies the description of an item, resource, cost, or a standard text on the service line.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende beskrivelse af varen, ressourcen eller omkostningen.;
                           ENU=Specifies an additional description of the item, resource, or cost.];
                ApplicationArea=#Service;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder, ressourcetimer, finanskontobetalinger eller omkostninger, der er leveret til debitoren.;
                           ENU=Specifies the number of item units, resource hours, general ledger account payments, or cost that have been shipped to the customer.];
                ApplicationArea=#Service;
                SourceExpr=Quantity }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for Çn enhed af varen eller ressourcen. Du kan angive en pris manuelt eller fÜ den angivet i henhold til feltet Avancepct.beregning pÜ det dertilhõrende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Service;
                SourceExpr="Unit Price" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen pÜ linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Service;
                SourceExpr="Line Discount %" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ linjen i vinduet Komponentoversigt - serviceart.;
                           ENU=Specifies the number of the line in the Service Item Component List window.];
                ApplicationArea=#Service;
                SourceExpr="Component Line No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den serviceartikelkomponent, der er erstattet med varen pÜ servicelinjen.;
                           ENU=Specifies the number of the service item component replaced by the item on the service line.];
                ApplicationArea=#Service;
                SourceExpr="Replaced Item No." }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varen er anvendt til at erstatte hele serviceartiklen, en af serviceartikelkomponenterne, installeret som en ny komponent eller blot anvendt som et supplerende vërktõj i serviceprocessen.;
                           ENU=Specifies whether the item has been used to replace the whole service item, one of the service item components, installed as a new component, or as a supplementary tool in the service process.];
                ApplicationArea=#Service;
                SourceExpr="Spare Part Action";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fejlÜrsagskoden for serviceleverancelinjen.;
                           ENU=Specifies the code of the fault reason for the service shipment line.];
                ApplicationArea=#Service;
                SourceExpr="Fault Reason Code";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at garantirabatten er udelukket pÜ denne serviceleverancelinje.;
                           ENU=Specifies that the warranty discount is excluded on this service shipment line.];
                ApplicationArea=#Service;
                SourceExpr="Exclude Warranty" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der gives en garantirabat pÜ serviceleverancelinjen af typen Vare eller Ressource.;
                           ENU=Specifies that a warranty discount is available on this service shipment line of type Item or Resource.];
                ApplicationArea=#Service;
                SourceExpr=Warranty }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kontrakt, som er knyttet til den bogfõrte serviceordre.;
                           ENU=Specifies the number of the contract associated with the posted service order.];
                ApplicationArea=#Service;
                SourceExpr="Contract No." }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontraktrabatprocent, der gëlder for varerne, ressourcerne og omkostningerne pÜ serviceleverancelinjen.;
                           ENU=Specifies the contract discount percentage valid for the items, resources, and costs on the service shipment line.];
                ApplicationArea=#Service;
                SourceExpr="Contract Disc. %" }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af garantirabatten, der gëlder for varerne eller ressourcerne pÜ serviceleverancelinjen.;
                           ENU=Specifies the percentage of the warranty discount valid for the items or resources on the service shipment line.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Disc. %" }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Service;
                SourceExpr="Unit Cost (LCY)" }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den type arbejde, der er udfõrt ifõlge den bogfõrte serviceordre.;
                           ENU=Specifies a code for the type of work performed under the posted service order.];
                ApplicationArea=#Service;
                SourceExpr="Work Type Code";
                Visible=FALSE }

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

