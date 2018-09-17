OBJECT Page 5524 Get Alternative Supply
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
    CaptionML=[DAN=Hent alternativ forsyning;
               ENU=Get Alternative Supply];
    SourceTable=Table246;
    DataCaptionFields=No.,Description;
    PageType=Worksheet;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 25  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lagerlokation, hvor de bestilte varer skal registreres p†.;
                           ENU=Specifies a code for an inventory location where the items that are being ordered will be registered.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver behovsdatoen for det behov, som planl‘gningslinjen repr‘senterer.;
                           ENU=Specifies the demanded date of the demand that the planning line represents.];
                ApplicationArea=#Advanced;
                SourceExpr="Demand Date" }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                Name=No.2;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tekst, der beskriver posten.;
                           ENU=Specifies text that describes the entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the code of the location that items are transferred from.];
                ApplicationArea=#Advanced;
                SourceExpr="Transfer-from Code" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den behovsm‘ngde, som ikke er tilg‘ngelig og skal bestilles for at opfylde det behov, som er anf›rt p† planl‘gningslinjen.;
                           ENU=Specifies the demand quantity that is not available and must be ordered to meet the demand represented on the planning line.];
                ApplicationArea=#Advanced;
                SourceExpr="Needed Quantity" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure Code";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                CaptionML=[DAN=Disponibelt antal;
                           ENU=Available Quantity];
                ToolTipML=[DAN=Angiver, hvor stor en andel af behovsm‘ngden der er tilg‘ngelig.;
                           ENU=Specifies how many of the demand quantity are available.];
                ApplicationArea=#Advanced;
                SourceExpr="Demand Qty. Available" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet for det behov, som planl‘gningslinjen repr‘senterer.;
                           ENU=Specifies the quantity on the demand that the planning line represents.];
                ApplicationArea=#Advanced;
                SourceExpr="Demand Quantity";
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

