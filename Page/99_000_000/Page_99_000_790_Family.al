OBJECT Page 99000790 Family
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Familie;
               ENU=Family];
    SourceTable=Table99000773;
    PageType=ListPlus;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

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
                SourceExpr="Description 2" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at s›ge efter den ›nskede record, hvis du ikke kan huske v‘rdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Search Name" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rute, der bruges til produktionen af familien.;
                           ENU=Specifies the number of the routing which is used for the production of the family.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing No." }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Blocked }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r stamdataene for denne produktionsfamilie sidst er ‘ndret.;
                           ENU=Specifies when the standard data of this production family was last modified.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Last Date Modified" }

    { 13  ;1   ;Part      ;
                ApplicationArea=#Manufacturing;
                SubPageView=SORTING(Family No.,Line No.);
                SubPageLink=Family No.=FIELD(No.);
                PagePartID=Page99000792;
                PartType=Page }

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

