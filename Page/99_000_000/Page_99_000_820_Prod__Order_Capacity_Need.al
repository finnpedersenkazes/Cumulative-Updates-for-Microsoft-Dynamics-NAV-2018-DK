OBJECT Page 99000820 Prod. Order Capacity Need
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
    CaptionML=[DAN=Prod.ordrekapacitetsbehov;
               ENU=Prod. Order Capacity Need];
    SourceTable=Table5410;
    DataCaptionFields=Status,Prod. Order No.;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Prod. Order No.";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kapacitetsbehovets type.;
                           ENU=Specifies the type of capacity need.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Type }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl‘ttet for kapacitetsbehovet.;
                           ENU=Specifies the starting time of the capacity need.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Time" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Startdato/tidspunkt.;
                           ENU=Specifies the date and the starting time, which are combined in a format called "starting date-time".];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Date-Time";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutklokkesl‘ttet for kapacitetsbehovet.;
                           ENU=Specifies the ending time of the capacity need.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Time" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Slutdato/tidspunkt.;
                           ENU=Specifies the date and the ending time, which are combined in a format called "ending date-time".];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Date-Time";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kapacitetsbehovet forekom.;
                           ENU=Specifies the date when this capacity need occurred.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Date }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om send-ahead-antallet er af typen Tilgang, Afgang eller Begge.;
                           ENU=Specifies if the send-ahead quantity is of type Input, Output, or Both.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Send-Ahead Type" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen af klokkesl‘t for kapacitetsbehovet.;
                           ENU=Specifies the time type of the capacity need.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Time Type" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kapacitetsbehovet for planlagte operationer.;
                           ENU=Specifies the capacity need of planned operations.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Allocated Time" }

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

