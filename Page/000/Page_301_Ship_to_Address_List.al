OBJECT Page 301 Ship-to Address List
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
    CaptionML=[DAN=Lev.adresseoversigt;
               ENU=Ship-to Address List];
    SourceTable=Table222;
    DataCaptionFields=Customer No.;
    PageType=List;
    CardPageID=Ship-to Address;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Adresse;
                                 ENU=&Address];
                      Image=Addresses }
      { 1102601000;2 ;Action    ;
                      CaptionML=[DAN=Online Map;
                                 ENU=Online Map];
                      ToolTipML=[DAN=Vis adressen p† et onlinekort.;
                                 ENU=View the address on an online map.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Map;
                      OnAction=BEGIN
                                 DisplayMap;
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en leveringsadressekode.;
                           ENU=Specifies a ship-to address code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den, der modtager varerne p† leveringsadressen.;
                           ENU=Specifies the name associated with the ship-to address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver leveringsadressen.;
                           ENU=Specifies the ship-to address.];
                ApplicationArea=#Advanced;
                SourceExpr=Address;
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Advanced;
                SourceExpr="Address 2";
                Visible=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Advanced;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den by, som varerne leveres til.;
                           ENU=Specifies the city the items are being shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver modtagerens telefonnummer.;
                           ENU=Specifies the recipient's telephone number.];
                ApplicationArea=#Advanced;
                SourceExpr="Phone No.";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver modtagerens faxnummer.;
                           ENU=Specifies the recipient's fax number.];
                ApplicationArea=#Advanced;
                SourceExpr="Fax No.";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† en fast kontaktperson, som h†ndterer ordrer, der sendes til denne adresse.;
                           ENU=Specifies the name of the person you contact about orders shipped to this address.];
                ApplicationArea=#Advanced;
                SourceExpr=Contact;
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokationskode der skal benyttes til modtageren.;
                           ENU=Specifies the location code to be used for the recipient.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

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

