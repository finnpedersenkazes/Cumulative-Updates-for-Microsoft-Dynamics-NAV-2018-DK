OBJECT Page 56 Purchase Orders
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
    CaptionML=[DAN=K�bsordrer;
               ENU=Purchase Orders];
    SourceTable=Table39;
    SourceTableView=WHERE(Document Type=FILTER(Order));
    DataCaptionFields=No.;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 32      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=�bn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Suite;
                      RunObject=Page 50;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(Document No.);
                      Image=View }
      { 33      ;2   ;Action    ;
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
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
                ApplicationArea=#Advanced;
                SourceExpr=Type }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Suite;
                SourceExpr="No." }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten for det produkt, der skal k�bes. Hvis du vil tilf�je en ikke-transaktionsbaseret tekstlinje, skal du kun udfylde feltet Beskrivelse.;
                           ENU=Specifies a description of the entry of the product to be purchased. To add a non-transactional text line, fill in the Description field only.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den dato, hvor du forventer, at varerne er tilg�ngelige p� lageret. Hvis du lader feltet v�re tomt, bliver det beregnet p� f�lgende m�de: Planlagt modtagelsesdato + Sikkerhedstid + Indg�ende lagerekspeditionstid = Forventet modtagelsesdato.";
                           ENU="Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date."];
                ApplicationArea=#Suite;
                SourceExpr="Expected Receipt Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Vendor No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret.;
                           ENU=Specifies the document number.];
                ApplicationArea=#Suite;
                SourceExpr="Document No." }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for bel�bene p� k�bslinjen.;
                           ENU=Specifies the code of the currency of the amounts on the purchase line.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der skal angives p� linjen.;
                           ENU=Specifies the number of units of the item that will be specified on the line.];
                ApplicationArea=#Advanced;
                SourceExpr=Quantity }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder p� ordrelinjen der endnu ikke er modtaget.;
                           ENU=Specifies how many units on the order line have not yet been received.];
                ApplicationArea=#Advanced;
                SourceExpr="Outstanding Quantity" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af bel�b i feltet Linjebel�b p� k�bsordrelinjerne.;
                           ENU=Specifies the sum of amounts in the Line Amount field on the purchase order lines.];
                ApplicationArea=#Suite;
                SourceExpr=Amount }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Unit Cost" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p� linjen.;
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

