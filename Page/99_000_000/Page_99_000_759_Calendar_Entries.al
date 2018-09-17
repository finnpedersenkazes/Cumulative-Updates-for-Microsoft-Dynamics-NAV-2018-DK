OBJECT Page 99000759 Calendar Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kalenderposter;
               ENU=Calendar Entries];
    SourceTable=Table99000757;
    DataCaptionExpr=Caption;
    DelayedInsert=Yes;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen af kapacitet for kalenderposten.;
                           ENU=Specifies the type of capacity for the calendar entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Capacity Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som kapaciteten vedr›rer.;
                           ENU=Specifies the date when this capacity refers to.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Date;
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det arbejdsskift, som kapaciteten vedr›rer.;
                           ENU=Specifies code for the work shift that the capacity refers to.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Shift Code" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Startdato/tidspunkt.;
                           ENU=Specifies the date and the starting time, which are combined in a format called "starting date-time".];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Date-Time" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl‘ttet for kalenderposten.;
                           ENU=Specifies the starting time of this calendar entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Time";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Slutdato/tidspunkt.;
                           ENU=Specifies the date and the ending time, which are combined in a format called "ending date-time".];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Date-Time";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutklokkesl‘ttet for kalenderposten.;
                           ENU=Specifies the ending time of this calendar entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Time" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver effektiviteten for kalenderposten.;
                           ENU=Specifies the efficiency of this calendar entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Efficiency }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kapaciteten for kalenderposten.;
                           ENU=Specifies the capacity of this calendar entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Capacity }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede kapacitet for kalenderposten.;
                           ENU=Specifies the total capacity of this calendar entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Capacity (Total)" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den effektive kapacitet for kalenderposten.;
                           ENU=Specifies the effective capacity of this calendar entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Capacity (Effective)" }

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

