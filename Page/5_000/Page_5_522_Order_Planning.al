OBJECT Page 5522 Order Planning
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ordreplanlëgning;
               ENU=Order Planning];
    InsertAllowed=No;
    SourceTable=Table246;
    PageType=Worksheet;
    SourceTableTemporary=Yes;
    OnInit=BEGIN
             DemandOrderFilterCtrlEnable := TRUE;
             SupplyFromEditable := TRUE;
             ReserveEditable := TRUE;
           END;

    OnOpenPage=BEGIN
                 IF NOT MfgUserTempl.GET(USERID) THEN BEGIN
                   MfgUserTempl.INIT;
                   MfgUserTempl."User ID" := USERID;
                   MfgUserTempl."Make Orders" := MfgUserTempl."Make Orders"::"The Active Order";
                   MfgUserTempl."Create Purchase Order" := MfgUserTempl."Create Purchase Order"::"Make Purch. Orders";
                   MfgUserTempl."Create Production Order" := MfgUserTempl."Create Production Order"::"Firm Planned";
                   MfgUserTempl."Create Transfer Order" := MfgUserTempl."Create Transfer Order"::"Make Trans. Orders";
                   MfgUserTempl."Create Assembly Order" := MfgUserTempl."Create Assembly Order"::"Make Assembly Orders";
                   MfgUserTempl.INSERT;
                 END;

                 InitTempRec;
               END;

    OnAfterGetRecord=BEGIN
                       DescriptionIndent := 0;
                       StatusText := FORMAT(Status);
                       StatusTextOnFormat(StatusText);
                       DemandTypeText := FORMAT("Demand Type");
                       DemandTypeTextOnFormat(DemandTypeText);
                       DemandSubtypeText := FORMAT("Demand Subtype");
                       DemandSubtypeTextOnFormat(DemandSubtypeText);
                       DemandOrderNoOnFormat;
                       DescriptionOnFormat;
                       DemandQuantityOnFormat;
                       DemandQtyAvailableOnFormat;
                       ReplenishmentSystemOnFormat;
                       QuantityOnFormat;
                       ReserveOnFormat;
                     END;

    OnModifyRecord=VAR
                     ReqLine@1000 : Record 246;
                   BEGIN
                     ReqLine.GET("Worksheet Template Name","Journal Batch Name","Line No.");
                     ReqLine.TRANSFERFIELDS(Rec,FALSE);
                     ReqLine.MODIFY(TRUE);
                   END;

    OnDeleteRecord=VAR
                     xReqLine@1000 : Record 246;
                   BEGIN
                     xReqLine := Rec;
                     WHILE (NEXT <> 0) AND (Level > xReqLine.Level) DO
                       DELETE(TRUE);
                     Rec := xReqLine;
                     xReqLine.DELETE(TRUE);
                     DELETE;
                     EXIT(FALSE);
                   END;

    OnAfterGetCurrRecord=BEGIN
                           IF ReqLine.GET("Worksheet Template Name","Journal Batch Name","Line No.") THEN BEGIN
                             Rec := ReqLine;
                             MODIFY
                           END ELSE
                             IF GET("Worksheet Template Name","Journal Batch Name","Line No.") THEN
                               DELETE;

                           UpdateSupplyFrom;
                           CalcItemAvail;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 99      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=èbn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Planning;
                      Image=View;
                      OnAction=BEGIN
                                 ShowDemandOrder;
                               END;
                                }
      { 63      ;2   ;Separator  }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Komponenter;
                                 ENU=Components];
                      ToolTipML=[DAN=FÜ vist eller rediger produktionsordrekomponenterne for den overordnede vare pÜ linjen.;
                                 ENU=View or edit the production order components of the parent item on the line.];
                      ApplicationArea=#Planning;
                      RunObject=Page 99000862;
                      RunPageLink=Worksheet Template Name=FIELD(Worksheet Template Name),
                                  Worksheet Batch Name=FIELD(Journal Batch Name),
                                  Worksheet Line No.=FIELD(Line No.);
                      Image=Components }
      { 47      ;2   ;Action    ;
                      CaptionML=[DAN=R&ute;
                                 ENU=Ro&uting];
                      ToolTipML=[DAN=FÜ vist eller rediger operationslisten for den overordnede vare pÜ linjen.;
                                 ENU=View or edit the operations list of the parent item on the line.];
                      ApplicationArea=#Planning;
                      RunObject=Page 99000863;
                      RunPageLink=Worksheet Template Name=FIELD(Worksheet Template Name),
                                  Worksheet Batch Name=FIELD(Journal Batch Name),
                                  Worksheet Line No.=FIELD(Line No.);
                      Image=Route }
      { 101     ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 100     ;1   ;ActionGroup;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      Image=Item }
      { 19      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den pÜgëldende record pÜ bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Planning;
                      Image=EditLines;
                      OnAction=VAR
                                 Item@1000 : Record 27;
                               BEGIN
                                 TESTFIELD(Type,Type::Item);
                                 TESTFIELD("No.");
                                 Item."No." := "No.";
                                 PAGE.RUNMODAL(PAGE::"Item Card",Item);
                               END;
                                }
      { 105     ;2   ;ActionGroup;
                      CaptionML=[DAN=&Varedisponering pr.;
                                 ENU=&Item Availability by];
                      Image=ItemAvailability }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilgëngelige saldo for en vare udvikler sig over tid i henhold til udbud og efterspõrgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Planning;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 106     ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller mÜned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Planning;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 107     ;3   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByVariant);
                               END;
                                }
      { 108     ;3   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByLocation);
                               END;
                                }
      { 5       ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=FÜ vist tilgëngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret pÜ tilgëngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 37      ;2   ;Action    ;
                      Name=CalculatePlan;
                      CaptionML=[DAN=&Beregn plan;
                                 ENU=&Calculate Plan];
                      ToolTipML=[DAN=Start beregningen af forsyningsordrer, der krëves for at opfylde det angivne behov. Husk, at der kun planlëgges Çt produktniveau, hver gang du vëlger handlingen Beregn plan.;
                                 ENU=Start the calculation of supply orders needed to fulfill the specified demand. Remember that each time, you choose the Calculate Plan action, only one product level is planned.];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      Image=CalculatePlan;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CalcPlan;
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 48      ;2   ;Separator  }
      { 66      ;2   ;Action    ;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserver den nõdvendige mëngde pÜ den bilagslinje, som vinduet blev Übnet for.;
                                 ENU=Reserve the quantity that is required on the document line that you opened this window for.];
                      ApplicationArea=#Planning;
                      Image=Reserve;
                      OnAction=BEGIN
                                 CurrPage.SAVERECORD;
                                 ShowReservation;
                               END;
                                }
      { 67      ;2   ;Action    ;
                      Name=OrderTracking;
                      CaptionML=[DAN=Ordre&sporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den dertil hõrende efterspõrgsel. PÜ denne mÜde kan du finde den oprindelige efterspõrgsel, der medfõrte en specifik produktionsordre eller kõbsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#Planning;
                      Image=OrderTracking;
                      OnAction=VAR
                                 TrackingForm@1001 : Page 99000822;
                               BEGIN
                                 TrackingForm.SetReqLine(Rec);
                                 TrackingForm.RUNMODAL;
                               END;
                                }
      { 77      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opdater &planlëgningslinje;
                                 ENU=Refresh &Planning Line];
                      ToolTipML=[DAN=Opdater planlëgningskomponenterne og rutelinjerne for den valgte planlëgningslinje med eventuelle ëndringer.;
                                 ENU=Update the planning components and the routing lines for the selected planning line with any changes.];
                      ApplicationArea=#Planning;
                      Image=RefreshPlanningLine;
                      OnAction=VAR
                                 ReqLine2@1000 : Record 246;
                               BEGIN
                                 ReqLine2.SETRANGE("Worksheet Template Name","Worksheet Template Name");
                                 ReqLine2.SETRANGE("Journal Batch Name","Journal Batch Name");
                                 ReqLine2.SETRANGE("Line No.","Line No.");

                                 REPORT.RUNMODAL(REPORT::"Refresh Planning Demand",TRUE,FALSE,ReqLine2);
                               END;
                                }
      { 36      ;2   ;Separator  }
      { 55      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Lav &ordrer;
                                 ENU=Make &Orders];
                      ToolTipML=[DAN=Opret de foreslÜede forsyningsordrer i henhold til indstillinger, du angiver i et nyt vindue.;
                                 ENU=Create the suggested supply orders according to options that you specify in a new window.];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      Image=NewOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MakeSupplyOrders@1001 : Codeunit 5521;
                               BEGIN
                                 MakeSupplyOrders.SetManufUserTemplate(MfgUserTempl);
                                 MakeSupplyOrders.RUN(Rec);

                                 IF MakeSupplyOrders.ActionMsgCarriedOut THEN BEGIN
                                   RefreshTempTable;
                                   SetRecFilters;
                                   CurrPage.UPDATE(FALSE);
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 78  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 80  ;2   ;Field     ;
                Name=DemandOrderFilterCtrl;
                CaptionML=[DAN=Vis behov som;
                           ENU=Show Demand as];
                ToolTipML=[DAN=Angiver et filter for at definere, hvilke behovstyper du vil have vist i vinduet Ordreplanlëgning.;
                           ENU=Specifies a filter to define which demand types you want to display in the Order Planning window.];
                OptionCaptionML=[DAN=Alle behov,Produktionsbehov,Salgsbehov,Servicebehov,Jobbehov,Montagebehov;
                                 ENU=All Demand,Production Demand,Sales Demand,Service Demand,Job Demand,Assembly Demand];
                ApplicationArea=#Planning;
                SourceExpr=DemandOrderFilter;
                Enabled=DemandOrderFilterCtrlEnable;
                OnValidate=BEGIN
                             DemandOrderFilterOnAfterValida;
                           END;
                            }

    { 1   ;1   ;Group     ;
                IndentationColumnName=DescriptionIndent;
                IndentationControls=Description;
                ShowAsTree=Yes;
                GroupType=Repeater }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver behovsdatoen for det behov, som planlëgningslinjen reprësenterer.;
                           ENU=Specifies the demanded date of the demand that the planning line represents.];
                ApplicationArea=#Planning;
                SourceExpr="Demand Date" }

    { 72  ;2   ;Field     ;
                ApplicationArea=#Planning;
                SourceExpr=StatusText;
                CaptionClass=FIELDCAPTION(Status);
                Editable=FALSE;
                HideValue=StatusHideValue }

    { 43  ;2   ;Field     ;
                Lookup=No;
                ApplicationArea=#Planning;
                SourceExpr=DemandTypeText;
                CaptionClass=FIELDCAPTION("Demand Type");
                Editable=FALSE;
                HideValue=DemandTypeHideValue;
                Style=Strong;
                StyleExpr=DemandTypeEmphasize }

    { 46  ;2   ;Field     ;
                ApplicationArea=#Planning;
                SourceExpr=DemandSubtypeText;
                CaptionClass=FIELDCAPTION("Demand Subtype");
                Visible=FALSE;
                Editable=FALSE }

    { 57  ;2   ;Field     ;
                CaptionML=[DAN=Ordrenr.;
                           ENU=Order No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den behovsordre, som reprësenterer planlëgningslinjen.;
                           ENU=Specifies the number of the demanded order that represents the planning line.];
                ApplicationArea=#Planning;
                SourceExpr="Demand Order No.";
                HideValue=DemandOrderNoHideValue;
                Style=Strong;
                StyleExpr=DemandOrderNoEmphasize }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret for behovet, som f.eks. en salgsordrelinje.;
                           ENU=Specifies the line number of the demand, such as a sales order line.];
                ApplicationArea=#Planning;
                SourceExpr="Demand Line No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Varenr.;
                           ENU=Item No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den vare, hvis tilgëngelighed er utilstrëkkelig og skal planlëgges.;
                           ENU=Specifies the number of the item with insufficient availability and must be planned.];
                ApplicationArea=#Planning;
                SourceExpr="No.";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE;
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lagerlokation, hvor de bestilte varer skal registreres pÜ.;
                           ENU=Specifies a code for an inventory location where the items that are being ordered will be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE;
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tekst, der beskriver posten.;
                           ENU=Specifies text that describes the entry.];
                ApplicationArea=#Planning;
                SourceExpr=Description;
                Editable=FALSE;
                Style=Strong;
                StyleExpr=DescriptionEmphasize }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet for det behov, som planlëgningslinjen reprësenterer.;
                           ENU=Specifies the quantity on the demand that the planning line represents.];
                ApplicationArea=#Planning;
                SourceExpr="Demand Quantity";
                Visible=FALSE;
                HideValue=DemandQuantityHideValue }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor stor en andel af behovsmëngden der er tilgëngelig.;
                           ENU=Specifies how many of the demand quantity are available.];
                ApplicationArea=#Planning;
                SourceExpr="Demand Qty. Available";
                Visible=FALSE;
                HideValue=DemandQtyAvailableHideValue }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den behovsmëngde, som ikke er tilgëngelig og skal bestilles for at opfylde det behov, som er anfõrt pÜ planlëgningslinjen.;
                           ENU=Specifies the demand quantity that is not available and must be ordered to meet the demand represented on the planning line.];
                ApplicationArea=#Planning;
                SourceExpr="Needed Quantity";
                Visible=TRUE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken slags ordre der bruges til at oprette genbestillingsordrer og forslag.;
                           ENU=Specifies which kind of order to use to create replenishment orders and order proposals.];
                ApplicationArea=#Planning;
                SourceExpr="Replenishment System";
                HideValue=ReplenishmentSystemHideValue;
                OnValidate=BEGIN
                             ReplenishmentSystemOnAfterVali;
                           END;
                            }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en vërdi i overensstemmelse med det valgte genbestillingssystem, inden der kan oprettes en forsyningsordre for linjen.;
                           ENU=Specifies a value, according to the selected replenishment system, before a supply order can be created for the line.];
                ApplicationArea=#Planning;
                SourceExpr="Supply From";
                Editable=SupplyFromEditable }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varen pÜ planlëgningslinjen har indstillingen Altid i feltet Reserver pÜ varekortet.;
                           ENU=Specifies whether the item on the planning line has a setting of Always in the Reserve field on its item card.];
                ApplicationArea=#Planning;
                SourceExpr=Reserve;
                Editable=ReserveEditable }

    { 28  ;2   ;Field     ;
                CaptionML=[DAN=Antal til ordre;
                           ENU=Qty. to Order];
                ToolTipML=[DAN=Angiver den mëngde, der vil blive bestilt pÜ den forsyningsordre, f.eks. kõbs- eller montageordre, som du kan oprette fra planlëgningslinjen.;
                           ENU=Specifies the quantity that will be ordered on the supply order, such as purchase or assembly, that you can create from the planning line.];
                ApplicationArea=#Assembly;
                SourceExpr=Quantity;
                HideValue=QuantityHideValue }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Planning;
                SourceExpr="Unit of Measure Code";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede ordre blev oprettet.;
                           ENU=Specifies the date when the related order was created.];
                ApplicationArea=#Planning;
                SourceExpr="Order Date" }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for produktionsprocessen, hvis den planlagte forsyning er en produktionsordre.;
                           ENU=Specifies the starting date of the manufacturing process, if the planned supply is a production order.];
                ApplicationArea=#Planning;
                SourceExpr="Starting Date";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du kan forvente at modtage varerne.;
                           ENU=Specifies the date when you can expect to receive the items.];
                ApplicationArea=#Planning;
                SourceExpr="Due Date" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Planning;
                SourceExpr="Unit Cost";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Planning;
                SourceExpr="Direct Unit Cost";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for rekvisitionslinjerne.;
                           ENU=Specifies the currency code for the requisition lines.];
                ApplicationArea=#Planning;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indkõber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Planning;
                SourceExpr="Purchasing Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 38  ;1   ;Group      }

    { 1902204901;2;Group  ;
                GroupType=FixedLayout }

    { 1901313001;3;Group  ;
                CaptionML=[DAN=Disponibel til overflytning;
                           ENU=Available for Transfer] }

    { 60  ;4   ;Field     ;
                Name=AvailableForTransfer;
                CaptionML=[DAN=Disponibel til overflytning;
                           ENU=Available For Transfer];
                ToolTipML=[DAN=Angiver den mëngde af varen pÜ den aktive planlëgningslinje, som er tilgëngelig pÜ en anden lokation end den, der er defineret.;
                           ENU=Specifies the quantity of the item on the active planning line, that is available on another location than the one defined.];
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                SourceExpr=QtyOnOtherLocations;
                Editable=FALSE;
                OnAssistEdit=BEGIN
                               OrderPlanningMgt.InsertAltSupplyLocation(Rec);
                             END;
                              }

    { 1901741901;3;Group  ;
                CaptionML=[DAN=Erstatning findes;
                           ENU=Substitutes Exist] }

    { 58  ;4   ;Field     ;
                Lookup=No;
                DrillDown=No;
                CaptionML=[DAN=Erstatning findes;
                           ENU=Substitutes Exist];
                ToolTipML=[DAN=Angiver, om der findes en stedfortrëdervare for komponenten pÜ planlëgningslinjen.;
                           ENU=Specifies if a substitute item exists for the component on the planning line.];
                ApplicationArea=#Planning;
                SourceExpr=SubstitionAvailable;
                Editable=FALSE;
                OnAssistEdit=VAR
                               ReqLine2@1001 : Record 246;
                               xReqLine@1002 : Record 246;
                               ReqLine3@1003 : Record 246;
                             BEGIN
                               ReqLine3 := Rec;
                               OrderPlanningMgt.InsertAltSupplySubstitution(ReqLine3);
                               Rec := ReqLine3;
                               MODIFY;

                               IF OrderPlanningMgt.DeleteLine THEN BEGIN
                                 xReqLine := Rec;
                                 ReqLine2.SETCURRENTKEY("User ID","Demand Type","Demand Subtype","Demand Order No.");
                                 ReqLine2.SETRANGE("User ID",USERID);
                                 ReqLine2.SETRANGE("Demand Type","Demand Type");
                                 ReqLine2.SETRANGE("Demand Subtype","Demand Subtype");
                                 ReqLine2.SETRANGE("Demand Order No.","Demand Order No.");
                                 ReqLine2.SETRANGE(Level,Level,Level + 1);
                                 ReqLine2.SETFILTER("Line No.",'<>%1',"Line No.");
                                 IF NOT ReqLine2.FINDFIRST THEN BEGIN // No other children
                                   ReqLine2.SETRANGE("Line No.");
                                   ReqLine2.SETRANGE(Level,0);
                                   IF ReqLine2.FINDFIRST THEN BEGIN // Find and delete parent
                                     Rec := ReqLine2;
                                     DELETE;
                                   END;
                                 END;

                                 Rec := xReqLine;
                                 DELETE;
                                 CurrPage.UPDATE(FALSE);
                               END ELSE
                                 CurrPage.UPDATE(TRUE);
                             END;
                              }

    { 1901741801;3;Group  ;
                CaptionML=[DAN=Disponibelt antal;
                           ENU=Quantity Available] }

    { 68  ;4   ;Field     ;
                Name=QuantityAvailable;
                Lookup=No;
                DrillDown=No;
                CaptionML=[DAN=Disponibelt antal;
                           ENU=Quantity Available];
                ToolTipML=[DAN=Angiver den samlede tilgëngelighed af varen pÜ den aktive planlëgningslinje, uanset de antal, der er beregnet for linjen.;
                           ENU=Specifies the total availability of the item on the active planning line, irrespective of quantities calculated for the line.];
                ApplicationArea=#Planning;
                DecimalPlaces=0:5;
                SourceExpr=QtyATP;
                Editable=FALSE }

    { 1901312901;3;Group  ;
                CaptionML=[DAN=Tidligste disponible dato;
                           ENU=Earliest Date Available] }

    { 70  ;4   ;Field     ;
                Lookup=No;
                DrillDown=No;
                CaptionML=[DAN=Tidligste disponible dato;
                           ENU=Earliest Date Available];
                ToolTipML=[DAN=Angiver ankomstdatoen for en indgÜende forsyningsordre, der kan dëkke det krëvede antal pÜ en dato, der er senere end behovsdatoen.;
                           ENU=Specifies the arrival date of an inbound supply order that can cover the needed quantity on a date later than the demand date.];
                ApplicationArea=#Planning;
                SourceExpr=EarliestShptDateAvailable;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      ReqLine@1001 : Record 246;
      SalesHeader@1000 : Record 36;
      ProdOrder@1006 : Record 5405;
      AsmHeader@1013 : Record 900;
      ServHeader@1004 : Record 5900;
      Job@1010 : Record 167;
      MfgUserTempl@1015 : Record 5525;
      OrderPlanningMgt@1002 : Codeunit 5522;
      ItemAvailFormsMgt@1003 : Codeunit 353;
      DemandOrderFilter@1007 : 'All Demands,Production Demand,Sales Demand,Service Demand,Job Demand,Assembly Demand';
      Text001@1008 : TextConst 'DAN=Salg;ENU=Sales';
      Text002@1009 : TextConst 'DAN=Produktion;ENU=Production';
      Text003@1011 : TextConst 'DAN=Service;ENU=Service';
      Text004@1012 : TextConst 'DAN=Sager;ENU=Jobs';
      StatusHideValue@19077886 : Boolean INDATASET;
      StatusText@19037117 : Text[1024] INDATASET;
      DemandTypeHideValue@19039011 : Boolean INDATASET;
      DemandTypeEmphasize@19074322 : Boolean INDATASET;
      DemandTypeText@19010028 : Text[1024] INDATASET;
      DemandSubtypeText@19017088 : Text[1024] INDATASET;
      DemandOrderNoHideValue@19045269 : Boolean INDATASET;
      DemandOrderNoEmphasize@19029891 : Boolean INDATASET;
      DescriptionEmphasize@19010547 : Boolean INDATASET;
      DescriptionIndent@19057867 : Integer INDATASET;
      DemandQuantityHideValue@19062899 : Boolean INDATASET;
      DemandQtyAvailableHideValue@19060213 : Boolean INDATASET;
      ReplenishmentSystemHideValue@19034362 : Boolean INDATASET;
      QuantityHideValue@19060207 : Boolean INDATASET;
      SupplyFromEditable@19071852 : Boolean INDATASET;
      ReserveEditable@1016 : Boolean INDATASET;
      DemandOrderFilterCtrlEnable@19066621 : Boolean INDATASET;
      Text005@1014 : TextConst 'DAN=Montage;ENU=Assembly';
      QtyOnOtherLocations@1005 : Decimal;
      SubstitionAvailable@1017 : Boolean;
      QtyATP@1018 : Decimal;
      EarliestShptDateAvailable@1019 : Date;

    [External]
    PROCEDURE SetSalesOrder@2(SalesHeader2@1001 : Record 36);
    BEGIN
      SalesHeader := SalesHeader2;
      DemandOrderFilter := DemandOrderFilter::"Sales Demand";
      DemandOrderFilterCtrlEnable := FALSE;
    END;

    [External]
    PROCEDURE SetProdOrder@3(ProdOrder2@1000 : Record 5405);
    BEGIN
      ProdOrder := ProdOrder2;
      DemandOrderFilter := DemandOrderFilter::"Production Demand";
      DemandOrderFilterCtrlEnable := FALSE;
    END;

    [External]
    PROCEDURE SetAsmOrder@23(AsmHeader2@1001 : Record 900);
    BEGIN
      AsmHeader := AsmHeader2;
      DemandOrderFilter := DemandOrderFilter::"Assembly Demand";
      DemandOrderFilterCtrlEnable := FALSE;
    END;

    [External]
    PROCEDURE SetServOrder@19(ServHeader2@1001 : Record 5900);
    BEGIN
      ServHeader := ServHeader2;
      DemandOrderFilter := DemandOrderFilter::"Service Demand";
      DemandOrderFilterCtrlEnable := FALSE;
    END;

    [External]
    PROCEDURE SetJobOrder@21(Job2@1001 : Record 167);
    BEGIN
      Job := Job2;
      DemandOrderFilter := DemandOrderFilter::"Job Demand";
      DemandOrderFilterCtrlEnable := FALSE;
    END;

    LOCAL PROCEDURE InitTempRec@12();
    VAR
      ReqLine@1000 : Record 246;
      ReqLineWithCursor@1001 : Record 246;
    BEGIN
      DELETEALL;

      ReqLine.RESET;
      ReqLine.COPYFILTERS(Rec);
      ReqLine.SETRANGE("User ID",USERID);
      ReqLine.SETRANGE("Worksheet Template Name",'');
      IF ReqLine.FINDSET THEN
        REPEAT
          Rec := ReqLine;
          INSERT;
          IF ReqLine.Level = 0 THEN
            FindReqLineForCursor(ReqLineWithCursor,ReqLine);
        UNTIL ReqLine.NEXT = 0;

      IF FINDFIRST THEN
        IF ReqLineWithCursor."Line No." > 0 THEN
          Rec := ReqLineWithCursor;

      SetRecFilters;
    END;

    LOCAL PROCEDURE FindReqLineForCursor@22(VAR ReqLineWithCursor@1000 : Record 246;ActualReqLine@1001 : Record 246);
    BEGIN
      IF ProdOrder."No." = '' THEN
        EXIT;

      IF (ActualReqLine."Demand Type" = DATABASE::"Prod. Order Component") AND
         (ActualReqLine."Demand Subtype" = ProdOrder.Status) AND
         (ActualReqLine."Demand Order No." = ProdOrder."No.")
      THEN
        ReqLineWithCursor := ActualReqLine;
    END;

    LOCAL PROCEDURE RefreshTempTable@14();
    VAR
      TempReqLine2@1001 : Record 246;
      ReqLine@1000 : Record 246;
    BEGIN
      TempReqLine2.COPY(Rec);

      RESET;
      IF FIND('-') THEN
        REPEAT
          ReqLine := Rec;
          IF NOT ReqLine.FIND OR
             ((Level = 0) AND ((ReqLine.NEXT = 0) OR (ReqLine.Level = 0)))
          THEN BEGIN
            IF Level = 0 THEN BEGIN
              ReqLine := Rec;
              ReqLine.FIND;
              ReqLine.DELETE(TRUE);
            END;
            DELETE
          END;
        UNTIL NEXT = 0;

      COPY(TempReqLine2);
    END;

    [External]
    PROCEDURE SetRecFilters@5();
    BEGIN
      RESET;
      FILTERGROUP(2);
      SETRANGE("User ID",USERID);
      SETRANGE("Worksheet Template Name",'');

      CASE DemandOrderFilter OF
        DemandOrderFilter::"All Demands":
          BEGIN
            SETRANGE("Demand Type");
            SETCURRENTKEY("User ID","Worksheet Template Name","Journal Batch Name","Line No.");
          END;
        DemandOrderFilter::"Sales Demand":
          BEGIN
            SETRANGE("Demand Type",DATABASE::"Sales Line");
            SETCURRENTKEY("User ID","Demand Type","Worksheet Template Name","Journal Batch Name","Line No.");
          END;
        DemandOrderFilter::"Production Demand":
          BEGIN
            SETRANGE("Demand Type",DATABASE::"Prod. Order Component");
            SETCURRENTKEY("User ID","Demand Type","Worksheet Template Name","Journal Batch Name","Line No.");
          END;
        DemandOrderFilter::"Assembly Demand":
          BEGIN
            SETRANGE("Demand Type",DATABASE::"Assembly Line");
            SETCURRENTKEY("User ID","Demand Type","Worksheet Template Name","Journal Batch Name","Line No.");
          END;
        DemandOrderFilter::"Service Demand":
          BEGIN
            SETRANGE("Demand Type",DATABASE::"Service Line");
            SETCURRENTKEY("User ID","Demand Type","Worksheet Template Name","Journal Batch Name","Line No.");
          END;
        DemandOrderFilter::"Job Demand":
          BEGIN
            SETRANGE("Demand Type",DATABASE::"Job Planning Line");
            SETCURRENTKEY("User ID","Demand Type","Worksheet Template Name","Journal Batch Name","Line No.");
          END;
      END;
      FILTERGROUP(0);

      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ShowDemandOrder@15();
    VAR
      SalesHeader@1001 : Record 36;
      ProdOrder@1000 : Record 5405;
      ServHeader@1002 : Record 5900;
      Job@1003 : Record 167;
      AsmHeader@1004 : Record 900;
    BEGIN
      CASE "Demand Type" OF
        DATABASE::"Sales Line":
          BEGIN
            SalesHeader.GET("Demand Subtype","Demand Order No.");
            CASE SalesHeader."Document Type" OF
              SalesHeader."Document Type"::Order:
                PAGE.RUN(PAGE::"Sales Order",SalesHeader);
              SalesHeader."Document Type"::"Return Order":
                PAGE.RUN(PAGE::"Sales Return Order",SalesHeader);
            END;
          END;
        DATABASE::"Prod. Order Component":
          BEGIN
            ProdOrder.GET("Demand Subtype","Demand Order No.");
            CASE ProdOrder.Status OF
              ProdOrder.Status::Planned:
                PAGE.RUN(PAGE::"Planned Production Order",ProdOrder);
              ProdOrder.Status::"Firm Planned":
                PAGE.RUN(PAGE::"Firm Planned Prod. Order",ProdOrder);
              ProdOrder.Status::Released:
                PAGE.RUN(PAGE::"Released Production Order",ProdOrder);
            END;
          END;
        DATABASE::"Assembly Line":
          BEGIN
            AsmHeader.GET("Demand Subtype","Demand Order No.");
            CASE AsmHeader."Document Type" OF
              AsmHeader."Document Type"::Order:
                PAGE.RUN(PAGE::"Assembly Order",AsmHeader);
            END;
          END;
        DATABASE::"Service Line":
          BEGIN
            ServHeader.GET("Demand Subtype","Demand Order No.");
            CASE ServHeader."Document Type" OF
              ServHeader."Document Type"::Order:
                PAGE.RUN(PAGE::"Service Order",ServHeader);
            END;
          END;
        DATABASE::"Job Planning Line":
          BEGIN
            Job.GET("Demand Order No.");
            CASE Job.Status OF
              Job.Status::Open:
                PAGE.RUN(PAGE::"Job Card",Job);
            END;
          END;
      END;
    END;

    LOCAL PROCEDURE CalcItemAvail@16();
    BEGIN
      QtyOnOtherLocations := CalcQtyOnOtherLocations;
      SubstitionAvailable := CalcSubstitionAvailable;
      QtyATP := CalcQtyATP;
      EarliestShptDateAvailable := CalcEarliestShptDateAvailable;
    END;

    LOCAL PROCEDURE CalcQtyOnOtherLocations@6() : Decimal;
    VAR
      QtyOnOtherLocation@1000 : Decimal;
    BEGIN
      IF "No." = '' THEN
        EXIT;

      QtyOnOtherLocation := OrderPlanningMgt.AvailQtyOnOtherLocations(Rec); // Base Unit
      IF "Qty. per Unit of Measure" = 0 THEN
        "Qty. per Unit of Measure" := 1;
      QtyOnOtherLocation := ROUND(QtyOnOtherLocation / "Qty. per Unit of Measure",0.00001);

      EXIT(QtyOnOtherLocation);
    END;

    LOCAL PROCEDURE CalcQtyATP@8() : Decimal;
    VAR
      QtyATP@1000 : Decimal;
    BEGIN
      IF "No." = '' THEN
        EXIT;

      QtyATP := OrderPlanningMgt.CalcATPQty("No.","Variant Code","Location Code","Demand Date"); // Base Unit
      IF "Qty. per Unit of Measure" = 0 THEN
        "Qty. per Unit of Measure" := 1;
      QtyATP := ROUND(QtyATP / "Qty. per Unit of Measure",0.00001);

      EXIT(QtyATP);
    END;

    LOCAL PROCEDURE CalcEarliestShptDateAvailable@9() : Date;
    VAR
      Item@1000 : Record 27;
    BEGIN
      IF "No." = '' THEN
        EXIT;

      Item.GET("No.");
      IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." THEN
        EXIT;

      EXIT(OrderPlanningMgt.CalcATPEarliestDate("No.","Variant Code","Location Code","Demand Date","Quantity (Base)"));
    END;

    LOCAL PROCEDURE CalcSubstitionAvailable@11() : Boolean;
    BEGIN
      IF "No." = '' THEN
        EXIT;

      EXIT(OrderPlanningMgt.SubstitutionPossible(Rec));
    END;

    LOCAL PROCEDURE CalcPlan@13();
    VAR
      ReqLine@1001 : Record 246;
    BEGIN
      RESET;
      DELETEALL;

      CLEAR(OrderPlanningMgt);
      CASE DemandOrderFilter OF
        DemandOrderFilter::"Sales Demand":
          OrderPlanningMgt.SetSalesOrder;
        DemandOrderFilter::"Assembly Demand":
          OrderPlanningMgt.SetAsmOrder;
        DemandOrderFilter::"Production Demand":
          OrderPlanningMgt.SetProdOrder;
        DemandOrderFilter::"Service Demand":
          OrderPlanningMgt.SetServOrder;
        DemandOrderFilter::"Job Demand":
          OrderPlanningMgt.SetJobOrder;
      END;
      OrderPlanningMgt.GetOrdersToPlan(ReqLine);

      InitTempRec;
    END;

    LOCAL PROCEDURE UpdateSupplyFrom@17();
    BEGIN
      SupplyFromEditable := NOT ("Replenishment System" IN ["Replenishment System"::"Prod. Order",
                                                            "Replenishment System"::Assembly]);
    END;

    LOCAL PROCEDURE DemandOrderFilterOnAfterValida@19021326();
    BEGIN
      CurrPage.SAVERECORD;
      SetRecFilters;
    END;

    LOCAL PROCEDURE ReplenishmentSystemOnAfterVali@19026301();
    BEGIN
      UpdateSupplyFrom;
    END;

    LOCAL PROCEDURE StatusTextOnFormat@19078586(VAR Text@19010365 : Text[1024]);
    BEGIN
      IF "Demand Line No." = 0 THEN
        CASE "Demand Type" OF
          DATABASE::"Prod. Order Component":
            BEGIN
              ProdOrder.Status := Status;
              Text := FORMAT(ProdOrder.Status);
            END;
          DATABASE::"Sales Line":
            BEGIN
              SalesHeader.Status := Status;
              Text := FORMAT(SalesHeader.Status);
            END;
          DATABASE::"Service Line":
            BEGIN
              ServHeader.INIT;
              ServHeader.Status := Status;
              Text := FORMAT(ServHeader.Status);
            END;
          DATABASE::"Job Planning Line":
            BEGIN
              Job.INIT;
              Job.Status := Status;
              Text := FORMAT(Job.Status);
            END;
          DATABASE::"Assembly Line":
            BEGIN
              AsmHeader.Status := Status;
              Text := FORMAT(AsmHeader.Status);
            END;
        END;

      StatusHideValue := "Demand Line No." <> 0;
    END;

    LOCAL PROCEDURE DemandTypeTextOnFormat@19059433(VAR Text@19044954 : Text[1024]);
    BEGIN
      IF "Demand Line No." = 0 THEN
        CASE "Demand Type" OF
          DATABASE::"Sales Line":
            Text := Text001;
          DATABASE::"Prod. Order Component":
            Text := Text002;
          DATABASE::"Service Line":
            Text := Text003;
          DATABASE::"Job Planning Line":
            Text := Text004;
          DATABASE::"Assembly Line":
            Text := Text005;
        END;

      DemandTypeHideValue := "Demand Line No." <> 0;
      DemandTypeEmphasize := Level = 0;
    END;

    LOCAL PROCEDURE DemandSubtypeTextOnFormat@19071287(VAR Text@19000137 : Text[1024]);
    BEGIN
      CASE "Demand Type" OF
        DATABASE::"Prod. Order Component":
          BEGIN
            ProdOrder.Status := Status;
            Text := FORMAT(ProdOrder.Status);
          END;
        DATABASE::"Sales Line":
          BEGIN
            SalesHeader."Document Type" := "Demand Subtype";
            Text := FORMAT(SalesHeader."Document Type");
          END;
        DATABASE::"Service Line":
          BEGIN
            ServHeader."Document Type" := "Demand Subtype";
            Text := FORMAT(ServHeader."Document Type");
          END;
        DATABASE::"Job Planning Line":
          BEGIN
            Job.Status := Status;
            Text := FORMAT(Job.Status);
          END;
        DATABASE::"Assembly Line":
          BEGIN
            AsmHeader."Document Type" := "Demand Subtype";
            Text := FORMAT(AsmHeader."Document Type");
          END;
      END
    END;

    LOCAL PROCEDURE DemandOrderNoOnFormat@19021785();
    BEGIN
      DemandOrderNoHideValue := "Demand Line No." <> 0;
      DemandOrderNoEmphasize := Level = 0;
    END;

    LOCAL PROCEDURE DescriptionOnFormat@19023855();
    BEGIN
      DescriptionIndent := Level + "Planning Level";
      DescriptionEmphasize := Level = 0;
    END;

    LOCAL PROCEDURE DemandQuantityOnFormat@19031262();
    BEGIN
      DemandQuantityHideValue := Level = 0;
    END;

    LOCAL PROCEDURE DemandQtyAvailableOnFormat@19015974();
    BEGIN
      DemandQtyAvailableHideValue := Level = 0;
    END;

    LOCAL PROCEDURE ReplenishmentSystemOnFormat@19008444();
    BEGIN
      ReplenishmentSystemHideValue := "Replenishment System" = "Replenishment System"::" ";
    END;

    LOCAL PROCEDURE QuantityOnFormat@19071269();
    BEGIN
      QuantityHideValue := Level = 0;
    END;

    LOCAL PROCEDURE ReserveOnFormat@26();
    BEGIN
      ReserveEditable := Level <> 0;
    END;

    BEGIN
    END.
  }
}

