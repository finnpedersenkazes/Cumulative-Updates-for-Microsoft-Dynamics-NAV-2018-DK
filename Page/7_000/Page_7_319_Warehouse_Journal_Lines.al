OBJECT Page 7319 Warehouse Journal Lines
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
    CaptionML=[DAN=Lagerkladdelinjer;
               ENU=Warehouse Journal Lines];
    SourceTable=Table7311;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kladdetypen - grundlaget for den kladdek›rsel, som posterne blev bogf›rt fra.;
                           ENU=Specifies the name of the journal template, the basis of the journal batch, that the entries were posted from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Journal Template Name";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som posterne blev bogf›rt fra.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the entries were posted from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Journal Batch Name";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† lagerkladdelinjen.;
                           ENU=Specifies the number of the warehouse journal line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Line No.";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for den transaktion, der vil blive registreret fra linjen.;
                           ENU=Specifies the type of transaction that will be registered from the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Entry Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som kladdelinjen vedr›rer.;
                           ENU=Specifies the code of the location to which the journal line applies.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, som varen p† kladdelinjen hentes fra.;
                           ENU=Specifies the code of the zone from which the item on the journal line is taken.];
                ApplicationArea=#Warehouse;
                SourceExpr="From Zone Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, som varen p† kladdelinjen hentes fra.;
                           ENU=Specifies the code of the bin from which the item on the journal line is taken.];
                ApplicationArea=#Warehouse;
                SourceExpr="From Bin Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens nummer p† kladdelinjen.;
                           ENU=Specifies the number of the item on the journal line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder i reguleringen (opregulering eller nedregulering) eller omposteringen.;
                           ENU=Specifies the number of units of the item in the adjustment (positive or negative) or the reclassification.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet anf›rt som et absolut (positivt) tal i basisenheden.;
                           ENU=Specifies the quantity expressed as an absolute (positive) number, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Absolute, Base)";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, som varen p† kladdelinjen skal flyttes til.;
                           ENU=Specifies the code of the zone to which the item on the journal line will be moved.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Zone Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, som varen p† kladdelinjen skal flyttes til.;
                           ENU=Specifies the code of the bin to which the item on the journal line will be moved.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Bin Code" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Warehouse;
                SourceExpr="Reason Code" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede rumm†l for varerne p† lagerkladdelinjen.;
                           ENU=Specifies the total cubage of the items on the warehouse journal line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Cubage;
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘gten af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the weight of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr=Weight;
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Warehouse;
                SourceExpr="User ID";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange basisenheder der g†r p† den enhed, der er angivet for varen p† kladdelinjen.;
                           ENU=Specifies the number of base units of measure in the unit of measure specified for the item on the journal line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. per Unit of Measure" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

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

