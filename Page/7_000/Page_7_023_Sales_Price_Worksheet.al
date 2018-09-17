OBJECT Page 7023 Sales Price Worksheet
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Salgspriskladde;
               ENU=Sales Price Worksheet];
    SaveValues=Yes;
    SourceTable=Table7023;
    DelayedInsert=Yes;
    PageType=Worksheet;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 32      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Foresl† varesalgspris p† kld.;
                                 ENU=Suggest &Item Price on Wksh.];
                      ToolTipML=[DAN=Opret forslag til ‘ndring af de godkendte varepriser for salgspriserne i vinduet Salgspriser p† grundlag af enhedsprisen p† varekortene. N†r k›rslen er afsluttet, kan du se resultatet i vinduet Salgspriskladde. Du kan ogs† aktivere k›rslen Foresl† salgspris p† kladde for at oprette forslag til nye salgspriser.;
                                 ENU=Create suggestions for changing the agreed item unit prices for your sales prices in the Sales Prices window on the basis of the unit price on the item cards. When the batch job has completed, you can see the result in the Sales Price Worksheet window. You can also use the Suggest Sales Price on Wksh. batch job to create suggestions for new sales prices.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=SuggestItemPrice;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Suggest Item Price on Wksh.",TRUE,TRUE);
                               END;
                                }
      { 33      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=F&oresl† salgspris p† kld.;
                                 ENU=Suggest &Sales Price on Wksh.];
                      ToolTipML=[DAN=Opret forslag til ‘ndring af de godkendte varepriser for salgspriserne i vinduet Salgspriser p† grundlag af enhedsprisen p† varekortene. N†r k›rslen er afsluttet, kan du se resultatet i vinduet Salgspriskladde. Du kan ogs† aktivere k›rslen Foresl† salgspris p† kladde for at oprette forslag til nye salgspriser.;
                                 ENU=Create suggestions for changing the agreed item unit prices for your sales prices in the Sales Prices window on the basis of the unit price on the item cards. When the batch job has completed, you can see the result in the Sales Price Worksheet window. You can also use the Suggest Sales Price on Wksh. batch job to create suggestions for new sales prices.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=SuggestSalesPrice;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Suggest Sales Price on Wksh.",TRUE,TRUE);
                               END;
                                }
      { 36      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Op&dater salgspris;
                                 ENU=I&mplement Price Change];
                      ToolTipML=[DAN=Opdater de alternative priser i vinduet Salgspriser med dem i vinduet Salgspriskladde.;
                                 ENU=Update the alternate prices in the Sales Prices window with the ones in the Sales Price Worksheet window.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ImplementPriceChange;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Implement Price Change",TRUE,TRUE,Rec);
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

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvorfra varen tidligst kan s‘lges til salgsprisen.;
                           ENU=Specifies the earliest date on which the item can be sold at the sales price.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Starting Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor salgsprisaftalen udl›ber.;
                           ENU=Specifies the date on which the sales price agreement ends.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ending Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den salgstype, som prisen er baseret p†, f.eks. Alle debitorer eller Kampagne.;
                           ENU=Specifies the type of sale that the price is based on, such as All Customers or Campaign.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Salgstype.;
                           ENU=Specifies the Sales Type code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales Code" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af salgstypen, eksempelvis Kampagne p† kladdelinjen, p† kladdelinjen.;
                           ENU=Specifies the description of the sales type, such as Campaign, on the worksheet line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales Description";
                Visible=FALSE }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for salgsprisen.;
                           ENU=Specifies the currency code of the sales price.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, som salgspriserne bliver ‘ndret eller oprettet for.;
                           ENU=Specifies the number of the item for which sales prices are being changed or set up.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af varen p† kladdelinjen.;
                           ENU=Specifies the description of the item on the worksheet line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Description";
                Visible=FALSE;
                Editable=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det minimale salgsantal, der skal opn†s for at garantere salgsprisen.;
                           ENU=Specifies the minimum sales quantity that must be met to warrant the sales price.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Minimum Quantity" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhedsprisen p† varen.;
                           ENU=Specifies the unit price of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Current Unit Price" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nye enhedspris, der g‘lder for den valgte kombination af Salgskode, Valutakode og/eller Startdato.;
                           ENU=Specifies the new unit price that is valid for the selected combination of Sales Code, Currency Code and/or Starting Date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="New Unit Price" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en fakturarabat beregnes, n†r salgsprisen tilbydes.;
                           ENU=Specifies if an invoice discount will be calculated when the sales price is offered.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om salgsprisen inkluderer moms.;
                           ENU=Specifies if the sales price includes VAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Price Includes VAT";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den momsvirksomhedsbogf›ringsgruppe for debitorer, som salgspriserne skal g‘lde for.;
                           ENU=Specifies the code for the VAT business posting group of customers for whom the sales prices will apply.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Gr. (Price)";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
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

