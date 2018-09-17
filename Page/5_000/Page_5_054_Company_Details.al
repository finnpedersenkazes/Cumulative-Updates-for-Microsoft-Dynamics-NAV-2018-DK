OBJECT Page 5054 Company Details
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Virksomhedsoplysninger;
               ENU=Company Details];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table5050;
    PageType=Card;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontakten. Hvis kontakten er en person, kan du klikke p† feltet og f† vist vinduet Navneoplysninger.;
                           ENU=Specifies the name of the contact. If the contact is a person, you can click the field to see the Name Details window.];
                ApplicationArea=#All;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens adresse.;
                           ENU=Specifies the contact's address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen, hvor kontakten har adresse.;
                           ENU=Specifies the city where the contact is located.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens telefonnummer.;
                           ENU=Specifies the contact's phone number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens faxnummer.;
                           ENU=Specifies the contact's fax number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fax No." }

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

