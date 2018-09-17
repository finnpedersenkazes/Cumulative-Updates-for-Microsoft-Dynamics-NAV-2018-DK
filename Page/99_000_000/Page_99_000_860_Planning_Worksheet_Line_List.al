OBJECT Page 99000860 Planning Worksheet Line List
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
    CaptionML=[DAN=Planl‘gningskladdelinjeliste;
               ENU=Planning Worksheet Line List];
    SourceTable=Table246;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 6500    ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p† bilags- eller kladdelinjen.;
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

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en handling for at genoprette balancen i forholdet mellem udbud og eftersp›rgsel.;
                           ENU=Specifies an action to take to rebalance the demand-supply situation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Action Message" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tekst, der beskriver posten.;
                           ENU=Specifies text that describes the entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ekstra tekst til beskrivelse af posten eller en bem‘rkning om indk›bskladdelinjen.;
                           ENU=Specifies additional text describing the entry, or a remark about the requisition worksheet line.];
                ApplicationArea=#Advanced;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lagerlokation, hvor de bestilte varer skal registreres p†.;
                           ENU=Specifies a code for an inventory location where the items that are being ordered will be registered.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder.;
                           ENU=Specifies the number of units of the item.];
                ApplicationArea=#Advanced;
                SourceExpr=Quantity;
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af varen, du forventer g†r til spilde i produktionsprocessen.;
                           ENU=Specifies the percentage of the item that you expect to be scrapped in the production process.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap %";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du kan forvente at modtage varerne.;
                           ENU=Specifies the date when you can expect to receive the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Due Date" }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl‘ttet for produktionsprocessen.;
                           ENU=Specifies the starting time of the manufacturing process.];
                ApplicationArea=#Advanced;
                SourceExpr="Starting Time";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for produktionsprocessen, hvis den planlagte forsyning er en produktionsordre.;
                           ENU=Specifies the starting date of the manufacturing process, if the planned supply is a production order.];
                ApplicationArea=#Advanced;
                SourceExpr="Starting Date" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutklokkesl‘ttet for produktionsprocessen.;
                           ENU=Specifies the ending time for the manufacturing process.];
                ApplicationArea=#Advanced;
                SourceExpr="Ending Time";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for produktionsprocessen, hvis den planlagte forsyning er en produktionsordre.;
                           ENU=Specifies the ending date of the manufacturing process, if the planned supply is a production order.];
                ApplicationArea=#Advanced;
                SourceExpr="Ending Date" }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver produktionsstyklistenummeret for produktionsordren.;
                           ENU=Specifies the production BOM number for this production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Production BOM No.";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rutenummeret.;
                           ENU=Specifies the routing number.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing No.";
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

