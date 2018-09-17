OBJECT Page 5790 Shipping Agent Services
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Spedit›rservice;
               ENU=Shipping Agent Services];
    SourceTable=Table5790;
    DataCaptionFields=Shipping Agent Code;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver spedit›ren.;
                           ENU=Specifies the shipping agent.];
                ApplicationArea=#Suite;
                SourceExpr=Code }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af spedit›ren.;
                           ENU=Specifies a description of the shipping agent.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid der g†r, fra varerne er sendt fra lageret, til de er leveret.;
                           ENU=Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Time" }

    { 2   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver en redigerbar kalender for leveringsplanl‘gning, der indeholder spedit›rens arbejdsdage og fridage.;
                           ENU=Specifies a customizable calendar for shipment planning that holds the shipping agent's working days and holidays.];
                ApplicationArea=#Advanced;
                SourceExpr="Base Calendar Code" }

    { 13  ;2   ;Field     ;
                Name=CustomizedCalendar;
                CaptionML=[DAN=Tilpasset kalender;
                           ENU=Customized Calendar];
                ToolTipML=[DAN=Angiver, om du har oprettet en tilpasset kalender for spedit›ren.;
                           ENU=Specifies if you have set up a customized calendar for the shipping agent.];
                ApplicationArea=#Advanced;
                SourceExpr=CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."Source Type"::"Shipping Agent","Shipping Agent Code",Code,"Base Calendar Code");
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              TESTFIELD("Base Calendar Code");
                              CalendarMgmt.ShowCustomizedCalendar(
                                CustomizedCalEntry."Source Type"::"Shipping Agent","Shipping Agent Code",Code,"Base Calendar Code");
                            END;
                             }

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
      CustomizedCalEntry@1001 : Record 7603;
      CustomizedCalendar@1003 : Record 7602;
      CalendarMgmt@1000 : Codeunit 7600;

    BEGIN
    END.
  }
}

