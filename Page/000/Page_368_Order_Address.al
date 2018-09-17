OBJECT Page 368 Order Address
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bestillingsadresse;
               ENU=Order Address];
    SourceTable=Table224;
    DataCaptionExpr=Caption;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Adresse;
                                 ENU=&Address];
                      Image=Addresses }
      { 39      ;2   ;Separator  }
      { 40      ;2   ;Action    ;
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
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en bestillingsadressekode.;
                           ENU=Specifies an order-from address code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den virksomhed, der befinder sig p† adressen.;
                           ENU=Specifies the name of the company located at the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver vejnavnet.;
                           ENU=Specifies the street address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver amtet i adressen.;
                           ENU=Specifies the county of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=County }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den person, du normalt er i kontakt med, n†r du handler med kreditoren p† denne adresse.;
                           ENU=Specifies the name of the person you regularly contact when you do business with this vendor at this address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r der sidst blev rettet i bestillingsadressen.;
                           ENU=Specifies when this order address was last modified.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Date Modified" }

    { 1902768601;1;Group  ;
                CaptionML=[DAN=Kommunikation;
                           ENU=Communication] }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det telefonnummer, der er tilknyttet bestillingsadressen.;
                           ENU=Specifies the telephone number that is associated with the order address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det faxnummer, der er tilknyttet bestillingsadressen.;
                           ENU=Specifies the fax number associated with the order address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fax No." }

    { 32  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver bestillingsadressens mailadresse.;
                           ENU=Specifies the email address associated with the order address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver modtagerens websted.;
                           ENU=Specifies the recipient's web site.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Home Page" }

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

