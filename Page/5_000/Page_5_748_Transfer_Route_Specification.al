OBJECT Page 5748 Transfer Route Specification
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Overflytningsrutespec.;
               ENU=Trans. Route Spec.];
    SourceTable=Table5742;
    PageType=Card;
    OnInit=BEGIN
             CurrPage.LOOKUPMODE := TRUE;
           END;

    OnClosePage=BEGIN
                  IF GET("Transfer-from Code","Transfer-to Code") THEN BEGIN
                    IF ("Shipping Agent Code" = '') AND
                       ("Shipping Agent Service Code" = '') AND
                       ("In-Transit Code" = '')
                    THEN
                      DELETE;
                  END;
                END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transitkoden for overflytningsordren, f.eks. en spedit›r.;
                           ENU=Specifies the in-transit code for the transfer order, such as a shipping agent.];
                ApplicationArea=#Location;
                SourceExpr="In-Transit Code" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit›r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Agent Code" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit›ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Agent Service Code" }

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

