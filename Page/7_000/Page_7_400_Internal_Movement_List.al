OBJECT Page 7400 Internal Movement List
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
    CaptionML=[DAN=Oversigt over intern flytning;
               ENU=Internal Movement List];
    SourceTable=Table7346;
    PageType=List;
    CardPageID=Internal Movement;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Intern flytning;
                                 ENU=&Internal Movement];
                      Image=CreateMovement }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Internal Movement),
                                  Type=CONST(" "),
                                  No.=FIELD(No.);
                      Image=ViewComments }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor den interne flytning udf›res.;
                           ENU=Specifies the code of the location where the internal movement is being performed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne i den interne flytning skal placeres, n†r de er blevet plukket.;
                           ENU=Specifies the bin where you want items on this internal movement to be placed when they are picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Bin Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal v‘re afsluttet.;
                           ENU=Specifies the date when the warehouse activity must be completed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken metode de interne flytninger sorteres med.;
                           ENU=Specifies the method by which the internal movements are sorted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

