OBJECT Page 369 Order Address List
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
    CaptionML=[DAN=Bestillingsadresseoversigt;
               ENU=Order Address List];
    SourceTable=Table224;
    DataCaptionFields=Vendor No.;
    PageType=List;
    CardPageID=Order Address;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Adresse;
                                 ENU=&Address];
                      Image=Addresses }
      { 1102601001;2 ;Separator  }
      { 1102601002;2 ;Action    ;
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
                ToolTipML=[DAN=Angiver en bestillingsadressekode.;
                           ENU=Specifies an order-from address code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedsnavnet p† bestillingsadressen.;
                           ENU=Specifies the company name for the order address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bestillingsadressen.;
                           ENU=Specifies the order address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address;
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen p† bestillingsadressen.;
                           ENU=Specifies the city of the order address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det telefonnummer, der er tilknyttet bestillingsadressen.;
                           ENU=Specifies the telephone number that is associated with the order address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No.";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det faxnummer, der er tilknyttet adressen.;
                           ENU=Specifies the fax number associated with the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fax No.";
                Visible=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den person, du normalt er i kontakt med, n†r du handler med kreditoren p† denne adresse.;
                           ENU=Specifies the name of the person you regularly contact when you do business with this vendor at this address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact;
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

