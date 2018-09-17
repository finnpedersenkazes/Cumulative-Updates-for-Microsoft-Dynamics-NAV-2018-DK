OBJECT Page 31 Item List
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Varer;
               ENU=Items];
    SourceTable=Table27;
    PageType=List;
    CardPageID=Item Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Vare,Oversigt,Specialpriser og rabatter,Anmod om godkendelse,Periodiske aktiviteter,Lager,Attributter;
                                ENU=New,Process,Report,Item,History,Special Prices & Discounts,Request Approval,Periodic Activities,Inventory,Attributes];
    OnOpenPage=VAR
                 CRMIntegrationManagement@1000 : Codeunit 5330;
                 ClientTypeManagement@1001 : Codeunit 4;
               BEGIN
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
                 IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
                 SetWorkflowManagementEnabledState;
                 IsOnPhone := ClientTypeManagement.IsClientType(CLIENTTYPE::Phone);

                 // Contextual Power BI FactBox: filtering available reports, setting context, loading Power BI related user settings
                 CurrPage."Power BI Report FactBox".PAGE.SetNameFilter(CurrPage.CAPTION);
                 CurrPage."Power BI Report FactBox".PAGE.SetContext(CurrPage.OBJECTID(FALSE));
                 PowerBIVisible := SetPowerBIUserConfig.SetUserConfig(PowerBIUserConfiguration,CurrPage.OBJECTID(FALSE));
               END;

    OnFindRecord=VAR
                   Found@1000 : Boolean;
                 BEGIN
                   IF RunOnTempRec THEN BEGIN
                     TempFilteredItem := Rec;
                     Found := TempFilteredItem.FIND(Which);
                     IF Found THEN
                       Rec := TempFilteredItem;
                     EXIT(Found);
                   END;
                   EXIT(FIND(Which));
                 END;

    OnNextRecord=VAR
                   ResultSteps@1000 : Integer;
                 BEGIN
                   IF RunOnTempRec THEN BEGIN
                     TempFilteredItem := Rec;
                     ResultSteps := TempFilteredItem.NEXT(Steps);
                     IF ResultSteps <> 0 THEN
                       Rec := TempFilteredItem;
                     EXIT(ResultSteps);
                   END;
                   EXIT(NEXT(Steps));
                 END;

    OnAfterGetRecord=BEGIN
                       EnableControls;
                     END;

    OnAfterGetCurrRecord=VAR
                           CRMCouplingManagement@1001 : Codeunit 5331;
                           WorkflowWebhookManagement@1000 : Codeunit 1543;
                         BEGIN
                           SetSocialListeningFactboxVisibility;

                           CRMIsCoupledToRecord :=
                             CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID) AND CRMIntegrationEnabled;

                           OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

                           CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
                           CurrPage.ItemAttributesFactBox.PAGE.LoadItemAttributesData("No.");

                           WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);

                           SetWorkflowManagementEnabledState;

                           // Contextual Power BI FactBox: send data to filter the report in the FactBox
                           CurrPage."Power BI Report FactBox".PAGE.SetCurrentListSelection("No.",FALSE);
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 64      ;1   ;ActionGroup;
                      CaptionML=[DAN=Vare;
                                 ENU=Item];
                      Image=DataEntry }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=En&heder;
                                 ENU=&Units of Measure];
                      ToolTipML=[DAN=Angiv de forskellige enheder, som en vare kan handles i, f.eks. styk, boks eller time.;
                                 ENU=Set up the different units that the item can be traded in, such as piece, box, or hour.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5404;
                      RunPageLink=Item No.=FIELD(No.);
                      Image=UnitOfMeasure;
                      PromotedCategory=Category4;
                      Scope=Repeater }
      { 137     ;2   ;Action    ;
                      Name=Attributes;
                      AccessByPermission=TableData 7500=R;
                      CaptionML=[DAN=Attributter;
                                 ENU=Attributes];
                      ToolTipML=[DAN=FÜ vist eller rediger varens attributter, f.eks. farve, stõrrelse eller andre egenskaber, der beskriver varen.;
                                 ENU=View or edit the item's attributes, such as color, size, or other characteristics that help to describe the item.];
                      ApplicationArea=#Advanced;
                      Image=Category;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 PAGE.RUNMODAL(PAGE::"Item Attribute Value Editor",Rec);
                                 CurrPage.SAVERECORD;
                                 CurrPage.ItemAttributesFactBox.PAGE.LoadItemAttributesData("No.");
                               END;
                                }
      { 138     ;2   ;Action    ;
                      Name=FilterByAttributes;
                      AccessByPermission=TableData 7500=R;
                      CaptionML=[DAN=Filtrer efter attributter;
                                 ENU=Filter by Attributes];
                      ToolTipML=[DAN=Find varer, der matcher specifikke attributter. Fjern filteret for at sikre, at du medtager de seneste ëndringer foretaget af andre brugere, og nulstil den derefter.;
                                 ENU=Find items that match specific attributes. To make sure you include recent changes made by other users, clear the filter and then reset it.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=EditFilter;
                      PromotedCategory=Category10;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ItemAttributeManagement@1002 : Codeunit 7500;
                                 TypeHelper@1006 : Codeunit 10;
                                 CloseAction@1003 : Action;
                                 FilterText@1001 : Text;
                                 FilterPageID@1000 : Integer;
                                 ParameterCount@1004 : Integer;
                               BEGIN
                                 FilterPageID := PAGE::"Filter Items by Attribute";
                                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Phone THEN
                                   FilterPageID := PAGE::"Filter Items by Att. Phone";

                                 CloseAction := PAGE.RUNMODAL(FilterPageID,TempFilterItemAttributesBuffer);
                                 IF (ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Phone) AND (CloseAction <> ACTION::LookupOK) THEN
                                   EXIT;

                                 IF TempFilterItemAttributesBuffer.ISEMPTY THEN BEGIN
                                   ClearAttributesFilter;
                                   EXIT;
                                 END;

                                 ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer,TempFilteredItem);
                                 FilterText := ItemAttributeManagement.GetItemNoFilterText(TempFilteredItem,ParameterCount);

                                 IF ParameterCount < TypeHelper.GetMaxNumberOfParametersInSQLQuery - 100 THEN BEGIN
                                   FILTERGROUP(0);
                                   MARKEDONLY(FALSE);
                                   SETFILTER("No.",FilterText);
                                 END ELSE BEGIN
                                   RunOnTempRec := TRUE;
                                   CLEARMARKS;
                                   RESET;
                                 END;
                               END;
                                }
      { 139     ;2   ;Action    ;
                      Name=ClearAttributes;
                      AccessByPermission=TableData 7500=R;
                      CaptionML=[DAN=Ryd attributfilter;
                                 ENU=Clear Attributes Filter];
                      ToolTipML=[DAN=Fjern filteret for specifikke vareattributter.;
                                 ENU=Remove the filter for specific item attributes.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=RemoveFilterLines;
                      PromotedCategory=Category10;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ClearAttributesFilter;
                                 TempFilteredItem.RESET;
                                 TempFilteredItem.DELETEALL;
                                 RunOnTempRec := FALSE;
                               END;
                                }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=V&arianter;
                                 ENU=Va&riants];
                      ToolTipML=[DAN=Se, hvordan lagerniveauet for en vare udvikles over tid i henhold til den valgte variant.;
                                 ENU=View how the inventory level of an item will develop over time according to the variant that you select.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5401;
                      RunPageLink=Item No.=FIELD(No.);
                      Image=ItemVariant }
      { 500     ;2   ;Action    ;
                      CaptionML=[DAN=Erstat&ninger;
                                 ENU=Substituti&ons];
                      ToolTipML=[DAN=FÜ vist erstatningsvarer, der er konfigureret til at blive solgt i stedet for varen.;
                                 ENU=View substitute items that are set up to be sold instead of the item.];
                      ApplicationArea=#Suite;
                      RunObject=Page 5716;
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(No.);
                      Image=ItemSubstitution }
      { 121     ;2   ;Action    ;
                      CaptionML=[DAN=Id'er;
                                 ENU=Identifiers];
                      ToolTipML=[DAN=FÜ vist et entydigt id for hver vare pÜ lagerstedet, som lagermedarbejderne skal holde styr pÜ ved at bruge de hÜndholdte enheder. Vare-id'et kan omfatte varenummer, variantkode og mÜleenhed.;
                                 ENU=View a unique identifier for each item that you want warehouse employees to keep track of within the warehouse when using handheld devices. The item identifier can include the item number, the variant code and the unit of measure.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7706;
                      RunPageView=SORTING(Item No.,Variant Code,Unit of Measure Code);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=BarCode }
      { 82      ;2   ;Action    ;
                      CaptionML=[DAN=Varere&ferencer;
                                 ENU=Cross Re&ferences];
                      ToolTipML=[DAN=Konfigurer en debitors eller kreditors egen identifikation af den valgte vare. Krydshenvisninger til debitorens varenummer betyder, at debitorens varenummer automatisk vises i salgsbilag i stedet for det nummer, du anvender.;
                                 ENU=Set up a customer's or vendor's own identification of the selected item. Cross-references to the customer's item number means that the item number is automatically shown on sales documents instead of the number that you use.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5721;
                      RunPageLink=Item No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Change;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      Scope=Repeater }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Udvidede &tekster;
                                 ENU=E&xtended Texts];
                      ToolTipML=[DAN=Vëlg eller konfigurer supplerende tekst til beskrivelsen af varen. Den udvidede tekst kan indsëttes under feltet Beskrivelse i dokumentlinjerne for varen.;
                                 ENU=Select or set up additional text for the description of the item. Extended text can be inserted under the Description field on document lines for the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 391;
                      RunPageView=SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                      RunPageLink=Table Name=CONST(Item),
                                  No.=FIELD(No.);
                      Image=Text;
                      Scope=Repeater }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Varetekster;
                                 ENU=Translations];
                      ToolTipML=[DAN=Angiv oversatte varebeskrivelser for den valgte vare. Oversatte varebeskrivelser indsëttes automatisk i dokumenter i overensstemmelse med sprogkode.;
                                 ENU=Set up translated item descriptions for the selected item. Translated item descriptions are automatically inserted on documents according to the language code.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 35;
                      RunPageLink=Item No.=FIELD(No.),
                                  Variant Code=CONST();
                      Image=Translations;
                      PromotedCategory=Category4;
                      Scope=Repeater }
      { 145     ;2   ;ActionGroup;
                      Visible=False }
      { 90      ;3   ;Action    ;
                      Name=AdjustInventory;
                      CaptionML=[DAN=Reguler lager;
                                 ENU=Adjust Inventory];
                      ToolTipML=[DAN=Forõg eller reducer varens lagerantal manuelt ved at angive et nyt antal. Det kan vëre relevant at regulere lagerantallet manuelt efter en fysisk optëlling, eller hvis du ikke registrerer indkõbte mëngder.;
                                 ENU=Increase or decrease the item's inventory quantity manually by entering a new quantity. Adjusting the inventory quantity manually may be relevant after a physical count or if you do not record purchased quantities.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      Enabled=InventoryItemEditable;
                      Image=InventoryCalculation;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=VAR
                                 AdjustInventory@1000 : Page 1327;
                               BEGIN
                                 COMMIT;
                                 AdjustInventory.SetItem("No.");
                                 AdjustInventory.RUNMODAL;
                               END;
                                }
      { 94      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      Image=Dimensions }
      { 184     ;3   ;Action    ;
                      Name=DimensionsSingle;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - enkelt;
                                 ENU=Dimensions-Single];
                      ToolTipML=[DAN=FÜ vist eller rediger de enkelte sët af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(27),
                                  No.=FIELD(No.);
                      Image=Dimensions;
                      Scope=Repeater }
      { 93      ;3   ;Action    ;
                      Name=DimensionsMultiple;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Suite;
                      Image=DimensionSets;
                      OnAction=VAR
                                 Item@1001 : Record 27;
                                 DefaultDimMultiple@1002 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Item);
                                 DefaultDimMultiple.SetMultiItem(Item);
                                 DefaultDimMultiple.RUNMODAL;
                               END;
                                }
      { 56      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 84      ;2   ;ActionGroup;
                      CaptionML=[DAN=Post&er;
                                 ENU=E&ntries];
                      Image=Entries }
      { 14      ;3   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Vareposter;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Vis historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 38;
                      RunPageView=SORTING(Item No.)
                                  ORDER(Descending);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=ItemLedger;
                      PromotedCategory=Category5;
                      Scope=Repeater }
      { 23      ;3   ;Action    ;
                      CaptionML=[DAN=&Lageropgõrelsesposter;
                                 ENU=&Phys. Inventory Ledger Entries];
                      ToolTipML=[DAN=FÜ vist antallet af vareenheder pÜ lager ved seneste manuelle optëlling.;
                                 ENU=View how many units of the item you had in stock at the last physical count.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 390;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=PhysicalInventoryLedger;
                      PromotedCategory=Category5;
                      Scope=Repeater }
      { 120     ;1   ;ActionGroup;
                      Name=PricesandDiscounts;
                      CaptionML=[DAN=Priser og rabatter;
                                 ENU=Prices and Discounts] }
      { 1901240604;2 ;Action    ;
                      Name=Prices_Prices;
                      CaptionML=[DAN=Specialpriser;
                                 ENU=Special Prices];
                      ToolTipML=[DAN=Angiv forskellige priser for den valgte vare. En varepris anvendes automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. debitor, mëngde eller slutdato.;
                                 ENU=Set up different prices for the selected item. An item price is automatically used on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7002;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=Price;
                      PromotedCategory=Category6;
                      Scope=Repeater }
      { 1900869004;2 ;Action    ;
                      Name=Prices_LineDiscounts;
                      CaptionML=[DAN=Specialrabatter;
                                 ENU=Special Discounts];
                      ToolTipML=[DAN=Angiv forskellige rabatter for den valgte vare. En varerabat anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. debitor, mëngde eller slutdato.;
                                 ENU=Set up different discounts for the selected item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7004;
                      RunPageView=SORTING(Type,Code);
                      RunPageLink=Type=CONST(Item),
                                  Code=FIELD(No.);
                      Image=LineDiscount;
                      PromotedCategory=Category6;
                      Scope=Repeater }
      { 133     ;2   ;Action    ;
                      Name=PricesDiscountsOverview;
                      CaptionML=[DAN=Oversigt over specialpriser og -rabatter;
                                 ENU=Special Prices & Discounts Overview];
                      ToolTipML=[DAN=Vis de sërlige priser og kõbslinjerabatter, som du giver til denne vare, nÜr visse kriterier er opfyldt, f.eks. kreditor, antal eller slutdato.;
                                 ENU=View the special prices and line discounts that you grant for this item when certain criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      Image=PriceWorksheet;
                      PromotedCategory=Category6;
                      OnAction=VAR
                                 SalesPriceAndLineDiscounts@1000 : Page 1345;
                               BEGIN
                                 SalesPriceAndLineDiscounts.InitPage(TRUE);
                                 SalesPriceAndLineDiscounts.LoadItem(Rec);
                                 SalesPriceAndLineDiscounts.RUNMODAL;
                               END;
                                }
      { 92      ;2   ;Action    ;
                      CaptionML=[DAN=Salgspriskladde;
                                 ENU=Sales Price Worksheet];
                      ToolTipML=[DAN=Rediger varens enhedspris, eller angiv, hvordan du vil angive ëndringer i prisaftalen for en debitor, en debitorgruppe eller alle debitorer.;
                                 ENU=Change to the unit price for the item or specify how you want to enter changes in the price agreement for one customer, a group of customers, or all customers.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7023;
                      Promoted=Yes;
                      Visible=NOT IsOnPhone;
                      Image=PriceWorksheet;
                      PromotedCategory=Category6 }
      { 117     ;1   ;ActionGroup;
                      CaptionML=[DAN=Periodiske aktiviteter;
                                 ENU=Periodic Activities] }
      { 1907108104;2 ;Action    ;
                      CaptionML=[DAN=Juster kostpris - vareposter;
                                 ENU=Adjust Cost - Item Entries];
                      ToolTipML=[DAN=Regulerer lagervërdierne i vareposter, sÜ du kan bruge den korrekte, regulerede kostpris til opdatering af finansregnskabet, og sÜ salgs- og indtjeningsstatistikkerne er opdateret.;
                                 ENU=Adjust inventory values in value entries so that you use the correct adjusted cost for updating the general ledger and so that sales and profit statistics are up to date.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 795;
                      Image=AdjustEntries;
                      PromotedCategory=Category8 }
      { 96      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõr lagerregulering;
                                 ENU=Post Inventory Cost to G/L];
                      ToolTipML=[DAN=Bogfõr ëndringen i antal og vërdi for lageret i vareposterne og vërdiposterne, nÜr du bogfõrer lagertransaktioner som f.eks. salgsleverancer eller kõbsfakturaer.;
                                 ENU=Post the quantity and value changes to the inventory in the item ledger entries and the value entries when you post inventory transactions, such as sales shipments or purchase receipts.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 1002;
                      Image=PostInventoryToGL;
                      PromotedCategory=Category8 }
      { 98      ;2   ;Action    ;
                      CaptionML=[DAN=Lageropgõrelseskladde;
                                 ENU=Physical Inventory Journal];
                      ToolTipML=[DAN=Vëlg, hvordan du vil fastholde en opdateret record over lageret pÜ forskellige lokationer.;
                                 ENU=Select how you want to maintain an up-to-date record of your inventory at different locations.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 392;
                      Image=PhysicalInventory;
                      PromotedCategory=Category8 }
      { 119     ;2   ;Action    ;
                      CaptionML=[DAN=Vërdireguleringskladde;
                                 ENU=Revaluation Journal];
                      ToolTipML=[DAN=Se eller rediger lagervërdien af varer, som du kan ëndre, f.eks nÜr du har foretaget en lageropgõrelse.;
                                 ENU=View or edit the inventory value of items, which you can change, such as after doing a physical inventory.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5803;
                      Image=Journal;
                      PromotedCategory=Category8 }
      { 88      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=SendApprovalRequest }
      { 87      ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send godkendelsesan&modning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om tilladelse til at ëndre recorden.;
                                 ENU=Request approval to change the record.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=(NOT OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist AND CanRequestApprovalForFlow;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckItemApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendItemForApproval(Rec);
                               END;
                                }
      { 86      ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godk&endelsesanmodning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                                 WorkflowWebhookManagement@1000 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelItemApprovalRequest(Rec);
                                 WorkflowWebhookManagement.FindAndCancel(RECORDID);
                               END;
                                }
      { 135     ;1   ;ActionGroup;
                      CaptionML=[DAN=Workflow;
                                 ENU=Workflow] }
      { 134     ;2   ;Action    ;
                      Name=CreateApprovalWorkflow;
                      CaptionML=[DAN=Opret godkendelsesworkflow;
                                 ENU=Create Approval Workflow];
                      ToolTipML=[DAN=Opret et godkendelsesworkflow for oprettelse og ëndring af varer ved at gennemgÜ et par sider med instruktioner.;
                                 ENU=Set up an approval workflow for creating or changing items, by going through a few pages that will guide you.];
                      ApplicationArea=#Suite;
                      Enabled=NOT EnabledApprovalWorkflowsExist;
                      Image=CreateWorkflow;
                      OnAction=BEGIN
                                 PAGE.RUNMODAL(PAGE::"Item Approval WF Setup Wizard");
                               END;
                                }
      { 20      ;2   ;Action    ;
                      Name=ManageApprovalWorkflow;
                      CaptionML=[DAN=Administrer godkendelsesworkflow;
                                 ENU=Manage Approval Workflow];
                      ToolTipML=[DAN=Se eller rediger eksisterende godkendelsesworkflows for oprettelse og ëndring af varer.;
                                 ENU=View or edit existing approval workflows for creating or changing items.];
                      ApplicationArea=#Suite;
                      Enabled=EnabledApprovalWorkflowsExist;
                      Image=WorkflowSetup;
                      OnAction=VAR
                                 WorkflowManagement@1000 : Codeunit 1501;
                               BEGIN
                                 WorkflowManagement.NavigateToWorkflows(DATABASE::Item,EventFilter);
                               END;
                                }
      { 110     ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 111     ;2   ;Action    ;
                      AccessByPermission=TableData 5700=R;
                      CaptionML=[DAN=&Opret lagervare (pr. lokation);
                                 ENU=&Create Stockkeeping Unit];
                      ToolTipML=[DAN=Opret en forekomst af varen pÜ hver lokation, der er konfigureret.;
                                 ENU=Create an instance of the item at each location that is set up.];
                      ApplicationArea=#Warehouse;
                      Image=CreateSKU;
                      OnAction=VAR
                                 Item@1001 : Record 27;
                               BEGIN
                                 Item.SETRANGE("No.","No.");
                                 REPORT.RUNMODAL(REPORT::"Create Stockkeeping Unit",TRUE,FALSE,Item);
                               END;
                                }
      { 7380    ;2   ;Action    ;
                      AccessByPermission=TableData 7380=R;
                      CaptionML=[DAN=Beregn optëllingsperio&de;
                                 ENU=C&alculate Counting Period];
                      ToolTipML=[DAN=Forbered et fysisk lager ved at beregne, hvilke varer eller lagervarer der skal tëlles med i den aktuelle periode.;
                                 ENU=Prepare for a physical inventory by calculating which items or SKUs need to be counted in the current period.];
                      ApplicationArea=#Warehouse;
                      Image=CalculateCalendar;
                      OnAction=VAR
                                 Item@1001 : Record 27;
                                 PhysInvtCountMgt@1000 : Codeunit 7380;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Item);
                                 PhysInvtCountMgt.UpdateItemPhysInvtCount(Item);
                               END;
                                }
      { 1905370404;1 ;Action    ;
                      CaptionML=[DAN=Indkõbskladde;
                                 ENU=Requisition Worksheet];
                      ToolTipML=[DAN=Beregn en forsyningsplan for at opfylde varebehov via indkõb eller overfõrsler.;
                                 ENU=Calculate a supply plan to fulfill item demand with purchases or transfers.];
                      ApplicationArea=#Planning;
                      RunObject=Page 291;
                      Image=Worksheet }
      { 1904344904;1 ;Action    ;
                      CaptionML=[DAN=Varekladde;
                                 ENU=Item Journal];
                      ToolTipML=[DAN=èbn en liste med kladder, hvor du kan justere det fysiske antal varer pÜ lager.;
                                 ENU=Open a list of journals where you can adjust the physical quantity of items on inventory.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 40;
                      Promoted=Yes;
                      Image=Journals;
                      PromotedCategory=Process }
      { 1906716204;1 ;Action    ;
                      CaptionML=[DAN=Vareomposteringskladde;
                                 ENU=Item Reclassification Journal];
                      ToolTipML=[DAN=Rediger oplysningerne i vareposter som f.eks. dimensioner, lokationskoder og placeringskoder og serie- eller lotnumre.;
                                 ENU=Change information on item ledger entries, such as dimensions, location codes, bin codes, and serial or lot numbers.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 393;
                      Promoted=Yes;
                      Image=Journals;
                      PromotedCategory=Process }
      { 1902532604;1 ;Action    ;
                      CaptionML=[DAN=Varesporing;
                                 ENU=Item Tracing];
                      ToolTipML=[DAN=Spor, hvor en lot- eller et serienummer, som varen er blevet tildelt, blev anvendt, eksempelvis for at finde ud af, hvilket lot en defekt komponent stammer fra, eller for at finde alle de debitorer, som har modtaget varer, der indeholder den defekte komponent.;
                                 ENU=Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6520;
                      Image=ItemTracing }
      { 1900805004;1 ;Action    ;
                      CaptionML=[DAN=Reguler varepris;
                                 ENU=Adjust Item Cost/Price];
                      ToolTipML=[DAN=Justerer felterne Sidste kõbspris, Kostpris (standard), Enhedspris, Avancepct. eller Indir. omkost.pct.) pÜ de valgte varekort eller lagervarekort samt for de valgte filtre. Du kan f.eks. ëndre den sidste direkte omkostning pÜ alle varer fra en bestemt leverandõr med 5 %.;
                                 ENU=Adjusts the Last Direct Cost, Standard Cost, Unit Price, Profit %, or Indirect Cost % fields on selected item or stockkeeping unit cards and for selected filters. For example, you can change the last direct cost by 5% on all items from a specific vendor.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 794;
                      Image=AdjustItemCost }
      { 147     ;1   ;Action    ;
                      Name=ApplyTemplate;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Anvend skabelon;
                                 ENU=Apply Template];
                      ToolTipML=[DAN=Anvend en skabelon for at opdatere en eller flere enheder med dine standardindstillinger for en bestemt enhedstype.;
                                 ENU=Apply a template to update one or more entities with your standard settings for a certain type of entity.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ApplyTemplate;
                      OnAction=VAR
                                 Item@1000 : Record 27;
                                 ItemTemplate@1001 : Record 1301;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Item);
                                 ItemTemplate.UpdateItemsFromTemplate(Item);
                               END;
                                }
      { 142     ;1   ;ActionGroup;
                      CaptionML=[DAN=Vis;
                                 ENU=Display] }
      { 141     ;2   ;Action    ;
                      Name=ReportFactBoxVisibility;
                      CaptionML=[DAN=Vis/skjul Power BI-rapporter;
                                 ENU=Show/Hide Power BI Reports];
                      ToolTipML=[DAN=Vëlg, om faktaboksen Power BI skal vëre synlig eller ej.;
                                 ENU=Select if the Power BI FactBox is visible or not.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Report;
                      OnAction=BEGIN
                                 IF PowerBIVisible THEN
                                   PowerBIVisible := FALSE
                                 ELSE
                                   PowerBIVisible := TRUE;
                                 // save visibility value into the table
                                 CurrPage."Power BI Report FactBox".PAGE.SetFactBoxVisibility(PowerBIVisible);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 127     ;1   ;ActionGroup;
                      CaptionML=[DAN=Montage/produktion;
                                 ENU=Assembly/Production] }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=Montage til ordre - salg;
                                 ENU=Assemble to Order - Sales];
                      ToolTipML=[DAN=FÜ vist nõglesalgstal for montagekomponenter, som kan vëre solgt enten som en del af montageelementer i montage til ordre-salg eller som separate varer direkte fra lageret. Brug denne rapport til at analysere antal, omkostning, salg og profitbelõb for montagekomponenter for at stõtte beslutninger, sÜsom om en pakke skal prissëttes anderledes, eller om der skal stoppes eller begyndes med at bruge en bestemt vare i montager.;
                                 ENU=View key sales figures for assembly components that may be sold either as part of assembly items in assemble-to-order sales or as separate items directly from inventory. Use this report to analyze the quantity, cost, sales, and profit figures of assembly components to support decisions, such as whether to price a kit differently or to stop or start using a particular item in assemblies.];
                      ApplicationArea=#Assembly;
                      RunObject=Report 915;
                      Image=Report }
      { 1902353206;2 ;Action    ;
                      CaptionML=[DAN=IndgÜr-i (hõjeste niveau);
                                 ENU=Where-Used (Top Level)];
                      ToolTipML=[DAN=Vis, hvor og i hvilke mëngder varen bruges, i produktstrukturen. Rapporten viser kun oplysninger for varen pÜ õverste niveau. Hvis varen A f.eks. anvendes til at producere varen B, og varen B anvendes til at producere varen C, viser rapporten varen B, hvis du kõrer en rapport for varen A. Hvis du kõrer rapporten for varen B, vises varen C som IndgÜr-i.;
                                 ENU=View where and in what quantities the item is used in the product structure. The report only shows information for the top-level item. For example, if item "A" is used to produce item "B", and item "B" is used to produce item "C", the report will show item B if you run this report for item A. If you run this report for item B, then item C will be shown as where-used.];
                      ApplicationArea=#Assembly;
                      RunObject=Report 99000757;
                      Image=Report }
      { 1907778006;2 ;Action    ;
                      CaptionML=[DAN=Styklisteudfold. - antal;
                                 ENU=Quantity Explosion of BOM];
                      ToolTipML=[DAN=Vis en niveaudelt styklisteoversigt med de varer, du angiver i filtrene. Produktionsstyklisten er fuldstëndig udfoldet (alle niveauer).;
                                 ENU=View an indented BOM listing for the item or items that you specify in the filters. The production BOM is completely exploded for all levels.];
                      ApplicationArea=#Assembly;
                      RunObject=Report 99000753;
                      Image=Report }
      { 132     ;2   ;ActionGroup;
                      CaptionML=[DAN=Kostprisberegning;
                                 ENU=Costing];
                      Image=ItemCosts }
      { 1907928706;3 ;Action    ;
                      CaptionML=[DAN=Lagervërdi - igangvërende arb.;
                                 ENU=Inventory Valuation - WIP];
                      ToolTipML=[DAN=FÜ vist lagervërdien pÜ udvalgte produktionsordrer i VIA-lagerbeholdningen. Rapporten indeholder ogsÜ oplysninger om forbrugsvërdi, kapacitetsudnyttelse og afgang i VIA-vërdien. Den udskrevne rapport viser kun fakturerede belõb, det vil sige kõbsprisen for poster, der er bogfõrt som fakturerede.;
                                 ENU=View inventory valuation for selected production orders in your WIP inventory. The report also shows information about the value of consumption, capacity usage and output in WIP. The printed report only shows invoiced amounts, that is, the cost of entries that have been posted as invoiced.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5802;
                      Image=Report }
      { 1905889606;3 ;Action    ;
                      CaptionML=[DAN=Grundlag for kostprisfordeling;
                                 ENU=Cost Shares Breakdown];
                      ToolTipML=[DAN=Vis varens omkostninger fordelt i lager, Igangvërende arbejde eller vareforbrug afhëngigt af indkõbs- og materialekostpris, kapacitetsomkostninger, faste produktionsomkostninger, underleverandõrkostpris, varians, indirekte omkostninger, regulering og afrunding. Rapporten fordeler omkostningen ved et enkelt styklisteniveau og akkumulerer ikke omkostningerne fra lavere styklisteniveauer. Rapporten beregner ikke kostprisfordelingen for elementer, som bruger kostmetoden Gennemsnit.;
                                 ENU=View the item's cost broken down in inventory, WIP, or COGS, according to purchase and material cost, capacity cost, capacity overhead cost, manufacturing overhead cost, subcontracted cost, variance, indirect cost, revaluation, and rounding. The report breaks down cost at a single BOM level and does not roll up the costs from lower BOM levels. The report does not calculate the cost share from items that use the Average costing method.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5848;
                      Image=Report }
      { 1901374406;3 ;Action    ;
                      CaptionML=[DAN=Detaljeret beregning;
                                 ENU=Detailed Calculation];
                      ToolTipML=[DAN=FÜ vist en liste over alle omkostninger for varen, som tager hõjde for spild under produktionen.;
                                 ENU=View the list of all costs for the item taking into account any scrap during production.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 99000756;
                      Image=Report }
      { 1900812706;3 ;Action    ;
                      CaptionML=[DAN=Kostprisfordeling - akk.;
                                 ENU=Rolled-up Cost Shares];
                      ToolTipML=[DAN=Vis kostprisfordelinger for alle varer i produktstrukturen for den overordnede vare, deres antal og deres kostprisfordelinger med angivelse af materiale, kapacitet, indirekte og samlede omkostninger. Materialekostprisen beregnes som kostprisen af alle varer i den overordnede vares produktstruktur. Kapacitet og underleverandõr beregnes som omkostningen ved at producere alle varerne i den overordnede vares produktstruktur. Materialekostpris beregnes som kostprisen for alle varer i varens produktstruktur. Kapacitets- og underleverandõrkostpriser er kun relateret til den overordnede vare.;
                                 ENU=View the cost shares of all items in the parent item's product structure, their quantity and their cost shares specified in material, capacity, overhead, and total cost. Material cost is calculated as the cost of all items in the parent item's product structure. Capacity and subcontractor costs are calculated as the costs related to produce all of the items in the parent item's product structure. Material cost is calculated as the cost of all items in the item's product structure. Capacity and subcontractor costs are the cost related to the parent item only.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000754;
                      Image=Report }
      { 1901316306;3 ;Action    ;
                      CaptionML=[DAN=Kostprisfordeling (enkeltniv.);
                                 ENU=Single-Level Cost Shares];
                      ToolTipML=[DAN=Vis kostprisfordelinger for alle varer i varens produktstruktur, deres antal og deres kostprisfordelinger med angivelse af materiale, kapacitet, indirekte og samlede omkostninger. Materialekostprisen beregnes som kostprisen af alle varer i den overordnede vares produktstruktur. Kapacitet og underleverandõr beregnes som omkostningen ved at producere alle varerne i den overordnede vares produktstruktur.;
                                 ENU=View the cost shares of all items in the item's product structure, their quantity and their cost shares specified in material, capacity, overhead, and total cost. Material cost is calculated as the cost of all items in the parent item's product structure. Capacity and subcontractor costs are calculated as the costs related to produce all of the items in the parent item's product structure.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000755;
                      Image=Report }
      { 128     ;1   ;ActionGroup;
                      CaptionML=[DAN=Lager;
                                 ENU=Inventory] }
      { 1900907306;2 ;Action    ;
                      CaptionML=[DAN=Vare - stamoplysninger;
                                 ENU=Inventory - List];
                      ToolTipML=[DAN=FÜ vist oplysninger om varen, sÜsom navn, enhed, bogfõringsgruppe, placeringsnummer, kreditors varenummer, beregning af leveringstid, genbestillingspunkt og alternativt varenummer. Du kan ogsÜ se, om varen er blokeret.;
                                 ENU=View various information about the item, such as name, unit of measure, posting group, shelf number, vendor's item number, lead time calculation, minimum inventory, and alternate item number. You can also see if the item is blocked.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 701;
                      Image=Report }
      { 1906212206;2 ;Action    ;
                      CaptionML=[DAN=Vare - disponeringsoversigt;
                                 ENU=Inventory - Availability Plan];
                      ToolTipML=[DAN=Vis en liste over antallet af de enkelte varer fordelt pÜ henholdsvis debitor-, kõbs- og overflytningsordrer, samt det antal der er disponibelt pÜ lageret. Oversigten er inddelt i kolonner, der dëkker seks perioder med angivne start- og slutdatoer, samt perioderne fõr og efter de pÜgëldende seks perioder. Listen er praktisk ved planlëgning af vareindkõb.;
                                 ENU=View a list of the quantity of each item in customer, purchase, and transfer orders and the quantity available in inventory. The list is divided into columns that cover six periods with starting and ending dates as well as the periods before and after those periods. The list is useful when you are planning your inventory purchases.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 707;
                      Image=ItemAvailability }
      { 1900430206;2 ;Action    ;
                      CaptionML=[DAN=Vare/leverandõrer;
                                 ENU=Item/Vendor Catalog];
                      ToolTipML=[DAN=Vis en oversigt over udvalgte varer med tilhõrende kreditorer. Der vises oplysninger om kõbspris, beregning af leveringstid og kreditorers varenummer.;
                                 ENU=View a list of the vendors for the selected items. For each combination of item and vendor, it shows direct unit cost, lead time calculation and the vendor's item number.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 720;
                      Image=Report }
      { 1907644006;2 ;Action    ;
                      CaptionML=[DAN=Lageropgõrelsesoversigt;
                                 ENU=Phys. Inventory List];
                      ToolTipML=[DAN=Vis en liste over de linjer, du har beregnet i vinduet Lageropgõrelseskladde. Du kan bruge denne rapport under den fysiske lageroptëlling til at notere det faktiske antal pÜ lager og sammenligne antallet med det antal, der er registreret i programmet.;
                                 ENU=View a list of the lines that you have calculated in the Phys. Inventory Journal window. You can use this report during the physical inventory count to mark down actual quantities on hand in the warehouse and compare them to what is recorded in the program.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 722;
                      Image=Report }
      { 1907253406;2 ;Action    ;
                      CaptionML=[DAN=Katalogvaresalg;
                                 ENU=Nonstock Item Sales];
                      ToolTipML=[DAN=FÜ vist en oversigt over varesalg for alle katalogvarer i en valgt periode. Den kan bruges til at gennemse en virksomheds salg af katalogvarer.;
                                 ENU=View a list of item sales for each nonstock item during a selected time period. It can be used to review a company's sale of nonstock items.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5700;
                      Image=Report }
      { 1905753506;2 ;Action    ;
                      CaptionML=[DAN=Erstatningsvarer;
                                 ENU=Item Substitutions];
                      ToolTipML=[DAN=Vis eller rediger alle stedfortrëdervarer, der er konfigureret til at blive solgt i stedet for varen, hvis den ikke er tilgëngelig.;
                                 ENU=View or edit any substitute items that are set up to be traded instead of the item in case it is not available.];
                      ApplicationArea=#Suite;
                      RunObject=Report 5701;
                      Image=Report }
      { 1905572506;2 ;Action    ;
                      CaptionML=[DAN=Prisliste;
                                 ENU=Price List];
                      ToolTipML=[DAN=Vis, udskriv, eller gem en liste over dine varer samt oplysninger om priser og omkostninger pÜ disse med henblik pÜ at sende den til debitorerne. Du kan oprette listen til specifikke debitorer, kampagner, valutaer eller til andre formÜl.;
                                 ENU=View, print, or save a list of your items and their prices, for example, to send to customers. You can create the list for specific customers, campaigns, currencies, or other criteria.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 715;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Category9 }
      { 1900128906;2 ;Action    ;
                      CaptionML=[DAN=Intern prisliste;
                                 ENU=Inventory Cost and Price List];
                      ToolTipML=[DAN=Vis, udskriv, eller gem en liste over dine varer og oplysninger om priser og omkostninger pÜ disse. Rapporten specificerer den direkte vareomkostning sidste direkte omkostning, enhedspris, avanceprocent og avance.;
                                 ENU=View, print, or save a list of your items and their price and cost information. The report specifies direct unit cost, last direct cost, unit price, profit percentage, and profit.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 716;
                      Image=Report }
      { 1901091106;2 ;Action    ;
                      CaptionML=[DAN=Varedisponering;
                                 ENU=Inventory Availability];
                      ToolTipML=[DAN=Vis, udskriv eller gem en historikoversigt over lagertransaktioner pr. valgte varer, f.eks. for at beslutte, hvornÜr varerne skal indkõbes. Rapporten specificerer antallet af salgsordrer, kõbsordrer, restordrer fra kreditorer, minimumslageret og eventuelle genbestillinger.;
                                 ENU=View, print, or save a summary of historical inventory transactions with selected items, for example, to decide when to purchase the items. The report specifies quantity on sales order, quantity on purchase order, back orders from vendors, minimum inventory, and whether there are reorders.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 705;
                      Image=Report }
      { 131     ;2   ;ActionGroup;
                      CaptionML=[DAN=Varejournal;
                                 ENU=Item Register];
                      Image=ItemRegisters }
      { 1907629906;3 ;Action    ;
                      CaptionML=[DAN=Varejournal - antal;
                                 ENU=Item Register - Quantity];
                      ToolTipML=[DAN=Vis en eller flere varejournaler, der viser antallet. Rapporten kan bruges til at dokumentere oplysningerne i en journal til interne eller eksterne revisionsformÜl.;
                                 ENU=View one or more selected item registers showing quantity. The report can be used to document a register's contents for internal or external audits.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 703;
                      Image=Report }
      { 1902962906;3 ;Action    ;
                      CaptionML=[DAN=Varejournal - vërdi;
                                 ENU=Item Register - Value];
                      ToolTipML=[DAN=Vis en eller flere varejournaler, der viser vërdi. Rapporten kan bruges til at dokumentere indholdet af en journal til interne eller eksterne revisionsformÜl.;
                                 ENU=View one or more selected item registers showing value. The report can be used to document the contents of a register for internal or external audits.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5805;
                      Image=Report }
      { 130     ;2   ;ActionGroup;
                      CaptionML=[DAN=Kostprisberegning;
                                 ENU=Costing];
                      Image=ItemCosts }
      { 1900730006;3 ;Action    ;
                      CaptionML=[DAN=Vare - prisafvigelser;
                                 ENU=Inventory - Cost Variance];
                      ToolTipML=[DAN=FÜ vist oplysninger om bestemte varer, enhed, standardkostpris og kostmetoden, samt supplerende oplysninger om vareposter: pris, kõbspris, prisafvigelse (forskellen mellem prisen og kostprisen), faktureret antal og samlet prisafvigelse (antal x prisafvigelse). Rapporten kan fõrst og fremmest bruges, hvis du har valgt kostmetoden Standard pÜ varekortet.;
                                 ENU=View information about selected items, unit of measure, standard cost, and costing method, as well as additional information about item entries: unit amount, direct unit cost, unit cost variance (the difference between the unit amount and unit cost), invoiced quantity, and total variance amount (quantity * unit cost variance). The report can be used primarily if you have chosen the Standard costing method on the item card.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 721;
                      Image=ItemCosts }
      { 1904299906;3 ;Action    ;
                      CaptionML=[DAN=Lagervërdi - kostspecifikation;
                                 ENU=Invt. Valuation - Cost Spec.];
                      ToolTipML=[DAN=FÜ vist et overblik over den aktuelle lagervërdi for valgte varer, som angiver omkostningen for disse varer pÜ datoen, som er angivet i feltet Vërdiansëttelsesdato. Rapporten indeholder alle omkostninger, bÜde dem, som er bogfõrt som faktureret og forventet. For hver af de varer, du angiver, nÜr du udformer rapporten, kommer den udskrevne rapport til at indeholde det antal, der er pÜ lager, kostprisen pr. enhed og det samlede belõb. For disse kolonner angiver rapporten kostprisen som de forskellige vërdiposttyper.;
                                 ENU=View an overview of the current inventory value of selected items and specifies the cost of these items as of the date specified in the Valuation Date field. The report includes all costs, both those posted as invoiced and those posted as expected. For each of the items that you specify when setting up the report, the printed report shows quantity on stock, the cost per unit and the total amount. For each of these columns, the report specifies the cost as the various value entry types.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5801;
                      Image=Report }
      { 1907846806;3 ;Action    ;
                      CaptionML=[DAN=Sammenligningsoversigt;
                                 ENU=Compare List];
                      ToolTipML=[DAN=FÜ vist en sammenligning af komponenter for to varer. Udskriften sammenligner komponenterne, deres kostpris, kostfordeling og kostpris pr. komponent.;
                                 ENU=View a comparison of components for two items. The printout compares the components, their unit cost, cost share and cost per component.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 99000758;
                      Image=Report }
      { 100     ;2   ;ActionGroup;
                      CaptionML=[DAN=Lagerbeholdningsdetaljer;
                                 ENU=Inventory Details];
                      Image=Report }
      { 1904068306;3 ;Action    ;
                      CaptionML=[DAN=Vare - kontokort;
                                 ENU=Inventory - Transaction Detail];
                      ToolTipML=[DAN=FÜ vist transaktionsdetaljer med poster for valgte varer i en angivet periode. Rapporten viser lagerbeholdningen ved periodens start med alle periodens tilgangs- og afgangsposter med lõbende opdatering af lageret, samt lageret ved periodens afslutning. Rapporten kan f.eks. bruges i forbindelse med afslutningen pÜ en regnskabsperiode eller ved revision.;
                                 ENU=View transaction details with entries for the selected items for a selected period. The report shows the inventory at the beginning of the period, all of the increase and decrease entries during the period with a running update of the inventory, and the inventory at the close of the period. The report can be used at the close of an accounting period, for example, or for an audit.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 704;
                      Image=Report }
      { 1900461506;3 ;Action    ;
                      CaptionML=[DAN=Varegebyrer - specifikation;
                                 ENU=Item Charges - Specification];
                      ToolTipML=[DAN=FÜ vist en specifikation af de direkte omkostninger, virksomheden har tilknyttet og bogfõrt som varegebyrer. Rapporten viser de forskellige vërdiposter, der er bogfõrt som varegebyrer. Alle kõbspriser medtages, bÜde dem, der er bogfõrt som fakturerede, og dem, der er bogfõrt som forventede.;
                                 ENU=View a specification of the direct costs that your company has assigned and posted as item charges. The report shows the various value entries that have been posted as item charges. It includes all costs, both those posted as invoiced and those posted as expected.];
                      ApplicationArea=#ItemCharges;
                      RunObject=Report 5806;
                      Image=Report }
      { 1900111206;3 ;Action    ;
                      CaptionML=[DAN=Beholdningsëndring - antal;
                                 ENU=Item Age Composition - Qty.];
                      ToolTipML=[DAN=Vis, udskriv eller gem en oversigt over den aktuelle alderssammensëtning pÜ bestemte varer i lagerbeholdningen.;
                                 ENU=View, print, or save an overview of the current age composition of selected items in your inventory.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 5807;
                      Image=Report }
      { 1906747006;3 ;Action    ;
                      CaptionML=[DAN=Vareudlõb - antal;
                                 ENU=Item Expiration - Quantity];
                      ToolTipML=[DAN=FÜ vist en oversigt over det antal udvalgte varer pÜ lageret, hvor udlõbsdatoen falder inden for en bestemt periode. Listen viser antallet af enheder for den udvalgte vare, der udlõber inden for en angivet tidsperiode. Det udskrevne dokument viser antallet af enheder, der udlõber inden for hver af tre perioder med samme varighed og det samlede lagerantal for hver af de varer, du har angivet under opsëtning af rapporten.;
                                 ENU=View an overview of the quantities of selected items in your inventory whose expiration dates fall within a certain period. The list shows the number of units of the selected item that will expire in a given time period. For each of the items that you specify when setting up the report, the printed document shows the number of units that will expire during each of three periods of equal length and the total inventory quantity of the selected item.];
                      ApplicationArea=#ItemTracking;
                      RunObject=Report 5809;
                      Image=Report }
      { 102     ;2   ;ActionGroup;
                      Name=Reports;
                      CaptionML=[DAN=Lagerbeholdningsstatistik;
                                 ENU=Inventory Statistics];
                      Image=Report }
      { 1900762706;3 ;Action    ;
                      CaptionML=[DAN=Vare - salgsstatistik;
                                 ENU=Inventory - Sales Statistics];
                      ToolTipML=[DAN=Vis, udskriv eller gem en oversigt over varesalg pr. debitor, f.eks. med henblik pÜ at analysere avancen pÜ individuelle varer eller for at se avancetendenser. Rapporten specificerer direkte kõbspris, enhedspris, salgsantal, salg i den lokale valuta, avanceprocent og avance.;
                                 ENU=View, print, or save a summary of selected items' sales per customer, for example, to analyze the profit on individual items or trends in revenues and profit. The report specifies direct unit cost, unit price, sales quantity, sales in LCY, profit percentage, and profit.];
                      ApplicationArea=#Suite;
                      RunObject=Report 712;
                      Image=Report }
      { 1904034006;3 ;Action    ;
                      CaptionML=[DAN=Vare/kundestatistik;
                                 ENU=Inventory - Customer Sales];
                      ToolTipML=[DAN=Vis, udskriv eller gem en liste over debitorer, der har kõbt bestemte varer inden for en bestemt periode, f.eks. med henblik pÜ at analysere debitorers kõbsmõnstre. Rapporten specificerer beholdning, mëngde, rabat, avanceprocent og avance.;
                                 ENU=View, print, or save a list of customers that have purchased selected items within a selected period, for example, to analyze customers' purchasing patterns. The report specifies quantity, amount, discount, profit percentage, and profit.];
                      ApplicationArea=#Suite;
                      RunObject=Report 713;
                      Image=Report }
      { 1907930606;3 ;Action    ;
                      CaptionML=[DAN=Vare - top 10-liste;
                                 ENU=Inventory - Top 10 List];
                      ToolTipML=[DAN=FÜ vist oplysninger om varerne med de hõjeste og laveste salgstal inden for en udvalgt periode. Du kan ogsÜ vëlge, at varer, der ikke er pÜ lager eller ikke er blevet solgt, ikke skal medtages i rapporten. I rapporten sorteres varerne i stõrrelsesorden inden for den valgte periode. Oversigten giver et hurtigt overblik over, hvilke varer der enten sëlger bedst eller dÜrligst, eller hvilke varer der er flest eller fërrest af pÜ lager.;
                                 ENU=View information about the items with the highest or lowest sales within a selected period. You can also choose that items that are not on hand or have not been sold are not included in the report. The items are sorted by order size within the selected period. The list gives a quick overview of the items that have sold either best or worst, or the items that have the most or fewest units on inventory.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 711;
                      Image=Report }
      { 104     ;2   ;ActionGroup;
                      CaptionML=[DAN=Finansrapporter;
                                 ENU=Finance Reports];
                      Image=Report }
      { 1906316306;3 ;Action    ;
                      CaptionML=[DAN=Lagervërdi;
                                 ENU=Inventory Valuation];
                      ToolTipML=[DAN=Se, udskriv eller gem en liste over vërdier for det disponible antal af hver lagervare.;
                                 ENU=View, print, or save a list of the values of the on-hand quantity of each inventory item.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 1001;
                      Image=Report }
      { 1901254106;3 ;Action    ;
                      CaptionML=[DAN=Status;
                                 ENU=Status];
                      ToolTipML=[DAN=Se, udskriv eller gem status for delvist udfyldte eller ikke-udfyldte ordrer, sÜ du kan angive, hvordan en opfyldning af disse ordrer pÜvirker lagerbeholdningen.;
                                 ENU=View, print, or save the status of partially filled or unfilled orders so you can determine what effect filling these orders may have on your inventory.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 706;
                      Image=Report }
      { 1903496006;3 ;Action    ;
                      CaptionML=[DAN=Beholdningsëndring - vërdi;
                                 ENU=Item Age Composition - Value];
                      ToolTipML=[DAN=Vis, udskriv eller gem en oversigt over den aktuelle alderssammensëtning pÜ bestemte varer i lagerbeholdningen.;
                                 ENU=View, print, or save an overview of the current age composition of selected items in your inventory.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5808;
                      Image=Report }
      { 129     ;1   ;ActionGroup;
                      CaptionML=[DAN=Ordrer;
                                 ENU=Orders] }
      { 1903262806;2 ;Action    ;
                      CaptionML=[DAN=Varer i salgsordrer;
                                 ENU=Inventory Order Details];
                      ToolTipML=[DAN=FÜ vist en liste over, hvilke ordrer der endnu ikke er leveret eller modtaget, og hvilke varer der indgÜr i ordren. Den viser ordrenummer, debitors navn, afsendelsesdato, ordrestõrrelse, antal i restordre, udestÜende antal, enhedspris, rabatprocent og belõb. Restordreantal, udestÜende antal og belõb lëgges sammen for hver vare. Rapporten kan bruges til at vise, om der er aktuelle eller kommende leveringsproblemer.;
                                 ENU=View a list of the orders that have not yet been shipped or received and the items in the orders. It shows the order number, customer's name, shipment date, order quantity, quantity on back order, outstanding quantity and unit price, as well as possible discount percentage and amount. The quantity on back order and outstanding quantity and amount are totaled for each item. The report can be used to find out whether there are currently shipment problems or any can be expected.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 708;
                      Image=Report }
      { 1904739806;2 ;Action    ;
                      CaptionML=[DAN=Varer i kõbsordrer;
                                 ENU=Inventory Purchase Orders];
                      ToolTipML=[DAN=Vis en oversigt over varer, der er bestilt hos kreditorer. Den indeholder ogsÜ oplysninger om forventet modtagelsesdato og restordrer i antal og belõb. Rapporten kan f.eks. bruges til at give et overblik over det forventede leveringstidspunkt for varerne, og om der skal rykkes for restordrer.;
                                 ENU=View a list of items on order from vendors. It also shows the expected receipt date and the quantity and amount on back orders. The report can be used, for example, to see when items should be received and whether a reminder of a back order should be issued.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 709;
                      Image=Report }
      { 1906231806;2 ;Action    ;
                      CaptionML=[DAN=Vare/leverandõrstatistik;
                                 ENU=Inventory - Vendor Purchases];
                      ToolTipML=[DAN=FÜ vist en liste over de leverandõrer, virksomheden har indkõbt varer hos i den valgte periode. Der vises oplysninger om faktureret antal, belõb og rabat. Rapporten kan bruges til analyse af virksomhedens varekõb.;
                                 ENU=View a list of the vendors that your company has purchased items from within a selected period. It shows invoiced quantity, amount and discount. The report can be used to analyze a company's item purchases.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 714;
                      Image=Report }
      { 1906101206;2 ;Action    ;
                      CaptionML=[DAN=Vare - genbestillingsliste;
                                 ENU=Inventory - Reorders];
                      ToolTipML=[DAN=FÜ vist en liste med negativt lager, som sorteres efter leverandõr. Du kan bruge denne rapport til at hjëlpe med at afgõre, hvilke varer skal genbestilles. Denne rapport viser, hvor mange varer er indgÜende pÜ kõbsordrer eller overflytningsordrer, samt hvor mange varer er pÜ lager. PÜ basis af disse oplysninger og det definerede genbestillingsantal for en vare indsëttes en foreslÜet vërdi i feltet Antal til ordre.;
                                 ENU=View a list of items with negative inventory that is sorted by vendor. You can use this report to help decide which items have to be reordered. The report shows how many items are inbound on purchase orders or transfer orders and how many items are in inventory. Based on this information and any defined reorder quantity for the item, a suggested value is inserted in the Qty. to Order field.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 717;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1900210306;2 ;Action    ;
                      CaptionML=[DAN=Vare - restordrer til kunder;
                                 ENU=Inventory - Sales Back Orders];
                      ToolTipML=[DAN=Viser en liste med ordrelinjer med overskredne afsendelsesdatoer. Rapporten viser ogsÜ, om kunden har andre varer i restordre.;
                                 ENU=Shows a list of order lines with shipment dates that are exceeded. The report also shows if there are other items for the customer on back order.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 718;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 126     ;1   ;ActionGroup;
                      CaptionML=[DAN=Vare;
                                 ENU=Item] }
      { 123     ;2   ;Action    ;
                      Name=ApprovalEntries;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID);
                               END;
                                }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=Disponering;
                                 ENU=Availability];
                      Image=Item }
      { 73      ;2   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Varer p&r. lokation;
                                 ENU=Items b&y Location];
                      ToolTipML=[DAN=Viser en liste over varer grupperet efter lokation.;
                                 ENU=Show a list of items grouped by location.];
                      ApplicationArea=#Location;
                      Image=ItemAvailbyLoc;
                      OnAction=BEGIN
                                 PAGE.RUN(PAGE::"Items by Location",Rec);
                               END;
                                }
      { 79      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Varedisponering pr.;
                                 ENU=&Item Availability by];
                      Image=ItemAvailability }
      { 5       ;3   ;Action    ;
                      Name=<Action5>;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilgëngelige saldo for en vare udvikles over tid i henhold til udbud og efterspõrgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Advanced;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 21      ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder, f.eks. dag, uge eller mÜned.;
                                 ENU=Show the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 157;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Filter),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Filter);
                      Image=Period }
      { 80      ;3   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5414;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Filter),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Filter);
                      Image=ItemVariant }
      { 78      ;3   ;Action    ;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 492;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Filter),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Filter);
                      Image=Warehouse }
      { 13      ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=FÜ vist tilgëngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret pÜ tilgëngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 19      ;3   ;Action    ;
                      CaptionML=[DAN=Tidslinje;
                                 ENU=Timeline];
                      ToolTipML=[DAN=FÜ en grafisk visning af en vares planlagte lager baseret pÜ fremtidige udbuds- og efterspõrgselshëndelser med eller uden planlëgningsforslag. Resultatet er en grafisk gengivelse af lagerprofilen.;
                                 ENU=Get a graphical view of an item's projected inventory based on future supply and demand events, with or without planning suggestions. The result is a graphical representation of the inventory profile.];
                      ApplicationArea=#Advanced;
                      Image=Timeline;
                      OnAction=BEGIN
                                 ShowTimelineFromItem(Rec);
                               END;
                                }
      { 83      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 75      ;2   ;Action    ;
                      Name=CRMGoToProduct;
                      CaptionML=[DAN=Produkt;
                                 ENU=Product];
                      ToolTipML=[DAN=èbn det sammenkëdede Dynamics 365 for Sales-produkt.;
                                 ENU=Open the coupled Dynamics 365 for Sales product.];
                      ApplicationArea=#Suite;
                      Image=CoupledItem;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowCRMEntityFromRecordID(RECORDID);
                               END;
                                }
      { 72      ;2   ;Action    ;
                      Name=CRMSynchronizeNow;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Synkroniser;
                                 ENU=Synchronize];
                      ToolTipML=[DAN=Send de opdaterede data til Dynamics 365 for Sales.;
                                 ENU=Send updated data to Dynamics 365 for Sales.];
                      ApplicationArea=#Suite;
                      Image=Refresh;
                      OnAction=VAR
                                 Item@1000 : Record 27;
                                 CRMIntegrationManagement@1001 : Codeunit 5330;
                                 ItemRecordRef@1003 : RecordRef;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Item);
                                 Item.NEXT;

                                 IF Item.COUNT = 1 THEN
                                   CRMIntegrationManagement.UpdateOneNow(Item.RECORDID)
                                 ELSE BEGIN
                                   ItemRecordRef.GETTABLE(Item);
                                   CRMIntegrationManagement.UpdateMultipleNow(ItemRecordRef);
                                 END
                               END;
                                }
      { 70      ;2   ;ActionGroup;
                      Name=Coupling;
                      CaptionML=[@@@=Coupling is a noun;
                                 DAN=Sammenkëdning;
                                 ENU=Coupling];
                      ToolTipML=[DAN=Opret, rediger eller slet en sammenkëdning mellem Microsoft Dynamics NAV-recorden og en Dynamics 365 for Sales-record.;
                                 ENU=Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.];
                      Image=LinkAccount }
      { 68      ;3   ;Action    ;
                      Name=ManageCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Konfigurer sammenkëdning;
                                 ENU=Set Up Coupling];
                      ToolTipML=[DAN=Opret eller rediger sammenkëdningen med et Dynamics 365 for Sales-produkt.;
                                 ENU=Create or modify the coupling to a Dynamics 365 for Sales product.];
                      ApplicationArea=#Suite;
                      Image=LinkAccount;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.DefineCoupling(RECORDID);
                               END;
                                }
      { 66      ;3   ;Action    ;
                      Name=DeleteCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Slet sammenkëdning;
                                 ENU=Delete Coupling];
                      ToolTipML=[DAN=Slet sammenkëdningen med et Dynamics 365 for Sales-produkt.;
                                 ENU=Delete the coupling to a Dynamics 365 for Sales product.];
                      ApplicationArea=#Suite;
                      Enabled=CRMIsCoupledToRecord;
                      Image=UnLinkAccount;
                      OnAction=VAR
                                 CRMCouplingManagement@1000 : Codeunit 5331;
                               BEGIN
                                 CRMCouplingManagement.RemoveCoupling(RECORDID);
                               END;
                                }
      { 54      ;1   ;ActionGroup;
                      Name=Assembly/Production;
                      CaptionML=[DAN=Montage/produktion;
                                 ENU=Assembly/Production];
                      Image=Production }
      { 52      ;2   ;Action    ;
                      CaptionML=[DAN=Struktur;
                                 ENU=Structure];
                      ToolTipML=[DAN=Vis, hvilke underordnede varer der bruges i en vares montagestykliste eller produktionsstykliste. Hvert vareniveau kan skjules eller vises for at fÜ et overblik eller en detaljeret visning.;
                                 ENU=View which child items are used in an item's assembly BOM or production BOM. Each item level can be collapsed or expanded to obtain an overview or detailed view.];
                      ApplicationArea=#Assembly;
                      Image=Hierarchy;
                      OnAction=VAR
                                 BOMStructure@1000 : Page 5870;
                               BEGIN
                                 BOMStructure.InitItem(Rec);
                                 BOMStructure.RUN;
                               END;
                                }
      { 50      ;2   ;Action    ;
                      CaptionML=[DAN=Kostprisfordelinger;
                                 ENU=Cost Shares];
                      ToolTipML=[DAN=FÜ vist, hvordan omkostningerne til underliggende varer pÜ styklisten akkumuleres til den overordnede vare. Oplysningerne arrangeres ifõlge styklistens struktur for at afspejle de niveauer, som de enkelte omkostninger angÜr. Hvert vareniveau kan skjules eller vises for at fÜ et overblik eller en detaljeret visning.;
                                 ENU=View how the costs of underlying items in the BOM roll up to the parent item. The information is organized according to the BOM structure to reflect at which levels the individual costs apply. Each item level can be collapsed or expanded to obtain an overview or detailed view.];
                      ApplicationArea=#Advanced;
                      Image=CostBudget;
                      OnAction=VAR
                                 BOMCostShares@1000 : Page 5872;
                               BEGIN
                                 BOMCostShares.InitItem(Rec);
                                 BOMCostShares.RUN;
                               END;
                                }
      { 49      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Montage;
                                 ENU=Assemb&ly];
                      Image=AssemblyBOM }
      { 48      ;3   ;Action    ;
                      Name=<Action32>;
                      CaptionML=[DAN=Montagestykliste;
                                 ENU=Assembly BOM];
                      ToolTipML=[DAN=FÜ vist eller rediger den stykliste, der angiver, hvilke varer og ressourcer der krëves for at samle montageelementet.;
                                 ENU=View or edit the bill of material that specifies which items and resources are required to assemble the assembly item.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 36;
                      RunPageLink=Parent Item No.=FIELD(No.);
                      Image=BOM }
      { 47      ;3   ;Action    ;
                      CaptionML=[DAN=IndgÜr-i;
                                 ENU=Where-Used];
                      ToolTipML=[DAN=FÜ vist en liste over styklister, hvor varen anvendes.;
                                 ENU=View a list of BOMs in which the item is used.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 37;
                      RunPageView=SORTING(Type,No.);
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(No.);
                      Image=Track }
      { 46      ;3   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=&Beregn kostpris;
                                 ENU=Calc. Stan&dard Cost];
                      ToolTipML=[DAN=Beregn kostprisen for varen ved at akkumulere kostprisen for hver komponent og ressource pÜ varens montagestykliste eller produktionsstykliste. Kostprisen for en overordnet vare skal altid svare til den samlede kostpris for komponenter, halvfabrikata og andre ressourcer.;
                                 ENU=Calculate the unit cost of the item by rolling up the unit cost of each component and resource in the item's assembly BOM or production BOM. The unit cost of a parent item must always equals the total of the unit costs of its components, subassemblies, and any resources.];
                      ApplicationArea=#Assembly;
                      Image=CalculateCost;
                      OnAction=BEGIN
                                 CalculateStdCost.CalcItem("No.",TRUE);
                               END;
                                }
      { 44      ;3   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=Beregn enhedspris;
                                 ENU=Calc. Unit Price];
                      ToolTipML=[DAN=Beregn enhedsprisen ud fra kostprisen og avanceprocenten.;
                                 ENU=Calculate the unit price based on the unit cost and the profit percentage.];
                      ApplicationArea=#Assembly;
                      Image=SuggestItemPrice;
                      OnAction=BEGIN
                                 CalculateStdCost.CalcAssemblyItemPrice("No.");
                               END;
                                }
      { 41      ;2   ;ActionGroup;
                      CaptionML=[DAN=Produktion;
                                 ENU=Production];
                      Image=Production }
      { 32      ;3   ;Action    ;
                      CaptionML=[DAN=Produktionsstykliste;
                                 ENU=Production BOM];
                      ToolTipML=[DAN=èbn varens produktionsstykliste for at vise eller redigere dens komponenter.;
                                 ENU=Open the item's production bill of material to view or edit its components.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000786;
                      RunPageLink=No.=FIELD(Production BOM No.);
                      Image=BOM }
      { 29      ;3   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=IndgÜr-i;
                                 ENU=Where-Used];
                      ToolTipML=[DAN=FÜ vist en liste over styklister, hvor varen anvendes.;
                                 ENU=View a list of BOMs in which the item is used.];
                      ApplicationArea=#Advanced;
                      Image=Where-Used;
                      OnAction=VAR
                                 ProdBOMWhereUsed@1001 : Page 99000811;
                               BEGIN
                                 ProdBOMWhereUsed.SetItem(Rec,WORKDATE);
                                 ProdBOMWhereUsed.RUNMODAL;
                               END;
                                }
      { 24      ;3   ;Action    ;
                      AccessByPermission=TableData 99000771=R;
                      CaptionML=[DAN=&Beregn kostpris;
                                 ENU=Calc. Stan&dard Cost];
                      ToolTipML=[DAN=Beregn kostprisen for varen ved at akkumulere kostprisen for hver komponent og ressource pÜ varens montagestykliste eller produktionsstykliste. Kostprisen for en overordnet vare skal altid svare til den samlede kostpris for komponenter, halvfabrikata og andre ressourcer.;
                                 ENU=Calculate the unit cost of the item by rolling up the unit cost of each component and resource in the item's assembly BOM or production BOM. The unit cost of a parent item must always equals the total of the unit costs of its components, subassemblies, and any resources.];
                      ApplicationArea=#Assembly;
                      Image=CalculateCost;
                      OnAction=BEGIN
                                 CalculateStdCost.CalcItem("No.",FALSE);
                               END;
                                }
      { 77      ;3   ;Action    ;
                      CaptionML=[DAN=&Reservationsposter;
                                 ENU=&Reservation Entries];
                      ToolTipML=[DAN=FÜ vist alle reservationer, der er foretaget for varen, enten manuelt eller automatisk.;
                                 ENU=View all reservations that are made for the item, either manually or automatically.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 497;
                      RunPageView=SORTING(Item No.,Variant Code,Location Code,Reservation Status);
                      RunPageLink=Reservation Status=CONST(Reservation),
                                  Item No.=FIELD(No.);
                      Image=ReservationLedger }
      { 5800    ;3   ;Action    ;
                      CaptionML=[DAN=V&ërdiposter;
                                 ENU=&Value Entries];
                      ToolTipML=[DAN=FÜ vist historikken over bogfõrte belõb, der pÜvirker vërdien af varen. Vërdiposter oprettes for hver transaktion med varen.;
                                 ENU=View the history of posted amounts that affect the value of the item. Value entries are created for every transaction with the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5802;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=ValueLedger }
      { 6500    ;3   ;Action    ;
                      CaptionML=[DAN=Vare&sporingsposter;
                                 ENU=Item &Tracking Entries];
                      ToolTipML=[DAN=Vis serie- eller lotnumre, der er tildelt til varer.;
                                 ENU=View serial or lot numbers that are assigned to items.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLedger;
                      OnAction=VAR
                                 ItemTrackingDocMgt@1000 : Codeunit 6503;
                               BEGIN
                                 ItemTrackingDocMgt.ShowItemTrackingForMasterData(3,'',"No.",'','','','');
                               END;
                                }
      { 7       ;3   ;Action    ;
                      CaptionML=[DAN=&Lagerposter;
                                 ENU=&Warehouse Entries];
                      ToolTipML=[DAN="FÜ vist historikken over antal, der er registreret for varen under lageraktiviteter. ";
                                 ENU="View the history of quantities that are registered for the item in warehouse activities. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7318;
                      RunPageView=SORTING(Item No.,Bin Code,Location Code,Variant Code,Unit of Measure Code,Lot No.,Serial No.,Entry Type,Dedicated);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=BinLedger }
      { 85      ;2   ;ActionGroup;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      Image=Statistics }
      { 16      ;3   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      Image=Statistics;
                      OnAction=VAR
                                 ItemStatistics@1001 : Page 5827;
                               BEGIN
                                 ItemStatistics.SetItem(Rec);
                                 ItemStatistics.RUNMODAL;
                               END;
                                }
      { 17      ;3   ;Action    ;
                      CaptionML=[DAN=Poststatistik;
                                 ENU=Entry Statistics];
                      ToolTipML=[DAN=Se statistik for vareposter.;
                                 ENU=View statistics for item ledger entries.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 304;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Filter),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Filter);
                      Image=EntryStatistics }
      { 22      ;3   ;Action    ;
                      CaptionML=[DAN=&Terminsoversigt;
                                 ENU=T&urnover];
                      ToolTipML=[DAN=Se en detaljeret oversigt over vareomsëtningen fordelt pÜ perioder, nÜr du har angivet de relevante filtre for lokation og variant.;
                                 ENU=View a detailed account of item turnover by periods after you have set the relevant filters for location and variant.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 158;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Filter),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Filter);
                      Image=Turnover }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=Bem&ërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Item),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Salg;
                                 ENU=S&ales];
                      Image=Sales }
      { 36      ;2   ;Action    ;
                      Name=Sales_Prices;
                      CaptionML=[DAN=Salgspriser;
                                 ENU=Prices];
                      ToolTipML=[DAN=Vis eller konfigurer forskellige priser for varen. En varepris anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er opfyldt, f.eks. kreditor, antal eller slutdato.;
                                 ENU=View or set up different prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7002;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=Price }
      { 34      ;2   ;Action    ;
                      Name=Sales_LineDiscounts;
                      CaptionML=[DAN=Linjerabat;
                                 ENU=Line Discounts];
                      ToolTipML=[DAN=Vis eller konfigurer forskellige rabatter for varen. En varerabat anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er opfyldt, f.eks. kreditor, antal eller slutdato.;
                                 ENU=View or set up different discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7004;
                      RunPageView=SORTING(Type,Code);
                      RunPageLink=Type=CONST(Item),
                                  Code=FIELD(No.);
                      Image=LineDiscount }
      { 124     ;2   ;Action    ;
                      CaptionML=[DAN=Forudb&etalingsprocenter;
                                 ENU=Prepa&yment Percentages];
                      ToolTipML=[DAN="Vis eller rediger de procentdele af prisen, der kan betales som forudbetaling. ";
                                 ENU="View or edit the percentages of the price that can be paid as a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 664;
                      RunPageLink=Item No.=FIELD(No.);
                      Image=PrepaymentPercentages }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Ordrer;
                                 ENU=Orders];
                      ToolTipML=[DAN=Vis en liste med igangvërende salgsordrer for varen.;
                                 ENU=View a list of ongoing orders for the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 48;
                      RunPageView=SORTING(Document Type,Type,No.);
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(No.);
                      Image=Document }
      { 114     ;2   ;Action    ;
                      CaptionML=[DAN=Returvareordrer;
                                 ENU=Returns Orders];
                      ToolTipML=[DAN=Vis igangvërende salgs- eller kõbsreturvareordrer for varen.;
                                 ENU=View ongoing sales or purchase return orders for the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6633;
                      RunPageView=SORTING(Document Type,Type,No.);
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(No.);
                      Image=ReturnOrder }
      { 38      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kõ&b;
                                 ENU=&Purchases];
                      Image=Purchasing }
      { 118     ;2   ;Action    ;
                      CaptionML=[DAN=&Kreditorer;
                                 ENU=Ven&dors];
                      ToolTipML=[DAN=Vis oversigten over kreditorer, der kan levere varen, samt gennemlõbstiden.;
                                 ENU=View the list of vendors who can supply the item, and at which lead time.];
                      ApplicationArea=#Planning;
                      RunObject=Page 114;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=Vendor }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=Kõbspriser;
                                 ENU=Prices];
                      ToolTipML=[DAN=Vis eller konfigurer forskellige priser for varen. En varepris anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er opfyldt, f.eks. kreditor, antal eller slutdato.;
                                 ENU=View or set up different prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7012;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=Price }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Linjerabat;
                                 ENU=Line Discounts];
                      ToolTipML=[DAN=Vis eller konfigurer forskellige rabatter for varen. En varerabat anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er opfyldt, f.eks. kreditor, antal eller slutdato.;
                                 ENU=View or set up different discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7014;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=LineDiscount }
      { 125     ;2   ;Action    ;
                      CaptionML=[DAN=Forudb&etalingsprocenter;
                                 ENU=Prepa&yment Percentages];
                      ToolTipML=[DAN="Vis eller rediger de procentdele af prisen, der kan betales som forudbetaling. ";
                                 ENU="View or edit the percentages of the price that can be paid as a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 665;
                      RunPageLink=Item No.=FIELD(No.);
                      Image=PrepaymentPercentages }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Ordrer;
                                 ENU=Orders];
                      ToolTipML=[DAN=Vis en liste med igangvërende salgsordrer for varen.;
                                 ENU=View a list of ongoing orders for the item.];
                      ApplicationArea=#Suite;
                      RunObject=Page 56;
                      RunPageView=SORTING(Document Type,Type,No.);
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(No.);
                      Image=Document }
      { 115     ;2   ;Action    ;
                      CaptionML=[DAN=Returvareordrer;
                                 ENU=Return Orders];
                      ToolTipML=[DAN=èbn listen over igangvërende returordrer for varen.;
                                 ENU=Open the list of ongoing return orders for the item.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 6643;
                      RunPageView=SORTING(Document Type,Type,No.);
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(No.);
                      Image=ReturnOrder }
      { 76      ;2   ;Action    ;
                      CaptionML=[DAN=Kata&logvarer;
                                 ENU=Nonstoc&k Items];
                      ToolTipML=[DAN="Vis oversigten over varer, du ikke lagerfõrer. ";
                                 ENU="View the list of items that you do not carry in inventory. "];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5726;
                      Image=NonStockItem }
      { 146     ;1   ;ActionGroup;
                      Name=PurchPricesandDiscounts;
                      CaptionML=[DAN=Specialkõbspriser og -rabatter;
                                 ENU=Special Purchase Prices & Discounts] }
      { 144     ;2   ;Action    ;
                      CaptionML=[DAN=Angiv specialpriser;
                                 ENU=Set Special Prices];
                      ToolTipML=[DAN=Angiv forskellige priser for varen. En varepris anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er opfyldt, f.eks. kreditor, antal eller slutdato.;
                                 ENU=Set up different prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Suite;
                      RunObject=Page 7012;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=Price }
      { 143     ;2   ;Action    ;
                      CaptionML=[DAN=Angiv specialrabatter;
                                 ENU=Set Special Discounts];
                      ToolTipML=[DAN=Angiv forskellige rabatter for varen. En varerabat anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. kreditor, mëngde eller slutdato.;
                                 ENU=Set up different discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Suite;
                      RunObject=Page 7014;
                      RunPageLink=Item No.=FIELD(No.);
                      Image=LineDiscount }
      { 107     ;2   ;Action    ;
                      Name=PurchPricesDiscountsOverview;
                      CaptionML=[DAN=Oversigt over specialpriser og -rabatter;
                                 ENU=Special Prices & Discounts Overview];
                      ToolTipML=[DAN=Vis de sërlige priser og kõbslinjerabatter, som du giver til denne vare, nÜr visse kriterier er opfyldt, f.eks. kreditor, mëngde eller slutdato.;
                                 ENU=View the special prices and line discounts that you grant for this item when certain criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Suite;
                      Image=PriceWorksheet;
                      OnAction=VAR
                                 PurchasesPriceAndLineDisc@1000 : Page 1346;
                               BEGIN
                                 PurchasesPriceAndLineDisc.LoadItem(Rec);
                                 PurchasesPriceAndLineDisc.RUNMODAL;
                               END;
                                }
      { 58      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 116     ;2   ;Action    ;
                      CaptionML=[DAN=Placeringsin&dhold;
                                 ENU=&Bin Contents];
                      ToolTipML=[DAN=FÜ vist varens antal pÜ alle relevante placeringer. Du kan se alle vigtige parametre i relation til placeringsindholdet, og du kan redigere bestemte parametre for placeringsindholdet i dette vindue.;
                                 ENU=View the quantities of the item in each bin where it exists. You can see all the important parameters relating to bin content, and you can modify certain bin content parameters in this window.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7379;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=BinContent }
      { 81      ;2   ;Action    ;
                      CaptionML=[DAN=&Lagervare (pr. lokation);
                                 ENU=Stockkeepin&g Units];
                      ToolTipML=[DAN="èbn lagervarer for varen for at vise eller redigere forekomster af varen pÜ forskellige lokationer eller med forskellige varianter. ";
                                 ENU="Open the item's SKUs to view or edit instances of the item at different locations or with different variants. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5701;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=SKU }
      { 60      ;1   ;ActionGroup;
                      CaptionML=[DAN=Service;
                                 ENU=Service];
                      Image=ServiceItem }
      { 103     ;2   ;Action    ;
                      CaptionML=[DAN=Servi&ceartikler;
                                 ENU=Ser&vice Items];
                      ToolTipML=[DAN="Vis forekomster af varen som serviceartikler, f.eks. maskiner som du vedligeholder eller reparerer for debitorer via serviceordrer. ";
                                 ENU="View instances of the item as service items, such as machines that you maintain or repair for customers through service orders. "];
                      ApplicationArea=#Service;
                      RunObject=Page 5988;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=ServiceItem }
      { 11      ;2   ;Action    ;
                      AccessByPermission=TableData 5900=R;
                      CaptionML=[DAN=Fejlfinding;
                                 ENU=Troubleshooting];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om tekniske problemer med en serviceartikel.;
                                 ENU=View or edit information about technical problems with a service item.];
                      ApplicationArea=#Service;
                      Image=Troubleshoot;
                      OnAction=VAR
                                 TroubleshootingHeader@1000 : Record 5943;
                               BEGIN
                                 TroubleshootingHeader.ShowForItem(Rec);
                               END;
                                }
      { 105     ;2   ;Action    ;
                      CaptionML=[DAN=Opsëtning af fejlfinding;
                                 ENU=Troubleshooting Setup];
                      ToolTipML=[DAN=Vis eller rediger indstillingerne for fejlfinding til serviceartikler.;
                                 ENU=View or edit your settings for troubleshooting service items.];
                      ApplicationArea=#Service;
                      RunObject=Page 5993;
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(No.);
                      Image=Troubleshoot }
      { 62      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ressourcer;
                                 ENU=Resources];
                      Image=Resource }
      { 108     ;2   ;Action    ;
                      CaptionML=[DAN=Ressource&kvalifikationer;
                                 ENU=Resource &Skills];
                      ToolTipML=[DAN=Vis tildelingen af kvalifikationer til ressourcer, varer, serviceartikelgrupper og serviceartikler. Du kan bruge kvalifikationskoderne til at allokere kvalificerede ressourcer til serviceartikler eller varer, hvor der ved reparation krëves specialviden.;
                                 ENU=View the assignment of skills to resources, items, service item groups, and service items. You can use skill codes to allocate skilled resources to service items or items that need special skills for servicing.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 6019;
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(No.);
                      Image=ResourceSkills }
      { 109     ;2   ;Action    ;
                      AccessByPermission=TableData 5900=R;
                      CaptionML=[DAN=Kval. r&essourcer;
                                 ENU=Skilled R&esources];
                      ToolTipML=[DAN=Vis en liste over alle registrerede ressourcer med oplysninger om, hvorvidt de har de nõdvendige kvalifikationer til at reparere den aktuelle serviceartikelgruppe, vare eller serviceartikel.;
                                 ENU=View a list of all registered resources with information about whether they have the skills required to service the particular service item group, item, or service item.];
                      ApplicationArea=#Jobs;
                      Image=ResourceSkills;
                      OnAction=VAR
                                 ResourceSkill@1001 : Record 5956;
                               BEGIN
                                 CLEAR(SkilledResourceList);
                                 SkilledResourceList.Initialize(ResourceSkill.Type::Item,"No.",Description);
                                 SkilledResourceList.RUNMODAL;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Vare;
                           ENU=Item];
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ varen.;
                           ENU=Specifies the number of the item.];
                ApplicationArea=#All;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen.;
                           ENU=Specifies a description of the item.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varekortet reprësenterer en fysisk vare (Lagerbeholdning) eller en service (Service).;
                           ENU=Specifies if the item card represents a physical item (Inventory) or a service (Service).];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type;
                Visible=IsFoundationEnabled }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen, f.eks. stk., ësker eller dÜser, der er pÜ lager.;
                           ENU=Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Inventory;
                HideValue=IsService }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen blev oprettet ud fra en katalogvare.;
                           ENU=Specifies that the item was created from a nonstock item.];
                ApplicationArea=#Advanced;
                SourceExpr="Created From Nonstock Item";
                Visible=FALSE }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der findes en erstatning for denne vare.;
                           ENU=Specifies that a substitute exists for this item.];
                ApplicationArea=#Suite;
                SourceExpr="Substitutes Exist" }

    { 112 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der findes en lagervare (SKU) for denne vare.;
                           ENU=Specifies that a stockkeeping unit exists for this item.];
                ApplicationArea=#Warehouse;
                SourceExpr="Stockkeeping Unit Exists";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                AccessByPermission=TableData 90=R;
                ToolTipML=[DAN=Angiver, om varen er en montagestykliste.;
                           ENU=Specifies if the item is an assembly BOM.];
                ApplicationArea=#Assembly;
                SourceExpr="Assembly BOM" }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den produktionsstykliste, som varen reprësenterer.;
                           ENU=Specifies the number of the production BOM that the item represents.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Production BOM No." }

    { 101 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den produktionsrute, som varen bruges i.;
                           ENU=Specifies the number of the production routing that the item is used in.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den basisenhed, der bruges til at mÜle varen, som f.eks. stk., kasse eller palle. BasismÜleenheden fungerer ogsÜ som konverteringsbasis for alternative mÜleenheder.;
                           ENU=Specifies the base unit used to measure the item, such as piece, box, or pallet. The base unit of measure also serves as the conversion basis for alternate units of measure.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Base Unit of Measure" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor varen findes pÜ lageret. Dette er kun orienterende.;
                           ENU=Specifies where to find the item in the warehouse. This is informational only.];
                ApplicationArea=#Advanced;
                SourceExpr="Shelf No.";
                Visible=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan varens kostprisforlõb registreres, og om en faktisk eller budgetteret vërdi fõres som aktiv og bruges i beregningen af kostprisen.;
                           ENU=Specifies how the item's cost flow is recorded and whether an actual or budgeted value is capitalized and used in the cost calculation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Costing Method";
                Visible=FALSE }

    { 122 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varens pris er reguleret enten automatisk eller manuelt.;
                           ENU=Specifies whether the item's unit cost has been adjusted, either automatically or manually.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost is Adjusted" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kostpris, der anvendes som et overslag, hvor afvigelser kan justeres pÜ et senere tidspunkt. Dette anvendes typisk ved montage og produktion, hvor omkostningerne varierer.;
                           ENU=Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Standard Cost";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. vareenhed.;
                           ENU=Specifies the cost per unit of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Cost" }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den seneste kõbspris, der er betalt for varen.;
                           ENU=Specifies the most recent direct unit cost that was paid for the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Last Direct Cost";
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver relationen mellem felterne Kostpris, Enhedspris og Avancepct. for denne vare.;
                           ENU=Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this item.];
                ApplicationArea=#Advanced;
                SourceExpr="Price/Profit Calculation";
                Visible=FALSE }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dëkningsgrad, du vil sëlge varen med. Du kan angive en avanceprocent manuelt eller fÜ den angivet i henhold til feltet Avancepct.beregning;
                           ENU=Specifies the profit margin that you want to sell the item at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field];
                ApplicationArea=#Advanced;
                SourceExpr="Profit %";
                Visible=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen i RV for en enhed af varen.;
                           ENU=Specifies the price for one unit of the item, in LCY.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Unit Price" }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver links mellem forretningstransaktioner, som er lavet til varen, og en lagerkonto i finansposterne for at samle belõbene for denne varetype i en gruppe.;
                           ENU=Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.];
                ApplicationArea=#Advanced;
                SourceExpr="Inventory Posting Group";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsproduktbogfõringsgruppen. Knytter forretningstransaktioner for varen, ressourcen eller finanskontoen til finansregnskabet for at gõre rede for momsbelõbet som fõlge af handlen med den pÜgëldende record.;
                           ENU=Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en varegruppekode, der kan bruges som kriterie til at tildele en rabat, nÜr varen sëlges til en bestemt debitor.;
                           ENU=Specifies an item group code that can be used as a criterion to grant a discount when the item is sold to a certain customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Item Disc. Group";
                Visible=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den kreditor, der leverer denne vare som standard.;
                           ENU=Specifies the vendor code of who supplies this item by default.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor No." }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som kreditoren bruger til denne vare.;
                           ENU=Specifies the number that the vendor uses for this item.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Item No.";
                Visible=FALSE }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for varens brugstarifnummer.;
                           ENU=Specifies a code for the item's tariff number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Tariff No.";
                Visible=FALSE }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en sõgebeskrivelse, som du kan bruge til at finde varen pÜ lister.;
                           ENU=Specifies a search description that you use to find the item in lists.];
                ApplicationArea=#Advanced;
                SourceExpr="Search Description" }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens indirekte omkostning som et absolut belõb.;
                           ENU=Specifies the item's indirect cost as an absolute amount.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Overhead Rate";
                Visible=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste kõbspris, der omfatter indirekte omkostninger, sÜsom fragt, der er knyttet til kõbet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Indirect Cost %";
                Visible=FALSE }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver den kategori, varen hõrer til. Varekategorier omfatter ogsÜ vareattributter, der mÜtte vëre tildelt.;
                           ENU=Specifies the category that the item belongs to. Item categories also contain any assigned item attributes.];
                ApplicationArea=#Advanced;
                SourceExpr="Item Category Code";
                Visible=FALSE }

    { 1102601002;2;Field  ;
                ToolTipML=[DAN=Angiver en produktgruppekode, der er tilknyttet varekategorien.;
                           ENU=Specifies a product group code associated with the item category.];
                ApplicationArea=#Advanced;
                SourceExpr="Product Group Code";
                Visible=FALSE }

    { 1102601004;2;Field  ;
                ToolTipML=[DAN=Angiver, at transaktioner med varen ikke kan bogfõres, f.eks. fordi varen er i karantëne.;
                           ENU=Specifies that transactions with the item cannot be posted, for example, because the item is in quarantine.];
                ApplicationArea=#Advanced;
                SourceExpr=Blocked;
                Visible=FALSE }

    { 1102601006;2;Field  ;
                ToolTipML=[DAN=Angiver, hvornÜr varekortet sidst blev ëndret.;
                           ENU=Specifies when the item card was last modified.];
                ApplicationArea=#Advanced;
                SourceExpr="Last Date Modified";
                Visible=FALSE }

    { 1102601010;2;Field  ;
                ToolTipML=[DAN=Angiver den enhedskode, der skal bruges, nÜr du sëlger varen.;
                           ENU=Specifies the unit of measure code used when you sell the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Unit of Measure";
                Visible=FALSE }

    { 1102601012;2;Field  ;
                ToolTipML=[DAN=Angiver, hvilken type forsyningsordre der oprettes af planlëgningssystemet, nÜr varen skal genbestilles.;
                           ENU=Specifies the type of supply order created by the planning system when the item needs to be replenished.];
                ApplicationArea=#Advanced;
                SourceExpr="Replenishment System";
                Visible=FALSE }

    { 1102601016;2;Field  ;
                ToolTipML=[DAN=Angiver den enhedskode, der bruges, nÜr du kõber varen.;
                           ENU=Specifies the unit of measure code used when you purchase the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Purch. Unit of Measure";
                Visible=FALSE }

    { 1102601018;2;Field  ;
                ToolTipML=[DAN=Angiver en datoformel for det tidsrum, det tager at genbestille varen.;
                           ENU=Specifies a date formula for the amount of time it takes to replenish the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Lead Time Calculation";
                Visible=FALSE }

    { 1102601020;2;Field  ;
                ToolTipML=[DAN=Angiver, om der skal foretages beregninger af yderligere ordrer for tilknyttede komponenter.;
                           ENU=Specifies if additional orders for any related components are calculated.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Manufacturing Policy";
                Visible=FALSE }

    { 1102601024;2;Field  ;
                ToolTipML=[DAN=Angiver, hvordan forbruget af varen (komponenten) beregnes og hÜndteres i produktionsprocesserne. Manuelt: Angiv og bogfõr forbrug i forbrugskladden manuelt. Fremad: Bogfõrer automatisk forbrug ifõlge produktionsordrekomponentlinjerne, nÜr den fõrste handling starter. Baglëns: Beregner og bogfõrer automatisk forbrug ifõlge produktionsordrekomponentlinjerne, nÜr produktionsordren er fërdig. Pluk + Fremad / Pluk + Baglëns: Variationer med lagersted.;
                           ENU=Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.];
                ApplicationArea=#Advanced;
                SourceExpr="Flushing Method";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken standardordrestrõm der bruges til at levere dette montageelement.;
                           ENU=Specifies which default order flow is used to supply this assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr="Assembly Policy";
                Visible=FALSE }

    { 1102601026;2;Field  ;
                ToolTipML=[DAN=Angiver, hvor mange af varerne der spores i forsyningskëden.;
                           ENU=Specifies how items are tracked in the supply chain.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Item Tracking Code";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                CaptionML=[DAN=Standardperiodiseringsskabelon;
                           ENU=Default Deferral Template];
                ToolTipML=[DAN=Angiver den standardskabelon, der styrer, hvordan indtjening og udgifter skal periodiseres til perioderne, nÜr de indtrëffer.;
                           ENU=Specifies the default template that governs how to defer revenues and expenses to the periods when they occurred.];
                ApplicationArea=#Suite;
                SourceExpr="Default Deferral Template Code";
                Importance=Additional }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 140 ;1   ;Part      ;
                Name=Power BI Report FactBox;
                CaptionML=[DAN=Power BI-rapporter;
                           ENU=Power BI Reports];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page6306;
                Visible=PowerBIVisible;
                PartType=Page }

    { 3   ;1   ;Part      ;
                ApplicationArea=#All;
                SubPageLink=Source Type=CONST(Item),
                            Source No.=FIELD(No.);
                PagePartID=Page875;
                Visible=SocialListeningVisible;
                PartType=Page }

    { 26  ;1   ;Part      ;
                ApplicationArea=#All;
                SubPageLink=Source Type=CONST(Item),
                            Source No.=FIELD(No.);
                PagePartID=Page876;
                Visible=SocialListeningSetupVisible;
                PartType=Page;
                UpdatePropagation=Both }

    { 1901314507;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                            Location Filter=FIELD(Location Filter),
                            Drop Shipment Filter=FIELD(Drop Shipment Filter),
                            Bin Filter=FIELD(Bin Filter),
                            Variant Filter=FIELD(Variant Filter),
                            Lot No. Filter=FIELD(Lot No. Filter),
                            Serial No. Filter=FIELD(Serial No. Filter);
                PagePartID=Page9089;
                PartType=Page }

    { 1903326807;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                            Location Filter=FIELD(Location Filter),
                            Drop Shipment Filter=FIELD(Drop Shipment Filter),
                            Bin Filter=FIELD(Bin Filter),
                            Variant Filter=FIELD(Variant Filter),
                            Lot No. Filter=FIELD(Lot No. Filter),
                            Serial No. Filter=FIELD(Serial No. Filter);
                PagePartID=Page9090;
                Visible=FALSE;
                PartType=Page }

    { 1906840407;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                            Location Filter=FIELD(Location Filter),
                            Drop Shipment Filter=FIELD(Drop Shipment Filter),
                            Bin Filter=FIELD(Bin Filter),
                            Variant Filter=FIELD(Variant Filter),
                            Lot No. Filter=FIELD(Lot No. Filter),
                            Serial No. Filter=FIELD(Serial No. Filter);
                PagePartID=Page9091;
                PartType=Page }

    { 1901796907;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                            Location Filter=FIELD(Location Filter),
                            Drop Shipment Filter=FIELD(Drop Shipment Filter),
                            Bin Filter=FIELD(Bin Filter),
                            Variant Filter=FIELD(Variant Filter),
                            Lot No. Filter=FIELD(Lot No. Filter),
                            Serial No. Filter=FIELD(Serial No. Filter);
                PagePartID=Page9109;
                Visible=FALSE;
                PartType=Page }

    { 136 ;1   ;Part      ;
                Name=ItemAttributesFactBox;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page9110;
                PartType=Page }

    { 1900383207;1;Part   ;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      TempFilterItemAttributesBuffer@1014 : TEMPORARY Record 7506;
      TempFilteredItem@1022 : TEMPORARY Record 27;
      ApplicationAreaSetup@1015 : Record 9178;
      PowerBIUserConfiguration@1021 : Record 6304;
      SetPowerBIUserConfig@1020 : Codeunit 6305;
      CalculateStdCost@1018 : Codeunit 5812;
      ItemAvailFormsMgt@1000 : Codeunit 353;
      ApprovalsMgmt@1016 : Codeunit 1535;
      ClientTypeManagement@1024 : Codeunit 4;
      SkilledResourceList@1013 : Page 6023;
      IsFoundationEnabled@1012 : Boolean;
      SocialListeningSetupVisible@1011 : Boolean INDATASET;
      SocialListeningVisible@1010 : Boolean INDATASET;
      CRMIntegrationEnabled@1009 : Boolean;
      CRMIsCoupledToRecord@1008 : Boolean;
      OpenApprovalEntriesExist@1007 : Boolean;
      IsService@1006 : Boolean INDATASET;
      InventoryItemEditable@1005 : Boolean INDATASET;
      EnabledApprovalWorkflowsExist@1004 : Boolean;
      CanCancelApprovalForRecord@1003 : Boolean;
      IsOnPhone@1002 : Boolean;
      RunOnTempRec@1027 : Boolean;
      EventFilter@1001 : Text;
      PowerBIVisible@1017 : Boolean;
      CanRequestApprovalForFlow@1019 : Boolean;
      CanCancelApprovalForFlow@1023 : Boolean;

    [External]
    PROCEDURE GetSelectionFilter@3() : Text;
    VAR
      Item@1001 : Record 27;
      SelectionFilterManagement@1002 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(Item);
      EXIT(SelectionFilterManagement.GetSelectionFilterForItem(Item));
    END;

    [External]
    PROCEDURE SetSelection@1(VAR Item@1000 : Record 27);
    BEGIN
      CurrPage.SETSELECTIONFILTER(Item);
    END;

    LOCAL PROCEDURE SetSocialListeningFactboxVisibility@2();
    VAR
      SocialListeningMgt@1000 : Codeunit 871;
    BEGIN
      SocialListeningMgt.GetItemFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
    END;

    LOCAL PROCEDURE EnableControls@4();
    BEGIN
      IsService := (Type = Type::Service);
      InventoryItemEditable := Type = Type::Inventory;
    END;

    LOCAL PROCEDURE SetWorkflowManagementEnabledState@9();
    VAR
      WorkflowManagement@1001 : Codeunit 1501;
      WorkflowEventHandling@1000 : Codeunit 1520;
    BEGIN
      EventFilter := WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode + '|' +
        WorkflowEventHandling.RunWorkflowOnItemChangedCode;

      EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Item,EventFilter);
    END;

    LOCAL PROCEDURE ClearAttributesFilter@5();
    BEGIN
      CLEARMARKS;
      MARKEDONLY(FALSE);
      TempFilterItemAttributesBuffer.RESET;
      TempFilterItemAttributesBuffer.DELETEALL;
      FILTERGROUP(0);
      SETRANGE("No.");
    END;

    BEGIN
    END.
  }
}

