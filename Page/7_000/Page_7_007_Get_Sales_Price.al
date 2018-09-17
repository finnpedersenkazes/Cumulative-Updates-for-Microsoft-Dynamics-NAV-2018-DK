OBJECT Page 7007 Get Sales Price
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
    CaptionML=[DAN=Hent salgspris;
               ENU=Get Sales Price];
    SourceTable=Table7002;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den salgspristype, som definerer, om prisen er for et individ, en gruppe, alle debitorer eller en kampagne.;
                           ENU=Specifies the sales price type, which defines whether the price is for an individual, group, all customers, or a campaign.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken kode der tilh›rer salgstypen.;
                           ENU=Specifies the code that belongs to the Sales Type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales Code" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for salgsprisens valuta.;
                           ENU=Specifies the code for the currency of the sales price.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, som salgsprisen g‘lder for.;
                           ENU=Specifies the number of the item for which the sales price is valid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No." }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det minimale salgsantal, der kr‘ves for at garantere salgsprisen.;
                           ENU=Specifies the minimum sales quantity required to warrant the sales price.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Minimum Quantity" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Price" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som salgsprisen er gyldig fra.;
                           ENU=Specifies the date from which the sales price is valid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Starting Date" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kalenderdato, hvor salgsprisaftalen slutter.;
                           ENU=Specifies the calendar date when the sales price agreement ends.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ending Date" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om salgsprisen inkluderer moms.;
                           ENU=Specifies if the sales price includes VAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Price Includes VAT";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en fakturarabat beregnes, n†r salgsprisen tilbydes.;
                           ENU=Specifies if an invoice discount will be calculated when the sales price is offered.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsvirksomhedsbogf›ringsgruppen for debitorer, som salgsprisen skal anvendes p† (inklusive moms).;
                           ENU=Specifies the VAT business posting group for customers for whom you want the sales price (which includes VAT) to apply.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Gr. (Price)";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der beregnes linjerabat, n†r salgsprisen tilbydes.;
                           ENU=Specifies if a line discount will be calculated when the sales price is offered.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Line Disc.";
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

