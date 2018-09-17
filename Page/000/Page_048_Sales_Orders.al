OBJECT Page 48 Sales Orders
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
    CaptionML=[DAN=Salgsordrer;
               ENU=Sales Orders];
    SourceTable=Table37;
    SourceTableView=WHERE(Document Type=FILTER(Order));
    DataCaptionFields=No.;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 32      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 33      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis ordrer;
                                 ENU=Show Order];
                      ToolTipML=[DAN=F† vist den valgte salgsordre.;
                                 ENU=View the selected sales order.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 42;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(Document No.);
                      Image=ViewOrder }
      { 31      ;2   ;Action    ;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=Reservationsposter;
                                 ENU=Reservation Entries];
                      ToolTipML=[DAN=Vis posterne for hver reservation, der er foretaget, enten manuelt eller automatisk.;
                                 ENU=View the entries for every reservation that is made, either manually or automatically.];
                      ApplicationArea=#Advanced;
                      Image=ReservationLedger;
                      OnAction=BEGIN
                                 ShowReservationEntries(TRUE);
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

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen af objekt, der skal bogf›res for denne salgslinje, f.eks vare, ressource eller finanskonto.;
                           ENU=Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.];
                ApplicationArea=#Advanced;
                SourceExpr=Type }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No." }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten for det produkt, der skal s‘lges. Hvis du vil tilf›je en ikke-transaktionsbaseret tekstlinje, skal du kun udfylde feltet Beskrivelse.;
                           ENU=Specifies a description of the entry of the product to be sold. To add a non-transactional text line, fill in the Description field only.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Customer No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret.;
                           ENU=Specifies the document number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for bel›bet p† denne linje.;
                           ENU=Specifies the currency code for the amount on this line.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder der s‘lges.;
                           ENU=Specifies how many units are being sold.];
                ApplicationArea=#Advanced;
                SourceExpr=Quantity }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder p† ordrelinjen der endnu ikke er leveret.;
                           ENU=Specifies how many units on the order line have not yet been shipped.];
                ApplicationArea=#Advanced;
                SourceExpr="Outstanding Quantity" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure Code" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen vedr›rer, n†r salget er relateret til en sag.;
                           ENU=Specifies which work type the resource applies to when the sale is related to a job.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Type Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af bel›b i feltet Linjebel›b p† salgsordrelinjerne.;
                           ENU=Specifies the sum of amounts in the Line Amount field on the sales order lines.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Price" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p† linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Line Discount %" }

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

