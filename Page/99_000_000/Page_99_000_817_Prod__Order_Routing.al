OBJECT Page 99000817 Prod. Order Routing
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Prod.ordrerute;
               ENU=Prod. Order Routing];
    SourceTable=Table5409;
    DataCaptionExpr=Caption;
    PageType=List;
    OnInit=BEGIN
             ProdOrderNoVisible := TRUE;
           END;

    OnOpenPage=BEGIN
                 ProdOrderNoVisible := TRUE;
                 IF GETFILTER("Prod. Order No.") <> '' THEN
                   ProdOrderNoVisible := GETRANGEMIN("Prod. Order No.") <> GETRANGEMAX("Prod. Order No.");
               END;

    OnDeleteRecord=BEGIN
                     CheckPreviousAndNext;
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 30      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000840;
                      RunPageLink=Status=FIELD(Status),
                                  Prod. Order No.=FIELD(Prod. Order No.),
                                  Routing Reference No.=FIELD(Routing Reference No.),
                                  Routing No.=FIELD(Routing No.),
                                  Operation No.=FIELD(Operation No.);
                      Image=ViewComments }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=V‘rkt›jer;
                                 ENU=Tools];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om funktioner, der g‘lder for operationer, der repr‘senterer standardopgaven.;
                                 ENU=View or edit information about tools that apply to operations that represent the standard task.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000844;
                      RunPageLink=Status=FIELD(Status),
                                  Prod. Order No.=FIELD(Prod. Order No.),
                                  Routing Reference No.=FIELD(Routing Reference No.),
                                  Routing No.=FIELD(Routing No.),
                                  Operation No.=FIELD(Operation No.);
                      Image=Tools }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Medarbejdere;
                                 ENU=Personnel];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om personale, der g‘lder for operationer, der repr‘senterer standardopgaven.;
                                 ENU=View or edit information about personnel that applies to operations that represent the standard task.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000845;
                      RunPageLink=Status=FIELD(Status),
                                  Prod. Order No.=FIELD(Prod. Order No.),
                                  Routing Reference No.=FIELD(Routing Reference No.),
                                  Routing No.=FIELD(Routing No.),
                                  Operation No.=FIELD(Operation No.);
                      Image=User }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Kvalitetsm†l;
                                 ENU=Quality Measures];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om kvalitetsm†l, der g‘lder for operationer, der repr‘senterer standardopgaven.;
                                 ENU=View or edit information about quality measures that apply to operations that represent the standard task.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000834;
                      RunPageLink=Status=FIELD(Status),
                                  Prod. Order No.=FIELD(Prod. Order No.),
                                  Routing Reference No.=FIELD(Routing Reference No.),
                                  Routing No.=FIELD(Routing No.),
                                  Operation No.=FIELD(Operation No.);
                      Image=TaskQualityMeasure }
      { 57      ;2   ;Action    ;
                      CaptionML=[DAN=Allokeret kapacitet;
                                 ENU=Allocated Capacity];
                      ToolTipML=[DAN=Vis kapacitetsbehovet, som er summen af ops‘tningstid og operationstid. Operationstiden er lig med operationstiden pr. styk ganget med antallet i produktionsordren.;
                                 ENU=View the capacity need, which is the sum of the setup time and the run time. The run time is equal to the run time per piece multiplied by the number of pieces in the production order.];
                      ApplicationArea=#Manufacturing;
                      Image=AllocatedCapacity;
                      OnAction=VAR
                                 ProdOrderCapNeed@1001 : Record 5410;
                               BEGIN
                                 IF Status = Status::Finished THEN
                                   EXIT;
                                 ProdOrderCapNeed.SETCURRENTKEY(Type,"No.","Starting Date-Time");
                                 ProdOrderCapNeed.SETRANGE(Type,Type);
                                 ProdOrderCapNeed.SETRANGE("No.","No.");
                                 ProdOrderCapNeed.SETRANGE(Date,"Starting Date","Ending Date");
                                 ProdOrderCapNeed.SETRANGE("Prod. Order No.","Prod. Order No.");
                                 ProdOrderCapNeed.SETRANGE(Status,Status);
                                 ProdOrderCapNeed.SETRANGE("Routing Reference No.","Routing Reference No.");
                                 ProdOrderCapNeed.SETRANGE("Operation No.","Operation No.");

                                 PAGE.RUNMODAL(0,ProdOrderCapNeed);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=Ordre&sporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den dertil h›rende eftersp›rgsel. P† denne m†de kan du finde den oprindelige eftersp›rgsel, der medf›rte en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#Manufacturing;
                      Image=OrderTracking;
                      OnAction=VAR
                                 ProdOrderLine@1001 : Record 5406;
                                 TrackingForm@1002 : Page 99000822;
                               BEGIN
                                 ProdOrderLine.SETRANGE(Status,Status);
                                 ProdOrderLine.SETRANGE("Prod. Order No.","Prod. Order No.");
                                 ProdOrderLine.SETRANGE("Routing No.","Routing No.");
                                 IF ProdOrderLine.FINDFIRST THEN BEGIN
                                   TrackingForm.SetProdOrderLine(ProdOrderLine);
                                   TrackingForm.RUNMODAL;
                                 END;
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

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Prod. Order No.";
                Visible=ProdOrderNoVisible }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den underliggende kapacitet skal genberegnes, hver gang der foretages en ‘ndring af ruteplanen.;
                           ENU=Specifies that the underlying capacity need is recalculated each time a change is made in the schedule of the routing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Schedule Manually";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationsnummeret.;
                           ENU=Specifies the operation number.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Operation No." }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forrige operationsnummer.;
                           ENU=Specifies the previous operation number.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Previous Operation No.";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det n‘ste operationsnummer.;
                           ENU=Specifies the next operation number.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Next Operation No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationstypen.;
                           ENU=Specifies the type of operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Type }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af operationen.;
                           ENU=Specifies the description of the operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan forbruget af varen (komponenten) beregnes og h†ndteres i produktionsprocesserne. Manuelt: Angiv og bogf›r forbrug i forbrugskladden manuelt. Fremad: Bogf›rer automatisk forbrug if›lge produktionsordrekomponentlinjerne, n†r den f›rste handling starter. Bagl‘ns: Beregner og bogf›rer automatisk forbrug if›lge produktionsordrekomponentlinjerne, n†r produktionsordren er f‘rdig. Pluk + Fremad / Pluk + Bagl‘ns: Variationer med lagersted.;
                           ENU=Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Flushing Method";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Startdato/tidspunkt.;
                           ENU=Specifies the starting date and the starting time, which are combined in a format called "starting date-time".];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Date-Time" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl‘ttet for rutelinjen (operationen).;
                           ENU=Specifies the starting time of the routing line (operation).];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Time";
                Visible=FALSE;
                OnValidate=BEGIN
                             StartingTimeOnAfterValidate;
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for rutelinjen (operationen).;
                           ENU=Specifies the starting date of the routing line (operation).];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Date";
                Visible=FALSE;
                OnValidate=BEGIN
                             StartingDateOnAfterValidate;
                           END;
                            }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Slutdato/tidspunkt.;
                           ENU=Specifies the ending date and the ending time, which are combined in a format called "ending date-time".];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Date-Time" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutklokkesl‘ttet for rutelinjen (operationen).;
                           ENU=Specifies the ending time of the routing line (operation).];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Time";
                Visible=FALSE;
                OnValidate=BEGIN
                             EndingTimeOnAfterValidate;
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for rutelinjen (operationen).;
                           ENU=Specifies the ending date of the routing line (operation).];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Date";
                Visible=FALSE;
                OnValidate=BEGIN
                             EndingDateOnAfterValidate;
                           END;
                            }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opstillingstiden for operationen.;
                           ENU=Specifies the setup time of the operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Setup Time" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationstiden for operationen.;
                           ENU=Specifies the run time of the operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Run Time" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ventetiden efter behandling.;
                           ENU=Specifies the wait time after processing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Wait Time" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transporttiden.;
                           ENU=Specifies the move time.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Move Time" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det faste spildantal.;
                           ENU=Specifies the fixed scrap quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Fixed Scrap Quantity";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en rutebindingskode.;
                           ENU=Specifies a routing link code.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing Link Code";
                Visible=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver spildfaktoren i procent.;
                           ENU=Specifies the scrap factor in percent.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap Factor %";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver send ahead-antallet for operationen.;
                           ENU=Specifies the send-ahead quantity of the operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Send-Ahead Quantity";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samtidige kapacitet for operationen.;
                           ENU=Specifies the con capacity of the operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Concurrent Capacities";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationens kostpris, hvis den er forskellig fra kostprisen p† arbejdscenter- eller produktionsressourcekortet.;
                           ENU=Specifies the unit cost for this operation if it is different than the unit cost on the work center or machine center card.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit Cost per";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de samlede driftsudgifter. Den beregnes automatisk ud fra kapacitetsbehovet, n†r en produktionsordre fornys eller omplanl‘gges.;
                           ENU=Specifies the total cost of operations. It is automatically calculated from the capacity need, when a production order is refreshed or replanned.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Expected Operation Cost Amt.";
                Visible=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den indirekte kapacitetskostpris. Den beregnes automatisk ud fra kapacitetsbehovet, n†r en produktionsordre fornys eller omplanl‘gges.;
                           ENU=Specifies the capacity overhead. It is automatically calculated from the capacity need, when a production order is refreshed or replanned.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Expected Capacity Ovhd. Cost";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                Name=Expected Capacity Need;
                CaptionML=[DAN=Forventet kapacitetsbehov;
                           ENU=Expected Capacity Need];
                ToolTipML=[DAN=Angiver det forventede kapacitetsbehov for produktionsordren.;
                           ENU=Specifies the expected capacity need for the production order.];
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr="Expected Capacity Need" / ExpCapacityNeed;
                Visible=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for rutelinjen som f.eks. Planlagt, Igangsat eller Udf›rt.;
                           ENU=Specifies the status of the routing line, such as Planned, In Progress, or Finished.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing Status";
                Visible=FALSE }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, hvor produktionsressourcen eller arbejdscenteret p† produktionsordrerutelinjen opererer.;
                           ENU=Specifies the location where the machine or work center on the production order routing line operates.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tilsvarende placering p† produktionsressourcen eller arbejdscenteret, hvis lokationskoden svarer til ops‘tningen af produktionsressourcen eller arbejdscenteret.;
                           ENU=Specifies the corresponding bin at the machine or work center, if the location code matches the setup of that machine or work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Open Shop Floor Bin Code";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, der indeholder komponenter med en tr‘kmetode, som involverer en lageraktivitet for at f›re varerne til placeringen.;
                           ENU=Specifies the bin that holds components with a flushing method, that involves a warehouse activity to bring the items to the bin.];
                ApplicationArea=#Manufacturing;
                SourceExpr="To-Production Bin Code";
                Visible=FALSE }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tilsvarende placering p† produktionsressourcen eller arbejdscenteret, hvis lokationskoden svarer til ops‘tningen af produktionsressourcen eller arbejdscenteret.;
                           ENU=Specifies the corresponding bin at the machine or work center if the location code matches the setup of that machine or work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="From-Production Bin Code";
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
    VAR
      ProdOrderNoVisible@19039876 : Boolean INDATASET;

    LOCAL PROCEDURE ExpCapacityNeed@2() : Decimal;
    VAR
      WorkCenter@1001 : Record 99000754;
      CalendarMgt@1000 : Codeunit 99000755;
    BEGIN
      IF "Work Center No." = '' THEN
        EXIT(1);
      WorkCenter.GET("Work Center No.");
      EXIT(CalendarMgt.TimeFactor(WorkCenter."Unit of Measure Code"));
    END;

    LOCAL PROCEDURE StartingTimeOnAfterValidate@19008557();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE StartingDateOnAfterValidate@19020273();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE EndingTimeOnAfterValidate@19075483();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE EndingDateOnAfterValidate@19076447();
    BEGIN
      CurrPage.UPDATE;
    END;

    [External]
    PROCEDURE Initialize@1(NewCaption@1000 : Text);
    BEGIN
      CurrPage.CAPTION(NewCaption);
    END;

    BEGIN
    END.
  }
}

