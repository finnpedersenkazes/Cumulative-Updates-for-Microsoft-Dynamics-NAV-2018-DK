OBJECT Page 5213 Unions
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Fagforeninger;
               ENU=Unions];
    SourceTable=Table5209;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en fagforeningskode.;
                           ENU=Specifies a union code.];
                ApplicationArea=#Advanced;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† fagforeningen.;
                           ENU=Specifies the name of the union.];
                ApplicationArea=#Advanced;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fagforeningens adresse.;
                           ENU=Specifies the union's address.];
                ApplicationArea=#Advanced;
                SourceExpr=Address;
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Advanced;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Advanced;
                SourceExpr=City;
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fagforeningens telefonnummer.;
                           ENU=Specifies the union's telephone number.];
                ApplicationArea=#Advanced;
                SourceExpr="Phone No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af ansatte medlemmer.;
                           ENU=Specifies the number of members employed.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Members Employed" }

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

