OBJECT Page 99000852 Planning Worksheet
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Planl‘gningskladde;
               ENU=Planning Worksheet];
    SaveValues=Yes;
    MultipleNewLines=Yes;
    SourceTable=Table246;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=VAR
                 JnlSelected@1000 : Boolean;
               BEGIN
                 OpenedFromBatch := ("Journal Batch Name" <> '') AND ("Worksheet Template Name" = '');
                 IF OpenedFromBatch THEN BEGIN
                   CurrentWkshBatchName := "Journal Batch Name";
                   ReqJnlManagement.OpenJnl(CurrentWkshBatchName,Rec);
                   EXIT;
                 END;
                 ReqJnlManagement.TemplateSelection(PAGE::"Planning Worksheet",FALSE,2,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 ReqJnlManagement.OpenJnl(CurrentWkshBatchName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       DescriptionIndent := 0;
                       ShowShortcutDimCode(ShortcutDimCode);
                       StartingDateTimeOnFormat;
                       StartingDateOnFormat;
                       DescriptionOnFormat;
                       RefOrderNoOnFormat;
                       PlanningWarningLevel1OnFormat;
                     END;

    OnNewRecord=BEGIN
                  SetUpNewLine(Rec);
                  Type := Type::Item;
                  CLEAR(ShortcutDimCode);
                END;

    OnDeleteRecord=BEGIN
                     "Accept Action Message" := FALSE;
                     DeleteMultiLevel;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           PlanningWkshManagement.GetDescriptionAndRcptName(Rec,ItemDescription,RoutingDescription);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 110     ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 6500    ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p† bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
                               END;
                                }
      { 48      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      Image=Item }
      { 53      ;2   ;Action    ;
                      CaptionML=[DAN=Komponenter;
                                 ENU=Components];
                      ToolTipML=[DAN=F† vist eller rediger produktionsordrekomponenterne for den overordnede vare p† linjen.;
                                 ENU=View or edit the production order components of the parent item on the line.];
                      ApplicationArea=#Planning;
                      RunObject=Page 99000862;
                      RunPageLink=Worksheet Template Name=FIELD(Worksheet Template Name),
                                  Worksheet Batch Name=FIELD(Journal Batch Name),
                                  Worksheet Line No.=FIELD(Line No.);
                      Image=Components }
      { 54      ;2   ;Action    ;
                      CaptionML=[DAN=R&ute;
                                 ENU=Ro&uting];
                      ToolTipML=[DAN=F† vist eller rediger operationslisten for den overordnede vare p† linjen.;
                                 ENU=View or edit the operations list of the parent item on the line.];
                      ApplicationArea=#Planning;
                      RunObject=Page 99000863;
                      RunPageLink=Worksheet Template Name=FIELD(Worksheet Template Name),
                                  Worksheet Batch Name=FIELD(Journal Batch Name),
                                  Worksheet Line No.=FIELD(Line No.);
                      Image=Route }
      { 49      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Varedisponering pr.;
                                 ENU=&Item Availability by];
                      Image=ItemAvailability }
      { 5       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Planning;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByEvent)
                               END;
                                }
      { 65      ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m†ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Planning;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByPeriod)
                               END;
                                }
      { 66      ;3   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByVariant)
                               END;
                                }
      { 67      ;3   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByLocation)
                               END;
                                }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F† vist tilg‘ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p† tilg‘ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByBOM)
                               END;
                                }
      { 7       ;3   ;Action    ;
                      CaptionML=[DAN=Tidslinje;
                                 ENU=Timeline];
                      ToolTipML=[DAN=F† en grafisk visning af en vares planlagte lager baseret p† fremtidige udbuds- og eftersp›rgselsh‘ndelser med eller uden planl‘gningsforslag. Resultatet er en grafisk gengivelse af lagerprofilen.;
                                 ENU=Get a graphical view of an item's projected inventory based on future supply and demand events, with or without planning suggestions. The result is a graphical representation of the inventory profile.];
                      ApplicationArea=#Planning;
                      Image=Timeline;
                      OnAction=BEGIN
                                 ShowTimeline(Rec);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 106     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent aktionsmeddelelser;
                                 ENU=Get &Action Messages];
                      ToolTipML=[DAN=F† en umiddelbar visning af resultatet af plan‘ndringer uden at k›re en total om- eller nettoplanl‘gningsproces. Denne funktion kan bruges som et kortfristet planl‘gningsv‘rkt›j ved at udstede handlingsmeddelelser for at g›re brugeren opm‘rksom p† eventuelle ‘ndringer, der er foretaget siden den sidste oml‘gnings- eller nettoplan blev beregnet.;
                                 ENU=Obtain an immediate view of the effect of schedule changes, without running a regenerative or net change planning process. This function serves as a short-term planning tool by issuing action messages to alert the user of any modifications made since the last regenerative or net change plan was calculated.];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      Image=GetActionMessages;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 GetActionMessages;

                                 IF NOT FIND('-') THEN
                                   SetUpNewLine(Rec);
                               END;
                                }
      { 109     ;2   ;Separator ;
                      CaptionML=[DAN="";
                                 ENU=""] }
      { 101     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Beregn &nettoplan;
                                 ENU=Calculate &Net Change Plan];
                      ToolTipML=[DAN=Planl‘g kun for varer, der har f›lgende typer ‘ndringer af deres eftersp›rgsels- og udbudsm›nster siden sidste planl‘gning blev k›rt: 1) ‘ndring i behov for varen, f.eks. budget, salg eller komponentlinjer. 2) ’ndringer i stamdata eller i det planlagte udbud af varen, f.eks. ‘ndringer af styklisten eller ruten, ‘ndringer i planl‘gningsparametre eller afvigelser i lagerbeholdningen.;
                                 ENU=Plan only for items that had the following types of changes to their demand-supply pattern since the last planning run: 1) Change in demand for the item, such as forecast, sales, or component lines. 2) Change in the master data or in the planned supply for the item, such as changes to the BOM or routing, changes to planning parameters, or unplanned inventory differences.];
                      ApplicationArea=#Planning;
                      Image=CalculatePlanChange;
                      OnAction=VAR
                                 CalcPlan@1001 : Report 99001017;
                               BEGIN
                                 CalcPlan.SetTemplAndWorksheet("Worksheet Template Name","Journal Batch Name",FALSE);
                                 CalcPlan.RUNMODAL;

                                 IF NOT FIND('-') THEN
                                   SetUpNewLine(Rec);

                                 CLEAR(CalcPlan);
                               END;
                                }
      { 102     ;2   ;Action    ;
                      Name=CalculateRegenerativePlan;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Beregn totalplan;
                                 ENU=Calculate Regenerative Plan];
                      ToolTipML=[DAN=Planl‘g for alle varer, uanset ‘ndringer siden forrige k›rsel. Du beregner en totalplan, n†r der er ‘ndringer i stamdata eller kapacitet, f.eks. produktionskalendere, der p†virker alle varer og derfor hele forsyningsplanen.;
                                 ENU=Plan for all items, regardless of changes since the previous planning run. You calculate a regenerative plan when there are changes to master data or capacity, such as shop calendars, that affect all items and therefore the whole supply plan.];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      Image=CalculateRegenerativePlan;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CalcPlan@1001 : Report 99001017;
                               BEGIN
                                 CalcPlan.SetTemplAndWorksheet("Worksheet Template Name","Journal Batch Name",TRUE);
                                 CalcPlan.RUNMODAL;

                                 IF NOT FIND('-') THEN
                                   SetUpNewLine(Rec);

                                 CLEAR(CalcPlan);
                               END;
                                }
      { 32      ;2   ;Separator  }
      { 23      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Opdater planl‘gningslinje;
                                 ENU=Re&fresh Planning Line];
                      ToolTipML=[DAN=Opdater den valgte planl‘gningslinje med eventuelle ‘ndringer, der er foretaget af planl‘gningskomponenter og rutelinjer, siden planl‘gningslinjen blev oprettet.;
                                 ENU=Update the selected planning line with any changes that are made to planning components and routing lines since the planning line was created.];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      Image=RefreshPlanningLine;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ReqLine@1001 : Record 246;
                               BEGIN
                                 ReqLine.SETRANGE("Worksheet Template Name","Worksheet Template Name");
                                 ReqLine.SETRANGE("Journal Batch Name","Journal Batch Name");
                                 ReqLine.SETRANGE("Line No.","Line No.");

                                 REPORT.RUNMODAL(REPORT::"Refresh Planning Demand",TRUE,FALSE,ReqLine);
                               END;
                                }
      { 42      ;2   ;Separator  }
      { 114     ;2   ;Action    ;
                      CaptionML=[DAN=Hent fejllo&g;
                                 ENU=&Get Error Log];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om planl‘gningslinjer med en v‘rdi i feltet Advarsel.;
                                 ENU=View detailed information for planning lines with a value in the Warning field.];
                      ApplicationArea=#Planning;
                      RunObject=Page 5430;
                      RunPageLink=Worksheet Template Name=FIELD(Worksheet Template Name),
                                  Journal Batch Name=FIELD(Journal Batch Name);
                      Image=ErrorLog }
      { 113     ;2   ;Separator  }
      { 59      ;2   ;Action    ;
                      Name=CarryOutActionMessage;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udf›r aktionsmeddelelse;
                                 ENU=Carry &Out Action Message];
                      ToolTipML=[DAN=Brug en k›rsel som hj‘lp til at oprette faktiske forsyningsordrer ud fra ordreforslagene.;
                                 ENU=Use a batch job to help you create actual supply orders from the order proposals.];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      Image=CarryOutActionMessage;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PerformAction.SetReqWkshLine(Rec);
                                 PerformAction.RUNMODAL;
                                 CLEAR(PerformAction);
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 19      ;2   ;Separator  }
      { 62      ;2   ;Action    ;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserver den n›dvendige m‘ngde p† den bilagslinje, som vinduet blev †bnet for.;
                                 ENU=Reserve the quantity that is required on the document line that you opened this window for.];
                      ApplicationArea=#Planning;
                      Image=Reserve;
                      OnAction=BEGIN
                                 CurrPage.SAVERECORD;
                                 ShowReservation;
                               END;
                                }
      { 18      ;2   ;Action    ;
                      Name=OrderTracking;
                      CaptionML=[DAN=Ordre&sporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den dertil h›rende eftersp›rgsel. P† denne m†de kan du finde den oprindelige eftersp›rgsel, der medf›rte en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      Image=OrderTracking;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 TrackingForm@1001 : Page 99000822;
                               BEGIN
                                 TrackingForm.SetReqLine(Rec);
                                 TrackingForm.RUNMODAL;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 69  ;1   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† kladdek›rslen for planl‘gningskladden.;
                           ENU=Specifies the name of the journal batch of the planning worksheet.];
                ApplicationArea=#Planning;
                SourceExpr=CurrentWkshBatchName;
                OnValidate=BEGIN
                             ReqJnlManagement.CheckName(CurrentWkshBatchName,Rec);
                             CurrentWkshBatchNameOnAfterVal;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           ReqJnlManagement.LookupName(CurrentWkshBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                IndentationColumnName=DescriptionIndent;
                IndentationControls=Description;
                GroupType=Repeater }

    { 118 ;2   ;Field     ;
                Name=Warning;
                CaptionML=[DAN=Advarsel;
                           ENU=Warning];
                ToolTipML=[DAN=Angiver en advarselstekst for alle planl‘gningslinjer, der oprettes for en us‘dvanlig situation.;
                           ENU=Specifies a warning text for any planning line that is created for an unusual situation.];
                OptionCaptionML=[DAN=" ,N›dsituation,Undtagelse,Opm‘rksomhed";
                                 ENU=" ,Emergency,Exception,Attention"];
                ApplicationArea=#Planning;
                SourceExpr=Warning;
                Editable=False;
                OnDrillDown=BEGIN
                              PlanningTransparency.SetCurrReqLine(Rec);
                              PlanningTransparency.DrillDownUntrackedQty('');
                            END;
                             }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type indk›bskladdelinje, du vil oprette.;
                           ENU=Specifies the type of requisition worksheet line you are creating.];
                ApplicationArea=#Planning;
                SourceExpr=Type;
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Planning;
                SourceExpr="No.";
                OnValidate=BEGIN
                             PlanningWkshManagement.GetDescriptionAndRcptName(Rec,ItemDescription,RoutingDescription);
                           END;
                            }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en handling for at genoprette balancen i forholdet mellem udbud og eftersp›rgsel.;
                           ENU=Specifies an action to take to rebalance the demand-supply situation.];
                ApplicationArea=#Planning;
                SourceExpr="Action Message" }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den aktionsmeddelelse, som foresl†s for linjen, skal godkendes.;
                           ENU=Specifies whether to accept the action message proposed for the line.];
                ApplicationArea=#Planning;
                SourceExpr="Accept Action Message" }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forfaldsdato, der er anf›rt p† produktions- eller k›bsordren, n†r en aktionsmeddelelse foresl†r omplanl‘gning af en ordre.;
                           ENU=Specifies the due date stated on the production or purchase order, when an action message proposes to reschedule an order.];
                ApplicationArea=#Planning;
                SourceExpr="Original Due Date" }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede ordre blev oprettet.;
                           ENU=Specifies the date when the related order was created.];
                ApplicationArea=#Planning;
                SourceExpr="Order Date";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du kan forvente at modtage varerne.;
                           ENU=Specifies the date when you can expect to receive the items.];
                ApplicationArea=#Planning;
                SourceExpr="Due Date" }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver afsendelsesdatoen p† overflytningsordreforslaget.;
                           ENU=Specifies the shipment date of the transfer order proposal.];
                ApplicationArea=#Location;
                SourceExpr="Transfer Shipment Date";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Startdato/tidspunkt.;
                           ENU=Specifies the starting date and the starting time, which are combined in a format called "starting date-time".];
                ApplicationArea=#Planning;
                SourceExpr="Starting Date-Time" }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl‘ttet for produktionsprocessen.;
                           ENU=Specifies the starting time of the manufacturing process.];
                ApplicationArea=#Planning;
                SourceExpr="Starting Time";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for produktionsprocessen, hvis den planlagte forsyning er en produktionsordre.;
                           ENU=Specifies the starting date of the manufacturing process, if the planned supply is a production order.];
                ApplicationArea=#Planning;
                SourceExpr="Starting Date";
                Visible=FALSE }

    { 107 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Slutdato/tidspunkt.;
                           ENU=Specifies the ending date and the ending time, which are combined in a format called "ending date-time".];
                ApplicationArea=#Planning;
                SourceExpr="Ending Date-Time" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutklokkesl‘ttet for produktionsprocessen.;
                           ENU=Specifies the ending time for the manufacturing process.];
                ApplicationArea=#Planning;
                SourceExpr="Ending Time";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for produktionsprocessen, hvis den planlagte forsyning er en produktionsordre.;
                           ENU=Specifies the ending date of the manufacturing process, if the planned supply is a production order.];
                ApplicationArea=#Planning;
                SourceExpr="Ending Date";
                Visible=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver planl‘gningsniveauet for vareposten i planl‘gningskladden.;
                           ENU=Specifies the planning level of this item entry in the planning worksheet.];
                ApplicationArea=#Planning;
                SourceExpr="Low-Level Code";
                Visible=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tekst, der beskriver posten.;
                           ENU=Specifies text that describes the entry.];
                ApplicationArea=#Planning;
                SourceExpr=Description }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ekstra tekst til beskrivelse af posten eller en bem‘rkning om indk›bskladdelinjen.;
                           ENU=Specifies additional text describing the entry, or a remark about the requisition worksheet line.];
                ApplicationArea=#Planning;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver produktionsstyklistenummeret for produktionsordren.;
                           ENU=Specifies the production BOM number for this production order.];
                ApplicationArea=#Assembly;
                SourceExpr="Production BOM No.";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver versionskoden for styklisten.;
                           ENU=Specifies the version code of the BOM.];
                ApplicationArea=#Assembly;
                SourceExpr="Production BOM Version Code";
                Visible=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rutenummeret.;
                           ENU=Specifies the routing number.];
                ApplicationArea=#Planning;
                SourceExpr="Routing No.";
                Visible=FALSE;
                OnValidate=BEGIN
                             PlanningWkshManagement.GetDescriptionAndRcptName(Rec,ItemDescription,RoutingDescription);
                           END;
                            }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver versionskoden for ruten.;
                           ENU=Specifies the version code of the routing.];
                ApplicationArea=#Planning;
                SourceExpr="Routing Version Code";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the code of the location that items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Code";
                Visible=FALSE }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lagerlokation, hvor de bestilte varer skal registreres p†.;
                           ENU=Specifies a code for an inventory location where the items that are being ordered will be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er anf›rt p† produktions- eller k›bsordren, n†r en aktionsmeddelelse foresl†r ‘ndring af antallet i en ordre.;
                           ENU=Specifies the quantity stated on the production or purchase order, when an action message proposes to change the quantity on an order.];
                ApplicationArea=#Planning;
                SourceExpr="Original Quantity" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om indk›bskladdelinjen er en MPS-ordre, dvs. om den er knyttet til et produktionsforecast eller en salgsordre.;
                           ENU=Specifies whether the requisition worksheet line is an MPS order, that is, whether it is linked to a production forecast or a sales order.];
                ApplicationArea=#Planning;
                SourceExpr="MPS Order" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder.;
                           ENU=Specifies the number of units of the item.];
                ApplicationArea=#Planning;
                SourceExpr=Quantity }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Planning;
                SourceExpr="Unit of Measure Code";
                Visible=FALSE }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken slags ordre der bruges til at oprette genbestillingsordrer og forslag.;
                           ENU=Specifies which kind of order to use to create replenishment orders and order proposals.];
                ApplicationArea=#Planning;
                SourceExpr="Replenishment System";
                Visible=FALSE }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om ordren er en k›bsordre, en produktionsordre eller en overflytningsordre.;
                           ENU=Specifies whether the order is a purchase order, a production order, or a transfer order.];
                ApplicationArea=#Planning;
                SourceExpr="Ref. Order Type" }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relevante produktions- eller indk›bsordre.;
                           ENU=Specifies the number of the relevant production or purchase order.];
                ApplicationArea=#Planning;
                SourceExpr="Ref. Order No." }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for produktionsordren.;
                           ENU=Specifies the status of the production order.];
                ApplicationArea=#Planning;
                SourceExpr="Ref. Order Status" }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† k›bs- eller produktionsordrelinjen.;
                           ENU=Specifies the number of the purchase or production order line.];
                ApplicationArea=#Planning;
                SourceExpr="Ref. Line No.";
                Visible=FALSE }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der tages h›jde for forsyningen, repr‘senteret af indk›bskladdelinjen i planl‘gningssystemet, n†r der beregnes aktionsmeddelelser.;
                           ENU=Specifies whether the supply, represented by the requisition worksheet line, is considered by the planning system, when calculating action messages.];
                ApplicationArea=#Planning;
                SourceExpr="Planning Flexibility";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen, der er blevet reserveret.;
                           ENU=Specifies how many units of this item have been reserved.];
                ApplicationArea=#Planning;
                SourceExpr="Reserved Quantity";
                Visible=FALSE;
                OnDrillDown=BEGIN
                              ShowReservationEntries(TRUE);
                            END;
                             }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Planning;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Planning;
                SourceExpr="Unit Cost";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den virksomhedsbogf›ringsgruppe, der skal bruges til varen, n†r du bogf›rer planl‘gningskladden.;
                           ENU=Specifies the code of the general business posting group to be used for the item when you post the planning worksheet.];
                ApplicationArea=#Planning;
                SourceExpr="Gen. Business Posting Group";
                Visible=FALSE }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostbel›bet for rekvisitionskladdelinjen.;
                           ENU=Specifies the total costs for the requisition worksheet line.];
                ApplicationArea=#Planning;
                SourceExpr="Cost Amount";
                Visible=FALSE }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, der skal levere varerne i k›bsordren.;
                           ENU=Specifies the number of the vendor who will ship the items in the purchase order.];
                ApplicationArea=#Planning;
                SourceExpr="Vendor No.";
                Visible=FALSE }

    { 56  ;1   ;Group      }

    { 1902454301;2;Group  ;
                GroupType=FixedLayout }

    { 1900295501;3;Group  ;
                CaptionML=[DAN=Varebeskrivelse;
                           ENU=Item Description] }

    { 57  ;4   ;Field     ;
                ApplicationArea=#Planning;
                SourceExpr=ItemDescription;
                Editable=FALSE;
                ShowCaption=No }

    { 1901312901;3;Group  ;
                CaptionML=[DAN=Rutebeskrivelse;
                           ENU=Routing Description] }

    { 70  ;4   ;Field     ;
                CaptionML=[DAN=Rutebeskrivelse;
                           ENU=Routing Description];
                ToolTipML=[DAN=Angiver en beskrivelse af ruten for den vare, der er angivet p† linjen.;
                           ENU=Specifies a description of the routing for the item that is entered on the line.];
                ApplicationArea=#Planning;
                SourceExpr=RoutingDescription;
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 9   ;1   ;Part      ;
                ApplicationArea=#Planning;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page9090;
                Visible=FALSE;
                PartType=Page }

    { 11  ;1   ;Part      ;
                ApplicationArea=#Planning;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page9091;
                PartType=Page }

    { 15  ;1   ;Part      ;
                ApplicationArea=#Planning;
                SubPageLink=Worksheet Template Name=FIELD(Worksheet Template Name),
                            Worksheet Batch Name=FIELD(Journal Batch Name),
                            Worksheet Line No.=FIELD(Line No.);
                PagePartID=Page9101;
                PartType=Page }

    { 13  ;1   ;Part      ;
                ApplicationArea=#Planning;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page9109;
                Visible=FALSE;
                PartType=Page }

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
    VAR
      PerformAction@1000 : Report 99001020;
      PlanningTransparency@1009 : Codeunit 99000856;
      ReqJnlManagement@1001 : Codeunit 330;
      PlanningWkshManagement@1002 : Codeunit 99000812;
      ItemAvailFormsMgt@1008 : Codeunit 353;
      CurrentWkshBatchName@1003 : Code[10];
      ItemDescription@1004 : Text[50];
      RoutingDescription@1005 : Text[50];
      ShortcutDimCode@1006 : ARRAY [8] OF Code[20];
      OpenedFromBatch@1007 : Boolean;
      DescriptionIndent@19057867 : Integer INDATASET;
      Warning@19070923 : ' ,Emergency,Exception,Attention';

    LOCAL PROCEDURE PlanningWarningLevel@40();
    VAR
      Transparency@1001 : Codeunit 99000856;
    BEGIN
      Warning := Transparency.ReqLineWarningLevel(Rec);
    END;

    LOCAL PROCEDURE CurrentWkshBatchNameOnAfterVal@19053116();
    BEGIN
      CurrPage.SAVERECORD;
      ReqJnlManagement.SetName(CurrentWkshBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE StartingDateTimeOnFormat@19018669();
    BEGIN
      IF ("Starting Date" < WORKDATE) AND
         ("Action Message" IN ["Action Message"::New,"Action Message"::Reschedule,"Action Message"::"Resched. & Chg. Qty."])
      THEN;
    END;

    LOCAL PROCEDURE StartingDateOnFormat@19039781();
    BEGIN
      IF "Starting Date" < WORKDATE THEN;
    END;

    LOCAL PROCEDURE DescriptionOnFormat@19023855();
    BEGIN
      DescriptionIndent := "Planning Level";
    END;

    LOCAL PROCEDURE RefOrderNoOnFormat@19059185();
    VAR
      PurchHeader@1000 : Record 38;
      TransfHeader@1003 : Record 5740;
    BEGIN
      CASE "Ref. Order Type" OF
        "Ref. Order Type"::Purchase:
          IF PurchHeader.GET(PurchHeader."Document Type"::Order,"Ref. Order No.") AND
             (PurchHeader.Status = PurchHeader.Status::Released)
          THEN;
        "Ref. Order Type"::"Prod. Order":
          ;
        "Ref. Order Type"::Transfer:
          IF TransfHeader.GET("Ref. Order No.") AND
             (TransfHeader.Status = TransfHeader.Status::Released)
          THEN;
      END;
    END;

    LOCAL PROCEDURE PlanningWarningLevel1OnFormat@19030151();
    BEGIN
      PlanningWarningLevel;
    END;

    [External]
    PROCEDURE OpenPlanningComponent@1(VAR PlanningComponent@1001 : Record 99000829);
    BEGIN
      PlanningComponent.SETRANGE("Worksheet Template Name",PlanningComponent."Worksheet Template Name");
      PlanningComponent.SETRANGE("Worksheet Batch Name",PlanningComponent."Worksheet Batch Name");
      PlanningComponent.SETRANGE("Worksheet Line No.",PlanningComponent."Worksheet Line No.");
      PAGE.RUNMODAL(PAGE::"Planning Components",PlanningComponent);
    END;

    BEGIN
    END.
  }
}

