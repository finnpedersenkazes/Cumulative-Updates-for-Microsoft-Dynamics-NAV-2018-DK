OBJECT Page 30 Item Card
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varekort;
               ENU=Item Card];
    SourceTable=Table27;
    PageType=Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Proces,Rapport,Vare,Oversigt,Specialsalgspriser og -rabatter,Godkend,Anmod om godkendelse;
                                ENU=New,Process,Report,Item,History,Special Sales Prices & Discounts,Approve,Request Approval];
    OnInit=BEGIN
             InitControls;
           END;

    OnOpenPage=VAR
                 PermissionManager@1000 : Codeunit 9002;
               BEGIN
                 IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
                 EnableControls;
                 SetNoFieldVisible;
                 IsSaaS := PermissionManager.SoftwareAsAService;
               END;

    OnNewRecord=BEGIN
                  OnNewRec
                END;

    OnInsertRecord=BEGIN
                     InsertItemUnitOfMeasure;
                   END;

    OnAfterGetCurrRecord=VAR
                           CRMCouplingManagement@1002 : Codeunit 5331;
                           WorkflowManagement@1001 : Codeunit 1501;
                           WorkflowEventHandling@1000 : Codeunit 1520;
                           WorkflowWebhookManagement@1003 : Codeunit 1543;
                         BEGIN
                           CreateItemFromTemplate;
                           EnableControls;
                           IF CRMIntegrationEnabled THEN BEGIN
                             CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
                             IF "No." <> xRec."No." THEN
                               CRMIntegrationManagement.SendResultNotification(Rec);
                           END;
                           OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
                           OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);

                           WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);

                           EventFilter := WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode + '|' +
                             WorkflowEventHandling.RunWorkflowOnItemChangedCode;

                           EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Item,EventFilter);

                           CurrPage.ItemAttributesFactbox.PAGE.LoadItemAttributesData("No.");
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 123     ;1   ;ActionGroup;
                      CaptionML=[DAN=Vare;
                                 ENU=Item];
                      Image=DataEntry }
      { 199     ;2   ;Action    ;
                      Name=Attributes;
                      AccessByPermission=TableData 7500=R;
                      CaptionML=[DAN=Attributter;
                                 ENU=Attributes];
                      ToolTipML=[DAN=FÜ vist eller rediger varens attributter, f.eks. farve, stõrrelse eller andre egenskaber, der beskriver varen.;
                                 ENU=View or edit the item's attributes, such as color, size, or other characteristics that help to describe the item.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Category;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 PAGE.RUNMODAL(PAGE::"Item Attribute Value Editor",Rec);
                                 CurrPage.SAVERECORD;
                                 CurrPage.ItemAttributesFactbox.PAGE.LoadItemAttributesData("No.");
                               END;
                                }
      { 186     ;2   ;Action    ;
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
                      OnAction=VAR
                                 AdjustInventory@1000 : Page 1327;
                               BEGIN
                                 COMMIT;
                                 AdjustInventory.SetItem("No.");
                                 AdjustInventory.RUNMODAL;
                               END;
                                }
      { 119     ;2   ;Action    ;
                      CaptionML=[DAN=V&arianter;
                                 ENU=Va&riants];
                      ToolTipML=[DAN=Se, hvordan lagerniveauet for en vare udvikles over tid i henhold til den valgte variant.;
                                 ENU=View how the inventory level of an item will develop over time according to the variant that you select.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5401;
                      RunPageLink=Item No.=FIELD(No.);
                      Image=ItemVariant }
      { 218     ;2   ;Action    ;
                      CaptionML=[DAN=Id'er;
                                 ENU=Identifiers];
                      ToolTipML=[DAN=FÜ vist et entydigt id for hver vare pÜ lagerstedet, som lagermedarbejderne skal holde styr pÜ ved at bruge de hÜndholdte enheder. Vare-id'et kan omfatte varenummer, variantkode og mÜleenhed.;
                                 ENU=View a unique identifier for each item that you want warehouse employees to keep track of within the warehouse when using handheld devices. The item identifier can include the item number, the variant code and the unit of measure.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7706;
                      RunPageView=SORTING(Item No.,Variant Code,Unit of Measure Code);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=BarCode }
      { 182     ;1   ;ActionGroup;
                      Name=PricesandDiscounts;
                      CaptionML=[DAN=Specialsalgspriser og -rabatter;
                                 ENU=Special Sales Prices & Discounts] }
      { 82      ;2   ;Action    ;
                      CaptionML=[DAN=Angiv specialpriser;
                                 ENU=Set Special Prices];
                      ToolTipML=[DAN=Angiv forskellige priser for varen. En varepris anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. debitor, mëngde eller slutdato.;
                                 ENU=Set up different prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7002;
                      RunPageLink=Item No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Price;
                      PromotedCategory=Category6 }
      { 80      ;2   ;Action    ;
                      CaptionML=[DAN=Angiv specialrabatter;
                                 ENU=Set Special Discounts];
                      ToolTipML=[DAN=Angiv forskellige rabatter for varen. En varerabat anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. debitor, mëngde eller slutdato.;
                                 ENU=Set up different discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7004;
                      RunPageView=SORTING(Type,Code);
                      RunPageLink=Type=CONST(Item),
                                  Code=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=LineDiscount;
                      PromotedCategory=Category6 }
      { 165     ;2   ;Action    ;
                      Name=PricesDiscountsOverview;
                      CaptionML=[DAN=Oversigt over specialpriser og -rabatter;
                                 ENU=Special Prices & Discounts Overview];
                      ToolTipML=[DAN=Vis de sërlige priser og kõbslinjerabatter, som du giver til denne vare, nÜr visse kriterier er opfyldt, f.eks. kreditor, antal eller slutdato.;
                                 ENU=View the special prices and line discounts that you grant for this item when certain criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
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
      { 160     ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 159     ;2   ;Action    ;
                      Name=Approve;
                      CaptionML=[DAN=Godkend;
                                 ENU=Approve];
                      ToolTipML=[DAN=Godkend de anmodede ëndringer.;
                                 ENU=Approve the requested changes.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistCurrUser;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 156     ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Afvis;
                                 ENU=Reject];
                      ToolTipML=[DAN=Afvis godkendelsesanmodningen.;
                                 ENU=Reject the approval request.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistCurrUser;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 154     ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsen til en stedfortrëdende godkender.;
                                 ENU=Delegate the approval to a substitute approver.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistCurrUser;
                      Image=Delegate;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 503     ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bemërkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistCurrUser;
                      Image=ViewComments;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.GetApprovalComment(Rec);
                               END;
                                }
      { 150     ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=SendApprovalRequest }
      { 149     ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send godkendelsesan&modning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om tilladelse til at ëndre recorden.;
                                 ENU=Request approval to change the record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=(NOT OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist AND CanRequestApprovalForFlow;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category8;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckItemApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendItemForApproval(Rec);
                               END;
                                }
      { 148     ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godk&endelsesanmodning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=OpenApprovalEntriesExist OR CanCancelApprovalForFlow;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category8;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                                 WorkflowWebhookManagement@1000 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelItemApprovalRequest(Rec);
                                 WorkflowWebhookManagement.FindAndCancel(RECORDID);
                               END;
                                }
      { 46      ;2   ;ActionGroup;
                      Name=Flow;
                      CaptionML=[DAN=Flow;
                                 ENU=Flow] }
      { 47      ;3   ;Action    ;
                      Name=CreateFlow;
                      CaptionML=[DAN=Opret et workflow;
                                 ENU=Create a Flow];
                      ToolTipML=[DAN=Opret et nyt workflow fra en liste over relevante Flow-skabeloner.;
                                 ENU=Create a new Flow from a list of relevant Flow templates.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaaS;
                      Image=Flow;
                      PromotedCategory=Category8;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 FlowServiceManagement@1001 : Codeunit 6400;
                                 FlowTemplateSelector@1000 : Page 6400;
                               BEGIN
                                 // Opens page 6400 where the user can use filtered templates to create new Flows.
                                 FlowTemplateSelector.SetSearchText(FlowServiceManagement.GetItemTemplateFilter);
                                 FlowTemplateSelector.RUN;
                               END;
                                }
      { 70      ;3   ;Action    ;
                      Name=SeeFlows;
                      CaptionML=[DAN=Se mine workflows;
                                 ENU=See my Flows];
                      ToolTipML=[DAN=FÜ vist og konfigurer de workflows, du har oprettet.;
                                 ENU=View and configure Flows that you created.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 6401;
                      Promoted=Yes;
                      Image=Flow;
                      PromotedCategory=Category8;
                      PromotedOnly=Yes }
      { 193     ;1   ;ActionGroup;
                      CaptionML=[DAN=Workflow;
                                 ENU=Workflow] }
      { 197     ;2   ;Action    ;
                      Name=CreateApprovalWorkflow;
                      CaptionML=[DAN=Opret godkendelsesworkflow;
                                 ENU=Create Approval Workflow];
                      ToolTipML=[DAN=Opret et godkendelsesworkflow for oprettelse og ëndring af varer ved at gennemgÜ et par sider med instruktioner.;
                                 ENU=Set up an approval workflow for creating or changing items, by going through a few pages that will guide you.];
                      ApplicationArea=#Advanced;
                      Enabled=NOT EnabledApprovalWorkflowsExist;
                      Image=CreateWorkflow;
                      OnAction=BEGIN
                                 PAGE.RUNMODAL(PAGE::"Item Approval WF Setup Wizard");
                               END;
                                }
      { 195     ;2   ;Action    ;
                      Name=ManageApprovalWorkflow;
                      CaptionML=[DAN=Administrer godkendelsesworkflow;
                                 ENU=Manage Approval Workflow];
                      ToolTipML=[DAN=Se eller rediger eksisterende godkendelsesworkflows for oprettelse og ëndring af varer.;
                                 ENU=View or edit existing approval workflows for creating or changing items.];
                      ApplicationArea=#Advanced;
                      Enabled=EnabledApprovalWorkflowsExist;
                      Image=WorkflowSetup;
                      OnAction=VAR
                                 WorkflowManagement@1000 : Codeunit 1501;
                               BEGIN
                                 WorkflowManagement.NavigateToWorkflows(DATABASE::Item,EventFilter);
                               END;
                                }
      { 91      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 92      ;2   ;Action    ;
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
                      Name=CalculateCountingPeriod;
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
                                 Item.SETRANGE("No.","No.");
                                 PhysInvtCountMgt.UpdateItemPhysInvtCount(Item);
                               END;
                                }
      { 178     ;2   ;Action    ;
                      Name=Templates;
                      CaptionML=[DAN=Skabeloner;
                                 ENU=Templates];
                      ToolTipML=[DAN=FÜ vist eller rediger vareskabeloner.;
                                 ENU=View or edit item templates.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1340;
                      RunPageLink=Table ID=CONST(27);
                      Image=Template }
      { 242     ;2   ;Action    ;
                      Name=ApplyTemplate;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Anvend skabelon;
                                 ENU=Apply Template];
                      ToolTipML=[DAN=Anvend en skabelon for at opdatere enheden med dine standardindstillinger for en bestemt enhedstype.;
                                 ENU=Apply a template to update the entity with your standard settings for a certain type of entity.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ApplyTemplate;
                      OnAction=VAR
                                 ItemTemplate@1002 : Record 1301;
                               BEGIN
                                 ItemTemplate.UpdateItemFromTemplate(Rec);
                               END;
                                }
      { 179     ;2   ;Action    ;
                      Name=SaveAsTemplate;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Gem som skabelon;
                                 ENU=Save as Template];
                      ToolTipML=[DAN=Gem varekortet som en skabelon, der kan genbruges ved oprettelse af nye varekort. Vareskabeloner indeholder forudindstillede oplysninger som en hjëlp til udfyldelse af varekortene.;
                                 ENU=Save the item card as a template that can be reused to create new item cards. Item templates contain preset information to help you fill in fields on item cards.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Save;
                      OnAction=VAR
                                 TempItemTemplate@1002 : TEMPORARY Record 1301;
                               BEGIN
                                 TempItemTemplate.SaveAsTemplate(Rec);
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
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 126     ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 101     ;2   ;ActionGroup;
                      CaptionML=[DAN=&Poster;
                                 ENU=E&ntries];
                      Image=Entries }
      { 105     ;3   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Varepos&ter;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Vis historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 38;
                      RunPageView=SORTING(Item No.)
                                  ORDER(Descending);
                      RunPageLink=Item No.=FIELD(No.);
                      PromotedIsBig=Yes;
                      Image=ItemLedger;
                      PromotedCategory=Category5 }
      { 112     ;3   ;Action    ;
                      CaptionML=[DAN=&Lageropgõrelsesposter;
                                 ENU=&Phys. Inventory Ledger Entries];
                      ToolTipML=[DAN=FÜ vist antallet af vareenheder pÜ lager ved seneste manuelle optëlling.;
                                 ENU=View how many units of the item you had in stock at the last physical count.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 390;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PhysicalInventoryLedger;
                      PromotedCategory=Category5 }
      { 75      ;3   ;Action    ;
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
      { 11      ;3   ;Action    ;
                      CaptionML=[DAN=&Lagerposter;
                                 ENU=&Warehouse Entries];
                      ToolTipML=[DAN="FÜ vist historikken over antal, der er registreret for varen under lageraktiviteter. ";
                                 ENU="View the history of quantities that are registered for the item in warehouse activities. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7318;
                      RunPageView=SORTING(Item No.,Bin Code,Location Code,Variant Code,Unit of Measure Code,Lot No.,Serial No.,Entry Type,Dedicated);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=BinLedger }
      { 237     ;3   ;Action    ;
                      CaptionML=[DAN=Udligningskladde;
                                 ENU=Application Worksheet];
                      ToolTipML=[DAN=Rediger vareudligninger, der er oprettet automatisk mellem vareposter under varetransaktioner. Brug specialfunktioner til at fortryde eller ëndre vareudligningsposter manuelt.;
                                 ENU=Edit item applications that are automatically created between item ledger entries during item transactions. Use special functions to manually undo or change item application entries.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 521;
                      RunPageLink=Item No.=FIELD(No.);
                      Image=ApplicationWorksheet }
      { 65      ;3   ;Action    ;
                      CaptionML=[DAN=EksportÇr varedata;
                                 ENU=Export Item Data];
                      ToolTipML=[DAN=Brug denne funktion til at eksportere varerelaterede data til en tekstfil (du kan vedhëfte denne fil til supportanmodninger, hvis du har problemer med omkostningsberegning).;
                                 ENU=Use this function to export item related data to text file (you can attach this file to support requests in case you may have issues with costing calculation).];
                      ApplicationArea=#Basic,#Suite;
                      Image=ExportFile;
                      OnAction=VAR
                                 Item@1001 : Record 27;
                                 ExportItemData@1000 : XMLport 5801;
                               BEGIN
                                 Item.SETRANGE("No.","No.");
                                 CLEAR(ExportItemData);
                                 ExportItemData.SETTABLEVIEW(Item);
                                 ExportItemData.RUN;
                               END;
                                }
      { 190     ;1   ;ActionGroup;
                      CaptionML=[DAN=Vare;
                                 ENU=Item] }
      { 184     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(27),
                                  No.=FIELD(No.);
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4 }
      { 161     ;2   ;Action    ;
                      CaptionML=[DAN=Varere&ferencer;
                                 ENU=Cross Re&ferences];
                      ToolTipML=[DAN=Angiv en debitors eller en kreditors egen identifikation af varen. Krydshenvisninger til debitorens varenummer betyder, at varenummeret automatisk vises i salgsbilag i stedet for det nummer, du anvender.;
                                 ENU=Set up a customer's or vendor's own identification of the item. Cross-references to the customer's item number means that the item number is automatically shown on sales documents instead of the number that you use.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5721;
                      RunPageLink=Item No.=FIELD(No.);
                      PromotedIsBig=Yes;
                      Image=Change;
                      PromotedCategory=Category4 }
      { 114     ;2   ;Action    ;
                      CaptionML=[DAN=En&heder;
                                 ENU=&Units of Measure];
                      ToolTipML=[DAN=Angiv de forskellige enheder, som en vare kan handles i, f.eks. styk, boks eller time.;
                                 ENU=Set up the different units that the item can be traded in, such as piece, box, or hour.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5404;
                      RunPageLink=Item No.=FIELD(No.);
                      PromotedIsBig=Yes;
                      Image=UnitOfMeasure;
                      PromotedCategory=Category4 }
      { 117     ;2   ;Action    ;
                      CaptionML=[DAN=&Udvidede tekster;
                                 ENU=E&xtended Texts];
                      ToolTipML=[DAN=Vëlg eller konfigurer supplerende tekst til beskrivelsen af varen. Den udvidede tekst kan indsëttes under feltet Beskrivelse i dokumentlinjerne for varen.;
                                 ENU=Select or set up additional text for the description of the item. Extended text can be inserted under the Description field on document lines for the item.];
                      ApplicationArea=#Suite;
                      RunObject=Page 391;
                      RunPageView=SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                      RunPageLink=Table Name=CONST(Item),
                                  No.=FIELD(No.);
                      PromotedIsBig=Yes;
                      Image=Text;
                      PromotedCategory=Category4 }
      { 116     ;2   ;Action    ;
                      CaptionML=[DAN=Varetekster;
                                 ENU=Translations];
                      ToolTipML=[DAN=Vis eller rediger oversatte varebeskrivelser. Oversatte varebeskrivelser indsëttes automatisk i dokumenter i overensstemmelse med sprogkoden.;
                                 ENU=View or edit translated item descriptions. Translated item descriptions are automatically inserted on documents according to the language code.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 35;
                      RunPageLink=Item No.=FIELD(No.);
                      PromotedIsBig=Yes;
                      Image=Translations;
                      PromotedCategory=Category4 }
      { 158     ;2   ;Action    ;
                      CaptionML=[DAN=Erstat&ninger;
                                 ENU=Substituti&ons];
                      ToolTipML=[DAN=FÜ vist erstatningsvarer, der er konfigureret til at blive solgt i stedet for varen.;
                                 ENU=View substitute items that are set up to be sold instead of the item.];
                      ApplicationArea=#Suite;
                      RunObject=Page 5716;
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(No.);
                      Image=ItemSubstitution }
      { 129     ;2   ;Action    ;
                      Name=ApprovalEntries;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Category8;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID);
                               END;
                                }
      { 147     ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 146     ;2   ;Action    ;
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
      { 144     ;2   ;Action    ;
                      Name=CRMSynchronizeNow;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Synkroniser;
                                 ENU=Synchronize];
                      ToolTipML=[DAN=Send de opdaterede data til Dynamics 365 for Sales.;
                                 ENU=Send updated data to Dynamics 365 for Sales.];
                      ApplicationArea=#Suite;
                      Image=Refresh;
                      OnAction=VAR
                                 CRMIntegrationManagement@1001 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.UpdateOneNow(RECORDID);
                               END;
                                }
      { 142     ;2   ;ActionGroup;
                      Name=Coupling;
                      CaptionML=[@@@=Coupling is a noun;
                                 DAN=Sammenkëdning;
                                 ENU=Coupling];
                      ToolTipML=[DAN=Opret, rediger eller slet en sammenkëdning mellem Microsoft Dynamics NAV-recorden og en Dynamics 365 for Sales-record.;
                                 ENU=Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.];
                      Image=LinkAccount }
      { 140     ;3   ;Action    ;
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
      { 138     ;3   ;Action    ;
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
      { 203     ;2   ;Action    ;
                      Name=ShowLog;
                      CaptionML=[DAN=Synkroniseringslog;
                                 ENU=Synchronization Log];
                      ToolTipML=[DAN=Vis integrationssynkroniseringsjobs for varetabellen.;
                                 ENU=View integration synchronization jobs for the item table.];
                      ApplicationArea=#Suite;
                      Image=Log;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowLog(RECORDID);
                               END;
                                }
      { 124     ;1   ;ActionGroup;
                      CaptionML=[DAN=Disponering;
                                 ENU=Availability];
                      Image=ItemAvailability }
      { 68      ;2   ;Action    ;
                      Name=ItemsByLocation;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Varer p&r. lokation;
                                 ENU=Items b&y Location];
                      ToolTipML=[DAN=Viser en liste over varer grupperet efter lokation.;
                                 ENU=Show a list of items grouped by location.];
                      ApplicationArea=#Advanced;
                      Image=ItemAvailbyLoc;
                      OnAction=BEGIN
                                 PAGE.RUN(PAGE::"Items by Location",Rec);
                               END;
                                }
      { 76      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Varedisponering pr.;
                                 ENU=&Item Availability by];
                      Image=ItemAvailability }
      { 3       ;3   ;Action    ;
                      Name=<Action110>;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilgëngelige saldo for en vare udvikles over tid i henhold til udbud og efterspõrgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 110     ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder, f.eks. dag, uge eller mÜned.;
                                 ENU=Show the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 157;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Filter),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Filter);
                      Image=Period }
      { 77      ;3   ;Action    ;
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
      { 69      ;3   ;Action    ;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      RunObject=Page 492;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Filter),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Filter);
                      Image=Warehouse }
      { 67      ;3   ;Action    ;
                      AccessByPermission=TableData 5870=R;
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
      { 74      ;3   ;Action    ;
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
      { 102     ;2   ;ActionGroup;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      Image=Statistics }
      { 107     ;3   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger sÜsom vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Statistics;
                      OnAction=VAR
                                 ItemStatistics@1001 : Page 5827;
                               BEGIN
                                 ItemStatistics.SetItem(Rec);
                                 ItemStatistics.RUNMODAL;
                               END;
                                }
      { 108     ;3   ;Action    ;
                      CaptionML=[DAN=Poststatistik;
                                 ENU=Entry Statistics];
                      ToolTipML=[DAN=Se statistik for vareposter.;
                                 ENU=View statistics for item ledger entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 304;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Filter),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Filter);
                      Image=EntryStatistics }
      { 111     ;3   ;Action    ;
                      CaptionML=[DAN=&Terminsoversigt;
                                 ENU=T&urnover];
                      ToolTipML=[DAN=Se en detaljeret oversigt over vareomsëtningen fordelt pÜ perioder, nÜr du har angivet de relevante filtre for lokation og variant.;
                                 ENU=View a detailed account of item turnover by periods after you have set the relevant filters for location and variant.];
                      ApplicationArea=#Suite;
                      RunObject=Page 158;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Filter),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Filter);
                      Image=Turnover }
      { 106     ;2   ;Action    ;
                      CaptionML=[DAN=Bem&ërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Item),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 84      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kõ&b;
                                 ENU=&Purchases];
                      Image=Purchasing }
      { 81      ;2   ;Action    ;
                      CaptionML=[DAN=&Kreditorer;
                                 ENU=Ven&dors];
                      ToolTipML=[DAN=Vis oversigten over kreditorer, der kan levere varen, samt gennemlõbstiden.;
                                 ENU=View the list of vendors who can supply the item, and at which lead time.];
                      ApplicationArea=#Planning;
                      RunObject=Page 114;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=Vendor }
      { 240     ;2   ;Action    ;
                      CaptionML=[DAN=Forudb&etalingsprocenter;
                                 ENU=Prepa&yment Percentages];
                      ToolTipML=[DAN="Vis eller rediger de procentdele af prisen, der kan betales som forudbetaling. ";
                                 ENU="View or edit the percentages of the price that can be paid as a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 665;
                      RunPageLink=Item No.=FIELD(No.);
                      Image=PrepaymentPercentages }
      { 87      ;2   ;Action    ;
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
      { 191     ;2   ;Action    ;
                      CaptionML=[DAN=Returvareordrer;
                                 ENU=Return Orders];
                      ToolTipML=[DAN=èbn listen over igangvërende returordrer for varen.;
                                 ENU=Open the list of ongoing return orders for the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6643;
                      RunPageView=SORTING(Document Type,Type,No.);
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(No.);
                      Image=ReturnOrder }
      { 42      ;1   ;ActionGroup;
                      Name=PurchPricesandDiscounts;
                      CaptionML=[DAN=Specialkõbspriser og -rabatter;
                                 ENU=Special Purchase Prices & Discounts] }
      { 86      ;2   ;Action    ;
                      CaptionML=[DAN=Angiv specialpriser;
                                 ENU=Set Special Prices];
                      ToolTipML=[DAN=Angiv forskellige priser for varen. En varepris anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er opfyldt, f.eks. kreditor, antal eller slutdato.;
                                 ENU=Set up different prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Suite;
                      RunObject=Page 7012;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=Price }
      { 85      ;2   ;Action    ;
                      CaptionML=[DAN=Angiv specialrabatter;
                                 ENU=Set Special Discounts];
                      ToolTipML=[DAN=Angiv forskellige rabatter for varen. En varerabat anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. kreditor, mëngde eller slutdato.;
                                 ENU=Set up different discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Suite;
                      RunObject=Page 7014;
                      RunPageLink=Item No.=FIELD(No.);
                      Image=LineDiscount }
      { 209     ;2   ;Action    ;
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
      { 79      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Salg;
                                 ENU=S&ales];
                      Image=Sales }
      { 300     ;2   ;Action    ;
                      CaptionML=[DAN=Forudb&etalingsprocenter;
                                 ENU=Prepa&yment Percentages];
                      ToolTipML=[DAN="Vis eller rediger de procentdele af prisen, der kan betales som forudbetaling. ";
                                 ENU="View or edit the percentages of the price that can be paid as a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 664;
                      RunPageLink=Item No.=FIELD(No.);
                      Image=PrepaymentPercentages }
      { 83      ;2   ;Action    ;
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
      { 163     ;2   ;Action    ;
                      CaptionML=[DAN=Returvareordrer;
                                 ENU=Return Orders];
                      ToolTipML=[DAN=èbn listen over igangvërende returordrer for varen.;
                                 ENU=Open the list of ongoing return orders for the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6633;
                      RunPageView=SORTING(Document Type,Type,No.);
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(No.);
                      Image=ReturnOrder }
      { 128     ;1   ;ActionGroup;
                      CaptionML=[DAN=Stykliste;
                                 ENU=Bill of Materials];
                      Image=Production }
      { 121     ;2   ;Action    ;
                      Name=BOMStructure;
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
      { 104     ;2   ;Action    ;
                      CaptionML=[DAN=Kostprisfordelinger;
                                 ENU=Cost Shares];
                      ToolTipML=[DAN=FÜ vist, hvordan omkostningerne til underliggende varer pÜ styklisten akkumuleres til den overordnede vare. Oplysningerne arrangeres ifõlge styklistens struktur for at afspejle de niveauer, som de enkelte omkostninger angÜr. Hvert vareniveau kan skjules eller vises for at fÜ et overblik eller en detaljeret visning.;
                                 ENU=View how the costs of underlying items in the BOM roll up to the parent item. The information is organized according to the BOM structure to reflect at which levels the individual costs apply. Each item level can be collapsed or expanded to obtain an overview or detailed view.];
                      ApplicationArea=#Assembly;
                      Image=CostBudget;
                      OnAction=VAR
                                 BOMCostShares@1000 : Page 5872;
                               BEGIN
                                 BOMCostShares.InitItem(Rec);
                                 BOMCostShares.RUN;
                               END;
                                }
      { 100     ;2   ;ActionGroup;
                      CaptionML=[DAN=&Montage;
                                 ENU=Assemb&ly];
                      Image=AssemblyBOM }
      { 98      ;3   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=Montagestykliste;
                                 ENU=Assembly BOM];
                      ToolTipML=[DAN=FÜ vist eller rediger den stykliste, der angiver, hvilke varer og ressourcer der krëves for at samle montageelementet.;
                                 ENU=View or edit the bill of material that specifies which items and resources are required to assemble the assembly item.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 36;
                      RunPageLink=Parent Item No.=FIELD(No.);
                      Image=BOM }
      { 96      ;3   ;Action    ;
                      AccessByPermission=TableData 90=R;
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
      { 94      ;3   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=&Beregn kostpris;
                                 ENU=Calc. Stan&dard Cost];
                      ToolTipML=[DAN=Beregn kostprisen for varen ved at akkumulere kostprisen for hver komponent og ressource pÜ varens montagestykliste eller produktionsstykliste. Kostprisen for en overordnet vare skal altid svare til den samlede kostpris for komponenter, halvfabrikata og andre ressourcer.;
                                 ENU=Calculate the unit cost of the item by rolling up the unit cost of each component and resource in the item's assembly BOM or production BOM. The unit cost of a parent item must always equals the total of the unit costs of its components, subassemblies, and any resources.];
                      ApplicationArea=#Assembly;
                      Image=CalculateCost;
                      OnAction=BEGIN
                                 CLEAR(CalculateStdCost);
                                 CalculateStdCost.CalcItem("No.",TRUE);
                               END;
                                }
      { 90      ;3   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=Beregn enhedspris;
                                 ENU=Calc. Unit Price];
                      ToolTipML=[DAN=Beregn enhedsprisen ud fra kostprisen og avanceprocenten.;
                                 ENU=Calculate the unit price based on the unit cost and the profit percentage.];
                      ApplicationArea=#Assembly;
                      Image=SuggestItemPrice;
                      OnAction=BEGIN
                                 CLEAR(CalculateStdCost);
                                 CalculateStdCost.CalcAssemblyItemPrice("No.")
                               END;
                                }
      { 89      ;2   ;ActionGroup;
                      CaptionML=[DAN=Produktion;
                                 ENU=Production];
                      Image=Production }
      { 88      ;3   ;Action    ;
                      CaptionML=[DAN=Produktionsstykliste;
                                 ENU=Production BOM];
                      ToolTipML=[DAN=èbn varens produktionsstykliste for at vise eller redigere dens komponenter.;
                                 ENU=Open the item's production bill of material to view or edit its components.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000786;
                      RunPageLink=No.=FIELD(Production BOM No.);
                      Image=BOM }
      { 78      ;3   ;Action    ;
                      AccessByPermission=TableData 99000771=R;
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
      { 5       ;3   ;Action    ;
                      AccessByPermission=TableData 99000771=R;
                      CaptionML=[DAN=&Beregn kostpris;
                                 ENU=Calc. Stan&dard Cost];
                      ToolTipML=[DAN=Beregn kostprisen for varen ved at akkumulere kostprisen for hver komponent og ressource pÜ varens montagestykliste eller produktionsstykliste. Kostprisen for en overordnet vare skal altid svare til den samlede kostpris for komponenter, halvfabrikata og andre ressourcer.;
                                 ENU=Calculate the unit cost of the item by rolling up the unit cost of each component and resource in the item's assembly BOM or production BOM. The unit cost of a parent item must always equals the total of the unit costs of its components, subassemblies, and any resources.];
                      ApplicationArea=#Advanced;
                      Image=CalculateCost;
                      OnAction=BEGIN
                                 CLEAR(CalculateStdCost);
                                 CalculateStdCost.CalcItem("No.",FALSE);
                               END;
                                }
      { 103     ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 212     ;2   ;Action    ;
                      CaptionML=[DAN=Placeringsi&ndhold;
                                 ENU=&Bin Contents];
                      ToolTipML=[DAN=FÜ vist varens antal pÜ alle relevante placeringer. Du kan se alle vigtige parametre i relation til placeringsindholdet, og du kan redigere bestemte parametre for placeringsindholdet i dette vindue.;
                                 ENU=View the quantities of the item in each bin where it exists. You can see all the important parameters relating to bin content, and you can modify certain bin content parameters in this window.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7379;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=BinContent }
      { 157     ;2   ;Action    ;
                      CaptionML=[DAN=La&gervare (pr. lokation);
                                 ENU=Stockkeepin&g Units];
                      ToolTipML=[DAN="èbn lagervarer for varen for at vise eller redigere forekomster af varen pÜ forskellige lokationer eller med forskellige varianter. ";
                                 ENU="Open the item's SKUs to view or edit instances of the item at different locations or with different variants. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5701;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=SKU }
      { 122     ;1   ;ActionGroup;
                      CaptionML=[DAN=Service;
                                 ENU=Service];
                      Image=ServiceItem }
      { 183     ;2   ;Action    ;
                      CaptionML=[DAN=Servi&ceartikler;
                                 ENU=Ser&vice Items];
                      ToolTipML=[DAN="Vis forekomster af varen som serviceartikler, f.eks. maskiner som du vedligeholder eller reparerer for debitorer via serviceordrer. ";
                                 ENU="View instances of the item as service items, such as machines that you maintain or repair for customers through service orders. "];
                      ApplicationArea=#Service;
                      RunObject=Page 5988;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(No.);
                      Image=ServiceItem }
      { 17      ;2   ;Action    ;
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
      { 185     ;2   ;Action    ;
                      CaptionML=[DAN=Opsëtning af fejlfinding;
                                 ENU=Troubleshooting Setup];
                      ToolTipML=[DAN=Vis eller rediger indstillingerne for fejlfinding til serviceartikler.;
                                 ENU=View or edit your settings for troubleshooting service items.];
                      ApplicationArea=#Service;
                      RunObject=Page 5993;
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(No.);
                      Image=Troubleshoot }
      { 127     ;1   ;ActionGroup;
                      CaptionML=[DAN=Ressourcer;
                                 ENU=Resources];
                      Image=Resource }
      { 187     ;2   ;Action    ;
                      CaptionML=[DAN=Ressourcekvalifikationer;
                                 ENU=Resource Skills];
                      ToolTipML=[DAN=Vis tildelingen af kvalifikationer til ressourcer, varer, serviceartikelgrupper og serviceartikler. Du kan bruge kvalifikationskoderne til at allokere kvalificerede ressourcer til serviceartikler eller varer, hvor der ved reparation krëves specialviden.;
                                 ENU=View the assignment of skills to resources, items, service item groups, and service items. You can use skill codes to allocate skilled resources to service items or items that need special skills for servicing.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6019;
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(No.);
                      Image=ResourceSkills }
      { 188     ;2   ;Action    ;
                      AccessByPermission=TableData 5900=R;
                      CaptionML=[DAN=Kval. ressourcer;
                                 ENU=Skilled Resources];
                      ToolTipML=[DAN=Vis en liste over alle registrerede ressourcer med oplysninger om, hvorvidt de har de nõdvendige kvalifikationer til at reparere den aktuelle serviceartikelgruppe, vare eller serviceartikel.;
                                 ENU=View a list of all registered resources with information about whether they have the skills required to service the particular service item group, item, or service item.];
                      ApplicationArea=#Advanced;
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
                Name=Item;
                CaptionML=[DAN=Vare;
                           ENU=Item];
                GroupType=Group }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Importance=Additional;
                Visible=NoFieldVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen.;
                           ENU=Specifies a description of the item.];
                ApplicationArea=#All;
                SourceExpr=Description;
                ShowMandatory=TRUE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogfõres under transaktioner - eksempelvis en debitor, som er erklëret insolvent, eller en vare, som er sat i karantëne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Blocked }

    { 166 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varekortet reprësenterer en fysisk vare (Lagerbeholdning) eller en service (Service).;
                           ENU=Specifies if the item card represents a physical item (Inventory) or a service (Service).];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type;
                OnValidate=BEGIN
                             EnableControls;
                           END;
                            }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den basisenhed, der bruges til at mÜle varen, som f.eks. stk., kasse eller palle. BasismÜleenheden fungerer ogsÜ som konverteringsbasis for alternative mÜleenheder.;
                           ENU=Specifies the base unit used to measure the item, such as piece, box, or pallet. The base unit of measure also serves as the conversion basis for alternate units of measure.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Base Unit of Measure";
                Importance=Promoted;
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE);
                             GET("No.");
                           END;

                ShowMandatory=TRUE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr varekortet sidst blev ëndret.;
                           ENU=Specifies when the item card was last modified.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Date Modified";
                Importance=Additional }

    { 135 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver GTIN-nummeret (Global Trade Item Number) for varen. GTIN anvendes f.eks. med stregkoder til at spore varer og ved elektronisk afsendelse og modtagelse af bilag. GTIN-nummeret indeholder typisk en UPC-kode (Universal Product Code) eller et EAN-nummer (European Article Number).;
                           ENU=Specifies the Global Trade Item Number (GTIN) for the item. For example, the GTIN is used with bar codes to track items, and when sending and receiving documents electronically. The GTIN number typically contains a Universal Product Code (UPC), or European Article Number (EAN).];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GTIN;
                Importance=Additional;
                Enabled=InventoryItemEditable }

    { 170 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kategori, varen hõrer til. Varekategorier omfatter ogsÜ vareattributter, der mÜtte vëre tildelt.;
                           ENU=Specifies the category that the item belongs to. Item categories also contain any assigned item attributes.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Category Code";
                OnValidate=BEGIN
                             CurrPage.ItemAttributesFactbox.PAGE.LoadItemAttributesData("No.");
                             EnableCostingControls;
                           END;
                            }

    { 168 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en produktgruppekode, der er tilknyttet varekategorien.;
                           ENU=Specifies a product group code associated with the item category.];
                ApplicationArea=#Advanced;
                SourceExpr="Product Group Code";
                Visible=FALSE }

    { 180 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den serviceartikelgruppe, som varen tilhõrer.;
                           ENU=Specifies the code of the service item group that the item belongs to.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Group";
                Importance=Additional }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der automatisk tilfõjes udvidet tekst, som du har angivet, pÜ salgs- eller kõbsdokumenter for denne vare.;
                           ENU=Specifies that an extended text that you have set up will be added automatically on sales or purchase documents for this item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Automatic Ext. Texts";
                Importance=Additional }

    { 171 ;1   ;Group     ;
                Name=InventoryGrp;
                CaptionML=[DAN=Lager;
                           ENU=Inventory];
                Visible=NOT IsService;
                GroupType=Group }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor varen findes pÜ lageret. Dette er kun orienterende.;
                           ENU=Specifies where to find the item in the warehouse. This is informational only.];
                ApplicationArea=#Advanced;
                SourceExpr="Shelf No." }

    { 164 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen blev oprettet ud fra en katalogvare.;
                           ENU=Specifies that the item was created from a nonstock item.];
                ApplicationArea=#Advanced;
                SourceExpr="Created From Nonstock Item";
                Importance=Additional }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en sõgebeskrivelse, som du kan bruge til at finde varen pÜ lister.;
                           ENU=Specifies a search description that you use to find the item in lists.];
                ApplicationArea=#Advanced;
                SourceExpr="Search Description";
                Importance=Additional }

    { 14  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen, f.eks. stk., ësker eller dÜser, der er pÜ lager.;
                           ENU=Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Inventory;
                Importance=Promoted;
                Visible=IsFoundationEnabled;
                Enabled=InventoryItemEditable;
                HideValue=IsService;
                OnAssistEdit=VAR
                               AdjustInventory@1000 : Page 1327;
                             BEGIN
                               MODIFY(TRUE);
                               COMMIT;

                               AdjustInventory.SetItem("No.");
                               IF AdjustInventory.RUNMODAL IN [ACTION::LookupOK,ACTION::OK] THEN
                                 GET("No.");
                               CurrPage.UPDATE
                             END;
                              }

    { 205 ;2   ;Field     ;
                Name=InventoryNonFoundation;
                DrillDown=No;
                AssistEdit=No;
                CaptionML=[DAN=Lagerbeholdning;
                           ENU=Inventory];
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen, f.eks. stk., ësker eller dÜser, som er pÜ lager.;
                           ENU=Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Inventory;
                Importance=Promoted;
                Visible=NOT IsFoundationEnabled;
                Enabled=InventoryItemEditable }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der er indgÜende pÜ kõbsordrer, hvilket betyder opfõrt pÜ udestÜende kõbsordrelinjer.;
                           ENU=Specifies how many units of the item are inbound on purchase orders, meaning listed on outstanding purchase order lines.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. on Purch. Order" }

    { 172 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der er allokeret til produktionsordrer, hvilket betyder opfõrt pÜ udestÜende produktionsordrelinjer.;
                           ENU=Specifies how many units of the item are allocated to production orders, meaning listed on outstanding production order lines.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Qty. on Prod. Order" }

    { 174 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der er allokeret som produktionsordrekomponenter, hvilket betyder opfõrt under udestÜende produktionsordrelinjer.;
                           ENU=Specifies how many units of the item are allocated as production order components, meaning listed under outstanding production order lines.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. on Component Lines" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der er allokeret til salgsordrer, hvilket betyder, at de er opfõrt pÜ udestÜende salgsordrelinjer.;
                           ENU=Specifies how many units of the item are allocated to sales orders, meaning listed on outstanding sales orders lines.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. on Sales Order" }

    { 189 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der er allokeret til serviceordrer, hvilket betyder opfõrt pÜ udestÜende serviceordrelinjer.;
                           ENU=Specifies how many units of the item are allocated to service orders, meaning listed on outstanding service order lines.];
                ApplicationArea=#Service;
                SourceExpr="Qty. on Service Order";
                Importance=Additional }

    { 152 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der er allokeret til sager, dvs. er anfõrt pÜ udestÜende sagsplanlëgningslinjer.;
                           ENU=Specifies how many units of the item are allocated to jobs, meaning listed on outstanding job planning lines.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. on Job Order";
                Importance=Additional }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af lageren der er allokeret til montageordrer, dvs. hvor mange der er anfõrt pÜ udestÜende montageordrehoveder.;
                           ENU=Specifies how many units of the item are allocated to assembly orders, which is how many are listed on outstanding assembly order headers.];
                ApplicationArea=#Assembly;
                SourceExpr="Qty. on Assembly Order";
                Importance=Additional }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange vareenheder der i alt er tildelt som montagekomponenter, hvilket betyder, hvor mange der er opfõrt pÜ udestÜende montageordrelinjer.;
                           ENU=Specifies how many units of the item are allocated as assembly components, which means how many are listed on outstanding assembly order lines.];
                ApplicationArea=#Assembly;
                SourceExpr="Qty. on Asm. Component";
                Importance=Additional }

    { 113 ;2   ;Field     ;
                Name=StockoutWarningDefaultYes;
                CaptionML=[DAN=Beholdningsadvarsel;
                           ENU=Stockout Warning];
                ToolTipML=[DAN=Angiver, om en advarsel skal vises, nÜr du angiver et antal i et salgsbilag, der bringer varens lager under nul.;
                           ENU=Specifies if a warning is displayed when you enter a quantity on a sales document that brings the item's inventory below zero.];
                OptionCaptionML=[DAN=Standard (Ja),Nej,Ja;
                                 ENU=Default (Yes),No,Yes];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Stockout Warning";
                Visible=ShowStockoutWarningDefaultYes;
                Editable=Type <> Type::Service }

    { 115 ;2   ;Field     ;
                Name=StockoutWarningDefaultNo;
                CaptionML=[DAN=Beholdningsadvarsel;
                           ENU=Stockout Warning];
                ToolTipML=[DAN=Angiver, om en advarsel skal vises, nÜr du angiver et antal i et salgsbilag, der bringer varens lager under nul.;
                           ENU=Specifies if a warning is displayed when you enter a quantity on a sales document that brings the item's inventory below zero.];
                OptionCaptionML=[DAN=Standard (nej),Nej,Ja;
                                 ENU=Default (No),No,Yes];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Stockout Warning";
                Visible=ShowStockoutWarningDefaultNo }

    { 120 ;2   ;Field     ;
                Name=PreventNegInventoryDefaultYes;
                CaptionML=[DAN=Forebyg negativt lager;
                           ENU=Prevent Negative Inventory];
                ToolTipML=[DAN=Angiver, om du kan bogfõre en transaktion, der vil bringe varens lager under nul.;
                           ENU=Specifies if you can post a transaction that will bring the item's inventory below zero.];
                OptionCaptionML=[DAN=Standard (Ja),Nej,Ja;
                                 ENU=Default (Yes),No,Yes];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Prevent Negative Inventory";
                Importance=Additional;
                Visible=ShowPreventNegInventoryDefaultYes }

    { 130 ;2   ;Field     ;
                Name=PreventNegInventoryDefaultNo;
                CaptionML=[DAN=Forebyg negativt lager;
                           ENU=Prevent Negative Inventory];
                ToolTipML=[DAN=Angiver, om du kan bogfõre en transaktion, der vil bringe varens lager under nul.;
                           ENU=Specifies if you can post a transaction that will bring the item's inventory below zero.];
                OptionCaptionML=[DAN=Standard (nej),Nej,Ja;
                                 ENU=Default (No),No,Yes];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Prevent Negative Inventory";
                Importance=Additional;
                Visible=ShowPreventNegInventoryDefaultNo }

    { 196 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens nettovëgt.;
                           ENU=Specifies the net weight of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Net Weight";
                Importance=Additional }

    { 235 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens bruttovëgt.;
                           ENU=Specifies the gross weight of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gross Weight";
                Importance=Additional }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver volumen pÜ Çn enhed af varen.;
                           ENU=Specifies the volume of one unit of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Volume" }

    { 169 ;1   ;Group     ;
                Name=Costs & Posting;
                CaptionML=[DAN=Omkostninger og bogfõring;
                           ENU=Costs & Posting];
                GroupType=Group }

    { 167 ;2   ;Group     ;
                Name=Cost Details;
                CaptionML=[DAN=Omkostningsdetaljer;
                           ENU=Cost Details];
                GroupType=Group }

    { 24  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan varens kostprisforlõb registreres, og om en faktisk eller budgetteret vërdi fõres som aktiv og bruges i beregningen af kostprisen.;
                           ENU=Specifies how the item's cost flow is recorded and whether an actual or budgeted value is capitalized and used in the cost calculation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Costing Method";
                OnValidate=BEGIN
                             EnableCostingControls;
                           END;
                            }

    { 28  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den kostpris, der anvendes som et overslag, hvor afvigelser kan justeres pÜ et senere tidspunkt. Dette anvendes typisk ved montage og produktion, hvor omkostningerne varierer.;
                           ENU=Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Standard Cost";
                Enabled=StandardCostEnable;
                OnDrillDown=VAR
                              ShowAvgCalcItem@1000 : Codeunit 5803;
                            BEGIN
                              ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Rec)
                            END;
                             }

    { 30  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Cost";
                Importance=Promoted;
                Enabled=UnitCostEnable;
                Editable=UnitCostEditable;
                OnDrillDown=VAR
                              ShowAvgCalcItem@1000 : Codeunit 5803;
                            BEGIN
                              ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Rec)
                            END;
                             }

    { 155 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste kõbspris, der omfatter indirekte omkostninger, sÜsom fragt, der er knyttet til kõbet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Indirect Cost %";
                Importance=Additional }

    { 32  ;3   ;Field     ;
                CaptionML=[DAN=Sidste kõbspris;
                           ENU=Last Purchase Cost];
                ToolTipML=[DAN=Angiver den seneste kõbspris for varen.;
                           ENU=Specifies the most recent direct unit cost of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Direct Cost";
                Importance=Additional }

    { 207 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange af vareenhederne pÜ lageret der er faktureret.;
                           ENU=Specifies how many units of the item in inventory have been invoiced.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Net Invoiced Qty." }

    { 238 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om varens pris er reguleret enten automatisk eller manuelt.;
                           ENU=Specifies whether the item's unit cost has been adjusted, either automatically or manually.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost is Adjusted" }

    { 26  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, at alle lagerreguleringer for denne vare er blevet bogfõrt i finansregnskabet.;
                           ENU=Specifies that all the inventory costs for this item have been posted to the general ledger.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost is Posted to G/L";
                Importance=Additional }

    { 211 ;3   ;Field     ;
                CaptionML=[DAN=Specialkõbspriser og -rabatter;
                           ENU=Special Purch. Prices & Discounts];
                ToolTipML=[DAN=Angiver specialkõbspriser og linjerabatter for varen.;
                           ENU=Specifies special purchase prices and line discounts for the item.];
                ApplicationArea=#Suite;
                SourceExpr=SpecialPurchPricesAndDiscountsTxt;
                Editable=FALSE;
                OnDrillDown=VAR
                              PurchasePrice@1001 : Record 7012;
                              PurchaseLineDiscount@1002 : Record 7014;
                              PurchasesPriceAndLineDisc@1000 : Page 1346;
                            BEGIN
                              IF SpecialPurchPricesAndDiscountsTxt = ViewExistingTxt THEN BEGIN
                                PurchasesPriceAndLineDisc.LoadItem(Rec);
                                PurchasesPriceAndLineDisc.RUNMODAL;
                                EXIT;
                              END;

                              CASE STRMENU(STRSUBSTNO('%1,%2',CreateNewSpecialPriceTxt,CreateNewSpecialDiscountTxt),1,'') OF
                                1:
                                  BEGIN
                                    PurchasePrice.SETRANGE("Item No.","No.");
                                    PAGE.RUNMODAL(PAGE::"Purchase Prices",PurchasePrice);
                                  END;
                                2:
                                  BEGIN
                                    PurchaseLineDiscount.SETRANGE("Item No.","No.");
                                    PAGE.RUNMODAL(PAGE::"Purchase Line Discounts",PurchaseLineDiscount);
                                  END;
                              END;

                              UpdateSpecialPricesAndDiscountsTxt;
                            END;
                             }

    { 176 ;2   ;Group     ;
                Name=Posting Details;
                CaptionML=[DAN=Bogfõringsoplysninger;
                           ENU=Posting Details];
                GroupType=Group }

    { 95  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Prod. Posting Group";
                Importance=Promoted;
                ShowMandatory=TRUE }

    { 66  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group";
                Importance=Additional;
                ShowMandatory=TRUE }

    { 40  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver links mellem forretningstransaktioner, som er lavet til varen, og en lagerkonto i finansposterne for at samle belõbene for denne varetype i en gruppe.;
                           ENU=Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inventory Posting Group";
                Importance=Promoted;
                Editable=InventoryItemEditable;
                ShowMandatory=InventoryItemEditable }

    { 136 ;3   ;Field     ;
                CaptionML=[DAN=Standardperiodiseringsskabelon;
                           ENU=Default Deferral Template];
                ToolTipML=[DAN=Angiver, hvordan indtëgter eller udgifter for varen som standard periodiseres til andre regnskabsperioder.;
                           ENU=Specifies how revenue or expenses for the item are deferred to other accounting periods by default.];
                ApplicationArea=#Suite;
                SourceExpr="Default Deferral Template Code" }

    { 177 ;2   ;Group     ;
                Name=ForeignTrade;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade];
                GroupType=Group }

    { 62  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for varens brugstarifnummer.;
                           ENU=Specifies a code for the item's tariff number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Tariff No." }

    { 93  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for det land/omrÜde, hvor varen er fremstillet eller behandlet.;
                           ENU=Specifies a code for the country/region where the item was produced or processed.];
                ApplicationArea=#Advanced;
                SourceExpr="Country/Region of Origin Code";
                Importance=Additional }

    { 1905885101;1;Group  ;
                Name=Prices & Sales;
                CaptionML=[DAN=Priser og salg;
                           ENU=Prices & Sales];
                GroupType=Group }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for Çn enhed af varen eller ressourcen. Du kan angive en pris manuelt eller fÜ den angivet i henhold til feltet Avancepct.beregning pÜ det dertilhõrende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Unit Price";
                Importance=Promoted;
                Editable=PriceEditable }

    { 173 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhedsprisen ekskl. moms.;
                           ENU=Specifies the unit price excluding VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CalcUnitPriceExclVAT;
                CaptionClass='2,0,' + FIELDCAPTION("Unit Price");
                Importance=Additional }

    { 175 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ salgsdokumentlinjer for denne vare skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on sales document lines for this item should be shown with or without VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Price Includes VAT";
                Importance=Additional;
                OnValidate=BEGIN
                             IF "Price Includes VAT" = xRec."Price Includes VAT" THEN
                               EXIT;
                           END;
                            }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver relationen mellem felterne Kostpris, Enhedspris og Avancepct. for denne vare.;
                           ENU=Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Price/Profit Calculation";
                Importance=Additional;
                OnValidate=BEGIN
                             EnableControls;
                           END;
                            }

    { 181 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dëkningsgrad, du vil sëlge varen med. Du kan angive en avanceprocent manuelt eller fÜ den angivet i henhold til feltet Avancepct.beregning;
                           ENU=Specifies the profit margin that you want to sell the item at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=2:2;
                SourceExpr="Profit %";
                Editable=ProfitEditable }

    { 36  ;2   ;Field     ;
                CaptionML=[DAN=Specialsalgspriser og -rabatter;
                           ENU=Special Sales Prices & Discounts];
                ToolTipML=[DAN=Angiver sërlige priser og linjerabatter for varen.;
                           ENU=Specifies special prices and line discounts for the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SpecialPricesAndDiscountsTxt;
                Editable=FALSE;
                OnDrillDown=VAR
                              SalesPrice@1001 : Record 7002;
                              SalesLineDiscount@1002 : Record 7004;
                              SalesPriceAndLineDiscounts@1000 : Page 1345;
                            BEGIN
                              IF SpecialPricesAndDiscountsTxt = ViewExistingTxt THEN BEGIN
                                SalesPriceAndLineDiscounts.InitPage(TRUE);
                                SalesPriceAndLineDiscounts.LoadItem(Rec);
                                SalesPriceAndLineDiscounts.RUNMODAL;
                                EXIT;
                              END;

                              CASE STRMENU(STRSUBSTNO('%1,%2',CreateNewSpecialPriceTxt,CreateNewSpecialDiscountTxt),1,'') OF
                                1:
                                  BEGIN
                                    SalesPrice.SETRANGE("Item No.","No.");
                                    PAGE.RUNMODAL(PAGE::"Sales Prices",SalesPrice);
                                  END;
                                2:
                                  BEGIN
                                    SalesLineDiscount.SETRANGE(Type,SalesLineDiscount.Type::Item);
                                    SalesLineDiscount.SETRANGE(Code,"No.");
                                    PAGE.RUNMODAL(PAGE::"Sales Line Discounts",SalesLineDiscount);
                                  END;
                              END;

                              UpdateSpecialPricesAndDiscountsTxt;
                            END;
                             }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varen skal indgÜ i beregningen af en fakturarabat pÜ dokumenter, hvor varen handles.;
                           ENU=Specifies if the item should be included in the calculation of an invoice discount on documents where the item is traded.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow Invoice Disc.";
                Importance=Additional }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en varegruppekode, der kan bruges som kriterie til at tildele en rabat, nÜr varen sëlges til en bestemt debitor.;
                           ENU=Specifies an item group code that can be used as a criterion to grant a discount when the item is sold to a certain customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Disc. Group";
                Importance=Additional }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den enhedskode, der skal bruges, nÜr du sëlger varen.;
                           ENU=Specifies the unit of measure code used when you sell the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Unit of Measure" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id for en bruger, der arbejder i vinduet Udligningskladde.;
                           ENU=Specifies the ID of a user who is working in the Application Worksheet window.];
                ApplicationArea=#Advanced;
                SourceExpr="Application Wksh. User ID";
                Importance=Additional;
                Visible=FALSE }

    { 151 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsvirksomhedsbogfõringsgruppen for debitorer, som salgsprisen (inklusive moms) skal anvendes pÜ.;
                           ENU=Specifies the VAT business posting group for customers for whom you want the sales price including VAT to apply.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Gr. (Price)" }

    { 1904731401;1;Group  ;
                CaptionML=[DAN=Genbestilling;
                           ENU=Replenishment] }

    { 133 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type forsyningsordre der oprettes af planlëgningssystemet, nÜr varen skal genbestilles.;
                           ENU=Specifies the type of supply order created by the planning system when the item needs to be replenished.];
                ApplicationArea=#Assembly;
                SourceExpr="Replenishment System";
                Importance=Promoted }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en datoformel for det tidsrum, det tager at genbestille varen.;
                           ENU=Specifies a date formula for the amount of time it takes to replenish the item.];
                ApplicationArea=#Assembly;
                SourceExpr="Lead Time Calculation" }

    { 229 ;2   ;Group     ;
                CaptionML=[DAN=Kõb;
                           ENU=Purchase] }

    { 50  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den kreditor, der leverer denne vare som standard.;
                           ENU=Specifies the vendor code of who supplies this item by default.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor No." }

    { 52  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som varen har hos kreditoren.;
                           ENU=Specifies the number that the vendor uses for this item.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Item No." }

    { 99  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den enhedskode, der bruges, nÜr du kõber varen.;
                           ENU=Specifies the unit of measure code used when you purchase the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Purch. Unit of Measure" }

    { 230 ;2   ;Group     ;
                CaptionML=[DAN=Produktion;
                           ENU=Production] }

    { 227 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om der skal foretages beregninger af yderligere ordrer for tilknyttede komponenter.;
                           ENU=Specifies if additional orders for any related components are calculated.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Manufacturing Policy" }

    { 137 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den produktionsrute, som varen bruges i.;
                           ENU=Specifies the number of the production routing that the item is used in.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing No." }

    { 139 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den produktionsstykliste, som varen reprësenterer.;
                           ENU=Specifies the number of the production BOM that the item represents.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Production BOM No." }

    { 141 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan beregnede forbrugsmëngder skal afrundes, nÜr de indtastes pÜ forbrugskladdelinjer.;
                           ENU=Specifies how calculated consumption quantities are rounded when entered on consumption journal lines.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Rounding Precision" }

    { 143 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan forbruget af varen (komponenten) beregnes og hÜndteres i produktionsprocesserne. Manuelt: Angiv og bogfõr forbrug i forbrugskladden manuelt. Fremad: Bogfõrer automatisk forbrug ifõlge produktionsordrekomponentlinjerne, nÜr den fõrste handling starter. Baglëns: Beregner og bogfõrer automatisk forbrug ifõlge produktionsordrekomponentlinjerne, nÜr produktionsordren er fërdig. Pluk + Fremad / Pluk + Baglëns: Variationer med lagersted.;
                           ENU=Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.];
                ApplicationArea=#Advanced;
                SourceExpr="Flushing Method" }

    { 153 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver varens indirekte omkostning som et absolut belõb.;
                           ENU=Specifies the item's indirect cost as an absolute amount.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Overhead Rate";
                Importance=Additional }

    { 118 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af varen, du forventer gÜr til spilde i produktionsprocessen.;
                           ENU=Specifies the percentage of the item that you expect to be scrapped in the production process.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap %" }

    { 145 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen, der som standard behandles i Çn produktionsoperation.;
                           ENU=Specifies how many units of the item are processed in one production operation by default.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Lot Size" }

    { 13  ;2   ;Group     ;
                CaptionML=[DAN=Montage;
                           ENU=Assembly];
                GroupType=Group }

    { 15  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken standardordrestrõm, der bruges til at levere dette montageelement.;
                           ENU=Specifies which default order flow is used to supply this assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr="Assembly Policy" }

    { 8   ;3   ;Field     ;
                AccessByPermission=TableData 90=R;
                ToolTipML=[DAN=Angiver, om varen er en montagestykliste.;
                           ENU=Specifies if the item is an assembly BOM.];
                ApplicationArea=#Assembly;
                SourceExpr="Assembly BOM";
                OnDrillDown=VAR
                              BOMComponent@1000 : Record 90;
                            BEGIN
                              COMMIT;
                              BOMComponent.SETRANGE("Parent Item No.","No.");
                              PAGE.RUN(PAGE::"Assembly BOM",BOMComponent);
                              CurrPage.UPDATE;
                            END;
                             }

    { 1901343701;1;Group  ;
                CaptionML=[DAN=Planlëgning;
                           ENU=Planning] }

    { 125 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver genbestilllingsmetoden.;
                           ENU=Specifies the reordering policy.];
                ApplicationArea=#Advanced;
                SourceExpr="Reordering Policy";
                Importance=Promoted;
                OnValidate=BEGIN
                             EnablePlanningControls
                           END;
                            }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varen skal kunne reserveres.;
                           ENU=Specifies whether the program will allow reservations to be made for this item.];
                ApplicationArea=#Advanced;
                SourceExpr=Reserve;
                Importance=Additional }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvis og hvordan ordresporingsposter oprettes og vedligeholdes mellem udbud og den tilsvarende efterspõrgsel.;
                           ENU=Specifies if and how order tracking entries are created and maintained between supply and its corresponding demand.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Tracking Policy";
                Importance=Promoted }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der findes en lagervare (SKU) for denne vare.;
                           ENU=Specifies that a stockkeeping unit exists for this item.];
                ApplicationArea=#Warehouse;
                SourceExpr="Stockkeeping Unit Exists" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en tidsperiode, hvor planlëgningsprogrammet ikke skal foreslÜ omplanlëgning af eksisterende forsyningsordrer.;
                           ENU=Specifies a period of time during which you do not want the planning system to propose to reschedule existing supply orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Dampener Period";
                Importance=Additional;
                Enabled=DampenerPeriodEnable }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en buffermëngde for spërring af ubetydelige ëndringsforslag til en eksisterende levering, hvis det ëndrede antal er lavere end buffermëngden.;
                           ENU=Specifies a dampener quantity to block insignificant change suggestions for an existing supply, if the change quantity is lower than the dampener quantity.];
                ApplicationArea=#Advanced;
                SourceExpr="Dampener Quantity";
                Importance=Additional;
                Enabled=DampenerQtyEnable }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varen medtages i disponeringsberegningerne for at love en afsendelsesdato for den overordnede vare.;
                           ENU=Specifies if the item is included in availability calculations to promise a shipment date for its parent item.];
                ApplicationArea=#Advanced;
                SourceExpr=Critical }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en datoformel, som angiver den sikkerhedstid, der kan bruges som bufferperiode i forbindelse med produktion og andre forsinkelser.;
                           ENU=Specifies a date formula to indicate a safety lead time that can be used as a buffer period for production and other delays.];
                ApplicationArea=#Advanced;
                SourceExpr="Safety Lead Time";
                Enabled=SafetyLeadTimeEnable }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et antal varer, der skal vëre pÜ lager for at vëre forberedt pÜ udsving i udbud og efterspõrgsel ved forsinkelser i leveringstiden.;
                           ENU=Specifies a quantity of stock to have in inventory to protect against supply-and-demand fluctuations during replenishment lead time.];
                ApplicationArea=#Advanced;
                SourceExpr="Safety Stock Quantity";
                Enabled=SafetyStockQtyEnable }

    { 43  ;2   ;Group     ;
                CaptionML=[DAN=Lot-for-lot-parametre;
                           ENU=Lot-for-Lot Parameters];
                GroupType=Group }

    { 45  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, at lagerantallet inkluderes i den planlagte disponible beholdning, nÜr genbestillingsordrer bliver beregnet.;
                           ENU=Specifies that the inventory quantity is included in the projected available balance when replenishment orders are calculated.];
                ApplicationArea=#Advanced;
                SourceExpr="Include Inventory";
                Enabled=IncludeInventoryEnable;
                OnValidate=BEGIN
                             EnablePlanningControls
                           END;
                            }

    { 27  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver en periode, hvor flere krav er akkumuleret i Çn forsyningsordre, nÜr du bruger Lot-for-Lot-genbestilllingsmetoden.;
                           ENU=Specifies a period in which multiple demands are accumulated into one supply order when you use the Lot-for-Lot reordering policy.];
                ApplicationArea=#Advanced;
                SourceExpr="Lot Accumulation Period";
                Enabled=LotAccumulationPeriodEnable }

    { 41  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver en periode, inden for hvilken alle forslag om at ëndre en forsyningsdato altid bestÜr af handlingen Omplanlëg og aldrig af handlingen Annuller + Ny.;
                           ENU=Specifies a period within which any suggestion to change a supply date always consists of a Reschedule action and never a Cancel + New action.];
                ApplicationArea=#Advanced;
                SourceExpr="Rescheduling Period";
                Enabled=ReschedulingPeriodEnable }

    { 39  ;2   ;Group     ;
                CaptionML=[DAN=Parametre for genbestillingspunkt;
                           ENU=Reorder-Point Parameters];
                GroupType=Group }

    { 64  ;3   ;Group     ;
                GroupType=Group }

    { 37  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver et antal varer pÜ lager, der ligger under det niveau, hvor varen skal genbestilles.;
                           ENU=Specifies a stock quantity that sets the inventory below the level that you must replenish the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Reorder Point";
                Enabled=ReorderPointEnable }

    { 35  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver et standardantal for lotstõrrelse, der skal bruges ved alle ordreforslag.;
                           ENU=Specifies a standard lot size quantity to be used for all order proposals.];
                ApplicationArea=#Advanced;
                SourceExpr="Reorder Quantity";
                Enabled=ReorderQtyEnable }

    { 33  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver en mëngde, du vil bruge som det maksimale lagerniveau.;
                           ENU=Specifies a quantity that you want to use as a maximum inventory level.];
                ApplicationArea=#Advanced;
                SourceExpr="Maximum Inventory";
                Enabled=MaximumInventoryEnable }

    { 31  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver et antal, som du tillader den planlagte beholdning at overstige genbestillingspunktet med, fõr systemet foreslÜr at reducere forsyningsordrerne.;
                           ENU=Specifies a quantity you allow projected inventory to exceed the reorder point, before the system suggests to decrease supply orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Overflow Level";
                Importance=Additional;
                Enabled=OverflowLevelEnable }

    { 29  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver en periode for den tilbagevendende planlëgningshorisont, der bruges til genbestillingsmetoderne Fast genbestil.antal eller Maks. antal.;
                           ENU=Specifies a time period that defines the recurring planning horizon used with Fixed Reorder Qty. or Maximum Qty. reordering policies.];
                ApplicationArea=#Advanced;
                SourceExpr="Time Bucket";
                Importance=Additional;
                Enabled=TimeBucketEnable }

    { 63  ;2   ;Group     ;
                CaptionML=[DAN=Ordremodifikatorer;
                           ENU=Order Modifiers];
                GroupType=Group }

    { 61  ;3   ;Group     ;
                GroupType=Group }

    { 25  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver det mindste tilladte vareantal i et ordreforslag.;
                           ENU=Specifies a minimum allowable quantity for an item order proposal.];
                ApplicationArea=#Advanced;
                SourceExpr="Minimum Order Quantity";
                Enabled=MinimumOrderQtyEnable }

    { 23  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver det maksimalt tilladte vareantal i et ordreforslag.;
                           ENU=Specifies a maximum allowable quantity for an item order proposal.];
                ApplicationArea=#Advanced;
                SourceExpr="Maximum Order Quantity";
                Enabled=MaximumOrderQtyEnable }

    { 21  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver en parameter, der bruges af planlëgningssystemet til at ëndre antallet for de planlagte forsyningsordrer.;
                           ENU=Specifies a parameter used by the planning system to modify the quantity of planned supply orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Multiple";
                Enabled=OrderMultipleEnable }

    { 1904830201;1;Group  ;
                CaptionML=[DAN=Varesporing;
                           ENU=Item Tracking] }

    { 225 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan serie- eller lotnumre, der er knyttet til varen, spores i forsyningskëden.;
                           ENU=Specifies how serial or lot numbers assigned to the item are tracked in the supply chain.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Item Tracking Code";
                Importance=Promoted }

    { 210 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en nummerseriekode for at tildele fortlõbende serienumre til producerede varer.;
                           ENU=Specifies a number series code to assign consecutive serial numbers to items produced.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial Nos." }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der skal bruges ved tildeling af lotnumre.;
                           ENU=Specifies the number series code that will be used when assigning lot numbers.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot Nos." }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver formlen til beregning af udlõbsdatoen pÜ sporingslinjen.;
                           ENU=Specifies the formula for calculating the expiration date on the item tracking line.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Expiration Calculation" }

    { 1907509201;1;Group  ;
                CaptionML=[DAN=Lagersted;
                           ENU=Warehouse] }

    { 215 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lagerklassekoden for varen.;
                           ENU=Specifies the warehouse class code for the item.];
                ApplicationArea=#Warehouse;
                SourceExpr="Warehouse Class Code" }

    { 213 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det udstyr, som lagermedarbejdere skal bruge til at hÜndtere varen.;
                           ENU=Specifies the code of the equipment that warehouse employees must use when handling the item.];
                ApplicationArea=#Warehouse;
                SourceExpr="Special Equipment Code";
                Importance=Additional }

    { 206 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lëg-pÜ-lager-skabelon, som programmet bruger til at bestemme den mest passende zone og placering til opbevaring af modtagede varer.;
                           ENU=Specifies the code of the put-away template by which the program determines the most appropriate zone and bin for storage of the item after receipt.];
                ApplicationArea=#Warehouse;
                SourceExpr="Put-away Template Code" }

    { 204 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den enhed, som programmet bruger, nÜr varen lëgges pÜ lager.;
                           ENU=Specifies the code of the item unit of measure in which the program will put the item away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Put-away Unit of Measure Code";
                Importance=Promoted }

    { 202 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den optëllingsperiode, der angiver, hvor ofte varen skal optëlles ved lageropgõrelse.;
                           ENU=Specifies the code of the counting period that indicates how often you want to count the item in a physical inventory.];
                ApplicationArea=#Warehouse;
                SourceExpr="Phys Invt Counting Period Code";
                Importance=Promoted }

    { 200 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du sidst har bogfõrt resultaterne af en lageropgõrelse af varen pÜ varekladden.;
                           ENU=Specifies the date on which you last posted the results of a physical inventory for the item to the item ledger.];
                ApplicationArea=#Warehouse;
                SourceExpr="Last Phys. Invt. Date" }

    { 198 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor optëllingsperioden sidst blev beregnet. Den opdateres, nÜr du bruger funktionen Beregn optëllingsperiode.;
                           ENU=Specifies the last date on which you calculated the counting period. It is updated when you use the function Calculate Counting Period.];
                ApplicationArea=#Warehouse;
                SourceExpr="Last Counting Period Update" }

    { 194 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for den nëste optëllingsperiode.;
                           ENU=Specifies the starting date of the next counting period.];
                ApplicationArea=#Warehouse;
                SourceExpr="Next Counting Start Date" }

    { 131 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sludatoen for den nëste optëllingsperiode.;
                           ENU=Specifies the ending date of the next counting period.];
                ApplicationArea=#Warehouse;
                SourceExpr="Next Counting End Date" }

    { 192 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en entydig kode for varen, som er nyttig i et ADCS-system.;
                           ENU=Specifies a unique code for the item in terms that are useful for automatic data capture.];
                ApplicationArea=#Advanced;
                SourceExpr="Identifier Code";
                Importance=Additional }

    { 208 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvis varen kan sendes direkte.;
                           ENU=Specifies if this item can be cross-docked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Use Cross-Docking";
                Importance=Additional }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 109 ;1   ;Part      ;
                Name=ItemPicture;
                CaptionML=[DAN=Billede;
                           ENU=Picture];
                ApplicationArea=#All;
                SubPageLink=No.=FIELD(No.),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                            Location Filter=FIELD(Location Filter),
                            Drop Shipment Filter=FIELD(Drop Shipment Filter),
                            Variant Filter=FIELD(Variant Filter);
                PagePartID=Page346;
                PartType=Page }

    { 201 ;1   ;Part      ;
                Name=ItemAttributesFactbox;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page9110;
                PartType=Page }

    { 132 ;1   ;Part      ;
                ApplicationArea=#All;
                SubPageLink=Source Type=CONST(Item),
                            Source No.=FIELD(No.);
                PagePartID=Page875;
                Visible=SocialListeningVisible;
                PartType=Page }

    { 134 ;1   ;Part      ;
                ApplicationArea=#All;
                SubPageLink=Source Type=CONST(Item),
                            Source No.=FIELD(No.);
                PagePartID=Page876;
                Visible=SocialListeningSetupVisible;
                PartType=Page;
                UpdatePropagation=Both }

    { 162 ;1   ;Part      ;
                Name=WorkflowStatus;
                ApplicationArea=#Suite;
                PagePartID=Page1528;
                Visible=ShowWorkflowStatus;
                Enabled=FALSE;
                Editable=FALSE;
                PartType=Page;
                ShowFilter=No }

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
      ApplicationAreaSetup@1027 : Record 9178;
      CalculateStdCost@1005 : Codeunit 5812;
      CRMIntegrationManagement@1030 : Codeunit 5330;
      ItemAvailFormsMgt@1000 : Codeunit 353;
      ApprovalsMgmt@1013 : Codeunit 1535;
      SkilledResourceList@1001 : Page 6023;
      IsFoundationEnabled@1028 : Boolean;
      ShowStockoutWarningDefaultYes@1006 : Boolean;
      ShowStockoutWarningDefaultNo@1004 : Boolean;
      ShowPreventNegInventoryDefaultYes@1003 : Boolean;
      ShowPreventNegInventoryDefaultNo@1002 : Boolean;
      TimeBucketEnable@19054765 : Boolean INDATASET;
      SafetyLeadTimeEnable@19079647 : Boolean INDATASET;
      SafetyStockQtyEnable@19036196 : Boolean INDATASET;
      ReorderPointEnable@19067744 : Boolean INDATASET;
      ReorderQtyEnable@19013534 : Boolean INDATASET;
      MaximumInventoryEnable@19059424 : Boolean INDATASET;
      MinimumOrderQtyEnable@19021857 : Boolean INDATASET;
      MaximumOrderQtyEnable@19007977 : Boolean INDATASET;
      OrderMultipleEnable@19004365 : Boolean INDATASET;
      IncludeInventoryEnable@19061544 : Boolean INDATASET;
      ReschedulingPeriodEnable@19049766 : Boolean INDATASET;
      LotAccumulationPeriodEnable@19019376 : Boolean INDATASET;
      DampenerPeriodEnable@19045210 : Boolean INDATASET;
      DampenerQtyEnable@19051814 : Boolean INDATASET;
      OverflowLevelEnable@19033283 : Boolean INDATASET;
      StandardCostEnable@19016419 : Boolean INDATASET;
      UnitCostEnable@19054429 : Boolean INDATASET;
      SocialListeningSetupVisible@1008 : Boolean INDATASET;
      SocialListeningVisible@1007 : Boolean INDATASET;
      CRMIntegrationEnabled@1010 : Boolean;
      CRMIsCoupledToRecord@1009 : Boolean;
      OpenApprovalEntriesExistCurrUser@1012 : Boolean;
      OpenApprovalEntriesExist@1011 : Boolean;
      ShowWorkflowStatus@1014 : Boolean;
      InventoryItemEditable@1015 : Boolean INDATASET;
      UnitCostEditable@1022 : Boolean INDATASET;
      ProfitEditable@1017 : Boolean;
      PriceEditable@1018 : Boolean;
      SpecialPricesAndDiscountsTxt@1019 : Text;
      CreateNewTxt@1020 : TextConst 'DAN=Opret nyt...;ENU=Create New...';
      ViewExistingTxt@1021 : TextConst 'DAN=FÜ vist eksisterende priser og rabatter...;ENU=View Existing Prices and Discounts...';
      CreateNewSpecialPriceTxt@1023 : TextConst 'DAN=Opret ny specialpris...;ENU=Create New Special Price...';
      CreateNewSpecialDiscountTxt@1024 : TextConst 'DAN=Opret ny specialrabat...;ENU=Create New Special Discount...';
      SpecialPurchPricesAndDiscountsTxt@1033 : Text;
      EnabledApprovalWorkflowsExist@1025 : Boolean;
      EventFilter@1026 : Text;
      NoFieldVisible@1016 : Boolean;
      NewMode@1029 : Boolean;
      IsService@1031 : Boolean;
      CanRequestApprovalForFlow@1032 : Boolean;
      CanCancelApprovalForFlow@1034 : Boolean;
      IsSaaS@1035 : Boolean;

    LOCAL PROCEDURE EnableControls@6();
    VAR
      ItemLedgerEntry@1000 : Record 32;
      CRMIntegrationManagement@1001 : Codeunit 5330;
    BEGIN
      InventoryItemEditable := Type = Type::Inventory;
      IsService := (Type = Type::Service);

      IF Type = Type::Inventory THEN BEGIN
        ItemLedgerEntry.SETRANGE("Item No.","No.");
        UnitCostEditable := ItemLedgerEntry.ISEMPTY;
      END ELSE
        UnitCostEditable := TRUE;

      ProfitEditable := "Price/Profit Calculation" <> "Price/Profit Calculation"::"Profit=Price-Cost";
      PriceEditable := "Price/Profit Calculation" <> "Price/Profit Calculation"::"Price=Cost+Profit";

      EnablePlanningControls;
      EnableCostingControls;

      EnableShowStockOutWarning;

      SetSocialListeningFactboxVisibility;
      EnableShowShowEnforcePositivInventory;
      CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

      UpdateSpecialPricesAndDiscountsTxt;
    END;

    LOCAL PROCEDURE OnNewRec@16();
    VAR
      DocumentNoVisibility@1002 : Codeunit 1400;
    BEGIN
      IF GUIALLOWED THEN BEGIN
        EnableControls;
        IF "No." = '' THEN
          IF DocumentNoVisibility.ItemNoSeriesIsDefault THEN
            NewMode := TRUE;
      END;
    END;

    LOCAL PROCEDURE EnableShowStockOutWarning@4();
    VAR
      SalesSetup@1000 : Record 311;
    BEGIN
      IF Type = Type::Service THEN
        "Stockout Warning" := "Stockout Warning"::No;

      SalesSetup.GET;
      ShowStockoutWarningDefaultYes := SalesSetup."Stockout Warning";
      ShowStockoutWarningDefaultNo := NOT ShowStockoutWarningDefaultYes;

      EnableShowShowEnforcePositivInventory;
    END;

    LOCAL PROCEDURE InsertItemUnitOfMeasure@8();
    VAR
      ItemUnitOfMeasure@1000 : Record 5404;
    BEGIN
      IF "Base Unit of Measure" <> '' THEN BEGIN
        ItemUnitOfMeasure.INIT;
        ItemUnitOfMeasure."Item No." := "No.";
        ItemUnitOfMeasure.VALIDATE(Code,"Base Unit of Measure");
        ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
        ItemUnitOfMeasure.INSERT;
      END;
    END;

    LOCAL PROCEDURE EnableShowShowEnforcePositivInventory@2();
    VAR
      InventorySetup@1000 : Record 313;
    BEGIN
      InventorySetup.GET;
      ShowPreventNegInventoryDefaultYes := InventorySetup."Prevent Negative Inventory";
      ShowPreventNegInventoryDefaultNo := NOT ShowPreventNegInventoryDefaultYes;
    END;

    LOCAL PROCEDURE EnablePlanningControls@1();
    VAR
      PlanningGetParam@1000 : Codeunit 99000855;
      TimeBucketEnabled@1010 : Boolean;
      SafetyLeadTimeEnabled@1009 : Boolean;
      SafetyStockQtyEnabled@1008 : Boolean;
      ReorderPointEnabled@1007 : Boolean;
      ReorderQtyEnabled@1006 : Boolean;
      MaximumInventoryEnabled@1005 : Boolean;
      MinimumOrderQtyEnabled@1004 : Boolean;
      MaximumOrderQtyEnabled@1003 : Boolean;
      OrderMultipleEnabled@1002 : Boolean;
      IncludeInventoryEnabled@1001 : Boolean;
      ReschedulingPeriodEnabled@1015 : Boolean;
      LotAccumulationPeriodEnabled@1014 : Boolean;
      DampenerPeriodEnabled@1013 : Boolean;
      DampenerQtyEnabled@1012 : Boolean;
      OverflowLevelEnabled@1011 : Boolean;
    BEGIN
      PlanningGetParam.SetUpPlanningControls("Reordering Policy","Include Inventory",
        TimeBucketEnabled,SafetyLeadTimeEnabled,SafetyStockQtyEnabled,
        ReorderPointEnabled,ReorderQtyEnabled,MaximumInventoryEnabled,
        MinimumOrderQtyEnabled,MaximumOrderQtyEnabled,OrderMultipleEnabled,IncludeInventoryEnabled,
        ReschedulingPeriodEnabled,LotAccumulationPeriodEnabled,
        DampenerPeriodEnabled,DampenerQtyEnabled,OverflowLevelEnabled);

      TimeBucketEnable := TimeBucketEnabled;
      SafetyLeadTimeEnable := SafetyLeadTimeEnabled;
      SafetyStockQtyEnable := SafetyStockQtyEnabled;
      ReorderPointEnable := ReorderPointEnabled;
      ReorderQtyEnable := ReorderQtyEnabled;
      MaximumInventoryEnable := MaximumInventoryEnabled;
      MinimumOrderQtyEnable := MinimumOrderQtyEnabled;
      MaximumOrderQtyEnable := MaximumOrderQtyEnabled;
      OrderMultipleEnable := OrderMultipleEnabled;
      IncludeInventoryEnable := IncludeInventoryEnabled;
      ReschedulingPeriodEnable := ReschedulingPeriodEnabled;
      LotAccumulationPeriodEnable := LotAccumulationPeriodEnabled;
      DampenerPeriodEnable := DampenerPeriodEnabled;
      DampenerQtyEnable := DampenerQtyEnabled;
      OverflowLevelEnable := OverflowLevelEnabled;
    END;

    LOCAL PROCEDURE EnableCostingControls@3();
    BEGIN
      StandardCostEnable := "Costing Method" = "Costing Method"::Standard;
      UnitCostEnable := "Costing Method" <> "Costing Method"::Standard;
    END;

    LOCAL PROCEDURE SetSocialListeningFactboxVisibility@5();
    VAR
      SocialListeningMgt@1000 : Codeunit 871;
    BEGIN
      SocialListeningMgt.GetItemFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
    END;

    LOCAL PROCEDURE InitControls@12();
    BEGIN
      UnitCostEnable := TRUE;
      StandardCostEnable := TRUE;
      OverflowLevelEnable := TRUE;
      DampenerQtyEnable := TRUE;
      DampenerPeriodEnable := TRUE;
      LotAccumulationPeriodEnable := TRUE;
      ReschedulingPeriodEnable := TRUE;
      IncludeInventoryEnable := TRUE;
      OrderMultipleEnable := TRUE;
      MaximumOrderQtyEnable := TRUE;
      MinimumOrderQtyEnable := TRUE;
      MaximumInventoryEnable := TRUE;
      ReorderQtyEnable := TRUE;
      ReorderPointEnable := TRUE;
      SafetyStockQtyEnable := TRUE;
      SafetyLeadTimeEnable := TRUE;
      TimeBucketEnable := TRUE;

      InventoryItemEditable := Type = Type::Inventory;
      "Costing Method" := "Costing Method"::FIFO;
      UnitCostEditable := TRUE;
    END;

    LOCAL PROCEDURE UpdateSpecialPricesAndDiscountsTxt@7();
    VAR
      TempSalesPriceAndLineDiscBuff@1000 : TEMPORARY Record 1304;
      TempPurchPriceLineDiscBuff@1001 : TEMPORARY Record 1315;
    BEGIN
      SpecialPricesAndDiscountsTxt := CreateNewTxt;
      IF TempSalesPriceAndLineDiscBuff.ItemHasLines(Rec) THEN
        SpecialPricesAndDiscountsTxt := ViewExistingTxt;

      SpecialPurchPricesAndDiscountsTxt := CreateNewTxt;
      IF TempPurchPriceLineDiscBuff.ItemHasLines(Rec) THEN
        SpecialPurchPricesAndDiscountsTxt := ViewExistingTxt;
    END;

    LOCAL PROCEDURE CreateItemFromTemplate@11();
    VAR
      ItemTemplate@1001 : Record 1301;
      Item@1000 : Record 27;
      InventorySetup@1002 : Record 313;
    BEGIN
      IF NewMode THEN BEGIN
        IF ItemTemplate.NewItemFromTemplate(Item) THEN BEGIN
          COPY(Item);
          CurrPage.UPDATE;
        END;

        IF ApplicationAreaSetup.IsFoundationEnabled THEN
          IF (Item."No." = '') AND InventorySetup.GET THEN
            VALIDATE("Costing Method",InventorySetup."Default Costing Method");

        NewMode := FALSE;
      END;
    END;

    LOCAL PROCEDURE SetNoFieldVisible@13();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
    BEGIN
      NoFieldVisible := DocumentNoVisibility.ItemNoIsVisible;
    END;

    BEGIN
    END.
  }
}

