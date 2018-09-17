OBJECT Page 99000863 Planning Routing
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Planl‘gning - rute;
               ENU=Planning Routing];
    SourceTable=Table99000830;
    DataCaptionExpr=Caption;
    DataCaptionFields=Worksheet Batch Name,Worksheet Line No.;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 37      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ru&te;
                                 ENU=&Routing];
                      Image=Route }
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=Allokeret kapacitet;
                                 ENU=Allocated Capacity];
                      ToolTipML=[DAN=Vis kapacitetsbehovet, som er summen af ops‘tningstid og operationstid. Operationstiden er lig med operationstiden pr. styk ganget med antallet i produktionsordren.;
                                 ENU=View the capacity need, which is the sum of the setup time and the run time. The run time is equal to the run time per piece multiplied by the number of pieces in the production order.];
                      ApplicationArea=#Manufacturing;
                      Image=AllocatedCapacity;
                      OnAction=VAR
                                 ProdOrderCapNeed@1000 : Record 5410;
                               BEGIN
                                 ProdOrderCapNeed.SETCURRENTKEY(Type,"No.","Starting Date-Time");
                                 ProdOrderCapNeed.SETRANGE(Type,Type);
                                 ProdOrderCapNeed.SETRANGE("No.","No.");
                                 ProdOrderCapNeed.SETRANGE(Date,"Starting Date","Ending Date");
                                 ProdOrderCapNeed.SETRANGE("Worksheet Template Name","Worksheet Template Name");
                                 ProdOrderCapNeed.SETRANGE("Worksheet Batch Name","Worksheet Batch Name");
                                 ProdOrderCapNeed.SETRANGE("Worksheet Line No.","Worksheet Line No.");
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
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Ordre&sporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den dertil h›rende eftersp›rgsel. P† denne m†de kan du finde den oprindelige eftersp›rgsel, der medf›rte en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#ItemTracking;
                      Image=OrderTracking;
                      OnAction=VAR
                                 ReqLine@1001 : Record 246;
                                 TrackingForm@1002 : Page 99000822;
                               BEGIN
                                 ReqLine.GET(
                                   "Worksheet Template Name",
                                   "Worksheet Batch Name",
                                   "Worksheet Line No.");

                                 TrackingForm.SetReqLine(ReqLine);
                                 TrackingForm.RUNMODAL;
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationsnummeret for planl‘gningsrutelinjen.;
                           ENU=Specifies the operation number for this planning routing line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Operation No." }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forrige operationsnummer og viser den operation, der blev k›rt lige f›r den aktuelle operation.;
                           ENU=Specifies the previous operation number and shows the operation that is run directly before the operation.];
                ApplicationArea=#Advanced;
                SourceExpr="Previous Operation No.";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den n‘ste operation, hvis du bruger parallelle ruter.;
                           ENU=Specifies the next operation number if you use parallel routings.];
                ApplicationArea=#Advanced;
                SourceExpr="Next Operation No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationstypen.;
                           ENU=Specifies the type of operation.];
                ApplicationArea=#Advanced;
                SourceExpr=Type }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af den opgave, der er tilknyttet rutelinjen.;
                           ENU=Specifies a description of the task related to this routing line.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Startdato/tidspunkt.;
                           ENU=Specifies the starting date and the starting time, which are combined in a format called "starting date-time".];
                ApplicationArea=#Advanced;
                SourceExpr="Starting Date-Time" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl‘ttet for operationen til planl‘gningsrutelinjen.;
                           ENU=Specifies the starting time for the operation for this planning routing line.];
                ApplicationArea=#Advanced;
                SourceExpr="Starting Time";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for operationen til planl‘gningsrutelinjen.;
                           ENU=Specifies the starting date for the operation for this planning routing line.];
                ApplicationArea=#Advanced;
                SourceExpr="Starting Date";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Slutdato/tidspunkt.;
                           ENU=Specifies the ending date and the ending time, which are combined in a format called "ending date-time".];
                ApplicationArea=#Advanced;
                SourceExpr="Ending Date-Time" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutklokkesl‘ttet for operationen til planl‘gningsrutelinjen.;
                           ENU=Specifies the ending time of the operation for this planning routing line.];
                ApplicationArea=#Advanced;
                SourceExpr="Ending Time";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for operationen til planl‘gningsrutelinjen.;
                           ENU=Specifies the ending date of the operation for this planning routing line.];
                ApplicationArea=#Advanced;
                SourceExpr="Ending Date";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opstillingstiden, anf›rt i enheden fra feltet Opstillingstidsenhedskode p† arbejdscenter- eller produktionsressourcekortet.;
                           ENU=Specifies the setup time using the unit of measure from the Setup Time Unit of Measure field on the work or machine center card.];
                ApplicationArea=#Advanced;
                SourceExpr="Setup Time" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationstiden for operationen.;
                           ENU=Specifies the run time of the operation.];
                ApplicationArea=#Advanced;
                SourceExpr="Run Time" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ventetiden.;
                           ENU=Specifies the wait time.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Wait Time" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transporttiden, anf›rt i enheden fra feltet Transporttidsenhedskode p† produktionsressource- og arbejdscenterkortet.;
                           ENU=Specifies the move time using the unit of measure in the Move Time Unit of Measure field on the machine or work center card.];
                ApplicationArea=#Advanced;
                SourceExpr="Move Time" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et fast spildantal for rutelinjen.;
                           ENU=Specifies a fixed scrap quantity for this routing line.];
                ApplicationArea=#Advanced;
                SourceExpr="Fixed Scrap Quantity";
                Visible=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver spildfaktoren som en procentdel.;
                           ENU=Specifies the scrap factor as a percentage.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap Factor %";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver afgangen for den operation, der skal udf›res, f›r den n‘ste operation kan p†begyndes.;
                           ENU=Specifies the output of the operation that must be completed before the next operation can be started.];
                ApplicationArea=#Advanced;
                SourceExpr="Send-Ahead Quantity";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal ressourcer eller medarbejdere, der kan udf›re de forventede funktioner samtidig.;
                           ENU=Specifies the quantity of machines or personnel that can perform their expected functions simultaneously.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Concurrent Capacities";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationens kostpris, hvis den er forskellig fra kostprisen p† arbejdscenter- eller produktionsressourcekortet.;
                           ENU=Specifies the unit cost for this operation if it is different than the unit cost on the work center or machine center card.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Cost per";
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

