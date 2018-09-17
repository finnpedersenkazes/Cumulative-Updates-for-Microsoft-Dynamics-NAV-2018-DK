OBJECT Page 904 Assembly List
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
    CaptionML=[DAN=Struktur;
               ENU=Assembly List];
    LinksAllowed=Yes;
    SourceTable=Table900;
    DataCaptionFields=Document Type,No.;
    PageType=List;
    ActionList=ACTIONS
    {
      { 9       ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 5       ;1   ;Action    ;
                      Name=Show Document;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vi&s bilag;
                                 ENU=&Show Document];
                      ToolTipML=[DAN=èbn det bilag, som oplysningerne pÜ linjen stammer fra.;
                                 ENU=Open the document that the information on the line comes from.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=View;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CASE "Document Type" OF
                                   "Document Type"::Quote:
                                     PAGE.RUN(PAGE::"Assembly Quote",Rec);
                                   "Document Type"::Order:
                                     PAGE.RUN(PAGE::"Assembly Order",Rec);
                                   "Document Type"::"Blanket Order":
                                     PAGE.RUN(PAGE::"Blanket Assembly Order",Rec);
                                 END;
                               END;
                                }
      { 4       ;1   ;Action    ;
                      Name=Reservation Entries;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=&Reservationsposter;
                                 ENU=&Reservation Entries];
                      ToolTipML=[DAN=FÜ vist alle reservationer, der er foretaget for varen, enten manuelt eller automatisk.;
                                 ENU=View all reservations that are made for the item, either manually or automatically.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReservationLedger;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowReservationEntries(TRUE);
                               END;
                                }
      { 3       ;1   ;Action    ;
                      Name=Item Tracking Lines;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen pÜ bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ItemTrackingLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 101 ;0   ;Container ;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver montagedokumenttypen, som recorden reprësenterer i ordremontagescenarier.;
                           ENU=Specifies the type of assembly document the record represents in assemble-to-order scenarios.];
                ApplicationArea=#Assembly;
                SourceExpr="Document Type" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No." }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af montageelementet.;
                           ENU=Specifies the description of the assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr=Description }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageelementet skal vëre tilgëngeligt.;
                           ENU=Specifies the date when the assembled item is due to be available for use.];
                ApplicationArea=#Assembly;
                SourceExpr="Due Date" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageordren forventes at starte.;
                           ENU=Specifies the date when the assembly order is expected to start.];
                ApplicationArea=#Assembly;
                SourceExpr="Starting Date" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageordren forventes at slutte.;
                           ENU=Specifies the date when the assembly order is expected to finish.];
                ApplicationArea=#Assembly;
                SourceExpr="Ending Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den vare, der er ved at blive monteret med montageordren.;
                           ENU=Specifies the number of the item that is being assembled with the assembly order.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montageelementet, du forventer at montere med montageordren.;
                           ENU=Specifies how many units of the assembly item that you expect to assemble with the assembly order.];
                ApplicationArea=#Assembly;
                SourceExpr=Quantity }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit Cost" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, som du vil bogfõre afgangen af montageelementet for.;
                           ENU=Specifies the location to which you want to post output of the assembly item.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, som montageelementet er bogfõrt for, som afgang, Her hentes det til lager eller afsendes, hvis det monteres under en salgsordre.;
                           ENU=Specifies the bin the assembly item is posted to as output and from where it is taken to storage or shipped if it is assembled to a sales order.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montageelementet, der mangler at blive bogfõrt som monteret afgang.;
                           ENU=Specifies how many units of the assembly item remain to be posted as assembled output.];
                ApplicationArea=#Assembly;
                SourceExpr="Remaining Quantity" }

    { 102 ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 103 ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 104 ;1   ;Part      ;
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

