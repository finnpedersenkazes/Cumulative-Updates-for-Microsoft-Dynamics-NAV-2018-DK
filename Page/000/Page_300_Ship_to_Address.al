OBJECT Page 300 Ship-to Address
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Leveringsadresse;
               ENU=Ship-to Address];
    SourceTable=Table222;
    DataCaptionExpr=Caption;
    PageType=Card;
    OnNewRecord=VAR
                  Customer@1000 : Record 18;
                BEGIN
                  IF Customer.GET(GetFilterCustNo) THEN BEGIN
                    VALIDATE(Name,Customer.Name);
                    VALIDATE(Address,Customer.Address);
                    VALIDATE("Address 2",Customer."Address 2");
                    VALIDATE(City,Customer.City);
                    VALIDATE(County,Customer.County);
                    VALIDATE("Post Code",Customer."Post Code");
                    VALIDATE("Country/Region Code",Customer."Country/Region Code");
                    VALIDATE(Contact,Customer.Contact);
                  END;
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Adresse;
                                 ENU=&Address];
                      Image=Addresses }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 3   ;2   ;Group     ;
                GroupType=Group }

    { 2   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver en leveringsadressekode.;
                           ENU=Specifies a ship-to address code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den, der modtager varerne p† leveringsadressen.;
                           ENU=Specifies the name associated with the ship-to address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 6   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver leveringsadressen.;
                           ENU=Specifies the ship-to address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 8   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2" }

    { 11  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code" }

    { 10  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den by, som varerne leveres til.;
                           ENU=Specifies the city the items are being shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 28  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 5   ;3   ;Field     ;
                Name=ShowMap;
                ToolTipML=[DAN=Angiver debitorens adresse p† dit foretrukne kortwebsted.;
                           ENU=Specifies the customer's address on your preferred map website.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShowMapLbl;
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              CurrPage.UPDATE(TRUE);
                              DisplayMap;
                            END;

                ShowCaption=No }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver modtagerens telefonnummer.;
                           ENU=Specifies the recipient's telephone number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No.";
                Importance=Additional }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† en fast kontaktperson, som h†ndterer ordrer, der sendes til denne adresse.;
                           ENU=Specifies the name of the person you contact about orders shipped to this address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver modtagerens faxnummer.;
                           ENU=Specifies the recipient's fax number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fax No.";
                Importance=Additional }

    { 38  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver modtagerens mailadresse.;
                           ENU=Specifies the recipient's email address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail";
                Importance=Additional }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver modtagerens websted.;
                           ENU=Specifies the recipient's web site.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Home Page";
                Importance=Additional }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokationskode der skal benyttes til modtageren.;
                           ENU=Specifies the location code to be used for the recipient.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for, hvilken leveringsform der skal benyttes til modtageren.;
                           ENU=Specifies a code for the shipment method to be used for the recipient.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Method Code";
                Importance=Additional }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit›r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipping Agent Code";
                Importance=Additional }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit›ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipping Agent Service Code";
                Importance=Additional }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den servicezone, hvor leveringsadressen er placeret.;
                           ENU=Specifies the code for the service zone in which the ship-to address is located.];
                ApplicationArea=#Service;
                SourceExpr="Service Zone Code" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r der sidst blev rettet i leveringsadressen.;
                           ENU=Specifies when the ship-to address was last modified.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Date Modified";
                Importance=Additional }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens nummer.;
                           ENU=Specifies the customer number.];
                ApplicationArea=#Advanced;
                SourceExpr="Customer No.";
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
    VAR
      ShowMapLbl@1000 : TextConst 'DAN=Vis p† kort;ENU=Show on Map';

    BEGIN
    END.
  }
}

