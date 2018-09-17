OBJECT Page 1342 Item Template Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Vareskabelon;
               ENU=Item Template];
    SourceTable=Table1301;
    DataCaptionExpr="Template Name";
    PageType=Card;
    SourceTableTemporary=Yes;
    CardPageID=Item Template Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚rer,Stamdata;
                                ENU=New,Process,Reports,Master Data];
    OnOpenPage=BEGIN
                 IF Item."No." <> '' THEN
                   CreateConfigTemplateFromExistingItem(Item,Rec);
               END;

    OnDeleteRecord=BEGIN
                     CheckTemplateNameProvided
                   END;

    OnQueryClosePage=BEGIN
                       CASE CloseAction OF
                         ACTION::LookupOK:
                           IF Code <> '' THEN
                             CheckTemplateNameProvided;
                         ACTION::LookupCancel:
                           IF DELETE(TRUE) THEN;
                       END;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           SetInventoryPostingGroupEditable;
                           SetDimensionsEnabled;
                           SetTemplateEnabled;
                           SetCostingMethodDefault;
                           SetNoSeries;
                         END;

    ActionList=ACTIONS
    {
      { 22      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Stamdata;
                                 ENU=Master Data] }
      { 24      ;2   ;Action    ;
                      Name=Default Dimensions;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 1343;
                      RunPageLink=Table Id=CONST(27),
                                  Master Record Template Code=FIELD(Code);
                      Promoted=Yes;
                      Enabled=DimensionsEnabled;
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4 }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† skabelonen.;
                           ENU=Specifies the name of the template.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Template Name";
                OnValidate=BEGIN
                             SetDimensionsEnabled;
                           END;
                            }

    { 23  ;2   ;Field     ;
                Name=TemplateEnabled;
                CaptionML=[DAN=Aktiveret;
                           ENU=Enabled];
                ToolTipML=[DAN=Angiver, om skabelonen er klar til at blive brugt;
                           ENU=Specifies if the template is ready to be used];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TemplateEnabled;
                OnValidate=VAR
                             ConfigTemplateHeader@1000 : Record 8618;
                           BEGIN
                             IF ConfigTemplateHeader.GET(Code) THEN
                               ConfigTemplateHeader.SetTemplateEnabled(TemplateEnabled);
                           END;
                            }

    { 30  ;2   ;Field     ;
                Name=NoSeries;
                CaptionML=[DAN=No. Series;
                           ENU=No. Series];
                ToolTipML=[DAN=Specifies the code for the number series that will be used to assign numbers to items.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NoSeries;
                TableRelation="No. Series";
                OnValidate=VAR
                             ConfigTemplateHeader@1000 : Record 8618;
                           BEGIN
                             IF ConfigTemplateHeader.GET(Code) THEN
                               ConfigTemplateHeader.SetNoSeries(NoSeries);
                           END;
                            }

    { 18  ;1   ;Group     ;
                Name=Item Setup;
                CaptionML=[DAN=Vareops‘tning;
                           ENU=Item Setup];
                GroupType=Group }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den enhed, som varen er lagerf›rt i. Basism†leenheden fungerer ogs† som konverteringsbasis for alternative m†leenheder.;
                           ENU=Specifies the unit in which the item is held in inventory. The base unit of measure also serves as the conversion basis for alternate units of measure.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Base Unit of Measure" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varekortet repr‘senterer en fysisk vare (Lagerbeholdning) eller en service (Service).;
                           ENU=Specifies if the item card represents a physical item (Inventory) or a service (Service).];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type;
                OnValidate=BEGIN
                             SetInventoryPostingGroupEditable;
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der tilf›jes udvidet tekst i salgs- eller k›bsdokumenter for denne vare.;
                           ENU=Specifies that an extended text will be added on sales or purchase documents for this item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Automatic Ext. Texts" }

    { 21  ;1   ;Group     ;
                Name=Price;
                CaptionML=[DAN=Pris;
                           ENU=Price];
                GroupType=Group }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebel›b p† salgsdokumentlinjer for denne vare skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on sales document lines for this item should be shown with or without VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Price Includes VAT" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver relationen mellem felterne Kostpris, Enhedspris og Avancepct. for denne vare.;
                           ENU=Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Price/Profit Calculation" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den d‘kningsgrad, du vil s‘lge varen med. Du kan angive en avanceprocent manuelt eller f† den angivet i henhold til feltet Avancepct.beregning;
                           ENU=Specifies the profit margin that you want to sell the item at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Profit %" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varen skal indg† i beregningen af en fakturarabat p† dokumenter, hvor varen handles.;
                           ENU=Specifies if the item should be included in the calculation of an invoice discount on documents where the item is traded.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow Invoice Disc." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en varegruppekode, der kan bruges som kriterie til at tildele en rabat, n†r varen s‘lges til en bestemt debitor.;
                           ENU=Specifies an item group code that can be used as a criterion to grant a discount when the item is sold to a certain customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Disc. Group" }

    { 20  ;1   ;Group     ;
                Name=Cost;
                CaptionML=[DAN=Vareforbrug;
                           ENU=Cost];
                GroupType=Group }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver links mellem forretningstransaktioner, som er lavet til denne vare, og finansposterne for at tage h›jde for momsbel›b, der er et resultat af handel med varen.;
                           ENU=Specifies links between business transactions made for this item and the general ledger, to account for VAT amounts that result from trade with the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Costing Method" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste k›bspris, der omfatter indirekte omkostninger, s†som fragt, der er knyttet til k›bet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Indirect Cost %" }

    { 19  ;1   ;Group     ;
                Name=Financial Details;
                CaptionML=[DAN=Finansielle oplysninger;
                           ENU=Financial Details];
                GroupType=Group }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Prod. Posting Group" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsproduktbogf›ringsgruppen. Knytter forretningstransaktioner for varen, ressourcen eller finanskontoen til finansregnskabet for at g›re rede for momsbel›bet som f›lge af handlen med den p†g‘ldende record.;
                           ENU=Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver links mellem forretningstransaktioner, som er lavet til varen, og en lagerkonto i finansposterne for at samle bel›bene for denne varetype i en gruppe.;
                           ENU=Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inventory Posting Group";
                Editable=InventoryPostingGroupEditable }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver skattegruppekoden for skattedetaljeposten.;
                           ENU=Specifies the tax group code for the tax-detail entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Tax Group Code" }

    { 25  ;1   ;Group     ;
                Name=Categorization;
                CaptionML=[DAN=Kategorisering;
                           ENU=Categorization];
                GroupType=Group }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kategori, varen h›rer til. Varekategorier omfatter ogs† vareattributter, der m†tte v‘re tildelt.;
                           ENU=Specifies the category that the item belongs to. Item categories also contain any assigned item attributes.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Category Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den serviceartikelgruppe, som varen tilh›rer.;
                           ENU=Specifies the code of the service item group that the item belongs to.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Group" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lagerklassekoden for varen.;
                           ENU=Specifies the warehouse class code for the item.];
                ApplicationArea=#Warehouse;
                SourceExpr="Warehouse Class Code" }

  }
  CODE
  {
    VAR
      Item@1003 : Record 27;
      NoSeries@1005 : Code[20];
      InventoryPostingGroupEditable@1000 : Boolean INDATASET;
      DimensionsEnabled@1001 : Boolean INDATASET;
      ProvideTemplateNameErr@1002 : TextConst '@@@=%1 Template Name;DAN=Du skal angive en %1.;ENU=You must enter a %1.';
      TemplateEnabled@1004 : Boolean;

    [External]
    PROCEDURE SetInventoryPostingGroupEditable@1();
    BEGIN
      InventoryPostingGroupEditable := Type = Type::Inventory;
    END;

    LOCAL PROCEDURE SetDimensionsEnabled@4();
    BEGIN
      DimensionsEnabled := "Template Name" <> '';
    END;

    LOCAL PROCEDURE SetTemplateEnabled@5();
    VAR
      ConfigTemplateHeader@1000 : Record 8618;
    BEGIN
      TemplateEnabled := ConfigTemplateHeader.GET(Code) AND ConfigTemplateHeader.Enabled;
    END;

    LOCAL PROCEDURE CheckTemplateNameProvided@2();
    BEGIN
      IF "Template Name" = '' THEN
        ERROR(STRSUBSTNO(ProvideTemplateNameErr,FIELDCAPTION("Template Name")));
    END;

    [External]
    PROCEDURE CreateFromItem@3(FromItem@1000 : Record 27);
    BEGIN
      Item := FromItem;
    END;

    LOCAL PROCEDURE SetCostingMethodDefault@6();
    VAR
      ConfigTemplateLine@1000 : Record 8619;
      InventorySetup@1001 : Record 313;
    BEGIN
      IF Item."No." <> '' THEN
        EXIT;

      ConfigTemplateLine.SETRANGE("Data Template Code",Code);
      ConfigTemplateLine.SETRANGE("Table ID",DATABASE::Item);
      ConfigTemplateLine.SETRANGE("Field ID",Item.FIELDNO("Costing Method"));
      IF ConfigTemplateLine.ISEMPTY AND InventorySetup.GET THEN
        "Costing Method" := InventorySetup."Default Costing Method";
    END;

    LOCAL PROCEDURE SetNoSeries@7();
    VAR
      ConfigTemplateHeader@1000 : Record 8618;
    BEGIN
      NoSeries := '';
      IF ConfigTemplateHeader.GET(Code) THEN
        NoSeries := ConfigTemplateHeader."Instance No. Series";
    END;

    BEGIN
    END.
  }
}

