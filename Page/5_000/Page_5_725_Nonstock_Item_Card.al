OBJECT Page 5725 Nonstock Item Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Katalogvarekort;
               ENU=Nonstock Item Card];
    SourceTable=Table5718;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&atalogvare;
                                 ENU=Nonstoc&k Item];
                      Image=NonStockItem }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Erstat&ninger;
                                 ENU=Substituti&ons];
                      ToolTipML=[DAN=F† vist erstatningsvarer, der er konfigureret til at blive solgt i stedet for varen.;
                                 ENU=View substitute items that are set up to be sold instead of the item.];
                      ApplicationArea=#Suite;
                      RunObject=Page 5716;
                      RunPageLink=Type=CONST(Nonstock Item),
                                  No.=FIELD(Entry No.);
                      Image=ItemSubstitution }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Nonstock Item),
                                  No.=FIELD(Entry No.);
                      Image=ViewComments }
      { 1900000005;0 ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 1900294905;1 ;Action    ;
                      CaptionML=[DAN=Ny vare;
                                 ENU=New Item];
                      ToolTipML=[DAN=Opret et varekort, der er baseret p† lagervaren.;
                                 ENU=Create an item card based on the stockkeeping unit.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 30;
                      Promoted=Yes;
                      Image=NewItem;
                      PromotedCategory=New;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktioner;
                                 ENU=F&unctions];
                      Image=Action }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=&Opret vare;
                                 ENU=&Create Item];
                      ToolTipML=[DAN=Konvert‚r katalogvarekortet til et normalt varekort ud fra en vareskabelon, som du v‘lger.;
                                 ENU=Convert the nonstock item card to a normal item card, according to an item template that you choose.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=NewItemNonStock;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 NonstockItemMgt.NonstockAutoItem(Rec);
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
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No.";
                Importance=Additional;
                OnAssistEdit=BEGIN
                               IF AssistEdit THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for producenten af katalogvaren.;
                           ENU=Specifies a code for the manufacturer of the nonstock item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Manufacturer Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, du kan k›be katalogvaren af.;
                           ENU=Specifies the number of the vendor from whom you can purchase the nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor No.";
                Importance=Promoted }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som kreditoren bruger til denne vare.;
                           ENU=Specifies the number that the vendor uses for this item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Item No.";
                Importance=Promoted }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det varenummer, som programmet har genereret til katalogvaren.;
                           ENU=Specifies the item number that the program has generated for this nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No.";
                Importance=Additional }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af katalogvaren.;
                           ENU=Specifies a description of the nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure";
                Importance=Promoted }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor katalogvarekortet sidst blev ‘ndret.;
                           ENU=Specifies the date on which the nonstock item card was last modified.];
                ApplicationArea=#Advanced;
                SourceExpr="Last Date Modified" }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver listekostprisen eller kreditorens vejledende pris p† katalogvaren.;
                           ENU=Specifies the published cost or vendor list price for the nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Published Cost";
                Importance=Additional }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den pris, du har forhandlet dig frem til for katalogvaren.;
                           ENU=Specifies the price you negotiated to pay for the nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Negotiated Cost";
                Importance=Additional }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Price";
                Importance=Promoted }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver katalogvarens bruttov‘gt, inklusive v‘gten af en eventuel emballage.;
                           ENU=Specifies the gross weight, including the weight of any packaging, of the nonstock item.];
                ApplicationArea=#Advanced;
                SourceExpr="Gross Weight" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens nettov‘gt. V‘gten af eventuel emballage er ikke inkluderet.;
                           ENU=Specifies the net weight of the item. The weight of packaging materials is not included.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Net Weight" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver stregkoden for katalogvaren.;
                           ENU=Specifies the bar code of the nonstock item.];
                ApplicationArea=#Advanced;
                SourceExpr="Bar Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den vareskabelon, der blev brugt til denne katalogvare.;
                           ENU=Specifies the code for the item template used for this nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Template Code" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      NonstockItemMgt@1000 : Codeunit 5703;

    BEGIN
    END.
  }
}

