OBJECT Page 99000922 Production Forecast Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Produktionsforecastposter;
               ENU=Production Forecast Entries];
    InsertAllowed=No;
    SourceTable=Table99000852;
    DelayedInsert=Yes;
    PageType=List;
    OnNewRecord=BEGIN
                  "Production Forecast Name" := xRec."Production Forecast Name";
                  "Item No." := xRec."Item No.";
                  "Forecast Date" := xRec."Forecast Date";
                END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† det produktionsforecast, som posten tilh›rer.;
                           ENU=Specifies the name of the production forecast to which the entry belongs.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Production Forecast Name";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver vareidentifikationsnummeret for posten.;
                           ENU=Specifies the item identification number of the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Item No.";
                Editable=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af din forecast.;
                           ENU=Specifies a brief description of your forecast.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i basisenheder for den anf›rte post.;
                           ENU=Specifies the quantity of the entry stated, in base units of measure.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Forecast Quantity (Base)";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for det produktionsforecast, som posten tilh›rer.;
                           ENU=Specifies the date of the production forecast to which the entry belongs.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Forecast Date";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, du har indtastet i produktionsforecastet for det valgte tidsinterval.;
                           ENU=Specifies the quantities you have entered in the production forecast within the selected time interval.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Forecast Quantity";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit of Measure Code";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det gyldige antal enheder, som enhedskoden repr‘senterer for produktionsforecastposten.;
                           ENU=Specifies the valid number of units that the unit of measure code represents for the production forecast entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Qty. per Unit of Measure";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som er knyttet til posten.;
                           ENU=Specifies the code for the location that is linked to the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Location Code";
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at forecastposten g‘lder en komponentvare.;
                           ENU=Specifies that the forecast entry is for a component item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Component Forecast";
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Entry No.";
                Visible=FALSE;
                Editable=FALSE }

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

