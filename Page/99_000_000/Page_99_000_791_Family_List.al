OBJECT Page 99000791 Family List
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
    CaptionML=[DAN=Familieoversigt;
               ENU=Family List];
    SourceTable=Table99000773;
    PageType=List;
    CardPageID=Family;
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
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af en produktionsfamilie.;
                           ENU=Specifies a description for a product family.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende beskrivelse af produktfamilien, hvis der ikke er plads nok i feltet Beskrivelse.;
                           ENU=Specifies an additional description of the product family if there is not enough space in the Description field.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rute, der bruges til produktionen af familien.;
                           ENU=Specifies the number of the routing which is used for the production of the family.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing No." }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Blocked;
                Visible=FALSE }

    { 1102601002;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn†r stamdataene for denne produktionsfamilie sidst er ‘ndret.;
                           ENU=Specifies when the standard data of this production family was last modified.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Last Date Modified";
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

