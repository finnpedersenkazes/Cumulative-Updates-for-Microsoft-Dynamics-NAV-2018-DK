OBJECT Page 5406 Prod. Order Line List
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
    CaptionML=[DAN=Prod.ordrelinjeoversigt;
               ENU=Prod. Order Line List];
    SourceTable=Table5406;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  CLEAR(ShortcutDimCode);
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 17      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=èbn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Manufacturing;
                      Image=View;
                      OnAction=VAR
                                 ProdOrder@1000 : Record 5405;
                               BEGIN
                                 ProdOrder.GET(Status,"Prod. Order No.");
                                 CASE Status OF
                                   Status::Planned:
                                     PAGE.RUN(PAGE::"Planned Production Order",ProdOrder);
                                   Status::"Firm Planned":
                                     PAGE.RUN(PAGE::"Firm Planned Prod. Order",ProdOrder);
                                   Status::Released:
                                     PAGE.RUN(PAGE::"Released Production Order",ProdOrder);
                                 END;
                               END;
                                }
      { 49      ;2   ;Action    ;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=Reservationsposter;
                                 ENU=Reservation Entries];
                      ToolTipML=[DAN=Vis posterne for hver reservation, der er foretaget, enten manuelt eller automatisk.;
                                 ENU=View the entries for every reservation that is made, either manually or automatically.];
                      ApplicationArea=#Manufacturing;
                      Image=ReservationLedger;
                      OnAction=BEGIN
                                 ShowReservationEntries(TRUE);
                               END;
                                }
      { 50      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen pÜ bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
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

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en vërdi, der kopieres fra det tilsvarende felt pÜ produktionsordrehovedet.;
                           ENU=Specifies a value that is copied from the corresponding field on the production order header.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Status }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Prod. Order No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den vare, der skal produceres.;
                           ENU=Specifies the number of the item that is to be produced.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Item No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver vërdien i feltet Beskrivelse pÜ varekortet. Hvis du angiver en variantkode, kopieres variantbeskrivelsen til feltet i stedet for.;
                           ENU=Specifies the value of the Description field on the item card. If you enter a variant code, the variant description is copied to this field instead.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en ekstra beskrivelse.;
                           ENU=Specifies an additional description.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[3];
                CaptionClass='1,2,3';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 302 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[4];
                CaptionClass='1,2,4';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 304 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[5];
                CaptionClass='1,2,5';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(5),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 306 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[6];
                CaptionClass='1,2,6';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(6),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 308 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[7];
                CaptionClass='1,2,7';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(7),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 310 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[8];
                CaptionClass='1,2,8';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(8),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationskoden, hvis de producerede varer skal opbevares pÜ en bestemt lokation.;
                           ENU=Specifies the location code, if the produced items should be stored in a specific location.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=TRUE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal produceres, hvis du udfylder linjen manuelt.;
                           ENU=Specifies the quantity to be produced if you manually fill in this line.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Quantity }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor stor en del af antallet pÜ linjen der er produceret.;
                           ENU=Specifies how much of the quantity on this line has been produced.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Finished Quantity" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forskellen mellem det fërdige og det planlagte antal, eller angiver 0, hvis det fërdige antal overstiger restantallet.;
                           ENU=Specifies the difference between the finished and planned quantities, or zero if the finished quantity is greater than the remaining quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Remaining Quantity" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af varen, du forventer gÜr til spilde i produktionsprocessen.;
                           ENU=Specifies the percentage of the item that you expect to be scrapped in the production process.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap %";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen, hvor den producerede vare skal vëre tilgëngelig. Datoen kopieres fra hovedet pÜ produktionsordren.;
                           ENU=Specifies the date when the produced item must be available. The date is copied from the header of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Due Date" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens startdato, som hentes fra produktionsordreruten.;
                           ENU=Specifies the entry's starting date, which is retrieved from the production order routing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Date" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens startklokkeslët, som hentes fra produktionsordreruten.;
                           ENU=Specifies the entry's starting time, which is retrieved from the production order routing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Time";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens slutdato, som hentes fra produktionsordreruten.;
                           ENU=Specifies the entry's ending date, which is retrieved from the production order routing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Date" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens slutklokkeslët, som hentes fra produktionsordreruten.;
                           ENU=Specifies the entry's ending time, which is retrieved from the production order routing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Time";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den produktionsstykliste, der er grundlaget for oprettelse af produktionsordrekomponentlisten for denne linje.;
                           ENU=Specifies the number of the production BOM that is the basis for creating the Prod. Order Component list for this line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Production BOM No." }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit Cost" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den totale pris pÜ linjen ved at multiplicere kostprisen med antallet.;
                           ENU=Specifies the total cost on the line by multiplying the unit cost by the quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Cost Amount" }

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
    VAR
      ShortcutDimCode@1000 : ARRAY [8] OF Code[20];

    BEGIN
    END.
  }
}

